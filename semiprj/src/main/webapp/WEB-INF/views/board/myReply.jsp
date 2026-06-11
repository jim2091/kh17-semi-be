<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_board.jsp"></jsp:include>

<style>
	.table{
	    width:100%;
	    table-layout:fixed;
	}
</style>

<div class="container w-900 mt-50 mb-50">
	<!-- 페이지 제목 -->
    <div class="cell center">
        <h1 class="mb-20">내가 쓴 댓글</h1>
    </div>
   
    <!-- 총 댓글 수 -->
	<div class="cell right">
        총 ${pageVO.count}개의 댓글
    </div>
    
    <!-- 댓글 목록 -->
    <div class="cell">
    	<table class="table">
    		<thead>
    			<tr>
                    <th style="width:75%;">댓글 내용</th>
                    <th style="width:15%;">작성일</th>
                    <th style="width:10%;">댓글 원글</th>
				</tr>
			</thead>
			<tbody align="center">
				<c:forEach var="replyDto" items="${list}" varStatus="stat">
				<tr>
					<!-- 댓글 내용 -->
					<td>${replyDto.replyContent}</td>
					<!-- 댓글 작성일 -->
					<td>${replyDto.replyWtimeString}</td>
					<!-- 댓글 원글 -->
					<td>
						<a href="./detail?boardNo=${replyDto.replyOrigin}"><i class="fa-solid fa-arrow-up-right-from-square"></i></a>
					</td>
				</tr>
				</c:forEach>
            </tbody>
        </table>
    </div>

	<!-- 페이지네이션 -->
    <div class="cell mt-50">
    	<c:set var="pageUrl" value="./myReply"/>
		<jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>