<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<<<<<<< HEAD
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
=======
>>>>>>> origin/main
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>둘러보기</title>
<style>
  /*
    ───────────────────────────────────────────────
<<<<<<< HEAD
    FIGMA-READY — 390px 모바일 프레임 (동적 데이터 연동판)
    - 카드 그리드는 DB(products) 데이터로 렌더링
    - 인기 매물 스트립은 Redis 랭킹 TOP 4 (Redis 미동작 시 자동 미표시)
=======
    FIGMA-READY — 390 × 1140 모바일 프레임
    - 모든 치수 px 고정 (no vh/vw/%/aspect-ratio)
    - position: sticky 없음
    - 미디어 쿼리 없음
>>>>>>> origin/main
    ───────────────────────────────────────────────
  */

  * { margin: 0; padding: 0; box-sizing: border-box; }

  html, body {
    background: #f0f0f0;
    font-family: ui-sans-serif, system-ui, -apple-system, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
    -webkit-font-smoothing: antialiased;
  }

<<<<<<< HEAD
  /* 모바일 프레임 (내용 길이에 맞춰 늘어나도록 변경) */
  .frame {
    width: 390px;
    min-height: 1140px;
    background: #ffffff;
    position: relative;
    margin: 40px auto;
    padding-bottom: 40px;
=======
  /* 모바일 프레임 */
  .frame {
    width: 390px;
    height: 1140px;
    background: #ffffff;
    position: relative;
    overflow: hidden;
    margin: 40px auto;
>>>>>>> origin/main
  }

  /* 상단 검색바 */
  .topbar {
<<<<<<< HEAD
=======
    position: absolute;
    top: 0;
    left: 0;
>>>>>>> origin/main
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

<<<<<<< HEAD
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
=======
  /* 그리드 */
  .grid {
    position: absolute;
    top: 80px;
    left: 24px;
    width: 342px;
>>>>>>> origin/main
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
<<<<<<< HEAD
    text-decoration: none;
=======
>>>>>>> origin/main
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
<<<<<<< HEAD
  .card-price {
    font-size: 15px;
    font-weight: 700;
    line-height: 20px;
    color: #000000;
  }
=======
>>>>>>> origin/main
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
<<<<<<< HEAD
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
=======
>>>>>>> origin/main
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

<<<<<<< HEAD
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
=======
    <!-- 매물 그리드 -->
    <div class="grid">
      <div class="card">
        <div class="card-image"><img src="https://picsum.photos/seed/freitag/326/326" alt=""></div>
        <div class="card-text">
          <div class="card-title">프라이탁 메신저백</div>
          <div class="card-desc">F41 해리스 모델, 짙은 카키와 머스타드 패치 조합. 사용감 적습니다.</div>
        </div>
      </div>

      <div class="card">
        <div class="card-image"><img src="https://picsum.photos/seed/ipad/326/326" alt=""></div>
        <div class="card-text">
          <div class="card-title">아이패드 프로 11인치</div>
          <div class="card-desc">스페이스 그레이 256GB Wi-Fi. 풀박스 + 애플펜슬 2세대.</div>
        </div>
      </div>

      <div class="card">
        <div class="card-image"><img src="https://picsum.photos/seed/levis/326/326" alt=""></div>
        <div class="card-text">
          <div class="card-title">리바이스 501 청바지</div>
          <div class="card-desc">90년대 빅이 셀비지 데님. 32x32, 자연스러운 페이드.</div>
        </div>
      </div>

      <div class="card">
        <div class="card-image"><img src="https://picsum.photos/seed/airpods/326/326" alt=""></div>
        <div class="card-text">
          <div class="card-title">에어팟 프로 2세대</div>
          <div class="card-desc">USB-C 모델, 작년 12월 구매. 배터리 상태 매우 좋습니다.</div>
        </div>
      </div>

      <div class="card">
        <div class="card-image"><img src="https://picsum.photos/seed/chair/326/326" alt=""></div>
        <div class="card-text">
          <div class="card-title">무지 원목 다이닝 체어</div>
          <div class="card-desc">참나무 원목, 2개 세트. 직접 픽업만 가능합니다.</div>
        </div>
      </div>

      <div class="card">
        <div class="card-image"><img src="https://picsum.photos/seed/switch/326/326" alt=""></div>
        <div class="card-text">
          <div class="card-title">닌텐도 스위치 OLED</div>
          <div class="card-desc">화이트, 젤다 왕국의 눈물 칩 포함. 액정 필름 부착 상태.</div>
        </div>
      </div>

      <div class="card">
        <div class="card-image"><img src="https://picsum.photos/seed/lecreuset/326/326" alt=""></div>
        <div class="card-text">
          <div class="card-title">르크루제 무쇠 냄비</div>
          <div class="card-desc">24cm 라운드, 체리레드. 결혼 선물로 받았는데 거의 안 썼어요.</div>
        </div>
      </div>

      <div class="card">
        <div class="card-image"><img src="https://picsum.photos/seed/helinox/326/326" alt=""></div>
        <div class="card-text">
          <div class="card-title">헬리녹스 체어원</div>
          <div class="card-desc">블랙 컬러, 정품 보관 파우치 포함. 컨디션 좋습니다.</div>
        </div>
      </div>
>>>>>>> origin/main
    </div>

  </div>
</body>
</html>
