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
h2 {
    text-align: center;
    margin: 50px 0;
}
a {
    text-decoration: none;
    color: black;
}
.couponlist {
    margin: 5px;
    padding: 10px;
    display: flex;
    flex-direction: column; /* 수직 정렬을 위해 flex-direction 설정 */
    align-items: center; /* 아이템들을 가운데 정렬 */
    width: auto;
    box-sizing: border-box;
    margin-right: 30px;
}
.couponlist img {
    width: 250px;
}
.couponview {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    margin: 0 auto;
    max-width: 1200px;
    flex-wrap: nowrap;
    overflow-x: auto;
    justify-content: center;
}
.btn_div {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 10px;
}
.couponsection {
    text-align: center;
    margin-bottom: 20px;
}
.cnum {
    margin: 5px;
    padding: 10px;
    border: 1px solid gray;
    display: inline-block;
    font-size: 20px;
    margin-bottom: 40px;
}
</style>
</head>
<body>
<div>
    <h2>쿠폰 목록</h2>
    <c:forEach items="${list}" var="aa">
        <div class="couponsection">
            <h2 class="cnum">나의 쿠폰 총 개수 : ${aa.couponnum}개</h2>
            <div class="couponview">
                <c:if test="${aa.mannum > 0}">
                    <div class="couponlist">
                        <div class="list_div">
                            <a><img alt="" src="./image/ico_10000coupon.png"></a>
                        </div>
                        <div class="btn_div">
                            <span>보유 : ${aa.mannum}</span>
                        </div>
                    </div>
                </c:if>
                <c:if test="${aa.tennum > 0}">
                    <div class="couponlist">
                        <div class="list_div">
                            <a><img alt="" src="./image/ico_10coupon.png"></a>
                        </div>
                        <div class="btn_div">
                            <span>보유 : ${aa.tennum}</span>
                        </div>
                    </div>
                </c:if>
                <c:if test="${aa.twentinum > 0}">
                    <div class="couponlist">
                        <div class="list_div">
                            <a><img alt="" src="./image/ico_20coupon.png"></a>
                        </div>
                        <div class="btn_div">
                            <span>보유 : ${aa.twentinum}</span>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </c:forEach>
</div>
</body>
</html>
