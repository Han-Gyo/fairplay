package com.fairplay.repository;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Schedule;
import com.fairplay.service.ScheduleService;
@Repository
public class ScheduleRepositoryImpl implements ScheduleRepository{

	private JdbcTemplate template;
	
	@Autowired
	public void setJdbctemplate(DataSource dataSource) {
		this.template = new JdbcTemplate(dataSource);
	}
	
    @Override
    public void insert(Schedule schedule) {
        String sql = "INSERT INTO schedule (member_id, group_id, title, memo, start_date, end_date, visibility) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        	template.update(sql,
            schedule.getMemberId(),
            schedule.getGroupId(),
            schedule.getTitle(),
            schedule.getMemo(),
            schedule.getStartDate(),
            schedule.getEndDate(),
            schedule.getVisibility()
        );
    }
}
