package com.market.board;

import com.market.global.config.DBManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {

    private static final String SELECT =
            "SELECT b.*, u.nickname AS nickname FROM boards b LEFT JOIN users u ON b.user_id = u.id ";

    public List<BoardDTO> findAll() throws SQLException {
        String sql = SELECT + "ORDER BY b.id DESC";
        List<BoardDTO> list = new ArrayList<>();
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(toDTO(rs));
        }
        return list;
    }

    public BoardDTO findById(long id) throws SQLException {
        String sql = SELECT + "WHERE b.id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return toDTO(rs);
            }
        }
        return null;
    }

    public void insert(BoardDTO board) throws SQLException {
        String sql = "INSERT INTO boards (user_id, title, content) VALUES (?, ?, ?)";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, board.getUserId());
            ps.setString(2, board.getTitle());
            ps.setString(3, board.getContent());
            ps.executeUpdate();
        }
    }

    public void increaseViewCount(long id) throws SQLException {
        String sql = "UPDATE boards SET view_count = view_count + 1 WHERE id = ?";
        try (Connection con = DBManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    private BoardDTO toDTO(ResultSet rs) throws SQLException {
        BoardDTO b = new BoardDTO();
        b.setId(rs.getLong("id"));
        b.setUserId(rs.getLong("user_id"));
        b.setNickname(rs.getString("nickname"));
        b.setTitle(rs.getString("title"));
        b.setContent(rs.getString("content"));
        b.setViewCount(rs.getInt("view_count"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        return b;
    }
}
