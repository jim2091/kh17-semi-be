<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* ========================================================
   전자결재 문서함 전용 커스텀 확장 탭 & 뱃지 스킨 (개정본)
   ======================================================== */

.gw-tabs {
	display: flex;
	gap: 6px; /* 💡 탭 사이 간격을 이미지 비율에 맞춰 소폭 조정 */
	margin-bottom: 24px;
	border-bottom: 2px solid var(--main-color, #22c55e); /* 💡 하단 선을 이미지의 초록색 테마로 동기화 */
}

.gw-tab-item {
	padding: 12px 28px;
	text-decoration: none;
	font-size: 14px;
	font-weight: 600;
	color: #475569; /* 💡 글자색을 이미지와 유사한 다크 그레이로 보정 */
	background: #f8fafc; /* 💡 선택 안 된 탭: 이미지 특유의 아주 연한 투명 톤 회색 배경 */
	border-radius: 8px 8px 0 0;
	transition: all 0.2s ease-in-out;
}

/* 마우스 호버 시 자연스러운 시각 피드백 추가 */
.gw-tab-item:hover {
	background: #e2e8f0;
	color: #1e293b;
}

/* 💡 [핵심] 선택된 활성화 상태: 이미지와 같이 테두리 없이 꽉 찬 완벽한 초록색 배경 구현 */
.gw-tab-item.active {
	background: var(--main-color, #22c55e); 
	color: #ffffff !important; /* 💡 글자색 흰색 강제 유지 */
}

/* 💡 진행 상황별 상태 뱃지 (기존 둥근 스킨 규격 유지) */
.appr-status-badge {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
}

/* 🟢 완료 상태 (초록색 뱃지) */
.appr-status-approve {
	background: #e8f5e9;
	color: #2e7d32;
}

/* 🔴 반려 상태 (빨간색 뱃지) */
.appr-status-reject {
	background: #ffebee;
	color: #c62828;
}

/* 🟡 진행 상태 (노란색 뱃지) */
.appr-status-progress {
	background: #fff8e1;
	color: #f57f17;
}

/* ⚪ 대기 상태 (회색 뱃지) */
.appr-status-wait {
	background: #f5f5f5;
	color: #71717a;
}

/* 테이블 열 마우스 오버 효과 추가 (UX 향상) */
.gw-table tbody tr {
	cursor: pointer;
	transition: background-color 0.15s ease;
}
.gw-table tbody tr:hover {
	background-color: #f8fafc; /* 💡 마우스 올렸을 때 은은한 회색 라인 효과 추가 */
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
	});
</script>

<div class="pds-width">
	<div class="gw-page-head">
		<div class="gw-breadcrumb">홈 > 전자결재 > 목록</div>
		<h1>전자결재 문서함</h1>
		<p>내가 상신한 기안 문서와 결재가 필요한 문서들을 한눈에 확인합니다.</p>
	</div>

	<div class="gw-tabs">
		<a href="/app/list" class="gw-tab-item">기안 문서함</a> 
		<a href="/appr/list" class="gw-tab-item active">결재 문서함</a> <%-- 💡 현재 페이지 활성화 --%>
		<a href="/app/bothList" class="gw-tab-item">전체 문서함</a> <%-- 💡 [추가] 통합 연계 이동용 링크 신설 --%>
	</div>

	<div class="gw-search-panel pds-width"
		style="padding: 20px; background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03); border: 1px solid #e2e8f0; margin-bottom: 20px;">
		<form action="/appr/list" method="get" class="gw-search-form" autocomplete="off"
			style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
			
			<div style="display: flex; align-items: center; gap: 8px;">
				<label style="font-size: 13px; font-weight: 700; color: #475569; white-space: nowrap;">검색분류</label>
				<select name="column" class="gw-form-select" style="margin: 0; min-width: 140px; padding: 6px 12px; border: 1px solid #cbd5e1; border-radius: 6px;">
					<option value="app_line_type" ${param.column == 'app_line_type' ? 'selected' : ''}>문서종류</option>
					<option value="app_line_status" ${param.column == 'app_line_status' ? 'selected' : ''}>진행상황</option>
				</select> 
			</div>
			
			<div style="display: flex; align-items: center; gap: 8px; flex-grow: 1; max-width: 400px;">
				<input type="text" name="keyword" class="gw-form-input" placeholder="검색어를 입력하세요." value="${param.keyword}"
					style="width: 100%; margin: 0; padding: 6px 12px; border: 1px solid #cbd5e1; border-radius: 6px;">
			</div>

			<button type="submit" class="gw-btn-primary"
				style="height: 38px; padding: 0 24px; background-color: #22c55e; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer;">
				<i class="fa-solid fa-magnifying-glass"></i> <span style="margin-left: 5px;">검색</span>
			</button>
		</form>
	</div>

	<div class="gw-list-panel pds-width">
		<div class="gw-table-top" style="margin-bottom: 15px;">
			<div>
				<div class="gw-table-title" style="font-size: 16px; font-weight: 700; color: #1e293b;">결재 대기 및 완료 목록</div>
				<div class="gw-table-sub" style="font-size: 13px; color: #64748b; margin-top: 2px;">총 ${list.size()}개의 문서</div>
			</div>
		</div>

		<table class="gw-table" style="width: 100%; border-collapse: collapse;">
			<thead>
				<tr style="border-bottom: 2px solid #e2e8f0;">
					<th style="width: 15%; padding: 12px; text-align: center;">기안자</th>
					<th style="width: 15%; padding: 12px; text-align: center;">문서종류</th>
					<th style="width: 40%; padding: 12px; text-align: center;">서류명</th>
					<th style="width: 15%; padding: 12px; text-align: center;">기안일</th>
					<th style="width: 15%; padding: 12px; text-align: center;">진행상황</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${not empty list}">
					<c:forEach var="line" items="${list}">
						<tr onclick="location.href='/appr/detail?appId=${line.appId}'" style="border-bottom: 1px solid #f1f5f9; text-align: center;">
							<td style="padding: 14px;">${line.reqEmpName}</td>
							<td style="padding: 14px;"><span class="gw-muted">[${line.appLineType}]</span></td>
							<td class="gw-title-cell" style="text-align: left; padding: 14px;"><a
								href="/appr/detail?appId=${line.appId}" class="gw-table-link" style="text-decoration: none; color: #334155;">
									${line.appTitle} </a></td>
							<td style="padding: 14px;">${line.appDate}</td>
							<td style="padding: 14px;">
								<c:choose>
									<c:when test="${line.appLineStatus == '완료'}">
										<span class="appr-status-badge appr-status-approve">완료</span>
									</c:when>
									<c:when test="${line.appLineStatus == '반려'}">
										<span class="appr-status-badge appr-status-reject">반려</span>
									</c:when>
									<c:when test="${line.appLineStatus == '진행중'}">
										<span class="appr-status-badge appr-status-progress">진행중</span>
									</c:when>
									<c:otherwise>
										<span class="appr-status-badge appr-status-wait">대기</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:if>

				<c:if test="${empty list}">
					<tr>
						<td colspan="5" class="gw-table-empty"
							style="padding: 60px; text-align: center; color: #94a3b8; font-size: 14px;">결재 대상 문서가 존재하지 않습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

		<div class="gw-pagination" style="margin-top: 20px; display: flex; justify-content: center;">
			<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>