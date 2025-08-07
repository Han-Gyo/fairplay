package com.fairplay.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fairplay.domain.GroupMonthlyScore;
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
	
	
	// 특정 그룹의 월간 총점 1개 조회
	@GetMapping("/group-monthly-total")
	public GroupMonthlyScore getGroupMonthlyTotal(
		@RequestParam("groupId") int groupId,
		@RequestParam("yearMonth") String yearMonth) {

		System.out.println("📌 [Controller] 그룹 월간 총점 요청");
		System.out.println("    ▶ groupId: " + groupId);
		System.out.println("    ▶ yearMonth: " + yearMonth);

		List<GroupMonthlyScore> results = historyService.getGroupMonthlyScore(groupId, yearMonth);
		
		if (results.isEmpty()) {
			GroupMonthlyScore empty = new GroupMonthlyScore();
			empty.setGroupId(groupId);
			empty.setYearMonth(yearMonth);
			empty.setTotalScore(0);
			empty.setGroupName("점수 없음");
			return empty;
		}

		return results.get(0);
	}

	

}
