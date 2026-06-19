<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link rel="stylesheet"
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

.dft-container {
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
	border-color: #22c55e; 
	box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.15);
}

.field[readonly] {
	background-color: #f8fafc;
	color: #64748b;
	cursor: not-allowed;
}

.textarea-field {
	width: 100%;
	min-height: 220px;
	padding: 16px;
	font-size: 14px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	resize: vertical;
	box-sizing: border-box;
	transition: all 0.2s ease-in-out;
}

.textarea-field:focus {
	outline: none;
	border-color: #22c55e; 
	box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.15);
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
	background: #22c55e; 
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
	border-color: #22c55e;
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
	background: #22c55e; 
	color: white;
}

.btn-submit:hover {
	background: #16a34a;
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
	var savedTheme = localStorage.getItem("gwTheme");
	if (savedTheme) {
		$("body").removeClass("theme-blue theme-green theme-purple theme-dark").addClass(savedTheme);
	} else {
		$("body").addClass("theme-green");
	}

	$("[name=appDate]").val(moment().format("YYYY-MM-DD"));

	$("#dftForm").on("submit", function(e) {
		var approver1 = document.getElementById('approverNo_1').value;
		if (!approver1) {
			alert("최소 1명 이상의 결재자를 반드시 지정해야 합니다.");
			e.preventDefault();
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
					alert("파일 바이트 추출 및 변환에 실패했습니다.");
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
				alert("파일 전송 중 원격 서버 통신 장애가 발생했습니다.");
			}
		});
	}
});
</script>

<div class="pds-width">
	<div class="gw-page-head">
		<div class="gw-breadcrumb">홈 > 전자결재 > 업무기안서</div>
		<h1>업무기안서</h1>
	</div>

	<div class="dft-container">

		<form action="./dftInsert" method="post" id="dftForm" autocomplete="off">
			<div class="form-group">
				<label>결재명 <span class="required">*</span></label> 
				<input type="text" name="appTitle" class="field" required placeholder="기안 결재 제목을 입력하세요.">
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
			</div>

			<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
				<div class="form-group">
					<label>업무일 <span class="required">*</span></label> 
					<input type="date" name="dftDate" class="field" required>
				</div>
				<div class="form-group">
					<label>기안일</label> 
					<input type="date" name="appDate" class="field" readonly>
				</div>
			</div>

			<div class="form-group">
				<label>기안 내용 <span class="required">*</span></label>
				<textarea name="appContent" class="textarea-field" required placeholder="기안할 업무 내용을 상세히 작성해 주세요."></textarea>
			</div>

			<div class="gw-upload-container">
				<span class="gw-upload-label"> 
					<i class="fa-solid fa-paperclip"></i> 첨부파일 증빙자료 (PDF / Word 문서만 허용)
				</span>
				<div class="gw-file-input-wrapper">
					<input type="file" id="gw-file-chooser" multiple accept=".pdf, .doc, .docx" style="display: none;">
					<button type="button" class="btn-search-unified" style="background-color: #475569;" 
							onclick="document.getElementById('gw-file-chooser').click();">
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