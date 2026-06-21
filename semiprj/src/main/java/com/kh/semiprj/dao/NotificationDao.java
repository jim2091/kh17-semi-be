package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.NotificationDto;
import com.kh.semiprj.dto.PdsDto;
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
	
	public boolean delete(long notificationNo) {
		String sql = "delete notification where notification_no = ?";
		Object[] params = { notificationNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public List<NotificationDto> selectList(String notificationReceiver){
		String sql = "select * from notification where notification_receiver = ? "
				+ "order by notification_time desc";
		Object[] params = { notificationReceiver };
		
		List<NotificationDto> list = jdbcTemplate.query(sql, notificationMapper, params);
		return list.isEmpty() ? List.of() : list;
	}
	public List<NotificationDto> selectList(String notificationReceiver, String type){
		String sql = "select * from notification where notification_receiver = ? "
				+ "order by notification_time desc";
		if (type.equals("all")) {
			sql = "select * from notification where notification_receiver = ? "
					+ "order by notification_time desc";
		}
		else if (type.equals("unread")) {
			sql = "select * from notification where notification_receiver = ? "
					+ "and notification_read = 'N'"
					+ "order by notification_time desc";
		}
		else if (type.equals("read")) {
			sql = "select * from notification where notification_receiver = ? "
					+ "and notification_read = 'Y'"
					+ "order by notification_time desc";
		}
		else if (type.equals("board")) {
			sql = "select * from notification where notification_receiver = ? "
					+ "and (notification_type = 'board_reply' or notification_type = 'comment' or notification_type = 'reply' or notification_type = 'like')"
					+ "order by notification_time desc";
		}
		else if (type.equals("app")) {
			sql = "select * from notification where notification_receiver = ? "
					+ "and (notification_type = 'approval' or notification_type = 'reject' or notification_type = 'app_waiting')"
					+ "order by notification_time desc";
		}
		
		Object[] params = { notificationReceiver };
		
		List<NotificationDto> list = jdbcTemplate.query(sql, notificationMapper, params);
		return list.isEmpty() ? List.of() : list;
	}
	
	public List<NotificationDto> selectListByPaging(String notificationReceiver, String type, int beginRow, int endRow){
		String sql = "select * from("
						+ "select rownum RN, TMP.* from("
							+ "select * from notification "
							+ "where notification_receiver = ? "
							+ "order by notification_no desc"
						+ ") TMP"
					+ ") where RN between ? and ?";
		if (type.equals("all")) {
			sql = "select * from("
					+ "select rownum RN, TMP.* from("
						+ "select * from notification "
						+ "where notification_receiver = ? "
						+ "order by notification_time desc"
					+ ") TMP"
				+ ") where RN between ? and ?";
		}
		else if (type.equals("unread")) {
			sql = "select * from("
					+ "select rownum RN, TMP.* from("
						+ "select * from notification "
						+ "where notification_receiver = ? "
						+ "and notification_read = 'N' "
						+ "order by notification_time desc"
					+ ") TMP"
				+ ") where RN between ? and ?";
		}
		else if (type.equals("read")) {
			sql = "select * from("
					+ "select rownum RN, TMP.* from("
						+ "select * from notification "
						+ "where notification_receiver = ? "
						+ "and notification_read = 'Y' "
						+ "order by notification_time desc"
					+ ") TMP"
				+ ") where RN between ? and ?";
		}
		else if (type.equals("board")) {
			sql = "select * from("
					+ "select rownum RN, TMP.* from("
						+ "select * from notification "
						+ "where notification_receiver = ? "
						+ "and (notification_type = 'board_reply' or notification_type = 'comment' or notification_type = 'reply' or notification_type = 'like') "
						+ "order by notification_time desc"
					+ ") TMP"
				+ ") where RN between ? and ?";
		}
		else if (type.equals("app")) {
			sql = "select * from("
					+ "select rownum RN, TMP.* from("
						+ "select * from notification "
						+ "where notification_receiver = ? "
						+ "and (notification_type = 'approval' or notification_type = 'reject') "
						+ "order by notification_time desc"
					+ ") TMP"
				+ ") where RN between ? and ?";
		}
		Object[] params = {
				notificationReceiver,
				beginRow,
				endRow
		};
		
		List<NotificationDto> list = jdbcTemplate.query(sql, notificationMapper, params);
		return list.isEmpty() ? List.of() : list;
	}
	
	
	public List<NotificationDto> selectRecent(String notificationReceiver){
		String sql = "select rownum, TMP.* from ("
				+ "select * from notification where notification_receiver = ? "
				+ "and notification_read = 'N'"
				+ "order by notification_time desc"
				+ ")TMP where rownum <= 5";
		Object[] params = { notificationReceiver };
		
		return jdbcTemplate.query(sql, notificationMapper, params);
	}
	
	public long countUnread(String notificationReceiver) {
		String sql = "select count(*) from ("
				+ "select * from notification where notification_receiver = ?) "
				+ "where notification_read = 'N'";
		Object[] params = { notificationReceiver };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	public NotificationDto selectOne(long notificationNo) {
		String sql = "select * from notification where notification_no = ?";
		Object[] params = { notificationNo };
		List<NotificationDto> list = jdbcTemplate.query(sql, notificationMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
}
