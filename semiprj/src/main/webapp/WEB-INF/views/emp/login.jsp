<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

		<div class="container w-400 mt-20 mb-20">
		    <div class="cell center">
		        <h1>로그인</h1>
		    </div>
		    <form action="./login" method="post" autocomplete="off">
		        <div class="cell">
		            <span class="text-login">ID</span>
		            <input type="text" name="empId" required class="field ms-20">
		        </div>
		        <div class="cell">
		            <span class="text-login">PW</span>
		            <input type="password" name="empPw" required class="field ms-20">
		        </div>
		        <div class="cell red center" style="min-height: 1.5em;">
		            <c:if test="${param.error != null}">
		                입력한 정보가 일치하지 않습니다
		            </c:if>
		        </div>
		        <div class="cell right">
		            <button type="submit" class="btn btn-positive">로그인</button>
		        </div>
		    </form>
		    <div class="cell center">
		    	<a href="./find_id">아이디가 기억나지 않으시면 여기를 클릭하세요</a>
		    </div>
		    <div class="cell center">
		    	<a href="./find_pw">비밀번호가 기억나지 않으시면 여기를 클릭하세요</a>
		    </div>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>