<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
/* 전자결재 상세 페이지 전용 확장 스타일 스킨 */
.appr-detail-container {
	margin-bottom: 50px;
}

.appr-page-title-wrap {
	display: flex;
	justify-content: space-between;
	align-items: center;
	width: 100%;
}

/* 카드 컴포넌트 스타일 */
.appr-info-card {
	background: white;
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
	border: 1px solid #e2e8f0;
	padding: 28px;
	margin-bottom: 20px;
}

.appr-card-title {
	font-size: 16px;
	font-weight: 700;
	color: var(--main-color, #3b82f6);
	margin: 0 0 16px 0;
	display: flex;
	align-items: center;
	gap: 8px;
	border-bottom: 1px solid #f1f5f9;
	padding-bottom: 12px;
}

/* 대기/진행/완료/반려 뱃지 가공 */
.status-pill {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 700;
}

.status-approve {
	background: #e8f5e9;
	color: #2e7d32;
}

.status-reject {
	background: #ffebee;
	color: #c62828;
}

.status-progress {
	background: #fff8e1;
	color: #f57f17;
}

.status-wait {
	background: #f1f5f9;
	color: #64748b;
}

/* 상세 테이블 정밀 튜닝 */
.appr-detail-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 14px;
}

.appr-detail-table th {
	padding: 14px 16px;
	text-align: left;
	color: #475569;
	font-weight: 600;
	background: #f8fafc;
	border: 1px solid #e2e8f0;
	width: 130px;
}

.appr-detail-table td {
	padding: 14px 16px;
	color: #334155;
	border: 1px solid #e2e8f0;
}

.appr-title-td {
	font-weight: 600;
}

.appr-content-td {
	line-height: 1.6;
	padding: 20px 16px;
}

.vac-date-td {
	font-weight: 600;
	color: var(--main-color);
}

.exp-price-td {
	font-weight: 700;
	color: #2e7d32;
}

.dft-date-td {
	font-weight: 600;
}

/* 첨부파일 영역 스킨 */
.gw-detail-file-list {
	display: flex;
	flex-direction: column;
	gap: 10px;
	margin-top: 5px;
}

.gw-download-item {
	display: flex;
	align-items: center;
	padding: 12px 20px;
	background: #f8fafc;
	border: 1px solid #e2e8f0;
	border-radius: 8px;
	text-decoration: none;
	color: #334155;
	font-size: 14px;
	transition: all 0.2s ease-in-out;
}

.gw-download-item:hover {
	background: #f1f5f9;
	border-color: #cbd5e1;
	color: var(--main-color, #3b82f6);
}

.gw-file-size {
	margin-left: auto;
	font-size: 12px;
	color: #94a3b8;
	font-weight: 500;
}

.gw-file-empty {
	padding: 24px;
	text-align: center;
	color: #94a3b8;
	font-size: 14px;
	background: #f8fafc;
	border-radius: 8px;
	border: 1px dashed #e2e8f0;
}

/* 결재선 영역 하단 정렬 */
.appr-line-panel {
	margin-top: 24px;
}

.appr-line-name {
	font-weight: 600;
}

.appr-line-empty-td {
	padding: 40px;
	text-align: center;
	color: #aaa;
}

.appr-btn-wrap {
	display: flex;
	justify-content: center;
	margin-top: 35px;
	width: 100%;
}

.appr-btn-back {
	padding: 12px 32px;
	font-size: 14px;
	font-weight: 600;
	cursor: pointer;
}
</style>

<div class="pds-width appr-detail-container">

	<div class="gw-page-head">
		<div class="gw-breadcrumb">홈 > 전자결재 > 문서상세</div>
		<div class="appr-page-title-wrap">
			<h1>결재 문서 상세조회</h1>
		</div>
	</div>

	<div class="appr-info-card">
		<h3 class="appr-card-title">
			<i class="fa-solid fa-file-lines"></i> 문서 기본 정보
		</h3>
		<table class="appr-detail-table">
			<tr>
				<th>문서종류</th>
				<td>${appDto.appType}</td>
				<th>진행상황</th>
				<td><c:choose>
						<c:when test="${appDto.appStatus == '승인'}">
							<span class="status-pill status-approve">승인</span>
						</c:when>
						<c:when test="${appDto.appStatus == '반려'}">
							<span class="status-pill status-reject">반려</span>
						</c:when>
						<c:otherwise>
							<span class="status-pill status-progress">처리중</span>
						</c:otherwise>
					</c:choose></td>
			</tr>
			<tr>
				<th>문서명</th>
				<td colspan="3" class="appr-title-td">${appDto.appTitle}</td>
			</tr>
			<tr>
				<th>기안자</th>
				<td>${appDto.empName}</td>
				<th>기안일</th>
				<td>${appDto.appDate}</td>
			</tr>
			<tr>
				<th>기안 내용</th>
				<td colspan="3" class="appr-content-td">${appDto.appContent}</td>
			</tr>
		</table>
	</div>

	<%-- 휴가신청서 추가 정보 --%>
	<c:if test="${not empty vacAppDto}">
		<div class="appr-info-card">
			<h3 class="appr-card-title">
				<i class="fa-solid fa-umbrella-beach"></i> 휴가 신청 상세 정보
			</h3>
			<table class="appr-detail-table">
				<tr>
					<th>휴가 구분</th>
					<td>${vacAppDto.vacType}</td>
					<th>휴가 기간</th>
					<td class="vac-date-td">${vacAppDto.vacStartDate}~
						${vacAppDto.vacEndDate}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<%-- 품의서 추가 정보 --%>
	<c:if test="${not empty expAppDto}">
		<div class="appr-info-card">
			<h3 class="appr-card-title">
				<i class="fa-solid fa-coins"></i> 지출 품의 상세 정보
			</h3>
			<table class="appr-detail-table">
				<tr>
					<th>지출일</th>
					<td>${expAppDto.expDate}</td>
					<th>지출금액</th>
					<td class="exp-price-td"><fmt:formatNumber
							value="${expAppDto.expPrice}" pattern="#,###" />원</td>
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
			<h3 class="appr-card-title">
				<i class="fa-solid fa-file-signature"></i> 업무 기안 상세 정보
			</h3>
			<table class="appr-detail-table">
				<tr>
					<th>업무 예정일</th>
					<td class="dft-date-td">${dftAppDto.dftDate}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<div class="appr-info-card">
		<h3 class="appr-card-title">
			<i class="fa-solid fa-paperclip"></i> 첨부파일 증빙자료
		</h3>
		<div class="gw-detail-file-list">
			<c:choose>
				<c:when test="${not empty attachList}">
					<c:forEach var="file" items="${attachList}">
						<%-- 💡 전용 파일 컨트롤러 주소 및 강제 다운로드 속성 전면 동기화 --%>
						<a href="/download/modern?attachNo=${file.attachNo}"
							download="${file.attachName}" class="gw-download-item"> <i
							class="fa-solid fa-file-arrow-down" style="margin-right: 10px;"></i>
							<strong>${file.attachName}</strong> <span class="gw-file-size">
								<fmt:formatNumber value="${file.attachSize / 1024}"
									pattern="#,##0.0" /> KB
						</span>
						</a>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="gw-file-empty">제출된 첨부파일 증빙자료가 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<div class="gw-list-panel pds-width appr-line-panel">
		<div class="gw-table-top">
			<div>
				<div class="gw-table-title">
					<i class="fa-solid fa-users-gear"></i> 문서 결재선 상태
				</div>
			</div>
		</div>
		<table class="gw-table">
			<thead>
				<tr>
					<th style="width: 15%;">결재자</th>
					<th style="width: 15%;">부서</th>
					<th style="width: 15%;">직급</th>
					<th style="width: 15%;">상태</th>
					<th style="width: 15%;">결재일</th>
					<th style="width: 15%;">반려사유</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="line" items="${lineList}">
					<tr>
						<td class="appr-line-name">${line.empName}</td>
						<td>${line.empDept}</td>
						<td>${line.empPosition}</td>
						<td><c:choose>
								<c:when test="${line.appLineStatus == '완료'}">
									<span class="status-pill status-approve">완료</span>
								</c:when>
								<c:when test="${line.appLineStatus == '반려'}">
									<span class="status-pill status-reject">반려</span>
								</c:when>
								<c:when test="${line.appLineStatus == '진행중'}">
									<span class="status-pill status-progress">진행중</span>
								</c:when>
								<c:otherwise>
									<span class="status-pill status-wait">대기</span>
								</c:otherwise>
							</c:choose></td>
						<td class="gw-muted"><c:choose>
								<c:when test="${not empty line.appLineDate}">
									<fmt:parseDate value="${line.appLineDate}"
										pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate" />
									<fmt:formatDate value="${parsedDate}"
										pattern="yyyy-MM-dd HH:mm" />
								</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose></td>
						<td style="color: #c62828; font-size: 13px;">${not empty line.appLineRej ? line.appLineRej : '-'}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty lineList}">
					<tr>
						<td colspan="6" class="appr-line-empty-td">지정된 결재선 데이터가 실시간
							추적되지 않았습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
		<div class="appr-btn-wrap">
			<button onclick="location.href='/app/list'"
				class="gw-btn-outline appr-btn-back">
				<i class="fa-solid fa-arrow-left"></i> 목록으로
			</button>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>