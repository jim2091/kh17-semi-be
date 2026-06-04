package com.kh.semiprj.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class EmpOnlyInterceptor implements HandlerInterceptor{

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		String loginId = (String) session.getAttribute("loginId");
		String loginRole = (String) session.getAttribute("loginRole");
		String loginNo = (String) session.getAttribute("loginNo");
		if(loginId == null || loginRole == null || loginNo == null) {
			throw new WhoAreYouException();
		}
		
		
		
		return true;
				
	}

}
