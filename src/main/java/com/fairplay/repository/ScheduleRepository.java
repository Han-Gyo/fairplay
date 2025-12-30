package com.fairplay.repository;

import java.util.List;
import com.fairplay.domain.Schedule;

public interface ScheduleRepository {

  void insert(Schedule schedule); // 일정 저장
  void delete(int id); 						// 일정 삭제
  void update(Schedule schedule); 
  List<Schedule> findByRange(int memberId, int groupId, String start, String end); // 달력 범위 내 일정 조회 (내 일정 + 내가 속한 그룹 일정)
}
