<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>

<h2>내 결재 목록</h2>

<table>
  <thead>
    <tr>
      <th>문서제목</th>
      <th>문서유형</th>
      <th>기안자</th>
      <th>기안일</th>
      <th>상태</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="item" items="${myList}">
      <tr>
        <td>${item.appTitle}</td>
        <td>${item.appType}</td>
        <td>${item.empName}</td>
        <td>${item.appDate}</td>
        <td>${item.appLineStatus}</td>
        <td>
          <a href="/appr/detail/${item.appId}">결재하기</a>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty myList}">
      <tr>
        <td colspan="6">결재 대기 중인 문서가 없습니다.</td>
      </tr>
    </c:if>
  </tbody>
</table>>