<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>환영합니다</title>
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
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  .stack {
    width: 342px;
    display: flex;
    flex-direction: column;
    align-items: stretch;
  }

  .headline {
    font-family: "SF Pro Rounded", "SF Pro Display", system-ui, -apple-system, "Apple SD Gothic Neo", sans-serif;
    font-size: 36px;
    font-weight: 500;
    line-height: 1.11;
    letter-spacing: 0;
    color: #000000;
    text-align: center;
    margin-bottom: 8px;
  }

  .sub {
    font-size: 16px;
    font-weight: 400;
    line-height: 1.5;
    color: #737373;
    text-align: center;
    margin-bottom: 32px;
  }

  .btn-group {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    height: 48px;
    padding: 0 20px;
    border-radius: 9999px;
    font-family: inherit;
    font-size: 14px;
    font-weight: 500;
    line-height: 1;
    cursor: pointer;
    border: 1px solid transparent;
  }

  .btn-primary {
    background: #000000;
    color: #ffffff;
  }
  .btn-primary:active {
    background: #090909;
  }

  .btn-secondary {
    background: #ffffff;
    color: #000000;
    border-color: #d4d4d4;
  }
  .btn-secondary:active {
    background: #fafafa;
  }
</style>
</head>
<body>
  <div class="frame">
    <div class="stack">
      <h1 class="headline">환영합니다</h1>
      <p class="sub">계속하려면 아래에서 선택하세요</p>

      <div class="btn-group">
        <button type="button" class="btn btn-primary">회원가입</button>
        <button type="button" class="btn btn-secondary">로그인</button>
      </div>
    </div>
  </div>
</body>
</html>
