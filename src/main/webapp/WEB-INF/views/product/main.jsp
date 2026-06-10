<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>둘러보기</title>
<style>
  /*
    ───────────────────────────────────────────────
    FIGMA-READY — 390px 모바일 프레임 (동적 데이터 연동판)
    - 카드 그리드는 DB(products) 데이터로 렌더링
    - 인기 매물 스트립은 Redis 랭킹 TOP 4 (Redis 미동작 시 자동 미표시)
    ───────────────────────────────────────────────
  */

  * { margin: 0; padding: 0; box-sizing: border-box; }

  html, body {
    background: #f0f0f0;
    font-family: ui-sans-serif, system-ui, -apple-system, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
    -webkit-font-smoothing: antialiased;
  }

  /* 모바일 프레임 (내용 길이에 맞춰 늘어나도록 변경) */
  .frame {
    width: 390px;
    min-height: 1140px;
    background: #ffffff;
    position: relative;
    margin: 40px auto;
    padding-bottom: 40px;
  }

  /* 상단 검색바 */
  .topbar {
    width: 390px;
    height: 56px;
    background: #ffffff;
    border-bottom: 1px solid #e5e5e5;
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 0 16px;
  }
  .topbar-action {
    width: 40px;
    height: 40px;
    flex-shrink: 0;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 9999px;
    color: #000;
    text-decoration: none;
  }
  .topbar-action svg { width: 24px; height: 24px; }
  .search-pill {
    flex: 1;
    height: 36px;
    background: #fafafa;
    border-radius: 9999px;
    display: flex;
    align-items: center;
    padding: 0 16px;
    gap: 8px;
  }
  .search-pill svg {
    width: 16px;
    height: 16px;
    color: #737373;
    flex-shrink: 0;
  }
  .search-pill .search-input {
    flex: 1;
    min-width: 0;
    border: 0;
    outline: none;
    background: transparent;
    font-family: inherit;
    font-size: 14px;
    line-height: 20px;
    color: #000;
  }
  .search-pill .search-input::placeholder { color: #a3a3a3; }

  /* 카테고리 칩 */
  .cat-row {
    width: 342px;
    margin: 12px auto 0;
    display: flex;
    gap: 8px;
    overflow-x: auto;
    padding-bottom: 4px;
  }
  .cat-chip {
    flex-shrink: 0;
    padding: 6px 14px;
    border-radius: 9999px;
    border: 1px solid #e5e5e5;
    background: #fff;
    color: #525252;
    font-size: 13px;
    text-decoration: none;
    white-space: nowrap;
  }
  .cat-chip.active { background: #ff6f0f; color: #fff; border-color: #ff6f0f; }

  /* 인기 매물 스트립 (Redis 랭킹) */
  .popular {
    width: 342px;
    margin: 16px auto 0;
  }
  .popular-title {
    font-size: 15px;
    font-weight: 700;
    line-height: 22px;
    color: #000000;
    margin-bottom: 8px;
  }
  .popular-row {
    display: flex;
    gap: 8px;
  }
  .popular-card {
    flex: 1;
    min-width: 0;
    background: #fff7f0;
    border: 1px solid #ffd2b3;
    border-radius: 10px;
    padding: 8px;
    text-decoration: none;
    color: #000000;
  }
  .popular-card .p-title {
    font-size: 12px;
    font-weight: 500;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .popular-card .p-price {
    font-size: 12px;
    font-weight: 700;
    color: #ff6f0f;
    margin-top: 2px;
  }

  /* 그리드 */
  .grid {
    width: 342px;
    margin: 24px auto 0;
    display: grid;
    grid-template-columns: 163px 163px;
    column-gap: 16px;
    row-gap: 24px;
  }
  .card {
    width: 163px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    text-decoration: none;
  }
  .card-image {
    width: 163px;
    height: 163px;
    border-radius: 12px;
    background: #fafafa;
    overflow: hidden;
  }
  .card-image img {
    width: 163px;
    height: 163px;
    object-fit: cover;
    display: block;
  }
  .card-text {
    display: flex;
    flex-direction: column;
    gap: 4px;
    padding: 0 4px;
  }
  .card-title {
    font-size: 16px;
    font-weight: 500;
    line-height: 22px;
    color: #000000;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .card-price {
    font-size: 15px;
    font-weight: 700;
    line-height: 20px;
    color: #000000;
  }
  .card-desc {
    font-size: 14px;
    font-weight: 400;
    line-height: 20px;
    color: #737373;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }
  .card-status {
    font-size: 12px;
    color: #2e9e4f;
  }
  .empty {
    width: 342px;
    margin: 60px auto;
    text-align: center;
    color: #a3a3a3;
    font-size: 14px;
  }
  .empty-cta {
    display: inline-block;
    margin-top: 16px;
    padding: 10px 20px;
    background: #ff6f0f;
    color: #ffffff;
    font-size: 14px;
    font-weight: 700;
    border-radius: 9999px;
    text-decoration: none;
  }

  /* 판매하기 플로팅 버튼 */
  .fab {
    position: fixed;
    left: 50%;
    transform: translateX(127px); /* 프레임(390px) 우하단에 고정 */
    bottom: 32px;
    width: 56px;
    height: 56px;
    border-radius: 9999px;
    background: #ff6f0f;
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 12px rgba(0,0,0,0.25);
    text-decoration: none;
    z-index: 50;
  }
  .fab svg { width: 28px; height: 28px; }
</style>
</head>
<body>
  <div class="frame">

    <!-- 상단 검색바 (실제 검색: GET /product/?q=) -->
    <div class="topbar">
      <form class="search-pill" method="get" action="${pageContext.request.contextPath}/product/">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="7"></circle>
          <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
        <input class="search-input" type="text" name="q" value="<c:out value='${q}'/>" placeholder="찾는 물건을 검색하세요">
        <c:if test="${not empty selectedCategory}">
          <input type="hidden" name="category" value="${selectedCategory}">
        </c:if>
      </form>

      <a class="topbar-action" href="${pageContext.request.contextPath}/board/" title="동네생활">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
        </svg>
      </a>
      <a class="topbar-action" href="${pageContext.request.contextPath}/cart/" title="장바구니">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle>
          <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
        </svg>
      </a>

      <%-- 로그인 상태면 내 프로필, 아니면 로그인으로 --%>
      <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
          <a class="topbar-action" href="${pageContext.request.contextPath}/user/profile" title="내 프로필">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="8" r="4"></circle>
              <path d="M4 21v-1a6 6 0 0 1 6-6h4a6 6 0 0 1 6 6v1"></path>
            </svg>
          </a>
        </c:when>
        <c:otherwise>
          <a class="topbar-action" href="${pageContext.request.contextPath}/user/login" title="로그인">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
              <polyline points="10 17 15 12 10 7"></polyline>
              <line x1="15" y1="12" x2="3" y2="12"></line>
            </svg>
          </a>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 카테고리 칩 (선택 시 GET /product/?category=, 검색어 유지) -->
    <c:if test="${not empty categories}">
      <div class="cat-row">
        <a class="cat-chip ${empty selectedCategory ? 'active' : ''}"
           href="${pageContext.request.contextPath}/product/?${empty q ? '' : 'q='.concat(q)}">전체</a>
        <a class="cat-chip ${nearby ? 'active' : ''}" href="#" onclick="goNearby(); return false;">📍 내 주변</a>
        <c:forEach var="cat" items="${categories}">
          <a class="cat-chip ${selectedCategory == cat.id ? 'active' : ''}"
             href="${pageContext.request.contextPath}/product/?category=${cat.id}${empty q ? '' : '&q='.concat(q)}"><c:out value="${cat.name}"/></a>
        </c:forEach>
      </div>
    </c:if>

    <!-- 인기 매물 (Redis 조회수 랭킹 TOP 4) -->
    <c:if test="${not empty popular}">
      <div class="popular">
        <div class="popular-title">🔥 지금 인기</div>
        <div class="popular-row">
          <c:forEach var="p" items="${popular}">
            <a class="popular-card" href="${pageContext.request.contextPath}/product/detail?id=${p.id}">
              <div class="p-title"><c:out value="${p.title}"/></div>
              <div class="p-price"><fmt:formatNumber value="${p.price}" />원</div>
            </a>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <!-- 매물 그리드 (DB 연동) -->
    <c:if test="${empty products}">
      <div class="empty">
        아직 등록된 매물이 없어요.<br>첫 매물을 등록해 보세요!<br>
        <a class="empty-cta" href="${pageContext.request.contextPath}/product/form">+ 매물 등록하기</a>
      </div>
    </c:if>
    <div class="grid">
      <c:forEach var="p" items="${products}">
        <c:set var="thumb" value="${empty p.thumbnail ? 'https://picsum.photos/seed/'.concat(p.id).concat('/326/326') : (fn:startsWith(p.thumbnail, '/') ? pageContext.request.contextPath.concat(p.thumbnail) : p.thumbnail)}"/>
        <a class="card" href="${pageContext.request.contextPath}/product/detail?id=${p.id}">
          <div class="card-image">
            <img src="<c:out value='${thumb}'/>" alt="<c:out value="${p.title}"/>">
          </div>
          <div class="card-text">
            <div class="card-title"><c:out value="${p.title}"/></div>
            <div class="card-price"><fmt:formatNumber value="${p.price}" />원</div>
            <c:if test="${nearby && not empty p.distanceKm}">
              <div class="card-status" style="color:#ff6f0f;">📍 <fmt:formatNumber value="${p.distanceKm}" maxFractionDigits="1"/>km</div>
            </c:if>
            <div class="card-desc"><c:out value="${p.description}"/></div>
            <c:if test="${p.status ne '판매중'}">
              <div class="card-status"><c:out value="${p.status}"/></div>
            </c:if>
          </div>
        </a>
      </c:forEach>
    </div>

    <!-- 판매하기 (매물 등록 폼으로 이동, 비로그인 시 LoginCheckFilter가 로그인 페이지로 유도) -->
    <a class="fab" href="${pageContext.request.contextPath}/product/form" title="판매하기">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
        <line x1="12" y1="5" x2="12" y2="19"></line>
        <line x1="5" y1="12" x2="19" y2="12"></line>
      </svg>
    </a>

  </div>

  <script>
    // "내 주변": 브라우저 위치 → 거리순 정렬 조회
    function goNearby() {
      if (!navigator.geolocation) { alert('이 브라우저는 위치를 지원하지 않습니다.'); return; }
      navigator.geolocation.getCurrentPosition(function (pos) {
        var params = new URLSearchParams(location.search);
        params.set('lat', pos.coords.latitude);
        params.set('lng', pos.coords.longitude);
        location.href = '${pageContext.request.contextPath}/product/?' + params.toString();
      }, function () { alert('위치 권한이 필요합니다.'); });
    }
  </script>
</body>
</html>
