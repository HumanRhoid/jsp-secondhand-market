-- ============================================================
-- SecondheadServiceDB
-- 실행: psql -U postgres -d SecondheadServiceDB -f schema.sql
-- ============================================================

-- 재실행 안전하게: 의존성 역순으로 DROP
DROP TABLE IF EXISTS sale_reviews      CASCADE;
DROP TABLE IF EXISTS manners           CASCADE;
DROP TABLE IF EXISTS notifications     CASCADE;
DROP TABLE IF EXISTS participants      CASCADE;
DROP TABLE IF EXISTS chat_rooms        CASCADE;
DROP TABLE IF EXISTS favorite_products CASCADE;
DROP TABLE IF EXISTS product_images    CASCADE;
DROP TABLE IF EXISTS products          CASCADE;
DROP TABLE IF EXISTS users             CASCADE;
DROP TABLE IF EXISTS categories        CASCADE;

-- 1. categories
CREATE TABLE categories (
    id         BIGSERIAL    PRIMARY KEY,
    name       VARCHAR(20)  NOT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 2. users
CREATE TABLE users (
    id            BIGSERIAL    PRIMARY KEY,
    nickname      VARCHAR(20)  NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    region        VARCHAR(20)  NOT NULL,
    profile_image VARCHAR(250),
    manner_temp   NUMERIC(4,2) NOT NULL DEFAULT 36.5,
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 3. products
CREATE TABLE products (
    id          BIGSERIAL    PRIMARY KEY,
    user_id     BIGINT       NOT NULL REFERENCES users(id)      ON DELETE CASCADE,
    category_id BIGINT                REFERENCES categories(id) ON DELETE SET NULL,
    title       VARCHAR(100) NOT NULL,
    description TEXT,
    status      VARCHAR(20)  NOT NULL DEFAULT '판매중',
    price       INT          NOT NULL CHECK (price >= 0),
    thumbnail   VARCHAR(250),
    view_count  INT          NOT NULL DEFAULT 0,
    like_count  INT          NOT NULL DEFAULT 0,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    deleted_at  TIMESTAMP
);

-- 4. product_images
CREATE TABLE product_images (
    id         BIGSERIAL    PRIMARY KEY,
    product_id BIGINT       NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    image_url  VARCHAR(250) NOT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 5. favorite_products
CREATE TABLE favorite_products (
    id         BIGSERIAL PRIMARY KEY,
    user_id    BIGINT    NOT NULL REFERENCES users(id)    ON DELETE CASCADE,
    product_id BIGINT    NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    is_active  BOOLEAN   NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, product_id)
);

-- 6. chat_rooms
CREATE TABLE chat_rooms (
    id           VARCHAR(36) PRIMARY KEY,
    product_id   BIGINT      REFERENCES products(id) ON DELETE SET NULL,
    buyer_id     BIGINT      REFERENCES users(id)    ON DELETE SET NULL,
    seller_id    BIGINT      REFERENCES users(id)    ON DELETE SET NULL,
    last_message VARCHAR(500),
    created_at   TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP   NOT NULL DEFAULT NOW()
);

-- 7. participants
CREATE TABLE participants (
    room_id      VARCHAR(36) NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    user_id      BIGINT      NOT NULL REFERENCES users(id)      ON DELETE CASCADE,
    unread_count BIGINT      NOT NULL DEFAULT 0,
    is_active    BOOLEAN     NOT NULL DEFAULT TRUE,
    last_read_id BIGINT,
    created_at   TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP   NOT NULL DEFAULT NOW(),
    PRIMARY KEY (room_id, user_id)
);

-- 8. notifications
CREATE TABLE notifications (
    id         BIGSERIAL   PRIMARY KEY,
    user_id    BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type       INT,
    content    VARCHAR(50),
    is_read    BOOLEAN     NOT NULL DEFAULT FALSE,
    is_active  BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP   NOT NULL DEFAULT NOW()
);

-- 9. manners
CREATE TABLE manners (
    id           BIGSERIAL PRIMARY KEY,
    from_user_id BIGINT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    to_user_id   BIGINT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    score        INT       CHECK (score BETWEEN 1 AND 5),
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 10. sale_reviews
CREATE TABLE sale_reviews (
    id         BIGSERIAL   PRIMARY KEY,
    product_id BIGINT      NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    buyer_id   BIGINT      NOT NULL REFERENCES users(id)    ON DELETE CASCADE,
    seller_id  BIGINT      NOT NULL REFERENCES users(id)    ON DELETE CASCADE,
    rating     INT         CHECK (rating BETWEEN 1 AND 5),
    content    VARCHAR(500),
    created_at TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP   NOT NULL DEFAULT NOW()
);

-- index
CREATE INDEX idx_products_user_id    ON products(user_id);
CREATE INDEX idx_products_category   ON products(category_id);
CREATE INDEX idx_products_created_at ON products(created_at DESC);
CREATE INDEX idx_products_status     ON products(status);
CREATE INDEX idx_product_images_pid  ON product_images(product_id);
CREATE INDEX idx_fav_user            ON favorite_products(user_id);
CREATE INDEX idx_chat_buyer          ON chat_rooms(buyer_id);
CREATE INDEX idx_chat_seller         ON chat_rooms(seller_id);
CREATE INDEX idx_notifications_user  ON notifications(user_id);

-- (추가) 동네생활 게시판
CREATE TABLE IF NOT EXISTS boards (
    id         BIGSERIAL    PRIMARY KEY,
    user_id    BIGINT       REFERENCES users(id) ON DELETE SET NULL,
    title      VARCHAR(100) NOT NULL,
    content    TEXT,
    view_count INT          NOT NULL DEFAULT 0,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
);
-- 외부 연동(카카오맵 좌표 / 포트원 결제 / SNS 로그인)용 스키마 추가

-- 1) 좌표 (카카오맵 좌표 변환 + 거리 계산)
ALTER TABLE users    ADD COLUMN IF NOT EXISTS latitude  DOUBLE PRECISION;
ALTER TABLE users    ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;
ALTER TABLE products ADD COLUMN IF NOT EXISTS latitude  DOUBLE PRECISION;
ALTER TABLE products ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;

-- 2) SNS 로그인 (kakao/naver). provider+provider_id로 기존 회원 식별
ALTER TABLE users ADD COLUMN IF NOT EXISTS provider    VARCHAR(20);
ALTER TABLE users ADD COLUMN IF NOT EXISTS provider_id VARCHAR(100);
CREATE UNIQUE INDEX IF NOT EXISTS uq_users_provider ON users(provider, provider_id) WHERE provider IS NOT NULL;

-- 3) 주문 (포트원 결제 검증 후 기록)
CREATE TABLE IF NOT EXISTS orders (
    id           BIGSERIAL    PRIMARY KEY,
    product_id   BIGINT       NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    buyer_id     BIGINT       REFERENCES users(id) ON DELETE SET NULL,
    imp_uid      VARCHAR(100) NOT NULL UNIQUE,
    merchant_uid VARCHAR(100) NOT NULL,
    amount       INT          NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'paid',
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);
