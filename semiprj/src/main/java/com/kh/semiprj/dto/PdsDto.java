package com.kh.semiprj.dto;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Data;

@Data
public class PdsDto {
	private int pdsNo;
	private String pdsWriter;
	private String pdsTitle;
	private long pdsReadcount;
	private String pdsContent;
	private Timestamp pdsWtime;
	
	private String empName;
	public String getPdsWtimeString() {
		
		//작성일과 현재시각을 LocalDateTime 형태로 불러온다
		LocalDateTime current = LocalDateTime.now();//현재시각
		LocalDateTime writeTime = pdsWtime.toLocalDateTime();//작성시각
		
		LocalDate currentDate = current.toLocalDate();//현재일자
		LocalDate writeDate = writeTime.toLocalDate();//작성일자
		
		if(writeDate.equals(currentDate)) {//작성일이 오늘이면
			//LocalTime time = writeTime.toLocalTime();//시간만 뽑아서
			//return time.toString();//반환하세요!
			DateTimeFormatter f = DateTimeFormatter.ofPattern("HH:mm");
			return writeTime.format(f);
		}
		else {//작성일이 오늘이 아니라면
			return writeDate.toString();//작성일을 문자열로 반환하세요!
		}
	}
	
	public boolean isNewPost() {
		LocalDateTime current = LocalDateTime.now();
		LocalDateTime writeTime = pdsWtime.toLocalDateTime();
		Duration duration = Duration.between(writeTime, current);
		
		return duration.toHours() <= 24;
	}
}
