<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<h1>사원 검색</h1>

<div class="cell right">
	<a href="./register">사원등록하기</a>
</div>

<form action="./list" method="get">
	<select name="column">
		<option value="emp_no" ${param.column == "emp_no" ? "selected" : ""}>사원번호</option>
		<option value="emp_id" ${param.column == "emp_id" ? "selected" : ""}>사원아이디</option>
		<option value="emp_name" ${param.column == "emp_name" ? "selected" : ""}>사원실명</option>
		<option value="emp_dept" ${param.column == "emp_dept" ? "selected" : ""}>부서</option>
		<option value="emp_position" ${param.column == "emp_position" ? "selected" : ""}>직위</option>
		<option value="emp_use_yn" ${param.column == "emp_use_yn" ? "selected" : ""}>활성화여부</option>
	</select>
<input type="text" name="keyword" placeholder="검색어 입력" 
							value="${param.keyword}" required>
<button>검색<i class="fa-solid fa-magnifying-glass"></i> </button>
</form>
<%-- <c:if test="${param.column != null && param.keyword != null}"> --%>



<table border="1" width="850">
		<thead>
				<tr align="center">
						<th>사원번호</th>
						<th>사원실명</th>
						<th>부서</th>
						<th>직위</th>
						<th>활성화여부</th>
						<th>담당사수</th>
						<th>입사일</th>
						<th>상세조회</th>
				</tr>
		</thead>
		<tbody>
			<c:forEach var="empDto" items="${list}">
				<tr align="center">
						<td>${empDto.empNo}</td>
						<td>${empDto.empName}</td>
						<td>${empDto.empDept}</td>
						<td>${empDto.empPosition}</td>
						<td>${empDto.empUseYn}</td>
						<td>${empDto.empMentor}</td>
						<td>${empDto.empHireDate}</td>
						<%-- <td><fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd E a h시 m분"/></td> --%>
						<td><a href="./detail?empNo=${empDto.empNo}"><button>상세조회</button></a></td>
				</tr>
			</c:forEach>
		</tbody>
</table>
<%-- </c:if> --%>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>