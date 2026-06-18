<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 전자결재 상세 페이지 전용 확장 스타일 스킨 */
.appr-detail-container {
	margin-bottom: 50px;
}

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
</style>


<div class="pds-width appr-detail-container">

	<!-- 1. 상단 브레드크럼 및 액션 타이틀 플로우 결합 -->
	<div class="gw-page-head">
		<div class="gw-breadcrumb">홈 > 전자결재 > 문서상세</div>
		<div
			style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
			<h1>결재 문서 상세조회</h1>
		</div>
	</div>

	<!-- 2. 문서 기본 정보 카드 영역 -->
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
				<td colspan="3" style="font-weight: 600;">${appDto.appTitle}</td>
			</tr>
			<tr>
				<th>기안자</th>
				<td>${appDto.empName}</td>
				<th>기안일</th>
				<td>${appDto.appDate}</td>
			</tr>
			<tr>
				<th>기안 내용</th>
				<td colspan="3" style="line-height: 1.6; padding: 20px 16px;">${appDto.appContent}</td>
			</tr>
		</table>
	</div>

	<!-- 3. 하위 컴포넌트 데이터 연동형 카드 세트 (조건부 렌더링) -->
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
					<td style="font-weight: 600; color: var(--main-color);">${vacAppDto.vacStartDate}
						~ ${vacAppDto.vacEndDate}</td>
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
					<td style="font-weight: 700; color: #2e7d32;"><fmt:formatNumber
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
					<td style="font-weight: 600;">${dftAppDto.dftDate}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<!-- 4. 결재선 추적 리스트 패널 (인라인 제거 후 리스트형 테이블 완전 동기화) -->
	<div class="gw-list-panel pds-width" style="margin-top: 24px;">
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
					<th style="width: 10%;">순서</th>
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
						<td><span class="gw-badge" style="background: #64748b;">${line.appLineOrder}순위</span></td>
						<td style="font-weight: 600;">${line.empName}</td>
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
						<td class="gw-muted">${not empty line.appLineDate ? line.appLineDate : '-'}</td>
						<td style="color: #c62828; font-size: 13px;">${not empty line.appLineRej ? line.appLineRej : '-'}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty lineList}">
					<tr>
						<td colspan="7" class="gw-table-empty"
							style="padding: 40px; text-align: center; color: #aaa;">지정된
							결재선 데이터가 실시간 추적되지 않았습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
		<div
			style="display: flex; justify-content: center; margin-top: 35px; width: 100%;">
			<button onclick="location.href='./list'" class="gw-btn-outline"
				style="padding: 12px 32px; font-size: 14px; font-weight: 600; cursor: pointer;">
				<i class="fa-solid fa-arrow-left"></i> 목록으로
			</button>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>