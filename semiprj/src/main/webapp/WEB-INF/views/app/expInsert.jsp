<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>


<form action="./insert" method="post" autocomplete="off">
	<div class="cell center">
		<h1>품의서</h1>
	</div>
	<div class="container w-900 mt-50 mb-50">
		<div class="cell mt-40">
			<label>결재명</label>
			<input type="text" name="appTitle" class="field w-50">
		</div>
		<div class="cell mt-40">
			<label>결재 기안자</label>
		</div>
		<div class="cell mt-40">
			<label>결재내용</label>
			<input type="text" name="appContent" class="field w-80">
		</div>
		<div class="cell mt-40">
			<label>기안일</label>
			<input type="date" name="appDate" class="field w-50">
		</div>
		<div class="cell mt-40">
			<label>품의목적</label>
			<input type="text" name="appDate" class="field w-50">
		</div>
		<div class="cell mt-40">
			<label>지출일자</label>
			<input type="date" name="appDate" class="field w-50">
		</div>
		<div class="cell mt-40">
			<label>지출금액</label>
			<input type="text" name="appDate" class="field w-50">
		</div>
		<div class="cell mt-40">
			<label>지출내역</label>
			<input type="text" name="appDate" class="field w-50">
		</div>
		<div class="cell mt-40">
			<label>지출처 및 지급방법</label>
			<input type="text" name="appDate" class="field w-50">
		</div>
	</div>
</form>