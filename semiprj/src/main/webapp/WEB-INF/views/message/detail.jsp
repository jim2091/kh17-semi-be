<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_message.jsp"></jsp:include>

<style>
	.message-nav {
	    display: flex;
	    align-items: center;
	}
	.message-nav > div {
		flex: 1;
	}
	
	.message-nav > div:nth-child(1) {
		text-align: left;
	}
	
	.message-nav > div:nth-child(2) {
		text-align: center;
	}
	
	.message-nav > div:nth-child(3) {
		text-align: right;
	}
	
	.reply-btn {
		margin-left: auto;
	}
</style>

<div class="container w-800 mt-50 mb-50">
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<!-- 쪽지 제목 -->
			<h1 class="mt-0 mb-0">${messageDto.messageTitle}</h1>
		</div>
	</div>
		<div class="cell">
			<div class="flex-area">
				<!-- 보낸이 -->
				<c:if test="${messageDto.messageSender == null}">
					(퇴사한 사용자)
				</c:if>
				<c:if test="${messageDto.messageSender != null}">
					<span>보낸 사람&nbsp;:&nbsp;</span>
					<a href="/emp/detail?empNo=${messageDto.messageSender}" class="link">
						${messageDto.senderName}
					</a>
				</c:if>
			</div>
			<div class="flex-area">
				<!-- 받는이 -->
				<c:if test="${messageDto.messageReceiver == null}">
					(퇴사한 사용자)
				</c:if>
				<c:if test="${messageDto.messageReceiver != null}">
					<span>받는 사람&nbsp;:&nbsp;</span>
					<a href="/emp/detail?empNo=${messageDto.messageReceiver}" class="link">
						${messageDto.receiverName}
					</a>
				</c:if>
			</div>
			<div class="flex-area">
				<!-- 작성일 -->
				<span>보낸 시간&nbsp;:&nbsp;</span>
				<fmt:formatDate value="${messageDto.messageWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate>
				<!-- 답장하기 버튼 -->
				<c:if test="${type == 'receive'}">
				    <a href="./writeReply?messageNo=${messageDto.messageNo}" class="btn btn-positive reply-btn">
				        답장하기<i class="fa-solid fa-reply"></i>
				    </a>
				</c:if>
				<!-- 삭제하기 버튼(관리자용) -->
				<c:if test="${type == 'admin'}">
				    <a href="./delete?messageNo=${messageDto.messageNo}" class="btn btn-negative reply-btn">
				        삭제하기 <i class="fa-regular fa-trash-can"></i>
				    </a>
				</c:if>
				
			</div>
		</div>
	
		<hr>
	
		<!-- 쪽지 본문 -->
		<div class="cell" style="min-height:300px">
			<pre>${messageDto.messageContent}</pre>
		</div>
		
		<hr class="mt-20 mb-20">
	
		<!-- 이전 쪽지 / 다음 쪽지 -->
		<div class="cell">
			<div class="message-nav">
				<div>
					<c:if test="${prevMessageDto != null}">
					<a href="./detail?messageNo=${prevMessageDto.messageNo}&type=${type}" class="link">
						<i class="fa-solid fa-circle-arrow-left"></i> 이전 쪽지
					</a>
					</c:if>
				</div>
				<div>
					<c:choose>
					    <c:when test="${type == 'receive'}">
					        <a href="./receiveList" class="btn btn-neutral">목록으로</a>
					    </c:when>
					
					    <c:when test="${type == 'send'}">
					        <a href="./sendList" class="btn btn-neutral">목록으로</a>
					    </c:when>
					
					    <c:when test="${type == 'admin'}">
					        <a href="./adminList" class="btn btn-neutral">목록으로</a>
					    </c:when>
					</c:choose>

				</div>
				<div>
					<c:if test="${nextMessageDto != null}">
					<a href="./detail?messageNo=${nextMessageDto.messageNo}&type=${type}" class="link">
						다음 쪽지 <i class="fa-solid fa-circle-arrow-right"></i>
					</a>	
					</c:if>
				</div>
			</div>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>