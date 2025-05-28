<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/admin.css')}" type="text/css">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/default.css')}" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/component.css')}" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		
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
		    		if(result[i].url == null) {
		    			result[i].url = "";
		    		}
		    		sliderURL = result[i].url;
		    		sliderIsUse = result[i].isUse;
		    		
		    		sliderHTML += "<li class = 'sliderList' id = 'sliderList"+i+"' data = '"+sliderID+"' >";
		    		sliderHTML += "<div class = 'slider-body' id= 'slider-body'>";
		    		sliderHTML += "<dl class='slider-head' id='slider-head'>";
		    		sliderHTML += "<dt class = 'sliderHDT' id='cancelNewSliderBtn' data2 = '"+sliderID+"' onclick='deleteSlider(this)'>";
			    	sliderHTML += "<img src='/images/admin/delete_white.png'></span></dt>";
			    	sliderHTML += "<dd class= 'sliderHDD' id= 'addNewSliderBttn"+i+"' data3 = '"+sliderID+"' onclick='modifySlider(this)'>";
			    	sliderHTML += "<img src='/images/admin/editPen_white.png' ></span></dd>";
		    		sliderHTML += "</dl>";
		    		sliderHTML += "<dl class = 'slider-content'>";
		    		sliderHTML += "<dt class = 'sliderCDT'>";
		    		sliderHTML += "<span class='sliderTtit'>URL</span>";
		    		sliderHTML += "<span class='sliderText'>";
		    		sliderHTML += "<input id = 'sliderURL' data6 ='"+sliderURL+"' class='admin_input' type='text' value='" + sliderURL + "' readonly></span>";
		    		sliderHTML += "</dt>";
		    		sliderHTML += "<dt class='sliderCDT'><span class='sliderTtit'><spring:message code = 'ezPersonal.mse1' /></span>";
		    		sliderHTML += "<span id='slideIsUse' class='sliderSwitch'><label class='switch'>";
		    		/* sliderHTML += "<tr><td class ='sliderInfoTD'><spring:message code = 'ezPersonal.mse3' /></td>";
		    		sliderHTML += "<td class ='sliderURL' id = 'sliderURL' data6 ='"+sliderURL+"'style='padding: 10px;'>"+sliderURL+"</td></tr>"*/
		    		
		    		if(sliderIsUse == 1){
		    			sliderHTML += "<input type='checkbox' id='toggleButton' checked='checked' data7='"+sliderIsUse+"' onchange='toggleButton(this)'><span class='slider round'>";
		    		}else {
		    			sliderHTML += "<input type='checkbox' id='toggleButton' data7='"+sliderIsUse+"' onchange='toggleButton(this)'><span class='slider round'>";
		    		}
		    		
		    		sliderHTML += "</label></span></dt>";
		    		sliderHTML += "</dl>";
		    		sliderHTML += "<span class='slider-imagePage' data4 = '"+sliderImagePath+"'>";
		    		sliderHTML += "<IMG src ="+sliderImagePath+" style='width:280px;height:450px'/>";
		    		sliderHTML += "</span>";
		    		sliderHTML += "</li>";
		    		document.getElementById("sliderContainer").innerHTML = sliderHTML;
		    	}
		    	
		    	sliderHTML += "<li class='addSlider' id='addSlider'><div style='width:280px;height:450px;border:1px dashed #aab2ba;'><img src='/images/admin/slideAdd.png' style='display:block;margin:0 auto;margin-top:225px;'></img></div></li>";
		    	document.getElementById("sliderContainer").innerHTML = sliderHTML;
		    	
		    	//슬라이더 추가
		    	document.getElementById("addSlider").onclick = btn_Select;
		    	
		    	//슬라이더 드래그앤드롭
		    	$("#sliderContainer").sortable({
		    		items: "li.sliderList:not(#addSliderBody)",
		    		start: function(event, ui) {
		    			
		    		},
		    		update : function(event, ui) {
		    			updateLinkOrder();
		    		}
		    	});
		    	//$("#sliderContainer").disableSelection();
		    }
			//슬라이드 이미지 사용여부 토글 버튼
		    function toggleButton(obj){
		    	var sliderIsUse = obj.checked;
		    	var sliderList = obj.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
		    	var sliderID = sliderList.getAttribute("data");
		    	var sliderHeader = sliderList.querySelector(".slider-header");
		    	var picture = sliderList.querySelector(".imagePage");
		    	var sliderContent = sliderList.querySelector(".slider-content");
		    	console.log(sliderList);
		    	
				/* if(sliderIsUse){
	 		    	sliderHeader.style.backgroundColor = "#2196f3";
	 		    } else{
	 		    	sliderHeader.style.backgroundColor = "#f4f4f4";
	 		    	sliderHeader.style.border = "1px solid #e7e7e7";
	 		    	sliderHeader.style.color =  "#b1b1b1";
					}  */
				
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
		    	
		    	var preList = $(".sliderList");
		    	var preListlength = preList.length;
		    	var preFind = "";
		    	var preShow = "";
		    	
		    	for (var i = 0; i<preListlength; i++){
		    		preFind = preList[i].querySelector(".sliderModifyBody");
		    		preShow = preList[i].querySelector("#slider-body");
		    		
		    		if(preFind != null){
		    			preFind.parentNode.removeChild(preFind);
		    			preShow.style.display = "";
		    		}
		    	}
		    	
		    	var liElmt = document.createElement("li");
		    	var divElmt  = document.createElement("div");// class : sliderModifyBody
		    	var headerDlElmt   = document.createElement("dl"); //header
		    	var contentDlElmt  = document.createElement("dl"); //content
		    	var divElmt2 = document.createElement("div"); //class : addImageBtnModify
		    	var addImgElmt = document.createElement("img");
		    	
		    	var	spanImgElmt = document.createElement("span"); //class : slider-imagePage
		    	var previewImgElmt = document.createElement("img");
		    	
		    	///// header element
		    	var dtElmt = document.createElement("dt");///back
		    	var imgElmt = document.createElement("img"); //back image
		    	var ddElmt = document.createElement("dd"); //save
		    	var imgElmt2 = document.createElement("img"); //save image
		    	
		    	liElmt.id = "addSliderBody";
		    	divElmt.className = "sliderModifyBody";
		    	headerDlElmt.className = "slider-header-modify";
		    	contentDlElmt.className = "slider-content-modify";
		    	divElmt2.className = "addImageBtnModify";
		    	spanImgElmt.className = "slider-imagePage";
		    	dtElmt.className = "sliderHDT";
		    	ddElmt.className = "sliderHDD";
		    	
		    	imgElmt.src = "/images/admin/back_white.png";
		    	imgElmt2.src = "/images/admin/save_white.png";
		    	previewImgElmt.src = "";
		    	
		    	///// content element
		    	var urlDT = document.createElement("dt"); //url input
		    	var useDT = document.createElement("dt"); //사용 여부
		    	var urlTit = document.createElement("span"); 
		    	var urlTitText = document.createElement("span");
		    	var urlInput = document.createElement("input");
		    	var useTit = document.createElement("span");
		    	var useSwitch = document.createElement("span");
		    	var useSwitchLabel = document.createElement("label");
		    	var useSwitchInput = document.createElement("input");
		    	var useSwitchSpan = document.createElement("span");
		    	
		    	urlDT.className = "sliderCDT";
		    	useDT.className = "sliderCDT";
		    	urlTit.className = "sliderTtit";
		    	urlTitText.className = "sliderText";
		    	urlInput.className = "admin_input";
		    	
		    	useTit.className = "sliderTtit";
		    	useSwitch.className = "sliderSwitch";
		    	useSwitchLabel.className = "switch";
		    	useSwitchSpan.className = "slider round";
		    	
		    	urlTit.innerText = "<spring:message code = 'ezPersonal.mse3' />";
		    	
		    	urlInput.setAttribute("id", "txtDisplayName3");
		    	urlInput.setAttribute("type", "text");
		    	urlInput.setAttribute("maxlength", 50);
		    	urlInput.setAttribute("value", "");
		    	
		    	useTit.innerText = "<spring:message code = 'ezPersonal.mse1' />"; 
		    	
		    	useSwitchInput.setAttribute("type", "checkbox");
		    	useSwitchInput.setAttribute("id", "slideIsUseAdd");
		    	useSwitchInput.setAttribute("checked", "checked");
		    	
		    	imgElmt2.addEventListener("click", function(event) {btnSave_click();});
		    	imgElmt.addEventListener("click", function(evnet) {addCancelModify(this);});
		    	
		    	//header 조합
		    	dtElmt.appendChild(imgElmt);
		    	ddElmt.appendChild(imgElmt2);
		    	headerDlElmt.appendChild(dtElmt);
		    	headerDlElmt.appendChild(ddElmt);
		    	
		    	//content 조합
		    	//- url 조합
		    	urlTitText.appendChild(urlInput);
		    	urlDT.appendChild(urlTit);
		    	urlDT.appendChild(urlTitText);
		    	
		    	//- 사용여부 조합
		    	useSwitchLabel.appendChild(useSwitchInput);
		    	useSwitchLabel.appendChild(useSwitchSpan);
		    	useSwitch.appendChild(useSwitchLabel);
		    	useDT.appendChild(useTit);
		    	useDT.appendChild(useSwitch);
		    	
		    	//url, 사용여부 합침
		    	contentDlElmt.appendChild(urlDT);
		    	contentDlElmt.appendChild(useDT);
		    	
		    	//add image 통합
		    	divElmt2.appendChild(addImgElmt);
		    	spanImgElmt.appendChild(previewImgElmt);
		    	
		    	divElmt2.setAttribute("id", "addImage");
		    	addImgElmt.addEventListener("click", function(event) {addImage();});
		    	previewImgElmt.setAttribute("id", "UploadSliderImage");
		    	previewImgElmt.style.display = "none"; 
		    	previewImgElmt.addEventListener("load", function(event){imgdisplay();});
		    	addImgElmt.setAttribute("src", "/images/admin/imagesPlus.png");

		    	//div에 통합
		    	divElmt.appendChild(spanImgElmt);
		    	divElmt.appendChild(headerDlElmt);
		    	divElmt.appendChild(contentDlElmt);
		    	divElmt.appendChild(divElmt2);
		    	
		    	liElmt.appendChild(divElmt);
		    	
		    	liElmt.style.display = "inline-block"; 
		    	liElmt.className = "sliderList";
				document.getElementById("addSlider").style.display = "none";
		    	$("#sliderContainer").append(liElmt);
		    	
		    } 
		    //슬라이드 이미지 생성 취소
		    var addCancel = function() {
		    	getSliderList();
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
		    	var extension = document.getElementById("file1").value;
		    	extension = extension.substring(extension.lastIndexOf(".") + 1, extension.length);
		    	
		    	if (extension.length >= 2) {
			        var check = false;
			        check = compareExtension(check, extension);
			        
			       if (!check) {
			            alert("<spring:message code = 'ezPersonal.t206' />" + " <spring:message code = 'ezPersonal.t200' />");
			            document.getElementById("file1").value = "";
			            return;
			        }
			       
			       /* 2021-12-09 홍승비 - 슬라이드 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
	   				if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
	   					alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
	   					document.getElementById("file1").value = "";
	   					return;
	   				}
			        
			        var frm = document.getElementById('form');
			        
			        frm.action = "/admin/ezPersonal/saveSliderImage.do?mode=SLIDERIMAGE";
			        frm.submit();
		    	}
		        
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
		        if (document.getElementById("UploadSliderImage").style.display == "none") {	
		            alert("<spring:message code = 'ezPersonal.t20000' /> ");
		            return;
		        }
		        
		    	var displayName = "";
		    	var displayName2 = "";
		    	var SliderImgPath = UploadSliderImage.src.substr(UploadSliderImage.src.indexOf("${uploadPortalPath}"));
		    	var isUseCk = document.getElementById("slideIsUseAdd").checked;
		    	var isUse = "";
		    	
		    	if (isUseCk) {
		    		isUse = 1;
		    	} else {
		    		isUse = 0;
		    	}

		        var item;
		        var mode;
		        	guid = "{" +  GetGUID() + "}";
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
		        			//alert("<spring:message code = 'ezPersonal.t191' />");
				            
				            if (ReturnFunction != null) {
				                ReturnFunction();
				            }
				            
				            getSliderList();
				            //window.location.reload();
		        		} else {
		        			//alert("<spring:message code = 'ezPersonal.t192' />");
		        		}
		        	}
		        });
		        
		        getSliderList();
		        
		    }
		    
		    //슬라이드 아이디 16진수 랜덤으로 등록
		    function S4() {
		        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
		    }
			//슬라이드 16진수 아이디 반환
		    function GetGUID() {
		        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
		    }
		    
		    //슬라이더 수정 함수
		    function modifySlider(obj) {
		    	var preList = $(".sliderList");
		    	var addList = $("#addSliderBody");
		    	var preListlength = preList.length;
		    	var preFind = "";
		    	var preShow = "";
		    	
		    	for (var i = 0; i<preListlength; i++){
		    		preFind = preList[i].querySelector(".sliderModifyBody");
		    		preShow = preList[i].querySelector("#slider-body");
		    		
		    		if(preFind != null){
		    			preFind.parentNode.removeChild(preFind);
		    			
		    			if (preShow != null) {
		    				preShow.style.display = "";
		    			}
		    			
		    		}
		    	}
		    	
		    	if(addList != null){
		    		addList.remove();
		    		$(".addSlider").show();
		    	}
		    	
		    	var sliderID = obj.getAttribute("data3");
		    	var sliderList = obj.parentNode.parentNode.parentNode;
		    	var url = sliderList.querySelector("#sliderURL").getAttribute("data6");
		    	var sliderIsUse = sliderList.querySelector("#toggleButton").checked;
		    	sliderList.querySelector("#slider-body").style.display = "none";
		    	var imgUrl = sliderList.querySelector(".slider-imagePage").getAttribute('data4');
		    	
		    	var divElmt  = document.createElement("div");// class : sliderModifyBody
		    	var headerDlElmt   = document.createElement("dl"); //header
		    	var contentDlElmt  = document.createElement("dl"); //content
		    	var divElmt2 = document.createElement("div"); //class : addImageBtnModify
		    	var addImgElmt = document.createElement("img");
		    	
		    	var	spanImgElmt = document.createElement("span"); //class : slider-imagePage
		    	var previewImgElmt = document.createElement("img");
		    	
		    	///// header element
		    	var dtElmt = document.createElement("dt");///back
		    	var imgElmt = document.createElement("img"); //back image
		    	var ddElmt = document.createElement("dd"); //save
		    	var imgElmt2 = document.createElement("img"); //save image
		    	
		    	divElmt.className = "sliderModifyBody";
		    	headerDlElmt.className = "slider-header-modify";
		    	contentDlElmt.className = "slider-content-modify";
		    	divElmt2.className = "addImageBtnModify";
		    	spanImgElmt.className = "slider-imagePage";
		    	dtElmt.className = "sliderHDT";
		    	ddElmt.className = "sliderHDD";
		    	
		    	imgElmt.src = "/images/admin/back_white.png";
		    	imgElmt2.src = "/images/admin/save_white.png";
		    	previewImgElmt.src = imgUrl;
		    	
		    	///// content element
		    	var urlDT = document.createElement("dt"); //url input
		    	var useDT = document.createElement("dt"); //사용 여부
		    	var urlTit = document.createElement("span"); 
		    	var urlTitText = document.createElement("span");
		    	var urlInput = document.createElement("input");
		    	var useTit = document.createElement("span");
		    	var useSwitch = document.createElement("span");
		    	var useSwitchLabel = document.createElement("label");
		    	var useSwitchInput = document.createElement("input");
		    	var useSwitchSpan = document.createElement("span");
		    	
		    	urlDT.className = "sliderCDT";
		    	useDT.className = "sliderCDT";
		    	urlTit.className = "sliderTtit";
		    	urlTitText.className = "sliderText";
		    	urlInput.className = "admin_input";
		    	
		    	useTit.className = "sliderTtit";
		    	useSwitch.className = "sliderSwitch";
		    	useSwitchLabel.className = "switch";
		    	useSwitchSpan.className = "slider round";
		    	
		    	urlTit.innerText = "<spring:message code = 'ezPersonal.mse3' />";
		    	
		    	urlInput.setAttribute("id", "txtDisplayName3");
		    	urlInput.setAttribute("type", "text");
		    	urlInput.setAttribute("maxlength", 50);
		    	urlInput.setAttribute("value", url);
		    	
		    	useTit.innerText = "<spring:message code = 'ezPersonal.mse1' />";
		    	/* tdElmt1.className = "sliderInfoTDadd";
		    	tdElmt1.innerText = "<spring:message code = 'ezPersonal.mse3' />"; */
		    	/* ipElmt1.setAttribute("id", "txtDisplayName3");
		    	ipElmt1.setAttribute("type", "text");
		    	ipElmt1.setAttribute("maxlength", 50);
		    	ipElmt1.setAttribute("value", url); */
		    	/* tdElmt3.className = "sliderInfoTDadd";
		    	tdElmt3.innerText = "<spring:message code = 'ezPersonal.mse1' />"; */
		    	
		    	useSwitchInput.setAttribute("type", "checkbox");
		    	useSwitchInput.setAttribute("id", "slideIsUseModify");
		    	
		    	if (sliderIsUse == true){
		    		/* tdElmt4.className = "slideIsUse";
		    		lalElmt.className = "switch";
		    		ipElmt3.setAttribute("id", "slideIsUseModify");
		    		ipElmt3.setAttribute("type", "checkbox"); */
		    		useSwitchInput.setAttribute("checked", "checked");
		    		/* spaElmt2.className = "slider round"; */
		    	} else {
		    		/* tdElmt4.className = "slideIsUse";
		    		lalElmt.className = "switch";
		    		ipElmt3.setAttribute("id", "slideIsUseModify"); */
		    		/* ipElmt3.setAttribute("type", "checkbox"); */
		    		/* spaElmt2.className = "slider round"; */
		    	}
		    	
		    	
		    	/* aElmt3.className = "imgbtn";
		    	aElmt3.setAttribute("href", "#");
		    	aElmt3.setAttribute("data", sliderID); */
		    	imgElmt2.addEventListener("click", function(event) {btnSave_click_modify(this);});
		    	imgElmt.addEventListener("click", function(evnet) {addCancelModify(this);});
		    	/* spaElmt4.innerText = "<spring:message code = 'ezPersonal.t34' />"; */
		    	
		    	/* tabElmt.appendChild(trElmt1);
		    	trElmt1.appendChild(tdElmt1);
		    	trElmt1.appendChild(tdElmt2);
		    	tdElmt2.appendChild(ipElmt1);
		    	tabElmt.appendChild(trElmt2);
		    	trElmt2.appendChild(tdElmt3);
		    	trElmt2.appendChild(tdElmt4);
		    	trElmt2.appendChild(tdElmt5);
		    	tdElmt4.appendChild(lalElmt);
		    	lalElmt.appendChild(ipElmt3);
		    	lalElmt.appendChild(spaElmt2);
		    	trElmt2.appendChild(tdElmt5);
		    	tdElmt5.appendChild(aElmt3);
		    	aElmt3.appendChild(spaElmt4); */
		    	
		    	//header 조합
		    	dtElmt.appendChild(imgElmt);
		    	ddElmt.appendChild(imgElmt2);
		    	headerDlElmt.appendChild(dtElmt);
		    	headerDlElmt.appendChild(ddElmt);
		    	
		    	//content 조합
		    	//- url 조합
		    	urlTitText.appendChild(urlInput);
		    	urlDT.appendChild(urlTit);
		    	urlDT.appendChild(urlTitText);
		    	
		    	//- 사용여부 조합
		    	useSwitchLabel.appendChild(useSwitchInput);
		    	useSwitchLabel.appendChild(useSwitchSpan);
		    	useSwitch.appendChild(useSwitchLabel);
		    	useDT.appendChild(useTit);
		    	useDT.appendChild(useSwitch);
		    	
		    	//url, 사용여부 합침
		    	contentDlElmt.appendChild(urlDT);
		    	contentDlElmt.appendChild(useDT);
		    	
		    	//add image 통합
		    	divElmt2.appendChild(addImgElmt);
		    	spanImgElmt.appendChild(previewImgElmt);
		    	
		    	divElmt2.setAttribute("id", "addImage");
		    	addImgElmt.addEventListener("click", function(event) {addImage();});
		    	previewImgElmt.setAttribute("id", "UploadSliderImage");
		    	addImgElmt.setAttribute("src", "/images/admin/imagesPlus.png");
		    	addImgElmt.addEventListener("load", function(event){imgdisplay();});

		    	//div에 통합
		    	divElmt.appendChild(spanImgElmt);
		    	divElmt.appendChild(headerDlElmt);
		    	divElmt.appendChild(contentDlElmt);
		    	divElmt.appendChild(divElmt2);
		    	
		    	sliderList.appendChild(divElmt);
		    }
		    
		    function btnSave_click_modify(obj, event){
		    	var sliderID = obj.parentNode.parentNode.parentNode.parentNode.getAttribute("data");
		    	/* if (specialChk(document.getElementById("txtDisplayName").value) ) {
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
		        if (document.getElementById("UploadSliderImage").style.display == "none") {	
		            alert("<spring:message code = 'ezPersonal.t20000' /> ");
		            return;
		        }
		        
		        var displayName = "";
			    var displayName2 = "";
		    	var SliderImgPath = UploadSliderImage.src.substr(UploadSliderImage.src.indexOf("${uploadPortalPath}"));
		    	var isUseCk = document.getElementById("slideIsUseModify").checked;
		    	var isUse = "";
		    	if (isUseCk) {
		    		isUse = 1;
		    	} else {
		    		isUse = 0;
		    	}

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
		        			//alert("<spring:message code = 'ezPersonal.t191' />");
				            
				            if (ReturnFunction != null) {
				                ReturnFunction();
				            } 
				            
				            getSliderList();
				            //window.location.reload();
		        		} else {
		        			//alert("<spring:message code = 'ezPersonal.t192' />");
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
		        			getSliderList();
		        		} else {
		        			//alert("error");
		        		}
		        	}
		        }); 
		    } 
	
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
		        			//alert(result);
		        		}
		        	}
		        });
		    } 
	
		</script>
		<style type="text/css">
			.addSlider {display:inline-block;}
			.addSlider div img {cursor:pointer;}
			.sliderCDT .sliderSwitch {margin:5px 0px 0px 0px;}
			.sliderModifyBody .slider-imagePage img {width:280px;height:450px;opacity:0.4;}
			#addSliderBody div.sliderModifyBody {cursor:default;}
			#addSliderBody div.sliderModifyBody .slider-header-modify {cursor:default;}
		</style>
	</head>
	<body class = "mainbody">
		<h1><spring:message code = 'ezPersonal.t20004' /></h1>
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;<spring:message code = 'ezPersonal.t20009' /></span><br />
	    <span class="txt" style="line-height:19px">&nbsp;*&nbsp;<spring:message code = 'ezPersonal.mse5' /></span><br />
		</span>
	    <ul id="sliderContainer" class="ui-sortable" style="margin-top: 25px;">
	    
	    </ul>
	   
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	     <form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm" style="width:1px;height:1px">
	        <input type="file" name="file1" id="file1" onchange="btn_attach()" style="display: none;" multiple="false" accept="image/*" />
	        <input type="hidden" name="boardid" id="boardid" />
	        <input type="hidden" name="maxsize" id="maxsize" />
	        <input type="hidden" name="mode" id="mode" value="SLIDERIMAGE"/>
	        <input type="hidden" name="cnt" id="cnt" />
	        <input type="hidden" name="mailgubun" id="mailgubun" />
	    </form>		
	</body>
</html>