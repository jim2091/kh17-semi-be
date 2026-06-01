package com.kh.semiprj.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.EmpDto;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class HomeInterceptors implements HandlerInterceptor{
	@Autowired
	private EmpDao empDao;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();

        String loginId =
                (String) session.getAttribute("loginId");

        if(loginId != null) {

            EmpDto loginUser = empDao.selectOne(loginId);

            request.setAttribute("loginUser", loginUser);
        }

        return true;
	}
}
