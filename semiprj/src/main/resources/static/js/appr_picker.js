$(function(){

    // ===== 공통 함수 =====
    function updateSelectedCount(){
        $(".selected-count").text($(".selected-item").length);
    }

    // ===== 모달 열기/닫기 =====
    $(".open-search").click(function(){
        $(".modal-overlay").css("display", "flex");
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
            url  : "/rest/emp/search",
            type : "get",
            data : { keyword : $(".keyword").val() },
            success : function(response){
                $(".emp-result-body").empty();

                for(var i = 0; i < response.length; i++){
                    var emp = response[i];

                    // 모달 밖의 리스트 체크
                    var checked = false;
                    $("input[name=messageReceiver]").each(function(){
                        if($(this).val() == emp.empNo){
                            checked = true;
                            return false;
                        }
                    });

                    var html = "";
                    html += "<tr>";
                    html += "<td>";
                    html += "<input type='checkbox' class='emp-check' ";
                    html += "data-no='"   + emp.empNo   + "' ";
                    html += "data-name='" + emp.empName + "' ";
                    if(checked){ html += "checked "; }
                    html += ">";
                    html += "</td>";
                    html += "<td>" + emp.empNo + "</td>";
                    html += "<td>" + emp.empName + "</td>";
                    html += "<td>" + emp.empPosition + "</td>";
                    html += "<td>" + (emp.empDeptName || "소속없음") + "</td>";
                    html += "</tr>";

                    $(".emp-result-body").append(html);
                }
            }
        });
    });

    // ===== 선택 완료 =====
    $(".confirm-btn").click(function(){
        $(".emp-check:checked").each(function(){
            var empNo   = $(this).data("no");
            var empName = $(this).data("name");

            var exists = false;
            $("input[name=messageReceiver]").each(function(){
                if($(this).val() == empNo){
                    exists = true;
                    return false;
                }
            });

            if(exists){ return; }

            var html = "";
            html += "<span class='receiver-tag'>";
            html += empName;
            html += "<button type='button' class='delete-tag'>✕</button>";
            html += "<input type='hidden' name='messageReceiver' value='" + empNo + "'>";
            html += "</span>";

            $(".receiver-selected-list").append(html);
        });

        $(".modal-overlay").hide(); // ← 루프 밖으로 이동
    });

    // ===== 동적 이벤트 =====

    // 모달 밖 receiver-list에서 삭제버튼
    $(".receiver-list").on("click", ".delete-tag", function(){
        $(this).closest(".receiver-tag").remove();
    });

    // 체크박스 선택/해제 시
    $(document).on("change", ".emp-check", function(){
        var empNo   = $(this).data("no");
        var empName = $(this).data("name");

        if($(this).prop("checked")){
            if($(".selected-item[data-no='" + empNo + "']").length > 0){ return; }

            var html = "";
            html += "<div class='selected-item' data-no='" + empNo + "'>";
            html += empName;
            html += "<span class='selected-remove'>✕</span>";
            html += "</div>";

            $(".selected-list").append(html);
        } else {
            $(".selected-item[data-no='" + empNo + "']").remove();
        }

        updateSelectedCount();
    });

    // selected-list에서 삭제 ← 수정된 부분
    $(".selected-list").on("click", ".selected-remove", function(){
        var target = $(this).closest(".selected-item");
        var empNo  = target.data("no");

        // 체크박스도 같이 해제
        $(".emp-check[data-no='" + empNo + "']").prop("checked", false);

        target.remove();
        updateSelectedCount();
    });

    // 엔터키
    $(".modal-overlay").on("keydown", ".keyword", function(e){
        if(e.key === "Enter"){
            e.preventDefault();
            $(".search-emp-btn").click();
        }
    });

    // 모달이 열려있을 때만 엔터로 선택완료
    $(document).on("keydown", function(e){
        if(e.key !== "Enter") return;
        if($(".modal-overlay").css("display") === "none") return;
        if($(".keyword").is(":focus")) return; // 검색창 포커스면 위에서 처리

        e.preventDefault();
        $(".confirm-btn").click();
    });

});