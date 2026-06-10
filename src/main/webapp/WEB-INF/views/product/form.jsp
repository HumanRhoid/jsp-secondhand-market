<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<style>
/*
    ───────────────────────────────────────────────
    FIGMA-READY — 390 × 844 모바일 프레임
    - 모든 치수 px 고정
    - position: sticky 없음, 미디어 쿼리 없음
    ───────────────────────────────────────────────
  */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

html, body {
	background: #f0f0f0;
	font-family: ui-sans-serif, system-ui, -apple-system,
		"Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
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
	padding: 0 16px;
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

.topbar-title {
	position: absolute;
	left: 0;
	right: 0;
	text-align: center;
	font-size: 16px;
	font-weight: 500;
	line-height: 24px;
	color: #000000;
	pointer-events: none;
}

/* 사진 업로드 영역 */
.photo-upload {
	position: absolute;
	top: 80px;
	left: 24px;
	width: 342px;
	height: 200px;
	border-radius: 12px;
	background: #fafafa;
	border: 1px dashed #d4d4d4;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	gap: 12px;
	cursor: pointer;
}

.photo-upload svg {
	width: 32px;
	height: 32px;
	color: #737373;
}

.photo-upload .photo-label {
	font-size: 14px;
	font-weight: 500;
	line-height: 20px;
	color: #525252;
}

.photo-upload .photo-hint {
	font-size: 12px;
	font-weight: 400;
	line-height: 16px;
	color: #a3a3a3;
	margin-top: -4px;
}

.photo-upload .photo-placeholder {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	gap: 12px;
	width: 100%;
	text-align: center;
}

.photo-upload .photo-preview-grid {
	display: flex;
	flex-wrap: wrap;
	gap: 6px;
	padding: 8px;
	width: 100%;
	height: 100%;
	overflow-y: auto;
	align-content: flex-start;
}

.photo-upload .photo-preview-grid img {
	width: 60px;
	height: 60px;
	object-fit: cover;
	border-radius: 8px;
}

.photo-upload .photo-preview-grid img:first-child {
	outline: 2px solid #ff6f0f; /* 대표 사진 표시 */
	outline-offset: -2px;
}

/* 폼 */
.form {
	position: absolute;
	top: 304px;
	left: 24px;
	width: 342px;
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.field {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.label {
	font-size: 14px;
	font-weight: 500;
	line-height: 20px;
	color: #000000;
	padding-left: 8px;
}

/* 단일 행 입력 (제목, 가격) */
.input-wrap {
	position: relative;
}

.input {
	width: 100%;
	height: 44px;
	padding: 8px 16px;
	border-radius: 9999px;
	border: 1px solid #e5e5e5;
	background: #ffffff;
	color: #000000;
	font-family: inherit;
	font-size: 16px;
	font-weight: 400;
	line-height: 24px;
	outline: none;
}

.input::placeholder {
	color: #a3a3a3;
}

.input.has-suffix {
	padding-right: 40px;
}

.input-suffix {
	position: absolute;
	top: 0;
	right: 16px;
	height: 44px;
	display: flex;
	align-items: center;
	font-size: 16px;
	font-weight: 500;
	color: #525252;
	pointer-events: none;
}

/* 멀티라인 textarea (설명) — pill 아니라 rounded.lg */
.textarea {
	width: 100%;
	height: 140px;
	padding: 12px 16px;
	border-radius: 12px;
	border: 1px solid #e5e5e5;
	background: #ffffff;
	color: #000000;
	font-family: inherit;
	font-size: 16px;
	font-weight: 400;
	line-height: 24px;
	outline: none;
	resize: none;
}

.textarea::placeholder {
	color: #a3a3a3;
}

/* 검증 실패 메시지 */
.error-msg {
	color: #e03131;
	font-size: 14px;
	line-height: 20px;
	padding-left: 8px;
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
	padding: 0 24px;
}

.submit-btn {
	width: 342px;
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
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
					stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
			</button>
			<div class="topbar-title">상품 등록</div>
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

			</div>

			<!-- 하단 등록 버튼 -->
			<div class="action-bar">
				<button class="submit-btn" type="submit">등록하기</button>
			</div>
		</form>

	</div>

	<script>
		// 파일 선택 시 여러 장 미리보기 (첫 장 = 대표 사진, 주황 테두리)
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
</body>
</html>
