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
        <h1 class="mb-20">내가 쓴 글</h1>
    </div>
    
    <!-- 총 게시글 수 -->
	<div class="cell right">
        ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
    </div>
    
    <!-- 게시글 목록 -->
    <div class="cell">
    	<table class="table">
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
			<tbody align="center">
				<c:forEach var="boardDto" items="${list}" varStatus="stat">
					<!-- 게시글 종류 -->
					<td>${boardDto.boardHead}</td>
					<!-- 게시글 유형 -->
					<td>${boardDto.boardType}</td>
					<!-- 게시글 제목 -->
					<td>
						<a href="./detail?boardNo=${boardDto.boardNo}&page=${pageVO.page}&${pageVO.searchParams}" class="link">${boardDto.boardTitle}</a>
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
            </tbody>
        </table>
    </div>
    
	<!-- 페이지네이션 -->
    <div class="cell mt-50">
    	<c:set var="pageUrl" value="./my"/>
		<jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
