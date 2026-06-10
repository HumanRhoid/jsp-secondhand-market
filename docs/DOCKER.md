# 🐳 Docker로 실행하기 (어느 PC든 한 줄 실행)

받는 사람 PC에 **Docker Desktop만 설치**돼 있으면, 아래 한 줄로 DB·Redis·앱이 모두 떠서 즉시 서버가 됩니다. JDK·Tomcat·PostgreSQL을 따로 깔 필요 없습니다.

```bash
docker compose up --build
```

실행 후 브라우저에서: **http://localhost:8080/secondhand/**

종료: `Ctrl+C` → `docker compose down` (사진/DB 유지) / 완전 초기화는 `docker compose down -v`

---

## 구성

| 서비스 | 이미지 | 역할 |
|---|---|---|
| `app` | Tomcat 10.1 + JDK 21 | 우리 앱(`secondhand.war`). **빌드도 컨테이너 안에서** 수행 → 로컬 Maven 불필요 |
| `db` | postgres:17 | PostgreSQL. 최초 실행 시 `docker/db-init/01_dump.sql`(스키마 + **현재 데이터**) 자동 적재 |
| `redis` | redis:7 | 인기 랭킹 캐시 |

데이터 영속화: `pgdata`(DB), `uploads`(업로드 사진) — named volume.

## 동작 원리 (실서비스 축소판)

- 앱은 `docker/db.properties`(빌드 시 주입)로 **`db:5432` / `redis:6379`** 에 연결 (compose 서비스명이 호스트명)
- 업로드 사진은 컨테이너 내부 `/data/upload`(=`uploads` 볼륨)에 저장, DB엔 경로만 — `ImageController`가 서빙
- DB 초기 데이터는 현재 로컬 DB를 `pg_dump`로 떠서 포함함

## 주의

- `docker/db.properties`와 `docker-compose.yml`에 개발용 DB 비밀번호(`990909`)가 들어 있음. 외부 공개 저장소에 올릴 땐 교체 권장(개발/시연용이라 그대로 둬도 무방).
- 최초 `up`은 Maven 의존성 내려받기 + 빌드로 수 분 걸릴 수 있음(이후 캐시).
- `db-init` SQL은 **DB 볼륨이 빈 최초 1회만** 실행됨. 데이터를 새로 적재하려면 `docker compose down -v` 후 재실행.

## 로컬(이클립스) 개발과의 관계

- 로컬 개발은 기존대로 이클립스 + 네이티브 PostgreSQL 사용(`src/main/resources/db.properties`).
- Docker는 **배포/전달용**. `.dockerignore`가 로컬 `db.properties`를 제외하고, 컨테이너는 `docker/db.properties`를 사용하므로 서로 충돌하지 않음.
