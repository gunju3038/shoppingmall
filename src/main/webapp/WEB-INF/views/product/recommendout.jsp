<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
body{
		visibility: hidden;
	}
body.visible{
	visibility: visible;
}
#tempertext{
	margin-top: 20px;
	text-align: center;
	font-size: 20px;
}
#recommendlist{
	margin-top: 30px;
	text-align: center;
	
}
#tempertextrefuse {
	margin-top: 20px;
	text-align: center;
	font-size: 20px;
}
hr{
	height: 2px;
	background: #000000;
}
h2{
	margin: 0;
}
/* 0도 이상이면 빨간색, 0도 아래면 파란색 표기 */
.positive {
   color: red;
}

.negative {
    color: blue;
}
a{
	text-decoration: none;
	color: black;
}
h2{
	text-align: center;
}
.product_list{
	position: relative;
    margin-top: 30px;
    max-width: 1920px;
    min-width: 1280px;
    padding-left: 80px;
    padding-right: 80px;	
}
.product_list h3{
	float: left;
	margin-left: 47%;
	margin-top:0;
	margin-bottom: 30px;
}
.product_list p{
	float: right;
	margin-bottom: 10px;
	margin-top: 15px;
}
.box{
	overflow: auto;
}
.clear{ 
	clear: both;
}
.product{ 
	list-style: none;
    width: 20%;
    float: left;
    margin-bottom: 30px;
    padding: 0 14px 0 0;
	
}
.product img{
	width: 100%;
	margin-bottom: 10px;
}
.product .name{
	font-weight: bold;
	font-size: 18px;
}
.product .price{
	font-size: 14px;
}

.paging {
    margin-top: 20px;
    text-align: center;
}

.paging ul {
    list-style: none;
    padding: 0;
}

.paging ul li {
    display: inline;
    margin-right: 5px;
}

.paging ul li a {
    text-decoration: none;
}

.paging ul li b {
    color: red;
}

.selected {
    font-weight: bold;
}

#footer {
	transform: translateY(100%);
}
</style>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">


// LCC DFS 좌표변환을 위한 기초 자료(기상청 단기예보 API에 위치 좌표 값을 넣어주려면 추가 변환이 필요)
var RE = 6371.00877; // 지구 반경(km)
var GRID = 5.0; // 격자 간격(km)
var SLAT1 = 30.0; // 투영 위도1(degree)
var SLAT2 = 60.0; // 투영 위도2(degree)
var OLON = 126.0; // 기준점 경도(degree)
var OLAT = 38.0; // 기준점 위도(degree)
var XO = 43; // 기준점 X좌표(GRID)
var YO = 136; // 기1준점 Y좌표(GRID)
//

// LCC DFS 좌표변환 ( code : "toXY"(위경도->좌표, v1:위도, v2:경도), "toLL"(좌표->위경도,v1:x, v2:y) )
function dfs_xy_conv(code, v1, v2) {
    var DEGRAD = Math.PI / 180.0;
    var RADDEG = 180.0 / Math.PI;

    var re = RE / GRID;
    var slat1 = SLAT1 * DEGRAD;
    var slat2 = SLAT2 * DEGRAD;
    var olon = OLON * DEGRAD;
    var olat = OLAT * DEGRAD;

    var sn = Math.tan(Math.PI * 0.25 + slat2 * 0.5) / Math.tan(Math.PI * 0.25 + slat1 * 0.5);
    sn = Math.log(Math.cos(slat1) / Math.cos(slat2)) / Math.log(sn);
    var sf = Math.tan(Math.PI * 0.25 + slat1 * 0.5);
    sf = Math.pow(sf, sn) * Math.cos(slat1) / sn;
    var ro = Math.tan(Math.PI * 0.25 + olat * 0.5);
    ro = re * sf / Math.pow(ro, sn);
    var rs = {};
    if (code == "toXY") {
        rs['lat'] = v1;
        rs['lng'] = v2;
        
        var ra = Math.tan(Math.PI * 0.25 + (v1) * DEGRAD * 0.5);
        ra = re * sf / Math.pow(ra, sn);
        var theta = v2 * DEGRAD - olon;
        if (theta > Math.PI) theta -= 2.0 * Math.PI;
        if (theta < -Math.PI) theta += 2.0 * Math.PI;
        theta *= sn;
        rs['x'] = Math.floor(ra * Math.sin(theta) + XO + 0.5);
        rs['y'] = Math.floor(ro - ra * Math.cos(theta) + YO + 0.5);
        
    }
    else {
        rs['x'] = v1;
        rs['y'] = v2;
        
        var xn = v1 - XO;
        var yn = ro - v2 + YO;
        ra = Math.sqrt(xn * xn + yn * yn);
        if (sn < 0.0) - ra;
        var alat = Math.pow((re * sf / ra), (1.0 / sn));
        alat = 2.0 * Math.atan(alat) - Math.PI * 0.5;

        if (Math.abs(xn) <= 0.0) {
            theta = 0.0;
        }
        else {
            if (Math.abs(yn) <= 0.0) {
                theta = Math.PI * 0.5;
                if (xn < 0.0) - theta;
            }
            else theta = Math.atan2(xn, yn);
        }
        var alon = theta / sn + olon;
        rs['lat'] = alat * RADDEG;
        rs['lng'] = alon * RADDEG;
    }
    return rs;
}
//

// 사용자에게 위치 정보 제공 요청하기
function getLocation() {
    if (navigator.geolocation) {
   
        
        if (true) { // 위치 정보 제공 요청 승인하면
        	// geolocation GPS API 실행(geolocation GPS API는 HTTP에 내장된 API이기 때문에 이 자바스크립트 선언 하나로 처리가 끝난다.)
        	navigator.geolocation.getCurrentPosition(function(position) {
//                 showPosition(position); // 위치 정보를 표시하는 함수 호출
                sendLocation(position); // 날씨 API에 위치 정보 전달 함수 호출
            }, showError);
        } 
            
           
            
   
    } else {
        console.log("Geolocation is not supported by this browser.");
    }
}
//

// // GPS API 정보 중 x(Latitude:위도)와 y(Longitude:경도) 값 추출하여 보여주기
// function showPosition(position) {
//     var latitude = position.coords.latitude;
//     var longitude = position.coords.longitude;
    
//     var locationElement = document.getElementById("location");
//     locationElement.innerHTML = "현재 귀하가 계신 곳의 위도는: " + latitude + ", 경도는: " + longitude;
// }
// //

// 위치 정보 요청을 거부 했을 경우 보이는 메세지 설정
function showError(error) {
	// 화면
    var locationElement = document.getElementById("location");
    locationElement.innerHTML = "사용자가 위치 정보 제공을 거부했습니다.<br><br>";
    
    var tempertextElement = document.getElementById("tempertext");
    tempertextElement.style.display = "none";
    
    var recommendlist = document.getElementById("recommendlist");
    recommendlist.style.display = "none";
    
    var tempertextrefuse = document.getElementById("tempertextrefuse");
    tempertextrefuse.style.display = "block";
    
    // 콘솔 
    switch(error.code) {
        case error.PERMISSION_DENIED:
            console.log("User denied the request for Geolocation.");
            break;
        case error.POSITION_UNAVAILABLE:
            console.log("Location information is unavailable.");
            break;
        case error.TIMEOUT:
            console.log("The request to get user location timed out.");
            break;
        case error.UNKNOWN_ERROR:
            console.log("An unknown error occurred.");
            break;
    }
}
//

// 기상청 단기예보 API에 위치 정보 전달
function sendLocation(position) {
	var latitude = position.coords.latitude; // GPS API 에서 받은 x 좌표 값
    var longitude = position.coords.longitude; // GPS API 에서 받은 y 좌표 값
    
    var convertedCoords = dfs_xy_conv("toXY", latitude, longitude); // 위 좌표변환 함수에 x,y값을 넣어주고 실행
    
    var convertedLatitude = convertedCoords.x; // 변환된 x 값
    var convertedLongitude = convertedCoords.y; // 변환된 y 값
    
    // AJAX 요청 보내기(기상청 단기예보 API 처리 과정 시작(productController.java))
    $.ajax({
        type: "POST",
        url: "bestproductoutweatherview",
        contentType: "application/json",
        data: JSON.stringify({ "convertedLatitude": convertedLatitude, "convertedLongitude": convertedLongitude }),
        success: function(response) {
        	displayWeather(response);
        },
        error: function(xhr, status, error) {
            alert("에러 발생: " + error);
        }
    });
}
//

// 시간 출력 형식을 지정하는 함수
    function formatTime(time) {
        var hours = time.slice(0, 2); // 시간 부분
        var minutes = time.slice(2); // 분 부분
        return hours + ":" + minutes; // 시간:분 형식으로 반환
    }
//

// 서버로부터 받은 날씨 데이터를 화면에 출력하는 함수
function displayWeather(weatherData) {
	if (!weatherData.id) {
	    $("#id").text("방문자");
	} else {
	    $("#id").text(weatherData.id);
	}
	
    // 최저온도 출력
    $("#lowFcstTime").text(formatTime(weatherData.lowfcstTime)); // 일 최저 온도 기준 시간
    
    var lowFcstValue = parseInt(weatherData.lowfcstValue); // 최저 온도 값
    var lowFcstValueText = Math.floor(lowFcstValue) + "℃"; // 소수점을 빼고 ℃ 로 표현
    $("#lowFcstValue").text(lowFcstValueText);
    $("#lowFcstValue").toggleClass("positive", lowFcstValue >= 0); // 0도 이상이면 빨간색 0도 아래면 파란색으로 표시하는 CSS 지정
    $("#lowFcstValue").toggleClass("negative", lowFcstValue < 0);
    
    // 최고온도 출력
    $("#highFcstTime").text(formatTime(weatherData.highfcstTime)); // 일 최고 온도 기준 시간
    
    var highFcstValue = parseInt(weatherData.highfcstValue);
    var highFcstValueText = Math.floor(highFcstValue) + "℃";
    $("#highFcstValue").text(highFcstValueText);
    $("#highFcstValue").toggleClass("positive", highFcstValue >= 0);
    $("#highFcstValue").toggleClass("negative", highFcstValue < 0);
    
    var avgTemp = (parseInt(weatherData.lowfcstValue) + parseInt(weatherData.highfcstValue)) / 2; // 정수로 바꿔서 온도 평균 계산
    
    // 평균 온도에 따라 출력문 조절
    if (avgTemp < 5) {
    	$("#tempertextdetail").text("날씨가 매우 춥습니다! 추위를 막아줄 두꺼운 코트와 목도리, 장갑을 착용해주세요.");
    }
    else if (avgTemp >= 5 && avgTemp < 15 ) {
    	$("#tempertextdetail").text("쌀쌀한 날씨입니다. 따뜻한 니트와 자켓을 입어보세요. 스카프도 함께하면 따뜻함을 느낄 수 있습니다.");
    }
    else if (avgTemp >= 15 && avgTemp < 20) {
    	$("#tempertextdetail").text("적당한 날씨입니다! 가볍고 스타일리시한 셔츠나 스웨터를 선택해보세요. 가벼운 재킷을 준비해두면 좋습니다.");
    }
    else if(avgTemp >= 20) {
    	$("#tempertextdetail").text("더운 날씨입니다! 시원하고 편안한 반팔 티셔츠를 선택하세요. 가벼운 반바지도 좋습니다.");
    }
    
    // 온도 기준에 따른 추천 상품 출력
    $.ajax({
        type: "POST",
        url: "recommendsearch",
        contentType: "application/json",
        data: JSON.stringify({ "avgTemp": avgTemp }),
        success: function(response) {
        	var html = '';
        	html += '<div class="product_list">';
        	html +=	'<div class="box">';
        	
            html += '<div class="clear"></div>';
            for (var i = 0; i < response.length; i++) {
                var aa = response[i];
                
                html += '<ul class="product">';
                html += '<li><a href="detailview?snum=' + aa.snum + '">';
                var imageArray = aa.image.split(',');
                for (var j = 0; j < imageArray.length; j++) {
                    if (j == 0) {
                        html += '<img alt="" src="./image/' + imageArray[j] + '">';
                    }
                }
                html += '</a></li>';
                html += '<li class="name"><a href="detailview?snum=${aa.snum}">' + aa.sname + '</a></li>';
                html += '<li class="price"><a href="detailview?snum=${aa.snum}">' + formatPrice(aa.price) + '</a></li>';
                if (aa.count != 0) {
                    html += '<li class="intro"><a href="detailview?snum=' + aa.snum + '">' + 
                            '<img alt="" src="./image/reviewStar.png" style="width: 17px;">' +
                            Math.round(aa.productrank * 10) / 10. + '</a></li>';
                    html += '<li class="review"><a href="detailview?snum=' + aa.snum + '">리뷰 수 : ' + aa.count + '</a></li>';
                }
                html += '</ul>';
            }
            html += '</div></div>'
            
            
            document.getElementById('recommendout').innerHTML = html; // 반복문 종료 후에 결과 출력
        },
        error: function(xhr, status, error) {
            alert("에러 발생: " + error);
        }
    });

    // 가격 포맷 변환 함수(, 추가)
    function formatPrice(price) {
    	return new Intl.NumberFormat('ko-KR').format(price);
    }
}
//


// 페이지 로드 시 GPS API 및 위치 정보 가져오기 자동 실행
window.onload = function() {
	var tempertextrefuse = document.getElementById("tempertextrefuse");
	tempertextrefuse.style.display = "none";
    getLocation();
};
//

// 화면 새로고침 하였을 때 alert창이 떴을 시 HTML 글들이 보이는 문제(FOUC(Flash Of Unstyled Content)현상) 수정
document.addEventListener('DOMContentLoaded', function() {
	document.body.classList.add("visible")
});

</script>
<meta charset="UTF-8">
<title>추천 상품 보기</title>
</head>
<body>

<div id="location"></div> <!-- 화면 시작 시 자바스크립트문 자동 실행  -->

<!-- 온도 출력 부분 -->
<div id="tempertext">
	<p>현재 <span id="id"></span> 님이 계신 장소의 최저 온도는 금일 <span id="lowFcstTime"></span> 시 기준 <span id="lowFcstValue"></span> </p><br>
	<p>최고 온도는 <span id="highFcstTime"></span> 시 기준 <span id="highFcstValue"></span> 입니다.</p><br>
	<p id="tempertextdetail"></p>
</div>

<!-- 위치 정보 제공 요청을 거절했을 경우 -->
<div id="tempertextrefuse">
	<p>죄송합니다.<br><br> 현재 페이지는 위치 정보 제공 요청을 승인하였을 경우에만 이용할 수 있습니다. </p>

</div>


<!-- 추천 상품 타이틀 출력 부분 -->
<div id="recommendlist">
<hr/>
	<h2>추천 상품</h2>
<hr/>
	
</div>

<!-- 추천 상품 내용 출력 부분-->
<div id="recommendout">


</div>

</body>
</html>
