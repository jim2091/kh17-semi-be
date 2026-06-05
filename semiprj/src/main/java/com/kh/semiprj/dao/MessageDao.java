package com.kh.semiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.MessageDto;
import com.kh.semiprj.mapper.MessageMapper;

@Repository
public class MessageDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private MessageMapper messageMapper;
	//검색 허용 컬럼
	private Set<String> allowList = Set.of(
			"message_title", "message_sender", "messege_receiver", "title_content");
	
	//1. 등록 메소드
	public long sequence() {
		String sql = "selecet message_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, long.class);
	}
	public void insert(MessageDto messageDto) {
		String sql = "insert into message("
						+ "message_no, message_sender, "
						+ "messege_receiver, message_title "
						+ "message_content, message_wtime"
					+ ") values(?, ?, ?, ?, ?, ?)";
		Object[] params = {
				messageDto.getMessageNo(), messageDto.getMessageSender(),
				messageDto.getMessageReceiver(), messageDto.getMessageTitle(),
				messageDto.getMessageContent(), messageDto.getMessageWtime()};
		jdbcTemplate.update(sql, params);
	}
	
	//2. 수정 메소드
	//- 쪽지 읽음 처리
	public boolean updateRead(long messageNo) {
		String sql = "update message set "
					+ "message_read = 'Y' "
					+ "where message_no = ?";
		Object[] params = {messageNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//3. 목록 및 검색 메소드
	//(3-1) 받은 쪽지함
	public List<MessageDto> selectReceiveList(String messageReceiver, int page, int size) {
		String sql = "select * from ("
						+ "select rownum RN, TMP.* FROM ("
							+ "select * from message_list "
							+ "where message_receiver = ? "
							+ "order by message_no desc"
						+ ")TMP"
					+ ") where RN between ? and ?";
		int baginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = {messageReceiver, baginRow, endRow};
		return jdbcTemplate.query(sql, messageMapper, params);	
	}
	
	//(3-2) 보낸 쪽지함
	public List<MessageDto> selectSendList(String messageSender, int page, int size) {
	    String sql = "select * from ("
			    		+ "select rownum RN, TMP.* FROM ("
			    			+ "select * from message_list "
			    			+ "where message_sender = ? "
			    			+ "order by message_no desc"
			    		+ ")TMP"
			    	+ ") where RN between ? and ?";
	    int baginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = {messageSender, baginRow, endRow};
		return jdbcTemplate.query(sql, messageMapper, params);	
	}
	
	//목록과 검색의 상황별 카운트 메소드
	public int countReceiveList(String messageReceiver) {
	    String sql = "select count(*) from message "
	               + "where message_receiver = ?";
	    Object[] params = {messageReceiver};
	    return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	public int countSendList(String messageSender) {
	    String sql = "select count(*) from message "
	               + "where message_sender = ?";
	    Object[] params = {messageSender};
	    return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	public int countUnread(String messageReceiver) {
	    String sql = "select count(*) from message "
	               + "where message_receiver = ? "
	               + "and message_read = 'Y'";
	    Object[] params = {messageReceiver};
	    return jdbcTemplate.queryForObject(sql, int.class, params);
	}
}
