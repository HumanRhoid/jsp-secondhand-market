<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>동네생활 글</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/design.css">
<style>
  .frame { padding-bottom: 40px; }
  .head { padding: 24px 24px 12px; border-bottom: 1px solid var(--hairline); }
  .head .t { font-family: var(--font-display); font-size: 20px; font-weight: 600; }
  .head .m { font-size: 12px; color: var(--mute); margin-top: 8px; }
  .body { padding: 24px; font-size: 15px; line-height: 1.7; color: var(--charcoal); white-space: pre-wrap; }
</style>
</head>
<body>
  <div class="frame">
    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/board/" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
      </a>
      <div class="topbar-title offset-back">동네생활</div>
    </div>

    <div class="head">
      <div class="t"><c:out value="${post.title}"/></div>
      <div class="m"><c:out value="${empty post.nickname ? '탈퇴회원' : post.nickname}"/> · 조회 ${post.viewCount} · <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/></div>
    </div>
    <div class="body"><c:out value="${post.content}"/></div>
  </div>
</body>
</html>
