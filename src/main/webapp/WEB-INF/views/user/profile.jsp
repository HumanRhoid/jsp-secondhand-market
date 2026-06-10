<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 프로필</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body {
    background: #f0f0f0;
    font-family: ui-sans-serif, system-ui, -apple-system, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
    -webkit-font-smoothing: antialiased;
  }
  .frame {
    width: 390px;
    min-height: 844px;
    background: #ffffff;
    position: relative;
    margin: 40px auto;
    padding-bottom: 40px;
  }
  .topbar {
    width: 390px;
    height: 56px;
    border-bottom: 1px solid #e5e5e5;
    display: flex;
    align-items: center;
    padding: 0 16px;
  }
  .icon-btn {
    width: 40px; height: 40px;
    display: inline-flex; align-items: center; justify-content: center;
    background: transparent; border: 0; border-radius: 9999px;
    color: #000; cursor: pointer; text-decoration: none;
  }
  .icon-btn svg { width: 22px; height: 22px; }
  .topbar-title {
    flex: 1; text-align: center; font-size: 16px; font-weight: 600;
    margin-right: 40px; /* 좌측 뒤로 버튼 폭 보정 */
  }

  .profile-head {
    display: flex; flex-direction: column; align-items: center;
    gap: 12px; padding: 32px 24px 24px;
  }
  .avatar {
    width: 96px; height: 96px; border-radius: 9999px;
    object-fit: cover; background: #fafafa; border: 1px solid #e5e5e5;
  }
  .nickname { font-size: 20px; font-weight: 700; }
  .manner {
    font-size: 13px; color: #ff6f0f; font-weight: 600;
    background: #fff7f0; padding: 4px 12px; border-radius: 9999px;
  }

  .info { padding: 8px 24px; display: flex; flex-direction: column; gap: 4px; }
  .info-row {
    display: flex; justify-content: space-between;
    padding: 14px 4px; border-bottom: 1px solid #f0f0f0;
  }
  .info-label { color: #737373; font-size: 14px; }
  .info-value { color: #000; font-size: 14px; font-weight: 500; }

  .actions { padding: 24px; display: flex; flex-direction: column; gap: 12px; }
  .btn {
    height: 48px; border-radius: 9999px; border: 0;
    font-size: 15px; font-weight: 600; cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    text-decoration: none;
  }
  .btn-primary { background: #ff6f0f; color: #fff; }
  .btn-line { background: #fff; color: #000; border: 1px solid #e5e5e5; }
  .btn-danger { background: #fff; color: #e03131; border: 1px solid #ffd0d0; }
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
      <div class="topbar-title">내 프로필</div>
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
      <a class="btn btn-line" href="${pageContext.request.contextPath}/product/">매물 둘러보기</a>
      <a class="btn btn-danger" href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
    </div>

  </div>
</body>
</html>
