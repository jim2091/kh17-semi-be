package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.mapper.AppMapper;

@Repository
public class AppDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private AppMapper appMapper;
	
	//시퀀스
	public int sequence() {
		String sql = "select app_seq.nextval from daul";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	//목록
	public List<AppDto> selectList(int page, int size){
		String sql = "select * from ("
					+ "	select rownum rn, TMP.* from("
					+ "		select * from app order by app_no desc"
					+ "	)TMP"
					+ ") where rn between ? and ?";
		int beginRow = page * size - (size-1);
		int endRow = page * size;
		Object[] params = { beginRow , endRow };
		return jdbcTemplate.query(sql, appMapper, params);
	}
	
	
	//등록 할 때 생각해야할 점 : 품의서, 휴가신청서, 업무기안서 를 세개의 테이블로 나눠서 진행할 때, 어떤 sql 구문을 써야 하는가
	
	
	//등록
	public void insert(AppDto appDto) {
		String sql = "insert into app (app_id, app_req_id, app_title, app_content, app_status, app_save_yn)"
						+ " values(?, ?, ?, ?, ?, ?)";
		Object[] params = {
						appDto.getAppId(), appDto.getAppReqId(), appDto.getAppTitle(),
						appDto.getAppContent(), appDto.getAppStatus(), appDto.getAppSaveYn(),
		};
		jdbcTemplate.update(sql, params);
	}
	
	
	
	
	//상세(기인자)
	public AppDto selectOne(String appReqId){
		String sql = "select * from app where app_req_id=?";
		Object[]params = { appReqId };
		List<AppDto> list = jdbcTemplate.query(sql, appMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	
	//삭제
	public boolean delete(int appId) {
		String sql = "delete app where app_id=?";
		Object[] params = { appId };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	
	
}
