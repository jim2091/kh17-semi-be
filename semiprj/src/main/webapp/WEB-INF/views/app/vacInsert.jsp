<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>

<script>
function showSelected(order) {
    let select = document.getElementById("approver" + order);
    let selectedText = select.options[select.selectedIndex].text;
    if (select.value) {
        document.getElementById("selectedName" + order).innerText = "✅ " + selectedText;
    } else {
        document.getElementById("selectedName" + order).innerText = "";
    }
}

function validateForm() {
    if (!document.getElementById("approver1").value) {
        alert("결재자 1은 필수입니다!");
        return false;
    }
    return true;
}
</script>

<form action="./vacInsert" method="post" autocomplete="off"
	onsubmit="return validateForm();">
	<div class="cell center">
		<h1>휴가신청서</h1>
	</div>
	<hr>
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
		<div class="form-section">
			<div class="form-section-title">
				<i class="fa-solid fa-users"></i> 결재자 설정
			</div>

			<c:forEach var="i" begin="1" end="3">
				<div class="approver-row">
					<span class="approver-label"> ${i}) 결재자 <c:if
							test="${i == 1}">
							<span class="required">*</span>
						</c:if>
					</span> <select id="approver${i}" name="approver${i}" class="field w-30"
						onchange="showSelected(${i})">
						<option value="">-- 선택 --</option>
						<c:forEach var="emp" items="${empList}">
							<option value="${emp.appReqId}">${emp.appTitle}/
								${emp.appContent} (${emp.appType})</option>
						</c:forEach>
					</select> <span id="selectedName${i}" class="selected-name"></span>
				</div>
			</c:forEach>
		</div>
		<div class="cell mt-40">
			<label>결재내용</label> <input type="text" name="appContent"
				class="field w-40" required maxlength="1000">
		</div>
		<div class="cell mt-40">
			<label>기안일</label> <input type="date" name="appDate"
				class="field w-80" required>
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
