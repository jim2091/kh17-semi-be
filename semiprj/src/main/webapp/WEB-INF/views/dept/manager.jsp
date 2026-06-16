<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
    color: var(--success-color);
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

.bar-blue { background: var(--main-color); }
.bar-green { background: var(--success-color); }
.bar-yellow { background: var(--warning-color); }
.bar-red { background: var(--danger-color); }

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

.fake-donut::after {
    content: "48건\A총 결재";
    white-space: pre;
    position: absolute;
    inset: 38px;
    border-radius: 50%;
    background: var(--card-bg);
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    color: var(--card-title-color);
    font-size: 20px;
    font-weight: 900;
    line-height: 1.35;
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

.leave-annual { background: var(--success-color); }
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

.state-work { background: var(--success-color); }
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
</style>

<div class="dept-dashboard">

    <div class="gw-hero">
        <div>
            <h1>부서장 대시보드</h1>
            <p>부서 근태, 결재, 휴가, 구성원 현황을 한눈에 확인하세요.</p>
        </div>

        <div class="dept-filter">
        	<form action="/dept/manager" method="get" class="dept-filter">
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
            <div class="summary-value">18명</div>
            <div class="summary-desc">근무 15명 · 휴가 2명 · 외근 1명</div>
        </div>

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fa-solid fa-business-time"></i>
            </div>
            <div class="summary-title">오늘 출근율</div>
            <div class="summary-value">92.3%</div>
            <div class="summary-desc">전월 대비 <span class="change-up">▲ 3.2%p</span></div>
        </div>

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fa-solid fa-file-signature"></i>
            </div>
            <div class="summary-title">이번 달 결재</div>
            <div class="summary-value">48건</div>
            <div class="summary-desc">완료 41건 · 진행중 7건</div>
        </div>

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fa-solid fa-plane-departure"></i>
            </div>
            <div class="summary-title">이번 달 휴가 사용</div>
            <div class="summary-value">6.5일</div>
            <div class="summary-desc">전월 대비 <span class="change-up">▲ 1.2일</span></div>
        </div>
    </div>

    <div class="manager-main-grid">
        <div class="dashboard-card manager-card large">
            <div class="card-header">
                <div class="card-title">근태 통계</div>
                <div class="card-actions">
                    <button type="button" class="gw-btn-outline" style="height:34px; padding:0 14px;">주간</button>
                    <button type="button" class="gw-btn-primary" style="height:34px; padding:0 14px;">월간</button>
                </div>
            </div>

            <div class="fake-chart">
                <div class="chart-group">
                    <div class="chart-bar bar-blue" style="height:68%;"></div>
                    <div class="chart-bar bar-green" style="height:24%;"></div>
                    <div class="chart-bar bar-yellow" style="height:8%;"></div>
                    <div class="chart-bar bar-red" style="height:4%;"></div>
                    <div class="chart-label">1주</div>
                </div>
                <div class="chart-group">
                    <div class="chart-bar bar-blue" style="height:72%;"></div>
                    <div class="chart-bar bar-green" style="height:28%;"></div>
                    <div class="chart-bar bar-yellow" style="height:10%;"></div>
                    <div class="chart-bar bar-red" style="height:0%;"></div>
                    <div class="chart-label">2주</div>
                </div>
                <div class="chart-group">
                    <div class="chart-bar bar-blue" style="height:66%;"></div>
                    <div class="chart-bar bar-green" style="height:18%;"></div>
                    <div class="chart-bar bar-yellow" style="height:6%;"></div>
                    <div class="chart-bar bar-red" style="height:5%;"></div>
                    <div class="chart-label">3주</div>
                </div>
                <div class="chart-group">
                    <div class="chart-bar bar-blue" style="height:63%;"></div>
                    <div class="chart-bar bar-green" style="height:14%;"></div>
                    <div class="chart-bar bar-yellow" style="height:5%;"></div>
                    <div class="chart-bar bar-red" style="height:0%;"></div>
                    <div class="chart-label">4주</div>
                </div>
                <div class="chart-group">
                    <div class="chart-bar bar-blue" style="height:58%;"></div>
                    <div class="chart-bar bar-green" style="height:10%;"></div>
                    <div class="chart-bar bar-yellow" style="height:3%;"></div>
                    <div class="chart-bar bar-red" style="height:0%;"></div>
                    <div class="chart-label">5주</div>
                </div>
            </div>

            <div class="chart-legend">
                <span><i class="legend-dot bar-blue"></i>출근</span>
                <span><i class="legend-dot bar-green"></i>연장근무</span>
                <span><i class="legend-dot bar-yellow"></i>지각</span>
                <span><i class="legend-dot bar-red"></i>결근</span>
            </div>
        </div>

        <div class="dashboard-card manager-card large">
            <div class="card-header">
                <div class="card-title">결재 통계</div>
                <a href="#" class="card-more">결재 목록 ></a>
            </div>

            <div class="donut-wrap">
                <div class="fake-donut"></div>

                <div class="stat-list">
                    <div class="stat-item">
                        <span><i class="legend-dot bar-blue"></i>기안</span>
                        <span>22건</span>
                    </div>
                    <div class="stat-item">
                        <span><i class="legend-dot bar-green"></i>완료</span>
                        <span>41건</span>
                    </div>
                    <div class="stat-item">
                        <span><i class="legend-dot bar-yellow"></i>결재중</span>
                        <span>7건</span>
                    </div>
                    <div class="stat-item">
                        <span><i class="legend-dot bar-red"></i>반려</span>
                        <span>2건</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="manager-sub-grid">
        <div class="dashboard-card manager-card">
            <div class="card-header">
                <div class="card-title">휴가 현황 (2025-05)</div>
                <a href="#" class="card-more">휴가 관리 ></a>
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
                    <tr>
                        <td class="muted">27</td>
                        <td class="muted">28</td>
                        <td class="muted">29</td>
                        <td class="muted">30</td>
                        <td>1</td>
                        <td>2 <br><span class="leave-dot leave-half">1</span></td>
                        <td>3</td>
                    </tr>
                    <tr>
                        <td>4</td>
                        <td>5</td>
                        <td>6</td>
                        <td>7 <br><span class="leave-dot leave-annual">2</span></td>
                        <td>8</td>
                        <td>9</td>
                        <td>10</td>
                    </tr>
                    <tr>
                        <td>11</td>
                        <td>12</td>
                        <td>13 <br><span class="leave-dot leave-out">1</span></td>
                        <td>14</td>
                        <td>15 <br><span class="leave-dot leave-annual">1</span></td>
                        <td>16</td>
                        <td>17</td>
                    </tr>
                    <tr>
                        <td>18</td>
                        <td>19</td>
                        <td>20</td>
                        <td>21 <br><span class="leave-dot leave-half">1</span></td>
                        <td>22</td>
                        <td>23</td>
                        <td>24</td>
                    </tr>
                    <tr>
                        <td>25</td>
                        <td>26 <br><span class="leave-dot leave-annual">2</span></td>
                        <td>27</td>
                        <td>28</td>
                        <td>29</td>
                        <td>30</td>
                        <td>31</td>
                    </tr>
                </tbody>
            </table>

            <div class="chart-legend" style="margin-top:16px;">
                <span><i class="legend-dot bar-green"></i>연차</span>
                <span><i class="legend-dot bar-blue"></i>반차</span>
                <span><i class="legend-dot bar-yellow"></i>외근</span>
            </div>
        </div>

        <div class="gw-list-panel" style="margin-bottom:0;">
            <div class="gw-table-top">
                <div>
                    <div class="gw-table-title">부서 구성원 현황</div>
                    <div class="gw-table-sub">총 18명 중 일부만 표시한 디자인 샘플입니다.</div>
                </div>
                <a href="#" class="card-more">전체 보기 ></a>
            </div>

            <table class="gw-table">
                <thead>
                    <tr>
                        <th>이름</th>
                        <th>직급</th>
                        <th>상태</th>
                        <th>근무시간</th>
                        <th>비고</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>김대리</td>
                        <td>대리</td>
                        <td>
                            <span class="member-state">
                                <i class="state-dot state-work"></i> 근무중
                            </span>
                        </td>
                        <td>09:00 ~ 18:00</td>
                        <td class="gw-muted">-</td>
                    </tr>
                    <tr>
                        <td>박사원</td>
                        <td>사원</td>
                        <td>
                            <span class="member-state">
                                <i class="state-dot state-leave"></i> 휴가
                            </span>
                        </td>
                        <td>-</td>
                        <td class="gw-muted">연차 사용</td>
                    </tr>
                    <tr>
                        <td>이사원</td>
                        <td>사원</td>
                        <td>
                            <span class="member-state">
                                <i class="state-dot state-out"></i> 외근
                            </span>
                        </td>
                        <td>-</td>
                        <td class="gw-muted">거래처 방문</td>
                    </tr>
                    <tr>
                        <td>최주임</td>
                        <td>주임</td>
                        <td>
                            <span class="member-state">
                                <i class="state-dot state-work"></i> 근무중
                            </span>
                        </td>
                        <td>09:00 ~ 18:00</td>
                        <td class="gw-muted">-</td>
                    </tr>
                    <tr>
                        <td>정사원</td>
                        <td>사원</td>
                        <td>
                            <span class="member-state">
                                <i class="state-dot state-late"></i> 지각
                            </span>
                        </td>
                        <td>09:32 ~ 18:00</td>
                        <td class="gw-muted">출근 지연</td>
                    </tr>
                    <tr>
                        <td>한대리</td>
                        <td>대리</td>
                        <td>
                            <span class="member-state">
                                <i class="state-dot state-work"></i> 근무중
                            </span>
                        </td>
                        <td>08:55 ~ 18:00</td>
                        <td class="gw-muted">-</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>