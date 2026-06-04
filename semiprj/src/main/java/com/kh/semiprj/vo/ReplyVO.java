package com.kh.semiprj.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ReplyVO {
	private long replyNo;
	private String replyWriter;
	private long replyOrigin;
	private String replyContent;
	private Timestamp replyWtime;
	private Timestamp replyEtime;
	private boolean writer;
	private boolean owner;
	private String empName;
}
