package com.market.global.web;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.market.global.config.AppConfig;
import com.market.user.SessionUser;
import com.market.user.UserService;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * SNS 로그인 (카카오/네이버 OAuth 2.0).
 * /auth/kakao  → 카카오 동의 화면 → /auth/kakao/callback  → 토큰 → 프로필 → 세션 로그인
 * /auth/naver  → 네이버 동의 화면 → /auth/naver/callback  → 토큰 → 프로필 → 세션 로그인
 * 키는 db.properties(kakao.rest.key / naver.client.id·secret / oauth.base.url)에서 읽는다.
 */
@WebServlet("/auth/*")
public class AuthController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final HttpClient HTTP = HttpClient.newHttpClient();
    private final transient UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            case "/kakao"           -> redirectKakao(req, resp);
            case "/kakao/callback"  -> kakaoCallback(req, resp);
            case "/naver"           -> redirectNaver(req, resp);
            case "/naver/callback"  -> naverCallback(req, resp);
            default                 -> resp.sendRedirect(req.getContextPath() + "/user/login");
        }
    }

    // ── 카카오 ──
    private void redirectKakao(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String url = "https://kauth.kakao.com/oauth/authorize?response_type=code"
                + "&client_id=" + AppConfig.get("kakao.rest.key")
                + "&redirect_uri=" + enc(AppConfig.get("oauth.base.url") + "/auth/kakao/callback");
        resp.sendRedirect(url);
    }

    private void kakaoCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code = req.getParameter("code");
        if (code == null) { resp.sendRedirect(req.getContextPath() + "/user/login"); return; }

        String body = "grant_type=authorization_code"
                + "&client_id=" + AppConfig.get("kakao.rest.key")
                + "&redirect_uri=" + enc(AppConfig.get("oauth.base.url") + "/auth/kakao/callback")
                + "&code=" + code;
        JsonObject token = postForm("https://kauth.kakao.com/oauth/token", body);
        String accessToken = token.get("access_token").getAsString();

        JsonObject me = getJson("https://kapi.kakao.com/v2/user/me", accessToken);
        String providerId = me.get("id").getAsString();
        String nickname = null;
        if (me.has("properties") && me.getAsJsonObject("properties").has("nickname")) {
            nickname = me.getAsJsonObject("properties").get("nickname").getAsString();
        }
        login(req, resp, "kakao", providerId, nickname);
    }

    // ── 네이버 ──
    private void redirectNaver(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String state = UUID.randomUUID().toString();
        req.getSession().setAttribute("naverState", state); // CSRF 방지
        String url = "https://nid.naver.com/oauth2.0/authorize?response_type=code"
                + "&client_id=" + AppConfig.get("naver.client.id")
                + "&redirect_uri=" + enc(AppConfig.get("oauth.base.url") + "/auth/naver/callback")
                + "&state=" + state;
        resp.sendRedirect(url);
    }

    private void naverCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code = req.getParameter("code");
        String state = req.getParameter("state");
        Object saved = req.getSession().getAttribute("naverState");
        if (code == null || saved == null || !saved.equals(state)) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }
        String body = "grant_type=authorization_code"
                + "&client_id=" + AppConfig.get("naver.client.id")
                + "&client_secret=" + AppConfig.get("naver.client.secret")
                + "&code=" + code + "&state=" + state;
        JsonObject token = postForm("https://nid.naver.com/oauth2.0/token", body);
        String accessToken = token.get("access_token").getAsString();

        JsonObject me = getJson("https://openapi.naver.com/v1/nid/me", accessToken)
                .getAsJsonObject("response");
        String providerId = me.get("id").getAsString();
        String nickname = me.has("nickname") ? me.get("nickname").getAsString() : null;
        login(req, resp, "naver", providerId, nickname);
    }

    // ── 공통 ──
    private void login(HttpServletRequest req, HttpServletResponse resp,
                       String provider, String providerId, String nickname) throws IOException {
        SessionUser user = userService.socialLogin(provider, providerId, nickname);
        req.getSession().setAttribute("loginUser", user);
        resp.sendRedirect(req.getContextPath() + "/product/");
    }

    private JsonObject postForm(String url, String body) throws IOException {
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                    .header("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();
            HttpResponse<String> res = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
            return JsonParser.parseString(res.body()).getAsJsonObject();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException(e);
        }
    }

    private JsonObject getJson(String url, String bearerToken) throws IOException {
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                    .header("Authorization", "Bearer " + bearerToken)
                    .GET()
                    .build();
            HttpResponse<String> res = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
            return JsonParser.parseString(res.body()).getAsJsonObject();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException(e);
        }
    }

    private String enc(String v) {
        return URLEncoder.encode(v, StandardCharsets.UTF_8);
    }
}
