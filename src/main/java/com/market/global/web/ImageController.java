package com.market.global.web;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import com.market.global.config.AppConfig;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 업로드된 매물 사진을 외부 폴더(upload.dir)에서 읽어 /images/{파일명} 으로 서빙한다.
 * DB에는 경로(/images/{파일명})만 저장되고, 실제 파일은 앱 바깥 폴더에 있다 (실서비스의 오브젝트 스토리지 역할의 축소판).
 */
@WebServlet("/images/*")
public class ImageController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo(); // 예: /abc.jpg
        if (pathInfo == null || pathInfo.length() <= 1) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File baseDir = new File(AppConfig.get("upload.dir"));
        File file = new File(baseDir, pathInfo.substring(1));

        // 경로 조작(../) 방어: 정규화 경로가 업로드 폴더 안에 있는지 검사
        if (!file.getCanonicalPath().startsWith(baseDir.getCanonicalPath() + File.separator)
                || !file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = getServletContext().getMimeType(file.getName());
        resp.setContentType(mime != null ? mime : "application/octet-stream");
        resp.setContentLengthLong(file.length());
        Files.copy(file.toPath(), resp.getOutputStream());
    }
}
