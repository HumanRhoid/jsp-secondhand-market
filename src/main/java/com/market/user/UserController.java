package com.market.user;

<<<<<<< HEAD
import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
=======
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
>>>>>>> origin/main

@WebServlet("/user/*")
public class UserController extends HttpServlet {

<<<<<<< HEAD
    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            case "/logout" -> {
                req.getSession().invalidate();
                resp.sendRedirect(req.getContextPath() + "/product/");
            }
            case "/profile" -> req.getRequestDispatcher("/profile.jsp").forward(req, resp); // LoginCheckFilter가 보호
            default -> resp.sendRedirect(req.getContextPath() + "/product/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        try {
            switch (path) {
                case "/join"   -> join(req, resp);
                case "/login"  -> login(req, resp);
                case "/update" -> update(req, resp);
                default        -> resp.sendRedirect(req.getContextPath() + "/product/");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void join(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        UserDTO user = new UserDTO();
        user.setNickname(req.getParameter("nickname"));
        user.setEmail(req.getParameter("email"));
        user.setPassword(req.getParameter("password"));
        user.setRegion(req.getParameter("region"));
        try {
            userDAO.join(user);
        } catch (SQLException e) {
            // 이메일 unique 제약 위반 등 → 가입 폼으로 되돌림
            req.setAttribute("error", "가입에 실패했습니다. 이미 사용 중인 이메일일 수 있습니다.");
            req.getRequestDispatcher("/join.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private void login(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        UserDTO user = userDAO.login(req.getParameter("email"), req.getParameter("password"));
        if (user == null) {
            req.setAttribute("error", "이메일 또는 비밀번호가 일치하지 않습니다.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        HttpSession session = req.getSession();
        session.setAttribute("loginUser", user);
        resp.sendRedirect(req.getContextPath() + "/product/");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        UserDTO loginUser = (UserDTO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        loginUser.setNickname(req.getParameter("nickname"));
        loginUser.setRegion(req.getParameter("region"));
        loginUser.setProfileImage(req.getParameter("profileImage"));
        userDAO.update(loginUser);
        req.getSession().setAttribute("loginUser", loginUser); // 세션 정보 갱신
        resp.sendRedirect(req.getContextPath() + "/user/profile");
    }
=======
>>>>>>> origin/main
}
