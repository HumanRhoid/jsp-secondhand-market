<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><c:out value="${product.title}"/> - 상품 상세</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/design.css">
<style>
  .frame { height: 844px; }
  .topbar { position: absolute; top: 0; left: 0; }

  /* 상품 사진 */
  .product-image {
    position: absolute;
    top: 56px;
    left: 0;
    width: 388px;        /* 프레임 hairline(1px×2) 보정 */
    height: 320px;
    background: var(--surface-soft);
    overflow: hidden;
  }
  .product-image img { width: 388px; height: 320px; object-fit: cover; display: block; }
  /* 여러 장: 좌우 스와이프 갤러리 */
  .product-image .gallery {
    display: flex;
    width: 388px;
    height: 320px;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
  }
  .product-image .gallery img { flex: 0 0 388px; scroll-snap-align: start; }

  /* 정보 영역 */
  .content {
    position: absolute;
    top: 400px;
    left: 24px;
    width: 342px;
    display: flex;
    flex-direction: column;
  }
  .seller { font-size: 14px; font-weight: 400; line-height: 20px; color: var(--body); margin-bottom: 4px; }
  .title { margin-bottom: 12px; }       /* heading-lg */
  .price { margin-bottom: 20px; }       /* display-lg */
  .meta-line { font-size: 14px; line-height: 20px; color: var(--charcoal); margin-bottom: 24px; }
  .divider { margin-bottom: 24px; }
  .description { font-size: 16px; font-weight: 400; line-height: 24px; color: var(--charcoal); }

  /* 본인 매물 관리(수정/삭제) 버튼 */
  .owner-actions { margin-top: 20px; display: flex; gap: 8px; }
  .owner-actions form { flex: 1; }
  .owner-actions .btn { width: 100%; height: 40px; }
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
      <h1 class="heading-lg title"><c:out value="${product.title}"/></h1>
      <div class="display-lg price"><fmt:formatNumber value="${product.price}" />원</div>
      <div class="meta-line"><c:out value="${product.status}"/> · 조회 ${product.viewCount} · 관심 ${product.likeCount}</div>
      <div class="divider"></div>
      <p class="description"><c:out value="${product.description}"/></p>

      <%-- 본인 매물일 때만 관리 메뉴 노출 --%>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id == product.userId}">
        <div class="owner-actions">
          <a class="btn btn-secondary" style="flex:1;" href="${pageContext.request.contextPath}/product/edit?id=${product.id}">수정</a>
          <form method="post" action="${pageContext.request.contextPath}/product/delete"
                onsubmit="return confirm('정말 삭제하시겠습니까?');">
            <input type="hidden" name="id" value="${product.id}">
            <button type="submit" class="btn btn-quiet">삭제</button>
          </form>
        </div>
      </c:if>
    </div>

    <!-- 하단 액션바 -->
    <div class="action-bar">
      <form method="post" action="${pageContext.request.contextPath}/cart/add" style="flex:0 0 auto;">
        <input type="hidden" name="id" value="${product.id}">
        <button type="submit" class="btn btn-secondary">장바구니</button>
      </form>
      <button class="btn btn-primary" style="flex:1;" type="button" onclick="requestPay()">구매하기</button>
    </div>

  <%-- 토스페이먼츠 결제 (테스트 키 — 실결제 없음). 성공 시 /order/success에서 서버 승인(confirm) --%>
  <script src="https://js.tosspayments.com/v1/payment"></script>
  <script>
    var TOSS_KEY = '<c:out value="${tossClientKey}"/>';
    function requestPay() {
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id == product.userId}">
      alert('본인 매물은 구매할 수 없습니다.'); return;
      </c:if>
      <c:if test="${empty sessionScope.loginUser}">
      location.href = '${pageContext.request.contextPath}/user/login'; return;
      </c:if>
      var base = location.origin + '${pageContext.request.contextPath}';
      TossPayments(TOSS_KEY).requestPayment('카드', {
        amount: ${product.price},
        orderId: 'order_${product.id}_' + Date.now(),
        orderName: '<c:out value="${product.title}"/>',
        successUrl: base + '/order/success',   // → 서버가 confirm API로 승인
        failUrl: base + '/order/fail'
      }).catch(function (err) {
        if (err.code !== 'USER_CANCEL') alert('결제 오류: ' + (err.message || ''));
      });
    }
    // 결제 결과 메시지 (/order/success|fail 리다이렉트 파라미터)
    (function () {
      var msg = new URLSearchParams(location.search).get('payMsg');
      if (msg) alert(msg);
    })();
  </script>

  </div>
</body>
</html>
