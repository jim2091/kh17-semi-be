<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_dept.jsp"></jsp:include>

<div class="cell center">
	<i class="fa-solid fa-bounce fa-3x fa-plus yellow"></i>
	<div>
		<h1>등록완료 되었습니다.</h1>
	</div>
		<a href = "./insert" class="btn btn-positive" >
			<i class="fa-solid fa-plus"></i>
			<span>추가등록하기</span>
		</a>
		
		<a href = "./list" class="btn btn-neutral">
			<i class="fa-solid fa-list"></i>
			<span>목록가기</span>
		</a>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>