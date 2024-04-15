<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../../../../resources/css/update_file.css">
<script type="text/javascript">
// 이름 수정 후, 수정된 주소 값을 부모 창(productsellout.jsp)으로 전송
function submitUpdatedname() {
    var updatedName = document.getElementById('newname').value;

	var updatedNameData = {
            
			updatedName: updatedName
            
        };
        
    // 수정된 이름을 부모 창으로 전달
    window.opener.postMessage({ type: 'nameUpdate', data: updatedNameData }, '*');
}
</script>
<meta charset="UTF-8">
<title>구매창 이름 수정</title>
</head>
<body>
<div class="member">
<b><수정할 이름을 입력해주세요></b>
<div class="field">
<input type="text" id="newname" placeholder="이름">
</div>
<input type="button" value="이름 수정" onclick="submitUpdatedname()">
</div>
</body>
</html>