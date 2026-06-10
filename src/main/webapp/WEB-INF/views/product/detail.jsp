<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><c:out value="${product.title}"/> - 상품 상세</title>
<style>
  /*
    ───────────────────────────────────────────────
    FIGMA-READY — 390 × 844 모바일 프레임
    - 모든 치수 px 고정
    - position: sticky 없음, 미디어 쿼리 없음
    ───────────────────────────────────────────────
  */

  * { margin: 0; padding: 0; box-sizing: border-box; }

  html, body {
    background: #f0f0f0;
    font-family: ui-sans-serif, system-ui, -apple-system, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
    -webkit-font-smoothing: antialiased;
  }

  /* 모바일 프레임 */
  .frame {
    width: 390px;
    height: 844px;
    background: #ffffff;
    position: relative;
    overflow: hidden;
    margin: 40px auto;
  }

  /* 상단바 */
  .topbar {
    position: absolute;
    top: 0;
    left: 0;
    width: 390px;
    height: 56px;
    background: #ffffff;
    border-bottom: 1px solid #e5e5e5;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 16px;
    z-index: 2;
  }
  .icon-btn {
    width: 40px;
    height: 40px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    background: transparent;
    border: 0;
    border-radius: 9999px;
    color: #000000;
    padding: 0;
    cursor: pointer;
  }
  .icon-btn svg {
    width: 22px;
    height: 22px;
  }
  .topbar-right {
    display: flex;
    align-items: center;
    gap: 4px;
  }

  /* 상품 사진 */
  .product-image {
    position: absolute;
    top: 56px;
    left: 0;
    width: 390px;
    height: 320px;
    background: #fafafa;
    overflow: hidden;
  }
  .product-image img {
    width: 390px;
    height: 320px;
    object-fit: cover;
    display: block;
  }
  /* 여러 장: 좌우 스와이프 갤러리 */
  .product-image .gallery {
    display: flex;
    width: 390px;
    height: 320px;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
  }
  .product-image .gallery img {
    flex: 0 0 390px;
    scroll-snap-align: start;
  }

  /* 정보 영역 */
  .content {
    position: absolute;
    top: 400px;
    left: 24px;
    width: 342px;
    display: flex;
    flex-direction: column;
  }
  .seller {
    font-size: 14px;
    font-weight: 400;
    line-height: 20px;
    color: #737373;
    margin-bottom: 4px;
  }
  .title {
    font-family: "SF Pro Rounded", "SF Pro Display", system-ui, -apple-system, "Apple SD Gothic Neo", sans-serif;
    font-size: 24px;
    font-weight: 600;
    line-height: 32px;
    color: #000000;
    margin-bottom: 12px;
  }
  .price {
    font-family: "SF Pro Rounded", "SF Pro Display", system-ui, -apple-system, "Apple SD Gothic Neo", sans-serif;
    font-size: 30px;
    font-weight: 500;
    line-height: 36px;
    color: #000000;
    margin-bottom: 20px;
  }
  .shipping {
    font-size: 14px;
    font-weight: 400;
    line-height: 20px;
    color: #525252;
    margin-bottom: 24px;
  }
  .divider {
    width: 342px;
    height: 1px;
    background: #e5e5e5;
    margin-bottom: 24px;
  }
  .description {
    font-size: 16px;
    font-weight: 400;
    line-height: 24px;
    color: #525252;
  }

  /* 하단 액션바 */
  .action-bar {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 390px;
    height: 80px;
    background: #ffffff;
    border-top: 1px solid #e5e5e5;
    display: flex;
    align-items: center;
    padding: 0 16px;
    gap: 12px;
  }
  .heart-btn {
    width: 48px;
    height: 48px;
    flex-shrink: 0;
    border-radius: 9999px;
    border: 1px solid #d4d4d4;
    background: #ffffff;
    color: #000000;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0;
    cursor: pointer;
  }
  .heart-btn svg {
    width: 22px;
    height: 22px;
  }
  .buy-btn {
    flex: 1;
    height: 48px;
    border-radius: 9999px;
    background: #000000;
    color: #ffffff;
    border: 0;
    font-family: inherit;
    font-size: 14px;
    font-weight: 500;
    line-height: 14px;
    cursor: pointer;
  }
</style>
</head>
<body>
  <div class="frame">

    <!-- 상단바 -->
    <div class="topbar">
      <button class="icon-btn" type="button" aria-label="뒤로"
              onclick="location.href='${pageContext.request.contextPath}/product/'">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
      </button>
    </div>

    <!-- 상품 사진 (여러 장이면 좌우 스와이프 갤러리, 없으면 대표/임시 이미지) -->
    <div class="product-image">
      <c:choose>
        <c:when test="${not empty product.images}">
          <div class="gallery">
            <c:forEach var="img" items="${product.images}">
              <img src="${pageContext.request.contextPath}<c:out value='${img}'/>" alt="<c:out value="${product.title}"/>">
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <c:set var="thumb" value="${empty product.thumbnail ? 'https://picsum.photos/seed/'.concat(product.id).concat('/780/640') : (fn:startsWith(product.thumbnail, '/') ? pageContext.request.contextPath.concat(product.thumbnail) : product.thumbnail)}"/>
          <img src="<c:out value='${thumb}'/>" alt="<c:out value="${product.title}"/>">
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 상품 정보 -->
    <div class="content">
      <div class="seller"><c:out value="${seller.nickname}"/> · <c:out value="${seller.region}"/> · 매너온도 ${seller.mannerTemp}℃</div>
      <h1 class="title"><c:out value="${product.title}"/></h1>
      <div class="price"><fmt:formatNumber value="${product.price}" />원</div>
      <div class="shipping"><c:out value="${product.status}"/> · 조회 ${product.viewCount} · 관심 ${product.likeCount}</div>
      <div class="divider"></div>
      <p class="description"><c:out value="${product.description}"/></p>

      <%-- 본인 매물일 때만 관리 메뉴 노출 --%>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id == product.userId}">
        <div style="margin-top:20px; display:flex; gap:8px;">
          <a href="${pageContext.request.contextPath}/product/edit?id=${product.id}"
             style="flex:1; height:40px; border-radius:9999px; border:1px solid #d4d4d4; background:#fff; color:#000; display:flex; align-items:center; justify-content:center; text-decoration:none;">수정</a>
          <form method="post" action="${pageContext.request.contextPath}/product/delete"
                onsubmit="return confirm('정말 삭제하시겠습니까?');" style="flex:1;">
            <input type="hidden" name="id" value="${product.id}">
            <button type="submit"
                    style="width:100%; height:40px; border-radius:9999px; border:1px solid #e03131; background:#fff; color:#e03131; cursor:pointer;">삭제</button>
          </form>
        </div>
      </c:if>
    </div>

    <!-- 하단 액션바 -->
    <div class="action-bar" style="gap:8px;">
      <form method="post" action="${pageContext.request.contextPath}/cart/add" style="flex:0 0 auto;">
        <input type="hidden" name="id" value="${product.id}">
        <button type="submit" style="height:48px; padding:0 18px; border-radius:9999px; border:1px solid #d4d4d4; background:#fff; cursor:pointer;">장바구니</button>
      </form>
      <button class="buy-btn" type="button" style="flex:1;" onclick="alert('결제(포트원) 연동은 준비 중입니다.')">구매하기</button>
    </div>

  </div>
</body>
</html>
