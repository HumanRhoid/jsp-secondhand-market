<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>둘러보기</title>
<style>
  /*
    ───────────────────────────────────────────────
    FIGMA-READY — 390 × 1140 모바일 프레임
    - 모든 치수 px 고정 (no vh/vw/%/aspect-ratio)
    - position: sticky 없음
    - 미디어 쿼리 없음
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
    height: 1140px;
    background: #ffffff;
    position: relative;
    overflow: hidden;
    margin: 40px auto;
  }

  /* 상단 검색바 */
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

  /* 그리드 */
  .grid {
    position: absolute;
    top: 80px;
    left: 24px;
    width: 342px;
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
    </div>

  </div>
</body>
</html>
