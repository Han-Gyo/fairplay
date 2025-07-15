package com.fairplay.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration	// ✅ 스프링 설정 클래스임을 명시
@EnableWebMvc  // ✅ 빠지면 적용 안 됨
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	// 브라우저에서 /upload/** 요청 → 실제 C:/upload/ 경로에서 파일을 제공함
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///C:/upload/"); // ✅ 마지막에 / 꼭 있어야 함
    }
}
