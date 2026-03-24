package com.fairplay.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUploadUtil {

    // 프로필 이미지 저장 경로
    private final String uploadPath = "C:/upload/profile/";

    // 실제 파일 저장 및 새 파일명 반환
    public String saveFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        try {
            // 파일명 정제 (한글, 특수문자 제거 → URL 오류 방지)
            String originalFileName = file.getOriginalFilename();
            String safeFileName = originalFileName.replaceAll("[^a-zA-Z0-9.]", "_");

            String uuid = UUID.randomUUID().toString();
            String newFileName = uuid + "_" + safeFileName;

            File destination = new File(uploadPath + newFileName);
            file.transferTo(destination);

            return newFileName;
        } catch (IOException e) {
            return null;
        }
    }

    // 기존 파일 삭제
    public void deleteFile(String fileName) {
        if (fileName == null) return;

        File file = new File(uploadPath + fileName);
        if (file.exists()) {
            file.delete();
        }
    }
}
