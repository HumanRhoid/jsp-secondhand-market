<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body { background: #f0f0f0; font-family: ui-sans-serif, system-ui, "Malgun Gothic", sans-serif; }
  .frame { width: 390px; min-height: 844px; background: #fff; position: relative; margin: 40px auto; padding-bottom: 100px; }
  .topbar { height: 56px; border-bottom: 1px solid #e5e5e5; display: flex; align-items: center; padding: 0 16px; }
  .icon-btn { width: 40px; height: 40px; display: inline-flex; align-items: center; justify-content: center; color: #000; text-decoration: none; }
  .icon-btn svg { width: 22px; height: 22px; }
  .topbar-title { flex: 1; text-align: center; font-size: 16px; font-weight: 600; margin-right: 40px; }
  .item { display: flex; gap: 12px; padding: 16px 24px; border-bottom: 1px solid #f0f0f0; align-items: center; }
  .item img { width: 64px; height: 64px; border-radius: 10px; object-fit: cover; background: #fafafa; }
  .item .info { flex: 1; min-width: 0; }
  .item .t { font-size: 15px; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .item .p { font-size: 15px; font-weight: 700; margin-top: 4px; }
  .rm { border: 0; background: transparent; color: #a3a3a3; font-size: 13px; cursor: pointer; }
  .empty { text-align: center; color: #a3a3a3; padding: 80px 24px; font-size: 14px; }
  .summary { position: absolute; bottom: 0; left: 0; width: 390px; padding: 16px 24px; border-top: 1px solid #e5e5e5; background: #fff; display: flex; justify-content: space-between; align-items: center; }
  .total { font-size: 16px; font-weight: 700; }
</style>
</head>
<body>
  <div class="frame">
    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/product/" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
      </a>
      <div class="topbar-title">장바구니</div>
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
          <span>합계</span>
          <span class="total"><fmt:formatNumber value="${total}"/>원</span>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>
