<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
@import url('https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;0,900;1,300;1,400;1,700;1,900&display=swap');
h2{
  font-family: "Merriweather", serif;
  font-weight: 700;
  font-style: italic;
  text-align: center;
  padding-bottom: 40px;
  margin-top: 54px; 
  margin-bottom:0;
  min-width: 1280px;
}
p{
	margin: 0;
}
.clearfix:after { 
	content: ''; 
	display: block; 
	clear: both; 
	float: none; 
}
.clearfix2:after { 
	content: ''; 
	display: block; 
	clear: both; 
	float: none; 
}
.slide_wrap { 
	position: relative; 
	width: 1184px; 
	margin: auto; 
	padding-bottom: 30px; 
	}
.slide_content { 
	position: relative; 
	float: left; 
	width: 1164px; 
	height: 720px;  
	margin: 0 10px;
}
.slide_box { 
   	width: 100%;
   	margin: auto;
}
.slide_content::after{
    content: "";
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    width: 100%;
    background: linear-gradient(-90deg, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0) 30%, rgba(0, 0, 0, 0.2) 60%);
}
.slide_content .str{ 
	position: absolute;
    top: 50%;
    right: 100px;
    left: 100px;
    transform: translate(0%, -60%);
    color: #fff;
    font-size: 18px;
    font-weight: 400;
    text-align: left;
    line-height: 1;
    z-index: 3;
    margin: 0;
}
.str a {
	color: #fff;
}
.str .tit{
	overflow: hidden;
    height: 1px;
    max-height: 2;
    line-height: 1;
    display: block;
    text-overflow: ellipsis;
    white-space: normal;
    height: auto;
    font-size: 52px;
    font-weight: 500;
    opacity: 0;
    transition-duration: .2s;
    transform: scale(0.7);
    transition-delay: .8s;
    line-height: 54px;
}
.str .sub{
	display: block;
    opacity: 0;
    transition-duration: .3s;
    transition-delay: .8s;
    line-height: 25px;
    padding-top: 17px;
    padding-left: 2px;
}
.slide_content.slide_active .tit {
    opacity: 1;
    transform: scale(1);
}
.slide_content.slide_active .sub {
    opacity: 1;
}
.slide_btn_box button { 
    	position: absolute; 
    	top: 0; 
    	width: 1164px; 
    	height: 720px; 
    	background: rgba(0, 0, 0, 0.7); 
    	cursor: pointer; 
    	opacity: 0.8;
    	border: none;
    	z-index: 10;	
}
.slide_btn_prev {
         left: auto;
    	right: 1194px;
}
.slide_btn_next {    
    	left: 1194px;
    	right: auto;
}    
.slide_btn_prev::before{
    content: ".";
    display: block;
    width: 40px;
    height: 70px;
    opacity: 1;
    background-image: url(resources/image/ico_prenavbar.png);
    background-repeat: no-repeat;
    position: absolute;
    right: 14px;
    top: 42%;
}
.slide_btn_next::before{
    content: "";
    display: block;
    width: 40px;
    height: 70px;
    opacity: 1;
    background-image: url("resources/image/ico_nextnavbar.png");
    background-repeat: no-repeat;
    position: absolute;
    left: 14px;
    top: 42%;
}
.slide_pagination{ 
	position: absolute; 
	left: 50%; 
	bottom: 0; 
	list-style: none; 
	margin: 0; 
	padding: 0; 
	transform: translateX(-50%); 
}
.slide_pagination .dot{ 
	display: inline-block; 
	width: 15px; 
	height: 15px; margin: 0 5px; 
	overflow: hidden; 
	background: #ddd; 
	border-radius: 50%; 
	transition: 0.3s; }
.slide_pagination .dot.dot_active{ 
	background: #333; 
}
.slide_pagination .dot a{
	display: block; 
	width: 100%; 
	height: 100%; 
}
.clearfix2:after { 
	content: ''; 
	display: block; 
	clear: both; 
	float: none; 
}
.best_wrap{
    position: relative;
    max-width: 1920px;
    min-width:1370px;
    margin: 0 auto;
    padding: 0 80px;
}
.best_content{ 
    position: relative;
    float: left;
    width: calc((100% - 100px) / 5); /* 수정: 여백을 고려하여 너비 조정 */
    max-width: 332px;
    min-width: 222px;
    margin: 0 10px;
}
.review_content{ 
    position: relative;
    float: left;
    width: calc((100% - 100px) / 5); /* 수정: 여백을 고려하여 너비 조정 */
    max-width: 332px;
    min-width: 222px;
    margin: 0 10p;
    background-color: #fff;
}
.best_content img{ 
	width: 100%;
	max-width: 100%;
	height: auto;
}
.best_rank{ 
	font-family: "Noto Sans KR", sans-serif;
	position: absolute;
    top: 0;
    left: 0;
    width: 50px;
    height: 50px;
    color: #fff;
    background-color: #000;
    text-align: center;
    line-height: 50px;
    font-size: 18px;
    font-weight: 600;
}
.best_info{
	font-family: "Noto Sans KR", sans-serif;
	font-size: 14px;
    padding: 2px ;
    font-weight: 400;
    line-height: 1.7;
}
.best_str{
	padding-top: 8px;
}
.best_review{
    margin-top: 80px;
    padding-top: 20px;
    background-color: #f5f5f5;
}
.review_wrap{
    position: relative;
    max-width: 1920px;
    min-width:1370px;
    margin: 0 auto;
    padding: 0 80px;
    background-color: #f5f5f5;
    height: 400px;
}
.review_content{ 
    position: relative;
    float: left;
    width: calc((100% - 100px) / 5); /* 수정: 여백을 고려하여 너비 조정 */
    max-width: 332px;
    min-width: 222px;
    margin: 0 10px;
    height: 274px;
}
.review_img {
	height: 100%;
	width: auto;
}
.review_img img{ 
	height: 100%;
	width: 100%;
}
.review_str{
	background-color: #fff;
}
.review_tit{
	font-family: "Noto Sans KR", sans-serif;
	font-size: 15px;
    font-weight: 600;
    padding: 2px ;
    color: #333333;
}
.review_tit a {
            color: inherit; /* 부모 요소의 색상을 상속 */
            text-decoration: none; /* 링크의 밑줄 제거 */
}
.review_sub{
	display: flex;
	justify-content: space-between;
	font-family: "Noto Sans KR", sans-serif;
	font-size: 14px;
    padding: 2px ;
    font-weight: 200;
	width: 100%;	
}
.review_sub span {
    flex: 1;
    color: gray;
}
.modal-bg {
	display:none;
	width:100%;
	height:100%;
	position:fixed;
	top:0;
	left:0;
	right:0;
	background: rgba(0, 0, 0, 0.6);
	z-index:1000;
}
.modal-wrap {
	display:none;
	position:fixed;
	top:50%;
	left:50%;
	transform:translate(-50%,-50%);
	width:1000px;
	height:600px;
	background:#fff;
	z-index:1001;    
}
.modal-close{
	background: white; 
	border:none; 
	position: absolute; 
	top: 0; 
	right: 0; 
	font-size: 20px; 
	color: gray;
}
.a{
	width: 360px; 
	padding: 10px 30px; 
	border-bottom: 1px solid #eeeeee;
}
.review-wrap{
	flex: 1; 
}
.reviewScore img {
	width: 14px;
}
.best_item a{
   color: #444444; /* 부모 요소의 색상을 상속 */
   text-decoration: none; /* 링크의 밑줄 제거 */
}
.best_info {
    font-size: 16px;
}
.best_infofirst{
    font-size: 18px;
    font-weight: bold;
}

</style>
</head>
<body>
<section class="main">
	<div class="slide_wrap">
	  <div class="slide_box">
	    <div class="slide_list clearfix">
	      <div class="slide_content">
	      	<div class="img">
	        	<a href="">
	        		<img alt="" src="resources/image/img1.jpg">
	        	</a>
	      	</div>
	      	<div class="str">
	      		<a href="#">
	      			<span class="tit">다채로운<br>스카프의 매력</span> 
	      			<span class="sub">한 끗 차이를 만드는 스카프 활용법</span>
	      		</a>
	      	</div>
	      </div>
	      <div class="slide_content">
	      	<div class="img">
	        	<a href="">
	        		<img alt="" src="resources/image/img2.jpg">
	        	</a>
	      	</div>
	      	<div class="str">
	      		<a href="">
	      			<span class="tit">놓칠 수 없는<br>아울렛 특가</span>
	      			<span class="sub">up to 60% + 20% 쿠폰</span>
	      		</a>
	      	</div>
	      </div>
	      <div class="slide_content">
	          <div class="img">
	        	<a href="">
	        		<img alt="" src="resources/image/img3.jpg">
	        	</a>
	      	</div>
	      	<div class="str">
	      		<a href="">
	      			<span class="tit">I ♡ Rouge Time</span>
	      			<span class="sub">ROUGE PRETZEL 캡슐 컬렉션 출시</span>
	      		</a>
	      	</div>
	      </div>
	      <div class="slide_content">
	        <div class="img">
	        	<a href="">
	        		<img alt="" src="resources/image/img4.jpg">
	        	</a>
	      	</div>
	      	<div class="str">
	      		<a href="">
	      			<span class="tit">TOMMY<br>FINAL SALE </span>
	      			<span class="sub">마지막 득템의 기회! 무제한 20% 쿠폰 증정</span>
	      		</a>
	      	</div>
	      </div>
	      <div class="slide_content">
	       <div class="img">
	        	<a href="">
	        		<img alt="" src="resources/image/img5.jpg">
	        	</a>
	      	</div>
	      	<div class="str">
	      		<a href="">
	      			<span class="tit">지금, 여기서만<br>최대 44% OFF</span>
	      			<span class="sub">간절기 아이템 합리적으로 준비!</span>
	      		</a>
	      	</div>
	      </div>
	      <div class="slide_content">
	        <div class="img">
	        	<a href="">
	        		<img alt="" src="resources/image/img6.jpg">
	        	</a>
	      	</div>
	      	<div class="str">
	      		<a href="">
	      			<span class="tit">일상에 묻어나는<br>세련된 감각</span>
	      			<span class="sub">멋스러운 남성 신상</span>
	      		</a>
	      	</div>
	      </div>
	    </div>
	  </div>
	  <div class="slide_btn_box">
	    <button type="button" class="slide_btn_prev">Prev</button>
	    <button type="button" class="slide_btn_next">Next</button>
	  </div>
	  <ul class="slide_pagination"></ul>
	</div>
</section>

<section class="best_item">
<h2>BEST ITEM</h2>
<div class="best_wrap">
	<div class="best_box">
    	<div class="best_list clearfix2">
      	<c:forEach items="${list }" var="aa" varStatus="loop">
      		<div class="best_content">
      			<div class="best_img">
      				<a href="detailview?snum=${aa.snum}"> 
      				<c:set var="imageArray" value="${fn:split(aa.image, ',')}" />
						<c:forEach items="${imageArray}" var="imageName" varStatus="loop2">
		   					<c:if test="${loop2.index == 0}">
		       					<img alt="" src="./image/${imageName}">
		   					</c:if>
						</c:forEach>
      				</a>
      			</div>
      			<div class="best_str">
      				<a href="detailview?snum=${aa.snum}">
      				<span class="best_rank">${loop.index+1 }</span>
      				<span class="best_infofirst">${aa.sname }<br></span> 
      				<span class="best_info"><f:formatNumber value="${aa.price }" pattern="#,###"/><br></span>
      				<span class="best_info">조회수 : ${aa.viewnum }</span>
      				</a>
      			</div>
      		</div>
      		</c:forEach>
		</div>
	</div>
</div>
</section>

<section class="best_review">
<h2>BEST REVIEW</h2>
<div class="review_wrap">
		<c:forEach items="${list2 }" var="aa" >
      		<div class="review_content">
      			<div class="review_img">
      				<a onclick="popOpen(${aa.bnum})">
      				<img alt="" src="./image/${aa.bpicture }">
      				</a>
      			</div>
      			<div class="review_str">
      				<div class="review_tit"><a onclick="popOpen(${aa.bnum})"><span>${aa.btitle}</span> </a> </div>
      				<div class="review_sub">
      					<div><a onclick="popOpen(${aa.bnum})"><span>${aa.id} </span></a></div>  
      					<div><a onclick="popOpen(${aa.bnum})"><span>${aa.bdate.substring(0,10)}</span> </a> </div>
      				</div>
      			</div>
      		</div>
      		</c:forEach>
		</div>
<div class="modal-bg" onClick="javascript:popClose();"></div>
  <div class="modal-wrap">
    <div>
    	<img alt="" src="" style="width: 600px; height:500px;"> </div>
  	<div style="position: absolute; right: 0">
   		<button class="modal-close" onClick="javascript:popClose();">X</button>
   		<div class="review-wrap">
   			<div class="a">
   				<p>상품명</p>	
   				<p></p>	
   			</div>
   			<div class="a">
   				<p>닉네임</p>
   				<p></p>
   			</div>
   			<div class="a" style="display: flex; justify-content: space-between;">
			    <div class="reviewScore">
			        <p>평점</p>
			        <p></p>
			    </div>
			    <div>
			        <p>작성일</p>
			        <p></p>
			    </div>
			</div>
   			<div class="a">
   				<p style="font-size: 18px"></p>
   				<p></p>
   			</div>
   		</div>
   	</div> 
 </div>
</section>



<script>
(function () {
    const slideList = document.querySelector('.slide_list');  // Slide parent dom
    const slideContents = document.querySelectorAll('.slide_content');  // each slide dom
    const slideBtnNext = document.querySelector('.slide_btn_next'); // next button
    const slideBtnPrev = document.querySelector('.slide_btn_prev'); // prev button
    const pagination = document.querySelector('.slide_pagination');
    const slideLen = slideContents.length;  // slide length
    const slideWidth = 1184; // slide width
    const slideSpeed = 300; // slide speed
    const startNum = 0; // initial slide index (0 ~ 4)
    let loopInterval;
    slideList.style.width = slideWidth * (slideLen + 2) + "px";
    
    // Copy first and last slide
    let firstChild = slideList.firstElementChild;
    let lastChild = slideList.lastElementChild;
    let clonedFirst = firstChild.cloneNode(true);
    let clonedLast = lastChild.cloneNode(true);

    // Add copied Slides
    slideList.appendChild(clonedFirst);
    slideList.insertBefore(clonedLast, slideList.firstElementChild);

    // Add pagination dynamically
    let pageChild = '';
    for (var i = 0; i < slideLen; i++) {
      pageChild += '<li class="dot';
      pageChild += (i === startNum) ? ' dot_active' : '';
      pageChild += '" data-index="' + i + '"><a href="#"></a></li>';
    }
    pagination.innerHTML = pageChild;
    const pageDots = document.querySelectorAll('.dot'); // each dot from pagination

    slideList.style.transform = "translate3d(-" + (slideWidth * (startNum + 1)) + "px, 0px, 0px)";

    let curIndex = startNum; // current slide index (except copied slide)
    let curSlide = slideContents[curIndex]; // current slide dom
    curSlide.classList.add('slide_active');
	
    function nextSlide() {
		 if (curIndex <= slideLen - 1) {
		        slideList.style.transition = slideSpeed + "ms";
		        slideList.style.transform = "translate3d(-" + (slideWidth * (curIndex + 2)) + "px, 0px, 0px)";
		      }
		      if (curIndex === slideLen - 1) {
		        setTimeout(function() {
		          slideList.style.transition = "0ms";
		          slideList.style.transform = "translate3d(-" + slideWidth + "px, 0px, 0px)";
		        }, slideSpeed);
		        curIndex = -1;
		      }
		      curSlide.classList.remove('slide_active');
		      pageDots[(curIndex === -1) ? slideLen - 1 : curIndex].classList.remove('dot_active');
		      curSlide = slideContents[++curIndex];
		      curSlide.classList.add('slide_active');
		      pageDots[curIndex].classList.add('dot_active');
	}
    function preSlide() {
	    if (curIndex >= 0) {
	        slideList.style.transition = slideSpeed + "ms";
	        slideList.style.transform = "translate3d(-" + (slideWidth * curIndex) + "px, 0px, 0px)";
	      }
	      if (curIndex === 0) {
	        setTimeout(function() {
	          slideList.style.transition = "0ms";
	          slideList.style.transform = "translate3d(-" + (slideWidth * slideLen) + "px, 0px, 0px)";
	        }, slideSpeed);
	        curIndex = slideLen;
	      }
	      curSlide.classList.remove('slide_active');
	      pageDots[(curIndex === slideLen) ? 0 : curIndex].classList.remove('dot_active');
	      curSlide = slideContents[--curIndex];
	      curSlide.classList.add('slide_active');
	      pageDots[curIndex].classList.add('dot_active');
	}
    /** Next Button Event */
    slideBtnNext.addEventListener('click', function() {
        clearInterval(loopInterval); // 자동 슬라이드 간격 제어를 위해 clearInterval 호출
    	nextSlide();
    	loopInterval = setInterval(() => {
        	nextSlide();
        	}, 4000);

    });
	
    /** Prev Button Event */
    slideBtnPrev.addEventListener('click', function() {
    	clearInterval(loopInterval); // 자동 슬라이드 간격 제어를 위해 clearInterval 호출
    	preSlide();
    	loopInterval = setInterval(() => {
        	nextSlide();
        	}, 4000);
    });

    /** Pagination Button Event */
    let curDot;
    Array.prototype.forEach.call(pageDots, function (dot, i) {
      dot.addEventListener('click', function (e) {
        e.preventDefault();
        curDot = document.querySelector('.dot_active');
        curDot.classList.remove('dot_active');
        
        curDot = this;
        this.classList.add('dot_active');

        curSlide.classList.remove('slide_active');
        curIndex = Number(this.getAttribute('data-index'));
        curSlide = slideContents[curIndex];
        curSlide.classList.add('slide_active');
        slideList.style.transition = slideSpeed + "ms";
        slideList.style.transform = "translate3d(-" + (slideWidth * (curIndex + 1)) + "px, 0px, 0px)";
      });
    });
    // 자동슬라이드
    loopInterval = setInterval(() => {
    	nextSlide();
    	}, 4000);
	// 슬라이드에 마우스가 올라간 경우 루프 멈추기
    slideList.addEventListener("mouseover", () => {
      clearInterval(loopInterval);
    });
    // 슬라이드에서 마우스가 나온 경우 루프 재시작하기
    slideList.addEventListener("mouseout", () => {
      loopInterval = setInterval(() => {
    	  nextSlide();
      }, 4000);
    });    
  })();

function fetchData(bnum) {
    $.ajax({
        url: 'takeReview',
        type: 'POST',
        data: {"bnum" : bnum},
        success: function(data) {
            // 받아온 데이터를 처리하고 모달에 표시하는 함수 호출
            displayDataInModal(data);
        },
        error: function(xhr, status, error) {
            console.error('Error fetching data:', error);
        }
    });
}

function displayDataInModal(data) {
    // 받아온 데이터를 이용하여 모달 내부의 요소들을 채웁니다.
	document.querySelector('.modal-wrap img').setAttribute('src', './image/' + data.bpicture);
	document.querySelector('.modal-wrap .a:nth-child(1) p:nth-child(2)').textContent = data.sname;
	document.querySelector('.modal-wrap .a:nth-child(2) p:nth-child(2)').textContent = data.id;

	var starsContainer = document.querySelector('.reviewScore');
	starsContainer.innerHTML = '<p>평점</p>'; // 기존의 내용 삭제

	for (var i = 1; i <= data.productrank; i++) {
	    var starImg = document.createElement('img');
	    starImg.setAttribute('src', './image/reviewStar.png');
	    starImg.setAttribute('alt', '');
	    starsContainer.appendChild(starImg);
	}

	document.querySelector('.modal-wrap .a:nth-child(3) div:nth-child(2) p:nth-child(2)').textContent = data.bdate.substring(0, 10);
	document.querySelector('.modal-wrap .a:nth-child(4) p:nth-child(1)').textContent = data.btitle;
	document.querySelector('.modal-wrap .a:nth-child(4) p:nth-child(2)').textContent = data.bcontent;

}

function popOpen(bnum) {
    var modalPop = $('.modal-wrap');
    var modalBg = $('.modal-bg'); 
    fetchData(bnum);
    $(modalPop).css('display', 'flex');
    $(modalBg).show();
}

 function popClose() {
   var modalPop = $('.modal-wrap');
   var modalBg = $('.modal-bg');

   $(modalPop).hide();
   $(modalBg).hide();
}
</script>
</body>
</html>