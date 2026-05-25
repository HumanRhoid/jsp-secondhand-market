package com.market.common;

<<<<<<< HEAD
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
=======
import javax.servlet.Filter;
import javax.servlet.annotation.WebFilter;
>>>>>>> c7b7f19884895851cc23093f1f1471d7a079cc1e

@WebFilter(urlPatterns = {"/product/form", "/product/write", "/user/profile"})
public class LoginCheckFilter implements Filter {

<<<<<<< HEAD
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("loginUser") != null;

        if (!loggedIn) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
=======
>>>>>>> c7b7f19884895851cc23093f1f1471d7a079cc1e
}
