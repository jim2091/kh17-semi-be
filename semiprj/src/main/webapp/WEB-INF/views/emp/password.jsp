<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>




<h1>비밀번호 입력</h1>
비밀번호 변경을 위해 기존 비밀번호를 한번 더 입력하고 신규 비밀번호를 입력해주세요
<form action="./password" method="post">
기존 비밀번호 입력<input type="password" name="originPw"><br>
변경할 비밀번호 입력<input type="password" name="changePw"><br>
<button>변경하기</button>
</form>

<c:if test="${param.error != null}" >
		비밀번호가 불일치하거나 동일한 값으로 변경할 수 없습니다
</c:if>




<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>