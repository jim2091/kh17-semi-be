<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 근태 페이지 전체 레이아웃 정렬 */
.attn-width {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
}

/* 관리자단 프레임 프론트와 일치화: 토요일 / 일요일 가독성 강조 색상 추가 */
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

/* 상태별 배지 디자인 완벽 분기 */
.status-vacation {
    background: #fffbeb;
    color: var(--warning-color);
}

.status-normal {
    background: #f0fdf4;
    color: #16a34a;
}

/* 지각, 조퇴, 결근 등 경고성/위험성 상태 배지 스타일 */
.status-warning {
    background: #fff7ed;
    color: #ea580c;
}
.status-danger {
    background: #fef2f2;
    color: #dc2626;
}

/* 🎯 [디자인 전면 변경] 답답하게 꼬여있던 absolute 구조 전면 폐기 */
.attn-bottom-wrapper {
    margin-top: 35px;
    padding: 0 10px;
    display: flex;
    flex-direction: column; /* 요약 배너를 위로 보내고 페이징/버튼을 아래로 내림 */
    gap: 24px; /* 1층(배너)과 2층(페이징/버튼) 사이의 확실한 여유 공간 확보 */
    width: 100%;
}

/* 🎯 [1층] 요약 배너 영역: 왼쪽 정렬 및 두 배너 간격 최적화 */
.vac-summary-container {
    display: flex;
    flex-direction: column;
    gap: 8px; /* 연차 배너와 휴가 배너 사이 간격 */
    align-items: flex-start;
}

/* 요약 배너 공통 디자인 */
.vac-summary-banner {
    display: inline-flex;
    align-items: center;
    gap: 12px;
    background: var(--main-light);
    color: var(--main-color);
    border: 1px solid var(--card-border);
    border-radius: 12px;
    padding: 10px 16px;
    font-weight: 700;
    font-size: 14px;
    width: fit-content;
}

.vac-summary-banner span strong {
    font-size: 15px;
}

/* 🎯 [2층] 페이징 및 버튼 영역을 담는 새 하단 정렬 컨테이너 */
.action-and-paging-row {
    display: flex;
    align-items: center;
    justify-content: center; /* 페이징은 무조건 가운데 고정 */
    position: relative;
    width: 100%;
    height: 40px;
}

/* 🎯 [2층 오른쪽] 휴가원 작성 버튼 단독 배치 */
.btn-vac-action {
    position: absolute;
    right: 0;
}

/* [2층 가운데] 페이징 디자인 스타일 보정 */
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
    <div class="gw-breadcrumb">홈 / 근태관리 / 목록</div>
    <h1>근태 기록</h1>
    <p>본인의 월별 근무 현황 및 연차 잔여 일수를 확인할 수 있습니다.</p>
</div>

<div class="gw-search-panel attn-width">
    <form id="searchForm" action="/attn/list" method="get" class="gw-search-form">
        <select id="yearSelect" name="year" class="gw-form-select" onchange="changeDate()">
            <c:forEach var="y" begin="2020" end="2030">
                <option value="${y}" ${search.year == y ? 'selected' : ''}>${y}년</option>
            </c:forEach>
        </select>
        
        <select id="monthSelect" name="month" class="gw-form-select" onchange="changeDate()">
            <c:forEach var="m" begin="1" end="12">
                <c:set var="mm" value="${m < 10 ? '0' : ''}${m}" />
                <option value="${mm}" ${search.month == mm ? 'selected' : ''}>${m}월</option>
            </c:forEach>
        </select>
        
        <button type="button" class="gw-btn-outline" onclick="setToday()">
            <i class="fa-solid fa-calendar-day"></i>
            <span>오늘</span>
        </button>
        <input type="hidden" name="page" value="1"/>
    </form>
</div>

<div class="gw-list-panel attn-width">
    <div class="gw-table-top">
        <div>
            <div class="gw-table-title">근무 내역 명세</div>
            <div class="gw-table-sub">
                ${search.year}년 ${search.month}월 데이터
            </div>
        </div>
    </div>

    <table class="gw-table">
        <thead>
            <tr>
                <th style="width: 20%;">월/일</th>
                <th style="width: 30%;">계획근로시간</th>
                <th style="width: 30%;">근태기록시간</th>
                <th style="width: 10%;">근로시간</th>
                <th style="width: 10%;">상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty attnList}">
                    <tr>
                        <td colspan="5" style="padding: 40px; text-align: center; color: #aaa;">
                            조회된 근태 데이터가 없습니다.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="dto" items="${attnList}">
                        <fmt:formatDate var="dayOfWeek" value="${dto.attnWorkDate}" pattern="E"/>
                        <c:set var="dateColorClass" value="${dayOfWeek == '토' ? 'sat-color' : (dayOfWeek == '일' ? 'sun-color' : '')}" />
                        <c:set var="isVacation" value="${dto.attnRecord == '휴가'}" />
                        
                        <tr>
                            <td class="${dateColorClass}">
                                <span class="bold"><fmt:formatDate value="${dto.attnWorkDate}" pattern="MM/dd"/>(${dayOfWeek})</span>
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
                                    <c:when test="${!isVacation && dto.convertedWorkTime != '-'}">
                                        <strong>${dto.convertedWorkTime}</strong>
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
                                                <span class="attn-head status-vacation">휴가</span>
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
        
        <div class="vac-summary-container">
            <div class="vac-summary-banner">
                <i class="fa-solid fa-umbrella-beach"></i>
                <span>총 연차: <strong style="color: var(--warning-color);">${empty vacInfo ? 0 : vacInfo.VAC_TOT}</strong>일</span>
                <div style="width: 1px; height: 14px; background: var(--card-border);"></div>
                <span>잔여 연차: <strong style="color: var(--main-color);">${empty vacInfo ? 0 : vacInfo.VAC_CNT}</strong>일</span>
            </div>
            
            <div class="vac-summary-banner">
                <i class="fa-solid fa-umbrella-beach"></i>
                <span>총 휴가: <strong style="color: var(--warning-color);">${empty leaveInfo ? 15 : (empty leaveInfo.leaveTot ? leaveInfo.LEAVE_TOT : leaveInfo.leaveTot)}</strong>일</span>
                <div style="width: 1px; height: 14px; background: var(--card-border);"></div>
                <span>잔여 휴가: <strong style="color: var(--main-color);">${empty leaveInfo ? 15 : (empty leaveInfo.leaveCnt ? leaveInfo.LEAVE_CNT : leaveInfo.leaveCnt)}</strong>일</span>
            </div>
        </div>
        
        <div class="action-and-paging-row">
            <div class="gw-pagination">
                <c:if test="${pageVO.hasPrevious()}">
                    <a href="/attn/list?page=${pageVO.previousBlock}&year=${search.year}&month=${search.month}" class="page-box">
                        <i class="fa-solid fa-angle-left"></i>
                    </a>
                </c:if>
    
                <c:forEach var="i" begin="${pageVO.beginBlock}" end="${pageVO.endBlock}">
                    <a href="/attn/list?page=${i}&year=${search.year}&month=${search.month}" 
                       class="page-box ${i == pageVO.page ? 'active' : ''}">${i}</a>
                </c:forEach>
    
                <c:if test="${pageVO.hasNext()}">
                    <a href="/attn/list?page=${pageVO.nextBlock}&year=${search.year}&month=${search.month}" class="page-box">
                        <i class="fa-solid fa-angle-right"></i>
                    </a>
                </c:if>
            </div>
            
            <div class="btn-vac-action">
                <a href="/app/vacInsert" class="gw-btn-primary">
                    <i class="fa-solid fa-file-signature"></i>
                    <span>휴가원 작성</span>
                </a>
            </div>
        </div>
        
    </div>
</div>

<script>
function changeDate() {
    document.getElementById("searchForm").submit();
}

function setToday() {
    const now = new Date();
    document.getElementById("yearSelect").value = now.getFullYear();
    document.getElementById("monthSelect").value = String(now.getMonth()+1).padStart(2,'0');
    changeDate();
}
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>