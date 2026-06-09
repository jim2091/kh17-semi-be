<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* 자리 잡기 */
.notification-wrapper{
	position: relative;
	display: inline-block;
}
.notification-icon{
	cursor: pointer;
}

.notification-badge{
	position: absolute;
	top: -6px;
	right: -8px;
	
	width: 18px;
	height: 18px;
	border-radius: 50%;
	background: red;
	color: white;
	font-size: 11px;
	
	display: flex;
	justify-content: center;
	align-items: center;
}
.notification-dropdown{
	position: absolute;
	top: 39px;
	right: -15px;
	
	font-size: 14px;
	font-weight: normal;
	width: 320px;
	background: white;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
	
	display: none;
	z-index: 999;
}
/* 호버 */
.notification-wrapper2:hover .notification-dropdown{
	display: block;
}
/* 드롭다운 디자인 */
.notification-item{
	padding: 12px;
	boder-bottom: 1px solid #eee;
	cursor: pointer;
}
.notification-item:hover{
	background: #f5f5f5;	
}
.notification-more{
	padding: 12px;
	text-align: center;
	font-weight: bold;
	cursor: pointer;
}

</style>

<script>
	//알림 읽음 처리 후 페이지 이동하도록
	$(function() {
		$(".notification-url").on("click", function(e){
			e.preventDefault();
			
			var url = $(this).attr("href");
			var notificationNo = $(this).data("notification-no");
			$.ajax({
				url: "${pageContext.request.contextPath}/rest/notification/read",
	            type: "post",
	            data: {
	                notificationNo: notificationNo
	            },
	            success: function(){
	            	location.href = url;
	            }
			})
		});
	});
</script>

<!-- 비회원일 때 보여줄 메뉴 -->
<ul class="menu">
	<li>
	    <a href="/">
	        <span>홈</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <span>전자결재</span>
		</a>
        <!-- 하위 메뉴 -->
        <ul>
            <li>
                <a href="/app/list">
                    <span>내 문서함</span>
                </a>
            </li>
            <li>
                <a href="/appr/list">
                    <span>결재 문서함</span>
                </a>
            </li>
        </ul>
	</li>
	<li>
	    <a href="/board/list">
	        <span>게시판</span>
		</a>
        <ul>
            <li>
                <a href="/pds/list">
                    <span>자료실</span>
                </a>
            </li>
        </ul>
	</li>
	<li>
	    <a href="/emp/list">
	        <span>직원목록</span>
	    </a>
	</li>
	<li>
	    <a href="/dept/list">
	        <span>부서목록</span>
	    </a>
	    <ul>
	    	<li>
                <a href="/dept/listTree">
                    <span>부서조직도</span>
                </a>
                
            </li>
        </ul>
	</li>
	<li>
	    <a href="/attn/list">
	        <span>근태관리</span>
	    </a>
	</li>
	<li>
	    <a href="/event/calendar">
	        <span>일정</span>
	    </a>
	</li>

	<li class="divider"></li>
	
	<li style="width: 50px;">
	    <a href="#">
	        <i class="fa-solid fa-paper-plane"></i>
	    </a>
	</li>
	<li style="width: 50px;" class="notification-wrapper2">
		<div class="notification-wrapper">
			<a href="/notification/list">
				<i class="fa-solid fa-bell notification-icon"></i>
			</a>
			<c:if test="${unreadCount > 0}">
			<span class="notification-badge">${unreadCount}</span>
			</c:if>
			<div class="notification-dropdown">
				<c:forEach var="notification" items="${recentList}">
					<div class="notification-item">
						<a href="${notification.notificationUrl}" class="notification-url" data-notification-no="${notification.notificationNo}">
						${notification.notificationContent}</a>
					</div>
				</c:forEach>
				<div class="notification-more">
					<a href="/notification/list">전체 알림 보기</a>
				</div>
			</div>
			
		</div>
	</li>
	<c:if test="${sessionScope.attnYn == false}">
	<li>
	    <a href="#">
	        <span>출근</span>
	    </a>
	</li>
	</c:if>
	<c:if test="${sessionScope.attYn == true}">
	<li>
	    <a href="#">
	        <span>퇴근</span>
	    </a>
	</li>
	</c:if>

	<li>
	    <a href="/emp/logout">
	        <span>로그아웃</span>
	    </a>
	</li>

</ul>