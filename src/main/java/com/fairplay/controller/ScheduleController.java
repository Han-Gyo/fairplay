package com.fairplay.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fairplay.domain.Member;
import com.fairplay.domain.Schedule;
import com.fairplay.service.ScheduleService;

@Controller
@RequestMapping("/schedule")
public class ScheduleController {
	
	@Autowired
	private ScheduleService scheduleService;
	
	// 일정 등록 처리용
	@PostMapping("/create")
	@ResponseBody
	public String createSchedule(@RequestBody Schedule schedule,
	                             HttpSession session) {

	    // 세션에서 로그인 사용자 확인 (예시)
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "unauthorized";
	    }

	    // DTO 값 이용해서 DB 저장 로직
	    schedule.setMemberId(loginMember.getId());
	    scheduleService.create(schedule);

	    return "success";  // JS에서 이 값을 받음
	}

}

