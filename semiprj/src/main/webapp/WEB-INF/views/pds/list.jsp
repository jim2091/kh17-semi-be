<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-900 mt-50 mb-50">
	<!-- 페이지 제목 -->
    <div class="cell center">
        <h1 class="mt-0 mb-0">사내 게시판</h1>
    </div>
    
    <!-- 경고문 -->
    <div class="cell center mt-10">
    	<i class="fa-solid fa-circle-exclamation red"></i>
        <span>타인에 대한 무분별한 비방글은 예고 없이 삭제될 수 있습니다.</span>
    </div>
    
    <!-- 검색창 -->
    <div class="cell center">
	<form action="./list" method="get">
		<select name="column" class="field">
			<option value="pds_title" ${param.column == 'board_title' ? 'selected':''}>제목</option>
			<option value="pds_writer" ${param.column == 'board_writer' ? 'selected':''}>작성자</option>
		</select>
		<input type="text" name="keyword" class="field" placeholder="검색어" value="${param.keyword}">
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-magnifying-glass"></i>
			<span>검색</span>
		</button>
	</form>
	</div>
    
    <!-- 글쓰기 버튼 -->
    <div class="cell right">
		<c:if test="${sessionScope.loginId != null}">
			<a href="./write" class="btn btn-neutral">글쓰기<i class="fa-solid fa-pencil"></i></a>
		</c:if>
    </div>
    
    <!-- 게시글 목록 -->
    <div class="cell">
    	<tabel class="table">
    		<thead>
    			<tr>
    				<th>번호</th>
    				<th>종류</th>
                    <th class="w-40">제목</th>
                    <th>작성자</th>
                    <th>조회수</th>
                    <th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="pdsDto" items="${list}" varStatus="stat">
					<!-- 게시글 번호 -->
					<td>${pdsDto.pdsNo}</td>
					<!-- 게시글 제목 -->
					<td align="left">
						<a href="./detail?pdsNo=${pdsDto.pdsNo}&page=${pageVO.page}&${pageVO.searchParams}" class="link">${pdsDto.pdsTitle}</a>
						<!-- 조회 수 -->
						<c:if test="${pdsDto.pdsreadcount > 0}">[${pdsDto.pdsReadcount}]</c:if>
					</td>
					<!-- 게시글 작성자 -->
					<td>
						<c:if test="${pdsDto.pdsWriter == null}">
							(퇴사한 사용자)
						</c:if>
						<c:if test="${pdsDto.pdsWriter != null}">
							<!-- 링크 누르면 사원 상세 정보 페이지로 이동 -->
							<a href="#=${pdsDto.pdsWriter}">
								${pdsDto.pdsWriter}
							</a>
						</c:if>
					</td>
					<!-- 게시글 조회수 -->
					<td>${pdsDto.pdsReadcount}</td>
					<!-- 게시글 작성일 -->
					<td>${pdsDto.getPdsWtimeString()}</td>
				</tr>
				</c:forEach>
            </tbody>
        </table>
    </div>
    
	<!-- 페이지네이션 -->
    <div class="cell mt-50">
		<jsp:include page="/WEB-INF/views/template/pagination2.jsp"></jsp:include>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>