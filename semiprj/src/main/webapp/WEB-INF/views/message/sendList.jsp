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

<div class="container w-900 mt-50 mb-50">
	<!-- 페이지 제목 -->
    <div class="cell center">
        <h1 class="mt-0 mb-0">보낸 쪽지함</h1>
    </div>
    
    <!-- 검색창 -->
    <div class="cell center">
	<form action="./sendList" method="get">
		<select name="column" class="field">
			<option value="message_title" ${param.column == 'message_title' ? 'selected':''}>제목</option>
			<option value="title_content" ${param.column == 'title_content' ? 'selected':''}>제목+내용</option>
			<option value="receiver_name" ${param.column == 'receiver_name' ? 'selected':''}>받는이</option>
		</select>
		<input type="text" name="keyword" class="field" placeholder="검색어" value="${param.keyword}">
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-magnifying-glass"></i>
			<span>검색</span>
		</button>
	</form>
	</div>
	
	<!-- 보내기 버튼 -->
    <div class="cell right">
		<c:if test="${sessionScope.loginId != null}">
			<a href="./write" class="btn btn-neutral">보내기 <i class="fa-solid fa-paper-plane"></i></a>
		</c:if>
    </div>

	<!-- 총 쪽지 수 -->
	<div class="cell right">
        ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 쪽지
    </div>
    
    <!-- 쪽지 목록 -->
    <div class="cell">
    	<table class="table">
    		<thead>
    			<tr>
                    <th>받는이</th>
                    <th>제목</th>
                    <th>열람</th>
                    <th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="messageDto" items="${list}" varStatus="stat">
				<tr>
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
						<a href="./detail?messageNo=${messageDto.messageNo}&page=${pageVO.page}&${pageVO.searchParams}&type=send" class="link">${messageDto.messageTitle}</a>
					</td>
					<!-- 쪽지 열람 -->	
					<td>
						<c:if test="${messageDto.messageRead == 'Y'}">
							<i class="fa-regular fa-circle-check"></i>
						</c:if>
						<c:if test="${messageDto.messageRead == 'N'}">
						</c:if>
					</td>
					<!-- 쪽지 작성일 -->
					<td>${messageDto.getMessageWtimeString()}</td>
				</tr>
				</c:forEach>
            </tbody>
        </table>
    </div>
    
    <!-- 페이지네이션 -->
    <div class="cell mt-50">
    	<c:set var="pageUrl" value="./sendList"/>
		<jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
    </div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>