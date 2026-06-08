package com.kh.semiprj.dto;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Data;

@Data
public class NotificationDto {
	private long notificationNo;
	private String notificationReceiver;
	private String notificationType;
	private long notificationTargetNo;
	private String notificationContent;
	private String notificationUrl;
	private String notificationRead;
	private Timestamp notificationTime;
	
	public String getNotificationTimeToString() {
		LocalDateTime writeTime = notificationTime.toLocalDateTime();
		LocalDate writeDate = writeTime.toLocalDate();
		
		return writeDate.toString();
	}
}
