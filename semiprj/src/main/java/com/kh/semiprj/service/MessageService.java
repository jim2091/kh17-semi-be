package com.kh.semiprj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.semiprj.dao.MessageDao;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.MessageDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.TargetNotfoundException;

@Service
public class MessageService {
	@Autowired
	private MessageDao messageDao;
	
	public MessageDto detail(long messageNo, EmpDto empDto) {
		MessageDto messageDto = messageDao.selectOne(messageNo);
		
		if(messageDto == null) {
			 throw new TargetNotfoundException("존재하지 않는 쪽지입니다.");
		}
		
		boolean admin = "관리자".equals(empDto.getEmpLevel());
		boolean owner = empDto.getEmpNo().equals(messageDto.getMessageSender())
				|| empDto.getEmpNo().equals(messageDto.getMessageReceiver());
		
		if(!admin && !owner) {
			throw new GetOutException("열람 권한이 없습니다.");
		}
		
		if(empDto.getEmpNo().equals(messageDto.getMessageReceiver())
				&& "N".equals(messageDto.getMessageRead())) {
		    messageDao.updateRead(messageNo);
		    messageDto.setMessageRead("Y");
		}
		
		return messageDto;		
	}
	
	public void delete(long messageNo, EmpDto loginUser) {
        MessageDto messageDto = messageDao.selectOne(messageNo);

        if(messageDto == null) {
            throw new TargetNotfoundException("존재하지 않는 쪽지입니다.");
        }

        if(!"관리자".equals(loginUser.getEmpLevel())) {
            throw new GetOutException("삭제 권한이 없습니다.");
        }

        messageDao.delete(messageNo);
    }
}
