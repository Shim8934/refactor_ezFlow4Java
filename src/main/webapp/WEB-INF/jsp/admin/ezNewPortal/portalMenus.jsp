<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>portalMenus</title>
		<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
		<style type="text/css">
			body {background-color : white;}
			.ui-sortable{ margin:0px; padding:0px;}
			.menu, .menuAdd {cursor:pointer; vertical-align:top;display : inline-block;width : 100px; border : 1px solid #d9d9d9; margin :10px 5px 0px 0px; height:122px}
			#menuAdd {border : 1px dashed #aaaaaa;}
			.menu dl dt, .menuAdd dl dt {text-align : center;display : block;height : 42px;margin : 0px;	padding : 0px;}
			.menu dl dd, .menuAdd dl dd {display:table-cell; width : 98px; height:56px; margin:0px; padding:0px 5px; text-align:center; vertical-align:middle; font-size:15px; font-weight:bold; letter-spacing:-1px;}
			span.icon_topmenu {margin-top : 20px;}
			.menuUsed {background-color : #fff;}
			.menuUsed_on{color: #0470e3; border-color: #b9d7f6; background: #f1f8ff;}
			.menuNotUsed {background-color : #cbcbcb;}
			.menuDetails {list-style:none;display : none; float:left; width:98%; position : relative;}
			.menuTitle {margin : 10px;}
			.menuTitle span {font-size : 18px; font-weight:bold;}
			.menuDetails hr {display:block; width:99%;}
			.menuIconInfo {display:inline-block; margin:43px 23px 23px 23px;}
			.menuIcon {width:100px;height:100px;border:1px solid black;margin-bottom:10px;text-align:center;vertical-align:middle;}
			.menuIcon span, .menuIcon img {margin:23px 26px;}
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
			.updateMenu, .addMenu {float : right; margin-right:20px;}
			.btnpositionJsp {margin-top : 0px;padding:0px;}
			.hideDetails {display : none;}
			.menuSortable {display : inline-block;}
			dt img {width:21px;height:21px;margin-top:20px;}
			.menuIcon img {width:21px;height:21px;}
			.deleteMenu {display:inline-block;margin-left:50px;vertical-align:top;margin-top:-3px;}
			.accessOK div, .accessNO div {margin-left:15px;display:inline-block;}
			.menuChoice {background: #edf7ff; border: 1px solid #2196f3; color: #0470e3;}
		</style>
	</head>
	
	<body class="mainbody">
		<h1>
			메뉴관리
			<select class="companySelect" id="ListCompany"></select>
		</h1>
		
		<div id="mainmenu">
			<ul style="margin-top: 15px;">
				<li id="menuOrderReset"><span>메뉴 순서 초기화</span></li>
			</ul>
		</div>
		<ul id="menuList">
		</ul>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	<script type="text/javascript">
		var menuAuths = [];
		
		$(function(){
			getCompanies();
			getMenus();
			document.getElementById("menuOrderReset").addEventListener("click", resetMenuOrder);
		});
		
		var resetMenuOrder = function() {
		}
		
		var getCompanies = function() {
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getCompanies.do', false);
			request.setRequestHeader('Content-Type', 'application/json');
			var companiesHTML = "";
	
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					
					var userCompany = result.userCompany;
					var companyList = result.list;
					
					companyList.forEach(function (item, index) {
						companiesHTML += "<option value=" + item.cn + ((item.cn == userCompany) ? ' selected>' : '>') + item.displayName + "</option>";
					});
					
					document.getElementById("ListCompany").innerHTML = companiesHTML;
					
					document.getElementById("ListCompany").addEventListener('change', function() {
						getMenus();
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
					
					menuList.forEach(function (item, index) {
						menusHTML += "<li class='menu' id='menu" + item.menuId + "'>";
						menusHTML += "<dl>";
						menusHTML += "<dt><span class='" + item.iconUrl + "'>";
						menusHTML += "</span></dt>";
						menusHTML += "<dd>" + item.menuName + "</dd>";
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
					$("#menuList").sortable({ 
						//handle : ".menuSortable",
						items: "li.menu",
						start : function(event, ui) {
							//$(".menuDetails").css("display", "none");
							$(".menuDetails").remove();
							
						},
						update : function(event, ui) {
							updateMenuOrder();
						}
					});
					
					$("#menuList").disableSelection();
					$("#menuList").on("sortstart", function( event, ui ) { ui.placeholder.css("width","100px"); });
					//메뉴추가버튼
					$("#menuAdd").on("click", openMenuAdd);
				}
			};
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				companyId : companyValue
			});
			 
			request.send(data);
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
					menusHTML += "<dt class='admin_menuTit'>" + menuInfo.menuName + "</dt><dd class='admin_menuX'></dd></dl>";
					
					menusHTML += "<div class='admin_menu_content'>";
					menusHTML += "<dl class='adminMenu_icon'><dt class='admenuIcon menuIcon'><span class='" + menuInfo.iconUrl + "'></span></dt>";
					
					if (menuInfo.menuType != "G") { //기본 메뉴는 아이콘 변경이 불가능함					
						menusHTML += "<dd class='admenuIcon_up iconBtn'>아이콘 등록</dd>";
					}
					
					menusHTML += "</dl><table class='iconTable01' border='0' cellpadding='0' cellspacing='0' style='clear:none'>";
					menusHTML += "<tr><th class='menuIconTH'>메뉴 사용</th><td colspan='2' class='menuIconTD'><label class='switch menuSwitch'><input type='checkbox'><span class='slider round'></span></label></td></tr>";
					menusHTML += "<tr><th rowspan='3' class='menuIconTH'>메뉴명</th>";
					
					menuNames.forEach(function(item, index) {
						if (index != 0) {
							menusHTML += "<tr>";
						}
						menusHTML += "<td class='menuIconTD'>";
						menusHTML += "메뉴명 ("; 
						
						var country = "";
						if (item.menuLang == 1) {
							country = "한국어";
						} else if (item.menuLang == 2) {
							country = "영어";
						} else if (item.menuLang == 3) {
							country = "일본어";
						}
						
						menusHTML += country + ")</td>";
						menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu" +  item.menuLang + "' type='text' value='" + item.menuName + "' maxlength='50'></td>";
						menusHTML += "</tr>";
					});
					
					menusHTML += "<tr><th class='menuIconTH'>URL</th><td colspan='2' class='menuIconTD conUrl'><input type='text' class='admin_input' style='width:281px;' value='" + menuInfo.menuUrl + "' maxlength='100'></td></tr></table>";
					menusHTML += "<table class='iconTable02' border='0' cellpadding='0' cellspacing='0' style='clear:none'>";
					menusHTML += "<tr><th class='menuIconTH'>접근허용</th><td class='menuIconTD accessOK'>";
					
					if (menuAuthsY != null && menuAuthsY.length != 0) {
						var menuAuthsYList = "";
						
						menuAuthsY.forEach(function(item, index) {
							if (item.userType) {
								menuAuthsYList += ", " + item.userName;
								menuAuthsYList += "(" + item.userDeptName + ")";
							} else {
								menuAuthsYList += ", " + item.userDeptName;
							}
						});
						
						menusHTML += menuAuthsYList.substring(1) + "</td></tr>";
					}
					
					menusHTML += "<tr><th class='menuIconTH'>접근불가</th><td class='menuIconTD accessNO'>";
					
					if (menuAuthsN != null && menuAuthsN.length != 0) {
						var menuAuthsNList = "";
						
						menuAuthsN.forEach(function(item, index) {
							if (item.userType) {
								menuAuthsNList += ", " + item.userName;
								menuAuthsNList += "(" + item.userDeptName + ")";
							} else {
								menuAuthsNList += ", " + item.userDeptName;
							}
						});
						
						menusHTML += menuAuthsNList.substring(1) + "</td></tr>";
					}
					
					menusHTML += "</table>";
					menusHTML += "<div class='bottomBtn'><a class='btnA updateMenu'>저장</a><a class='btnA menuAuthBtn'>권한 설정</a>";
					
					if (menuInfo.menuType == "A") {
						menusHTML += "<a class='btnA deleteMenu'>메뉴 삭제</a>";
					}
					menusHTML += "</div></div></div></li>"
					
					/* if (menuInfo.menuType == "A") {
						menusHTML += "<div class='btnpositionJsp deleteMenu'><a class='imgbtn deleteMenuBtn'><span>메뉴 삭제</span></a></div>";
					} */
					
					/* menusHTML += "<div id='close' class='close'><ul><li><span></li></ul></div>";
					menusHTML += "</div>";
					menusHTML += "<hr/>";
					menusHTML += "<div class='btnpositionJsp updateMenu'><a class='imgbtn updateMenuBtn'><span>저장</span></a></div>";
					menusHTML += "<div class='menuIconInfo'>";
					menusHTML += "<div class='menuIcon'>";
					menusHTML += "<span class='" + menuInfo.iconUrl + "'></span>";
					menusHTML += "</div>";
					
					if (menuInfo.menuType != "G") { //기본 메뉴는 아이콘 변경이 불가능함
						menusHTML += "<div class='btnpositionJsp iconBtn'><a class='imgbtn'><span>아이콘등록</span></a></div>";
					}
					
					menusHTML += "</div>";
					menusHTML += "<div class='menuInfo'>";
					menusHTML += "<ul>";
					menusHTML += "<li class='menuSwitch'>[메뉴 사용]<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>";
					menusHTML += "<li class='menuName'>[메뉴명]<table class='menuNameTbl'>"
					
					menuNames.forEach(function(item, index) {
						menusHTML += "<tr>";
						menusHTML += "<th>메뉴명("; 
						
						var country = "";
						if (item.menuLang == 1) {
							country = "한국어";
						} else if (item.menuLang == 2) {
							country = "영어";
						} else if (item.menuLang == 3) {
							country = "일본어";
						}
						
						menusHTML += country + ")</th>";
						menusHTML += "<td><input class='menuNameInput' id='menu" +  item.menuLang + "' type='text' value='" + item.menuName + "' maxlength='50'></td>";
						menusHTML += "</tr>";
					});
					
					menusHTML += "</table></li>";
					menusHTML += "<li class='conUrl'>[연결 URL]<input type='text' value='" + menuInfo.menuUrl + "' maxlength='100'></li>"
					menusHTML += "</ul></div>";
					menusHTML += "<div class='menuAuth'><div class='btnpositionJsp menuAuthBtn'><a class='imgbtn'><span>권한 설정</span></a></div>";
					menusHTML += "<div class='accessOK'>[접근 허용]"
					menusHTML += "<div>";
					
					if (menuAuthsY != null && menuAuthsY.length != 0) {
						var menuAuthsYList = "";
						
						menuAuthsY.forEach(function(item, index) {
							if (item.userType) {
								menuAuthsYList += ", " + item.userName;
								menuAuthsYList += "(" + item.userDeptName + ")";
							} else {
								menuAuthsYList += ", " + item.userDeptName;
							}
						});
						
						menusHTML += menuAuthsYList.substring(1);
					}
					
					menusHTML += "</div>";
					menusHTML += "</div>";
					menusHTML += "<div class='accessNO'>[접근 불가]"
					menusHTML += "<div>"; */
					
					/* if (menuAuthsN != null && menuAuthsN.length != 0) {
						var menuAuthsNList = "";
						
						menuAuthsN.forEach(function(item, index) {
							if (item.userType) {
								menuAuthsNList += "," + item.userName;
								menuAuthsNList += "(" + item.userDeptName + ")";
							} else {
								menuAuthsNList += "," + item.userDeptName;
							}
						});
						
						menusHTML += menuAuthsNList.substring(1);
					}
					
					menusHTML += "</div>";
					menusHTML += "</div>";
					menusHTML += "</div>";
					menusHTML += "</div>";
					menusHTML += "</li>"; */
					
					var nowShowDetails = $(".menuDetails").children().attr("id");
		
					if (nowShowDetails == "menuDetails" + menuId) { 
						$(".menuDetails").slideUp(function(){
							$(".menuDetails").remove();
						});
					} else {
						$(".menuDetails").slideUp(function(){
							$(".menuDetails").not("#menuLi" + menuId).remove();
						});
					}
					
					if (nowShowDetails != "menuDetails" + menuId) {
						if (nowShowDetails == undefined) {
							//$("#menu" + menuId).after(menusHTML);
							$("#menuAdd").after(menusHTML);
							
							if (menuInfo.menuUsed) {
								$("#menuDetails" + menuInfo.menuId).find(".menuSwitch").find("input[type='checkbox']").prop("checked", true);
							}
							
							$(".menuDetails").slideDown();
						} else {
							//$("#menu" + menuId).after(menusHTML);
							$("#menuAdd").after(menusHTML);

							if (menuInfo.menuUsed) {
								$("#menuDetails" + menuInfo.menuId).find(".menuSwitch").find("input[type='checkbox']").prop("checked", true);
							}
							
							$(".menuDetails").slideDown();
						}
					}
					
					//기본메뉴일때 연결 URL변경 불가능
					if (menuInfo.menuType == "G") { //기본 메뉴는 아이콘 변경이 불가능함
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
					
					if (menuInfo.menuType == "A") {
						$(".deleteMenu").on("click", {"menuId" : menuInfo.menuId}, deleteMenu);
					}
				}
			}
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				menuId : menuId,
				companyId : companyValue
			});
			 
			request.send(data);
		}
		
		var updateMenu = function(event) {
			var menuId = event.data.menuId;
			var menuNameList = [];
			var menuNames = $(".menuNameInput");
			var menuNamesCount = menuNames.length;
			var menuType = event.data.menuType;
			var menuNameEmptyNum = 0;
			
			//메뉴 사용 유무
			var menuUsed = $(".menuSwitch").find("input[type='checkbox']").prop("checked");
			
			//연결 url
			var menuUrl = $(".conUrl").find("input[type='text']").val();
			
			if (menuUrl == "" || menuUrl == null) {
				alert("메뉴 URL을 입력해 주세요.");
				return;
			}
			
			//아이콘
			var iconUrl = $(".menuIcon").find("span").attr("class");
			
			var menuInfo = {
				"menuId" : menuId,
				"menuUsed" : menuUsed,
				"menuUrl" : menuUrl,
				"menuType" : menuType,
				"iconUrl" : iconUrl
			}
			
			for (var i = 0; i < menuNamesCount; i++) {
				var menuName = menuNames[i];
				var menuLang = menuName.id;
				menuLang = menuLang.substring(4);
				
				if (menuName.value == "") {
					menuNameEmptyNum++;
				}
				
				menuNameList.push({"menuLang" : menuLang, "menuId" : menuId, "menuName" : menuName.value});
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
			
			var data = JSON.stringify({
				menuId : menuId,
				companyId : companyValue,
				menuNames : menuNameList,
				menuInfo : menuInfo
				/* , menuAuths : menuAuths */
			});
			 
			request.send(data);
		}
		
		var openMenuAdd = function() {
			menuAuths = [];
			
			var menusHTML = "<li class='menuDetails' id='menuLiNew'>";
			menusHTML += "<div class='admin_menu' id='menuDetailsNew'>";
			menusHTML += "<dl class='admin_menuDL'><dt class='admin_menuTit'>&nbsp;</dt><dd class='admin_menuX'></dd></dl>";
			menusHTML += "<div class='admin_menu_content'>";
			menusHTML += "<dl class='adminMenu_icon'><dt class='admenuIcon menuIcon'><span></span></dt>";
			menusHTML += "<dd class='admenuIcon_up iconBtn'>아이콘 등록</dd></dl>";
			menusHTML += "<table class='iconTable01' border='0' cellpadding='0' cellspacing='0' style='clear:none'>";
			menusHTML += "<tr><th class='menuIconTH'>메뉴 사용</th><td colspan='2' class='menuIconTD'><label class='switch menuSwitch'><input type='checkbox'><span class='slider round'></span></label></td></tr>";
			menusHTML += "<tr><th rowspan='3' class='menuIconTH'>메뉴명</th>";
			menusHTML += "<td class='menuIconTD'>메뉴명(한국어)</td>";
			menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu1' type='text' maxlength='50'></td>";
			menusHTML += "</tr>";
			menusHTML += "<tr><td class='menuIconTD'>메뉴명(영어)</td>";
			menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu2' type='text' maxlength='50'></td>";
			menusHTML += "</tr>";
			menusHTML += "<tr><td class='menuIconTD'>메뉴명(일본어)</td>";
			menusHTML += "<td class='menuInput'><input class='admin_input menuNameInput' id='menu3' type='text' maxlength='50'></td>";
			menusHTML += "</tr>";
			menusHTML += "<tr><th class='menuIconTH'>URL</th><td colspan='2' class='menuIconTD conUrl'><input type='text' class='admin_input' style='width:281px;' maxlength='100'></td></tr></table>";
			menusHTML += "<table class='iconTable02' border='0' cellpadding='0' cellspacing='0' style='clear:none'>";
			menusHTML += "<tr><th class='menuIconTH'>접근허용</th><td class='menuIconTD accessOK'></td></tr>";
			menusHTML += "<tr><th class='menuIconTH'>접근불가</th><td class='menuIconTD accessNO'></td></tr></table>";
			menusHTML += "<div class='bottomBtn'><a class='btnA addMenuBtn'>저장</a><a class='btnA menuAuthBtn'>권한 설정</a>";
			menusHTML += "</div></div></div></li>"
			
			/* menusHTML += "<div class='btnpositionJsp addMenu'><a class='imgbtn addMenuBtn'><span>저장</span></a></div>";
			menusHTML += "<div class='menuIconInfo'>";
			menusHTML += "<div class='menuIcon'>";
			menusHTML += "<span></span>";
			menusHTML += "</div>";
			menusHTML += "<div class='btnpositionJsp iconBtn'><a class='imgbtn'><span>아이콘등록</span></a></div>";
			
			menusHTML += "</div>";
			menusHTML += "<div class='menuInfo'>";
			menusHTML += "<ul>";
			menusHTML += "<li class='menuSwitch'>[메뉴 사용]<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>";
			menusHTML += "<li class='menuName'>[메뉴명]<table class='menuNameTbl'>"
			
			//메뉴 언어
			menusHTML += "<tr>";
			menusHTML += "<th>메뉴명(한국어)</th>";
			menusHTML += "<td><input class='menuNameInput' id='menu1' type='text' maxlength='50'></td>";
			menusHTML += "</tr>";
			menusHTML += "<tr>";
			menusHTML += "<th>메뉴명(영어)</th>";
			menusHTML += "<td><input class='menuNameInput' id='menu2' type='text' maxlength='50'></td>";
			menusHTML += "</tr>";
			menusHTML += "<tr>";
			menusHTML += "<th>메뉴명(일본어)</th>";
			menusHTML += "<td><input class='menuNameInput' id='menu3' type='text' maxlength='50'></td>";
			menusHTML += "</tr>";
			
			menusHTML += "</table></li>";
			menusHTML += "<li class='conUrl'>[연결 URL]<input type='text' maxlength='100'></li>"
			menusHTML += "</ul></div>";
			menusHTML += "<div class='menuAuth'><div class='btnpositionJsp menuAuthBtn'><a class='imgbtn'><span>권한 설정</span></a></div>";
			menusHTML += "<div class='accessOK'>[접근 허용]<div></div></div>";
			menusHTML += "<div class='accessNO'>[접근 불가]<div></div></div>";
			menusHTML += "</div>";
			menusHTML += "</div>";
			menusHTML += "</li>"; */
			
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
		}
		
		var insertMenu = function() {
			var menuNameList = [];
			var menuNames = $(".menuNameInput");
			var menuNamesCount = menuNames.length;
			var menuNameEmptyNum = 0;
			
			//메뉴 사용 유무
			var menuUsed = $(".menuSwitch").find("input[type='checkbox']").prop("checked");
			
			//연결 url
			var menuUrl = $(".conUrl").find("input[type='text']").val();
			
			if (menuUrl == "" || menuUrl == null) {
				alert("메뉴 URL을 입력해 주세요.");
				return;
			}
			
			//아이콘
			var iconUrl = $(".menuIcon").find("span").attr("class");
			
			var menuInfo = {
				"menuUsed" : menuUsed,
				"menuUrl" : menuUrl,
				"menuType" : "A",
				"iconUrl" : iconUrl
			}
			
			for (var i = 0; i < menuNamesCount; i++) {
				var menuName = menuNames[i];
				var menuLang = menuName.id;
				menuLang = menuLang.substring(4);
				
				if (menuName.value == "") {
					menuNameEmptyNum++;
				}
				
				menuNameList.push({"menuLang" : menuLang, "menuName" : menuName.value});
			}
			
			if (menuNameEmptyNum >= menuNamesCount) {
				alert("하나 이상의 메뉴 이름을 입력해주세요.");
				return;
			}
			
			/* if (menuAuths.length == 0 || menuAuths == null) {
				alert("메뉴 접근 권한을 설정해 주세요.");
				return;
			} */
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/insertMenu.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { 
				getMenus();
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
			var response = confirm("메뉴를 삭제하면 메뉴와 관련된 포틀릿도 함께 삭제됩니다.\n메뉴를 삭제하시겠습니까?");
			
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
					companyId : companyValue
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
			   
			window.open("/admin/ezNewPortal/selectMenuIcon.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=342,width=500,top=" + top + ",left=" + left, "");
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
			
			request.onload = function() { getMenus(); }
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				companyId : companyValue,
				menus : menuOrderList
			});
			 
			request.send(data);
		}
		
		var openMenuAuth = function(event) {
			var mode = event.data.mode;

			var url = "/admin/ezNewPortal/portalMenuAuth.do?menuId=" + event.data.menuId + "&companyId=" + event.data.companyId;
			var OpenWin = window.open(url, "", GetOpenWindowfeature(980, 650));
		    	try { OpenWin.focus(); } catch (e) { }
		}

	</script>
</html>