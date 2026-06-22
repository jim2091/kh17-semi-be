<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
.submenu {
    display: none;
    padding-left: 25px;
}

.submenu a {
    font-size: 14px;
}

</style>

<script>
$(function(){

    $(".submenu-toggle").on("click", function(e){
        e.preventDefault();

        var group = $(this).closest(".has-submenu");
        var submenu = group.find(".submenu").first();

        submenu.stop(true, true).slideToggle(200);
        group.toggleClass("open");
    });

});
</script>

<div class="gw-sidebar">
    <div class="gw-logo">
        <img src="/images/kh.jpg">
        <span>KH 그룹웨어</span>
    </div>

    <div class="gw-menu">
        <a href="/" class="active">
            <i class="fa-solid fa-house"></i>
            <span>홈</span>
        </a>

        <div class="gw-menu-title">WORK</div>
		
		<div class="menu-group has-submenu">
			<a href="#" class="submenu-toggle">
				<i class="fa-solid fa-building"></i>
		        <span>부서목록</span>
			</a>
			
			<div class="submenu">
			    <a href="/dept/list">
		        	<i class="fa-solid fa-building"></i>
		        	<span>부서목록</span>
		        </a>
		        <a href="/dept/listTree">
			        <i class="fa-solid fa-sitemap"></i>
			        <span>조직도</span>
			    </a>
			</div>
		</div>
		
        <a href="/emp/list">
            <i class="fa-solid fa-users"></i>
            <span>사원목록</span>
        </a>
        
        <a href="/app/list">
            <i class="fa-solid fa-file-signature"></i>
            <span>전자결재</span>
        </a>
        
        <div class="menu-group has-submenu">
			<a href="#" class="submenu-toggle">
				<i class="fa-solid fa-business-time"></i>
		        <span>근태관리</span>
			</a>
			
			<div class="submenu">
				<a href="/attn/list">
			        <i class="fa-solid fa-business-time"></i>
			        <span>근태기록</span>
			    </a>
			    <a href="/attn/calculator">
		        	<i class="fa-solid fa-calculator"></i>
		        	<span>근태계산기</span>
		        </a>
			</div>
		</div>
        
        <div class="menu-group has-submenu">
		    <a href="#" class="submenu-toggle">
		        <i class="fa-solid fa-calendar-day"></i>
		        <span>일정</span>
		    </a>
		
		    <div class="submenu">
		        <a href="/event/calendar">
		            <i class="fa-solid fa-calendar-day"></i>
		            <span>캘린더</span>
		        </a>
		        <a href="/event/calendarList">
		            <i class="fa-solid fa-list"></i>
		            <span>일정 목록</span>
		        </a>
		    </div>
		</div>
        <a href="/board/list">
            <i class="fa-solid fa-clipboard-list"></i>
            <span>게시판</span>
        </a>
        <a href="/pds/list">
            <i class="fa-solid fa-folder-open"></i>
            <span>자료실</span>
        </a>
        <a href="/message/receiveList">
            <i class="fa-solid fa-paper-plane"></i>
            <span>쪽지함</span>
        </a>
		
		<c:if test="${sessionScope.isManager}">
			<div class="gw-menu-title">MY DEPT</div>
				<a href="/dept/manager">
	            <i class="fa-solid fa-gauge-high"></i>
	            <span>부서대시보드</span>
	        </a>
		</c:if>
		
		<c:if test="${sessionScope.loginRole == '관리자'}">
	        <div class="gw-menu-title">MANAGEMENT</div>
	        
	        <div class="menu-group has-submenu">
	        	<a href="/admin/dashboard">
				    <i class="fa-solid fa-gauge-high"></i>
				    <span>관리자 대시보드</span>
				</a>
	        	
				<a href="#" class="submenu-toggle">
					<i class="fa-solid fa-users"></i>
			        <span>사원관리</span>
				</a>
				
				<div class="submenu">
					<a href="/admin/list">
				        <i class="fa-solid fa-list"></i>
				        <span>전체 사원</span>
				    </a>
				    <a href="/admin/waitingList">
			        	<i class="fa-solid fa-user-clock"></i>
			        	<span>대기 사원 목록</span>
			        </a>

				</div>
			</div>
	        
	        <a href="/dept/list">
	            <i class="fa-solid fa-sitemap"></i>
	            <span>부서관리</span>
	        </a>
	        
	        <div class="menu-group has-submenu">
				<a href="#" class="submenu-toggle">
					<i class="fa-solid fa-clock"></i>
			        <span>근태관리</span>
				</a>
				
				<div class="submenu">
					<a href="/attn/admin/list">
				        <i class="fa-solid fa-clock"></i>
				        <span>근태기록</span>
				    </a>
				    <a href="${pageContext.request.contextPath}/attn/admin/manage">
			        	<i class="fa-solid fa-sliders"></i>
			        	<span>근무제도</span>
			        </a>
			        <a href="/admin/vacList">
			        	<i class="fa-solid fa-calendar-plus"></i>
			        	<span>연차 지급</span>
			        </a>
			        <a href="/admin/leaveList">
			        	<i class="fa-solid fa-calendar-plus"></i>
			        	<span>휴가 지급</span>
			        </a>
				</div>
			</div>
	        <a href="/message/adminList">
	           <i class="fa-solid fa-envelope"></i>
	           <span>쪽지관리</span>
	        </a>
		</c:if>
		
    </div>
</div>