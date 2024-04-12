<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- <script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script> -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
<style type="text/css">
/* Google web font CDN*/
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700&display=swap');

body, html {
  font-family: 'Noto Sans KR', sans-serif;
	
  background-color: #eeeeee;
  padding: 0;
  margin: 0;
}

.container{
  margin: 0;
  top: 20%;
  left: 50%;
  position: absolute;
  text-align: center;
  transform: translateX(-50%);
  background-color: #fff;
  border-radius: 9px;
  border-top: 10px solid #000000;
  border-bottom: 10px solid #000000;
  width: 400px;
  height: 500px;
	border-left:1px solid #333;
	border-right:1px solid #333;
	
}

.box h4 {
  font-family: 'Noto Sans KR', sans-serif;
  color: #000000; 
  font-size: 18px;
  margin-top: 45px;
}

.box h4 span {
  color: #000000;
  font-weight: lighter;
}

.box h5 {
  font-family: 'Noto Sans KR', sans-serif;
  font-size: 13px;
  color: #000;
  letter-spacing: 1.5px;
  margin-top: 0px;
  margin-bottom: 40px;
}

.box input[type = "text"],.box input[type = "password"] {
  display: block;
  margin: 15px auto;
  background: #ffff;
  border: 1px solid #808080;
  border-radius: 5px;
  padding: 14px 10px;
  width: 320px;
  outline: none;
  color: #000;
  transition: all .2s ease-out;
}


.box input[type = "text"]:focus,.box input[type = "password"]:focus {
  border: 1px solid #79A6FE;
  
}

a{
  color: #000;
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}

.rmbcheck{
	margin-top: -10px;
}
/* 기본 체크박스 표시 */
.rmbcheck input[type="checkbox"] {
    display: inline-block;
    width: 0;
    height: 0;
    opacity: 0;
		
}

/* 사용자 정의 체크박스 스타일링 */
.rmbcheck input[type="checkbox"] + label > span {
    height: 13px;
    width: 13px;
    border: 2px solid #464d64;
    border-radius: 8px;
    display: inline-block;
    position: relative;
    cursor: pointer;
    margin-right: 5px;
	vertical-align: middle;
	margin-left: -260px;
}

/* 체크된 상태의 사용자 정의 체크박스 스타일링 */
.rmbcheck input[type="checkbox"]:checked + label > span {
    transition: all 0.3s;
	background-color: #464d64;
}

/* 체크 표시 스타일링 */
.rmbcheck input[type="checkbox"]:checked + label > span::after {
    content: "\2713"; 
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 10px; 
    color: #fff; 
    position: absolute;
    top: 50%; 
    left: 50%; 
    transform: translate(-50%, -50%); 
}

/* 로그인 상태 유지 텍스트 스타일링 */
.rmbcheck .rmb {
    color: #000;
    font-size: 13px;
    vertical-align: middle;
}

.btn1 {
  border:0;
  background: #333;
  color: #fff;
  border-radius: 100px;
  width: 340px;
  height: 49px;
  font-size: 16px;
  position: absolute;
  top: 59%;
  left: 8%;
  transition: 0.3s;
  cursor: pointer;
}

.btn1:hover {
  background: #000000;
}

.forgetid {
  position: absolute;
  top: 92%;
	left: 25px;
	font-size: 14px;
}

.forgetpass {
  position: absolute;
  top: 92%;
	left: 100px;
	font-size: 14px;
}

.dnthave{
    position: absolute;
    top: 92%;
    right: 25px;
	font-size: 14px;
}

.typcn {
  position: absolute;
  left: 339px;
  top: 282px;
  color: #3b476b;
  font-size: 22px;
  cursor: pointer;
}      

.typcn.active {
  color: #7f60eb;
}


.footer {
    position: relative;
    left: 0px;
    bottom: 0;
    top: 30%;
    width: 110%;
    font-size: 12px;
    text-align: center;
}

.footer div a:hover{
    text-decoration: underline;
    color:#fff;
}

.footer div a:after{
    content:'|';
    font-size: 10px;
    color:#bbb;
    margin-right: 3px;
    margin-left: 5px;
    display: inline-block;
    transform: translateY(-2px);
}

.footer div a:last-child:after {
    content: none;
}

.divider {
  position: relative;
  margin-bottom: 15px;
	margin-top:78px;
}
.divider::after{
  content: "";
  height: 1px;
  width: 100%;
  background-color: #C2C7D0;
  position: absolute;
  top: 15px;
  left: 0;
}
.divider span {
  padding: 0 10px;
  background-color: #FFF;
  z-index: 1;  
  position: relative;
}
</style>
</head>
<body>
  <div class="container">
    <form class="box" action="logingoing" method="post">
      <h4>Snack<span>Closet</span></h4>
      <h5>The closet is such a snack</h5>
      <input type="text" name="id" placeholder="ID" autocomplete="off">
        <i class="typcn typcn-eye" id="eye"></i>
        <input type="password" name="pw" placeholder="Passsword" id="pwd" autocomplete="off">
	<div class="rmbcheck">
    <input id="login-checkbox" type="checkbox">
    <label for="login-checkbox">
      <span></span>
      <small class="rmb">아이디 저장</small>
    </label>
	</div>
      <input type="submit" value="Login" class="btn1">
      </form>
	  <a href="pwforget" class="forgetpass">비밀번호찾기</a>
      <a href="idforget" class="forgetid">아이디찾기</a>
      <a href="membershipjoin2" class="dnthave">회원가입</a>
		
		<div class="divider">
          <span>or</span>
    </div>
		<div class="social_login">
			<a href="https://kauth.kakao.com/oauth/authorize?client_id=e3b75c80af4089c257294b73789f4644&redirect_uri=http://localhost:8667/haha/kakaologin&response_type=code">
			<img src="../image/kakaologin.png" alt="Kakao Login"></a>
			
			<a href="https://nid.naver.com/oauth2.0/authorize?client_id=bZp1_Dnu3oky5iTcsVsO&response_type=code&redirect_uri=http://localhost:8667/haha/naverlogin&state=test">
			<img src="../image/naverlogin.png" alt="Naver Login"></a>
	</div>
		<!-- 푸터 -->
       <div class="footer">
      		<div>
                <a href="#none">이용약관</a>
                <a href="#none">개인정보처리방침</a>
                <a href="#none">책임의 한계와 법적고지</a>
                <a href="#none">회원정보 고객센터</a> 
            <span><a href="#none">Snack Closet.</a></span>
				 </div>
		</div>
	</div>
</body>
</html>