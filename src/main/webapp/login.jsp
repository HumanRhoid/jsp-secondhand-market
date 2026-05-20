<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인</title>
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
    top: 64px;
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
    top: 160px;
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
  .input {
    width: 100%;
    height: 44px;
    padding: 8px 44px 8px 16px;
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

  .input-icon {
    position: absolute;
    top: 50%;
    right: 12px;
    transform: translateY(-50%);
    width: 28px;
    height: 28px;
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

  .forgot-row {
    display: flex;
    justify-content: flex-end;
    margin-top: -8px;
  }
  .link-mute {
    font-size: 14px;
    font-weight: 400;
    line-height: 20px;
    color: #737373;
    text-decoration: underline;
    text-underline-offset: 3px;
    text-decoration-color: #d4d4d4;
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
      <h1 class="headline">안녕하세요,<br>로그인하세요</h1>
    </header>

    <!-- form -->
    <form class="form" onsubmit="event.preventDefault();">
      <div class="field">
        <label class="label" for="email">이메일</label>
        <div class="input-wrap">
          <input class="input" type="email" id="email" name="email"
                 placeholder="name@example.com" autocomplete="email" value="">
          <span class="input-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="20 6 9 17 4 12"></polyline>
            </svg>
          </span>
        </div>
      </div>

      <div class="field">
        <label class="label" for="password">비밀번호</label>
        <div class="input-wrap">
          <input class="input" type="password" id="password" name="password"
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

      <button type="submit" class="btn">로그인</button>
    </form>

    <!-- footer -->
    <div class="footer-prompt">
      계정이 없으신가요?<a class="link-inline" href="#">회원가입</a>
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
