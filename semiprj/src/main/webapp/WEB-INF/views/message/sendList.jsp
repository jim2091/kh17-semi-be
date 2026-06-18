<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
	.profile-image {
	    width:36px;
    	height:36px;
	    border-radius: 50%;
	    object-fit: cover;
	}
	.flex {
	    display:flex;
	    align-items:center;
	    gap:8px;
	    justify-content:center;
	}
	.table{
	    width:100%;
	    table-layout:fixed;
	}
	.message-read{
    display:inline-block;
    padding:4px 10px;

    border:1px solid #cbd5e1;
    border-radius:999px;

    background:#f8fafc;
	color:#64748b;

    font-size:12px;
    font-weight:600;
}
	.message-unread{
    display:inline-block;
    padding:4px 10px;

    border:1px solid #93c5fd;
    border-radius:999px;

    background:#dbeafe;
	color:#2563eb;

    font-size:12px;
    font-weight:600;
}
</style>

	<div class="pds-width">
		<div class="gw-page-head">
        	<div class="gw-breadcrumb">홈 / 쪽지 / 보낸 쪽지함</div>
        	<h1>보낸 쪽지함</h1>
        	<p>보낸 쪽지들을 확인하실 수 있습니다.</p>
    	</div>
    
	    <div class="gw-tab-panel">
			<ul class="gw-tabs">
			    <li class="gw-tab ${type == 'receive' ? 'active' : ''}"><a href="./receiveList">받은 쪽지함</a></li>
			    <li class="gw-tab ${type == 'send' ? 'active' : ''}"><a href="./sendList">보낸 쪽지함</a></li>
			</ul>
		</div>
		
		<div class="gw-search-panel pds-width">
			<form action="./sendList" method="get" class="gw-search-form">
				<select name="column" class="gw-form-select">
					<option value="message_title" ${param.column == 'message_title' ? 'selected':''}>제목</option>
					<option value="title_content" ${param.column == 'title_content' ? 'selected':''}>제목+내용</option>
					<option value="receiver_name" ${param.column == 'receiver_name' ? 'selected':''}>받는이</option>
				</select>
				<input type="text" name="keyword" class="gw-form-input" 
					placeholder="검색어를 입력하세요." value="${param.keyword}">
				<button type="submit" class="gw-btn-primary">
					<i class="fa-solid fa-magnifying-glass"></i>
					<span>검색</span>
				</button>
			</form>
		</div>
		
		<div class="gw-list-panel">
			<div class="gw-table-top">
				<div>
					<div class="gw-table-title">보낸 쪽지</div>
					<div class="gw-table-sub">
						${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 쪽지
					</div>
				</div>
				<div class="gw-table-actions">
			        <c:if test="${sessionScope.loginId != null}">
			            <a href="./write" class="gw-btn-outline"> 
			                <span>보내기</span>
			                <i class="fa-solid fa-paper-plane"></i>
			            </a>
			        </c:if>
			    </div>
			</div>
			
			<table class="gw-table pds-table">
		   		<thead>
		   			<tr>
		   				<th style="width:20%;">받는이</th>
	                    <th style="width:50%;">제목</th>
	                    <th style="width:10%;">열람</th>
	                    <th style="width:20%;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="messageDto" items="${list}" varStatus="stat">
					<tr class="${messageDto.messageRead == 'N' ? 'unread-row' : ''}">
						<td>
							<div class="flex center">
								<c:if test="${messageDto.messageReceiver == null}">
									<span class="gw-muted">(퇴사한 사용자)</span>
								</c:if>
								<c:if test="${messageDto.messageReceiver != null}">
									<img src="/emp/profile?empNo=${messageDto.messageReceiver}" class="profile-image">
									<a href="/emp/detail?empNo=${messageDto.messageReceiver}" class="gw-table-link">
										${messageDto.receiverName}
									</a>
								</c:if>
							</div>
						</td>
						<!-- 쪽지 제목 -->
						<td>
							<a href="./detail?messageNo=${messageDto.messageNo}&page=${pageVO.page}&${pageVO.searchParams}&type=send" class="gw-table-link">${messageDto.messageTitle}</a>
						</td>
						<td>
							<c:if test="${messageDto.messageRead == 'Y'}">
								<span class="message-read">
						            읽음
						        </span>
							</c:if>
							<c:if test="${messageDto.messageRead == 'N'}">
								<span class="message-unread">
						            안읽음
						        </span>
							</c:if>
						</td>
						<!-- 쪽지 작성일 -->
						<td>${messageDto.getMessageWtimeString()}</td>
					</tr>
					</c:forEach>
					
					<c:if test="${empty list}">
                        <tr>
							<td colspan="4"
								style="padding: 40px; text-align: center; color: #aaa;">
								조회된 내용이 없습니다.
							</td>
						</tr>
                    </c:if>
	            </tbody>
	        </table>
        
	        <div class="gw-pagination">
	            <c:set var="pageUrl" value="./sendList"/>
				<jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
	       </div>
	    </div>
	</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>