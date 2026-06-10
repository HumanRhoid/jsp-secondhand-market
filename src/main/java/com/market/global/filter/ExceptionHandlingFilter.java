package com.market.global.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.market.global.exception.BaseErrorCode;
import com.market.global.exception.CustomException;

import java.io.IOException;

/**
 * 전역 예외 처리 필터 (Spring의 @RestControllerAdvice 대응).
 * Service에서 던진 CustomException을 한 곳에서 잡아 에러 페이지로 변환한다.
 * Controller에서 처리하지 않은(폼 복귀형이 아닌) 예외만 여기로 전파된다.
 */
public class ExceptionHandlingFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(ExceptionHandlingFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        try {
            chain.doFilter(request, response);
        } catch (Throwable t) {
            // Servlet 컨테이너가 RuntimeException을 ServletException으로 감싸므로 언랩
            Throwable cause = (t instanceof ServletException se && se.getRootCause() != null)
                    ? se.getRootCause() : t;

            if (cause instanceof CustomException ce) {
                BaseErrorCode ec = ce.getErrorCode();
                log.warn("CustomException [{}] {} - {} {}",
                        ec.getCode(), ec.getMessage(), req.getMethod(), req.getRequestURI());
                resp.setStatus(ec.getStatus());
                req.setAttribute("errorCode", ec.getCode());
                req.setAttribute("errorMessage", ec.getMessage());
                req.getRequestDispatcher("/WEB-INF/views/error/error.jsp").forward(req, resp);
            } else {
                log.error("처리되지 않은 예외: {} {}", req.getMethod(), req.getRequestURI(), cause);
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}
