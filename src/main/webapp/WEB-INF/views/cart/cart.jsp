<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/design.css">
<style>
  .frame { padding-bottom: 100px; }
  .item { display: flex; gap: 12px; padding: 16px 24px; border-bottom: 1px solid var(--hairline); align-items: center; }
  .item img { width: 64px; height: 64px; border-radius: var(--rounded-lg); object-fit: cover; background: var(--surface-soft); border: 1px solid var(--hairline); }
  .item .info { flex: 1; min-width: 0; }
  .item .t { font-size: 15px; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .item .p { font-size: 15px; font-weight: 700; margin-top: 4px; }
  .rm { border: 0; background: transparent; color: var(--mute); font-size: 13px; cursor: pointer; font-family: inherit; text-decoration: underline; text-underline-offset: 3px; }
  .summary {
    position: absolute; bottom: 0; left: 0; width: 100%;
    padding: 16px 24px; border-top: 1px solid var(--hairline); background: var(--canvas);
    display: flex; justify-content: space-between; align-items: center;
  }
  .summary .label-sum { font-size: 14px; color: var(--body); }
  .total { font-family: var(--font-display); font-size: 18px; font-weight: 600; }
</style>
</head>
<body>
  <div class="frame">
    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/product/" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
      </a>
      <div class="topbar-title offset-back">장바구니</div>
    </div>

    <c:choose>
      <c:when test="${empty items}">
        <div class="empty">장바구니가 비어 있어요.<br>관심 매물을 담아보세요!</div>
      </c:when>
      <c:otherwise>
        <c:set var="total" value="0"/>
        <c:forEach var="p" items="${items}">
          <c:set var="total" value="${total + p.price}"/>
          <c:set var="thumb" value="${empty p.thumbnail ? 'https://picsum.photos/seed/'.concat(p.id).concat('/128/128') : (fn:startsWith(p.thumbnail, '/') ? pageContext.request.contextPath.concat(p.thumbnail) : p.thumbnail)}"/>
          <div class="item">
            <a href="${pageContext.request.contextPath}/product/detail?id=${p.id}"><img src="<c:out value='${thumb}'/>" alt=""></a>
            <div class="info">
              <div class="t"><c:out value="${p.title}"/></div>
              <div class="p"><fmt:formatNumber value="${p.price}"/>원</div>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/cart/remove">
              <input type="hidden" name="id" value="${p.id}">
              <button class="rm" type="submit">삭제</button>
            </form>
          </div>
        </c:forEach>
        <div class="summary">
          <span class="label-sum">합계</span>
          <span class="total"><fmt:formatNumber value="${total}"/>원</span>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>
