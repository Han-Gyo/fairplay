package com.fairplay.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
@EnableScheduling   // 스케줄링 활성화
public class SchedulingConfig {
    // 별도의 Bean 설정은 필요 없음
    // @Scheduled 메서드가 있는 Service 클래스들이 자동으로 실행 대상이 됩니다.
}