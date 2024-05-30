
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<meta charset="UTF-8">
<title>Insert title here</title>
<style>
p{
	font-size: 40px;
	text-align: center;
	font-weight: 700;
	margin: 20px;
}
 
.rouletter {
  position: relative;
  min-width: 1380px;
  height: 500px;  
}
.rouletter-bg {
  position: absolute;
  top: 55%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 500px;
  height: 488px;
  overflow: hidden;
}
.rouletter-wacu {
  width: 100%;
  height: 100%;
  background: url("./image/img_roulette.png") no-repeat;
  background-size: 100%;
  transform-origin: center;
  transition-timing-function: ease-in-out;
  transition: 2s;
}
.rouletter-arrow {
  position: absolute;
  top: 10px;
  left: 50%;
  transform: translateX(-50%);
  border-right: 20px solid transparent;
  border-left: 20px solid transparent;
  border-top: 40px solid black;
}
.rouletter-btn {
  position: absolute;
  top: 55%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 80px;
  height: 80px;
  border-radius: 80px;
  border: 3px solid;
}
.hidden-input {
  display: none;
}
</style>
</head>
 <body>
 	<div><p>행운의 돌림판!!</p> </div>
	<div class="rouletter">
    <div class="rouletter-bg">
        <div class="rouletter-wacu"></div>
    </div>
    <div class="rouletter-arrow"></div>
    <button class="rouletter-btn">
         <img alt="" src="./image/img_rouletteBtn.png" style="width: 55px; pointer-events: none;">
    </button>
</div>
     
<script type="text/javascript">
var rolLength = 6;
var setNum;
var hiddenInput = document.createElement("input");
hiddenInput.className = "hidden-input";

const rRandom = () => {
  var min = Math.ceil(0);
  var max = Math.floor(rolLength - 1);
  return Math.floor(Math.random() * (max - min)) + min;
};

const rRotate = () => {
  var panel = document.querySelector(".rouletter-wacu");
  var btn = document.querySelector(".rouletter-btn");
  var deg = [];
  for (var i = 1, len = rolLength; i <= len; i++) {
    deg.push((360 / len) * i);
  }

  var num = 0;
  document.body.append(hiddenInput);
  setNum = hiddenInput.value = rRandom();

  var ani = setInterval(() => {
    num++;
    panel.style.transform = "rotate(" + 360 * num + "deg)";
    btn.disabled = true; //button,input

    if (num === 50) {
      clearInterval(ani);
      panel.style.transform = "rotate(" + deg[setNum] + "deg)";
    }
  }, 50);
};

const rLayerPopup = (num) => {
	var win = 0;
  	switch (num) {
	    case 1:
	      alert("당첨!! 10,000원 할인쿠폰");
	      win = 1;
	      break;
	    case 3:
	      alert("당첨!! 10% 할인쿠폰");
	      win = 3;
	      break;
	    case 5:
	      alert("당첨!! 20% 할인쿠폰");
	      win = 5;
	      break;
	    default:
	      alert("꽝! 다음기회에");
	  }
  	if(win === 1 || win === 3 || win === 5){
  		$.ajax({
			type: "post",
            async: true,
            url: "couponUpdate",
            data: {"win": win},
            success: function(response) {
                
            },
            error: function(xhr, status, error) {
                
            }
        });
  		
  	} 
  	
};

const rReset = (ele) => {
  setTimeout(() => {
    ele.disabled = false;
    rLayerPopup(setNum);
    hiddenInput.remove();
  }, 4800);
};

document.addEventListener("click", function (e) {
  var target = e.target;
  if (target.tagName === "BUTTON") {
    rRotate();
    rReset(target);
  }
});



</script>
</body>
</html>