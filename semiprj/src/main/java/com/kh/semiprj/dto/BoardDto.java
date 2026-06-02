package com.kh.semiprj.dto;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Data;

@Data
public class BoardDto {
	private long boardNo;
	private String boardWriter;
	private String boardTitle;
	private String boardContent;
	private String boardHead;
	private String boardType;
	private Timestamp boardWtime;
	private long boardLikecount;
	private long boardReadcount;
	private long boardReplycount;
	private long boardGroup;
	private Long boardParent;
	private long boardDepth;
	
	//게시글 소유자(사원 아이디)
	private String empId;
	public String getEmpId() {
		return empId;
	}
	public void setEmpId(String empId) {
		this.empId = empId;
	}
	
	//게시글 작성자(사원명)
	private String empName;
	public String getEmpName() {
		return empName;
	}
	public void setEmpName(String empName) {
		this.empName = empName;
	}
	
	//게시글 작성일
	public String getBoardWtimeString() {
		LocalDateTime current = LocalDateTime.now();
		LocalDateTime writeTime = boardWtime.toLocalDateTime();
	
		LocalDate currentDate = current.toLocalDate();
		LocalDate writeDate = writeTime.toLocalDate();
		
		if(writeDate.equals(currentDate)) { 
			DateTimeFormatter f = DateTimeFormatter.ofPattern("HH:mm");
			return writeTime.format(f);
		}
		else {
			return writeDate.toString();
		}
	}
}
