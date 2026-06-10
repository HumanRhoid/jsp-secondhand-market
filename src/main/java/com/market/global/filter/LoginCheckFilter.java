package com.market.global.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * 로그인이 필요한 URL을 보호한다. 보호 대상 URL은 web.xml의 filter-mapping에 명시.
 * 미로그인 시 로그인 페이지(GET /user/login)로 리다이렉트한다.
 */
public class LoginCheckFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(LoginCheckFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("loginUser") != null;

        if (!loggedIn) {
            log.warn("미로그인 접근 차단: {} {}", req.getMethod(), req.getRequestURI());
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }
        chain.doFilter(request, response);
    }
}
