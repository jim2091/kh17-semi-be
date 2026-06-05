<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<form action="./vacInsert" method="post" autocomplete="off">
	<div class="cell center">
		<h1>휴가신청서</h1>
	</div>
	<div class="container w-900 mt-50 mb-50">
		<div class="cell mt-40">
			<label>결재명</label> 
            <input type="text" name="appTitle" class="field w-40" required maxlength="100">
		</div>
		<div class="cell mt-40">
			<label>결재 기안자</label>
            <input type="text" value="${empName}" name="appReqId" class="field" readonly>
		</div>
        
		<div class="cell mt-40">
			<label>결재내용</label> 
            <input type="text" name="appContent" class="field w-40" required maxlength="1000">
		</div>
		<div class="cell mt-40">
			<label>기안일</label> 
            <input type="date" name="appDate" class="field w-40" required maxlength="1000">
		</div>
		<div class="cell mt-40">
			<label>휴가시작일</label> 
            <input type="date" name="vacStartDate" class="field w-40" required maxlength="1000">
		</div>
		<div class="cell mt-40">
			<label>휴가종료일</label> 
            <input type="date" name="vacEndDate" class="field w-40" required maxlength="1000">
		</div>
		<div class="cell mt-40">
			<label>휴가구분</label>
            <select name="vacType">
				<option value="연차">연차</option>
				<option value="휴가">휴가</option>
				<option value="병가">병가</option>
			</select>
		</div>
		
		<div class="cell center">
            <button class="btn" type="submit">기안</button>
            <button class="btn" type="button" onclick="location.href='./list';">취소</button>
		</div>
		
	</div>
</form>

