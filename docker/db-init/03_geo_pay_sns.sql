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
    payment_key  VARCHAR(200) NOT NULL UNIQUE,
    merchant_uid VARCHAR(100) NOT NULL,
    amount       INT          NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'paid',
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);
