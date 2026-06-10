<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }

  html, body {
    background: #f0f0f0;
    font-family: ui-sans-serif, system-ui, -apple-system, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
    -webkit-font-smoothing: antialiased;
  }

  /* 모바일 프레임 */
  .frame {
    width: 390px;
    height: 844px;
    background: #ffffff;
    position: relative;
    overflow: hidden;
    margin: 40px auto;
  }

  /* hero */
  .hero {
    position: absolute;
    top: 48px;
    left: 24px;
    width: 342px;
  }
  .headline {
    font-family: "SF Pro Rounded", "SF Pro Display", system-ui, -apple-system, "Apple SD Gothic Neo", sans-serif;
    font-size: 36px;
    font-weight: 500;
    line-height: 1.15;
    color: #000000;
    text-align: left;
  }

  /* form */
  .form {
    position: absolute;
    top: 136px;
    left: 24px;
    width: 342px;
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
  .field {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }
  .label {
    font-size: 14px;
    font-weight: 500;
    line-height: 20px;
    color: #000000;
    padding-left: 8px;
  }
  .input-wrap {
    position: relative;
  }
  .input,
  .select {
    width: 100%;
    height: 44px;
    padding: 8px 16px;
    border-radius: 9999px;
    border: 1px solid #e5e5e5;
    background: #ffffff;
    color: #000000;
    font-family: inherit;
    font-size: 16px;
    font-weight: 400;
    line-height: 24px;
    outline: none;
  }
  .input::placeholder { color: #a3a3a3; }
  .input.has-icon { padding-right: 44px; }

  .select {
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    padding-right: 44px;
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23737373' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'></polyline></svg>");
    background-repeat: no-repeat;
    background-position: right 16px center;
    cursor: pointer;
  }
  .select.is-placeholder { color: #a3a3a3; }

  .input-icon {
    position: absolute;
    top: 50%;
    right: 8px;
    transform: translateY(-50%);
    width: 32px;
    height: 32px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: transparent;
    border: 0;
    border-radius: 9999px;
    cursor: pointer;
    color: #737373;
    padding: 0;
  }
  .input-icon svg {
    width: 18px;
    height: 18px;
  }

  .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    height: 48px;
    border-radius: 9999px;
    background: #000000;
    color: #ffffff;
    border: 0;
    font-family: inherit;
    font-size: 14px;
    font-weight: 500;
    line-height: 1;
    cursor: pointer;
    margin-top: 8px;
  }

  /* footer */
  .footer-prompt {
    position: absolute;
    bottom: 32px;
    left: 0;
    width: 390px;
    text-align: center;
    font-size: 14px;
    font-weight: 400;
    line-height: 20px;
    color: #737373;
  }
  .link-inline {
    color: #000000;
    font-weight: 500;
    text-decoration: underline;
    text-underline-offset: 3px;
    margin-left: 4px;
  }
</style>
</head>
<body>
  <div class="frame">

    <!-- hero -->
    <header class="hero">
      <h1 class="headline">계정을<br>만들어보세요</h1>
    </header>

    <!-- form -->
    <%-- 가입 실패 메시지 (UserController에서 전달, c:out으로 XSS 방지) --%>
    <c:if test="${not empty errorMessage}">
      <div style="width:342px; margin:0 auto 12px; color:#e03131; font-size:14px;"><c:out value="${errorMessage}"/></div>
    </c:if>

    <form class="form" method="post"
          action="<%= request.getContextPath() %>/user/join"
          onsubmit="return checkJoin(this);">
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

      <button type="submit" class="btn">회원가입</button>
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
