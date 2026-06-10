package com.market.product;

import com.market.global.config.DBManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
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
        }
        return list;
    }

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

    // 상품 등록 → 생성된 id 반환 (product_images 적재에 사용)
    public long insert(ProductDTO product) throws SQLException {
        String sql = "INSERT INTO products (user_id, title, description, price, status, thumbnail) VALUES (?, ?, ?, ?, '판매중', ?)";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, product.getUserId());
            ps.setString(2, product.getTitle());
            ps.setString(3, product.getDescription());
            ps.setInt(4, product.getPrice());
            ps.setString(5, product.getThumbnail());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        }
        return 0;
    }

    // 상품 사진 여러 장 일괄 저장 (product_images)
    public void insertImages(long productId, List<String> imageUrls) throws SQLException {
        if (imageUrls == null || imageUrls.isEmpty()) return;
        String sql = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (String url : imageUrls) {
                ps.setLong(1, productId);
                ps.setString(2, url);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    // 상품 사진 경로 목록 (등록 순)
    public List<String> findImageUrls(long productId) throws SQLException {
        String sql = "SELECT image_url FROM product_images WHERE product_id = ? ORDER BY id";
        List<String> urls = new ArrayList<>();
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) urls.add(rs.getString("image_url"));
            }
        }
        return urls;
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
}
