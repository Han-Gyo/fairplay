package com.fairplay.service;

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
		scheduleRepository.insert(schedule);
	}
	
}
