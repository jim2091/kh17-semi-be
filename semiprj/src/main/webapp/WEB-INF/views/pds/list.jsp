<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_board_pds.jsp"></jsp:include>

<script>
$(function(){
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

<div class="container w-950 mt-50 mb-50">
	<!-- 페이지 제목 -->
    <div class="cell center">
        <h1 class="mt-0 mb-0">자료실</h1>
    </div>
	
    <!-- 검색창 -->
	<div class="cell center">
		<form action="./list" method="get">
			<select name="column" class="field">
				<option value="pds_title" ${param.column == 'pds_title' ? 'selected':''}>제목</option>
				<option value="title_content" ${param.column == 'title_content' ? 'selected':''}>제목+내용</option>
				<option value="pds_writer" ${param.column == 'pds_writer' ? 'selected':''}>작성자</option>
			</select>
			<input type="text" name="keyword" class="field" placeholder="검색어" value="${param.keyword}">
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-magnifying-glass"></i>
				<span>검색</span>
			</button>
		</form>
    </div>
    <form action="./deleteAll" method="post">
	    <div class="cell right">
	    	<!-- 글쓰기 버튼 -->
			<c:if test="${sessionScope.loginId != null}">
				<a href="./write" class="btn btn-neutral">글쓰기<i class="fa-solid fa-pencil"></i></a>
			</c:if>
			<button type="submit" class="btn btn-negative">삭제하기<i class="fa-regular fa-trash-can"></i></button>
	    </div>
	    <div class="cell right">
	        ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
	    </div>
	    <div class="cell">
	        <table class="table">
	            <thead>
	                <tr>
	                	<c:if test="${sessionScope.loginRole == '관리자'}">
	                		<th>
		                		<input type="checkbox" class="check-all">
	                		</th>
	                	</c:if>
	                    <th>번호</th>
	                    <th class="w-40">제목</th>
	                    <th>작성자</th>
	                    <th>작성일</th>
	                    <th>조회수</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<!-- 일반 게시글 -->
					<!-- varStatus를 쓰면 반복문의 상태를 알 수 있다(index, count, first, last) -->
					<c:forEach var="pdsDto" items="${list}" varStatus="stat">
					<tr>
						<c:if test="${sessionScope.loginRole == '관리자'}">
	                		<td>
		                		<input type="checkbox" name="pdsNoList" value="${pdsDto.pdsNo}">
	                		</td>
	                	</c:if>
						<td>${pdsDto.pdsNo}</td>
						<td align="left">
						
							<!-- 게시글 제목 -->
							<a href="./detail?pdsNo=${pdsDto.pdsNo}&page=${pageVO.page}&${pageVO.searchParams}" class="link">
							${pdsDto.pdsTitle}
							</a>
						</td>
						<td>
							<c:if test="${pdsDto.pdsWriter == null}">
								(탈퇴한사용자)
							</c:if>
							<c:if test="${pdsDto.pdsWriter != null}">
								<!-- 누르면 이동하도록 링크 구현 -->
								<a href="/emp/detail?empNo=${pdsDto.pdsWriter}" class="link">
									${pdsDto.empName}
								</a>
							</c:if>
						</td>
						<td>${pdsDto.getPdsWtimeString()}</td>
						<td>${pdsDto.pdsReadcount}</td>
					</tr>
					</c:forEach>
	            </tbody>
	        </table>
	    </div>
    </form>
    
    <!-- 페이지네이션 -->
    <div class="cell mt-50">
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
    </div>
    
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
