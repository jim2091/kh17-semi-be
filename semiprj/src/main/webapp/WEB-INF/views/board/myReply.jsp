<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

	<div class="gw-page-head pds-width">
        <div class="gw-breadcrumb">홈 / 게시판 / 내가 쓴 댓글</div>
        <h1>내가 쓴 댓글</h1>
        <p>내가 쓴 댓글을 한 곳에서 보고 관리할 수 있습니다.</p>
    </div>
    
    <div class="gw-list-panel pds-width">
		<div class="gw-table-top">
		    <div>
		        <div class="gw-table-title">내가 쓴 댓글</div>
		        <div class="gw-table-sub">
		            ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
		        </div>
		    </div>
	    </div>
	    
	    <table class="gw-table pds-table">
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
						<a href="./detail?boardNo=${replyDto.replyOrigin}" class="gw-table-link"><i class="fa-solid fa-arrow-up-right-from-square"></i></a>
					</td>
				</tr>
				</c:forEach>
            </tbody>
        </table>
        
        <div class="gw-pagination">
        	<c:set var="pageUrl" value="./myReply"/>
            <jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
       </div>
    </div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>