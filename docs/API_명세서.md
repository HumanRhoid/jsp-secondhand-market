# 📡 API / 라우트 명세서 — 중고거래 플랫폼

> JSP/Servlet MVC2. 컨텍스트 경로: `/secondhand`. 모든 경로는 컨텍스트 경로 하위.
> 인증: 세션(`loginUser`). 🔒 표시는 `LoginCheckFilter` 보호(미로그인 시 `/user/login`으로 redirect).
> 에러: 폼 복귀형(검증·로그인 실패)은 해당 화면에 메시지, 그 외는 `ExceptionHandlingFilter`가 에러 페이지로 변환.

## 1. 회원 (`UserController` — `/user/*`)

| 메서드 | 경로 | 인증 | 파라미터 | 동작 | 응답 |
|---|---|---|---|---|---|
| GET | `/user/login` | | | 로그인 폼 | login.jsp |
| GET | `/user/join` | | | 가입 폼 | join.jsp |
| GET | `/user/logout` | | | 세션 무효화 | → `/product/` |
| GET | `/user/profile` | 🔒 | | 내 프로필(UserDTO 전달) | profile.jsp |
| GET | `/user/edit` | 🔒 | | 프로필 수정 폼(prefill) | profileEdit.jsp |
| POST | `/user/join` | | nickname, email, password, region | 가입(BCrypt). 중복 이메일 U001 | 성공 → `/user/login` / 실패 → join.jsp |
| POST | `/user/login` | | email, password | 로그인, 세션 적재. 실패 A001 | 성공 → `/product/` / 실패 → login.jsp |
| POST | `/user/update` | 🔒 | nickname, region, profileImage | 프로필 수정, 세션 갱신 | → `/user/profile` |

## 2. 매물 (`ProductController` — `/product/*`)

| 메서드 | 경로 | 인증 | 파라미터 | 동작 | 응답 |
|---|---|---|---|---|---|
| GET | `/product/` `/product/list` | | | 목록 + Redis 인기 TOP4 | main.jsp |
| GET | `/product/detail` | | id | 상세(조회수↑, 랭킹↑, 사진 갤러리) | detail.jsp |
| GET | `/product/form` | 🔒 | | 등록 폼 | form.jsp |
| GET | `/product/edit` | 🔒 | id | 수정 폼(소유자 검증, prefill) | edit.jsp |
| POST | `/product/write` | 🔒 | title, price, description, photos[] | 등록(첫 사진=대표, 전체=product_images). 검증 G001 | 성공 → `/product/` / 실패 → form.jsp |
| POST | `/product/update` | 🔒 | id, title, price, description, status, photos[], currentThumbnail | 수정(소유자 P002). 새 사진 있으면 대표 교체 | → `/product/detail?id=` |
| POST | `/product/delete` | 🔒 | id | 소프트 삭제(소유자 P002) + 랭킹 제거 | → `/product/` |

## 3. 이미지 (`ImageController` — `/images/*`)

| 메서드 | 경로 | 인증 | 동작 |
|---|---|---|---|
| GET | `/images/{파일명}` | | 업로드 폴더(`upload.dir`)의 사진 서빙. `../` 경로 조작 차단 |

## 4. 홈 (`HomeController` — `/`)

| 메서드 | 경로 | 동작 | 응답 |
|---|---|---|---|
| GET | `/` | 랜딩 | index.jsp (가입/로그인/둘러보기) |

## 에러 코드

| 코드 | 상태 | 의미 |
|---|---|---|
| G001 | 400 | 입력값 검증 실패 |
| G002 | 500 | DB 오류 |
| U001 | 409 | 중복 이메일 |
| U002 | 404 | 존재하지 않는 사용자 |
| A001 | 401 | 로그인 실패 |
| P001 | 404 | 존재하지 않는 상품 |
| P002 | 403 | 소유자 아님(수정/삭제 차단) |

## 파일 업로드 규약

- 인코딩: `multipart/form-data`, 파트명 `photos`(다중)
- 제한: 파일당 10MB, 요청 50MB (`@MultipartConfig`)
- 저장: `upload.dir`(기본 `C:/Users/ssant/upload`)에 UUID 파일명, DB엔 `/images/{파일명}` 경로만
