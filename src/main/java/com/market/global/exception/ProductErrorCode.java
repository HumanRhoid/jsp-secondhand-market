package com.market.global.exception;

public enum ProductErrorCode implements BaseErrorCode {

    PRODUCT_NOT_FOUND("P001", "존재하지 않는 상품입니다.", 404),
    NOT_OWNER("P002", "본인의 상품만 수정/삭제할 수 있습니다.", 403);

    private final String code;
    private final String message;
    private final int status;

    ProductErrorCode(String code, String message, int status) {
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
