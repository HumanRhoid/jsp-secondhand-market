<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>동네생활</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/design.css">
<style>
  .frame { padding-bottom: 40px; }
  .post { display: block; padding: 16px 24px; border-bottom: 1px solid var(--hairline); text-decoration: none; color: var(--ink); }
  .post .t { font-size: 15px; font-weight: 500; }
  .post .m { font-size: 12px; color: var(--mute); margin-top: 6px; }
</style>
</head>
<body>
  <div class="frame">
    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/product/" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
      </a>
      <div class="topbar-title">동네생활</div>
      <span style="width:40px;"></span>
    </div>

    <c:choose>
      <c:when test="${empty posts}">
        <div class="empty">아직 글이 없어요.<br>첫 글을 남겨보세요!</div>
      </c:when>
      <c:otherwise>
        <c:forEach var="post" items="${posts}">
          <a class="post" href="${pageContext.request.contextPath}/board/view?id=${post.id}">
            <div class="t"><c:out value="${post.title}"/></div>
            <div class="m"><c:out value="${empty post.nickname ? '탈퇴회원' : post.nickname}"/> · 조회 ${post.viewCount} · <fmt:formatDate value="${post.createdAt}" pattern="MM.dd HH:mm"/></div>
          </a>
        </c:forEach>
      </c:otherwise>
    </c:choose>

    <a class="fab" href="${pageContext.request.contextPath}/board/write" title="글쓰기">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
    </a>
  </div>
</body>
</html>
