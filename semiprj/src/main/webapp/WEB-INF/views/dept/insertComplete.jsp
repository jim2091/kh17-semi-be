<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"/>
<jsp:include page="/WEB-INF/views/template/side_home2.jsp"/>

<div style="display:flex; flex-direction:column; align-items:center; justify-content:center; min-height:60vh; gap:20px; text-align:center;">

    <!-- 아이콘 -->
    <div style="width:72px; height:72px; border-radius:50%; background:var(--main-light); color:var(--success-color); display:flex; align-items:center; justify-content:center; font-size:32px;">
        <i class="fa-solid fa-check"></i>
    </div>

    <!-- 메시지 -->
    <div style="display:flex; flex-direction:column; gap:8px;">
        <h2 style="margin:0; font-size:24px; font-weight:900; color:var(--card-title-color);">부서 등록이 완료되었습니다</h2>
        <p style="margin:0; font-size:15px; color:var(--sub-text);">새로운 부서가 조직 체계에 성공적으로 추가되었습니다.</p>
    </div>

    <!-- 버튼 -->
    <div style="display:flex; gap:12px; margin-top:8px;">
        <a href="./insert" class="gw-btn-outline">
            <i class="fa-solid fa-plus"></i> 추가 등록
        </a>
        <a href="./list" class="gw-btn-primary">
            <i class="fa-solid fa-list"></i> 목록으로
        </a>
    </div>

</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"/>
