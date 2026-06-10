package com.market.product;

<<<<<<< HEAD
import com.market.common.DBManager;

=======
>>>>>>> origin/main
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
<<<<<<< HEAD
import java.util.List;

public class ProductDAO {

    // 전체 목록 (삭제 안 된 것만, 최신순)
    public List<ProductDTO> findAll() throws SQLException {
        String sql = "SELECT * FROM products WHERE deleted_at IS NULL ORDER BY created_at DESC";
        List<ProductDTO> list = new ArrayList<>();
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(toDTO(rs));
=======

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
>>>>>>> origin/main
        }
        return list;
    }

<<<<<<< HEAD
    // 상품 상세
    public ProductDTO findById(long id) throws SQLException {
        String sql = "SELECT * FROM products WHERE id = ? AND deleted_at IS NULL";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return toDTO(rs);
            }
        }
        return null;
    }

    // 내 상품 목록
    public List<ProductDTO> findByUserId(long userId) throws SQLException {
        String sql = "SELECT * FROM products WHERE user_id = ? AND deleted_at IS NULL ORDER BY created_at DESC";
        List<ProductDTO> list = new ArrayList<>();
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(toDTO(rs));
            }
        }
        return list;
    }

    // 상품 등록
    public void insert(ProductDTO product) throws SQLException {
        String sql = "INSERT INTO products (user_id, title, description, price, status, thumbnail) VALUES (?, ?, ?, ?, '판매중', ?)";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, product.getUserId());
            ps.setString(2, product.getTitle());
            ps.setString(3, product.getDescription());
            ps.setInt(4, product.getPrice());
            ps.setString(5, product.getThumbnail());
            ps.executeUpdate();
        }
    }

    // 상품 수정
    public void update(ProductDTO product) throws SQLException {
        String sql = "UPDATE products SET title = ?, description = ?, price = ?, status = ?, thumbnail = ?, updated_at = NOW() WHERE id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, product.getTitle());
            ps.setString(2, product.getDescription());
            ps.setInt(3, product.getPrice());
            ps.setString(4, product.getStatus());
            ps.setString(5, product.getThumbnail());
            ps.setLong(6, product.getId());
            ps.executeUpdate();
        }
    }

    // 조회수 증가 (영속 조회수는 PostgreSQL이 담당)
    public void increaseViewCount(long id) throws SQLException {
        String sql = "UPDATE products SET view_count = view_count + 1 WHERE id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    // 상품 삭제 (소프트 삭제)
    public void delete(long id) throws SQLException {
        String sql = "UPDATE products SET deleted_at = NOW() WHERE id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    // ResultSet → ProductDTO 변환
    private ProductDTO toDTO(ResultSet rs) throws SQLException {
        ProductDTO p = new ProductDTO();
        p.setId(rs.getLong("id"));
        p.setUserId(rs.getLong("user_id"));
        p.setCategoryId(rs.getLong("category_id"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setStatus(rs.getString("status"));
        p.setPrice(rs.getInt("price"));
        p.setThumbnail(rs.getString("thumbnail"));
        p.setViewCount(rs.getInt("view_count"));
        p.setLikeCount(rs.getInt("like_count"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        p.setDeletedAt(rs.getTimestamp("deleted_at"));
        return p;
    }
=======
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
>>>>>>> origin/main
}
