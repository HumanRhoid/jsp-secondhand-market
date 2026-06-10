package com.market.global.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * classpath의 db.properties를 1회 로드해 제공하는 설정 클래스.
 * 접속 정보를 코드에 하드코딩하지 않기 위해 분리한다 (db.properties.example 참고).
 */
public final class AppConfig {

    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = AppConfig.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) {
                throw new IllegalStateException(
                        "db.properties를 찾을 수 없습니다. src/main/resources/db.properties.example을 복사해 생성하세요.");
            }
            PROPS.load(in);
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private AppConfig() {
    }

    public static String get(String key) {
        return PROPS.getProperty(key);
    }

    public static int getInt(String key) {
        return Integer.parseInt(PROPS.getProperty(key));
    }
}
