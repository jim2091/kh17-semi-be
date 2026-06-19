<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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
	.title-ellipsis{
	    overflow:hidden;
	    text-overflow:ellipsis;
	    white-space:nowrap;
	    min-width:0;
	}
</style>
	
	<div class="pds-width">
		<div class="gw-page-head">
        	<div class="gw-breadcrumb">홈 / 게시판 / 내가 쓴 글</div>
        	<h1>내가 쓴 글</h1>
        	<p>내가 쓴 게시글을 한 곳에서 보고 관리할 수 있습니다.</p>
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
			        <div class="gw-table-title">내가 쓴 글</div>
			        <div class="gw-table-sub">
			            ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
			        </div>
			    </div>
			    <div class="gw-table-actions">
				    <a href="./list" class="gw-btn-outline">
		                <i class="fa-solid fa-list"></i>
		                <span>게시판</span>
		            </a>
				</div>
		    </div>

	
		<table class="gw-table pds-table">
	   		<thead>
	   			<tr>
	   				<th style="width:10%;">종류</th>
	   				<th style="width:10%;">유형</th>
	                <th style="width:35%;">제목</th>
	                <th style="width:10%;">조회수</th>
	                <th style="width:10%;">댓글수</th>
	                <th style="width:10%;">추천수</th>
	                <th style="width:15%;">작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="boardDto" items="${list}" varStatus="stat">
				<tr>
					<!-- 게시글 종류 -->
					<td>
						<span class="board-head">
							${boardDto.boardHead}
						</span>
					</td>
					<!-- 게시글 유형 -->
					<td>${boardDto.boardType}</td>
					<!-- 게시글 제목 -->
					<td class="title-ellipsis">
						<a href="./detail?boardNo=${boardDto.boardNo}&page=${pageVO.page}&${pageVO.searchParams}" class="gw-table-link">${boardDto.boardTitle}</a>
					</td>
					<!-- 게시글 조회수 -->
					<td>${boardDto.boardReadcount}</td>
					<!-- 게시글 댓글수 -->
					<td>${boardDto.boardReplycount}</td>
					<!-- 게시글 추천수 -->
					<td>${boardDto.boardLikecount}</td>
					<!-- 게시글 작성일 -->
					<td>${boardDto.getBoardWtimeString()}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty list}">
					<tr>
						<td colspan="5"
							style="padding: 40px; text-align: center; color: #aaa;">
							조회된 자료가 없습니다.
						</td>
					</tr>
				</c:if>
			</tbody>
	       </table>
       
	       <div class="gw-pagination">
	       		<c:set var="pageUrl" value="./my"/>
	            <jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
	       </div>
	    </div>
	</div>


<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>
