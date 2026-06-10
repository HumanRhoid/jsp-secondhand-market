package com.market.user;

import com.market.global.config.DBManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // 회원가입
    public void join(UserDTO user) throws SQLException {
        String sql = "INSERT INTO users (nickname, email, password, region) VALUES (?, ?, ?, ?)";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getNickname());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRegion());
            ps.executeUpdate();
        }
    }

    // email로 회원 조회 (비밀번호 비교는 Service에서 수행)
    public UserDTO findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return toDTO(rs);
            }
        }
        return null;
    }

    // 이메일 중복 여부
    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // id로 회원 조회
    public UserDTO findById(long id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return toDTO(rs);
            }
        }
        return null;
    }

    // 프로필 수정 (닉네임, 지역, 프로필사진)
    public void update(UserDTO user) throws SQLException {
        String sql = "UPDATE users SET nickname = ?, region = ?, profile_image = ?, updated_at = NOW() WHERE id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getNickname());
            ps.setString(2, user.getRegion());
            ps.setString(3, user.getProfileImage());
            ps.setLong(4, user.getId());
            ps.executeUpdate();
        }
    }

    // 회원 탈퇴 (하드 삭제). FK ON DELETE CASCADE로 매물·찜 등도 함께 삭제됨
    public void delete(long id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    // ResultSet → UserDTO 변환
    private UserDTO toDTO(ResultSet rs) throws SQLException {
        UserDTO u = new UserDTO();
        u.setId(rs.getLong("id"));
        u.setNickname(rs.getString("nickname"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRegion(rs.getString("region"));
        u.setProfileImage(rs.getString("profile_image"));
        u.setMannerTemp(rs.getDouble("manner_temp"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }
}
