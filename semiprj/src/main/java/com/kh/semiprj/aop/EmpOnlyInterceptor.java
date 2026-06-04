package com.kh.semiprj.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//비회원 접근을 차단하는 인터셉터
@Service
public class EmpOnlyInterceptor implements HandlerInterceptor{
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		String loginId = (String) session.getAttribute("loginId");
		String loginRole = (String) session.getAttribute("loginRole");
		if(loginId == null || loginRole == null) {
			throw new WhoAreYouException();
		}
		return true;
	}
}
