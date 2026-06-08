<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>

<form action="./dftInsert" method="post" autocomplete="off">
	<div class="cell center">
		<h1>업무기안서</h1>
	</div>
	<div class="container w-900 mt-50 mb-50">
		<div class="cell mt-40">
			<label>결재명</label> <input type="text" name="appTitle"
				class="field w-50" required maxlength="100">
		</div>
		<div class="cell mt-40">
			<label>결재 기안자</label> <input type="text" value="${empName}"
				name="appReqId" class="field" readonly>
		</div>
		<!-- 결재자 추가 -->
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
			<div class="cell mt-40">
				<label>결재내용</label> <input type="text" name="appContent"
					class="field w-80" required maxlength="1000">
			</div>
			<div class="cell mt-40">
				<label>기안일</label> <input type="date" name="appDate"
					class="field w-80" required>
			</div>

			<%-- 업무기안서 전용 항목 --%>
			<div class="cell mt-40">
				<label>업무일</label> <input type="date" name="dftDate"
					class="field w-80" required>
			</div>

			<div class="cell center">
				<button class="btn" type="submit">기안</button>
				<button class="btn" type="button" onclick="location.href='./list';">취소</button>
			</div>
		</div>
</form>