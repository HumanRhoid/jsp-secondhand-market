<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/design.css">
<style>
  /* 흐름 레이아웃: 위에서 아래로 쌓고 SNS 버튼은 맨 아래 고정 */
  .frame {
    display: flex;
    flex-direction: column;
    padding: 64px 24px 32px;
  }
  .hero { margin-bottom: 32px; }
  .form { display: flex; flex-direction: column; gap: 16px; }
  .forgot-row { display: flex; justify-content: flex-end; margin-top: -8px; }
  .form .error-msg { margin-bottom: -4px; }
  .footer-prompt { margin-top: 20px; }

  /* SNS 로그인 — 페이지 맨 아래 */
  .sns-bottom { margin-top: auto; display: flex; flex-direction: column; gap: 8px; padding-top: 32px; }
  .sns-bottom .or-row { margin-bottom: 8px; }
</style>
</head>
<body>
  <div class="frame">

    <!-- hero -->
    <header class="hero">
      <h1 class="headline">안녕하세요,<br>로그인하세요</h1>
    </header>

    <!-- form -->
    <form class="form" method="post" action="<%= request.getContextPath() %>/user/login">

      <%-- 로그인 실패 메시지 (UserController에서 전달, c:out으로 XSS 방지) --%>
      <c:if test="${not empty errorMessage}">
        <div class="error-msg"><c:out value="${errorMessage}"/></div>
      </c:if>
      <%-- SNS 키 미설정 안내 (/auth/* 가드에서 리다이렉트) --%>
      <c:if test="${not empty param.snsMsg}">
        <div class="error-msg"><c:out value="${param.snsMsg}"/></div>
      </c:if>

      <div class="field">
        <label class="label" for="email">이메일</label>
        <div class="input-wrap">
          <input class="input" type="email" id="email" name="email"
                 placeholder="name@example.com" autocomplete="email" value="">
        </div>
      </div>

      <div class="field">
        <label class="label" for="password">비밀번호</label>
        <div class="input-wrap">
          <input class="input has-icon" type="password" id="password" name="password"
                 placeholder="••••••••" autocomplete="current-password">
          <button class="input-icon" type="button" id="togglePw" aria-label="비밀번호 표시 전환">
            <svg id="eyeIcon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
              <circle cx="12" cy="12" r="3"></circle>
            </svg>
          </button>
        </div>
      </div>

      <div class="forgot-row">
        <a class="link-mute" href="#">비밀번호를 잊으셨나요?</a>
      </div>

      <button type="submit" class="btn btn-primary btn-block">로그인</button>
    </form>

    <div class="footer-prompt">
      계정이 없으신가요?<a class="link-inline" href="<%= request.getContextPath() %>/user/join">회원가입</a>
    </div>

    <!-- SNS 로그인 (카카오/네이버 OAuth) — 페이지 맨 아래 -->
    <div class="sns-bottom">
      <div class="or-row">
        <span class="line"></span><span class="or">또는</span><span class="line"></span>
      </div>
      <a class="btn btn-block btn-sns" href="<%= request.getContextPath() %>/auth/kakao"><span class="sns-dot kakao"></span>카카오로 시작하기</a>
      <a class="btn btn-block btn-sns" href="<%= request.getContextPath() %>/auth/naver"><span class="sns-dot naver"></span>네이버로 시작하기</a>
    </div>

  </div>

  <script>
    const pw = document.getElementById('password');
    const toggle = document.getElementById('togglePw');
    const eye = document.getElementById('eyeIcon');

    const eyeOpen = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle>';
    const eyeOff = '<path d="M17.94 17.94A10.94 10.94 0 0 1 12 20c-7 0-11-8-11-8a19.77 19.77 0 0 1 5.17-5.94"></path><path d="M9.9 4.24A10.94 10.94 0 0 1 12 4c7 0 11 8 11 8a19.86 19.86 0 0 1-3.17 4.19"></path><line x1="1" y1="1" x2="23" y2="23"></line><path d="M14.12 14.12A3 3 0 1 1 9.88 9.88"></path>';

    toggle.addEventListener('click', () => {
      const showing = pw.type === 'text';
      pw.type = showing ? 'password' : 'text';
      eye.innerHTML = showing ? eyeOpen : eyeOff;
    });
  </script>
</body>
</html>
