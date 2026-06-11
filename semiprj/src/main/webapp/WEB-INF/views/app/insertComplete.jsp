<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<div style="padding:30px; display:flex; justify-content:center; align-items:center; min-height:70vh;">
    <div style="background:white; border-radius:16px;
                box-shadow:0 4px 20px rgba(0,0,0,0.08);
                padding:60px 80px; text-align:center; max-width:480px; width:100%;">

        <%-- 체크 아이콘 --%>
        <div style="width:80px; height:80px; border-radius:50%;
                    background:var(--main-color); margin:0 auto 24px;
                    display:flex; align-items:center; justify-content:center;">
            <i class="fa-solid fa-check" style="font-size:36px; color:white;"></i>
        </div>

        <%-- 타이틀 --%>
        <h2 style="margin:0 0 12px 0; font-size:22px; font-weight:700; color:#222;">
            결재 전송이 완료되었습니다!
        </h2>

        <%-- 서브 텍스트 --%>
        <p style="margin:0 0 40px 0; font-size:14px; color:#888; line-height:1.6;">
            담당 결재자에게 문서가 전달되었습니다.<br>
            결재 진행 상황은 문서 목록에서 확인하실 수 있습니다.
        </p>

        <%-- 버튼 그룹 --%>
        <div style="display:flex; gap:12px; justify-content:center;">
            <a href="./list"
               style="padding:12px 24px; background:#f0f0f0; color:#333;
                      border-radius:8px; text-decoration:none; font-size:14px;
                      font-weight:600; display:flex; align-items:center; gap:8px;">
                <i class="fa-solid fa-list"></i> 문서 목록
            </a>
            <a href="./vacInsert"
               style="padding:12px 24px; background:var(--main-color); color:white;
                      border-radius:8px; text-decoration:none; font-size:14px;
                      font-weight:600; display:flex; align-items:center; gap:8px;">
                <i class="fa-solid fa-file-arrow-up"></i> 새 문서 작성
            </a>
        </div>

        <%-- 새 문서 작성 드롭다운 --%>
        <div style="margin-top:16px; display:flex; gap:8px; justify-content:center;">
            <a href="./vacInsert"
               style="padding:8px 16px; border:1px solid var(--main-color);
                      color:var(--main-color); border-radius:6px;
                      text-decoration:none; font-size:13px;">
                휴가신청서
            </a>
            <a href="./expInsert"
               style="padding:8px 16px; border:1px solid var(--main-color);
                      color:var(--main-color); border-radius:6px;
                      text-decoration:none; font-size:13px;">
                품의서
            </a>
            <a href="./dftInsert"
               style="padding:8px 16px; border:1px solid var(--main-color);
                      color:var(--main-color); border-radius:6px;
                      text-decoration:none; font-size:13px;">
                업무기안서
            </a>
        </div>
    </div>
</div>

<script>
$(function(){
    var savedTheme = localStorage.getItem("gwTheme");

    if(savedTheme){
        $("body").addClass(savedTheme);
    }
    else{
        $("body").addClass("theme-blue");
    }

    $(".theme-btn").click(function(){
        $(".theme-popup").toggle();
    });

    $(".theme-item").click(function(){
        var theme = $(this).data("theme");

        $("body")
            .removeClass("theme-blue theme-green theme-purple theme-dark")
            .addClass(theme);

        localStorage.setItem("gwTheme", theme);

        $(".theme-popup").hide();
    });

    $(".check-all").change(function(){
        $("input[name=pdsNoList]").prop("checked", this.checked);
    });

    $("input[name=pdsNoList]").change(function(){
        $(".check-all").prop("checked",
            $("input[name=pdsNoList]").length == $("input[name=pdsNoList]:checked").length
        );
    });
});
</script>