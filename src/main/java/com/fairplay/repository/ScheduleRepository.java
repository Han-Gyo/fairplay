package com.fairplay.repository;

import java.time.LocalDateTime;
import java.util.List;

import com.fairplay.domain.Schedule;

public interface ScheduleRepository {
	void insert(Schedule schedule);
	List<Schedule> findByDate(int id, LocalDateTime start, LocalDateTime end);
}
