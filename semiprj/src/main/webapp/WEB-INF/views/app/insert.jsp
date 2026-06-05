<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<form action="./insert" method="post" autocomplete="off">
	<div class="cell center">
		<a href="./vacInsert">휴가신청서</a>
		<a href="./expInsert">품의서</a>
		<a href="./dftInsert">업무기안서</a>
	</div>
	<div class="container w-900 mt-50 mb-50">
		<div class="cell mt-40">
			<label>결재명</label> 
            <input type="text" name="appTitle" class="field w-50" required maxlength="100">
		</div>
        
		<div class="cell mt-40">
			<label>결재 기안자</label>
            <input type="text" value="${empName}" name="appReqId" class="field" readonly>
		</div>
        
		<div class="cell mt-40">
			<label>결재내용</label> 
            <input type="text" name="appContent" class="field w-80" required maxlength="1000">
		</div>
		
		<!-- 추후 날짜형식 yyyy-MM-dd 만 들어갈수 있게  -->
		<div class="cell mt-40">
			<label>기안일</label> 
            <input type="date" name="appDate" class="field w-80" required maxlength="1000">
		</div>
        
		<div class="cell center">
            <button class="btn" type="submit">기안</button>
            <button class="btn" type="button" onclick="location.href='./list';">취소</button>
		</div>
	</div>
</form>



