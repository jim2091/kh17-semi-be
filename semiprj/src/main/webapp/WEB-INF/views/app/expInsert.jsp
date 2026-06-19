<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link class="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>

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

.exp-container {
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
	position: relative;
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

.field {
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

.field:focus {
	outline: none;
	border-color: var(--main-color, #22c55e); 
	box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.15);
}

.field[readonly] {
	background-color: #f8fafc;
	color: #64748b;
	cursor: not-allowed;
}

.field.success {
	border-color: #10b981;
	background-color: #f0fdf4;
}

.field.fail {
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

.form-group.has-error .fail-feedback {
	display: block;
}

.form-group.has-error .approval-row-flex .appr-box-item .field {
	border-color: #ef4444 !important;
	background-color: #fef2f2 !important;
	color: #ef4444 !important;
}

.form-group.has-error .approval-row-flex .appr-box-item .appr-badge {
	background: #ef4444 !important;
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

.appr-box-item .field {
	padding-top: 28px;
	font-size: 13px;
	text-align: center;
	background-color: #f8fafc;
}

.appr-box-item .field.fail {
	border-color: #ef4444;
	background-color: #fef2f2;
}

.appr-box-item .field.success {
	border-color: #10b981;
	background-color: #f0fdf4;
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
	background: var(--main-color, #22c55e); 
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
	border-color: var(--main-color, #22c55e);
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
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.02);
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
	background: var(--main-color, #22c55e); 
	color: white;
}

.btn-submit:hover {
	filter: brightness(90%);
}

.btn-cancel {
	background: #f1f5f9;
	color: #475569;
}

.btn-cancel:hover {
	background-color: #e2e8f0;
}
</style>

<script>
$(function(){
	var state = {
		appTitleValid   : false,
		approverValid   : false,
		appContentValid : false,
		expPriceValid   : false,
		expDateValid    : false,
		expHistoryValid : false,
		expHowValid     : false,
		ok : function() {
			return this.appTitleValid && this.approverValid && this.appContentValid && this.expPriceValid && this.expDateValid && this.expHistoryValid && this.expHowValid;
		}
	};

	var savedTheme = localStorage.getItem("gwTheme");
	if (savedTheme) {
		$("body").removeClass("theme-blue theme-green theme-purple theme-dark").addClass(savedTheme);
	} else {
		$("body").addClass("theme-green");
	}

	var today = moment().format("YYYY-MM-DD");
	$("[name=appDate]").val(today);

	$("[name=appTitle]").on("input blur", function() {
		var value = $(this).val().trim();
		var $group = $(this).closest(".form-group");
		if(value.length === 0) {
			$(this).removeClass("success").addClass("fail");
			$group.addClass("has-error");
			state.appTitleValid = false;
		} else {
			$(this).removeClass("fail").addClass("success");
			$group.removeClass("has-error");
			state.appTitleValid = true;
		}
	});

	$("[name=appContent]").on("input blur", function() {
		var value = $(this).val().trim();
		var $group = $(this).closest(".form-group");
		if(value.length === 0) {
			$(this).removeClass("success").addClass("fail");
			$group.addClass("has-error");
			state.appContentValid = false;
		} else {
			$(this).removeClass("fail").addClass("success");
			$group.removeClass("has-error");
			state.appContentValid = true;
		}
	});

	$("[name=expPrice]").on("input blur", function() {
		var $input = $(this); 
		var rawValue = $input.val(); 
		var cleanValue = rawValue.replace(/[^0-9]/g, '');
		var $group = $input.closest(".form-group");

		if (cleanValue === '') {
			$input.val('');
			$("#realPrice").val(''); 
			$input.removeClass("success").addClass("fail"); 
			$group.addClass("has-error");
			state.expPriceValid = false; 
			return;
		}

		if (cleanValue.length > 12) {
			cleanValue = cleanValue.substring(0, 12);
		}

		$input.val(cleanValue);
		$("#realPrice").val(cleanValue);
		$input.removeClass("fail").addClass("success"); 
		$group.removeClass("has-error");
		state.expPriceValid = true;
	});

	$("[name=expDate]").on("change blur", function() {
		var value = $(this).val();
		var $group = $(this).closest(".form-group");
		if(!value) {
			$(this).removeClass("success").addClass("fail");
			$group.addClass("has-error");
			state.expDateValid = false;
		} else {
			$(this).removeClass("fail").addClass("success");
			$group.removeClass("has-error");
			state.expDateValid = true;
		}
	});

	$("[name=expHistory]").on("input blur", function() {
		var value = $(this).val().trim();
		var $group = $(this).closest(".form-group");
		if(value.length === 0) {
			$(this).removeClass("success").addClass("fail");
			$group.addClass("has-error");
			state.expHistoryValid = false;
		} else {
			$(this).removeClass("fail").addClass("success");
			$group.removeClass("has-error");
			state.expHistoryValid = true;
		}
	});

	$("[name=expHow]").on("input blur", function() {
		var value = $(this).val().trim();
		var $group = $(this).closest(".form-group");
		if(value.length === 0) {
			$(this).removeClass("success").addClass("fail");
			$group.addClass("has-error");
			state.expHowValid = false;
		} else {
			$(this).removeClass("fail").addClass("success");
			$group.removeClass("has-error");
			state.expHowValid = true;
		}
	});

	window.checkApproverState = function() {
		var approver1 = $("#approverNo_1").val();
		var $group = $("#approverNo_1").closest(".form-group");
		if(!approver1) {
			$group.addClass("has-error");
			$group.find(".appr-box-item .field").removeClass("success").addClass("fail");
			state.approverValid = false;
		} else {
			$group.removeClass("has-error");
			$group.find(".appr-box-item .field").removeClass("fail").addClass("success");
			state.approverValid = true;
		}
	};

	$("#approvalForm").on("submit", function(e){
		$("[name=appTitle]").trigger("input");
		$("[name=appContent]").trigger("input");
		$("[name=expPrice]").trigger("input");
		$("[name=expDate]").trigger("change");
		$("[name=expHistory]").trigger("input");
		$("[name=expHow]").trigger("input");
		window.checkApproverState();

		if(!state.ok()){
			e.preventDefault();
			var $firstFail = $(".form-group.has-error").first();
			if($firstFail.length > 0) {
				$('html, body').animate({
					scrollTop: $firstFail.offset().top - 100
				}, 200);
				$firstFail.find(".field").first().focus();
			}
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
		<div class="gw-breadcrumb">홈 > 전자결재 > 목록</div>
		<h1>전자결재 문서함</h1>
		<p>내가 상신한 기안 문서와 결재가 필요한 문서들을 한눈에 확인합니다.</p>
	</div>

	<div class="exp-container">
		<h2 class="form-title">품의서 작성</h2>

		<form action="./expInsert" method="post" id="approvalForm" autocomplete="off">
			<input type="hidden" name="realPrice" id="realPrice">

			<div class="form-group">
				<label>결재명 <span class="required">*</span></label> 
				<input type="text" name="appTitle" class="field" placeholder="품의 결재 제목을 입력하세요.">
				<div class="fail-feedback">결재명을 기입해야 상신이 가능합니다.</div>
			</div>

			<div class="form-group">
				<label>결재 기안자</label> 
				<input type="text" value="${empName}" class="field" readonly> 
				<input type="hidden" value="${empId}" name="appReqId">
			</div>

			<div class="form-group">
				<label>결재자 설정 <span class="required">*</span></label>
				<div class="approval-row-flex">
					<div class="appr-box-item">
						<span class="appr-badge gold">1순위</span> 
						<input type="text" id="approverDisplay_1" class="field" placeholder="미지정" readonly>
					</div>
					<div class="appr-box-item">
						<span class="appr-badge">2순위</span> 
						<input type="text" id="approverDisplay_2" class="field" placeholder="미지정" readonly>
					</div>
					<div class="appr-box-item">
						<span class="appr-badge">3순위</span> 
						<input type="text" id="approverDisplay_3" class="field" placeholder="미지정" readonly>
					</div>
					<button type="button" class="btn-search-unified" onclick="window.openApproverPopup(1)">
						<i class="fa-solid fa-user-gear"></i> 지정
					</button>
				</div>
				<input type="hidden" id="approverNo_1" name="approver1"> 
				<input type="hidden" id="approverNo_2" name="approver2"> 
				<input type="hidden" id="approverNo_3" name="approver3"> 
				<input type="hidden" id="approverDept_1" value=""> 
				<input type="hidden" id="approverDept_2" value=""> 
				<input type="hidden" id="approverDept_3" value="">
				<div class="fail-feedback" style="margin-top: 8px;">최소 1순위 결재자는 필수 지정되어야 상신이 가능합니다.</div>
			</div>

			<div class="form-group">
				<label>결재내용 <span class="required">*</span></label> 
				<input type="text" name="appContent" class="field" placeholder="상세 지출 내용을 명시하십시오.">
				<div class="fail-feedback">결재 상세 품의 사유를 명시해 주십시오.</div>
			</div>

			<div class="form-group">
				<label>지출금액 <span class="required">*</span></label> 
				<input type="text" name="expPrice" class="field" placeholder="숫자만 입력하세요">
				<div class="fail-feedback">집행할 지출금액을 필수 입력해 주세요.</div>
			</div>

			<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
				<div class="form-group">
					<label>지출일 <span class="required">*</span></label> 
					<input type="date" name="expDate" class="field">
					<div class="fail-feedback">실제 지출이 발생한 날짜를 지정하세요.</div>
				</div>
				<div class="form-group">
					<label>기안일</label> 
					<input type="date" name="appDate" class="field" readonly>
				</div>
			</div>

			<div class="form-group">
				<label>지출내역 <span class="required">*</span></label> 
				<input type="text" name="expHistory" class="field" placeholder="지출 내역 항목명 명시">
				<div class="fail-feedback">지출 내역 항목 요약을 기입해 주세요.</div>
			</div>

			<div class="form-group">
				<label>지출방법 <span class="required">*</span></label> 
				<input type="text" name="expHow" class="field" placeholder="예: 법인카드 / 계좌이체">
				<div class="fail-feedback">지출 결제 수단 수단을 지정하세요.</div>
			</div>

			<div class="form-group">
				<label>지출목적</label> 
				<input type="text" name="expPurpose" class="field" placeholder="지출 원인 및 구체적 목적">
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