package com.kh.semiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.BoardReadDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.PdsDao;
import com.kh.semiprj.dao.PdsReadDao;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.PdsDto;
import com.kh.semiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class PdsReadInterceptor implements HandlerInterceptor{
	@Autowired
	private PdsDao pdsDao;
	@Autowired
	private PdsReadDao pdsReadDao;
	@Autowired
	private EmpDao empDao;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		String pdsNoStr = request.getParameter("pdsNo");

		//[1] pdsNo가 없으면
		if (pdsNoStr == null) {
			throw new TargetNotfoundException("존재하지 않는 게시글");
		}
		
		//[2] 유효하지 않은 번호면
		int pdsNo = Integer.parseInt(pdsNoStr);
		PdsDto pdsDto = pdsDao.selectOne(pdsNo);
		if (pdsDto == null) {
			throw new TargetNotfoundException("존재하지 않는 게시글");
		}
		
		//[3] 비회원인 경우
		HttpSession session = request.getSession();
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return true;
		}
		
		//[4] 이미 읽은 게시물이면
		EmpDto empDto = empDao.selectOne(loginId);
		String empNo = empDto.getEmpNo();
		int count = pdsReadDao.count(empNo, pdsNo);
		if (count > 0) {
			return true;
		}
		
		pdsReadDao.insert(empNo, pdsNo);
		pdsDao.updatePdsReadcount(pdsNo);
		
		return true;
	}
}
