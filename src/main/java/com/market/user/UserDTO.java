package com.market.user;

import java.io.Serializable;

public class UserDTO implements Serializable {

    private static final long serialVersionUID = 1L;
    private String email;       // 이메일 (로그인 ID 겸용)
    private String password;    // 비밀번호
    private String name;        // 이름/닉네임
    private String region;      // 지역

    public UserDTO() {
    }

    public UserDTO(String email, String password, String name, String region) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.region = region;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }
}
