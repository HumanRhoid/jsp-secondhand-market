<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서버 오류</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/error.css">
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
