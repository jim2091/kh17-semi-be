package com.kh.semiprj.service;

import org.springframework.stereotype.Service;

import com.kh.semiprj.dao.NotificationDao;
import com.kh.semiprj.dto.NotificationDto;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class NotificationService {
	private final NotificationDao notificationDao;
	
	public void createNotification(
			String EmpNo, String type, long targetNo, String content, String url) {
		
		NotificationDto notificationDto = new NotificationDto();
		notificationDto.setNotificationNo(notificationDao.sequence());
		notificationDto.setNotificationReceiver(EmpNo);
		notificationDto.setNotificationType(type);
		notificationDto.setNotificationTargetNo(targetNo);
		notificationDto.setNotificationContent(content);
		notificationDto.setNotificationUrl(url);
		
		notificationDao.insert(notificationDto);
	}
	
	public void notifyBoardReply(String EmpNo, long targetNo) {
		createNotification(
				EmpNo, 
				"board_reply", 
				targetNo, 
				"게시글에 답글이 작성되었습니다", 
				"/board/detail?boardNo=" + targetNo
				);
	}
	
	public void notifyComment(String EmpNo, long targetNo) {
		createNotification(
				EmpNo, 
				"comment", 
				targetNo, 
				"게시글에 댓글이 작성되었습니다", 
				"/board/detail?boardNo=" + targetNo
				);
	}
	
	public void notifyReply(String EmpNo, long targetNo) {
		createNotification(
				EmpNo, 
				"reply", 
				targetNo, 
				"내 댓글에 댓글이 작성되었습니다", 
				"/board/detail?boardNo=" + targetNo
				);
	}
	
	public void notifyLike(String EmpNo, long targetNo) {
		createNotification(
				EmpNo, 
				"like", 
				targetNo, 
				"누군가 게시글에 좋아요를 눌렀습니다", 
				"/board/detail?boardNo=" + targetNo
				);
	}
	
	public void notifyAppWaiting(String EmpNo, long targetNo) {
		createNotification(
				EmpNo, 
				"app_waiting", 
				targetNo, 
				"결재해야하는 문서가 있습니다", 
				"/appr/detail?appId=" + targetNo
				);
	}
	
	public void notifyApproval(String EmpNo, long targetNo) {
		createNotification(
				EmpNo, 
				"approval", 
				targetNo, 
				"결재문서가 최종 승인되었습니다", //문서 제목도 자동으로 달아줄까.. 흠..
				"/app/detail?appId=" + targetNo
				);
	}
	
	public void notifyReject(String EmpNo, long targetNo) {
		createNotification(
				EmpNo, 
				"reject", 
				targetNo, 
				"결재문서가 최종 반려되었습니다",
				"/app/detail?appId=" + targetNo
				);
	}
	
	public void notifyMessage(String EmpNo, long targetNo) {//쪽지 알림이 따로 있을텐데 필요하려나?
		createNotification(
				EmpNo, 
				"message", 
				targetNo, 
				"쪽지가 도착했습니다", 
				"/message/detail?messageNo=" + targetNo
				);
	}
	
	public void notifyNotice(String EmpNo, long targetNo) {//쪽지 알림이 따로 있을텐데 필요하려나?
		createNotification(
				EmpNo, 
				"notice", 
				targetNo, 
				"새로운 공지가 등록되었습니다",
				 "#" + targetNo //게시판 공지? 사내 일정에서? 별도로?
				);
	}
	
}
