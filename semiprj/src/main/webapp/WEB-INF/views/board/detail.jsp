<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
	.badge {
	padding:0.2em;
	border:1px solid gray;
	border-radius:0.2em;
	}
	.badge.blue { border-color: #0984e3 !important; }
	.badge.silver { border-color: #BDC3C7 !important; }
</style>

<!-- 좋아요 토글 자바스크립트 -->
<script type="text/javascript">
</script>

<div class="container w-800 mt-50 mb-50">
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<h1 class="mt-0 mb-0">
					<!-- 게시글 종류 -->
					<div class="cell">
						<span class="badge silver me-10">${boardDto.boardHead}</span> 
					</div>
					<!-- 게시글 제목 -->
					${boardDto.boardTitle}
				</h1>
			</div>
			<div class="ms-40">
				<!-- 게시글 작성자 -->
				<c:if test="${boardDto.boardWriter == null}">
					(퇴사한 사용자)
				</c:if>
				<c:if test="${boardDto.boardWriter != null}">
					<!-- 링크 누르면 사원 상세 정보 페이지로 이동 -->
					<a href="#=${boardDto.boardWriter}" class="link">
						${boardDto.boardWriter}
					</a>
				</c:if>
			</div>
		</div>
	</div>
	
	<div class="cell mt-20 flex-area">
		<div><fmt:formatDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
		<div class="ms-20">조회수 ${boardDto.boardReadcount}</div>
	</div>
	
	<hr>
	
	<!-- 게시글 본문 -->
	<div class="cell" style="min-height:300px">
		<pre>${boardDto.boardContent}</pre>
	</div>
	
	<!-- 좋아요/댓글 수 -->
	<div class="cell mt-20 flex-area">
		<div>
			<i class="fa-regular fa-comment"></i>
			댓글 ${boardDto.boardReplycount}
		</div>
		<div class="ms-20">
			<i class="fa-solid fa-heart red"></i>
			좋아요
			<span class="heart-count">?</span>
		</div>
	</div>
	
	<!-- 댓글 -->
	<div class="cell reply-area"></div>
	<!-- 로그인한 경우 -->
	<c:if test="${sessionScope.loginId != null}">
	<div class="cell">
		<textarea class="field w-100 field-reply" rows="4" placeholder="댓글 내용 작성"></textarea>
		<button type="button" class="btn btn-positive w-100 mt-10 btn-reply">
			<i class="fa-solid fa-pen"></i>
			<span>댓글 작성하기</span>
		</button>
	</div>
	</c:if>
	<!-- 비로그인인 경우 -->
	<c:if test="${sessionScope.loginId == null}">
	<div class="cell">
		<h3>댓글 작성을 원하시면 <a href="/member/login">로그인</a>하세요</h3>
	</div>
	</c:if>
	
	<hr class="mt-20">
	
	<!-- 이전글/다음글 -->
	<div class="cell">
		<span class="badge blue me-10">이전글</span> 
		<a href="./detail?boardNo=${prevBoardDto.boardNo}" class="link">${prevBoardDto.boardTitle}</a>	
	</div>
	<div class="cell">
		<span class="badge blue me-10">다음글</span>
		<a href="./detail?boardNo=${nextBoardDto.boardNo}" class="link">${nextBoardDto.boardTitle}</a>	
	</div>
	
	<hr class="mb-20">
	
	<!-- 버튼 -->
	<div class="cell right">
		<!-- 로그인 한 경우 보이는 버튼 -->
		<c:if test="${sessionScope.loginId != null}">
			<a class="btn btn-positive" href="./write">글쓰기</a>
			<a class="btn btn-positive" href="./write?boardParent=${boardDto.boardNo}">답글쓰기</a>
		</c:if>
		
		<!-- 작성자와 로그인 한 아이디가 같은 경우 보이는 버튼 -->
		<c:if test="${boardDto.boardWriter != null && boardDto.boardWriter == sessionScope.loginId}">
		<a class="btn btn-negative" href="./edit?boardNo=${boardDto.boardNo}">수정하기</a>
		<a class="btn btn-negative" href="./delete?boardNo=${boardDto.boardNo}">삭제하기</a>
		</c:if>
		
		<a class="btn btn-neutral" href="./list">목록으로</a>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>