package com.kh.semiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.MessageDto;
import com.kh.semiprj.mapper.MessageMapper;
import com.kh.semiprj.vo.PageVO;

@Repository
public class MessageDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private MessageMapper messageMapper;
	//검색 허용 컬럼
	private Set<String> allowList = Set.of(
			"message_title", "sender_name", "receiver_name", "title_content");
	private Set<String> receiveAllowList = Set.of("sender_name", "message_title", "title_content");
	private Set<String> sendAllowList = Set.of("receiver_name", "message_title", "title_content");
	
	//1. 등록 메소드
	public long sequence() {
		String sql = "select message_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, long.class);
	}
	public void insert(MessageDto messageDto) {
		String sql = "insert into message("
						+ "message_no, message_sender, "
						+ "message_receiver, message_title, "
						+ "message_content"
					+ ") values(?, ?, ?, ?, ?)";
		Object[] params = {
				messageDto.getMessageNo(), messageDto.getMessageSender(),
				messageDto.getMessageReceiver(), messageDto.getMessageTitle(),
				messageDto.getMessageContent()};
		jdbcTemplate.update(sql, params);
	}
	
	//2. 수정 메소드
	//(2-1) 쪽지 읽음 처리
	public boolean updateRead(long messageNo) {
		String sql = "update message set "
						+ "message_read = 'Y' "
					+ "where message_no = ?";
		Object[] params = {messageNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//3. 목록 및 검색 메소드
	//(3-1) 받은 쪽지함(사용자)
	public List<MessageDto> selectReceiveList(String messageReceiver, PageVO pageVO) {
		//- 목록
		if(pageVO.isList()) {
			String sql = "select * from ("
							+ "select rownum RN, TMP.* FROM ("
								+ "select * from message_list "
								+ "where message_receiver = ? "
								+ "order by message_no desc"
							+ ")TMP"
						+ ") where RN between ? and ?";
			Object[] params = {messageReceiver, pageVO.getBeginRownum(), pageVO.getEndRownum()};
			return jdbcTemplate.query(sql, messageMapper, params);	
		}
		
		String column = pageVO.getColumn();
		
		//- 제목+내용 검색
		if("title_content".equals(column)) {
			String sql = "select * from ("
		            		+ "select rownum rn, tmp.* from ("
		            			+ "select m.*, "
		            +           "sender.emp_name sender_name, "
		            +           "receiver.emp_name receiver_name "
		            +           "from message m "
		            +           "left outer join emp sender "
		            +           "on m.message_sender = sender.emp_no "
		            +           "left outer join emp receiver "
		            +           "on m.message_receiver = receiver.emp_no "
		            +           "where m.message_receiver = ? "
		            +           "and ("
		            +               "instr(m.message_title, ?) > 0 "
		            +               "or instr(m.message_content, ?) > 0"
		            +           ") "
		            +           "order by m.message_no desc"
		            +       ") tmp"
		            +   ") where rn between ? and ?";
			Object[] params = {messageReceiver, pageVO.getKeyword(), pageVO.getKeyword(),
								pageVO.getBeginRownum(), pageVO.getEndRownum()};
			return jdbcTemplate.query(sql, messageMapper, params);	
		}
		
		if(!receiveAllowList.contains(column)) return List.of();
		
		//- 보낸이, 제목 검색
		String sql = "select * from ("
						+ "select rownum RN, TMP.* FROM ("
							+ "select * from message_list "
							+ "where message_receiver = ? "
							+ "and instr("+column+", ?) > 0 "
							+ "order by message_no desc"
						+ ")TMP"
					+ ") where RN between ? and ?";
		Object[] params = {messageReceiver, pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
		return jdbcTemplate.query(sql, messageMapper, params);
	}
	
	//(3-2) 보낸 쪽지함(사용자)
	public List<MessageDto> selectSendList(String messageSender, PageVO pageVO) {
		//- 목록
		if(pageVO.isList()) {
		    String sql = "select * from ("
				    		+ "select rownum RN, TMP.* FROM ("
				    			+ "select * from message_list "
				    			+ "where message_sender = ? "
				    			+ "order by message_no desc"
				    		+ ")TMP"
				    	+ ") where RN between ? and ?";
			Object[] params = {messageSender, pageVO.getBeginRownum(), pageVO.getEndRownum()};
			return jdbcTemplate.query(sql, messageMapper, params);	
		}
		
		String column = pageVO.getColumn();
		
		//- 제목+내용 검색
		if("title_content".equals(column)) {
			String sql = "select * from ("
		            +       "select rownum rn, tmp.* from ("
		            +           "select m.*, "
		            +           "sender.emp_name sender_name, "
		            +           "receiver.emp_name receiver_name "
		            +           "from message m "
		            +           "left outer join emp sender "
		            +           "on m.message_sender = sender.emp_no "
		            +           "left outer join emp receiver "
		            +           "on m.message_receiver = receiver.emp_no "
		            +           "where m.message_sender = ? "
		            +           "and ("
		            +               "instr(m.message_title, ?) > 0 "
		            +               "or instr(m.message_content, ?) > 0"
		            +           ") "
		            +           "order by m.message_no desc"
		            +       ") tmp"
		            +   ") where rn between ? and ?";
			Object[] params = {messageSender, pageVO.getKeyword(), pageVO.getKeyword(),
								pageVO.getBeginRownum(), pageVO.getEndRownum()};
			return jdbcTemplate.query(sql, messageMapper, params);	
		}
		
		if(!sendAllowList.contains(column)) return List.of();
		
		//- 보낸이, 제목 검색
		String sql = "select * from ("
						+ "select rownum RN, TMP.* FROM ("
							+ "select * from message_list "
							+ "where message_sender = ? "
							+ "and instr("+column+", ?) > 0 "
							+ "order by message_no desc"
						+ ")TMP"
					+ ") where RN between ? and ?";
		Object[] params = {messageSender, pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
		return jdbcTemplate.query(sql, messageMapper, params);
	}
	
	//(3-3) 전체 쪽지 목록(관리자)
	public List<MessageDto> selectAdminList(PageVO pageVO) {
		//- 목록
		if(pageVO.isList()) {
			String sql = "select * from ("
							+ "select rownum RN, TMP.* FROM ("
								+ "select * from message_list "
								+ "order by message_no desc"
							+ ")TMP"
						+ ") where RN between ? and ?";
			Object[] params = {pageVO.getBeginRownum(), pageVO.getEndRownum()};

			return jdbcTemplate.query(sql, messageMapper, params);
		}
		
		//- 제목+내용 검색
		if("title_content".equals(pageVO.getColumn())) {
			String sql = "select * from ("
				      +     "select rownum rn, tmp.* from ("
				      +         "select m.*, "
				      +                "sender.emp_name sender_name, "
				      +                "receiver.emp_name receiver_name "
				      +         "from message m "
				      +         "left outer join emp sender "
				      +         "on m.message_sender = sender.emp_no "
				      +         "left outer join emp receiver "
				      +         "on m.message_receiver = receiver.emp_no "
				      +         "where instr(m.message_title, ?) > 0 "
				      +         "or instr(m.message_content, ?) > 0 "
				      +         "order by m.message_no desc"
				      +     ") tmp"
				      + ") where rn between ? and ?";
			Object[] params = {pageVO.getKeyword(), pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
			return jdbcTemplate.query(sql, messageMapper, params);	
		}
		
		if(!allowList.contains(pageVO.getColumn())) return List.of();
		
		//- 보낸이, 받는이, 제목 검색
		String sql ="select * from ("
						+"select rownum rn, tmp.* from ("
							+"select * from message_list "
							+"where instr("+pageVO.getColumn()+", ?) > 0 "
							+"order by message_no desc"
						+") tmp"
					+") where rn between ? and ?";

		Object[] params = {pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};

		return jdbcTemplate.query(sql, messageMapper, params);
	}
	
	//(3-4) 목록 및 검색의 상황별 카운트 메소드
	//- 받은 쪽지함 카운트
	public int countReceiveList(String messageReceiver, PageVO pageVO) {
	    if(pageVO.isList()) {
			String sql = "select count(*) from message "
		               + "where message_receiver = ?";
		    Object[] params = {messageReceiver};
		    return jdbcTemplate.queryForObject(sql, int.class, params);
	    }
	    
	    String column = pageVO.getColumn();

	    if("title_content".equals(column)) {
	        String sql = "select count(*) "
	                +   "from message "
	                +   "where message_receiver = ? "
	                +   "and ("
	                +       "instr(message_title, ?) > 0 "
	                +       "or instr(message_content, ?) > 0"
	                +   ")";

	        Object[] params = { messageReceiver, pageVO.getKeyword(), pageVO.getKeyword()};
	        return jdbcTemplate.queryForObject(sql, int.class, params);
	    }

	    if(!receiveAllowList.contains(column)) return 0;

	    String sql = "select count(*) from message_list "
	            	+ "where message_receiver = ? "
	            	+ "and instr(" + column + ", ?) > 0";

	    Object[] params = {messageReceiver,pageVO.getKeyword()};

	    return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//- 보낸 쪽지함 카운트
	public int countSendList(String messageSender, PageVO pageVO) {
		if(pageVO.isList()) {
		    String sql = "select count(*) from message "
		               + "where message_sender = ?";
		    Object[] params = {messageSender};
		    return jdbcTemplate.queryForObject(sql, int.class, params);
		}
		
	    String column = pageVO.getColumn();

	    if("title_content".equals(column)) {
	        String sql = "select count(*) "
	                +   "from message "
	                +   "where message_sender = ? "
	                +   "and ("
	                +       "instr(message_title, ?) > 0 "
	                +       "or instr(message_content, ?) > 0"
	                +   ")";

	        Object[] params = { messageSender, pageVO.getKeyword(), pageVO.getKeyword()};
	        return jdbcTemplate.queryForObject(sql, int.class, params);
	    }

	    if(!sendAllowList.contains(column)) return 0;

	    String sql = "select count(*) from message_list "
	            	+ "where message_sender = ? "
	            	+ "and instr(" + column + ", ?) > 0";

	    Object[] params = {messageSender, pageVO.getKeyword()};

	    return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//- 안읽은 쪽지 카운드
	public int countUnread(String messageReceiver) {
	    String sql = "select count(*) from message "
	               + "where message_receiver = ? "
	               + "and message_read = 'N'";
	    Object[] params = {messageReceiver};
	    return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//- 전체 쪽지함 카운트
	public int countAdminList(PageVO pageVO) {
		if(pageVO.isList()) {
			String sql = "select count(*) from message";
			return jdbcTemplate.queryForObject(sql, int.class);
		}
		
	    if("title_content".equals(pageVO.getColumn())) {
	        String sql = "select count(*) "
	        		  + "from message "
	        		  + "where instr(message_title, ?) > 0 "
	        		  + "or instr(message_content, ?) > 0";
	        Object[] params = {pageVO.getKeyword(), pageVO.getKeyword()};
	        return jdbcTemplate.queryForObject(sql, int.class, params);
	    }

		if(!allowList.contains(pageVO.getColumn())) {
			return 0;
		}

		String sql = "select count(*) from message_list "
						+"where instr("+pageVO.getColumn()+", ?) > 0";

		Object[] params = {pageVO.getKeyword()};

		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//4. 상세 메소드
	//(4-1) 쪽지 상세(사용자 + 관리자)
	public MessageDto selectOne(long messageNo) {
		String sql = "select m.*, "
			      + "sender.emp_name sender_name, "
			      + "receiver.emp_name receiver_name "
			      + "from message m "
			      + "left outer join emp sender "
			      + "on m.message_sender = sender.emp_no "
			      + "left outer join emp receiver "
			      + "on m.message_receiver = receiver.emp_no "
			      + "where m.message_no = ?";
		Object[] params = {messageNo};
		List<MessageDto> list = jdbcTemplate.query(sql, messageMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//(4-2) 전체 이전 쪽지(관리자)
	public MessageDto selectPreviousOne(long messageNo) {
		String sql = "select * from message_list "
						+ "where message_no = ("
							+ "select max(message_no) from message "
						+ "where message_no < ?"
					+ ")";
		Object[] params = {messageNo};
		List<MessageDto> list = jdbcTemplate.query(sql, messageMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//(4-3) 전체 다음 쪽지(관리자)
	public MessageDto selectNextOne(long messageNo) {
		String sql = "select * from message_list "
						+ "where message_no = ("
							+ "select min(message_no) from message "
						+ "where message_no > ?"
					+ ")";
		Object[] params = {messageNo};
		List<MessageDto> list = jdbcTemplate.query(sql, messageMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//(4-4) 받은 이전 쪽지(사용자)
	public MessageDto selectPreviousReceive(
	        long messageNo, String loginNo) {

	    String sql =
	        "select * from message_list "
	      + "where message_no = ( "
	      +     "select max(message_no) "
	      +     "from message "
	      +     "where message_receiver = ? "
	      +     "and message_no < ? "
	      + ")";

	    Object[] params = {loginNo, messageNo};

	    List<MessageDto> list =
	            jdbcTemplate.query(sql, messageMapper, params);

	    return list.isEmpty() ? null : list.get(0);
	}
	//(4-5) 받은 다음 쪽지(사용자)
	public MessageDto selectNextReceive(
	        long messageNo, String loginNo) {

	    String sql =
	        "select * from message_list "
	      + "where message_no = ( "
	      +     "select min(message_no) "
	      +     "from message "
	      +     "where message_receiver = ? "
	      +     "and message_no > ? "
	      + ")";

	    Object[] params = {loginNo, messageNo};

	    List<MessageDto> list =
	            jdbcTemplate.query(sql, messageMapper, params);

	    return list.isEmpty() ? null : list.get(0);
	}
	//(4-6) 보낸 이전 쪽지(사용자)
	public MessageDto selectPreviousSend(
	        long messageNo, String loginNo) {

	    String sql =
	        "select * from message_list "
	      + "where message_no = ( "
	      +     "select max(message_no) "
	      +     "from message "
	      +     "where message_sender = ? "
	      +     "and message_no < ? "
	      + ")";

	    Object[] params = {loginNo, messageNo};

	    List<MessageDto> list =
	            jdbcTemplate.query(sql, messageMapper, params);

	    return list.isEmpty() ? null : list.get(0);
	}
	//(4-7) 보낸 다음 쪽지(사용자)
	public MessageDto selectNextSend(
	        long messageNo, String loginNo) {

	    String sql =
	        "select * from message_list "
	      + "where message_no = ( "
	      +     "select min(message_no) "
	      +     "from message "
	      +     "where message_sender = ? "
	      +     "and message_no > ? "
	      + ")";

	    Object[] params = {loginNo, messageNo};

	    List<MessageDto> list =
	            jdbcTemplate.query(sql, messageMapper, params);

	    return list.isEmpty() ? null : list.get(0);
	}
	
	//5. 삭제 메소드
	public boolean delete(long messageNo) {
		String sql = "delete from message where message_no = ?";
		Object[] params = {messageNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	// dept_id가 아닌 dept_name 보이게하는 메소드
	public String selectDetpNameById(int deptId) {
		String sql = "select dept_name from dept where dept_id = ?";
	    Object[] params = { deptId }; 
	    return jdbcTemplate.queryForObject(sql, String.class, params);
	}
	
	
}
