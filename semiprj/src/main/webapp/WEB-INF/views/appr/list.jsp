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

.appr-status-wait {
	background: #f5f5f5;
	color: #999;
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
		<a href="/app/list" class="gw-tab-item">기안 문서함</a> <a
			href="/appr/list" class="gw-tab-item active">결재 문서함</a>
	</div>

	<div class="gw-search-panel pds-width">
		<form action="/appr/list" method="get" class="gw-search-form"
			autocomplete="off">
			<select name="column" class="gw-form-select">
				<option value="app_line_type"
					${param.column == 'app_line_type' ? 'selected' : ''}>문서종류</option>
				<option value="app_line_status"
					${param.column == 'app_line_status' ? 'selected' : ''}>진행상황</option>
			</select> <input type="text" name="keyword" class="gw-form-input"
				placeholder="검색어를 입력하세요." value="${param.keyword}">

			<button type="submit" class="gw-btn-primary">
				<i class="fa-solid fa-magnifying-glass"></i> <span>검색</span>
			</button>
		</form>
	</div>

	<div class="gw-list-panel pds-width">
		<div class="gw-table-top">
			<div>
				<div class="gw-table-title">결재 대기 및 완료 목록</div>
				<div class="gw-table-sub">총 ${list.size()}개의 문서</div>
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
					<c:forEach var="line" items="${list}">
						<tr onclick="location.href='/appr/detail?appId=${line.appId}'">
							<td>${line.reqEmpName}</td>
							<td><span class="gw-muted">[${line.appLineType}]</span></td>
							<td class="gw-title-cell" style="text-align: left;"><a
								href="/appr/detail?appId=${line.appId}" class="gw-table-link">
									${line.appTitle} </a></td>
							<td>${line.appDate}</td>
							<td><c:choose>
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
								</c:choose></td>
						</tr>
					</c:forEach>
				</c:if>

				<c:if test="${empty list}">
					<tr>
						<td colspan="5" class="gw-table-empty"
							style="padding: 40px; text-align: center; color: #aaa;">결재
							대상 문서가 존재하지 않습니다.</td>
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