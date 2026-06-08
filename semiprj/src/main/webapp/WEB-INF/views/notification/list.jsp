<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<style>
.filter-tab{
    list-style: none;
    padding: 0;
    margin: 0;
	
    display: flex;
}

.filter-tab li {
    width: 110px;
    font-size: 16px;
    padding: 0.5em;
    text-align: center;
}

.filter-tab > .divider {
	width : 0px;
    flex-grow: 1;
}
/* (8) 메뉴, 항목, 링크의 디자인 변경 */
.filter-tab {
    background-color: none;
}
.filter-tab a {
    color: inherit;
    background-color: inherit;
    text-decoration: none;
    display: block;
    width: 100%;
    height: 100%;
}
/* .menu a:hover  */
.filter-tab li:hover 
{
    background-color: #636e72;
}

.filter-tab .active a {
    font-weight: bold;
    border-bottom: 2px solid #333;
}

</style>


<script>
//체크박스 기능
$(function(){
    $(".check-all").change(function(){
        $("input[name=notificationNoList]").prop("checked", this.checked);
    });

    $("input[name=notificationNoList]").change(function(){
        $(".check-all").prop("checked",
            $("input[name=notificationNoList]").length == $("input[name=notificationNoList]:checked").length
        );
    });
});
</script>

<div class="container w-900 mt-50 mb-50">
	<!-- 페이지 제목 -->
    <div class="cell center">
        <h1 class="mt-0 mb-0">알림</h1>
    </div>
    
    
    <!-- 총 게시글 수 -->
	<div class="cell right">
        총 ${list.size()} 개의 알림이 있습니다
    </div>
    <div class="filter-area">
    	<ul class="filter-tab">
		    <li class="${type == 'all' ? 'active' : ''}"><a href="?type=all">전체 알림</a></li>
		    <li class="${type == 'unread' ? 'active' : ''}"><a href="?type=unread">안읽은 알림</a></li>
		    <li class="${type == 'read' ? 'active' : ''}"><a href="?type=read">읽은 알림</a></li>
		    <li class="${type == 'board' ? 'active' : ''}"><a href="?type=board">게시판 알림</a></li>
		    <li class="${type == 'app' ? 'active' : ''}"><a href="?type=app">결재문서 알림</a></li>
		</ul>
			
    </div>
    <form action="./deleteAll" method="post">
	    <!-- 알림 목록 -->
	    <div class="cell">
	    	<table class="table">
	    		<thead>
	    			<tr>
	               		<th>
	                		<input type="checkbox" class="check-all">
	               		</th>
	    				<th style="width: 200px">종류</th>
	                    <th style="width: 500px">내용</th>
	                    <th>생성일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="notification" items="${list}">
						<tr>
							<td>
		                		<input type="checkbox" name="notificationNoList" value="${notification.notificationNo}">
	                		</td>
							<!-- 알림 종류 -->
							<td>${notification.notificationType}</td>
							<!-- 알림 내용 -->
							<td align="left">
								<a href="${notification.notificationUrl}" class="notification-url link" data-notification-no="${notification.notificationNo}">
								${notification.notificationContent}</a>
							</td>
							<!-- 알림 생성일 -->
							<td>${notification.getNotificationTimeToString()}</td>
						</tr>
					</c:forEach>
	            </tbody>
	        </table>
	    </div>
	    <div class="cell right">
	    	<button type="submit" class="btn btn-negative">삭제하기<i class="fa-regular fa-trash-can"></i></button>
	    </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>