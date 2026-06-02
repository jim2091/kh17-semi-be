package com.kh.semiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.PdsDto;
import com.kh.semiprj.mapper.DeptMapper;
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

	private Set<String> allowList = Set.of("pds_title", "pds_writer", "pds_content");
	//등록
	
	//시퀀스 생성
	public Long sequence() {
		String sql = "select pds_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, long.class);
	}
	public void insert(PdsDto pdsDto) {
		String sql = "insert into pds("
						+ "pds_no, pds_writer, pds_title, "
						+ "pds_content, pds_wtime, pds_readcount"
					+ ") values(?, ?, ?, ?, ?, ?)";
		Object[] params = {
				pdsDto.getPdsNo(), pdsDto.getPdsWriter(),
				pdsDto.getPdsTitle(), pdsDto.getPdsContent(),
				pdsDto.getPdsWtime(), pdsDto.getPdsReadcount()
		};
		jdbcTemplate.update(sql, params);
	}
	
	//수정
	public boolean update(PdsDto pdsDto) {
		String sql = "update pds set "
						+ "pds_title, pds_content"
					+ "where pds_no";
		Object[] params = {
				pdsDto.getPdsTitle(), pdsDto.getPdsContent()
		};
		return jdbcTemplate.update(sql, params) > 0;
	}
	//조쇠수 증가
	public boolean updatePdsReadcount(long pdsNo) {
		String sql = "update pds set "
						+ "pds_readcount = pds_readcount + 1"
					+ "where pds_no = ?";
		Object[] params = { pdsNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	
	//삭제
	public boolean delete(long pdsNo) {
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
	
	//페이징
	public List<PdsDto> selectList(PageVO pageVO){
		if(pageVO.isList()) return selectList(pageVO.getPage(), pageVO.getSize());
		if(!allowList.contains(pageVO.getColumn())) 
			return selectList(pageVO.getPage(), pageVO.getSize());

		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
					+ "select * from board_list "
					+ "where instr("+pageVO.getColumn()+", ?) > 0 "
					+ "order by board_no desc"
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
		String sql = "select count(*) from pds "
					+ "where instr(" + pageVO.getColumn() + ", ?) > 0";
		Object[] params = {pageVO.getKeyword()};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//상세 조회
	public PdsDto selectOne(long pdsNo) {
		String sql = "select * from pds where pds_no = ?";
		Object[] params = { pdsNo };
		List<PdsDto> list = jdbcTemplate.query(sql, pdsMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	public PdsDto selectPreviousOne(long pdsNo) {
		String sql = "select * from pds "
				+ "where pds_no = ("
				+ "select max(pds_no) from pds "
				+ "where pds_no < ?)";
		Object[] params = { pdsNo };
		List<PdsDto> list = jdbcTemplate.query(sql, pdsMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	public PdsDto selectNextOne(long pdsNo) {
		String sql = "select * from pds "
				+ "where pds_no = ("
				+ "select min(pds_no) from pds "
				+ "where pds_no > ?)";
		Object[] params = { pdsNo };
		List<PdsDto> list = jdbcTemplate.query(sql, pdsMapper, params);
		return list.isEmpty() ? null : list.get(0);
	
	}
}