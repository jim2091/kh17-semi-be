package com.kh.semiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.BoardDao;
import com.kh.semiprj.dto.BoardDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//사원 본인 소유의 글일 경우만 통과
@Service
public class BoardOwnerInterceptor implements HandlerInterceptor{
	@Autowired
	private BoardDao boardDao;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		//(1) 파라미터에 boardNo가 없으면 차단
		String boardNoStr = request.getParameter("boardNo");
		if(boardNoStr == null) {
			throw new TargetNotfoundException("존재하지 않는 게시글입니다.");
		}
		
		//(2) 로그인 된 사용자가 아니면 차단
		HttpSession session = request.getSession();
		String empNo = (String) session.getAttribute("loginNo");
		if(empNo == null) {
			throw new WhoAreYouException();
		}
		
		//(3) 존재하지 않는 글이면 차단
		long boardNo = Long.parseLong(boardNoStr);
		BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) {
        	throw new TargetNotfoundException("존재하지 않는 게시글입니다.");
        }
        
        //(+추가) 관리자는 무조건 통과(수정/삭제 가능)
        String loginRole = (String) session.getAttribute("loginRole");
        if ("관리자".equals(loginRole)) {
            return true;
        }
        
        //(4) 작성자가 탈퇴했다면 차단
        if(boardDto.getBoardWriter() == null) {
        	throw new GetOutException();
        }
        
        //(5) 글 소유자가 아니면 차단
		String loginNo = (String) session.getAttribute("loginNo");
		if (!loginNo.equals(boardDto.getBoardWriter())) {
		    throw new GetOutException();
		}
        
        //(6) 위를 다 통과했다면 본인 소유의 글에 접근하는 것으로 간주
		return true;//통과
	}
	

}
