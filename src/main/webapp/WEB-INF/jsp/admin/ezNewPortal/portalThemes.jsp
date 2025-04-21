<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezNewPortal.t054' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style type="text/css">
			.themeThumbnails {width : 350px; height : 200px; border : 1px solid #cecece; margin-top : 15px;}
			.themesImgDetails {width : 500px; height : 350px; border : 3px solid #898989;margin:15px; float:left;}
			#themeList{ padding:0px;}
			#themeList li {margin : 10px 10px 10px 0px; display : inline-block;}
			.isDefault{position:absolute;background: rgba(0,0,0,0.3);width: 352px;height: 202px;top: 15px;left: 12px;}
			.selectTheme {background-color:#edf7ff !important; border:1px solid #2196f3 !important; width : 375px; height : 270px; text-align:center; }
         	.theme {position:relative;background-color : white; width : 375px; height : 270px; text-align : center; border: 1px solid #cecece; cursor: pointer;}
			.themeHr {margin-top : 10px;width : 85%;margin-left : 30px;}
			.themeTitle {margin-top : 9px;}
			.themeNotUsed {background-color : #eee}
			.themeName {margin-left : 10px;font-size : 14px;font-weight : bold;}
			.themeDetails, .portletList {display : none; float:left; width:98%; position : relative;margin-left:0px; padding:0px;}
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
			.frameList {clear : none !important; width:64%; margin-bottom:20px;}
			.frameList tr {height:40px;}
			.frameList tr:first-child {height : 78px;}
			.frameList td {text-align : center; border:1px solid #e1e1e1;}
			.frameList th {width:61px;}
			
			.themePortlet img {cursor:pointer;background-color:#b9b9b9;}
			.themePortlet {float:left; margin-top:3px; margin-left:13px;}
			
			.ui-portlet { position:relative;  width: 290px; height: 47px; box-sizing:border-box; border-radius: 0px; padding-left: 10px; margin: 0px 10px 10px 0px; line-height: 20px;}
			.ui-portlet-on { background-color: #f0f0f0; }
			.ui-portlet-off { background-color: #f0f0f0; }
			.ui-portlet-off .ui-portlet-span{ color:#999;}
			.ui-portlet-content { font-weight: bold; display: inline-block; float: left;cursor:move; border:1px dotted #000;}
			.ui-portlet-list { padding-left: 20px; height: 335px; width: 97%;}
			.ui-portlet-span { display: inline-block; width: calc(100% - 70px); font-size:13px; color:#333; font-weight:normal;text-overflow:ellipsis;overflow:hidden;white-space:nowrap;margin-top:12px;}
			/* .portlet_switch {position:relative;display:inline-block;width:60px;height:18px;margin:13px 0px 10px 0px; vertical-align:top;} */
			.portlet_switch {margin: 1px 0px 10px 14px;}
			.portlet_switch .slider {z-index:10;}
			.admin_theme_portlet {width : 1151px;}
			.admin_theme_portlet.mobilePortlet {width : 315px;}
			.bottomBtn {clear:both;}
			#themePortletList {display:inline-block;}
			
	        .portlet_switch input {opacity: 0;width: 0;height: 0;}
	        .ui-portlet-span img {vertical-align : text-bottom; margin-right:5px;cursor:pointer;}
	        .admin_menuDL .admin_menuX {float:right;margin-right:20px;}
	        .admin_menuX span {margin-right:10px;}
	        .admin_menuX span img {margin-right:5px; vertical-align:text-bottom;}
	        /*2019.06.18 테마별권한 디자인 추가 */
	        .admin_thema .frameList {float:left;border-right:none;}
	        .admin_thema .authList {clear:none; margin:20px 0px 0px; height:189px; width:100%;} 
	        .admin_thema .authList th {width:90px; /*border-left:none;*/} 
	        .admin_thema .menuIconTD {padding:0px;}
	        .admin_thema .menuIconTD div {height:82px; overflow:auto; padding:5px;}
		</style>
	</head>
	
	<body class="mainbody">
		<h1 class="adminH1">
			<c:if test="${webType != 'mobile'}"><spring:message code='ezNewPortal.t054' /></c:if>
			<c:if test="${webType == 'mobile'}"><spring:message code='ezNewPortal.mobilePortal02' /></c:if>
		    <span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select class="companySelect" id="ListCompany"></select>
		</h1>
		<div id="mainmenu">
			<ul style="margin-top: 15px;">
				<c:if test="${webType != 'mobile'}">
					<li id="setDefaultTheme"><span><spring:message code='ezNewPortal.t110' /></span></li>
				</c:if>
			</ul>
		</div>
		<c:if test="${webType != 'mobile'}">
			<ul id="themeList" style="margin-top:10px">
			</ul>
		</c:if>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPortlet/web-animations.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPortlet/muuri.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPortlet/portlet-util.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/css/ezPortlet/portlet.css')}" type="text/css" />

	<script type="text/javascript">
		var defaultTheme = "";
		var isBtnClicked = false;
		var themeAuths = [];
		var usePortletSize = "<c:out value='${usePortletSize}'/>" === "Y";
		var allSize = !!"<c:out value='${allSize}'/>" ? "<c:out value='${allSize}'/>".slice(1, -1).split(", ") : [];
		var webType = "<c:out value='${webType}'/>";
		$(function() {
			getCompanies();
			getThemes();
			if (webType == "mobile") {
				getThemePortletList();
			}
			$("#setDefaultTheme").on("click", updateDefaultTheme);
			
		});
		
		function selectTheme(val01) {
			var compThemeId = $(".selectTheme").attr("id");
			$(".selectTheme").removeClass("selectTheme");
			$("#"+val01.id).addClass("selectTheme");
			
			defineDetailsSlideUp(compThemeId, val01.id);
		}
		
		function defineDetailsSlideUp(beforeThemeId, themeId) {
			if (!isBtnClicked) {
				if (beforeThemeId != themeId) {
					$(".portletList").slideUp(function(){
						$(".portletList").remove();
					});
					
					$(".themeDetails").slideUp(function(){
						$(".themeDetails").remove();
					});
				}
			}
		}
		
		var openThemeDetail = function (event) {
			var themeId = event.data.themeId;
			getThemeDetail(themeId);
			
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
					
					companyList.forEach(function (item, index) {
						companiesHTML += "<option value=" + item.cn + ((item.cn == userCompany) ? ' selected>' : '>') + item.displayName + "</option>";
					});
					
					document.getElementById("ListCompany").innerHTML = companiesHTML;
					
					document.getElementById("ListCompany").addEventListener('change', function() {
						getThemes();
						if (webType == "mobile") {
							getThemePortletList();
						}
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
		
		var getThemes = function () {
			$(".themeDetails").remove(); 
			$(".portletList").remove();
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getThemes.do', false);
			request.setRequestHeader('Content-Type', 'application/json');
	
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					var themes = result.list;
					var userLang = result.userLang;
					var themesHTML = "";
					
					themes.forEach(function (item, index) {
						if (item.themeId != 4) { // 모바일 테마 제외
							themesHTML += "<li>";
							themesHTML += "<div class='theme' id='theme" + item.themeId + "' onclick='selectTheme(this)'>";
							
							var themeImgUrl = "";
							
							if (item.themeId == 1) {
								themeImgUrl = "/images/ezNewPortal/theme_default.png";
							} else if (item.themeId == 2) {
								themeImgUrl = "/images/ezNewPortal/theme_shortcut.png";
							} else if (item.themeId == 3) {
								themeImgUrl = "/images/ezNewPortal/theme_separation.png";
							}
							
							themesHTML += "<div class='themeImg'><img src='" + themeImgUrl + "' class='themeThumbnails' alt='img02'/>";
							themesHTML += "</div><div>";
							themesHTML += "<div class='themeTitle' id='themeTitle" + item.themeId + "'>";
							themesHTML += "<span class='themePortlet' id='themePortlet" + item.themeId + "'><img src='/images/admin/frameSetting3.png'></span>";
							themesHTML += "<span class='themeName'>" + item.themeName + "</span>";
							themesHTML += "<span class='themeSetting' id='"+item.themeId+"'><img src='/images/kr/left/icon_setup.gif'/></span>";
							themesHTML += "</div>";
							themesHTML += "</li>";
							
							/* themesHTML += "<div class='themeDetails' id='themeDetails" + item.themeId + "'>";
							themesHTML += "<div class='themeInfo'>";
							themesHTML += "<div class='themeActive'><div>[테마 활성화] </div><label class='switch'><input type='checkbox' name='usedTheme'><span class='slider round'></span></label></div>";
							themesHTML += "<div class='btnpositionJsp'><a class='imgbtn previewBtn'><span>미리보기</span></a><a class='imgbtn updateThemeBtn'><span>저장</span></a><div id='close' class='close'><ul><li><span></li></ul></div></div>";
							themesHTML += "<div class='themeDefault'>[기본 테마 설정] <label class='switch'><input type='checkbox' name='defaultTheme'><span class='slider round'></span></label></div>";
							themesHTML += "<div class='themeContent'></div>";
							themesHTML += "</div>";
							themesHTML += "<div class='frameInfo'>";
							themesHTML += "<p>[프레임 설정]</p>";
							themesHTML += "<table class='frameList'></table>";
							themesHTML += "</div>";
							themesHTML += "</div>"; */
						}
					});
					
					$("#themeList").html(themesHTML);
					
					//event setting
					themes.forEach(function (item, index) {
						$("#themeTitle" + item.themeId).find(".themeSetting").on("click", {"themeId" : item.themeId}, openThemeDetail);
						$("#themePortlet" + item.themeId).on("click", {"themeId" : item.themeId, "themeName" : item.themeName}, getThemePortletList);
						
						if (!item.themeUsed) {
							$("#theme" + item.themeId).attr("class", "theme themeNotUsed");
						}
						
						if (item.themeDefault) {
							defaultTheme = item.themeId;
							$("#theme" + item.themeId).addClass("defaultTheme");
							$("#theme" + item.themeId).append("<div class='isDefault'><img src='/images/admin/themeDefault.png' style='margin-top:70px' /></div>");
						}
					});
					
					$("input[name='defaultTheme']").change(function(){
						var checked = $(this).is(":checked");
						
						$("input[name='defaultTheme']").prop("checked", false);
						
						if (checked) {
							$(this).prop("checked", true);
						}
					});
					
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
		
		var getThemeDetail = function(themeId) {
			
			isBtnClicked = true;
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getThemeInfo.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
	
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					var theme = result.themeInfo;
					var frameList = result.frameInfos;
					var themeAuthsY = result.themeAuths.themeAuthsY;
					var themeAuthsN = result.themeAuths.themeAuthsN;
					
					themeAuths = themeAuthsY;
					themeAuths = themeAuths.concat(themeAuthsN);
					
					var themesHTML = "<div id='themeDetails" + theme.themeId + "' class='themeDetails'>";
					themesHTML += "<div class='admin_thema'><dl class='admin_menuDL'><dd class='admin_menuX'></dd><dt class='admin_menuTit'>" + theme.themeName + "</dt></dl>";
					themesHTML += "<div class='admin_menu_content'>";
					themesHTML += "<table class='themaTable' border='0' cellpadding='0' cellspacing='0' width='100%'>";
					themesHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t111' /></th>";
					
					if (theme.themeUsed) {
						themesHTML += "<td class='menuIconTD'><label class='switch'><input type='checkbox' name='usedTheme' checked style='height:0px !important;'><span class='slider round'></span></label></td>";
					} else {
						themesHTML += "<td class='menuIconTD'><label class='switch'><input type='checkbox' name='usedTheme' style='height:0px !important;'><span class='slider round'></span></label></td>";
					}
					
					themesHTML += "<th class='menuIconTH'><spring:message code='ezNewPortal.t110' /></th>";
					
					if (theme.themeDefault) {
						themesHTML += "<td class='menuIconTD'><label class='switch'><input type='checkbox' name='defaultTheme' checked style='height:0px !important;'><span class='slider round'></span></label></td></tr>";
					} else {
						themesHTML += "<td class='menuIconTD'><label class='switch'><input type='checkbox' name='defaultTheme' style='height:0px !important;'><span class='slider round'></span></label></td></tr>";
					}
					
					themesHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t112' /></th><td colspan='4' class='menuIconTD'><input type='text' class='admin_input themeContent' readOnly></td></tr>";						
					themesHTML += "</table>";
					themesHTML += "<table class='themaTable frameList' border='0' cellpadding='0' cellspacing='0' width='100%' style='display:none; margin:20px 0px 0px 0px;'></table>";
					themesHTML += "<table class='themaTable iconTable02 authList' border='0' cellpadding='0' cellspacing='0'>";
					themesHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t081' /></th><td class='menuIconTD accessOK'><div>";
					
					if (themeAuthsY != null && themeAuthsY.length != 0) {
						var themeAuthsYList = "";
						
						themeAuthsY.forEach(function(item, index) {
							if (item.userType == 1) {
								themeAuthsYList += ", " + item.userName;
								themeAuthsYList += "(" + item.userDeptName + ")";
							} else if (item.userType == 0) {
								themeAuthsYList += ", " + item.userDeptName;
							} else {
								themeAuthsYList += ", " + item.userName;
							}
						});
						
						themesHTML += themeAuthsYList.substring(1) + "</div></td></tr>";
					}
					
					themesHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t082' /></th><td class='menuIconTD accessNO'><div>";
					
					if (themeAuthsN != null && themeAuthsN.length != 0) {
						var themeAuthsNList = "";
						
						themeAuthsN.forEach(function(item, index) {
							if (item.userType == 1) {
								themeAuthsNList += ", " + item.userName;
								themeAuthsNList += "(" + item.userDeptName + ")";
							} else if (item.userType == 0) {
								themeAuthsNList += ", " + item.userDeptName;
							} else {
								themeAuthsNList += ", " + item.userName;
							}
						});
						
						themesHTML += themeAuthsNList.substring(1) + "</div></td></tr>";
					}
					
					themesHTML += "</table>";
					themesHTML += "<div class='bottomBtn'><a class='btnA updateThemeBtn'><spring:message code='ezNewPortal.t002'/></a>";
					<%--themesHTML += "<a class='btnA previewBtn' ><spring:message code='ezNewPortal.t113' /></a>";--%>
					themesHTML += "<a class='btnA themeAuthBtn' ><spring:message code='ezNewPortal.t086' /></a></div>";
					themesHTML += "</div></div></div>";
					

					var nowShowDetails = $(".themeDetails").attr("id");
					var portletList = document.getElementsByClassName("portletList")[0];
					
					if (portletList != undefined) {
						$(".portletList").remove();
					}
					
					if (nowShowDetails == "themeDetails" + themeId) { 
						$(".themeDetails").slideUp(function(){
							$(".themeDetails").remove();
						});
					} else {
						$(".themeDetails").slideUp(function(){
							$(".themeDetails").not("#themeDetails" + theme.themeId).remove();
						});
					}
					
					if (nowShowDetails != "themeDetails" + themeId) {
						if (nowShowDetails == undefined) {
							$("#themeList").after(themesHTML);
							
							$(".themeDetails").slideDown(function(){
								isBtnClicked = false;
							});
							
						} else {
							$("#themeList").after(themesHTML);
							
							$(".themeDetails").slideDown(function(){
								isBtnClicked = false;
							});
						}
					}
					
					$("#themeDetails" + theme.themeId).find(".themeContent").val(theme.themeContent);

					$("#themeDetails" + theme.themeId).find(".updateThemeBtn").on("click", {"themeId" : theme.themeId}, updateTheme);
					$("#themeDetails" + theme.themeId).find(".previewBtn").on("click", {"themeId" : theme.themeId}, openThemePreview);
					$("#themeDetails" + theme.themeId).find(".themeAuthBtn").on("click", {"themeId" : theme.themeId}, openThemeAuth);
					
					$(".close").on("click", function(){
						$(".themeDetails").slideUp();
						$(".themeDetails").attr("class", "themeDetails hideDetails");
					});
					
					var frameHTML = "";
					frameHTML += "<tr>";
					frameHTML += "<th class='menuIconTH'></th>";
					
					frameList.forEach(function (item, index) {
						frameHTML += "<td class='menuIconTD_img'><img src='/images/admin/theme" + theme.themeId + "_frame" + item.frameId + ".png' /></td>"; //사진 url 필요
					});
					
					frameHTML += "</tr>";
					frameHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t114' /></th>";
					
					frameList.forEach(function (item, index) {
						if (item.frameDefault) {
							frameHTML += "<td class='menuIconTD_input'><input type='radio' value='F" + item.frameId + "' name='frameDefault' checked></td>";
						} else {
							frameHTML += "<td class='menuIconTD_input'><input type='radio' value='F" + item.frameId + "' name='frameDefault'></td>";
						}
						
					});

					frameHTML += "</tr>";
					frameHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t115' /></th>";
					
					frameList.forEach(function (item, index) {
						if (item.frameUsed) {
							frameHTML += "<td class='menuIconTD_input'><input value='frameUsed" + item.frameId + "' type='checkbox' name='frameUsed' checked></td>";
						} else {
							frameHTML += "<td class='menuIconTD_input'><input value='frameUsed" + item.frameId + "' type='checkbox' name='frameUsed'></td>";
						}
						
					});
					
					frameHTML += "</tr>";
					
					$("#themeDetails" + theme.themeId).find(".frameList").html(frameHTML);
				} else {
					// We reached our target server, but it returned an error
				}
			};
	
			request.onerror = function() {
			  // There was a connection error of some sort
			};
			
			var data = JSON.stringify({
				companyId : companyValue,
				themeId : themeId
			});
			
			request.send(data);
		}
		
		//테마 수정
		var updateTheme = function(event) {
			var result = confirm("<spring:message code='ezNewPortal.t116' />");
			
			if (result) {
				var themeId = event.data.themeId;
				//테마 사용여부, 테마  디폴트
				var themeUsed = $("#themeDetails" + themeId).find("input[name='usedTheme']").prop("checked");
				var themeDefault = $("#themeDetails" + themeId).find("input[name='defaultTheme']").prop("checked");
				
				if (!themeDefault && defaultTheme == themeId) {
					alert("<spring:message code='ezNewPortal.t117' />");
					return;
				}
				
				if (themeDefault && !themeUsed) {
					alert("<spring:message code='ezNewPortal.t118' />");
					return;
				}
				
				var themeInfo = {"themeUsed" : themeUsed, "themeDefault" : themeDefault, "themeId" : themeId};
				
				//현재 전체적으로 기본테마가 있는지 확인
				/* if (!$("input[name='defaultTheme']").is(":checked")) {
					alert("설정된 기본 테마가 없습니다.");
					return;
				} */
				
				//프레임 사용여부
				var frameList = $("#themeDetails" + themeId).find("input:checkbox[name=frameUsed]");
				var frameListCount = frameList.length;
				//기본프레임
				var frameDefault = $("#themeDetails" + themeId).find("input:radio[name=frameDefault]:checked").val();
				frameDefault = frameDefault.substring(1);
				
				var frameInfos = [];
				
				for (var i = 0; i < frameListCount; i++) {
					var frameId = frameList[i].value;
					frameId = frameId.substring(frameId.indexOf("d") + 1);
					
					var frameUsed = $("#themeDetails" + themeId).find("input:checkbox[value=" + frameList[i].value + "]").prop("checked"); 
					var isDefault = false;
					
					if (frameDefault == frameId) {
						isDefault = true;
					}
					
					if (frameDefault == frameId && !frameUsed) {
						alert("<spring:message code='ezNewPortal.t119' />");
						return;
					}
					
					frameInfos.push({"themeId" : themeId, "frameId" : frameId, "frameDefault" : isDefault, "frameUsed" : frameUsed});
				}
				
				var companiesObj = document.getElementById("ListCompany");
				var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
				
				// checkAuth(themeId, companyValue, themeInfo, frameInfos);
				checkAuthAfter(themeId, companyValue, themeInfo, frameInfos);
			}
		}
		
   		function checkAuth(themeId, companyValue, themeInfo, frameInfos) {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;

			if (typeof themeAuths == "string") {
				themeAuths = JSON.parse(themeAuths);
			}
			
			if (themeAuths.length == 0) {
				alert("<spring:message code='ezNewPortal.yej11' />");
				return;
			}
			
   			var request = new XMLHttpRequest();
   			request.open('POST','/admin/ezNewPortal/checkThemeAuths.do');
			request.setRequestHeader('Content-Type', 'application/json');
   			
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					console.log(request.responseText);
					var result = JSON.parse(request.responseText).authResult;
					if (result) {
						checkAuthAfter(themeId, companyValue, themeInfo, frameInfos);
					} else if (!result) {
						alert("<spring:message code='ezNewPortal.yej13' />");
						return;
					}
				}
			}
			
			request.onerror = function(e) {
			}
			
			var data = JSON.stringify({
				companyId : companyValue,
				themeAuths : themeAuths,
				themeId : themeId
			});
			
			request.send(data);
   		}
   		
   		var checkAuthAfter = function(themeId, companyValue, themeInfo, frameInfos) {
			if (typeof themeAuths == "string") {
				themeAuths = JSON.parse(themeAuths);
			}
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updateThemeInfo.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
			
			request.onload = function() {
				getThemes();
			}
			
			request.onerror = function() {
				  // There was a connection error of some sort
			};
				
			var data = JSON.stringify({
				companyId : companyValue,
				themeInfo : themeInfo,
				frameInfos : frameInfos,
				themeId : themeId,
				themeAuths : themeAuths
			});
			
			request.send(data);
   		}
   		
		//미리보기
		var openThemePreview = function(event) {
			var themeId = event.data.themeId;
			var frameId = document.getElementById("themeDetails" + themeId).querySelector("input[name='frameDefault']:checked").getAttribute("value");
			frameId = frameId.substring(1);
			
			var portletId = event.data.portletId;
	 		var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
	        var wWeight = "1208";
	        var wHeight = "744";

	        var heigth = window.screen.availHeight;
	        var width = window.screen.availWidth;

	        var left = (width - wWeight) / 2;
	        var top = (heigth - wHeight) / 2;
	        
	        window.open("/admin/ezNewPortal/themePreview.do?themeId=" + themeId + "&frameId=" + frameId, "",
	            "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		}
		
		//기본 테마 선택 (기본 테마만 선택)
		var updateDefaultTheme = function() {
	 		var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
			
			var themeId = $(".selectTheme").attr("id");
			
			if (themeId == undefined) {
				alert("<spring:message code='ezNewPortal.t120' />");
				return;
			} else {
				themeId = themeId.substring(5);
			}
			
			if ($("#theme" + themeId).attr("class").indexOf("themeNotUsed") != -1) {
				alert("<spring:message code='ezNewPortal.t121' />");
				return;
			}
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updateCompanyDefaultTheme.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
			request.onload = function() {
				getThemes();
			}
			
			var data = JSON.stringify({
				companyId : companyId,
				themeId : themeId
			});
			
			request.send(data);
		}
		
		//2018-12-03 ~ 2018-12-06 테마별 포틀릿 on/off 개발
		var getThemePortletList = function (event) {

			isBtnClicked = true;

			var themeId = "";
			var themeName = "";
			
			if (webType == "mobile"){
				themeId = 4;
				themeName = "<spring:message code='ezNewportal.mPortletSort01' />";
			} else {
				themeId = event.data.themeId;
				themeName = event.data.themeName;
			}
			
			var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
			
			var frameSize = -1;
			var availableSize = {};

			if (webType != "mobile" && usePortletSize) {
				frameSize = getFrameSize(themeId);
				availableSize = getAvailablePortletSize(companyId, themeId);
			}

			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getThemePortletList.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
			
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					if (webType != "mobile") {
	
						var data = JSON.parse(request.responseText);
						var fixList = data['fixBoard'];
						var portletList = data['poList'];
	
						var listHTML = "<div id='themePortletList" + themeId + "' class='portletList' data-themeid='" + themeId + "'>";
						listHTML += "<div class='admin_thema admin_theme_portlet'>";
						listHTML += "<dl class='admin_menuDL'>";
						listHTML += "<dd class='admin_menuX'><span class='fixed_info'><img src='/images/ezNewPortal/portlet_fixed.png'><spring:message code='ezNewPortal.t134' /></span></dd>";
						if (usePortletSize) {
							var dd = document.createElement("dd");
							dd.className = "admin_menuX";
							var btnR = document.createElement("div");
							btnR.className = "btn_size";
							btnR.id = "removeAllSize";
							btnR.innerText = "<spring:message code='ezNewPortal.pgb02' />";
							dd.append(btnR);
							var dd2 = dd.cloneNode(true);
							dd2.childNodes[0].innerText = "<spring:message code='ezNewPortal.pgb01' />";
							dd2.childNodes[0].id = "addAllSize";
							listHTML += dd.outerHTML + dd2.outerHTML;
						}
						listHTML += "<dt class='admin_menuTit'>" + themeName + "</dt>";
						listHTML += "</dl>";
						if (fixList != null) {
							listHTML += "<div class='admin_menu_content'>";
	
							var fixCount = fixList.length * -1;
							fixList.forEach(function (item) {
								var portletId = item.portletId;
	
								listHTML += "<div class='portlets ui-portlet ui-portlet-on ui-portlet-content'";
								listHTML += " id='" + item.portletCode + "'";
								listHTML += " data-portletid='" + portletId + "' data-menuid='" + item.menuId + "' data-fix=" + fixCount++ + ">";
								listHTML += "<span class='ui-portlet-span'>";
	
								listHTML += ConvertCharToEntityReference(item.portletName);
								listHTML += "</span>";
								listHTML += "<label class='portlet_switch switch' title='" + "<spring:message code='ezNewPortal.fixportlet.theme2' />" + "'>";
	
								listHTML += "<input class='chk_portlet' type='checkbox' id='portlet" + portletId + "' ";
								listHTML += item.fixBoard ? " data-fix=true " : "";
	
								if (themeId == 2) {
									listHTML += " disabled > ";
								} else {
									listHTML += item.portletUsed ? " checked>" : ">";
								}
	
								listHTML += "<span class='slider round'></span></label>";
								listHTML += "</div>";
							});
							listHTML += "</div>";
						}
						listHTML += "<div class='admin_menu_content'>";
						if (usePortletSize) {
							listHTML += "<div id='themePortletList' class=" + ClassPortlet.AREA_PORTLET + ">";
						} else {
							listHTML += "<div id='themePortletList'>";
						}
	
						portletList.forEach(function (item, index) {
							var portletId = item.portletId;
	
							listHTML += "<div class='portlets ui-portlet ui-portlet-on ui-portlet-content";
							if (usePortletSize) {
								listHTML += " " + ClassPortlet.PORTLET + " " + item.classSize;
								listHTML += item.portletUsed ? "'" : " off_portlet'";
								listHTML += " data-size='" + item.classSize + "' ";
							} else {
								listHTML += "'";
							}
							listHTML += " data-portletid='" + portletId + "' data-menuid='" + item.menuId + "'>";
							if (usePortletSize) {
								listHTML += "<div class=wrap_title>";
							}
							listHTML += "<span class='ui-portlet-span'>";
	
							if (item.fixed) {
								listHTML += "<img class='fixedPortlet' id='fixedPortlet" + portletId + "' src='/images/ezNewPortal/portlet_fixed.png'>";
							} else {
								listHTML += "<img class='noneFixedPortlet' id='fixedPortlet" + portletId + "' src='/images/ezNewPortal/portlet_not_fixed.png'>";
							}
	
							listHTML += ConvertCharToEntityReference(item.portletName);
							listHTML += "</span>";
							if (usePortletSize) {
								listHTML += "<div class='sortablePortlet'></div>";
							}
							listHTML += "<label class='portlet_switch switch'>";
	
							if (item.portletUsed) {
								listHTML += "<input class='chk_portlet' type='checkbox' id='portlet" + portletId + "' checked>";
							} else {
								listHTML += "<input class='chk_portlet' type='checkbox' id='portlet" + portletId + "'>";
							}
	
							listHTML += "<span class='slider round'></span></label>";
							if (usePortletSize) {
								listHTML += "</div><div class='" + ClassPortlet.BODY_POP + "'>";
								var btnSet = document.createElement("img");
								btnSet.src = "/images/verified.png?version=23110801";
								btnSet.className = "btn_set";
								listHTML += btnSet.outerHTML;
								for (var i = 0; i < allSize.length; i++) {
									var size = allSize[i];
									var img = document.createElement("img");
									img.src = "/images/portal/" + size + ".svg?version=23110801"; // queryString. 이미지 변경시 YYMMDD + 넘버링 (01, 02, 03)
									img.className = size;
									img.dataset.size = size;
									if (size !== GridSize.ONE_BY_ONE && item.classSize !== size
											&& (availableSize[portletId] === undefined || availableSize[portletId].indexOf(size) === -1)) {
										img.classList.add(ClassPortlet.UNAVAILABLE_SIZE);
									} else {
										img.classList.add(ClassPortlet.AVAILABLE_SIZE);
									}
									listHTML += img.outerHTML;
								}
								listHTML += "</div></div>";
							} else {
								listHTML += "</div>";
							}
						});
	
						listHTML += "</div>";
						listHTML += "<div class='bottomBtn'><a class='btnA updateThemePortletBtn'><spring:message code='ezNewPortal.t002'/></a></div>";
						listHTML += "</div>";
						if (usePortletSize) {
							listHTML += "</div>";
						}
	
						var nowShowList = document.getElementsByClassName("portletList")[0];
	
						if (nowShowList != undefined) {
							nowShowList = nowShowList.getAttribute("data-themeid");
						}
	
						//themeDetails가 열려있으면 없애기
						var themeDetails = document.getElementsByClassName("themeDetails")[0];
	
						if (themeDetails != undefined) {
							$(".themeDetails").remove();
						}
	
						if (nowShowList == themeId) {
							$(".portletList").slideUp(function () {
								$(".portletList").remove();
							});
						} else {
							$(".portletList").slideUp(function () {
								$(".portletList").not("#themePortletList" + themeId).remove();
							});
						}
	
						if (nowShowList != themeId) {
							$("#themeList").after(listHTML);
	
							$(".portletList").slideDown(function () {
								isBtnClicked = false;
							});
						}
	
						//drag and drop
						if (usePortletSize) {
							gridElement = null;
							startGridElement();
						} else {
							$("#themePortletList").sortable({
								items: ".portlets",
								scroll: false
							});
						}
	
						$("#themePortletList").disableSelection();
	
						//저장버튼 활성화
						$(".updateThemePortletBtn").on("click", {"themeId": themeId}, updateThemePortlet);
						//2018-12-18 유은정 - 포틀릿 필수 사용 지정 관련 개발
						$(".ui-portlet-span").find("img").on("click", changeFixed);
						$(".portlet_switch").find("input").on("change", checkFixedInput);
	
						if (usePortletSize) {
							// 포틀릿 사이즈 변경
							var btnList = document.querySelectorAll("img[data-size]");
							Array.prototype.forEach.call(btnList, function (btn) {
								btn.addEventListener("click", function (e) {
									var target = e.target;
									if (target.classList.contains(ClassPortlet.EDITING)) {
										// edit 중일때 동작 - 포틀릿 사용가능 사이즈 지정
										if (target.classList.contains(ClassPortlet.AVAILABLE_SIZE)) {
											target.classList.remove(ClassPortlet.AVAILABLE_SIZE);
											target.classList.add(ClassPortlet.UNAVAILABLE_SIZE);
										} else {
											target.classList.remove(ClassPortlet.UNAVAILABLE_SIZE);
											target.classList.add(ClassPortlet.AVAILABLE_SIZE);
										}
									} else {
										// edit 중이지 않을때 - 포틀릿 사이즈 변경
										changePortletSize(target.closest("." + ClassPortlet.PORTLET), target.dataset.size);
									}
								});
							});
	
							// 포틀릿 사용가능 사이즈 설정 버튼
							var btnSetList = document.querySelectorAll(".body_pop_for_size .btn_set");
							Array.prototype.forEach.call(btnSetList, function (btn) {
								btn.addEventListener("click", function (e) {
									var target = e.target;
									var siblings = !!target && target.parentElement.querySelectorAll("img:not(." + GridSize.ONE_BY_ONE + ")") || [];
									Array.prototype.forEach.call(siblings, function (node) {
										if (node.classList.contains(ClassPortlet.UNAVAILABLE_SIZE)) {
											var portlet = node.closest("." + ClassPortlet.PORTLET);
											if (portlet.classList.contains(node.dataset.size)) {
												changePortletSize(portlet, GridSize.ONE_BY_ONE);
											}
										}
										node.classList.toggle(ClassPortlet.EDITING);
									});
								});
							});
	
							// 사이즈 일괄 추가
							var btnAList = document.getElementById("addAllSize");
							btnAList.addEventListener("click", function (e) {
								var nodes = document.querySelectorAll("." + ClassPortlet.UNAVAILABLE_SIZE);
								Array.prototype.forEach.call(nodes, function (node) {
									node.classList.remove(ClassPortlet.UNAVAILABLE_SIZE);
									node.classList.add(ClassPortlet.AVAILABLE_SIZE);
								});
							});
	
							// 사이즈 일괄 제거
							var btnRList = document.getElementById("removeAllSize");
							btnRList.addEventListener("click", function (e) {
								var nodes = document.querySelectorAll("." + ClassPortlet.AVAILABLE_SIZE + ":not(." + GridSize.ONE_BY_ONE + ")");
								Array.prototype.forEach.call(nodes, function (node) {
									node.classList.remove(ClassPortlet.AVAILABLE_SIZE);
									node.classList.add(ClassPortlet.UNAVAILABLE_SIZE);
								});
	
								var notDefaultSizePortletList = document.querySelectorAll("." + ClassPortlet.PORTLET + ":not(." + GridSize.ONE_BY_ONE + ")");
								Array.prototype.forEach.call(notDefaultSizePortletList, function (portlet) {
									changePortletSize(portlet, GridSize.ONE_BY_ONE);
								});
							});
						}
					} else {
						var portletLists = JSON.parse(request.responseText);
						var portletList = portletLists.poList;
						var portletListCount = portletList.length;

						var listHTML = "<div id='themePortletList" + themeId + "' class='portletList' data-themeid='" + themeId + "'>";
						listHTML += "<div class='admin_thema admin_theme_portlet mobilePortlet'>";
						listHTML += "<dl class='admin_menuDL'>";
						listHTML += "<dd class='admin_menuX'><span class='fixed_info'><img src='/images/ezNewPortal/portlet_fixed.png'><spring:message code='ezNewPortal.t134' /></span></dd>";
						listHTML += "<dt class='admin_menuTit'>" + themeName + "</dt>";
						listHTML += "</dl>";
						listHTML += "<div class='admin_menu_content'>";
						listHTML += "<div id='themePortletList'>";

						portletList.forEach(function (item, index) {
							var portletId = item.portletId;

							listHTML += "<div class='portlets ui-portlet ui-portlet-on ui-portlet-content' data-portletid='" + portletId + "' data-menuid='" + item.menuId + "'>";
							listHTML += "<span class='ui-portlet-span'>";

							if (item.fixed) {
								listHTML += "<img class='fixedPortlet' id='fixedPortlet" + portletId + "' src='/images/ezNewPortal/portlet_fixed.png'>";
							} else {
								listHTML += "<img class='noneFixedPortlet' id='fixedPortlet" + portletId + "' src='/images/ezNewPortal/portlet_not_fixed.png'>";
							}

							listHTML += ConvertCharToEntityReference(item.portletName);
							listHTML += "</span>";
							listHTML += "<label class='portlet_switch switch'>";

							if (item.portletUsed) {
								listHTML += "<input class='chk_portlet' type='checkbox' id='portlet" + portletId + "' checked>";
							} else {
								listHTML += "<input class='chk_portlet' type='checkbox' id='portlet" + portletId + "'>";
							}

							listHTML += "<span class='slider round'></span></label>";
							listHTML += "</div>";
						});

						listHTML += "</div>";
						listHTML += "<div class='bottomBtn'><a class='btnA updateThemePortletBtn'><spring:message code='ezOrgan.t167' /></a></div>";
						listHTML += "</div>";
						listHTML += "</div>";

						var nowShowList = document.getElementsByClassName("portletList")[0];

						if (nowShowList != undefined) {
							nowShowList = nowShowList.getAttribute("data-themeid");
						}

						//themeDetails가 열려있으면 없애기
						var themeDetails = document.getElementsByClassName("themeDetails")[0];

						if (themeDetails != undefined) {
							$(".themeDetails").remove();
						}

						if (nowShowList == themeId) {
							$(".portletList").slideUp(function(){
								$(".portletList").remove();
							});
						} else {
							$(".portletList").slideUp(function(){
								$(".portletList").not("#themePortletList" + themeId).remove();
							});
						}

						if (nowShowList != themeId) {

							if (nowShowList == null || nowShowList == undefined) {
								$(".adminH1").after(listHTML);

								$(".portletList").slideDown(function(){
									isBtnClicked = false;
								});
							} else {
								$("#themeList").after(listHTML);

								$(".portletList").slideDown(function(){
									isBtnClicked = false;
								});
							}
						}

						//drag and drop
						$("#themePortletList").sortable({
							items : ".portlets",
							scroll: false
						});

						$("#themePortletList").disableSelection();

						//저장버튼 활성화
						$(".updateThemePortletBtn").on("click", {"themeId" : themeId}, updateThemePortlet);
						//2018-12-18 유은정 - 포틀릿 필수 사용 지정 관련 개발
						$(".ui-portlet-span").find("img").on("click", changeFixed);
						$(".portlet_switch").find("input").on("change", checkFixedInput);

					}
				}else {
					// We reached our target server, but it returned an error
				}
			};
	
			request.onerror = function() {
			  // There was a connection error of some sort
			};
			
			var data = JSON.stringify({
				companyId : companyId,
				themeId : themeId
			});
			
			request.send(data);
		}
		
		var updateThemePortlet = function(event) {
			var themeId = event.data.themeId;
			var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
			
			if (webType != "mobile") {
				if (usePortletSize) gridElement.synchronize();
				var themePortletList = $(".portlets");

				var themePortletListCount = themePortletList.length;
				var themePortlet = [];
				var portletSizeList = [];

				if (usePortletSize) {
					portletSizeList = [];
					for (var i = 0; i < themePortletListCount; i++) {
						var portlet = themePortletList[i];
						var portletId = portlet.dataset.portletid;
						var portletSize = portlet.dataset.size;
						var btnList = portlet.querySelectorAll("img." + ClassPortlet.AVAILABLE_SIZE + "[data-size]");
						Array.prototype.forEach.call(btnList, function (btn) {
							portletSizeList.push({
								portletId: portletId,
								portletSize: btn.dataset.size,
								default: btn.dataset.size === portletSize ? 1 : 0
							});
						});
					}
				}

				var index = 1;

				for (var i = 0; i < themePortletListCount; i++) {
					var portlet = themePortletList[i];
					var portletId = portlet.getAttribute("data-portletid");
					var menuId = portlet.getAttribute("data-menuid");
					var portletUsed = $("#portlet" + portletId).prop("checked");
					// 고정 포틀릿은 순서 고정
					var fixOrder = portlet.getAttribute('data-fix');
					var currIndex;
					if (!!fixOrder) {
						currIndex = fixOrder;
					} else {
						currIndex = index++;
					}
					var isFixed = false;
					var fixPo = document.getElementById("fixedPortlet" + portletId);
					if (!!fixPo) {
						var fixedClassList = fixPo.classList;

						for (var j = 0; j < fixedClassList.length; j++) {
							if (fixedClassList[j] === "fixedPortlet") {
								isFixed = true;
								break;
							} else if (fixedClassList[j] === "noneFixedPortlet") {
								isFixed = false;
								break;
							}
						}
					} else {
						isFixed = true;
					}

					themePortlet.push({
						"portletId": portletId,
						"menuId": menuId,
						"portletUsed": portletUsed,
						"portletOrder": currIndex,
						"isFixed": isFixed
					});
				}
			} else {
				var themePortletList = $(".portlets");

				var themePortletListCount = themePortletList.length;
				var themePortlet = [];

				for (var i = 0; i < themePortletListCount; i++) {
					var portlet = themePortletList[i];
					var portletId = portlet.getAttribute("data-portletid");
					var menuId = portlet.getAttribute("data-menuid");
					var portletUsed = $("#portlet" + portletId).prop("checked");

					var isFixed = false;
					var fixedClassList = document.getElementById("fixedPortlet" + portletId).classList;

					for (var j = 0; j < fixedClassList.length; j++) {
						if (fixedClassList[j] === "fixedPortlet") {
							isFixed = true;
							break;
						} else if (fixedClassList[j] === "noneFixedPortlet") {
							isFixed = false;
							break;
						}
					}

					themePortlet.push({"portletId" : portletId, "menuId" : menuId, "portletUsed" : portletUsed, "portletOrder" : i + 1, "isFixed" : isFixed});
				}
			}
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updateThemePortletUsed.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
			
			request.onload = function() {
				if (webType != "mobile") {
					getThemes();
				} else {
					if (request.status >= 200 && request.status < 300) {
						alert("<spring:message code='ezNewPortal.t102' />");
					} else {
						alert("<spring:message code='ezNewPortal.t032' />");
					}
				}
			}
			
			request.onerror = function() {
				  // There was a connection error of some sort
			};
			
			var data = JSON.stringify({
				companyId : companyId,
				themeId : themeId,
				themePortletList : themePortlet,
				sizeList : portletSizeList,
				webType : webType
			});
			
			request.send(data);

		}
		
		//2018-12-18 유은정 - 포틀릿 필수 사용 지정 관련 개발
		var checkFixedInput = function() {			
			var portletId = this.id;
			portletId = portletId.substring(7);
			
			var isFixed = false;
			var fixedClassList = document.getElementById("fixedPortlet" + portletId).classList;

			for (var i = 0; i < fixedClassList.length; i++) {
				if (fixedClassList[i] === "fixedPortlet") {
					isFixed = true;
					break;
				} else if (fixedClassList[i] === "noneFixedPortlet") {
					isFixed = false;
					break;
				}
			}

			if (isFixed) {
				alert("<spring:message code='ezNewPortal.t132' />");
				$(this).prop("checked", true);
				return;
			}

			if (usePortletSize) {
				var portlet = document.querySelector('[data-portletid="' + portletId + '"]');
				var item = gridElement.getItem(portlet);
				if ($(this).is(':checked')) {
					var itemArr = gridElement.getItems();
					for (let i = itemArr.length-1; i > -1; i--) {
						if (!itemArr[i].getElement().classList.contains(ClassPortlet.OFF_PORTLET)) {
							gridElement.move(item, i+1);
							break;
						}
					}
					portlet.classList.remove(ClassPortlet.OFF_PORTLET);
				} else if (!this.getAttribute('data-fix')){
					portlet.classList.add(ClassPortlet.OFF_PORTLET);
					gridElement.move(item,-1);
					changePortletSize(portlet, GridSize.ONE_BY_ONE);
				}
			}

		}
		
		function checkPortletUsed(portletId) {
			var isPortletUsed = $("#portlet" + portletId).prop("checked");
			
			if (!isPortletUsed) {
				alert("<spring:message code='ezNewPortal.t133' />");
				$(this).prop("checked", false);
				return false;
			} else {
				return true;
			}
		}
		
		var changeFixed = function() {
			var imgId = this.id;
			var portletId = imgId.substring(12);
			var checkPortlet = checkPortletUsed(portletId);
			
			if (checkPortlet) {
				for (var i = 0; i < this.classList.length; i++) {
					if (this.classList[i] == "fixedPortlet") {
						this.classList.remove("fixedPortlet");
						this.classList.add("noneFixedPortlet");
						this.src = "/images/ezNewPortal/portlet_not_fixed.png";
						break;
					} else if (this.classList[i] == "noneFixedPortlet") {
						this.classList.remove("noneFixedPortlet");
						this.classList.add("fixedPortlet");
						this.src = "/images/ezNewPortal/portlet_fixed.png";
						break;
					}
				}
			}
		}
		
		var openThemeAuth = function(event) {
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var url = "/admin/ezNewPortal/portalMenuAuth.do?menuId=" + event.data.themeId + "&companyId=" + companyValue + "&mode=theme";
			var OpenWin = window.open(url, "", GetOpenWindowfeature(980, 660)); // 높이 수정 650 > 660
		    	try { OpenWin.focus(); } catch (e) { }
		}

		function getFrameSize(themeId) {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;

			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getThemeInfo.do', false);
			request.setRequestHeader('Content-Type', 'application/json');
			var usingFrame = 1;
			var sizeArr = [-1, 3, 3, 2, 2, 3, 3, 2, 2];

			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					var frameList = result.frameInfos;
					frameList.forEach(function (item) {
						if (item.frameDefault) {
							usingFrame = item.frameId;
						}
					});
				}
			}

			request.onerror = function() {
				// There was a connection error of some sort
			};

			var data = JSON.stringify({
				companyId : companyValue,
				themeId : themeId
			});

			request.send(data);

			return sizeArr[usingFrame];
		}
	</script>
</html>