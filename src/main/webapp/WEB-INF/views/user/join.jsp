<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/design.css">
<style>
  .frame {
    display: flex;
    flex-direction: column;
    padding: 48px 24px 32px;
  }
  .hero { margin-bottom: 32px; }
  .form { display: flex; flex-direction: column; gap: 16px; }
  .form .btn { margin-top: 8px; }
  .footer-prompt { margin-top: auto; padding-top: 32px; }
</style>
</head>
<body>
  <div class="frame">

    <!-- hero -->
    <header class="hero">
      <h1 class="headline">계정을<br>만들어보세요</h1>
    </header>

    <!-- form -->
    <form class="form" method="post"
          action="<%= request.getContextPath() %>/user/join"
          onsubmit="return checkJoin(this);">

      <%-- 가입 실패 메시지 (UserController에서 전달, c:out으로 XSS 방지) --%>
      <c:if test="${not empty errorMessage}">
        <div class="error-msg"><c:out value="${errorMessage}"/></div>
      </c:if>

      <!-- 이름(닉네임) -->
      <div class="field">
        <label class="label" for="nickname">이름</label>
        <div class="input-wrap">
          <input class="input" type="text" id="nickname" name="nickname"
                 placeholder="홍길동" autocomplete="name">
        </div>
      </div>

      <!-- 이메일 -->
      <div class="field">
        <label class="label" for="email">이메일</label>
        <div class="input-wrap">
          <input class="input" type="email" id="email" name="email"
                 placeholder="name@example.com" autocomplete="email">
        </div>
      </div>

      <!-- 지역 -->
      <div class="field">
        <label class="label" for="region">지역</label>
        <div class="input-wrap">
          <select class="select is-placeholder" id="region" name="region" required>
            <option value="" disabled selected hidden>지역을 선택하세요</option>
            <option value="seoul">서울</option>
            <option value="busan">부산</option>
            <option value="incheon">인천</option>
            <option value="daegu">대구</option>
            <option value="gwangju">광주</option>
            <option value="daejeon">대전</option>
            <option value="ulsan">울산</option>
            <option value="sejong">세종</option>
            <option value="gyeonggi">경기</option>
            <option value="gangwon">강원</option>
            <option value="chungbuk">충북</option>
            <option value="chungnam">충남</option>
            <option value="jeonbuk">전북</option>
            <option value="jeonnam">전남</option>
            <option value="gyeongbuk">경북</option>
            <option value="gyeongnam">경남</option>
            <option value="jeju">제주</option>
          </select>
        </div>
      </div>

      <!-- 비밀번호 -->
      <div class="field">
        <label class="label" for="password">비밀번호</label>
        <div class="input-wrap">
          <input class="input has-icon" type="password" id="password" name="password"
                 placeholder="••••••••" autocomplete="new-password">
          <button class="input-icon" type="button" data-toggle="password" aria-label="비밀번호 표시 전환">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
              <circle cx="12" cy="12" r="3"></circle>
            </svg>
          </button>
        </div>
      </div>

      <!-- 비밀번호 확인 -->
      <div class="field">
        <label class="label" for="confirm">비밀번호 확인</label>
        <div class="input-wrap">
          <input class="input has-icon" type="password" id="confirm" name="confirm"
                 placeholder="••••••••" autocomplete="new-password">
          <button class="input-icon" type="button" data-toggle="confirm" aria-label="비밀번호 표시 전환">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
              <circle cx="12" cy="12" r="3"></circle>
            </svg>
          </button>
        </div>
      </div>

      <button type="submit" class="btn btn-primary btn-block">회원가입</button>
    </form>

    <!-- footer -->
    <div class="footer-prompt">
      이미 계정이 있으신가요?<a class="link-inline" href="<%= request.getContextPath() %>/user/login">로그인</a>
    </div>

  </div>

  <script>
    // 가입 유효성 검사: 빈 값, 비밀번호 확인 일치
    function checkJoin(f) {
      if (f.nickname.value.trim() === "") { alert("이름을 입력하세요."); f.nickname.focus(); return false; }
      if (f.email.value.trim() === "") { alert("이메일을 입력하세요."); f.email.focus(); return false; }
      if (f.region.value === "") { alert("지역을 선택하세요."); f.region.focus(); return false; }
      if (f.password.value.length < 8 || f.password.value.length > 20) { alert("비밀번호는 8자 이상 20자 이하로 입력하세요."); f.password.focus(); return false; }
      if (f.password.value !== f.confirm.value) { alert("비밀번호가 일치하지 않습니다."); f.confirm.focus(); return false; }
      return true;
    }

    const eyeOpen = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle>';
    const eyeOff  = '<path d="M17.94 17.94A10.94 10.94 0 0 1 12 20c-7 0-11-8-11-8a19.77 19.77 0 0 1 5.17-5.94"></path><path d="M9.9 4.24A10.94 10.94 0 0 1 12 4c7 0 11 8 11 8a19.86 19.86 0 0 1-3.17 4.19"></path><line x1="1" y1="1" x2="23" y2="23"></line><path d="M14.12 14.12A3 3 0 1 1 9.88 9.88"></path>';

    document.querySelectorAll('[data-toggle]').forEach(btn => {
      btn.addEventListener('click', () => {
        const target = document.getElementById(btn.dataset.toggle);
        const showing = target.type === 'text';
        target.type = showing ? 'password' : 'text';
        btn.querySelector('svg').innerHTML = showing ? eyeOpen : eyeOff;
      });
    });

    const region = document.getElementById('region');
    region.addEventListener('change', () => {
      if (region.value) region.classList.remove('is-placeholder');
      else region.classList.add('is-placeholder');
    });
  </script>
</body>
</html>
