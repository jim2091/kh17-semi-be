package com.kh.semiprj.dto;

import java.sql.Timestamp;

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
}
