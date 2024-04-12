<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
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
input[type="text"],
input[type="number"]{
    width: 330px;
    padding: 4px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #f9f9f9;
    display: inline-block;
}

label{
	display: block;
    max-width: 100%;
    margin: 2px 0 2px 0;
    font-weight: 700;	
    vertical-align: middle;
    
}
textarea{
	width:600px;
	height:80px;
	padding: 4px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #f9f9f9;
    resize: none;
}
select {
    width: auto;
    padding: 3px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #f9f9f9;
}
select option {
    font-size: 16px;
}
input[type="checkbox"]{
	width: 20px;
    height: 20px;
    margin: 0 5px;
    vertical-align: middle;
}

.product_input{
 	margin-top: 24px;
	width: 100%; 
	min-width:1360px;
	position:absolute;
	display:flex;
    justify-content: center;
}
.product_inputform{
  	background-color: #fff;
	border-radius: 9px;
  	width: 706px;
  	height: auto;
	border:1px solid #808080;
	position: relative;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	padding: 0 20px 0 20px;
	margin-bottom: 100px;
}
.btn1 {
  background: lightslategray;
  color: #fff;
  border-radius: 100px;
  width: 200px;
  height: 44px;
  font-size: 16px;
  text-align:center;
  border: none;
  margin-bottom: 15px;
}
.btn1:hover {
  background: slategray;
}
.filebox label {
    display: inline-block;
    padding: 10px 20px;
    color: #fff;
    vertical-align: middle;
    background-color: lightslategray;
    cursor: pointer;
    height: 38px;
    border-radius: 5px;
}
.att_zone{
	width: 664px;
	min-height:150px;
	padding:10px;
	border:1px solid #cccccc;
	background-color: #f9f9f9;
	border-radius: 5px;
	margin-bottom: 15px
}
.att_zone:empty:before{
	content : attr(data-placeholder);
	color : #999;
	font-size:17px;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<form action="updateproduct" method="post" enctype="multipart/form-data">
<div class="product_input">
  <div class="product_inputform">
      <h3>상품입력</h3>
      <c:forEach items="${list }" var="aa">
      <div class="input_group">
	      <label for="snum">상품코드</label>
	      <input type="text" id="snum" name="snum" value="${aa.snum }" readonly="readonly">
	      <select name="best" id="best">
					<option value="0" ${aa.best == '0' ? 'selected' : ''}>일반상품지정</option>
					<option value="1" ${aa.best == '1' ? 'selected' : ''}>베스트상품지정</option>
		  </select>
		  <select name="recommend">
		  <option value="1" ${aa.recommend == '1' ? 'selected' : ''}>추천상품지정(온도구별)</option>
		  <option value="0" ${aa.recommend == '0' ? 'selected' : ''}>5℃ 이하</option>
		  <option value="5" ${aa.recommend == '5' ? 'selected' : ''}>5℃ 이상</option>
		  <option value="15" ${aa.recommend == '15' ? 'selected' : ''}>15℃ 이상</option>
		  <option value="20" ${aa.recommend == '20' ? 'selected' : ''}>20℃ 이상</option>
		</select>
      </div>
      <div class="input_group">
	      <label for="sname">상품명</label>
	      <input type="text" id="sname" name="sname" value="${aa.sname }" required="required">
      </div>
      <div class="input_group">
	      <label for="stype">상품타입</label>
	      <select name="stype" id="stype">
		      <option value="상의" ${aa.stype == '상의' ? 'selected' : ''}>상의</option>
		      <option value="바지" ${aa.stype == '바지' ? 'selected' : ''}>바지</option>
		      <option value="아우터" ${aa.stype == '아우터' ? 'selected' : ''}>아우터</option>
		      <option value="모자" ${aa.stype == '모자' ? 'selected' : ''}>모자</option>
	      </select>
      </div>
      <div class="input_group">
	      <label for="price">가격</label>
	      <input type="text" id="price" name="price" value="${aa.price }" required="required">
      </div>
 <div class="input_group">
	      <label>사이즈별 재고</label>
	      <label for="ssize" style="display: inline-block; vertical-align: text-bottom;">S&nbsp;: </label>
	      <input type="number" min="0" value="${aa.ssize }" name="ssize" id="ssize" style="width: 50px; margin: 0 5px;">
	      <label for="msize" style="display: inline-block; vertical-align: text-bottom;">M&nbsp;: </label>
	      <input type="number" min="0" value="${aa.msize }" name="msize" id="msize" style="width: 50px; margin: 0 5px;">
	      <label for="lsize" style="display: inline-block; vertical-align: text-bottom;">L&nbsp;: </label>
	      <input type="number" min="0" value="${aa.lsize }" name="lsize" id="lsize" style="width: 50px; margin: 0 5px;">
	      <label for="xlsize" style="display: inline-block; vertical-align: text-bottom;">XL&nbsp;: </label>
	      <input type="number" min="0" value="${aa.xlsize }" name="xlsize" id="xlsize" style="width: 50px; margin: 0 5px;">
	  </div>
      <div class="input_group">
			<label for="color">색상</label>
				<select name="color" id="color">
					<option value="red" ${aa.color == 'red' ? 'selected' : ''}>red</option>
					<option value="blue" ${aa.color == 'blue' ? 'selected' : ''}>blue</option>
					<option value="green" ${aa.color == 'green' ? 'selected' : ''}>green</option>
				</select>
	  </div>
      <div class="input_group">
	      <label for="intro">상품설명</label>
	      <textarea name="intro">${aa.intro }</textarea>
      </div>
      <div class="input_group">
	      <label style="d" >이미지</label>
		  <input type='file' id='btnAtt' multiple='multiple' name="image" />
		  <div id='att_zone' class="att_zone" data-placeholder='파일을 첨부 하려면 파일 선택 버튼을 클릭하거나 파일을 드래그앤드롭 하세요'></div>
      </div>
      
      <div class="input_group" style="text-align: center;">
      <input type="submit" value="상품등록" class="btn1">
      </div>
      </c:forEach>
    </div>
</div> 


<script type="text/javascript">
( /* att_zone : 이미지들이 들어갈 위치 id, btn : file tag id */
	    imageView = function imageView(att_zone, btn){

	    var attZone = document.getElementById(att_zone);
	    var btnAtt = document.getElementById(btn)
	    var sel_files = [];
	    
	    // 이미지와 체크 박스를 감싸고 있는 div 속성
	    var div_style = 'display:inline-block;position:relative;'
	                  + 'width:150px;height:140px;margin:5px;border:1px solid #000;';
	    // 미리보기 이미지 속성
	    var img_style = 'width:100%;height:100%;';
	    // 이미지안에 표시되는 체크박스의 속성
	    var chk_style = 'width:24px;height:30px;position:absolute;font-size:23px;'
	                  + 'right:0px;top:0px;z-index:999;border:none;color:#000;cursor:pointer;opacity:0.8;line-height:1;';
	  
	    btnAtt.onchange = function(e){
	    	var files = e.target.files;
	        var allFiles = new DataTransfer();

	        // 기존에 선택된 파일들을 추가
	        for (var i = 0; i < sel_files.length; i++) {
	            allFiles.items.add(sel_files[i]);
	        }

	        // 새로 선택된 파일들을 추가
	        for (var i = 0; i < files.length; i++) {
	            allFiles.items.add(files[i]);
	        }

	        // 새로운 FileList를 파일 선택 요소에 설정
	        btnAtt.files = allFiles.files;

	        // 선택된 모든 파일들에 대해 미리보기 생성
	        for(f of files){
	            imageLoader(f);
	        }
	    };

	    // 탐색기에서 드래그앤 드롭 사용
	    attZone.addEventListener('dragenter', function(e){
	      e.preventDefault();
	      e.stopPropagation();
	    }, false)
	    
	    attZone.addEventListener('dragover', function(e){
	      e.preventDefault();
	      e.stopPropagation();
	      
	    }, false)
	  
	attZone.addEventListener('drop', function(e){
	    e.preventDefault();
	    e.stopPropagation();
	    var dt = e.dataTransfer;
	    var files = dt.files;
	    
	    var allFiles = new DataTransfer();
	    for (var i = 0; i < btnAtt.files.length; i++) {
	        allFiles.items.add(btnAtt.files[i]);
	    }
	    for (var i = 0; i < files.length; i++) {
	        allFiles.items.add(files[i]);
	    }
	    
	    // 새로운 FileList를 파일 선택 요소에 설정
	    btnAtt.files = allFiles.files;
	    
	    
	    for(f of files){
	        imageLoader(f);
	    }
	}, false);
	    

	    
	    /*첨부된 이미리즐을 배열에 넣고 미리보기 */
	    imageLoader = function(file){
	      sel_files.push(file);
	      var reader = new FileReader();
	      reader.onload = function(ee){
	        let img = document.createElement('img')
	        img.setAttribute('style', img_style)
	        img.src = ee.target.result;
	        attZone.appendChild(makeDiv(img, file));
	      }
	      
	      reader.readAsDataURL(file);
	    }
	    
	    /*첨부된 파일이 있는 경우 checkbox와 함께 attZone에 추가할 div를 만들어 반환 */
	    makeDiv = function(img, file){
	      var div = document.createElement('div')
	      div.setAttribute('style', div_style)
	      
	      var btn = document.createElement('input')
	      btn.setAttribute('type', 'button')
	      btn.setAttribute('value', 'x')
	      btn.setAttribute('delFile', file.name);
	      btn.setAttribute('style', chk_style);
	      btn.onclick = function(ev){
	        var ele = ev.srcElement;
	        var delFile = ele.getAttribute('delFile');
	        for(var i=0 ;i<sel_files.length; i++){
	          if(delFile== sel_files[i].name){
	            sel_files.splice(i, 1);      
	          }
	        }
	        
	        dt = new DataTransfer();
	        for(f in sel_files) {
	          var file = sel_files[f];
	          dt.items.add(file);
	        }
	        btnAtt.files = dt.files;
	        var p = ele.parentNode;
	        attZone.removeChild(p)
	      }
	      div.appendChild(img)
	      div.appendChild(btn)
	      return div
	    }
	  }
	)('att_zone', 'btnAtt')

</script>
</form>
</body>
</html>