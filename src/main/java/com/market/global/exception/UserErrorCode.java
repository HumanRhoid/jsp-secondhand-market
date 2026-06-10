package com.market.global.exception;

public enum UserErrorCode implements BaseErrorCode {

    DUPLICATE_EMAIL("U001", "이미 사용 중인 이메일입니다.", 409),
    USER_NOT_FOUND("U002", "존재하지 않는 사용자입니다.", 404);

    private final String code;
    private final String message;
    private final int status;

    UserErrorCode(String code, String message, int status) {
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
