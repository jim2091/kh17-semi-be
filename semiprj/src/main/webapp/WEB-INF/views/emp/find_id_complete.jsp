<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

		<div class="container w-400 mt-20 mb-20">
		    <div class="cell">
		        <h1>찾은 아이디</h1>
		    </div>
		    <div class="cell mt-40">
		    	<!-- 지금은 addFlashAttribute로 받은 상태라 새로고침하면 아이디 사라짐. 고칠지 고민 -->
		    	<span class="field2 w-200" style="display: inline-block;">${findId}</span>
		    </div>
		    <div class="cell">
		    	<span>혹시 비밀번호를 잊으셨나요?</span>
		    </div>
		    <div class="flex-area">
		    	<div class="cell">
		            <a href="./find_pw" class="btn btn-neutral">비밀번호 찾기</a>
		        </div>
		        <div class="flex-fill"></div>
		        <div class="cell">
		            <a href="./login" class="btn btn-positive">로그인하러 가기</a>
		        </div>
		    </div>
		
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>