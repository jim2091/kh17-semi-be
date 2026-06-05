package com.kh.semiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.ReplyDao;
import com.kh.semiprj.dto.ReplyDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class ReplyOwnerInterceptor implements HandlerInterceptor{
	@Autowired
	private ReplyDao replyDao;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		//(1) 파라미터에 replyNo가 없으면 차단
		String replyNoStr = request.getParameter("replyNo");
		if(replyNoStr == null) {
			throw new TargetNotfoundException("존재하지 않는 댓글입니다.");
		}
		
		//(2) 비회원이면 차단
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginId");
		if(loginId == null) {
			throw new WhoAreYouException();
		}
		
		//(3) 존재하지 않는 댓글이면 차단
		long replyNo = Long.parseLong(replyNoStr);
		ReplyDto replyDto = replyDao.selectOne(replyNo);
		if(replyDto == null) {
			throw new TargetNotfoundException("존재하지 않는 댓글입니다");
		}
		
		//(4) 작성자가 탈퇴했다면 차단
        if(replyDto.getReplyWriter() == null) {
        	throw new GetOutException();
        }
        
        //(5) 소유자가 아니면 차단
        String loginNo = (String)session.getAttribute("loginNo");
        if(!loginNo.equals(replyDto.getReplyWriter())) {
        	throw new GetOutException();
        }
        //(6) 위를 다 통과했다면 본인 소유의 글에 접근하는 것으로 간주하여 통과
		return true;
	}
}
