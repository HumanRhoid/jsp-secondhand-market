<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 프로필</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/design.css">
<style>
  .frame { padding-bottom: 40px; }
  .profile-head {
    display: flex; flex-direction: column; align-items: center;
    gap: 12px; padding: 32px 24px 24px;
  }
  .nickname { font-family: var(--font-display); font-size: 20px; font-weight: 600; }
  .manner {
    font-size: 13px; color: var(--charcoal); font-weight: 500;
    background: var(--surface-soft); border: 1px solid var(--hairline);
    padding: 4px 12px; border-radius: var(--rounded-full);
  }
  .info { padding: 8px 24px; display: flex; flex-direction: column; gap: 4px; }
  .actions { padding: 24px; display: flex; flex-direction: column; gap: 12px; }
</style>
</head>
<body>
  <div class="frame">

    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/product/" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"></polyline>
        </svg>
      </a>
      <div class="topbar-title offset-back">내 프로필</div>
    </div>

    <div class="profile-head">
      <c:set var="avatar" value="${empty user.profileImage ? 'https://i.pravatar.cc/192?u='.concat(user.id) : (fn:startsWith(user.profileImage, '/') ? pageContext.request.contextPath.concat(user.profileImage) : user.profileImage)}"/>
      <img class="avatar" src="<c:out value='${avatar}'/>" alt="프로필 사진">
      <div class="nickname"><c:out value="${user.nickname}"/></div>
      <div class="manner">매너온도 <fmt:formatNumber value="${user.mannerTemp}" maxFractionDigits="1"/>℃</div>
    </div>

    <div class="info">
      <div class="info-row">
        <span class="info-label">이메일</span>
        <span class="info-value"><c:out value="${user.email}"/></span>
      </div>
      <div class="info-row">
        <span class="info-label">지역</span>
        <span class="info-value"><c:out value="${user.region}"/></span>
      </div>
    </div>

    <div class="actions">
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/user/edit">프로필 수정</a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/product/">매물 둘러보기</a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
      <form method="post" action="${pageContext.request.contextPath}/user/delete"
            onsubmit="return confirm('정말 탈퇴하시겠습니까? 등록한 매물도 함께 삭제됩니다.');">
        <button type="submit" class="btn btn-quiet btn-block">회원 탈퇴</button>
      </form>
    </div>

  </div>
</body>
</html>
