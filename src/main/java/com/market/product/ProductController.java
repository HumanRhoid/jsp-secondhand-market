package com.market.product;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.market.global.config.AppConfig;
import com.market.global.exception.CustomException;
import com.market.global.exception.GlobalErrorCode;
import com.market.user.SessionUser;
import com.market.user.UserService;

/**
 * 상품 Servlet. 요청 파라미터 추출과 응답(forward/redirect)만 담당하고
 * 비즈니스 로직(소유자 검증, 조회수/랭킹)은 ProductService에 위임한다 (MVC2).
 * 사진 업로드를 위해 multipart/form-data를 처리한다 (파일은 외부 폴더 저장, DB엔 경로만).
 */
@WebServlet("/product/*")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB 넘으면 디스크에 버퍼
        maxFileSize = 10L * 1024 * 1024,      // 파일 1개 최대 10MB
        maxRequestSize = 50L * 1024 * 1024)   // 요청 전체 최대 50MB
public class ProductController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final transient ProductService productService = new ProductService();
    private final transient UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            case "/", "/list" -> list(req, resp);
            case "/detail"    -> detail(req, resp);
            case "/form"      -> formPage(req, resp); // LoginCheckFilter가 보호
            case "/edit"      -> editForm(req, resp); // LoginCheckFilter가 보호
            default           -> resp.sendRedirect(req.getContextPath() + "/product/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
        switch (path) {
            // 아래 셋은 LoginCheckFilter가 보호
            case "/write"  -> write(req, resp);
            case "/update" -> update(req, resp);
            case "/delete" -> delete(req, resp);
            default        -> resp.sendRedirect(req.getContextPath() + "/product/");
        }
    }

    // 상품 목록 + 검색(q) + 카테고리 필터(category) + Redis 인기 랭킹 TOP 4
    private void list(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("q");
        Long categoryId = null;
        String cat = req.getParameter("category");
        if (cat != null && !cat.isBlank()) {
            categoryId = parseLong(cat);
        }
        req.setAttribute("products", productService.getProducts(keyword, categoryId));
        req.setAttribute("categories", productService.getCategories());
        req.setAttribute("popular", productService.getPopularProducts(4));
        req.setAttribute("q", keyword);                 // 검색어 유지
        req.setAttribute("selectedCategory", categoryId); // 선택 카테고리 유지
        req.getRequestDispatcher("/WEB-INF/views/product/main.jsp").forward(req, resp);
    }

    // 등록 폼 (카테고리 목록 전달)
    private void formPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("categories", productService.getCategories());
        req.getRequestDispatcher("/WEB-INF/views/product/form.jsp").forward(req, resp);
    }

    private void detail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        ProductDTO product = productService.getProductDetail(parseLong(req.getParameter("id")));
        req.setAttribute("product", product);
        req.setAttribute("seller", userService.findById(product.getUserId()));
        req.getRequestDispatcher("/WEB-INF/views/product/detail.jsp").forward(req, resp);
    }

    // 수정 폼: 소유자 검증 후 기존 상품 정보를 실어 edit.jsp로 forward
    private void editForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        SessionUser loginUser = SessionUser.current(req);
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }
        ProductDTO product = productService.getForEdit(loginUser.getId(), parseLong(req.getParameter("id")));
        req.setAttribute("product", product);
        req.getRequestDispatcher("/WEB-INF/views/product/edit.jsp").forward(req, resp);
    }

    private void write(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        SessionUser loginUser = SessionUser.current(req);
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }
        ProductDTO product = new ProductDTO();
        product.setTitle(req.getParameter("title"));
        product.setDescription(req.getParameter("description"));
        product.setPrice((int) parseLong(req.getParameter("price")));
        product.setCategoryId(parseLong(req.getParameter("category"))); // 0이면 미분류
        List<String> photoPaths = savePhotos(req); // 업로드 사진들 저장 후 경로(/images/...) 목록, 없으면 빈 목록
        try {
            productService.write(loginUser.getId(), product, photoPaths);
        } catch (CustomException e) {
            if (e.getErrorCode() != GlobalErrorCode.INVALID_INPUT) throw e;
            // 검증 실패 → 등록 폼으로 되돌림
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/product/form.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/product/");
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        SessionUser loginUser = SessionUser.current(req);
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }
        ProductDTO form = new ProductDTO();
        form.setId(parseLong(req.getParameter("id")));
        form.setTitle(req.getParameter("title"));
        form.setDescription(req.getParameter("description"));
        form.setPrice((int) parseLong(req.getParameter("price")));
        form.setStatus(req.getParameter("status"));
        List<String> newPhotos = savePhotos(req);
        // 새 사진을 올렸으면 대표 사진 교체, 아니면 기존 경로(hidden 필드 currentThumbnail) 유지
        form.setThumbnail(!newPhotos.isEmpty() ? newPhotos.get(0) : req.getParameter("currentThumbnail"));
        productService.update(loginUser.getId(), form);
        resp.sendRedirect(req.getContextPath() + "/product/detail?id=" + form.getId());
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        SessionUser loginUser = SessionUser.current(req);
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }
        productService.delete(loginUser.getId(), parseLong(req.getParameter("id")));
        resp.sendRedirect(req.getContextPath() + "/product/");
    }

    /**
     * 업로드된 사진들(part name="photos")을 외부 폴더(upload.dir)에 UUID 파일명으로 저장하고
     * 화면에서 접근할 경로(/images/{파일명}) 목록을 반환한다. 업로드가 없으면 빈 목록.
     */
    private List<String> savePhotos(HttpServletRequest req) throws ServletException, IOException {
        List<String> paths = new ArrayList<>();
        File dir = new File(AppConfig.get("upload.dir"));
        if (!dir.exists()) {
            dir.mkdirs();
        }
        for (Part part : req.getParts()) {
            if (!"photos".equals(part.getName()) || part.getSize() == 0) {
                continue; // 사진 파트가 아니거나 빈 파일
            }
            String submitted = part.getSubmittedFileName();
            String ext = "";
            int dot = submitted == null ? -1 : submitted.lastIndexOf('.');
            if (dot >= 0) {
                ext = submitted.substring(dot).toLowerCase();
            }
            String filename = UUID.randomUUID() + ext;
            part.write(new File(dir, filename).getAbsolutePath());
            paths.add("/images/" + filename);
        }
        return paths;
    }

    private long parseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (Exception e) {
            return 0;
        }
    }
}
