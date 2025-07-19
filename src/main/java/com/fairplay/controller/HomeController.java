package com.fairplay.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

<<<<<<< HEAD
    @GetMapping("/") // 루트 요청 처리
    public String home() {
        return "home";    // /WEB-INF/views/index.jsp 로 이동
    }
}
=======
	@GetMapping("/") // 루트 요청 처리
	public String home() {
		return "home";	// /WEB-INF/views/index.jsp 로 이동
	}
}
>>>>>>> 624f70e5a388df436b1783b856ef3d33a869a48a
