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
	<link rel="stylesheet" href="/css/home_blue.css" type="text/css">
	
	<!-- jQuery CDN -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	
	<!-- toastui-calendar CDN -->
	<script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.min.js"></script>
	<script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>
	<link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css">
	
	<!-- lightpick CDN-->
	<script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/locale/ko.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css" rel="stylesheet">
	
	<!-- Summernote -->
	<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
	<!-- 한글 -->
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/lang/summernote-ko-KR.min.js"></script>
	
	
	<script>
		$(function(){
		    $("[name=managerToggle]").change(function(){
		        $.post("/menu/toggle", {
		            managerToggle : $(this).is(":checked")
		        }, function(){
		            location.reload();
		        });
		    });
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
		    $(".notification-btn").click(function(e){
		        e.stopPropagation();
		        $(".notification-area").toggleClass("open");
		    });

		    $(".notification-dropdown").click(function(e){
		        e.stopPropagation();
		    });

		    $(document).click(function(){
		        $(".notification-area").removeClass("open");
		    });
	
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
	
	            <div class="notification-area">
				
				    <button type="button" class="gw-icon-btn notification-btn">
				        <i class="fa-solid fa-bell"></i>
				
				        <c:if test="${unreadNotificationCount > 0}">
				            <span class="gw-badge">${unreadNotificationCount}</span>
				        </c:if>
				    </button>
				
				    <div class="notification-dropdown">
				        <div class="notification-dropdown-head">
				            <span>최근 알림</span>
				            <a href="/notification/list">전체보기</a>
				        </div>
				
				        <div class="notification-dropdown-body">
				            <c:forEach var="notification" items="${recentNotificationList}">
				                <div class="notification-item">
				                    <div class="notification-sub">
				                        <a href="${notification.notificationUrl}" class="notification-url" data-notification-no="${notification.notificationNo}">
				                        ${notification.notificationContent}</a>
				                    </div>
				                </div>
				            </c:forEach>
				
				            <c:if test="${empty recentNotificationList}">
				                <div class="notification-empty">
				                    최근 알림이 없습니다.
				                </div>
				            </c:if>
				        </div>
				    </div>
				
				</div>
				
				<c:if test="${sessionScope.loginId == null}">
					<a href="/emp/login">
		            	<span class="gw-login-out">로그인</span>
		            </a>
				</c:if>
				<c:if test="${sessionScope.loginId != null}">
					<a href="/emp/logout">
		            	<span class="gw-login-out">로그아웃</span>
		            </a>
				</c:if>
	            
	
	            <a href="/emp/mypage" class="gw-user">
	                <img src="/emp/profile?empNo=${sessionScope.loginNo}">
	                <span>${loginUser.empName} ${loginUser.empPosition}</span>
	                <i class="fa-solid fa-angle-down"></i>
	            </a>
	        </div>
	    </div>