<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>


<form action="./edit" method="post" enctype="multipart/form-data" autocomplete="off">
<input type="hidden" name="deptId" value="${deptDto.deptId}">

<div class="container w-400 mt-50 mb-50">
	<div class="cell center">
		<h1>부서 정보 수정</h1>
	</div>
	
	<div class="cell">
		<label>부서 카테고리 <i class="fa-solid fa-asterisk red"></i></label>
		<select class="field w-100" name="deptCategory" required>
            <option value="">선택하세요</option>
            <c:forEach var ="category" items="${categoryList}">
				<option value="${category.deptCategoryNo }"
						${deptDto.deptCategory == category.deptCategoryNo ? 'selected' : ''}>
					${category.deptCategoryName}
				</option>
		</c:forEach>
        </select>
	</div>
	<div class="cell">
		<label>이름 <i class="fa-solid fa-asterisk red"></i></label>
		<input type="text" name="deptName" value="${deptDto.deptName}"
				class="field w-100" required> 
	</div>
	<div class="cell">
		<label>부서장 <i class="fa-solid fa-asterisk red"></i></label>
		<input type="text" name="deptHeadId" value="${deptDto.deptHeadId}"
				class="field w-100" required> 
	</div>
	<div class="cell">
		<label>업무내용 <i class="fa-solid fa-asterisk red"></i></label>
		<input type="text" name="deptContent" value="${deptDto.deptContent}"
				class="field w-100" required>
	</div>
	
	<div class="cell mt-50">
		<button type="submit" class="btn btn-positive w-100">수정하기</button>
	</div>
</div>

</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>