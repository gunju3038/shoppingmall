<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style type="text/css">
    .clearfix:after { content: ''; display: block; clear: both; float: none; }
    .slide_wrap { position: relative; width: 900px; margin: auto; padding-bottom: 30px; }
    .slide_box { width: 100%; margin: auto; overflow-x: hidden; }
    .slide_content {  float: left; width: 450px; height: 540px; }
    .slide_content img { width:100%; height:100%;}
    .slide_btn_box button { 
    	position: absolute;  
    	width: 60px; 
    	height: 60px; 
    	cursor: pointer; 
    }
    .slide_btn_box .slide_btn_prev { 
    	left: 0px; 
    	top:40%;
    	background: rgba(0, 0, 0, 0.2); 
    	cursor: pointer; 	
    	border: none;
    	z-index: 10;	
    }
    .slide_btn_prev::before{
    content: "";
    width: 40px;
    height: 70px;
    opacity: 0.5;
    background-image: url(resources/image/ico_prenavbar.png);
    background-repeat: no-repeat;
    position: absolute;
    right: 14px;
    top: -9%;
    }
    .slide_btn_box .slide_btn_next { 
    	right: 0px; 
    	top:40%;
    	background: rgba(0, 0, 0, 0.2); 
    	cursor: pointer; 
    	border: none;
    	z-index: 10;	
    }
    .slide_btn_next::before{
    content: "";
    width: 40px;
    height: 70px;
    opacity: 0.5;
    background-image: url("resources/image/ico_nextnavbar.png");
    background-repeat: no-repeat;
    position: absolute;
    left: 14px;
    top: -9%;
    }
    .slide_pagination { position: absolute; left: 50%; bottom: 0; list-style: none; margin: 0; padding: 0; transform: translateX(-50%); }
    .slide_pagination .dot { display: inline-block; width: 15px; height: 15px; margin: 0 5px; overflow: hidden; background: #ddd; border-radius: 50%; transition: 0.3s; }
    .slide_pagination .dot.dot_active { background: #333; }
    .slide_pagination .dot a { display: block; width: 100%; height: 100%; }


.main{
	display: flex;
	justify-content: center;
    position: relative;
    max-width: 1920px;
    min-width:1370px;
    margin: 0 auto;
    padding: 0 80px;
    margin-top: 30px;
}
.option { 
	width: 450px;
	margin-left: 120px;
}
.option h2 { 
	margin: 15px 0 15px; 
	padding-bottom: 10px; 
	border-bottom:2px solid #333; 
	font-size:30px; 
	line-height: 22px;
	font-weight: 700;
}
.option table th,
.option table td { 
	padding:30px 30px 0 5px; 
	font-size: 15px; 
	color:#444; 
	text-align: left;
}

.option table input { 
	width:44px; 
	height: 30px; 
	border:none;
	border:1px solid #c6c6c6; 
	text-align:center; 
}

.option table select { 
	width:100%; 
	border:1px solid #c6c6c6; 
	box-sizing: border-box;  
}
.product_mainbtns {
  width: 320px;
  height: 160px;
  display: flex;
  margin: auto;
}
.product_btn {
  width: 140px;
  height: 40px;
  font-size: 16px;
  margin: auto;
  border-radius: 5px;
}

.product_btn.left {
  background-color: #fff;
  border: 1px #808080 solid;
}

.product_btn.right {
  background-color: slategray;
  color: #fff;
  border: none;
}



#dynamicULArea ul {
  padding:5px;
  margin: 30px 0;
  list-style-type: none; /* 리스트 항목의 점 제거 */
}
/* Chrome, Safari, Edge, Opera */
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

#dynamicULArea li{
	font-size: 15px;
	font-weight: 500;
}

/* 수정된 스타일 */
input[type="number"] {
  width: 40px; /* 인풋 너비 조절 */
  height: 30px; /* 인풋 높이 조절 */
  text-align: center; /* 수량 입력값 중앙 정렬 */
  border: none;
  
}
.btn-wrapper {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.btn-wrapper p{
  display: inline-block;
  margin: 15px 30px; 
  font-size: 17px;
}

.btn {
  display: inline-block;
  width: 30px; /* 버튼 너비 조절 */
  height: 30px; /* 버튼 높이 조절 */
  vertical-align: middle;
 
}


.minus {
  background-image: url("resources/image/ico_minus.png"); /* 이미지 경로 설정 */
  background-repeat: no-repeat;
  background-position: center;
}
.plus {
  background-image: url('resources/image/ico_plus.png'); /* 이미지 경로 설정 */
  background-repeat: no-repeat;
  background-position: center;
}
.delete {
  background-image: url('resources/image/ico_x.png'); /* 이미지 경로 설정 */
  background-repeat: no-repeat;
  background-position: center;
  border: none;
  background-color: #fff;
}

</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

</head>
<body>
<section class="main">
<div class="slide">
    <div class="slide_wrap">
      <div class="slide_box">
        <div class="slide_list clearfix">
          <div class="slide_content slide01">
            <img alt="" src="resources/image/img_review1.jpg">
          </div>
          <div class="slide_content slide02">
            <img alt="" src="resources/image/img_review2.jpg">
          </div>
          <div class="slide_content slide03">
            <img alt="" src="resources/image/img_review3.jpg">
          </div>
          <div class="slide_content slide04">
            <img alt="" src="resources/image/img_review4.jpg">
          </div>
          <div class="slide_content slide05">
            <img alt="" src="resources/image/img_review5.jpg">
          </div>
        </div>
        <!-- // .slide_list -->
      </div>
      <!-- // .slide_box -->
      <div class="slide_btn_box">
        <button type="button" class="slide_btn_prev"></button>
        <button type="button" class="slide_btn_next"></button>
      </div>
      <!-- // .slide_btn_box -->
      <ul class="slide_pagination"></ul>
      <!-- // .slide_pagination -->
    </div>
    <!-- // .slide_wrap -->
  </div>
  <!-- // .container -->
<div class="option">
<h2>.상품명</h2>
	<table>
		<tr>
			<th>상품코드</th>
			<td class="code">blue</td>
		</tr>
		
		<tr>
			<th>사이즈</th>
			<td>
				<select name="ssize" id="ssize">
				<option value="" selected disabled>사이즈를 선택하세요</option>
				<option value="S">S</option>
				<option value="M">M</option>
				<option value="L">L</option>
				<option value="XL">XL</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<th>배송비</th>
			<td>무료배송</td>
		</tr>
		<tr>
			<th>가격</th>
			<td class="price">10000</td>
		</tr>
	</table>
<!-- 		스크롤 -->
	<div id="dynamicULArea"></div>
      <div class="product_mainbtns">
            <button class="product_btn left">장바구니</button>
            <button class="product_btn right">바로구매</button>
      </div>

</div>


	
</section>





<section class="info">
	<div>
		<h2 style="text-align: center;">상품설명</h2>
	</div>
</section>
<section class="reivew">
<h2 style="text-align: center;">상품리뷰</h2>
			
		<c:forEach items="${list1 }" var="bb">
			<table border="1" width="400px" align="center">
				<tr>
					<td>${bb.productrank } / 5</td>
					<td>${bb.bdate }</td>
				</tr>
				<tr>
					<th colspan="2" style="text-align: center;">${bb.btitle }</th>
				</tr>
				<tr>
					<td colspan="2">${bb.bcontent }</td>
				</tr>
				<tr>
					<td colspan="2"><img alt="" src="./image/${bb.bpicture }" width="200px" height="200px"> </td>
				</tr> 
				
			</table>
		</c:forEach>

</section>



<script type="text/javascript">

var selectOption = document.getElementById('ssize');
var dynamicULArea = document.getElementById('dynamicULArea');

function handleOptionChange() {

	  var price = parseInt(document.querySelector(".price").textContent);
	  var selectedOption = selectOption.value;
	  var code = document.querySelector(".code").textContent;	
	 
		$.ajax({
				type: "post",
	            async: true,
	            url: "check",
	            data: {"code": code, "ssize": selectedOption},
	            success: function(result) {
	            	addListItem(selectedOption,result,price);
	            },
	            error: function () {
	                alert("에러");
	            }
	        });
}
	// select 요소의 변경을 감지하는 이벤트 리스너를 추가합니다.
	selectOption.addEventListener('change', handleOptionChange);
	 
	function addListItem(content, stock, price) {

	    var newContent = '';
	    newContent += '<ul>'; 
	    newContent += '<li>' + content + ' ';
	    newContent += '<div class="btn-wrapper">';
	    newContent += '<div>';
	    newContent += '<span class="btn minus" onclick="decrement(this)"></span>';
	    newContent += '<input type="number" value="1" min="1" max="' + stock + '" name="su" id="su" onkeydown="if(event.keyCode == 13) event.preventDefault();">';
	    newContent += '<span class="btn plus" onclick="increment(this)"></span>';
	    newContent += '</div>';
	    newContent += '<div>';
	    newContent += '<p class="totpriceview" id="totpriceview">' + price + '원</p>';
	    newContent += '<button class="btn delete" onclick="removeul(this)"></button>';
	    newContent += '</div>';
	    newContent += '</div>';
	    newContent += '<span>(재고: ' + stock + ')</span></li>';
	    newContent += '</ul>'; 

	    // 기존 내용을 지우고 새로운 내용으로 대체합니다.
	    dynamicULArea.innerHTML = newContent;
	}


// '-' 버튼 클릭 시 수량 감소
function decrement(element) {
  var input = element.nextElementSibling;
  if (parseInt(input.value) > 1) {
    input.value = parseInt(input.value) - 1;
  }
  totalprice()
  
}

// '+' 버튼 클릭 시 수량 증가
function increment(element) {
  var input = element.previousElementSibling;
  input.value = parseInt(input.value) + 1;
  checkMax(input, input.getAttribute('max'));
  totalprice()
}

// 최대값 확인 함수
function checkMax(input, stock) {
  if (parseInt(input.value) > parseInt(stock)) {
    alert("최대 주문 가능한 수량은 " + stock + "개 입니다.");
    input.value = stock; // 입력된 값이 최대값을 초과하는 경우 최대값으로 변경
    
  }
}
function removeul(element) {
	  var ulElement = element.parentNode.parentNode.parentNode;
	  ulElement.parentNode.removeChild(ulElement);
	}
// 새로운 리스트 아이템을 추가하는 함수


function numbercommas(a) {
    return a.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); // 0,000원 결과값을 만들기 위한 정규식
}

function totalprice() {
	var price = parseInt(document.querySelector(".price").textContent);
    var su = document.getElementById("su").value;
    var totprice = parseInt(price) * parseInt(su);
    document.getElementById("totpriceview").innerText = numbercommas(totprice) + "원";
}








(function () {
    const slideList = document.querySelector('.slide_list');  // Slide parent dom
    const slideContents = document.querySelectorAll('.slide_content');  // each slide dom
    const slideBtnNext = document.querySelector('.slide_btn_next'); // next button
    const slideBtnPrev = document.querySelector('.slide_btn_prev'); // prev button
    const pagination = document.querySelector('.slide_pagination');
    const slideLen = slideContents.length;  // slide length
    const slideWidth = 450; // slide width
    const slideSpeed = 300; // slide speed
    const startNum = 0; // initial slide index (0 ~ 4)
    
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

    /** Next Button Event */
    slideBtnNext.addEventListener('click', function() {
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
    });

    /** Prev Button Event */
    slideBtnPrev.addEventListener('click', function() {
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
  })();

</script>

</body>
</html>