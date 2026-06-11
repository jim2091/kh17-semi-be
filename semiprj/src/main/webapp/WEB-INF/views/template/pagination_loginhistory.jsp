<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ${historyPageVO} --%>
<h2>
<c:if test="${historyPageVO.hasPrevious()}">
<a href="./history?page=${historyPageVO.getPreviousBlock()}&empNo=${empDto.empNo}&${historyPageVO.getSearchParams()}">&lt;</a></c:if>
<c:forEach var="i" begin="${historyPageVO.getBeginBlock()}" end="${historyPageVO.getEndBlock()}" step="1">

<c:if test="${historyPageVO.page == i}">${i}</c:if>
<c:if test="${historyPageVO.page != i}">
<a href="./history?page=${i}&empNo=${empDto.empNo}&${historyPageVO.getSearchParams()}">${i}</a> 
</c:if>
</c:forEach>
<c:if test="${historyPageVO.hasNext()}">
<a href="./history?page=${historyPageVO.getNextBlock()}&empNo=${empDto.empNo}&${historyPageVO.getSearchParams()}">&gt;</a></c:if>
</h2>