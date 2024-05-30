<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
.footerContainer {
    background-color: #000; /* 어두운 배경색 */
    color: #fff; /* 흰색 텍스트 */
    padding: 60px 0 20px 0;
    width: 100%;
    text-align: center;
    font-size: 15px;
  	position : relative;
  	transform : translateY(20%);
    bottom: 0;
}
.footerInfo, .maker{
	padding: 0 0 10px 0;
}
.footerInfo span:after{
    content:'|';
    font-size: 10px;
    color:#bbb;
    margin-right: 5px;
    margin-left: 7px;
    display: inline-block;
    transform: translateY(-1px);
}
.footerInfo span:last-child:after {
    content: none; /* 마지막 span 요소의 ::after 내용을 없앰 */
}
.maker span:after{
    content:'|';
    font-size: 10px;
    color:#bbb;
    margin-right: 5px;
    margin-left: 7px;
    display: inline-block;
    transform: translateY(-1px);
}
.maker span:last-child:after {
    content: none; /* 마지막 span 요소의 ::after 내용을 없앰 */
}
</style>
</head>
<body>
<div class="footerContainer">
	<div class="footerInfo">
	    <span>이용약관</span>
	    <span>개인정보처리방침</span>
	    <span>책임의 한계와 법적고지</span>
	    <span>회원정보</span>
	    <span>고객센터</span>
	</div>
	<div class="maker">
		<span>남 동 수</span>
		<span>이 건 주</span>
		<span>박 신 아</span>
	</div>            
    <span>Snack Closet.</span>
</div>
</body>
</html>