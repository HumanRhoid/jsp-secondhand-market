<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>동네생활 글</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body { background: #f0f0f0; font-family: ui-sans-serif, system-ui, "Malgun Gothic", sans-serif; }
  .frame { width: 390px; min-height: 844px; background: #fff; position: relative; margin: 40px auto; padding-bottom: 40px; }
  .topbar { height: 56px; border-bottom: 1px solid #e5e5e5; display: flex; align-items: center; padding: 0 16px; }
  .icon-btn { width: 40px; height: 40px; display: inline-flex; align-items: center; justify-content: center; color: #000; text-decoration: none; }
  .icon-btn svg { width: 22px; height: 22px; }
  .topbar-title { flex: 1; text-align: center; font-size: 16px; font-weight: 600; margin-right: 40px; }
  .head { padding: 24px 24px 12px; border-bottom: 1px solid #f0f0f0; }
  .head .t { font-size: 20px; font-weight: 700; }
  .head .m { font-size: 12px; color: #a3a3a3; margin-top: 8px; }
  .body { padding: 24px; font-size: 15px; line-height: 1.7; white-space: pre-wrap; }
</style>
</head>
<body>
  <div class="frame">
    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/board/" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
      </a>
      <div class="topbar-title">동네생활</div>
    </div>

    <div class="head">
      <div class="t"><c:out value="${post.title}"/></div>
      <div class="m"><c:out value="${empty post.nickname ? '탈퇴회원' : post.nickname}"/> · 조회 ${post.viewCount} · <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd HH:mm"/></div>
    </div>
    <div class="body"><c:out value="${post.content}"/></div>
  </div>
</body>
</html>
