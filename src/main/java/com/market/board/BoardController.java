package com.market.board;

import java.io.IOException;
import java.sql.SQLException;

import com.market.global.exception.CustomException;
import com.market.global.exception.GlobalErrorCode;
import com.market.global.util.ValidationUtil;
import com.market.user.SessionUser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 동네생활 게시판 (MVC2). 목록/상세/글쓰기. /board/write 는 LoginCheckFilter 보호.
 */
@WebServlet("/board/*")
public class BoardController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final transient BoardDAO boardDAO = new BoardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        try {
            switch (path) {
                case "/", "/list" -> {
                    req.setAttribute("posts", boardDAO.findAll());
                    req.getRequestDispatcher("/WEB-INF/views/board/list.jsp").forward(req, resp);
                }
                case "/view" -> {
                    long id = parseLong(req.getParameter("id"));
                    boardDAO.increaseViewCount(id);
                    BoardDTO post = boardDAO.findById(id);
                    if (post == null) throw new CustomException(GlobalErrorCode.INVALID_INPUT);
                    req.setAttribute("post", post);
                    req.getRequestDispatcher("/WEB-INF/views/board/view.jsp").forward(req, resp);
                }
                case "/write" -> req.getRequestDispatcher("/WEB-INF/views/board/write.jsp").forward(req, resp);
                default -> resp.sendRedirect(req.getContextPath() + "/board/");
            }
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        SessionUser loginUser = SessionUser.current(req);
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }
        BoardDTO post = new BoardDTO();
        post.setUserId(loginUser.getId());
        post.setTitle(req.getParameter("title"));
        post.setContent(req.getParameter("content"));
        ValidationUtil.validateRequired(post.getTitle(), "title");
        try {
            boardDAO.insert(post);
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
        resp.sendRedirect(req.getContextPath() + "/board/");
    }

    private long parseLong(String v) {
        try { return Long.parseLong(v); } catch (Exception e) { return 0; }
    }
}
