<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
// 카카오 페이 결재
function kakaopay() {
	var formData = {
			address: $('#display_address').val(),
			name: $('#display_name').val(),
			tel: $('#display_tel').val(),
			email: $('#display_email').val(),
			request: $('#request').val(),
			
			ordernum: $('#ordernum').val(),
			snum: $('#snum').val(),
            sname: $('#sname').val(),
            guestbuysu: $('#guestbuysu').val(),
            totprice: $('#totprice').val()
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

// 주소 수정
function openAddressUpdateWindow() {
	// 주소 수정창 크기 조절
	var width = 300;
    var height = 200;
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
	        
	        document.getElementById('display_address').value = updatedAddress.fullAddress;
	        
	        updateWindow.close();
        }
    }

    // 수정된 주소 정보를 수신하면 위의 receiveUpdatedAddress 함수 호출
    
    	window.addEventListener('message', receiveUpdatedAddress);	
    
}

// 이름 수정
function openNameUpdateWindow() {
	
	var width = 300;
    var height = 200;
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
	        
	        document.getElementById('display_name').value = newName.updatedName;
	        
	        updateWindow.close();
        }
    }

    // 수정된 이름 정보를 수신하면 위의 receiveUpdatedName 함수 호출
    window.addEventListener('message', receiveUpdatedName);
}

// 연락처 수정
function openTelUpdateWindow() {
	
	var width = 300;
    var height = 200;
    var leftPosition = (window.screen.width - width) / 2; 
    var topPosition = (window.innerHeight - height) / 2; 
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    
    var updateWindow = window.open('updatetel', '_blank', options);
    
    
    function receiveUpdatedTel(event) {
    
        if (event.data.type === 'telUpdate') {
	        var newTel = event.data.data;
	        
	        document.getElementById('display_tel').value = newTel.updatedTel;
	        
	        updateWindow.close();
        }
    }

    
    window.addEventListener('message', receiveUpdatedTel);
}

// 이메일 수정
function openEmailUpdateWindow() {
	
	var width = 300;
    var height = 200;
    var leftPosition = (window.screen.width - width) / 2; 
    var topPosition = (window.innerHeight - height) / 2; 
    var options = 'width=' + width + ', height=' + height + ', left=' + leftPosition + ', top=' + topPosition;
    
    
    var updateWindow = window.open('updateemail', '_blank', options);
    
    
    function receiveUpdatedEmail(event) {
        
        if (event.data.type === 'emailUpdate') {
	        var newEmail = event.data.data;
	        
	        document.getElementById('display_email').value = newEmail.updatedEmail;
	        
	        updateWindow.close();
        }
    }

    window.addEventListener('message', receiveUpdatedEmail);
}
</script>
<meta charset="UTF-8">
<title>구매 페이지</title>
</head>
<body>
	<div>
		<table border="1" width="500px" align="center">
		<c:forEach items="${list }" var="aa">
			<tr>
				<th>배송지</th> 
				<td colspan="4">
					<input type="text" name="newaddress" value="${aa.address }" id="display_address" style="width: 300px;"> 
					<input type="hidden" name="address" value="${aa.address }"> 
					
				</td>
				<td>
					<input type="button" value="수정" onclick="openAddressUpdateWindow()">
				</td>
			</tr>
			<tr>
				<th>이름</th> 
				<td colspan="4">
					<input type="text" name="newname" value="${aa.name }" id="display_name" style="width: 300px;">
					<input type="hidden" name="name" value="${aa.name }"> 
				</td>
				<td>
					<input type="button" value="수정" onclick="openNameUpdateWindow()">
				</td>
			</tr>
			<tr>
				<th>연락처</th> 
				<td colspan="4">
					<input type="text" name="newtel" value="${aa.tel }" id="display_tel" style="width: 300px;">
					<input type="hidden" name="tel" value="${aa.tel }"> 
				</td>
				<td>
					<input type="button" value="수정" onclick="openTelUpdateWindow()">
				</td>
			</tr>
			<tr>
				<th>Email</th> 
				<td colspan="4">
					<input type="text" name="newemail" value="${aa.email }" id="display_email" style="width: 300px;">
					<input type="hidden" name="email" value="${aa.email }"> 
				</td>
				<td>
					<input type="button" value="수정" onclick="openEmailUpdateWindow()">
				</td>
			</tr>
			<tr>
				<th>배송 요청사항</th>
				<td colspan="5">
					<select name="request" id="request">
						<option value="부재시 연락주세요">부재시 연락주세요</option>
						<option value="경비실에 보관해주세요">경비실에 보관해주세요</option>
						<option value="문앞에 놓아주세요">문앞에 놓아주세요</option>
					</select>
				</td>
			</tr>
	</div>
	
	<div>
			<tr>
				<th>상품이미지</th>
				<th>상품명</th>
				<th>상품사이즈</th>
				<th>상품색상</th>
				<th>상품수량</th>
				<th>상품가격</th>
			</tr>
			<tr>
				<td>
					<input type="hidden" name="ordernum" value="${aa.ordernum }" id="ordernum"> <!-- 주문번호 -->
					<img alt="" src="./image/${aa.image }" width="60px" height="60px">
					<input type="hidden" name="image" value="${aa.image }"> 
				</td>
				<td>
					<span>${aa.sname }</span>
					<input type="hidden" name="sname" value="${aa.sname }" id="sname">
				</td>
				<td>
					<span>${aa.ssize }</span>
					<input type="hidden" name="ssize" value="${aa.ssize }">
				</td>
				<td>
					<span>${aa.color }</span>
					<input type="hidden" name="ssize" value="${aa.color }">
				</td>
				<td>
					<span>${aa.guestbuysu }</span>
					<input type="hidden" name="guestbuysu" value="${aa.guestbuysu }" id="guestbuysu">
				</td>
				<td>
					<span><f:formatNumber value="${aa.totprice }" pattern="#,###원"/></span>
					<input type="hidden" name="totprice" value="${aa.totprice }" id="totprice">
					<input type="hidden" name="snum" value="${aa.snum }" id="snum">
					<input type="hidden" name="stype" value="${aa.stype }">
				</td>
			</tr>
			<tr>
				<td colspan="5" align="center">
					<button onclick="kakaopay()"><f:formatNumber value="${aa.totprice }" pattern="#,###원" /> 구입하기</button>
				</td>
			</tr>
		</table>	
		</c:forEach>
	</div>

</body>
</html>