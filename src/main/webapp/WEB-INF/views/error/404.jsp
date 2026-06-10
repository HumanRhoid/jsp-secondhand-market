<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>페이지를 찾을 수 없습니다</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/error.css">
</head>
<body>
  <div class="frame">
    <div class="stack">
      <h1 class="headline">404</h1>
      <p class="sub">요청하신 페이지를 찾을 수 없습니다.</p>
      <a class="btn" href="${pageContext.request.contextPath}/product/">홈으로 돌아가기</a>
    </div>
  </div>
</body>
</html>
