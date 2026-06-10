<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/design.css">
<style>
	.frame { padding-bottom: 110px; } /* 하단 등록 버튼(action-bar)과 겹침 방지 */
	.photo-upload { margin: 24px auto 0; }
	.form { margin: 24px auto 0; width: 342px; display: flex; flex-direction: column; gap: 16px; }
	/* 거래 위치 안내줄 */
	.loc-line { font-size: 13px; color: var(--mute); padding-left: 8px; line-height: 20px; }
	.textarea { height: 140px; }
</style>
</head>
<body>
	<div class="frame">

		<!-- 상단바 -->
		<div class="topbar">
			<button class="icon-btn" type="button" aria-label="뒤로"
				onclick="location.href='${pageContext.request.contextPath}/product/'">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
					stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
			</button>
			<div class="topbar-title offset-back">상품 등록</div>
		</div>

		<!-- 폼 (사진 파일 전송을 위해 multipart 인코딩) -->
		<form method="post"
			action="${pageContext.request.contextPath}/product/write"
			enctype="multipart/form-data">

			<!-- 사진 업로드: 실제 file input을 라벨로 감싸 클릭 시 파일 선택 (여러 장 가능) -->
			<label class="photo-upload" for="photos">
				<input type="file" id="photos" name="photos" accept="image/*" multiple hidden
					onchange="previewPhotos(this)">
				<span id="photoPlaceholder" class="photo-placeholder">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
						<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
						<circle cx="12" cy="13" r="4"></circle>
					</svg>
					<span class="photo-label">사진 추가</span>
					<span class="photo-hint">여러 장 선택 가능 · 첫 장이 대표 사진</span>
				</span>
				<span id="photoPreview" class="photo-preview-grid" hidden></span>
			</label>

			<div class="form">

				<%-- 검증 실패 메시지 (ProductController에서 전달, c:out으로 XSS 방지) --%>
				<c:if test="${not empty errorMessage}">
					<div class="error-msg">
						<c:out value="${errorMessage}" />
					</div>
				</c:if>

				<div class="field">
					<label class="label" for="title">제목</label>
					<div class="input-wrap">
						<input class="input" type="text" id="title" name="title"
							placeholder="상품명을 입력하세요" required>
					</div>
				</div>

				<div class="field">
					<label class="label" for="category">카테고리</label>
					<div class="input-wrap">
						<select class="select" id="category" name="category">
							<option value="">선택 안 함</option>
							<c:forEach var="cat" items="${categories}">
								<option value="${cat.id}"><c:out value="${cat.name}"/></option>
							</c:forEach>
						</select>
					</div>
				</div>

				<div class="field">
					<label class="label" for="price">가격</label>
					<div class="input-wrap">
						<input class="input has-suffix" type="number" id="price"
							name="price" inputmode="numeric" placeholder="0" min="1" required>
						<span class="input-suffix">원</span>
					</div>
				</div>

				<div class="field">
					<label class="label" for="description">설명</label>
					<textarea class="textarea" id="description" name="description"
						placeholder="상품 상태, 사용 기간, 거래 가능 지역 등을 자유롭게 적어주세요"></textarea>
				</div>

				<%-- 거래 위치: Geolocation으로 좌표 수집, 카카오맵 키가 있으면 동네명으로 변환 표시 --%>
				<input type="hidden" id="lat" name="lat">
				<input type="hidden" id="lng" name="lng">
				<div class="field">
					<span class="label">거래 위치</span>
					<span id="locLabel" class="loc-line">위치 확인 중…</span>
				</div>

			</div>

			<!-- 하단 등록 버튼 -->
			<div class="action-bar">
				<button class="btn btn-primary btn-block" type="submit">등록하기</button>
			</div>
		</form>

	</div>

	<script>
		// 파일 선택 시 여러 장 미리보기 (첫 장 = 대표 사진, ink 테두리)
		function previewPhotos(input) {
			var files = input.files;
			var grid = document.getElementById('photoPreview');
			var placeholder = document.getElementById('photoPlaceholder');
			grid.innerHTML = '';
			if (!files || files.length === 0) {
				grid.hidden = true;
				placeholder.hidden = false;
				return;
			}
			for (var i = 0; i < files.length; i++) {
				var img = document.createElement('img');
				img.src = URL.createObjectURL(files[i]);
				grid.appendChild(img);
			}
			grid.hidden = false;
			placeholder.hidden = true;
		}
	</script>

	<%-- 위치 수집 + 카카오맵 좌표→행정동 변환 (키 미설정 시 좌표만 저장) --%>
	<c:set var="kakaoKeyReady" value="${not empty kakaoJsKey && !fn:startsWith(kakaoJsKey, 'YOUR_')}"/>
	<c:if test="${kakaoKeyReady}">
		<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services&autoload=false"></script>
	</c:if>
	<script>
		(function () {
			var label = document.getElementById('locLabel');
			if (!navigator.geolocation) { label.textContent = '위치 미지원 브라우저'; return; }
			navigator.geolocation.getCurrentPosition(function (pos) {
				var lat = pos.coords.latitude, lng = pos.coords.longitude;
				document.getElementById('lat').value = lat;
				document.getElementById('lng').value = lng;
				<c:choose>
					<c:when test="${kakaoKeyReady}">
				kakao.maps.load(function () {
					new kakao.maps.services.Geocoder().coord2RegionCode(lng, lat, function (result, status) {
						if (status === kakao.maps.services.Status.OK && result.length) {
							label.textContent = '📍 ' + result[0].address_name; // 좌표 → 행정동 변환(카카오맵)
						} else {
							label.textContent = '📍 좌표 저장됨 (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ')';
						}
					});
				});
					</c:when>
					<c:otherwise>
				label.textContent = '📍 좌표 저장됨 (' + lat.toFixed(4) + ', ' + lng.toFixed(4) + ') — 카카오맵 키 설정 시 동네명 표시';
					</c:otherwise>
				</c:choose>
			}, function () { label.textContent = '위치 권한이 거부되어 위치 없이 등록됩니다'; });
		})();
	</script>
</body>
</html>
