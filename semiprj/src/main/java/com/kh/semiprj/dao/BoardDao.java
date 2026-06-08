package com.kh.semiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.BoardDto;
import com.kh.semiprj.mapper.BoardMapper;
import com.kh.semiprj.mapper.EmpMapper;
import com.kh.semiprj.vo.PageVO;

@Repository
public class BoardDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private BoardMapper boardMapper;
	@Autowired
	private EmpMapper empMapper;
	//검색 허용 컬럼
	private Set<String> allowList = Set.of("board_title", "board_writer", "title_content", "board_head");
	
	//1. 등록 메소드
	public long sequence() {
	    String sql = "select board_seq.nextval from dual";
	    return jdbcTemplate.queryForObject(sql, long.class);
	}
	public void insert(BoardDto boardDto) {
		String sql = "insert into board("
						+ "board_no, board_writer, board_title, "
						+ "board_content, board_head, board_type, "
						+ "board_group, board_parent, board_depth"
					+ ") values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {
				boardDto.getBoardNo(), boardDto.getBoardWriter(),
				boardDto.getBoardTitle(), boardDto.getBoardContent(),
				boardDto.getBoardHead(), boardDto.getBoardType(), 
				boardDto.getBoardGroup(), boardDto.getBoardParent(), 
				boardDto.getBoardDepth()};
		jdbcTemplate.update(sql, params);	
	}
	
	//2. 수정 메소드
	//(2-1) 게시글 수정
	public boolean update(BoardDto boardDto) {
		String sql = "update board set "
						+ "board_title = ?, board_content = ?, "
						+ "board_head = ?, board_type = ? "
					+ "where board_no = ?";
		Object[] params = {
				boardDto.getBoardTitle(), boardDto.getBoardContent(), 
				boardDto.getBoardHead(), boardDto.getBoardType(), 
				boardDto.getBoardNo()};
		return jdbcTemplate.update(sql, params) > 0; 
	}
	
	//(2-2) 조회수 증가
	public boolean updateBoardReadcount(long boardNo) {
		String sql = "update board set "
						+ "board_readcount = board_readcount + 1 "
					+ "where board_no = ?";
		Object[] params = {boardNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//(2-3) 추천수 수정
	public boolean updateBoardLikecount(long boardNo) {
		String sql = "update board set board_likecount = ("
						+ "select count(*) from board_like where board_no = ?"
					+ ") where board_no = ?";
		Object[] params = { boardNo, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//(2-4) 댓글수 수정
	public void updateBoardReplycount(long boardNo) {
		String sql = "update board set board_replycount = ("
						+ "select count(*) from reply where reply_origin = ?"
					+ ") where board_no = ?";
	    jdbcTemplate.update(sql, boardNo, boardNo);
	}
	
	//3. 목록 및 검색 메소드
	//(3-1) 일반글 목록
	public List<BoardDto> selectList(int page, int size) { 
		String sql = "select * from ("
						+ "select rownum RN, TMP.* FROM ("
							+ "select * from board_list "
							+ "connect by prior board_no=board_parent "
							+ "start with board_parent is null "
							+ "order siblings by board_group desc, board_no asc"
						+ ")TMP"
					+ ") where RN between ? and ?";
		int baginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = {baginRow, endRow};
		return jdbcTemplate.query(sql, boardMapper, params);
	}
	
	//(3-2) 공지글 목록
	public List<BoardDto> selectNoticeList() {
		String sql = "select * from board_list "
						+ "where board_head = '공지' "
					+ "order by board_no desc";
		return jdbcTemplate.query(sql, boardMapper);
	}
	
	//(3-3) 작성자로 검색하는 메소드
	public List<BoardDto> selectMyList(String boardWriter) {
		String sql = "select * from board_list "
						+ "where board_writer = ? "
					+ "order by board_no desc";
		Object[] params = {boardWriter};
		return jdbcTemplate.query(sql, boardMapper, params);
	}
	
	//(3-4) 목록 및 검색 결과 페이징
	public List<BoardDto> selectList(PageVO pageVO) {
		if(pageVO.getBoardHead() != null &&
				   !pageVO.getBoardHead().isEmpty()) {

		    String sql =
		        "select * from ("
		        + "select rownum RN, TMP.* FROM ("
		            + "select * from board_list "
		            + "where board_head = ? "
		            + "connect by prior board_no=board_parent "
		            + "start with board_parent is null "
		            + "order siblings by board_group desc, board_no asc"
		        + ")TMP"
		        + ") where RN between ? and ?";

		    Object[] params = {
		        pageVO.getBoardHead(),
		        pageVO.getBeginRownum(),
		        pageVO.getEndRownum()
		    };

		    return jdbcTemplate.query(sql, boardMapper, params);
		}
		if(pageVO.isList()) 
			return selectList(pageVO.getPage(), pageVO.getSize());	
		if(!allowList.contains(pageVO.getColumn())) 
			return selectList(pageVO.getPage(), pageVO.getSize());
		
		//작성자
		if(pageVO.getColumn().equals("board_writer")) {
		    String sql = "select * from ( "
		    				+ "select rownum RN, TMP.* from ( "
		    					+ "select b.* "
		    					+ "from board b "
		    					+ "left outer join emp e on b.board_writer = e.emp_no "
		    					+ "where instr(e.emp_name, ?) > 0 "
		    					+ "and b.board_type <> '익명'"
		    					+ "connect by prior board_no = board_parent "
		    					+ "start with board_parent is null "
		    					+ "order siblings by board_group desc, board_no asc "
		    				+ ") TMP "
		    			+ ") where RN between ? and ?";
		    Object[] params = {pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
		    return jdbcTemplate.query(sql, boardMapper, params);
		}
		
		//제목+내용
		if(pageVO.getColumn().equals("title_content")) {
			String sql = "select * from ("
							+ "select rownum RN, TMP.* FROM ("
								+ "select * from board "
								+ "where instr(board_title, ?) > 0 "
								+ "or instr(board_content, ?) > 0 "
								+ "connect by prior board_no=board_parent "
								+ "start with board_parent is null "
								+ "order siblings by board_group desc, board_no asc"
							+ ")TMP"
						+ ") where RN between ? and ?";
			Object[] params = {pageVO.getKeyword(), pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
			return jdbcTemplate.query(sql, boardMapper, params);
		}

		//제목
		String sql = "select * from ("
						+ "select rownum RN, TMP.* FROM ("
							+ "select * from board_list "
							+ "where instr(" + pageVO.getColumn() + ", ?) > 0 "
							+ "connect by prior board_no=board_parent "
							+ "start with board_parent is null "
							+ "order siblings by board_group desc, board_no asc"
						+ ")TMP"
					+ ") where RN between ? and ?";
		Object[] params = {pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
		return jdbcTemplate.query(sql, boardMapper, params);
	}
	
	//(3-5) 목록과 검색의 상황별 카운트 메소드
	public int count() {
		String sql = "select count(*) from board";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	public int count(PageVO pageVO) {
		if(pageVO.getBoardHead() != null &&
				   !pageVO.getBoardHead().isEmpty()) {

				    String sql =
				        "select count(*) from board "
				        + "where board_head = ?";

				    return jdbcTemplate.queryForObject(
				        sql,
				        int.class,
				        pageVO.getBoardHead()
				    );
				}
		if(pageVO.isList()) return count();
		if(!allowList.contains(pageVO.getColumn())) return count();
		
		if(pageVO.getColumn().equals("board_writer")) {
		    String sql = "select count(*) "
		    				+ "from board b "
		    				+ "left outer join emp e on b.board_writer = e.emp_no "
		    			+ "where instr(e.emp_name, ?) > 0";
		    Object[] params = {pageVO.getKeyword()};
		    return jdbcTemplate.queryForObject(sql, int.class, params);
		}
		
		if(pageVO.getColumn().equals("title_content")) {
			String sql = "select count(*) from board "
						+ "where instr(board_title, ?) > 0 "
						+ "or instr(board_content, ?) > 0";
			Object[] params = {pageVO.getKeyword(), pageVO.getKeyword()};
			return jdbcTemplate.queryForObject(sql, int.class, params);
		}
		
		String sql = "select count(*) from board "
					+ "where instr(" + pageVO.getColumn() + ", ?) > 0";
		Object[] params = {pageVO.getKeyword()};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//(3-6) 내가 쓴 글 목록
	public List<BoardDto> selectMyList(String boardWriter, PageVO pageVO) {
		String sql = "select * from ("
				+ "select rownum RN, TMP.* from ("
				+ "select * from board_list "
				+ "where board_writer = ? "
				+ "connect by prior board_no = board_parent "
				+ "start with board_parent is null "
				+ "order siblings by board_group desc, board_no asc"
				+ ") TMP"
				+ ") where RN between ? and ?";
		Object[] params = {boardWriter,  pageVO.getBeginRownum(), pageVO.getEndRownum()};
		return jdbcTemplate.query(sql, boardMapper, params);
	}
	public int countMyList(String boardWriter) {
		String sql = "select count(*) from board "
				+ "where board_writer = ?";
		Object[] params = {boardWriter};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//4. 상세 메소드
	//(4-1) 게시글 상세
	public BoardDto selectOne(long boardNo) {
		String sql = "select * from board where board_no = ?";
		Object[] params = {boardNo};
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//(4-2) 이전글
	public BoardDto selectPreviousOne(long boardNo) {
		String sql = "select * from board "
					+ "where board_no = ("
					+ "select max(board_no) from board "
					+ "where board_no < ?"
					+ ")";
		Object[] params = {boardNo};
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//(4-3) 다음글
	public BoardDto selectNextOne(long boardNo) {
		String sql = "select * from board "
					+ "where board_no = ("
					+ "select min(board_no) from board "
					+ "where board_no > ?"
					+ ")";
		Object[] params = {boardNo};
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//5. 삭제 메소드
	public boolean delete(long boardNo) {
		String sql = "delete from board where board_no = ?";
		Object[] params = {boardNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
}
