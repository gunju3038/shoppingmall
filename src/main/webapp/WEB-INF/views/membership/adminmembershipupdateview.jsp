<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	display: inline-block;
	margin-right: 20px auto; /* 버튼 간격 조절을 위해 추가 */
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
.buttonmove{
	padding-left: 70px;
	padding-top : 30px;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">    
//이름 수정
function openNameUpdateWindow() {
	
	var width = 400;
    var height = 400;
    var leftPosition = (window.screen.width - width) / 2; 
    var topPosition = (window.innerHeight - height) / 2; 
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    // 이름 수정창 열기
    var updateWindow = window.open('updatename', '_blank', options);
    
    // 부모 창(updatename.jsp) 으로부터 데이터를 받아와서 처리
    function receiveUpdatedName(event) {
        // event.data를 이용하여 수정된 이름 정보를 받아옴
        if (event.data.type === 'nameUpdate') {
	        var newName = event.data.data;
	        
	        document.getElementById('name').value = newName.updatedName;
	        
	        updateWindow.close();
        }
    }

    // 수정된 이름 정보를 수신하면 위의 receiveUpdatedName 함수 호출
    window.addEventListener('message', receiveUpdatedName);
}

//연락처 수정
function openTelUpdateWindow() {
	
	var width = 400;
    var height = 400;
    var leftPosition = (window.screen.width - width) / 2; 
    var topPosition = (window.innerHeight - height) / 2; 
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    
    var updateWindow = window.open('updatetel', '_blank', options);
    
    
    function receiveUpdatedTel(event) {
    
        if (event.data.type === 'telUpdate') {
	        var newTel = event.data.data;
	        
	        document.getElementById('tel').value = newTel.updatedTel;
	        
	        updateWindow.close();
        }
    }

    
    window.addEventListener('message', receiveUpdatedTel);
}

//이메일 수정
function openEmailUpdateWindow() {
	
	var width = 400;
    var height = 400;
    var leftPosition = (window.screen.width - width) / 2; 
    var topPosition = (window.innerHeight - height) / 2; 
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    
    var updateWindow = window.open('updateemail', '_blank', options);
    
    
    function receiveUpdatedEmail(event) {
        
        if (event.data.type === 'emailUpdate') {
	        var newEmail = event.data.data;
	        
	        document.getElementById('email').value = newEmail.updatedEmail;
	        
	        updateWindow.close();
        }
    }

    window.addEventListener('message', receiveUpdatedEmail);
}

// 주소 수정
function openAddressUpdateWindow() {
	// 주소 수정창 크기 조절
	var width = 400;
    var height = 400;
    var leftPosition = (window.screen.width - width) / 2; // 윈도우 화면 중앙에 화면이 보이게 가로 조절
    var topPosition = (window.innerHeight - height) / 2; // 브라우저 창 중앙에 화면이 보이게 세로 조절
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    // 주소 수정창 열기
    var updateWindow = window.open('updateaddress', '_blank', options);
    
    // 부모 창(updateaddress.jsp) 으로부터 데이터를 받아와서 처리
    function receiveUpdatedAddress(event) {
        // event.data를 이용하여 수정된 주소 정보를 받아옴
        if (event.data.type === 'addressUpdate') {
	        var updatedAddress = event.data.data;
	        
	        document.getElementById('address').value = updatedAddress.fullAddress;
	        
	        updateWindow.close();
        }
    }

    // 수정된 주소 정보를 수신하면 위의 receiveUpdatedAddress 함수 호출
    
    	window.addEventListener('message', receiveUpdatedAddress);	
    
}

// ID 수정
function openIdUpdateWindow() {
	
	var width = 500;
    var height = 400;
    var leftPosition = (window.screen.width - width) / 2; 
    var topPosition = (window.innerHeight - height) / 2; 
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    
    var updateWindow = window.open('updateid', '_blank', options);
    
    
    function receiveUpdatedId(event) {
        
        if (event.data.type === 'idUpdate') {
        	
	        var newId = event.data.data;
	        
	        document.getElementById('id').value = newId.updatedId;
	        
	        updateWindow.close();
        }
    }

    window.addEventListener('message', receiveUpdatedId);
}

// 비밀번호 수정
function openPwUpdateWindow() {
	
	var width = 400;
    var height = 400;
    var leftPosition = (window.screen.width - width) / 2; 
    var topPosition = (window.innerHeight - height) / 2; 
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    
    var updateWindow = window.open('updatepw', '_blank', options);
    
    
    function receiveUpdatedPw(event) {
        
        if (event.data.type === 'pwUpdate') {
        	
	        var newPw = event.data.data;
	        
	        document.getElementById('pw').value = newPw.updatedPw;
	        
	        updateWindow.close();
        }
    }

    window.addEventListener('message', receiveUpdatedPw);
}

// 주민번호 수정
function openPidUpdateWindow() {
	
	var width = 400;
    var height = 400;
    var leftPosition = (window.screen.width - width) / 2; 
    var topPosition = (window.innerHeight - height) / 2; 
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    
    var updateWindow = window.open('updatepid', '_blank', options);
    
    
    function receiveUpdatedPid(event) {
        
        if (event.data.type === 'pidUpdate') {
        	
	        var newPid = event.data.data;
	        
	        document.getElementById('pid').value = newPid.updatedPid;
	        
	        updateWindow.close();
        }
    }

    window.addEventListener('message', receiveUpdatedPid);
}


</script>

<meta charset="UTF-8">
<title>회원정보수정</title>
</head>
<body>
<form action="adminmembershipupdate" method="post">
	
	<div class="member">
	<c:forEach items="${list }" var="aa">	
    <!-- 필드 id, 비밀번호, 비밀번호 재확인 -->
    <h2 style="text-align: center;">회원정보수정</h2>
    <div class="field">
    <b>아이디</b>
    <input type="hidden" name="beforeid" class="placehold-text" value=${aa.id } readonly>
    <input type="text" name="id" id="id" class="placehold-text" value=${aa.id } readonly>
    <input type="button" value="ID 수정하기" onclick="openIdUpdateWindow()">
	</div>
	<div class="field">
    <b>비밀번호</b>
	<input type="password" id="pw" name="pw" value="${aa.pw }">
	<input type="button" value="비밀번호 수정하기" onclick="openPwUpdateWindow()">
	</div>
	
	<div class="field">
	<b>이름</b>
	<input type="text" name="name" id="name" value="${aa.name }" readonly>
	<input type="button" value="이름 수정하기" onclick="openNameUpdateWindow()">
    </div>
    
    <!-- 전화번호 -->
    <div class="field tel-number">
		<b>연락처</b>
		<input type="text" name="tel" id="tel" value="${aa.tel }" readonly>
    	<input type="button" value="연락처 수정하기" onclick="openTelUpdateWindow()">
   		</div>
   	
   	<!-- 이메일 -->
   	<div class="field email">
	<b>이메일</b>
	<input type="text" name="email" id="email" value="${aa.email }" readonly>
	<input type="button" value="Email 수정하기" onclick="openEmailUpdateWindow()">
	</div>
	
	<!-- 주민번호 -->
	<div class="field birth">
	<b>주민번호</b>
	<input type="text" name="pid" id="pid" value="${aa.pid }">
	<input type="button" value="주민번호 수정하기" onclick="openPidUpdateWindow()">
	</div>
	
	<!-- 주소 -->
	<div class="field address">
	<b>주소</b>
		<input type="text" name="address" id="address" value="${aa.address }" readonly>
		<input type="button" value="주소 수정하기" onclick="openAddressUpdateWindow()">
	</div>
	</c:forEach>
	<div class="buttonmove">
	 <button type="submit" class="submitgo" id="go">수정하기</button> 
	 <button type="button" class="submitgo" onclick="window.history.back();">이전 화면으로</button>
	</div>
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