package com.fairplay.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	public ResponseEntity<String> createSchedule(@RequestBody Schedule schedule, HttpSession session) {
	    System.out.println("[ScheduleController] 일정 등록 요청 진입");

	    // 요청 데이터 출력
	    System.out.println("시작일시: " + schedule.getStartDate());
	    System.out.println("종료일시: " + schedule.getEndDate());
	    System.out.println("제목: " + schedule.getTitle());
	    System.out.println("그룹 ID: " + schedule.getGroupId());
	    System.out.println("공개범위: " + schedule.getVisibility());

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        System.out.println("❌ 세션에 로그인 멤버 없음");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("unauthorized");
	    }

	    schedule.setMemberId(loginMember.getId());

	    try {
	        scheduleService.create(schedule);
	        System.out.println("[ScheduleController] 일정 등록 성공");
	        return ResponseEntity.ok("success");
	    } catch (Exception e) {
	        System.out.println("[ScheduleController] 일정 등록 중 오류 발생");
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
	    }
	}
	
	@GetMapping("/by-date")
	@ResponseBody
	public List<Schedule> getSchedulesByDate(@RequestParam String date, HttpSession session) {
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) return Collections.emptyList();

	    LocalDateTime start = LocalDate.parse(date).atStartOfDay();
	    LocalDateTime end = start.withHour(23).withMinute(59).withSecond(59);

	    return scheduleService.findByDate(loginMember.getId(), start, end);
	}


}

