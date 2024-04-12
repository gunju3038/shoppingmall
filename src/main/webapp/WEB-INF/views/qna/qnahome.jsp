<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
* {
	margin: 0; 
	padding: 0; 
	box-sizing: border-box; 		
	font-family: 'Poppins', sans-serif;}

.container {
  text-align: center;
  margin-top: 5%;
  margin-left: 20px;
  margin-right: 20px;
}

body {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f2f2f2;
  overflow: hidden;
}
h2 {
  margin-bottom: 80px;
  margin-top: 15%;
}
.menu_box {
  position: relative;
  margin-top: 20px;
  margin-bottom: 20px;
  background-color: #ffffff;
  border: 1px solid transparent; 
  border-radius: 20px;
}

.nav {
  position: relative;
  display: inline-flex; 
  max-width: 100%;
  background: #fff; 
  border-radius: 40px; 
  overflow: hidden; 
  padding: 0 20px;
}

.item {
  position: relative;
  padding: 20px;
  margin: 0 6px;
  font-size: 18px;
  color: #83818c;
  font-weight: 500;
  transition: 0.5s;
}

.item::before {
  opacity: 0;
  content: '';
  position: absolute;
  left: 0;
  bottom: -6px;
  width: 100%;
  height: 5px;
  background: transparent;
  border-radius: 8px 8px 0 0;
  transition: 0.5s;
}

.item:not(.active):hover:before {
  opacity: 1;
  bottom: 0;
}

.item:not(.active):hover {
  color: #51829B;
}

.item.active {
  color: #35374B;
}

.indicator {
  position: absolute;
  left: 0;
  bottom: 0;
  width: var(--widthJS);
  height: 5px;
  background: #B5C0D0;
  border-radius: 8px 8px 0 0;
  transform: translateX(var(--transformJS));
  transition: 0.5s;
  height: 100px;
}

.myqna {
  background-color: #EAD8C0;
  padding: 20px; 
  border-radius: 10px;
  margin-top: 20px;
  color: #222831;
}

.myqna dl {
  margin-bottom: 20px;
}

.myqna dt {
  font-weight: bold;
  margin-bottom: 20px;
}

.myqna dd {
  margin-left: 10px;
  color: #1B3C73;
}
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="container">
<h2>고객센터</h2>
<div class="menu_box">
    <nav class="nav">
        <a href="qnahome" class="item active">Home</a>
        <a href="notice" class="item">공지사항</a>
        <a href="#" class="item">Q&A</a>
        <a href="#" class="item">FAQ</a>
        <span class="indicator"></span>
    </nav>
</div>
    <c:choose>
        <c:when test="${loginstate == true}">
            <div class="myqna">
                <dl>
                <dt>MY문의 진행현황</dt>
                <dd>
                <span class="count">0</span>
                 건 답변완료,
                <span class="count">0</span>
                건 답변대기중 입니다.
                </dd>
                <a onclick=""></a>
                </dl>
                </div>
        </c:when>
        <c:otherwise> 
            <div class="myqna">
                <dl>
                <dt>MY문의 진행현황</dt>
                <dd>문의를 보기 위해선 로그인 해주세요.</dd>
                <a href="login">로그인</a>
                </dl>
                </div>
        </c:otherwise>
    </c:choose>
</div>
<script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function() {
        let navItems = document.querySelectorAll(".item");
        let indicator = document.querySelector(".indicator");
        let activeLink = document.querySelector(".active");
        changeIndicator(activeLink);
        navItems.forEach((item) => {
        	item.addEventListener("click", () => {
        	document.querySelector(".active").classList.remove("active");
        	item.classList.add("active");
        	changeIndicator(item);
        	})
        });
        function changeIndicator(item) {
            indicator.style.setProperty("--transformJS", `${item.offsetLeft}px`);
            indicator.style.setProperty("--widthJS", `${item.offsetWidth}px`);
        }
    });
</script>
</body>
</html>
