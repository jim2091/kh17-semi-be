<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 비회원일 때 보여줄 메뉴 -->
<ul class="menu">
	<li>
	    <a href="/">
	        <span>홈</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <span>전자결재</span>
		</a>
	</li>
	<li>
	    <a href="/board/list">
	        <span>게시판</span>
		</a>
	</li>
	<li>
	    <a href="/admin/list">
	        <span>직원관리</span>
	    </a>
	    <ul>
            <li>
                <a href="/admin/register">
                    <span>사원등록</span>
                </a>
            </li>
            <li>
                <a href="/admin/waitingList">
                    <span>대기사원목록</span>
                </a>
            </li>
        </ul>
	</li>
	<li>
	    <a href="/dept/list">
	        <span>부서관리</span>
	    </a>
	</li>
	<li>
	    <a href="/attn/list">
	        <span>근태관리</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <span>기타관리</span>
	    </a>
	     <ul>
            <li>
                <a href="#">
                    <span>자리가 모자라서 일정/쪽지 일단 임시로 합쳐뒀어요</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <span>어떻게할지 고민해봅시다</span>
                </a>
            </li>
        </ul>
	</li>


	<li class="divider"></li>
	
	<li style="width: 50px;">
	    <a href="#">
	        <i class="fa-solid fa-paper-plane"></i>
	    </a>
	</li>
	<li style="width: 50px;">
	    <a href="#">
	        <i class="fa-solid fa-bell"></i>
	    </a>
	</li>
	<c:if test="${sessionScope.attnYn == false}">
	<li>
	    <a href="#">
	        <span>출근</span>
	    </a>
	</li>
	</c:if>
	<c:if test="${sessionScope.attYn == true}">
	<li>
	    <a href="#">
	        <span>퇴근</span>
	    </a>
	</li>
	</c:if>

	<li>
	    <a href="/emp/logout">
	        <span>로그아웃</span>
	    </a>
	</li>

</ul>