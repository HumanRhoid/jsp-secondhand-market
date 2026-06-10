# jsp-web-project
🛍️ JSP 기반 중고거래 플랫폼 개발 협업 저장소

## 구현 목표
| 기술 | 중요도 | 상태 |
| :--- | :--- | :--- |
|**Postgre 공간 좌표 특성 활용 거래 범위 설정**| ✨✨ | ✅ 좌표 저장(Geolocation+카카오맵 행정동 변환) + 하버사인 SQL "📍 내 주변" 거리순 |
| **Redis를 활용한 캐쉬** | ✨✨✨ | ✅ 조회수 기반 인기 매물 랭킹(Sorted Set), 장애 시 폴백 |
| **SNS 로그인 API** | ✨✨ | ✅ 카카오/네이버 OAuth 2.0, 최초 로그인 자동 가입 |
| **결제 대행 API** | ✨✨ | ✅ 토스페이먼츠 — 결제창 → 서버 confirm 승인(금액 검증) → 판매완료 |
| **AWS 활용 DB 조작**| ✨ | ⬜ 예정 (Docker 구성으로 클라우드 배포 준비됨) |

## ⚙️ 주요 기능
- **회원**: 가입/로그인(BCrypt)/SNS 로그인/프로필 조회·수정/탈퇴
- **매물**: 등록(다중 사진 업로드)·수정·소프트 삭제, 검색·카테고리 필터, 상세 사진 갤러리
- **거래**: 장바구니(세션), 토스 결제(테스트 키 내장 — 즉시 시연 가능)
- **위치**: 등록 시 좌표 자동 수집, "내 주변" 거리순 정렬 + 거리 표시
- **커뮤니티**: 동네생활 게시판(목록/조회/글쓰기)
- **인프라**: MVC2(Service 계층), 전역 예외 체계(ErrorCode), 필터 4종, SLF4J+Logback, XSS 방지

## 🚀 실행 방법

### A. Docker (아무 PC나 한 줄 — 권장)
```bash
docker compose up --build
# → http://localhost:8080/secondhand/  (DB·Redis·앱 자동 구성, 초기 데이터 포함)
```

### B. 이클립스 (개발)
1. `Import → Existing Maven Projects`
2. `src/main/resources/db.properties.example` → `db.properties` 복사 후 로컬 PostgreSQL 정보 입력
3. `schema.sql` 실행(테이블 생성) → Tomcat 10.1로 구동
4. 카카오맵/SNS 로그인은 `db.properties`에 API 키 입력 시 활성화 (토스 결제는 테스트 키 내장)

## 📚 문서
| 문서 | 내용 |
| :--- | :--- |
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | 프로젝트 현황·작업 이력 |
| [docs/ERD.md](docs/ERD.md) | ERD(Mermaid) + 테이블 관계 |
| [docs/API_명세서.md](docs/API_명세서.md) | 전체 라우트·파라미터·에러코드 |
| [docs/DOCKER.md](docs/DOCKER.md) | Docker 실행 가이드 |
| [docs/이미지_저장_방식.md](docs/이미지_저장_방식.md) | 사진 저장 설계(스토리지+DB 경로) |

## 🎯 Git Commit Convention
커밋 메시지는 아래의 핵심 이모지와 형식을 준수하여 작성합니다. 너무 많은 이모지 대신 자주 쓰는 6가지로 제한하여 개발 속도를 높입니다.

| 이모지 | 타입 | 설명 |
| :--- | :--- | :--- |
| ✨ | **Feat** | 새로운 기능 추가 및 구현 (`:sparkles:`) |
| 🐛 | **Fix** | 버그 수정 및 해결 (`:bug:`) |
| 🎨 | **Design** | UI 디자인 변경 / CSS, JSP 화면 수정 (`:art:`) |
| ♻️ | **Refactor** | 코드 구조 개선 / 리팩토링 (`:recycle:`) |
| 🔧 | **Chore** | 빌드 설정, 라이브러리(JAR) 추가, 환경설정 수정 (`:wrench:`) |
| 📝 | **Docs** | README 등 문서 수정 및 추가 (`:memo:`) |

### 📝 커밋 메시지 형식
> **형식:** `이모지 타입: 작업 내용 요약`
> - 예: `✨ Feat: 상품 등록 기능 구현`
> - 예: `🎨 Design: 메인 페이지 레이아웃 수정`

---

## 🌿 Branch Convention (GitHub Flow)
2인 프로젝트의 빠른 리드타임을 위해 `develop` 브랜치 없이 **`main` 브랜치 하나만 중심**으로 운영합니다.

* **main** : 언제든 실행 및 배포 가능한 최신 상태의 브랜치입니다.
* **feature/{본인이름}/{기능명}** : 각자 새로운 기능을 개발하는 개인 작업 브랜치입니다.
  * 예: `feature/minho/product-crud`
  * 예: `feature/team/user-login`

---

## 🔀 Workflow (작업 흐름)

1. 최신 `main` 브랜치에서 본인의 `feature` 브랜치를 생성합니다.
2. 작업 완료 후 커밋 컨벤션에 맞춰 커밋을 남깁니다.
3. 작업이 끝나면 GitHub에 Push 후 **Pull Request(PR)**를 생성합니다.
4. 상대방의 코드 리뷰를 받거나 상호 확인 후 `main` 브랜치로 병합(Merge)합니다.
5. **[중요]** 새로운 작업을 시작하기 전에는 항상 로컬 `main`에서 `git pull origin main`을 받아 최신 코드를 동기화합니다.

---

## 🚨 [필독] JSP 프로젝트 협업 주의사항 (충돌 방지)

1. **IDE 설정 파일 공유 금지 (`.gitignore` 확인)**
   - 이클립스의 `.metadata`, `.settings`, `.classpath`, `.project` 파일이나 인텔리제이의 `.idea/` 폴더는 개인 컴퓨터 경로가 포함되어 있어 Git에 올리면 무조건 충돌이 발생합니다. 프로젝트 시작 전 반드시 제외되었는지 확인합니다.
2. **톰캣(Tomcat) 및 로컬 DB 환경 맞추기**
   - 서로 사용하는 서버 포트(예: 8080)와 로컬 MySQL 비밀번호를 사전에 맞추거나, DB 연결 정보가 포함된 클래스는 환경 변화 시 팀원에게 미리 공유합니다.
3. **`WEB-INF/lib` 라이브러리 추가 시 공유**
   - Maven/Gradle을 쓰지 않고 외부 JAR 파일(MySQL 커넥터, JSTL 등)을 `lib` 폴더에 직접 추가할 경우, 프로젝트가 깨지지 않도록 반드시 `🔧 Chore` 커밋으로 명시하고 팀원에게 알립니다.
