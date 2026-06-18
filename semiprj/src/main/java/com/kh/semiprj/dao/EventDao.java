package com.kh.semiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.EventDto;
import com.kh.semiprj.mapper.EventMapper;
import com.kh.semiprj.vo.PageVO;

@Repository
public class EventDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EventMapper eventMapper;
	private Set<String> allowColumns = Set.of("event_title", "event_content");

	public List<EventDto> selectList(String eventOrigin){
	    String sql = "select "
	                + "event_no, event_origin, event_title, "
	                + "event_category, event_content, event_start, event_end, event_option, event_color "
	               + "from event where event_origin = ? or event_category = '사내일정'"
	               + "order by event_no desc";
	    Object[] params = {eventOrigin};
	    
	    return jdbcTemplate.query(sql, eventMapper, params);
	}
	
	public List<EventDto> selectListByUser(String eventOrigin, String column, String keyword){
		if(column == null || keyword == null) return selectList(eventOrigin);
		if(column.isEmpty()||keyword.isEmpty()) return selectList(eventOrigin);

		if(!allowColumns.contains(column)) return List.of();
		String sql = "select * from event "
				+ "where instr("+column+", ?) >0 "
						+ "and event_origin = ? "
						+ "order by "+column+" asc, event_no desc";
		Object[] params = {keyword, eventOrigin};
		return jdbcTemplate.query(sql, eventMapper, params);
	}
	
	//일정 등록
	public void insertEvent(EventDto eventDto) {
		String sql = "insert into event("
					+ "event_no, event_origin, event_title, event_category, "
					+ "event_content, event_start, event_end, event_option, event_color) "
					+ "values("
					+ "event_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {eventDto.getEventOrigin(), 
							eventDto.getEventTitle(), eventDto.getEventCategory(), 
							eventDto.getEventContent(), eventDto.getEventStart(), 
							eventDto.getEventEnd(), eventDto.getEventOption(),
							eventDto.getEventColor()};
		
		jdbcTemplate.update(sql, params);
	}
	
	public int sequence() {
		String sql = "select event_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	//일정 수정
	public boolean update(EventDto eventDto) {
	    String sql = "update event set event_title = ?, "
	    				+ "event_content = ?, event_start = ?, event_end = ?, "
	    				+ "event_option=?, event_color=? where event_no = ?";
	    Object[] params = {
	    		eventDto.getEventTitle(), eventDto.getEventContent(), 
		        eventDto.getEventStart(), eventDto.getEventEnd(), 
		        eventDto.getEventOption(), 
		        eventDto.getEventColor(), eventDto.getEventNo()
	    };
	    return	jdbcTemplate.update(sql, params) >0;
	}
	
	//일정 삭제
	public boolean delete(int eventNo) {
	    String sql = "delete event where event_no = ?";
	    Object[] params = {eventNo};
	    return jdbcTemplate.update(sql, params) > 0;
	}
	
	public List<EventDto> selectListByUser(String eventOrigin){
		String sql = "select * from event where event_origin=? "
						+ "and event_category='개인일정' "
						+ "order by event_start desc";
		Object[] params = {eventOrigin};
		return jdbcTemplate.query(sql, eventMapper, params);
	}
	
	public List<EventDto> selectNewest(String eventOrigin){
		
		String sql = "select * from event where event_origin=? "
						+ "and event_category='개인일정' "
						+ "order by event_no desc";
		Object[] params = {eventOrigin};
		return jdbcTemplate.query(sql, eventMapper, params);
	}
	
	public List<EventDto> selectBySchedule(String eventOrigin){
		
		String sql = "select * from event where event_origin=? "
						+ "and event_category='개인일정' "
						+ "order by event_start asc";
		Object[] params = {eventOrigin};
		return jdbcTemplate.query(sql, eventMapper, params);	
	}
	
	public List<EventDto> selectOldest(String eventOrigin){
		
		String sql = "select * from event where event_origin=? "
						+ "and event_category='개인일정' "
						+ "order by event_no asc";
		Object[] params = {eventOrigin};
		return jdbcTemplate.query(sql, eventMapper, params);	
	}
	
	//오늘 일정 count
	public int countTodayEvent(String empId) {
		String sql = "select count(*) from event "
				+ "where event_start < trunc(sysdate) + 1 and event_end >= trunc(sysdate) "
				+ "and event_origin = ?";
		Object[] params = { empId };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	public List<EventDto> selectTodayEvent(String empId){
		String sql = "select * from event "
				+ "where event_start < trunc(sysdate) + 1 and event_end >= trunc(sysdate) "
				+ "and event_origin = ?";
		Object[] params = { empId };
		return jdbcTemplate.query(sql, eventMapper, params);
	}
	
	//일정 상세
	public EventDto selectOne(int eventNo) {
		String sql = "select e.*, emp.emp_name "
				+ "from event e "
				+ "left join emp on e.event_origin = emp.emp_no "
				+ "where e.event_no = ?";
		Object[] params = {eventNo};
		List<EventDto> list = jdbcTemplate.query(sql, eventMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public int count(String eventOrigin) {
		String sql =
				"select count(*) from event " +
				"where event_origin=? " +
				"or event_category='사내일정'";
		Object[] params = {eventOrigin};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	public int count(String eventOrigin,
			 String column,
			 String keyword) {

	if(!allowColumns.contains(column))
		return 0;
	
	String sql =
			"select count(*) from event " +
			"where instr("+column+", ?) > 0 " +
			"and event_origin=?";
	
	Object[] params = {
			keyword,
			eventOrigin
	};
	
	return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	public List<EventDto> selectListByPage(
	        String eventOrigin,
	        PageVO pageVO){

	    String sql =
	        "select * from ("
	        + " select rownum rn, TMP.* from ("
	        + "   select * from event "
	        + "   where event_origin=? "
	        + "      or event_category='사내일정' "
	        + "   order by event_no desc"
	        + " ) TMP"
	        + ") where rn between ? and ?";

	    Object[] params = {
	        eventOrigin,
	        pageVO.getBeginRownum(),
	        pageVO.getEndRownum()
	    };

	    return jdbcTemplate.query(
	            sql,
	            eventMapper,
	            params
	    );
	}
	
	public List<EventDto> selectSearchByPage(
	        String eventOrigin,
	        String column,
	        String keyword,
	        PageVO pageVO){

	    if(!allowColumns.contains(column))
	        return List.of();

	    String sql =
	        "select * from ("
	        + " select rownum rn, TMP.* from ("
	        + "   select * from event "
	        + "   where instr(" + column + ", ?) > 0 "
	        + "   and event_origin = ? "
	        + "   order by event_no desc"
	        + " ) TMP"
	        + ") where rn between ? and ?";

	    Object[] params = {
	        keyword,
	        eventOrigin,
	        pageVO.getBeginRownum(),
	        pageVO.getEndRownum()
	    };

	    return jdbcTemplate.query(
	            sql,
	            eventMapper,
	            params
	    );
	}
}
