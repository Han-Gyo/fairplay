package com.fairplay.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Schedule;

@Repository
public class ScheduleRepositoryImpl implements ScheduleRepository {

    @Autowired
    private JdbcTemplate template;

    @Override
    public void insert(Schedule schedule) {
        String sql = """
            INSERT INTO schedule (member_id, group_id, title, memo, schedule_date, visibility)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        template.update(sql,
            schedule.getMemberId(),
            schedule.getGroupId() == 0 ? null : schedule.getGroupId(),
            schedule.getTitle(),
            schedule.getMemo(),
            schedule.getScheduleDate(),
            schedule.getVisibility().toLowerCase() 
        );
    }

    @Override
    public List<Schedule> findByRange(int memberId, int groupId, String start, String end) {
      String sql = """
        SELECT s.*, g.name AS group_name 
        FROM schedule s
        LEFT JOIN `group` g ON s.group_id = g.id
        WHERE ( 
            (s.member_id = ? AND s.visibility = 'private') 
            OR 
            (s.group_id IN (SELECT group_id FROM group_member WHERE member_id = ?) AND s.visibility = 'group') 
        )
        AND s.schedule_date BETWEEN ? AND ?
        ORDER BY s.schedule_date ASC
      """;

      return template.query(sql, (rs, rowNum) -> {
        Schedule s = new Schedule();
        s.setId(rs.getInt("id"));
        s.setMemberId(rs.getInt("member_id"));
        s.setGroupId(rs.getInt("group_id"));
        s.setGroupName(rs.getString("group_name"));
        s.setTitle(rs.getString("title"));
        s.setMemo(rs.getString("memo"));
        s.setScheduleDate(rs.getString("schedule_date"));
        s.setVisibility(rs.getString("visibility"));
        return s;
      }, memberId, memberId, start, end);
    }

    @Override
    public void update(Schedule schedule) {
        String sql = """
            UPDATE schedule 
            SET title = ?, 
                memo = ?, 
                schedule_date = ?, 
                visibility = ?
            WHERE id = ?
        """;
        
        template.update(sql,
            schedule.getTitle(),
            schedule.getMemo(),
            schedule.getScheduleDate(),
            schedule.getVisibility().toLowerCase(),
            schedule.getId()
        );
    }

		@Override
    public void delete(int id) {
        String sql = "DELETE FROM schedule WHERE id = ?";
        template.update(sql, id);
    }
}