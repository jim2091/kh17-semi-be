<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 전자결재 문서함 전용 커스텀 확장 탭 & 뱃지 스킨 */
.gw-tabs {
	display: flex;
	gap: 4px;
	margin-bottom: 24px;
	border-bottom: 2px solid var(--main-color, #3b82f6);
}

.gw-tab-item {
	padding: 12px 28px;
	text-decoration: none;
	font-size: 14px;
	font-weight: 600;
	color: #64748b;
	background: #f1f5f9;
	border-radius: 8px 8px 0 0;
	transition: all 0.2s;
}

.gw-tab-item.active {
	background: var(--main-color, #3b82f6);
	color: #ffffff;
}

.appr-status-badge {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	padding: 4px 10px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
}

.appr-status-approve {
	background: #e8f5e9;
	color: #2e7d32;
}

.appr-status-reject {
	background: #ffebee;
	color: #c62828;
}

.appr-status-progress {
	background: #fff8e1;
	color: #f57f17;
}

.gw-table tbody tr {
	cursor: pointer;
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
		<a href="/app/list" class="gw-tab-item active">기안 문서함</a> <a
			href="/appr/list" class="gw-tab-item">결재 문서함</a>
	</div>

	<div class="gw-search-panel pds-width"
		style="padding: 16px 20px; background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03); border: 1px solid #e2e8f0; margin-bottom: 20px;">
		<form action="./list" method="get" class="gw-search-form"
			style="display: flex; gap: 20px; align-items: center;">

			<div style="display: flex; align-items: center; gap: 8px;">
				<label
					style="font-size: 13px; font-weight: 700; color: #475569; white-space: nowrap;">문서종류</label>
				<select name="searchAppType" class="gw-form-select"
					style="margin: 0; min-width: 150px;" onchange="this.form.submit();">
					<option value="">전체 문서 종류</option>
					<option value="휴가신청서" ${searchAppType == '휴가신청서' ? 'selected' : ''}>휴가신청서</option>
					<option value="품의서" ${searchAppType == '품의서' ? 'selected' : ''}>품의서</option>
					<option value="업무기안서" ${searchAppType == '업무기안서' ? 'selected' : ''}>업무기안서</option>
				</select>
			</div>

			<div style="display: flex; align-items: center; gap: 8px;">
				<label
					style="font-size: 13px; font-weight: 700; color: #475569; white-space: nowrap;">진행상황</label>
				<select name="searchAppStatus" class="gw-form-select"
					style="margin: 0; min-width: 130px;" onchange="this.form.submit();">
					<option value="">전체 결재 상태</option>
					<option value="처리중" ${searchAppStatus == '처리중' ? 'selected' : ''}>처리중</option>
					<option value="승인" ${searchAppStatus == '승인' ? 'selected' : ''}>승인</option>
					<option value="반려" ${searchAppStatus == '반려' ? 'selected' : ''}>반려</option>
				</select>
			</div>

		</form>
	</div>

	<div class="gw-list-panel pds-width">
		<div class="gw-table-top">
			<div>
				<div class="gw-table-title">기안 완료 목록</div>
				<div class="gw-table-sub">총 ${list.size()}개의 문서</div>
			</div>
			<div class="gw-table-actions">
				<a href="./vacInsert" class="gw-btn-outline"
					style="font-size: 13px; padding: 8px 14px;"> <i
					class="fa-solid fa-umbrella-beach"></i> 휴가신청서
				</a> <a href="./expInsert" class="gw-btn-outline"
					style="font-size: 13px; padding: 8px 14px;"> <i
					class="fa-solid fa-coins"></i> 품의서
				</a> <a href="./dftInsert" class="gw-btn-outline"
					style="font-size: 13px; padding: 8px 14px;"> <i
					class="fa-solid fa-file-signature"></i> 업무기안서
				</a>
			</div>
		</div>

		<table class="gw-table">
			<thead>
				<tr>
					<th style="width: 15%;">기안자</th>
					<th style="width: 15%;">문서종류</th>
					<th style="width: 40%;">서류명</th>
					<th style="width: 15%;">기안일</th>
					<th style="width: 15%;">진행상황</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${not empty list}">
					<c:forEach var="appDto" items="${list}">
						<tr onclick="location.href='./detail?appId=${appDto.appId}'">
							<td>${appDto.empName}</td>
							<td><span class="gw-muted">[${appDto.appType}]</span></td>
							<td class="gw-title-cell" style="text-align: left;"><a
								href="./detail?appId=${appDto.appId}" class="gw-table-link">
									${appDto.appTitle} </a></td>
							<td>${appDto.appDate}</td>
							<td><c:choose>
									<c:when test="${appDto.appStatus == '승인'}">
										<span class="appr-status-badge appr-status-approve">승인</span>
									</c:when>
									<c:when test="${appDto.appStatus == '반려'}">
										<span class="appr-status-badge appr-status-reject">반려</span>
									</c:when>
									<c:otherwise>
										<span class="appr-status-badge appr-status-progress">${appDto.appStatus}</span>
									</c:otherwise>
								</c:choose></td>
						</tr>
					</c:forEach>
				</c:if>

				<c:if test="${empty list}">
					<tr>
						<td colspan="5" class="gw-table-empty"
							style="padding: 40px; text-align: center; color: #aaa;">기안한
							문서가 존재하지 않습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

		<div class="gw-pagination">
			<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>