<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 페이지네이션 -->

<div class="pagination">
	<!-- 맨 첫 페이지 -->
	<a href="${pageUrl}?page=1&${pageVO.getSearchParams()}">
		<i class="fa-solid fa-angles-left"></i>
	</a>
	
	<!-- 이전 -->
	<c:if test="${pageVO.hasPrevious()}">
		<a href="${pageUrl}?page=${pageVO.getPreviousBlock()}&${pageVO.getSearchParams()}">
			<i class="fa-solid fa-angle-left"></i>
		</a>
	</c:if>

	<!-- 숫자 --> 
	<c:forEach var="i" begin="${pageVO.getBeginBlock()}" end="${pageVO.getEndBlock()}" step="1">
		<c:if test="${pageVO.page == i}">
			<a href="${pageUrl}?page=${i}&${pageVO.getSearchParams()}" class="on">${i}</a>
		</c:if>
		<c:if test="${pageVO.page != i}">
			<a href="${pageUrl}?page=${i}&${pageVO.getSearchParams()}">${i}</a>
		</c:if>
	</c:forEach>

	<!-- 다음 -->
	<c:if test="${pageVO.hasNext()}">
		<a href="${pageUrl}?page=${pageVO.getNextBlock()}&${pageVO.getSearchParams()}">
			<i class="fa-solid fa-angle-right"></i>
		</a>
	</c:if>

	<!-- 맨 뒷 페이지 -->
	<a href="${pageUrl}?page=${pageVO.getPageCount()}&${pageVO.getSearchParams()}">
		<i class="fa-solid fa-angles-right"></i>
	</a>
</div>