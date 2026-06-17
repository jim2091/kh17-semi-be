package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.EventDto;

@Component
public class EventMapper implements RowMapper<EventDto>{

	@Override
	public EventDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		EventDto eventDto = new EventDto();
		eventDto.setEventNo(rs.getInt("event_no"));
		eventDto.setEventOrigin(rs.getString("event_origin"));
		eventDto.setEventTitle(rs.getString("event_title"));
		eventDto.setEventCategory(rs.getString("event_category"));
		eventDto.setEventContent(rs.getString("event_content"));
		eventDto.setEventStart(rs.getTimestamp("event_start"));
		eventDto.setEventEnd(rs.getTimestamp("event_end"));
		eventDto.setEventOption(rs.getString("event_option"));
		eventDto.setEventColor(rs.getString("event_color"));
		try {
	        eventDto.setEmpName(rs.getString("emp_name"));
	    }
	    catch(SQLException e) {}
		
		return eventDto;
	}
}
