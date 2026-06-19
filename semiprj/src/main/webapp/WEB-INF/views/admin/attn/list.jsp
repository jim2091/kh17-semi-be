<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.attn-width {
	width: 100%;
	max-width: 1200px;
	margin: 0 auto;
}
.gw-search-panel.attn-width {
	margin-bottom: 30px;
}
.sat-color { color: #2f80ed !important; font-weight: bold; }
.sun-color { color: #eb5757 !important; font-weight: bold; }

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
.status-vacation { background: #fffbeb; color: var(--warning-color); }
.status-normal { background: #f0fdf4; color: #16a34a; }
.status-warning { background: #fff7ed; color: #ea580c; }
.status-danger { background: #fef2f2; color: #dc2626; }

.attn-bottom-wrapper {
	position: relative;
	margin-top: 30px;
	padding: 0 10px;
	height: 45px;
	display: flex;
	align-items: center;
	justify-content: center;
}
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
    <form id="searchForm" action="/attn/admin/list" method="get" class="gw-search-form" autocomplete="off">
        
        <select id="search-column" class="gw-form-select" style="width: 140px;">
            <option value="all">전체 검색</option>
            <option value="dept" ${not empty param.deptCode || not empty search.deptCode ? 'selected' : ''}>부서별</option>
            <option value="position" ${not empty param.positionCode || not empty search.positionCode ? 'selected' : ''}>직위별</option>
            <option value="name" ${not empty param.empName || not empty search.empName ? 'selected' : ''}>직원명별</option>
        </select>

        <input type="text" name="empName" id="keyword-empName" placeholder="직원명을 입력하세요." 
               class="gw-form-input" value="${not empty param.empName ? param.empName : search.empName}" style="display:none;">

        <select name="deptCode" id="keyword-dept" class="gw-form-select" style="display:none;">
            <option value="">부서 선택</option>
            <c:forEach var="dept" items="${deptList}">
                <option value="${dept.deptId}" ${(param.deptCode == dept.deptId || search.deptCode == dept.deptId) ? 'selected' : ''}>${dept.deptName}</option>
            </c:forEach>
        </select>

        <select name="positionCode" id="keyword-position" class="gw-form-select" style="display:none;">
            <option value="">직위 선택</option>
            <c:forEach var="pos" items="${positionList}">
                <option value="${pos}" ${(param.positionCode == pos || search.positionCode == pos) ? 'selected' : ''}>${pos}</option>
            </c:forEach>
        </select>

        <div class="date-range-group" style="display: inline-flex; align-items: center; gap: 5px;">
            <input type="date" name="startDate" value="${startDate}" class="gw-form-select" style="width: 140px;">
            <span style="color: var(--sub-text);">~</span>
            <input type="date" name="endDate" value="${endDate}" class="gw-form-select" style="width: 140px;">
        </div>

        <select name="size" class="gw-form-select" style="width: 100px;" onchange="this.form.submit();">
            <option value="10" ${pageVO.size == 10 || empty pageVO.size ? 'selected' : ''}>10개씩</option>
            <option value="20" ${pageVO.size == 20 ? 'selected' : ''}>20개씩</option>
            <option value="50" ${pageVO.size == 50 ? 'selected' : ''}>50개씩</option>
        </select>

        <button type="submit" class="gw-btn-primary">
            <i class="fa-solid fa-magnifying-glass"></i> <span>검색</span>
        </button>
    </form>
</div>

<div class="gw-list-panel attn-width">
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
					<tr><td colspan="8" style="padding: 40px; text-align: center; color: #aaa;">조회된 근태 데이터가 없습니다.</td></tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="dto" items="${attnList}">
						<fmt:formatDate var="dayOfWeek" value="${dto.attnWorkDate}" pattern="E"/>
						<c:set var="dateColorClass" value="${dayOfWeek == '토' ? 'sat-color' : (dayOfWeek == '일' ? 'sun-color' : '')}" />
						<c:set var="isVacation" value="${dto.attnRecord == '휴가' || dto.attnRecord == '연차' || dto.attnRecord == '병가' || dto.attnRecord == '보건휴가' || dto.attnRecord == '경조사'}" />
						<tr>
							<td class="gw-muted"><c:out value="${empty dto.deptName ? dto.deptCode : dto.deptName}" /></td>
							<td class="gw-muted">${dto.positionCode}</td>
							<td><span class="bold">${dto.empName}</span></td>
							<td class="${dateColorClass}"><fmt:formatDate value="${dto.attnWorkDate}" pattern="MM/dd"/>(${dayOfWeek})</td>
							<td class="gw-muted">${isVacation ? '-' : '09:00 ~ 18:00'}</td>
							<td>
								<c:choose>
									<c:when test="${!isVacation && not empty dto.attnInTime}">
										<fmt:formatDate value="${dto.attnInTime}" pattern="HH:mm"/> ~ <fmt:formatDate value="${dto.attnOutTime}" pattern="HH:mm"/>
									</c:when>
									<c:otherwise><span class="gw-muted">-</span></c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${!isVacation && dto.attnWorkTime > 0}"><strong>${dto.attnWorkTime}h</strong></c:when>
									<c:otherwise><span class="gw-muted">-</span></c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${not empty dto.attnRecord}">
										<c:choose>
											<c:when test="${dto.attnRecord == '정상근무'}"><span class="attn-head status-normal">정상</span></c:when>
											<c:when test="${dto.attnRecord == '지각' || dto.attnRecord == '조퇴' || dto.attnRecord == '지각-조퇴'}"><span class="attn-head status-warning">${dto.attnRecord}</span></c:when>
											<c:when test="${dto.attnRecord == '결근'}"><span class="attn-head status-danger">결근</span></c:when>
											<c:when test="${isVacation}"><span class="attn-head status-vacation">${dto.attnRecord}</span></c:when>
											<c:otherwise><span class="attn-head">${dto.attnRecord}</span></c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise><span class="gw-muted">-</span></c:otherwise>
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
			<c:set var="query" value="deptCode=${not empty param.deptCode ? param.deptCode : search.deptCode}&positionCode=${not empty param.positionCode ? param.positionCode : search.positionCode}&empName=${not empty param.empName ? param.empName : search.empName}&startDate=${startDate}&endDate=${endDate}&size=${empty param.size ? 10 : param.size}" />
			<c:if test="${pageVO.hasPrevious()}">
				<a href="/attn/admin/list?page=${pageVO.previousBlock}&${query}" class="page-box"><i class="fa-solid fa-angle-left"></i></a>
			</c:if>
			<c:forEach var="i" begin="${pageVO.beginBlock}" end="${pageVO.endBlock}">
				<a href="/attn/admin/list?page=${i}&${query}" class="page-box ${i == pageVO.page ? 'active' : ''}">${i}</a>
			</c:forEach>
			<c:if test="${pageVO.hasNext()}">
				<a href="/attn/admin/list?page=${pageVO.nextBlock}&${query}" class="page-box"><i class="fa-solid fa-angle-right"></i></a>
			</c:if>
		</div>
	</div>
</div>

<script>
$(function(){
    function toggleSearchInput() {
        const column = $("#search-column").val();
        $("#keyword-empName, #keyword-dept, #keyword-position").hide().prop("disabled", true);
        
        if(column === "dept") { $("#keyword-dept").show().prop("disabled", false); } 
        else if(column === "position") { $("#keyword-position").show().prop("disabled", false); } 
        else if(column === "name") { $("#keyword-empName").show().prop("disabled", false); }
        else if(column === "all") {
            $("#keyword-dept").val("").prop("disabled", true);
            $("#keyword-position").val("").prop("disabled", true);
            $("#keyword-empName").val("").prop("disabled", true);
        }
    }
    toggleSearchInput();
    $("#search-column").change(function() {
        $("#keyword-dept").val(""); $("#keyword-position").val(""); $("#keyword-empName").val("");
        toggleSearchInput();
    });
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>