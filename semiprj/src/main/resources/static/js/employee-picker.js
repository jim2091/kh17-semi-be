// ===== 공통 함수 =====

function updateSelectedCount(){
    $(".selected-count").text(
        $(".selected-item").length
    );
}

// 모달 열때 바깥과 동기화 함수
function syncModalSelectedFromReceiver(){
    $(".selected-list").empty();

    $("input[name=messageReceiver]").each(function(){
        var empNo = $(this).val();
        // 부서 명칭 등이 괄호로 묶여있을 수 있으므로 안전하게 텍스트 추출 후 앞부분 사원명만 정제
        var rawText = $(this).closest(".receiver-tag").contents().first().text().trim();
        var empName = rawText.split("(")[0].trim(); 

        var html = "";
        html += "<div class='selected-item' data-no='" + empNo + "'>";
        html += empName;
        html += "<span class='selected-remove'>✕</span>";
        html += "</div>";

        $(".selected-list").append(html);
    });

    updateSelectedCount();
}

// ===== 모달 열기/닫기 =====
$(".open-search").click(function(){
    syncModalSelectedFromReceiver();
    $(".modal-overlay").css("display","flex");
    $(".keyword").focus();
});

$(".close-btn").click(function(){
    $(".modal-overlay").hide();
});

$(".cancel-btn").click(function(){
    $(".modal-overlay").hide();
});

// ===== 검색 =====
$(".search-emp-btn").click(function(){
    $.ajax({
        url : "/rest/emp/search",
        type : "get",
        data : {
            keyword : $(".keyword").val()
        },
        success : function(response){
            $(".emp-result-body").empty();
            
            for(var i = 0; i < response.length; i++){
                var emp = response[i];
                
                var checked = $("input[name=messageReceiver][value='" + emp.empNo + "']").length > 0
                           || $(".selected-item[data-no='" + emp.empNo + "']").length > 0;
                
                var html = "";
                html += "<tr>";
                html += "<td>";
                // pickerMode가 single이면 라디오 버튼처럼 보이도록 외형 처리를 위해 스타일이나 대안을 쓸 수 있지만, 
                // 원활한 구동을 위해 기존 체크박스 구조를 유지하되 스크립트로 제어합니다.
                html += "<input type='checkbox' class='emp-check' ";
                html += "data-no='" + emp.empNo + "' ";
                html += "data-name='" + emp.empName + "' ";
                html += "data-dept='" + (emp.empDeptName || "소속없음") + "' "; // 부서명 데이터셋 추가
                if(checked){
                    html += "checked ";
                }
                html += ">";
                html += "</td>";
                html += "<td>" + emp.empNo + "</td>";
                html += "<td>" + emp.empName + "</td>";
                html += "<td>" + emp.empPosition + "</td>";
                html += "<td>" + (emp.empDeptName || "소속없음" )+ "</td>";
                html += "</tr>";
                
                $(".emp-result-body").append(html);
            }
        }
    })
});

// ===== 선택 완료 =====
$(document).on("click", ".confirm-btn", function(){
    
    $(".receiver-selected-list").empty();

    $(".selected-item").each(function(){
        var empNo = $(this).data("no");
        // 복제 후 x 버튼 떼고 순수 텍스트만 추출
        var empName = $(this).clone().children().remove().end().text().trim();
        var empDept = $(this).data("dept") || "소속없음";

        var html = "";
        html += "<span class='receiver-tag'>";
        // 부서 정보까지 깔끔하게 결합해서 출력하도록 구성
        html += empName + " (" + empDept + ")";
        html += "<button type='button' class='delete-tag'>✕</button>";
        html += "<input type='hidden' name='messageReceiver' value='" + empNo + "'>";
        html += "</span>";

        $(".receiver-selected-list").append(html);
    });

    $(".modal-overlay").hide();
    $(".receiver-feedback").hide();
    
    // 바깥 부서 수정 페이지의 유효성 검사 트리거 호출
    if($("[name=deptHeadIdKeyword]").length > 0) {
        $("[name=deptHeadIdKeyword]").trigger("check");
    }
});

// ===== 동적 이벤트 =====
$(function(){
    
    // 모달 밖 리스트에서 삭제
    $(".receiver-selected-list").on("click", ".delete-tag", function(){
        $(this).closest(".receiver-tag").remove();
        if($("[name=deptHeadIdKeyword]").length > 0) {
            $("[name=deptHeadIdKeyword]").trigger("check");
        }
    });
    
    // 모달에서 체크박스 선택/해제시 (★ 1명 제한 핵심 로직 반영 구역)
    $(document).on("change", ".emp-check", function(){
        var empNo = $(this).data("no");
        var empName = $(this).data("name");
        var empDept = $(this).data("dept");
        var pickerMode = $("#pickerMode").val(); // single 여부 판단

        if($(this).prop("checked")){
            // [단일 선택 모드 제어]
            if(pickerMode === "single") {
                // 다른 모든 체크박스 체크 해제 및 상단 누적 리스트 완전 초기화
                $(".emp-check").not(this).prop("checked", false);
                $(".selected-list").empty();
            } else {
                // 다중 선택 모드일 때만 중복 스킵 검사
                if($(".selected-item[data-no='" + empNo + "']").length > 0){
                    return;
                }
            }

            // 상단 선택된 목록에 추가
            var html = "";
            html += "<div class='selected-item' data-no='" + empNo + "' data-dept='" + empDept + "'>";
            html += empName;
            html += "<span class='selected-remove'>✕</span>";
            html += "</div>";

            $(".selected-list").append(html);
        }
        else{
            $(".selected-item[data-no='" + empNo + "']").remove();
        }

        updateSelectedCount();
    });
    
    // 모달 상단 selected-item 삭제
    $(".selected-list").on("click", ".selected-remove", function(){
        var target = $(this).closest(".selected-item");
        var empNo = target.data("no");

        $(".emp-check[data-no='" + empNo + "']").prop("checked", false);
        target.remove();
        updateSelectedCount();
    });
    
    // 모달 엔터키 제어
    $(document).on("keydown", function(e){
        if(e.key !== "Enter"){
            return;
        }
        e.preventDefault();
        
        if($(".modal-overlay").css("display") == "none"){
            return;
        }
        
        if($(".keyword").is(":focus")){
            $(".search-emp-btn").click();
            return;
        }
        
        $(".confirm-btn").click();
    });
});