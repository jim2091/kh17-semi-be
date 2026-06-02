package com.kh.semiprj.dto;

import lombok.Data;

@Data
public class AttachDto {
	private int attachNo;
	private String attachName;
	private String attachType;
	private long attachSize;
	
	public String getAttachTypeString() {
		if(attachType == null) return "application/octet-stream";
		return attachType;
	}
}
