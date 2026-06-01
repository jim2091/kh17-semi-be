<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-600 mt-20 mb-20">
    <div class="cell center">
        <h1>로그인</h1>
    </div>
    <form action="./login" method="post" autocomplete="off">
        <div class="cell">
            <div>아이디</div>
            <input type="text" name="empId" required class="field">
        </div>
        <div class="cell">
            <div>비밀번호</div>
            <input type="password" name="empPw" required class="field">
        </div>
        <div class="cell red">
            <c:if test="${param.error != null}">
                입력한 정보가 일치하지 않습니다
            </c:if>
        </div>
        <div class="cell right">
            <button type="submit" class="btn btn-positive">로그인</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>