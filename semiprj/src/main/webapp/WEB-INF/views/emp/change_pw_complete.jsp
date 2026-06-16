<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
	.password-panel{
	    max-width:700px;
	    margin:80px auto;
	    padding:50px 40px;
	    background:white;
	    border:1px solid #e5e7eb;
	    border-radius:16px;
	    text-align:center;
	}
	
	.password-icon{
	    width:90px;
	    height:90px;
	    margin:0 auto 24px;
	    border-radius:50%;
	    background:#edf4ff;
	    color:var(--main-color);
	    display:flex;
	    align-items:center;
	    justify-content:center;
	}
	
	.password-title{
	    font-size:28px;
	    font-weight:700;
	    color:#111827;
	    margin-bottom:12px;
	}
	
	.password-desc{
		font-size:15px;
	    color:#6b7280;
	    line-height:1.7;
	    margin-bottom:32px;
	}
	
	.password-actions{
	    margin-top:40px;
	    display:flex;
	    justify-content:center;
	    gap:12px;
	}
	.password-guide{
	    background:#f8fafc;
	    border:1px solid #e5e7eb;
	    border-radius:12px;
	
	    padding:16px;
	    margin-top:24px;
	
	    text-align:left;
	
	    color:#6b7280;
	    font-size:14px;
	    line-height:1.8;
	}
	.input-group{
	    text-align:left;
	    margin-bottom:20px;
	}
	
	.input-group label{
	    display:block;
	    margin-bottom:8px;
	    font-size:14px;
	    font-weight:700;
	    color:#374151;
	}
</style>
<div class="password-panel">
	<div class="password-icon">
		<i class="fa-solid fa-check fa-2x"></i>
	</div>
	
	<div class="password-title">
		비밀번호 변경이 완료되었습니다
	</div>
	<div class="password-desc mb-30">
	    새로운 비밀번호가 정상적으로 저장되었습니다.<br>
	    변경된 비밀번호로 다시 로그인해주세요.
	</div>
	
	<div class="password-actions">
 		<a href="./login" class="gw-btn-primary"><i class="fa-solid fa-right-to-bracket"></i>로그인하러 가기</a>
	</div>

</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>