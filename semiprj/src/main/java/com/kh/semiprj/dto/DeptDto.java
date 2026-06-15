package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class DeptDto {
	
	private int deptId;
	private int parentDeptId;
	private String deptHeadId;
	private String deptName;
	private String deptYn;
	private Timestamp deptCreateAt;
	private String deptContent;
	private Timestamp updateAt;
	
	//상위부서 이름도 넣기위해 생성
	private String parentDeptName;
	//부서장 이름 추가
	private String deptHeadName;

}
