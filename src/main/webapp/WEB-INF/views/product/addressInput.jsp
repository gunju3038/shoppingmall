<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">
/* Google web font CDN*/
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700&display=swap');
*{
    box-sizing: border-box; /*전체에 박스사이징*/
    outline: none; /*focus 했을때 테두리 나오게 */
}

body{
    font-family: 'Noto Sans KR', sans-serif;
    font-size:14px;
    background-color: #f5f6f7;
    line-height: 1.5em;
    color : #222;
    margin: 0px;
}

a{
    text-decoration: none;
    color: #222;
}

.member{
  	width: 100%;
	height: 100%;

	padding: 20px; 
	background-color: #fff; 
	
}

.member .field{
    margin :15px 0;
}

.member b{
    display: block;
    margin-bottom: 5px;
}

.field.tel-number div {
    display: flex;
}



.field.address input[type="text"]{
	margin-bottom: 5px;
}



.submitgo{
    display: block;
    margin: 0 auto;
    width: 100px;
    height: 40px;
}

.textbox1{
    width: 100px; 
}

input[type="text"]
{
  border-radius: 4px;
	height: 35px;
	border: 1px solid #ccc;
	padding: 8px;
	font-size: 14px;
}
.member input[type=button]{ 
	background-color: #333; 
 	color: #fff;
 	height: 33px;
 }

.submitgo {
    border-radius: 5px;
    background-color: #333;
    color: #fff;
    border: none;
    padding: 8px 20px;
    font-size: 14px;
    cursor: pointer;
}
.submitgo:hover {
  background: #000000;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
//주소API
function sample6_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
            } 

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample6_postcode').value = data.zonecode;
            document.getElementById("sample6_address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("sample6_detailAddress").focus();
        }
    }).open();
}
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="addressSave" method="post">
	<div class="member">
	<b>배송지명</b>
	<input type="text" name="addressname" id="addressname" required="required">
		
	<b>이름</b>
	<input type="text" name="name" id="name" required="required">
    <!-- 전화번호 -->
    <div class="field tel-number">
		<b>휴대전화</b>
    	<input type="text" value="010" readonly="readonly" class="textbox1">
   		<span style="font-size: 20px; font-weight: bold; vertical-align: middle;">-</span>
   		<input type="text" name="tel1" maxlength="4" class="textbox1" id="tel1">
   		<span style="font-size: 20px; font-weight: bold; vertical-align: middle;">-</span>
   		<input type="text" name="tel2" maxlength="4" class="textbox1" id="tel2">
   	</div>

	<!-- 주소 -->
	<div class="field address">
	<b>주소</b>
		<input type="text" name="postcode" class="form-input3" id="sample6_postcode" placeholder="우편번호">
		<input type="button" class="form-button2" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
		<input type="text" name="address1" class="form-input" id="sample6_address" style="width: 400px;" placeholder="주소" ><br>
		<input type="text" name="address2" class="form-input" id="sample6_detailAddress" style="width: 400px;" placeholder="상세주소">
	</div>
	 <button type="submit" class="submitgo" id="go">추가하기</button>
</div>
	

</form>
</body>
</html>