<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>프로필 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/design.css">
<style>
  .frame { padding-bottom: 100px; }
  .avatar-section { display: flex; justify-content: center; padding: 28px 0 8px; }
  .form { padding: 16px 24px; display: flex; flex-direction: column; gap: 16px; }
</style>
</head>
<body>
  <div class="frame">

    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/user/profile" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
      </a>
      <div class="topbar-title offset-back">프로필 수정</div>
    </div>

    <c:set var="avatar" value="${empty user.profileImage ? 'https://i.pravatar.cc/192?u='.concat(user.id) : (fn:startsWith(user.profileImage, '/') ? pageContext.request.contextPath.concat(user.profileImage) : user.profileImage)}"/>
    <div class="avatar-section">
      <img class="avatar" src="<c:out value='${avatar}'/>" alt="프로필 사진">
    </div>

    <form method="post" action="${pageContext.request.contextPath}/user/update">
      <div class="form">

        <div class="field">
          <label class="label" for="email">이메일</label>
          <input class="input" type="email" id="email" value="<c:out value='${user.email}'/>" disabled>
          <span class="hint">이메일은 변경할 수 없어요</span>
        </div>

        <div class="field">
          <label class="label" for="nickname">닉네임</label>
          <input class="input" type="text" id="nickname" name="nickname"
                 value="<c:out value='${user.nickname}'/>" required>
        </div>

        <div class="field">
          <label class="label" for="region">지역</label>
          <select class="select" id="region" name="region">
            <c:forEach var="r" items="서울,부산,인천,대구,광주,대전,울산,세종,경기,강원,충북,충남,전북,전남,경북,경남,제주">
              <option value="${r}" ${user.region eq r ? 'selected' : ''}>${r}</option>
            </c:forEach>
          </select>
        </div>

        <div class="field">
          <label class="label" for="profileImage">프로필 이미지 URL</label>
          <input class="input" type="text" id="profileImage" name="profileImage"
                 value="<c:out value='${user.profileImage}'/>" placeholder="https://...">
          <span class="hint">이미지 주소를 입력하면 프로필 사진이 바뀝니다</span>
        </div>

      </div>

      <div class="action-bar">
        <button class="btn btn-primary btn-block" type="submit">저장</button>
      </div>
    </form>

  </div>
</body>
</html>
