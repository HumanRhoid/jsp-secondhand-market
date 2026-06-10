<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/design.css">
<style>
  .frame { padding-bottom: 100px; }
  .form { padding: 16px 24px; display: flex; flex-direction: column; gap: 16px; }
  .textarea { height: 360px; }
</style>
</head>
<body>
  <div class="frame">
    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/board/" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
      </a>
      <div class="topbar-title offset-back">글쓰기</div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/board/write">
      <div class="form">
        <input class="input" type="text" name="title" placeholder="제목" required>
        <textarea class="textarea" name="content" placeholder="이웃과 나누고 싶은 이야기를 적어보세요"></textarea>
      </div>
      <div class="action-bar">
        <button class="btn btn-primary btn-block" type="submit">등록</button>
      </div>
    </form>
  </div>
</body>
</html>
