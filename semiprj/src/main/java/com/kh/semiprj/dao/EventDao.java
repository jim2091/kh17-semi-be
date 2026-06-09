package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.EventDto;
import com.kh.semiprj.mapper.EventMapper;

@Repository
public class EventDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private EventMapper eventMapper;
	

	public List<EventDto> selectList(){
	    String sql = "select "
	                + "event_no, event_origin, event_title, "
	                + "event_category, event_content, event_start, event_end, event_option "
	               + "from event "
	               + "order by event_no desc";
	    
	    return jdbcTemplate.query(sql, eventMapper);
	}
	public void insertEvent(EventDto eventDto) {
		String sql = "insert into event("
					+ "event_no, event_origin, event_title, event_category, "
					+ "event_content, event_start, event_end, event_option) "
					+ "values("
					+ "event_seq.nextval, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {eventDto.getEventOrigin(), 
							eventDto.getEventTitle(), eventDto.getEventCategory(), 
							eventDto.getEventContent(), eventDto.getEventStart(), 
							eventDto.getEventEnd(), eventDto.getEventOption()};
		
		jdbcTemplate.update(sql, params);
	}
	
	public int sequence() {
		String sql = "select event_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	public boolean update(EventDto eventDto) {

	    String sql = "update event set event_title = ?, "
	    				+ "event_content = ?, event_start = ?, event_end = ?, "
	    				+ "event_category = ?, event_option=? where event_no = ?";
	    		

	    Object[] params = {
	    		eventDto.getEventTitle(), eventDto.getEventContent(), 
		        eventDto.getEventStart(), eventDto.getEventEnd(), 
		        eventDto.getEventCategory(),  
		        eventDto.getEventOption(), eventDto.getEventNo()
	    };
	    	
	    
	    
	    return	jdbcTemplate.update(sql, params) >0;
	}
	
	public boolean delete(int eventNo) {

	    String sql = "delete event where event_no = ?";

	    Object[] params = {eventNo};

	    return jdbcTemplate.update(sql, params) > 0;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}
