package com.market.user;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.market.global.exception.CustomException;

/**
 * 회원 Servlet. 요청 파라미터 추출과 응답(forward/redirect)만 담당하고
 * 비즈니스 로직은 UserService에 위임한다 (MVC2).
 */
@WebServlet("/user/*")
public class UserController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final transient UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            case "/login"  -> req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, resp);
            case "/join"   -> req.getRequestDispatcher("/WEB-INF/views/user/join.jsp").forward(req, resp);
            case "/logout" -> {
                req.getSession().invalidate();
                resp.sendRedirect(req.getContextPath() + "/product/");
            }
            // 아래 둘은 LoginCheckFilter가 보호
            case "/profile" -> req.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(req, resp);
            case "/edit"    -> req.getRequestDispatcher("/WEB-INF/views/user/profileEdit.jsp").forward(req, resp);
            default         -> resp.sendRedirect(req.getContextPath() + "/product/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            case "/join"   -> join(req, resp);
            case "/login"  -> login(req, resp);
            case "/update" -> update(req, resp);
            default        -> resp.sendRedirect(req.getContextPath() + "/product/");
        }
    }

    private void join(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDTO user = new UserDTO();
        user.setNickname(req.getParameter("nickname"));
        user.setEmail(req.getParameter("email"));
        user.setPassword(req.getParameter("password"));
        user.setRegion(req.getParameter("region"));
        try {
            userService.join(user);
        } catch (CustomException e) {
            // 중복 이메일/검증 실패 → 가입 폼으로 되돌림
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/join.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/user/login");
    }

    private void login(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            SessionUser user = userService.login(req.getParameter("email"), req.getParameter("password"));
            HttpSession session = req.getSession();
            session.setAttribute("loginUser", user);
            resp.sendRedirect(req.getContextPath() + "/product/");
        } catch (CustomException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(req, resp);
        }
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        SessionUser loginUser = (SessionUser) req.getSession().getAttribute("loginUser"); // LoginCheckFilter가 보호
        SessionUser updated = userService.updateProfile(
                loginUser.getId(),
                req.getParameter("nickname"),
                req.getParameter("region"),
                req.getParameter("profileImage"));
        req.getSession().setAttribute("loginUser", updated); // 세션 정보 갱신
        resp.sendRedirect(req.getContextPath() + "/user/profile");
    }
}
