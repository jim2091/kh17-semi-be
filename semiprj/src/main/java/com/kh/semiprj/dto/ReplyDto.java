package com.kh.semiprj.dto;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ReplyDto {
	private long replyNo;
	private String replyWriter;
	private long replyOrigin;
	private Long replyParent;
	private String replyContent;
	private Timestamp replyWtime;
	private Timestamp replyEtime;

	//댓글 작성자(사원 아이디, 사원 이름)
	private String empId;
	public String getEmpId() {
		return empId;
	}
	public void setEmpId(String empId) {
		this.empId = empId;
	}
	
	private String empName;
	public String getEmpName() {
		return empName;
	}
	public void setEmpName(String empName) {
		this.empName = empName;
	}
	
	//댓글 작성일
	public String getReplyWtimeString() {
		LocalDateTime current = LocalDateTime.now();
		LocalDateTime writeTime = replyWtime.toLocalDateTime();
	
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
