<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.admin-dashboard {
    max-width: 1280px;
    margin: 0 auto;
}

.admin-filter {
    display: flex;
    gap: 10px;
    align-items: center;
}

.admin-filter .gw-form-input,
.admin-filter .gw-btn-primary {
    height: 42px;
}

.admin-filter .gw-btn-primary {
    padding: 0 22px;
}

/* =========================
   Layout
========================= */

.admin-summary-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 18px;
    margin-bottom: 18px;
}

.admin-main-grid {
    display: grid;
    grid-template-columns: 1.25fr 1fr;
    gap: 18px;
    margin-bottom: 18px;
}

.admin-sub-grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 18px;
    align-items: stretch;
}

.admin-bottom-grid {
    display: grid;
    grid-template-columns: 0.8fr 1.2fr 1.3fr;
    gap: 18px;
    margin-top: 18px;
    align-items: stretch;
}

.admin-card {
    height: auto;
    min-height: 0;
}

.admin-card.large {
    min-height: 420px;
}

.admin-sub-grid .admin-card,
.admin-bottom-grid .admin-card,
.admin-sub-grid .gw-list-panel {
    min-height: 260px;
}

.admin-sub-grid > *,
.admin-bottom-grid > * {
    height: 100%;
}

.admin-sub-grid .dashboard-card,
.admin-bottom-grid .dashboard-card,
.admin-sub-grid .gw-list-panel,
.gw-list-panel {
    display: flex;
    flex-direction: column;
}

/* =========================
   Summary Cards
========================= */

.admin-summary-grid .summary-card {
    min-height: 120px;
    padding: 22px 24px;

    display: grid;
    grid-template-columns: 58px 1fr;
    grid-template-areas:
        "icon title"
        "icon value"
        "icon desc";
    column-gap: 18px;
    align-items: center;
}

.admin-summary-grid .summary-icon {
    grid-area: icon;
    width: 58px;
    height: 58px;
    margin: 0;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;
    font-size: 24px;
}

.admin-summary-grid .summary-title {
    grid-area: title;
    align-self: end;

    font-size: 14px;
    font-weight: 900;
    color: var(--sub-text);
}

.admin-summary-grid .summary-value {
    grid-area: value;

    margin: 2px 0 0;
    font-size: 32px;
    font-weight: 900;
    line-height: 1.1;
    color: var(--card-title-color);
}

.admin-summary-grid .summary-desc {
    grid-area: desc;
    align-self: start;

    margin-top: 4px;
    color: var(--sub-text);
    font-size: 12px;
    font-weight: 700;
    line-height: 1.4;
}

/* =========================
   Common Chart Colors
========================= */

.bar-blue { background: #2563eb; }
.bar-green { background: #10b981; }
.bar-yellow { background: #f59e0b; }
.bar-red { background: #fb7185; }
.bar-purple { background: #8b5cf6; }
.bar-gray { background: #64748b; }

.legend-dot {
    display: inline-block;
    width: 9px;
    height: 9px;
    border-radius: 50%;
    margin-right: 6px;
}

/* =========================
   Attendance Chart
========================= */

.chart-legend {
    display: flex;
    justify-content: center;
    gap: 18px;
    margin-top: 4px;
    color: var(--sub-text);
    font-size: 13px;
    font-weight: 800;
}

.chart-area {
    position: relative;
    height: 230px;
    padding: 24px 8px 8px 34px;
    border-bottom: 1px solid var(--border-color);
}

.chart-grid {
    position: absolute;
    left: 34px;
    right: 8px;
    top: 24px;
    bottom: 8px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.chart-grid-line {
    border-top: 1px solid var(--border-color);
    font-size: 11px;
    color: var(--sub-text);
}

.chart-bars {
    position: relative;
    height: 100%;
    display: flex;
    align-items: flex-end;
    gap: 18px;
    z-index: 2;
}

.chart-group {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: flex-end;
    gap: 7px;
    height: 100%;
    position: relative;
}

.chart-bar {
    width: 14px;
    border-radius: 999px 999px 4px 4px;
}

.chart-label {
    position: absolute;
    bottom: -28px;
    color: var(--sub-text);
    font-size: 12px;
    font-weight: 800;
}

.attn-mini-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 10px;
    margin-top: 18px;
}

.attn-mini-card {
    padding: 12px;
    border: 1px solid var(--border-color);
    border-radius: 12px;
    background: var(--input-bg);
    text-align: center;
}

.attn-mini-title {
    font-size: 12px;
    color: var(--sub-text);
    font-weight: 800;
}

.attn-mini-value {
    margin-top: 6px;
    font-size: 20px;
    font-weight: 900;
    color: var(--card-title-color);
}

/* =========================
   Approval Donut
========================= */

.donut-wrap {
    display: flex;
    align-items: center;
    gap: 34px;
    min-height: 240px;
}

.fake-donut {
    width: 180px;
    height: 180px;
    border-radius: 50%;
    position: relative;
    flex: 0 0 auto;
}

.approval-donut {
    background: conic-gradient(
        #10b981 0% var(--approve-end),
        #f59e0b var(--approve-end) var(--ing-end),
        #fb7185 var(--ing-end) 100%
    );
}

.approval-donut.empty {
    background: var(--input-bg);
}

.fake-donut-center {
    position: absolute;
    inset: 38px;
    border-radius: 50%;
    background: var(--card-bg);
}

.approval-total-box {
    display: flex;
    justify-content: space-between;
    align-items: center;

    margin-bottom: 14px;
    padding: 14px 18px;

    border: 1px solid var(--border-color);
    border-radius: 14px;
    background: var(--input-bg);
}

.approval-total-title {
    color: var(--sub-text);
    font-size: 14px;
    font-weight: 800;
}

.approval-total-value {
    color: var(--card-title-color);
    font-size: 20px;
    font-weight: 900;
}

/* =========================
   List / Stat
========================= */

.stat-list {
    flex: 1;
}

.stat-item {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    padding: 12px 0;
    border-bottom: 1px solid var(--border-color);
    color: var(--list-text-color);
    font-size: 14px;
    font-weight: 800;
}

.stat-item:last-child {
    border-bottom: none;
}

.notice-title {
    max-width: 260px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}

/* =========================
   Department Rank
========================= */

.dept-rank-list {
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.dept-rank-row {
    display: grid;
    grid-template-columns: 110px 1fr 50px;
    align-items: center;
    gap: 12px;

    color: var(--list-text-color);
    font-size: 14px;
    font-weight: 800;
}

.dept-rank-track {
    height: 10px;
    border-radius: 999px;
    background: var(--input-bg);
    border: 1px solid var(--border-color);
    overflow: hidden;
}

.dept-rank-fill {
    height: 100%;
    border-radius: 999px;
    background: var(--main-color);
}

/* =========================
   Recent Employee Table
========================= */

.gw-table {
    flex: 1;
}

.admin-compact-table {
    table-layout: fixed;
}

.admin-compact-table th,
.admin-compact-table td {
    padding: 6px 10px;
    font-size: 13px;
    white-space: nowrap;
}

.admin-compact-table th:nth-child(1),
.admin-compact-table td:nth-child(1) {
    width: 26%;
}

.admin-compact-table th:nth-child(2),
.admin-compact-table td:nth-child(2) {
    width: 22%;
}

.admin-compact-table th:nth-child(3),
.admin-compact-table td:nth-child(3) {
    width: 26%;
}

.admin-compact-table th:nth-child(4),
.admin-compact-table td:nth-child(4) {
    width: 26%;
}

/* =========================
   Buttons
========================= */

.admin-link-btn {
    display: block;
    margin-top: 18px;
    height: 42px;
    line-height: 42px;
    padding: 0 10px;

    text-align: center;
    border-radius: 12px;
    background: var(--main-color);
    color: #fff;
    font-weight: 900;
    text-decoration: none;
}

.admin-link-btn.subtle {
    background: var(--input-bg);
    color: var(--main-color);
    border: 1px solid var(--border-color);
}

/* =========================
   Waiting Employee Card
========================= */

.admin-wait-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 12px;
    height: 100%;
}

.admin-wait-icon {
    font-size: 42px;
    color: var(--main-color);
}

.admin-wait-title {
    color: var(--sub-text);
    font-size: 15px;
    font-weight: 800;
}

.admin-wait-count {
    color: var(--card-title-color);
    font-size: 42px;
    font-weight: 900;
}

/* =========================
   Empty Card
========================= */

.admin-empty-card {
    height: 100%;
    min-height: 180px;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 10px;

    color: var(--sub-text);
    text-align: center;
}

.admin-empty-icon {
    width: 54px;
    height: 54px;
    border-radius: 18px;

    display: flex;
    align-items: center;
    justify-content: center;

    background: rgba(251, 113, 133, 0.12);
    color: #fb7185;
    font-size: 24px;
}

.admin-empty-title {
    color: var(--card-title-color);
    font-size: 15px;
    font-weight: 900;
}

.admin-empty-desc {
    font-size: 13px;
    font-weight: 700;
}

/* =========================
   Login Chart
========================= */

.login-stat-list {
    display: flex;
    align-items: flex-end;
    gap: 10px;
    height: 150px;
    padding: 28px 0 28px;
    border-bottom: 1px solid var(--border-color);
}

.login-stat-item {
    flex: 1;
    height: 100%;
    display: flex;
    align-items: flex-end;
    justify-content: center;
    position: relative;
}

.login-stat-bar {
    width: 18px;
    min-height: 6px;
    border-radius: 999px 999px 4px 4px;
    background: var(--main-color);
}

.login-stat-label {
    position: absolute;
    bottom: -24px;
    color: var(--sub-text);
    font-size: 11px;
    font-weight: 800;
}

.login-stat-count {
    position: absolute;
    bottom: calc(100% + 6px);
    color: var(--card-title-color);
    font-size: 11px;
    font-weight: 900;
}

/* =========================
   Responsive
========================= */

@media (max-width: 1200px) {
    .admin-summary-grid,
    .admin-main-grid,
    .admin-sub-grid,
    .admin-bottom-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<div class="admin-dashboard">

    <div class="gw-hero">
        <div>
            <h1>관리자 대시보드</h1>
            <p>전사 직원, 근태, 결재, 부서 현황을 한눈에 확인하세요.</p>
        </div>

        <form action="/admin/dashboard" method="get" class="admin-filter">
            <input type="month" name="month" class="gw-form-input w-200"
                   value="${dashboard.selectedMonth}">
            <button type="submit" class="gw-btn-primary">조회</button>
        </form>
    </div>

    <div class="admin-summary-grid">

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fa-solid fa-users"></i>
            </div>
            <div class="summary-title">전체 직원</div>
            <div class="summary-value">${dashboard.totalEmpCount}명</div>
            <div class="summary-desc">
                관리자 계정을 제외한 활성 직원 기준
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fa-solid fa-business-time"></i>
            </div>
            <div class="summary-title">오늘 출근</div>
            <div class="summary-value">${dashboard.todayCheckedInCount}명</div>
            <div class="summary-desc">
                오늘 출근 시간이 기록된 직원 수
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fa-solid fa-user-clock"></i>
            </div>
            <div class="summary-title">승인 대기 직원</div>
            <div class="summary-value">${dashboard.waitingEmpCount}명</div>
            <div class="summary-desc">
                가입 승인 대기 직원
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fa-solid fa-plane-departure"></i>
            </div>
            <div class="summary-title">이번 달 휴가</div>
            <div class="summary-value">${dashboard.monthlyLeaveCount}일</div>
            <div class="summary-desc">
                선택 월 기준 전사 휴가 사용 일수
            </div>
        </div>

    </div>
    
    <div class="admin-main-grid">

        <div class="dashboard-card admin-card large">
            <div class="card-header">
                <div class="card-title">전사 근태 통계</div>
            </div>

            <c:set var="normalTotal" value="0" />
            <c:set var="lateTotal" value="0" />
            <c:set var="earlyTotal" value="0" />
            <c:set var="lateEarlyTotal" value="0" />
            <c:set var="absentTotal" value="0" />

            <c:forEach var="stat" items="${dashboard.attendanceStats}">
                <c:set var="normalTotal" value="${normalTotal + stat.normalCount}" />
                <c:set var="lateTotal" value="${lateTotal + stat.lateCount}" />
                <c:set var="earlyTotal" value="${earlyTotal + stat.earlyLeaveCount}" />
                <c:set var="lateEarlyTotal" value="${lateEarlyTotal + stat.lateEarlyCount}" />
                <c:set var="absentTotal" value="${absentTotal + stat.absentCount}" />
            </c:forEach>

            <div class="chart-legend">
                <span><i class="legend-dot bar-blue"></i>정상근무</span>
                <span><i class="legend-dot bar-green"></i>휴가</span>
                <span><i class="legend-dot bar-yellow"></i>지각</span>
                <span><i class="legend-dot bar-red"></i>조퇴</span>
                <span><i class="legend-dot bar-purple"></i>지각-조퇴</span>
                <span><i class="legend-dot bar-gray"></i>결근</span>
            </div>

            <div class="chart-area">
                <div class="chart-grid">
                    <div class="chart-grid-line">${dashboard.attendanceChartMax}</div>
                    <div class="chart-grid-line">${dashboard.attendanceChart4}</div>
                    <div class="chart-grid-line">${dashboard.attendanceChart3}</div>
                    <div class="chart-grid-line">${dashboard.attendanceChart2}</div>
                    <div class="chart-grid-line">${dashboard.attendanceChart1}</div>
                    <div class="chart-grid-line">0</div>
                </div>

                <div class="chart-bars">
                    <c:forEach var="stat" items="${dashboard.attendanceStats}">
                        <div class="chart-group">
                            <div class="chart-bar bar-blue"
                                 style="height:${stat.normalCount * 100 / dashboard.attendanceChartMax}%;"></div>

                            <div class="chart-bar bar-green"
                                 style="height:${stat.leaveCount * 100 / dashboard.attendanceChartMax}%;"></div>

                            <div class="chart-bar bar-yellow"
                                 style="height:${stat.lateCount * 100 / dashboard.attendanceChartMax}%;"></div>

                            <div class="chart-bar bar-red"
                                 style="height:${stat.earlyLeaveCount * 100 / dashboard.attendanceChartMax}%;"></div>

                            <div class="chart-bar bar-purple"
                                 style="height:${stat.lateEarlyCount * 100 / dashboard.attendanceChartMax}%;"></div>

                            <div class="chart-bar bar-gray"
                                 style="height:${stat.absentCount * 100 / dashboard.attendanceChartMax}%;"></div>

                            <div class="chart-label">${stat.label}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="attn-mini-grid">
                <div class="attn-mini-card">
                    <div class="attn-mini-title">출근</div>
                    <div class="attn-mini-value">${normalTotal}건</div>
                </div>

                <div class="attn-mini-card">
                    <div class="attn-mini-title">지각</div>
                    <div class="attn-mini-value">${lateTotal + lateEarlyTotal}건</div>
                </div>

                <div class="attn-mini-card">
                    <div class="attn-mini-title">조퇴</div>
                    <div class="attn-mini-value">${earlyTotal + lateEarlyTotal}건</div>
                </div>

                <div class="attn-mini-card">
                    <div class="attn-mini-title">결근</div>
                    <div class="attn-mini-value">${absentTotal}건</div>
                </div>
            </div>
        </div>

        <div class="dashboard-card admin-card large">
            <div class="card-header">
                <div class="card-title">전사 결재 통계</div>
            </div>

            <div class="approval-total-box">
                <div class="approval-total-title">선택 월 전체 결재</div>
                <div class="approval-total-value">${dashboard.approvalTotalCount}건</div>
            </div>

            <div class="donut-wrap">
                <c:choose>
                    <c:when test="${dashboard.approvalTotalCount > 0}">
                        <div class="fake-donut approval-donut"
                             style="--approve-end:${dashboard.approvalApprovePercent}%;
                                    --ing-end:${dashboard.approvalIngEndPercent}%;">
                            <div class="fake-donut-center"></div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="fake-donut approval-donut empty">
                            <div class="fake-donut-center"></div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="stat-list">
                    <div class="stat-item">
                        <span><i class="legend-dot bar-green"></i>승인</span>
                        <span>${dashboard.approvalApproveCount}건 (${dashboard.approvalApprovePercent}%)</span>
                    </div>

                    <div class="stat-item">
                        <span><i class="legend-dot bar-yellow"></i>진행중</span>
                        <span>${dashboard.approvalIngCount}건 (${dashboard.approvalIngPercent}%)</span>
                    </div>

                    <div class="stat-item">
                        <span><i class="legend-dot bar-red"></i>반려</span>
                        <span>${dashboard.approvalRejectCount}건 (${dashboard.approvalRejectPercent}%)</span>
                    </div>
                </div>
            </div>

            <a href="/admin/app/list" class="admin-link-btn">
                결재 관리 바로가기
            </a>
        </div>

    </div>
	
	    <div class="admin-sub-grid">

        <div class="dashboard-card admin-card">
		    <div class="card-header">
		        <div>
		            <div class="card-title">부서 현황</div>
		            <div class="gw-table-sub">
		                모든 하위부서에 포함된 인원을 표시합니다.
		            </div>
		        </div>
		
		        <a href="/dept/list" class="gw-link">더보기</a>
		    </div>
		
		    <div class="dept-rank-list">
		        <c:forEach var="dept" items="${dashboard.deptEmpCountList}">
		            <div class="dept-rank-row">
		                <div>${dept.deptName}</div>
		
		                <div class="dept-rank-track">
		                    <div class="dept-rank-fill"
		                         style="width:${dashboard.maxDeptEmpCount == 0 ? 0 : dept.empCount * 100 / dashboard.maxDeptEmpCount}%;"></div>
		                </div>
		
		                <div>${dept.empCount}명</div>
		            </div>
		        </c:forEach>
		    </div>
		</div>

        <div class="gw-list-panel" style="margin-bottom:0;">
		    <div class="gw-table-top" style="margin-bottom: 5px;">
		        <div>
		            <div class="gw-table-title">최근 가입 직원</div>
		            <div class="gw-table-sub">
		                최근 생성된 직원 계정 5건을 표시합니다.
		            </div>
		        </div>
		
		        <a href="/admin/list" class="gw-link">더보기</a>
		    </div>
		
		    <table class="gw-table admin-compact-table">
		        <tbody>
		            <c:forEach var="emp" items="${dashboard.recentEmpList}">
		                <tr>
		                    <td>${emp.empNo}</td>
		                    <td>${emp.empName}</td>
		                    <td>${emp.deptName}</td>
		                    <td>${emp.empCreateAt}</td>
		                </tr>
		            </c:forEach>
		
		            <c:if test="${empty dashboard.recentEmpList}">
		                <tr>
		                    <td colspan="4" class="gw-muted">
		                        최근 가입 직원이 없습니다.
		                    </td>
		                </tr>
		            </c:if>
		        </tbody>
		    </table>
		</div>
		
        <div class="dashboard-card admin-card">
		    <div class="card-header">
		        <div class="card-title">오늘 생일자</div>
		        <a href="/admin/list" class="gw-link">더보기</a>
		    </div>
		
		    <c:choose>
		        <c:when test="${empty dashboard.todayBirthdayList}">
		            <div class="admin-empty-card">
		                <div class="admin-empty-icon">
		                    <i class="fa-solid fa-cake-candles"></i>
		                </div>
		                <div class="admin-empty-title">오늘 생일자는 없습니다</div>
		                <div class="admin-empty-desc">직원 생일 정보가 있으면 이곳에 표시됩니다.</div>
		            </div>
		        </c:when>
		
		        <c:otherwise>
		            <div class="stat-list">
		                <c:forEach var="emp" items="${dashboard.todayBirthdayList}">
		                    <div class="stat-item">
		                        <span>
		                            <i class="fa-solid fa-cake-candles" style="color:#fb7185; margin-right:8px;"></i>
		                            ${emp.empName} ${emp.empPosition}
		                        </span>
		                        <span>${emp.deptName}</span>
		                    </div>
		                </c:forEach>
		            </div>
		        </c:otherwise>
		    </c:choose>
		</div>

    </div>
    <div class="admin-bottom-grid">
	
	    <div class="dashboard-card admin-card">
	       <div class="admin-wait-card">
			    <div class="admin-wait-icon">
			        <i class="fa-solid fa-user-clock"></i>
			    </div>
			
			    <div class="admin-wait-title">
			        가입 승인 대기
			    </div>
			
			    <div class="admin-wait-count">
			        ${dashboard.waitingEmpCount}명
			    </div>
			
			    <a href="/admin/waitingList" class="admin-link-btn" style="margin-top: 8px;">
			        승인하러 가기
			    </a>
			</div>
	    </div>
	
	    <div class="dashboard-card admin-card">
	        <div class="card-header">
	            <div class="card-title">최근 공지사항</div>
	            <a href="/board/list" class="gw-link">더보기</a>
	        </div>
	
	        <div class="stat-list">
	            <c:forEach var="notice" items="${dashboard.recentNoticeList}">
	                <div class="stat-item">
					    <span class="notice-title">${notice.noticeTitle}</span>
					    <span>${notice.noticeDate}</span>
	                </div>
	            </c:forEach>
	
	            <c:if test="${empty dashboard.recentNoticeList}">
	                <div class="gw-muted" style="padding:18px 0;">
	                    최근 공지사항이 없습니다.
	                </div>
	            </c:if>
	        </div>
	    </div>
	
	    <div class="dashboard-card admin-card">
	        <div class="card-header">
	            <div class="card-title">최근 로그인 현황</div>
	        </div>
	
	        <div class="login-stat-list">
	            <c:forEach var="stat" items="${dashboard.loginStatList}">
	                <div class="login-stat-item">
	                    <div class="login-stat-bar"
	                         style="height:${stat.count * 100 / dashboard.loginChartMax}%;"></div>
	                    <div class="login-stat-count">${stat.count}</div>
	                    <div class="login-stat-label">${stat.label}</div>
	                </div>
	            </c:forEach>
	        </div>
	    </div>
	
	</div>

</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>