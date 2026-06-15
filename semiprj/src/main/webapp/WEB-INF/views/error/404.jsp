<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include> 


		<div class="container w-400 mt-20 mb-20">
		    <div class="cell center">
		        <h1>${message == null ? "존재하지 않는 대상입니다" : message}</h1>
		    </div>
		    <div class="cell"><a href="/">홈으로</a></div>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>