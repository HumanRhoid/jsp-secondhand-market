package com.market.order;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;

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
 * 토스페이먼츠 결제 승인.
 * 프런트(requestPayment) → successUrl(GET /order/success?paymentKey&orderId&amount)
 * → 서버가 POST https://api.tosspayments.com/v1/payments/confirm 으로 승인(검증)
 * → orders 기록 + 상품 '판매완료'. (참고: docs.tosspayments.com/reference — confirm API)
 * 클라이언트 금액을 믿지 않고 DB 가격과 대조 후 승인한다(위변조 방지).
 * orderId 형식: order_{productId}_{timestamp}
 */
@WebServlet("/order/*")
public class OrderController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final HttpClient HTTP = HttpClient.newHttpClient();
    private final transient ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            case "/success" -> success(req, resp);
            case "/fail"    -> {
                String msg = req.getParameter("message");
                redirectWithAlert(req, resp, req.getParameter("orderId"),
                        "결제 실패: " + (msg == null ? "사용자 취소" : msg));
            }
            default -> resp.sendRedirect(req.getContextPath() + "/product/");
        }
    }

    private void success(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String paymentKey = req.getParameter("paymentKey");
        String orderId = req.getParameter("orderId");
        long amount = parseLong(req.getParameter("amount"));
        long productId = productIdFrom(orderId);

        SessionUser loginUser = SessionUser.current(req);
        if (loginUser == null || paymentKey == null || productId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/product/");
            return;
        }
        try {
            // 1) 서버 기준 금액 대조 (클라이언트 amount 신뢰 금지)
            ProductDTO product = productService.getProductDetail(productId);
            if (product.getPrice() != amount) {
                redirectWithAlert(req, resp, orderId, "결제 금액 불일치로 승인을 거부했습니다.");
                return;
            }

            // 2) 결제 승인 — POST /v1/payments/confirm, Basic base64(secretKey + ":")
            String basic = Base64.getEncoder().encodeToString(
                    (AppConfig.get("toss.secret.key") + ":").getBytes(StandardCharsets.UTF_8));
            String body = "{\"paymentKey\":\"" + paymentKey + "\",\"orderId\":\"" + orderId
                    + "\",\"amount\":" + amount + "}";
            HttpRequest confirm = HttpRequest.newBuilder(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
                    .header("Authorization", "Basic " + basic)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();
            HttpResponse<String> res = HTTP.send(confirm, HttpResponse.BodyHandlers.ofString());
            JsonObject payment = JsonParser.parseString(res.body()).getAsJsonObject();

            if (res.statusCode() != 200 || !"DONE".equals(payment.get("status").getAsString())) {
                String msg = payment.has("message") ? payment.get("message").getAsString() : "승인 거절";
                redirectWithAlert(req, resp, orderId, "결제 승인 실패: " + msg);
                return;
            }

            // 3) 주문 기록 + 판매완료
            insertOrder(productId, loginUser.getId(), paymentKey, orderId, (int) amount);
            markSold(productId);
            redirectWithAlert(req, resp, orderId, "결제 완료! 거래가 성사되었습니다.");
        } catch (Exception e) {
            redirectWithAlert(req, resp, orderId, "결제 승인 중 오류가 발생했습니다.");
        }
    }

    /** orderId(order_{productId}_{ts})에서 productId 추출 */
    private long productIdFrom(String orderId) {
        try {
            return Long.parseLong(orderId.split("_")[1]);
        } catch (Exception e) {
            return 0;
        }
    }

    private void redirectWithAlert(HttpServletRequest req, HttpServletResponse resp,
                                   String orderId, String message) throws IOException {
        long productId = productIdFrom(orderId);
        String target = productId > 0 ? "/product/detail?id=" + productId + "&" : "/product/?";
        resp.sendRedirect(req.getContextPath() + target + "payMsg="
                + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private void insertOrder(long productId, long buyerId, String paymentKey, String orderId, int amount)
            throws SQLException {
        String sql = "INSERT INTO orders (product_id, buyer_id, payment_key, merchant_uid, amount) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setLong(2, buyerId);
            ps.setString(3, paymentKey);
            ps.setString(4, orderId);
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

    private long parseLong(String v) {
        try { return Long.parseLong(v); } catch (Exception e) { return 0; }
    }
}
