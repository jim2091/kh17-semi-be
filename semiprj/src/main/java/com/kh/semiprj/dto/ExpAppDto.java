package com.kh.semiprj.dto;

import java.sql.Timestamp;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class ExpAppDto {
	private int appId;
	private String expDate;
	private int expPrice;
	private String expHistory;
	private String expHow;
	private String expPurpose;
}
