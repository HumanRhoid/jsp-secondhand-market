package com.market.cart;

import java.io.IOException;
import java.util.LinkedHashSet;
import java.util.Set;

import com.market.product.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 장바구니. 세션에 상품 id 집합(Set)만 담는 방식이라 별도 DB 테이블이 없다.
 * (중고거래 1:1 특성상 영속 장바구니 대신 세션 기반으로 가볍게 구현)
 */
@WebServlet("/cart/*")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final transient ProductService productService = new ProductService();

    @SuppressWarnings("unchecked")
    private Set<Long> cart(HttpServletRequest req) {
        HttpSession session = req.getSession();
        Set<Long> cart = (Set<Long>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashSet<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 장바구니 보기
        req.setAttribute("items", productService.getProductsByIds(cart(req)));
        req.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        long id = parseLong(req.getParameter("id"));
        switch (path) {
            case "/add"    -> { if (id > 0) cart(req).add(id); resp.sendRedirect(req.getContextPath() + "/cart/"); }
            case "/remove" -> { cart(req).remove(id); resp.sendRedirect(req.getContextPath() + "/cart/"); }
            case "/clear"  -> { cart(req).clear(); resp.sendRedirect(req.getContextPath() + "/cart/"); }
            default        -> resp.sendRedirect(req.getContextPath() + "/cart/");
        }
    }

    private long parseLong(String v) {
        try { return Long.parseLong(v); } catch (Exception e) { return 0; }
    }
}
