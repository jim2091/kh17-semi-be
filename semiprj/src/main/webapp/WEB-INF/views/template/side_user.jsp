<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                    <div class="container w-100 mt-10 side-area center cell flex-fill">
                    <c:if test="${sessionScope.loginId != null && sessionScope.loginRole != null}">
                    	 <div class="cell">[${sessionScope.loginRole}]님</div>
                    	 <c:if test="${sessionScope.loginRole == '관리자'}">
                    	 <div class="cell">
                    	 	<a href="/admin/register">사용자 등록하기</a>
                    	 </div>
                    	 <div class="cell">
                    	 	<a href="/admin/list">직원 목록 및 검색</a>
                    	 </div>
                    	 <div class="cell">
                    	 	<a href="/admin/waitingList">대기 사용자 목록</a>
                    	 </div>
                    	 </c:if>
                    	 <c:if test="${sessionScope.loginRole != '관리자'}">
                    	 <div class="cell">
                    	 	<a href="/emp/list">직원 목록 및 검색</a>
                    	 </div>
                    	 <div class="cell">
                    	  	<a href="/emp/mypage">마이페이지</a>
                    	 </div>
                    	 </c:if>
                    </c:if>	 
                    </div>
                    
                </div>
				<div class="w-200 flex-fill">