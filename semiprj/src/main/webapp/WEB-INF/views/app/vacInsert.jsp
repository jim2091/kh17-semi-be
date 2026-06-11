<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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

window.onload = function() {
    let today = new Date();
    let yyyy = today.getFullYear();
    let mm = String(today.getMonth() + 1).padStart(2, '0');
    let dd = String(today.getDate()).padStart(2, '0');
    document.querySelector("input[name='appDate']").value = yyyy + "-" + mm + "-" + dd;
};
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
				class="field w-60" required maxlength="100">
		</div>
		<div class="cell mt-40">
			<label>결재 기안자</label> <input type="text" value="${empName}"
				class="field w-60" readonly> <input type="hidden"
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
					</span> <select id="approver${i}" name="approver${i}" class="field w-30 mt-20"
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
				class="field w-60" required maxlength="1000">
		</div>
		<div class="cell mt-40">
			<label>기안일</label> 
			<input type="date" name="appDate" class="field w-60" readonly>
		</div>
		<div class="cell mt-40">
			<label>휴가시작일</label> <input type="date" name="vacStartDate"
				class="field w-60" required>
		</div>
		<div class="cell mt-40">
			<label>휴가종료일</label> <input type="date" name="vacEndDate"
				class="field w-60" required>
		</div>
		<div class="form-row">
			<label>휴가구분 <span class="required">*</span></label>
			<div class="vac-type-wrap">
				<label class="vac-type-item"> <input type="radio"
					name="vacType" value="연차" checked> <span><i
						class="fa-solid fa-calendar-days"></i> 연차</span>
				</label> <label class="vac-type-item"> <input type="radio"
					name="vacType" value="휴가"> <span><i
						class="fa-solid fa-umbrella-beach"></i> 휴가</span>
				</label> <label class="vac-type-item"> <input type="radio"
					name="vacType" value="병가"> <span><i
						class="fa-solid fa-kit-medical"></i> 병가</span>
				</label>
			</div>
		</div>



		<div class="cell center">
			<button class="btn" type="submit">기안</button>
			<button class="btn" type="button" onclick="location.href='./list';">취소</button>
		</div>

	</div>
</form>
