<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<h1>[${empDto.empName}]사원 정보 수정</h1>


<form action="./edit" method="post" autocomplete="off" enctype="multipart/form-data">
	<input type="hidden" name="empNo" value="${empDto.empNo}">
<ul>
 		<li>사원번호 : ${empDto.empNo}</li>
 		<li>사원실명 : ${empDto.empName}</li>
 		<li>사진 <input type="file" name="attach" accept=".png, .jpeg"><br><br>
	(기존사진)<br>
		<img src="./profile?empNo=${empDto.empNo}" width="80"><br><br></li>
 		<li>사원부서 : ${empDto.empDept}</li>
 		<li>사원직위 : ${empDto.empPosition}</li>
 		<li>담당사수! : ${empDto.empMentor}</li>
 		<li>사원아이디 : ${empDto.empId}</li>
 		<li>생년월일 : <input type="text" name="empBirth" value="${empDto.empBirth}"></li>
 		<li>이메일주소 : <input type="text" name="empEmail" value="${empDto.empEmail}"></li>
 		<li>연락처 : <input type="text" name="empContact" value="${empDto.empContact}"></li>
 		<li>주소 : 
 		<input type="text" name="empPost" value="${empDto.empPost}"><br>
 		<input type="text" name="empAddress1" value="${empDto.empAddress1}"><br>
 		<input type="text" name="empAddress2" value="${empDto.empAddress2}"><br>
 		</li>
 		
 		<li>입사일 : ${empDto.empHireDate} </li>
 		<li>최종 비밀번호 변경일 : <fmt:formatDate value = "${empDto.empPwChange}" pattern="y년 M월 d일 E a h시 m분"/></li>
 </ul>
 

		
	<button type="submit">수정하기</button>
	<a href="./mypage">돌아가기</a>
	<a href="./password">비밀번호 변경하기</a>
	
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include></html>