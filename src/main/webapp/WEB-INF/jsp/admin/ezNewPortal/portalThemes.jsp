<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezNewPortal.t054' /></title>
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
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
			.themeName {margin-left : 40px;font-size : 14px;font-weight : bold;}
			.themeDetails {display : none; float:left; width:98%; position : relative;margin-left:0px; padding:0px;}
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
			.frameList {clear : none !important; width:100%; margin-bottom:20px;}
			.frameList tr {height:40px;}
			.frameList tr:first-child {height : 78px;}
			.frameList td {text-align : center; border:1px solid #e1e1e1;}
			.frameList th {width:61px;}
		</style>
	</head>
	
	<body class="mainbody">
		<h1 class="adminH1">
			<spring:message code='ezNewPortal.t054' />
			<select class="companySelect" id="ListCompany"></select>
		</h1>
		<div id="mainmenu">
			<ul style="margin-top: 15px;">
				<li id="setDefaultTheme"><span><spring:message code='ezNewPortal.t110' /></span></li>
			</ul>
		</div>
		<ul id="themeList" style="margin-top:10px">
		</ul>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		var defaultTheme = "";
		
		$(function() {
			getCompanies();
			getThemes();
			
			$("#setDefaultTheme").on("click", updateDefaultTheme);
		});
		
		function selectTheme(val01) {
			$(".selectTheme").removeClass("selectTheme");
			$("#"+val01.id).addClass("selectTheme");
		}
		
		var openThemeDetail = function (event) {
			var themeId = event.data.themeId;
			getThemeDetail(themeId);
			
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
		
		var getThemes = function () {
			$(".themeDetails").remove(); 
			
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getThemes.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
	
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					var themes = result.list;
					var themesHTML = "";
					
					themes.forEach(function (item, index) {
						themesHTML += "<li>";
						themesHTML += "<div class='theme' id='theme" + item.themeId + "' onclick='selectTheme(this)'>";
						themesHTML += "<div class='themeImg'><img src='/images/ezNewPortal/Theme1.GIF' class='themeThumbnails' alt='img02'/>";
						themesHTML += "</div><div>";
						themesHTML += "<div class='themeTitle' id='themeTitle" + item.themeId + "'>";
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
					});
					
					$("#themeList").html(themesHTML);
					
					//event setting
					themes.forEach(function (item, index) {
						$("#themeTitle" + item.themeId).find(".themeSetting").on("click", {"themeId" : item.themeId}, openThemeDetail);
						
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
					
					var themesHTML = "<div id='themeDetails" + theme.themeId + "' class='themeDetails'>";
					themesHTML += "<div class='admin_thema'><dl class='admin_menuDL'><dt class='admin_menuTit'>" + theme.themeName + "</dt><dd class='admin_menuX'></dd></dl>";
					themesHTML += "<div class='admin_menu_content'>";
					themesHTML += "<table class='themaTable' border='0' cellpadding='0' cellspacing='0' width='100%'>";
					themesHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t111' /></th>";
					
					if (theme.themeUsed) {
						themesHTML += "<td class='menuIconTD'><label class='switch'><input type='checkbox' name='usedTheme' checked><span class='slider round'></span></label></td>";
					} else {
						themesHTML += "<td class='menuIconTD'><label class='switch'><input type='checkbox' name='usedTheme'><span class='slider round'></span></label></td>";
					}
					
					themesHTML += "<th class='menuIconTH'><spring:message code='ezNewPortal.t110' /></th>";
					
					if (theme.themeDefault) {
						themesHTML += "<td class='menuIconTD'><label class='switch'><input type='checkbox' name='defaultTheme' checked><span class='slider round'></span></label></td></tr>";
					} else {
						themesHTML += "<td class='menuIconTD'><label class='switch'><input type='checkbox' name='defaultTheme'><span class='slider round'></span></label></td></tr>";
					}
					
					themesHTML += "<tr><th class='menuIconTH'><spring:message code='ezNewPortal.t112' /></th><td colspan='4' class='menuIconTD'><input type='text' class='admin_input themeContent' readOnly></td></tr>";						
					themesHTML += "</table>";
					themesHTML += "<table class='themaTable frameList' border='0' cellpadding='0' cellspacing='0' width='100%' style='margin:20px 0px 0px 0px;'></table>";
					themesHTML += "<div class='bottomBtn'><a class='btnA updateThemeBtn'>저장</a><a class='btnA previewBtn' ><spring:message code='ezNewPortal.t113' /></a></div>";
					themesHTML += "</div></div></div>";
					

					var nowShowDetails = $(".themeDetails").attr("id");
					
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
							
							$(".themeDetails").slideDown();
						} else {
							$("#themeList").after(themesHTML);
							
							$(".themeDetails").slideDown();
						}
					}
					
					$("#themeDetails" + theme.themeId).find(".themeContent").val(theme.themeContent);

					$("#themeDetails" + theme.themeId).find(".updateThemeBtn").on("click", {"themeId" : theme.themeId}, updateTheme);
					$("#themeDetails" + theme.themeId).find(".previewBtn").on("click", {"themeId" : theme.themeId}, openThemePreview);
					
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
					themeId : themeId
				});
				
				request.send(data);
			}
		}
		
		//미리보기
		var openThemePreview = function(event) {
			var themeId = event.data.themeId;
			var frameId = document.getElementById("themeDetails" + themeId).querySelector("input[name='frameDefault']:checked").getAttribute("value");
			frameId = frameId.substring(1);
			
			var portletId = event.data.portletId;
	 		var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
	        var wWeight = "900";
	        var wHeight = "750";

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
			
			console.log($("#theme" + themeId).attr("class").indexOf("themeNotUsed"));
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
	</script>
</html>