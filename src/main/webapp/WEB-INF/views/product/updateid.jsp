<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../../../../resources/css/update_file.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$("#id_check").click(function(){
	    var id = $("#id").val();
	    var vid = /^[a-zA-Z0-9]{4,12}$/;
	
	    if(!vid.test(id)){
	        alert("ID는 영어 또는 숫자 4~12자리만 가능합니다.");
	        return false;
	    } 
	
	    // Ajax를 통한 ID 중복 확인 요청
	    $.ajax({
	        type: "post",
	        async: true,
	        url: "idcheckgogo", // 실제 서버 엔드포인트로 수정해야 함
	        data: {"id": id},
	        success: function(result) {
	            if(result == 0){
	                alert("사용 가능한 ID입니다.");    
	            } else {
	                alert("이미 사용 중인 ID입니다.");
	            }
	        },
	        error: function () {
	            alert("서버 통신 오류가 발생했습니다.");
	        }
	    });
	});
});

// ID 수정 
function submitUpdatedId() {
    var updatedId = document.getElementById('id').value;
    
	var updatedIdData = {
			updatedId: updatedId
        };
        
    // 수정된 ID를 부모 창으로 전달
    window.opener.postMessage({ type: 'idUpdate', data: updatedIdData }, '*');
}
</script>
<meta charset="UTF-8">
<title>ID 수정</title>
</head>
<body>
<div class="member">
<b><수정할 ID를 입력해주세요></b>
<div class="field">
<input type="text" id="id" placeholder="ID">
<input type="button" value="ID 중복검사" id="id_check">
<input type="button" value="ID 수정" onclick="submitUpdatedId()">
</div>
</div>
</body>
</html>