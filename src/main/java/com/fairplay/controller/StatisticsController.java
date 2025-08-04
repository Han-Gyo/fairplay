package com.fairplay.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fairplay.domain.MemberMonthlyScore;
import com.fairplay.service.HistoryService;

@RestController // JSON 반환용 컨트롤러 (@Controller + @ResponseBody)
@RequestMapping("/statistics")
public class StatisticsController {
	
	@Autowired
	private HistoryService historyService;
	
	// 월별 그룹 점수 통계 JSON 반환
	@GetMapping("/monthly-score")
	public List<MemberMonthlyScore> getMonthlyScore(
			@RequestParam("groupId") int groupId,
			@RequestParam("yearMonth") String yearMonth) {
		
		// 예: yearMonth = "2025-07"
		return historyService.getMemberMonthlyScore(groupId, yearMonth);
	}						  
			
}
