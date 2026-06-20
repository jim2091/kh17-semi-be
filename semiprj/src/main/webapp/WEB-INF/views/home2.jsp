<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* =========================
   Home Calendar Custom
========================= */

#home-calendar {
    height: 500px !important;
}

/* 캘린더 기본 테두리 제거 */
#home-calendar .toastui-calendar-layout,
#home-calendar .toastui-calendar-month {
    border: none !important;
}

/* 날짜 셀 여백 */
#home-calendar .toastui-calendar-month-daygrid-cell {
    padding-top: 4px !important;
}

/* 제목은 display:none 하지 말고 글자만 숨김 */
#home-calendar .toastui-calendar-weekday-event-title {
    font-size: 0 !important;
    color: transparent !important;
    line-height: 0 !important;
}

/* 하루짜리 일정 컨테이너 */
#home-calendar .toastui-calendar-weekday-event {
    min-height: 25px !important;
    line-height: 25px !important;
    overflow: visible !important;
}

/* 여러 날 일정 외곽 */
#home-calendar .toastui-calendar-weekday-event-block {
    height: 15px !important;
    min-height: 15px !important;
    margin-top: 5px !important;
    margin-bottom: 4px !important;
    background: transparent !important;
    overflow: visible !important;
}

/* 여러 날 일정 막대 */
#home-calendar .toastui-calendar-weekday-event-block 
.toastui-calendar-weekday-event {
    height: 10px !important;
	min-height: 10px !important;
 	line-height: 10px !important;
    border-radius: 999px !important;
}

/* 막대 내부 요소까지 둥글게 */
#home-calendar .toastui-calendar-weekday-event-block 
.toastui-calendar-weekday-event > div {
    height: 8px !important;
    min-height: 8px !important;
    border-radius: 999px !important;
}

#home-calendar [class*="more-events"] {
	margin-top: 10px;
    font-size: 0 !important;
}

#home-calendar [class*="more-events"]::after {
    content: "+";
    font-size: 11px;
    color: var(--muted-text);
}
/* 하루짜리 일정 점 복구 */
#home-calendar .toastui-calendar-weekday-event-dot {
    display: inline-block !important;
    width: 8px !important;
    height: 8px !important;
    min-width: 6px !important;
    min-height: 6px !important;
    border-radius: 50% !important;
    margin: 0 !important;
    padding: 0 !important;
    opacity: 1 !important;
    visibility: visible !important;
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
		
            <!-- 💡 초기화 버튼 삭제 후 출/퇴근 버튼이 영역을 깔끔하게 채우도록 정렬 구성 최적화 -->
            <div style="display: flex; gap: 8px; width: 100%;">
                <!-- 출근 버튼 -->
                <button type="button" id="mainCheckInBtn" class="gw-btn-primary" onclick="ajaxCheckIn()"
                    style="padding: 12px; border-radius: 8px; font-size: 14px; font-weight: bold; cursor: pointer; flex: 1; border: none;">
                    <span id="mainCheckInBtnText">출근하기</span>
                </button>
                <!-- 퇴근 버튼 -->
                <button type="button" id="mainCheckOutBtn" class="gw-btn-primary" onclick="ajaxCheckOut()"
                    style="padding: 12px; border-radius: 8px; font-size: 14px; font-weight: bold; cursor: pointer; flex: 1; background-color: #3b82f6; border: none; color: white;">
                    <span id="mainCheckOutBtnText">퇴근하기</span>
                </button>
            </div>
	    </div>
    </div>

    <div class="dashboard-grid">
		<div class="movable-widget-area">
	        <div class="dashboard-card dashboard-widget normal-widget" data-widget-id="notice">
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
		                        <div style="font-size: 12px;">${board.boardTitle}</div>
		                        <div class="list-sub">${board.boardType}</div>
		                    </div>
		                </div>
		            </c:forEach>
		            <c:if test="${empty boardList}">
		                <div class="empty-text">공지가 없습니다.</div>
		            </c:if>
	           </div>
	        </div>
	
	        <div class="dashboard-card dashboard-widget normal-widget" data-widget-id="today-schedule">
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
		                        <div style="font-size: 12px;">${event.eventTitle}</div>
		                        <div class="list-sub">${event.eventCategory}</div>
		                    </div>
		                </div>
		            </c:forEach>
		            <c:if test="${empty todayEventList}">
		                <div class="empty-text">일정이 없습니다.</div>
		            </c:if>
		        </div>
	        </div>
	        
	        <div class="dashboard-card dashboard-widget normal-widget" data-widget-id="approval">
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
		                        <div style="font-size: 12px;">${app.appTitle}</div>
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
		                        <div style="font-size: 12px;">${board.boardTitle}</div>
		                        <div class="list-sub">${board.boardType}</div>
		                    </div>
		                </div>
		            </c:forEach>
		            <c:if test="${empty boardList}">
		                <div class="empty-text">게시글이 없습니다.</div>
		            </c:if>
		        </div>
	        </div>
		</div>
		<div class="fixed-widget-area">
	        <div class="dashboard-card dashboard-fixed calendar-card" data-widget-id="calendar">
	            <div class="card-header">
	                <div class="card-title">캘린더</div>
	                <div class="card-actions">
	                	<a href="/event/calendar" class="card-more">></a>
			    	</div>
	            </div>
	            <div class="card-body">
	            	<div id="home-calendar"></div>
	            </div>
	        </div>
			
	        <div class="dashboard-card dashboard-fixed quick-menu" data-widget-id="quick-menu">
	            <div class="card-header">
				    <div class="card-title">빠른 메뉴</div>
				    <div class="card-actions">
				        <button type="button" class="quick-setting-btn">
				            <i class="fa-solid fa-gear"></i>
				        </button>
				    </div>
				</div>
				<div class="card-body">
					<div class="quick-setting-panel">
					    <div class="quick-setting-title">빠른 메뉴 설정</div>
					    <div class="quick-setting-list">
					        <label><input type="checkbox" class="quick-check" value="deptTree">조직도</label>
					        <label><input type="checkbox" class="quick-check" value="dept">부서목록</label>
					        <label><input type="checkbox" class="quick-check" value="emp">직원목록</label>
					        <label><input type="checkbox" class="quick-check" value="app">전자결재</label>
					        <label><input type="checkbox" class="quick-check" value="attn" checked>근태기록</label>
					        <label><input type="checkbox" class="quick-check" value="calendar" checked>일정</label>
					        <label><input type="checkbox" class="quick-check" value="board" checked>게시판</label>
					        <label><input type="checkbox" class="quick-check" value="pds" checked>자료실</label>
					        <label><input type="checkbox" class="quick-check" value="message" checked>쪽지함</label>
					        <c:if test="${sessionScope.loginRole == '관리자'}">
				        	<label><input type="checkbox" class="quick-check" value="admin-emp" checked>직원관리</label>
					        <label><input type="checkbox" class="quick-check" value="admin-dept" checked>부서관리</label>
					        <label><input type="checkbox" class="quick-check" value="admin-app" checked>결재관리</label>
					        <label><input type="checkbox" class="quick-check" value="admin-attn" checked>근태관리</label>
					        <label><input type="checkbox" class="quick-check" value="admin-attn" checked>쪽지관리</label>
					        </c:if>
					    </div>
					</div>
				</div>
	
	            <div class="quick-grid">
	            	<a href="/dept/listTree" data-quick-id="deptTree"><i class="fa-solid fa-sitemap"></i>조직도</a>
				    <a href="/dept/list" data-quick-id="dept"><i class="fa-solid fa-building"></i>부서목록</a>
				    <a href="/emp/list" data-quick-id="emp"><i class="fa-solid fa-users"></i>직원목록</a>
				    <a href="/app/list" data-quick-id="app"><i class="fa-solid fa-file-signature"></i>전자결재</a>
				    <a href="/attn/list" data-quick-id="attn"><i class="fa-solid fa-clock"></i>근태기록</a>
				    <a href="/event/calendar" data-quick-id="calendar"><i class="fa-solid fa-calendar-day"></i>일정</a>
			        <a href="/board/list" data-quick-id="board"><i class="fa-solid fa-clipboard-list"></i>게시판</a>
				    <a href="/pds/list" data-quick-id="pds"><i class="fa-solid fa-folder-open"></i>자료실</a>
				    <a href="/message/receiveList" data-quick-id="message"><i class="fa-solid fa-paper-plane"></i>쪽지함</a>
				    <c:if test="${sessionScope.loginRole == '관리자'}">
		        	<a href="/admin/list" data-quick-id="admin-emp"><i class="fa-solid fa-users"></i>직원관리</a>
			        <a href="/dept/list" data-quick-id="admin-dept"><i class="fa-solid fa-sitemap"></i>부서관리</a>
			        <a href="/attn/list" data-quick-id="admin-attn"><i class="fa-solid fa-clock"></i>근태관리</a>
			        <a href="/admin/app/list" data-quick-id="admin-app"><i class="fa-solid fa-file-shield"></i>결재관리</a>
				    <a href="/message/adminList" data-quick-id="admin-app"><i class="fa-solid fa-envelope"></i>쪽지관리</a>
			        </c:if>
				</div>
	        </div>
		</div>
</div>

<script>
let homeCalendar = null;

function updateAttendanceUI(status, startTime, endTime) {
    const inTimeDisplay = document.getElementById("inTimeDisplay");
    const outTimeDisplay = document.getElementById("outTimeDisplay");
    const statusText = document.getElementById("attnStatusText");
    const checkInBtn = document.getElementById("mainCheckInBtn");
    const checkInBtnText = document.getElementById("mainCheckInBtnText");
    const checkOutBtn = document.getElementById("mainCheckOutBtn");
    const checkOutBtnText = document.getElementById("mainCheckOutBtnText");

    if(checkInBtn) { checkInBtn.disabled = false; checkInBtn.style.opacity = "1"; checkInBtn.style.cursor = "pointer"; }
    if(checkOutBtn) { checkOutBtn.disabled = false; checkOutBtn.style.opacity = "1"; checkOutBtn.style.cursor = "pointer"; }

    if (status === "휴가" || status === "결근") {
        if(inTimeDisplay) inTimeDisplay.innerText = "-";
        if(outTimeDisplay) outTimeDisplay.innerText = "-";
        if(statusText) statusText.innerText = "● " + status;
        
        if(checkInBtn) { checkInBtn.disabled = true; checkInBtn.style.opacity = "0.5"; checkInBtn.style.cursor = "not-allowed"; }
        if(checkInBtnText) checkInBtnText.innerText = "출근 불가";
        if(checkOutBtn) { checkOutBtn.disabled = true; checkOutBtn.style.opacity = "0.5"; checkOutBtn.style.cursor = "not-allowed"; }
        if(checkOutBtnText) checkOutBtnText.innerText = "퇴근 불가";
    }
    else if (endTime && endTime !== "-") {
        if(inTimeDisplay) inTimeDisplay.innerText = startTime;
        if(outTimeDisplay) outTimeDisplay.innerText = endTime;
        if(statusText) statusText.innerText = "● 퇴근 완료";
        
        if(checkInBtn) { checkInBtn.disabled = true; checkInBtn.style.opacity = "0.5"; checkInBtn.style.cursor = "not-allowed"; }
        if(checkInBtnText) checkInBtnText.innerText = "출근 완료";
        if(checkOutBtn) { checkOutBtn.disabled = true; checkOutBtn.style.opacity = "0.5"; checkOutBtn.style.cursor = "not-allowed"; }
        if(checkOutBtnText) checkOutBtnText.innerText = "퇴근 완료";
    } 
    else if (startTime && startTime !== "-") {
        if(inTimeDisplay) inTimeDisplay.innerText = startTime;
        if(outTimeDisplay) outTimeDisplay.innerText = "-";
        
        let displayText = (status === "정상근무") ? "근무중" : status;
        if(statusText) statusText.innerText = "● " + displayText; 
        
        if(checkInBtn) { checkInBtn.disabled = true; checkInBtn.style.opacity = "0.5"; checkInBtn.style.cursor = "not-allowed"; }
        if(checkInBtnText) checkInBtnText.innerText = "출근 완료";
        if(checkOutBtn) { checkOutBtn.disabled = false; }
        if(checkOutBtnText) checkOutBtnText.innerText = "퇴근하기";
    }
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
                loadAttendanceStatus();
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
            if(widget.length > 0){
                $(".movable-widget-area").append(widget);
            }
        }
    }

    function saveWidgetOrder(){
        var order = [];
        $(".movable-widget-area .dashboard-widget").each(function(){
            order.push($(this).data("widget-id"));
        });
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