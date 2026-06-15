package com.kh.semiprj.dto;

import lombok.Data;

//전자결재

@Data
public class AppDto {
	private int appId;
	private String appReqId;
	private String appTitle;
	private String appContent;
	private String appType;
	private String appDate;
	private String appStatus;
	private String appSaveYn;
	private String empName; // 기안자 이름 (JOIN용)
}
