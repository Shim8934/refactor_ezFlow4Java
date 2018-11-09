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
  	.portlet, .newPortlet {float:none; position: relative;margin: 0 1em 1em 0;padding: 0.3em;display : inline-block;vertical-align : top; background-color : #ffffff;}
  	.portlet-header {padding: 0.4em 0.7em;margin-bottom: 0.5em;position: relative;cursor:move;}
  	.portlet-toggle {top: 50%;right: 0;float:right;}
  	.portlet-content {padding: 0.4em;clear:both;}
  	.portlet-placeholder {border: 1px dotted black; margin: 0 1em 1em 0; height: 50px;}
	.col, .newPortlet {padding: 16px 16px 5px 16px;}
	.addPortlet:hover {cursor:pointer;}
	.updatePortlet, .addNewPortlet, .cancelNewPortlet {float : right;margin : 0px; padding : 0px;}
	.deletePortletBtn, .cancelNewPortletBtn {margin-left:7px;}
	.boardSetting, .menuSetting {margin:0px 0px 0px 12px;padding:0px;text-align:left;display:inline-block;vertical-align:top;}
	.portletInfo {display:inline-block;marging-top:8px;}
	.portletInfoTH {background-color : white;border:0px; padding-left:0px;}
	.portletInfoTH, .portletInfoTD {padding-bottom : 5px;}
	.boardNotUsed {height:2.6em;}
	.portletInfo {width : 100%;}
	.portletInfoTD {width:100%;}
	.portletInfoTD input[type='text'] {width:79%;}
	.addPortlet {border:2px dashed black; text-align:center;height:18.3em;}
	.addPortlet dl {margin:87px;}
	.portlet-toggle {cursor:pointer;}
	.newPortlet .portlet-header {cursor:default;}
	.setBoard {display : none;}
	/* switch */
	.switch {position: absolute;display: inline-block;width: 60px;height: 25px;margin-top:-13px;}
	.switch input {opacity: 0;width: 0;height: 0;}
	.slider {  position: absolute;  cursor: pointer;  top: 0;  left: 0;  right: 0;  bottom: 0;  background-color: #ccc;  -webkit-transition: .4s;  transition: .4s;}
	.slider:before {  position: absolute;  content: "";  height: 17px;  width: 18px;  left: 4px;  bottom: 4px;  background-color: white;  -webkit-transition: .4s;  transition: .4s;}
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
		.portlet, .newPortlet{ width:32%;}
	}

	@media only screen and (max-width :1422px) and (min-width :1280px) {
		.portlet, .newPortlet{width:48%;}
	}

	@media only screen and (max-width : 1279px) {
		.portlet, .newPortlet {width:460px;}
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
		
		if (connectionUrl == "") {
			alert("연결 URL을 입력해주세요.");
			return;
		}
		
		//새로운 포틀릿인 경우 관련 메뉴 지정
		var portletMenuId = document.getElementById("newPortlet").querySelector("#newPortletMenu").getAttribute("data1");
		
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
		console.log(portletOrderList);
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
		
		for (var i = 0; i < portletNameListCount; i++) {
			nameList.push({"portletId" : portletId, "portletName" : portletNameList[i].value, "portletLang" : portletNameList[i].getAttribute("data1")});
		}
		
		//게시판 설정(게시판 아이디)
		var boardName = document.getElementById("portletBoard" + portletId);
		var boardId = null;
		
		if (boardName != null) {
			boardId = boardName.getAttribute("data1");
		}
		
		//새로운 포틀릿인 경우 ...connection url
		var url = document.getElementById("portlet" + portletId).querySelector(".connectionUrl");
		var connectionUrl = null;
		
		if (url != null) {
			connectionUrl = url.value;
		}
		
		//새로운 포틀릿인 경우에는 메뉴 아이디
		var portletMenuId = document.getElementById("portlet" + portletId).querySelector("#newPortletMenu");
		var menuId = null;
		
		if (portletMenuId != null) {
			menuId = portletMenuId.getAttribute("data1")
		} else {
			menuId = document.getElementById("portlet" + portletId).getAttribute("data2");
		}
		
		// 즐겨찾기 포틀릿 응급처치만 해놓음
		var favoriteBoardUrl = document.getElementById("portlet" + portletId).dataset.url; 
		
		if ((menuId == 4 && favoriteBoardUrl != '/ezNewPortal/favoriteBoardPortlet.do' ) && boardId == null) {
			alert("게시판을 선택해 주세요.");
			return;
		}
		
		var request = new XMLHttpRequest();
		request.open('POST', '/admin/ezNewPortal/updatePortlet.do', true);
		request.setRequestHeader('content-type', 'application/json');
		
		request.onload = function() { 
			showToastMessage(portletId);
			getPortletList(); 
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
					listHTML += "<div class='portlet-header'>" + portletNameList[arrayLang].portletName + "</div>";
					listHTML += "<div class='portlet-content'>";
					listHTML += "<div class='btnpositionJsp updatePortlet'>";
					listHTML += "<a class='imgbtn updatePortletBtn'>";
					listHTML += "<span>저장</span></a>";
					
					if (!result[i].general) {
						listHTML += "<a class='imgbtn deletePortletBtn'>";
						listHTML += "<span>삭제</span></a>"
					}
					
					listHTML += "</div>";
					listHTML += "<table class='portletInfo'><tr><th class='portletInfoTH'>포틀릿 사용  : </th>"
					listHTML += "<td class='portletInfoTD'><label class='switch'><input type='checkbox'><span class='slider round'></span></label></td>";
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
						listHTML += "<tr><th class='portletInfoTH'>연결 URL :</th><td class='portletInfoTD'><input type='text' class='connectionUrl' value='"+ portletURL +"' maxlength='100'></td></tr>";
						listHTML += "<tr><th class='portletInfoTH'>관련 메뉴 : </th><td class='portletInfoTD'>";
						
						var menuName = result[i].menuName;
						
						if (menuName == null || menuName == "null") {
							menuName = "관련 메뉴 없음";
						}
						
						listHTML += "<input id='portletMenu" + portletId + "' type='text' value='" + menuName + "'readonly>";
						listHTML += "<div class='btnpositionJsp menuSetting'>";
						listHTML += "<a class='imgbtn menuSettingtBtn'>";
						listHTML += "<span>선택</span></a></div>";
						listHTML += "</td></tr>";
					}
					
					if (menuId == 4 && portletId != 10) {
						listHTML += "<tr class='boardTR'><th class='portletInfoTH'>게시판 설정 :</th><td class='portletInfoTD'>";
						listHTML += "<input id='portletBoard" + portletId + "' class='boardName' type='text' value='" + result[i].boardName1 + "' data1='" + result[i].portletBoardId + "' readonly>";
						listHTML += "<div class='btnpositionJsp boardSetting'>";
						listHTML += "<a class='imgbtn boardSettingtBtn'>";
						listHTML += "<span>설정</span></a></div></td></tr>";
					} else {
						listHTML += "<tr class='boardNotUsed'><th class='portletInfoTH'>&nbsp;</th><td class='portletInfoTD'>&nbsp;<br/></td></tr>";
					}
					
					listHTML += "</table>";
					listHTML += "</li>";
				}
				
				listHTML += "<li class='portlet addPortlet'><dl><dt><span class='icon_topmenu' style='background:none; font-size:20px; font-weight:bold'>+</span></dt><dd>메뉴추가</dd></li>";
				document.getElementById("portletListContainer").innerHTML = listHTML;
				
				for (var i = 0; i < portletCnt; i++) { //포틀릿 사용여부에 따라 title 변경
					if (result[i].portletUsed) {
						$("#portlet" + result[i].portletId).find(".portlet-header").css("background-color", "#b0e4ff");
						$("#portlet" + result[i].portletId).find(".switch").find("input").prop("checked", true);
					} else {
						$("#portlet" + result[i].portletId).find(".portlet-header").css("background-color", "#e3e3e3");
						$("#portlet" + result[i].portletId).find(".switch").find("input").prop("checked", false);
					}
					
					//포틀릿 게시판 설정이 있으면 설정 버튼 활성화
					if ((result[i].menuId == 4 && result[i].portletId != 10) || result[i].portletType == "B") {
						$("#portlet" + result[i].portletId).find(".boardSetting").on("click", {"portletId" : result[i].portletId}, openBoardTree);
					}
					
					$("#portlet" + result[i].portletId).find(".updatePortletBtn").on("click", {"portletId" : result[i].portletId}, portletUpdate);
					
					if (!result[i].general) {
						$("#portletMenu" + result[i].portletId).parent().find(".menuSetting").on("click", {"portletId" : result[i].portletId}, openMenuList);
						$("#portlet" + result[i].portletId).find(".deletePortletBtn").on("click", {"portletId" : result[i].portletId, "menuId" : result[i].menuId}, portletDelete);
						
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
	  
	function loadAfter() {
		$( ".col-container" ).sortable({
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
			.prepend( "<span class='ui-icon ui-icon-minusthick portlet-toggle'></span>");
		 
		$( ".portlet-toggle" ).on( "click", function() {
			var icon = $( this );
			icon.toggleClass( "ui-icon-minusthick ui-icon-plusthick" );
			icon.closest( ".portlet" ).find( ".portlet-content" ).toggle();
			
		});
		
		$(".addPortlet").on("click", showAddPortletForm);
	} 
	var showAddPortletForm = function() {
		$(".addPortlet").remove();
		
		var listHTML = "";
		listHTML += "<li id='newPortlet' class='newPortlet'>"	
		listHTML += "<div class='portlet-header'>포틀릿 추가</div>";
		listHTML += "<div class='portlet-content'>";
		listHTML += "<div class='btnpositionJsp addNewPortlet'>";
		listHTML += "<a class='imgbtn addNewPortletBtn'>";
		listHTML += "<span>추가</span></a>";
		listHTML += "<a class='imgbtn cancelNewPortletBtn'>";
		listHTML += "<span>취소</span></a></div>";
		listHTML += "<table class='portletInfo'><tr><th class='portletInfoTH'>포틀릿 사용  : </th>"
		listHTML += "<td class='portletInfoTD'><label class='switch'><input type='checkbox'><span class='slider round'></span></label></td>";
		listHTML += "</tr>";
		
		//언어
		listHTML += "<tr><th class='portletInfoTH'>포틀릿명(한국어) :</th><td class='portletInfoTD'><input class='portletName' data1='1' type='text' maxlength='50'></td></tr>"
		listHTML += "<tr><th class='portletInfoTH'>포틀릿명(영어) :</th><td class='portletInfoTD'><input class='portletName' data1='2' type='text' maxlength='50'></td></tr>"
		listHTML += "<tr><th class='portletInfoTH'>포틀릿명(일본어) :</th><td class='portletInfoTD'><input class='portletName' data1='3' type='text' maxlength='50'></td></tr>"
		listHTML += "<tr><th class='portletInfoTH'>연결 URL :</th><td class='portletInfoTD'><input class='connectionUrl' type='text' maxlength='100'></td></tr>";
		listHTML += "<tr><th class='portletInfoTH'>관련 메뉴 : </th><td class='portletInfoTD'>";
		listHTML += "<input id='newPortletMenu' type='text' readonly>";
		listHTML += "<div class='btnpositionJsp menuSetting'>";
		listHTML += "<a class='imgbtn menuSettingtBtn'>";
		listHTML += "<span>선택</span></a></div>";
		listHTML += "</td></tr>";
		listHTML += "<tr class='setBoard'><th class='portletInfoTH'>게시판 설정 :</th><td class='portletInfoTD'>";
		listHTML += "<input id='newPortletBoard' type='text' readonly>";
		listHTML += "<div class='btnpositionJsp boardSetting'>";
		listHTML += "<a class='imgbtn boardSettingtBtn'>";
		listHTML += "<span>설정</span></a></div></td></tr>";
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
		toastArea.style.left = "185px";
		toastArea.style.display = "block";
		toastArea.id = "toast" + portletId;
		
		$("#portlet" + portletId).prepend(toastArea);
		
		setTimeout(function() {
			$("#toast" + portletId).fadeOut(1000, function() {
				var parent = doc.getElementById("portlet" + portletId);
				parent.removeChild(toastArea);
			})
		}, 500);
	}
	
	</script>
</head>
	
<body class="mainbody" marginwidth="0" marginheight="0">
	<h1>포틀릿 관리</h1>
	<div id="mainmenu">
		<span><b>회사 선택  : </b></span>
		<select id="ListCompany">
        	<c:forEach var="item" items="${companyList}">
           		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
           	</c:forEach>
	    </select>
		<ul style="margin-top: 15px;">
			<li id="portletOrderReset"><span>포틀릿 순서 초기화</span></li>
		</ul>
	</div>
	
	<h1># 드래그 앤 드롭을 하고 순서저장 버튼을 누르면 기본 포틀릿 순서를 지정할 수 있습니다.</h1>
	<br>
	
	<ul id="portletListContainer" class="col-container">
			
	</ul>
</body>
	
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
</html>