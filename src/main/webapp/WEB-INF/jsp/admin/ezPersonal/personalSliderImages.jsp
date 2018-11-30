<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		
		<style type="text/css">
		body {background-color : white;}
		.ui-sortable{ margin:0px; padding:0px 0px 0px 15px;}
		ul .sliderList {margin:0px 30px 15px 0px;display:inline-block; border-radius:0px; vertical-align : top; background-color : #ffffff; box-sizing:border-box; border:none; box-shadow:0px 1px 5px 0px rgba(0, 0, 0, 0.20);position:relative;}
		ul .slider-header {padding:0px 0px 0px 15px;margin:0px;position: relative;cursor:move; border:none; font-size:14px; font-weight:bold; height:40px; line-height:38px; border-radius:0px; color:#393939;background-color:#2196f3; border:1px solid #2196f3; width:268px;}
		ul .slider-header-add {padding:0px 0px 0px 15px;margin:0px;position: relative;cursor:move; border:none; font-size:14px; font-weight:bold; height:40px; line-height:38px; border-radius:0px; color:#393939;background-color:#2196f3; border:1px solid #2196f3; width:268px;}
		ul .slider-header-modify {padding:0px 0px 0px 15px;margin:0px;position: relative;cursor:move; border:none; font-size:14px; font-weight:bold; height:40px; line-height:38px; border-radius:0px; color:#393939;background-color:#2196f3; border:1px solid #2196f3; width:268px;}
		ul .slider-content {clear:both; box-sizing:border-box; border-radius:0px; border:1px solid #dfe2e4; margin:-1px 0px 0px 0px;}
		ul .slider-imagePage {width:225px; height:210px;}
		ul .addSlider {border:1px dashed #aab2ba; display:inline-block; text-align:center; vertical-align : top; height:19.3em; border-radius:0px; width:285px; height:635px; position:relative;}
		.sliderInfoTD {padding:10px 15px 10px 15px;}
		.sliderInfoTDadd {padding:10px 15px 10px 15px;}
		.sliderInfoModify {padding:10px 15px 10px 15px;}
		ul .addSlider:hover {cursor:pointer;}
		ul .slideIsUse {padding: 10px 5px 10px 10px;}
		.cancelNewSliderBtn img {height:25px; float:right; padding: 3px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
		.addNewSliderBttn img {height:25px; float:right; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
		.slider-header-add {padding:0px 0px 0px 15px;margin:0px;position: relative;cursor:move; border:none; font-size:14px; font-weight:bold; height:40px; line-height:38px; border-radius:0px; color:#393939;border:1px solid #2196f3; width:210px;}
		.addImageBtn span {height:25px; background-color:#f4f4f4; border:1px solid #e7e7e7;  float:right; padding: 0px 9px; line-height: 23px; display:block; text-align: center; margin-top:65%; margin-right:35%}
		#UploadSliderImage {position:relative; bottom:210px;}
		.imgbtn {position: relative;}
		.sliderListmodify {display:inline-block; border-radius:0px; vertical-align : top; background-color : #ffffff; box-sizing:border-box; border:none; box-shadow:0px 1px 5px 0px rgba(0, 0, 0, 0.20);position:relative;}
		.cancelNewSliderBtnmodify img {height:25px; float:right; padding: 3px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
		.sliderURL {display: block; width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;}
	}
		</style>
		<script type="text/javascript">
		  var sliderid = "<c:out value = '${sliderID}' />";
		  var guid = "{" + GetGUID() + "}";
		  var g_xmlhttp;
		  var ReturnFunction;
		  var pNoneActiveX = "YES";
		  
			 document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };  
			
		    $(document).ready(function() {
		    	getSliderList();
		    });
		    
		    //데이터 값 부르기
		    var getSliderList = function() {
		    	$.ajax({
		        	type : "POST",
		        	dataType : "json",
		        	url : "/admin/ezPersonal/getSlider.do",
		        	async : false,
		        	success : function (result) {
		        		//MakeSliderList(loadXMLString(result));
		        		MakeSliderList(result);
		        	}
		        });
		    }
		    
		    //슬라이드 이미지 목록
		    function MakeSliderList(result) {
		    
		    	var sliderSn = "";
		    	var sliderID = "";
		    	var sliderImagePath = "";
		    	/* var sliderName = "";
		    	var sliderName2 = ""; */
		    	var sliderRegDate = "";
		    	var sliderURL = "";
		    	var sliderIsUse = "";
		    	var sliderHTML = "";
		    	var sliderCnt = result.length;
		    	var sliderFileName = "";
		    	
		    	for (var i = 0; i < sliderCnt; i++) {
		    		sliderSn = result[i].sn;
		    		sliderID = result[i].sliderID;
		    		sliderImagePath = result[i].imagePath;
		    		/* sliderName = result[i].sliderName;
		    		sliderName2 = result[i].sliderName2; */
		    		sliderRegDate = result[i].regDate;
		    		sliderURL = result[i].url;
		    		sliderIsUse = result[i].isUse;
		    		
		    		sliderHTML += "<li class = 'sliderList' id = 'sliderList"+i+"' data = '"+sliderID+"' >";
		    		if(sliderIsUse == 1){ 
		    			sliderHTML += "<div class = 'slider-header' style= 'background-color : #3d8fea;'>";
		    		}else {
		    			sliderHTML += "<div class = 'slider-header' style= 'background-color : #f4f4f4; border : 1px solid #e7e7e7; color = #b1b1b1;'>";
		    		}
		    		sliderHTML += "<span class = 'cancelNewSliderBtn' id='cancelNewSliderBtn' data2 = '"+sliderID+"' onclick='deleteSlider(this)'>";
			    	sliderHTML += "<img src='/images/close_xBtn.png'></span>";
			    	sliderHTML += "<span class= 'addNewSliderBttn' id= 'addNewSliderBttn"+i+"' data3 = '"+sliderID+"' onclick='modifySlider(this)'>";
			    	sliderHTML += "<img src='/images/email/popup_icon.gif' ></span>";
		    		sliderHTML += "</div>";
		    		sliderHTML += "<dt><span class='slider-imagePage' data4 = '"+sliderImagePath+"'>";
		    		sliderHTML += "<IMG src ="+sliderImagePath+" style='width:285px;height:515px'/>";
		    		sliderHTML += "</span></dt>";
		    		sliderHTML += "<div class = 'slider-content'>";
		    		sliderHTML += "<table class = 'sliderInfo'>";
		    		/* sliderHTML += "<tr><td class ='sliderInfoTD'>이름</td>";
		    		sliderHTML += "<td class ='sliderName' id = 'sliderName' data4 ='"+sliderName+"'>"+sliderName+"</td></tr>"
		    		sliderHTML += "<tr><td class ='sliderInfoTD'></td><td class ='sliderName2'id = 'sliderName2' data5 ='"+sliderName2+"'></td></tr>"; */
		    		sliderHTML += "<tr><td class ='sliderInfoTD'>URL</td>";
		    		sliderHTML += "<td class ='sliderURL' id = 'sliderURL' data6 ='"+sliderURL+"'style='padding: 10px;'>"+sliderURL+"</td></tr>"
		    		/* sliderHTML += "<tr><td class ='sliderInfoTD'>등록일</td>";
		    		sliderHTML += "<td class ='sliderRegDate' id= 'sliderRegDate' data7 ='"+sliderRegDate+"'>"+sliderRegDate+"</td></tr>" */
		    		
		    		if(sliderIsUse == 1){
		    			sliderHTML += "<tr><td class ='sliderInfoTD'>사용여부</td><td class= 'slideIsUse' id='slideIsUse'><label class='switch'><input type='checkbox' id='toggleButton' checked='checked' data7='"+sliderIsUse+"' onchange='toggleButton(this)'><span class='slider round'></label></td>";
		    		}else {
		    			sliderHTML += "<tr><td class ='sliderInfoTD'>사용여부</td><td class= 'slideIsUse' id='slideIsUse'><label class='switch'><input type='checkbox' id='toggleButton' data7='"+sliderIsUse+"' onchange='toggleButton(this)'><span class='slider round'></label></td>";
		    		}
		    		
		    		sliderHTML += "</tr></table>";
		    		sliderHTML += "</div></li>";
		    		document.getElementById("sliderContainer").innerHTML = sliderHTML;
		    	}
		    	
		    	sliderHTML += "<li class='addSlider' id='addSlider'><div style='margin-top:270px'><img src='/images/admin/slideAdd.png' ></img></div></li>";
		    	document.getElementById("sliderContainer").innerHTML = sliderHTML;
		    	
		    	//슬라이더 추가
		    	document.getElementById("addSlider").onclick = btn_Select;
		    	
		    	//슬라이더 드래그앤드롭
		    	$("#sliderContainer").sortable({
		    		items: "li.sliderList",
		    		start: function(event, ui) {
		    			
		    		},
		    		update : function(event, ui) {
		    			updateLinkOrder();
		    		}
		    	});
		    	$("#sliderContainer").disableSelection();
		    }
			//슬라이드 이미지 사용여부 토글 버튼
		    function toggleButton(obj){
		    	var sliderIsUse = obj.checked;
		    	var sliderList = obj.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
		    	var sliderID = sliderList.getAttribute("data");
		    	var sliderHeader = sliderList.querySelector(".slider-header");
		    	var picture = sliderList.querySelector(".imagePage");
		    	var sliderContent = sliderList.querySelector(".slider-content");
		    	
				if(sliderIsUse){
	 		    	sliderHeader.style.backgroundColor = "#2196f3";
	 		    } else{
	 		    	sliderHeader.style.backgroundColor = "#f4f4f4";
	 		    	sliderHeader.style.border = "1px solid #e7e7e7";
	 		    	sliderHeader.style.color =  "#b1b1b1";
					}
				
				event_statuschange(sliderIsUse, sliderID);
		    }
			
		    //슬라이드 드래그 앤 드랍
		    function updateLinkOrder(){
		    	var sliderList = $(".sliderList");
		    	var sliderListCount = sliderList.length;
		    	var slierImageList = [];
		    	
		    	for (var i = 0; i < sliderListCount; i++){
		    		var sliderID = sliderList[i].getAttribute("data");
		    		var sn = i + 1;
		    		slierImageList.push({"sn": sn, "sliderID": sliderID});
		    	}
		    	
		    	var data = {
		    			slierImageList : slierImageList
		    	};
		    	
		    	$.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/updateSliderImageOrder.do",
		        	contentType: "application/json; charset=utf-8",
		        	dataType : "json",
		        	data : JSON.stringify(data),
		        	success : function(result) {
		        		//success
		        		console.log(result);
		        	}
		        });  
		    }
		    
		    //슬라이더 이미지 추가
		    function btn_Select() {
		    	$(".addSlider").remove();
		    	
		    	var sliderHTML = "";
		    	sliderHTML += "<li class = 'sliderList' id = 'sliderList'>";
		    	sliderHTML += "<div class = 'slider-header-add' style='background-color:#f4f4f4;border:1px solid #e7e7e7;color:#b1b1b1'>";
		    	sliderHTML += "<a class = 'cancelNewSliderBtn' id='cancelNewSliderBtn'>";
		    	sliderHTML += "<span class ='addCancel'><img src='/images/close_xBtn.png'></span></a>";
		    	sliderHTML += "</div>";
		    	sliderHTML += "<div class = 'slider-content' style='width:285px;height:515px'>";
		    	sliderHTML += "<a class ='addImageBtn'>";
		    	sliderHTML += "<span class = 'addImage' id='addImage' onclick='addImage()'>이미지 선택</span></a>";
		    	sliderHTML += "<img id='UploadSliderImage' src='' onload ='imgdisplay()' style='width:285px;height:515px;display:none'>";
		    	sliderHTML += "</div>";
		    	sliderHTML += "<div class = 'slider-content'>";
		    	sliderHTML += "<table class = 'sliderInfo'>";
		    	/* sliderHTML += "<tr><td class ='sliderInfoTDadd'>한글";
		    	sliderHTML += "<input id ='txtDisplayName' type='text' maxlength='50'></td></tr>";
		    	sliderHTML += "<tr><td class ='sliderInfoTDadd'>영어";
		    	sliderHTML += "<input id ='txtDisplayName2' type='text' maxlength='50'></td></tr>"; */
		    	sliderHTML += "<tr><td class ='sliderInfoTDadd'>URL</td>";
		    	sliderHTML += "<td><input id='txtDisplayName3' type='text' maxlength='50'></td></tr>";
		    	sliderHTML += "<tr><td class ='sliderInfoTDadd'>사용여부</td><td class= 'slideIsUse'><label class='switch'><input id='slideIsUseAdd' type='checkbox' checked='checked'><span class='slider round'></label></td>";
		    	sliderHTML += "<td><a href='#' class='imgbtn'><span onclick='btnSave_click();'><spring:message code = 'ezPersonal.t34' /></span></a></td>";
		    	sliderHTML += "</tr></table>"
		    	sliderHTML += "</div>";
		    	sliderHTML += "</li>";
		    	
		    	document.getElementById("sliderContainer").insertAdjacentHTML('beforeend', sliderHTML);
		    	
		    	$(".cancelNewSliderBtn").on("click", addCancel);
		    } 
		    //슬라이드 이미지 생성 취소
		    var addCancel = function() {
		    	getSliderList();
		    	//window.location.reload();
		    }
		    
		    //슬라이드 이미지 추가
		    function addImage(){
		    	if(CrossYN() || pNoneActiveX == "YES"){
		    		document.getElementById("file1").click();
		    	} else {
		    		//IE9 미만 처리 소스
		    		var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
 		            var filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
 		            if (filepath == "") return;
	
 		            var strBase64 = ezUtil.DownloadToBase64(filepath);
 		            ezUtil = null;
	
 		            var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
 		            var temp = ezUtil.GetImageSize(filepath);
 		            ezUtil = null;
	
 		            imageWidth = temp.split("*")[0];
 		            imageHeight = temp.split("*")[1];
 		            tempfilename = filepath.substr(filepath.lastIndexOf("\\") + 1);
 		            var strXML = "<IMAGE><OLDFILENAME>" + tempfilename + "</OLDFILENAME><FILENAME>" + guid + "</FILENAME><DATA>" + strBase64 + "</DATA></IMAGE>";
	
 		            g_xmlhttp = createXMLHttpRequest();
 		            g_xmlhttp.open("POST", "/ezPersonal/uploadSliderImage.do?mode=SLIDERIMAGE", true);
 		            g_xmlhttp.onreadystatechange = changeSliderImage_end;
 		            g_xmlhttp.send(strXML);
		    	}
		    }
		    //IE9 미만 브라우저일 때 이미지 처리
		    function changeSliderImage_end() {
		        /* if (g_xmlhttp.readyState != 4) {
		        	return;
		        } */
	
		        UploadSliderImage.src = g_xmlhttp.responseText;
		    } 
		    
		    //이미지 파일 컨트롤러에 보내기
		    function btn_attach(){
		    	var extension = document.getElementById("file1").value.split('.');
		    	console.log(extension);
		        var check = false;
		        check = compareExtension(check, extension[1]);
		        
		       if (!check) {
		            alert("<spring:message code = 'ezPersonal.t206' />" + " <spring:message code = 'ezPersonal.t200' />");
		            document.getElementById("file1").value = "";
		        }
		        
		        var frm = document.getElementById('form');
		        
		        frm.action = "/admin/ezPersonal/saveSliderImage.do?mode=SLIDERIMAGE";
		        frm.submit();
		        
		        
		        document.form.file1.value = ""; 
		        
		    }
		    
		    
		    //슬라이드 이미지 파일 체크 여부
		    function compareExtension(check, extension) {
		        var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
		        for (var i = 0; i < filterExtension.length; i++) {
		            if (extension.toLowerCase() == filterExtension[i]) {
		                check = true;
		                break;
		            }
		        }
		        return check;
		    } 
		    
		    function imgdisplay() {
		        UploadSliderImage.style.display = "";
		    }
		    
		    var xml;
		    //xml로 된 이미지 파일 출력
		    function returnvalue(result) {
		        xml = loadXMLString(result);
		        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		        for (var i = 0; i < nodes.length; i++) {
		            if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
		                if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
		                    alert(strLang6);
		                    return;
		                }
		                
		                if (navigator.userAgent.indexOf("Firefox") != -1) {
		                    UploadSliderImage.src = getNodeText(GetChildNodes(nodes[i])[4]);
		                } else {
		                    UploadSliderImage.src = getNodeText(GetChildNodes(nodes[i])[4]);
		                }
		                
		                //UploadSliderImage.style.display = "";
		            } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		                alert(strLang8 + "10MB" + strLang9);
		                return;
		            } else {
		                alert(filename + " <spring:message code = 'ezPersonal.lhj01' />" + "\n\n" + result);
		            }
		        }
		    }
		    
		    //생성된 슬라이드 이미지 저장 
		    function btnSave_click(){
		    	/* if (specialChk(document.getElementById("txtDisplayName").value)) {
			    	alert("<spring:message code='ezResource.special' />");
			    	return;
			    }
		    	if (document.getElementById("txtDisplayName").value == "") {
		            alert("<spring:message code = 'ezPersonal.t1027' />");
		            return;
		        } else if (document.getElementById("txtDisplayName2").value == "") {
		            alert("<spring:message code = 'ezPersonal.t1027' />");
		            return; 
		        } */
		        //} else if (document.getElementById("UploadSliderImage").src.indexOf("upload_portal") == -1) {
		         if (document.getElementById("UploadSliderImage").src.indexOf("${uploadPortalPath}") == -1) {	
		            alert("<spring:message code = 'ezPersonal.t20000' /> ");
		            return;
		        } else if (document.getElementById("txtDisplayName3").value == "") {
		            alert("URL을 입력하세요.");
		            return; 
		        }
		         
		    	var displayName = "";
		    	var displayName2 = "";
		    	var SliderImgPath = UploadSliderImage.src.substr(UploadSliderImage.src.indexOf("${uploadPortalPath}"));
		    	var isUseCk = document.getElementById("slideIsUseAdd").checked;
		    	var isUse = "";
		    	console.log(isUseCk);
		    	if (isUseCk) {
		    		isUse = 1;
		    	} else {
		    		isUse = 0;
		    	}
		    	console.log(isUse);

		        var item;
		        var mode;
		        
		            item = guid;
		            mode = "NEW";
		            fileName = getNodeText(SelectNodes(xml, "ROOT/NODES/NODE/PFILENAME")[0]);
		         /* else {
		            item = sliderid;
		            mode = "MOD";
		            fileName = SliderImgPath.substr(SliderImgPath.lastIndexOf("/") + 1);
		        } */
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/saveSlider.do",
		        	async : false,
		        	data : {sliderID : item,
		        			mode : mode,
		        			displayName : displayName,
		        			displayName2 : displayName2,
		        			url : txtDisplayName3.value,
		        			fileName : fileName,
		        			sliderImage : SliderImgPath,
		        			isUse : isUse},
		        	dataType : "text",
		        	success : function (result) {
		        		if (result == "OK") {
		        			alert("<spring:message code = 'ezPersonal.t191' />");
				            
				            if (ReturnFunction != null) {
				                ReturnFunction();
				            }
				            window.location.reload();
		        		} else {
		        			alert("<spring:message code = 'ezPersonal.t192' />");
		        		}
		        	}
		        });
		        
		        getSliderList();
		        
		    }
		    
		    //수정한 슬라이드 저장
		    //슬라이드 아이디 16진수 랜덤으로 등록
		    function S4() {
		        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
		    }
			//슬라이드 16진수 아이디 반환
		    function GetGUID() {
		        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
		    }
		    
		    /* function btn_Select_Complete() {
		        window.location.reload(false);
		    }  */
		    //슬라이더 수정 함수
		    function modifySlider(obj) {
		    	var preList = $(".sliderList");
		    	var preListlength = preList.length;
		    	var preFind = "";
		    	
		    	for(var i = 0; i<preListlength; i++){
		    		preFind = preList[i].querySelector(".sliderListmodify");
		    		
		    		if(preFind != null){
		    			preFind.remove();
		    			getSliderList();
		    		}
		    	}
		    	
		    	var sliderID = obj.getAttribute("data3");
		    	var sliderList = obj.parentNode.parentNode;
		    	/* var name1 = sliderList.querySelector("#sliderName").getAttribute("data4");
		    	var name2 = sliderList.querySelector("#sliderName2").getAttribute("data5"); */
		    	var url = sliderList.querySelector("#sliderURL").getAttribute("data6");
		    	//var regDate = sliderList.querySelector("#sliderRegDate").getAttribute("data7");
		    	
		    	var sliderHTML = "";
		    	sliderHTML += "<li class = 'sliderListmodify' id = 'sliderListmodify'>";
		    	sliderHTML += "<div class = 'slider-header-add' style='background-color:#f4f4f4;border:1px solid #e7e7e7;color:#b1b1b1'>";
		    	sliderHTML += "<a class = 'cancelNewSliderBtnmodify' id='cancelNewSliderBtnmodify'>";
		    	sliderHTML += "<span class ='addCancel-modify'><img src='/images/admin/icon_cancel.png'></span></a>";
		    	sliderHTML += "</div>";
		    	sliderHTML += "<div class = 'slider-content' style='width:285px;height:515px'>";
		    	sliderHTML += "<a class ='addImageBtn'>";
		    	sliderHTML += "<span class = 'addImage' id='addImage' onclick='addImage()'>이미지 선택</span></a>";
		    	sliderHTML += "<img id='UploadSliderImage' src='' onload ='imgdisplay()' style='width:285px;height:515px;display:none'>";
		    	sliderHTML += "</div>";
		    	sliderHTML += "<div class = 'slider-content'>";
		    	sliderHTML += "<table class = 'sliderInfo'>";
		    	/* sliderHTML += "<tr><td class ='sliderInfoTDadd'>한글<input id ='txtDisplayName' value='"+name1+"' type='text' maxlength='50'></td></tr>";
		    	sliderHTML += "<tr><td class ='sliderInfoTDadd'>영어";
		    	sliderHTML += "<input id ='txtDisplayName2' value='"+name2+"' type='text' maxlength='50'></td></tr>"; */
		    	sliderHTML += "<tr><td class ='sliderInfoTDadd'>URL</td>";
		    	sliderHTML += "<td><input id='txtDisplayName3' value='"+url+"'type='text' maxlength='50'></td></tr>";
		    	sliderHTML += "<tr><td class ='sliderInfoTDadd'>사용여부</td><td class= 'slideIsUse'><label class='switch' style='right:10px'><input id='slideIsUseModify' type='checkbox' checked='checked'><span class='slider round'></label></td>";
		    	sliderHTML += "<td><a href='#' class='imgbtn'><span data='"+sliderID+"' onclick='btnSave_click_modify(this);'><spring:message code = 'ezPersonal.t34' /></span></a></td></tr>";
		    	sliderHTML += "</table>"
		    	sliderHTML += "</div>";
		    	sliderHTML += "</li>";
		    	
		    	sliderList.innerHTML = sliderHTML;
		    	
		    	$(".cancelNewSliderBtnmodify").on("click", addCancelModify);
		    }
		    
		    function btnSave_click_modify(obj){
		    	var sliderID = obj.getAttribute("data");
		    	
		    	/* if (specialChk(document.getElementById("txtDisplayName").value)) {
			    	alert("<spring:message code='ezResource.special' />");
			    	return;
			    }
		    	if (document.getElementById("txtDisplayName").value == "") {
		            alert("<spring:message code = 'ezPersonal.t1027' />");
		            return;
		        } else if (document.getElementById("txtDisplayName2").value == "") {
		            alert("<spring:message code = 'ezPersonal.t1027' />");
		            return; } */
		        //} else if (document.getElementById("UploadSliderImage").src.indexOf("upload_portal") == -1) {
		         if (document.getElementById("UploadSliderImage").src.indexOf("${uploadPortalPath}") == -1) {	
		            alert("<spring:message code = 'ezPersonal.t20000' /> ");
		            return;
		        }
		        
		        var displayName = "";
			    var displayName2 = "";
		    	var SliderImgPath = UploadSliderImage.src.substr(UploadSliderImage.src.indexOf("${uploadPortalPath}"));
		    	var isUseCk = document.getElementById("slideIsUseModify").checked;
		    	var isUse = "";
		    	console.log(isUseCk);
		    	if (isUseCk) {
		    		isUse = 1;
		    	} else {
		    		isUse = 0;
		    	}
		    	console.log(isUse);

		        var item;
		        var mode;
		        item = sliderID;
	            mode = "MOD";
	            fileName = SliderImgPath.substr(SliderImgPath.lastIndexOf("/") + 1);
	            
	            
	            $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/saveSlider.do",
		        	async : false,
		        	data : {sliderID : item,
		        			mode : mode,
		        			displayName : displayName,
		        			displayName2 : displayName2,
		        			url : txtDisplayName3.value,
		        			fileName : fileName,
		        			sliderImage : SliderImgPath,
		        			isUse : isUse},
		        	dataType : "text",
		        	success : function (result) {
		        		if (result == "OK") {
		        			alert("<spring:message code = 'ezPersonal.t191' />");
				            
				            if (ReturnFunction != null) {
				                ReturnFunction();
				            } 
				            
				            getSliderList();
				            //window.location.reload();
		        		} else {
		        			alert("<spring:message code = 'ezPersonal.t192' />");
		        		}
		        	}
		        });
		        
		    }
		    
		    var addCancelModify = function(){
		    	//window.location.reload();
		    	getSliderList();
		    }
			//슬라이드 카드 삭제
		    function deleteSlider(obj) {
		    	var slideList = obj.parentNode.parentNode;
		    	var sliderID = obj.getAttribute("data2");
		    	
		        if (sliderID == "") {
		            alert("<spring:message code = 'ezPersonal.t1022' />");
		            return;
		        }
		        if (!confirm("<spring:message code = 'ezPersonal.t00003' />"))
		            return;
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/deleteSlider.do",
		        	async : false,
		        	dataType : "text",
		        	data : {sliderID : sliderID},
		        	success : function(result) {
		        		if (result == "OK") {
		        			window.location.reload(false);
		        		} else {
		        			alert("error");
		        		}
		        	}
		        }); 
		    } 
	
		    /* function MakeDescription(filepath) {
		        document.getElementById("ContentDescription").innerHTML = "<IMG src = '"+filepath+"' style='width:280px;height:515px' />";
		    } */
	
		    /* function Reload() {
		        window.location.reload(false);
		    } */
		    
		    /* function Priority_UP() {
		    	if (CrossYN()) {
		            if (_RowObject == null) {
		                alert("<spring:message code = 'ezPersonal.t1022' />");
		                return;
		            }
		            var ChangeRow = null;
		            for (var i = 0; i < _RowObject.parentNode.children.length ; i++) {
		                if (_RowObject.parentNode.children.item(i) == _RowObject) {
		                    if (i == 0) {
		                        return;
		                    }
		                    ChangeRow = i - 1;
		                    if (event_ChangePriority(_RowObject.getAttribute("DATA1"), _RowObject.getAttribute("DATA5"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA1"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA5"))) {
		                    swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
		                    }
		                    break;
		                }
		            }
		    	} else {
		    	    if (_RowObject == null) {
		                alert("<spring:message code = 'ezPersonal.t1022' />");
		                return;
		            }
		            
		            var ChangeRow = null;
		            for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
		                if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
		                    if (i == 0) {
		                        return;
		                    }
		                    ChangeRow = i - 1;
		                    if (event_ChangePriority(_RowObject.getAttribute("DATA1"), _RowObject.getAttribute("DATA5"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA1"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA5")))
		                    swapNodes(_RowObject, _RowObject.parentNode.childNodes.item(ChangeRow));
		                    break;
		                }
		            }
		    	}
		    } */
		    
		    /* function Priority_DOWN() {
		        if (_RowObject == null) {
		            alert("<spring:message code = 'ezPersonal.t1022' />");
		            return;
		        }
		        
		        var ChangeRow = null;
		        for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
		            if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
		                if (i == _RowObject.parentNode.childNodes.length - 1) {
		                    return;
		                }
		                ChangeRow = i + 1;
		                
		                if (event_ChangePriority(_RowObject.getAttribute("DATA1"), _RowObject.getAttribute("DATA5"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA1"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("DATA5"))) {
		                	swapNodes(_RowObject, _RowObject.parentNode.childNodes.item(ChangeRow));
		                }
		                
		                break;
		            }
		        }
		    } */
		    
		    /* function event_ChangePriority(A_itemid, A_priority, B_itemid, B_priority) {
		        var ret = null;
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/statusChangeSlider.do",
		        	async : false,
		        	dataType : "text",
		        	data : {aRuleID : A_itemid, aPriority : B_priority, bRuleID : B_itemid, bPriority : A_priority, mode : "P"},
		        	success : function(result) {
		        		if (result == "OK") {
		        			ret = true;
		        		} else {
		        			alert(result);
		        			
		        			ret = false;
		        		}
		        	}
		        });
		        
		        return ret;
		    } */
		    
		    /* function swapNodes(item1, item2) {
		        var itemtmp = item1.cloneNode(1);
		        var parent = item1.parentNode;
		        item2 = parent.replaceChild(itemtmp, item2);
		        item1.setAttribute("DATA5", item2.getAttribute("DATA5"));
		        item2.setAttribute("DATA5", itemtmp.getAttribute("DATA5"));
		        parent.replaceChild(item2, item1);
		        parent.replaceChild(item1, itemtmp);
		        itemtmp = null;
		    } */
			//슬라이드 이미지 사용여부
		    function event_statuschange(check, sliderId) {
		       var isUse = "";
		         
		       if(check== true) {
			      isUse = '1';
			   } else {
			      isUse = '0';
			   }  
			    
			        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/statusChangeSlider.do",
		        	async : false,
		        	dataType : "text",
		        	data : {sliderID : sliderId, isUse : isUse, mode : "U"},
		        	success : function(result) {
		        		if (result != "OK") {
		        			alert(result);
		        		}
		        	}
		        });
		    } 
	
		    /* function event_dbclick(clickitem) {
		        if (CrossYN()) {
		            selectimage_dialogArguments[1] = btn_Select_Complete;
		            
		            var SelectImage = window.open("/admin/ezPersonal/selectImage.do?item=" + document.getElementById(clickitem).getAttribute("DATA1"), "SelectImage", GetOpenWindowfeature(410, 750));
		            try { SelectImage.focus(); } catch (e) {
		            }
		        }
		        else {
		            var url = "/admin/ezPersonal/selectImage.do?item=" + document.getElementById(clickitem).getAttribute("DATA1") + "";
		            var feature = "center:yes;status:no;dialogWidth:410px;dialogHeight:750px;edge:sunken;scroll:no" + GetShowModalPosition(410, 750);
		            feature = feature + GetShowModalPosition(410, 750);
	
		            window.showModalDialog(url, "", feature);
	
		            window.location.reload(false);
		        }
		    } */
		</script>
	</head>
	<body class = "mainbody">
		<h1><spring:message code = 'ezPersonal.t20004' /></h1>
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;<spring:message code = 'ezPersonal.t20009' /></span><br />
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;등록된 이미지는 285 * 515(가로*세로)으로 홈 화면에 보여지게 됩니다.</span><br />
		</span>
	    <br /><br /><br />
	    <div id="mainmenu">
	    	<ul>
	        	<%-- <li class="important"><span id ="NEW" onClick="btn_Select(this)"><spring:message code = 'ezPersonal.t105' /></span></li> --%>
				<%-- <li><span onclick="sliderdelete();"><spring:message code = 'ezPersonal.t99' /></span></li> --%>
				<%-- <li><span class="icon16 icon16_refresh" onclick="Reload();"></span></li>
				<li><span onclick="Priority_UP();"><img src="/images/ImgIcon/prev.gif"  style="margin-top:-2px;" alt="<spring:message code = 'ezPersonal.t366' />"/></span></li>
				<li><span onclick="Priority_DOWN();"><img src="/images/ImgIcon/next.gif"  style="margin-top:-2px;" alt="<spring:message code = 'ezPersonal.t367' />" /></span></li> --%>
			</ul>
	    </div>
	    <ul id="sliderContainer" class="ui-sortable">
	    
	    </ul>
	   
		<%-- <table style="width:750px;height:215px;">
	    	<tr>
	            <td>
	            <!-- 18-05-10 김민성 - 관리자 > 슬라이드 이미지 테이블 크기 수정 -->
	            	<div style="border:1px solid #dbdbda;width:560px;height:530px;border-top:0px;overflow-y:auto;overflow-x:hidden">
					<!-- <div style="border:1px solid #dbdbda;width:435px;height:215px;border-top:0px;overflow-y:auto;overflow-x:hidden"> -->
	                	<%--<div id="lvDocList"></div>
	                <table class="mainlist" style="width:100%;">
		                    <tr>
		                        <td style="width:8%;background-color:#f8f8f8;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;"><span><spring:message code = 'ezPersonal.t937' /></span></td>
		                        <td style="width:60%;background-color:#f8f8f8;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;"><span style="padding-left:10px;"><spring:message code = 'ezPersonal.t9' /></span></td>
		                        <td style="width:32%;background-color:#f8f8f8;text-align:center;border-bottom:2px solid #dbdbda;"><span><spring:message code = 'ezPersonal.t1024' /></span></td>
		                    </tr>
		                </table>
					</div>
	            </td>
	            <!-- <td style="vertical-align:top">
	            	<div style="border:1px solid #dbdbda;width:295px;height:530px;overflow-y:auto;margin:0px 5px 0px 5px;">
	                	<div id="ContentDescription" style="margin-top:1px;margin:5px 5px 5px 5px;">
	                	</div>
	            	</div>
	            </td> -->
	        </tr>
		</table> --%>
		<script>
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	     <form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm" style="width:1px;height:1px">
	        <input type="file" name="file1" id="file1" onchange="btn_attach()" style="display: none;" multiple="false" />
	        <input type="hidden" name="boardid" id="boardid" />
	        <input type="hidden" name="maxsize" id="maxsize" />
	        <input type="hidden" name="mode" id="mode" value="SLIDERIMAGE"/>
	        <input type="hidden" name="cnt" id="cnt" />
	        <input type="hidden" name="mailgubun" id="mailgubun" />
	    </form>		
	</body>
</html>