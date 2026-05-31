<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!-- 페이지네이션 -->
<h2>

<!-- 이전 -->
<c:if test="${pageVo.hasPrevious()}">
<a href="./history?page=${pageVo.getPreviousBlock()}&${pageVo.getSearchParams()}">&lt;</a>
</c:if>

<!-- 숫자 --> 
<c:forEach var="i" begin="${pageVo.getBeginBlock()}" end="${pageVo.getEndBlock()}" step="1">
	<c:if test="${pageVo.page == i}">${i}</c:if>
	<c:if test="${pageVo.page != i}">
		<a href="./history?page=${i}&${pageVo.getSearchParams()}">${i}</a>
	</c:if>
</c:forEach>

<!-- 다음 -->
<c:if test="${pageVo.hasNext()}">
<a href="./history?page=${pageVo.getNextBlock()}&${pageVo.getSearchParams()}">&gt;</a>
</c:if>

</h2>