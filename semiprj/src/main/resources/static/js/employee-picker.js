// ===== 공통 함수 =====

function updateSelectedCount(){
    $(".selected-count").text(
        $(".selected-item").length
    );
}

// ===== 모달 열기/닫기 =====
$(".open-search").click(function(){
	$(".modal-overlay").css("display","flex");
	//모달 열리면 키워드 입력창으로 포커싱
	$(".keyword").focus();
});

//모달 우측 상단 x
$(".close-btn").click(function(){
    $(".modal-overlay").hide();
});

//모달 취소 버튼
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
				
				//모달 밖의 리스트 체크
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
				html += "data-no='" + emp.empNo + "' ";
				html += "data-name='" + emp.empName + "' ";
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

/*$(".confirm-btn").click(function(){
	$(".emp-check:checked").each(function(){
		var empNo = $(this).data("no");
		var empName = $(this).data("name");
		
		var exists = false;

		$("input[name=messageReceiver]").each(function(){
			if($(this).val() == empNo){
				exists = true;
				return false;
			}
		});
		
		if(exists){
			return;
		}
		
		var html = "";
		
		html += "<span class='receiver-tag'>";
		html += empName;
		
		html += "<button type = 'button' class = 'delete-tag'>";
		html += "✕";
		html += "</button>";
		
		html += "<input type = 'hidden' name = 'messageReceiver' ";
		html += "value = '" + empNo + "'>";
		
		html += "</span>";
		
		$(".receiver-selected-list").append(html);
		$(".modal-overlay").hide();
	});
});*/

$(".confirm-btn").click(function(){

    var mode = $("#pickerMode").val();

    if(mode === "single") {
        // 부서장 - 1명만 선택
        var first = $(".emp-check:checked").first();
        if(first.length === 0) { $(".modal-overlay").hide(); return; }

        var tr = first.closest("tr");
        var empNo       = first.data("no");
        var empName     = first.data("name");
        var empDeptName = tr.find("td").eq(4).text();

        $(".receiver-selected-list").empty();

        var html = "";
        html += "<span class='receiver-tag'>";
        html += empName + " (" + (empDeptName || "소속없음") + ")";
        html += "<button type='button' class='delete-tag'>✕</button>";
        html += "<input type='hidden' name='messageReceiver' value='" + empNo + "'>";
        html += "</span>";

        $(".receiver-selected-list").append(html);

    } else {
        // 기존 다중선택 로직 그대로 유지
        $(".emp-check:checked").each(function(){
            var empNo = $(this).data("no");
            var empName = $(this).data("name");

            var exists = false;
            $("input[name=messageReceiver]").each(function(){
                if($(this).val() == empNo){ exists = true; return false; }
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
    }

    $(".modal-overlay").hide();
});


// ===== 동적 이벤트=====

$(function(){
	
	//모달 밖 receiver-list에서 삭제버튼
    $(".receiver-list").on("click", ".delete-tag", function(){
        $(this).closest(".receiver-tag").remove();
    });
	
	//모달에서 체크박스 선택/해제시
	$(document).on("change", ".emp-check", function(){

        var empNo = $(this).data("no");
        var empName = $(this).data("name");

        if($(this).prop("checked")){
			if($(".selected-item[data-no='" + empNo + "']").length > 0){
			    return;
			}
            var html = "";

            html += "<div class='selected-item' ";
            html += "data-no='" + empNo + "'>";

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
	
	//모달 상단 selected-item 삭제
    $(".emp-result-body").on("click", ".selected-remove", function(){

        var target = $(this).closest(".selected-item");

        var empNo = target.data("no");

        $(".emp-check[data-no='" + empNo + "']")
            .prop("checked", false);

        target.remove();

        updateSelectedCount();
    });
	
	//모달 엔터 할당
	$(document).on("keydown", function(e){

		if(e.key !== "Enter"){
	        return;
	    }

	    e.preventDefault();
		
		if($(".modal-overlay").css("display") == "none"){
			return;
		}
		
		//검색창에 포커스가 있으면 검색버튼 클릭
		if($(".keyword").is(":focus")){
			if(e.key === "Enter"){
				$(".search-emp-btn").click();
				return;
			}
			
		}
		
		//외에는 선택 완료 버튼 클릭
			$(".confirm-btn").click();
	});

});