package com.kh.semiprj.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.WhoAreYouException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class MasterOnlyInterceptor implements HandlerInterceptor{

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		String loginRole = (String) session.getAttribute("loginRole");
		
		if(loginRole == null) {
			throw new WhoAreYouException();
		}
		if(!loginRole.equals("관리자")) {
			throw new GetOutException();
		}
		return true;
		
	}
	

}
