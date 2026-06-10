# 🗂 ERD — 중고거래 플랫폼 (jsp-web-project)

> 기준: `schema.sql` (PostgreSQL 16). 핵심 도메인은 users · products · product_images.

## 관계 다이어그램 (Mermaid)

```mermaid
erDiagram
    users ||--o{ products : "등록(user_id)"
    users ||--o{ favorite_products : "찜(user_id)"
    users ||--o{ sale_reviews : "후기 작성/대상"
    users ||--o{ manners : "매너평가"
    categories ||--o{ products : "분류(category_id)"
    products ||--o{ product_images : "사진(product_id)"
    products ||--o{ favorite_products : "찜 대상"
    products ||--o{ chat_rooms : "거래 채팅"
    chat_rooms ||--o{ participants : "참여자"
    chat_rooms ||--o{ notifications : "알림"
    users ||--o{ participants : "참여"

    users {
        bigserial id PK
        varchar nickname
        varchar email UK
        varchar password "BCrypt 해시"
        varchar region
        varchar profile_image "경로/URL"
        numeric manner_temp "기본 36.5"
    }
    products {
        bigserial id PK
        bigint user_id FK
        bigint category_id FK
        varchar title
        text description
        varchar status "판매중/예약중/판매완료"
        int price
        varchar thumbnail "대표 사진 경로"
        int view_count
        int like_count
        timestamp deleted_at "소프트 삭제"
    }
    product_images {
        bigserial id PK
        bigint product_id FK
        varchar image_url "사진 경로(/images/..)"
    }
    categories {
        bigserial id PK
        varchar name
    }
    favorite_products {
        bigserial id PK
        bigint user_id FK
        bigint product_id FK
        boolean is_active
    }
    chat_rooms {
        varchar id PK
        bigint product_id FK
        bigint buyer_id FK
        bigint seller_id FK
        varchar last_message
    }
```

## 핵심 관계 요약

| 관계 | 설명 | 삭제 정책 |
|---|---|---|
| users → products | 한 사용자가 매물 여러 개 등록 | 사용자 삭제 시 매물 CASCADE |
| categories → products | 매물은 카테고리 1개(선택) | 카테고리 삭제 시 SET NULL |
| **products → product_images** | **매물 1개에 사진 여러 장** (다중 이미지) | 매물 삭제 시 CASCADE |
| users ↔ products (favorite) | 찜 (user, product) UNIQUE | 양쪽 CASCADE |
| products → chat_rooms | 매물별 거래 채팅 | 매물 삭제 시 SET NULL |

## 구현에서 실제 사용하는 테이블

현재 애플리케이션이 읽고 쓰는 테이블:
- **users** — 가입/로그인/프로필 (UserDAO)
- **products** — 매물 CRUD, 대표 사진(thumbnail), 소프트 삭제, 조회수 (ProductDAO)
- **product_images** — 매물 다중 사진 (ProductDAO.insertImages / findImageUrls)
- **categories** — 시드 7개 (등록 폼에서 미사용, 추후 분류 기능 여지)

> favorite_products·chat_rooms·participants·notifications·manners·sale_reviews는 스키마에만 존재(찜/채팅/알림/후기 미구현). 확장 여지로 남김.
