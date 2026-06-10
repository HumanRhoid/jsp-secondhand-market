package com.market.user;

import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.market.global.exception.AuthErrorCode;
import com.market.global.exception.CustomException;
import com.market.global.exception.GlobalErrorCode;
import com.market.global.exception.UserErrorCode;

/**
 * 회원 비즈니스 로직. 검증/중복 체크/인증은 여기서 처리하고 SQL은 UserDAO에 위임한다.
 * 실패는 CustomException으로 통일한다.
 */
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    private final UserDAO userDAO = new UserDAO();

    /** 회원가입. 이메일 중복 시 U001 */
    public void join(UserDTO user) {
        try {
            if (userDAO.existsByEmail(user.getEmail())) {
                throw new CustomException(UserErrorCode.DUPLICATE_EMAIL);
            }
            userDAO.join(user);
            log.info("회원가입 완료: email={}", user.getEmail());
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 로그인. 이메일/비밀번호 불일치 시 A001 */
    public UserDTO login(String email, String password) {
        try {
            UserDTO user = userDAO.findByEmail(email);
            if (user == null || !user.getPassword().equals(password)) {
                throw new CustomException(AuthErrorCode.LOGIN_FAILED);
            }
            log.info("로그인 성공: userId={}", user.getId());
            return user;
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 프로필 수정. 갱신된 사용자 정보를 반환한다 (세션 갱신용). */
    public UserDTO updateProfile(long userId, String nickname, String region, String profileImage) {
        try {
            UserDTO user = userDAO.findById(userId);
            if (user == null) {
                throw new CustomException(UserErrorCode.USER_NOT_FOUND);
            }
            user.setNickname(nickname);
            user.setRegion(region);
            user.setProfileImage(profileImage);
            userDAO.update(user);
            log.info("프로필 수정: userId={}", userId);
            return user;
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** id로 회원 조회. 없으면 U002 */
    public UserDTO findById(long id) {
        try {
            UserDTO user = userDAO.findById(id);
            if (user == null) {
                throw new CustomException(UserErrorCode.USER_NOT_FOUND);
            }
            return user;
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }
}
