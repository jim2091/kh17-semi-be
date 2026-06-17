<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.dept-dashboard {
    max-width: 1280px;
    margin: 0 auto;
}

.dept-filter {
    display: flex;
    gap: 10px;
    align-items: center;
}

.manager-summary-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 18px;
    margin-bottom: 18px;
}

.manager-main-grid {
    display: grid;
    grid-template-columns: 1.25fr 1fr;
    gap: 18px;
    margin-bottom: 18px;
}

.manager-sub-grid {
    display: grid;
    grid-template-columns: 1fr 1.35fr;
    gap: 18px;
}

.manager-card {
    height: auto;
    min-height: 360px;
}

.manager-card.large {
    min-height: 420px;
}

.summary-desc {
    color: var(--sub-text);
    font-size: 13px;
    font-weight: 700;
    line-height: 1.6;
}

.change-up {
    color: var(#3b82f6);
    font-weight: 900;
}

.change-down {
    color: var(--danger-color);
    font-weight: 900;
}

.fake-chart {
    height: 230px;
    display: flex;
    align-items: flex-end;
    gap: 18px;
    padding: 18px 8px 8px;
    border-bottom: 1px solid var(--border-color);
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

.bar-blue {
    background: #2563eb; /* 정상근무 */
}

.bar-green {
    background: #10b981; /* 휴가 */
}

.bar-yellow {
    background: #f59e0b; /* 지각 */
}

.bar-red {
    background: #fb7185; /* 조퇴 */
}

.bar-purple {
    background: #8b5cf6; /* 지각-조퇴 */
}

.bar-gray {
    background: #64748b; /* 결근 */
}

.chart-label {
    position: absolute;
    bottom: -28px;
    color: var(--sub-text);
    font-size: 12px;
    font-weight: 800;
}

.chart-legend {
    display: flex;
    justify-content: center;
    gap: 18px;
    margin-top: 36px;
    color: var(--sub-text);
    font-size: 13px;
    font-weight: 800;
}

.legend-dot {
    display: inline-block;
    width: 9px;
    height: 9px;
    border-radius: 50%;
    margin-right: 6px;
}

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
    background: conic-gradient(
        var(--main-color) 0 68%,
        var(--success-color) 68% 82%,
        var(--warning-color) 82% 94%,
        var(--danger-color) 94% 100%
    );
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
    line-height: 1;
    margin: 0;
}

.approval-more-btn {
    display: block;
    margin-top: 18px;
    height: 42px;
    line-height: 42px;
    text-align: center;
    border-radius: 12px;
    background: var(--main-color);
    color: #fff;
    font-weight: 900;
    text-decoration: none;
}

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

.leave-calendar {
    width: 100%;
    border-collapse: collapse;
    table-layout: fixed;
    font-size: 13px;
}

.leave-calendar th {
    height: 34px;
    color: var(--sub-text);
    border-bottom: 1px solid var(--border-color);
}

.leave-calendar td {
    height: 54px;
    vertical-align: top;
    padding: 7px;
    border-bottom: 1px solid var(--border-color);
    color: var(--list-text-color);
    font-weight: 800;
}

.leave-calendar .muted {
    color: var(--muted-text);
}

.leave-dot {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 20px;
    height: 20px;
    margin-top: 5px;
    padding: 0 6px;
    border-radius: 999px;
    color: #fff;
    font-size: 11px;
    font-weight: 900;
}

.leave-annual { background: var(#3b82f6); }
.leave-half { background: var(--main-color); }
.leave-out { background: var(--warning-color); }

.member-state {
    display: flex;
    align-items: center;
    gap: 8px;
}

.state-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
}

.state-work { background: var(#3b82f6); }
.state-leave { background: var(--main-color); }
.state-out { background: var(--warning-color); }
.state-late { background: var(--danger-color); }

@media (max-width: 1200px) {
    .manager-summary-grid,
    .manager-main-grid,
    .manager-sub-grid {
        grid-template-columns: 1fr;
    }
}

.week-progress-wrap {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 18px 4px 4px;
}

.week-progress-item {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.week-progress-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: var(--list-text-color);
    font-size: 14px;
    font-weight: 800;
}

.week-progress-top strong {
    color: var(--card-title-color);
    font-size: 14px;
    font-weight: 900;
}

.week-progress-track {
    width: 100%;
    height: 12px;
    background: var(--input-bg);
    border: 1px solid var(--border-color);
    border-radius: 999px;
    overflow: hidden;
}

.week-progress-fill {
    height: 100%;
    border-radius: 999px;
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
</style>

<div class="dept-dashboard">

    <div class="gw-hero">
        <div>
            <h1>부서장 대시보드</h1>
            <p>부서 근태, 결재, 휴가, 구성원 현황을 한눈에 확인하세요.</p>
        </div>

        <div class="dept-filter">
        	<form id="deptDashboardForm" action="/dept/manager" method="get" class="dept-filter">
	            <input type="hidden" name="attnMode" id="attnModeInput" value="${dashboard.attnMode}">
	            <select name="deptId" class="gw-form-select">
	            	<c:forEach var="dept" items="${dashboard.managedDeptList}">
	            		<option value="${dept.deptId}"
	            			<c:if test="${dept.deptId == dashboard.selectedDeptId}">selected</c:if>>
	            			<c:forEach begin="1" end="${dept.depth}">&nbsp;&nbsp;</c:forEach>
	            			${dept.deptName}
	           			</option>
	            	</c:forEach>
	            </select>
	            <input type="month" name="month" class="gw-form-input w-200" 
	            		value="${dashboard.selectedMonth}">
	            <button type="submit" class="gw-btn-primary">조회</button>
            </form>
        </div>
    </div>

    <div class="manager-summary-grid">
        <div class="summary-card">
		    <div class="summary-icon">
		        <i class="fa-solid fa-users"></i>
		    </div>
		    <div class="summary-title">부서 구성원</div>
		    <div class="summary-value">${dashboard.memberCount}명</div>
		    <div class="summary-desc">
		        근무 ${dashboard.workingNowCount}명 ·
		        휴가 ${dashboard.leaveCount}명 ·
		        미확인 ${dashboard.uncheckedCount}명
		    </div>
		</div>

        <div class="summary-card">
		    <div class="summary-icon">
		        <i class="fa-solid fa-business-time"></i>
		    </div>
		    <div class="summary-title">오늘 출근율</div>
		    <div class="summary-value">
		        <fmt:formatNumber value="${dashboard.attendanceRate}" pattern="0.0"/>%
		    </div>
		    <div class="summary-desc">
		        출근 ${dashboard.checkedInCount}명 · 미확인 ${dashboard.uncheckedCount}명
		    </div>
		</div>

        <div class="summary-card">
		    <div class="summary-icon">
		        <i class="fa-solid fa-file-signature"></i>
		    </div>
		    <div class="summary-title">이번 달 결재</div>
		    <div class="summary-value">${dashboard.approvalTotalCount}건</div>
		    <div class="summary-desc">
		        승인 ${dashboard.approvalApproveCount}건 · 진행 ${dashboard.approvalIngCount}건
		    </div>
		</div>

        <div class="summary-card">
		    <div class="summary-icon">
		        <i class="fa-solid fa-plane-departure"></i>
		    </div>
		    <div class="summary-title">이번 달 휴가 사용</div>
		    <div class="summary-value">${dashboard.monthlyLeaveCount}일</div>
		    <div class="summary-desc">
		        선택 월 기준 휴가 사용 일수
		    </div>
		</div>
    </div>

    <div class="manager-main-grid">
        <div class="dashboard-card manager-card large">
            <div class="card-header">
                <div class="card-title">근태 통계</div>
                <div class="card-actions">
				    <button type="button"
				            class="attn-mode-btn ${dashboard.attnMode eq 'week' ? 'gw-btn-primary' : 'gw-btn-outline'}"
				            data-mode="week"
				            style="height:34px; padding:0 14px;">
				        주간
				    </button>
				
				    <button type="button"
				            class="attn-mode-btn ${dashboard.attnMode eq 'month' ? 'gw-btn-primary' : 'gw-btn-outline'}"
				            data-mode="month"
				            style="height:34px; padding:0 14px;">
				        월간
				    </button>
				</div>
            </div>

			<div id="attendanceChartArea">
	            <c:choose>
				    <%-- 주간 모드 --%>
				    <c:when test="${dashboard.attnMode eq 'week'}">
				        <c:forEach var="stat" items="${dashboard.attendanceStats}">
				
				            <c:set var="weekTotal"
								value="${stat.normalCount
								      + stat.lateCount
								      + stat.earlyLeaveCount
								      + stat.lateEarlyCount
								      + stat.leaveCount
								      + stat.absentCount}" />
				
				            <div class="week-progress-wrap">
				
				                <div class="week-progress-item">
				                    <div class="week-progress-top">
				                        <span><i class="legend-dot bar-blue"></i>정상근무</span>
				                        <strong>${stat.normalCount}건</strong>
				                    </div>
				                    <div class="week-progress-track">
				                        <div class="week-progress-fill bar-blue"
				                             style="width:${weekTotal == 0 ? 0 : stat.normalCount * 100 / weekTotal}%;"></div>
				                    </div>
				                </div>
				
				                <div class="week-progress-item">
				                    <div class="week-progress-top">
				                        <span><i class="legend-dot bar-yellow"></i>지각</span>
				                        <strong>${stat.lateCount}건</strong>
				                    </div>
				                    <div class="week-progress-track">
				                        <div class="week-progress-fill bar-yellow"
				                             style="width:${weekTotal == 0 ? 0 : stat.lateCount * 100 / weekTotal}%;"></div>
				                    </div>
				                </div>
				
				                <div class="week-progress-item">
				                    <div class="week-progress-top">
				                        <span><i class="legend-dot bar-red"></i>조퇴</span>
				                        <strong>${stat.earlyLeaveCount}건</strong>
				                    </div>
				                    <div class="week-progress-track">
				                        <div class="week-progress-fill bar-red"
				                             style="width:${weekTotal == 0 ? 0 : stat.earlyLeaveCount * 100 / weekTotal}%;"></div>
				                    </div>
				                </div>
				
				                <div class="week-progress-item">
				                    <div class="week-progress-top">
				                        <span><i class="legend-dot bar-purple"></i>지각-조퇴</span>
				                        <strong>${stat.lateEarlyCount}건</strong>
				                    </div>
				                    <div class="week-progress-track">
				                        <div class="week-progress-fill bar-purple"
				                             style="width:${weekTotal == 0 ? 0 : stat.lateEarlyCount * 100 / weekTotal}%;"></div>
				                    </div>
				                </div>
				
				                <div class="week-progress-item">
				                    <div class="week-progress-top">
				                        <span><i class="legend-dot bar-green"></i>휴가</span>
				                        <strong>${stat.leaveCount}건</strong>
				                    </div>
				                    <div class="week-progress-track">
				                        <div class="week-progress-fill bar-green"
				                             style="width:${weekTotal == 0 ? 0 : stat.leaveCount * 100 / weekTotal}%;"></div>
				                    </div>
				                </div>
				                <div class="week-progress-item">
								    <div class="week-progress-top">
								        <span>
								            <i class="legend-dot bar-gray"></i>결근</span>
								        <strong>${stat.absentCount}건</strong>
								    </div>
								    <div class="week-progress-track">
								        <div class="week-progress-fill bar-gray"
								             style="width:${weekTotal == 0 ? 0 : stat.absentCount * 100 / weekTotal}%;"></div>
								    </div>
								</div>
				
				            </div>
				        </c:forEach>
				    </c:when>
				
				    <%-- 월간 모드 --%>
				    <c:otherwise>
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
						
						<div class="chart-legend" style="margin-top:4px;">
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
	
				    </c:otherwise>
				
				</c:choose>
			</div>
        </div>

        <div class="dashboard-card manager-card large">
            <div class="card-header">
                <div class="card-title">결재 통계</div>
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
			                <div class="fake-donut-center">
			                </div>
			            </div>
			        </c:when>
			        <c:otherwise>
			            <div class="fake-donut approval-donut empty">
			                <div class="fake-donut-center">
			                    0건<br>
			                    데이터 없음
			                </div>
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
			
			<a href="/app/list" class="approval-more-btn">
			    결재 목록 바로가기
			</a>
        </div>
    </div>

    <div class="manager-sub-grid">
        <div class="dashboard-card manager-card">
            <div class="card-header">
                <div class="card-title">휴가 현황 (${dashboard.selectedMonth})</div>
            </div>

            <table class="leave-calendar">
                <thead>
                    <tr>
                        <th>일</th>
                        <th>월</th>
                        <th>화</th>
                        <th>수</th>
                        <th>목</th>
                        <th>금</th>
                        <th>토</th>
                    </tr>
                </thead>
                <tbody>
				    <c:forEach var="week" items="${dashboard.leaveCalendarWeeks}">
				        <tr>
				            <c:forEach var="day" items="${week}">
				                <td class="${day.currentMonth ? '' : 'muted'}">
				                    ${day.day}
				
				                    <c:if test="${day.leaveCount > 0}">
				                        <br>
				                        <span class="leave-dot leave-annual">
				                            ${day.leaveCount}
				                        </span>
				                    </c:if>
				                </td>
				            </c:forEach>
				        </tr>
				    </c:forEach>
				</tbody>
            </table>
        </div>

        <div class="gw-list-panel" style="margin-bottom:0;">
            <div class="gw-table-top">
                <div>
                    <div class="gw-table-title">부서 구성원 현황</div>
                    <div class="gw-table-sub">
					    선택한 부서 직접 소속 ${dashboard.directMemberCount}명을 표시합니다.
					    하위 부서 구성원은 상단 통계에만 포함됩니다.
					</div>
                </div>
            </div>

            <table class="gw-table">
                <thead>
                    <tr>
					    <th>이름</th>
					    <th>직급</th>
					    <th>상태</th>
					    <th>출근시간</th>
					</tr>
                </thead>
                <tbody>
				    <c:forEach var="member" items="${dashboard.directMemberList}">
				        <tr>
				            <td>${member.empName}</td>
				            <td>${member.empPosition}</td>
				            <td>
				                <span class="member-state">
				                    <c:choose>
				                        <c:when test="${member.attnRecord eq '정상근무'}">
				                            <i class="state-dot state-work"></i> 근무중
				                        </c:when>
				                        <c:when test="${member.attnRecord eq '휴가'}">
				                            <i class="state-dot state-leave"></i> 휴가
				                        </c:when>
				                        <c:when test="${member.attnRecord eq '지각'}">
				                            <i class="state-dot state-late"></i> 지각
				                        </c:when>
				                        <c:when test="${member.attnRecord eq '조퇴'}">
				                            <i class="state-dot state-late"></i> 조퇴
				                        </c:when>
				                        <c:when test="${member.attnRecord eq '지각-조퇴'}">
				                            <i class="state-dot state-late"></i> 지각-조퇴
				                        </c:when>
				                        <c:when test="${member.attnRecord eq '결근'}">
				                            <i class="state-dot state-out"></i> 결근
				                        </c:when>
				                        <c:otherwise>
				                            <i class="state-dot state-out"></i> 미확인
				                        </c:otherwise>
				                    </c:choose>
				                </span>
				            </td>
				            <td>
				                <c:choose>
				                    <c:when test="${empty member.attnInTime}">
				                        -
				                    </c:when>
				                    <c:otherwise>
				                        ${member.attnInTime}
				                    </c:otherwise>
				                </c:choose>
				            </td>
				        </tr>
				    </c:forEach>
				
				    <c:if test="${empty dashboard.directMemberList}">
				        <tr>
				            <td colspan="4" class="gw-muted">
				                선택한 부서에 직접 소속된 구성원이 없습니다.
				            </td>
				        </tr>
				    </c:if>
				</tbody>
            </table>
        </div>
    </div>

</div>

<script>
$(function() {

    $(".attn-mode-btn").on("click", function() {
        var mode = $(this).data("mode");
        var deptId = $("select[name=deptId]").val();
        var month = $("input[name=month]").val();

        $("#attnModeInput").val(mode);

        $.ajax({
            url: "/rest/dept/manager/attendance",
            method: "get",
            data: {
                deptId: deptId,
                month: month,
                attnMode: mode
            },
            success: function(resp) {
                renderAttendanceChart(resp);
                changeAttendanceButton(mode);
            }
        });
    });

    function changeAttendanceButton(mode) {
        $(".attn-mode-btn").removeClass("gw-btn-primary").addClass("gw-btn-outline");

        $(".attn-mode-btn[data-mode=" + mode + "]")
            .removeClass("gw-btn-outline")
            .addClass("gw-btn-primary");
    }

    function renderAttendanceChart(resp) {
        if (resp.attnMode === "week") {
            renderWeekAttendance(resp);
        }
        else {
            renderMonthAttendance(resp);
        }
    }
    function renderWeekAttendance(resp) {
        var stats = resp.stats;

        if (stats.length === 0) {
            $("#attendanceChartArea").html(
                '<div class="empty-text">선택한 기간의 근태 통계가 없습니다.</div>'
            );
            return;
        }

        var stat = stats[0];

        var weekTotal =
            stat.normalCount +
            stat.leaveCount +
            stat.lateCount +
            stat.earlyLeaveCount +
            stat.lateEarlyCount +
            stat.absentCount;

        function percent(value) {
            if (weekTotal === 0) return 0;
            return value * 100 / weekTotal;
        }

        var html = '';

        html += '<div class="week-progress-wrap">';

        html += createProgressRow('bar-blue', '정상근무', stat.normalCount, percent(stat.normalCount));
        html += createProgressRow('bar-green', '휴가', stat.leaveCount, percent(stat.leaveCount));
        html += createProgressRow('bar-yellow', '지각', stat.lateCount, percent(stat.lateCount));
        html += createProgressRow('bar-red', '조퇴', stat.earlyLeaveCount, percent(stat.earlyLeaveCount));
        html += createProgressRow('bar-purple', '지각-조퇴', stat.lateEarlyCount, percent(stat.lateEarlyCount));
        html += createProgressRow('bar-gray', '결근', stat.absentCount, percent(stat.absentCount));

        html += '</div>';

        $("#attendanceChartArea").html(html);
    }

    function createProgressRow(colorClass, label, count, percent) {
        var html = '';

        html += '<div class="week-progress-item">';
        html += '   <div class="week-progress-top">';
        html += '       <span><i class="legend-dot ' + colorClass + '"></i>' + label + '</span>';
        html += '       <strong>' + count + '건</strong>';
        html += '   </div>';
        html += '   <div class="week-progress-track">';
        html += '       <div class="week-progress-fill ' + colorClass + '" style="width:' + percent + '%;"></div>';
        html += '   </div>';
        html += '</div>';

        return html;
    }
    
    function renderMonthAttendance(resp) {
        var stats = resp.stats;

        if (stats.length === 0) {
            $("#attendanceChartArea").html(
                '<div class="empty-text">선택한 월의 근태 통계가 없습니다.</div>'
            );
            return;
        }

        var normalTotal = 0;
        var lateTotal = 0;
        var earlyTotal = 0;
        var lateEarlyTotal = 0;
        var absentTotal = 0;

        var html = '';

        html += '<div class="chart-legend" style="margin-top:4px;">';
        html += '   <span><i class="legend-dot bar-blue"></i>정상근무</span>';
        html += '   <span><i class="legend-dot bar-green"></i>휴가</span>';
        html += '   <span><i class="legend-dot bar-yellow"></i>지각</span>';
        html += '   <span><i class="legend-dot bar-red"></i>조퇴</span>';
        html += '   <span><i class="legend-dot bar-purple"></i>지각-조퇴</span>';
        html += '   <span><i class="legend-dot bar-gray"></i>결근</span>';
        html += '</div>';

        html += '<div class="chart-area">';

        html += '   <div class="chart-grid">';
        html += '       <div class="chart-grid-line">' + resp.chartMax + '</div>';
        html += '       <div class="chart-grid-line">' + resp.chart4 + '</div>';
        html += '       <div class="chart-grid-line">' + resp.chart3 + '</div>';
        html += '       <div class="chart-grid-line">' + resp.chart2 + '</div>';
        html += '       <div class="chart-grid-line">' + resp.chart1 + '</div>';
        html += '       <div class="chart-grid-line">0</div>';
        html += '   </div>';

        html += '   <div class="chart-bars">';

        for (var i = 0; i < stats.length; i++) {
            var stat = stats[i];

            normalTotal += stat.normalCount;
            lateTotal += stat.lateCount;
            earlyTotal += stat.earlyLeaveCount;
            lateEarlyTotal += stat.lateEarlyCount;
            absentTotal += stat.absentCount;

            html += '<div class="chart-group">';
            html += createChartBar('bar-blue', stat.normalCount, resp.chartMax);
            html += createChartBar('bar-green', stat.leaveCount, resp.chartMax);
            html += createChartBar('bar-yellow', stat.lateCount, resp.chartMax);
            html += createChartBar('bar-red', stat.earlyLeaveCount, resp.chartMax);
            html += createChartBar('bar-purple', stat.lateEarlyCount, resp.chartMax);
            html += createChartBar('bar-gray', stat.absentCount, resp.chartMax);
            html += '   <div class="chart-label">' + stat.label + '</div>';
            html += '</div>';
        }

        html += '   </div>';
        html += '</div>';

        html += '<div class="attn-mini-grid">';
        html += createMiniCard('출근', normalTotal);
        html += createMiniCard('지각', lateTotal + lateEarlyTotal);
        html += createMiniCard('조퇴', earlyTotal + lateEarlyTotal);
        html += createMiniCard('결근', absentTotal);
        html += '</div>';

        $("#attendanceChartArea").html(html);
    }

    function createChartBar(colorClass, count, chartMax) {
        var height = 0;

        if (chartMax > 0) {
            height = count * 100 / chartMax;
        }

        return '<div class="chart-bar ' + colorClass + '" style="height:' + height + '%;"></div>';
    }

    function createMiniCard(title, count) {
        var html = '';

        html += '<div class="attn-mini-card">';
        html += '   <div class="attn-mini-title">' + title + '</div>';
        html += '   <div class="attn-mini-value">' + count + '건</div>';
        html += '</div>';

        return html;
    }
    
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>