<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
        <!-- 하위 메뉴 -->
        <ul>
            <li>
                <a href="#">
                    <span>내 문서함</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <span>결재 문서함</span>
                </a>
            </li>
        </ul>
	</li>
	<li>
	    <a href="/board/list">
	        <span>게시판</span>
		</a>
	</li>
	<li>
	    <a href="#">
	        <span>직원목록</span>
	    </a>
	</li>
	<li>
	    <a href="/dept/list">
	        <span>부서목록</span>
	    </a>
	</li>
	<li>
	    <a href="/attn/list">
	        <span>근태관리</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <span>일정</span>
	    </a>
	</li>

	<li class="divider"></li>
	<li style="width: 50px;">
	    <a href="#">
	        <i class="fa-solid fa-paper-plane"></i>
	    </a>
	</li>
	<li>
	    <a href="/emp/login">
	        <span>로그인</span>
	    </a>
	</li>

</ul>