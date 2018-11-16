<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>슬라이드 이미지 설정</title>
<link rel="stylesheet"  href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css">

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<!-- 모달 -->
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>

<style type="text/css">
.ui-sortable{ margin:0px; padding:0px;}
.themeThumbnails {width : 350px; height : 200px; border : 1px solid #cecece; margin-top : 15px;}
.themesImgDetails {width : 500px; height : 350px; border : 3px solid #898989;margin:15px; float:left;}
#themeList{ padding:0px;}
#themeList li {margin : 10px 10px 10px 0px; display : inline-block;}
.isDefault{position:absolute;background: rgba(0,0,0,0.3);width: 352px;height: 202px;top: 15px;left: 12px;}
.selectTheme {background-color:#edf7ff !important; border:1px solid #2196f3 !important; width : 375px; height : 270px; text-align:center; }
.theme {position:relative;background-color : white; width : 375px; height : 270px; text-align : center; border: 1px solid #cecece; cursor: pointer;}
.themeHr {margin-top : 10px;width : 85%;margin-left : 30px;}
.themeTitle {margin-top : 9px;}
.themeNotUsed {display:none;width:100%; height:87%;background-color:#e1e1e180; z-index:99;position:absolute; right:0; top:0;}
.themeName {margin-left : 10px;font-size : 14px;font-weight : bold;}
.themeDetails {display : none; float:left; width:98%; position : relative;margin-left:0px; padding:0px;}
.themeSetting {float : right;margin-right : 27px; margin-top:3px; cursor:pointer;}
.themeSetting img {width : 13px;height : 13px;}
.hideDetails {display : none;}
.showDetails {display : block;}
.themeInfo {margin : 15px;}
.themeActive{position:relative; margin-top : 20px; font-size : 15px; font-weight : bold; display : inline-block;}
.themeActive div {display : inline-block;}
.btnpositionJsp {float : right; margin-top : 0px;padding-right:35px; padding-top:0px;}
.close {margin-top : 6px;}
.btnpositionJsp a {margin-left : 5px;}
.themeDefault {font-size : 15px; font-weight:bold; margin-top : 20px;}

.frameInfo {margin : 15px;}
.frameInfo p {font-size : 15px; font-weight : bold;}
.frameList {clear : none !important; width:100%; margin-bottom:20px;}
.frameList tr {height:40px;}
.frameList tr:first-child {height : 78px;}
.frameList td {text-align : center; border:1px solid #e1e1e1;}
.frameList th {width:61px;}
			
#slideImageList {margin-top:30px;}
#slideImageList li {margin : 10px; display : inline-block;}

#mainmenu ul {
	margin-top: 15px;
}

.addLayerPopup {
    z-index: 2000;
    position: absolute;
    top: 46.7px;
    left: 50px;
    height: 809.6px;
}
.layerPopupBackground {
	width:100%;
	height:100%;
	position:absolute;
	top:0;
	left:0;
	z-index:1000;
	background:none rgba(0,0,0,0.5);
	display:none;
}
#tdNormalImage {
	width: 611px; height: 250px;
}
</style>
</head>
<body class="popup">
	<h1>슬라이드 이미지 설정</h1>
	<div id="close"><ul><li><span></span></ul></div>
	
	<div id="mainmenu">
		<ul>
			<li id="slideImageAddBtn"><span>등록</span></li>
			<li id="slideImageEditBtn"><span>수정</span></li>
			<li id="slideImageDelBtn"><span>삭제</span></li>
		</ul>
	</div>
	<div>
		<ul id="slideImageList">
		</ul>
	</div>


<!-- 등록/수정 레이어 팝업 -->
	<div id="addLayerPopup" class="popupwrap1"
		style="display: none; margin-bottom: 50px; max-width: 748px;">
		<div class="popupJQLayer">
			<div id="contentPopup_title" class="title">슬라이드 이미지 등록/수정</div>
			<div id="close">
				<ul>
					<li><a id="layerCloseBtn" rel="modal:close"><span></span></a></li>
				</ul>
			</div>
			<div style="max-height: 466px; overflow-y: auto;">
				<h2 style="font-weight: normal">▒ 이미지는 611 * 250 사이즈로 등록됩니다.</h2>
				<table id="toggle_tbl1" class="content">
					<tbody>
						<tr>
							<th>URL</th>
							<td><input type="text" id="imageUrl" style="width: 100%"></td>
						</tr>
						<tr>
							<th><a class="imgbtn"><span onclick="ImageUploadBtn()">이미지등록</span></a>
							</th>
							<td>
								<table border="0">
									<tbody>
										<tr>
											<td id="tdNormalImage">
												<img id="UploadSliderImage" src="" onload="imgdisplay()" style="width:100%; height: 100%; display: none">
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<table style="width: 100%">
				<tbody>
					<tr>
						<td style="text-align: center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onclick="btnSave_click();">저장</span></a>
							</div>	
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	
    <input type="file" name="imgFile" id="imgFile" onchange="btn_AttachAdd_onclick()" style="display: none;"/>

<script type="text/javascript">
var g_xmlhttp; 
var sliderid = "";
var pNoneActiveX = "YES";
var imageSrc = "";
var companyValue = "<c:out value='${companyId}'/>";
var mode = "";

$(function(){
	$("#close").on("click", function(){
		window.close();
	});
	
	eventSetting();
	getSlideImage();
});

//버튼 이벤트 셋팅
var eventSetting = function() {
	$("#slideImageAddBtn").on("click", slideImageAdd);
	$("#slideImageEditBtn").on("click", slideImageEdit);
	$("#slideImageDelBtn").on("click", slideImageDel);
	$("#layerCloseBtn").on("click", layerCloseBtnClick);
}

// 슬라이드 이미지 리스트
var getSlideImage = function () {
	var request = new XMLHttpRequest();
	request.open('POST', '/admin/ezNewPortal/getSlideImages.do', true);
	request.setRequestHeader('Content-Type', 'application/json');

	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			var result = JSON.parse(request.responseText);
			var slideImageList = result.list;
			var slideImageHTML = "";
			
			if (slideImageList != null && slideImageList.length > 0) {
				slideImageList.forEach(function (item, index) {
					slideImageHTML += "<li class='slide'>";
					slideImageHTML += "<div class='theme' id='" + item.sliderID + "' sn='" + item.sn + "' onclick='selectImage(this)'>";
					slideImageHTML += "<div class='themeImg'><img src='" + item.imagePath + "' class='themeThumbnails' alt='img02'/>";
					slideImageHTML += "<div class='themeNotUsed'>&nbsp;</div>";
					slideImageHTML += "</div><div>";
					slideImageHTML += "<hr class='themeHr'/>";
					slideImageHTML += "<div class='themeTitle' id='themeTitle" + item.sliderID + "'>";
					slideImageHTML += "<span class='themeName'>url : " + item.url + "</span>";
					slideImageHTML += "</div>";
					slideImageHTML += "</li>";
				});
			} else {
					slideImageHTML += "<li>";
					slideImageHTML += "데이터가 없습니다.";
					slideImageHTML += "</li>";
			}
			document.getElementById("slideImageList").innerHTML = slideImageHTML;
			
			//드래그앤드롭
			$("#slideImageList").sortable({ 
				items: "li.slide",
				update : function(event, ui) {
					updateSlideOrder();
				}
			});
			
			$("#slideImageList").disableSelection();
			$("#slideImageList").on("sortstart", function( event, ui ) { ui.placeholder.css("width","377px"); });
		} else {
			// We reached our target server, but it returned an error
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	var data = JSON.stringify({
		companyId : companyValue
	});
	
	request.send(data);
}

//이미지 선택
function selectImage(obj) {
	$(".selectTheme").removeClass("selectTheme");
	obj.classList.add("selectTheme");
}

//등록버튼
var slideImageAdd = function(event) {
	mode = "new";
	
	var popupX = document.body.clientWidth / 2 - ($("#addLayerPopup").width() / 2);
	$("#addLayerPopup").css("left", popupX);
	
	$("#addLayerPopup").modal();
}

//====레이어팝업 시작====
//이미지등록 버튼 클릭
var ImageUploadBtn = function (obj){
	tempObj = obj;
	document.getElementById("imgFile").click();
}
 
//이미지등록버튼 클릭시
var btn_AttachAdd_onclick = function () {
	var fd = new FormData();		    	
	var _file = document.getElementById("imgFile").files[0];    	
	var ext = _file.name.split('.').pop().toLowerCase();

	if (_file.size / 1024 / 1024 > 5) {
		alert("<spring:message code = 'ezPoll.t208' />");
		return;
	}	
	
	fd.append("file", _file);
	fd.append("companyId", companyValue);
	
	var request = new XMLHttpRequest();

	if ( ext == "jpeg" || ext == "jpg" || ext == "png" || ext == "bmp" || ext == "gif") {
		request.open("POST", "/admin/ezNewPortal/uploadSlideImage.do");
		request.send(fd);

		request.onload = function() {
			var result = request.responseText;
			imageSrc = result;
			document.getElementById("UploadSliderImage").src = result;
		}
	} else {
		alert("<spring:message code = 'ezCommunity.lhj03' /> (jpg, png, bmp, jpeg, gif)");
		return false;
	}
}

//이미지가 로드된 후
var imgdisplay = function () {
    document.getElementById("UploadSliderImage").style.display = "";
}

//저장버튼
var btnSave_click = function () {
    if (document.getElementById("UploadSliderImage").src == -1) {	
        alert("<spring:message code = 'ezPersonal.t20000' /> ");
        return;
    }
    
    var SliderImgPath = document.getElementById("UploadSliderImage").src;
    var imageUrl = document.getElementById("imageUrl").value;
    
    var selectSlideId = "";
    if (mode == "mod") {
    	var selectImage = document.getElementsByClassName("selectTheme");
        selectSlideId = selectImage[0].id;
    }
    
	var request = new XMLHttpRequest();
	request.open('POST', '/admin/ezNewPortal/saveSlideImages.do', true);
	request.setRequestHeader('Content-Type', 'application/json');

	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			var result = JSON.parse(request.responseText);

			document.getElementById("layerCloseBtn").click();
			
			getSlideImage();
		} else {
			// We reached our target server, but it returned an error
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	var data = JSON.stringify({
		slideId : selectSlideId,
		mode : mode,
		companyId : companyValue,
		imagePath : imageSrc,
		imageUrl : imageUrl,
		imageName : SliderImgPath.substr(SliderImgPath.lastIndexOf("/") + 1)
	});
	
	request.send(data);
}

var layerCloseBtnClick = function(event) {
	document.getElementById("imageUrl").value = "";
	document.getElementById("UploadSliderImage").src = "";
	document.getElementById("UploadSliderImage").style.display = "none";
}
//====레이어팝업 끝====

//수정버튼
var slideImageEdit = function(event) {
	mode = "mod";
	
	if (document.getElementsByClassName("selectTheme").length <= 0) {	
        alert("<spring:message code = 'ezPersonal.t20000' /> ");
        return;
    }
    
	var selectImage = document.getElementsByClassName("selectTheme");
    var selectSlideId = selectImage[0].id; 
    
	var request = new XMLHttpRequest();
	request.open('POST', '/admin/ezNewPortal/getSlideImageInfo.do', true);
	request.setRequestHeader('Content-Type', 'application/json');

	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			var result = JSON.parse(request.responseText);
			
			imageSrc = result.slideInfo.imagePath;
			document.getElementById("imageUrl").value = result.slideInfo.url;
			document.getElementById("UploadSliderImage").src = result.slideInfo.imagePath;
			document.getElementById("UploadSliderImage").style.display = "";
			
			var popupX = document.body.clientWidth / 2 - ($("#addLayerPopup").width() / 2);
			$("#addLayerPopup").css("left", popupX);
			$("#addLayerPopup").modal();
		} else {
			// We reached our target server, but it returned an error
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	var data = JSON.stringify({
		companyId : companyValue,
		slideId : selectSlideId
	});
	
	request.send(data);
}
var slideImageDel = function(event) {
	if (document.getElementsByClassName("selectTheme").length <= 0) {	
        alert("<spring:message code = 'ezPersonal.t20000' /> ");
        return;
    }
    
	if (confirm("삭제하시겠습니까?")) {
		var selectImage = document.getElementsByClassName("selectTheme");
	    var selectSlideId = selectImage[0].id; 
	    
		var request = new XMLHttpRequest();
		request.open('POST', '/admin/ezNewPortal/delSlideImage.do', true);
		request.setRequestHeader('Content-Type', 'application/json');
	
		request.onload = function() {
			if (request.status >= 200 && request.status < 400) {
				getSlideImage();
			} else {
				// We reached our target server, but it returned an error
			}
		};
	
		request.onerror = function() {
		  // There was a connection error of some sort
		};
		
		var data = JSON.stringify({
			companyId : companyValue,
			slideId : selectSlideId
		});
		
		request.send(data);
	}
}

var updateSlideOrder = function() {
	var slideList = $(".theme");
	var slideListCount = slideList.length;
	var slideOrderList = [];
	
	for (var i = 0; i < slideListCount; i++) {
		var slideId = slideList[i].id;
		var order = i + 1;
		
		slideOrderList.push({"order" : order, "slideId" : slideId});
	}
	
	var request = new XMLHttpRequest();
	request.open('POST', '/admin/ezNewPortal/updateSlideOrder.do', true);
	request.setRequestHeader('content-type', 'application/json');
	
	request.onload = function() {getSlideImage();}
	
	request.onerror = function() {}
	
	var data = JSON.stringify({
		companyId : companyValue,
		slideList : slideOrderList
	});
	 
	request.send(data);
}

</script>
</body>
</html>