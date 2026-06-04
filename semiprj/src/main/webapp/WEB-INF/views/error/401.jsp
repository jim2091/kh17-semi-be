<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>    


<h1>${message == null ? "로그인 후 이용 가능합니다" : message}</h1>
<a href="/emp/login">로그인하기</a>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>