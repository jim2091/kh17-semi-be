package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class PdsDto {
	private long pdsNo;
	private String pdsWriter;
	private String pdsTitle;
	private long pdsReadcount;
	private String pdsContent;
	private Timestamp pdsWtime;
}
