package com.kh.semiprj.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.EmpDto;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AccountStatusInterceptor implements HandlerInterceptor {

    private final EmpDao empDao;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession();

        String loginId = (String) session.getAttribute("loginId");

        // 원래는 EmpOnlyInterceptor가 먼저 막아야 하지만, 안전장치
        if (loginId == null) {
            response.sendRedirect(request.getContextPath() + "/emp/login");
            return false;
        }

        EmpDto empDto = empDao.selectOne(loginId);

        // 세션에는 있는데 DB에 사원이 없는 경우
        if (empDto == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/emp/login");
            return false;
        }

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (contextPath != null && !contextPath.isEmpty()) {
            uri = uri.substring(contextPath.length());
        }

        String empUseYn = empDto.getEmpUseYn();
        String empEmailVerified = empDto.getEmpEmailVerified();

        // 항상 허용할 주소
        if (isAlwaysAllowed(uri)) {
            return true;
        }

        // 1. 정보 입력/이메일 인증 전
        if (!"Y".equals(empEmailVerified)) {

            if (isEditAllowed(uri)) {
                return true;
            }

            response.sendRedirect(contextPath + "/emp/edit");
            return false;
        }

        // 2. 이메일 인증은 됐지만 관리자 승인 전
        if ("Y".equals(empEmailVerified) && !"Y".equals(empUseYn)) {

            if (isWaitAllowed(uri)) {
                return true;
            }

            response.sendRedirect(contextPath + "/emp/wait");
            return false;
        }

        // 3. 정상 승인 계정
        return true;
    }

    private boolean isAlwaysAllowed(String uri) {
        return uri.equals("/emp/logout")
                || uri.startsWith("/css/")
                || uri.startsWith("/js/")
                || uri.startsWith("/images/")
                || uri.startsWith("/attachment/")
                || uri.startsWith("/error");
    }

    private boolean isEditAllowed(String uri) {
    	return uri.equals("/emp/edit")
                || uri.startsWith("/emp/edit/")
                || uri.startsWith("/rest/emp/")
                || uri.startsWith("/rest/cert/")
                || uri.equals("/emp/logout");
    }

    private boolean isWaitAllowed(String uri) {
        return uri.equals("/emp/wait");
    }
}