<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightpick/1.6.2/css/lightpick.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightpick/1.6.2/lightpick.min.js"></script>

<style>
.vac-type-item input[type="radio"] {
	display: none;
}
.vac-type-item {
	display: inline-flex;
	align-items: center;
	padding: 10px 20px;
	margin-right: 10px;
	border: 1px solid #cbd5e1;
	border-radius: 5px;
	cursor: pointer;
	background-color: #f9f9f9;
	color: #333;
	transition: all 0.2s ease;
}
.vac-type-item:hover {
	background-color: #f0f0f0;
	border-color: #94a3b8;
}
.vac-type-item input[type="radio"]:checked+span {
	color: #fff;
	font-weight: bold;
}
/* 테마 색상 반영 지점 */
.vac-type-item:has(input[type="radio"]:checked) {
	background-color: var(--main-color, #3b82f6);
	border-color: var(--main-color, #3b82f6);
	color: #fff;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
}
.vac-type-item i {
	margin-right: 6px;
}
.vacation-container {
	max-width: 800px;
	margin: 60px auto;
	padding: 40px;
	background: #ffffff;
	border-radius: 12px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
	font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
}
.form-title {
	font-size: 28px;
	font-weight: 700;
	color: #1e293b;
	text-align: center;
	margin-bottom: 30px;
	letter-spacing: -0.5px;
}
.form-group {
	margin-bottom: 24px;
}
.form-group label {
	display: block;
	font-size: 14px;
	font-weight: 600;
	color: #475569;
	margin-bottom: 8px;
}
.form-group label .required {
	color: #ef4444;
	margin-left: 4px;
}
.input-field {
	width: 100%;
	padding: 12px 16px;
	font-size: 15px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	background-color: #ffffff;
	color: #334155;
	transition: all 0.2s ease-in-out;
	box-sizing: border-box;
}
/* 테마 색상 반영 지점 */
.input-field:focus {
	outline: none;
	border-color: var(--main-color, #3b82f6);
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}
.input-field[readonly] {
	background-color: #f8fafc;
	color: #64748b;
	cursor: not-allowed;
}
.input-field.success {
	border-color: #10b981;
	background-color: #f0fdf4;
}
.input-field.fail {
	border-color: #ef4444;
	background-color: #fef2f2;
}
.fail-feedback {
	display: none;
	color: #ef4444;
	font-size: 13px;
	margin-top: 6px;
	font-weight: 500;
}
.input-field.fail+.fail-feedback {
	display: block;
}
.approval-row-flex {
    display: flex;
    align-items: stretch;
    gap: 12px;
    width: 100%;
}
.appr-box-item {
    flex: 1;
    position: relative;
    display: flex;
    flex-direction: column;
}
.appr-box-item .input-field {
    padding-top: 24px;
    font-size: 14px;
    text-align: center;
    background-color: #f8fafc;
}
.appr-badge {
    position: absolute;
    top: 6px;
    left: 8px;
    font-size: 11px;
    font-weight: 700;
    padding: 2px 8px;
    background: #64748b;
    color: white;
    border-radius: 4px;
    z-index: 2;
}





/* 테마 색상 반영 지점 */
.appr-badge.gold {
    background: var(--main-color, #3b82f6);
}
.vac-type-wrap {
	display: flex;
	gap: 16px;
}
.vac-type-item {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	padding: 14px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	cursor: pointer;
	font-size: 15px;
	font-weight: 500;
	color: #64748b;
	transition: all 0.2s;
	background: #ffffff;
}
.vac-type-item:hover {
	background-color: #f8fafc;
	border-color: #94a3b8;
}
/* 테마 색상 반영 지점 */
.vac-type-item:has(input:checked) {
	border-color: var(--main-color, #3b82f6);
	background-color: #f8fafc;
	color: var(--main-color, #3b82f6);
	font-weight: 600;
	box-shadow: 0 0 0 1px var(--main-color, #3b82f6);
}
.btn-group {
	display: flex;
	justify-content: center;
	gap: 12px;
	margin-top: 40px;
	border-top: 1px solid #e2e8f0;
	padding-top: 30px;
}
.btn-submit, .btn-cancel {
	padding: 14px 32px;
	font-size: 16px;
	font-weight: 600;
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.2s;
	min-width: 120px;
	border: none;
}
/* 테마 색상 반영 지점 */
.btn-submit {
	background-color: var(--main-color, #3b82f6);
	color: #ffffff;
}
.btn-submit:hover {
	filter: brightness(90%);
}
.btn-cancel {
	background-color: #f1f5f9;
	color: #475569;
}
.btn-cancel:hover {
	background-color: #e2e8f0;
}
.btn-search-unified {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    background-color: #1e293b;
    color: #ffffff;
    border: none;
    padding: 0 24px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s;
    white-space: nowrap;
}
.btn-search-unified:hover {
    background-color: #0f172a;
}
</style>
<script>
	$(function() {
		var savedTheme = localStorage.getItem("gwTheme");

		if (savedTheme) {
			$("body").addClass(savedTheme);
		} else {
			$("body").addClass("theme-blue");
		}

		$(".theme-btn").click(function() {
			$(".theme-popup").toggle();
		});

		$(".theme-item").click(
				function() {
					var theme = $(this).data("theme");

					$("body").removeClass(
							"theme-blue theme-green theme-purple theme-dark")
							.addClass(theme);

					localStorage.setItem("gwTheme", theme);

					$(".theme-popup").hide();
				});

		$(".check-all").change(function() {
			$("input[name=pdsNoList]").prop("checked", this.checked);
		});

		$("input[name=pdsNoList]")
				.change(
						function() {
							$(".check-all")
									.prop(
											"checked",
											$("input[name=pdsNoList]").length == $("input[name=pdsNoList]:checked").length);
						});
	});
</script>


<script>
$(function(){
    // [추가] list.jsp와 동일한 테마 영속성 검증 및 body 클래스 인젝션
    var savedTheme = localStorage.getItem("gwTheme");
    if (savedTheme) {
        $("body").removeClass("theme-blue theme-green theme-purple theme-dark").addClass(savedTheme);
    } else {
        $("body").addClass("theme-blue");
    }

    var state = {
        vacStartDateValid : false,
        vacEndDateValid   : false,
        ok : function() {
            return Object.values(this).filter(v => typeof v === "boolean").every(v => v === true);
        }
    };

    var today = moment().format("YYYY-MM-DD");
    $("[name=appDate]").val(today);

    var startEl = $("[name=vacStartDate]")[0];
    var endEl   = $("[name=vacEndDate]")[0];
    var startPicker, endPicker;

    if(startEl && endEl) {
        startPicker = new Lightpick({
            field: startEl, format: "YYYY-MM-DD", firstDay: 7, minDate: moment(),
            onSelect: function(){ $("[name=vacStartDate]").trigger("change"); }
        });
        endPicker = new Lightpick({
            field: endEl, format: "YYYY-MM-DD", firstDay: 7, minDate: moment(),
            onSelect: function(){ $("[name=vacEndDate]").trigger("change"); }
        });
    }

    $("[name=vacStartDate]").on("change", function(){
        var appDate   = $("[name=appDate]").val() || today;
        var startDate = $(this).val();
        var endDate   = $("[name=vacEndDate]").val();
        if(!startDate){ $(this).removeClass("success fail"); state.vacStartDateValid = false; return; }
        if(startDate < appDate){ $(this).removeClass("success").addClass("fail"); state.vacStartDateValid = false; }
        else { $(this).removeClass("fail").addClass("success"); state.vacStartDateValid = true; if(endPicker) endPicker.setMinDate(moment(startDate)); }
        if(endDate) $("[name=vacEndDate]").trigger("change");
    });

    $("[name=vacEndDate]").on("change", function(){
        var startDate = $("[name=vacStartDate]").val();
        var endDate   = $(this).val();
        if(!endDate || !startDate){ $(this).removeClass("success fail"); state.vacEndDateValid = false; return; }
        if(endDate < startDate){ $(this).removeClass("success").addClass("fail"); state.vacEndDateValid = false; }
        else { $(this).removeClass("fail").addClass("success"); state.vacEndDateValid = true; }
    });

    $("#vacationForm").on("submit", function(e){
        if(!state.ok()){
            e.preventDefault();
            $("[name=vacStartDate]").trigger("change");
            $("[name=vacEndDate]").trigger("change");
            $(".input-field.fail").first().focus();
            return false;
        }
        
        var approver1 = document.getElementById('approverNo_1').value;
        if (!approver1) {
            e.preventDefault();
            return false;
        }
    });
});
</script>

<div class="gw-page-head pds-width">
	<div class="gw-breadcrumb">홈 / 전자결재 / 휴가신청서</div>
</div>

<div class="vacation-container">
	<h1 class="form-title">휴가 신청서</h1>

	<form action="./vacInsert" method="post" autocomplete="off" id="vacationForm">

		<div class="form-group">
			<label>결재명<span class="required">*</span></label> 
			<input type="text" name="appTitle" class="input-field" required maxlength="100">
		</div>

		<div class="form-group">
			<label>결재 기안자</label> 
			<input type="text" value="${empName}" class="input-field" readonly> 
			<input type="hidden" value="${empId}" name="appReqId">
		</div>
		
		<div class="form-group">
			<label>결재자 설정<span class="required">*</span></label>
			<div class="approval-row-flex">
				<div class="appr-box-item">
					<span class="appr-badge gold">1순위</span> 
					<input type="text" id="approverDisplay_1" class="input-field" placeholder="미지정" readonly> 
					<input type="hidden" id="approverNo_1" name="approver1" value=""> 
					<input type="hidden" id="approverName_1" name="approverName1" value=""> 
					<input type="hidden" id="approverLevel_1" name="approverLevel1" value="">
					<input type="hidden" id="approverDept_1" value="">
				</div>

				<div class="appr-box-item">
					<span class="appr-badge">2순위</span> 
					<input type="text" id="approverDisplay_2" class="input-field" placeholder="미지정" readonly> 
					<input type="hidden" id="approverNo_2" name="approver2" value=""> 
					<input type="hidden" id="approverName_2" name="approverName2" value=""> 
					<input type="hidden" id="approverLevel_2" name="approverLevel2" value="">
					<input type="hidden" id="approverDept_2" value="">
				</div>

				<div class="appr-box-item">
					<span class="appr-badge">3순위</span> 
					<input type="text" id="approverDisplay_3" class="input-field" placeholder="미지정" readonly> 
					<input type="hidden" id="approverNo_3" name="approver3" value=""> 
					<input type="hidden" id="approverName_3" name="approverName3" value=""> 
					<input type="hidden" id="approverLevel_3" name="approverLevel3" value="">
					<input type="hidden" id="approverDept_3" value="">
				</div>

				<button type="button" class="btn-search-unified" onclick="window.openApproverPopup(1)">
					<i class="fa-solid fa-user-gear"></i> 결재자 지정
				</button>
			</div>
		</div>

		<jsp:include page="/WEB-INF/views/template/appr_picker.jsp" />

		<div class="form-group">
			<label>결재내용<span class="required">*</span></label> 
			<input type="text" name="appContent" class="input-field" required maxlength="1000" placeholder="상세 사유를 기입해 주세요.">
		</div>

		<div class="form-group">
			<label>기안일</label> 
			<input type="date" name="appDate" class="input-field" readonly>
		</div>

		<div class="form-group">
			<label>휴가 시작일<span class="required">*</span></label> 
			<input type="text" name="vacStartDate" class="input-field" required placeholder="YYYY-MM-DD">
			<div class="fail-feedback">
				<i class="fa-solid fa-circle-exclamation"></i> 휴가 시작일은 기안일(오늘) 이후여야 합니다.
			</div>
		</div>

		<div class="form-group">
			<label>휴가 종료일<span class="required">*</span></label> 
			<input type="text" name="vacEndDate" class="input-field" required placeholder="YYYY-MM-DD">
			<div class="fail-feedback">
				<i class="fa-solid fa-circle-exclamation"></i> 휴가 종료일은 시작일보다 빠를 수 없습니다.
			</div>
		</div>

		<div class="form-group">
			<label>휴가 구분<span class="required">*</span></label>
			<div class="vac-type-wrap">
				<label class="vac-type-item">
					<input type="radio" name="vacType" value="연차" checked>
					<span><i class="fa-solid fa-calendar-days"></i> 연차</span>
				</label> 
				<label class="vac-type-item">
					<input type="radio" name="vacType" value="휴가">
					<span><i class="fa-solid fa-umbrella-beach"></i> 휴가</span>
				</label> 
				<label class="vac-type-item">
					<input type="radio" name="vacType" value="병가">
					<span><i class="fa-solid fa-kit-medical"></i> 병가</span>
				</label>
			</div>
		</div>

		<div class="btn-group">
			<button class="btn-submit" type="submit">기안하기</button>
			<button class="btn-cancel" type="button" onclick="location.href='./list';">취소</button>
		</div>
	</form>
</div>