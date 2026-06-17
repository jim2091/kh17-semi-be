<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.board-title-row{
    display:flex;
    align-items:center;
    gap:12px;
    margin-top:10px;
}

.board-title-row h1{
    margin:0;
    font-size:32px;
    font-weight:700;
    color:#0f172a;
}

.board-head{
    display:inline-flex;
    align-items:center;

    padding:6px 12px;

    border-radius:999px;

    font-size:13px;
    font-weight:600;

    background:#f3e8ff;
    color:#7c3aed;
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
	.field-reply, 
	.field-reply-edit {
	    border-radius:12px !important;
	}
	
	.reply-length{
	    margin-top:8px;
	
	    text-align:right;
	
	    color:#64748b;
	
	    font-size:13px;
	    margin-bottom: 16px;
	}
	.board-writer{
	    display:inline-block;
	    margin-left:8px;
	    padding:4px 8px;
	    border-radius:999px;
	    background:#dbeafe;
	    color:#2563eb;
	    font-size:11px;
	    font-weight:700;
	}
	.child-reply{
		position: relative;
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
.action-group {
    margin-left: auto;
    display: flex;
    gap: 8px;
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
	    transition:0.2s;
	}
	
	/* 좋아요 안 눌렀을 때 */
.gw-reaction-item .fa-heart.fa-regular{
    color:#666;
}

/* 좋아요 눌렀을 때 */
.gw-reaction-item .fa-heart.fa-solid{
    color:#2563eb;
}

.gw-reaction-item .heart-count{
    font-weight:600;
}

/* 숫자도 파랗게 */
.gw-reaction-item.active .heart-count{
    color:#2563eb;
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
    gap:10px;
}
.reply-content{
    margin-top:12px;
    line-height:1.7;
    white-space:pre-wrap;
    font-size:14px;
    border:none;
    background:none;
}

.field-child-content{
    width: 100%;
    resize: none;
    padding: 12px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 14px;
}
.field-child-content:focus{
    outline: none;
    border-color: #2563eb;
}
.reply-child-editor{
    margin-left: 60px;
    margin-top: 10px;

    padding: 15px;

    border-left: 3px solid #dbeafe;
    background-color: #f8fbff;
    border-radius: 8px;
}
.reply-editor{
    margin-top: 10px;
    padding: 15px;

    background: #fafafa;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
}
.reply-write-length,
.reply-edit-length,
.reply-child-length{
    text-align:right;
    color:#9ca3af;
    font-size:12px;
    margin-top:5px;
}

.btn-reply {
width: 220px;
margin-left:auto;
display:block;
}
/* 댓글 액션 영역 */
.owner-menu {
    display: flex;
    gap: 12px;
}

/* 답글 / 수정 / 삭제 공통 */
.btn-reply-child,
.btn-reply-edit,
.btn-reply-delete {
    font-size: 13px;
    font-weight: 500;
    color: var(--sub-text);
    cursor: pointer;
    transition: color 0.2s ease;
}

.btn-reply-cancel,
.btn-reply-save,
.btn-child-cancel,
.btn-child-save {
	color: var(--sub-text);
    cursor: pointer;
    transition: color 0.2s ease;
}

/* hover */
.btn-reply-child:hover,
.btn-reply-edit:hover,
.btn-reply-delete:hover,
.btn-reply-cancel:hover,
.btn-reply-save:hover,
.btn-child-cancel:hover,
.btn-child-save:hover {
    color: var(--main-color);
}
.reply-wtime {
    color: #64748b;
    font-size: 12px;
    letter-spacing: -0.3px;
}
.board-title{
    overflow-wrap: anywhere;
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
				$(".like-item")
		        .toggleClass("active", response.action);
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
						if(response[i].empName.startsWith("익명")){
						    $(html).find(".image-profile")
						        .attr("src", "/images/no_profile.jpg");
						}
						else{
						    $(html).find(".image-profile")
						        .attr("src", "/emp/profile?empNo="+response[i].replyWriter);
						}
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

						if(response[i].replyEtime != null){
						    $(html).find(".reply-wtime").append(
						        " <span class='edited-tag' style='color:gray; font-size:12px;'>(수정됨)</span>"
						    );
						}
						
						if(response[i].owner){
						    // 수정 + 삭제
						}
						else if(response[i].admin){
						    $(html).find(".btn-reply-edit").remove();
						}
						else{
						    $(html).find(".owner-menu").remove();
						}
						
						//(2) writer가 false면 작성자라는 글자 영역을 지움
						if(response[i].writer == false) {
							$(html).find(".board-writer").remove();
						}
						if(response[i].replyParent != null){
							$(html).addClass("child-reply");
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
					$(".reply-write-length").text("0 / 500");
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
			
			$(html).find(".reply-edit-length")
		       .text(replyContent.length + " / 500");
			
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

		// 댓글 작성
		$(document).on("input", ".field-reply", function(){
		    $(".reply-write-length")
		        .text($(this).val().length + " / 500");
		});

		// 댓글 수정
		$(document).on("input", ".field-reply-edit", function(){
		    $(this)
		        .closest(".reply-editor")
		        .find(".reply-edit-length")
		        .text($(this).val().length + " / 500");
		});

		// 대댓글
		$(document).on("input", ".field-child-content", function(){
		    $(this)
		        .closest(".reply-child-editor")
		        .find(".reply-child-length")
		        .text($(this).val().length + " / 500");
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
				<span class="board-writer">작성자</span>
			</h3>
			<pre class="mt-10 mb-0 reply-content">내용 샘플</pre>
			<div class="mt-20 flex-area">
				<div class="w-50">
					<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
					<span class="edited-tag"></span>
				</div>
				<div class="button-wrapper right w-50">
				    <span class="btn-reply-child">
						<i class="fa-solid fa-reply"></i>댓글
					</span>
				    <span class="owner-menu">
				        <span class="btn-reply-edit reply-action">수정</span>
    					<span class="btn-reply-delete reply-action">삭제</span>
				    </span>
				</div>
			</div>
		</div>
	</div>
</script>
<script type="text/template" id="reply-child-template">
<div class="reply-child-editor ms-50t mb-10">
    <textarea class="field field-child-content w-100" 
			rows="4"
			maxlength="500"
             placeholder="답글을 입력하세요"></textarea>
	<div class="reply-child-footer flex-area">
		<div class="reply-child-length">0 / 500</div>
		<div class="button-wrapper right w-50">
			<i class="fa-solid fa-xmark btn-child-cancel"></i>
			<i class="fa-solid fa-check btn-child-save"></i>
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
			<textarea class="field w-100 field-reply-edit" rows="3" maxlength="500">내용 샘플</textarea>
			<div class="reply-edit-length">0 / 500</div>
			<div class="mt-20 flex-area">
				<div class="w-50">
					<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
				</div>
				<div class="button-wrapper right w-50">
					<i class="fa-solid fa-xmark btn-reply-cancel"></i>
					<i class="fa-solid fa-check btn-reply-save"></i>
				</div>
			</div>
		</div>
	</div>
</script>

	<div class="gw-detail-panel pds-width">

        <div class="gw-page-head">
		    <div class="gw-breadcrumb">홈 / 게시판 / 상세보기</div>
		    <div class="board-title-row">
				<span class="board-head">${boardDto.boardHead}</span>
				<h1 class="board-title">${boardDto.boardTitle}</h1>
			</div>
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

			<div class="gw-reaction-bar">
				<div class="gw-reaction-item like-item">
					<i class="fa-solid fa-heart"></i> 
					좋아요
					<span class="heart-count">?</span>
				</div>
				
				<c:if test="${boardDto.empId == sessionScope.loginId || sessionScope.loginRole == '관리자'}">
		        <div class="action-group">
			        <a href="./edit?boardNo=${boardDto.boardNo}" class="gw-btn-outline">
			        	<i class="fa-solid fa-edit"></i>
			            <span>수정하기</span>
			        </a>
			        <a href="./delete?boardNo=${boardDto.boardNo}"
			           class="gw-btn-danger btn-content-delete">
			            <i class="fa-regular fa-trash-can"></i>
			            <span>삭제하기</span>
			        </a>
		        </div>
		        </c:if>
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
					<textarea class="field w-100 field-reply" rows="4" maxlength="500" placeholder="댓글을 입력하세요"></textarea>
					<div class="reply-length reply-write-length">0 / 500</div>
					<button type="button" class="gw-btn-outline mt-10 btn-reply">
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
				<a href="./write" class="gw-btn-outline"><i class="fa-solid fa-pen"></i>글쓰기</a>
					<c:if test="${!(boardDto.boardType eq '비밀' and boardDto.boardParent ne null)}">
					<a href="./write?boardParent=${boardDto.boardNo}" class="gw-btn-outline"><i class="fa-solid fa-share"></i>답글쓰기</a>
					</c:if>
				</c:if>

		        <a href="./list" class="gw-btn-primary">
		            <i class="fa-solid fa-list"></i>
		            <span>목록으로</span>
		        </a>
		    </div>    
		</div>
	</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>