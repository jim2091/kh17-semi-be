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
	
	//가상의 Getter : 오늘 작성한 글은 시간만, 이전에 작성한 글은 날짜만 반환
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
