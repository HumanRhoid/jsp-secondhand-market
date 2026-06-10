-- 동네생활 게시판 테이블 (기존 DB엔 이 파일을 한 번 실행해서 추가)
CREATE TABLE IF NOT EXISTS boards (
    id         BIGSERIAL    PRIMARY KEY,
    user_id    BIGINT       REFERENCES users(id) ON DELETE SET NULL,
    title      VARCHAR(100) NOT NULL,
    content    TEXT,
    view_count INT          NOT NULL DEFAULT 0,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
);
