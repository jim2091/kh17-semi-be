<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightpick/1.6.2/css/lightpick.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightpick/1.6.2/lightpick.min.js"></script>

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


$(function(){
    // 1. 상태 객체
    var state = {
        vacStartDateValid : false,
        vacEndDateValid : false,
        
        ok : function() {
            return Object.values(this)
                    .filter(v => typeof v === "boolean")
                    .every(v => v === true);
        }
    };

    // 오늘 날짜를 기안일(appDate)에 기본값으로 세팅
    var today = moment().format("YYYY-MM-DD");
    $("[name=appDate]").val(today);

    var startPicker = new Lightpick({
        field: $("[name=vacStartDate]")[0],
        format: "YYYY-MM-DD",
        firstDay: 7,
        minDate: moment(), // 오늘부터 미래만 선택 가능
        onError: function(message) {
            console.error("Lightpick 에러:", message);
            $("[name=vacStartDate]").val(moment().format("YYYY-MM-DD"));
        },
        onSelect: function(date){
            $("[name=vacStartDate]").trigger("change");
        }
    });

    var endPicker = new Lightpick({
        field: $("[name=vacEndDate]")[0],
        format: "YYYY-MM-DD",
        firstDay: 7,
        minDate: moment(), // 종료일도 기본적으로 오늘부터 선택 가능
        onError: function(message) {
            console.error("Lightpick 에러:", message);
            $("[name=vacEndDate]").val(moment().format("YYYY-MM-DD"));
        },
        onSelect: function(date){
            $("[name=vacEndDate]").trigger("change");
        }
    });

    // 2. 휴가 시작일 변경 시 검사
    $("[name=vacStartDate]").on("change", function(){
        var appDate = $("[name=appDate]").val() || today; 
        var startDate = $(this).val();
        var endDate = $("[name=vacEndDate]").val();

        if(!startDate) {
            $(this).removeClass("success fail").removeAttr("data-error");
            state.vacStartDateValid = false;
            return;
        }

        if(startDate < appDate) {
            $(this).removeClass("success fail").addClass("fail").attr("data-error", "1");
            state.vacStartDateValid = false;
        } else {
            $(this).removeClass("success fail").addClass("success").removeAttr("data-error");
            state.vacStartDateValid = true;
            
            endPicker.setMinDate(moment(startDate));
        }

        if(endDate) {
            $("[name=vacEndDate]").trigger("change");
        }
    });

    // 3. 휴가 종료일 변경 시 검사
    $("[name=vacEndDate]").on("change", function(){
        var startDate = $("[name=vacStartDate]").val();
        var endDate = $(this).val();

        if(!endDate) {
            $(this).removeClass("success fail").removeAttr("data-error");
            state.vacEndDateValid = false;
            return;
        }

        if(!startDate) {
            $(this).removeClass("success fail").removeAttr("data-error");
            state.vacEndDateValid = false;
            return;
        }

        if(endDate < startDate) {
            $(this).removeClass("success fail").addClass("fail").attr("data-error", "1");
            state.vacEndDateValid = false;
        } else {
            $(this).removeClass("success fail").addClass("success").removeAttr("data-error");
            state.vacEndDateValid = true;
        }
    });

    // 4. 폼 서밋 시 최종 차단
    $("#vacationForm").on("submit", function(e){
        if(state.ok() == false) {
            e.preventDefault(); 
            $("[name=vacStartDate]").trigger("change");
            $("[name=vacEndDate]").trigger("change");
            $(".field.fail").first().focus();
        }
    });
});
</script>

<form action="./vacInsert" method="post" autocomplete="off"
	id="vacationForm" onsubmit="return validateForm();">
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
					</span> <select id="approver${i}" name="approver${i}"
						class="field w-30 mt-20" onchange="showSelected(${i})">
						<option value="">-- 선택 --</option>
						<c:forEach var="emp" items="${empList}">
							<option value="${emp.appReqId}">${emp.appTitle}/
								${emp.appContent} (${emp.appType})</option>
						</c:forEach>
					</select> <span id="selectedName${i}" class="selected-name"></span>
				</div>
			</c:forEach>
		</div>


		<%-- 에러 메시지 --%>
		<c:if test="${not empty errorMsg}">
			<div
				style="background: #ffebee; color: #c62828; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px;">
				⚠️ ${errorMsg}</div>
		</c:if>


		<div class="cell mt-40">
			<label>결재내용</label> <input type="text" name="appContent"
				class="field w-60" required maxlength="1000">
		</div>
		<div class="cell mt-40">
			<label>기안일</label> <input type="date" name="appDate"
				class="field w-60" readonly>
		</div>

		<div class="cell mt-40">
			<label>휴가시작일</label> 
			<input type="text" name="vacStartDate" class="field w-60" required placeholder="YYYY-MM-DD">

			<div class="fail-feedback">
				<div>휴가 시작일은 기안일(오늘) 이후여야 합니다.</div>
			</div>
		</div>

		<div class="cell mt-40">
			<label>휴가종료일</label> 
			<input type="text" name="vacEndDate" class="field w-60" required placeholder="YYYY-MM-DD">

			<div class="fail-feedback">
				<div>휴가 종료일은 시작일보다 빠를 수 없습니다.</div>
			</div>
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