package com.market.user;

<<<<<<< HEAD
import java.sql.Timestamp;

public class UserDTO {

    private long      id;
    private String    nickname;
    private String    email;
    private String    password;
    private String    region;
    private String    profileImage;
    private double    mannerTemp;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public long getId()                  { return id; }
    public void setId(long id)           { this.id = id; }

    public String getNickname()                    { return nickname; }
    public void   setNickname(String nickname)     { this.nickname = nickname; }

    public String getEmail()                 { return email; }
    public void   setEmail(String email)     { this.email = email; }

    public String getPassword()                    { return password; }
    public void   setPassword(String password)     { this.password = password; }

    public String getRegion()                  { return region; }
    public void   setRegion(String region)     { this.region = region; }

    public String getProfileImage()                      { return profileImage; }
    public void   setProfileImage(String profileImage)   { this.profileImage = profileImage; }

    public double getMannerTemp()                    { return mannerTemp; }
    public void   setMannerTemp(double mannerTemp)   { this.mannerTemp = mannerTemp; }

    public Timestamp getCreatedAt()                    { return createdAt; }
    public void      setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt()                    { return updatedAt; }
    public void      setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
=======
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
>>>>>>> origin/main
}
