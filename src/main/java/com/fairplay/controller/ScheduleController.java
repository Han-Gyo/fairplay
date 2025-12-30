package com.fairplay.controller;

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

    // 1. 달력에 뿌릴 일정 데이터 가져오기
    @GetMapping("/events")
    @ResponseBody
    public List<Schedule> getEvents(
            @RequestParam("start") String start,
            @RequestParam("end") String end,
            HttpSession session) {
        
        Member loginMember = (Member) session.getAttribute("loginMember");
        Integer groupId = (Integer) session.getAttribute("currentGroupId");

        if (loginMember == null || groupId == null) {
            return Collections.emptyList();
        }

        return scheduleService.getEvents(loginMember.getId(), groupId, start, end);
    }

    // 2. 일정 등록
    @PostMapping("/create")
    public ResponseEntity<String> createSchedule(@RequestBody Schedule schedule, HttpSession session) {
        Member loginMember = (Member) session.getAttribute("loginMember");
        Integer groupId = (Integer) session.getAttribute("currentGroupId");

        if (loginMember == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        schedule.setMemberId(loginMember.getId());
        schedule.setGroupId(groupId != null ? groupId : 0);

        try {
            scheduleService.create(schedule);
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
        } 
    }
    // 3. 일정 수정 (POST) - 추가된 부분! 🔥
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<String> updateSchedule(@RequestBody Schedule schedule, HttpSession session) {
        Member loginMember = (Member) session.getAttribute("loginMember");
        
        if (loginMember == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("unauthorized");
        }

        try {
            // Service에 update(Schedule schedule) 메서드 추가 필요!
            scheduleService.updateSchedule(schedule); 
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
        }
    }
    // 4. 일정 삭제
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> deleteSchedule(@RequestParam("id") int id) {
        try {
            scheduleService.deleteSchedule(id);
            return ResponseEntity.ok("success"); 
        } catch (Exception e) {
            e.printStackTrace(); 
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
        }
    }
    
}