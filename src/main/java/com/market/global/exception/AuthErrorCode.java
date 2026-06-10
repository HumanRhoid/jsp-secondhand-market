package com.market.global.exception;

public enum AuthErrorCode implements BaseErrorCode {

    LOGIN_FAILED("A001", "이메일 또는 비밀번호가 일치하지 않습니다.", 401),
    UNAUTHORIZED("A002", "로그인이 필요한 요청입니다.", 401);

    private final String code;
    private final String message;
    private final int status;

    AuthErrorCode(String code, String message, int status) {
        this.code = code;
        this.message = message;
        this.status = status;
    }

    @Override
    public String getCode() {
        return code;
    }

    @Override
    public String getMessage() {
        return message;
    }

    @Override
    public int getStatus() {
        return status;
    }
}
