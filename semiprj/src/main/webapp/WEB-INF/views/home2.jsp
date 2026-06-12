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
            <a href="#" class="summary-link">결재하러 가기 ></a>
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
            <a href="#" class="summary-link">일정보기 ></a>
        </div>

        <div class="summary-card attendance-summary">
		
		    <div class="attendance-top">
		        <div class="attendance-title-wrap">
		            <div class="summary-icon">
		                <i class="fa-solid fa-business-time"></i>
		            </div>
		
		            <div class="summary-title">
		                근태 현황
		            </div>
		        </div>
		
		        <div id="attnStatusText" class="attendance-status working">
		            ● 미출근
		        </div>
		    </div>
		
		    <div class="attendance-time">
		        <div>출근 <strong id="inTimeDisplay">-</strong></div>
		        <div>퇴근 <strong>-</strong></div>
		    </div>
		
            <div style="display: flex; gap: 8px;">
                <button type="button" id="mainCheckInBtn" class="gw-btn-primary" onclick="ajaxCheckIn()"
                    style="padding: 10px 20px; border-radius: 8px; font-size: 14px; cursor: pointer; flex: 1;">
                    <span class="toggle-light"></span>
                    <span id="mainCheckInBtnText">출근하기</span>
                </button>
                <button type="button" class="gw-btn-secondary" onclick="ajaxClearAttn()"
                    style="padding: 10px 15px; border-radius: 8px; font-size: 14px; cursor: pointer; background-color: #ef4444; color: white; border: none;">
                    기록 삭제
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
				        <a href="#" class="card-more">일정 전체보기 ></a>
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
                	<a href="#" class="card-more">></a>
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
			        <i class="fa-solid fa-envelope"></i>
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
		        </c:if>
			</div>
        </div>

</div>
<script>
function ajaxCheckIn() {
    let userKey = "${sessionScope.loginNo}";
    if(!userKey || userKey.trim() === "") {
        userKey = "TEMP_USER"; 
    }

    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const currentTimeStr = hours + ":" + minutes;
    const todayStr = now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, '0') + "-" + String(now.getDate()).padStart(2, '0');
    
    localStorage.setItem("gw_date_" + userKey, todayStr);
    localStorage.setItem("gw_time_" + userKey, currentTimeStr);

    document.getElementById("inTimeDisplay").innerText = currentTimeStr;
    document.getElementById("attnStatusText").innerText = "● 정상근무";
    document.getElementById("mainCheckInBtn").disabled = true;
    document.getElementById("mainCheckInBtnText").innerText = "출근 완료";

    $.ajax({
        url: "${pageContext.request.contextPath}/attn/checkIn",
        type: "POST",
        success: function(res) {
            if(res === "success") {
                location.reload(); 
            } else {
                console.error("서버 DB 출근 처리 실패 반환");
            }
        },
        error: function(err) {
            console.error("근태 서버 통신 연결 실패", err);
        }
    });
}

function ajaxClearAttn() {
    if(!confirm("현재 사원의 모든 출근 기록을 초기화하시겠습니까?")) return;

    let userKey = "${sessionScope.loginNo}";
    if(!userKey || userKey.trim() === "") userKey = "TEMP_USER";

    $.ajax({
        url: "${pageContext.request.contextPath}/attn/clearAttn",
        type: "POST",
        success: function(res) {
            if(res === "success") {
                localStorage.removeItem("gw_date_" + userKey);
                localStorage.removeItem("gw_time_" + userKey);
                location.reload();
            } else {
                alert("기록 삭제 처리에 실패했습니다.");
            }
        },
        error: function(err) {
            console.error("근태 삭제 서버 통신 실패", err);
        }
    });
}

const homeCalendar = new tui.Calendar('#home-calendar', {
    defaultView: 'month',
    useFormPopup: false,
    useDetailPopup: false,
    isReadOnly: true
});

$(function(){
    let userKey = "${sessionScope.loginNo}";
    if(!userKey || userKey.trim() === "") {
        userKey = "TEMP_USER";
    }

    const now = new Date();
    const todayStr = now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, '0') + "-" + String(now.getDate()).padStart(2, '0');
    
    const savedDate = localStorage.getItem("gw_date_" + userKey);
    const savedTime = localStorage.getItem("gw_time_" + userKey);
    
    if(savedDate === todayStr && savedTime) {
        document.getElementById("inTimeDisplay").innerText = savedTime;
        document.getElementById("attnStatusText").innerText = "● 정상근무";
        document.getElementById("mainCheckInBtn").disabled = true;
        document.getElementById("mainCheckInBtnText").innerText = "출근 완료";
    } else {
        document.getElementById("inTimeDisplay").innerText = "-";
        document.getElementById("attnStatusText").innerText = "● 미출근";
        document.getElementById("mainCheckInBtn").disabled = false;
        document.getElementById("mainCheckInBtnText").innerText = "출근하기";
    }

	var savedTheme = localStorage.getItem("gwTheme");

	if(savedTheme){
	    $("body").addClass(savedTheme);
	}
	else{
	    $("body").addClass("theme-blue");
	}

	$(".theme-btn").click(function(){
	    $(".theme-popup").toggle();
	});

	$(".theme-item").click(function(){
	    var theme = $(this).data("theme");

	    $("body")
	        .removeClass("theme-blue theme-green theme-purple theme-dark")
	        .addClass(theme);

	    localStorage.setItem("gwTheme", theme);

	    $(".theme-popup").hide();
	});
	
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

	    $(".dashboard-widget").each(function(){
	        order.push($(this).data("widget-id"));
	    });

	    localStorage.setItem("gwWidgetOrder", order.join(","));
	}

	$(".widget-up").click(function(){
	    var card = $(this).closest(".dashboard-widget");
	    var prev = card.prev(".dashboard-widget");

	    if(prev.length > 0){
	        prev.before(card);
	        saveWidgetOrder();
	    }
	});

	$(".widget-down").click(function(){
	    var card = $(this).closest(".dashboard-widget");
	    var next = card.next(".dashboard-widget");

	    if(next.length > 0){
	        next.after(card);
	        saveWidgetOrder();
	    }
	});
	
	$(".quick-setting-btn").click(function(){
	    $(".quick-setting-panel").toggle();
	});

	function applyQuickMenu(){
	    $(".quick-check").each(function(){
	        var quickId = $(this).val();
	        var checked = $(this).prop("checked");

	        if(checked){
	            $(".quick-grid [data-quick-id='" + quickId + "']").show();
	        }
	        else{
	            $(".quick-grid [data-quick-id='" + quickId + "']").hide();
	        }
	    });
	}

	function saveQuickMenu(){
	    var selected = [];

	    $(".quick-check:checked").each(function(){
	        selected.push($(this).val());
	    });

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
	    var checkedCount = $(".quick-check:checked").length;
	
	    if(checkedCount > 9){
	        $(this).prop("checked", false);
	        return;
	    }
	
	    applyQuickMenu();
	    saveQuickMenu();
	});
	<%-- 작은 카드에서는 어차피 일정 제대로 안보여서 안찍도록 숨겼어요
    $.ajax({
        url : "/event/api/events",
        type : "get",
        dataType : "json",
        success : function(data){
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
    --%>
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>