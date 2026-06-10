package com.market.order;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.market.global.config.AppConfig;
import com.market.global.config.DBManager;
import com.market.product.ProductDTO;
import com.market.product.ProductService;
import com.market.user.SessionUser;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 포트원(아임포트 v1) 결제 검증.
 * 프런트(IMP.request_pay) 성공 → POST /order/verify(imp_uid, productId)
 * → 포트원 REST로 실제 결제 조회 → 금액/상태 검증 → orders 기록 + 상품 '판매완료'.
 * 클라이언트 금액을 절대 믿지 않고 서버가 포트원에 직접 확인한다(위변조 방지).
 */
@WebServlet("/order/*")
public class OrderController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final HttpClient HTTP = HttpClient.newHttpClient();
    private final transient ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        if (!"/verify".equals(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        resp.setContentType("application/json;charset=UTF-8");
        SessionUser loginUser = SessionUser.current(req);
        if (loginUser == null) {
            resp.getWriter().write("{\"success\":false,\"message\":\"로그인이 필요합니다\"}");
            return;
        }
        try {
            String impUid = req.getParameter("imp_uid");
            long productId = Long.parseLong(req.getParameter("productId"));
            ProductDTO product = productService.getProductDetail(productId);

            // 1) 포트원 토큰 발급
            JsonObject tokenRes = postJson("https://api.iamport.kr/users/getToken",
                    "{\"imp_key\":\"" + AppConfig.get("portone.api.key") + "\",\"imp_secret\":\"" + AppConfig.get("portone.api.secret") + "\"}");
            String accessToken = tokenRes.getAsJsonObject("response").get("access_token").getAsString();

            // 2) 결제 단건 조회
            HttpRequest payReq = HttpRequest.newBuilder(URI.create("https://api.iamport.kr/payments/" + impUid))
                    .header("Authorization", "Bearer " + accessToken).GET().build();
            HttpResponse<String> payRes = HTTP.send(payReq, HttpResponse.BodyHandlers.ofString());
            JsonObject payment = JsonParser.parseString(payRes.body()).getAsJsonObject().getAsJsonObject("response");

            // 3) 검증: 결제완료 + 금액 일치
            String status = payment.get("status").getAsString();
            int amount = payment.get("amount").getAsInt();
            if (!"paid".equals(status) || amount != product.getPrice()) {
                resp.getWriter().write("{\"success\":false,\"message\":\"결제 검증 실패(금액/상태 불일치)\"}");
                return;
            }

            // 4) 주문 기록 + 판매완료 처리
            insertOrder(productId, loginUser.getId(), impUid,
                    payment.get("merchant_uid").getAsString(), amount);
            markSold(productId);

            resp.getWriter().write("{\"success\":true}");
        } catch (Exception e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"결제 검증 중 오류\"}");
        }
    }

    private JsonObject postJson(String url, String json) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(json)).build();
        HttpResponse<String> res = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
        return JsonParser.parseString(res.body()).getAsJsonObject();
    }

    private void insertOrder(long productId, long buyerId, String impUid, String merchantUid, int amount)
            throws SQLException {
        String sql = "INSERT INTO orders (product_id, buyer_id, imp_uid, merchant_uid, amount) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setLong(2, buyerId);
            ps.setString(3, impUid);
            ps.setString(4, merchantUid);
            ps.setInt(5, amount);
            ps.executeUpdate();
        }
    }

    private void markSold(long productId) throws SQLException {
        String sql = "UPDATE products SET status = '판매완료', updated_at = NOW() WHERE id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.executeUpdate();
        }
    }
}
