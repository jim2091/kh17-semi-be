package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class DeptDto {
	
	private int deptId;
	private String deptCategory;
	private String deptHeadId;
	private String deptName;
	private String deptYn;
	private Timestamp deptCreateAt;
	private String deptContent;
}
