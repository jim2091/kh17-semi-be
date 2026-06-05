package com.kh.semiprj.vo;

import lombok.Data;

@Data
public class CertNumVo {
	private String num1;
	private String num2;
	private String num3;
	private String num4;
	private String num5;
	private String num6;
	
	public String concat() {
		return num1 + num2 + num3 + num4 + num5 + num6;
	}
}
