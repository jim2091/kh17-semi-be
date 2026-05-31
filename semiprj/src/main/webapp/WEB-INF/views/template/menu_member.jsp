<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 관리자가 아닌 회원일 때 보여줄 메뉴 -->
<ul class="menu">
	<li>
	    <a href="/">
	        <i class="fa-solid fa-house"></i>
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
                    <span>전자결재</span>
                </a>
            </li>
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
	    <a href="#">
	        <span>게시판</span>
	    </a>
	     <!-- 하위 메뉴 -->
        <ul>
            <li>
                <a href="#">
                    <span>전자결재</span>
                </a>
            </li>
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
	
	<li class="divider"></li>
	
	<li>
	    <a href="/member/mypage">
	        <i class="fa-solid fa-user"></i>
	        <span>내정보</span>
	    </a>
	    <!-- 하위메뉴 -->
        <ul>
            <li>
                <a href="/member/logout">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <span>로그아웃</span>
                </a>
            </li>
        </ul>
    </li>
</ul>