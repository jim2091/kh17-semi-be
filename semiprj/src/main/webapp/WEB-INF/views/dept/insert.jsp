<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"/>
<jsp:include page="/WEB-INF/views/template/side_home2.jsp"/>

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
        
	    if(valid) {
	        $(this).removeClass("success fail"); 
	        $(".deptHeadId-wrapper .fail-feedback").hide();
	    }
	    else{
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
    $(".form-check").on("submit", function(){
        state.deptHeadIdValid = $("input[name=messageReceiver]").length > 0;
        $("[name=deptHeadIdKeyword]").trigger("check");
        $("[name=parentDeptId]").trigger("change");
        $("[name=deptName]").trigger("input");
        $("[name=deptContent]").trigger("blur");
        return state.ok();
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
			            <div class="success-feedback">사용 가능한 부서명입니다.</div>
			            <div class="fail-feedback">이미 등록되었거나 올바르지 않은 이름입니다.</div>
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
					               placeholder="사원 이름으로 검색하세요">
					        <button type="button" class="gw-btn-outline open-search" style="height:46px; padding:0 18px;">
					            <i class="fa-solid fa-user-tie"></i> 찾기
					        </button>
					    </div>
					    <div class="fail-feedback" style="display:none;">부서장을 선택해 주세요.</div>
					    
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
