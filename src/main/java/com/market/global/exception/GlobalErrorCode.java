package com.market.global.exception;

public enum GlobalErrorCode implements BaseErrorCode {

    INVALID_INPUT("G001", "입력값이 올바르지 않습니다.", 400),
    DATABASE_ERROR("G002", "데이터 처리 중 오류가 발생했습니다.", 500);

    private final String code;
    private final String message;
    private final int status;

    GlobalErrorCode(String code, String message, int status) {
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
