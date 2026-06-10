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

    /** 전체 상품 목록 (최신순) */
    public List<ProductDTO> getProducts() {
        try {
            return productDAO.findAll();
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
            return product;
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 상품 등록. 검증 실패 시 G001 */
    public void write(long userId, ProductDTO product) {
        ValidationUtil.validateRequired(product.getTitle(), "title");
        ValidationUtil.validatePositive(product.getPrice(), "price");
        try {
            product.setUserId(userId);
            productDAO.insert(product);
            log.info("상품 등록: userId={}, title={}", userId, product.getTitle());
        } catch (SQLException e) {
            throw new CustomException(GlobalErrorCode.DATABASE_ERROR, e);
        }
    }

    /** 상품 수정. 소유자가 아니면 P002 */
    public void update(long loginUserId, long productId, String title, String description,
                       int price, String status, String thumbnail) {
        ValidationUtil.validateRequired(title, "title");
        ValidationUtil.validatePositive(price, "price");
        try {
            ProductDTO product = verifyOwner(loginUserId, productId);
            product.setTitle(title);
            product.setDescription(description);
            product.setPrice(price);
            product.setStatus(status);
            product.setThumbnail(thumbnail);
            productDAO.update(product);
            log.info("상품 수정: productId={}, userId={}", productId, loginUserId);
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
