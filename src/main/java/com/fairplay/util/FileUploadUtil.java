package com.fairplay.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUploadUtil {

    // 프로필 이미지 저장 경로 (config-local.properties의 값을 읽어옴)
    @Value("${upload.path}")
    private String uploadPath;

    // 하위 폴더(subDir)를 파라미터로 받아 유연하게 저장하는 메서드
    public String saveFile(MultipartFile file, String subDir) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        try {
            // 경로 사이에 슬래시(/)가 누락되지 않도록 File 객체를 활용해 경로 병합
            File uploadDir = new File(uploadPath, subDir);
            
            // 저장 경로 폴더가 없으면 생성 (C:/upload/profile/ 형태)
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 파일명 정제 (한글, 특수문자 제거 → URL 오류 방지)
            String originalFileName = file.getOriginalFilename();
            String safeFileName = originalFileName.replaceAll("[^a-zA-Z0-9.]", "_");

            String uuid = UUID.randomUUID().toString();
            String newFileName = uuid + "_" + safeFileName;

            // 최종 파일 객체 생성 및 저장
            File destination = new File(uploadDir, newFileName);
            file.transferTo(destination);

            // DB에는 파일명만 저장하지만, 나중에 불러올 때 'profile/파일명' 구조가 되어야 함
            return newFileName; 
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    // 실제 파일 저장 및 새 파일명 반환 (기존 메서드 호환성 유지)
    public String saveFile(MultipartFile file) {
        return saveFile(file, "");
    }

    // 기존 파일 삭제
    public void deleteFile(String fileName) {
        if (fileName == null) return;
        File file = new File(uploadPath, fileName);
        if (file.exists()) {
            file.delete();
        }
    }
    
    // 하위 폴더 경로를 포함한 삭제 메서드
    public void deleteFile(String fileName, String subDir) {
        if (fileName == null) return;
        // 삭제 시에도 경로 병합을 안전하게 처리
        File dir = new File(uploadPath, subDir);
        File file = new File(dir, fileName);
        
        if (file.exists()) {
            file.delete();
        }
    }
}