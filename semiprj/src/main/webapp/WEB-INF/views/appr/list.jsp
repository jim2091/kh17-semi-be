<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<div class="container w-900 mt-50 mb-50">
    <div class="cell center">
        <h1 class="mt-0 mb-0">결재 목록</h1>
    </div>

    <div class="cell">
        <table class="table">
            <thead>
                <tr>
                    <th>문서종류</th>
                    <th>문서명</th>
                    <th>기안자</th>
                    <th>기안일</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="line" items="${list}">
                    <tr style="cursor:pointer;"
                        onclick="location.href='/appr/detail?appId=${line.appId}'">
                        <td>${line.appLineType}</td>
                        <td>${line.appTitle}</td>
                        <td>${line.empName}</td>
                        <td>${line.appDate}</td>
                        <td><span style="color:orange;">진행중</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="5" class="center">결재할 문서가 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>