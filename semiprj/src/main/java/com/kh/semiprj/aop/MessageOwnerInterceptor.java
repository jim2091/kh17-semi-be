package com.kh.semiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.MessageDao;
import com.kh.semiprj.dto.MessageDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class MessageOwnerInterceptor implements HandlerInterceptor{
	@Autowired
	private MessageDao messageDao;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//(1) 파라미터에 messageNo가 없으면 차단
		String messageNoStr = request.getParameter("messageNo");
		if(messageNoStr == null) {
			throw new TargetNotfoundException("존재하지 않는 메세지입니다.");
		}
		
		//(2) 비회원이면 차단
		HttpSession session = request.getSession();
		String empNo = (String)session.getAttribute("loginNo");
		if(empNo == null) {
			throw new WhoAreYouException();
		}
		
		//(3) 존재하지 않는 메세지면 차단
		long messageNo = Long.parseLong(messageNoStr);
		MessageDto messageDto = messageDao.selectOne(messageNo);
		if(messageDto == null) {
			throw new TargetNotfoundException("존재하지 않는 메세지입니다");
		}
        
        //(4) 보낸 사람 OR 받은 사람 아니면 차단
        String loginRole = (String)session.getAttribute("loginRole");
        if("관리자".equals(loginRole)) {
            return true;
        }
        
        String loginNo = (String)session.getAttribute("loginNo");
       
        boolean sender = loginNo.equals(messageDto.getMessageSender());
        boolean receiver = loginNo.equals(messageDto.getMessageReceiver());

        if(!sender && !receiver) {
            throw new GetOutException();
        }
		
        //(6) 위를 다 통과했다면 본인 소유의 메세지
		return true;
	}
}
