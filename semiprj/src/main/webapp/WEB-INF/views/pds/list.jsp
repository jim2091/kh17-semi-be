<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<div class="container w-950 mt-50 mb-50">
    <div class="cell center mb-0">
        <h1 class="mb-0">자료실</h1>
    </div>
    <div class="cell center mt-0">
        타인에 대한 무분별한 비방글은 예고 없이 삭제될 수 있습니다
    </div>
    
    <div class="cell right">
    	<!-- 글쓰기 버튼 -->
		<c:if test="${sessionScope.loginId != null}">
			<a href="./write" class="btn btn-neutral">글쓰기</a>
		</c:if>
    </div>
    <div class="cell right">
        ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
    </div>
    <div class="cell">
        <table class="table">
            <thead>
                <tr>
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
							<a href="/member/detail?memberId=${pdsDto.pdsWriter}">
								${pdsDto.pdsWriter}
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
    
    <!-- 페이지네이션 -->
    <div class="cell mt-40">
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
    </div>
    <div class="cell center">
        <!-- 검색창 -->
		<form action="./list" method="get">
			<select name="column" class="field">
				<option value="pds_title" ${param.column == 'pds_title' ? 'selected':''}>제목</option>
				<option value="pds_writer" ${param.column == 'pds_writer' ? 'selected':''}>작성자</option>
			</select>
			<input type="text" name="keyword" class="field" placeholder="검색어" value="${param.keyword}">
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-magnifying-glass"></i>
				<span>검색</span>
			</button>
		</form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
