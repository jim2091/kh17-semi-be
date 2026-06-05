<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<style>
	.side-title{
	    background:#fafafa;
	    border-bottom:1px solid #ddd;
	    padding:15px;
	    font-size:20px;
	    font-weight:bold;
	    text-align:center;
	}
	
	.side-link{
	    display:block;
	    padding:10px 15px;
	    text-decoration:none;
	    color:#333;
	    font-size:17px;
	}
	
	.side-link:hover{
	    background:#f5f5f5;
	}
	
	.rank-link{
	    display:block;
	    padding:8px 12px;
	    text-decoration:none;
	    color:#333;
	    font-size:14px;
	    white-space:nowrap;
	    overflow:hidden;
	    text-overflow:ellipsis;
	}
	.board-rank{
	    height:180px;
	}
	
	.side-section{
	    border:1px solid #e5e5e5;
	    border-radius:10px;
	    overflow:hidden;
	    margin-bottom:15px;
	}
	
	.side-section:last-child{
	    border-bottom: none;
	}
</style>

					<div class="container w-100 mt-10 side-area center cell flex-fill">
						<div class="board-side">
							<div class="side-section">
								<div class="side-title">게시판 종류</div>
								<a href="/board/list" class="side-link">
									<i class="fa-regular fa-rectangle-list"></i> 전체글
								</a>
								<a href="./list?boardHead=공지" class="side-link">
									<i class="fa-solid fa-bullhorn"></i> 공지글
								</a>
								<a href="./list?boardHead=자유" class="side-link">
									<i class="fa-regular fa-comments"></i> 자유글
								</a>
								<a href="./list?boardHead=정보" class="side-link">
									<i class="fa-solid fa-circle-info"></i> 정보글
								</a>
								<a href="./list?boardHead=질문" class="side-link">
									<i class="fa-solid fa-question"></i> 질문글
								</a>
							</div>

                  				<div class="side-section">
					  			<div class="side-title">내 활동</div>
				            	<a href="./my" class="side-link">
				            		<i class="fa-solid fa-file-pen"></i> 내가 쓴 글
				            	</a>
								<a href="./myReply" class="side-link">
									<i class="fa-regular fa-comment-dots"></i> 내가 쓴 댓글
								</a>
							</div> 
						</div>
                	</div>
                	</div>
				<div class="w-200 flex-fill">