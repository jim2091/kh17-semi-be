package com.kh.semiprj.dto;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Data;

@Data
public class MessageDto {
	private long messageNo;
	private String messageSender;
	private String messageReceiver;
	private String messageTitle;
	private String messageContent;
	private Timestamp messageWtime;
	private String messageRead;
	private String senderName;
	private String receiverName;
	
	//쪽지 작성일
	public String getMessageWtimeString() {
		LocalDateTime current = LocalDateTime.now();
		LocalDateTime writeTime = messageWtime.toLocalDateTime();
	
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
