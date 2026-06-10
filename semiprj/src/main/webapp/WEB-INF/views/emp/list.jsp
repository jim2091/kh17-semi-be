<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_user.jsp"></jsp:include>

<div class="container w-80">
	<div class="center">
		<h1>사원 목록 및 검색</h1>
	</div>
    <div class="cell">
		<form action="./list" method="get">
			<select name="column" class="field">
				<option value="emp_id" ${param.column == "emp_id" ? "selected" : ""}>사원아이디</option>
				<option value="emp_name" ${param.column == "emp_name" ? "selected" : ""}>사원실명</option>
				<option value="emp_dept" ${param.column == "emp_dept" ? "selected" : ""}>부서</option>
				<option value="emp_position" ${param.column == "emp_position" ? "selected" : ""}>직위</option>
			</select>
			<input type="text" name="keyword" placeholder="검색어 입력" 
								class="field" value="${param.keyword}">
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-magnifying-glass"></i> 
				<span>검색</span>
			</button>
		</form>
	</div>


	<div class="cell">
		<table class="table table-stripe">
		<thead>
				<tr align="center">
						<th>사원실명</th>
						<th>사원아이디</th>
						<th>부서</th>
						<th>직위</th>
						<th>담당사수</th>
						<th>입사일</th>
						<th>상세조회</th>
				</tr>
		</thead>
		<tbody>
			<c:forEach var="empDto" items="${list}">
				<tr align="center">
						<td>${empDto.empName}</td>
						<td>${empDto.empId}</td>
						<td>${empDto.empDept}</td>
						<td>${empDto.empPosition}</td>
						<td>${empDto.empMentor}</td>
						<td><fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd"/></td>
						<td><a href="./detail?empNo=${empDto.empNo}"><button>상세조회</button></a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</div> 
    	<div class="cell center">
   		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
		</div>
	</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>