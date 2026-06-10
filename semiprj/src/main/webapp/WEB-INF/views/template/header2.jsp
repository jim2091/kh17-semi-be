<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>KH 그룹웨어</title>

<link rel="icon" href="/images/kh.jpg" type="image/jpeg">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
<link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css">

<link rel="stylesheet" href="/css/home_blue.css" type="text/css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.min.js"></script>
<script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>

<script>
$(function(){
    $("[name=managerToggle]").change(function(){
        $.post("/menu/toggle", {
            managerToggle : $(this).is(":checked")
        }, function(){
            location.reload();
        });
    });
});
</script>
</head>

<body>

<div class="gw-layout">
	<jsp:include page="/WEB-INF/views/template/side_home2.jsp"></jsp:include>
	<div class="gw-main">
	
	    <div class="gw-header">
	        <div class="gw-search">
	            <i class="fa-solid fa-magnifying-glass"></i>
	            <input type="text" placeholder="통합검색">
	        </div>
			
	        <div class="gw-header-right">
	        
				<div class="theme-area">
				    <div class="theme-btn">
				        <i class="fa-solid fa-palette"></i>
				    </div>
				
				    <div class="theme-popup">
				        <div class="theme-popup-title">테마 설정</div>
				
				        <div class="theme-item" data-theme="theme-blue">
				            🔵 모던 블루
				        </div>
				
				        <div class="theme-item" data-theme="theme-green">
				            🟢 에메랄드
				        </div>
				
				        <div class="theme-item" data-theme="theme-purple">
				            🟣 퍼플
				        </div>
				
				        <div class="theme-item" data-theme="theme-dark">
				            ⚫ 다크
				        </div>
				    </div>
				</div>
	        
	            <a href="/message/receiveList" class="gw-icon-btn">
	                <i class="fa-solid fa-paper-plane"></i>
	            </a>
	
	            <a href="/notification/list" class="gw-icon-btn">
	                <i class="fa-solid fa-bell"></i>
	                <c:if test="${unreadCount > 0}">
	                    <span class="gw-badge">${unreadCount}</span>
	                </c:if>
	            </a>
	
	            <a href="/emp/logout">
	            	<span class="gw-login-out">로그아웃</span>
	            </a>
	
	            <a href="/emp/mypage" class="gw-user">
	                <img src="/emp/profile?empNo=${sessionScope.loginNo}">
	                <span>${loginUser.empName} ${loginUser.empPosition}</span>
	                <i class="fa-solid fa-angle-down"></i>
	            </a>
	        </div>
	    </div>