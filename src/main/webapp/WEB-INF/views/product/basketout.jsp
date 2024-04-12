<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<!DOCTYPE html>
<html>
<head>
<script>
	// 1. 총 금액 계산 갱신 관련 스크립트
    function totalprice(rowId) {
        var price = document.getElementById("price_" + rowId).value;
        var su = document.getElementById("su_" + rowId).value;
        var totprice = parseInt(price) * parseInt(su);

        document.getElementById("totpriceid_" + rowId).value = totprice; // hidden 총 금액
        document.getElementById("totpriceview_" + rowId).innerText = numbercommas(totprice) + "원"; // 사용자에게 보여지는 총 금액, 위의 정규식 포함 결과값 끝에 원을 붙임
        
        updateTotalPrice(); // 총 가격 업데이트
    }
	
    function numbercommas(a) {
        return a.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); // 0,000원 결과값을 만들기 위한 정규식
    }
	
    // c:forEash 반복 출력에 따른 각각의 목록 총 금액 갱신
    window.addEventListener("load", function() {
        var suInputs = document.querySelectorAll('input[name="guestbuysu"]');
        suInputs.forEach(function(input) {
            var rowId = input.getAttribute("data-row-id"); // 목록의 수량마다 고유 id 부여
            totalprice(rowId);
        });
    });
   // 1. 총 금액 계산 갱신 관련 스크립트 end
	
   
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
	        form.action = 'basketsell';
	        form.submit();
	    }
	}

	// 2. 체크박스 선택 확인 및 각각 다른 submit을 실행 end
	
	// 3. 체크박스 전체 선택 및 해제
	function toggleCheckboxtrue() {
	    var checkbox = document.querySelectorAll('input[type="checkbox"]');
	    var selectAllCheckbox = document.querySelector('input[value="전체 선택"]');
	    
	    if (selectAllCheckbox.value === "전체 선택") {
	        for (var i = 0; i < checkbox.length; i++) {
	            checkbox[i].checked = true;
	        }
	    } 
	}
	
	function toggleCheckboxfalse() {
		 var checkbox = document.querySelectorAll('input[type="checkbox"]');
		 var selectAllCheckbox = document.querySelector('input[value="전체 해제"]');
		 
		 if (selectAllCheckbox.value === "전체 해제") {
		        for (var i = 0; i < checkbox.length; i++) {
		        	checkbox[i].checked = false;
		        }
		 }
	}
	// 3. 체크박스 전체 선택 및 해제 end
	
	// 4. 장바구니에 등록된 목록의 총 가격을 업데이트하는 함수
	// 위의 1. 총 금액 계산 갱신 관련 스크립트와 연계
	function updateTotalPrice() {
        var totalPrice = 0;
        var spans = document.querySelectorAll('span[id^="totpriceview_"]');
    
        spans.forEach(function(span) {
            var priceText = span.innerText.replace("원", "").replace(",", "");
            totalPrice += parseInt(priceText);
        });
    
        document.getElementById("totalPriceDisplay").innerText = numbercommas(totalPrice) + "원";
    }
 	// 4. 장바구니에 등록된 목록의 총 가격을 업데이트하는 함수 end
    
 	
    // 5. 체크박스를 체크한 목록의 총 가격을 업데이트 하는 함수
    function updateCheckboxTotalPrice() {
	    var totalPrice = 0;
	
	    // 선택된 체크박스들을 반복하며 총 가격 계산
	    var checkboxes = document.querySelectorAll('input[name="item"]:checked');
	    checkboxes.forEach(function(checkbox) {
	        var rowId = checkbox.value; // checkbox의 value에는 각 항목의 basketnum이 들어 있음
	        var totpriceView = document.getElementById("totpriceview_" + rowId);
	        var priceText = totpriceView.innerText.replace("원", "").replace(",", "");
	        totalPrice += parseInt(priceText);
	    });
	
	    // 총 가격 업데이트
	    document.getElementById("totalPriceCheckboxDisplay").innerText = numbercommas(totalPrice) + "원";
	}
 	// 5. 체크박스를 체크한 목록의 총 가격을 업데이트 하는 함수 end
</script>
<style type="text/css">s
table {
    width: 900px;
    text-align: center;
    border: 1px solid #fff;
    border-spacing: 1px;
    font-family: 'Cairo', sans-serif;
  margin: auto;
}

caption {
    font-weight: bold;
}

table td {
    padding: 10px;
    background-color: #eee;
}

table th {
    background-color: #333;
    color: #fff;
    padding: 10px;
}

img {
    width: 90px;
    height: 90px;
}

.view,
.delete {
    border: none;
    padding: 5px 10px;
    color: #fff;
    font-weight: bold;
}

.view {
    background-color: #03A9F4;
}

.delete {
    background-color: #E91E63;
}

.tablefoot {
    padding: 0;
    border-bottom: 3px solid #009688;
}
</style>
<meta charset="UTF-8">
<title>장바구니</title>
</head>
<body>
<form id="formselect" method="post"> <!-- 하단 버튼과 자바스크립트로 form 장소 선택 -->
    <table border="1" align="center">
        <tr>
            <th>선택</th>
            <th>상품이미지</th>
            <th>상품명</th>
            <th>상품사이즈</th>
            <th>상품색상</th>
            <th>상품수량</th>
            <th>상품가격</th>
            <th>주문관리</th>
        </tr>
            <div>
                <c:forEach items="${list }" var="aa" varStatus="loop">
                    <tr>
                        <td>
                            <input type="checkbox" name="item" value="${aa.basketnum }">
                            <input type="hidden" name="basketnum" value="${aa.basketnum }">
                        </td>
                        
                        <td>
                            <a href="detailview?snum=${aa.snum}">
                            <img alt="" src="./image/${aa.image }" width="60px" height="60px">
                            </a>
                            <input type="hidden" name="image" value="${aa.image }"> 
                        </td>
                        <td>
                        	<a href="detailview?snum=${aa.snum}">
                            <span>${aa.sname }</span>
                            </a>
                            <input type="hidden" name="sname" value="${aa.sname }">
                            
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
                            <input type="number" name="guestbuysu" value="${aa.guestbuysu}" id="su_${loop.index}" data-row-id="${loop.index}" min="1" max="99" onchange="totalprice(${loop.index})">
            				<input type="hidden" name="price" value="${aa.price}" id="price_${loop.index}">
                        </td>
                        <td>
                            <span id="totpriceview_${loop.index}">0원</span>
                            <input type="hidden" name="totprice" value="${aa.totprice}" id="totpriceid_${loop.index}">
                            <input type="hidden" name="snum" value="${aa.snum }">
                            <input type="hidden" name="stype" value="${aa.stype }">
                        </td>
                       <td align="center">
	                		<input type="button" value="목록삭제" onclick="submitbasketdeleteAndcheckboxclick()" class="delete">
	                		<input type="button" value="구매하기" onclick="submitbasketsellAndcheckboxclick()" class="view">
	                	</td>
                    </tr>
                    </c:forEach>
                    <tr>
                    	<td colspan="5" align="left">
                    		<input type="button" value="전체 선택" onclick="toggleCheckboxtrue()" class="view">
							<input type="button" value="전체 해제" onclick="toggleCheckboxfalse()" class="delete">
                    	</td>
                    	<td colspan="3" align="right">
                    		총 가격 : <span id="totalPriceDisplay">0원</span>
                    		체크박스 총 가격 : <span id="totalPriceCheckboxDisplay">0원</span>
                    	</td>
                    </tr>
             </div>     
	 </table>    
				
            <div>
		    <!-- 페이징처리 -->
			<table align="center">
				<tr style="border-left: none;border-right: none;border-bottom: none">
				   <td colspan="7" style="text-align: center;">
				   
				   <c:if test="${paging.startPage!=1 }"> 
				      <a href="basketout?nowPage=${paging.startPage-1 }&cntPerPage=${paging.cntPerPage}">◀</a> 
				      
				   </c:if>   
				   
				      <c:forEach begin="${paging.startPage }" end="${paging.endPage}" var="p"> 
				         <c:choose>
				            <c:when test="${p == paging.nowPage }"> 
				               <b><span style="color: red;">${p}</span></b>
				            </c:when>   
				            <c:when test="${p != paging.nowPage }"> 
				               <a href="basketout?nowPage=${p}&cntPerPage=${paging.cntPerPage}">${p}</a>
				            </c:when>   
				         </c:choose>
				      </c:forEach>
				     
				      <c:if test="${paging.endPage != paging.lastPage}">
				      <a href="basketout?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage }">▶</a>
				   </c:if>
				   
				   </td>
				</tr>
			</table>
			<!-- 페이징처리 -->
			</div>
</form>
</body>
</html>
