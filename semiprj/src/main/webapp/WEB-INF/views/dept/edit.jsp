<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"/>

<style>
	
	.receiver-selected-list{
	    margin-top: 10px;
	    display: flex;
	    flex-wrap: wrap;
	    gap: 8px;
	}
	
	.receiver-tag{
	    display: inline-flex;
	    align-items: center;
	    gap: 6px;
	
	    padding: 6px 12px;
	
	    border: 1px solid #d9d9d9;
	    border-radius: 999px;
	
	    background-color: #f5f7fa;
	
	    font-size: 14px;
	}
	
	.receiver-tag .delete-tag{
	    border: none;
	    background: transparent;
	    cursor: pointer;
	
	    color: #999;
	    font-size: 14px;
	    padding: 0;
	}
	
	.receiver-tag .delete-tag:hover{
	    color: #e74c3c;
	}

	.screen{
		width:800px;
    	margin:0 auto;
	}
</style>


<script>
$(function(){
    var state = {
        parentDeptIdValid : true,
        deptNameValid     : true,
        deptHeadIdValid   : false,
        deptContentValid  : true,
        ok : function() {
            return Object.values(this)
                .filter(v => typeof v === "boolean")
                .every(v => v === true);
        }
    };

    // 초기 진입 시 이미 등록된 부서장이 있다면 검증 통과 처리
    setTimeout(function(){
        if ($("input[name=messageReceiver]").length > 0) {
            state.deptHeadIdValid = true; // 강제 트리거 대신 상태만 true로 설정
        }
    }, 50);
    
    /* 픽커 내 다중 선택 원천 차단 (클릭 순간 개입) */
    $(document).on("click", ".emp-check", function(e) {
        var pickerMode = $("#pickerMode").val();
        if (pickerMode === "single" && $(this).is(":checked")) {
            // 내가 방금 체크한 것 외에 모달 안의 다른 체크박스는 전부 해제
            $(".emp-check").not(this).prop("checked", false);
            // 선택 리스트가 모달 내부에 동적으로 쌓이고 있다면 그것도 1개로 유지되도록 초기화
            $(".selected-list").empty(); 
        }
    });

    /* 상위 부서 검사 */
    $("[name=parentDeptId]").on("change input", function(){
        var valid = $(this).val().length > 0;
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.parentDeptIdValid = valid;
    });

    /* 부서명 중복 검사 */
    var originalDeptName = "${deptDto.deptName}";
    $("[name=deptName]").on("input", function(){
        var deptName = $(this).val();
        var valid = deptName.length > 0;
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.deptNameValid = valid;
        if (!valid) return;

        if (deptName === originalDeptName) {
            state.deptNameValid = true;
            return;
        }

        $.ajax({
            url    : "http://localhost:8080/rest/dept/validName",
            method : "post",
            data   : { deptName : deptName },
            success: function(response){
                var ok = response === true;
                $("[name=deptName]").removeClass("success fail").addClass(ok ? "success" : "fail");
                state.deptNameValid = ok;
            }
        });
    });

    /* 부서장 검사 검증식 */
    $("[name=deptHeadIdKeyword]").on("input change check", function(){
        // 화면에 messageReceiver(사원번호 hidden input)가 존재하는지 체크
        var valid = $("input[name=messageReceiver]").length > 0;
    
        if(valid) {
            // 다른 입력 필드와 동일하게 테두리 스타일을 success로 변경하고 fail 메시지 숨김
            $(this).removeClass("fail").addClass("success"); 
            $(".deptHeadId-wrapper .fail-feedback").hide();
        }
        else{
            // 값이 없으면 테두리를 fail로 변경하고 fail 메시지 표시
            $(this).removeClass("success").addClass("fail"); 
            $(".deptHeadId-wrapper .fail-feedback").show();
        }
    
        // 가장 중요한 state 변수 갱신 (초기 진입 시 false -> true로 전환됨)
        state.deptHeadIdValid = valid;
    });

    /* 자동완성 검색 기능 */
    $("[name=deptHeadIdKeyword]").on("keyup", function(){
        var keyword = $(this).val();
        if(keyword.length < 1){ $(".deptHeadId").empty(); return; }
    
        $.ajax({
            url    : "http://localhost:8080/dept/searchEmp",
            method : "get",
            data   : { keyword : keyword },
            success: function(response){
                $(".deptHeadId").empty();
                $.each(response, function(index, emp){
                    var div = $("<div>");
                    div.addClass("deptHeadId-item");
                    div.text(emp.empName + " (" + (emp.empDeptName || "소속없음") + ")");
    
                    div.click(function(){
                        $(".receiver-selected-list").empty(); // 기존 선택 초기화
    
                        var html = "";
                        html += "<span class='receiver-tag'>";
                        html += emp.empName + " (" + (emp.empDeptName || "소속없음") + ")";
                        html += "<button type='button' class='delete-tag'>✕</button>";
                        html += "<input type='hidden' name='messageReceiver' value='" + emp.empNo + "'>";
                        html += "</span>";
    
                        $(".receiver-selected-list").append(html);
                        $("[name=deptHeadIdKeyword]").val("");
                        $(".deptHeadId").empty();
                        
                        $("[name=deptHeadIdKeyword]").trigger("check");
                    });
    
                    $(".deptHeadId").append(div);
                });
            }
        });
    });

    /* 모달 확인 버튼 반영 */
    $(document).on("click", ".confirm-btn", function(){
        var checked = $(".emp-check:checked");
        
        if(checked.length === 0) {
            $(".modal-overlay").hide();
            return;
        }
        
        var first = checked.first();
        var tr = first.closest("tr");
        
        var empNo       = first.data("no");
        var empName     = first.data("name");
        var empDeptName = tr.find("td").eq(4).text().trim(); 

        // 부서화면 최종 반영 대상 리스트 초기화 (1명만 남기기)
        $(".receiver-selected-list").empty();
        
        var html = "";
        html += "<span class='receiver-tag'>";
        html += empName + " (" + (empDeptName || "소속없음") + ")";
        html += "<button type='button' class='delete-tag'>✕</button>";
        html += "<input type='hidden' name='messageReceiver' value='" + empNo + "'>";
        html += "</span>";

        $(".receiver-selected-list").append(html);
        
        $("[name=deptHeadIdKeyword]").trigger("check");
        
        // 체크박스 상태 초기화 후 닫기
        $(".emp-check").prop("checked", false);
        $(".modal-overlay").hide();
    });
    
    /* 모달 상단 selected-item 삭제 */
    $(document).on("click", ".selected-remove", function(){
        var target = $(this).closest(".selected-item");
        var empNo = target.data("no");

        $(".emp-check[data-no='" + empNo + "']").prop("checked", false);
        target.remove();
        $(".selected-count").text($(".selected-item").length);
    });

    /* 태그 삭제 버튼 */
    $(".receiver-selected-list").on("click", ".delete-tag", function(){
        $(this).closest(".receiver-tag").remove();
        $("[name=deptHeadIdKeyword]").trigger("check"); 
    });

    /* 업무내용 검증 */
    $("[name=deptContent]").on("blur", function(){
        state.deptContentValid = true;
        if ($(this).val().length > 0) $(this).removeClass("success fail").addClass("success");
    });

    /* 서브밋 제어 */
    $(".form-check").on("submit", function(){
        if (!state.parentDeptIdValid) $("[name=parentDeptId]").addClass("fail");
        if (!state.deptNameValid)     $("[name=deptName]").addClass("fail");
        if (!state.deptHeadIdValid)   $("[name=deptHeadIdKeyword]").addClass("fail");

        if(!state.ok()) {
            alert("입력하신 항목 중 형식에 맞지 않거나 누락된 필수 항목이 있습니다.");
            $(".field.fail").first().trigger("focus"); 
            return false;
        }
        return true;
    });
}); // <--- 중복 마무리 태그 정리 완료
</script>
		<div class="screen">
			<!-- ── 페이지 헤더 ── -->
			<div class="gw-page-head">
				<div class="gw-breadcrumb">
			        부서 > 상세 > 수정
			    </div>
			    <h1>부서 정보 수정</h1>
			    <p>기존 부서 정보를 변경합니다.</p>
			</div>


<!-- ── 수정 폼 ── -->
<form action="./edit" method="post" autocomplete="off" class="form-check" style="max-width:800px;">
    <input type="hidden" id="pickerMode" value="single">
    <input type="hidden" name="deptId" value="${deptDto.deptId}">

    <div class="gw-form-panel">

        <!-- 상위 부서 -->
        <div class="gw-form-row">
            <label class="gw-form-label">
                상위 부서 분류 <span class="required">*</span>
            </label>
            <select name="parentDeptId" class="field gw-form-select w-100">
                <option value="">선택하세요</option>
                <option value="0" ${deptDto.parentDeptId == 0 ? 'selected' : ''}>최상위 부서 (독립 조직)</option>
                <c:forEach var="dept" items="${deptList}">
                    <c:if test="${dept.deptId != deptDto.deptId}">
                        <option value="${dept.deptId}" ${deptDto.parentDeptId == dept.deptId ? 'selected' : ''}>
                            ${dept.deptName}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
            <div class="fail-feedback">상위 분류를 선택해 주세요.</div>
        </div>

        <!-- 부서명 -->
        <div class="gw-form-row">
            <label class="gw-form-label">
                부서명 <span class="required">*</span>
            </label>
            <input type="text" name="deptName"
                   class="field gw-form-input full"
                   value="${deptDto.deptName}">
            <div class="success-feedback"></div>
            <div class="fail-feedback">이미 존재하는 부서명입니다.</div>
        </div>

<!-- 부서장 -->
	<label class="gw-form-label">
	    부서장 <span class="required">*</span>
	</label>
	<div class="gw-form-row deptHeadId-wrapper">
	    <div style="display:flex; gap:10px; align-items:center;">
	        <input type="text" name="deptHeadIdKeyword"
	               class="field gw-form-input"
	               style="flex:1;"
	               placeholder="변경할 사원 이름을 입력하세요">
	        <button type="button" class="gw-btn-outline open-search" style="height:46px; padding:0 18px;">
	            <i class="fa-solid fa-user-tie"></i> 찾기
	        </button>
	    </div>
	    <div class="fail-feedback" style="display:none;">부서장을 선택해 주세요.</div>
	
	    <div class="receiver-list receiver-selected-list mt-10">
    <c:if test="${deptDto.deptHeadId != null && deptDto.deptHeadId != 0}">
        <span class="receiver-tag">
            ${deptDto.deptHeadName != null ? deptDto.deptHeadName : '기존 부서장'} 
            
            <button type="button" class="delete-tag">✕</button>
            <input type="hidden" name="messageReceiver" value="${deptDto.deptHeadId}">
        </span>
    </c:if>
</div>
	    <div class="deptHeadId"></div>
	
	    <jsp:include page="/WEB-INF/views/template/employee-picker.jsp"/>
	    <script src="/js/employee-picker.js"></script>
	</div>
        <!-- 주요 업무 -->
        <div class="gw-form-row">
            <label class="gw-form-label">주요 업무 내용</label>
            <input type="text" name="deptContent"
                   class="gw-form-input full"
                   value="${deptDto.deptContent}"
                   placeholder="해당 부서의 주 업무 및 담당 역할을 기재하세요">
            <div class="gw-form-help">선택 항목입니다.</div>
        </div>

        <!-- 액션 버튼 -->
        <div class="gw-form-actions">
            <a href="./list" class="gw-btn-outline">
                <i class="fa-solid fa-arrow-left"></i> 목록으로
            </a>
            <button type="submit" class="gw-btn-primary">
                <i class="fa-solid fa-pen"></i> 수정 완료
            </button>
        </div>

    </div>
</form>
</div>
<jsp:include page="/WEB-INF/views/template/footer2.jsp"/>
