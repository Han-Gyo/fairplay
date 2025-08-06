package com.fairplay.service;

import java.time.LocalDateTime;
import java.util.List;

import com.fairplay.domain.Schedule;

public interface ScheduleService {
	void create(Schedule schedule);
	List<Schedule> findByDate(int id, LocalDateTime start, LocalDateTime end);
}
