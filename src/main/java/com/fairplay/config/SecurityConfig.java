package com.fairplay.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration // 설정 클래스 선언
public class SecurityConfig{
	
	@Bean // 암호화 Bean 등록
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

}
