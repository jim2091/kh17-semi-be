<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 카드 범위 넘어가는 부분 흐릿하게 자연스럽게 지워지게 */
.calendar-card {
    position: relative;
}
.calendar-card::after {
    content: "";
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    height: 55px;
    pointer-events: none;
    background: linear-gradient(
        to bottom,
        rgba(255,255,255,0),
        rgba(255,255,255,1)
    );
}
/* 일정 제목 숨김 */
.toastui-calendar-weekday-event-title {
    display:none !important;
}

/* 점 형태로 표시 */
.toastui-calendar-weekday-event-block {
    height:6px !important;
    min-height:6px !important;
    border-radius:999px !important;
}
#home-calendar{
    height:500px !important;
}
</style>


    <div class="gw-hero">
        <div>
            <h1>${loginUser.empName}님, 좋은 하루 보내세요! 👋</h1>
            <p>오늘도 효율적인 업무를 시작해보세요.</p>
        </div>

        <c:if test="${sessionScope.managerToggle != null}">
            <div class="gw-toggle-box">
                <span>
                    <c:choose>
                        <c:when test="${sessionScope.managerToggle}">
                            관리자 모드
                        </c:when>
                        <c:otherwise>
                            직원 모드
                        </c:otherwise>
                    </c:choose>
                </span>

                <label class="toggle">
                    <input type="checkbox" name="managerToggle"
                        <c:if test="${sessionScope.managerToggle}">checked</c:if>>
                    <span class="slider"></span>
                </label>
            </div>
        </c:if>
    </div>

    <div class="summary-grid">
        <div class="summary-card">
            <div class="summary-icon"><i class="fa-solid fa-file-circle-check"></i></div>
            <div class="summary-title">미결재 문서</div>
            <div class="summary-value">${penddingAppCount}건</div>
            <a href="/appr/list" class="summary-link">결재하러 가기 ></a>
        </div>

        <div class="summary-card">
            <div class="summary-icon"><i class="fa-solid fa-envelope-open-text"></i></div>
            <div class="summary-title">안 읽은 쪽지</div>
            <div class="summary-value">${unreadMessageCount}건</div>
            <a href="/message/receiveList" class="summary-link">쪽지함 ></a>
        </div>

        <div class="summary-card">
            <div class="summary-icon"><i class="fa-solid fa-calendar-day"></i></div>
            <div class="summary-title">오늘 일정</div>
            <div class="summary-value">${todayEventCount}건</div>
            <a href="/event/calendar" class="summary-link">일정보기 ></a>
        </div>

       <div class="summary-card attendance-summary" style="display: flex; flex-direction: column; justify-content: space-between; min-height: 200px;">
		    <div class="attendance-top">
		        <div class="attendance-title-wrap" style="display: flex; align-items: center; gap: 8px;">
		            <div class="summary-icon">
		                <i class="fa-solid fa-business-time"></i>
		            </div>
		            <div class="summary-title" style="font-weight: bold; font-size: 16px;">근태 현황</div>
		        </div>
		        <div id="attnStatusText" class="attendance-status working" style="margin-left: auto; font-weight: bold;">● 미출근</div>
		    </div>
		
		    <div class="attendance-time" style="display: flex; justify-content: space-between; margin: 15px 0; font-size: 15px;">
		        <div>출근 <strong id="inTimeDisplay" style="color: #2563eb; margin-left: 4px;">-</strong></div>
		        <div>퇴근 <strong id="outTimeDisplay" style="color: #ef4444; margin-left: 4px;">-</strong></div>
		    </div>
		
            <!-- 💡 버튼 그리드 영역 최적화 (출퇴근 좌우 정렬 / 삭제 하단 배치) -->
            <div style="display: flex; flex-direction: column; gap: 8px; width: 100%;">
                <div style="display: flex; gap: 8px; width: 100%;">
                    <!-- 출근 버튼 -->
                    <button type="button" id="mainCheckInBtn" class="gw-btn-primary" onclick="ajaxCheckIn()"
                        style="padding: 12px; border-radius: 8px; font-size: 14px; font-weight: bold; cursor: pointer; flex: 1; border: none;">
                        <span id="mainCheckInBtnText">출근하기</span>
                    </button>
                    <!-- 퇴근 버튼 (새로 주입됨) -->
                    <button type="button" id="mainCheckOutBtn" class="gw-btn-primary" onclick="ajaxCheckOut()"
                        style="padding: 12px; border-radius: 8px; font-size: 14px; font-weight: bold; cursor: pointer; flex: 1; background-color: #3b82f6; border: none; color: white;">
                        <span id="mainCheckOutBtnText">퇴근하기</span>
                    </button>
                </div>
                
                <!-- 기록 삭제 버튼 -->
                <button type="button" class="gw-btn-secondary" onclick="ajaxClearAttn()"
                    style="padding: 6px; border-radius: 6px; font-size: 12px; cursor: pointer; background-color: #f3f4f6; color: #6b7280; border: 1px solid #e5e7eb; width: 100%;">
                    기록 초기화
                </button>
            </div>
	    </div>
    </div>

    <div class="dashboard-grid">

        <div class="dashboard-card dashboard-widget" data-widget-id="notice">
            <div class="card-header">
                <div class="card-title">공지사항</div>
			    <div class="card-actions">
			        <button type="button" class="widget-up">▲</button>
			        <button type="button" class="widget-down">▼</button>
			        <a href="/board/list" class="card-more">더보기 ></a>
			    </div>
            </div>
			<div class="card-body">
	            <c:forEach var="board" items="${noticeList}">
	                <div class="list-row" onclick="location.href='/board/detail?boardNo=${board.boardNo}'" style="cursor:pointer;">
	                    <div>
	                        <div>${board.boardTitle}</div>
	                        <div class="list-sub">${board.boardType}</div>
	                    </div>
	                </div>
	            </c:forEach>
	            <c:if test="${empty boardList}">
	                <div class="empty-text">공지가 없습니다.</div>
	            </c:if>
           </div>
        </div>

        <div class="dashboard-card dashboard-widget" data-widget-id="today-schedule">
            <div class="card-header">
                <div class="card-title">오늘의 일정</div>
                    <div class="card-actions">
				        <button type="button" class="widget-up">▲</button>
				        <button type="button" class="widget-down">▼</button>
				        <a href="/event/calendarList" class="card-more">일정 전체보기 ></a>
				    </div>
                
            </div>
			<div class="card-body">
	            <c:forEach var="event" items="${todayEventList}">
	                <div class="list-row" onclick="location.href='/event/calendar'" style="cursor:pointer;">
	                    <div><fmt:formatDate value="${event.eventStart}" pattern="HH:mm"/></div>
	                    <div style="margin-left:auto; text-align:right;">
	                        <div>${event.eventTitle}</div>
	                        <div class="list-sub">${event.eventCategory}</div>
	                    </div>
	                </div>
	            </c:forEach>
	            <c:if test="${empty todayEventList}">
	                <div class="empty-text">일정이 없습니다.</div>
	            </c:if>
	        </div>
        </div>

        <div class="dashboard-card dashboard-widget calendar-card" data-widget-id="calendar">
            <div class="card-header">
                <div class="card-title">캘린더</div>
                <div class="card-actions">
		        	<button type="button" class="widget-up">▲</button>
		        	<button type="button" class="widget-down">▼</button>
                	<a href="/event/calendar" class="card-more">></a>
		    	</div>
            </div>
            <div class="card-body">
            	<div id="home-calendar"></div>
            </div>
        </div>
		
        <div class="dashboard-card dashboard-widget" data-widget-id="approval">
            <div class="card-header">
                <div class="card-title">최근 전자결재</div>
                <div class="card-actions">
			        <button type="button" class="widget-up">▲</button>
			        <button type="button" class="widget-down">▼</button>
			        <a href="/app/list" class="card-more">더보기 ></a>
			    </div>
            </div>
			<div class="card-body">
	            <c:forEach var="app" items="${myAppList}">
	                <div class="list-row" onclick="location.href='/app/detail?appId=${app.appId}'" style="cursor:pointer;">
	                    <div>
	                        <div>${app.appTitle}</div>
	                        <div class="list-sub">${app.appType}</div>
	                    </div>
	
	                    <c:choose>
	                        <c:when test="${app.appStatus == '승인'}">
	                            <span class="status ok">승인</span>
	                        </c:when>
	                        <c:when test="${app.appStatus == '반려'}">
	                            <span class="status reject">반려</span>
	                        </c:when>
	                        <c:when test="${app.appStatus == '결재중'}">
	                            <span class="status ing">결재중</span>
	                        </c:when>
	                        <c:otherwise>
	                            <span class="status wait">대기</span>
	                        </c:otherwise>
	                    </c:choose>
	                </div>
	            </c:forEach>
	            <c:if test="${empty myAppList}">
	                <div class="empty-text">결재 문서가 없습니다.</div>
	            </c:if>
	        </div>
        </div>

        <div class="dashboard-card dashboard-widget" data-widget-id="board">
            <div class="card-header">
                <div class="card-title">최근 게시글</div>
                <div class="card-actions">
			        <button type="button" class="widget-up">▲</button>
			        <button type="button" class="widget-down">▼</button>
			        <a href="/board/list" class="card-more">더보기 ></a>
			    </div>
            </div>
			<div class="card-body">
	            <c:forEach var="board" items="${boardList}">
	                <div class="list-row" onclick="location.href='/board/detail?boardNo=${board.boardNo}'" style="cursor:pointer;">
	                    <div>
	                        <div>${board.boardTitle}</div>
	                        <div class="list-sub">${board.boardType}</div>
	                    </div>
	                </div>
	            </c:forEach>
	            <c:if test="${empty boardList}">
	                <div class="empty-text">게시글이 없습니다.</div>
	            </c:if>
	        </div>
        </div>

        <div class="dashboard-card dashboard-widget quick-menu" data-widget-id="quick-menu">
            <div class="card-header">
			    <div class="card-title">빠른 메뉴</div>
			
			    <div class="card-actions">
			        <button type="button" class="widget-up">▲</button>
			        <button type="button" class="widget-down">▼</button>
			        <button type="button" class="quick-setting-btn">
			            <i class="fa-solid fa-gear"></i>
			        </button>
			    </div>
			</div>
			<div class="card-body">
				<div class="quick-setting-panel">
				    <div class="quick-setting-title">빠른 메뉴 설정</div>
				
				    <div class="quick-setting-list">
				        <label>
				            <input type="checkbox" class="quick-check" value="deptTree">
				            조직도
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="dept">
				            부서목록
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="emp">
				            직원목록
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="app">
				            전자결재
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="attn" checked>
				            근태기록
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="calendar" checked>
				            일정
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="board" checked>
				            게시판
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="pds" checked>
				            자료실
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="message" checked>
				            쪽지함
				        </label>
				        <c:if test="${sessionScope.loginRole == '관리자'}">
			        	<label>
				            <input type="checkbox" class="quick-check" value="admin-emp" checked>
				            직원관리
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="admin-dept" checked>
				            부서관리
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="admin-app" checked>
				            결재관리
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="admin-attn" checked>
				            근태관리
				        </label>
				        <label>
				            <input type="checkbox" class="quick-check" value="admin-attn" checked>
				           	쪽지관리
				        </label>
				        </c:if>
				    </div>
				</div>
			</div>

            <div class="quick-grid">
            	<a href="/dept/listTree" data-quick-id="deptTree">
			        <i class="fa-solid fa-sitemap"></i>
			        조직도
			    </a>
			    <a href="/dept/list" data-quick-id="dept">
			        <i class="fa-solid fa-building"></i>
			        부서목록
			    </a>
			    <a href="/emp/list" data-quick-id="emp">
			        <i class="fa-solid fa-users"></i>
			        직원목록
			    </a>
			    <a href="/app/list" data-quick-id="app">
			        <i class="fa-solid fa-file-signature"></i>
			        전자결재
			    </a>
			    <a href="/attn/list" data-quick-id="attn">
			        <i class="fa-solid fa-clock"></i>
			        근태기록
			    </a>
			    <a href="/event/calendar" data-quick-id="calendar">
		            <i class="fa-solid fa-calendar-day"></i>
		            일정
		        </a>
		        <a href="/board/list" data-quick-id="board">
			        <i class="fa-solid fa-clipboard-list"></i>
			        게시판
			    </a>
			    <a href="/pds/list" data-quick-id="pds">
			        <i class="fa-solid fa-folder-open"></i>
			        자료실
			    </a>
			    <a href="/message/receiveList" data-quick-id="message">
			        <i class="fa-solid fa-paper-plane"></i>
			        쪽지함
			    </a>
			    <c:if test="${sessionScope.loginRole == '관리자'}">
	        	<a href="/admin/list" data-quick-id="admin-emp">
			        <i class="fa-solid fa-users"></i>
			        직원관리
			    </a>
		        <a href="/dept/list" data-quick-id="admin-dept">
			        <i class="fa-solid fa-sitemap"></i>
			        부서관리
			    </a>
		        <a href="/attn/list" data-quick-id="admin-attn">
			        <i class="fa-solid fa-clock"></i>
			        근태관리
			    </a>
		        <a href="/admin/app/list" data-quick-id="admin-app">
			        <i class="fa-solid fa-file-shield"></i>
			        결재관리
			    </a>
			    <a href="/message/adminList" data-quick-id="admin-app">
			        <i class="fa-solid fa-envelope"></i>
			        쪽지관리
			    </a>
		        </c:if>
			</div>
        </div>

</div>
<script>
let homeCalendar = null;

// 💡 [클린 UI 제어] 불필요한 예외 처리 요소를 지우고, 오직 서버 상태로만 버튼을 켜고 끕니다.
// 💡 [클린 UI 제어] 서버 상태값에만 의존하지 않고, 실제 시간이 들어왔는지 체크하여 완벽하게 방어합니다.
function updateAttendanceUI(status, startTime, endTime) {
    const inTimeDisplay = document.getElementById("inTimeDisplay");
    const outTimeDisplay = document.getElementById("outTimeDisplay");
    const statusText = document.getElementById("attnStatusText");
    const checkInBtn = document.getElementById("mainCheckInBtn");
    const checkInBtnText = document.getElementById("mainCheckInBtnText");
    const checkOutBtn = document.getElementById("mainCheckOutBtn");
    const checkOutBtnText = document.getElementById("mainCheckOutBtnText");

    // 기본 스타일 및 활성화 상태 초기화 리셋
    if(checkInBtn) { checkInBtn.disabled = false; checkInBtn.style.opacity = "1"; checkInBtn.style.cursor = "pointer"; }
    if(checkOutBtn) { checkOutBtn.disabled = false; checkOutBtn.style.opacity = "1"; checkOutBtn.style.cursor = "pointer"; }

    // 1. 부재 상태 판별 (자정에 스케줄러가 입력했거나 관리자가 수정한 '휴가' / '결근' 처리)
    if (status === "휴가" || status === "결근") {
        if(inTimeDisplay) inTimeDisplay.innerText = "-";
        if(outTimeDisplay) outTimeDisplay.innerText = "-";
        if(statusText) statusText.innerText = "● " + status;
        
        if(checkInBtn) { checkInBtn.disabled = true; checkInBtn.style.opacity = "0.5"; checkInBtn.style.cursor = "not-allowed"; }
        if(checkInBtnText) checkInBtnText.innerText = "출근 불가";
        if(checkOutBtn) { checkOutBtn.disabled = true; checkOutBtn.style.opacity = "0.5"; checkOutBtn.style.cursor = "not-allowed"; }
        if(checkOutBtnText) checkOutBtnText.innerText = "퇴근 불가";
    }
    // 2. 퇴근 완료 상태 (퇴근 시간이 명확하게 찍혀 있는 경우)
    else if (endTime && endTime !== "-") {
        if(inTimeDisplay) inTimeDisplay.innerText = startTime;
        if(outTimeDisplay) outTimeDisplay.innerText = endTime;
        if(statusText) statusText.innerText = "● 퇴근 완료";
        
        if(checkInBtn) { checkInBtn.disabled = true; checkInBtn.style.opacity = "0.5"; checkInBtn.style.cursor = "not-allowed"; }
        if(checkInBtnText) checkInBtnText.innerText = "출근 완료";
        if(checkOutBtn) { checkOutBtn.disabled = true; checkOutBtn.style.opacity = "0.5"; checkOutBtn.style.cursor = "not-allowed"; }
        if(checkOutBtnText) checkOutBtnText.innerText = "퇴근 완료";
    } 
    // 3. 근무 중 상태 (출근 시간은 있고, 퇴근 시간은 아직 없는 상태)
    else if (startTime && startTime !== "-") {
        if(inTimeDisplay) inTimeDisplay.innerText = startTime;
        if(outTimeDisplay) outTimeDisplay.innerText = "-";
        
        // 💡 핵심: DB의 attn_record가 '지각'이면 화면에도 정직하게 '● 지각'으로 찍고, 
        // '정상근무' 상태로 출근해 있는 상태라면 근무 중임을 인지하도록 '● 근무중'으로 예쁘게 변환해 줍니다.
        let displayText = (status === "정상근무") ? "근무중" : status;
        if(statusText) statusText.innerText = "● " + displayText; 
        
        if(checkInBtn) { checkInBtn.disabled = true; checkInBtn.style.opacity = "0.5"; checkInBtn.style.cursor = "not-allowed"; }
        if(checkInBtnText) checkInBtnText.innerText = "출근 완료";
        if(checkOutBtn) { checkOutBtn.disabled = false; }
        if(checkOutBtnText) checkOutBtnText.innerText = "퇴근하기";
    }
    // 4. 출근 전 상태 (출퇴근 시간이 모두 없고 미확인 상태일 때)
    else { 
        if(inTimeDisplay) inTimeDisplay.innerText = "-";
        if(outTimeDisplay) outTimeDisplay.innerText = "-";
        if(statusText) statusText.innerText = "● 미출근";
        
        if(checkInBtn) { checkInBtn.disabled = false; }
        if(checkInBtnText) checkInBtnText.innerText = "출근하기";
        if(checkOutBtn) { checkOutBtn.disabled = true; checkOutBtn.style.opacity = "0.5"; checkOutBtn.style.cursor = "not-allowed"; }
        if(checkOutBtnText) checkOutBtnText.innerText = "퇴근하기";
    }
}

// 💡 화면 갱신 시 실시간 DB 데이터 매핑
function loadAttendanceStatus() {
    $.ajax({
        url: "${pageContext.request.contextPath}/attn/status",
        type: "GET",
        dataType: "json",
        success: function(res) {
            updateAttendanceUI(res.status, res.startTime, res.endTime);
        },
        error: function() {
            updateAttendanceUI("미출근", "-", "-");
        }
    });
}

// [출근 비동기 처리]
function ajaxCheckIn() {
    const now = new Date();
    const currentTimeStr = String(now.getHours()).padStart(2, '0') + ":" + String(now.getMinutes()).padStart(2, '0');
    
    $.ajax({
        url: "${pageContext.request.contextPath}/attn/checkIn",
        type: "POST",
        data: { inTime: currentTimeStr }, 
        success: function(res) {
            if(res === "success") {
                alert("출근 처리가 완료되었습니다!");
                loadAttendanceStatus(); // 화면 상태 즉시 재갱신
            } else if(res === "already") {
                alert("이미 오늘 출근 혹은 퇴근 처리가 완료되었습니다.");
                loadAttendanceStatus();
            } else {
                alert("출근 처리에 실패했습니다. (금일 근태 데이터 존재 여부 확인 필요)");
            }
        },
        error: function(err) { 
            alert("서버 통신 중 오류가 발생했습니다.");
            console.error(err); 
        }
    });
}

// [퇴근 비동기 처리]
function ajaxCheckOut() {
    if(!confirm("퇴근 처리하시겠습니까? 오늘 업무를 마감합니다.")) return;

    $.ajax({
        url: "${pageContext.request.contextPath}/attn/checkOut",
        type: "POST",
        success: function(res) {
            if(res === "success") {
                alert("퇴근 마감 처리가 완료되었습니다. 수고하셨습니다!");
                loadAttendanceStatus(); 
            } else {
                alert("퇴근 처리 실패 (출근 내역이 존재하는지 확인바랍니다.)");
            }
        },
        error: function(err) { 
            alert("서버 통신 중 오류가 발생했습니다.");
            console.error(err); 
        }
    });
}

// [기록 초기화]
function ajaxClearAttn() {
    if(!confirm("현재 사원의 오늘 근태 기록을 전체 삭제하시겠습니까?")) return;

    $.ajax({
        url: "${pageContext.request.contextPath}/attn/clearAttn",
        type: "POST",
        success: function(res) {
            if(res === "success") {
                alert("오늘 자 근태 기록이 초기화되었습니다.");
                loadAttendanceStatus();
            } else {
                alert("기록 초기화 처리에 실패했습니다.");
            }
        },
        error: function(err) { console.error(err); }
    });
}

// DOM 로드 후 실행 구역 (테마 및 위젯 기능은 그대로 유지)
$(function(){
    loadAttendanceStatus();

    try {
        if(document.getElementById('home-calendar')) {
            homeCalendar = new tui.Calendar('#home-calendar', {
                defaultView: 'month',
                useFormPopup: false,
                useDetailPopup: false,
                isReadOnly: true
            });
        }
    } catch(e) {
        console.warn("캘린더 인스턴스 초기화 지연", e);
    }
    
    var savedWidgetOrder = localStorage.getItem("gwWidgetOrder");
    if(savedWidgetOrder){
        var widgetIds = savedWidgetOrder.split(",");
        for(var i = 0; i < widgetIds.length; i++){
            var widget = $(".dashboard-widget[data-widget-id='" + widgetIds[i] + "']");
            $(".dashboard-grid").append(widget);
        }
    }

    function saveWidgetOrder(){
        var order = [];
        $(".dashboard-widget").each(function(){ order.push($(this).data("widget-id")); });
        localStorage.setItem("gwWidgetOrder", order.join(","));
    }

    $(".widget-up").click(function(){
        var card = $(this).closest(".dashboard-widget");
        var prev = card.prev(".dashboard-widget");
        if(prev.length > 0){ prev.before(card); saveWidgetOrder(); }
    });

    $(".widget-down").click(function(){
        var card = $(this).closest(".dashboard-widget");
        var next = card.next(".dashboard-widget");
        if(next.length > 0){ next.after(card); saveWidgetOrder(); }
    });
    
    $(".quick-setting-btn").click(function(){ $(".quick-setting-panel").toggle(); });

    function applyQuickMenu(){
        $(".quick-check").each(function(){
            var quickId = $(this).val();
            var checked = $(this).prop("checked");
            $(".quick-grid [data-quick-id='" + quickId + "']").toggle(checked);
        });
    }

    function saveQuickMenu(){
        var selected = [];
        $(".quick-check:checked").each(function(){ selected.push($(this).val()); });
        localStorage.setItem("gwQuickMenu", selected.join(","));
    }

    var savedQuickMenu = localStorage.getItem("gwQuickMenu");
    if(savedQuickMenu){
        var quickIds = savedQuickMenu.split(",");
        $(".quick-check").prop("checked", false);
        for(var i = 0; i < quickIds.length; i++){
            $(".quick-check[value='" + quickIds[i] + "']").prop("checked", true);
        }
    }

    applyQuickMenu();

    $(".quick-check").change(function(){
        if($(".quick-check:checked").length > 9){
            $(this).prop("checked", false);
            return;
        }
        applyQuickMenu();
        saveQuickMenu();
    });
});


    $.ajax({
        url : "/event/api/events",
        type : "get",
        dataType : "json",
        success : function(data){
        	console.log(data);
            const events = data.map(function(item){
                let color;

                if(item.eventCategory === "개인일정"){
                    color = "#16a34a";
                }
                else{
                    color = "#2563eb";
                }

                return {
                    id : item.eventNo,
                    title : item.eventTitle,
                    category : item.eventOption,
                    start : item.eventStart,
                    end : item.eventEnd,
                    backgroundColor : color,
                    borderColor : color,
                    color : "#ffffff"
                };
            });

            homeCalendar.createEvents(events);
        }
    });

</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>