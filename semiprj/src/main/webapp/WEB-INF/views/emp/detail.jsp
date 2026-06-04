<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>


<h1>[${empDto.empName}]사원 상세 정보</h1>
<img src="./profile?empNo=${empDto.empNo}" width="100"><br>
 		사원사진 

 <ul>
 		<li>사원번호 : ${empDto.empNo}</li>
 		<li>사원실명 : ${empDto.empName}</li>
 		<li>사원부서 : ${empDto.empDept}</li>
 		<li>사원직위 : ${empDto.empPosition}</li>
 		<li>담당사수 : ${empDto.empMentor}</li>
 		<li>생년월일 : ${empDto.empBirth}</li>
 		<li>이메일주소 : ${empDto.empEmail}</li>
 		<li>연락처 : ${empDto.empContact}</li>
 		<li>입사일 :<fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd"/></li>
</ul>
<h2>
<c:if test="${sessionScope.loginNo != null && sessionScope.loginNo == empDto.empNo}">
<a href="./edit?empNo=${empDto.empNo}">내정보수정</a>
</c:if>
<a href="./list">목록으로</a>
</h2>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>