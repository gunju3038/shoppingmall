<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<style type="text/css">
a{
	text-decoration: none;
	color: gray;
}
h2{
  text-align:center;
  margin:0;
}
h5{
	margin-left: 5px;
    font-size: 15px;
    line-height: 4px;
}
.baskettable {
  border-top: solid 2px black;
  border-collapse: collapse;
  width: 100%;
  font-size: 14px;
}
.basketth {
  padding: 15px 0px;
  border-bottom: 1px solid lightgrey;
  text-align: center;
}
.baskettd {
  padding: 15px 0px;
  border-bottom: 1px solid lightgrey;
  text-align: center;
}
.product_list{
	margin-top: 24px;
    width: 72%;
    min-width:1360px;
    left:330px;
    position: absolute;
}

.cart_list_detail td:nth-child(1) { /* 이미지가 있는 두 번째 열의 td 요소를 선택합니다. */
  width: 160px; /* 이미지 칸의 너비를 조정합니다. */
  text-align: center; /* 이미지를 가운데 정렬합니다. */
}

.cart_list_detail td:not(:nth-child(1)) { /* 이미지가 아닌 나머지 열의 td 요소를 선택합니다. */
  text-align: center; /* 텍스트를 가운데 정렬합니다. */
}

.cart_delete{
  width: 60px;
  height: 30px;
  font-size: 12px;
  margin: auto;
  border-radius: 5px;
  color: #000;
  background-color:#fff;
  border: 1px #808080 solid;
}
.totalPrice{
	font-size: 24px;
	font-weight: 700;
}
.view, .delete{
	background-color: white;
	border: 1px solid gray;
	border-radius: 5px;
	width: 70px;
	height: 28px;
}
.view:hover, .delete:hover, .cart_btn.left:hover{
	background-color: #eee;
}
.cart_mainbtns {
  width: 420px;
  height: 200px;
  display: flex;
  margin: auto;
}
.cart_btn {
  width: 170px;
  height: 50px;
  font-size: 16px;
  margin: auto;
  border-radius: 5px;
}

.cart_btn.left {
  background-color: #fff;
  border: 1px #808080 solid;
}

.cart_btn.right {
  background-color: #333;
  color: white;
  border: none;
}
.cart_btn.right:hover {
  background: slategray;
}

input[type="number"]{
	width:50px;
}
</style>
<meta charset="UTF-8">
<title>장바구니</title>
</head>
<body>
<div class="product_list">
<form id="formselect" method="post"> <!-- 하단 버튼과 자바스크립트로 form 장소 선택 -->
	<h2>장바구니</h2>
    <table  class="baskettable" align="center">
        <tr>
            <th class="basketth">선택</th>
            <th class="basketth">상품이미지</th>
            <th class="basketth">상품명</th>
            <th class="basketth">상품색상</th>
            <th class="basketth">상품사이즈</th>
            <th class="basketth">상품수량</th>
            <th class="basketth">상품가격</th>
        </tr>
                <c:forEach items="${list }" var="aa" varStatus="loop">
                    <tr data-index="${loop.index}">
						<!-- 선택 -->
                        <td class="baskettd">
                            <input type="checkbox" name="item" value="${aa.basketnum }" class="checkitem" style="width: 17px; height: 17px;">
                        </td>  
						<!-- 이미지 -->
						<td class="baskettd">
                            <a href="detailview?snum=${aa.snum}">
							<c:set var="imageArray" value="${fn:split(aa.productdto.image, ',')}" />
							<c:forEach items="${imageArray}" var="imageName" varStatus="loop_image">
		   						<c:if test="${loop_image.index == 0}">
		       						<img alt="" src="./image/${imageName}" width="80px" height="80px">
		   						</c:if>
							</c:forEach>
							</a>
							<input type="hidden" name="image" value="${aa.productdto.image}">
						</td>
                        <!-- 상품명 -->
                        <td class="baskettd">
                        	<a href="detailview?snum=${aa.snum}">
                            <span>${aa.productdto.getSname() }</span>
                            </a>
                            <input type="hidden" name="sname" value="${aa.productdto.sname }">
                        </td>
                        <!-- 색상 -->
                        <td class="baskettd">
                            <span>${aa.color }</span>
                            <input type="hidden" name="ssize" value="${aa.color }">
                        </td>
                        <!-- 사이즈 -->
                        <td class="baskettd">
                            <span>${aa.psize }</span>
                            <input type="hidden" name="ssize" value="${aa.psize }">
                        </td>
                        <!-- 수량 -->
                        <td class="baskettd">
                        	<c:choose>
                        		<c:when test="${aa.stock == 0 }">
									<input type="number" name="guestbuysu" value="0" id="su_${loop.index}" min="0" max="${aa.stock }" oninput="checkNumber(this)" >
                        		</c:when>
                        		<c:otherwise>
		                            <input type="number" name="guestbuysu" value="${aa.guestbuysu}" id="su_${loop.index}" min="1" max="${aa.stock }" oninput="checkNumber(this)" >
                        		</c:otherwise>
                        	</c:choose>
                            <p>재고 : ${aa.stock }</p>
                        </td>
                        <!-- 가격 -->
                        <td class="baskettd">
                            <span id="totpriceview_${loop.index}">  
                            <f:formatNumber value="${aa.productdto.price * aa.guestbuysu }" pattern="#,###원"/>
                            </span>
                            <input type="hidden" name="totprice"  id="totpriceid_${loop.index}">
                            <input type="hidden" name="snum" value="${aa.snum }">
                    	    <input type="hidden" name="price" value="${aa.productdto.price}" id="price_${loop.index}">
                        </td>
                    </tr>
                    </c:forEach>
                    <tr>
                    	<td colspan="6" align="left" style="padding-top: 10px;">
                    		<input type="button" value="전체 선택" onclick="toggleCheckboxtrue()" class="view">
							<input type="button" value="전체 해제" onclick="toggleCheckboxfalse()" class="delete">
                    	</td>
                    	<td align="right" style="padding-top: 10px;">
							<input type="button" value="선택 삭제" onclick="submitbasketdeleteAndcheckboxclick()" class="delete">
                    	</td>
                    </tr>
                    <tr>
                    	<td colspan="7" align="center" class="totalPrice" >
                    		합계 : <span id="totalPriceDisplay"> 0원</span> 
                    		<input type="hidden" name="topPrice" value=""> 
                    	</td>
                    </tr>
	 </table>    
	 <div class="cart_mainbtns">
			<button type="button" class="cart_btn left" onclick="history.back()">계속 쇼핑하기</button>
            <button class="cart_btn right" onclick="submitbasketsellAndcheckboxclick()">주문하기</button>
      </div>
         
</form>
</div>
<script>
$(document).ready(function() {
    // 수량이 변경되었을 때 총 가격 업데이트
    $('input[name="guestbuysu"]').change(function() {
        var index = $(this).attr('id').split('_')[1];
        updatePriceForRow(index);
        updateTotal();
    });

    // 체크박스 상태가 변경될 때 총합 업데이트
    $('.checkitem').change(function() {
        updateTotal();
    });

    // 행별 가격 업데이트 함수
    function updatePriceForRow(index) {
        var price = parseInt($('#price_' + index).val(), 10);
        var quantity = parseInt($('#su_' + index).val(), 10);
        var totalPrice = price * quantity;
        $('#totpriceview_' + index).text(numberCommas(totalPrice) + '원');
    }

    // 전체 가격 합계 업데이트 함수
    function updateTotal() {
        var total = 0;
        $('.checkitem:checked').each(function() {
            var index = $(this).closest('tr').data('index');
            var price = parseInt($('#price_' + index).val(), 10);
            var quantity = parseInt($('#su_' + index).val(), 10);
            total += price * quantity;
        });
        $('#totalPriceDisplay').text(numberCommas(total) + '원');
        $('input[name="topPrice"]').val(total);
    }

    // 숫자에 콤마 추가
    function numberCommas(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    
    
 // 2. 체크박스 선택 확인 및 각각 다른 submit을 실행
	function submitbasketdeleteAndcheckboxclick() {
	    var checkboxes = document.querySelectorAll('input[name="item"]:checked');
	    if (checkboxes.length === 0) {
	        // 체크박스가 선택되지 않았을 때 확인 대화 상자 표시
	        alert("하나 이상의 항목을 선택해야 합니다.");
	    } else {
	        // 확인 대화 상자에서 확인을 누를 경우에만 삭제 작업 수행
	        if (confirm("정말로 삭제하시겠습니까?")) {
	            var form = document.getElementById('formselect');
	            form.action = 'basketdelete';
	            form.submit();
	        }
	    }
	}
	
	function submitbasketsellAndcheckboxclick() {
	    var checkboxes = document.querySelectorAll('input[name="item"]:checked');
	    if (checkboxes.length === 0) {
	        // 체크박스가 선택되지 않았을 때 확인 대화 상자 표시
	        alert("하나 이상의 항목을 선택해야 합니다.");
	    } else {
	        var form = document.getElementById('formselect');
	        form.action = 'productsell';
	        form.submit();
	    }
	}

	// 3. 체크박스 전체 선택 및 해제
	function toggleCheckboxtrue() {
	    var checkbox = document.querySelectorAll('input[type="checkbox"]');
	    var selectAllCheckbox = document.querySelector('input[value="전체 선택"]');
	    
	    if (selectAllCheckbox.value === "전체 선택") {
	        for (var i = 0; i < checkbox.length; i++) {
	            checkbox[i].checked = true;
	        }
	        updateTotal();  // 합계 업데이트 호출

	    }
	}
	
	function toggleCheckboxfalse() {
		 var checkbox = document.querySelectorAll('input[type="checkbox"]');
		 var selectAllCheckbox = document.querySelector('input[value="전체 해제"]');
		 
		 if (selectAllCheckbox.value === "전체 해제") {
		        for (var i = 0; i < checkbox.length; i++) {
		        	checkbox[i].checked = false;
		        }
		        updateTotal();  // 합계 업데이트 호출
		 }
	}
	window.submitbasketdeleteAndcheckboxclick = submitbasketdeleteAndcheckboxclick;
    window.submitbasketsellAndcheckboxclick = submitbasketsellAndcheckboxclick;
    window.toggleCheckboxtrue = toggleCheckboxtrue;
    window.toggleCheckboxfalse = toggleCheckboxfalse;
    window.updateTotal = updateTotal;
    window.updatePriceForRow = updatePriceForRow;
});

function checkNumber(element) {
	  var max = parseInt(element.max, 10);  // 최대값
	  var value = parseInt(element.value, 10);  // 현재 입력 값
	  if (isNaN(value)) {
	    element.value = 1;  // 숫자가 아니면 1로 설정
	  } else if (value > max) {
	    element.value = max;  // 최대값을 초과하면 최대값으로 설정
	}
}
</script>
</body>
</html>
