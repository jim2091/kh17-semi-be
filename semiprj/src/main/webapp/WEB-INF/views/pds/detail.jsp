<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_board_pds.jsp"></jsp:include>

<style>
	.badge {
	padding:0.2em;
	border:1px solid gray;
	border-radius:0.2em;
	}
	.badge.blue { border-color: #0984e3 !important; }
	.badge.silver { border-color: #BDC3C7 !important; }
</style>

<!-- 게시글 삭제 시 한번 더 물어보는 확인창 -->
<script>
$(function(){
	$(".btn-content-delete").click(function(e){
		var choice = window.confirm("정말 삭제하시겠습니까?");
		if(choice == false) {
			e.preventDefault();
		}
	});
});
</script>

<div class="container w-800 mt-50 mb-50">
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<h1 class="mt-0 mb-0">
					<!-- 게시글 제목 -->
					${pdsDto.pdsTitle}
				</h1>
			</div>
			<div class="ms-40">
				<!-- 게시글 작성자 -->
				<c:if test="${pdsDto.pdsWriter == null}">
					(퇴사한 사용자)
				</c:if>
				<c:if test="${pdsDto.pdsWriter != null}">
					<!-- 링크 누르면 사원 상세 정보 페이지로 이동 -->
					<a href="#=${pdsDto.pdsWriter}" class="link">
						${pdsDto.empName}
					</a>
				</c:if>
			</div>
		</div>
	</div>
	
	<div class="cell mt-20 flex-area">
		<div><fmt:formatDate value="${pdsDto.pdsWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
		<div class="ms-20">조회수 ${pdsDto.pdsReadcount}</div>
	</div>
	
	<hr>
	
	<!-- 게시글 본문 -->
	<div class="cell" style="min-height:300px">
		<pre>${pdsDto.pdsContent}</pre>
	</div>
	
	<hr class="mt-20">
	
	<!-- 첨부파일 다운로드 -->
	<div class="cell mt-20">
		<h3>첨부파일</h3>
		<c:forEach var="attachDto" items="${attachList}">
			<a href="/download/modern?attachNo=${attachDto.attachNo}">
				${attachDto.attachName}<br>
			</a>
		</c:forEach>
		<hr>
	</div>
	<!-- 이전글/다음글 -->
	<div class="cell">
		<span class="badge blue me-10">이전글</span> 
		<a href="./detail?pdsNo=${prevPdsDto.pdsNo}" class="link">${prevPdsDto.pdsTitle}</a>	
	</div>
	<div class="cell">
		<span class="badge blue me-10">다음글</span>
		<a href="./detail?pdsNo=${nextPdsDto.pdsNo}" class="link">${nextPdsDto.pdsTitle}</a>	
	</div>
	
	<hr class="mb-20">
	
	<!-- 버튼 -->
	<div class="cell right">
		<a class="btn btn-negative" href="./edit?boardNo=${boardDto.boardNo}">수정하기</a>
		<a class="btn btn-negative" href="./delete?boardNo=${boardDto.boardNo}">삭제하기</a>
		
		<a class="btn btn-neutral" href="./list">목록으로</a>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>