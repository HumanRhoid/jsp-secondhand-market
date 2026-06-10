<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>환영합니다</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/design.css">
<style>
  .frame {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .stack { width: 342px; display: flex; flex-direction: column; align-items: stretch; }
  .stack .headline { text-align: center; margin-bottom: 8px; }
  .stack .sub { text-align: center; margin-bottom: 32px; }
  .btn-group { display: flex; flex-direction: column; gap: 12px; }
</style>
</head>
<body>
  <div class="frame">
    <div class="stack">
      <h1 class="headline">환영합니다</h1>
      <p class="sub">계속하려면 아래에서 선택하세요</p>

      <div class="btn-group">
        <button type="button" class="btn btn-primary" onclick="location.href='<%= request.getContextPath() %>/user/join'">회원가입</button>
        <button type="button" class="btn btn-secondary" onclick="location.href='<%= request.getContextPath() %>/user/login'">로그인</button>
        <button type="button" class="btn btn-secondary" onclick="location.href='<%= request.getContextPath() %>/product/'">로그인 없이 둘러보기</button>
      </div>
    </div>
  </div>
</body>
</html>
