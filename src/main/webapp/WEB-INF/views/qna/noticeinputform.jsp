<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="notice_menubox.jsp" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.container {
    width: 600px;
    height: auto;
    margin: auto;
    margin-top: 30px;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    border-radius: 9px;
    border-top: 10px solid #000000;
    border-bottom: 10px solid #000000;
    padding: 20px;
    background-color: #fff;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    overflow: hidden;
}

.inputform {
    margin-bottom: 20px;
    margin-top: -10px;
    display: flex;
    flex-direction: column;
}

.inputform label {
    margin-bottom: 5px;
}

.inputform select,
.inputform input[type="text"],
.inputform textarea,
.inputform input[type="file"] {
    width: calc(100% - 20px);
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 20px;
    margin-bottom: 10px;
    box-sizing: border-box;
}

.inputform textarea {
    height: 100px;
}

.inputform input[type="file"] {
    height: 45px;
}

.btn-container button {
    margin: 0 20px;
    width: 100px;
    background-color: #16222A;
    color: #fff;
    border: none;
    border-radius: 5px;
    padding: 8px 16px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.btn-container {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
}

.btn-container button:hover {
    background-color: #000000;
}
h2 {
	margin-bottom: 50px;
	margin-top: 3%;
}
.att_zone {
    width: calc(100% - 20px);
    min-height: 50px;
    padding: 10px;
    border: 1px solid #cccccc;
    background-color: #f9f9f9;
    border-radius: 5px;
    margin-bottom: 15px;
    overflow-y: auto;

.att_zone img {
    max-width: 100%;
    max-height: 100%;
    display: block;
}

.att_zone div {
    margin-bottom: 5px;
}
</style>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
</head>
<body>
	<div class="container" role="main">
	<h2 class="notice">공지사항 글쓰기</h2>
	<form action="noticesave" method="post" enctype="multipart/form-data" id="form">
	<input type="hidden" class="form-control" name="bid" value="${membership.id}">
	<div class="inputform">
	    <label for="selectbtype">공지유형</label>
	    <select id="selectbtype" name="btype">
	        <option value="" disabled selected>유형선택</option>
	        <option value="이벤트" id="event">이벤트</option>
	        <option value="공지" id="notice">공지</option>
	    </select>
	</div>
	<div class="inputform">
		<label for="btitle">제목</label>
		<input type="text" class="form-control" name="btitle" id="btitle" placeholder="제목을 입력해 주세요">
	</div>
	<div class="inputform">
		<label for="bcontent">내용</label>
		<textarea class="form-control" rows="5" name="bcontent" id="bcontent" placeholder="내용을 입력해 주세요" ></textarea>
	</div>
	<div class="inputform">
		<label for="bpicture">사진</label>
		<input type="file" class="form-control" name="bpicture" id='btnAtt' multiple='multiple'>
		<div id='att_zone' class="att_zone" data-placeholder='파일을 첨부 하려면 파일 선택 버튼을 클릭하거나 파일을 드래그앤드롭 하세요'></div>
	</div>
	<div class="btn-container">
		<button type="button" class="btn btn-sm btn-primary" id="btnSave">등록</button>
		<button type="button" class="btn btn-sm btn-primary" id="btnList">목록</button>
	</div>
	</form>
</div>
<script type="text/javascript">
( /* att_zone : 이미지들이 들어갈 위치 id, btn : file tag id */
	    imageView = function imageView(att_zone, btn){

	    var attZone = document.getElementById(att_zone);
	    var btnAtt = document.getElementById(btn)
	    var sel_files = [];
	    
	    // 이미지와 체크 박스를 감싸고 있는 div 속성
	    var div_style = 'display:inline-block;position:relative;'
	                  + 'width:100px;height:90px;margin:5px;border:1px solid #000;';
	    // 미리보기 이미지 속성
	    var img_style = 'width:50%;height:50%;';
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
	
	$(document).ready(function(){
		$("#btnSave").click(function(event){
			event.preventDefault();
				
			var btype = $("#selectbtype option:selected").val();
			var btitle = $("#btitle").val();
			var bcontent = $("#bcontent").val();
				
			if (btype === "") {
				alert('공지유형을 선택 해주세요.');
				return false;
			}
			if (btitle === "") {
				alert('제목 입력은 필수 입니다.');
				return false;
			}
			if (bcontent === "") {
				alert('내용 입력은 필수 입니다.');
				return false;
			}
			$("#form").submit();	
		});
	});
	$(document).on('click', '#btnList', function(e){		
		e.preventDefault();				
		location.href="./notice";
	});
</script>
</body>
</html>
