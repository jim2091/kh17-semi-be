<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_message.jsp"></jsp:include>

<style>
	.profile-image {
	    width: 40px;
	    height: 40px;
	    border-radius: 50%;
	    object-fit: cover;
	}
	.flex {
	    display:flex;
	    align-items:center;
	    gap:8px;
	    justify-content:center;
	}
</style>

<script>
$(function(){
    $(".check-all").change(function(){
        $("input[name=messageNoList]").prop("checked", this.checked);
    });

    $("input[name=messageNoList]").change(function(){
        $(".check-all").prop("checked",
            $("input[name=messageNoList]").length == $("input[name=messageNoList]:checked").length
        );
    });
});
</script>

<div class="container w-900 mt-50 mb-50">
	<!-- 페이지 제목 -->
    <div class="cell center">
        <h1 class="mt-0 mb-0">전체 쪽지함</h1>
    </div>
    
    <!-- 검색창 -->
    <div class="cell center">
	<form action="./adminList" method="get">
		<select name="column" class="field">
			<option value="message_title" ${param.column == 'message_title' ? 'selected':''}>제목</option>
			<option value="title_content" ${param.column == 'title_content' ? 'selected':''}>제목+내용</option>
			<option value="sender_name" ${param.column == 'sender_name' ? 'selected':''}>보낸이</option>
			<option value="receiver_name" ${param.column == 'receiver_name' ? 'selected':''}>받는이</option>
		</select>
		<input type="text" name="keyword" class="field" placeholder="검색어" value="${param.keyword}">
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-magnifying-glass"></i>
			<span>검색</span>
		</button>
	</form>
	</div>
	
	<!-- 삭제 버튼 -->
	<form action="./deleteAll" method="post">
	    <div class="cell right">
	     	<button type="submit" class="btn btn-negative">삭제하기 <i class="fa-regular fa-trash-can"></i></button>
	    </div>	
	
		<!-- 총 쪽지 수 -->
		<div class="cell right">
	        ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 쪽지
	    </div>
	
		<!-- 게시글 목록 -->
	    <div class="cell">
	    	<table class="table">
	    		<thead>
	    			<tr>
	    				<c:if test="${sessionScope.loginRole == '관리자'}">
	                		<th><input type="checkbox" class="check-all"></th>
	                	</c:if>
	    				<th>보낸이</th>
	                    <th>받는이</th>
	                    <th>제목</th>
	                    <th>작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="messageDto" items="${list}" varStatus="stat">
					<tr>
						<!-- 체크박스 -->
						<c:if test="${sessionScope.loginRole == '관리자'}">
	                		<td>
		                		<input type="checkbox" name="messageNoList" value="${messageDto.messageNo}">
	                		</td>
	                	</c:if>
	                	<!-- 보낸이 프로필 사진 + 이름 -->
						<td>
							<div class="flex center">
								<c:if test="${messageDto.messageSender == null}">
									(퇴사한 사용자)
								</c:if>
								<c:if test="${messageDto.messageSender != null}">
									<img src="/emp/profile?empNo=${messageDto.messageSender}" class="profile-image">
									<!-- 링크 누르면 사원 상세 정보 페이지로 이동 -->
									<a href="/emp/detail?empNo=${messageDto.messageSender}" class="link">
										${messageDto.senderName}
									</a>
								</c:if>
							</div>
						</td>
						<!-- 받는이 프로필 사진 + 이름 -->
						<td>
							<div class="flex center">
								<c:if test="${messageDto.messageReceiver == null}">
									(퇴사한 사용자)
								</c:if>
								<c:if test="${messageDto.messageReceiver != null}">
									<img src="/emp/profile?empNo=${messageDto.messageReceiver}" class="profile-image">
									<!-- 링크 누르면 사원 상세 정보 페이지로 이동 -->
									<a href="/emp/detail?empNo=${messageDto.messageReceiver}" class="link">
										${messageDto.receiverName}
									</a>
								</c:if>
							</div>
						</td>
						<!-- 쪽지 제목 -->
						<td>
							<a href="./detail?messageNo=${messageDto.messageNo}&page=${pageVO.page}&${pageVO.searchParams}&type=admin" class="link">${messageDto.messageTitle}</a>
						</td>
						<!-- 쪽지 작성일 -->
						<td>${messageDto.getMessageWtimeString()}</td>
					</tr>
					</c:forEach>
	            </tbody>
	        </table>
	    </div>
	</form>

	<!-- 페이지네이션 -->
    <div class="cell mt-50">
    	<c:set var="pageUrl" value="./adminList"/>
		<jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
    </div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>