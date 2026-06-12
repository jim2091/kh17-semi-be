<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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

	<div class="gw-page-head pds-width">
        <div class="gw-breadcrumb">홈 / 쪽지 / 전체 쪽지함</div>
        <h1>전체 쪽지함</h1>
        <p>사원들이 보내고 받은 쪽지들을 한 곳에 모아 볼 수 있습니다.</p>
    </div>
    
    <div class="gw-search-panel pds-width">
		<form action="./adminList" method="get" class="gw-search-form">
			<select name="column" class="gw-form-select">
				<option value="message_title" ${param.column == 'message_title' ? 'selected':''}>제목</option>
				<option value="title_content" ${param.column == 'title_content' ? 'selected':''}>제목+내용</option>
				<option value="sender_name" ${param.column == 'sender_name' ? 'selected':''}>보낸이</option>
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
	
	<form action="./deleteAll" method="post">
        <div class="gw-list-panel pds-width">
        	<div class="gw-table-top">
                <div>
                    <div class="gw-table-title">전체 쪽지 목록</div>
                    <div class="gw-table-sub">
                        ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 쪽지
                    </div>
                </div>
                
                <div class="gw-table-actions">
                    <c:if test="${sessionScope.loginRole == '관리자'}">
                        <button type="submit" class="gw-btn-danger">
                            <i class="fa-regular fa-trash-can"></i>
                            <span>삭제하기</span>
                        </button>
                    </c:if>
                </div>
            </div>

	    	<table class="gw-table pds-table">
	    		<thead>
	    			<tr>
	    				<c:if test="${sessionScope.loginRole == '관리자'}">
	                		<th style="width:5%;">
	                			<input type="checkbox" class="check-all">
	                		</th>
	                	</c:if>
	    				<th style="width:15%;">보낸이</th>
	                    <th style="width:15%;">받는이</th>
	                    <th style="width:50%;">제목</th>
	                    <th style="width:15%;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="messageDto" items="${list}" varStatus="stat">
					<tr class="gw-check-col">
						<c:if test="${sessionScope.loginRole == '관리자'}">
	                		<td>
		                		<input type="checkbox" name="messageNoList" value="${messageDto.messageNo}">
	                		</td>
	                	</c:if>
	                	<!-- 보낸이 프로필 사진 + 이름 -->
						<td>
							<div class="flex center">
								<c:if test="${messageDto.messageSender == null}">
									<span class="gw-muted">(퇴사한 사용자)</span>
								</c:if>
								<c:if test="${messageDto.messageSender != null}">
									<img src="/emp/profile?empNo=${messageDto.messageSender}" class="profile-image">
									<a href="/emp/detail?empNo=${messageDto.messageSender}" class="gw-table-link">
										${messageDto.senderName}
									</a>
								</c:if>
							</div>
						</td>
						<!-- 받는이 프로필 사진 + 이름 -->
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
							<a href="./detail?messageNo=${messageDto.messageNo}&page=${pageVO.page}&${pageVO.searchParams}&type=admin" class="gw-table-link">${messageDto.messageTitle}</a>
						</td>
						<!-- 쪽지 작성일 -->
						<td>${messageDto.getMessageWtimeString()}</td>
					</tr>
					</c:forEach>
					
					<c:if test="${empty list}">
                        <tr>
                            <td colspan="${sessionScope.loginRole == '관리자' ? 6 : 5}" class="gw-table-empty">
                                조회된 내용이 없습니다.
                            </td>
                        </tr>
                    </c:if>
                    
	            </tbody>
	        </table>
	        
	        <div class="gw-pagination">
	        	<c:set var="pageUrl" value="./adminList"/>
                <jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
            </div>
	    </div>
	</form>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>