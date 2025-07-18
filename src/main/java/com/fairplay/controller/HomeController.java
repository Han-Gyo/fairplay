package com.fairplay.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/") // 루트 요청 처리
    public String home() {
        return "home";    // /WEB-INF/views/index.jsp 로 이동
    }
}