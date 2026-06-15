<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.notice-banner {
    display: flex;
    align-items: center;
    gap: 10px;
    background: var(--main-light);
    color: var(--main-color);
    border: 1px solid var(--card-border);
    border-radius: 16px;
    padding: 14px 18px;
    margin-bottom: 18px;
    font-weight: 700;
}

.board-table th:nth-child(1),
.board-table td:nth-child(1) {
    width: 110px;
}

.board-table th:nth-child(3),
.board-table td:nth-child(3) {
    width: 140px;
}

.board-table th:nth-child(4),
.board-table td:nth-child(4) {
    width: 90px;
}

.board-table th:nth-child(5),
.board-table td:nth-child(5) {
    width: 140px;
}

.board-title-cell {
    text-align: left !important;
}

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

.notice-row {
    background: rgba(245, 158, 11, 0.08);
}

.notice-row .board-head {
    background: #fffbeb;
    color: var(--warning-color);
}

.lock-icon {
    color: var(--warning-color);
    margin-right: 5px;
}

.reply-mark {
    color: var(--sub-text);
    margin-right: 4px;
}

.reply-mark i{
    transform: scaleY(-1);
}

.reply-count {
    color: var(--main-color);
    font-size: 13px;
    font-weight: 800;
    margin-left: 4px;
}

.muted-text {
    color: var(--sub-text);
}
.title-wrapper{
    display:flex;
    align-items:center;
    gap:4px;
    min-width:0;
}

.title-ellipsis{
    overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap;
    min-width:0;
}
.gw-table{
    table-layout: fixed;
    width: 100%;
}
</style>
	
	<div class="pds-width">
		<div class="gw-page-head">
        	<div class="gw-breadcrumb">홈 / 게시판 / 목록</div>
        	<h1>사내 게시판</h1>
        	<p>타인에 대한 무분별한 비방글은 예고 없이 삭제될 수 있습니다.</p>
    	</div>

	    <div class="gw-search-panel pds-width">
		<form action="./list" method="get" class="gw-search-form">
			<select name="column" class="gw-form-select">
				<option value="board_title" ${param.column == 'board_title' ? 'selected':''}>제목</option>
				<option value="title_content" ${param.column == 'title_content' ? 'selected':''}>제목+내용</option>
				<option value="board_writer" ${param.column == 'board_writer' ? 'selected':''}>작성자</option>
			</select>
			<input type="text" name="keyword" class="gw-form-input" 
				placeholder="검색어를 입력하세요." value="${param.keyword}">
			<button type="submit" class="gw-btn-primary">
				<i class="fa-solid fa-magnifying-glass"></i>
				<span>검색</span>
			</button>
		</form>
		</div>
	
		<div class="gw-list-panel pds-width">
			<div class="gw-table-top">
			    <div>
			        <div class="gw-table-title">게시판 목록</div>
			        <div class="gw-table-sub">
			            ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
			        </div>
			    </div>
	    		<div class="gw-table-actions">
		        <c:if test="${sessionScope.loginId != null}">
		        	<a href="/board/my" class="gw-btn-outline">
				        <i class="fa-solid fa-file-pen"></i>
				        <span>내 활동</span>
				    </a>
		            <a href="./write" class="gw-btn-outline">
		                <i class="fa-solid fa-pencil"></i>
		                <span>글쓰기</span>
		            </a>
		        </c:if>
			    </div>
			</div>

    <table class="gw-table pds-table">
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
			<tr class="${stat.index < noticeCount ? 'notice-row' : ''}">
				<td>
					<span class="board-head">
						${boardDto.boardHead}
					</span>
				</td>

				<td class="gw-title-cell">
					<div class="title-wrapper">
						<!-- 비밀글인 경우 -->
						<c:if test="${boardDto.boardType eq '비밀'}">
	   						<i class="fa-solid fa-lock lock-icon"></i>
						</c:if>
						<!-- 답변글인 경우 -->
						<c:if test="${boardDto.boardDepth > 0}">
							<c:forEach var="i" begin="1" end="${boardDto.boardDepth}" step="1">
								&nbsp;&nbsp;&nbsp;&nbsp;
							</c:forEach> 
							<span class="reply-mark">
							    <i class="fa-solid fa-share"></i>
							</span>
						</c:if>
					
					    <div class="title-ellipsis">
					        <a href="./detail?boardNo=${boardDto.boardNo}&page=${pageVO.page}&${pageVO.searchParams}" class="gw-table-link">
					            ${boardDto.boardTitle}
					        </a>
						</div>
					
						<!-- 댓글 개수 -->
						<c:if test="${boardDto.boardReplycount > 0}">
						    <span class="reply-count">
						        [${boardDto.boardReplycount}]
						    </span>
						</c:if>
					</div>
				</td>
				
				<!-- 게시글 작성자 -->
				<td>
					<c:choose>
						<c:when test="${boardDto.boardWriter == null}">
							<span class="gw-muted">(퇴사한 사용자)</span>
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
				</td>
				<!-- 게시글 조회수 -->
				<td>${boardDto.boardReadcount}</td>
				<!-- 게시글 작성일 -->
				<td>${boardDto.getBoardWtimeString()}</td>
			</tr>
			</c:forEach>
			
			<c:if test="${pageVO.isSearch() && list.size() == noticeCount}">
			    <tr>
			        <td colspan="5"
			            style="padding:40px;text-align:center;color:#aaa;">
			            검색 결과가 없습니다.
			        </td>
			    </tr>
			</c:if>
           </tbody>
       </table>
       
       <div class="gw-pagination">
            <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
       </div>
   </div>
   </div>

<script>
$(function(){
    var savedTheme = localStorage.getItem("gwTheme");

    if(savedTheme){
        $("body").addClass(savedTheme);
    }
    else{
        $("body").addClass("theme-blue");
    }

    $(".theme-btn").click(function(){
        $(".theme-popup").toggle();
    });

    $(".theme-item").click(function(){
        var theme = $(this).data("theme");

        $("body")
            .removeClass("theme-blue theme-green theme-purple theme-dark")
            .addClass(theme);

        localStorage.setItem("gwTheme", theme);

        $(".theme-popup").hide();
    });

    $(".check-all").change(function(){
        $("input[name=pdsNoList]").prop("checked", this.checked);
    });

    $("input[name=pdsNoList]").change(function(){
        $(".check-all").prop("checked",
            $("input[name=pdsNoList]").length == $("input[name=pdsNoList]:checked").length
        );
    });
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>