<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.find-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 70vh;
    padding: 20px;
}

.find-card {
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
    width: 100%;
    max-width: 460px;
    padding: 30px;
}

.find-header {
    text-align: center;
    margin-bottom: 25px;
}

.find-header h1 {
    font-size: 26px;
    font-weight: 800;
    margin-bottom: 10px;
    color: #1f2937;
}

.find-header p {
    font-size: 14px;
    color: #6b7280;
    line-height: 1.4;
}

.input-group {
    position: relative;
    margin-bottom: 15px;
}

.input-group i {
    position: absolute;
    left: 14px;
    top: 24px; /* 에러 메시지 공간 확보로 인한 아이콘 위치 조정 */
    transform: translateY(-50%);
    color: #9ca3af;
    font-size: 16px;
}

.find-field {
    width: 100%;
    padding: 12px 14px 12px 42px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 15px;
    outline: none;
    transition: all 0.2s ease-in-out;
    box-sizing: border-box;
}

.find-field:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}
.find-actions{
	    margin-top:20px;
	    display:flex;
	    justify-content:center;
	    gap:12px;
	}
	.found-id{
    display:inline-block;
    padding:14px 28px;
    margin-top:12px;

    background:#f8fafc;
    border:1px solid #dbeafe;
    border-radius:12px;

    font-size:24px;
    font-weight:800;
    color:var(--main-color);
}
</style>



<div class="find-wrapper">
    <div class="find-card">
        
        <div class="find-header">
			<h1><i class="fa-regular fa-circle-check" style="color: #3b82f6; margin-right: 6px;"></i>찾은 아이디</h1>

		    <div class="cell mt-40">
		    	<!-- 지금은 addFlashAttribute로 받은 상태라 새로고침하면 아이디 사라짐. 고칠지 고민 -->
		    	<span class="found-id field2 w-200" style="display: inline-block;">${findId}</span>
		    </div>
		    
		    <div class="find-header">
		    	<p>혹시 비밀번호를 잊으셨나요?</p>
		    </div>
		    
		    <div class="find-actions">
				<a href="./find_pw" class="gw-btn-outline">비밀번호 찾기</a>
				<a href="./login" class="gw-btn-primary">로그인하러 가기</a>
		    </div>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>