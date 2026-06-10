package com.market.global.exception;

/**
 * 비즈니스 예외. Service 계층에서 던지면 ExceptionHandlingFilter가
 * 에러코드에 맞는 상태/메시지로 에러 페이지를 렌더링한다.
 */
public class CustomException extends RuntimeException {

    private final BaseErrorCode errorCode;

    public CustomException(BaseErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    public CustomException(BaseErrorCode errorCode, Throwable cause) {
        super(errorCode.getMessage(), cause);
        this.errorCode = errorCode;
    }

    public BaseErrorCode getErrorCode() {
        return errorCode;
    }
}
