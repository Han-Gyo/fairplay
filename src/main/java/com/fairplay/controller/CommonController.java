package com.fairplay.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CommonController {

    @GetMapping("/access-denied")
    public String showAccessDeniedPage() {
        return "access-denied"; 
    }

}
