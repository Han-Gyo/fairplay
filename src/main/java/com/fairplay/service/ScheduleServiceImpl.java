package com.fairplay.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Schedule;
import com.fairplay.repository.ScheduleRepository;

@Service
public class ScheduleServiceImpl implements ScheduleService{

	@Autowired
	private ScheduleRepository scheduleRepository;
	@Override
	public void create(Schedule schedule) {
		System.out.println("일정 등록 서비스 시작");
		scheduleRepository.insert(schedule);
	}
	
	@Override
	public List<Schedule> findByDate(int id, LocalDateTime start, LocalDateTime end) {
	    return scheduleRepository.findByDate(id, start, end);
	}
	
}
