<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 오류</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body {
    background: #f0f0f0;
    font-family: ui-sans-serif, system-ui, -apple-system, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
  }
  .frame {
    width: 390px; height: 844px; background: #ffffff;
    margin: 40px auto; display: flex; flex-direction: column;
    align-items: center; justify-content: center;
  }
  .stack { width: 342px; display: flex; flex-direction: column; align-items: stretch; }
  .headline { font-size: 28px; font-weight: 500; color: #000; text-align: center; margin-bottom: 8px; }
  .sub { font-size: 16px; color: #737373; text-align: center; margin-bottom: 32px; }
  .btn {
    display: inline-flex; align-items: center; justify-content: center;
    height: 48px; border-radius: 9999px; font-size: 14px; font-weight: 500;
    cursor: pointer; border: 1px solid transparent;
    background: #000; color: #fff; text-decoration: none;
  }
</style>
</head>
<body>
  <div class="frame">
    <div class="stack">
      <h1 class="headline">500</h1>
      <p class="sub">서버 내부 오류가 발생했습니다.<br>잠시 후 다시 시도해 주세요.</p>
      <a class="btn" href="${pageContext.request.contextPath}/product/">홈으로 돌아가기</a>
    </div>
  </div>
</body>
</html>
