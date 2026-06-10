package com.market.product;

<<<<<<< HEAD
import java.sql.Timestamp;

public class ProductDTO {

    private long      id;
    private long      userId;
    private long      categoryId;
    private String    title;
    private String    description;
    private String    status;       // 판매중 / 예약중 / 판매완료
    private int       price;
    private String    thumbnail;
    private int       viewCount;
    private int       likeCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp deletedAt;

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
=======
import java.io.Serializable;

public class ProductDTO implements Serializable {

    private static final long serialVersionUID = 1L;
    private String productId;    // 상품 ID
    private String title;        // 제목
    private int price;           // 가격
    private String description;  // 설명
    private String filename;     // 상품 이미지 파일명

    public ProductDTO() {
    }

    public ProductDTO(String productId, String title, int price) {
        this.productId = productId;
        this.title = title;
        this.price = price;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }
>>>>>>> origin/main
}
