<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<h1>등록완료 되었습니다.</h1>

	<a href = "./insert" class="btn btn-positive" >
		<i class="fa-solid fa-plus"></i>
		<span>추가등록하기</span>
	</a>
	
	<a href = "./list" class="btn btn-neutral">
		<i class="fa-solid fa-list"></i>
		<span>목록가기</span>
	</a>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>