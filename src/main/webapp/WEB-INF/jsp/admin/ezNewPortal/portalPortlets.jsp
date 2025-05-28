<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><spring:message code='ezNewPortal.t056' /></title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
	<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/default.css')}" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/component.css')}" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
	<style type="text/css">
	body {min-width: 520px;background-color:white;}
	.mainbody h1 {margin-bottom: 24px;}
	.ui-widget-header .ui-icon {background-image : url(/js/jquery-ui/images/ui-icons_444444_256x240.png);}
	.ui-widget-content {background : none;}
	.ui-widget-header {background : none;}
  	.column {width: 1820px; padding-bottom: 100px;}
  	.portlet, .newPortlet {margin:0px 15px 15px 0px;display:inline-block; border-radius:0px; vertical-align : top; background-color : #ffffff; box-sizing:border-box; border:none; box-shadow:0px 1px 5px 0px rgba(0, 0, 0, 0.20);position:relative;}
  	.portlet-header {padding:0px 0px 0px 15px;margin:0px;position: relative;border:none; font-size:14px; font-weight:bold; height:40px; line-height:38px; border-radius:0px; color:#393939; border:1px solid #2196f3;}
  	.portlet-toggle {top: 50%;right: 0;float:right;}
  	.portlet-content {padding:5px 15px 10px 15px;clear:both; box-sizing:border-box; border-radius:0px; border:1px solid #dfe2e4; margin:-1px 0px 0px 0px; height:250px; overflow:auto;}
  	.portlet-placeholder {border: 1px dotted black; margin: 0 1em 1em 0; height: 50px;}
	.col, .newPortlet {padding:0px;}
	.addPortlet:hover {cursor:pointer;}
	.updatePortlet, .addNewPortlet {float :right;margin :0px; padding :0px;}
	.updatePortletBtn span{height:25px; float:right; background: #2196f3; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
	.deletePortletBtn span{height:25px; float:right; background: #2196f3; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}	
	.boardSetting, .menuSetting, .connectionSetting {float:right; position:relative; margin-top:-18px; margin-right:5px; padding:0px;text-align:left;display:inline-block;vertical-align:top;cursor:pointer;}
	.portletInfo {display:inline-block;marging-top:8px;}
	.portletInfoTH {background-color :white;border:0px; padding:0px 15px 0px 0px; color:#393939; font-weight:bold; letter-spacing:-1px; line-height:34px;}
	.portletInfoTH, .portletInfoTD {}
	.boardNotUsed {height:2.6em;}
	.portletInfo {width : 100%;}
	.portletInfoTD {width:100%; position:relative;}
	.portletInfoTD input[type='text'] {width:100%; height:27px; font-size:12px; padding:0px 0px 0px 5px; color:#393939;}
	.addPortlet {border:1px dashed #aab2ba; text-align:center;height:289.006px; border-radius:0px;}
	.addPortlet dl {margin:87px;}
	.portlet-toggle {cursor:pointer;}
	.newPortlet .portlet-header {cursor:default;}
	.notUsedTR {display : none;}
	.notUsedTR2 {display : none;}
	.usedTR {display:table-row;}
	.cancelNewPortletBtn span{height:25px; float:right; background: #2196f3; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
	.addNewPortletBtn span{height:25px; float:right; background: #2196f3; padding: 0px 9px; line-height: 23px; display: inline-block; margin:7px 7px 0px 0px; color: #fff; box-sizing: border-box; cursor:pointer; border-radius:2px;}
	span.spanOff{ background:#959595;}
	span.addCancel{ background:#6c6c6c;}
	.portlet_header_name {width:60%;display:inline-block;text-overflow:ellipsis;overflow:hidden;white-space:nowrap;}
	/* switch */
	.switch {position: absolute;display: inline-block;width: 53px;height: 22px;margin-top:-10px;}
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
		.portlet, .newPortlet{ width:24%;}
	}

	@media only screen and (max-width :1422px) and (min-width :1280px) {
		.portlet, .newPortlet{width:48%;}
	}

	@media only screen and (max-width : 1279px) {
		.portlet, .newPortlet {width:460px;}
	}
	.slideImageSetting {
		position: absolute;
	    right: 90px;
	    top: 12px;
        cursor: pointer;
        display: inline-block;
	}
	.slideImageSetting img {
		width : 12px;
		height: 12px;
	}
	
	.portletAuthSetting img {
		width : 20px;
		height: 20px;
	}
	
	.portletAuthSetting {
		position: absolute;
	    right: 0px;
	    top: 6px;
        cursor: pointer;
        display: inline-block;
	}

	.cardTR td {
		display: flex;
		padding: 5px 0;
	}

	.cardTR select {
		font-size: 12px;
		font-family: 'Noto Sans KR', sans-serif, 'malgun gothic', 'arial', 'verdana';
		padding: 0px 0px 0px 5px;
		flex: 1;
	}

	.cardTR a {margin-left: 10px;}
	</style>
</head>
	
<body class="mainbody" marginwidth="0" marginheight="0">
	<h1>
		<spring:message code='ezNewPortal.t056' />
		<span class="title_bar"><img src="/images/name_bar.gif"></span>
		<select class="companySelect" id="ListCompany"></select>
		<span> <spring:message code='ezNewPortal.yej14' /></span>
	</h1>
		
	<ul id="portletListContainer" class="col-container" style="overflow: auto"></ul>

	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript">
		var lang = "${lang}";
		var arrayLang = Number(lang) - 1;
		var usePrimaryLangOnly = "";
		var primary = "";
		var useJapanese = "${useJapanese}";
		var useChinese = "${useChinese}";
		var useVietnamese = "${useVietnamese}";
		var useIndonesian = "${useIndonesian}";
		var webType = "${type}";
		const connectMenuId = "${connectMenuId}"; 

		// 일반 게시판 포틀릿의 표출 타입 enum.
		var BoardViewType = Object.freeze({
			DEFAULT : '', CARD_A : 'a', CARD_B : 'b'
		});
		var CLASS_DISPLAY_NONE = 'notUsedTR';

		// 전자결재 포틀릿의 표출 타입 enum.
		var CabinetType = Object.freeze({
			DOING : 'doing',
			REJECT : 'reject',
			DRAFT : 'draft',
			DISPLAY : 'display'
		});

		$(function() {
			getCompanies();
			getPortletList();	
			//이벤트 세팅
			/* $("#portletOrderReset").on("click", portletOrderReset); */
		});
		
		var getCompanies = function() {
			var request = new XMLHttpRequest();
			request.open('GET', '/admin/ezNewPortal/getCompanies.do', false);
			request.setRequestHeader('Content-Type', 'application/json');
			var companiesHTML = "";
	
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					
					var userCompany = result.userCompany;
					var companyList = result.list;
					usePrimaryLangOnly = result.usePrimaryLangOnly;
					primary = result.primary;
					
					companyList.forEach(function (item, index) {
						companiesHTML += "<option value=" + item.cn + ((item.cn == userCompany) ? ' selected>' : '>') + item.displayName + "</option>";
					});
					
					document.getElementById("ListCompany").innerHTML = companiesHTML;
					
					document.getElementById("ListCompany").addEventListener('change', function() {
						getPortletList();	
					});
				} else {
					// We reached our target server, but it returned an error
				}
			};
	
			request.onerror = function() {
			  // There was a connection error of some sort
			};
			
			request.send();
		}
		
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
			
			//특수문자  체크 (앤드&, 소괄호(), 슬래쉬/만 허용함)
			var special_pattern = /[\{\}\[\]?.,;:|*~`!^\-_+<>@\#$%\\\=\'\"]/g;
			const regex = new RegExp(special_pattern);
			
			for (var i = 0; i < portletNameListCount; i++) {
				
				if (regex.test($.trim(portletNameList[i].value))) {
					alert("<spring:message code='ezNewPortal.csj01' />");
				    return;
				}
				
				if ($.trim(portletNameList[i].value) == "") {
					portletNameEmptyNum++;
				}
				
				nameList.push({"portletName" : $.trim(portletNameList[i].value), "portletLang" : portletNameList[i].getAttribute("data1")});
			}
			
			if (portletNameEmptyNum >= portletNameListCount) {
				alert("<spring:message code='ezNewPortal.t091' />");
				return;
			}
				
			//게시판 설정(게시판 아이디)
			var boardName = document.getElementById("newPortletBoard");
			var boardId = null;
			
			if (boardName != undefined) {
				boardId = boardName.getAttribute("data1");
			}
			
			//연계 설정(Config 아이디)
			var connectionName = document.getElementById("newPortletConnection");
			var connectionId = null;
			
			if (connectionName != undefined) {
				connectionId = connectionName.getAttribute("data1");
			}
			
			//새로운 포틀릿인 경우 connection url
			var connectionUrl = document.getElementById("newPortlet").querySelector(".connectionUrl").value;
			connectionUrl = $.trim(connectionUrl);
			
			//새로운 포틀릿인 경우 관련 메뉴 지정
			var portletMenuId = document.getElementById("newPortlet").querySelector("#newPortletMenu").getAttribute("data2");
			
			// 포틀릿 코드
			var portletCode = "";
			if (portletMenuId == connectMenuId) { // 연계포틀릿 추가
				portletCode = "connectPortlet";
			}
			
			if (connectionUrl == "" && portletMenuId != 4) {
				alert("<spring:message code='ezNewPortal.t092' />");
				return;
			}
			
			if (connectionUrl.indexOf("#_self") != -1 && portletMenuId != 4) {
				alert("<spring:message code='ezNewPortal.t093' />");
				return;
			}
			
			if (portletMenuId == null) {
				alert("<spring:message code='ezNewPortal.t094' />");
				return;
			}
			
			if (portletMenuId == 4 && boardId == null) {
				alert("<spring:message code='ezNewPortal.t050' />");
				return;
			}
			
			if (portletMenuId == connectMenuId && (connectionId == null || connectionId == "")) {
				alert("<spring:message code='ezSystem.config.hth29' />");
				return;
			}
			
			if (portletMenuId == 3) {
				console.log(connectionUrl + " / cabinetType: " + document.getElementById("newPortlet").querySelector("#cabinetType").value);
				connectionUrl += ("?cabinetType=" + document.getElementById("newPortlet").querySelector("#cabinetType").value);
			}
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/addPortlet.do?type=' + webType, true);
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
				menuId : portletMenuId,
				portletCode : portletCode,
				connectionId : connectionId
			});
			 
			request.send(data);
		}
		  
		var portletDelete = function(event) {
			var response = confirm("<spring:message code='ezNewPortal.t095' />");
			
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
		
		//게시판 설정 
		var openBoardTree = function(event) {
			var portletId = event.data.portletId;
	 		var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
			var portletCode = "";
			var portletBoardId = "";
			if (portletId != null) {
				portletCode = document.getElementById("portlet" + portletId).getAttribute("data3");
			}
			if (document.getElementById("portletBoard" + portletId) == null) {
				portletBoardId = document.getElementById("newPortletBoard").getAttribute("data1") == null ? "" : document.getElementById("newPortletBoard").getAttribute("data1");
			} else {
				portletBoardId = document.getElementById("portletBoard" + portletId).getAttribute("data1") == "null" ? "" : document.getElementById("portletBoard" + portletId).getAttribute("data1");
			}
			
	        var wWeight = "355";
	        var wHeight = "600";
	
	        var heigth = window.screen.availHeight;
	        var width = window.screen.availWidth;
	
	        var left = (width - wWeight) / 2;
	        var top = (heigth - wHeight) / 2;
	        
	        window.open("/admin/ezNewPortal/openBoardTree.do?portletId=" + portletId + "&companyId=" + companyId + "&code=" + portletCode + "&portletBoardId=" + portletBoardId, "",
	            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		}
		  
		var portletUpdate = function(event) {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			//포틀릿 아이디
			var portletId = event.data.portletId;
			
			//포틀릿 사용 여부
			var targetPortlet = document.getElementById("portlet" + portletId);
			var isUsed = targetPortlet.querySelectorAll(".switch")[0].querySelectorAll("input")[0].checked;
			
			//포틀릿 이름 리스트
			var portletNameList = targetPortlet.querySelectorAll(".portletName");
			var portletNameListCount = portletNameList.length;
			var nameList = [];
			var portletNameEmptyNum = 0;
			
			//특수문자 체크 (앤드&, 소괄호(), 슬래쉬/만 허용함)
			var special_pattern = /[\{\}\[\]?.,;:|*~`!^\-_+<>@\#$%\\\=\'\"]/g;
			const regex = new RegExp(special_pattern);
			
			for (var i = 0; i < portletNameListCount; i++) {

				if (regex.test($.trim(portletNameList[i].value))){
					alert("<spring:message code='ezNewPortal.csj01' />");
				    return;
				}
				
				if ($.trim(portletNameList[i].value) == "") {
					portletNameEmptyNum++;
				}
				
				nameList.push({"portletId" : portletId, "portletName" : $.trim(portletNameList[i].value), "portletLang" : portletNameList[i].getAttribute("data1")});
			}
			
			if (portletNameEmptyNum >= portletNameListCount) {
				alert("<spring:message code='ezNewPortal.t091' />");
				return;
			}
			
			//게시판 설정(게시판 아이디)
			var boardName = document.getElementById("portletBoard" + portletId);
			var boardId = null;
			
			if (boardName != null) {
				boardId = boardName.getAttribute("data1");
			}
			
			//연계 설정(Config 아이디)
			var connectionName = document.getElementById("portletConnection" + portletId);
			var connectionId = null;
			
			if (connectionName != null) {
				connectionId = connectionName.getAttribute("data1");
			}
			
			//새로운 포틀릿인 경우에는 메뉴 아이디
			//var portletMenuId = document.getElementById("portlet" + portletId);
			var menuId = document.getElementById("portlet" + portletId).getAttribute("data2");
			var portletCode = document.getElementById("portlet" + portletId).getAttribute("data3");
			var dataGeneral = document.getElementById("portlet" + portletId).getAttribute("data-general");
			
			var favoriteBoardUrl = document.getElementById("portlet" + portletId).dataset.url;
			if ((menuId == 4 && favoriteBoardUrl != '/ezNewPortal/favoriteBoardPortlet.do') && boardId == null && portletCode != "tabBoard") {
				alert("<spring:message code='ezNewPortal.t050' />");
				return;
			}
			
			if (menuId == connectMenuId && (connectionId == null || connectionId == "")) {
				alert("<spring:message code='ezSystem.config.hth29' />");
				return;
			}
			
			//새로운 포틀릿인 경우 ...connection url
			var url = document.getElementById("portlet" + portletId).querySelector(".connectionUrl");
			var connectionUrl = null;
			
			if (url != null) {
				connectionUrl = url.value;
				connectionUrl = $.trim(connectionUrl);
				
				if (connectionUrl == null || connectionUrl == "") {
					alert("<spring:message code='ezNewPortal.t092'/>");
					return;
				}
			}
			
			if (menuId == 3 && !(dataGeneral == 'true')) {
				connectionUrl += ("?cabinetType=" + document.getElementById("portlet" + portletId).querySelector("#cabinetType" + portletId).value);
			}
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updatePortlet.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { 
				if (request.status >= 200 && request.status < 300) {
					showToastMessage(portletId);
				}
			};
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				portletId : portletId,
				companyId : companyValue,
				nameList : nameList,
				boardId : boardId,
				connectionId : connectionId,
				portletUsed : isUsed,
				connectionUrl : connectionUrl,
				menuId : menuId,
				portletCode : portletCode
			});
			 
			request.send(data);
		}
		  
		//포틀릿 리스트 불러오는 함수
		var getPortletList = function() {
			var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getPortlets.do?type=' + webType, true);
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
					// 2020-12-07 박기범 - portletCode 조회 추가 
					var portletCode ="";
					for (var i = 0; i < portletCnt; i++) {
						portletId = result[i].portletId;
						defaultOrder = result[i].defaultOrder;
						portletName = result[i].portletName;
						portletType = result[i].portletType == null ? "" : result[i].portletType;
						portletURL = result[i].connectionUrl;
						portletNameList = result[i].portletNameList;
						menuId = result[i].menuId;
						portletNameListCnt = portletNameList.length;
						portletCode =  result[i].portletCode == null ? "" : result[i].portletCode;

						// 2020-12-08 박기범 - data3에 portletCode 추가
						listHTML += "<li class='portlet col' id='portlet" + portletId + "' data1='" + defaultOrder
								+ "' data2='" + menuId + "' data3='" + portletCode + "' data-general=" + result[i].general
								+ " data-url='" + ReplaceText(ReplaceText(ConvertCharToEntityReference(result[i].portletUrl), '\"', "&#39;"), "\'", "&#34;");
						
						if (lang != 1 && lang != 2 && portletId == 12) {
							listHTML +=  "' style='display:none'>";
						} else {
							listHTML +=  "'>";
						}
						
						if (usePrimaryLangOnly == "YES") {
							listHTML += "<div class='portlet-header'><div class='portlet_header_name'>" + ConvertCharToEntityReference(portletNameList[0].portletName) + "</div>";
						} else {
							listHTML += "<div class='portlet-header'><div class='portlet_header_name'>" + portletName + "</div>";
						}
						
						if (!result[i].general) {
							listHTML += "<a class='deletePortletBtn'>";
							listHTML += "<span><spring:message code='ezNewPortal.t059' /></span></a>";
						}
						
						listHTML += "<a class='updatePortletBtn'>";
						listHTML += "<span><spring:message code='ezNewPortal.t002' /></span></a>";
						listHTML += "</div>";
						listHTML += "<div class='portlet-content'>";
						listHTML += "<table class='portletInfo'><tr><th class='portletInfoTH'><spring:message code='ezNewPortal.t096' /> : </th>";
						if (portletId == 34) { //슬라이드 이미지 포틀릿의 경우
							listHTML += "<td class='portletInfoTD'><label class='switch'><input type='checkbox'><span class='slider round'></span></label>";
							listHTML += "<div class='slideImageSetting'><a><img src='/images/admin/admin_portlet_set.png'></a></div>";
							listHTML += "<div class='portletAuthSetting'><a class='imgbtn'><span><spring:message code='ezNewPortal.t074'/></span></a></div>";
							listHTML += "</td>";
						} else {
							listHTML += "<td class='portletInfoTD'><label class='switch'><input type='checkbox'><span class='slider round'></span></label>";
							listHTML += "<div class='portletAuthSetting'><a class='imgbtn'><span><spring:message code='ezNewPortal.t074'/></span></a></div>";
							listHTML += "</td>";
						}
						listHTML += "</tr>";
						
						for (var j = 0; j < portletNameListCnt; j++) {
							var language = "";
							var portletNameTrId = "";
							
							//언어
							if (portletNameList[j].portletLang == 1) {
								language = "<spring:message code='ezNewPortal.t078' />";
								portletNameTr = "ko";
							} else if (portletNameList[j].portletLang == 2) {
								language = "<spring:message code='ezNewPortal.t079' />";
								portletNameTr = "en";
							} else if (portletNameList[j].portletLang == 3) {
								language = "<spring:message code='ezNewPortal.t080' />";
								portletNameTr = "ja";
							} else if (portletNameList[j].portletLang == 4) {
								language = "<spring:message code='ezPortal.t4094' />";
								portletNameTr = "zh";
							} else if (portletNameList[j].portletLang == 5) {
								language = "<spring:message code='ezPersonal.s86' />";
								portletNameTr = "vi";
							} else if (portletNameList[j].portletLang == 6) {
								language = "<spring:message code='ezPersonal.s87' />";
								portletNameTr = "id";
							}
							
							// 2023-12-01 조소정 - 일본어, 중국어 사용 여부에 따라 포틀릿명 표출/미표출 구현
							if ((useJapanese == "NO" && portletNameTr == "ja") || (useChinese == "NO" && portletNameTr == "zh")) {
								listHTML += "<tr style='display:none;'><th class='portletInfoTH'><spring:message code='ezNewPortal.t097' />(" + language + ") :</th><td class='portletInfoTD'><input class='portletName' data1='" + portletNameList[j].portletLang + "' type='text' value='" + ConvertCharToEntityReference(portletNameList[j].portletName) + "' maxlength='50'></td></tr>"
							} else {
								listHTML += "<tr><th class='portletInfoTH'><spring:message code='ezNewPortal.t097' />(" + language + ") :</th><td class='portletInfoTD'><input class='portletName' data1='" + portletNameList[j].portletLang + "' type='text' value='" + ConvertCharToEntityReference(portletNameList[j].portletName) + "' maxlength='50'></td></tr>"
							}
						}
						
						if (!result[i].general) {						
							listHTML += "<tr><th class='portletInfoTH'><spring:message code='ezNewPortal.t098' /> : </th><td class='portletInfoTD'>";
							
							var menuName = result[i].menuName;
							
							if (menuName == null || menuName == "null") {
								menuName = "<spring:message code='ezNewPortal.t089' />";
							} else {
								menuName = ConvertCharToEntityReference(menuName);
							}
	
							listHTML += "<input id='portletMenu" + portletId + "' type='text' value='" + menuName + "'readonly>";
							listHTML += "<div class='btnpositionJsp menuSetting'>";
							listHTML += "<a class='menuSettingtBtn'>";
							listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div>";
							listHTML += "</td></tr>";
							
							if (menuId != 4 && menuId != connectMenuId) {
								listHTML += "<tr class='connectionTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t101' /></th><td class='portletInfoTD'><input type='text' class='connectionUrl' value='"+ ReplaceText(ReplaceText(ConvertCharToEntityReference(portletURL), '\"', "&#39;"), "\'", "&#34;") +"' maxlength='100'></td></tr>";
							} else {
								if (!result[i].general) {
									listHTML += "<tr class='connectionTR notUsedTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t101' /></th><td class='portletInfoTD'><input type='text' class='connectionUrl' value='"+ ReplaceText(ReplaceText(ConvertCharToEntityReference(portletURL), '\"', "&#39;"), "\'", "&#34;") +"' maxlength='100'></td></tr>";
								} else {
									listHTML += "<tr class='connectionTR notUsedTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t101' /></th><td class='portletInfoTD'><input type='text' class='connectionUrl' value='' maxlength='100'></td></tr>";
								}	
							}
							
						} else if (isFixBoardPortlet(portletCode)) {
							listHTML += "<tr class='connectionTR notUsedTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t101' /></th><td class='portletInfoTD'><input type='text' class='connectionUrl' value='"+ ReplaceText(ReplaceText(ConvertCharToEntityReference(portletURL), '\"', "&#39;"), "\'", "&#34;") +"' maxlength='100'></td></tr>";
						}
						
						// 2020-12-07 박기범:tabBoard 게시판도 게시판설정 감추도록 분기 추가
						if (menuId == 4 && portletId != 10 && portletCode != "tabBoard") {
							listHTML += "<tr class='boardTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t048' /> :</th><td class='portletInfoTD'>";
							
							var boardName = "";
							
							if (result[i].boardName1 == null || result[i].boardName1 == "null") {
								boardName = "<spring:message code='ezNewportal.boardNameNone01' />";
							} else {
								boardName = ReplaceText(ReplaceText(result[i].boardName1, '\"', "&#39;"), "\'", "&#34;");
							}
							
							listHTML += "<input id='portletBoard" + portletId + "' class='boardName' type='text' value='" + boardName + "' data1='" + result[i].portletBoardId + "' readonly>";
							listHTML += "<div class='boardSetting'>";
							listHTML += "<a class='boardSettingtBtn'>";
							listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";
							
							listHTML += "<tr class='boardTR2 notUsedTR'><th class='portletInfoTH'><spring:message code='ezSystem.w018' /> :</th><td class='portletInfoTD'>";
							listHTML += "<input id='portletConnection" + portletId + "' type='text' readonly>";
							listHTML += "<div class='connectionSetting'>";
							listHTML += "<a class='connectionSettingtBtn'>";
							listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";	
						} else if (result[i].general && (menuId != 4 || portletId == 10)){
							listHTML += "<tr class='boardNotUsed'><th class='portletInfoTH'>&nbsp;</th><td class='portletInfoTD'>&nbsp;<br/></td></tr>";
						} else if (menuId == connectMenuId) {
							var connectionName = "";
							
							if (result[i].connectionName == null || result[i].connectionName == "null") {
								connectionName = "없음";
							} else {
								connectionName = ReplaceText(ReplaceText(result[i].connectionName, '\"', "&#39;"), "\'", "&#34;");
							}
							
							listHTML += "<tr class='boardTR notUsedTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t048' /> :</th><td class='portletInfoTD'>";
							listHTML += "<input id='portletBoard" + portletId + "' type='text' readonly>";
							listHTML += "<div class='boardSetting'>";
							listHTML += "<a class='boardSettingtBtn'>";
							listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";
							
							listHTML += "<tr class='boardTR2 UsedTR'><th class='portletInfoTH'><spring:message code='ezSystem.w018' /> :</th><td class='portletInfoTD'>";
							listHTML += "<input id='portletConnection" + portletId + "' type='text' value='" + connectionName + "' data1='" + result[i].portletConnectionId + "' readonly>";
							listHTML += "<div class='connectionSetting'>";
							listHTML += "<a class='connectionSettingtBtn'>";
							listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";
							
						} else if (!result[i].general) {
							listHTML += "<tr class='boardTR notUsedTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t048' /> :</th><td class='portletInfoTD'>";
							listHTML += "<input id='portletBoard" + portletId + "' type='text' readonly>";
							listHTML += "<div class='boardSetting'>";
							listHTML += "<a class='boardSettingtBtn'>";
							listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";
							
							listHTML += "<tr class='boardTR2 notUsedTR'><th class='portletInfoTH'><spring:message code='ezSystem.w018' /> :</th><td class='portletInfoTD'>";
							listHTML += "<input id='portletConnection" + portletId + "' type='text' readonly>";
							listHTML += "<div class='connectionSetting'>";
							listHTML += "<a class='connectionSettingtBtn'>";
							listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";	
							
						}

						if (!result[i].general) {
							listHTML += getCabinetTypeRowStr(portletURL, portletId);
							listHTML += getBoardViewTypeRowStr(portletURL, portletId);
						} else if (isFixBoardPortlet(portletCode)) {
							listHTML += getFixBoardKeyRowStr(portletURL, portletId);
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
						
						var connectionSettingBtn = $("#portlet" + result[i].portletId).find(".connectionSetting");
						if (connectionSettingBtn) {
							connectionSettingBtn.on("click", {"portletId" : result[i].portletId}, openConfigTree);
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
						
						//포틀릿 권한 창 불러오기 버튼 활성화
						$("#portlet" + result[i].portletId).find(".portletAuthSetting").on("click", {"portletId" : result[i].portletId}, openPortletAuthSetting);

						if (isFixBoardPortlet(result[i].portletCode)) {
							switchBoardViewTypeRow(result[i].portletId, true);
						} else if (result[i].menuId == 4 && !result[i].general && result[i].boardGubun == 0) {
							switchBoardViewTypeRow(result[i].portletId, true);
						} else if (result[i].menuId == 3 && !result[i].portletCode) {
							document.getElementById("portlet" + result[i].portletId).querySelector(".connectionTR").style.display = "none";
							document.getElementById("portlet" + result[i].portletId).querySelector(".connectionUrl").value = portletURL.split('?')[0];
							document.getElementById("portlet" + result[i].portletId).querySelector("#cabinetSelRow" + result[i].portletId).style.display = "";
							
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
			$( ".portlet" )
				.addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
				.find( ".portlet-header" )
				.addClass( "ui-widget-header ui-corner-all" )
				//.prepend( "<span class='ui-icon ui-icon-minusthick portlet-toggle'></span>");
			
			$(".addPortlet").on("click", showAddPortletForm); //click event
		}
	 
		var showAddPortletForm = function() {
			$(".addPortlet").remove();
			
			var listHTML = "";
			listHTML += "<li id='newPortlet' class='newPortlet'>";
			listHTML += "<div class='portlet-header' style='background-color:#f4f4f4;border:1px solid #e7e7e7;color:#b1b1b1'><spring:message code='ezNewPortal.t100' />";
			listHTML += "<a class='cancelNewPortletBtn'>";
			listHTML += "<span class='addCancel'><spring:message code='ezNewPortal.t001' /></span></a>";
			listHTML += "<a class='addNewPortletBtn'>";
			listHTML += "<span class='addCancel'><spring:message code='ezNewPortal.t099' /></span></a>";
			listHTML += "</div>";
			listHTML += "<div class='portlet-content'>";
			listHTML += "<table class='portletInfo'><tr><th class='portletInfoTH'><spring:message code='ezNewPortal.t096' /> </th>"
			listHTML += "<td class='portletInfoTD'><label class='switch'><input type='checkbox'><span class='slider round'></span></label></td>";
			listHTML += "</tr>";
			
			//언어
			if (usePrimaryLangOnly == "YES") {
				listHTML += "<tr><th class='portletInfoTH'><spring:message code='ezNewPortal.t097' />";
				
				if (primary == "1") {
					listHTML += "(<spring:message code='ezNewPortal.t078' />) </th><td class='portletInfoTD'><input class='portletName' data1='1' type='text' maxlength='50'></td></tr>";
				} else if (primary == "2") {
					listHTML += "(<spring:message code='ezNewPortal.t079' />) </th><td class='portletInfoTD'><input class='portletName' data1='2' type='text' maxlength='50'></td></tr>";
				} else if (primary == "3") {
					listHTML += "(<spring:message code='ezNewPortal.t080' />) </th><td class='portletInfoTD'><input class='portletName' data1='3' type='text' maxlength='50'></td></tr>";
				} else if (primary =="4") {
					listHTML += "(<spring:message code='ezPortal.t4094' />) </th><td class='portletInfoTD'><input class='portletName' data1='4' type='text' maxlength='50'></td></tr>";
				} else if (primary =="5") {
					listHTML += "(<spring:message code='ezPersonal.s86' />) </th><td class='portletInfoTD'><input class='portletName' data1='5' type='text' maxlength='50'></td></tr>";
				} else if (primary =="6") {
					listHTML += "(<spring:message code='ezPersonal.s87' />) </th><td class='portletInfoTD'><input class='portletName' data1='6' type='text' maxlength='50'></td></tr>";
				}
			} else {
				var titleMap = new Map();

				titleMap.set("1", "<spring:message code='ezNewPortal.t078' />");
				titleMap.set("2", "<spring:message code='ezNewPortal.t079' />");

				if (useJapanese == "YES") {
					titleMap.set("3", "<spring:message code='ezNewPortal.t080' />");
				}
				if (useChinese == "YES") {
					titleMap.set("4", "<spring:message code='ezPortal.t4094' />");
				}
				if (useVietnamese == "YES") {
					titleMap.set("5", "<spring:message code='ezPersonal.s86' />");
				}
				if (useIndonesian == "YES") {
					titleMap.set("6", "<spring:message code='ezPersonal.s87' />");
				}
				if (!primary || !titleMap.has(primary)) {
					primary = "1";
				}

				// main
				listHTML += "<tr><th class='portletInfoTH'><spring:message code='ezNewPortal.t097' />(" + titleMap.get(primary) + ") </th><td class='portletInfoTD'><input class='portletName' data1='" + primary + "' type='text' maxlength='50'></td></tr>";
				titleMap.delete(primary);

				// sub		*맵은 입력된 순서를 기억합니다. 열거는 입력된 순서대로 이루어집니다. (https://offbyone.tistory.com/468)
				titleMap.forEach(
					function (message, key, map) {
						return listHTML += "<tr><th class='portletInfoTH'><spring:message code='ezNewPortal.t097' />(" + message + ") </th><td class='portletInfoTD'><input class='portletName' data1='" + key + "' type='text' maxlength='50'></td></tr>";
					}
				);
			}
			
			listHTML += "<tr><th class='portletInfoTH'><spring:message code='ezNewPortal.t098' /> </th><td class='portletInfoTD'>";
			listHTML += "<input id='newPortletMenu' type='text' readonly>";
			listHTML += "<div class='btnpositionJsp menuSetting'>";
			listHTML += "<a class='menuSettingtBtn'>";
			listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div>";
			listHTML += "</td></tr>";
			listHTML += "<tr class='connectionTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t101' /> </th><td class='portletInfoTD'><input class='connectionUrl' type='text' maxlength='100'></td></tr>";
			listHTML += "<tr class='notUsedTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.t048' /> </th><td class='portletInfoTD'>";
			listHTML += "<input id='newPortletBoard' type='text' readonly>";
			listHTML += "<div class='btnpositionJsp boardSetting'>";
			listHTML += "<a class='boardSettingtBtn'>";
			listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";
			listHTML += "<tr class='notUsedTR2'><th class='portletInfoTH'><spring:message code='ezSystem.w018' /> </th><td class='portletInfoTD'>";
			listHTML += "<input id='newPortletConnection' type='text' readonly>";
			listHTML += "<div class='btnpositionJsp connectionSetting'>";
			listHTML += "<a class='connectionSettingtBtn'>";
			listHTML += "<img src='/images/admin/admin_portlet_set.png' /></a></div></td></tr>";

			listHTML += getBoardViewTypeRowStr('', '');
			
			listHTML += getCabinetTypeRowStr('', '');
			
			listHTML += "</table>";
			listHTML += "</li>";
			
			document.getElementById("portletListContainer").insertAdjacentHTML('beforeend', listHTML);
			
			
			$( ".newPortlet")
			.addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
			.find( ".portlet-header" )
			.addClass( "ui-widget-header ui-corner-all" );
			//jquery ui - 끝
			
			$("#newPortlet").find(".menuSetting").on("click", {"portletId" : null}, openMenuList);
			
			$(".addNewPortletBtn").on("click", {"portletId" : null}, portletAdd);
			$(".cancelNewPortletBtn").on("click", cancelPortlet);
			$(".newPortlet").find(".boardSetting").on("click", {"portletId" : null}, openBoardTree);
			$(".newPortlet").find(".connectionSetting").on("click", {"portletId" : null}, openConfigTree);
		}
		
		var cancelPortlet = function() {
			getPortletList();
		}
		
		var openMenuList = function (event) {
			var portletId = event.data.portletId;
	 		var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
	        var wWeight = "662";
	        var wHeight = "445";
	
			if (webType == 'mobile') {
				wWeight = 450;
				wHeight = 300;
			}

	        var heigth = window.screen.availHeight;
	        var width = window.screen.availWidth;
	
	        var left = (width - wWeight) / 2;
	        var top = (heigth - wHeight) / 2;
	        
	        window.open("/admin/ezNewPortal/openPortalMenu.do?portletId=" + portletId + "&companyId=" + companyId +"&type=" + webType, "",
	            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		}
		
		var showToastMessage = function (portletId) {
			var doc = window.document;
			var alertMessage = "<spring:message code='ezNewPortal.t102' />";
			var toastArea = doc.createElement("div");
			var width = $("#portlet" + portletId).width();
			var height = $("#portlet" + portletId).height();
			var topPosition = (height / 2) - 10;
			var leftPosition = (width / 2) - 47;
			
			toastArea.innerHTML = alertMessage;
			toastArea.setAttribute("class", "toastArea");
			toastArea.style.top = topPosition + "px";
			toastArea.style.left = leftPosition + "px";
			toastArea.style.display = "block";
			toastArea.style.zIndex = 9999;
			toastArea.id = "toast" + portletId;
			
			$("#portlet" + portletId).prepend(toastArea);
	
			var isUsedPortlet = $("#portlet" + portletId).find(".switch").find("input[type='checkbox']").prop("checked");
			
			if (isUsedPortlet) {
				$("#portlet" + portletId).find(".portlet-header").css("background-color", "rgb(237, 247, 255)");
				$("#portlet" + portletId).find(".portlet-header").css("border", "");
				$("#portlet" + portletId).find(".portlet-header").css("color", "");
				$("#portlet" + portletId).find(".portlet-header").find("span").attr("class", "spanOn");
				var changedName = $("#portlet" + portletId).find(".portletName[data1='" + lang + "']").val();
				$("#portlet" + portletId).find(".portlet-header").find(".portlet_header_name").text(changedName);
			} else {
				$("#portlet" + portletId).find(".portlet-header").css("background-color", "rgb(244,244,244)");
				$("#portlet" + portletId).find(".portlet-header").css("border", "1px solid rgb(231, 231, 231)");
				$("#portlet" + portletId).find(".portlet-header").css("color", "rgb(177, 177, 177)");
				$("#portlet" + portletId).find(".portlet-header").find("span").attr("class", "spanOff");
				var changedName = $("#portlet" + portletId).find(".portletName[data1='" + lang + "']").val();
				$("#portlet" + portletId).find(".portlet-header").find(".portlet_header_name").text(changedName);
			}
			
			setTimeout(function() {
				$("#toast" + portletId).fadeOut(1000, function() {
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
	            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1, top=" + top + ",left = " + left);
		}
		
		var openPortletAuthSetting = function (event) {
			var portletId = event.data.portletId;
	 		var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
			
	        var wWeight = "401";
	        var wHeight = "339";
	
	        var heigth = window.screen.availHeight;
	        var width = window.screen.availWidth;
	
	        var left = (width - wWeight) / 2;
	        var top = (heigth - wHeight) / 2;
	        
	        window.open("/admin/ezNewPortal/openPortletAuthSetting.do?portletId=" + portletId + "&companyId=" + companyId, "",
	            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1, top=" + top + ",left = " + left);
		}

		function getBoardViewTypeRowStr(portletURL, portletId) {
			var portletUrl = URLParamsUtils(portletURL);
			var viewType = portletUrl.get('type');
			var mobileType = portletURL.indexOf("/mobile/ezNewPortal/boardPortlet.do?type=b");

			var resultStr = "<tr id='rowViewType" + portletId + "' class='cardTR notUsedTR'><th class='portletInfoTH'><spring:message code='ezNewPortal.board.pgb04' /> :</th><td class='portletInfoTD typeTD'>";
			resultStr += "<select id='portletViewType" + portletId + "' name='portletViewType" + portletId + "' style='font-size:12px;' onchange='updateViewTypeOfBoard(this.value,\"" + portletId + "\", \"" + portletURL + "\");'>";
			resultStr += "<option value='" + BoardViewType.DEFAULT + "' " + (viewType === BoardViewType.DEFAULT ? "selected" : "") + "><spring:message code='ezNewPortal.board.pgb01' /></option>";
			resultStr += "<option value='" + BoardViewType.CARD_A + "' " + (viewType === BoardViewType.CARD_A ? "selected" : "") + "><spring:message code='ezNewPortal.board.pgb02' /></option>";
			resultStr += "<option value='" + BoardViewType.CARD_B + "' " + (viewType === BoardViewType.CARD_B ? "selected" : "") + "><spring:message code='ezNewPortal.board.pgb03' /></option>";
			resultStr += "</select>   ";
			resultStr += "<a class='imgbtn wordSelect " + (isWordSelectDisplay(viewType, portletURL) && mobileType == -1 ? "" : CLASS_DISPLAY_NONE) + "' id='wordSelect" + portletId + "' onclick='selectWord(\"" + portletId + "\");'>";
			resultStr += "<span style='font-size:11px;'><spring:message code='ezNewPortal.board.pgb05' /></span></a>";

			return resultStr;
		}

		function getFixBoardKeyRowStr(portletURL, portletId) {
			var portletUrl = URLParamsUtils(portletURL);
			var viewType = portletUrl.get('type');

			var resultStr = "<tr id='rowFixKeyword" + portletId + "' class=''><th class='portletInfoTH'><spring:message code='ezNewPortal.board.pgb08' /> :</th><td class='portletInfoTD typeTD'>";
			resultStr += "<a class='imgbtn wordSelect' id='wordSelect" + portletId + "' onclick='selectWord(\"" + portletId + "\");'>";
			resultStr += "<span style='font-size:11px;'><spring:message code='ezNewPortal.board.pgb05' /></span></a>";

			return resultStr;
		}

		function resetBoardUrl(id) {
			var portlet = !!id ? 'portlet' + id : 'newPortlet';
			var conUrl = document.getElementById(portlet).querySelector('.connectionUrl');
			console.log('conUrl : ' + conUrl);
			// url의 파라미터 제거
			if (!!conUrl) conUrl.value = URLParamsUtils(conUrl.value).base;
		}

		function switchBoardViewTypeRow(portletId, turnOn) {
			var row = document.getElementById('rowViewType' + portletId);
			if (!row) return;
			var select = document.getElementById('portletViewType' + portletId);
			var anchor = document.getElementById('wordSelect' + portletId);

			if (turnOn) {
				row.classList.remove(CLASS_DISPLAY_NONE);
			} else {
				row.classList.add(CLASS_DISPLAY_NONE);
				anchor.classList.add(CLASS_DISPLAY_NONE);
				if (!!select) select.value = '';
			}
		}

		function selectWord(id) {
			var portletId = !!id ? "portlet" + id : "newPortlet";
			var connectionUrl = document.getElementById(portletId).querySelector(".connectionUrl");

			var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;

			var wWeight ="540";
			var wHeight = "270";

			var heigth = window.screen.availHeight;
			var width = window.screen.availWidth;
			var left = (width - wWeight) / 2;
			var top = (heigth - wHeight) / 2;
			var conUrl = URLParamsUtils(connectionUrl.value);
			var wordSetUrl = URLParamsUtils("/admin/ezNewPortal/cardViewPortletWordSetting.do?");
			wordSetUrl.put('portletId', portletId);
			wordSetUrl.put('companyId', companyId);
			wordSetUrl.put('fileName', conUrl.get('fileName'));
			var openWin = window.open(wordSetUrl.url, "", "height = " + wHeight + ", width = " + wWeight
					+ ", status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=1, top=" + top + ",left = " + left);

		}

		function updateViewTypeOfBoard(type, portletId, mobileUrl) {
			var anchor = document.getElementById('wordSelect' + portletId);
			if (isWordSelectDisplay(type, mobileUrl)) {
				anchor.classList.remove(CLASS_DISPLAY_NONE);
			} else {
				anchor.classList.add(CLASS_DISPLAY_NONE);
			}

			var domId = !!portletId ? "portlet" + portletId : "newPortlet";
			var connectionUrl = document.getElementById(domId).querySelector(".connectionUrl");
            var url = URLParamsUtils(connectionUrl.value);
            connectionUrl.value = url.put('type', type).getFullUrl();
		}

		function isFixBoardPortlet(code) {
			if (!code) return false;
			return code === 'fixLeft' || code === 'fixRight' || code === 'mFixTop' || code === 'mFixBottom';
		}

		// 단어설정 버튼 표출 조건
		function isWordSelectDisplay(viewType, portletURL) {
			var mobilePortlet = -1;
			var mobileUrl = portletURL.indexOf("/mobile/");
			
			if (mobileUrl > -1) {
				if (viewType == "b") {
					mobilePortlet = 1;
				}
			} 
			
			if (mobilePortlet == -1) {
				return viewType === BoardViewType.CARD_A || viewType === BoardViewType.CARD_B;
			}
		}
		
		// 2024-06-26 조수빈 - 관련 메뉴가 전자결재일 경우 포틀릿에 보여질 문서함을 선택하는 ui 생성 메소드
		function getCabinetTypeRowStr(portletURL, portletId) {
			var portletUrl = URLParamsUtils(portletURL);
			var cabinetType = portletUrl.get('cabinetType');
			var approvalFlag = "<c:out value='${approvalFlag}'/>";

			var resultStr = "<tr id='cabinetSelRow" + portletId + "' class='CabinetTR' style='display:none'><th class='portletInfoTH'><spring:message code='ezApprovalG.t1187' /> :</th><td class='portletInfoTD CabinetSelTD'>";
			resultStr += "<select id='cabinetType" + portletId + "' style='font-size:12px;'>";
			resultStr += "<option value='" + CabinetType.DOING + "' " + (cabinetType === CabinetType.DOING ||  !cabinetType ? "selected" : "") + "><spring:message code='main.t00003' /></option>";
			resultStr += "<option value='" + CabinetType.REJECT + "' " + (cabinetType === CabinetType.REJECT ? "selected" : "") + "><spring:message code='main.t00004' /></option>";
			resultStr += "<option value='" + CabinetType.DRAFT + "' " + (cabinetType === CabinetType.DRAFT ? "selected" : "") + "><spring:message code='main.t00005' /></option>";
			
			if (webType != 'mobile') {
				resultStr += "<option value='" + CabinetType.DISPLAY + "' " + (cabinetType === CabinetType.DISPLAY ? "selected" : "") + ">";
				resultStr += approvalFlag === "G" ? "<spring:message code='ezApprovalG.t10011' />" : "<spring:message code='ezCircular.t7' />";
				resultStr += "</option>";
			} else if (webType == 'mobile' && approvalFlag === "G") {
				resultStr += "<option value='" + CabinetType.DISPLAY + "' " + (cabinetType === CabinetType.DISPLAY ? "selected" : "") + "><spring:message code='ezApprovalG.t10011' /></option>";
			}
			
			resultStr += "</select></tr>";

			return resultStr;
		}
		
		/* 2024-07-12 한태훈 > 연계 포틀릿 시스템 컨피그 선택창*/
		var openConfigTree = function(event) {
			var portletId = event.data.portletId;
	 		var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
			
	        var wWeight = "690";
	        var wHeight = "650";
	
	        var heigth = window.screen.availHeight;
	        var width = window.screen.availWidth;
	
	        var left = (width - wWeight) / 2;
	        var top = (heigth - wHeight) / 2;
	        
	        window.open("/admin/ezNewPortal/openConfigTree.do?portletId=" + portletId + "&companyId=" + companyId + "&typeCode=PORTLET", "",
		            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		}
		
	</script>
</body>
</html>
