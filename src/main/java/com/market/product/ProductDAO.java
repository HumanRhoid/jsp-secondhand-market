package com.market.product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.market.common.DBManager;

public class ProductDAO {

    private static ProductDAO instance = new ProductDAO();

    private ProductDAO() {
    }

    public static ProductDAO getInstance() {
        return instance;
    }

    public ArrayList<ProductDTO> getAllProducts() {
        ArrayList<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT id, title, price, description, thumbnail FROM products";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getString("id"));
                p.setTitle(rs.getString("title"));
                p.setPrice(rs.getInt("price"));
                p.setDescription(rs.getString("description"));
                p.setFilename(rs.getString("thumbnail"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ProductDTO getProductById(String productId) {
        ProductDTO product = null;
        String sql = "SELECT id, title, price, description, thumbnail FROM products WHERE id = ?";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, Long.parseLong(productId));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    product = new ProductDTO();
                    product.setProductId(rs.getString("id"));
                    product.setTitle(rs.getString("title"));
                    product.setPrice(rs.getInt("price"));
                    product.setDescription(rs.getString("description"));
                    product.setFilename(rs.getString("thumbnail"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    public void addProduct(ProductDTO product) {
        String sql = "INSERT INTO products (user_id, title, price, description, thumbnail) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, 1L); // TODO: 로그인한 사용자 ID로 교체
            pstmt.setString(2, product.getTitle());
            pstmt.setInt(3, product.getPrice());
            pstmt.setString(4, product.getDescription());
            pstmt.setString(5, product.getFilename());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
