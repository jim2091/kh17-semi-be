<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<h1>[${empDto.empName}]님 정보</h1>
<img src="./profile?empNo=${empDto.empNo}" width="100"><br>
 		사원사진
 <ul>
 		
 		<li>사원실명 : ${empDto.empName}</li>
 		<li>사원아이디 : ${empDto.empId}</li>
 		<li>사원부서 : ${empDto.empDept}</li>
 		<li>사원직위 : ${empDto.empPosition}</li>
 		<li>담당사수 : ${empDto.empMentor}</li>
 		<li>생년월일 : ${empDto.empBirth}</li>
 		<li>이메일주소 : ${empDto.empEmail}</li>
 		<li>연락처 : ${empDto.empContact}</li>
 		<li>주소 : [${empDto.empPost}]  ${empDto.empAddress1}  ${empDto.empAddress2}</li>
 		<li>입사일 :<fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd"/></li>
 </ul>
<h2><a href="./edit?empNo=${empDto.empNo}">내정보수정</a>
<a href="./list">목록으로</a>
</h2>


<br><br>
 	<h1>	[최근 로그인 이력 ] </h1>
 <table border="1" width="1200">
	<thead>
			<tr>
				<th>일시</th>
				<th>접속주소</th>
				<th>에이전트</th>
			</tr>
	</thead>
	<tbody>
		<c:forEach var= "empHistoryDto" items="${loginHistory}">
		<tr>
			<td>${empHistoryDto.empHistoryTime}</td>
			<td>${empHistoryDto.empHistoryAddress}</td>
			<td>${empHistoryDto.empHistoryAgent}</td>
		</tr>
		</c:forEach>
	</tbody>
</table>
 
<h2><a href="./list">검색으로 이동</a></h2>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>