package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.NotificationDto;

@Component
public class NotificationMapper implements RowMapper<NotificationDto>{
	@Override
	public NotificationDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		NotificationDto  notificationDto = new NotificationDto();
		notificationDto.setNotificationNo(rs.getLong("notification_no"));
		notificationDto.setNotificationReceiver(rs.getString("notification_receiver"));
		notificationDto.setNotificationType(rs.getString("notification_type"));
		notificationDto.setNotificationTargetNo(rs.getLong("notification_target_no"));
		notificationDto.setNotificationContent(rs.getString("notification_content"));
		notificationDto.setNotificationUrl(rs.getString("notification_url"));
		notificationDto.setNotificationRead(rs.getString("notification_read"));
		notificationDto.setNotificationTime(rs.getTimestamp("notification_time"));
		
		return notificationDto;
	}
}
