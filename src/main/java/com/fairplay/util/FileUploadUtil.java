package com.fairplay.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUploadUtil {

    // 프로필 이미지 저장 경로 (C:/upload/)
    @Value("${upload.path}")
    private String uploadPath;

    // 하위 폴더(subDir)를 파라미터로 받아 유연하게 저장하는 메서드 추가
    public String saveFile(MultipartFile file, String subDir) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        try {
            // 루트 경로와 하위 폴더(profile/)를 합침
            String finalPath = uploadPath + subDir;
            
            // 저장 경로 폴더가 없으면 생성하는 로직 추가 (안정성 강화)
            File uploadDir = new File(finalPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 파일명 정제 (한글, 특수문자 제거 → URL 오류 방지)
            String originalFileName = file.getOriginalFilename();
            String safeFileName = originalFileName.replaceAll("[^a-zA-Z0-9.]", "_");

            String uuid = UUID.randomUUID().toString();
            String newFileName = uuid + "_" + safeFileName;

            // 최종 경로(finalPath)를 사용하여 파일 객체 생성
            File destination = new File(finalPath, newFileName);
            file.transferTo(destination);

            return newFileName;
        } catch (IOException e) {
            // 디버깅을 위해 에러 로그 출력
            e.printStackTrace();
            return null;
        }
    }

    // 실제 파일 저장 및 새 파일명 반환 (기존 메서드 호환성 유지)
    public String saveFile(MultipartFile file) {
        return saveFile(file, "");
    }

    // 기존 파일 삭제 시에도 하위 폴더를 고려하도록 수정 가능
    public void deleteFile(String fileName) {
        if (fileName == null) return;

        File file = new File(uploadPath + fileName);
        if (file.exists()) {
            file.delete();
        }
    }
    
    // 하위 폴더 경로를 포함한 삭제 메서드
    public void deleteFile(String fileName, String subDir) {
        if (fileName == null) return;

        File file = new File(uploadPath + subDir + fileName);
        if (file.exists()) {
            file.delete();
        }
    }
}