# 프로젝트 현재 상황 정리

> 작성일: 2026-06-10 · 기준 브랜치: `main` (origin/main과 동기화됨)

JSP/Servlet 기반 중고거래 웹앱. Spring Boot 세션에서 배운 패턴(계층형 아키텍처, 전역 예외 처리, BCrypt, 검증, 로깅)을 순수 Servlet 환경에 적용하는 리팩토링을 완료하고, 런타임 검증과 코드 리뷰까지 마친 상태.

---

## 1. 실행 방법 (현재 환경)

| 항목 | 값 |
|---|---|
| 접속 주소 | **http://localhost:8080/secondhand/** (Maven 변환 후 `/jsp_web_project` → `/secondhand`로 변경됨) |
| 실행 | Eclipse Servers 뷰에서 `Tomcat v10.1 Server at localhost` 시작 |
| DB | Docker 컨테이너 `market-pg` (PostgreSQL 16, 포트 5432, DB명 `SecondheadServiceDB`) — users/products 테이블 생성 완료 |
| Redis | 미기동 (선택). 없으면 인기 랭킹만 비활성화되고 나머지 정상. 띄우려면: `docker run -d --name market-redis -p 6379:6379 redis:7` |

재부팅 후에는: Docker Desktop 실행 → `docker start market-pg` → Eclipse에서 Tomcat 시작.

DB 접속 정보는 `src/main/resources/db.properties`에 있음 (git 미추적, `db.properties.example` 참고).
> ⚠️ 이 PC(로컬)에는 Docker가 설치돼 있지 않음. **PostgreSQL은 네이티브로 직접 설치·구동**하며 `SecondheadServiceDB`와 테이블이 로컬에 이미 존재함. PROJECT_STATUS의 "Docker" 설명은 문서 작성 PC(팀원) 기준이니 로컬에선 네이티브 PostgreSQL을 켜면 됨.
> 사진 업로드 파일은 `upload.dir`(기본 `C:/Users/ssant/upload`) 외부 폴더에 저장됨(7번 참고).

---

## 2. 완료된 리팩토링 (커밋 10개)

| 커밋 | 내용 |
|---|---|
| `153b1f4` | 이전 merge에서 코드에 박힌 채 커밋됐던 **git 충돌 마커 17개 파일 해결** (컴파일 불가 상태였음) |
| `91cc31f` | DB/Redis 접속 정보를 `db.properties`로 **외부화**(AppConfig), **SLF4J+Logback 로깅** 도입 |
| `813cd78` | **전역 예외 체계**: BaseErrorCode + 도메인별 ErrorCode enum(G/U/A/P) + CustomException + ExceptionHandlingFilter. web.xml로 필터 순서 보장(Encoding→Logging→Exception→LoginCheck), 세션 30분, 404/500 에러 페이지 |
| `9d5e944` | **MVC2 재편**: UserService/ProductService 신설(검증·중복체크·소유자검증 이관), JSP 전부 `WEB-INF/views/`로 이동(직접 URL 접근 차단), HomeController(GET /)와 페이지 라우트 추가 |
| `975a074` | **보안**: BCrypt 해시, ValidationUtil(이메일/비밀번호 8~20자), 모든 사용자 입력 출력에 `<c:out>`(XSS), 세션에 민감정보 없는 SessionUser만 저장 |
| `32a6ce4` `ea3ed0e` `ae7e237` | 정리: 미사용 gson 의존성·에러코드(G500, A002)·메서드(ping, findByUserId) 제거 |
| `2c7b94f` | **로깅 NOP 버그 수정**: jedis의 전이 의존성 slf4j-api 1.7이 logback 1.5와 충돌해 로그가 전혀 안 나오던 문제 → slf4j-api 2.0.17 명시 (런타임 검증 중 발견) |
| `cac1331` | 코드 리뷰 지적 수정: **form.jsp 백엔드 연동**(이제 브라우저로 상품 등록 가능), 세션 null 가드(SessionUser.current), 에러 페이지 CSS 공통화, ProductService.update DTO 시그니처 |

### 에러 코드 표

| 코드 | 상태 | 의미 |
|---|---|---|
| G001 | 400 | 입력값 검증 실패 |
| G002 | 500 | DB 오류 |
| U001 | 409 | 중복 이메일 |
| U002 | 404 | 존재하지 않는 사용자 |
| A001 | 401 | 로그인 실패 |
| P001 | 404 | 존재하지 않는 상품 |
| P002 | 403 | 소유자 아님 (수정/삭제 차단) |

---

## 3. 패키지/디렉토리 구조

```
com/market/
├── user/        UserController, UserService, UserDAO, UserDTO, SessionUser
├── product/     ProductController, ProductService, ProductDAO, ProductDTO
├── home/        HomeController (GET / → index)
└── global/
    ├── config/     AppConfig, DBManager, RedisManager
    ├── filter/     EncodingFilter, LoggingFilter, ExceptionHandlingFilter, LoginCheckFilter
    ├── exception/  BaseErrorCode, CustomException, Global/User/Auth/Product ErrorCode
    └── util/       ValidationUtil

src/main/resources/   db.properties(미추적), db.properties.example, logback.xml
webapp/WEB-INF/web.xml          (필터 순서, 세션 타임아웃, error-page)
webapp/WEB-INF/views/           index, user/{login,join,profile,profileEdit},
                                product/{main,detail,form}, error/{error,404,500}, layout/
webapp/resources/css/error.css  (에러 페이지 공통 스타일)
```

규칙: Controller는 파라미터 추출/응답만, 비즈니스 로직은 Service, SQL은 DAO만. 폼 복귀형 에러(로그인 실패, 검증 실패)만 Controller에서 catch하고 나머지는 ExceptionHandlingFilter가 에러 페이지로 변환.

---

## 4. 검증 완료 내역

실제 Tomcat + PostgreSQL/Redis(Docker)에 배포해 curl로 전수 검증함:

- WEB-INF 차단(`/login.jsp` 직접 접근 → 404), 가입/로그인/로그아웃, LoginCheckFilter redirect
- BCrypt 해시 저장(`$2a$...`), 로그인 실패 A001, 중복 이메일 U001, 비밀번호 8자 미만 G001
- XSS: 제목에 `<script>` 입력 → `&lt;script&gt;`로 이스케이프 출력
- 소유자 검증: 타인 상품 삭제 → 403 P002 / 없는 상품 → 404 P001
- 소프트 삭제(deleted_at), Redis 인기 랭킹 적립, 한글 UTF-8 왕복
- 브라우저 폼으로 상품 등록 + 검증 실패 메시지 표시 (cac1331 이후)
- SLF4J 로그 출력 (LoggingFilter 요청/처리시간, 예외 warn)

코드 리뷰(7개 관점, 후보 35건)에서 살아남은 4건도 전부 수정·재검증 완료.

---

## 5. Eclipse 환경 관련 (오늘 해결한 문제)

- **증상**: Tomcat 기동 실패 → 원인: 프로젝트가 Maven이 아닌 Dynamic Web Project로 등록되어 pom 의존성이 빌드패스에 없었음 (`ClassNotFoundException: Logger`)
- **해결**: `.project`/`.classpath`에 Maven nature 추가 → m2e가 의존성을 `WEB-INF/lib`로 배포. 이 과정에서 컨텍스트 경로가 `/secondhand`로 변경됨
- `.project`/`.classpath`/`.settings`는 gitignore 대상이라 **이 수정은 이 PC에만 적용됨**. 다른 PC에서 클론하면 Eclipse에서 Import → Existing Maven Projects로 가져올 것

---

## 6. 남은 일 / 알아둘 것

- [x] **git push** — 완료 (gitmoji 컨벤션으로 메시지 정리 후 push)
- [x] **이미지(사진) 업로드** — 완료(7번 참고). 단일→다중, 파일은 외부 폴더·DB엔 경로만
- [x] **매물 등록 진입 동선** — 메인에 판매하기(+) FAB + 빈 상태 CTA 추가(7번 참고)
- [x] **profile.jsp 동적화** — 완료(8번). `/user/profile`이 UserDTO 전달, 실제 닉네임·지역·매너온도·이메일·아바타 표시
- [x] **profileEdit.jsp 폼** — 완료(8번). 실제 `<form>`(닉네임/지역/프로필이미지) + prefill, `/user/update` 연동
- [x] **상품 수정 폼** — 완료(8번). `GET /product/edit`(소유자 검증) + `edit.jsp`(prefill·상태변경·사진교체), 상세에 "수정" 진입
- [x] **헤더 네비** — 완료(8번). 메인 상단에 로그인/내 프로필 진입(세션 분기), 상세에 수정/삭제
- [x] **발표 산출물** — 완료(8번). `docs/ERD.md`, `docs/API_명세서.md`
- [ ] BCrypt 전환으로 **기존 평문 비밀번호 계정은 로그인 불가** — 테스트 계정 재가입 필요
- [ ] (선택) 등록/수정 검증 실패 시 업로드된 파일이 고아로 남음 — 정리 로직
- [ ] (선택) 상품 수정 시 다중 이미지 갤러리 자체 교체 UI(현재 수정은 대표 사진만 교체)
- 참고: 검증용으로 Docker Desktop을 켜뒀음(팀원 PC 기준). **이 PC(로컬)는 Docker 미설치 — PostgreSQL 네이티브 사용**

---

## 7. 추가 작업 (2026-06-10, 로컬 — 아직 미커밋)

문서 작성(`5d2bd5f`) 이후 로컬에서 진행한 작업. 다음 커밋 대상.

### 🐛 Fix — 실행 차단 이슈 해결
- `db.properties`가 없어 `AppConfig` 정적 초기화 실패 → DB 접근 페이지마다 **500**이던 문제: 로컬 PostgreSQL 정보로 `db.properties` 생성해 해결.

### ✨ Feat — 매물 등록 진입 동선
- 메인(`/product/`)에 **판매하기 플로팅 버튼(+)** + 빈 상태 **"매물 등록하기" CTA** 추가. 기존엔 등록 폼·백엔드는 있는데 화면에 진입 버튼이 없었음.

### ✨ Feat — 매물 사진 업로드 (단일 → 다중)
실서비스 패턴의 축소판: **파일은 외부 폴더, DB엔 경로만, 서블릿이 서빙.** (설계 근거는 `docs/이미지_저장_방식.md`)
- 저장 전략: 첫 장 = 대표 사진(`products.thumbnail`, 목록용) / 전체 = `product_images`(상세 갤러리용)
- `global/web/ImageController.java`(신규): `/images/*` 외부 폴더 서빙(`../` 경로 조작 방어, 비보호 URL)
- `ProductController`: `@MultipartConfig`(파일 10MB·요청 50MB) + `savePhotos()` 다중 파일 저장
- `ProductDAO`: `insert()` 생성 id 반환 + `insertImages()`(배치) + `findImageUrls()`
- `ProductService.write(userId, product, imageUrls)`: 첫 장 대표 + 전체 적재 / 상세에서 이미지 로드
- `ProductDTO`: `List<String> images` 필드 추가
- `form.jsp`: `enctype=multipart` + `<input type=file name=photos multiple>` + 다중 미리보기(첫 장 주황 테두리=대표)
- `main.jsp`/`detail.jsp`: 업로드 경로(`/`)면 contextPath 부착, 외부 URL은 그대로, 미첨부면 picsum 폴백. detail은 좌우 스와이프 갤러리
- `db.properties`(+example): `upload.dir` 추가

### 🔧 설정/환경
- 외부 업로드 폴더 `C:/Users/ssant/upload` 생성

> 적용 시: 이클립스 **Project → Clean → Tomcat Restart** (Java/web.xml 외 신규 서블릿·multipart 반영).

---

## 8. 추가 작업 2차 (2026-06-10, 로컬 — 미완성 UI 일괄 연결)

"백엔드는 있는데 화면 진입/연결이 빠진" 항목들을 전부 연결. (미커밋)

### ✨ 프로필 (정적 목업 → 동적)
- `UserController`: `/user/profile`·`/user/edit`가 `showUserPage()`로 **UserDTO를 `user`로 전달**(기존엔 데이터 없이 forward, profile.jsp는 등록폼 복붙 목업이었음)
- `profile.jsp`(재작성): 아바타·닉네임·매너온도·이메일·지역 표시 + 프로필수정/둘러보기/로그아웃 버튼
- `profileEdit.jsp`(재작성): 실제 `<form action=/user/update>` — 닉네임/지역(select)/프로필이미지 URL **prefill**, 이메일은 읽기전용

### ✨ 상품 수정 (백엔드만 있던 것 → UI 연결)
- `ProductController`: `GET /product/edit`(`editForm`, 소유자 검증) 라우트 추가
- `ProductService.getForEdit(loginUserId, productId)`: 소유자 검증 + 이미지 로드(조회수 미증가)
- `edit.jsp`(신규): 등록 폼 재활용 — 제목/가격/**상태(select)**/설명 prefill, 사진 새로 올리면 대표 교체(hidden `currentThumbnail` 유지), `POST /product/update`
- `detail.jsp`: 본인 매물에 **"수정" 버튼** 추가(기존 삭제 옆)
- `web.xml`: LoginCheckFilter에 `/product/edit` 보호 추가

### ✨ 네비게이션
- `main.jsp` 상단바: 로그인 상태면 **내 프로필**, 아니면 **로그인** 아이콘(세션 `loginUser` 분기)

### 📄 발표 산출물
- `docs/ERD.md`(Mermaid ERD + 관계 표), `docs/API_명세서.md`(전 라우트·파라미터·에러코드·업로드 규약)

### ✅ 점검 (mvn 미설치로 런타임 대신 정적 점검)
- 라우트↔뷰 매핑, 메서드 시그니처, EL/taglib 선언·사용, 폼 필드↔컨트롤러 파라미터 **전수 대조 일치**. 런타임 검증은 이클립스에서 필요.
