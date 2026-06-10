<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>동네생활</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body { background: #f0f0f0; font-family: ui-sans-serif, system-ui, "Malgun Gothic", sans-serif; }
  .frame { width: 390px; min-height: 844px; background: #fff; position: relative; margin: 40px auto; padding-bottom: 40px; }
  .topbar { height: 56px; border-bottom: 1px solid #e5e5e5; display: flex; align-items: center; padding: 0 16px; }
  .icon-btn { width: 40px; height: 40px; display: inline-flex; align-items: center; justify-content: center; color: #000; text-decoration: none; }
  .icon-btn svg { width: 22px; height: 22px; }
  .topbar-title { flex: 1; text-align: center; font-size: 16px; font-weight: 600; }
  .post { display: block; padding: 16px 24px; border-bottom: 1px solid #f0f0f0; text-decoration: none; color: #000; }
  .post .t { font-size: 15px; font-weight: 500; }
  .post .m { font-size: 12px; color: #a3a3a3; margin-top: 6px; }
  .empty { text-align: center; color: #a3a3a3; padding: 80px 24px; font-size: 14px; }
  .fab { position: fixed; left: 50%; transform: translateX(127px); bottom: 32px; width: 56px; height: 56px; border-radius: 9999px; background: #ff6f0f; color: #fff; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 12px rgba(0,0,0,.25); text-decoration: none; }
  .fab svg { width: 28px; height: 28px; }
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
