<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">

function submitUpdatedemail() {
    var updatedEmail = document.getElementById('newemail').value;

	var updatedEmailData = {
            
			updatedEmail: updatedEmail
            
        };
        

    window.opener.postMessage({ type: 'emailUpdate', data: updatedEmailData }, '*');
}
</script>
<meta charset="UTF-8">
<title>구매창 이메일 수정</title>
</head>
<body>
<span><수정할 이메일을 입력해주세요></span>
<input type="text" id="newemail" placeholder="ex)abcd1234@gmail.com">
<input type="button" value="이메일 수정" onclick="submitUpdatedemail()">
</body>
</html>