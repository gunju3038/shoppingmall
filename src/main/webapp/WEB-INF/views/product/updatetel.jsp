<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">

function submitUpdatedtel() {
    var updatedTel = document.getElementById('newtel').value;

	var updatedTelData = {
            
			updatedTel: updatedTel
            
        };
        
    window.opener.postMessage({ type: 'telUpdate', data: updatedTelData }, '*');
}
</script>
<meta charset="UTF-8">
<title>구매창 연락처 수정</title>
</head>
<body>
<span><수정할 전화번호를 입력해주세요></span>
<input type="text" id="newtel" placeholder="ex)010-1234-5678">
<input type="button" value="연락처 수정" onclick="submitUpdatedtel()">
</body>
</html>