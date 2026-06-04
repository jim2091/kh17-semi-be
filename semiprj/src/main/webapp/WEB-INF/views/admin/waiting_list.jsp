<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>



<div class="container w-80">
	<div class="center">
		<h1>대기사원 목록</h1>
	</div>

	<div class="cell">
	<table class="table table-stripe">
		<thead>
				<tr align="center">
						<th>사원실명</th>
						<th>사원아이디</th>
						<th>부서</th>
						<th>직위</th>
						<th>활성화여부</th>
						<th>담당사수</th>
						<th>입사일</th>
						<th>승인하기</th>
				</tr>
		</thead>
		<tbody>
			<c:forEach var="empDto" items="${list}">
				<tr align="center">
						<td>${empDto.empName}</td>
						<td>${empDto.empId}</td>
						<td>${empDto.empDept}</td>
						<td>${empDto.empPosition}</td>
						<td>${empDto.empUseYn}</td>
						<td>${empDto.empMentor}</td>
						<td>${empDto.empHireDate}</td>
						<td>
			 				<a href="./approval?empNo=${empDto.empNo}" class="btn btn-neutral">
			 				  ${empDto.empApprovalStatus == 'N' ? '승인하기' : '승인중'}
			 				</a>
 						</td>
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