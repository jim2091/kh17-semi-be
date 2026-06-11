<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>
	
	<div class="pds-width">
		<div class="gw-page-head">
			<div class="gw-breadcrumb">홈 / 알림 / 목록</div>
			<h1>알림</h1>
			<p>3일이 지난 읽은 알림은 자동으로 삭제됩니다</p>
		</div>
		
		<form action="./deleteAll" method="post">
			<div class="gw-tab-panel">
				<ul class="gw-tabs">
					<li class="gw-tab ${type == 'all' ? 'active' : ''}"><a href="?type=all">전체 알림</a></li>
					<li class="gw-tab ${type == 'unread' ? 'active' : ''}"><a href="?type=unread">안읽은 알림</a></li>
				    <li class="gw-tab ${type == 'read' ? 'active' : ''}"><a href="?type=read">읽은 알림</a></li>
				    <li class="gw-tab ${type == 'board' ? 'active' : ''}"><a href="?type=board">게시판 알림</a></li>
				    <li class="gw-tab ${type == 'app' ? 'active' : ''}"><a href="?type=app">결재문서 알림</a></li>
				</ul>
			</div>
			<div class="gw-list-panel">
				<div class="gw-table-top">
					<div>
						<div class="gw-table-title">알림 목록</div>
						<div class="gw-table-sub">
							총 ${list.size()} 개의 알림이 있습니다
						</div>
					</div>
					
					<div class=qw-table-actions">
						<button type="submit" class="gw-btn-danger">
							<i class="fa-solid fa-trash-can"></i>
							<span>삭제하기</span>
						</button>
					</div>
				</div>
				<table class="gw-table notification-table">
					<thead>
						<tr>
							<th class="gw-check-col">
								<input type="checkbox" class="check-all">
							</th>
							<th class="w-150">종류</th>
							<th class="w-600">내용</th>
							<th>생성일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="notification" items="${list}">
							<tr class="${notification.notificationRead == 'Y' ? 'gw-read' : ''}">
								<td>
			                		<input type="checkbox" name="notificationNoList" value="${notification.notificationNo}">
		                		</td>
								<td>${notification.notificationType}</td>
								<td align="left">
									<a href="${notification.notificationUrl}" class="notification-url link" data-notification-no="${notification.notificationNo}">
									${notification.notificationContent}</a>
								</td>
								<td>${notification.getNotificationTimeToString()}</td>
							</tr>
						</c:forEach>
						
						<c:if test="${empty list}">
	                        <tr>
	                            <td colspan=5 class="gw-table-empty">
	                                알림이 없습니다
	                            </td>
	                        </tr>
	                    </c:if>
	                    
					</tbody>
				</table>
				<div class="gw-scroll-state">
					<span class="gw-scroll-loading" style="display:none;">알림을 불러오는중...</span>
					<div class="gw-scroll-end" style="display:none;">
					    <span></span>
					    <p>
					        <i class="fa-regular fa-circle-check"></i>
					        모든 알림을 확인했습니다
					    </p>
					    <span></span>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>

<script>
//체크박스 기능
$(function(){
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
    
    $(".check-all").change(function(){
        $("input[name=notificationNoList]").prop("checked", this.checked);
    });

    $("input[name=notificationNoList]").change(function(){
        $(".check-all").prop("checked",
            $("input[name=notificationNoList]").length == $("input[name=notificationNoList]:checked").length
        );
    });
    
    //알림 읽음 처리
    $(document).on("click", ".notification-url", function(e){
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
    	});
    });
    
    //무한스크롤
    var page = 1;
    var type = "${empty param.type ? 'all' : param.type}";
    var loading = false;
    var finished = false;
    var size = 10;
    
    $(window).scroll(function(){
    	if(loading || finished) return;
    	
    	var scrollTop = $(window).scrollTop();
    	var windowHeight = $(window).height();
    	var documentHeight = $(document).height();
    	
    	if (scrollTop + windowHeight >= documentHeight - 300){
    		loadMore();
    	}
    });
    
    function loadMore(){
    	loading = true;
    	page++;
    	
    	$(".gw-scroll-loading").show();
    	
    	$.ajax({
    		url: "${pageContext.request.contextPath}/rest/notification/listMore",
    		method: "get",
    		data: {
    			page: page,
    			type: type
    		},
    		success: function(list){
    			if(list.length == 0){
    				finished = true;
    				$(".gw-scroll-end").show();
    				return;
    			}
    			
    			for(var i = 0; i < list.length; i++){
    				if (list.length == 0){
    					finished = true;
    					$(".gw-scroll-end").show();
    					return;
    				}
    				
    				var item = list[i];
    				var readClass = item.notificationRead == "Y" ? "gw-read" : "";
    				
    				var html = "";
    				html += "<tr class='" + readClass + "'>";
    				html += "<td><input type='checkbox' name='notificationNoList' value='" + item.notificationNo + "'></td>";
    				html += "<td>" + item.notificationType + "</td>";
    				html += "<td align='left'>";
    				html += "<a href='" + item.notificationUrl + "' class='notification-url link' data-notification-no='" + item.notificationNo + "'>";
    				html += item.notificationContent;
    				html += "</a>";
    				html += "</td>";
    				html += "<td>" + item.notificationTimeToString + "</td>";
    				
    				$(".notification-table tbody").append(html);
    			}
    			
    			if (list.length < size){
    				finished = true;
    				$(".gw-scroll-end").show();
    			}
    		},
    		complete: function(){
    			loading = false;
                $(".gw-scroll-loading").hide();
    		}
    	});
    }
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>