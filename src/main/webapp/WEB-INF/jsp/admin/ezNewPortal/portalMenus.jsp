<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html style="height: 97%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezNewPortal.t055' /></title>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
		<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/default.css')}" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/component.css')}" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
		<style type="text/css">
			body {background-color : white;}
			.ui-sortable{ margin:0px; padding:0px;}
			.menu, .menuAdd {cursor:pointer; vertical-align:top;display : inline-block;width : 100px; border : 1px solid #d9d9d9; margin :10px 5px 0px 0px; height:122px}
			#menuAdd {border : 1px dashed #aaaaaa;}
			.menu dl dt, .menuAdd dl dt {text-align : center;display : block;height : 42px;margin : 0px;	padding : 0px;}
			.menu dl dt{height:auto;}
			.menu dl dd, .menuAdd dl dd {display:table-cell; width : 98px; height:56px; margin:0px; padding:0px; text-align:center; vertical-align:middle; font-size:15px; font-weight:bold; letter-spacing:-1px;}
			.menu dl dd{height:auto; display:block; margin-top:10px;}
			span.icon_topmenu {margin-top : 20px;}
			.menuUsed {background-color : #fff;}
			.menuUsed_on{color: #0470e3; border-color: #b9d7f6; background: #f1f8ff;}
			.menuNotUsed {background-color : #efefef; border:1px solid #d9d9d9; color:#b9b9be;}
			.menuDetails {list-style:none;display : none; float:left; width:98%; position : relative;}
			.menuTitle {margin : 10px;}
			.menuTitle span {font-size : 18px; font-weight:bold;}
			.menuDetails hr {display:block; width:99%;}
			.menuIconInfo {display:inline-block; margin:43px 23px 23px 23px;}
			.menuIcon {width:100px;height:100px;border:1px solid black;margin-bottom:10px;text-align:center;vertical-align:middle;}
			.menuIcon span, .menuIcon img {margin:18px 21px;}
			.menuInfo {display:inline-block; vertical-align:top; margin-top:23px;}
			.menuInfo ul {padding:0px;}
			.menuInfo ul li {font-size:15px; font-weight:bold; display:block;margin-bottom:12px;}
			.menuAuth {display:inline-block;}
			.menuName table {margin-top:5px;}
			.menuName table tr {height : 34px;}
			.menuName table tr td input {width:300px; margin-left:10px;}
			.conUrl input {width:300px;}
			.menuName table th {border:none;background-color:white;font-size:13px;color:black;}
			.menuAuth {vertical-align:top;margin-top:23px;margin-left:150px;}
			.menuAuthBtn {display:inline-block}
			.updateMenu, .addMenu {margin-right:20px;}
			.btnpositionJsp {margin-top : 0px;padding:0px;}
			.hideDetails {display : none;}
			.menuSortable {display : inline-block;}
			dt img {width:21px;height:21px;margin-top:20px;}
			.menuIcon img {width:21px;height:21px;}
			.deleteMenu {display:inline-block;margin-left:50px;vertical-align:top;margin-top:-3px;}
			.accessOK div, .accessNO div {display:inline-block;}
			.menuChoice {background: #edf7ff; border: 1px solid #2196f3; color: #0470e3;}
	        .admin_menu .menuIconTD {padding:0px;}
	        .admin_menu .menuIconTD div {height:100%; overflow:auto; padding:5px;}
			li.menu dl dd span {white-space:normal; line-height:1.2; word-wrap:break-word;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;}
			.bottomBtn .btnA:hover{text-decoration:none;}
		</style>
	</head>
	
	<body class="mainbody">
		<h1>
			<spring:message code='ezNewPortal.t055' />
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select class="companySelect" id="ListCompany"></select>
		</h1>
		<c:if test="${type != 'mobile' }">
		<div style="margin-bottom:10px;">
			<span style="font-size: 14px; font-weight: 500;">▒ <spring:message code="ezNewPortal.topMenu.hth01"/></span> <span style="font-size: 11px; font-weight: 400;">(<spring:message code="ezNewPortal.topMenu.hth02"/></span>)</span>
			<form id="Form1" method="post">
				<br>
				<table class="content" style="width: 450px; margin-top:10px;">
				    <tbody><tr>
				        <th><spring:message code="ezNewPortal.topMenu.hth01"/></th>
				        <td>
				            <input style="margin-top: 0px;" type="radio" id="topDisplayMode" name="topMenuDisplayMode" value="0"><label for="topDisplayMode" style="cursor: pointer; vertical-align: middle"><spring:message code="ezNewPortal.kwc01"/></label>
				            <input style="margin-top: 0px;" type="radio" id="leftDisplayMode" name="topMenuDisplayMode" value="1"><label for="leftDisplayMode" style="cursor: pointer; vertical-align: middle"><spring:message code="ezPortal.t72"/></label>
				        </td>
				    </tr>
				</tbody></table>
				<div class="btnpositionJsp" style="width: 436px; margin-top:10px;">
				    <a class="imgbtn" onclick="topMenuDisplayModeSave()"><span><spring:message code="ezNewPortal.topMenu.hth05"/></span></a>
				    <a class="imgbtn" onclick="getCompanyTopMenuDisplayMode()"><span><spring:message code="ezNewPortal.topMenu.hth06"/></span></a>
				</div>
			</form>
		</div>
		</c:if>
		<%-- <div id="mainmenu">
			<ul style="margin-top: 15px;">
				<li class="menuOrderResetButton" id="menuOrderReset"><span><spring:message code='ezNewPortal.t003' /></span></li>
			</ul>
		</div> --%>
		<div>
		<span style="font-size: 14px; font-weight: 500;">▒ <spring:message code="ezNewPortal.topMenu.hth04"/></span> </span> <span style="font-size: 11px; font-weight: 400;">(<spring:message code='ezNewPortal.garm07' />)</span>
		<ul id="menuList" class="admin_menu_set">
		</ul>
		</div>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	<script type="text/javascript">
		var menuAuths = [];
		var usePrimaryLangOnly = "";
		var primary = "";
		var useJapanese = "${useJapanese}";
		var useChinese = "${useChinese}";
		var useVietnamese = "${useVietnamese}";
		var useIndonesian = "${useIndonesian}";
		var type = "${type}";
		var connectMenuId = '<c:out value="${connectMenuId}"/>';
		var userLang = '<c:out value="${userLang}"/>';
		
		$(function(){
			getCompanies();
			getMenus();
			getCompanyTopMenuDisplayMode();
			/* document.getElementById("menuOrderReset").addEventListener("click", resetMenuOrder); */
		});
		
		var resetMenuOrder = function() {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/resetMenuOrder.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
			
			request.onload = function() {
				getMenus();
			}
			
			var data = JSON.stringify({
				companyId : companyValue
			});
			 
			request.send(data);
		}
		
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
						getMenus();
						getCompanyTopMenuDisplayMode();
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
		
		var getMenus = function() {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getMenus.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					var menuList = result.list;
					var menusHTML = "";
					var agent = navigator.userAgent.toLowerCase();
					var isIE = false
					
					if ( (navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || (agent.indexOf("msie") != -1)) {
						// ie일 경우
						isIE = true;
					}
					
					menuList.forEach(function (item, index) {
						if (item.menuId == connectMenuId) { // 연계메뉴는 표출 안함.
							return;
						}
						
						menusHTML += "<li class='menu draggable-item' id='menu" + item.menuId + "'>";
						menusHTML += "<dl>";
						menusHTML += "<dt><span class='" + item.iconUrl + "'>";
						menusHTML += "</span></dt>";
						
						if (isIE) {
							var menuNameWithoutSpace = ConvertCharToEntityReference(item.menuName).replace(/ /gi, "");
							if (menuNameWithoutSpace.length > 18) {
								var menuName = ConvertCharToEntityReference(item.menuName).substr(0, 19) + '...';
								menusHTML += "<dd><span style='font-size: 15px; text-overflow: ellipsis; overflow: hidden; width: 95px;'>" + ConvertCharToEntityReference(menuName) + "</span></dd>" ;
							} else {
								menusHTML += "<dd><span style='font-size: 15px; text-overflow: ellipsis; overflow: hidden; width: 95px;'>" + ConvertCharToEntityReference(item.menuName) + "</span></dd>" ;
							}
						} else {
							menusHTML += "<dd><span style='font-size: 15px; text-overflow: ellipsis; overflow: hidden; width: 95px;'>" + ConvertCharToEntityReference(item.menuName) + "</span></dd>" ;
						}
						
						menusHTML += "</li>";
					});
					
					//메뉴 추가 관련
					menusHTML += "<li class='menuAdd' id='menuAdd'><div><img src='/images/admin/menuAdd.png' style='margin:49px 38px' /></div></li>";
					
					$("#menuList").html(menusHTML);
					
					menuList.forEach(function (item, index) {
						$("#menu" + item.menuId).on("click", {"menuId" : item.menuId}, openMenuDetail);
						
						if (item.menuUsed) {
							$("#menu" + item.menuId).addClass("menuUsed");
						} else {
							$("#menu" + item.menuId).addClass("menuNotUsed");
						}
						
					});
					
					//메뉴 드래그앤드롭
					$("#menuList .draggable-item").draggable({
					    revert: "invalid",
					    containment: "parent",
					    zIndex: 100,
					    start: function (event, ui) {
					    	var dragElem = $(this);
					    	dragElem.css({
					    		"cursor": "move",
					    		"opacity": "0.6"
					    	});
					    },
					    snap:'#menuList li',
					    stop : function(event, ui) {
					    	var dragElem = $(this);
					    	dragElem.css({
					    		"cursor": "pointer",
					    		"opacity": ""
					    	});
					    },
					    helper : "clone"
					});
					  
					$("#menuList .draggable-item").droppable({
					    tolerance: "intersect",
					    drop: function(event, ui) {
						var dragElem = ui.draggable;
						var dropElem = $(this);
						changePosition(dragElem, dropElem);
						updateMenuOrder();
					  }
					});
					
					//$("#menuList").disableSelection();
					$("#menuList").on("sortstart", function( event, ui ) { ui.placeholder.css("width","100px"); });
					//메뉴추가버튼
					$("#menuAdd").on("click", openMenuAdd);
				}
			};
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				companyId : companyValue,
				type : type
			});
			 
			request.send(data);
		}
		
		var getCompanyTopMenuDisplayMode = function() {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			$.ajax({
				type: "GET",
				url: "/admin/ezNewPortal/getTopMenuDisplayModeForCompany.do",
				dataType: "JSON",
				data : {
					companyId : companyValue	
				},
				async: true,
				success: function(result) {
					var topMenuDisplayModeBtn = document.getElementsByName('topMenuDisplayMode');
					for (var i = 0; i < topMenuDisplayModeBtn.length; i++) {
						if (topMenuDisplayModeBtn[i].value == result.data) {
							topMenuDisplayModeBtn[i].checked = true;
							break;
						}
					}
					
				},
				error: function (xhr, status, e){
					
				}
			});
		}
		
		var openMenuDetail = function(event) {
			var menuId = event.data.menuId;
			
			$(".menuChoice").removeClass("menuChoice");
			$("#menu" + menuId).addClass("menuChoice");
			
			getMenuDetail(menuId);
		}
		
		var getMenuDetail = function(menuId) {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getMenuInfo.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					var menuInfo = result.menuInfo;
					var menuNames = result.menuNames;
					var menuAuthsY = result.menuAuths.menuAuthsY;
					var menuAuthsN = result.menuAuths.menuAuthsN;
					
					menuAuths = menuAuthsY;
					menuAuths = menuAuths.concat(menuAuthsN);
					
					var menusHTML = "<li class='menuDetails' id='menuLi" + menuInfo.menuId + "'>";
					menusHTML += "<div class='admin_menu' id='menuDetails" + menuInfo.menuId + "'>";
					menusHTML += "<dl class='admin_menuDL'>";
					menusHTML += "<dt class='admin_menuTit'>" + ConvertCharToEntityReference(menuInfo.menuName) + "</dt><dd class='admin_menuX'></dd></dl>";
					
					menusHTML += "<div class='admin_menu_content'>";
					menusHTML += "<dl class='adminMenu_icon'><dt class='admenuIcon menuIcon'><span class='" + menuInfo.iconUrl + "'></span></dt>";
					
					// if (menuInfo.menuType != "G") { //기본 메뉴는 아이콘 변경이 불가능함					
					menusHTML += "<dd class='admenuIcon_up iconBtn'><spring:message code='ezNewPortal.t075' /></dd>";
					// }
					
					menusHTML += "</dl><table class='iconTable01' border='0' cellpadding='0' cellspacing='0' style='clear:none;'>";
					menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t076' /></th>";
					
					if (menuInfo.menuUsed) {
						menusHTML += "<td colspan='2' class='menuIconTD'><label class='switch menuSwitch' style='vertical-align: bottom;'><input type='checkbox' checked><span class='slider round'></span></label></td></tr>";
					} else {
						menusHTML += "<td colspan='2' class='menuIconTD'><label class='switch menuSwitch' style='vertical-align: bottom;'><input type='checkbox'><span class='slider round'></span></label></td></tr>";
					}
					
					menusHTML += "<tr><th class='menuIconTH'>URL</th><td colspan='2' class='menuIconTD conUrl'><input type='text' class='admin_input' style='width:281px;' value='" +ReplaceText(ReplaceText(ConvertCharToEntityReference(menuInfo.menuUrl), '\"', "&#39;"), "\'", "&#34;") + "' maxlength='100'></td></tr>"
					menusHTML += "<tr><th rowspan='" + menuNames.length + "' class='menuIconTH'><spring:message code='ezNewPortal.t077' /></th>";
					
					var menuIconTD1 = "<spring:message code='ezNewPortal.t078' />";
					var menuIconTD2 = "<spring:message code='ezNewPortal.t079' />";
					var menuIconTD3 = "<spring:message code='ezNewPortal.t080' />";
					var menuIconTD4 = "<spring:message code='ezPortal.t4094' />";
					var menuIconTD5 = "<spring:message code='ezNewPortal.t079' />"; // 베트남어(사용시 추가)
 					var menuIconTD6 = "<spring:message code='ezNewPortal.t079' />"; // 인도네시아어(사용시 추가)
					
					var langOrder = [1, 2, 3, 4, 5, 6];
					var langType = ['1', '2', '3', '4', '5', '6'];
					
					var menuNames1 = ""; // 한국어
					var menuNames2 = ""; // 영어
					var menuNames3 = ""; // 일본어
					var menuNames4 = ""; // 중국어
					var menuNames5 = ""; // 베트남어
					var menuNames6 = ""; // 인도네시아어
					
					function clearMenuNames(menuName) {
						return ReplaceText(ReplaceText(ConvertCharToEntityReference(menuName), '\"', "&#39;"), "\'", "&#34;");
					}
					
					function checkMenuLang(menuNames, lang) {
					  return menuNames.filter(function(item) {
						return item.menuLang == lang;
					  });
					}
					
					langType.forEach(function(lang) {
					var filteredMenu = checkMenuLang(menuNames, lang);
					
					if (filteredMenu.length > 0) {
						var menuName = filteredMenu[0].menuName;
						var clearMenuName = clearMenuNames(menuName);
						
						switch (lang) {
							case '1':
								menuNames1 = clearMenuName;
								break;
							case '2':
								menuNames2 = clearMenuName;
								break;
							case '3':
								menuNames3 = clearMenuName;
								break;
							case '4':
								menuNames4 = clearMenuName;
								break;
							case '5':
								menuNames5 = clearMenuName;
								break;
							case '6':
								menuNames6 = clearMenuName;
								break;
							default:
								break;
							}
						}
					});
					
					menuNames.forEach(function(item, index) {
						if (index != 0) {
							menusHTML += "<tr>";
						}
						menusHTML += "<td class='menuIconTD'>";
						menusHTML += "<spring:message code='ezNewPortal.t077' /> ("; 
						
						var country = "";
						var menuNameInputId = 1;
						var menuRealName = menuNames1;
						
						if (userLang == "1") { // 한국어
							langOrder.forEach(function(lang) {
								if (item.menuLang == lang) {
									switch (lang) {
										case 1:
											country = menuIconTD1;
											break;
										case 2:
											country = menuIconTD2;
											menuNameInputId = 2;
											menuRealName = menuNames2;
											break;
										case 3:
											country = menuIconTD3;
											menuNameInputId = 3;
											menuRealName = menuNames3;
											break;
										case 4:
											country = menuIconTD4;
											menuNameInputId = 4;
											menuRealName = menuNames4;
											break;
										case 5:
											country = menuIconTD5;
											menuNameInputId = 5;
											menuRealName = menuNames5;
											break;
										case 6:
											country = menuIconTD6;
											menuNameInputId = 6;
											menuRealName = menuNames6;
											break;
										default:
											break;
									}
								}
							});
						} else if (userLang == "2") { // 영어
							langOrder.forEach(function(lang) {
								if (item.menuLang == lang) {
									switch (lang) {
										case 1:
											country = menuIconTD2;
											menuNameInputId = 2;
											menuRealName = menuNames2;
											break;
										case 2:
											country = menuIconTD1;
											break;
										case 3:
											country = menuIconTD3;
											menuNameInputId = 3;
											menuRealName = menuNames3;
											break;
										case 4:
											country = menuIconTD4;
											menuNameInputId = 4;
											menuRealName = menuNames4;
											break;
										case 5:
											country = menuIconTD5;
											menuNameInputId = 5;
											menuRealName = menuNames5;
											break;
										case 6:
											country = menuIconTD6;
											menuNameInputId = 6;
											menuRealName = menuNames6;
											break;
										default:
											break;
									}
								}
							});
						} else if (userLang == "3") { // 일본어
							langOrder.forEach(function(lang) {
								if (item.menuLang == lang) {
									switch (lang) {
										case 1:
											country = menuIconTD3;
											menuNameInputId = 3;
											menuRealName = menuNames3;
											break;
										case 2:
											country = menuIconTD2;
											menuNameInputId = 2;
											menuRealName = menuNames2;
											break;
										case 3:
											country = menuIconTD1;
											break;
										case 4:
											country = menuIconTD4;
											menuNameInputId = 4;
											menuRealName = menuNames4;
											break;
										case 5:
											country = menuIconTD5;
											menuNameInputId = 5;
											menuRealName = menuNames5;
											break;
										case 6:
											country = menuIconTD6;
											menuNameInputId = 6;
											menuRealName = menuNames6;
											break;
										default:
											break;
									}
								}
							});
						} else if (userLang == "4") { // 중국어
							langOrder.forEach(function(lang) {
								if (item.menuLang == lang) {
									switch (lang) {
										case 1:
											country = menuIconTD4;
											menuNameInputId = 4;
											menuRealName = menuNames4;
											break;
										case 2:
											country = menuIconTD2;
											menuNameInputId = 2;
											menuRealName = menuNames2;
											break;
										case 3:
											country = menuIconTD1;
											break;
										case 4:
											country = menuIconTD3;
											menuNameInputId = 3;
											menuRealName = menuNames3;
											break;
										case 5:
											country = menuIconTD5;
											menuNameInputId = 5;
											menuRealName = menuNames5;
											break;
										case 6:
											country = menuIconTD6;
											menuNameInputId = 6;
											menuRealName = menuNames6;
											break;
										default:
											break;
									}
								}
							});
						} else if (userLang == "5") { // 베트남어
							langOrder.forEach(function(lang) {
								if (item.menuLang == lang) {
									switch (lang) {
										case 1:
											country = menuIconTD5;
											menuNameInputId = 5;
											menuRealName = menuNames5;
											break;
										case 2:
											country = menuIconTD2;
											menuNameInputId = 2;
											menuRealName = menuNames2;
											break;
										case 3:
											country = menuIconTD1;
											break;
										case 4:
											country = menuIconTD3;
											menuNameInputId = 3;
											menuRealName = menuNames3;
											break;
										case 5:
											country = menuIconTD4;
											menuNameInputId = 4;
											menuRealName = menuNames4;
											break;
										case 6:
											country = menuIconTD6;
											menuNameInputId = 6;
											menuRealName = menuNames6;
											break;
										default:
											break;
									}
								}
							});
						} else if (userLang == "6") { // 인도네시아어
							langOrder.forEach(function(lang) {
								if (item.menuLang == lang) {
									switch (lang) {
										case 1:
											country = menuIconTD6;
											menuNameInputId = 6;
											menuRealName = menuNames6;
											break;
										case 2:
											country = menuIconTD2;
											menuNameInputId = 2;
											menuRealName = menuNames2;
											break;
										case 3:
											country = menuIconTD1;
											break;
										case 4:
											country = menuIconTD3;
											menuNameInputId = 3;
											menuRealName = menuNames3;
											break;
										case 5:
											country = menuIconTD4;
											menuNameInputId = 4;
											menuRealName = menuNames4;
											break;
										case 6:
											country = menuIconTD5;
											menuNameInputId = 5;
											menuRealName = menuNames5;
											break;
										default:
											break;
									}
								}
							});
						}
						
						menusHTML += country + ")</td>";
						menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu";
						menusHTML += menuNameInputId + "' type='text' value='"
						menusHTML += menuRealName + "' maxlength='50'></td>";
						menusHTML += "</tr>";
					});
					
					menusHTML += "</table>";
					menusHTML += "<table class='iconTable02' border='0' cellpadding='0' cellspacing='0' style='clear:none;'>";
					
					// 2024-07-19 조수빈 - 웹인 경우 새 탭 / 새 창 / iframe으로 띄우는 옵션 설정 행 추가
					if (type != 'mobile') {
						menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewportal.openType' /></th><td class='menuIconTD'>";
						menusHTML += "<select id='menuOpenType' style='margin-left:10px'>";
						menusHTML += "<option value='tab' " + (menuInfo.openType == 1 ? "selected" : "") + "><spring:message code='ezNewportal.openNewTab' /></option>";
						menusHTML += "<option value='window' " + (menuInfo.openType == 2 ? "selected" : "") + "><spring:message code='ezNewportal.openNewWindow' /></option>";
						menusHTML += "<option value='iframe' " + (menuInfo.openType == 3 ? "selected" : "") + "><spring:message code='ezNewportal.openIframe' /></option>";
						menusHTML += "</select></td></tr>";
					}
					
					menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t081' /></th><td class='menuIconTD accessOK'><div>";
					
					if (menuAuthsY != null && menuAuthsY.length != 0) {
						var menuAuthsYList = "";
						
						menuAuthsY.forEach(function(item, index) {
							if (item.userType == 1) {
								menuAuthsYList += ", " + item.userName;
								menuAuthsYList += "(" + item.userDeptName + ")";
							} else if (item.userType == 0) {
								menuAuthsYList += ", " + item.userDeptName;
							} else {
								menuAuthsYList += ", " + item.userName;
							}
						});
						
						menusHTML += menuAuthsYList.substring(1) + "</div></td></tr>";
					}
					
					menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t082' /></th><td class='menuIconTD accessNO'><div>";
					
					if (menuAuthsN != null && menuAuthsN.length != 0) {
						var menuAuthsNList = "";
						
						menuAuthsN.forEach(function(item, index) {
							if (item.userType == 1) {
								menuAuthsNList += ", " + item.userName;
								menuAuthsNList += "(" + item.userDeptName + ")";
							} else if (item.userType == 0) {
								menuAuthsNList += ", " + item.userDeptName;
							} else {
								menuAuthsNList += ", " + item.userName;
							}
						});
						
						menusHTML += menuAuthsNList.substring(1) + "</div></td></tr>";
					}
					
					menusHTML += "</table>";
					menusHTML += "<div class='bottomBtn'><a class='btnA updateMenu'><spring:message code='ezNewPortal.t002' /></a><a class='btnA menuAuthBtn'><spring:message code='ezNewPortal.t086' /></a>";
					
					if (menuInfo.menuType == "A" || menuInfo.menuType == "MA") {
						menusHTML += "<a class='btnA deleteMenu'><spring:message code='ezNewPortal.t124' /></a>";
					}
					menusHTML += "</div></div></div></li>"
					
					var nowShowDetails = $(".menuDetails").children().attr("id");
					
					if (nowShowDetails == "menuDetails" + menuId) {
						$(".menuDetails").slideUp(function(){
							$(".menuDetails").remove();
						});
					} else {
						//나와있는 menuDetails를 제외하곤 다 지운다
						$(".menuDetails").slideUp(function(){
							$(".menuDetails").not("#menuLi" + menuId).remove();
						});
					}
					
					if (nowShowDetails != "menuDetails" + menuId) {
						if (nowShowDetails == undefined) {
							//$("#menu" + menuId).after(menusHTML);
							$("#menuAdd").after(menusHTML);
							$(".menuDetails").slideDown();
						} else {
							//$("#menu" + menuId).after(menusHTML);
							$("#menuAdd").after(menusHTML);
							$(".menuDetails").slideDown();
						}
					}
					
					//기본메뉴일때 연결 URL변경 불가능
					if (menuInfo.menuType == "G" || menuInfo.menuType == "MG") { //기본 메뉴는 아이콘 변경이 불가능함
						$(".conUrl").find("input[type='text']").attr('readonly','readonly');
					}
					
					//닫기버튼 설정
					$(".close").on("click", function(){
						$(".menuDetails").slideUp();
						$(".menuDetails").attr("class", "menuDetails hideDetails");
					});
					
					//아이콘등록 버튼 설정
					$(".iconBtn").on("click", uploadIconImg);
					
					//권한설정 기능
					$(".menuAuthBtn").on("click", {"menuId" : menuInfo.menuId, "companyId" : companyValue, "mode" : "view"}, openMenuAuth);
					
					//저장기능 
					$(".updateMenu").on("click", {"menuId" : menuInfo.menuId, "menuType" : menuInfo.menuType}, updateMenu);
					
					if (menuInfo.menuType == "A" || menuInfo.menuType == "MA") {
						$(".deleteMenu").on("click", {"menuId" : menuInfo.menuId}, deleteMenu);
					}
					
					//메뉴 상세보기 iconTable01 height 지정
					$(".iconTable01, .iconTable02").css("height", (106 + 33 * (menuNames.length -1)) + "px");
				}
			}
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				menuId : menuId,
				companyId : companyValue
			});
			 
			request.send(data);
		}
		
		var closeMenuDetail = function(event) {
			//그냥 모든 메뉴디테일을 닫아버린다
			$(".menuDetails").slideUp();
			$(".menuDetails").remove();
		}
		
		$('html').click(function(e) {
			//영역 외 삭제
			var obj = e.target;
			var flag = false;
			var elemArr = ["menu", "admin_menuDL", "admin_menu_content", "menuOrderResetButton", "companySelect", "menuAdd"];
			//console.log(obj.tagName);
			if (obj.tagName == "HTML" || obj.tagName == "UL" || obj.tagName == "LI" || obj.tagName == "H1") {
				closeMenuDetail();
				return false;
			}
			/* console.log(obj.className);
			while(elemArr.indexOf(obj.className) == -1){
				obj = obj.parentElement;
				console.log(obj);
				if(obj.tagName == "HTML"){
					closeMenuDetail();
					break;
				}
			} */
		}); 

		var updateMenu = function(event) {
			var menuId = event.data.menuId;
			var menuNameList = [];
			var menuNames = $(".menuNameInput");
			var menuNamesCount = menuNames.length;
			var menuType = event.data.menuType;
			var menuNameEmptyNum = 0;
			//특수문자  체크 (앤드&, 소괄호(), 슬래쉬/만 허용함)
			var special_pattern = /[\{\}\[\]?.,;:|*~`!^\-_+<>@\#$%\\\=\'\"]/g;
			const regex = new RegExp(special_pattern);
			
			//메뉴 사용 유무
			var menuUsed = $(".menuSwitch").find("input[type='checkbox']").prop("checked");
			
			//연결 urlz
			var menuUrl = $(".conUrl").find("input[type='text']").val();
			menuUrl = $.trim(menuUrl);
			
			if (type == 'mobile' && menuUrl.indexOf('/mobile/') != 0) {
				alert("<spring:message code='ezNewPortal.mobileUrl' />");
				return;
			}
			
			if (menuUrl == "" || menuUrl == null) {
				alert("<spring:message code='ezNewPortal.t083' />");
				return;
			}
			
			if (menuAuths.length == 0 || menuAuths == null || menuAuths == "[]") {
				alert("<spring:message code='ezNewPortal.t084' />");
				return;
			}

			// 2024-08-05 조수빈 - 모바일은 해당 기능을 사용하지 않으나 not null인 값이므로 임의로 tab에 해당하는 1을 넣도록 한다.
			var openType = document.getElementById("menuOpenType") ? document.getElementById("menuOpenType").value : 'tab';
			var mapping = {'tab': 1, 'window': 2, 'iframe': 3};
			
			//아이콘
			var iconUrl = $(".menuIcon").find("span").attr("class");
			
			var menuInfo = {
				"menuId" : menuId,
				"menuUsed" : menuUsed,
				"menuUrl" : menuUrl,
				"menuType" : menuType,
				"iconUrl" : iconUrl,
				"openType" : mapping[openType]
			}
			
			for (var i = 0; i < menuNamesCount; i++) {
				var menuName = menuNames[i];
				var menuLang = menuName.id;
				menuLang = menuLang.substring(4);
				
				if (regex.test($.trim(menuName.value))) {
					alert("<spring:message code='ezNewPortal.csj01' />");
				    return;
				}
				
				if ($.trim(menuName.value) == "") {
					menuNameEmptyNum++;
				}
				
				menuNameList.push({"menuLang" : menuLang, "menuId" : menuId, "menuName" : $.trim(menuName.value)});
			}
			
			if (menuNameEmptyNum >= menuNamesCount) {
				alert("<spring:message code='ezNewPortal.t085' />");
				return;
			}
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updateMenu.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { 
				getMenus();
				//menuAuths = [];
			}
			
			request.onerror = function() {}
			
			if (typeof menuAuths == "string") {
				menuAuths = JSON.parse(menuAuths);
			}
			
			var data = JSON.stringify({
				menuId : menuId,
				companyId : companyValue,
				menuNames : menuNameList,
				menuInfo : menuInfo, 
				menuAuths : menuAuths,
				type : type
			});
			 
			request.send(data);
		}
		
		var openMenuAdd = function() {
			$(".menuChoice").removeClass("menuChoice");
			
			menuAuths = [];
			
			var menusHTML = "<li class='menuDetails' id='menuLiNew'>";
			menusHTML += "<div class='admin_menu' id='menuDetailsNew'>";
			menusHTML += "<dl class='admin_menuDL'><dt class='admin_menuTit'>&nbsp;</dt><dd class='admin_menuX'></dd></dl>";
			menusHTML += "<div class='admin_menu_content'>";
			menusHTML += "<dl class='adminMenu_icon'><dt class='admenuIcon menuIcon'><span></span></dt>";
			menusHTML += "<dd class='admenuIcon_up iconBtn'><spring:message code='ezNewPortal.t075' /></dd></dl>";
			menusHTML += "<table class='iconTable01' border='0' cellpadding='0' cellspacing='0' style='clear:none'>";
			menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t076' /></th><td colspan='2' class='menuIconTD'><label class='switch menuSwitch' style='vertical-align: bottom;'><input type='checkbox'><span class='slider round'></span></label></td></tr>";
			menusHTML += "<tr><th class='menuIconTH'>URL</th><td colspan='2' class='menuIconTD conUrl'><input type='text' class='admin_input' style='width:281px;' maxlength='100'></td></tr>";
			
			if (usePrimaryLangOnly == "YES") {
				menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t077' /></th>";
				if (primary == "1") {
					menusHTML += "<td class='menuIconTD'><spring:message code='ezNewPortal.t077' />(<spring:message code='ezNewPortal.t078' />)</td>";
					menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu1' type='text' maxlength='50'></td>";
					menusHTML += "</tr>";	
				} else if (primary == "2") {
					menusHTML += "<td class='menuIconTD'><spring:message code='ezNewPortal.t077' />(<spring:message code='ezNewPortal.t079' />)</td>";
					menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu1' type='text' maxlength='50'></td>";
					menusHTML += "</tr>";	
				} else if (primary == "3") {
					menusHTML += "<td class='menuIconTD'><spring:message code='ezNewPortal.t077' />(<spring:message code='ezNewPortal.t080' />)</td>";
					menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu1' type='text' maxlength='50'></td>";
					menusHTML += "</tr>";	
				} else if (primary == "4") {
					menusHTML += "<td class='menuIconTD'><spring:message code='ezNewPortal.t077' />(<spring:message code='ezNewPortal.t080' />)</td>";
					menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu1' type='text' maxlength='50'></td>";
					menusHTML += "</tr>";	
				}
			} else {
				var mainTitle = "<spring:message code='ezNewPortal.t078' />";
				var subTitle1 = "<spring:message code='ezNewPortal.t079' />";
				var subTitle2 = "<spring:message code='ezNewPortal.t080' />";
				var subTitle3 = "<spring:message code='ezPortal.t4094' />";
				
				var mainTitleId = "menu1";
				var subTitle1Id = "menu2";
				var subTitle2Id = "menu3";
				var subTitle3Id = "menu4";
				
				var subTitleTr1Id = "en";
				var subTitleTr2Id = "ja";
				var subTitleTr3Id = "zh";
				
				if (primary == "2") {
					mainTitle = "<spring:message code='ezNewPortal.t079' />";
					subTitle1 = "<spring:message code='ezNewPortal.t078' />";
					subTitle2 = "<spring:message code='ezNewPortal.t080' />";
					subTitle3 = "<spring:message code='ezPortal.t4094' />";
					
					mainTitleId = "menu2";
					subTitle1Id = "menu1";
					subTitle2Id = "menu3";
					subTitle3Id = "menu4";
					
					subTitleTr1Id = "ko";
					subTitleTr2Id = "ja";
					subTitleTr3Id = "zh";
				} else if (primary == "3") {
					mainTitle = "<spring:message code='ezNewPortal.t080' />";
					subTitle1 = "<spring:message code='ezNewPortal.t078' />";
					subTitle2 = "<spring:message code='ezNewPortal.t079' />";
					subTitle3 = "<spring:message code='ezPortal.t4094' />";
					
					mainTitleId = "menu3";
					subTitle1Id = "menu1";
					subTitle2Id = "menu2";
					subTitle3Id = "menu4";
					
					subTitleTr1Id = "ko";
					subTitleTr2Id = "en";
					subTitleTr3Id = "zh";
				} else if (primary == "4") {
					mainTitle = "<spring:message code='ezPortal.t4094' />";
					subTitle1 = "<spring:message code='ezNewPortal.t078' />";
					subTitle2 = "<spring:message code='ezNewPortal.t079' />";
					subTitle3 = "<spring:message code='ezNewPortal.t080' />";
					
					mainTitleId = "menu4";
					subTitle1Id = "menu1";
					subTitle2Id = "menu2";
					subTitle3Id = "menu3";
					
					subTitleTr1Id = "ko";
					subTitleTr2Id = "en";
					subTitleTr3Id = "ja";
				}
				
				// 2023-11-23 조소정 - 일본어, 중국어 사용 여부에 따라 메뉴명 rowspan 및 height 조정
				var menuLength = 0;
				if (useJapanese === "YES" && useChinese === "YES") {
					  menuLength = 4;
				} else if (useJapanese === "YES" && useChinese === "NO") {
				  menuLength = 3;
				} else if (useJapanese === "NO" && useChinese === "YES") {
				  menuLength = 3;
				} else {
				  menuLength = 2;
				}

				menusHTML += "<tr><th rowspan=" + menuLength + " class='menuIconTH'><spring:message code='ezNewPortal.t077' /></th>";
				menusHTML += "<td class='menuIconTD'><spring:message code='ezNewPortal.t077' />(" + mainTitle + ")</td>";
				menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='" + mainTitleId + "' type='text' maxlength='50'></td>";
				menusHTML += "</tr>";
				menusHTML += "<tr id='" + subTitleTr1Id + "'><td class='menuIconTD'><spring:message code='ezNewPortal.t077' />(" + subTitle1 + ")</td>";
				menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='" + subTitle1Id + "' type='text' maxlength='50'></td>";
				menusHTML += "</tr>";
				menusHTML += "<tr id='" + subTitleTr2Id + "'><td class='menuIconTD'><spring:message code='ezNewPortal.t077' />(" + subTitle2 + ")</td>";
				menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='" + subTitle2Id + "' type='text' maxlength='50'></td>";
				menusHTML += "</tr>";
				menusHTML += "<tr id='" + subTitleTr3Id + "'><td class='menuIconTD'><spring:message code='ezNewPortal.t077' />(" + subTitle3 + ")</td>";
				menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='" + subTitle3Id + "' type='text' maxlength='50'></td>";
				menusHTML += "</tr>";
			}
			menusHTML += "</table>";
			menusHTML += "<table class='iconTable02' border='0' cellpadding='0' cellspacing='0' style='clear:none'>";

			// 2024-07-19 조수빈 - 웹인 경우 새 탭 / 새 창 / iframe으로 띄우는 옵션 설정 행 추가
			if (type != 'mobile') {
				menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewportal.openType' /></th><td class='menuIconTD'>";
				menusHTML += "<select id='menuOpenType' style='margin-left:10px'>";
				menusHTML += "<option value='tab'><spring:message code='ezNewportal.openNewTab' /></option>";
				menusHTML += "<option value='window'><spring:message code='ezNewportal.openNewWindow' /></option>";
				menusHTML += "<option value='iframe'><spring:message code='ezNewportal.openIframe' /></option>";
				menusHTML += "</select></td></tr>";
			}
			
			menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t081' /></th><td class='menuIconTD accessOK'><div></div></td></tr>";
			menusHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t082' /></th><td class='menuIconTD accessNO'><div></div></td></tr></table>";
			menusHTML += "<div class='bottomBtn'><a class='btnA addMenuBtn'><spring:message code='ezNewPortal.t002' /></a><a class='btnA menuAuthBtn'><spring:message code='ezNewPortal.t086' /></a>";
			menusHTML += "</div></div></div></li>"
			
			var nowShowDetails = $(".menuDetails").children().attr("id");
			
			if (nowShowDetails == "menuDetailsNew") { 
				$(".menuDetails").slideUp(function(){
					$(".menuDetails").remove();
				});
			} else {
				$(".menuDetails").slideUp(function(){
					$(".menuDetails").not("#menuLiNew").remove();
				});
			}
			
			if (nowShowDetails != "menuDetailsNew") {
				if (nowShowDetails == undefined) {
					$("#menuAdd").after(menusHTML);
					$(".menuDetails").slideDown();
				} else {
					$("#menuAdd").after(menusHTML);
					$(".menuDetails").slideDown();
				}
			}
			
			//닫기버튼 설정
			$(".close").on("click", function(){
				$(".menuDetails").slideUp();
				$(".menuDetails").attr("class", "menuDetails hideDetails");
			});
			
			//아이콘등록 버튼 설정
			$(".iconBtn").on("click", uploadIconImg);

			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			//권한설정 기능
			$(".menuAuthBtn").on("click", {"menuId" : null, "companyId" : companyValue, "mode" : "new"}, openMenuAuth);
			
			//저장기능
			$(".addMenuBtn").on("click", insertMenu);
			
			//메뉴 추가 iconTable01 height 지정
			$(".iconTable01, .iconTable02").css("height", (usePrimaryLangOnly == "YES" ? 106 : (106 + 33 * (menuLength -1))) + "px");
			
			if (useJapanese == "NO") {
				document.getElementById("ja").style.display = "none";
			}
			
			if (useChinese == "NO") {
				document.getElementById("zh").style.display = "none";
			}
		}
		
		var insertMenu = function() {
			var menuNameList = [];
			var menuNames = $(".menuNameInput");
			var menuNamesCount = menuNames.length;
			var menuNameEmptyNum = 0;
			// 특수문자 체크 (앤드&, 소괄호(), 슬래쉬/만 허용함)
			var special_pattern = /[\{\}\[\]?.,;:|*~`!^\-_+<>@\#$%\\\=\'\"]/g;
			const regex = new RegExp(special_pattern);
			
			//메뉴 사용 유무
			var menuUsed = $(".menuSwitch").find("input[type='checkbox']").prop("checked");
			
			//연결 url
			var menuUrl = $(".conUrl").find("input[type='text']").val();
			menuUrl = $.trim(menuUrl);
			
			if (menuUrl == "" || menuUrl == null) {
				alert("<spring:message code='ezNewPortal.t083' />");
				return;
			}
			
			// 2024-08-05 조수빈 - 모바일은 해당 기능을 사용하지 않으나 not null인 값이므로 임의로 tab에 해당하는 1을 넣도록 한다.
			var openType = document.getElementById("menuOpenType") ? document.getElementById("menuOpenType").value : 'tab';
			var mapping = {'tab': 1, 'window': 2, 'iframe': 3};
			
			//아이콘
			var iconUrl = $(".menuIcon").find("span").attr("class");
			
			if (iconUrl == null || iconUrl == "") {
				alert("<spring:message code='ezNewPortal.adminMenu.hth01' />");
				return;
			}
			
			var menuInfo = {
				"menuUsed" : menuUsed,
				"menuUrl" : menuUrl,
				"menuType" : type == "mobile" ? "MA" : "A",
				"iconUrl" : iconUrl,
				"openType" : mapping[openType]
			}
			
			for (var i = 0; i < menuNamesCount; i++) {
				var menuName = menuNames[i];
				var menuLang = menuName.id;
				menuLang = menuLang.substring(4);
				
				if (regex.test($.trim(menuName.value))) {
					alert("<spring:message code='ezNewPortal.csj01' />");
				    return;
				}
				
				if ($.trim(menuName.value) == "") {
					menuNameEmptyNum++;
				}
				
				menuNameList.push({"menuLang" : menuLang, "menuName" : $.trim(menuName.value)});
			}
			
			if (menuNameEmptyNum >= menuNamesCount) {
				alert("<spring:message code='ezNewPortal.t085' />");
				return;
			}
			
			if (menuAuths.length == 0 || menuAuths == null || menuAuths == "[]") {
				alert("<spring:message code='ezNewPortal.t084' />");
				return;
			}
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/insertMenu.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { 
				getMenus();
			}
			
			if (typeof menuAuths == "string") {
				menuAuths = JSON.parse(menuAuths);
			}
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				companyId : companyValue,
				menuNames : menuNameList,
				menuInfo : menuInfo,
				menuAuths : menuAuths
			});
			 
			request.send(data);
		}
		
		var deleteMenu = function (event) {
			var response = confirm("<spring:message code='ezNewPortal.t087' />");
			
			if (response) {
				var menuId = event.data.menuId;
				
				var companiesObj = document.getElementById("ListCompany");
				var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
				
				var request = new XMLHttpRequest();
				request.open('POST', '/admin/ezNewPortal/deleteMenu.do', true);
				request.setRequestHeader('content-type', 'application/json');
				
				request.onload = function() { getMenus(); }
				
				request.onerror = function() {}
				
				var data = JSON.stringify({
					menuId : menuId,
					companyId : companyValue,
					type : type
				});
				 
				request.send(data);
			} else {
				return;
			}
			
		}
		
		var uploadIconImg = function() {
			var height = window.screen.availHeight;
			var width = window.screen.availWidth;
			var top = (height - 500) / 2;
			var left = (width - 765) / 2;
			   
			window.open("/admin/ezNewPortal/selectMenuIcon.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=470,width=660,top=" + top + ",left=" + left, "");
		}
		
		var updateMenuOrder = function() {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			//메뉴 순서 가져오기
			var menuList = $(".menu");
			var menuListCount = menuList.length;
			var menuOrderList = [];
			
			for (var i = 0; i < menuListCount; i++) {
				var menuId = menuList[i].id;
				menuId = menuId.substring(4);
				var order = i + 1;
				
				menuOrderList.push({"companyOrder" : order, "menuId" : menuId});
			}
			
			//ajax로 메뉴 순서지정
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updateMenuOrder.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { }
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				companyId : companyValue,
				menus : menuOrderList
			});
			 
			request.send(data);
		}
		
		var openMenuAuth = function(event) {
			var mode = event.data.mode;

			var url = "/admin/ezNewPortal/portalMenuAuth.do?menuId=" + event.data.menuId + "&companyId=" + event.data.companyId + "&mode=menu";
			var OpenWin = window.open(url, "", GetOpenWindowfeature(980, 650));
		    	try { OpenWin.focus(); } catch (e) { }
		}
		
		var topMenuDisplayModeSave = function () {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var topMenuDisplayModeBtn = document.getElementsByName('topMenuDisplayMode');
		    var type = 0;
		    for (let i = 0; i < topMenuDisplayModeBtn.length; i++) {
		        if (topMenuDisplayModeBtn[i].checked) {
		        	type = topMenuDisplayModeBtn[i].value;
		        	break;
		        }
		    }
			
			$.ajax({
				type: "POST",
				url: "/admin/ezNewPortal/updateTopMenuDisplayModeForCompany.do",
				dataType: "text",
				data : {
					companyId : companyValue,
					type : type
				},
				async: true,
				success: function(result) {
					alert("<spring:message code='ezPortal.t121'/>");
				},
				error: function (xhr, status, e){
					
				}
			});
		}
		
		function changePosition(dragElem, dropElem) {
			var menuListChildren = $("#menuList li");
			var dragElemIndex = menuListChildren.index(dragElem);
			var dropElemIndex = menuListChildren.index(dropElem);
			var menuList = $('#menuList');
			
			dragElem.insertAfter(menuList.children().eq(dropElemIndex));
			if (dragElemIndex > dropElemIndex) {
				dropElem.insertAfter(menuList.children().eq(dragElemIndex));
			} else {
				if (dragElemIndex - 1 < 0) {
					dropElem.insertBefore(menuList.children().eq(0));
				} else {
					dropElem.insertAfter(menuList.children().eq(dragElemIndex - 1));
				}
			}
			
			dragElem.css({
				left: '0',
			    top: '0'
			});
			
			dropElem.css({
				left: '0',
			    top: '0'
		    });
		}

	</script>
</html>