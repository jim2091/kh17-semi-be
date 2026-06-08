package com.kh.semiprj.dto;

import java.sql.Timestamp;

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
}
