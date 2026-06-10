package com.market.home;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 시작 페이지. JSP가 WEB-INF 아래로 이동해 직접 접근이 차단되므로
 * 컨텍스트 루트(GET /)를 Servlet이 받아 forward한다.
 * 매핑은 반드시 빈 문자열("") — "/"는 default servlet을 덮어 정적 리소스가 깨진다.
 */
@WebServlet("")
public class HomeController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
    }
}
