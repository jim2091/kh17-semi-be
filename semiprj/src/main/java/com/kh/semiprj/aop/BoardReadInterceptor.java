package com.kh.semiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.BoardDao;
import com.kh.semiprj.dao.BoardReadDao;
import com.kh.semiprj.dto.BoardDto;
import com.kh.semiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//파라미터에 있는 boardNo를 찾아서 해당 글의 조회수를 증가시키기
@Service
public class BoardReadInterceptor implements HandlerInterceptor{
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private BoardReadDao boardReadDao;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		//(1) boardNo가 없는 경우를 제거
		String boardNoStr = request.getParameter("boardNo");
		if(boardNoStr == null) {
			throw new TargetNotfoundException("존재하지 않는 게시글 입니다.");
		}
		
		//(2) boardNo가 유효하지 않은 번호인 경우를 제거
		long boardNo = Long.parseLong(boardNoStr);
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) {
			throw new TargetNotfoundException("존재하지 않는 게시글 입니다.");
		}
		
		//(3) 비회원인 경우를 제거
		HttpSession session = request.getSession();
		String loginId = (String) session.getAttribute("loginId");
		if(loginId == null) {
			return true;
		}
		
		//(4) DB에 조회이력이 있으면 제거
		int count = boardReadDao.count(loginId, boardNo);
		if(count > 0) {//기록이 1개 이상이라면
			return true;
		}
		
		//(5) DB에 조회이력을 생성
		boardReadDao.insert(loginId, boardNo);
		
		//(6) 조회수 증가 처리
		boardDao.updateBoardReadcount(boardNo);
		
		//조회수가 올라가든 안 올라가든 무조건 통과
		return true;
	}
}
