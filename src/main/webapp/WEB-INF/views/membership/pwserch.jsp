<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
    margin: auto;
    margin-top: 150px;
    margin-bottom: 20px;
	border: 1px solid #ccc;
	border-radius: 10px; 
	padding: 20px; 
	background-color: #fff; 
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    border-top: 10px solid #000000;
  	border-bottom: 10px solid #000000;
}

.member .title{
    margin :30px 0;
	text-align : center;
}

.member .field{
    margin :40px 0;
}

.member b{
    display: block;
    margin-bottom: 5px;
}

.member input:focus, .member select:focus{
    border: 1px solid #5356FF;
}

.member-footer {
    text-align: center;
    font-size: 12px;
    margin-top: 40px;
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

.submitgo {
    border-radius: 5px;
    background-color: #333;
    color: #fff;
    border: none;
    padding: 8px 20px;
    font-size: 14px;
    cursor: pointer;
	display: block;
    margin: 0 auto;
	margin-top: 30px;
}
.submitgo:hover {
	background: #000000;
}
</style>
<script type="text/javascript">
//이메일 선택
$(function() {
$('#selectemail').change(function() {
    var selectedValue = $(this).val(); // 선택된 값 가져오기
    var emailInput = $('input[name="email2"]'); // 이메일 입력란 선택

    if (selectedValue === 'directly') {
        emailInput.prop("disabled", false).val("").focus(); // 직접 입력하기 선택 시 활성화
    } else {
        emailInput.prop("disabled", true).val(selectedValue); // 다른 이메일 선택 시 비활성화하고 선택된 값 설정
    }
    
    // email 주소 입력란에서 직접 선택한 값을 사용
    var email1 = $('input[name="email1"]').val();
    var selected_email = emailInput.val();
    var email = email1 + "@" + selected_email;
    $('input[name="email"]').val(email); // hidden 필드에 할당
	});
});

//입력된 이메일이 DB에서 확인
$(function(){
	$("#findBtn").click(function(){
		$.ajax({
			url : "find_pw",
			type : "POST",
			data : {
				id : $("#id").val(),
				email : $("#email").val()
			},
			success : function(result) {
				alert(result);
			},
		})
	});
})

</script>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="pwserchgogo" method="post">
	<div class="member">
		<h2 class="title">비밀번호 찾기</h2>
		<div class="field">
			<b>아이디</b>
			<input type="text" name="id" id="id" class="placehold-text">
		</div>
		<div class="field">
			<b>이름</b>
			<input type="text" name="name">
	    </div>
	   	
	   	<!-- 이메일 -->
	   	<div class="field email">
			<b>이메일</b>
			<input type="text" name="email1" class="textbox1" class="placehold-text">
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
		        <input type="text" name="email" class="textbox1" hidden>
			</div>
		
		 <button type="submit" class="submitgo" id="findBtn">확인</button>
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