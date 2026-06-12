<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
	.board-head {
	    display: inline-flex;
	    justify-content: center;
	    min-width: 58px;
	    padding: 5px 9px;
	    border-radius: 999px;
	    background: var(--main-light);
	    color: var(--main-color);
	    font-size: 12px;
	    font-weight: 900;
	}
</style>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

	<div class="pds-width">
		<div class="gw-page-head">
        	<div class="gw-breadcrumb">홈 / 게시판 / 내가 쓴 댓글</div>
        	<h1>내가 쓴 댓글</h1>
        	<p>내가 쓴 댓글을 한 곳에서 보고 관리할 수 있습니다.</p>
    	</div>
    	
    	<div class="gw-tab-panel">
			<ul class="gw-tabs">
			    <li class="gw-tab ${type == 'my' ? 'active' : ''}"><a href="./my">내가 쓴 글</a></li>
			    <li class="gw-tab ${type == 'myReply' ? 'active' : ''}"><a href="./myReply">내가 쓴 댓글</a></li>
			</ul>
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
		   				<th style="width:70%;">댓글 내용</th>
	                    <th style="width:15%;">작성일</th>
	                    <th style="width:15%;">댓글 원글</th>
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
							<a href="./detail?boardNo=${replyDto.replyOrigin}" class="gw-table-link">
								<span class="board-head">보기</span>
							</a>
						</td>
					</tr>
					</c:forEach>
					
					<c:if test="${empty list}">
					    <tr>
					        <td colspan="3" class="gw-table-empty">
					            작성한 댓글이 없습니다.
					        </td>
					    </tr>
					</c:if>
	            </tbody>
	        </table>
	        
	        <div class="gw-pagination">
	        	<c:set var="pageUrl" value="./myReply"/>
	            <jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
	       </div>
	    </div>
	</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>