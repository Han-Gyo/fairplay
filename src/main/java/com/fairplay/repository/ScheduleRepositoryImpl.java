package com.fairplay.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Schedule;
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

	        System.out.println("일정 등록 데이터 확인:");
	        System.out.println("memberId: " + schedule.getMemberId());
	        System.out.println("groupId: " + schedule.getGroupId());
	        System.out.println("title: " + schedule.getTitle());
	        System.out.println("memo: " + schedule.getMemo());
	        System.out.println("start: " + schedule.getStartDate());
	        System.out.println("end: " + schedule.getEndDate());
	        System.out.println("visibility: " + schedule.getVisibility());
	        
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
    
    @Override
    public List<Schedule> findByDate(int memberId, LocalDateTime start, LocalDateTime end) {
        String sql = "SELECT * FROM schedule WHERE member_id = ? AND DATE(start_date) = ?";

        return template.query(sql, new Object[]{memberId, start, end}, new ScheduleRowMapper());
    }
    
    public class ScheduleRowMapper implements RowMapper<Schedule> {
        @Override
        public Schedule mapRow(ResultSet rs, int rowNum) throws SQLException {
            Schedule s = new Schedule();
            s.setMemberId(rs.getInt("member_id"));
            s.setGroupId(rs.getInt("group_id"));
            s.setTitle(rs.getString("title"));
            s.setMemo(rs.getString("memo"));
            s.setStartDate(rs.getTimestamp("start_date").toLocalDateTime());
            s.setEndDate(rs.getTimestamp("end_date").toLocalDateTime());
            s.setVisibility(rs.getString("visibility"));
            return s;
        }
    }

}
