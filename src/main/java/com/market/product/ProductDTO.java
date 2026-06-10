package com.market.product;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ProductDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private long      id;
    private long      userId;
    private long      categoryId;
    private String    title;
    private String    description;
    private String    status;       // 판매중 / 예약중 / 판매완료
    private int       price;
    private String    thumbnail;     // 대표 사진(첫 장) 경로
    private int       viewCount;
    private int       likeCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp deletedAt;
    private List<String> images = new ArrayList<>(); // 상세용 전체 사진 경로 목록(product_images)
    private Double    latitude;   // 매물 좌표 (카카오맵/거리 계산용, 없으면 null)
    private Double    longitude;
    private Double    distanceKm; // "내 주변" 조회 시 계산된 거리(km)

    public long getId()              { return id; }
    public void setId(long id)       { this.id = id; }

    public long getUserId()                { return userId; }
    public void setUserId(long userId)     { this.userId = userId; }

    public long getCategoryId()                  { return categoryId; }
    public void setCategoryId(long categoryId)   { this.categoryId = categoryId; }

    public String getTitle()               { return title; }
    public void   setTitle(String title)   { this.title = title; }

    public String getDescription()                     { return description; }
    public void   setDescription(String description)   { this.description = description; }

    public String getStatus()                { return status; }
    public void   setStatus(String status)   { this.status = status; }

    public int  getPrice()             { return price; }
    public void setPrice(int price)    { this.price = price; }

    public String getThumbnail()                   { return thumbnail; }
    public void   setThumbnail(String thumbnail)   { this.thumbnail = thumbnail; }

    public int  getViewCount()                 { return viewCount; }
    public void setViewCount(int viewCount)    { this.viewCount = viewCount; }

    public int  getLikeCount()                 { return likeCount; }
    public void setLikeCount(int likeCount)    { this.likeCount = likeCount; }

    public Timestamp getCreatedAt()                    { return createdAt; }
    public void      setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt()                    { return updatedAt; }
    public void      setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public Timestamp getDeletedAt()                    { return deletedAt; }
    public void      setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }

    public List<String> getImages()                    { return images; }
    public void         setImages(List<String> images) { this.images = images; }

    public Double getLatitude()                  { return latitude; }
    public void   setLatitude(Double latitude)   { this.latitude = latitude; }

    public Double getLongitude()                 { return longitude; }
    public void   setLongitude(Double longitude) { this.longitude = longitude; }

    public Double getDistanceKm()                  { return distanceKm; }
    public void   setDistanceKm(Double distanceKm) { this.distanceKm = distanceKm; }
}
