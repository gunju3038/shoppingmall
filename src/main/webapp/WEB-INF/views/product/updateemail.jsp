<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../../../../resources/css/update_file.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
var email;
$(document).ready(function(){
    $('#selectemail').change(function() {
        var selectedValue = $(this).val();
        var emailInput = $('input[name="email2"]');
    
        if (selectedValue === 'directly') {
            emailInput.prop("disabled", false).val("").focus();
        } else {
            emailInput.prop("disabled", true).val(selectedValue);
        }
        
        var email1 = $('input[name="email1"]').val();
        var selected_email = emailInput.val();
        email = email1 + "@" + selected_email;
        
    });

    // 직접 입력한 이메일을 selected_email에 할당
    $('input[name="email2"]').on('input', function() {
        var email1 = $('input[name="email1"]').val();
        var selected_email = $(this).val();
        email = email1 + "@" + selected_email;
    });
});

function submitUpdatedemail() {
    var updatedEmail = email;
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
<div class="member">
<b><수정할 이메일을 입력해주세요></b>
<div class="field">
<input type="text" name="email1" class="textbox1">
	<span>@</span>
	<input type="text" name="email2" class="textbox1" disabled>
		<select id="selectemail">
            <option value="" disabled selected>E-Mail 선택</option>
            <option value="naver.com" id="naver.com">naver.com</option>
            <option value="hanmail.net" id="hanmail.net">hanmail.net</option>
            <option value="gmail.com" id="gmail.com">gmail.com</option>
            <option value="nate.com" id="nate.com">nate.com</option>
            <option value="directly" id="textEmail">직접 입력하기</option>
        </select>
</div>
<input type="button" value="이메일 수정" onclick="submitUpdatedemail()">
</div>
</body>
</html>