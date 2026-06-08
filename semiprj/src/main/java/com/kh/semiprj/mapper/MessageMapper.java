package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.MessageDto;

@Component
public class MessageMapper implements RowMapper<MessageDto>{
	@Override
	public MessageDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		MessageDto messageDto = new MessageDto();
		messageDto.setMessageNo(rs.getLong("message_no"));
		messageDto.setMessageSender(rs.getString("message_sender"));
		messageDto.setMessageReceiver(rs.getString("message_receiver"));
		messageDto.setMessageTitle(rs.getString("message_title"));
		try {
			messageDto.setMessageContent(rs.getString("message_content"));
		}
		catch(Exception e) {
		}
		messageDto.setMessageWtime(rs.getTimestamp("message_wtime"));
		messageDto.setMessageRead(rs.getString("message_read"));
		try {
            messageDto.setSenderName(rs.getString("sender_name"));
        }
        catch(Exception e) {}

        try {
            messageDto.setReceiverName(rs.getString("receiver_name"));
        }
        catch(Exception e) {}
		return messageDto;
	}
}
