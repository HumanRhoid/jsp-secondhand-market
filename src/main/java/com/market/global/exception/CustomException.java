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

    /** 에러코드는 유지하되 메시지만 구체화할 때 사용 (예: 검증 실패 필드 안내) */
    public CustomException(BaseErrorCode errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }

    public BaseErrorCode getErrorCode() {
        return errorCode;
    }
}
