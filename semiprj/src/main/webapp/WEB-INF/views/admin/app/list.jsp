<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 전자결재 문서 목록 커스텀 보완 스킨 */
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
		<div class="gw-breadcrumb">홈 > 전자결재 > 관리자목록</div>
		<h1>관리자목록</h1>
		<p>기안된 전체 결재 문서의 진행 상황을 모니터링하고 검색할 수 있습니다.</p>
	</div>

	<div class="gw-search-panel pds-width">
		<form action="./admin/list" method="get" class="gw-search-form" autocomplete="off">
			<input type="hidden" name="appType" value="${param.appType}">
			
			<select name="column" class="gw-form-select">
				<option value="app_title" ${param.column == 'app_title'  ? 'selected' : ''}>서류명</option>
				<option value="app_type" ${param.column == 'app_type'   ? 'selected' : ''}>문서종류</option>
				<option value="app_status" ${param.column == 'app_status' ? 'selected' : ''}>진행상황</option>
			</select> 
			
			<input type="text" name="keyword" class="gw-form-input" 
				placeholder="검색어를 입력하세요." value="${param.keyword}">
				
			<button type="submit" class="gw-btn-primary">
				<i class="fa-solid fa-magnifying-glass"></i>
				<span>검색</span>
			</button>
		</form>
	</div>

	<div class="gw-list-panel pds-width">
		<div class="gw-table-top">
			<div>
				<div class="gw-table-title">결재 문서 목록</div>
				<div class="gw-table-sub">
					총 ${list.size()}개의 결재 문서
				</div>
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
							<td>
								<span class="gw-muted">[${appDto.appType}]</span>
							</td>
							<td class="gw-title-cell" style="text-align: left;">
								<a href="./detail?appId=${appDto.appId}" class="gw-table-link">
									${appDto.appTitle}
								</a>
							</td>
							<td>${appDto.appDate}</td>
							<td>
								<c:choose>
									<c:when test="${appDto.appStatus == '승인'}">
										<span class="appr-status-badge appr-status-approve">승인</span>
									</c:when>
									<c:when test="${appDto.appStatus == '반려'}">
										<span class="appr-status-badge appr-status-reject">반려</span>
									</c:when>
									<c:otherwise>
										<span class="appr-status-badge appr-status-progress">처리중</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:if>

				<c:if test="${empty list}">
					<tr>
						<td colspan="5" class="gw-table-empty" style="padding: 40px; text-align: center; color: #aaa;">
							조회된 결재 문서가 없습니다.
						</td>
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