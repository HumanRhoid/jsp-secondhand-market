<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 수정</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body {
    background: #f0f0f0;
    font-family: ui-sans-serif, system-ui, -apple-system, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
    -webkit-font-smoothing: antialiased;
  }
  .frame {
    width: 390px; min-height: 844px; background: #fff;
    position: relative; margin: 40px auto; padding-bottom: 100px;
  }
  .topbar {
    width: 390px; height: 56px; border-bottom: 1px solid #e5e5e5;
    display: flex; align-items: center; padding: 0 16px;
  }
  .icon-btn {
    width: 40px; height: 40px;
    display: inline-flex; align-items: center; justify-content: center;
    background: transparent; border: 0; color: #000; cursor: pointer; text-decoration: none;
  }
  .icon-btn svg { width: 22px; height: 22px; }
  .topbar-title { flex: 1; text-align: center; font-size: 16px; font-weight: 600; margin-right: 40px; }

  .photo-upload {
    margin: 24px auto 0; width: 342px; height: 200px;
    border-radius: 12px; background: #fafafa; border: 1px dashed #d4d4d4;
    position: relative; cursor: pointer; overflow: hidden; display: block;
  }
  .photo-placeholder {
    position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    gap: 12px; width: 100%; text-align: center; color: #737373;
  }
  .photo-placeholder svg { width: 32px; height: 32px; }
  .photo-placeholder .photo-label { font-size: 14px; font-weight: 500; color: #525252; }
  .photo-placeholder .photo-hint { font-size: 12px; color: #a3a3a3; margin-top: -4px; }
  .photo-preview-grid {
    display: none; flex-wrap: wrap; gap: 6px; padding: 8px;
    width: 100%; height: 100%; overflow-y: auto; align-content: flex-start;
  }
  .photo-preview-grid.show { display: flex; }
  .photo-preview-grid img { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; }
  .photo-preview-grid img:first-child { outline: 2px solid #ff6f0f; outline-offset: -2px; }

  .form { margin: 24px auto 0; width: 342px; display: flex; flex-direction: column; gap: 16px; }
  .field { display: flex; flex-direction: column; gap: 8px; }
  .label { font-size: 14px; font-weight: 500; padding-left: 8px; }
  .input-wrap { position: relative; }
  .input, .select {
    width: 100%; height: 44px; padding: 8px 16px; border-radius: 9999px;
    border: 1px solid #e5e5e5; background: #fff; font-family: inherit; font-size: 16px; outline: none;
  }
  .input.has-suffix { padding-right: 40px; }
  .input-suffix {
    position: absolute; top: 0; right: 16px; height: 44px;
    display: flex; align-items: center; font-size: 16px; font-weight: 500; color: #525252; pointer-events: none;
  }
  .textarea {
    width: 100%; height: 140px; padding: 12px 16px; border-radius: 12px;
    border: 1px solid #e5e5e5; background: #fff; font-family: inherit; font-size: 16px; outline: none; resize: none;
  }
  .error-msg { color: #e03131; font-size: 14px; padding-left: 8px; }

  .action-bar {
    position: absolute; bottom: 0; left: 0; width: 390px; height: 80px;
    background: #fff; border-top: 1px solid #e5e5e5; display: flex; align-items: center; padding: 0 24px;
  }
  .submit-btn {
    width: 342px; height: 48px; border-radius: 9999px; background: #ff6f0f;
    color: #fff; border: 0; font-size: 15px; font-weight: 600; cursor: pointer;
  }
</style>
</head>
<body>
  <div class="frame">

    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/product/detail?id=${product.id}" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
      </a>
      <div class="topbar-title">상품 수정</div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/product/update" enctype="multipart/form-data">
      <input type="hidden" name="id" value="${product.id}">
      <input type="hidden" name="currentThumbnail" value="<c:out value='${product.thumbnail}'/>">

      <%-- 사진: 새로 고르면 대표 사진 교체, 안 고르면 기존 유지 --%>
      <c:set var="thumb" value="${empty product.thumbnail ? '' : (fn:startsWith(product.thumbnail, '/') ? pageContext.request.contextPath.concat(product.thumbnail) : product.thumbnail)}"/>
      <label class="photo-upload" for="photos">
        <input type="file" id="photos" name="photos" accept="image/*" multiple hidden onchange="previewPhotos(this)">
        <span id="photoPlaceholder" class="photo-placeholder">
          <c:choose>
            <c:when test="${not empty thumb}">
              <img src="<c:out value='${thumb}'/>" alt="현재 대표 사진" style="width:120px;height:120px;object-fit:cover;border-radius:10px;">
              <span class="photo-hint">탭하면 사진을 새로 올려 교체합니다</span>
            </c:when>
            <c:otherwise>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                <circle cx="12" cy="13" r="4"></circle>
              </svg>
              <span class="photo-label">사진 추가</span>
              <span class="photo-hint">여러 장 선택 가능 · 첫 장이 대표 사진</span>
            </c:otherwise>
          </c:choose>
        </span>
        <span id="photoPreview" class="photo-preview-grid"></span>
      </label>

      <div class="form">

        <c:if test="${not empty errorMessage}">
          <div class="error-msg"><c:out value="${errorMessage}"/></div>
        </c:if>

        <div class="field">
          <label class="label" for="title">제목</label>
          <div class="input-wrap">
            <input class="input" type="text" id="title" name="title"
                   value="<c:out value='${product.title}'/>" required>
          </div>
        </div>

        <div class="field">
          <label class="label" for="price">가격</label>
          <div class="input-wrap">
            <input class="input has-suffix" type="number" id="price" name="price"
                   inputmode="numeric" value="${product.price}" min="1" required>
            <span class="input-suffix">원</span>
          </div>
        </div>

        <div class="field">
          <label class="label" for="status">상태</label>
          <select class="select" id="status" name="status">
            <c:forEach var="s" items="판매중,예약중,판매완료">
              <option value="${s}" ${product.status eq s ? 'selected' : ''}>${s}</option>
            </c:forEach>
          </select>
        </div>

        <div class="field">
          <label class="label" for="description">설명</label>
          <textarea class="textarea" id="description" name="description"><c:out value="${product.description}"/></textarea>
        </div>

      </div>

      <div class="action-bar">
        <button class="submit-btn" type="submit">수정하기</button>
      </div>
    </form>

  </div>

  <script>
    function previewPhotos(input) {
      var files = input.files;
      var grid = document.getElementById('photoPreview');
      var placeholder = document.getElementById('photoPlaceholder');
      grid.innerHTML = '';
      if (!files || files.length === 0) {
        grid.classList.remove('show');
        placeholder.style.display = '';
        return;
      }
      for (var i = 0; i < files.length; i++) {
        var img = document.createElement('img');
        img.src = URL.createObjectURL(files[i]);
        grid.appendChild(img);
      }
      grid.classList.add('show');
      placeholder.style.display = 'none';
    }
  </script>
</body>
</html>
