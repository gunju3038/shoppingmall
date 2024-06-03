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
  	width: 400px;
	height: 700px;
  	margin: auto;
  	margin-top: 30px;
  	margin-bottom: 20px;
	border: 1px solid #ccc;
	border-radius: 9px;
	border-top: 10px solid #000000;
  	border-bottom: 10px solid #000000;
	padding: 20px; 
	background-color: #fff; 
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.member .field{
    margin :15px 0;
}

.member b{
    display: block;
    margin-bottom: 5px;
}

.member input:focus, .member select:focus{
    border: 1px solid #2db400;
}

.field.tel-number div {
    display: flex;
}

.placehold-text{
   display: inline-block;
   position:relative;
   border: 1px solid #000; 
} 

.placehold-text:before{
   position:absolute;
   right : 20px; 
   top:13px; 
   pointer-events: none;
} 

.field.address input[type="text"]{
	margin-bottom: 5px;
}

.member-footer {
    text-align: center;
    font-size: 12px;
    margin-top: 20px;
}

.member-footer div a:hover{
    text-decoration: underline;
    color:#2db400;
}

.member-footer div a:after{
    content:'|';
    font-size: 10px;
    color:#bbb;
    margin-right: 5px;
    margin-left: 7px;
    display: inline-block;
    transform: translateY(-1px);
}

.submitgo{
    display: block;
    margin: 0 auto;
}

.textbox1{
    width: 100px; 
}

@media (max-width:768px) {
    .member{
        width: 100%;
    }
form{
    	margin-top: 50px;
    	padding: 0px;
    }
}

input[type="text"],
input[type="password"]
{
  border-radius: 4px;
	height: 25px;
	border: 1px solid #ccc;
	padding: 8px;
	font-size: 14px;
}
.member input[type=button]{ 
	border-radius: 5px;
	background-color: #16222A; 
 	color: #fff;
 	border: 1px solid;
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
<script type="text/javascript">
$(document).ready(function(){
    // ID 중복 확인 버튼 클릭 시 이벤트 처리
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
                    $("#id").data("checked", true);
                } else {
                    alert("이미 사용 중인 ID입니다.");
                }
            },
            error: function () {
                alert("서버 통신 오류가 발생했습니다.");
            }
        });
    });

    $(document).ready(function(){
        $("#go").click(function(event){
            event.preventDefault(); // 기본 동작 방지

            var id = $("#id").val();
            var idchecked = $("#id").data("checked");
            var pw = $("#pw").val();
            var pwvalid = pwcheck1($("#pw").val());
            var pwcheck = $('#pw_check').val();
            var name = $("#name").val();
            var tel1 = $("#tel1").val();
            var tel2 = $("#tel2").val();
            var email1 = $("input[name='email1']").val();
            var email2 = $('input[name="email2"]').val();
            var pid1 = $("#pid1").val();
            var pid2 = $("#pid2").val();
            var address1 = $("#sample6_address").val();
            var address2 = $("#sample6_detailAddress").val();
            if (id === "" || pw === "" || name === "") {
                alert("입력되지 않은 항목이 있습니다. 모든 항목을 입력해주세요.");
                return false; 
            }
            if (tel1 === "" || tel2 === "") {
                alert('전화번호를 모두 입력해주세요.');
                return false;
            }
            if (pid1 === "" || pid2 === "") {
                alert('주민등록번호를 모두 입력해주세요.');
                return false;
            }
            if (address1 === "" || address2 === "") {
            	alert('주소를 정확히 모두 입력해주세요');
            	return false;
            }
            if (email1 === "" || email2 === "") {
            	alert('이메일 입력 혹은 선택을 해주세요');
            	return false;
            }

            // ID 중복 확인
            var checkdoing = legocheck(id);
            if (checkdoing) {
                alert("ID가 이미 사용 중입니다. 다른 ID를 선택해주세요.");
                return false;
            }
            
            if (!idchecked) {
                alert("ID 중복 확인을 해주세요.");
                return false;
            }
            
            if (!pwvalid) {
                alert('비밀번호형식이 올바르지 않습니다.');
                return false;
            }
            
            // 비밀번호 확인
            if (pw !== pwcheck) {
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
            
            $('form').submit();
        });

        
     // 비밀번호 유효성 검사
        $('#pw').on('input', function() {
            var pw = $(this).val();
            if (!pwcheck1(pw)) {
                $('#pw_error1').text('비밀번호는 영문자, 숫자, 특수문자를 모두 포함하여 8자 이상이어야 합니다.').css('color', 'red');
            } else {
                $('#pw_error1').html('&#10003;').css('color', 'green');
                
            }
        });
        function pwcheck1(pw) {
            var regex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            return regex.test(pw);
        }
        
        $('#pw_check').on('input', function() {
            var pw = $('#pw').val();
            var pwCheck = $(this).val();

            if (pw !== pwCheck) {
                $('#pw_error').text('비밀번호가 일치하지 않습니다.').css('color', 'red');
            } else {
                $('#pw_error').html('&#10003;').css('color', 'green');
            }
        });

        // ID 중복 확인 함수
        function legocheck(id) {
            var isDuplicated = false;

            $.ajax({
                type: "post",
                async: false,
                url: "idcheckgogo",
                data: {"id": id},
                success: function(result) {
                    if (result == 1) {
                        isDuplicated = true;
                    }
                },
                error: function () {
                    alert("서버 통신 오류가 발생했습니다.");
                }
            });

            return isDuplicated;
        }
    });
    
    
    $(document).ready(function(){
        $('#selectemail').change(function() {
            var selectedValue = $(this).val();
            var emailInput = $('input[name="email2"]');

            if (selectedValue === 'directly') {
                emailInput.prop("disabled", false).val("").focus();
            } else {
                emailInput.prop("disabled", true).val(selectedValue);
            }

            updateEmail();
        });

        $('input[name="email1"], input[name="email2"]').on('input', function() {
            updateEmail();
        });

        function updateEmail() {
            var email1 = $('input[name="email1"]').val();
            var email2 = $('input[name="email2"]').val();
            var email = email1 + "@" + email2;
            $('input[name="email"]').val(email);
        }
    });


        function update_tel() {
            var tel1 = document.getElementById("tel1").value;
            var tel2 = document.getElementById("tel2").value;
            var tel = "010-" + tel1 + "-" + tel2;
            $('input[name="tel"]').val(tel);
        }

        function update_pid() {
            var pid1 = document.getElementById("pid1").value;
            var pid2 = document.getElementById("pid2").value;
            var pid = pid1 + "-" + pid2;
            $('input[name="pid"]').val(pid);
        }
        document.getElementById("tel1").addEventListener("input", update_tel);
        document.getElementById("tel2").addEventListener("input", update_tel);
        document.getElementById("pid1").addEventListener("input", update_pid);
        document.getElementById("pid2").addEventListener("input", update_pid);
    });
</script>
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
<form action="membershipsave" method="post">
	<div class="member">

    <!-- 필드 id, 비밀번호, 비밀번호 재확인 -->
    <div class="field">
    <b>아이디</b>
    <input type="text" name="id" id="id" class="placehold-text">
    <input type="button" value="ID 중복검사" id="id_check">
	</div>
	<div class="field">
    <b>비밀번호</b>
	<input type="password" id="pw" name="pw">
	<span id="pw_error1" class="error-message1"></span>
	</div>
	<div class="field">
    <b>비밀번호 재확인</b>
        <input type="password" id="pw_check">
        <span id="pw_error" class="error-message"></span>
    </div>
	<div class="field">
	<b>이름</b>
	<input type="text" name="name" id="name">
    </div>
    
    <!-- 전화번호 -->
    <div class="field tel-number">
		<b>휴대전화</b>
    	<input type="text" value="010" readonly="readonly" class="textbox1">
   		<span style="font-size: 20px; font-weight: bold; vertical-align: middle;">-</span>
   		<input type="text" name="tel1" maxlength="4" class="textbox1" id="tel1">
   		<span style="font-size: 20px; font-weight: bold; vertical-align: middle;">-</span>
   		<input type="text" name="tel2" maxlength="4" class="textbox1" id="tel2">
   		<input type="text" name="tel" class="textbox1" hidden id="tel">
   		</div>
   	
   	<!-- 이메일 -->
   	<div class="field email">
	<b>이메일</b>
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
        <input type="text" name="email" class="textbox1" hidden id="email">
	</div>
	
	<!-- 주민번호 -->
	<div class="field birth">
	<b>주민번호</b>
	<input type="text" name="pid1" maxlength="6" class="textbox1" id="pid1">
	<span style="font-size: 20px; font-weight: bold; vertical-align: middle;">-</span>
	<input type="password" name="pid2" maxlength="7" class="textbox1" id="pid2">
	<input type="text" name="pid" class="textbox1" hidden id="pid">
	</div>
	
	<!-- 주소 -->
	<div class="field address">
	<b>주소</b>
		<input type="text" name="postcode" class="form-input3" id="sample6_postcode" placeholder="우편번호">
		<input type="button" class="form-button2" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
		<input type="text" name="address1" class="form-input" id="sample6_address" placeholder="주소"><br>
		<input type="text" name="address2" class="form-input" id="sample6_detailAddress" placeholder="상세주소">
	</div>
	 <button type="submit" class="submitgo" id="go">가입하기</button>
</div>
	
	<!-- 푸터 -->
        <div class="member-footer">
            <div>
                <a href="#none">이용약관</a>
                <a href="#none">개인정보처리방침</a>
                <a href="#none">책임의 한계와 법적고지</a>
                <a href="#none">회원정보 고객센터</a>
            </div>
            <span><a href="#none">Snack Closet.</a></span>
         </div>
</form>
</body>
</html>