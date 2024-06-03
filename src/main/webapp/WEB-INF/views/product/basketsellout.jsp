<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
body{  
  padding: 0;
  margin: 0;
  width: 100%;
  height: 100%;
}
h3{
	text-align: center;
}
.product_sellform input[type="text"],
.product_sellform input[type="number"]{
    width: 330px;
    padding: 4px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #f9f9f9;
    display: inline-block;
    margin-bottom: 5px;
}

.product_sellform2 input[type="text"],
.product_sellform2 input[type="number"]{
    width: 200px;
    padding: 4px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #f9f9f9;
    display: inline-block;
    margin-bottom: 5px;
}


label{
	display: block;
    max-width: 100%;
    margin: 2px 0 2px 0;
    font-weight: 700;	
    vertical-align: middle;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.product_sell{
 	margin-top: 24px;
	width: 100%; 
	min-width:1650px;
	position:relative;
	display:flex;
    justify-content: center;
}
.product_sellform{
  	background-color: #fff;
	border-radius: 9px;
  	width: 600px;
  	height: auto;
	border:1px solid #808080;
	position: relative;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	padding: 0 20px 0 20px;
	margin-bottom: 100px;
}
.product_sellform2{
  	background-color: #fff;
	border-radius: 9px;
  	width: 300px; 
  	height: fit-content;
	border:1px solid #808080;
	position: relative;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	padding: 0 20px 60px 20px;
	margin-left: 20px;
	
}
.product_view{
	display: flex;
	margin: 7px 0;
}
.product_view p{
	margin: 7px;
	font-size: 16px;
}
.input_group{
	margin: 8px 0; 
}

.btn1{ 
	min-width: 80px; 
	height: 30px;
    padding: 0 10px;
    line-height: 28px;
    font-size: 12px;
    border-radius: 2px;
    background-color: #333;
    color: white;
}
#submit_btn{
	min-width: 150px; 
	height: 40px;
    padding: 0 10px;
    line-height: 28px;
    border-radius: 2px;
    background-color: #333;
    color: white;
    position: absolute;
    bottom: 12px;
    left: 74px;
    font-size: 17px;
    font-weight: 500;
}
#savepoint, #price, #saleprice,
#totprice, #availablePoint{
	background-color: white; 
	border: none;
}
#point {
	width: 250px; 
}
#address1, #address2{
	min-width: 430px;
}
.request{
	width: 300px;
	height: 30px;
}
#payment{
	display: inline-block;
	font-weight: 400;
	margin-top: -5px;
	font-size: 15px;
	margin-right: 10px;
}
</style>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<form action="" method="post" id="paymentForm">
<div class="product_sell">
  <div class="product_sellform">
      <h3>주문 / 결제</h3>
      <div class="input_group">
          <button type="button" class="btn1" onclick="openAddressPopup()">배송지 목록</button>
	      <label for="">배송지</label>
	      <input type="text" name="postcode" class="form-input3" id="postcode" placeholder="우편번호" required="required">
		  <input type="button" class="btn1" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
		  <input type="text" name="address1" class="form-input" id="address1" placeholder="주소" required="required"><br>
		  <input type="text" name="address2" class="form-input" id="address2" placeholder="상세주소" required="required">
      	  <input type="hidden" value="${rank }" id="rank">
      	  <label for="name">이름</label> 
      	  <input type="text" name="name" id="name" required="required">
      	  <label for="tel">연락처</label>
      	  <input type="text" name="tel" id="tel" required="required">
      </div>
     <div class="input_group">
     	<label>주문시 요청사항</label>
		<select name="request" class="request">
			<option value="부재">부재시 연락주세요</option>
			<option value="경비실">경비실에 보관해주세요</option>
			<option value="문앞" selected="selected">문앞에 놓아주세요</option>
		</select>
     </div>
    <div class="input_group">
	      <label>주문상품</label>
	      <c:set var="guestbuysu" value="0"/>
		  <c:set var="snum" value=""/>
          <c:set var="basketnum" value=""/>
		  <c:choose>
			  <c:when test="${fn:length(list) >= 2}">
			      <c:set var="sname" value="${list[0].productdto.sname} 외 ${fn:length(list) - 1}건"/>
			  </c:when>
			  <c:otherwise>
			      <c:set var="sname" value="${list[0].productdto.sname}"/>
			  </c:otherwise>
		  </c:choose>
			<c:forEach items="${list}" var="aa">
			    <div class="product_view">
			        <div>
			            <c:set var="imageArray" value="${fn:split(aa.productdto.image, ',')}" />
			            <c:forEach items="${imageArray}" var="imageName" varStatus="loop">
			                <c:if test="${loop.index == 0}">
			                    <img alt="" src="./image/${imageName}" width="70px" height="70px">
			                </c:if>
			            </c:forEach>
			        </div>
			        <div>
			            <p>${aa.productdto.getSname()}</p>
			            <p style="font-size: 14px; color: gray;">색상 : ${aa.color} / 사이즈 : ${aa.psize} / 수량 : ${aa.guestbuysu} </p>
			            <c:set var="guestbuysu" value="${guestbuysu + aa.guestbuysu}"/>
			        </div>
			    </div>
			    <c:choose>
			        <c:when test="${empty snum}">
			            <!-- 처음에는 단순히 변수를 설정합니다. -->
			            <c:set var="snum" value="${aa.snum}"/>
			            <c:set var="basketnum" value="${aa.basketnum}"/>
			        </c:when>
			        <c:otherwise>
			            <!-- 이후부터는 기존 값에 추가합니다. -->
			            <c:set var="snum" value="${snum},${aa.snum}"/>
			            <c:set var="basketnum" value="${basketnum},${aa.basketnum}"/>
			        </c:otherwise>
			    </c:choose>
			</c:forEach>
      </div>
      <div class="input_group">
	      <label>쿠폰</label>
	      <div class="coupon">
	      	<input type="text" name="useCoupon" id="useCoupon" onchange="couponPrice()" value="쿠폰사용안함" readonly="readonly"> 
	      	<button type="button" class="btn1" onclick="openCouponPopup()">쿠폰 목록</button>
	      </div>
	      <label>포인트</label>
	      <div class="point">
	      	<p>보유 포인트 : <input type="text" id="availablePoint" value="${point }" readonly="readonly"> </p>
			<p style="display: inline-block;">사용 포인트 : <input type="text" id="point" name="point" value="0" oninput="pointsPrice()"></p>
	      	<button type="button" class="btn1" onclick="allPointsPrice()">전액 사용</button>
	      </div>
      </div>
  </div>
  <div class="product_sellform2">
  	 <div class="input_group">
	      <div class="sell">
		        <label>주문 금액</label>	      
	      		<input type="text" value="${totprice }" id="totprice" name="totprice" readonly="readonly" >
	      		<label>할인 금액</label>
	      		<input type="text" value="0" id="saleprice" name="saleprice" readonly="readonly">
	      		<div id="detailSale"></div>
	      		<label>최종 금액</label>
	      		<input type="text" value="${totprice }" id="price" name="price" readonly="readonly" >
	      		<label>포인트 적립</label>
	      		<input type="text" value="" id="savepoint" name="savepoint" readonly="readonly">
	     		<label for="">결제방식</label>	     			
					<input type="radio" id="bank" value="무통장입금" name="payment" style="width: 17px;">
					<label for="bank" id="payment">무통장입금</label>
					<input type="radio" id="kakaopay" value="카카오페이" name="payment" style="width: 17px;">
					<label for="kakaopay" id="payment"><img alt="" src="./image/ico_kakaopay.png" width="52px" height="23px">카카오페이</label>
				<br>
				<div id="bank-selection" style="display: none;">
				    <label for="bank-choice">은행 선택:</label>
				    <select id="bank-choice" name="bankChoice" style="width: 100px; height: 30px;">
				        <option value="농협">농협은행</option>
				        <option value="국민">국민은행</option>
				        <option value="신한">신한은행</option>
				        <option value="우리">우리은행</option>
				        <option value="기업">기업은행</option>
				        <option value="하나">하나은행</option>
				    </select>
				</div>
				<input type="hidden" value="" id="guestbuysu" name="guestbuysu">
				<input type="hidden" value="" id="sname" name="sname">
				<input type="hidden" value="" id="snum" name="snum">
				<input type="hidden" value="" id="basketnum" name="basketnum">
				<input type="button" value="결 제" id="submit_btn" data-guestbuysu="${guestbuysu}" 
					   data-sname="${sname}" data-snum="${snum}" data-basketnum="${basketnum}" onclick="submitForm(this)">
      	  </div>
  	</div> 
	</div>
</div>
</form>
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() {
    // 임의의 총 가격 값, 실제 사용 시에는 서버로부터 받아오거나 계산하여 설정
    var totPrice = document.getElementById('totprice').value;
    var availablePoint = document.getElementById('availablePoint').value;
    var rank = document.getElementById('rank').value;
    var savepoint = totPrice * 0.01;
    
    var  rankdiscount = rankDiscount(totPrice, rank);
    var  finalPrice = totPrice - rankdiscount;
    
    // 입력 필드에 값을 설정
    document.getElementById('totprice').value = numberWithCommas(totPrice);
    document.getElementById('price').value = numberWithCommas(totPrice);
    document.getElementById('availablePoint').value = numberWithCommas(availablePoint);
    document.getElementById('savepoint').value = numberWithCommas(savepoint);
    document.getElementById('saleprice').value = numberWithCommas(rankdiscount);
    document.getElementById('price').value = numberWithCommas(finalPrice);
    
    if(rankdiscount>0){
	    document.getElementById('detailSale').innerHTML = "<p>&nbsp;ㄴ 등급할인 -" + numberWithCommas(rankdiscount) + " </p>";
    }
    
});
//rank ,totPrice전역변수
var rank = document.getElementById('rank').value;   
var totPrice = document.getElementById('totprice').value;


document.getElementById('point').addEventListener('focus', function() {
    if (this.value === '0') {
        this.value = '';
    }
});

function rankDiscount(price, rank) {
    const discounts = {1: 0.00, 2: 0.02, 3: 0.03, 4: 0.05};
    return price * discounts[rank];
}


function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function pointsPrice() {
    var availablePoint = parseInt(document.getElementById('availablePoint').value.replace(/,/g, ''), 10);
    var pointInput = document.getElementById('point').value;
    var usedPoint = pointInput.replace(/,/g, '').trim(); // 콤마 제거 및 양쪽 공백 제거
    
    if (usedPoint === '' || isNaN(usedPoint)) {
        usedPoint = 0;
        document.getElementById('point').value = '0'; // 입력 필드에 '0' 표시
    } else {
        usedPoint = parseInt(usedPoint, 10);
    }

    // 사용 가능 포인트를 초과하지 않도록 조정
    if (usedPoint > availablePoint) {
        usedPoint = availablePoint;
    }
    
    document.getElementById('point').value = numberWithCommas(usedPoint);
   
    var rankdiscount = rankDiscount(totPrice, rank);
    var coupondiscount = couponPrice();
  	var salePrice = coupondiscount
  	salePrice += rankdiscount;
    
    var maxUsablePoints = totPrice - salePrice;
    if (usedPoint > maxUsablePoints) {
        usedPoint = maxUsablePoints;
    }
    document.getElementById('point').value = numberWithCommas(usedPoint);

    salePrice += usedPoint;
    var finalPrice = totPrice - salePrice;
    
    
    var html="";
    // 할인 금액과 최종 금액 업데이트
    document.getElementById('saleprice').value = numberWithCommas(salePrice);
    document.getElementById('price').value = numberWithCommas(finalPrice);
    if(rankdiscount>0){
	    html += "<p>&nbsp;ㄴ 등급할인 -" + numberWithCommas(rankdiscount) + " </p>";
    }
    if(coupondiscount>0){
    	html += "<p>&nbsp;ㄴ 쿠폰할인 -" + numberWithCommas(coupondiscount) + " </p>";    	
    }
    if(usedPoint>0){
    	html += "<p>&nbsp;ㄴ 포인트할인 -" + numberWithCommas(usedPoint) + " </p>";    	    	
    }
    document.getElementById('detailSale').innerHTML = html
}

function allPointsPrice() {
	var salePrice = 0;
	var availablePoint = parseInt(document.getElementById('availablePoint').value.replace(/,/g, ''), 10);
	var usedPoint = availablePoint; // 바로 숫자로 사용
    var totPrice = parseInt(document.getElementById('totprice').value.replace(/,/g, ''), 10);
	
    var rankdiscount = rankDiscount(totPrice, rank);
	var coupondiscount = couponPrice();
	salePrice = coupondiscount
	salePrice += rankdiscount;
    // 최대 사용 가능 포인트 계산
    var maxUsablePoints = totPrice - salePrice;
    if (usedPoint > maxUsablePoints) {
        usedPoint = maxUsablePoints;
    }
    document.getElementById('point').value = numberWithCommas(usedPoint);

    salePrice += usedPoint;
    var finalPrice = totPrice - salePrice;
	var html="";
    // 할인 금액과 최종 금액 업데이트
    document.getElementById('saleprice').value = numberWithCommas(salePrice);
    document.getElementById('price').value = numberWithCommas(finalPrice);
    
    if(rankdiscount>0){
	    html += "<p>&nbsp;ㄴ 등급할인 -" + numberWithCommas(rankdiscount) + " </p>";
    }
    if(coupondiscount>0){
    	html += "<p>&nbsp;ㄴ 쿠폰할인 -" + numberWithCommas(coupondiscount) + " </p>";    	
    }
    if(usedPoint>0){
    	html += "<p>&nbsp;ㄴ 포인트할인 -" + numberWithCommas(usedPoint) + " </p>";    	    	
    }
    document.getElementById('detailSale').innerHTML = html
}
	
function couponPrice() {
    var totPrice = parseInt(document.getElementById('totprice').value.replace(/,/g, ''), 10); // 콤마 제거 후 정수 변환
    var couponValue = document.getElementById('useCoupon').value;
    var discount = 0;

    if (couponValue.endsWith('% 할인쿠폰')) {
        var percentage = parseInt(couponValue);
        discount = totPrice * (percentage / 100);
    } else if (couponValue.endsWith('원 할인쿠폰')) {
        discount = parseInt(couponValue);
    }
    else if (couponValue.endsWith('적용안함')) {
        discount = 0
    }
    return discount;
}

function openAddressPopup() {
    var popup = window.open("addressPopup", "Address Popup", "width=600,height=400");
    popup.focus();
}
function openCouponPopup() {
    var popup = window.open("couponPopup", "Coupon Popup", "width=550,height=500");
    popup.focus();
}

function kakaopay() {
	var postcode = document.getElementById('postcode').value;
	var address1 = document.getElementById('address1').value;
	var address2 = document.getElementById('address2').value;
	var address = postcode + ', ' + address1 + ', ' + address2;

	var formData = {
	     address: address,
	     name: $('#name').val(),
	     tel: $('#tel').val(),
	     request: $('#request').val(),
	     basketnum: $('#basketnum').val(),
	     usepoint : $('#point').val(),
	     savepoint : $('#savepoint').val(),
	     usecoupon : $('#useCoupon').val(),
	     snum: $('#snum').val(),
	     sname: $('#sname').val(),
	     guestbuysu: $('#guestbuysu').val(),
	     totprice: $('#price').val()
	    };

    $.ajax({
        type: 'POST',
        url: 'payready',
        contentType: 'application/json',
        data: JSON.stringify(formData),
        success: function (response) {
            // Ajax 요청이 성공하면 다음 페이지로 리디렉션
        	window.location.href = response;
            
        },
        error: function (xhr, status, error) {
            // 에러 처리
            console.error(error);
        }
    });
}

function submitForm(element) {
	var form = document.getElementById('paymentForm');
    var paymentTypeInput = document.querySelector('input[name="payment"]:checked');
    var paymentType = paymentTypeInput ? paymentTypeInput.value : null;
    var guestbuysu = element.getAttribute('data-guestbuysu');
    var sname = element.getAttribute('data-sname');
    var snum = element.getAttribute('data-snum');
    var basketnum = element.getAttribute('data-basketnum');
    
    document.getElementById('guestbuysu').value = guestbuysu;
    document.getElementById('sname').value = sname;
    document.getElementById('snum').value = snum;
    document.getElementById('basketnum').value = basketnum;
 // 폼의 유효성 검사 및 제출
    if (!form.checkValidity()) {
    	alert('모든 필수 항목을 채워주세요.');
        form.reportValidity();
        return;
    } 
    // 결제 방식이 선택되지 않았을 때 경고 표시
    if (!paymentType) {
        alert('결제 방식을 선택해주세요.');
        return; // 함수를 여기서 종료
    }
    
    if (paymentType === '무통장입금') {
        form.action = 'bankAction';
        form.submit();

    } 
    else if (paymentType === '카카오페이' && $('#price').val()==0) {
    	form.action = 'bankAction';
        form.submit();
    }
    else if (paymentType === '카카오페이') {
        kakaopay();
        return; // 카카오페이는 별도의 처리가 필요하므로 여기서 함수를 종료
    }
}

document.querySelectorAll('input[name="payment"]').forEach((input) => {
    input.addEventListener('change', function() {
        const bankSelection = document.getElementById('bank-selection');
        // '무통장입금' 선택 시 은행 선택 드롭다운 보이기
        if (this.value === '무통장입금' && this.checked) {
            bankSelection.style.display = 'block';
        } else {
            bankSelection.style.display = 'none';
        }
    });
});


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

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("address1").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("address2").focus();
        }
    }).open();
}
</script>
</body>
</html>