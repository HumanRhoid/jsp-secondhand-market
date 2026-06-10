<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오류</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/error.css">
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
