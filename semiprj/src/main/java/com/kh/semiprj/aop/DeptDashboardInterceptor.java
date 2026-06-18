package com.kh.semiprj.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeptDashboardInterceptor implements HandlerInterceptor{
	
	private final EmpDao empDao;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			throw new WhoAreYouException();
		}
		
		EmpDto empDto = empDao.selectOne(loginId);
		
		if (empDto == null) {
			throw new WhoAreYouException();
		}
		
		String loginRole = (String) session.getAttribute("loginRole");
		if ("관리자".equals(loginRole)) {
			return true;
		}
		
		if (!empDao.isManager(empDto.getEmpNo())) {
			throw new GetOutException();
		}
	
		return true;
	}
}
