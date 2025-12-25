package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Schedule;
import com.fairplay.repository.ScheduleRepository;

@Service
public class ScheduleServiceImpl implements ScheduleService {

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Override
    public void create(Schedule schedule) {
        System.out.println("[Service] 일정 등록 시작: " + schedule.getTitle());
        scheduleRepository.insert(schedule);
    }

    @Override
    public List<Schedule> getEvents(int memberId, int groupId, String start, String end) {
        List<Schedule> schedules = scheduleRepository.findByRange(memberId, groupId, start, end);
        
        for (Schedule s : schedules) {
            if ("PRIVATE".equals(s.getVisibility())) {
                s.setColor("#20c997"); // 민트 (개인 일정)
            } else if ("GROUP".equals(s.getVisibility())) {
                s.setColor("#6f42c1"); // 보라 (그룹 일정)
            }
        }
        
        return schedules;
    }

    @Override
    public void deleteSchedule(int id) {
        scheduleRepository.delete(id);
    }
}