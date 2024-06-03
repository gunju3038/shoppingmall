<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    margin-bottom: 10px;
    margin-top: 3%;
}
h4{
    margin-bottom: 40px;
    font-size: 16px;
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
}

.att_zone img {
    max-width: 100%;
    max-height: 100%;
    display: block;
}

.att_zone div {
    margin-bottom: 5px;
}

.star_rating {
    display: flex;
    justify-content: flex-start;
}

.star_rating .star {
    width: 25px;
    height: 25px;
    margin-right: 10px;
    display: inline-block;
    background: url('./image/starstamp.png') no-repeat;
    background-size: 100%;
    box-sizing: border-box;
}

.star_rating .star.on {
    background: url('./image/starfull.png') no-repeat;
    background-size: 100%;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    function imageView(att_zone, btn) {
        var attZone = document.getElementById(att_zone);
        var btnAtt = document.getElementById(btn);
        if (!attZone || !btnAtt) {
            console.error('Element with id ' + att_zone + ' or ' + btn + ' not found.');
            return;
        }

        var sel_files = [];

        var div_style = 'display:inline-block;position:relative;width:100px;height:90px;margin:5px;border:1px solid #000;';
        var img_style = 'width:50%;height:50%;';
        var chk_style = 'width:24px;height:30px;position:absolute;font-size:23px;right:0px;top:0px;z-index:999;border:none;color:#000;cursor:pointer;opacity:0.8;line-height:1;';

        btnAtt.onchange = function(e) {
            var files = e.target.files;
            var allFiles = new DataTransfer();

            for (var i = 0; i < sel_files.length; i++) {
                allFiles.items.add(sel_files[i]);
            }

            for (var i = 0; i < files.length; i++) {
                allFiles.items.add(files[i]);
            }

            btnAtt.files = allFiles.files;

            for (var f of files) {
                imageLoader(f);
            }
        };

        attZone.addEventListener('dragenter', function(e) {
            e.preventDefault();
            e.stopPropagation();
        }, false);

        attZone.addEventListener('dragover', function(e) {
            e.preventDefault();
            e.stopPropagation();
        }, false);

        attZone.addEventListener('drop', function(e) {
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

            btnAtt.files = allFiles.files;

            for (var f of files) {
                imageLoader(f);
            }
        }, false);

        function imageLoader(file) {
            sel_files.push(file);
            var reader = new FileReader();
            reader.onload = function(ee) {
                let img = document.createElement('img');
                img.setAttribute('style', img_style);
                img.src = ee.target.result;
                attZone.appendChild(makeDiv(img, file));
            };

            reader.readAsDataURL(file);
        }

        function makeDiv(img, file) {
            var div = document.createElement('div');
            div.setAttribute('style', div_style);

            var btn = document.createElement('input');
            btn.setAttribute('type', 'button');
            btn.setAttribute('value', 'x');
            btn.setAttribute('delFile', file.name);
            btn.setAttribute('style', chk_style);
            btn.onclick = function(ev) {
                var ele = ev.srcElement;
                var delFile = ele.getAttribute('delFile');
                for (var i = 0; i < sel_files.length; i++) {
                    if (delFile == sel_files[i].name) {
                        sel_files.splice(i, 1);
                    }
                }

                var dt = new DataTransfer();
                for (var f of sel_files) {
                    dt.items.add(f);
                }
                btnAtt.files = dt.files;
                var p = ele.parentNode;
                attZone.removeChild(p);
            };
            div.appendChild(img);
            div.appendChild(btn);
            return div;
        }
    }

    imageView('att_zone', 'btnAtt');

    $("#btnSave").click(function(event) {
        event.preventDefault();

        var btitle = $("#btitle").val();
        var bcontent = $("#bcontent").val();

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

    $('.star_rating > .star').click(function() {
        $(this).parent().children('span').removeClass('on');
        $(this).addClass('on').prevAll('span').addClass('on');
     
        var rank = $(this).attr('value');
        $('#productrank').val(rank);
    });

    $(document).on('click', '#btnList', function(e) {
        e.preventDefault();
        history.back();
    });
    
    var defaultRank = $('#rank').val(); 
    $('#productrank').val(defaultRank);
    $('.star_rating > .star').each(function(index) {
        if (index < defaultRank) {
            $(this).addClass('on');
        }
    });
    
});
</script>
<meta charset="UTF-8">
<title>상품 리뷰</title>
</head>
<body>
<div class="container" role="main">
    <h2 class="notice">상품구매후기</h2>
    <c:forEach items="${list }" var="aa">
    <h4>구매상품 : ${aa.sname}</h4>
    <form action="productreviewupdate" method="post" enctype="multipart/form-data" id="form">
        <div class="inputform">
            <label for="btitle">제목</label>
            <input type="text" class="form-control" name="btitle" id="btitle" value="${aa.btitle}" placeholder="제목을 입력해 주세요">
            <input type="hidden" name="snum" value="${aa.snum}">
            <input type="hidden" name="sname" value="${aa.sname}">
            <input type="hidden" name="image" value="${aa.image}">
            <input type="hidden" name="rank" id="rank" value="${aa.productrank}">
        </div>
        <div class="inputform">
        <div class="review-score" id="reviewScorePos">
            <label for="productrank">별점을 매겨주세요</label>
            <input type="hidden" name="productrank" id="productrank" value="0">
            <div class="star_rating">
                <span class="star" value="1"></span>
                <span class="star" value="2"></span>
                <span class="star" value="3"></span>
                <span class="star" value="4"></span>
                <span class="star" value="5"></span>
            </div>
        </div>
        </div>
        <div class="inputform">
            <label for="bcontent">내용</label>
            <textarea class="form-control" rows="5" name="bcontent" id="bcontent"  placeholder="리뷰 내용을 입력해 주세요">${aa.bcontent}</textarea>
        </div>
        <div class="inputform">
            <label for="bpicture">사진</label>
            <input type="file" class="form-control" name="bpicture" id="btnAtt" multiple="multiple">
            <div id="att_zone" class="att_zone" data-placeholder="파일을 첨부 하려면 파일 선택 버튼을 클릭하거나 파일을 드래그앤드롭 하세요"></div>
        </div>
        <div class="btn-container">
            <button type="button" class="btn btn-sm btn-primary" id="btnSave">리뷰등록</button>
            <button type="button" class="btn btn-sm btn-primary" id="btnList" onclick="history.back()">이전</button>
        </div>
    </form>
    </c:forEach>
</div>
</body>
</html>
