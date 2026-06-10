package com.market.board;

import java.io.Serializable;
import java.sql.Timestamp;

public class BoardDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private long      id;
    private long      userId;
    private String    nickname;   // 작성자 (users join)
    private String    title;
    private String    content;
    private int       viewCount;
    private Timestamp createdAt;

    public long getId()                 { return id; }
    public void setId(long id)          { this.id = id; }

    public long getUserId()             { return userId; }
    public void setUserId(long userId)  { this.userId = userId; }

    public String getNickname()              { return nickname; }
    public void   setNickname(String n)      { this.nickname = n; }

    public String getTitle()             { return title; }
    public void   setTitle(String t)     { this.title = t; }

    public String getContent()           { return content; }
    public void   setContent(String c)   { this.content = c; }

    public int  getViewCount()           { return viewCount; }
    public void setViewCount(int v)      { this.viewCount = v; }

    public Timestamp getCreatedAt()             { return createdAt; }
    public void      setCreatedAt(Timestamp t)  { this.createdAt = t; }
}
