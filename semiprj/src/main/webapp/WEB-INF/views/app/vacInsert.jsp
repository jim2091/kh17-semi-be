<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>

<form action="./vacInsert" method="post" autocomplete="off"
	onsubmit="return validateForm();">
	<div class="cell center">
		<h1>휴가신청서</h1>
	</div>
	<div class="container w-900 mt-50 mb-50">
		<div class="cell mt-40">
			<label>결재명</label> <input type="text" name="appTitle"
				class="field w-40" required maxlength="100">
		</div>
		<div class="cell mt-40">
			<label>결재 기안자</label> <input type="text" value="${empName}"
				class="field" readonly> <input type="hidden"
				value="${empId}" name="appReqId">
		</div>

		<%-- 결재자 설정 --%>
		<div class="cell mt-40">
			<h3>결재자 설정</h3>

			<%-- 결재자 1 (필수) --%>
			<div class="cell mt-10">
				<label>1) 결재자 <span style="color: red;">*</span></label> <input
					type="text" id="searchKeyword1" placeholder="이름 검색"
					class="field w-20">
				<button type="button" onclick="searchApprover(1)">검색</button>
				<div id="searchResult1"></div>
				<span id="selectedName1"></span> <input type="hidden"
					name="approver1" id="approver1">
			</div>

			<%-- 결재자 2 (선택) --%>
			<div class="cell mt-10">
				<label>2) 결재자</label> <input type="text" id="searchKeyword2"
					placeholder="이름 검색" class="field w-20">
				<button type="button" onclick="searchApprover(2)">검색</button>
				<div id="searchResult2"></div>
				<span id="selectedName2"></span> <input type="hidden"
					name="approver2" id="approver2">
			</div>

			<%-- 결재자 3 (선택) --%>
			<div class="cell mt-10">
				<label>3) 결재자</label> <input type="text" id="searchKeyword3"
					placeholder="이름 검색" class="field w-20">
				<button type="button" onclick="searchApprover(3)">검색</button>
				<div id="searchResult3"></div>
				<span id="selectedName3"></span> <input type="hidden"
					name="approver3" id="approver3">
			</div>
		</div>
		<div class="cell mt-40">
			<label>결재내용</label> <input type="text" name="appContent"
				class="field w-40" required maxlength="1000">
		</div>
		<div class="cell mt-40">
			<label>기안일</label> <input type="date" name="appDate" id="currentDate"
				class="field w-40" readonly>
		</div>
		<div class="cell mt-40">
			<label>휴가시작일</label> <input type="date" name="vacStartDate"
				class="field w-40" required>
		</div>
		<div class="cell mt-40">
			<label>휴가종료일</label> <input type="date" name="vacEndDate"
				class="field w-40" required>
		</div>
		<div class="cell mt-40">
			<label>휴가구분</label> <select name="vacType">
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
