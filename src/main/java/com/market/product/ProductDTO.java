package com.market.product;

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
}
