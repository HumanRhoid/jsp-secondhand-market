<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 정보</title>
<style>
  /*
    ───────────────────────────────────────────────
    FIGMA-READY — 390 × 720 모바일 프레임
    - 모든 치수 px 고정
    - position: sticky 없음, 미디어 쿼리 없음
    ───────────────────────────────────────────────
  */

  * { margin: 0; padding: 0; box-sizing: border-box; }

  html, body {
    background: #f0f0f0;
    font-family: ui-sans-serif, system-ui, -apple-system, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
    -webkit-font-smoothing: antialiased;
  }

  /* 모바일 프레임 */
  .frame {
    width: 390px;
    height: 720px;
    background: #ffffff;
    position: relative;
    overflow: hidden;
    margin: 40px auto;
  }

  /* 프로필 사진 영역 */
  .avatar-section {
    position: absolute;
    top: 56px;
    left: 0;
    width: 390px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  .avatar-wrap {
    position: relative;
    width: 96px;
    height: 96px;
  }
  .avatar {
    width: 96px;
    height: 96px;
    border-radius: 9999px;
    background: #fafafa;
    object-fit: cover;
    display: block;
  }
  .avatar-edit {
    position: absolute;
    bottom: 0;
    right: 0;
    width: 30px;
    height: 30px;
    border-radius: 9999px;
    background: #000000;
    border: 2px solid #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #ffffff;
    padding: 0;
    cursor: pointer;
  }
  .avatar-edit svg {
    width: 14px;
    height: 14px;
  }

  /* 폼 */
  .form {
    position: absolute;
    top: 200px;
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
  .has-icon { padding-right: 44px; }

  .input-icon {
    position: absolute;
    top: 6px;
    right: 8px;
    width: 32px;
    height: 32px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: transparent;
    border: 0;
    border-radius: 9999px;
    color: #737373;
    padding: 0;
    cursor: pointer;
  }
  .input-icon svg {
    width: 18px;
    height: 18px;
  }

  .select {
    appearance: none;
    -webkit-appearance: none;
    padding-right: 44px;
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%23737373' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'></polyline></svg>");
    background-repeat: no-repeat;
    background-position: right 16px center;
    cursor: pointer;
  }

  /* 저장 버튼 */
  .save-btn {
    position: absolute;
    left: 24px;
    bottom: 32px;
    width: 342px;
    height: 48px;
    border-radius: 9999px;
    background: #000000;
    color: #ffffff;
    border: 0;
    font-family: inherit;
    font-size: 14px;
    font-weight: 500;
    line-height: 14px;
    cursor: pointer;
  }
</style>
</head>
<body>
  <div class="frame">

    <!-- 프로필 사진 -->
    <div class="avatar-section">
      <div class="avatar-wrap">
        <img class="avatar" src="https://i.pravatar.cc/192?img=47" alt="프로필 사진">
        <button class="avatar-edit" type="button" aria-label="사진 변경">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 20h9"></path>
            <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
          </svg>
        </button>
      </div>
    </div>

    <!-- 폼 -->
    <div class="form">

      <div class="field">
        <label class="label">이름</label>
        <div class="input-wrap">
          <input class="input" type="text" value="홍길동">
        </div>
      </div>

      <div class="field">
        <label class="label">이메일</label>
        <div class="input-wrap">
          <input class="input" type="email" value="hong@example.com">
        </div>
      </div>

      <div class="field">
        <label class="label">비밀번호</label>
        <div class="input-wrap">
          <input class="input has-icon" type="password" value="••••••••">
          <button class="input-icon" type="button" aria-label="비밀번호 표시 전환">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
              <circle cx="12" cy="12" r="3"></circle>
            </svg>
          </button>
        </div>
      </div>

      <div class="field">
        <label class="label">지역</label>
        <div class="input-wrap">
          <select class="select">
            <option>서울</option>
            <option>부산</option>
            <option>인천</option>
            <option>대구</option>
            <option>광주</option>
            <option>대전</option>
            <option>울산</option>
            <option>세종</option>
            <option>경기</option>
            <option>강원</option>
            <option>충북</option>
            <option>충남</option>
            <option>전북</option>
            <option>전남</option>
            <option>경북</option>
            <option>경남</option>
            <option>제주</option>
          </select>
        </div>
      </div>

    </div>

    <!-- 저장 -->
    <button class="save-btn" type="button" onclick="location.href='<%= request.getContextPath() %>/user/profile'">저장</button>

  </div>
</body>
</html>
