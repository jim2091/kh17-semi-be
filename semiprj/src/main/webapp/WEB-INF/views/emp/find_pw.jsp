<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

		<div class="container w-600 mt-20 mb-20">
		    <div class="cell center">
		        <h1>비밀번호 찾기</h1>
		    </div>
		    <div class="cell center">
		    	<h3>아래 정보를 입력하시면 인증번호를 메일로 발송해드립니다</h3>
		    </div>
		    <form action="./find_pw" method="post" autocomplete="off">
		        <div class="cell">
		            <div>이름</div>
		            <input type="text" name="empName" required class="field">
		        </div>
		        <div class="cell">
		            <div>이메일</div>
		            <input type="email" name="empEmail" required class="field">
		        </div>
		        <div class="cell red" style="min-height: 1.5em;">
		            <c:if test="${param.error != null}">
		                입력한 정보가 일치하지 않습니다
		            </c:if>
		        </div>
		        <div class="cell right">
		  		    <a href="./login" class="btn btn-neutral">로그인 페이지로 이동</a>
		            <button type="submit" class="btn btn-positive">다음</button>
		        </div>
		
		    </form>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>