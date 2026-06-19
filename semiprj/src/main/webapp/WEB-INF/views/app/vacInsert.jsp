<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/lightpick/1.6.2/css/lightpick.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lightpick/1.6.2/lightpick.min.js"></script>

<style>
.pds-width {
	max-width: 1200px;
	margin: 40px auto;
	padding: 0 20px;
	font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
}

.gw-page-head {
	margin-bottom: 35px;
	padding-bottom: 25px;
	border-bottom: 2px solid #e2e8f0;
}

.gw-breadcrumb {
	font-size: 13px;
	color: #64748b;
	margin-bottom: 12px;
	font-weight: 500;
}

.gw-page-head h1 {
	font-size: 28px;
	font-weight: 700;
	color: #0f172a;
	margin: 0 0 8px 0;
	letter-spacing: -0.5px;
}

.gw-page-head p {
	font-size: 14px;
	color: #64748b;
	margin: 0;
}

.vacation-container {
	background: #ffffff;
	border: 1px solid #e2e8f0;
	border-radius: 12px;
	padding: 40px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
}

.form-title {
	font-size: 22px;
	font-weight: 700;
	color: #1e293b;
	margin-top: 0;
	margin-bottom: 30px;
	padding-bottom: 12px;
	border-bottom: 1px solid #f1f5f9;
}

.form-group {
	margin-bottom: 24px;
}

.form-group label {
	display: block;
	font-size: 14px;
	font-weight: 600;
	color: #334155;
	margin-bottom: 8px;
}

.form-group label .required {
	color: #ef4444;
	margin-left: 4px;
}

.input-field {
	width: 100%;
	padding: 12px 16px;
	font-size: 14px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	background-color: #ffffff;
	color: #334155;
	transition: all 0.2s ease-in-out;
	box-sizing: border-box;
}

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

.approval-row-flex {
	display: flex;
	align-items: flex-start;
	gap: 16px;
	width: 100%;
}

.appr-box-item {
	flex: 1;
	position: relative;
	display: flex;
	flex-direction: column;
}

.appr-box-item .input-field {
	padding-top: 28px;
	font-size: 13px;
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
	font-size: 14px;
	font-weight: 500;
	color: #64748b;
	transition: all 0.2s;
	background: #ffffff;
}

.vac-type-item input[type="radio"] {
	display: none;
}

.vac-type-item:hover {
	background-color: #f8fafc;
	border-color: #94a3b8;
}

.vac-type-item:has(input:checked) {
	border-color: var(--main-color, #3b82f6);
	background-color: #f8fafc;
	color: var(--main-color, #3b82f6);
	font-weight: 600;
	box-shadow: 0 0 0 1px var(--main-color, #3b82f6);
}

.btn-group {
	display: flex;
	justify-content: flex-end;
	gap: 12px;
	margin-top: 40px;
	border-top: 1px solid #e2e8f0;
	padding-top: 24px;
}

.btn-submit, .btn-cancel {
	padding: 12px 28px;
	font-size: 14px;
	font-weight: 600;
	border-radius: 6px;
	cursor: pointer;
	transition: all 0.2s;
	min-width: 100px;
	border: none;
}

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
	padding: 0 20px;
	height: 45px;
	margin-top: 0;
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

.gw-upload-container {
	margin-top: 24px;
	padding: 24px;
	background: #f8fafc;
	border: 2px dashed #cbd5e1;
	border-radius: 12px;
	transition: all 0.2s ease;
}

.gw-upload-container:hover {
	border-color: var(--main-color, #3b82f6);
}

.gw-upload-label {
	display: block;
	font-size: 14px;
	font-weight: 700;
	color: #334155;
	margin-bottom: 12px;
}

.gw-file-input-wrapper {
	margin-bottom: 16px;
}

.gw-file-list {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.gw-file-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 10px 16px;
	background: #ffffff;
	border: 1px solid #e2e8f0;
	border-radius: 8px;
	font-size: 13.5px;
	color: #475569;
}

.gw-file-delete-btn {
	background: none;
	border: none;
	color: #ef4444;
	cursor: pointer;
	font-weight: 600;
	padding: 2px 6px;
	border-radius: 4px;
}

.gw-file-delete-btn:hover {
	background: #fef2f2;
}
</style>

<script>
$(function() {
	$(".check-all").change(function() {
		$("input[name=pdsNoList]").prop("checked", this.checked);
	});

	$("input[name=pdsNoList]").change(function() {
		$(".check-all").prop("checked",
			$("input[name=pdsNoList]").length == $("input[name=pdsNoList]:checked").length);
	});
});
</script>

<script>
$(function(){
	var state = {
		vacStartDateValid : false,
		vacEndDateValid   : false,
		ok : function() {
			return this.vacStartDateValid && this.vacEndDateValid;
		}
	};

	var today = moment().format("YYYY-MM-DD");
	$("[name=appDate]").val(today);

	var startEl = $("[name=vacStartDate]")[0];
	var endEl   = $("[name=vacEndDate]")[0];
	var startPicker = null, endPicker = null;

	function initPickers(isSickLeave) {
		if (startPicker) { startPicker.destroy(); startPicker = null; }
		if (endPicker) { endPicker.destroy(); endPicker = null; }

		if (startEl && endEl) {
			startPicker = new Lightpick({
				field: startEl, format: "YYYY-MM-DD", firstDay: 7, 
				minDate: isSickLeave ? null : moment(),
				onSelect: function(){ $("[name=vacStartDate]").trigger("change"); }
			});
			endPicker = new Lightpick({
				field: endEl, format: "YYYY-MM-DD", firstDay: 7, 
				minDate: isSickLeave ? null : moment(),
				onSelect: function(){ $("[name=vacEndDate]").trigger("change"); }
			});
		}
	}

	initPickers(false);

	$("input[name=vacType]").on("change", function() {
		var currentType = $(this).val();
		var isSick = (currentType === "병가");

		initPickers(isSick);
		
		$("[name=vacStartDate]").val("").removeClass("success fail");
		$("[name=vacEndDate]").val("").removeClass("success fail");
		state.vacStartDateValid = false;
		state.vacEndDateValid = false;
	});

	$("[name=vacStartDate]").on("change", function(){
		var appDate   = $("[name=appDate]").val() || today;
		var startDate = $(this).val();
		var endDate   = $("[name=vacEndDate]").val();
		var vacType   = $("input[name=vacType]:checked").val();
		
		if(!startDate){ $(this).removeClass("success fail"); state.vacStartDateValid = false; return; }
		
		if(vacType !== "병가" && startDate < appDate){ 
			$(this).removeClass("success").addClass("fail"); 
			state.vacStartDateValid = false; 
		}
		else { 
			$(this).removeClass("fail").addClass("success"); 
			state.vacStartDateValid = true; 
			if(endPicker && vacType !== "병가") endPicker.setMinDate(moment(startDate)); 
		}
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
		var approver1 = document.getElementById('approverNo_1').value;
		if (!approver1) {
			alert("최소 1명 이상의 결재자를 반드시 지정해야 합니다.");
			e.preventDefault();
			return false;
		}

		if(!state.ok()){
			alert("휴가 시작일과 종료일 항목의 정합성을 다시 검증하십시오.");
			e.preventDefault();
			$("[name=vacStartDate]").trigger("change");
			$("[name=vacEndDate]").trigger("change");
			return false;
		}
	});

	$("#gw-file-chooser").on("change", function() {
		var files = this.files;
		if(files.length === 0) return;
		
		for(var i = 0; i < files.length; i++) {
			uploadFile(files[i]);
		}
		$(this).val(""); 
	});
	
	function uploadFile(file) {
		var formData = new FormData();
		formData.append("attach", file);
		
		$.ajax({
			url: "/rest/attach/upload",
			type: "POST",
			data: formData,
			processData: false,
			contentType: false,
			success: function(attachNo) {
				if(!attachNo || attachNo <= 0) {
					alert("파일 변환에 실패했습니다.");
					return;
				}
				
				var $li = $("<li class='gw-file-item'></li>");
				var $nameSpan = $("<span></span>").html("<i class='fa-regular fa-file-lines'></i> " + file.name + " (" + (file.size / 1024).toFixed(1) + " KB)");
				var $deleteBtn = $("<button type='button' class='gw-file-delete-btn'>삭제</button>");
				
				$li.append($nameSpan).append($deleteBtn);
				$("#gw-file-queue").append($li);
				
				var $hiddenInput = $("<input type='hidden' name='attachNo'>").val(attachNo);
				$("#gw-hidden-attach-fields").append($hiddenInput);
				
				$deleteBtn.on("click", function() {
					$li.remove();
					$hiddenInput.remove();
				});
			},
			error: function() {
				alert("파일 업로드 중 연동 서버 에러가 발생했습니다.");
			}
		});
	}
});
</script>

<div class="pds-width">
	<div class="gw-page-head">
		<div class="gw-breadcrumb">홈 > 전자결재 > 휴가신청서</div>
		<h1>휴가신청서</h1>
	</div>

	<div class="vacation-container">

		<form action="./vacInsert" method="post" autocomplete="off" id="vacationForm">
			<div class="form-group">
				<label>결재명<span class="required">*</span></label> 
				<input type="text" name="appTitle" class="input-field" required maxlength="100" placeholder="예) [연차] 홍길동 연차 신청서">
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
						<input type="hidden" id="approverPositionLevel_1" value="">
					</div>

					<div class="appr-box-item">
						<span class="appr-badge">2순위</span> 
						<input type="text" id="approverDisplay_2" class="input-field" placeholder="미지정" readonly> 
						<input type="hidden" id="approverNo_2" name="approver2" value=""> 
						<input type="hidden" id="approverName_2" name="approverName2" value=""> 
						<input type="hidden" id="approverLevel_2" name="approverLevel2" value="">
						<input type="hidden" id="approverDept_2" value=""> 
						<input type="hidden" id="approverPositionLevel_2" value="">
					</div>

					<div class="appr-box-item">
						<span class="appr-badge">3순위</span> 
						<input type="text" id="approverDisplay_3" class="input-field" placeholder="미지정" readonly> 
						<input type="hidden" id="approverNo_3" name="approver3" value=""> 
						<input type="hidden" id="approverName_3" name="approverName3" value=""> 
						<input type="hidden" id="approverLevel_3" name="approverLevel3" value="">
						<input type="hidden" id="approverDept_3" value=""> 
						<input type="hidden" id="approverPositionLevel_3" value="">
					</div>

					<button type="button" class="btn-search-unified" onclick="window.openApproverPopup(1)">
						<i class="fa-solid fa-user-gear"></i> 결재자 지정
					</button>
				</div>
			</div>

			<div class="form-group">
				<label>결재내용<span class="required">*</span></label> 
				<input type="text" name="appContent" class="input-field" required maxlength="1000" placeholder="상세 사유를 기입해 주세요.">
			</div>

			<div class="form-group">
				<label>기안일</label> 
				<input type="text" name="appDate" class="input-field" readonly>
			</div>

			<div class="form-group">
				<label>휴가 시작일<span class="required">*</span></label> 
				<input type="text" name="vacStartDate" class="input-field" required placeholder="YYYY-MM-DD">
			</div>

			<div class="form-group">
				<label>휴가 종료일<span class="required">*</span></label> 
				<input type="text" name="vacEndDate" class="input-field" required placeholder="YYYY-MM-DD">
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

			<div class="gw-upload-container">
				<span class="gw-upload-label"> 
					<i class="fa-solid fa-paperclip"></i> 첨부파일 증빙자료 (PDF / Word 문서만 허용)
				</span>
				<div class="gw-file-input-wrapper">
					<input type="file" id="gw-file-chooser" multiple accept=".pdf, .doc, .docx" style="display: none;">
					<button type="button" class="btn-search-unified" style="background-color: #475569;" onclick="document.getElementById('gw-file-chooser').click();">
						<i class="fa-solid fa-file-arrow-up"></i> 파일 선택
					</button>
				</div>
				<ul id="gw-file-queue" class="gw-file-list"></ul>
				<div id="gw-hidden-attach-fields"></div>
			</div>

			<div class="btn-group">
				<button class="btn-submit" type="submit">기안하기</button>
				<button class="btn-cancel" type="button" onclick="location.href='./list';">취소</button>
			</div>
		</form>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/appr_picker.jsp" />
<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>