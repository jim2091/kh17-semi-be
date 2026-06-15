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

/* 지각, 조퇴 등 경고성 상태 배지 스타일 */
.status-late {
    background: #fef2f2;
    color: #dc2626;
}

/* 하단 정렬 컨테이너: relative를 활용해 완벽한 좌/우/중앙 정렬 구현 */
.attn-bottom-wrapper {
    position: relative;
    margin-top: 30px;
    padding: 0 10px;
    height: 45px;
    display: flex;
    align-items: center;
    justify-content: center; /* 페이징이 무조건 중앙에 오도록 설정 */
}

/* 왼쪽 배치: 연차 요약 정보 */
.vac-summary-banner {
    position: absolute;
    left: 0;
    display: flex;
    align-items: center;
    gap: 12px;
    background: var(--main-light);
    color: var(--main-color);
    border: 1px solid var(--card-border);
    border-radius: 12px;
    padding: 10px 16px;
    font-weight: 700;
    font-size: 14px;
}

.vac-summary-banner span strong {
    color: var(--warning-color);
    font-size: 15px;
}

/* 오른쪽 배치: 휴가원 작성 버튼 */
.btn-vac-action {
    position: absolute;
    right: 0;
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
                <th style="width: 15%;">월/일</th>
                <th style="width: 15%;">부재사항</th>
                <th style="width: 25%;">계획근로시간</th>
                <th style="width: 25%;">근태기록시간</th>
                <th style="width: 10%;">근로시간</th>
                <th style="width: 10%;">상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty attnList}">
                    <tr>
                        <td colspan="6" style="padding: 40px; text-align: center; color: #aaa;">
                            조회된 근태 데이터가 없습니다.
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="dto" items="${attnList}">
                        <tr>
                            <td>
                                <span class="bold"><fmt:formatDate value="${dto.attnWorkDate}" pattern="MM/dd"/></span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${dto.attnRecord == '연차' || dto.attnRecord == '반차' || dto.attnRecord == '휴가'}">
                                        <span style="color:var(--warning-color); font-weight: bold;">○ ${dto.attnRecord}</span>
                                    </c:when>
                                    <c:otherwise><span class="gw-muted">-</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="gw-muted">09:00 ~ 18:00</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty dto.attnInTime}">
                                        <fmt:formatDate value="${dto.attnInTime}" pattern="HH:mm"/> ~
                                        <fmt:formatDate value="${dto.attnOutTime}" pattern="HH:mm"/>
                                    </c:when>
                                    <c:otherwise><span class="gw-muted">-</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${dto.attnWorkTime > 0}">
                                        <strong>${dto.attnWorkTime}h</strong>
                                    </c:when>
                                    <c:otherwise><span class="gw-muted">-</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${not empty dto.attnRecord}">
                                    <c:choose>
                                        <c:when test="${dto.attnRecord == '지각' || dto.attnRecord == '조퇴' || dto.attnRecord == '결근'}">
                                            <span class="attn-head status-late">${dto.attnRecord}</span>
                                        </c:when>
                                        <c:when test="${dto.attnRecord == '연차' || dto.attnRecord == '반차' || dto.attnRecord == '휴가'}">
                                            <span class="attn-head status-vacation">${dto.attnRecord}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="attn-head status-normal">${dto.attnRecord}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    
    <div class="attn-bottom-wrapper">
        
        <div class="vac-summary-banner">
            <i class="fa-solid fa-umbrella-beach"></i>
            <span>총 연차: <strong>${empty vacInfo ? 0 : vacInfo.VAC_TOT}</strong>일</span>
            <div style="width: 1px; height: 14px; background: var(--card-border);"></div>
            <span>잔여 연차: <strong style="color: var(--main-color);">${empty vacInfo ? 0 : vacInfo.VAC_CNT}</strong>일</span>
        </div>
        
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