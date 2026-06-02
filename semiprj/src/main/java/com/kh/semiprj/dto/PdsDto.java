package com.kh.semiprj.dto;

import lombok.Data;

@Data
public class PdsDto {
	private int pdsNo;
	private String pdsWriter;
	private String pdsTitle;
	private int pdsDownloadCount;
	private String pdsContent;
}
