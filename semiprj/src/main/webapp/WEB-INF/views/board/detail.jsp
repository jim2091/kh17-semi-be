<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
	.reply-viewer, .reply-editor {
		display:flex;
		padding:15px;
		box-shadow: 0 0 0 1px lightgray;
	}
	.reply-viewer > .profile-wrapper,
	.reply-editor > .profile-wrapper {
		width:100px;
	}
	.reply-viewer > .profile-wrapper > img,
	.reply-editor > .profile-wrapper > img {
		width:100%;
		aspect-ratio:1/1;
	}
	.reply-viewer > .content-wrapper,
	.reply-editor > .content-wrapper {
		flex-grow: 1;
	}
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

<!-- 좋아요 처리 관련 자바스크립트 -->
<c:if test="${sessionScope.loginId != null}">
<script type="text/javascript">
	$(function(){
		//(1) 좋아요 상태와 개수를 알아내기
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		$.ajax({
			url: "/rest/board/like-check",
			method: "post",
			data: { boardNo : boardNo },
			success: function(response){
				$(".fa-heart").removeClass("fa-regular fa-solid")
					.addClass(response.action ? "fa-solid" : "fa-regular");
				$(".fa-heart").next(".heart-count").text(response.count);
			}
		});
		//(2) 하트 클릭시 토글이 발생하도록 처리
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		$(".fa-heart").on("click", function(){
			$.ajax({
				url:"/rest/board/like-action",
				method:"post",
				data:{boardNo : boardNo},
				success:function(response){
					$(".fa-heart").removeClass("fa-regular fa-solid")
						.addClass(response.action ? "fa-solid" : "fa-regular");
					$(".fa-heart").next(".heart-count").text(response.count);
				}
			});
		});
	});
</script>
</c:if>

<!-- 댓글 시스템을 위한 자바스크립트 -->
<script type="text/javascript">
	$(function(){
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");

		loadList();
		
		function loadList() {
			$(".reply-area").empty();
			$.ajax({
				url: "/rest/reply/list",
				method: "post",
				data: {replyOrigin : boardNo},
				success: function(response) {
					for(var i=0; i < response.length; i++) {
						var template = $("#reply-viewer-template").text();
						var html = $.parseHTML(template);

						$(html).attr("data-key", response[i].replyNo);
						$(html).find(".image-profile")
							.attr("src", "/emp/profile?empNo="+response[i].replyWriter);
						$(html).find(".reply-writer").text(response[i].empName);
						$(html).find(".reply-content").text(response[i].replyContent);
					
						var wtime = moment(response[i].replyWtime).fromNow();
						$(html).find(".reply-wtime").text(wtime);
						
						//(1) owner가 false면 수정/삭제 버튼 영역을 지움
						if(response[i].owner == false) {
							$(html).find(".button-wrapper").remove();
						}
						//(2) writer가 false면 작성자라는 글자 영역을 지움
						if(response[i].writer == false) {
							$(html).find(".board-writer").remove();
						}
						
						$(".reply-area").append(html);
					}
				}
			});
		}
		
		//등록 버튼을 누르면 댓글 등록이 이루어지도록 처리
		$(".btn-reply").on("click", function(){
			var replyContent = $(".field-reply").val();
			if(replyContent.length == 0) return;
			$.ajax({
				url: "/rest/reply/write",
				method: "post",
				data: {
					replyContent : replyContent, 
					replyOrigin : boardNo
				},
				success: function(){
					$(".field-reply").val("");
					var count = Number($(".reply-count").text());
				    $(".reply-count").text(count + 1);
					loadList();
				}
			});
		});
		
		//삭제 버튼을 누르면 확인창을 띄우고 댓글 삭제가 이루어지도록 처리
		$(".reply-area").on("click", ".btn-reply-delete", function(){
			var choice = window.confirm("정말 삭제하시겠습니까?");
			if(choice == false) return;
			var replyNo = $(this).closest(".reply-viewer").data("key");
			$.ajax({
				url: "/rest/reply/delete",
				method: "post",
				data: { replyNo : replyNo },
				success: function(response){
					var count = Number($(".reply-count").text());
				    $(".reply-count").text(count - 1);
					loadList();
				}
			});
		});
		
		//수정 버튼을 누르면 수정창을 띄우고 댓글 수정이 이루어지도록 처리
		$(".reply-area").on("click", ".btn-reply-edit", function(){
			$(".reply-editor").prev(".reply-viewer").show();
			$(".reply-editor").remove();
			
			//기존 reply-viewer의 정보를 불러온다
			var replyViewer = $(this).closest(".reply-viewer");
			var key = replyViewer.data("key");
			var src = replyViewer.find(".image-profile").attr("src");
			var replyWriter = replyViewer.find(".reply-writer").text();
			var replyContent = replyViewer.find(".reply-content").text();
			var replyWtime = replyViewer.find(".reply-wtime").text();
			
			//현재 수정하려는 댓글 화면에 대한 처리
			var template = $("#reply-editor-template").text();//수정용 템플릿 본문 불러오기
			var html = $.parseHTML(template);//HTML로 변환해서
			//필요한 정보를 설정하고(프로필, 작성자, 내용, 작성시각, + 댓글번호)
			$(html).attr("data-key", key);
			$(html).find(".image-profile").attr("src", src);
			$(html).find(".reply-writer").text(replyWriter);
			$(html).find(".field-reply-edit").val(replyContent);
			$(html).find(".reply-wtime").text(replyWtime);
			
			$(this).closest(".reply-viewer").hide().after(html);
		});
		
		//수정 취소버튼을 누르면 수정창을 삭제하고 표시화면을 출력
		$(".reply-area").on("click", ".btn-reply-cancel", function(){
			$(this).closest(".reply-editor").prev(".reply-viewer").show();
			$(this).closest(".reply-editor").remove();
		});
		
		//수정 완료버튼을 누르면 ajax통신을 이용해 수정요청을 한 뒤 목록 갱신
		$(".reply-area").on("click", ".btn-reply-save", function(){
			var replyNo = $(this).closest(".reply-editor").data("key");
			var replyContent = $(this).closest(".reply-editor").find(".field-reply-edit").val();
			if(replyContent.length == 0) return;
			$.ajax({
				url : "/rest/reply/edit",
				method : "post",
				data : {
					replyNo : replyNo, 
					replyContent : replyContent
				},
				success : function(){
					loadList();
				}
			});
		});
	});
</script>

<script type="text/template" id="reply-viewer-template">
	<div class="reply-viewer">
		<div class="profile-wrapper">
			<img src="https://picsum.photos/500" class="image-circle image-profile">
		</div>
		<div class="content-wrapper ms-20">
			<h3 class="mt-0 mb-0">
				<span class="reply-writer">아이디</span>
				<span class="board-writer red">(작성자)</span>
			</h3>
			<pre class="mt-10 mb-0 reply-content">내용 샘플</pre>
			<div class="mt-20 flex-area">
				<div class="w-50">
					<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
				</div>
				<div class="button-wrapper right w-50">
					<i class="fa-solid fa-edit orange btn-reply-edit"></i>
					<i class="fa-solid fa-trash red btn-reply-delete"></i>
				</div>
			</div>
		</div>
	</div>
</script>
<script type="text/template" id="reply-editor-template">
	<div class="reply-editor">
		<div class="profile-wrapper">
			<img src="https://picsum.photos/500" class="image-circle image-profile">
		</div>
		<div class="content-wrapper ms-20">
			<h3 class="mb-10 mt-0 mb-0 reply-writer">작성자</h3>
			<textarea class="field w-100 field-reply-edit" rows="3">내용 샘플</textarea>
			<div class="mt-20 flex-area">
				<div class="w-50">
					<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
				</div>
				<div class="button-wrapper right w-50">
					<i class="fa-solid fa-xmark red btn-reply-cancel"></i>
					<i class="fa-solid fa-check blue btn-reply-save"></i>
				</div>
			</div>
		</div>
	</div>
</script>

<div class="container w-800 mt-50 mb-50">
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<h1 class="mt-0 mb-0">
					<!-- 게시글 종류, 제목 -->
					<div class="cell">
						<span class="badge silver me-10">${boardDto.boardHead}</span> ${boardDto.boardTitle}
					</div>
				</h1>
			</div>
			<div class="ms-40">
				<!-- 게시글 작성자 -->
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
			</div>
		</div>
	</div>
	
	<!-- 작성일/조회수 -->
	<div class="cell mt-20 flex-area">
		<div><fmt:formatDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
		<div class="ms-20">조회수 ${boardDto.boardReadcount}</div>
	</div>
	
	<!-- 작성자와 로그인 한 아이디가 같은 경우 보이는 버튼 -->
	<div class="cell right">
		<c:if test="${boardDto.empId != null && boardDto.empId == sessionScope.loginId}">
		<a class="btn btn-negative" href="./edit?boardNo=${boardDto.boardNo}">수정하기</a>
		<a class="btn btn-negative btn-content-delete" href="./delete?boardNo=${boardDto.boardNo}">삭제하기</a>
		</c:if>
	</div>
	
	<hr>
	
	<!-- 게시글 본문 -->
	<div class="cell" style="min-height:300px">
		<pre>${boardDto.boardContent}</pre>
	</div>
	
	<!-- 좋아요/댓글수 -->
	<div class="cell mt-20 flex-area">
		<div>
			<i class="fa-regular fa-comment"></i>
			댓글 
			<span class="reply-count">${boardDto.boardReplycount}</span>
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
			<h3>댓글 작성은 <a href="/emp/login">로그인</a> 한 사람만 가능합니다.</h3>
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
		<a class="btn btn-neutral" href="./list">목록으로</a>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>