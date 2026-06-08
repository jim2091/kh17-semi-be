package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.NotificationDto;
import com.kh.semiprj.mapper.NotificationMapper;

@Repository
public class NotificationDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private NotificationMapper notificationMapper;
	
	public long sequence() {
		String sql = "select notification_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	public void insert(NotificationDto notificationDto) {
		String sql = "insert into notification("
						+ "notification_no, notification_receiver, "
						+ "notification_type, notification_target_no, "
						+ "notification_content, notification_url"
					+ ") values(?, ?, ?, ?, ?, ?)";
		Object[] params = { 
				notificationDto.getNotificationNo(), notificationDto.getNotificationReceiver(), 
				notificationDto.getNotificationType(), notificationDto.getNotificationTargetNo(), 
				notificationDto.getNotificationContent(), notificationDto.getNotificationUrl()
		};
		jdbcTemplate.update(sql, params);
	}
	
	public boolean update(NotificationDto notificationDto) {
		String sql = "update notification "
				+ "set notification_read = 'Y' where notification_no = ?";
		Object[] params = {notificationDto.getNotificationNo()};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean delete(NotificationDto notificationDto) {
		String sql = "delete notification where notification_no = ?";
		Object[] params = { notificationDto.getNotificationNo() };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public List<NotificationDto> selectList(String notificationReceiver){
		String sql = "select * from notification where notification_receiver = ? "
				+ "order by notification_time desc";
		Object[] params = { notificationReceiver };
		
		return jdbcTemplate.query(sql, notificationMapper, params);
	}
}
