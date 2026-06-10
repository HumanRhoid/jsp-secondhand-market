package com.market.global.util;

import java.util.regex.Pattern;

import com.market.global.exception.CustomException;
import com.market.global.exception.GlobalErrorCode;

/**
 * 입력값 검증 유틸 (Bean Validation 대체).
 * Service 진입부에서 호출하며, 위반 시 CustomException(G001)을 던진다.
 */
public final class ValidationUtil {

    private static final Pattern EMAIL =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private ValidationUtil() {
    }

    public static void validateRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new CustomException(GlobalErrorCode.INVALID_INPUT,
                    "[" + fieldName + "] 필수 입력값입니다.");
        }
    }

    public static void validateEmail(String email) {
        if (email == null || !EMAIL.matcher(email).matches()) {
            throw new CustomException(GlobalErrorCode.INVALID_INPUT,
                    "[email] 올바른 이메일 형식이 아닙니다.");
        }
    }

    public static void validatePassword(String password) {
        if (password == null || password.length() < 8 || password.length() > 20) {
            throw new CustomException(GlobalErrorCode.INVALID_INPUT,
                    "[password] 비밀번호는 8자 이상 20자 이하여야 합니다.");
        }
    }

    public static void validatePositive(int value, String fieldName) {
        if (value <= 0) {
            throw new CustomException(GlobalErrorCode.INVALID_INPUT,
                    "[" + fieldName + "] 0보다 큰 값이어야 합니다.");
        }
    }
}
