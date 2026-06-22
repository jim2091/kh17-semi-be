<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%-- [스타일 통합] 모든 인라인 스타일을 클래스로 추출하여 묶어줌 --%>
<style>
/* 메인 컨테이너 및 헤더 */
.appr-detail-container {
	padding: 30px;
}
.appr-title-area {
	display: flex; 
	justify-content: space-between; 
	align-items: center; 
	margin-bottom: 24px;
}
.appr-main-title {
	margin: 0; 
	font-size: 22px; 
	font-weight: 700; 
	color: var(--main-color, #22c55e);
}
.btn-back-list {
	padding: 8px 16px; 
	background: #f0f0f0; 
	color: #333; 
	border: none; 
	border-radius: 6px; 
	font-size: 13px; 
	cursor: pointer;
}

/* 카드 공통 템플릿 스킨 */
.appr-info-card {
	background: white; 
	border-radius: 10px; 
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08); 
	padding: 24px; 
	margin-bottom: 16px;
}
.appr-card-title {
	margin: 0 0 16px 0; 
	font-size: 15px; 
	color: var(--main-color, #22c55e); 
	font-weight: 600;
}

/* 테이블 구조 */
.appr-detail-table {
	width: 100%; 
	border-collapse: collapse; 
	font-size: 14px;
}
.appr-detail-table tr {
	border-bottom: 1px solid #f0f0f0;
}
.appr-detail-table tr:last-child {
	border-bottom: none;
}
.appr-detail-table th {
	padding: 12px 16px; 
	text-align: left; 
	color: #888; 
	font-weight: 600; 
	width: 120px; 
	background: #fafafa;
}
.appr-detail-table td {
	padding: 12px 16px;
}

/* 상태 표시 뱃지 */
.status-pill {
	padding: 4px 10px; 
	border-radius: 20px; 
	font-size: 12px; 
	font-weight: 600;
}
.status-pill.approve {
	background: #e8f5e9; 
	color: #2e7d32;
}
.status-pill.reject {
	background: #ffebee; 
	color: #c62828;
}
.status-pill.progress {
	background: #fff8e1; 
	color: #f57f17;
}
.status-pill.wait {
	background: #f5f5f5; 
	color: #999;
}

/* 첨부파일 영역 */
.appr-file-list {
	display: flex; 
	flex-direction: column; 
	gap: 8px; 
	margin-top: 12px;
}
.appr-download-item {
	display: flex; 
	align-items: center; 
	padding: 12px 16px; 
	background: #f8fafc; 
	border: 1px solid #e2e8f0; 
	border-radius: 8px; 
	text-decoration: none; 
	color: #334155; 
	font-size: 14px; 
	transition: background 0.15s;
}
.appr-download-item:hover {
	background: #f1f5f9;
}
.appr-file-size {
	margin-left: auto; 
	font-size: 12px; 
	color: #94a3b8; 
	font-weight: 500;
}
.appr-file-empty {
	padding: 20px; 
	text-align: center; 
	color: #94a3b8; 
	font-size: 13.5px; 
	background: #f8fafc; 
	border-radius: 8px; 
	border: 1px dashed #e2e8f0;
}

/* 결재선 테이블 전용 헤더 */
.appr-line-thead-tr {
	border-bottom: 2px solid var(--main-color, #22c55e) !important;
}

/* 💡 [UX 교정] 결재선 테이블 헤더와 바디의 정렬, 패딩 가두리 완비 */
.appr-line-table-header th {
	padding: 12px 10px; 
	text-align: center; /* 헤더 텍스트도 전부 무조건 정가운데 정렬 */
	color: var(--main-color, #22c55e); 
	font-weight: 600;
	font-size: 14px;
}
.appr-line-tbody-tr td {
	vertical-align: middle !important;
	text-align: center; /* 💡 바디 데이터도 전부 무조건 정가운데 정렬하여 대칭 구축 */
	padding: 14px 10px;
}

/* 액션 버튼 그룹 및 반려 팝업 모달 */
.appr-action-group {
	display: flex; 
	gap: 12px; 
	justify-content: center; 
	margin-top: 24px;
}
.btn-approve-submit {
	padding: 12px 28px; 
	background: var(--main-color, #22c55e); 
	color: white; 
	border: none; 
	border-radius: 8px; 
	font-size: 14px; 
	font-weight: 600; 
	cursor: pointer;
}
.btn-reject-trigger {
	padding: 12px 28px; 
	background: #ffebee; 
	color: #c62828; 
	border: 1px solid #c62828; 
	border-radius: 8px; 
	font-size: 14px; 
	font-weight: 600; 
	cursor: pointer;
}
.appr-modal-overlay {
	display: none; 
	position: fixed; 
	top: 0; 
	left: 0; 
	width: 100%; 
	height: 100%; 
	background: rgba(0, 0, 0, 0.5); 
	justify-content: center; 
	align-items: center; 
	z-index: 999;
}
.appr-modal-content {
	background: white; 
	padding: 30px; 
	border-radius: 12px; 
	width: 440px; 
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}
.appr-modal-textarea {
	width: 100%; 
	padding: 12px; 
	border: 1px solid #ddd; 
	border-radius: 8px; 
	font-size: 14px; 
	resize: none; 
	box-sizing: border-box;
}
.btn-reject-confirm {
	padding: 10px 24px; 
	background: #ffebee; 
	color: #c62828; 
	border: 1px solid #c62828; 
	border-radius: 6px; 
	font-size: 14px; 
	font-weight: 600; 
	cursor: pointer;
}
.btn-modal-close {
	padding: 10px 24px; 
	background: #f0f0f0; 
	color: #333; 
	border: none; 
	border-radius: 6px; 
	font-size: 14px; 
	cursor: pointer;
}
</style>

<%-- 자바스크립트 엔진부 --%>
<script>
	function openRejectPopup() {
		document.getElementById('rejectPopup').style.display = 'flex';
	}
	function closeRejectPopup() {
		document.getElementById('rejectPopup').style.display = 'none';
		document.getElementById('rejectReason').value = '';
	}
	function validateReject() {
		const reason = document.getElementById('rejectReason').value.trim();
		if (!reason) {
			alert('반려 사유를 입력하세요.');
			return false;
		}
		return confirm('반려하시겠습니까?');
	}

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

<div class="appr-detail-container">
	<div class="gw-page-head pds-width">
		<div class="gw-breadcrumb">홈 > 전자결재 > 상세</div>
	</div>

	<%-- 상단 타이틀 --%>
	<div class="appr-title-area">
		<h2 class="appr-main-title">📄 결재 문서 상세</h2>
		<button onclick="location.href='/appr/list'" class="btn-back-list">← 목록으로</button>
	</div>

	<%-- 문서 기본 정보 --%>
	<div class="appr-info-card">
		<h3 class="appr-card-title">문서 정보</h3>
		<table class="appr-detail-table">
			<tr>
				<th>문서종류</th>
				<td>${appDto.appType}</td>
				<th>진행상황</th>
				<td>
					<c:choose>
						<c:when test="${appDto.appStatus == '승인' || appDto.appStatus == '완료'}">
							<span class="status-pill approve">완료</span>
						</c:when>
						<c:when test="${appDto.appStatus == '반려'}">
							<span class="status-pill reject">반려</span>
						</c:when>
						<c:otherwise>
							<span class="status-pill progress">처리중</span>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th>문서명</th>
				<td colspan="3">${appDto.appTitle}</td>
			</tr>
			<tr>
				<th>기안자</th>
				<td>${appDto.empName}</td>
				<th>기안일</th>
				<td>${appDto.appDate}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="3">${appDto.appContent}</td>
			</tr>
		</table>
	</div>

	<%-- 휴가신청서 추가 정보 --%>
	<c:if test="${not empty vacAppDto}">
		<div class="appr-info-card">
			<h3 class="appr-card-title">휴가 정보</h3>
			<table class="appr-detail-table">
				<tr>
					<th>휴가 구분</th>
					<td>${vacAppDto.vacType}</td>
					<th>휴가 기간</th>
					<td>${vacAppDto.vacStartDate}~ ${vacAppDto.vacEndDate}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<%-- 품의서 추가 정보 --%>
	<c:if test="${not empty expAppDto}">
		<div class="appr-info-card">
			<h3 class="appr-card-title">품의 정보</h3>
			<table class="appr-detail-table">
				<tr>
					<th>지출일</th>
					<td>${expAppDto.expDate}</td>
					<th>지출금액</th>
					<td><fmt:formatNumber value="${expAppDto.expPrice}" pattern="#,###" />원</td>
				</tr>
				<tr>
					<th>지출내역</th>
					<td colspan="3">${expAppDto.expHistory}</td>
				</tr>
				<tr>
					<th>지출방법</th>
					<td>${expAppDto.expHow}</td>
					<th>지출목적</th>
					<td>${expAppDto.expPurpose}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<%-- 업무기안서 추가 정보 --%>
	<c:if test="${not empty dftAppDto}">
		<div class="appr-info-card">
			<h3 class="appr-card-title">업무기안 정보</h3>
			<table class="appr-detail-table">
				<tr>
					<th>업무일</th>
					<td>${dftAppDto.dftDate}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<%-- 첨부파일 증빙자료 스킨 카드 --%>
	<div class="appr-info-card">
		<h3 class="appr-card-title">
			<i class="fa-solid fa-paperclip"></i> 첨부파일 증빙자료
		</h3>
		<div class="appr-file-list">
			<c:choose>
				<c:when test="${not empty attachList}">
					<c:forEach var="file" items="${attachList}">
						<a href="/attach/download?attachNo=${file.attachNo}" download="${file.attachName}" class="appr-download-item">
							<i class="fa-solid fa-file-arrow-down" style="margin-right: 10px; color: #22c55e;"></i>
							<strong>${file.attachName}</strong>
							<span class="appr-file-size">
								<fmt:formatNumber value="${file.attachSize / 1024}" pattern="#,##0.0"/> KB
							</span>
						</a>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="appr-file-empty">제출된 첨부파일 증빙자료가 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<%-- 결재선 --%>
	<div class="appr-info-card">
		<h3 class="appr-card-title">결재선</h3>
		<table class="appr-detail-table">
			<thead>
				<%-- 💡 [리팩토링] 각 th 컬럼에 고정 너비(%)와 가운데 정렬 통합 스킨 매핑 --%>
				<tr class="appr-line-thead-tr appr-line-table-header">
					<th style="width: 8%;">순서</th>
					<th style="width: 15%;">결재자</th>
					<th style="width: 17%;">부서</th>
					<th style="width: 12%;">직급</th>
					<th style="width: 13%;">상태</th>
					<th style="width: 20%;">결재일</th>
					<th style="width: 15%;">반려사유</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="line" items="${lineList}">
					<tr class="appr-line-tbody-tr" style="border-bottom: 1px solid #f0f0f0;">
						<td>${line.appLineOrder}</td>
						<td style="font-weight: 600;">${line.empName}</td>
						<td style="color: #666;">${line.empDept}</td>
						<td style="color: #666;">${line.empPosition}</td>
						<td>
							<c:choose>
								<c:when test="${line.appLineStatus == '완료'}">
									<span class="status-pill approve">완료</span>
								</c:when>
								<c:when test="${line.appLineStatus == '반려'}">
									<span class="status-pill reject">반려</span>
								</c:when>
								<c:when test="${line.appLineStatus == '진행중'}">
									<span class="status-pill progress">진행중</span>
								</c:when>
								<c:otherwise>
									<span class="status-pill wait">대기</span>
								</c:otherwise>
							</c:choose>
						</td>
						<%-- 💡 공백 유지를 위해 인라인 스타일 정리 --%>
						<td style="color: #666; font-size: 13.5px; white-space: nowrap;">${line.appLineDate}</td>
						<td style="color: #c62828;">${line.appLineRej != null ? line.appLineRej : '-'}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty lineList}">
					<tr>
						<td colspan="7" style="padding: 40px; text-align: center; color: #aaa;">결재선이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>

	<%-- 승인/반려 버튼 (내 차례일 때만) --%>
	<c:if test="${myTurn != null}">
		<div class="appr-action-group">
			<form action="/appr/approve" method="post" onsubmit="return confirm('승인하시겠습니까?')">
				<input type="hidden" name="appLineId" value="${myTurn.appLineId}">
				<input type="hidden" name="appId" value="${appDto.appId}"> 
				<input type="hidden" name="currentOrder" value="${myTurn.appLineOrder}">
				<button type="submit" class="btn-approve-submit">✅ 승인</button>
			</form>
			<button type="button" onclick="openRejectPopup()" class="btn-reject-trigger">❌ 반려</button>
		</div>
	</c:if>
</div>

<%-- 반려 사유 팝업 --%>
<div id="rejectPopup" class="appr-modal-overlay">
	<div class="appr-modal-content">
		<h3 style="margin: 0 0 16px 0; color: var(--main-color, #22c55e);">반려 사유</h3>
		<form action="/appr/reject" method="post" onsubmit="return validateReject()">
			<input type="hidden" name="appLineId" value="${myTurn.appLineId}">
			<input type="hidden" name="appId" value="${appDto.appId}">
			<textarea id="rejectReason" name="appLineRej" placeholder="반려 사유를 입력하세요. (최대 300자)" rows="4" maxlength="300" class="appr-modal-textarea"></textarea>
			<div class="appr-action-group" style="margin-top: 16px; gap: 8px;">
				<button type="submit" class="btn-reject-confirm">반려 확정</button>
				<button type="button" onclick="closeRejectPopup()" class="btn-modal-close">취소</button>
			</div>
		</form>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>