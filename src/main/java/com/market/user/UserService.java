package com.market.user;

import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.market.global.exception.AuthErrorCode;
import com.market.global.exception.CustomException;
import com.market.global.exception.GlobalErrorCode;
import com.market.global.exception.UserErrorCode;
import com.market.global.util.ValidationUtil;

/**
 * 회원 비즈니스 로직. 검증/중복 체크/인증은 여기서 처리하고 SQL은 UserDAO에 위임한다.
 * 실패는 CustomException으로 통일한다.
 */
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    private final UserDAO userDAO = new UserDAO();

    /** 회원가입. 검증 실패 시 G001, 이메일 중복 시 U001. 비밀번호는 BCrypt 해시로 저장한다. */
    public void join(UserDTO user) {
        ValidationUtil.validateRequired(user.getNickname(), "nickname");
        ValidationUtil.validateEmail(user.getEmail());
        ValidationUtil.validatePassword(user.getPassword());
        try {
            if (userDAO.existsByEmail(user.getEmail())) {
                throw new CustomException(UserErrorCode.DUPLICATE_EMAIL);
            }
            user.setPassword(BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));
            userDAO.join(user);
            log.info("회원가입 완료: email={}", user.getEmail());
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 로그인. 이메일/비밀번호 불일치 시 A001. 세션 저장용 SessionUser를 반환한다. */
    public SessionUser login(String email, String password) {
        ValidationUtil.validateRequired(email, "email");
        ValidationUtil.validateRequired(password, "password");
        try {
            UserDTO user = userDAO.findByEmail(email);
            boolean matches;
            try {
                matches = user != null && BCrypt.checkpw(password, user.getPassword());
            } catch (IllegalArgumentException e) {
                matches = false; // DB에 BCrypt 형식이 아닌(평문 등) 비밀번호가 남아있는 경우 방어
            }
            if (!matches) {
                log.warn("로그인 실패: email={}", email);
                throw new CustomException(AuthErrorCode.LOGIN_FAILED);
            }
            log.info("로그인 성공: userId={}", user.getId());
            return SessionUser.from(user);
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 프로필 수정. 갱신된 SessionUser를 반환한다 (세션 갱신용). */
    public SessionUser updateProfile(long userId, String nickname, String region, String profileImage) {
        ValidationUtil.validateRequired(nickname, "nickname");
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
            return SessionUser.from(user);
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
