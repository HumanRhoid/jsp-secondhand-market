package com.market.user;

import java.io.Serializable;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

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

    /**
     * 현재 요청의 로그인 사용자. 미로그인이거나 세션에 다른 타입이 들어있으면(재배포 후
     * 복원된 구버전 세션, 동시 로그아웃 경합 등) null을 반환한다 — 캐스트 예외 방지.
     * 보호 URL은 LoginCheckFilter가 막지만, 컨트롤러도 null을 방어해야 한다.
     */
    public static SessionUser current(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        Object user = session == null ? null : session.getAttribute("loginUser");
        return user instanceof SessionUser su ? su : null;
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
