<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
	#tempertext{
		margin-top: 50px;
		text-align: center;
		font-size: 20px;
	}
	#recommendlist{
		margin-top: 50px;
		text-align: center;
		
	}
	hr{
		height: 2px;
		background: #000000;
	}
	/* 0도 이상이면 빨간색, 0도 아래면 파란색 표기 */
	.positive {
    color: red;
	}
	
	.negative {
	    color: blue;
	}
	/* */
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
        var permission = confirm("이 웹사이트에서는 현재 위치 정보를 사용합니다. 위치 정보를 허용하시겠습니까?");
        
        if (permission) { // 위치 정보 제공 요청 승인하면
        	// geolocation GPS API 실행(geolocation GPS API는 HTTP에 내장된 API이기 때문에 이 자바스크립트 선언 하나로 처리가 끝난다.)
        	navigator.geolocation.getCurrentPosition(function(position) {
//                 showPosition(position); // 위치 정보를 표시하는 함수 호출
                sendLocation(position); // 날씨 API에 위치 정보 전달 함수 호출
            }, showError);
        } else {
            var locationElement = document.getElementById("location");
            locationElement.innerHTML = "사용자가 위치 정보 제공을 거부했습니다.";
            console.log("사용자가 위치 정보를 거부했습니다.");
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
    locationElement.innerHTML = "사용자가 위치 정보 제공을 거부했습니다.";
    
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
    	$("#tempertextdetail").text("추운 겨울 날씨네요. 아래 상품을 추천드립니다.");
    }
    else if (avgTemp >= 5 && avgTemp < 15 ) {
    	$("#tempertextdetail").text("쓸쓸한 날씨네요. 아래 상품을 추천드립니다.");
    }
    else if (avgTemp >= 15 && avgTemp < 20) {
    	$("#tempertextdetail").text("더운 날씨네요. 아래 상품을 추천드립니다.");
    }
    else if(avgTemp >= 20) {
    	$("#tempertextdetail").text("무더운 여름 날씨네요. 아래 상품을 추천드립니다.");
    }
    
    $.ajax({
        type: "POST",
        url: "recommendsearch", // recommendsearch 경로로 요청을 보냅니다. 이 경로는 실제로 해당 요청을 처리할 서버 측 엔드포인트여야 합니다.
        contentType: "application/json",
        data: JSON.stringify({ "avgTemp": avgTemp }), // avgTemp 값을 요청 데이터로 전송합니다.
        success: function(response) {
            console.log(response);
        },
        error: function(xhr, status, error) {
            alert("에러 발생: " + error);
        }
    });
}
//


// 페이지 로드 시 GPS API 및 위치 정보 가져오기 자동 실행
window.onload = function() {
    getLocation();
};
//


</script>
<meta charset="UTF-8">
<title>추천 상품 보기</title>
</head>
<body>

<div id="location"></div> <!-- 화면 시작 시 자바스크립트문 자동 실행  -->
<div id="tempertext">
	<p>현재 <span id="id"></span> 님이 계신 장소의 최저 온도는 금일 <span id="lowFcstTime"></span> 시 기준 <span id="lowFcstValue"></span> </p><br>
	<p>최고 온도는 <span id="highFcstTime"></span> 시 기준 <span id="highFcstValue"></span> 입니다.</p><br>
	<p id="tempertextdetail"></p>
</div>

<div id="recommendlist">
<hr/>
	<h2>추천 상품</h2>
<hr/>
	
</div>
<c:forEach items="${list }" var="aa">
	<a href="detailview?snum=${aa.snum}">
		<div>
			<table border="1" width="200px" align="center">
				<tr>
					<td>
						<c:if test="${aa.best eq 1}"> <!-- best가 1이라면 베스트 상품 출력 -->
							베스트 상품
						</c:if>
					</td>
				</tr>
				<tr>
					<td>
						<c:set var="imageArray" value="${fn:split(aa.image, ', ')}" />
						<c:forEach items="${imageArray}" var="imageName" varStatus="loop">
		   					<c:if test="${loop.index == 0}">
		       					<img alt="" src="./image/${imageName }" width="100px" height="100px">
		       					
		   					</c:if>
						</c:forEach>
						<input type="hidden" name="snum" value="${aa.snum }">
					</td>
				</tr>
				<tr>
					<td>${aa.sname }</td>
				</tr>
				<tr>	
					<td><f:formatNumber value="${aa.price }" pattern="#,###원"/> </td>
				</tr>
			</table>
		</div>
	</a>
</c:forEach>
	
</body>
</html>
