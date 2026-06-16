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
.dft-container {
	max-width: 800px;
	margin: 50px auto;
	padding: 40px;
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
	font-family: 'Pretendard', sans-serif;
}

.form-title {
	font-size: 24px;
	font-weight: 700;
	color: #1e293b;
	margin-bottom: 30px;
	text-align: center;
}

.form-group {
	margin-bottom: 20px;
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

.field {
	width: 100%;
	padding: 12px 16px;
	font-size: 15px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	box-sizing: border-box;
	transition: all 0.2s;
}

.field:focus {
	outline: none;
	border-color: var(--main-color, #3b82f6);
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}
/* [피드백 반영] vacInsert와 동일한 기안자/기안일 readonly 전용 시각 락 스킨 */
.field[readonly] {
	background-color: #f8fafc;
	color: #64748b;
	cursor: not-allowed;
}

.textarea-field {
	width: 100%;
	min-height: 200px;
	padding: 16px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	resize: vertical;
	box-sizing: border-box;
	transition: all 0.2s;
}

.textarea-field:focus {
	outline: none;
	border-color: var(--main-color, #3b82f6);
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

/* 결재선 디자인 통일 */
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

.appr-box-item .field {
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

.appr-badge.gold {
	background: var(--main-color, #3b82f6);
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
	white-space: nowrap;
}

.btn-search-unified:hover {
	background-color: #0f172a;
}

.btn-group {
	display: flex;
	justify-content: center;
	gap: 12px;
	margin-top: 40px;
	border-top: 1px solid #e2e8f0;
	padding-top: 30px;
}

.btn-submit {
	background: var(--main-color, #3b82f6);
	color: white;
	border: none;
	padding: 14px 32px;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
}

.btn-submit:hover {
	filter: brightness(90%);
}

.btn-cancel {
	background: #f1f5f9;
	color: #475569;
	border: none;
	padding: 14px 32px;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
}
</style>

<script>
	$(function() {
		var savedTheme = localStorage.getItem("gwTheme");
		if (savedTheme) {
			$("body").removeClass(
					"theme-blue theme-green theme-purple theme-dark").addClass(
					savedTheme);
		} else {
			$("body").addClass("theme-blue");
		}

		$("[name=appDate]").val(moment().format("YYYY-MM-DD"));

		$("#dftForm").on("submit", function(e) {
			if (!$('#approverNo_1').val()) {
				e.preventDefault();
				return false;
			}
		});
	});
</script>
<div class="gw-page-head pds-width">
	<div class="gw-breadcrumb">홈 / 전자결재 / 업무기안서</div>
</div>

<div class="dft-container">
	<h1 class="form-title">업무 기안서</h1>

	<form action="./dftInsert" method="post" id="dftForm"
		autocomplete="off">
		<div class="form-group">
			<label>결재명 <span class="required">*</span></label> <input type="text"
				name="appTitle" class="field" required
				placeholder="기안 결재 제목을 입력하세요.">
		</div>

		<div class="form-group">
			<label>결재 기안자</label> <input type="text" value="${empName}"
				class="field" readonly> <input type="hidden"
				value="${empId}" name="appReqId">
		</div>

		<div class="form-group">
			<label>결재자 설정 <span class="required">*</span></label>
			<div class="approval-row-flex">
				<div class="appr-box-item">
					<span class="appr-badge gold">1순위</span><input type="text"
						id="approverDisplay_1" class="field" placeholder="미지정" readonly>
				</div>
				<div class="appr-box-item">
					<span class="appr-badge">2순위</span><input type="text"
						id="approverDisplay_2" class="field" placeholder="미지정" readonly>
				</div>
				<div class="appr-box-item">
					<span class="appr-badge">3순위</span><input type="text"
						id="approverDisplay_3" class="field" placeholder="미지정" readonly>
				</div>
				<button type="button" class="btn-search-unified"
					onclick="window.openApproverPopup(1)">
					<i class="fa-solid fa-user-gear"></i> 지정
				</button>
			</div>
			<input type="hidden" id="approverNo_1" name="approver1"> <input
				type="hidden" id="approverNo_2" name="approver2"> <input
				type="hidden" id="approverNo_3" name="approver3"> <input
				type="hidden" id="approverDept_1" value=""> <input
				type="hidden" id="approverDept_2" value=""> <input
				type="hidden" id="approverDept_3" value="">
		</div>

		<div class="form-group">
			<label>기안일</label> <input type="date" name="appDate" class="field"
				readonly>
		</div>
		<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
			<div class="form-group">
				<label>업무일 <span class="required">*</span></label> <input
					type="date" name="dftDate" class="field" required>
			</div>
		</div>

		<div class="form-group">
			<label>기안 내용 <span class="required">*</span></label>
			<textarea name="appContent" class="textarea-field" required
				placeholder="기안할 업무 내용을 상세히 작성해 주세요."></textarea>
		</div>

		<div class="btn-group">
			<button class="btn-submit" type="submit">기안하기</button>
			<button class="btn-cancel" type="button"
				onclick="location.href='./list';">취소</button>
		</div>
	</form>
	<jsp:include page="/WEB-INF/views/template/appr_picker.jsp" />
</div>