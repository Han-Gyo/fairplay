package com.fairplay.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration	// ✅ 스프링 설정 클래스임을 명시
public class WebConfig implements WebMvcConfigurer {

	// 정적 리소스 매핑
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // ✅ 최종 경로는 /upload/** → C:/upload/ 에서 파일 찾음
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///C:/upload/");
        
        registry.addResourceHandler("/upload/profile/**")
        .addResourceLocations("file:///C:/upload/profile/");

        // ✅ 나머지는 그대로 유지
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
    }
}
