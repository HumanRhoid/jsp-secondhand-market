package com.market.product;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.market.global.config.RedisManager;
import com.market.global.exception.CustomException;
import com.market.global.exception.GlobalErrorCode;
import com.market.global.exception.ProductErrorCode;
import com.market.global.util.ValidationUtil;

/**
 * 상품 비즈니스 로직. 소유자 검증/조회수·랭킹 연동은 여기서 처리하고 SQL은 ProductDAO에 위임한다.
 */
public class ProductService {

    private static final Logger log = LoggerFactory.getLogger(ProductService.class);

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    /** 상품 목록. keyword(검색)·categoryId(분류)·lat/lng(내 좌표 → 거리순 정렬) 선택 필터. */
    public List<ProductDTO> getProducts(String keyword, Long categoryId, Double lat, Double lng) {
        try {
            return productDAO.findAll(keyword, categoryId, lat, lng);
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 카테고리 전체 (등록 폼·목록 필터용) */
    public List<CategoryDTO> getCategories() {
        try {
            return categoryDAO.findAll();
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** id 목록으로 상품 조회 (장바구니용). 삭제됐거나 없는 건 건너뛴다. */
    public List<ProductDTO> getProductsByIds(java.util.Collection<Long> ids) {
        List<ProductDTO> list = new ArrayList<>();
        if (ids == null) return list;
        try {
            for (Long id : ids) {
                ProductDTO p = productDAO.findById(id);
                if (p != null) list.add(p);
            }
            return list;
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** Redis 인기 랭킹 상위 상품 목록 (Redis 장애 시 빈 목록) */
    public List<ProductDTO> getPopularProducts(int count) {
        try {
            List<ProductDTO> popular = new ArrayList<>();
            for (Long id : RedisManager.getTopProductIds(count)) {
                ProductDTO p = productDAO.findById(id);
                if (p != null) popular.add(p);
            }
            return popular;
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 상품 상세 조회. 영속 조회수(PostgreSQL)와 실시간 랭킹(Redis)을 함께 갱신한다. 없으면 P001 */
    public ProductDTO getProductDetail(long id) {
        try {
            ProductDTO product = productDAO.findById(id);
            if (product == null) {
                throw new CustomException(ProductErrorCode.PRODUCT_NOT_FOUND);
            }
            productDAO.increaseViewCount(id);
            RedisManager.incrementProductRank(id);
            product.setViewCount(product.getViewCount() + 1); // 화면 표시용 보정
            product.setImages(productDAO.findImageUrls(id)); // 상세 갤러리용 전체 사진
            return product;
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 상품 등록. 검증 실패 시 G001. imageUrls의 첫 장이 대표 사진(thumbnail), 전체는 product_images에 저장. */
    public void write(long userId, ProductDTO product, List<String> imageUrls) {
        ValidationUtil.validateRequired(product.getTitle(), "title");
        ValidationUtil.validatePositive(product.getPrice(), "price");
        try {
            product.setUserId(userId);
            if (imageUrls != null && !imageUrls.isEmpty()) {
                product.setThumbnail(imageUrls.get(0)); // 첫 장을 대표 사진으로
            }
            long productId = productDAO.insert(product);
            productDAO.insertImages(productId, imageUrls);
            log.info("상품 등록: userId={}, title={}, 사진 {}장", userId, product.getTitle(),
                    imageUrls == null ? 0 : imageUrls.size());
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 수정 폼용 조회. 소유자가 아니면 P002. 조회수는 올리지 않는다. */
    public ProductDTO getForEdit(long loginUserId, long productId) {
        try {
            ProductDTO product = verifyOwner(loginUserId, productId);
            product.setImages(productDAO.findImageUrls(productId));
            return product;
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 상품 수정. 소유자가 아니면 P002. form에는 id와 수정할 필드들이 담긴다. */
    public void update(long loginUserId, ProductDTO form) {
        ValidationUtil.validateRequired(form.getTitle(), "title");
        ValidationUtil.validatePositive(form.getPrice(), "price");
        try {
            ProductDTO product = verifyOwner(loginUserId, form.getId());
            product.setTitle(form.getTitle());
            product.setDescription(form.getDescription());
            product.setPrice(form.getPrice());
            product.setStatus(form.getStatus());
            product.setThumbnail(form.getThumbnail());
            productDAO.update(product);
            log.info("상품 수정: productId={}, userId={}", form.getId(), loginUserId);
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 상품 삭제(소프트). 소유자가 아니면 P002. 랭킹에서도 제거한다. */
    public void delete(long loginUserId, long productId) {
        try {
            verifyOwner(loginUserId, productId);
            productDAO.delete(productId);
            RedisManager.removeProductRank(productId);
            log.info("상품 삭제: productId={}, userId={}", productId, loginUserId);
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 로그인 사용자가 상품 소유자인지 검증하고 상품을 반환한다. */
    private ProductDTO verifyOwner(long loginUserId, long productId) throws SQLException {
        ProductDTO product = productDAO.findById(productId);
        if (product == null) {
            throw new CustomException(ProductErrorCode.PRODUCT_NOT_FOUND);
        }
        if (product.getUserId() != loginUserId) {
            log.warn("권한 없는 상품 접근 시도: userId={}, productId={}", loginUserId, productId);
            throw new CustomException(ProductErrorCode.NOT_OWNER);
        }
        return product;
    }
}
