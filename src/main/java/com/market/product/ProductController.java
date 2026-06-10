package com.market.product;

<<<<<<< HEAD
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.market.common.RedisManager;
import com.market.user.UserDAO;
import com.market.user.UserDTO;
=======
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
>>>>>>> origin/main

@WebServlet("/product/*")
public class ProductController extends HttpServlet {

<<<<<<< HEAD
    private static final long serialVersionUID = 1L;

    private final ProductDAO productDAO = new ProductDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        try {
            switch (path) {
                case "/", "/list" -> list(req, resp);
                case "/detail"    -> detail(req, resp);
                case "/form"      -> req.getRequestDispatcher("/productForm.jsp").forward(req, resp); // LoginCheckFilter가 보호
                default           -> resp.sendRedirect(req.getContextPath() + "/product/");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        try {
            switch (path) {
                case "/write"  -> write(req, resp);  // LoginCheckFilter가 보호
                case "/update" -> update(req, resp);
                case "/delete" -> delete(req, resp);
                default        -> resp.sendRedirect(req.getContextPath() + "/product/");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // 상품 목록 + Redis 인기 랭킹 TOP 4
    private void list(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        req.setAttribute("products", productDAO.findAll());

        List<ProductDTO> popular = new ArrayList<>();
        for (Long id : RedisManager.getTopProductIds(4)) {
            ProductDTO p = productDAO.findById(id);
            if (p != null) popular.add(p);
        }
        req.setAttribute("popular", popular);

        req.getRequestDispatcher("/main.jsp").forward(req, resp);
    }

    // 상품 상세: 영속 조회수는 PostgreSQL, 실시간 인기 랭킹은 Redis
    private void detail(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        long id = parseLong(req.getParameter("id"));
        ProductDTO product = productDAO.findById(id);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/product/");
            return;
        }
        productDAO.increaseViewCount(id);
        RedisManager.incrementProductRank(id);
        product.setViewCount(product.getViewCount() + 1); // 화면 표시용 보정

        req.setAttribute("product", product);
        req.setAttribute("seller", userDAO.findById(product.getUserId()));
        req.getRequestDispatcher("/productDetail.jsp").forward(req, resp);
    }

    private void write(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");
        ProductDTO product = new ProductDTO();
        product.setUserId(loginUser.getId());
        product.setTitle(req.getParameter("title"));
        product.setDescription(req.getParameter("description"));
        product.setPrice((int) parseLong(req.getParameter("price")));
        product.setThumbnail(req.getParameter("thumbnail"));
        productDAO.insert(product);
        resp.sendRedirect(req.getContextPath() + "/product/");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        long id = parseLong(req.getParameter("id"));
        if (notOwner(req, id)) {
            resp.sendRedirect(req.getContextPath() + "/product/detail?id=" + id);
            return;
        }
        ProductDTO product = productDAO.findById(id);
        product.setTitle(req.getParameter("title"));
        product.setDescription(req.getParameter("description"));
        product.setPrice((int) parseLong(req.getParameter("price")));
        product.setStatus(req.getParameter("status"));
        product.setThumbnail(req.getParameter("thumbnail"));
        productDAO.update(product);
        resp.sendRedirect(req.getContextPath() + "/product/detail?id=" + id);
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        long id = parseLong(req.getParameter("id"));
        if (!notOwner(req, id)) {
            productDAO.delete(id);
            RedisManager.removeProductRank(id); // 삭제된 상품은 랭킹에서도 제거
        }
        resp.sendRedirect(req.getContextPath() + "/product/");
    }

    // 로그인 사용자가 해당 상품의 판매자가 아닌지 검사
    private boolean notOwner(HttpServletRequest req, long productId) throws SQLException {
        UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) return true;
        ProductDTO product = productDAO.findById(productId);
        return product == null || product.getUserId() != loginUser.getId();
    }

    private long parseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (Exception e) {
            return 0;
        }
    }
=======
>>>>>>> origin/main
}
