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
- [ ] BCrypt 전환으로 **기존 평문 비밀번호 계정은 로그인 불가** — 테스트 계정 재가입 필요
- [ ] 미구현 페이지: `profile.jsp`(빈 파일), `profileEdit.jsp`(정적 목업, 저장 미연동), 상품 **수정** 폼 화면(백엔드 `/product/update`는 동작), 이미지 업로드(thumbnail은 URL 문자열만)
- [ ] 발표/보고서용 산출물: ERD, API 명세서(원하면 md 표 형식 권장 — Swagger는 페이지 렌더링 앱엔 과해서 제외했음)
- 참고: 검증용으로 Docker Desktop을 켜뒀음. `market-pg` 컨테이너는 개발용으로 계속 사용
