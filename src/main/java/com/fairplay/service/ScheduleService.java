package com.fairplay.service;

import java.util.List;
import com.fairplay.domain.Schedule;

public interface ScheduleService {
	void create(Schedule schedule);
  void deleteSchedule(int id);
  void updateSchedule(Schedule schedule); 
  List<Schedule> getEvents(int memberId, int groupId, String start, String end);
}
