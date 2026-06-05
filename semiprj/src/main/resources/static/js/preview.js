//이미지 미리보기처리(개수무관)
$(function(){
    $(".preview-input").on("input", function(){

        //기존에 .preview-area에 있는 이미지를 제거 
        //  -있을지 없을지 모르며 있다면 URL.revokeObjectURL()을 써서 회수까지 해줘야함
        //  -jQuery에서 제공하는 반복함수 each를 사용(for보다 편함)
        $(".preview-area").find("img").each(function(){
            //this == 이미 있던 이미지들 반복할 이미지들 
            //이미지 주소 회수 + 이미지 태그 삭제 (or 영역 비우기)

            var address = $(this).attr("src");
            URL.revokeObjectURL(address);
            //위 두줄을 안하면 성능하락이 됨
            $(this).remove();
        });
        //영역 비우기
        $(".preview-area").empty();

        //미리보기 생성
        if(this.files.length > 0){//파일 선택
            for(var i=0; i<this.files.length;i++){//선택한 파일수만큼
                //이미지 태그를 만들어서
                var img = $("<img>")
                    .addClass("image-shadow image-round")
                    .attr("src", URL.createObjectURL(this.files[i]))
                    .prop("height", 100);
                //.preview-area에 추가
                $(".preview-area").append(img);

            }
        }
        else{//파일 선택 취소

        }
    });
});