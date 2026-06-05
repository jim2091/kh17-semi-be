<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_user.jsp"></jsp:include>



<form action="./edit" method="post" autocomplete="off" enctype="multipart/form-data">
	<input type="hidden" name="empNo" value="${empDto.empNo}">
	<div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>[${empDto.empName}]님 정보 수정</h1>
        </div>
        <div class="cell">
			<img src="./profile?empNo=${empDto.empNo}" width="150">
			(기존사진)
        </div>
        <div class="cell">
        	<input type="file" name="attach" accept=".png, .jpeg">
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
            <label>생년월일 : </label>
		</div>
        <div class="cell">            
            <input type="text" name="empBirth" value="${empDto.empBirth}">
        </div>
        <div class="cell">
            <label>이메일주소 : </label>
        </div>
        <div class="cell">
            <input type="text" name="empEmail" value="${empDto.empEmail}">
        </div>
        <div class="cell">
            <label>연락처 : </label>
        </div>
        <div class="cell"> 
            <input type="text" name="empContact" value="${empDto.empContact}">
        </div>
        <div class="cell mt-0">
            <label>주소</label>
        </div>
        <div class="cell">
            <input type="text" inputmode="numeric" name="empPost" 
                value="${empDto.empPost}" size="6" maxlength="6" placeholder="우편번호">
            <button type="button" class="btn btn-neutral btn-post">
                    <i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <div class="cell">
            <input type="text" name="empAddress1" value="${empDto.empAddress1}" placeholder="기본주소">
        </div>
        <div class="cell">
            <input type="text" name="empAddress2" value="${empDto.empAddress2}" placeholder="상세주소">
        </div>
        <div class="cell">
            <span>입사일 :<fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd"/></span>
        </div>
        <div class="cell">
        	
        <button type="submit" class="btn btn-positive">수정하기</button>
			<a href="./mypage" class="btn btn-neutral">돌아가기</a>
			<a href="./password" class="btn btn-neutral">비밀번호 변경하기</a>
		</div>
</div>
	
</form>




<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include></html>