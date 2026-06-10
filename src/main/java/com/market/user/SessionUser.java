package com.market.user;

import java.io.Serializable;

/**
 * 세션에 저장하는 최소 사용자 정보.
 * password/email 등 민감정보를 세션에 올리지 않기 위해 UserDTO 대신 사용한다.
 */
public class SessionUser implements Serializable {

    private static final long serialVersionUID = 1L;

    private final long id;
    private final String nickname;
    private final String region;
    private final String profileImage;

    public SessionUser(long id, String nickname, String region, String profileImage) {
        this.id = id;
        this.nickname = nickname;
        this.region = region;
        this.profileImage = profileImage;
    }

    public static SessionUser from(UserDTO user) {
        return new SessionUser(user.getId(), user.getNickname(), user.getRegion(), user.getProfileImage());
    }

    public long getId() {
        return id;
    }

    public String getNickname() {
        return nickname;
    }

    public String getRegion() {
        return region;
    }

    public String getProfileImage() {
        return profileImage;
    }
}
