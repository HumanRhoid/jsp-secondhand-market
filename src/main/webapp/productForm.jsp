<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<style>
  /*
    ───────────────────────────────────────────────
    FIGMA-READY — 390 × 844 모바일 프레임
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
    height: 844px;
    background: #ffffff;
    position: relative;
    overflow: hidden;
    margin: 40px auto;
  }

  /* 상단바 */
  .topbar {
    position: absolute;
    top: 0;
    left: 0;
    width: 390px;
    height: 56px;
    background: #ffffff;
    border-bottom: 1px solid #e5e5e5;
    display: flex;
    align-items: center;
    padding: 0 16px;
  }
  .icon-btn {
    width: 40px;
    height: 40px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: transparent;
    border: 0;
    border-radius: 9999px;
    color: #000000;
    padding: 0;
    cursor: pointer;
  }
  .icon-btn svg {
    width: 22px;
    height: 22px;
  }
  .topbar-title {
    position: absolute;
    left: 0;
    right: 0;
    text-align: center;
    font-size: 16px;
    font-weight: 500;
    line-height: 24px;
    color: #000000;
    pointer-events: none;
  }

  /* 사진 업로드 영역 */
  .photo-upload {
    position: absolute;
    top: 80px;
    left: 24px;
    width: 342px;
    height: 200px;
    border-radius: 12px;
    background: #fafafa;
    border: 1px dashed #d4d4d4;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 12px;
    cursor: pointer;
  }
  .photo-upload svg {
    width: 32px;
    height: 32px;
    color: #737373;
  }
  .photo-upload .photo-label {
    font-size: 14px;
    font-weight: 500;
    line-height: 20px;
    color: #525252;
  }
  .photo-upload .photo-hint {
    font-size: 12px;
    font-weight: 400;
    line-height: 16px;
    color: #a3a3a3;
    margin-top: -4px;
  }

  /* 폼 */
  .form {
    position: absolute;
    top: 304px;
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

  /* 단일 행 입력 (제목, 가격) */
  .input-wrap {
    position: relative;
  }
  .input {
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
  .input.has-suffix { padding-right: 40px; }

  .input-suffix {
    position: absolute;
    top: 0;
    right: 16px;
    height: 44px;
    display: flex;
    align-items: center;
    font-size: 16px;
    font-weight: 500;
    color: #525252;
    pointer-events: none;
  }

  /* 멀티라인 textarea (설명) — pill 아니라 rounded.lg */
  .textarea {
    width: 100%;
    height: 140px;
    padding: 12px 16px;
    border-radius: 12px;
    border: 1px solid #e5e5e5;
    background: #ffffff;
    color: #000000;
    font-family: inherit;
    font-size: 16px;
    font-weight: 400;
    line-height: 24px;
    outline: none;
    resize: none;
  }
  .textarea::placeholder { color: #a3a3a3; }

  /* 하단 액션바 */
  .action-bar {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 390px;
    height: 80px;
    background: #ffffff;
    border-top: 1px solid #e5e5e5;
    display: flex;
    align-items: center;
    padding: 0 24px;
  }
  .submit-btn {
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

    <!-- 상단바 -->
    <div class="topbar">
      <button class="icon-btn" type="button" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
      </button>
      <div class="topbar-title">상품 등록</div>
    </div>

    <!-- 사진 업로드 -->
    <div class="photo-upload" role="button" tabindex="0" aria-label="사진 추가">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
        <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
        <circle cx="12" cy="13" r="4"></circle>
      </svg>
      <div class="photo-label">사진 추가</div>
      <div class="photo-hint">최대 10장까지 올릴 수 있어요</div>
    </div>

    <!-- 폼 -->
    <div class="form">

      <div class="field">
        <label class="label">제목</label>
        <div class="input-wrap">
          <input class="input" type="text" placeholder="상품명을 입력하세요">
        </div>
      </div>

      <div class="field">
        <label class="label">가격</label>
        <div class="input-wrap">
          <input class="input has-suffix" type="text" inputmode="numeric" placeholder="0">
          <span class="input-suffix">원</span>
        </div>
      </div>

      <div class="field">
        <label class="label">설명</label>
        <textarea class="textarea" placeholder="상품 상태, 사용 기간, 거래 가능 지역 등을 자유롭게 적어주세요"></textarea>
      </div>

    </div>

    <!-- 하단 등록 버튼 -->
    <div class="action-bar">
      <button class="submit-btn" type="button">등록하기</button>
    </div>

  </div>
</body>
</html>
