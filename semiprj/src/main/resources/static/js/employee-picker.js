//사원 찾기 버튼 클릭시 modal 보여주기
$(".open-search").click(function(){
	$(".modal-overlay").css("display","flex");
	
	$(".keyword").focus();
});
$(".close-btn").click(function(){
    $(".modal-overlay").hide();
});
$(".cancel-btn").click(function(){
    $(".modal-overlay").hide();
});
//모달 상의 찾기 검색 버튼 클릭
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
				html += "<td>" + emp.empDept + "</td>";
				html += "</tr>";
				
				$(".emp-result-body").append(html);
			}
		}
	})
});

$(".confirm-btn").click(function(){
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
		
		$(".receiver-list").append(html);
		$(".modal-overlay").hide();
	});
});

function updateSelectedCount(){
    $(".selected-count").text(
        $(".selected-item").length
    );
}

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
	
	//선택 취소
    $(document).on("click", ".selected-remove", function(){

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