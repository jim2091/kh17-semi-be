<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<style>
.side-title {
	background: #fafafa;
	border-bottom: 1px solid #ddd;
	padding: 15px;
	font-size: 20px;
	font-weight: bold;
	text-align: center;
}

.side-link {
	display: block;
	padding: 10px 15px;
	text-decoration: none;
	color: #333;
	font-size: 17px;
}

.side-link:hover {
	background: #f5f5f5;
}

.side-section {
	border: 1px solid #e5e5e5;
	border-radius: 10px;
	overflow: hidden;
	margin-bottom: 15px;
}

.side-section:last-child {
	border-bottom: none;
}

.board-side {
    height: 600px;
    overflow-y: auto;
    position: sticky;
    top: 0;
    align-self: flex-start;
}
</style>
<div class="container w-100 mt-10 side-area center cell flex-fill">
	<div class="board-side">
		<div class="side-section">
			<div class="side-title">결재 작성</div>
			<a href="./expInsert" class="side-link"> <i class="fa-solid fa-file-arrow-up"></i> 품의서
			</a> <a href="./dftInsert" class="side-link"> <i class="fa-solid fa-file-arrow-up"></i> 업무기안서
			</a> <a href="./vacInsert" class="side-link"> <i class="fa-solid fa-file-arrow-up"></i> 휴가신청서
			</a>
		</div>
		<div class="side-section">
			<div class="side-title">문서함</div>
			<a href="./list" class="side-link"> <i class="fa-solid fa-folder-open"></i> 전체 문서함</a>
		 	<a href="./myAppr" class="side-link"> <i class="fa-solid fa-file-circle-check"></i> 미결재 문서함</a> 
			<hr>
			<a href="./myList" class="side-link"> <i class="fa-solid fa-file-lines"></i> 기안 문서함</a>
			<a href="./myNoneList" class="side-link"> <i class="fa-solid fa-file-lines"></i> 결재 대기함</a>
		 	<a href="./myIng" class="side-link"> <i class="fa-solid fa-clock"></i> 결재 진행 문서함</a> 
		 	<a href="./myRej" class="side-link"> <i class="fa-solid fa-file-circle-xmark"></i> 반려 문서함</a>
		</div>
	</div>
</div>
</div>
<div class="w-200 flex-fill">