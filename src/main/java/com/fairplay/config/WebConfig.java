package com.fairplay.config;

import java.util.List;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@Configuration	// 스프링 설정 클래스임을 명시
@EnableWebMvc  // 빠지면 적용 안 됨
public class WebConfig implements WebMvcConfigurer {

	// 정적 리소스 매핑
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	// 브라우저에서 /upload/** 요청 → 실제 C:/upload/ 경로에서 파일을 제공함
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///C:/upload/"); // 마지막에 꼭 있어야 함
        
        registry.addResourceHandler("/resources/**")
        .addResourceLocations("/resources/");  // /webapp/resources/
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
