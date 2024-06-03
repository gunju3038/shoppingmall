<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
h2{
	text-align: center;
}
a{
	text-decoration: none;
	color: black;
}

.couponlist{
	margin: 5px;
	padding: 10px;
	border: 1px solid gray;
	display: flex;
	justify-content: space-between;
}
.list_div img{
	width: 320px;
}
.btn_div {
    display: flex;
    justify-content: space-between; 
    align-items: center; /* 세로 방향 중앙 정렬 */
    flex: 0.85;
}
.btn_div button,
.resetbtn_div button{
	min-width: 60px; 
	height: 30px;
    padding: 0 10px;
    line-height: 28px;
    font-size: 12px;
    border-radius: 2px;
    background-color: #333;
    color: white;
}

.resetbtn_div {
        display: flex;
        justify-content: flex-end; /* 오른쪽 정렬 */
        margin: 0 5px 5px 0; /* 여백 조절 */
}
</style>


</head>
<body>
<h2>쿠폰 목록</h2>
<div class="resetbtn_div">
 <button type="button" onclick="setCoupon('쿠폰적용안함')">쿠폰적용안함</button>
 </div>
<c:forEach items="${list}" var="aa">
    <c:if test="${aa.mannum > 0}">
        <div class="couponlist">
            <div class="list_div">
            	<a><img alt="" src="resources/image/ico_10000coupon.png"> </a>
            </div>
            <div class="btn_div">
            <span>보유 : ${aa.mannum}</span>
                <button type="button" onclick="setCoupon('10000원 할인쿠폰')">사용</button>
            </div>
        </div>
    </c:if>
    <c:if test="${aa.tennum > 0}">
        <div class="couponlist">
            <div class="list_div">
            	<a><img alt="" src="resources/image/ico_10coupon.png"> </a>
            </div>
            <div class="btn_div">
            <span>보유 : ${aa.tennum}</span>
                <button type="button" onclick="setCoupon('10% 할인쿠폰')">사용</button>
            </div>
        </div>
    </c:if>
    
    <c:if test="${aa.twentinum > 0}">
        <div class="couponlist">
            <div class="list_div">
            	<a><img alt="" src="resources/image/ico_20coupon.png"> </a>
            </div>
            <div class="btn_div">
            <span>보유 : ${aa.twentinum}</span>
                <button type="button" onclick="setCoupon('20% 할인쿠폰')">사용</button>
            </div>
        </div>
    </c:if>

</c:forEach>
<script type="text/javascript">
function setCoupon(useCoupon) {
	window.opener.document.getElementById('useCoupon').value = useCoupon;
    window.opener.pointsPrice();
    window.close();
}
</script>
</body>
</html>