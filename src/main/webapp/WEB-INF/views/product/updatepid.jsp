<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../../../../resources/css/update_file.css">
<script type="text/javascript">
function submitUpdatedPid() {
	var pid1 = document.getElementById("pid1").value;
    var pid2 = document.getElementById("pid2").value;
    var updatedPid = pid1 + "-" + pid2;
    
	console.log(updatedPid);
	var updatedPidData = {
			updatedPid: updatedPid
        };
        
    // 수정된 이름을 부모 창으로 전달
    window.opener.postMessage({ type: 'pidUpdate', data: updatedPidData }, '*');
}
</script>
<meta charset="UTF-8">
<title>주민번호 수정</title>
</head>
<body>
<div class="member">
<b><수정할 주민번호를 입력해주세요></b>
<div class="field birth">
	<b>주민번호</b>
	<input type="text" name="pid1" maxlength="6" class="textbox1" id="pid1">
	<span style="font-size: 20px; font-weight: bold; vertical-align: middle;">-</span>
	<input type="text" name="pid2" maxlength="7" class="textbox1" id="pid2">
</div>
<input type="button" value="주민번호 수정" onclick="submitUpdatedPid()">
</div>
</body>
</html>