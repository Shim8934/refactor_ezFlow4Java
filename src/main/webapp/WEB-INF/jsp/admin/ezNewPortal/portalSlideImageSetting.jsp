<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezNewPortal.t104' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<!-- 모달 -->
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>

<style type="text/css">
.ui-sortable{ margin:0px; padding:0px; padding-left: 30px;}
.themeThumbnails {width : 355px; height : 190px; border : 1px solid #cecece;}
.themesImgDetails {width : 500px; height : 350px; border : 3px solid #898989;margin:15px; float:left;}
.selectTheme {background-color:#edf7ff !important; border:1px solid #2196f3 !important; width : 375px; height : 270px; text-align:center; }
.theme {position:relative;background-color : white; width : 390px; height : 270px; text-align : center; border: 1px solid #cecece; cursor: pointer;}
.themeHr {margin-top : 10px;width : 85%;margin-left : 30px;}
.themeTitle {margin-top : 9px;}
.themeName {margin-left : 5px;font-size : 14px;font-weight : bold; display:inline-block; white-space:normal; overflow-y:auto; max-width:325px; height:24px; word-wrap:break-word;}
.hideDetails {display : none;}
.showDetails {display : block;}
.close {margin-top : 6px;}

#slideImageList li {margin : 10px; display : inline-block;}
.slideDiv {position: absolute; top: 18px; left: 16px;}
.slideDiv2 {position: relative;}

#mainmenu ul {margin-top: 15px;}
#mainmenu li {margin-right: 5px;}

.addLayerPopup {z-index: 2000; position: absolute; top: 46.7px; left: 50px; height: 809.6px;}
.layerPopupBackground {	width:100%;	height:100%; position:absolute; top:0; left:0; z-index:1000; background:none rgba(0,0,0,0.5); display:none;}
#tdNormalImage {width: 514px; height: 250px;}

dd {margin : 20px; padding: 0px; font-size: 13px; color: #c0c0c0; font-weight: bold;}
</style>
</head>
<body class="popup">
	<h1><spring:message code='ezNewPortal.t104' /></h1>
	<div id="close"><ul><li><span></span></ul></div>
	
	<div id="mainmenu">
		<ul>
			<li id="slideImageAddBtn"><span><spring:message code='ezNewPortal.t058' /></span></li>
			<li id="slideImageEditBtn"><span><spring:message code='ezNewPortal.t067' /></span></li>
			<li id="slideImageDelBtn"><span><spring:message code='ezNewPortal.t059' /></span></li>
		</ul>
	</div>
	<ul id="slideImageList">
	</ul>


<!-- 등록/수정 레이어 팝업 -->
	<div id="addLayerPopup" class="popupwrap1"
		style="display: none; margin-bottom: 50px; max-width: 650px;">
		<div class="popupJQLayer">
			<div id="contentPopup_title" class="title"><spring:message code='ezNewPortal.t105' /></div>
			<div id="close">
				<ul>
					<li><a id="layerCloseBtn" rel="modal:close"><span></span></a></li>
				</ul>
			</div>
			<div style="max-height: 466px; overflow-y: auto;">
				<h2 style="font-weight: normal"><spring:message code='ezNewPortal.t106' /></h2>
				<table id="toggle_tbl1" class="content">
					<tbody>
						<tr>
							<th><spring:message code='ezNewPortal.t107' /></th>
							<td><input type="text" id="imageUrl" style="width: 100%" tabindex="1"></td>
						</tr>
						<tr>
							<th><a class="imgbtn" tabindex="2"><span onclick="ImageUploadBtn()"><spring:message code='ezNewPortal.t108' /></span></a>
							</th>
							<td id="tdNormalImage">
								<img id="UploadSliderImage" src="" onload="imgdisplay()" style="width:100%; height: 100%; display: none">
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
								<a class="imgbtn"><span onclick="btnSave_click();"><spring:message code='ezNewPortal.t002' /></span></a>
							</div>	
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	
    <input type="file" name="imgFile" id="imgFile" onchange="btn_AttachAdd_onclick()" style="display: none;" accept="image/*" />

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
				document.getElementById("slideImageList").style.textAlign = "";
				document.getElementById("slideImageList").style.marginLeft = "";
				
				slideImageList.forEach(function (item, index) {
					slideImageHTML += "<li class='slide'>";
					slideImageHTML += "<div class='theme' id='" + item.sliderID + "' sn='" + item.sn + "' onclick='selectImage(this)'><div class='slideDiv'><div class='slideDiv2'>";
					slideImageHTML += "<div class='themeImg'><img src='" + item.imagePath + "' class='themeThumbnails' alt='img02'/>";
					slideImageHTML += "</div><div>";
					slideImageHTML += "<hr class='themeHr'/>";
					slideImageHTML += "<div class='themeTitle' id='themeTitle" + item.sliderID + "'>";
					if (item.url == null || item.url == "") {
						slideImageHTML += "<span class='themeName'>url : <spring:message code='ezNewPortal.t089'/></span>";
					} else {
						slideImageHTML += "<span class='themeName'>url : </span><span class='themeName'>" + item.url + "</span></span>";
					}
					slideImageHTML += "</div></div></div>";
					slideImageHTML += "</li>";
				});
			} else {
					document.getElementById("slideImageList").style.textAlign = "center";
					document.getElementById("slideImageList").style.marginLeft = "-45px";
				
					slideImageHTML += "<li>";
					slideImageHTML += "<div id='nodata_slideImage' class='nodata'>";
					slideImageHTML += "<dl class='nodata'>";
					slideImageHTML += "	<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
					slideImageHTML += "	<dd>\"" + "<spring:message code='main.t00026' />" + "\"</dd>";
					slideImageHTML += "</dl>";
					slideImageHTML += "</div>";
					slideImageHTML += "</li>";
			}
			document.getElementById("slideImageList").innerHTML = slideImageHTML;
			
			//드래그앤드롭
			$("#slideImageList").sortable({ 
				items: "li.slide",
				start : function(event, ui) {
					
				},
				update : function(event, ui) {
					updateSlideOrder();
				}
			});
			
			$("#slideImageList").disableSelection();
			$("#slideImageList").on("sortstart", function( event, ui ) { ui.placeholder.css("width","390px"); });
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

	if (ext == "jpeg" || ext == "jpg" || ext == "png" || ext == "bmp" || ext == "gif") {
		/* 2021-12-09 홍승비 - 슬라이드 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
		if (checkImgExtension(ext) == "UPLOAD_EXT_ERROR") {
			alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
			return false;
		}
		
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
    if ($("#UploadSliderImage").attr("src") == "") {	
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

//레이어 닫기
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

//삭제버튼
var slideImageDel = function(event) {
	if (document.getElementsByClassName("selectTheme").length <= 0) {	
        alert("<spring:message code = 'ezPersonal.t20000' /> ");
        return;
    }
    
	if (confirm("<spring:message code='ezNewPortal.t109' />")) {
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

//슬라이드 이미지 순서변경
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