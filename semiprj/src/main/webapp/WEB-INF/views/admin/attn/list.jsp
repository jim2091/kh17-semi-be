<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 근태 페이지 전체 레이아웃 정렬 - 직원용 프레임 그대로 적용 */
.attn-width {
	width: 100%;
	max-width: 1200px;
	margin: 0 auto;
}

/* [마진 일치화] 검색창과 근무 내역 명세 테이블 사이의 답답한 틈을 직원용과 동일하게 해결 */
.gw-search-panel.attn-width {
	margin-bottom: 30px;
}

/* 토요일 / 일요일 가독성 강조 색상 */
.sat-color { color: #2f80ed !important; font-weight: bold; }
.sun-color { color: #eb5757 !important; font-weight: bold; }

/* 근태 상태 배지 스타일 */
.attn-head {
	display: inline-flex;
	justify-content: center;
	min-width: 65px;
	padding: 5px 9px;
	border-radius: 999px;
	background: var(--main-light);
	color: var(--main-color);
	font-size: 12px;
	font-weight: 900;
}

/* 상태별 배지 디자인 분기 */
.status-vacation {
	background: #fffbeb;
	color: var(--warning-color);
}

.status-normal {
	background: #f0fdf4;
	color: #16a34a;
}

/* 지각, 조퇴, 결근을 직관적으로 구분하기 위한 경고/위험 스타일 추가 */
.status-warning {
	background: #fff7ed;
	color: #ea580c;
}
.status-danger {
	background: #fef2f2;
	color: #dc2626;
}

/* 하단 정렬 컨테이너: 완벽한 좌/우/중앙 정렬 구현 */
.attn-bottom-wrapper {
	position: relative;
	margin-top: 30px;
	padding: 0 10px;
	height: 45px;
	display: flex;
	align-items: center;
	justify-content: center; /* 페이징 중앙 정렬 */
}

/* 가운데 배치: 페이징 디자인 스타일 보정 */
.gw-pagination {
	display: flex;
	align-items: center;
	gap: 6px;
	margin: 0;
}

.gw-pagination .page-box {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 34px;
	height: 34px;
	border-radius: 8px;
	border: 1px solid var(--card-border);
	color: var(--sub-text);
	font-size: 14px;
	font-weight: 500;
	text-decoration: none;
	transition: all 0.2s ease;
	background: #fff;
}

.gw-pagination .page-box:hover {
	background: var(--main-light);
	color: var(--main-color);
	border-color: var(--main-color);
	text-decoration: none;
}

.gw-pagination .page-box.active {
	background: var(--main-color);
	color: #fff;
	border-color: var(--main-color);
	font-weight: 700;
}
</style>

<div class="gw-page-head attn-width">
	<div class="gw-breadcrumb">홈 / 근태관리 / 전사근태기록</div>
	<h1>전사 근태 기록 관리</h1>
	<p>부서별, 직위별 임직원들의 상세 근태 현황 및 근무 시간을 모니터링할 수 있습니다.</p>
</div>

<div class="gw-search-panel attn-width">
	<form id="searchForm" action="/attn/admin/list" method="get" class="gw-search-form">
		
		<select name="deptCode" class="gw-form-select" onchange="this.form.submit();">
			<option value="">부서 전체</option>
			<c:forEach var="dept" items="${deptList}">
				<option value="${dept.deptCode}" ${search.deptCode == dept.deptCode ? 'selected' : ''}>
					${dept.deptName}
				</option>
			</c:forEach>
		</select>

		<select name="positionCode" class="gw-form-select" onchange="this.form.submit();">
			<option value="">직위 전체</option>
			<option value="사원" ${search.positionCode == '사원' ? 'selected' : ''}>사원</option>
			<option value="선임" ${search.positionCode == '선임' ? 'selected' : ''}>선임</option>
			<option value="주임" ${search.positionCode == '주임' ? 'selected' : ''}>주임</option>
			<option value="대리" ${search.positionCode == '대리' ? 'selected' : ''}>대리</option>
			<option value="과장" ${search.positionCode == '과장' ? 'selected' : ''}>과장</option>
			<option value="차장" ${search.positionCode == '차장' ? 'selected' : ''}>차장</option>
			<option value="부장" ${search.positionCode == '부장' ? 'selected' : ''}>부장</option>
			<option value="이사" ${search.positionCode == '이사' ? 'selected' : ''}>이사</option>
			<option value="상무" ${search.positionCode == '상무' ? 'selected' : ''}>상무</option>
			<option value="전무" ${search.positionCode == '전무' ? 'selected' : ''}>전무</option>
			<option value="부사장" ${search.positionCode == '부사장' ? 'selected' : ''}>부사장</option>
			<option value="사장" ${search.positionCode == '사장' ? 'selected' : ''}>사장</option>
			<option value="부회장" ${search.positionCode == '부회장' ? 'selected' : ''}>부회장</option>
			<option value="회장" ${search.positionCode == '회장' ? 'selected' : ''}>회장</option>
		</select>

		<select name="empName" class="gw-form-select" onchange="this.form.submit();">
			<option value="">직원명 전체</option>
			<c:forEach var="emp" items="${empList}">
				<option value="${emp.empName}" ${search.empName == emp.empName ? 'selected' : ''}>
					${emp.empName}
				</option>
			</c:forEach>
		</select>

		<input type="date" name="startDate" value="${startDate}" class="gw-form-select" style="width: 140px;" onchange="this.form.submit();">
		<span style="color: var(--sub-text);">~</span>
		<input type="date" name="endDate" value="${endDate}" class="gw-form-select" style="width: 140px;" onchange="this.form.submit();">

		<select name="size" class="gw-form-select" onchange="this.form.submit();">
			<option value="10" ${pageVO.size == 10 || empty pageVO.size ? 'selected' : ''}>10개씩</option>
			<option value="20" ${pageVO.size == 20 ? 'selected' : ''}>20개씩</option>
			<option value="50" ${pageVO.size == 50 ? 'selected' : ''}>50개씩</option>
		</select>
	</form>
</div>

<div class="gw-list-panel attn-width">
	<div class="gw-table-top">
		<div>
			<div class="gw-table-title">전사 근무 내역 명세</div>
			<div class="gw-table-sub">임직원 전체의 실시간 근태 내역입니다.</div>
		</div>
	</div>

	<table class="gw-table">
		<thead>
			<tr>
				<th style="width: 14%;">부서</th>
				<th style="width: 11%;">직위</th>
				<th style="width: 13%;">사원명</th>
				<th style="width: 13%;">월/일</th>
				<th style="width: 18%;">계획근로시간</th>
				<th style="width: 18%;">근태기록시간</th>
				<th style="width: 11%;">근로시간</th>
				<th style="width: 12%;">상태</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${empty attnList}">
					<tr>
						<td colspan="8" style="padding: 40px; text-align: center; color: #aaa;">
							조회된 근태 데이터가 없습니다.
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="dto" items="${attnList}">
						<fmt:formatDate var="dayOfWeek" value="${dto.attnWorkDate}" pattern="E"/>
						<c:set var="dateColorClass" value="${dayOfWeek == '토' ? 'sat-color' : (dayOfWeek == '일' ? 'sun-color' : '')}" />
						<c:set var="isVacation" value="${dto.attnRecord == '휴가' || dto.attnRecord == '연차' || dto.attnRecord == '병가' || dto.attnRecord == '보건휴가' || dto.attnRecord == '경조사'}" />
						
						<tr>
							<%-- 🎯 [수정 완료] 복잡한 내부 loop를 전부 지우고 백엔드가 넘겨준 dto.deptName을 즉시 출력합니다. --%>
							<td class="gw-muted">
								<c:out value="${empty dto.deptName ? dto.deptCode : dto.deptName}" />
							</td>
							<td class="gw-muted">${dto.positionCode}</td>
							<td><span class="bold">${dto.empName}</span></td>
							<td class="${dateColorClass}">
								<fmt:formatDate value="${dto.attnWorkDate}" pattern="MM/dd"/>(${dayOfWeek})
							</td>
							<td class="gw-muted">${isVacation ? '-' : '09:00 ~ 18:00'}</td>
							<td>
								<c:choose>
									<c:when test="${!isVacation && not empty dto.attnInTime}">
										<fmt:formatDate value="${dto.attnInTime}" pattern="HH:mm"/> ~
										<fmt:formatDate value="${dto.attnOutTime}" pattern="HH:mm"/>
									</c:when>
									<c:otherwise><span class="gw-muted">-</span></c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${!isVacation && dto.attnWorkTime > 0}">
										<strong>${dto.attnWorkTime}h</strong>
									</c:when>
									<c:otherwise><span class="gw-muted">-</span></c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${not empty dto.attnRecord}">
										<c:choose>
											<c:when test="${dto.attnRecord == '정상근무'}">
												<span class="attn-head status-normal">정상</span>
											</c:when>
											<c:when test="${dto.attnRecord == '지각' || dto.attnRecord == '조퇴' || dto.attnRecord == '지각-조퇴'}">
												<span class="attn-head status-warning">${dto.attnRecord}</span>
											</c:when>
											<c:when test="${dto.attnRecord == '결근'}">
												<span class="attn-head status-danger">결근</span>
											</c:when>
											<c:when test="${isVacation}">
												<span class="attn-head status-vacation">${dto.attnRecord}</span>
											</c:when>
											<c:otherwise>
												<span class="attn-head">${dto.attnRecord}</span>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<span class="gw-muted">-</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<div class="attn-bottom-wrapper">
		<div class="gw-pagination">
			<c:set var="query" value="deptCode=${search.deptCode}&positionCode=${search.positionCode}&empName=${search.empName}&startDate=${startDate}&endDate=${endDate}&size=${empty param.size ? 10 : param.size}" />

			<c:if test="${pageVO.hasPrevious()}">
				<a href="/attn/admin/list?page=${pageVO.previousBlock}&${query}" class="page-box">
					<i class="fa-solid fa-angle-left"></i>
				</a>
			</c:if>

			<c:forEach var="i" begin="${pageVO.beginBlock}" end="${pageVO.endBlock}">
				<a href="/attn/admin/list?page=${i}&${query}"
				   class="page-box ${i == pageVO.page ? 'active' : ''}">${i}</a>
			</c:forEach>

			<c:if test="${pageVO.hasNext()}">
				<a href="/attn/admin/list?page=${pageVO.nextBlock}&${query}" class="page-box">
					<i class="fa-solid fa-angle-right"></i>
				</a>
			</c:if>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>