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
			.menu, .menuAdd {cursor:pointer; vertical-align:top;display : inline-block;width : 100px; border : 1px solid #000000; margin : 10px;}
			.menu dl dt, .menuAdd dl dt {text-align : center;display : block;height : 42px;margin : 0px;	padding : 0px;}
			.menu dl dd, .menuAdd dl dd {display:table-cell; width : 98px; height:56px; margin:0px; padding:0px 5px; text-align:center; vertical-align:middle; font-size:15px; font-weight:bold; letter-spacing:-1px;}
			span.icon_topmenu {margin-top : 20px;}
			.menuUsed {background-color : #b0e4ff;}
			.menuNotUsed {background-color : #cbcbcb;}
			.menuDetails {list-style:none;display : none; float:left; width:98%; border:1px solid black;position : relative;}
			.menuTitle {margin : 10px;}
			.menuTitle span {font-size : 18px; font-weight:bold;}
			.menuDetails hr {display:block; width:99%;}
			.menuIconInfo {display:inline-block; margin:43px 23px 23px 23px;}
			.menuIcon {width:100px;height:100px;border:1px solid black;margin-bottom:10px;text-align:center;vertical-align:middle;}
			.menuIcon span, .menuIcon img {margin:36px;}
			.menuInfo {display:inline-block; vertical-align:top; margin-top:23px;}
			.menuInfo ul {padding:0px;}
			.menuInfo ul li {font-size:15px; font-weight:bold; display:block;margin-bottom:12px;}
			.menuAuth {display:inline-block;}
			.menuName table {margin-top:5px;}
			.menuName table tr {height : 34px;}
			.menuName table tr td input {width:300px; margin-left:10px;}
			.conUrl input {width:300px; margin-left:10px;}
			.menuName table th {border:none;background-color:white;font-size:13px;color:black;}
			.menuAuth {vertical-align:top;margin-top:23px;margin-left:150px;}
			.menuAuthBtn {display:inline-block}
			.accessOK, .accessNO {font-size:15px; font-weight:bold; margin-top:10px;}
			.updateMenu, .addMenu {float : right; margin-right:20px;}
			.btnpositionJsp {margin-top : 0px;padding:0px;}
			.hideDetails {display : none;}
			.menuSortable {display : inline-block;}
			dt img {width:21px;height:21px;margin-top:20px;}
			.menuIcon img {width:21px;height:21px;}
			.deleteMenu {display:inline-block;margin-left:50px;vertical-align:top;margin-top:-3px;}
			#menuAdd {border : 2px dashed black;}
			.accessOK div, .accessNO div {margin-left:15px;display:inline-block;}
			
			/* switch */
			.switch {position: absolute;display: inline-block;width: 60px;height: 25px;margin-left:26px; margin-top:-3px;}
			.switch input {opacity: 0;width: 0;height: 0;}
			.slider {  position: absolute;  cursor: pointer;  top: 0;  left: 0;  right: 0;  bottom: 0;  background-color: #ccc;  -webkit-transition: .4s;  transition: .4s;}
			.slider:before {  position: absolute;  content: "";  height: 17px;  width: 18px;  left: 4px;  bottom: 4px;  background-color: white;  -webkit-transition: .4s;  transition: .4s;}
			input:checked + .slider {  background-color: #2196F3;}
			input:focus + .slider { box-shadow: 0 0 1px #2196F3;}
			input:checked + .slider:before {-webkit-transform: translateX(26px); -ms-transform: translateX(26px);transform: translateX(26px);}
			/* Rounded sliders */
			.slider.round {border-radius: 15px;}
			.slider.round:before {border-radius: 50%;}
		</style>
	</head>
	
	<body class="mainbody">
		<h1>메뉴관리</h1>
		
		<div id="mainmenu">    
		    <span><b>회사선택 :</b> 
			    <select id="ListCompany">
			    </select><br /><br />
		    </span>
		</div>
		<ul id="menuList">
		</ul>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	<script type="text/javascript">
		$(function(){
			getCompanies();
			getMenus();
		});
		
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
						getThemes();
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
					menusHTML += "<li class='menuAdd' id='menuAdd'><dl><dt><span class='icon_topmenu' style='background:none; font-size:20px; font-weight:bold'>+</span></dt><dd>메뉴추가</dd></li>";
					
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
					var menuAuth = result.menuAuths;
					var menuAuthsY = menuAuth.menuAuthsY;
					var menuAuthsN = menuAuth.menuAuthsN;
					
					var menusHTML = "<li class='menuDetails'>";
					menusHTML += "<div id='menuDetails" + menuInfo.menuId + "'>";
					menusHTML += "<div class='menuTitle'>";
					menusHTML += "<span>" + menuInfo.menuName + "</span>";
					
					if (menuInfo.menuType == "A") {
						menusHTML += "<div class='btnpositionJsp deleteMenu'><a class='imgbtn deleteMenuBtn'><span>메뉴 삭제</span></a></div>";
					}
					
					menusHTML += "<div id='close' class='close'><ul><li><span></li></ul></div>";
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
						menusHTML += "<td><input class='menuNameInput' id='menu" +  item.menuLang + "' type='text' value='" + item.menuName + "'></td>";
						menusHTML += "</tr>";
					});
					
					menusHTML += "</table></li>";
					menusHTML += "<li class='conUrl'>[연결 URL]<input type='text' value='" + menuInfo.menuUrl + "'></li>"
					menusHTML += "</ul></div>";
					menusHTML += "<div class='menuAuth'><div class='btnpositionJsp menuAuthBtn'><a class='imgbtn'><span>권한 설정</span></a></div>";
					menusHTML += "<div class='accessOK'>[접근 허용]"
					menusHTML += "<div>";
					
					if (menuAuthsY != null && menuAuthsY.length != 0) {
						var menuAuthsYList = "";
						
						menuAuthsY.forEach(function(item, index) {
							if (item.isUser) {
								menuAuthsYList += "," + item.userName;
								menuAuthsYList += "(" + item.userDeptName + ")";	
							} else {
								menuAuthsYList += "," + item.userDeptName;
							}
						});
						
						menusHTML += menuAuthsYList.substring(1);
					}
					
					menusHTML += "</div>";
					menusHTML += "</div>";
					menusHTML += "<div class='accessNO'>[접근 불가]"
					menusHTML += "<div>";
					
					if (menuAuthsN != null && menuAuthsN.length != 0) {
						var menuAuthsNList = "";
						
						menuAuthsN.forEach(function(item, index) {
							if (item.isUser) {
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
					menusHTML += "</li>";
					
					var nowShowDetails = $(".menuDetails").children().attr("id");
					
					if (nowShowDetails == "menuDetails" + menuId) { 
						$(".menuDetails").slideUp(function(){
							$(".menuDetails").remove();
						});
					} else {
						$(".menuDetails").remove();
					}
					
					if (nowShowDetails != "menuDetails" + menuId) {
						if (nowShowDetails == undefined) {
							$("#menu" + menuId).after(menusHTML);
							
							if (menuInfo.menuUsed) {
								$("#menuDetails" + menuInfo.menuId).find(".menuSwitch").find("input[type='checkbox']").prop("checked", true);
							}
							
							$(".menuDetails").slideDown();
						} else {
							$("#menu" + menuId).after(menusHTML);

							if (menuInfo.menuUsed) {
								$("#menuDetails" + menuInfo.menuId).find(".menuSwitch").find("input[type='checkbox']").prop("checked", true);
							}
							
							$(".menuDetails").show();
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
					$(".menuAuthBtn").on("click", {"menuId" : menuInfo.menuId, "mode" : "view"}, openMenuAuth);
					
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
			
			//메뉴 사용 유무
			var menuUsed = $(".menuSwitch").find("input[type='checkbox']").prop("checked");
			
			//연결 url
			var menuUrl = $(".conUrl").find("input[type='text']").val();
			
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
				
				menuNameList.push({"menuLang" : menuLang, "menuId" : menuId, "menuName" : menuName.value});
			}
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updateMenu.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { getMenus();}
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				menuId : menuId,
				companyId : companyValue,
				menuNames : menuNameList,
				menuInfo : menuInfo
			});
			 
			request.send(data);
		}
		
		var openMenuAdd = function() {
			var menusHTML = "<li class='menuDetails'>";
			menusHTML += "<div id='menuDetailsNew'>";
			menusHTML += "<div class='menuTitle'>";
			menusHTML += "<span>&nbsp</span>";
			menusHTML += "<div id='close' class='close'><ul><li><span></li></ul></div>";
			menusHTML += "</div>";
			menusHTML += "<hr/>";
			menusHTML += "<div class='btnpositionJsp addMenu'><a class='imgbtn addMenuBtn'><span>저장</span></a></div>";
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
			menusHTML += "<td><input class='menuNameInput' id='menu1' type='text'></td>";
			menusHTML += "</tr>";
			menusHTML += "<tr>";
			menusHTML += "<th>메뉴명(영어)</th>";
			menusHTML += "<td><input class='menuNameInput' id='menu2' type='text'></td>";
			menusHTML += "</tr>";
			menusHTML += "<tr>";
			menusHTML += "<th>메뉴명(일본어)</th>";
			menusHTML += "<td><input class='menuNameInput' id='menu3' type='text'></td>";
			menusHTML += "</tr>";
			
			menusHTML += "</table></li>";
			menusHTML += "<li class='conUrl'>[연결 URL]<input type='text'></li>"
			menusHTML += "</ul></div>";
			menusHTML += "<div class='menuAuth'><div class='btnpositionJsp menuAuthBtn'><a class='imgbtn'><span>권한 설정</span></a></div>";
			menusHTML += "<div class='accessOK'>[접근 허용]</div>";
			menusHTML += "<div class='accessNO'>[접근 불가]</div>";  /////권한 가져오기
			menusHTML += "</div>";
			menusHTML += "</div>";
			menusHTML += "</li>";
			
			var nowShowDetails = $(".menuDetails").children().attr("id");
			
			if (nowShowDetails == "menuDetailsNew") { 
				$(".menuDetails").slideUp(function(){
					$(".menuDetails").remove();
				});
			} else {
				$(".menuDetails").remove();
			}
			
			if (nowShowDetails != "menuDetailsNew") {
				if (nowShowDetails == undefined) {
					$("#menuAdd").after(menusHTML);
					$(".menuDetails").slideDown();
				} else {
					$("#menuAdd").after(menusHTML);
					$(".menuDetails").show();
				}
			}
			
			//닫기버튼 설정
			$(".close").on("click", function(){
				$(".menuDetails").slideUp();
				$(".menuDetails").attr("class", "menuDetails hideDetails");
			});
			
			//아이콘등록 버튼 설정
			$(".iconBtn").on("click", uploadIconImg);
			
			//권한설정 기능
			$(".menuAuthBtn").on("click", {"mode" : "new"}, openMenuAuth);
			
			//저장기능
			$(".addMenuBtn").on("click", insertMenu);
		}
		
		var insertMenu = function() {
			var menuNameList = [];
			var menuNames = $(".menuNameInput");
			var menuNamesCount = menuNames.length;
			
			//메뉴 사용 유무
			var menuUsed = $(".menuSwitch").find("input[type='checkbox']").prop("checked");
			
			//연결 url
			var menuUrl = $(".conUrl").find("input[type='text']").val();
			
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
				
				menuNameList.push({"menuLang" : menuLang, "menuName" : menuName.value});
			}
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/insertMenu.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { getMenus();}
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				companyId : companyValue,
				menuNames : menuNameList,
				menuInfo : menuInfo
			});
			 
			request.send(data);
		}
		
		var deleteMenu = function (event) {
			var response = confirm("메뉴를 삭제하시겠습니까?");
			
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
		////구현해야할 부분/////
		var uploadIconImg = function() {
			var height = window.screen.availHeight;
			var width = window.screen.availWidth;
			var top = (height - 500) / 2;
			var left = (width - 765) / 2;
			   
			window.open("/admin/ezNewPortal/selectMenuIcon.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=342,width=500,top=" + top + ",left=" + left, "");
		}
		
		var openMenuAuth = function(event) {
			var mode = event.data.mode;
			
			if (mode == "view") {
				var menuId = event.data.menuId;
			}
		}

	</script>
</html>