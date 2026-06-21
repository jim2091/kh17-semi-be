<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"/>

<style>

	.receiver-list{
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

</style>
	
<script>

$(function(){
    var state = {
        parentDeptIdValid : false,
        deptNameValid     : false,
        deptHeadIdValid   : false,
        deptContentValid  : true,
        ok : function() {
            return Object.values(this)
                .filter(v => typeof v === "boolean")
                .every(v => v === true);
        }
    };
	
    setTimeout(function(){
        if ($("input[name=messageReceiver]").length > 0) {
            $("[name=deptHeadIdKeyword]").trigger("check");
        }
    }, 50);
    
    /* 상위 부서 */
    $("[name=parentDeptId]").on("change input", function(){
        var valid = $(this).val().length > 0;
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.parentDeptIdValid = valid;
    });

    /* 부서명 중복 검사 */
    $("[name=deptName]").on("input", function(){
        var deptName = $(this).val();
        var valid = deptName.length > 0;
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.deptNameValid = valid;
        if (!valid) return;

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

    /* 부서장 검사 */
    $("[name=deptHeadIdKeyword]").on("input change check", function(){
        var valid = $("input[name=messageReceiver]").length > 0;
        
        // 상위 분류, 부서명과 동일하게 success / fail 클래스 부여 방식으로 통일
        if(valid) {
            $(this).removeClass("fail").addClass("success"); 
            $(".deptHeadId-wrapper .fail-feedback").hide();
            // 필요 시 성공 메시지 노출 원하면 .show() 처리
        }
        else {
            $(this).removeClass("success").addClass("fail"); 
            $(".deptHeadId-wrapper .fail-feedback").show();
        }
    
        state.deptHeadIdValid = valid;
    });

    /* 자동완성 */
    $("[name=deptHeadIdKeyword]").on("keyup", function(){
        var keyword = $(this).val();
        
        if (keyword.length < 1){ 
            $(".deptHeadId").empty();
            return; 
        }

        $.ajax({
            url    : "http://localhost:8080/dept/searchEmp",
            method : "get",
            data   : { keyword : keyword },
            success: function(response){
                $(".deptHeadId").empty();
                
                $.each(response, function(index, emp){
                    var div = $("<div>");
                    div.addClass("deptHeadId-item");

                    div.text(
                        emp.empName + " (" + (emp.empDeptName || "소속없음") + ")"
                    );

                    div.click(function(){
                        selectHead(emp);

                        $("[name=deptHeadIdKeyword]").val("");
                        $(".deptHeadId").empty();

                        state.deptHeadIdValid = true;
                        $("[name=deptHeadIdKeyword]").trigger("check");
                    });

                    $(".deptHeadId").append(div);
                });
            }
        });
    });

    function selectHead(emp){
        var html = "";
        html += "<span class='receiver-tag'>";
        html += emp.empName + " (" + (emp.empDeptName || "소속없음") + ")";
        html += "<button type='button' class='delete-tag'>";
        html += "✕";
        html += "</button>";
        html += "<input type='hidden' ";
        html += "name='messageReceiver' ";
        html += "value='" + emp.empNo + "'>";
        html += "</span>";

        // 부서장은 1명만
        $(".receiver-selected-list").html(html);
    }
    //피커 안에서 다중 선택 차단
    $(document).on("click", ".emp-check", function(e) {
        var pickerMode = $("#pickerMode").val();
        if (pickerMode === "single" && $(this).is(":checked")) {
            // 내가 방금 체크한 것 외에 모달 안의 다른 체크박스는 전부 해제
            $(".emp-check").not(this).prop("checked", false);
            // 선택 리스트가 모달 내부에 동적으로 쌓이고 있다면 그것도 초기화
            $(".selected-list").empty(); 
        }
    });
    /* 모달 확인 */
    $(document).on("click", ".confirm-btn", function(){
        // 바깥 선택 리스트 비우기
        $(".receiver-selected-list").empty();
        
        var checked = $(".emp-check:checked");
        if(checked.length === 0) {
            state.deptHeadIdValid = false;
            $("[name=deptHeadIdKeyword]").trigger("check");
            $(".modal-overlay").hide();
            return;
        }
        
        // 부서장은 1명만 필요하므로 체크된 것 중 첫 번째 사원만 선택
        var first = checked.first();
        var tr = first.closest("tr");
        
        selectHead({
            empNo      : first.data("no"),
            empName    : first.data("name"),
            empDeptName: tr.find("td").eq(4).text().trim()
        });
        
        // 유효성 갱신 및 모달 닫기
        state.deptHeadIdValid = true;
        $("[name=deptHeadIdKeyword]").trigger("check");
        
        $(".modal-overlay").hide();
    });

    /* 모달 상단 selected-item 삭제 - edit 전용 */
    $(document).on("click", ".selected-remove", function(){
        var target = $(this).closest(".selected-item");
        var empNo = target.data("no");

        // 모달 안 체크박스 해제
        $(".emp-check[data-no='" + empNo + "']").prop("checked", false);
        target.remove();

        // 선택 인원 수 업데이트
        $(".selected-count").text($(".selected-item").length);
    });

    // 태그 삭제 (바깥 x 버튼 클릭 시)
    $(".receiver-selected-list").on("click", ".delete-tag", function(){
        $(this).closest(".receiver-tag").remove();
        state.deptHeadIdValid = false;
        $("[name=deptHeadIdKeyword]").trigger("check");
    });

    /* 업무내용 */
    $("[name=deptContent]").on("blur", function(){
        state.deptContentValid = true;
        if ($(this).val().length > 0) $(this).removeClass("success fail").addClass("success");
    });

    /* 제출 */
    $(".form-check").on("submit", function(e){
        // 1. 부서장 체크 및 일반 필드 유효성 다시 갱신
        state.deptHeadIdValid = $("input[name=messageReceiver]").length > 0;
        $("[name=deptHeadIdKeyword]").trigger("check");
        
        var parentValid = $("[name=parentDeptId]").val().length > 0;
        $("[name=parentDeptId]").removeClass("success fail").addClass(parentValid ? "success" : "fail");
        state.parentDeptIdValid = parentValid;

        // 만약 비어있다면 대처
        if($("[name=deptName]").val().length === 0) {
            state.deptNameValid = false;
            $("[name=deptName]").removeClass("success fail").addClass("fail");
        }

        // 2. 최종 검사
        if (!state.ok()) {
            alert("입력 항목을 다시 확인해 주세요.");
            
            // 유효하지 않은 첫 번째 항목으로 포커스 이동
            if(!state.parentDeptIdValid) $("[name=parentDeptId]").focus();
            else if(!state.deptNameValid) $("[name=deptName]").focus();
            else if(!state.deptHeadIdValid) $("[name=deptHeadIdKeyword]").focus();
            
            return false; // 서버 전송 막기
        }
        
        return true; // 전송 허용
    });
});
</script>
		<div class="dept-screen">
			<!-- ── 페이지 헤더 ── -->
			<div class="gw-page-head">
				<div class="gw-breadcrumb">
			        부서 > 등록
			    </div>
			    <h1>부서 신규 등록</h1>
			    <p>회사의 조직 체계에 맞춰 새로운 부서 정보를 생성합니다.</p>
			</div>

			<!-- ── 등록 폼 ── -->
			<form action="./insert" method="post" autocomplete="off" class="form-check" style="max-width:1100px">
			<input type="hidden" id="pickerMode" value="single">
			    <div class="gw-form-panel">
			
			        <!-- 상위 부서 -->
			        <div class="gw-form-row">
			            <label class="gw-form-label">
			                상위 부서 분류 <span class="required">*</span>
			            </label>
			            <select name="parentDeptId" class="field gw-form-select w-100">
			                <option value="">부서를 선택하세요</option>
			                <option value="0">최상위 부서 추가 (독립 조직)</option>
			                <c:forEach var="deptDto" items="${deptList}">
			                    <option value="${deptDto.deptId}">${deptDto.deptName}</option>
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
			                   placeholder="생성할 부서 이름을 입력하세요">
			            <div class="success-feedback"></div>
			            <div class="fail-feedback">이미 등록되었거나 올바르지 않은 이름입니다.</div>
			        </div>
			
			        <!-- 부서장 -->
			        <div class="gw-form-row deptHeadId-wrapper">
					    <label class="gw-form-label">
					        부서장 <span class="required">*</span>
					    </label>
					    
					    <div style="display:flex; gap:10px; align-items:center; width:100%;">
					        <input type="text" name="deptHeadIdKeyword"
					               class="field gw-form-input"
					               style="flex:1;"
					               placeholder="사원 이름으로 검색하세요">
					        <button type="button" class="gw-btn-outline open-search" style="height:46px; padding:0 18px;">
					            <i class="fa-solid fa-user-tie"></i> 찾기
					        </button>
					    </div>
					
					    <div class="success-feedback"></div>
					    <div class="fail-feedback">부서장을 선택해 주세요.</div>
					    
					    <div class="receiver-list receiver-selected-list mt-10">
					        <c:if test="${deptHeadEmp != null}">
					            <span class="receiver-tag">
					                ${deptHeadEmp.empName}
					                (${deptHeadEmp.empDeptName != null ? deptHeadEmp.empDeptName : '소속없음'})
					                <button type="button" class="delete-tag">✕</button>
					                <input type="hidden" name="messageReceiver" value="${deptHeadEmp.empNo}">
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
			                   placeholder="해당 부서의 주 업무 및 담당 역할을 기재하세요">
			            <div class="gw-form-help">선택 항목입니다. 부서의 역할을 간략히 설명해 주세요.</div>
			        </div>
				</div>
			        <!-- 액션 버튼 -->
			        <div class="gw-form-actions">
			            <a href="./list" class="gw-btn-outline">
			                <i class="fa-solid fa-arrow-left"></i> 목록으로
			            </a>
			            <button type="submit" class="gw-btn-primary">
			                <i class="fa-solid fa-check"></i> 신규 부서 등록
			            </button>
			        </div>
			
			    </div>
			</form>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/template/footer2.jsp"/>
