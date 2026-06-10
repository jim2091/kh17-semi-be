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
        <h1 class="mt-0 mb-0">사내 게시판</h1>
    </div>
    
    <!-- 경고문 -->
    <div class="cell center mt-10">
    	<i class="fa-solid fa-circle-exclamation fa-fade red"></i>
        <span>타인에 대한 무분별한 비방글은 예고 없이 삭제될 수 있습니다.</span>
    </div>
    
    <!-- 검색창 -->
    <div class="cell center">
	<form action="./list" method="get">
		<select name="column" class="field">
			<option value="board_title" ${param.column == 'board_title' ? 'selected':''}>제목</option>
			<option value="title_content" ${param.column == 'title_content' ? 'selected':''}>제목+내용</option>
			<option value="board_writer" ${param.column == 'board_writer' ? 'selected':''}>작성자</option>
		</select>
		<input type="text" name="keyword" class="field" placeholder="검색어" value="${param.keyword}">
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-magnifying-glass"></i>
			<span>검색</span>
		</button>
	</form>
	</div>
    
    <!-- 글쓰기 버튼 -->
    <div class="cell right">
		<c:if test="${sessionScope.loginId != null}">
			<a href="./write" class="btn btn-neutral">글쓰기<i class="fa-solid fa-pencil"></i></a>
		</c:if>
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
                    <th style="width:50%;">제목</th>
                    <th style="width:15%;">작성자</th>
                    <th style="width:10%;">조회수</th>
                    <th style="width:15%;">작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="boardDto" items="${list}" varStatus="stat">
				<tr>
				<tr bgcolor="${stat.index < noticeCount ? '#ffeaa7':''}">
					<!-- 게시글 종류 -->
					<td>${boardDto.boardHead}</td>
					<!-- 게시글 제목 -->
					<td align="left">
						<!-- 비밀글인 경우 -->
						<c:if test="${boardDto.boardType eq '비밀'}">
    						<i class="fa-solid fa-lock"></i>
						</c:if>
						<!-- 답변글인 경우 -->
						<c:if test="${boardDto.boardDepth > 0}">
							<c:forEach var="i" begin="1" end="${boardDto.boardDepth}" step="1">
								&nbsp;&nbsp;&nbsp;&nbsp;
							</c:forEach> 
							→
						</c:if>
						<a href="./detail?boardNo=${boardDto.boardNo}&page=${pageVO.page}&${pageVO.searchParams}" class="link">${boardDto.boardTitle}</a>
						<!-- 댓글 개수 -->
						<c:if test="${boardDto.boardReplycount > 0}">[${boardDto.boardReplycount}]</c:if>
					</td>
					<!-- 게시글 작성자 -->
					<td>
						<c:choose>
							<c:when test="${boardDto.boardWriter == null}">
								(퇴사한 사용자)
							</c:when>
						    <c:when test="${boardDto.boardType eq '익명'}">
						        익명
						    </c:when>
						    <c:otherwise>
						        <!-- 링크 누르면 사원 상세 정보 페이지로 이동 -->
								<a href="/emp/detail?empNo=${boardDto.boardWriter}" class="link">
									${boardDto.empName}
								</a>
						    </c:otherwise>
						</c:choose>
					</td>
					<!-- 게시글 조회수 -->
					<td>${boardDto.boardReadcount}</td>
					<!-- 게시글 작성일 -->
					<td>${boardDto.getBoardWtimeString()}</td>
				</tr>
				</c:forEach>
            </tbody>
        </table>
    </div>
    
	<!-- 페이지네이션 -->
    <div class="cell mt-50">
    	<c:set var="pageUrl" value="./list"/>
		<jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>