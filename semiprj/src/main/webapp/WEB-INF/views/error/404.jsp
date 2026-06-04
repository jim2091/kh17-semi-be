<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>    


<h1>${message == null ? "존재하지 않는 대상입니다" : message}</h1>
<a href="/">홈으로</a>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>