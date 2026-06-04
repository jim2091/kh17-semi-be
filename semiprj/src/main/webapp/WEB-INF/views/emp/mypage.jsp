<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>[${empDto.empName}]사원 상세 정보</h1>
        </div>
        <div class="cell">
            <img src="./profile?empNo=${empDto.empNo}" width="100">
        </div>
        
        <div class="cell">
            <span>사원실명 : ${empDto.empName}</span>
        </div>
        <div class="cell">
            <span>사원부서 : ${empDto.empDept}</span>
        </div>
        <div class="cell">
            <span>사원직위 : ${empDto.empPosition}</span>
        </div>
        <div class="cell">
            <span>담당사수 : ${empDto.empMentor}</span>
        </div>
        <div class="cell">
            <span>사원아이디 : ${empDto.empId}</span>
        </div>
        <div class="cell">
            <span>생년월일 : ${empDto.empBirth}</span>
        </div>
        <div class="cell">
            <span>이메일주소 : ${empDto.empEmail}</span>
        </div>
        <div class="cell">
            <span>연락처 : ${empDto.empContact}</span>
        </div>
        <div class="cell">
            <span>주소 : [${empDto.empPost}]  ${empDto.empAddress1}  ${empDto.empAddress2}</span>
        </div>
        <div class="cell">
            <span>입사일 :<fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd"/></span>
        </div>
        <div class="cell">
        	<c:if test="${sessionScope.loginNo != null && sessionScope.loginNo == empDto.empNo}">
            <a href="./edit?empNo=${empDto.empNo}" class="btn btn-neutral">내정보수정</a>
            </c:if>
            <a href="./list" class="btn btn-neutral">목록으로</a>
        </div>
        


</div>

<div class="container w-80">
	<div class="center">
		<h1>최근 로그인 이력</h1>
	</div>
	<div class="cell">
 		<table class="table table-stripe">
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
		<div class="cell center">
  		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
	</div>
</div>
 

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>