<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/admin_attn_side_home.jsp"></jsp:include>

<style>
    .search-box { background: #f9f9f9; padding: 20px; border-radius: 8px; margin-bottom: 20px; display: flex; gap: 10px; align-items: center; }
    .pagination { display: flex; justify-content: center; align-items: center; gap: 5px; margin-top: 40px; }
    .page-box { width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; text-decoration: none; color: #333; border: 1px solid #ddd; }
    .page-box.active { border: 1px solid #000; font-weight: bold; background-color: #f9f9f9; }
</style>

<div class="attn-content-body" style="flex-grow: 1; padding-left: 40px; font-family: 'Malgun Gothic', sans-serif;">
    <h1 style="border-bottom: 2px solid #333; padding-bottom: 10px;">관리자 근태 조회</h1>

    <form action="/admin/attn/manage" method="get" class="search-box">
        <input type="text" name="deptCode" placeholder="부서코드" value="${search.deptCode}" style="padding: 8px;">
        <input type="text" name="positionCode" placeholder="직위코드" value="${search.positionCode}" style="padding: 8px;">
        <input type="text" name="empName" placeholder="직원명" value="${search.empName}" style="padding: 8px;">
        <button type="submit" style="padding: 8px 20px; cursor: pointer;">조회</button>
    </form>

    <table style="width:100%; border-collapse: collapse; text-align: center;">
        <thead>
            <tr style="border-bottom: 2px solid #ddd;">
                <th style="padding: 12px;">사번</th>
                <th style="padding: 12px;">직원명</th>
                <th style="padding: 12px;">날짜</th>
                <th style="padding: 12px;">근로시간</th>
                <th style="padding: 12px;">상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty attnList}">
                    <tr><td colspan="5" style="padding: 40px;">조회된 데이터 없음</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="dto" items="${attnList}">
                        <tr style="border-bottom: 1px solid #eee;">
                            <td style="padding: 12px;">${dto.empNo}</td>
                            <td style="padding: 12px;">${dto.empName}</td>
                            <td style="padding: 12px;"><fmt:formatDate value="${dto.attnWorkDate}" pattern="yyyy-MM-dd"/></td>
                            <td style="padding: 12px;">${dto.attnWorkTime}h</td>
                            <td style="padding: 12px;">${dto.attnStatus}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="pagination">
        <c:set var="query" value="deptCode=${search.deptCode}&positionCode=${search.positionCode}&empName=${search.empName}" />
        
        <c:if test="${pageVO.hasPrevious()}">
            <a href="/admin/attn/manage?page=${pageVO.previousBlock}&${query}" class="page-box">◀</a>
        </c:if>
        <c:forEach var="i" begin="${pageVO.beginBlock}" end="${pageVO.endBlock}">
            <a href="/admin/attn/manage?page=${i}&${query}" class="page-box ${i == pageVO.page ? 'active' : ''}">${i}</a>
        </c:forEach>
        <c:if test="${pageVO.hasNext()}">
            <a href="/admin/attn/manage?page=${pageVO.nextBlock}&${query}" class="page-box">▶</a>
        </c:if>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>