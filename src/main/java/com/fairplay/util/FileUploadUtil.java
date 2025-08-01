package com.fairplay.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUploadUtil {

    // 파일이 저장될 절대 경로
    private final String uploadPath = "C:/upload/";

    // 실제 파일 저장 및 이름 반환
    public String saveFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        try {
            String originalFileName = file.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String newFileName = uuid + "_" + originalFileName;

            File destination = new File(uploadPath + newFileName);
            file.transferTo(destination);

            return newFileName;
        } catch (IOException e) {
            throw new RuntimeException("파일 저장 중 오류 발생", e);
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
