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
	.reply-viewer, .reply-editor {
		display:flex;
		padding:20px;
		border:1px solid #e5e7eb;
	    border-radius:12px;
	    margin-bottom:10px;
	    background:white;
	}
	.reply-viewer > .profile-wrapper,
	.reply-editor > .profile-wrapper {
		width:60px;
		min-width:60px;
		flex-shrink:0;
	}
	.reply-viewer > .profile-wrapper > img,
	.reply-editor > .profile-wrapper > img {
		width:100%;
		aspect-ratio:1/1;
		object-fit:cover;
	}
	.reply-viewer > .content-wrapper,
	.reply-editor > .content-wrapper {
		flex-grow: 1;
	}
	.field-reply{
	    border-radius:12px !important;
	}
	
	.reply-length{
	    margin-top:8px;
	
	    text-align:right;
	
	    color:#64748b;
	
	    font-size:13px;
	}
	.board-writer{
	    display:inline-block;
	    margin-left:8px;
	    padding:2px 8px;
	    border-radius:999px;
	    background:#dbeafe;
	    color:#2563eb;
	    font-size:11px;
	    font-weight:700;
	}
	.child-reply{
	    margin-left:50px;
	    padding-left:20px;
	    border-left:3px solid #dbeafe;
	    background:#fafcff;
	}
	.gw-like-btn{
	    border:none;
	    background:#fff1f2;
	    color:#e11d48;
	    border-radius:999px;
	    padding:8px 16px;
	}
	.reply-content{
    	white-space: pre-wrap;
    	overflow-wrap: break-word;
	}


.gw-content-box img{
    max-width:100%;
    border-radius:10px;
}

.gw-content-box p{
    margin:10px 0;
}
.gw-reaction-bar{
    display:flex;
    align-items:center;
    gap:15px;
    padding:15px 0;
}
.gw-form-actions{
    display:flex;
    justify-content:flex-end;
    gap:10px;

    margin-top:25px;
}
.gw-reaction-item{
    display:flex;
    align-items:center;
    gap:6px;

    padding:8px 16px;

    border-radius:999px;

    background:#f8fafc;

    font-weight:600;
}

.gw-reaction-item .fa-heart{
    cursor:pointer;
}
.image-profile{
    width:60px !important;
    height:60px !important;

    border-radius:50%;

    object-fit:cover;
}
.reply-section-title{
    margin:30px 0 15px;

    font-size:18px;
    font-weight:700;
}

.reply-section-title span{
    color:var(--main-color);
    font-weight:900;
}
.flex-area{
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.button-wrapper{
    display:flex;
    justify-content:flex-end;
    align-items:center;
    gap:12px;
}
.reply-content{
    margin-top:12px;
    line-height:1.7;
    white-space:pre-wrap;
    font-size:14px;
    border:none;
    background:none;
}
.btn-reply-child{
    cursor:pointer;
    color:var(--main-color);
    font-weight:600;
    font-size:13px;
}

.btn-reply-child:hover{
    text-decoration:underline;
}
.btn-reply-edit,
.btn-reply-delete{
    cursor:pointer;
    padding:5px;
    border-radius:6px;
}

.btn-reply-edit:hover,
.btn-reply-delete:hover{
    background:#f1f5f9;
}
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
						if(response[i].replyParent == null){
						    $(html).find(".btn-reply-child")
						        .text("답글");
						}
						else{
						    $(html).find(".btn-reply-child")
						        .remove();
						}
						var wtime = moment(response[i].replyWtime).fromNow();
						$(html).find(".reply-wtime").text(wtime);
						
						<!-- 수정됨 표시 -->
						if(response[i].replyEtime != null){
						    $(html).find(".reply-wtime").append(
						        " <span class='edited-tag' style='color:gray; font-size:12px;'>(수정됨)</span>"
						    );
						}
						
						//(1) owner가 false면 수정/삭제 버튼 영역을 지움
						if(response[i].owner == false &&
  							response[i].admin == false){
							$(html).find(".owner-menu").remove();
						}
						//(2) writer가 false면 작성자라는 글자 영역을 지움
						if(response[i].writer == false) {
							$(html).find(".board-writer").remove();
						}
						if(response[i].replyParent != null){
							$(html).addClass("child-reply")
								.prepend("↳ ");;
						}
						$(".reply-area").append(html);
					}
				}
			});
		}
		
		//등록 버튼을 누르면 댓글 등록이 이루어지도록 처리
		$(".btn-reply").on("click", function(){
			var replyContent = $(".field-reply").val();
			 console.log("글자수 =", replyContent.length);
			if(replyContent.length == 0) return;
			if(replyContent.length > 500){
		        alert("댓글은 500자까지 작성 가능합니다.");
		        return;
		    }
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
			if(replyContent.length > 500){
		        alert("댓글은 500자까지 작성 가능합니다.");
		        return;
		    }

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

		$(".field-reply, .field-child-content, .field-reply-edit").on("input", function(){

		    var len = $(this).val().length;

		    $(".reply-length").text(len + " / 500");

		    if(len >= 500){
		        $(".reply-length").css("color", "red");
		    }
		    else{
		        $(".reply-length").css("color", "");
		    }
		});
		
		//대댓글 입력창
		$(".reply-area").on("click", ".btn-reply-child", function(){
			 $(".reply-child-editor").remove();
		    var template = $("#reply-child-template").text();
		    var html = $.parseHTML(template);

		    var replyViewer = $(this).closest(".reply-viewer");
		    var parentNo = replyViewer.data("key");

		    $(html).attr("data-parent", parentNo);

		    replyViewer.after(html);
		});
		$(".reply-area").on("click", ".btn-child-cancel", function(){
		    $(this).closest(".reply-child-editor").remove();
		});
		$(".reply-area").on("click", ".btn-child-save", function(){

		    var editor = $(this).closest(".reply-child-editor");

		    var parentNo = editor.data("parent");

		    var replyContent =
		        editor.find(".field-child-content").val();

		    if(replyContent.length == 0) return;
		    if(replyContent.length > 500){
		        alert("댓글은 500자까지 작성 가능합니다.");
		        return;
		    }

		    $.ajax({
		        url: "/rest/reply/write",
		        method: "post",
		        data: {
		            replyOrigin : boardNo,
		            replyParent : parentNo,
		            replyContent : replyContent
		        },
		        success: function(){
		        	$(".reply-child-editor").remove();
		            loadList();
		            var count = Number($(".reply-count").text());
		            $(".reply-count").text(count + 1);
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
				<span class="board-writer red">작성자</span>
			</h3>
			<pre class="mt-10 mb-0 reply-content">내용 샘플</pre>
			<div class="mt-20 flex-area">
				<div class="w-50">
					<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
					<span class="edited-tag"></span>
				</div>
				<div class="button-wrapper right w-50">
				    <span class="btn-reply-child"><i class="fa-solid fa-reply"></i>댓글</span>
				    <span class="owner-menu">
				        <i class="fa-solid fa-edit orange btn-reply-edit"></i>
				        <i class="fa-solid fa-trash red btn-reply-delete"></i>
				    </span>
				</div>
			</div>
		</div>
	</div>
</script>
<script type="text/template" id="reply-child-template">
<div class="reply-child-editor ms-50">
    <textarea class="field field-child-content w-100"
              rows="3"
			maxlength="1500"
              placeholder="답글을 입력하세요"></textarea>
	<div class="reply-length">0 / 500</div>
    <div class="right mt-10">
        <button type="button" class="btn btn-negative btn-child-cancel">
            취소
        </button>

        <button type="button" class="btn btn-positive btn-child-save">
            등록
        </button>
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
			<textarea class="field w-100 field-reply-edit" rows="3" maxlength="1500">내용 샘플</textarea>
			<div class="reply-length">0 / 500</div>
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

	<div class="gw-detail-panel pds-width">

        <div class="gw-page-head">
		    <div class="gw-breadcrumb">홈 / 게시판 / 상세보기</div>
			<span class="board-head">${boardDto.boardHead}</span>
			<h1>${boardDto.boardTitle}</h1>
		</div>
		
		<div class="gw-form-panel">
		    
		    <!-- 작성자 / 날짜 / 조회수 -->
		    <div class="gw-detail-info">
		        <div class="gw-detail-author">
		            <i class="fa-regular fa-user"></i>

					<!-- 게시글 작성자 -->
					<c:choose>
						<c:when test="${boardDto.boardWriter == null}">
							<span class="gw-muted">(탈퇴한 사용자)</span>
						</c:when>
					    <c:when test="${boardDto.boardType eq '익명'}">
					        <span class="gw-muted">익명</span>
					    </c:when>
					    <c:otherwise>
					        <!-- 링크 누르면 사원 상세 정보 페이지로 이동 -->
							<a href="/emp/detail?empNo=${boardDto.boardWriter}" class="gw-table-link">
								${boardDto.empName}
							</a>
					    </c:otherwise>
					</c:choose>
				</div>
				
				<div class="gw-detail-meta">
		            <span>
		                <i class="fa-regular fa-calendar"></i>
		                <fmt:formatDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm"/>
		            </span>
		            <span>
		                <i class="fa-regular fa-eye"></i>
		                ${boardDto.boardReadcount}
		            </span>
		        </div>
		    </div>
		    
		    <!-- 본문 -->
		    <div class="gw-form-row">
		        <label class="gw-form-label">내용</label>
		        <div class="gw-content-box">
		            <pre>${boardDto.boardContent}</pre>
		        </div>
		    </div>
		    
		    <!-- 좋아요/댓글수 -->
			<div class="gw-reaction-bar">
				<div class="gw-reaction-item">
					<i class="fa-regular fa-comment"></i>
						댓글 
					<span class="reply-count">${boardDto.boardReplycount}</span>
				</div>
				<div class="gw-reaction-item">
					<i class="fa-solid fa-heart red"></i> 
					좋아요
					<span class="heart-count">?</span>
				</div>
			</div>
			
			<!-- 댓글 -->
			<h3 class="reply-section-title">
			    댓글
			    <span class="reply-count">
			        ${boardDto.boardReplycount}
			    </span>
			</h3>
			<div class="cell reply-area"></div>
			<!-- 로그인한 경우 -->
			<c:if test="${sessionScope.loginId != null}">
				<div class="gw-form-row">
					<textarea class="field w-100 field-reply" rows="4" maxlength="1500" placeholder="댓글 내용 작성"></textarea>
					<div class="reply-length">0 / 500</div>
					<button type="button" class="gw-btn-outline w-100 mt-10 btn-reply">
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
		    
		    <!-- 이전글 / 다음글 -->
		    <div class="gw-form-row">
		        <label class="gw-form-label">이전 글 / 다음 글</label>
		        <div class="gw-nav-box">
		
		            <div class="gw-nav-row">
		                <span class="gw-nav-label">이전글</span>
		                <c:if test="${prevBoardDto != null}">
		                    <a href="./detail?boardNo=${prevBoardDto.boardNo}" class="gw-table-link">
		                        ${prevBoardDto.boardTitle}
		                    </a>
		                </c:if>
		            </div>
		
		            <div class="gw-nav-row">
		                <span class="gw-nav-label">다음글</span>
		                <c:if test="${nextBoardDto != null}">
		                    <a href="./detail?boardNo=${nextBoardDto.boardNo}" class="gw-table-link">
		                        ${nextBoardDto.boardTitle}
		                    </a>
		                </c:if>
		            </div>
		        </div>
		    </div>
		    
		    <!-- 버튼 -->
		    <div class="gw-form-actions">
				<!-- 로그인 한 경우 보이는 버튼 -->
				<c:if test="${sessionScope.loginId != null}">
				<a href="./write" class="gw-btn-outline">글쓰기</a>
					<c:if test="${!(boardDto.boardType eq '비밀' and boardDto.boardParent ne null)}">
					<a href="./write?boardParent=${boardDto.boardNo}" class="gw-btn-outline">답글쓰기</a>
					</c:if>
				</c:if>
		    	
		        <a href="./list" class="gw-btn-outline">
		            <i class="fa-solid fa-list"></i>
		            <span>목록으로</span>
		        </a>
				<c:if test="${boardDto.empId == sessionScope.loginId || sessionScope.loginRole == '관리자'}">
		        <a href="./edit?boardNo=${boardDto.boardNo}" class="gw-btn-outline">
		            <i class="fa-solid fa-pen"></i>
		            <span>수정하기</span>
		        </a>
		
		        <a href="./delete?boardNo=${boardDto.boardNo}"
		           class="gw-btn-danger btn-content-delete">
		            <i class="fa-regular fa-trash-can"></i>
		            <span>삭제하기</span>
		        </a>
		        </c:if>
		    </div>    
		</div>
	</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>