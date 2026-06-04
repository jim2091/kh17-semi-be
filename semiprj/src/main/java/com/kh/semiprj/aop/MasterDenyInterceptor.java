package com.kh.semiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Service
public class MasterDenyInterceptor implements HandlerInterceptor{
	@Autowired
	private EmpDao empDao;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		//인터셉터에서는 사용자정보(request)에서 파라미터를 추출한다
		String empNo = request.getParameter("empNo");
		
		if(empNo == null) {
			throw new IllegalArgumentException("잘못된 형식의 요청");
		}
		EmpDto empDto = empDao.selectOne(empNo);
		if(empDto == null) {
			throw new TargetNotfoundException("존재하지 않는 회원");
		}
		
		
		if(empDto.getEmpLevel().equals("관리자")) {
			throw new GetOutException();
		}
		
		return true;
	}
	

}
