<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오류</title>
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
  .code { font-size: 13px; color: #a3a3a3; text-align: center; margin-bottom: 4px; }
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
      <h1 class="headline">문제가 발생했어요</h1>
      <p class="code"><c:out value="${errorCode}"/></p>
      <p class="sub"><c:out value="${errorMessage}"/></p>
      <a class="btn" href="${pageContext.request.contextPath}/product/">홈으로 돌아가기</a>
    </div>
  </div>
</body>
</html>
