<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<h1>[${empDto.empName}]사원 정보 수정</h1>


<form action="./edit" method="post" autocomplete="off">
<input type="hidden" name="empNo" value="${empDto.empNo}">
<ul>
 		<li>사원번호 : ${empDto.empNo}</li>
 		<li>사원실명 : ${empDto.empName}</li>
 		<li>사원부서 : 
 				<select name="empDept">
 					<option ${empDto.empDept=='영업'? 'selected' : '' }>영업</option>
 					<option ${empDto.empDept=='관리'? 'selected' : '' }>관리</option>
 					<option ${empDto.empDept=='감사'? 'selected' : '' }>감사</option>
 				</select>
 		</li>
 		<li>사원직위 : 
 				<select name="empPosition">
 					<option ${empDto.empPosition=='사원'? 'selected' : '' }>사원</option>
 					<option ${empDto.empPosition=='과장'? 'selected' : '' }>과장</option>
 					<option ${empDto.empPosition=='이사'? 'selected' : '' }>이사</option>
 				</select>
 				<!-- 추후 직위 종류 늘리기 -->
 		</li>
 		<li>담당사수! : <input type="text" name="empMentor" value="${empDto.empMentor}"></li>
 		<li>사원아이디 : ${empDto.empId}</li>
 		<li>생년월일 : ${empDto.empBirth}</li>
 		<li>이메일주소 : ${empDto.empEmail}</li>
 		<li>연락처 : ${empDto.empContact}</li>
 		<li>주소 : [${empDto.empPost}]  ${empDto.empAddress1}  ${empDto.empAddress2}</li>
 		<li>권한 : 
 				<select name="empLevel">
 					<option ${empDto.empLevel=='사용자'? 'selected' : '' }>사용자</option>
 					<option ${empDto.empLevel=='관리자'? 'selected' : '' }>관리자</option>
 				</select>
 		</li>
 		<li>활성화여부 : ${empDto.empUseYn}
 				<a href="./useYn?empNo=${empDto.empNo}">
 				  ${empDto.empUseYn == 'Y' ? '비활성화하기' : '활성화하기'}
 				</a>
 		</li>
 		<li>입사일 : <input type="date" name="hireDateStr" value="${hireDate}"> </li>
 		<li>퇴사일 : <input type="date" name="retiredDateStr" value="${retiredDate}"></li>
 		<li>등록일 : <fmt:formatDate value = "${empDto.empCreateAt}" pattern="yyyy-MM-dd"/></li>
 		<li>최종 비밀번호 변경일 : <fmt:formatDate value = "${empDto.empPwChange}" pattern="y년 M월 d일 E a h시 m분"/></li>
 </ul>

		
	<button type="submit">수정하기</button>
	<a href="./list">목록으로</a>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include></html>