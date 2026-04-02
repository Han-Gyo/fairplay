package com.fairplay.config;

import java.util.List;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@Configuration    // 스프링 설정 클래스임을 명시
public class WebConfig implements WebMvcConfigurer {

    // 정적 리소스 매핑
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        
        // OS 환경에 따른 업로드 경로 동적 설정 (AWS 배포 대비)
        String os = System.getProperty("os.name").toLowerCase();
        String uploadPath;
        String profilePath;

        if (os.contains("win")) {
            // 로컬 윈도우 환경
            uploadPath = "file:///C:/upload/";
            profilePath = "file:///C:/upload/profile/";
        } else {
            // AWS 리눅스 환경 (EC2 등) - /home/ubuntu/upload 등
            // 관리자 권한 문제가 없는 사용자 홈 디렉토리 하위를 권장
            uploadPath = "file:/home/ubuntu/upload/";
            profilePath = "file:/home/ubuntu/upload/profile/";
        }

        // 최종 경로는 /upload/ -> 설정된 경로에서 파일 찾음
        // /** 와일드카드를 추가하여 하위 파일 접근 허용
        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath);

        registry.addResourceHandler("/upload/profile/**")
                .addResourceLocations(profilePath);

        // 나머지는 그대로 유지
        // 리소스도 하위 폴더 인식을 위해 /** 권장
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
    }
    
    @Override
    public void extendMessageConverters(List<org.springframework.http.converter.HttpMessageConverter<?>> converters) {
        for (org.springframework.http.converter.HttpMessageConverter<?> converter : converters) {
            if (converter instanceof MappingJackson2HttpMessageConverter) {
                ObjectMapper objectMapper = ((MappingJackson2HttpMessageConverter) converter).getObjectMapper();
                objectMapper.registerModule(new JavaTimeModule()); // LocalDateTime 매핑 가능
            }
        }
    }
}