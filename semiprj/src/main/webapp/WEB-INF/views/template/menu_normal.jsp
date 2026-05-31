<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 비회원일 때 보여줄 메뉴 -->
<ul class="menu">
	<li>
	    <a href="/">
	        <i class="fa-solid fa-house"></i>
	        <span>홈</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <i class="fa-solid fa-database"></i>
	        <span>데이터</span>
		</a>
        <!-- 하위 메뉴 -->
        <ul>
            <li>
                <a href="/country/list">
                    <i class="fa-solid fa-flag"></i>
                    <span>국가정보</span>
                </a>
            </li>
            <li>
                <a href="/lecture/list">
                    <i class="fa-solid fa-chalkboard-user"></i>
                    <span>강좌정보</span>
                </a>
            </li>
        </ul>
	</li>
	<li>
	    <a href="/board/list">
	        <i class="fa-solid fa-comments"></i>
	        <span>게시판</span>
	    </a>
	</li>
	
	<li class="divider"></li>
	
	<li>
	    <a href="/member/login">
	        <i class="fa-solid fa-right-to-bracket"></i>
	        <span>로그인</span>
	    </a>
	    <!-- 하위메뉴 -->
        <ul>
            <li>
                <a href="/member/join">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>회원가입</span>
                </a>
            </li>
        </ul>
    </li>
</ul>