<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body { background: #f0f0f0; font-family: ui-sans-serif, system-ui, "Malgun Gothic", sans-serif; }
  .frame { width: 390px; min-height: 844px; background: #fff; position: relative; margin: 40px auto; padding-bottom: 100px; }
  .topbar { height: 56px; border-bottom: 1px solid #e5e5e5; display: flex; align-items: center; padding: 0 16px; }
  .icon-btn { width: 40px; height: 40px; display: inline-flex; align-items: center; justify-content: center; color: #000; text-decoration: none; }
  .icon-btn svg { width: 22px; height: 22px; }
  .topbar-title { flex: 1; text-align: center; font-size: 16px; font-weight: 600; margin-right: 40px; }
  .form { padding: 16px 24px; display: flex; flex-direction: column; gap: 16px; }
  .input { width: 100%; height: 44px; padding: 8px 16px; border-radius: 9999px; border: 1px solid #e5e5e5; font-size: 16px; outline: none; font-family: inherit; }
  .textarea { width: 100%; height: 360px; padding: 12px 16px; border-radius: 12px; border: 1px solid #e5e5e5; font-size: 16px; outline: none; resize: none; font-family: inherit; }
  .action-bar { position: absolute; bottom: 0; left: 0; width: 390px; height: 80px; background: #fff; border-top: 1px solid #e5e5e5; display: flex; align-items: center; padding: 0 24px; }
  .submit-btn { width: 342px; height: 48px; border-radius: 9999px; background: #ff6f0f; color: #fff; border: 0; font-size: 15px; font-weight: 600; cursor: pointer; }
</style>
</head>
<body>
  <div class="frame">
    <div class="topbar">
      <a class="icon-btn" href="${pageContext.request.contextPath}/board/" aria-label="뒤로">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
      </a>
      <div class="topbar-title">글쓰기</div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/board/write">
      <div class="form">
        <input class="input" type="text" name="title" placeholder="제목" required>
        <textarea class="textarea" name="content" placeholder="이웃과 나누고 싶은 이야기를 적어보세요"></textarea>
      </div>
      <div class="action-bar">
        <button class="submit-btn" type="submit">등록</button>
      </div>
    </form>
  </div>
</body>
</html>
