<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
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
    padding: 0 24px;
  }
  .search-pill {
    width: 342px;
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
  .search-pill .placeholder {
    font-size: 14px;
    line-height: 20px;
    color: #a3a3a3;
  }

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
</style>
</head>
<body>
  <div class="frame">

    <!-- 상단 검색바 -->
    <div class="topbar">
      <div class="search-pill">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="7"></circle>
          <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
        <span class="placeholder">찾는 물건을 검색하세요</span>
      </div>
    </div>

    <!-- 인기 매물 (Redis 조회수 랭킹 TOP 4) -->
    <c:if test="${not empty popular}">
      <div class="popular">
        <div class="popular-title">🔥 지금 인기</div>
        <div class="popular-row">
          <c:forEach var="p" items="${popular}">
            <a class="popular-card" href="${pageContext.request.contextPath}/product/detail?id=${p.id}">
              <div class="p-title">${p.title}</div>
              <div class="p-price"><fmt:formatNumber value="${p.price}" />원</div>
            </a>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <!-- 매물 그리드 (DB 연동) -->
    <c:if test="${empty products}">
      <div class="empty">아직 등록된 매물이 없어요.<br>첫 매물을 등록해 보세요!</div>
    </c:if>
    <div class="grid">
      <c:forEach var="p" items="${products}">
        <a class="card" href="${pageContext.request.contextPath}/product/detail?id=${p.id}">
          <div class="card-image">
            <img src="${empty p.thumbnail ? 'https://picsum.photos/seed/'.concat(p.id).concat('/326/326') : p.thumbnail}" alt="${p.title}">
          </div>
          <div class="card-text">
            <div class="card-title">${p.title}</div>
            <div class="card-price"><fmt:formatNumber value="${p.price}" />원</div>
            <div class="card-desc">${p.description}</div>
            <c:if test="${p.status ne '판매중'}">
              <div class="card-status">${p.status}</div>
            </c:if>
          </div>
        </a>
      </c:forEach>
    </div>

  </div>
</body>
</html>
