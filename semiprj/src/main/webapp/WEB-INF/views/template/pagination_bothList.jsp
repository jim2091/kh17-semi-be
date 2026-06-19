<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="pagination">
	<c:if test="${pageVO.hasPrevious()}">
		<%-- 💡 독자 매핑 주소인 /app/bothList 뒤에 3대 커스텀 파라미터를 명시적으로 체이닝 --%>
		<a href="/app/bothlist?page=${pageVO.getPreviousBlock()}&${searchParams}">
			<i class="fa-solid fa-chevron-left"></i>
		</a>
	</c:if>

	<c:forEach var="i" begin="${pageVO.getBeginBlock()}" end="${pageVO.getEndBlock()}" step="1">
		<c:if test="${pageVO.page == i}">
			<a href="/app/bothlist?page=${i}&${searchParams}" class="on">${i}</a>
		</c:if>
		<c:if test="${pageVO.page != i}">
			<a href="/app/bothlist?page=${i}&${searchParams}">${i}</a>
		</c:if>
	</c:forEach>

	<c:if test="${pageVO.hasNext()}">
		<a href="/app/bothlist?page=${pageVO.getNextBlock()}&${searchParams}">
			<i class="fa-solid fa-chevron-right"></i>
		</a>
	</c:if>
</div>
