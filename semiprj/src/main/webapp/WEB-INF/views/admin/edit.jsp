<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_user.jsp"></jsp:include>



<form action="./edit" method="post" autocomplete="off">
<input type="hidden" name="empNo" value="${empDto.empNo}">
<div class="container w-600 mt-50 mb-50">
	<div class="cell center">
        <h1>[${empDto.empName}]님 정보 수정</h1>
    </div>
    <div class="cell">
         <img src="/emp/profile?empNo=${empDto.empNo}" width="100">
    </div>
    <div class="cell">
        <span>사원번호 : ${empDto.empNo}</span>
    </div>
    <div class="cell">
        <span>사원실명 : ${empDto.empName}</span>
    </div>    
    <div class="cell">
    	<label>사원부서 :</label>
		<select name="empDept" class="field">
			<option ${empDto.empDept=='영업'? 'selected' : '' }>영업</option>
			<option ${empDto.empDept=='관리'? 'selected' : '' }>관리</option>
			<option ${empDto.empDept=='감사'? 'selected' : '' }>감사</option>
		</select>
    </div>
    <div class="cell">
    	<label>사원직위 :</label>
		<select name="empPosition" class="field">
			<option ${empDto.empPosition=='사원'? 'selected' : '' }>사원</option>
			<option ${empDto.empPosition=='과장'? 'selected' : '' }>과장</option>
			<option ${empDto.empPosition=='이사'? 'selected' : '' }>이사</option>
		</select>
    </div>    
 				<!-- 추후 직위 종류 늘리기 -->
 				
 	<div class="cell">
 		<label>담당사수 :</label>
 	</div>
    <div class="cell">	
 		<input type="text" name="empMentor" value="${empDto.empMentor}" class="field">
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
 		<label>권한 :</label>
 		<select name="empLevel" class="field">
			<option ${empDto.empLevel=='사용자'? 'selected' : '' }>사용자</option>
			<option ${empDto.empLevel=='관리자'? 'selected' : '' }>관리자</option>
		</select>
	</div>	
	<div class="cell">
		<span>활성화여부 : ${empDto.empUseYn}</span>
		<a href="./useYn?empNo=${empDto.empNo}" class="btn btn-neutral">
 				  ${empDto.empUseYn == 'Y' ? '비활성화하기' : '활성화하기'}
 		</a>
	</div>		
	<div class="cell">
		<label>입사일 :</label>
	</div>
    <div class="cell">
		<input type="date" name="hireDateStr" value="${hireDate}" class="field">
	</div>
	<div class="cell">
		<label>퇴사일 :</label>
	</div>
    <div class="cell">	
		<input type="date" name="retiredDateStr" value="${retiredDate}" class="field">
	</div>
	<div class="cell">
		<span>등록일 : <fmt:formatDate value = "${empDto.empCreateAt}" pattern="yyyy-MM-dd"/></span>
	</div>
	<div class="cell">
		<span>최종 비밀번호 변경일 : <fmt:formatDate value = "${empDto.empPwChange}" pattern="y년 M월 d일 E a h시 m분"/></span>
	</div>
	<div class="cell">
		<button type="submit" class="btn btn-positive">수정완료</button>
		<a href="./list" class="btn btn-neutral">목록으로</a>
	</div>
</div>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include></html>