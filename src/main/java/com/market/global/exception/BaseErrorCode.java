package com.market.global.exception;

/**
 * 모든 도메인 에러코드 enum이 구현하는 공통 인터페이스.
 * status는 HTTP 상태 코드(int)를 사용한다.
 */
public interface BaseErrorCode {

    String getCode();

    String getMessage();

    int getStatus();
}
