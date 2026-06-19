package com.kh.semiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.AttachDto;
import com.kh.semiprj.dto.PdsDto;
import com.kh.semiprj.mapper.AttachMapper;
import com.kh.semiprj.mapper.EmpMapper;
import com.kh.semiprj.mapper.PdsMapper;
import com.kh.semiprj.vo.PageVO;

@Repository
public class PdsDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private PdsMapper pdsMapper;
	@Autowired
	private EmpMapper empMapper;
	@Autowired
	private AttachMapper attachMapper;

	private Set<String> allowList = Set.of("pds_title", "pds_writer", "title_content");
	//등록
	
	//시퀀스 생성
	public int sequence() {
		String sql = "select pds_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	public void insert(PdsDto pdsDto) {
		String sql = "insert into pds("
						+ "pds_no, pds_writer, pds_title, "
						+ "pds_content, pds_readcount"
					+ ") values(?, ?, ?, ?, ?)";
		Object[] params = {
				pdsDto.getPdsNo(), pdsDto.getPdsWriter(),
				pdsDto.getPdsTitle(), pdsDto.getPdsContent(),
				pdsDto.getPdsReadcount()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//수정
	public boolean update(PdsDto pdsDto) {
		String sql = "update pds set "
						+ "pds_title = ?, pds_content = ? "
					+ "where pds_no = ?";
		Object[] params = {
				pdsDto.getPdsTitle(), pdsDto.getPdsContent(), pdsDto.getPdsNo()
		};
		return jdbcTemplate.update(sql, params) > 0;
	}
	//조회수 증가
	public boolean updatePdsReadcount(int pdsNo) {
		String sql = "update pds set "
						+ "pds_readcount = pds_readcount + 1 "
					+ "where pds_no = ?";
		Object[] params = { pdsNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	
	//삭제
	public boolean delete(int pdsNo) {
		String sql = "delete from pds where pds_no = ?";
		Object[] params = { pdsNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//조회
	public List<PdsDto> selectList(int page, int size){
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
					+ "select * from pds_list order by pds_no desc"
				+ ") TMP"
			+ ") where rn between ? and ?";
		int beginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = { beginRow , endRow };		
		return jdbcTemplate.query(sql, pdsMapper, params);
	}
	
	//검색+페이징 조회
	public List<PdsDto> selectList(PageVO pageVO){
		if(pageVO.isList()) return selectList(pageVO.getPage(), pageVO.getSize());
		if(!allowList.contains(pageVO.getColumn())) 
			return selectList(pageVO.getPage(), pageVO.getSize());
		
		
		//귀찮아서 이렇게 했어요 근데 저는 검색할때 이방식으로 되면 오히려 좋을때가 많을 거 같아요
		//근데 바꾸다 보니 안나눴기때문에 컨텐츠 검색 안해도 되는 view 안쓰게 되서 고민해봐야할거같아요
		String column = pageVO.getColumn();
		if(column.equals("title_content")) {
		    column = "pds_title || ' ' || pds_content";
		}
		if(column.equals("pds_writer")) {
		    column = "emp_name";
		}
		
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
					+ "select * from pds_list "
					+ "where instr("+column+", ?) > 0 "
					+ "order by pds_no desc"
				+ ") TMP"
			+ ") where rn between ? and ?";

		Object[] params = {pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
		return jdbcTemplate.query(sql, pdsMapper, params);
	}
	
	//카운트
	public int count() {
		String sql = "select count(*) from pds";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	public int count(PageVO pageVO) {
		if(pageVO.isList()) return count();
		if(!allowList.contains(pageVO.getColumn())) return count();
		String column = pageVO.getColumn();
		if(column.equals("title_content")) {
		    column = "pds_title || ' ' || pds_content";
		}
		String sql = "select count(*) from pds "
					+ "where instr(" + column + ", ?) > 0";
		Object[] params = {pageVO.getKeyword()};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//상세 조회
	public PdsDto selectOne(int pdsNo) {
		String sql = "select * from pds where pds_no = ?";
		Object[] params = { pdsNo };
		List<PdsDto> list = jdbcTemplate.query(sql, pdsMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	public PdsDto selectPreviousOne(int pdsNo) {
		String sql = "select * from pds "
				+ "where pds_no = ("
				+ "select max(pds_no) from pds "
				+ "where pds_no < ?)";
		Object[] params = { pdsNo };
		List<PdsDto> list = jdbcTemplate.query(sql, pdsMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	public PdsDto selectNextOne(int pdsNo) {
		String sql = "select * from pds "
				+ "where pds_no = ("
				+ "select min(pds_no) from pds "
				+ "where pds_no > ?)";
		Object[] params = { pdsNo };
		List<PdsDto> list = jdbcTemplate.query(sql, pdsMapper, params);
		return list.isEmpty() ? null : list.get(0);
	
	}
	
	public void connect(int pdsNo, int attachNo) {
		String sql = "insert into pds_files(pds_no, attach_no) values(?, ?)";
		Object[] params = { pdsNo, attachNo };
		jdbcTemplate.update(sql, params);
	}
	
	public boolean disconnect(int pdsNo, int attachNo) {
		String sql = "delete pds_files where pds_no = ? and attach_no = ?";
		Object[] params = {pdsNo, attachNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public List<AttachDto> searchFiles(int pdsNo) {
		String sql = "select attach.* from attach join pds_files "
						+ "on attach.attach_no = pds_files.attach_no where pds_files.pds_no = ?";
		Object[] params = { pdsNo };
		return jdbcTemplate.query(sql, attachMapper, params);
	}
	
	
}