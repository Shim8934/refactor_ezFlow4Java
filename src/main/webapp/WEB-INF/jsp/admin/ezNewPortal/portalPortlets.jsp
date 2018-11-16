<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>portalPortlets</title>
	<link rel="stylesheet"  href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css">
	<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/default.css')}" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/component.css')}" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
	<style type="text/css">
	body {min-width: 520px;background-color:white;}
	.ui-widget-header .ui-icon {background-image : url(/js/jquery-ui/images/ui-icons_444444_256x240.png);}
	.ui-widget-content {background : none;}
	.ui-widget-header {background : none;}
  	.column {width: 1820px; padding-bottom: 100px;}
  	.portlet, .newPortlet {margin:0px 15px 15px 0px;display:inline-block; border-radius:0px; vertical-align : top; background-color : #ffffff; box-sizing:border-box; border:none; box-shadow:0px 1px 5px 0px rgba(0, 0, 0, 0.20);position:relative;}
  	.portlet-header {padding:0px 0px 0px 15px;margin:0px;position: relative;cursor:move; border:none; font-size:14px; font-weight:bold; height:40px; line-height:38px; border-radius:0px; color:#393939; border:1px solid #2196f3;}
  	.portlet-toggle {top: 50%;right: 0;float:right;}
  	.portlet-content {padding:5px 15px 10px 15px;clear:both; box-sizing:border-box; border-radius:0px; border:1px solid #dfe2e4; margin:-1px 0px 0px 0px; height:215px;}
  	.portlet-placeholder {border: 1px dotted black; margin: 0 1em 1em 0; height: 50px;}
	.col, .newPortlet {padding:0px;}
	.addPortlet:hover {cursor:pointer;}
	.updatePortlet, .addNewPortlet {float :right;margin :0px; padding :0px;}
	.updatePortletBtn span{height:25px; float:right; background: #2196f3; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
	.deletePortletBtn span{height:25px; float:right; background: #2196f3; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}	
	.boardSetting, .menuSetting {float:right; position:relative; margin-top:-20px; margin-right:5px; padding:0px;text-align:left;display:inline-block;vertical-align:top;cursor:pointer;}
	.portletInfo {display:inline-block;marging-top:8px;}
	.portletInfoTH {background-color :white;border:0px; padding:0px 15px 0px 0px; color:#393939; font-weight:bold; letter-spacing:-1px; line-height:34px;}
	.portletInfoTH, .portletInfoTD {}
	.boardNotUsed {height:2.6em;}
	.portletInfo {width : 100%;}
	.portletInfoTD {width:100%;}
	.portletInfoTD input[type='text'] {width:100%; height:27px; font-size:12px; padding:0px 0px 0px 5px; color:#393939;}
	.addPortlet {border:1px dashed #aab2ba; text-align:center;height:19.3em; border-radius:0px;}
	.addPortlet dl {margin:87px;}
	.portlet-toggle {cursor:pointer;}
	.newPortlet .portlet-header {cursor:default;}
	.notUsedTR {display : none;}
	.usedTR {display:table-row;}
	.cancelNewPortletBtn span{height:25px; float:right; background: #2196f3; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
	.addNewPortletBtn span{height:25px; float:right; background: #2196f3; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
	span.spanOff{ background:#959595;}
	span.addCancel{ background:#6c6c6c;}
	/* switch */
	.switch {position: absolute;display: inline-block;width: 60px;height: 22px;margin-top:-10px;}
	.switch input {opacity: 0;width: 0;height: 0;}
	.slider {  position: absolute;  cursor: pointer;  top: 0;  left: 0;  right: 0;  bottom: 0;  background-color: #ccc;  -webkit-transition: .4s;  transition: .4s;}
	.slider:before {  position: absolute;  content: "";  height: 13px;  width: 13px;  left: 8px;  bottom: 5px;  background-color: white;  -webkit-transition: .4s;  transition: .4s;}
	input:checked + .slider {  background-color: #2196F3;}
	input:focus + .slider { box-shadow: 0 0 1px #2196F3;}
	input:checked + .slider:before {-webkit-transform: translateX(26px); -ms-transform: translateX(26px);transform: translateX(26px);}
	.toastArea { padding : 10px; position : absolute; background : rgba(0, 0, 0, 0.33); display : block; color : #ffffff; font-size: 12px; border-radius: 3px;}
	/* Rounded sliders */
	.slider.round {border-radius: 15px;}
	.slider.round:before {border-radius: 50%;}	
	
	/* portlet media query */
	@media only screen and (min-width :1921px) {
		.portlet, .newPortlet{ width:483px;}
	}

	@media only screen and (max-width :1920px) and (min-width :1423px) {
		.portlet, .newPortlet{ width:20%;}
	}

	@media only screen and (max-width :1422px) and (min-width :1280px) {
		.portlet, .newPortlet{width:48%;}
	}

	@media only screen and (max-width : 1279px) {
		.portlet, .newPortlet {width:460px;}
	}
	.slideImageSetting {
		position: absolute;
	    right: 20px;
	    top: 55px;
        cursor: pointer;
        display: inline-block;
	}
	</style>
	<script type="text/javascript">	
	
	var lang = "${lang}";
	var arrayLang = Number(lang) - 1;
	
	$( function() {
		$("#ListCompany").on("change", getPortletList);
		getPortletList();	
		//이벤트 세팅
		$("#portletOrderReset").on("click", portletOrderReset);
	});
	
	
	
	//포틀릿 추가
	var portletAdd = function() {
		var companiesObj = document.getElementById("ListCompany");
		var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
		
		//포틀릿 사용 여부
		var isUsed = document.getElementById("newPortlet").querySelectorAll(".switch")[0].querySelectorAll("input")[0].checked;
		
		//포틀릿 이름 리스트
		var portletNameList = document.getElementById("newPortlet").querySelectorAll(".portletName");
		var portletNameListCount = portletNameList.length;
		var nameList = [];
		var portletNameEmptyNum = 0;
		
		for (var i = 0; i < portletNameListCount; i++) {
			
			if (portletNameList[i].value == "") {
				portletNameEmptyNum++;
			}
			
			nameList.push({"portletName" : portletNameList[i].value, "portletLang" : portletNameList[i].getAttribute("data1")});
		}
		
		if (portletNameEmptyNum >= portletNameListCount) {
			alert("하나 이상의 포틀릿 이름을 입력해주세요.");
			return;
		}
			
		//게시판 설정(게시판 아이디)
		var boardName = document.getElementById("newPortletBoard");
		var boardId = null;
		
		if (boardName != undefined) {
			boardId = boardName.getAttribute("data1");
		}
			
		//새로운 포틀릿인 경우 connection url
		var connectionUrl = document.getElementById("newPortlet").querySelector(".connectionUrl").value;
		
		
		//새로운 포틀릿인 경우 관련 메뉴 지정
		var portletMenuId = document.getElementById("newPortlet").querySelector("#newPortletMenu").getAttribute("data2");

		if (connectionUrl == "" && portletMenuId != 4) {
			alert("연결 URL을 입력해주세요.");
			return;
		}
		
		if (connectionUrl.indexOf("#_self") != -1 && portletMenuId != 4) {
			alert("#이나 _self 등은 입력할 수 없습니다.");
			return;
		}
		
		if (portletMenuId == null) {
			alert("추가할 포틀릿과 관련된 메뉴를 설정해주세요.");
			return;
		}
		
		if (portletMenuId == 4 && boardId == null && portletId != 10) {
			alert("게시판을 선택해 주세요.");
			return;
		}
		
		var request = new XMLHttpRequest();
		request.open('POST', '/admin/ezNewPortal/addPortlet.do', true);
		request.setRequestHeader('content-type', 'application/json');
		
		request.onload = function() { 
			getPortletList(); 
		};
		
		request.onerror = function() {}
		
		var data = JSON.stringify({
			companyId : companyValue,
			nameList : nameList,
			boardId : boardId,
			portletUsed : isUsed,
			connectionUrl : connectionUrl,
			menuId : portletMenuId
		});
		 
		request.send(data);
	}
	  
	var portletDelete = function(event) {
		var response = confirm("포틀릿을 삭제하시겠습니까?");
		
		if (!response) {
			return;
		}
		
		var companiesObj = document.getElementById("ListCompany");
		var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
		var portletId = event.data.portletId;
		var menuId = event.data.menuId;
		
		var request = new XMLHttpRequest();
		request.open('POST', '/admin/ezNewPortal/deletePortlet.do', true);
		request.setRequestHeader('content-type', 'application/json');
		
		request.onload = function() { 
			getPortletList(); 
		};
		
		request.onerror = function() {}
		
		var data = JSON.stringify({
			companyId : companyValue,
			portletId : portletId,
			menuId : menuId
		});
		 
		request.send(data);
	}
	
	//순서변경
	var updatePortletOrder = function () {
		var companiesObj = document.getElementById("ListCompany");
		var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
		
		//포틀릿 순서가져오기
		var portletList = $(".col");
		var portletListCount = portletList.length;
		var portletOrderList = [];
		
		for (var i = 0; i < portletListCount; i++) {
			var order = i + 1;
			var portletId = portletList[i].id;
			portletId = portletId.substring(7);
			
			portletOrderList.push({"portletOrder" : order, "portletId" : portletId});
		}
		
 		var request = new XMLHttpRequest();
		
		request.open('POST', '/admin/ezNewPortal/updatePortletOrder.do', true);
		request.setRequestHeader('content-type', 'application/json');
		
		request.onload = function() {};
		
		request.onerror = function() {}
		
		var data = JSON.stringify({
			companyId : companyValue,
			portlets : portletOrderList
		});
		 
		request.send(data);
	}
	
	//순서초기화
	var portletOrderReset = function() {
 		var companiesObj = document.getElementById("ListCompany");
		var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
		
		//포틀릿 순서가져오기
		var portletList = document.getElementsByClassName("col");
		var portletListCount = portletList.length;
		var portletOrderList = [];
		
		for (var i = 0; i < portletListCount; i++) {
			var order = portletList[i].getAttribute("data1");
			var portletId = portletList[i].id;
			portletId = portletId.substring(7);
			
			portletOrderList.push({"portletOrder" : order, "portletId" : portletId});
		}
		
		var request = new XMLHttpRequest();
		
		request.open('POST', '/admin/ezNewPortal/updatePortletOrder.do', true);
		request.setRequestHeader('content-type', 'application/json');
		
		request.onload = function() { 
			getPortletList(); 
		};
		
		request.onerror = function() {}
		
		var data = JSON.stringify({
			companyId : companyValue,
			portlets : portletOrderList
		});
		 
		request.send(data);
	}

	//게시판 설정 
	var openBoardTree = function(event) {
		var portletId = event.data.portletId;
 		var companiesObj = document.getElementById("ListCompany");
		var companyId = companiesObj.options[companiesObj.selectedIndex].value;
		
        var wWeight = "355";
        var wHeight = "600";

        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = (width - wWeight) / 2;
        var top = (heigth - wHeight) / 2;
        
        window.open("/admin/ezNewPortal/openBoardTree.do?portletId=" + portletId + "&companyId=" + companyId, "",
            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
	}
	  
	var portletUpdate = function(event) {
		var companiesObj = document.getElementById("ListCompany");
		var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
		
		//포틀릿 아이디
		var portletId = event.data.portletId;
		
		//포틀릿 사용 여부
		var isUsed = document.getElementById("portlet" + portletId).querySelectorAll(".switch")[0].querySelectorAll("input")[0].checked;
		
		//포틀릿 이름 리스트
		var portletNameList = document.getElementById("portlet" + portletId).querySelectorAll(".portletName");
		var portletNameListCount = portletNameList.length;
		var nameList = [];
		var portletNameEmptyNum = 0;
		
		for (var i = 0; i < portletNameListCount; i++) {

			if (portletNameList[i].value == "") {
				portletNameEmptyNum++;
			}
			
			nameList.push({"portletId" : portletId, "portletName" : portletNameList[i].value, "portletLang" : portletNameList[i].getAttribute("data1")});
		}
		
		//게시판 설정(게시판 아이디)
		var boardName = document.getElementById("portletBoard" + portletId);
		var boardId = null;
		
		if (boardName != null) {
			boardId = boardName.getAttribute("data1");
		}
		
		//새로운 포틀릿인 경우에는 메뉴 아이디
		//var portletMenuId = document.getElementById("portlet" + portletId);
		var menuId = document.getElementById("portlet" + portletId).getAttribute("data2");
		
		// 즐겨찾기 포틀릿 응급처치만 해놓음
		var favoriteBoardUrl = document.getElementById("portlet" + portletId).dataset.url; 
		
		if ((menuId == 4 && favoriteBoardUrl != '/ezNewPortal/favoriteBoardPortlet.do' ) && boardId == null) {
			alert("게시판을 선택해 주세요.");
			return;
		}

		
		//새로운 포틀릿인 경우 ...connection url
		var url = document.getElementById("portlet" + portletId).querySelector(".connectionUrl");
		var connectionUrl = null;
		
		if (url != null) {
			connectionUrl = url.value;
		}
		
		var request = new XMLHttpRequest();
		request.open('POST', '/admin/ezNewPortal/updatePortlet.do', true);
		request.setRequestHeader('content-type', 'application/json');
		
		request.onload = function() { 
			showToastMessage(portletId);
		};
		
		request.onerror = function() {}
		
		var data = JSON.stringify({
			portletId : portletId,
			companyId : companyValue,
			nameList : nameList,
			boardId : boardId,
			portletUsed : isUsed,
			connectionUrl : connectionUrl,
			menuId : menuId
		});
		 
		request.send(data);
	}
	  
	//포틀릿 리스트 불러오는 함수
	var getPortletList = function() {
		var companiesObj = document.getElementById("ListCompany");
		var companyId = companiesObj.options[companiesObj.selectedIndex].value;
		
		var request = new XMLHttpRequest();
		request.open('POST', '/admin/ezNewPortal/getPortlets.do', true);
		request.setRequestHeader('content-type', 'application/json');
		
		request.onload = function() { 
			if (request.status >= 200 && request.status < 400) {
				var result = JSON.parse(request.responseText);
				var portletId = "";
				var portletOrder = "";
				var portletName = "";
				var portletType = "";
				var menuId = "";
				var portletURL = "";
				var portletNameList;
				var listHTML = "";
				var portletCnt = result.length;
				
				for (var i = 0; i < portletCnt; i++) {
					portletId = result[i].portletId;
					defaultOrder = result[i].defaultOrder;
					portletName = result[i].portletName;
					portletType = result[i].portletType;
					portletURL = result[i].connectionUrl;
					portletNameList = result[i].portletNameList;
					menuId = result[i].menuId;
					portletNameListCnt = portletNameList.length;
					
					listHTML += "<li class='portlet col' id='portlet" + portletId + "' data1='" + defaultOrder + "' data2='" + menuId + "' data-url='" + result[i].portletUrl + "'>";
					listHTML += "<div class='portlet-header'>" + portletNameList[arrayLang].portletName;
					
					if (!result[i].general) {
						listHTML += "<a class='deletePortletBtn'>";
						listHTML += "<span>삭제</span></a>"
					}
					
					listHTML += "<a class='updatePortletBtn'>";
					listHTML += "<span>저장</span></a>";
					listHTML += "</div>";
					listHTML += "<div class='portlet-content'>";
					listHTML += "<table class='portletInfo'><tr><th class='portletInfoTH'>포틀릿 사용  : </th>";
					if (portletId == 34) { //슬라이드 이미지 포틀릿의 경우
						listHTML += "<td class='portletInfoTD'><label class='switch'><input type='checkbox'><span class='slider round'></span></label>";
						listHTML += "<div class='slideImageSetting'><a><img src='/images/admin/admin_portlet_set.png'></a></div></td>";
					} else {
						listHTML += "<td class='portletInfoTD'><label class='switch'><input type='checkbox'><span class='slider round'></span></label></td>";
					}
					listHTML += "</tr>";
					
					for (var j = 0; j < portletNameListCnt; j++) {
						var language = "";
						
						//언어
						if (portletNameList[j].portletLang == 1) {
							language = "한국어";
						} else if (portletNameList[j].portletLang == 2) {
							language = "영어";
						} else if (portletNameList[j].portletLang == 3) {
							language = "일본어";
						}
						
						listHTML += "<tr><th class='portletInfoTH'>포틀릿명(" + language + ") :</th><td class='portletInfoTD'><input class='portletName' data1='" + portletNameList[j].portletLang + "' type='text' value='" + portletNameList[j].portletName + "' maxlength='50'></td></tr>"
					 }
					
					if (!result[i].general) {						
						listHTML += "<tr><th class='portletInfoTH'>관련 메뉴 : </th><td class='portletInfoTD'>";
						
						var menuName = result[i].menuName;
						
						if (menuName == null || menuName == "null") {
							menuName = "관련 메뉴 없음";
						}

						listHTML += "<input id='portletMenu" + portletId + "' type='text' value='" + menuName + "'readonly>";
						listHTML += "<div class='btnpositionJsp menuSetting'>";
						listHTML += "<a class='menuSettingtBtn'>";
						listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div>";
						listHTML += "</td></tr>";
						console.log(portletURL);
						if (menuId != 4) {
							listHTML += "<tr class='connectionTR'><th class='portletInfoTH'>연결 URL :</th><td class='portletInfoTD'><input type='text' class='connectionUrl' value='"+ portletURL +"' maxlength='100'></td></tr>";
						} else {
							if (!result[i].general) {
								listHTML += "<tr class='connectionTR notUsedTR'><th class='portletInfoTH'>연결 URL :</th><td class='portletInfoTD'><input type='text' class='connectionUrl' value='"+ portletURL +"' maxlength='100'></td></tr>";
							} else {
								listHTML += "<tr class='connectionTR notUsedTR'><th class='portletInfoTH'>연결 URL :</th><td class='portletInfoTD'><input type='text' class='connectionUrl' value='' maxlength='100'></td></tr>";
							}	
						}
						
					}
					
					if (menuId == 4 && portletId != 10) {
						listHTML += "<tr class='boardTR'><th class='portletInfoTH'>게시판 설정 :</th><td class='portletInfoTD'>";
						listHTML += "<input id='portletBoard" + portletId + "' class='boardName' type='text' value='" + ReplaceText(ReplaceText(result[i].boardName1, '\"', "&#39;"), "\'", "&#34;") + "' data1='" + result[i].portletBoardId + "' readonly>";
						listHTML += "<div class='boardSetting'>";
						listHTML += "<a class='boardSettingtBtn'>";
						listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";
					} else if (result[i].general && (menuId != 4 || portletId == 10)){
						listHTML += "<tr class='boardNotUsed'><th class='portletInfoTH'>&nbsp;</th><td class='portletInfoTD'>&nbsp;<br/></td></tr>";
					} else if (!result[i].general) {
						listHTML += "<tr class='boardTR notUsedTR'><th class='portletInfoTH'>게시판 설정 :</th><td class='portletInfoTD'>";
						listHTML += "<input id='portletBoard" + portletId + "' type='text' readonly>";
						listHTML += "<div class='boardSetting'>";
						listHTML += "<a class='boardSettingtBtn'>";
						listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";
					}
					
					listHTML += "</table>";
					listHTML += "</li>";
				}
				
				listHTML += "<li class='portlet addPortlet'><div style='margin-top:97px'><img src='/images/admin/admin_portlet_plus.png' /></div></li>";
				document.getElementById("portletListContainer").innerHTML = listHTML;
				
				for (var i = 0; i < portletCnt; i++) { //포틀릿 사용여부에 따라 title 변경
					if (result[i].portletUsed) {
						//$("#portlet" + result[i].portletId).find(".portlet-header").css("background-color", "#687077");
						$("#portlet" + result[i].portletId).find(".portlet-header").css("background-color", "##edf7ff");
						$("#portlet" + result[i].portletId).find(".switch").find("input").prop("checked", true);
						$("#portlet" + result[i].portletId + " .updatePortletBtn span").attr("class", "spanOn");
						$("#portlet" + result[i].portletId + " .deletePortletBtn span").attr("class", "spanOn");
					} else {
						$("#portlet" + result[i].portletId).find(".portlet-header").css("background-color", "#f4f4f4").css("border", "1px solid #e7e7e7").css("color", "#b1b1b1");
						$("#portlet" + result[i].portletId).find(".switch").find("input").prop("checked", false);
						$("#portlet" + result[i].portletId + " .updatePortletBtn span").attr("class", "spanOff");
						$("#portlet" + result[i].portletId + " .deletePortletBtn span").attr("class", "spanOff");
					}
					
					//포틀릿 게시판 설정이 있으면 설정 버튼 활성화
					if ((result[i].menuId == 4 && result[i].portletId != 10) || !result[i].isGeneral) {
						$("#portlet" + result[i].portletId).find(".boardSetting").on("click", {"portletId" : result[i].portletId}, openBoardTree);
					}
					
					$("#portlet" + result[i].portletId).find(".updatePortletBtn").on("click", {"portletId" : result[i].portletId}, portletUpdate);
					
					if (!result[i].general) {
						$("#portletMenu" + result[i].portletId).parent().find(".menuSetting").on("click", {"portletId" : result[i].portletId}, openMenuList);
						$("#portlet" + result[i].portletId).find(".deletePortletBtn").on("click", {"portletId" : result[i].portletId, "menuId" : result[i].menuId}, portletDelete);
						
					}
					
					//슬라이드 이미지 버튼 활성화
					if (result[i].portletId == 34) {
						$("#portlet" + result[i].portletId).find(".slideImageSetting").on("click", {"portletId" : result[i].portletId}, openSlideImageSetting);
					}
				}
				
				loadAfter();
			}
		};
		
		request.onerror = function() {}
		
		var data = JSON.stringify({
			companyId : companyId
		});
		 
		request.send(data);
	}
	  
	function loadAfter() { //데이터 로드 다 된 후
		$( ".col-container" ).sortable({ //drag and drop 
			items : "li.col",
		    handle: ".portlet-header",
		    cancel: ".portlet-toggle",
		    update : function(event, ui) {
		    	updatePortletOrder();
		    }
		});
		
		$( ".portlet" )
			.addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
			.find( ".portlet-header" )
			.addClass( "ui-widget-header ui-corner-all" )
			//.prepend( "<span class='ui-icon ui-icon-minusthick portlet-toggle'></span>");
		 
		/* $( ".portlet-toggle" ).on( "click", function() {
			var icon = $( this );
			icon.toggleClass( "ui-icon-minusthick ui-icon-plusthick" );
			icon.closest( ".portlet" ).find( ".portlet-content" ).toggle();
			
		}); */
		
		$(".addPortlet").on("click", showAddPortletForm); //click event
	}
 
	var showAddPortletForm = function() {
		$(".addPortlet").remove();
		
		var listHTML = "";
		listHTML += "<li id='newPortlet' class='newPortlet'>";
		listHTML += "<div class='portlet-header' style='background-color:#f4f4f4;border:1px solid #e7e7e7;color:#b1b1b1'>포틀릿 추가";
		listHTML += "<a class='cancelNewPortletBtn'>";
		listHTML += "<span class='addCancel'>취소</span></a>";
		listHTML += "<a class='addNewPortletBtn'>";
		listHTML += "<span class='addCancel'>추가</span></a>";
		listHTML += "</div>";
		listHTML += "<div class='portlet-content'>";
		listHTML += "<table class='portletInfo'><tr><th class='portletInfoTH'>포틀릿 사용 </th>"
		listHTML += "<td class='portletInfoTD'><label class='switch'><input type='checkbox'><span class='slider round'></span></label></td>";
		listHTML += "</tr>";
		
		//언어
		listHTML += "<tr><th class='portletInfoTH'>포틀릿명(한국어) </th><td class='portletInfoTD'><input class='portletName' data1='1' type='text' maxlength='50'></td></tr>";
		listHTML += "<tr><th class='portletInfoTH'>포틀릿명(영어) </th><td class='portletInfoTD'><input class='portletName' data1='2' type='text' maxlength='50'></td></tr>";
		listHTML += "<tr><th class='portletInfoTH'>포틀릿명(일본어) </th><td class='portletInfoTD'><input class='portletName' data1='3' type='text' maxlength='50'></td></tr>";
		listHTML += "<tr><th class='portletInfoTH'>관련 메뉴 </th><td class='portletInfoTD'>";
		listHTML += "<input id='newPortletMenu' type='text' readonly>";
		listHTML += "<div class='btnpositionJsp menuSetting'>";
		listHTML += "<a class='menuSettingtBtn'>";
		listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div>";
		listHTML += "</td></tr>";
		listHTML += "<tr class='connectionTR'><th class='portletInfoTH'>연결 URL </th><td class='portletInfoTD'><input class='connectionUrl' type='text' maxlength='100'></td></tr>";
		listHTML += "<tr class='notUsedTR'><th class='portletInfoTH'>게시판 설정 </th><td class='portletInfoTD'>";
		listHTML += "<input id='newPortletBoard' type='text' readonly>";
		listHTML += "<div class='btnpositionJsp boardSetting'>";
		listHTML += "<a class='boardSettingtBtn'>";
		listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";
		listHTML += "</table>";
		listHTML += "</li>";
		
		document.getElementById("portletListContainer").insertAdjacentHTML('beforeend', listHTML);
		
		//jquery ui - sortable(드래그앤드랍)
		$(".col-container").sortable("destroy");

		$( ".col-container" ).sortable({
			items : "li.col",
		    handle: ".portlet-header",
		    cancel: ".portlet-toggle"
		});
		
		$( ".newPortlet")
		.addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
		.find( ".portlet-header" )
		.addClass( "ui-widget-header ui-corner-all" );
		//jquery ui - 끝
		
		/* var categoryList = document.querySelectorAll("input[name='category']");
		
		[].forEach.call(categoryList, function(category) {
			category.addEventListener("click", function(){
				if (this.value == "B" && this.checked) {
					document.getElementById("newPortlet").querySelector(".setBoard").style.display = "table-row";
				} else {
					document.getElementById("newPortlet").querySelector(".setBoard").style.display = "none";
				}
			});
		}); */
		
		$("#newPortlet").find(".menuSetting").on("click", {"portletId" : null}, openMenuList);
		
		$(".addNewPortletBtn").on("click", {"portletId" : null}, portletAdd);
		$(".cancelNewPortletBtn").on("click", cancelPortlet);
		$(".newPortlet").find(".boardSetting").on("click", {"portletId" : null}, openBoardTree);
	}
	
	var cancelPortlet = function() {
		getPortletList();
	}
	
	var openMenuList = function (event) {
		var portletId = event.data.portletId;
 		var companiesObj = document.getElementById("ListCompany");
		var companyId = companiesObj.options[companiesObj.selectedIndex].value;
        var wWeight = "639";
        var wHeight = "445";

        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = (width - wWeight) / 2;
        var top = (heigth - wHeight) / 2;
        
        window.open("/admin/ezNewPortal/openPortalMenu.do?portletId=" + portletId + "&companyId=" + companyId, "",
            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
	}
	
	var showToastMessage = function (portletId) {
		var doc = window.document;
		var alertMessage = "저장되었습니다.";
		var toastArea = doc.createElement("div");
		
		toastArea.innerHTML = alertMessage;
		toastArea.setAttribute("class", "toastArea");
		toastArea.style.top = "115px";
		toastArea.style.left = "115px";
		toastArea.style.display = "block";
		toastArea.id = "toast" + portletId;
		
		$("#portlet" + portletId).prepend(toastArea);
		
		setTimeout(function() {
			$("#toast" + portletId).fadeOut(1000, function() {
				getPortletList(); 
				
				var parent = doc.getElementById("portlet" + portletId);
				parent.removeChild(toastArea);
			});
		}, 1000);
	}
	
	var openSlideImageSetting = function(event) {
		var portletId = event.data.portletId;
 		var companiesObj = document.getElementById("ListCompany");
		var companyId = companiesObj.options[companiesObj.selectedIndex].value;
		
        var wWeight = "902";
        var wHeight = "734";

        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = (width - wWeight) / 2;
        var top = (heigth - wHeight) / 2;
        
        window.open("/admin/ezNewPortal/openSlideImageSetting.do?portletId=" + portletId + "&companyId=" + companyId, "",
            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
	}
	</script>
</head>
	
<body class="mainbody" marginwidth="0" marginheight="0">
	<h1>
		포틀릿 관리
		<select class="companySelect" id="ListCompany">
        	<c:forEach var="item" items="${companyList}">
           		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
           	</c:forEach>
	    </select>
	</h1>
	<div id="mainmenu">
		<ul style="margin-top: 15px;">
			<li id="portletOrderReset"><span>포틀릿 순서 초기화</span></li>
		</ul>
	</div>
		
	<ul id="portletListContainer" class="col-container">
			
	</ul>
</body>
	
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
</html>