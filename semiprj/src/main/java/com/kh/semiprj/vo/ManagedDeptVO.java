package com.kh.semiprj.vo;

import lombok.Data;

@Data
public class ManagedDeptVO {
	private String deptId;
	private String deptName;
	private String parentDeptId;
	private int depth;
}
