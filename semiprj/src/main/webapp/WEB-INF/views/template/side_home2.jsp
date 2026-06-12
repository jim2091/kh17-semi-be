<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>
$(function(){

    $(".admin-menu").click(function(e){
        e.preventDefault();

        $(this).next(".admin-submenu").slideToggle(200);
    });
    
    $(".calendar-menu").click(function(e){
        e.preventDefault();

        $(this).next(".calendar-submenu").slideToggle(200);
    });
    
	$(".attn-container").hover(function() {
			// 마우스를 올렸을 때 (Stop을 주어 마우스를 마구 움직여도 애니메이션이 꼬이지 않게 함)
			$(this).find(".attn-submenu").stop(true, true).slideDown(200);
		}, function() {
			// 마우스가 벗어났을 때
			$(this).find(".attn-submenu").stop(true, true).slideUp(200);
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
		
		<a href="/dept/listTree">
            <i class="fa-solid fa-sitemap"></i>
            <span>조직도</span>
        </a>
        <a href="/dept/list">
            <i class="fa-solid fa-building"></i>
            <span>부서목록</span>
        </a>
        <a href="/emp/list">
            <i class="fa-solid fa-users"></i>
            <span>직원목록</span>
        </a>
        <a href="/app/list">
            <i class="fa-solid fa-file-signature"></i>
            <span>전자결재</span>
        </a>
        <div class="attn-container">
            <a href="/attn/list" class="attn-menu">
                <i class="fa-solid fa-business-time"></i>
                <span>근태관리</span>
            </a>
            <div class="attn-submenu" style="display:none; padding-left:25px;">
		        <a href="/attn/calculator"> <i class="fa-solid fa-calculator"></i>
		            <span>근태 계산기</span>
		        </a>
		    </div>
        </div>
        <a href="/event/calendar" class="calendar-menu">
            <i class="fa-solid fa-calendar-day"></i>
            <span>일정</span>
        </a>
        <div class="calendar-submenu" style="display:none; padding-left:25px;">
		        <a href="/event/calendar">
		            <i class="fa-solid fa-calendar-day"></i>
		            <span>캘린더</span>
		        </a>
		
		        <a href="/event/calendarList">
		            <i class="fa-solid fa-list"></i>
		            <span>일정 목록</span>
		        </a>
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
            <i class="fa-solid fa-envelope"></i>
            <span>쪽지함</span>
        </a>

		
		<c:if test="${sessionScope.loginRole == '관리자'}">
	        <div class="gw-menu-title">MANAGEMENT</div>
	        <a href="/admin/list" class="admin-menu">
	            <i class="fa-solid fa-users"></i>
	            <span>직원관리</span>
	        </a>
	        <div class="admin-submenu" style="display:none; padding-left:25px;">
		        <a href="/admin/list">
		            <i class="fa-solid fa-list"></i>
		            <span>전체 직원</span>
		        </a>
		
		        <a href="/admin/waitingList">
		            <i class="fa-solid fa-user-clock"></i>
		            <span>대기 직원 목록</span>
		        </a>
		    </div>
	        <a href="/dept/list">
	            <i class="fa-solid fa-sitemap"></i>
	            <span>부서관리</span>
	        </a>
	        
	        
	        <div class="attn-container">
            <a href="/attn/admin/list" class="attn-menu">
	            <i class="fa-solid fa-clock" ></i>
	            <span>근태기록</span>
	        </a>
            <div class="attn-submenu" style="display:none; padding-left:25px;">
		        <a href="/admin/attn/manage"> <i class="fa-solid fa-sliders"></i>
		            <span>근무제도</span>
		        </a>
		    </div>
        </div>
	        
	        <a href="/admin/app/list">
	           <i class="fa-solid fa-file-shield"></i>
	            <span>결재관리</span>
	        </a>
		</c:if>
		
    </div>
</div>