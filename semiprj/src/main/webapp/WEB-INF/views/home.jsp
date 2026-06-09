<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>



<link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css">

<div class="flex-area flex-vertical ms-40 me-40" style="height: 600px">
	<div class="cell w-100 content-cell">공지 및 다양한 알림</div>
	<div class="cell flex-area">
		<div class="cell w-50 content-cell me-10"
			style="height: 300px; overflow-y: auto;">
			
			
			
			
			<!-- 전자결재 5개 -->
			<div
				style="font-weight: bold; font-size: 15px; padding: 10px; border-bottom: 1px solid #eee;">
				<i class="fa-solid fa-file-lines"></i> 전자결재
			</div>
			<table
				style="width: 100%; font-size: 13px; border-collapse: collapse;">
				<thead>
					<!-- 색 생각하기 -->
					<tr style="background: ;"> 
						<th style="padding: 8px; text-align: left;">문서명</th>
						<th style="padding: 8px; text-align: center;">종류</th>
						<th style="padding: 8px; text-align: center;">상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="app" items="${myAppList}">
						<tr style="border-bottom: 1px solid #f0f0f0; cursor: pointer;"
							onclick="location.href='/app/detail?appId=${app.appId}'">
							<td style="padding: 8px;">${app.appTitle}</td>
							<td style="padding: 8px; text-align: center;">${app.appType}</td>
							<td style="padding: 8px; text-align: center;"><c:choose>
									<c:when test="${app.appStatus == '승인'}">
										<span style="color: blue;">승인</span>
									</c:when>
									<c:when test="${app.appStatus == '반려'}">
										<span style="color: red;">반려</span>
									</c:when>
									<c:when test="${app.appStatus == '결재중'}">
										<span style="color: orange;">결재중</span>
									</c:when>
									<c:otherwise>
										<span style="color: green;">대기</span>
									</c:otherwise>
								</c:choose></td>
						</tr>
					</c:forEach>
					<c:if test="${empty myAppList}">
						<tr>
							<td colspan="3"
								style="text-align: center; padding: 20px; color: #888;">결재
								문서가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
		
		
		
		
		
		<div class="cell w-50 content-cell ms-10" style="height: 300px;">
			 <div id="home-calendar" style="height:250px;"></div>
		</div>
		

<script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.min.js"></script>
<script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>
<script>
$(function(){

    $.ajax({
        url : "/event/api/events",
        type : "get",
        dataType : "json",

        success : function(data){

            const events = data.map(function(item){

                let color;

                if(item.eventCategory === "개인일정"){
                    color = "#4CAF50";
                }
                else{
                    color = "#2196F3";
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

});
</script>	
		
		
		
		
	</div>
	<div class="cell w-100 content-cell flex-fill">사내일정</div>
	</div>
<script>
const homeCalendar = new tui.Calendar('#home-calendar', {
    defaultView: 'month',

    useFormPopup: false,
    useDetailPopup: false,

    isReadOnly: true
});
</script>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
