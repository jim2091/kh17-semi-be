<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<div class="container w-400 mt-20 mb-20">
    <div class="cell center mt-40">
        비밀번호가 변경되었습니다
    </div>
    <div class="cell center mt-40">
		로그인하러 가시겠습니까?
    </div>

   	<div class="cell center">
    	<a href="./login" class="btn btn-neutral">로그인하러 가기</a>
    </div>

    </div>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>