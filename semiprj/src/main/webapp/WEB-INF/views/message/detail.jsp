<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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

	<div class="gw-detail-panel pds-width">
        <div class="gw-page-head">
		    <div class="gw-breadcrumb">홈 / 쪽지 / 상세보기</div>
		    <h1>${messageDto.messageTitle}</h1>
		</div>
		
		<div class="gw-form-panel">
			<div>
		        <div class="gw-detail-author">
		            <i class="fa-regular fa-user"></i>
					<c:if test="${messageDto.messageSender == null}">
						<span class="gw-muted">(퇴사한 사용자)</span>
					</c:if>
					<c:if test="${messageDto.messageSender != null}">
						<span>보낸 사람</span>
						<a href="/emp/detail?empNo=${messageDto.messageSender}" class="gw-table-link">
							${messageDto.senderName}
						</a>
					</c:if>
				</div>
			</div>
			<div class="gw-detail-info mt-10">
				<div class="gw-detail-author">
					<i class="fa-regular fa-user"></i>
					<c:if test="${messageDto.messageReceiver == null}">
						<span class="gw-muted">(퇴사한 사용자)</span>
					</c:if>
					<c:if test="${messageDto.messageReceiver != null}">
						<span>받는 사람</span>
						<a href="/emp/detail?empNo=${messageDto.messageReceiver}" class="gw-table-link">
							${messageDto.receiverName}
						</a>
					</c:if>
				</div>
			</div>
			
			<div class="gw-detail-info">
				<div class="gw-detail-meta">
					<span>
						<i class="fa-regular fa-calendar"></i>
						보낸 시간&nbsp;:&nbsp;
						<fmt:formatDate value="${messageDto.messageWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate>
					</span>
				</div>
				
				<!-- 답장하기 버튼 -->
				<c:if test="${type == 'receive'}">
				    <a href="./writeReply?messageNo=${messageDto.messageNo}" class="gw-btn-primary reply-btn">
				        <i class="fa-solid fa-arrow-rotate-right"></i>답장하기
				    </a>
				</c:if>
				<!-- 삭제하기 버튼(관리자용) -->
				<c:if test="${type == 'admin'}">
				    <a href="./delete?messageNo=${messageDto.messageNo}" class="gw-btn-danger btn-content-delete reply-btn">
				        삭제하기 <i class="fa-regular fa-trash-can"></i>
				    </a>
				</c:if>
			</div>
		
			<div class="gw-form-row">
		        <label class="gw-form-label">내용</label>
		        <div class="gw-content-box">
		            <pre>${messageDto.messageContent}</pre>
		        </div>
		    </div>
		    
		    <div class="cell">
			<div class="message-nav">
				<div>
					<c:if test="${prevMessageDto != null}">
					<a href="./detail?messageNo=${prevMessageDto.messageNo}&type=${type}" class="gw-table-link">
						<i class="fa-solid fa-circle-arrow-left"></i> 이전 쪽지
					</a>
					</c:if>
				</div>
				<div>
					<c:choose>
					    <c:when test="${type == 'receive'}">
					        <a href="./receiveList" class="gw-btn-outline"><i class="fa-solid fa-list"></i>목록으로</a>
					    </c:when>
					
					    <c:when test="${type == 'send'}">
					        <a href="./sendList" class="gw-btn-outline"><i class="fa-solid fa-list"></i>목록으로</a>
					    </c:when>
					
					    <c:when test="${type == 'admin'}">
					        <a href="./adminList" class="gw-btn-outline"><i class="fa-solid fa-list"></i>목록으로</a>
					    </c:when>
					</c:choose>

				</div>
				<div>
					<c:if test="${nextMessageDto != null}">
					<a href="./detail?messageNo=${nextMessageDto.messageNo}&type=${type}" class="gw-table-link">
						다음 쪽지 <i class="fa-solid fa-circle-arrow-right"></i>
					</a>	
					</c:if>
				</div>
			</div>
			</div>

	</div>
</div>
<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>