package com.market.product;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.market.global.exception.CustomException;
import com.market.global.exception.GlobalErrorCode;
import com.market.user.SessionUser;
import com.market.user.UserService;

/**
 * 상품 Servlet. 요청 파라미터 추출과 응답(forward/redirect)만 담당하고
 * 비즈니스 로직(소유자 검증, 조회수/랭킹)은 ProductService에 위임한다 (MVC2).
 */
@WebServlet("/product/*")
public class ProductController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final transient ProductService productService = new ProductService();
    private final transient UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            case "/", "/list" -> list(req, resp);
            case "/detail"    -> detail(req, resp);
            case "/form"      -> req.getRequestDispatcher("/WEB-INF/views/product/form.jsp").forward(req, resp); // LoginCheckFilter가 보호
            default           -> resp.sendRedirect(req.getContextPath() + "/product/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            // 아래 셋은 LoginCheckFilter가 보호
            case "/write"  -> write(req, resp);
            case "/update" -> update(req, resp);
            case "/delete" -> delete(req, resp);
            default        -> resp.sendRedirect(req.getContextPath() + "/product/");
        }
    }

    // 상품 목록 + Redis 인기 랭킹 TOP 4
    private void list(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("products", productService.getProducts());
        req.setAttribute("popular", productService.getPopularProducts(4));
        req.getRequestDispatcher("/WEB-INF/views/product/main.jsp").forward(req, resp);
    }

    private void detail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        ProductDTO product = productService.getProductDetail(parseLong(req.getParameter("id")));
        req.setAttribute("product", product);
        req.setAttribute("seller", userService.findById(product.getUserId()));
        req.getRequestDispatcher("/WEB-INF/views/product/detail.jsp").forward(req, resp);
    }

    private void write(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        SessionUser loginUser = (SessionUser) req.getSession().getAttribute("loginUser");
        ProductDTO product = new ProductDTO();
        product.setTitle(req.getParameter("title"));
        product.setDescription(req.getParameter("description"));
        product.setPrice((int) parseLong(req.getParameter("price")));
        product.setThumbnail(req.getParameter("thumbnail"));
        try {
            productService.write(loginUser.getId(), product);
        } catch (CustomException e) {
            if (e.getErrorCode() != GlobalErrorCode.INVALID_INPUT) throw e;
            // 검증 실패 → 등록 폼으로 되돌림
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/product/form.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/product/");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        SessionUser loginUser = (SessionUser) req.getSession().getAttribute("loginUser");
        long id = parseLong(req.getParameter("id"));
        productService.update(
                loginUser.getId(),
                id,
                req.getParameter("title"),
                req.getParameter("description"),
                (int) parseLong(req.getParameter("price")),
                req.getParameter("status"),
                req.getParameter("thumbnail"));
        resp.sendRedirect(req.getContextPath() + "/product/detail?id=" + id);
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        SessionUser loginUser = (SessionUser) req.getSession().getAttribute("loginUser");
        productService.delete(loginUser.getId(), parseLong(req.getParameter("id")));
        resp.sendRedirect(req.getContextPath() + "/product/");
    }

    private long parseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (Exception e) {
            return 0;
        }
    }
}
