<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>portalThemes</title>
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
		<style type="text/css">
			.themeThumbnails {width : 350px; height : 200px; border : 3px solid #7d7d7d; margin-top : 15px;}
			.themesImgDetails {width : 500px; height : 350px; border : 3px solid #898989;margin:15px; float:left;}
			#themeList li {margin : 10px; display : inline-block;}
			.theme {position:relative;background-color : white; width : 375px; height : 270px; text-align : center; border: 2px solid #949292;}
			.themeHr {margin-top : 10px;width : 85%;margin-left : 30px;}
			.themeTitle {margin-top : 9px;}
			.themeNotUsed {display:none;width:100%; height:87%;background-color:#e1e1e180; z-index:99;position:absolute; right:0; top:0;}
			.themeName {font-size : 14px;font-weight : bold;}
			.themeDetails {display : none; float:left; width:98%; border:1px solid black;position : relative;margin-left:10px;}
			.themeSetting {float : right;margin-right : 27px;cursor:pointer;}
			.themeSetting img {width : 17px;height : 17px;}
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
			
			.hideDetails {display : none;}
			.showDetails {display : block;}
			.themeInfo {margin : 15px;}
			.themeActive{position:relative; margin-top : 20px; font-size : 15px; font-weight : bold; display : inline-block;}
			.themeActive div {display : inline-block;}
			.btnpositionJsp {float : right; margin-top : 0px;padding-right:35px; padding-top:0px;}
			.close {margin-top : 6px;}
			.btnpositionJsp a {margin-left : 5px;}
			.themeDefault {font-size : 15px; font-weight:bold; margin-top : 20px;}
			.themeContent{margin-top:20px; overflow-y:auto; width:98%; height : 60px; display:inline-block; border : 1px solid #928686; padding : 10px;}

			.frameInfo {margin : 15px;}
			.frameInfo p {font-size : 15px; font-weight : bold;}
			.frameList {clear : none !important; width:100%; margin-bottom:20px;}
			.frameList tr {height:40px;}
			.frameList tr:first-child {height : 78px;}
			.frameList td {text-align : center; border:1px solid #e1e1e1;}
			.frameList th {width:61px;}
			
			.defaultTheme {background-color:rgb(182, 226, 255);}
			.setDefault {float : left; margin-left:18px; cursor : pointer;}
		</style>
	</head>
	
	<body class="mainbody">
		<h1 class="adminH1">
			테마관리
			<select class="companySelect" id="ListCompany"></select>
		</h1>
		<ul id="themeList" style="margin-top:30px">
		</ul>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		
		$(function() {
			getCompanies();
			getThemes();
		});
		
		var openThemeDetail = function (event) {
			var themeId = event.data.themeId;
			getThemeDetail(themeId);
			
			var nowShowDetails = $(".showDetails").attr("id");
			
			if (nowShowDetails == "themeDetails" + themeId) { 
				$(".themeDetails").slideUp();
				$('.theme').css('border', '2px solid #949292');
			} else {
				$(".themeDetails").hide();
				$('.theme').css('border', '2px solid #949292');
				$('#theme' + this.id).css('border', '2px solid #0088CC');				
			}
			
			$(".themeDetails").attr("class", "themeDetails hideDetails");
			if (nowShowDetails != "themeDetails" + themeId) {
				if (nowShowDetails == undefined) {
					$("#themeDetails" + themeId).slideDown();
				} else {
					$("#themeDetails" + themeId).show();
				}
				
				$("#themeDetails" + themeId).attr("class", "themeDetails showDetails");
			}
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
					console.log(themes);
					console.log(result);
					themes.forEach(function (item, index) {
						themesHTML += "<li>";
						themesHTML += "<div class='theme' id='theme" + item.themeId + "'>";
						themesHTML += "<div class='themeImg'><img src='/images/ezNewPortal/Theme1.GIF' class='themeThumbnails' alt='img02'/>";
						themesHTML += "<div class='themeNotUsed'>&nbsp;</div>";
						themesHTML += "</div><div>";
						themesHTML += "<hr class='themeHr'/>";
						themesHTML += "<div class='themeTitle' id='themeTitle" + item.themeId + "'>";
						themesHTML += "<span class='setDefault'><img src='/images/arr_down.gif'/></span>"
						themesHTML += "<span class='themeName'>" + item.themeName + "</span>";
						themesHTML += "<span class='themeSetting' id='"+item.themeId+"'><img src='/images/kr/left/icon_setup.gif'/></span>";
						themesHTML += "</div>";
						themesHTML += "</li>";
						
						themesHTML += "<div class='themeDetails' id='themeDetails" + item.themeId + "'>";
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
						themesHTML += "</div>";
					});
					
					document.getElementById("themeList").innerHTML = themesHTML;
					
					//event setting
					themes.forEach(function (item, index) {
						$("#themeTitle" + item.themeId).find(".themeSetting").on("click", {"themeId" : item.themeId}, openThemeDetail);
						$("#themeDetails" + item.themeId).find(".updateThemeBtn").on("click", {"themeId" : item.themeId}, updateTheme);
						$("#themeDetails" + item.themeId).find(".previewBtn").on("click", {"themeId" : item.themeId}, openThemePreview);
						$("#theme" + item.themeId).find(".setDefault").on("click", {"themeId" : item.themeId}, updateDefaultTheme);
						
						if (!item.themeUsed) {
							$("#theme" + item.themeId).find(".themeNotUsed").css("display", "");
						} else {
							$("#themeDetails" + item.themeId).find("input[name='usedTheme']").prop("checked", true);
						}
						
						if (item.themeDefault) {
							$("#theme" + item.themeId).addClass("defaultTheme");
							$("#themeDetails" + item.themeId).find("input[name='defaultTheme']").prop("checked", true);
						}
					});
					
					$("input[name='defaultTheme']").change(function(){
						var checked = $(this).is(":checked");
						
						$("input[name='defaultTheme']").prop("checked", false);
						
						if (checked) {
							$(this).prop("checked", true);
						}
					});
					
					$(".close").on("click", function(){
						$(".themeDetails").slideUp();
						$(".themeDetails").attr("class", "themeDetails hideDetails");
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
					
					$("#themeDetails" + theme.themeId).find(".themeContent").text(theme.themeContent);
					
					var frameHTML = "";
					frameHTML += "<tr class='frameImg'>";
					frameHTML += "<th></th>";
					
					frameList.forEach(function (item, index) {
						frameHTML += "<td>그림" + (index + 1) + "</td>"; //사진 url 필요
					});
					
					frameHTML += "</tr>";
					frameHTML += "<tr><th>기본 프레임 설정</th>";
					
					frameList.forEach(function (item, index) {
						if (item.frameDefault) {
							frameHTML += "<td><input type='radio' value='F" + item.frameId + "' name='frameDefault' checked></td>";
						} else {
							frameHTML += "<td><input type='radio' value='F" + item.frameId + "' name='frameDefault'></td>";
						}
						
					});

					frameHTML += "</tr>";
					frameHTML += "<tr><th>사용자 프레임 설정</th>";
					
					frameList.forEach(function (item, index) {
						if (item.frameUsed) {
							frameHTML += "<td><input value='frameUsed" + item.frameId + "' type='checkbox' name='frameUsed' checked></td>";
						} else {
							frameHTML += "<td><input value='frameUsed" + item.frameId + "' type='checkbox' name='frameUsed'></td>";
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
			var result = confirm("테마 설정을 수정하시겠습니까?");
			
			if (result) {
				var themeId = event.data.themeId;
				//테마 사용여부, 테마  디폴트
				var themeUsed = $("#themeDetails" + themeId).find(".switch").find("input").prop("checked");
				var themeDefault = $("#themeDetails" + themeId).find(".themeDefault").find("input").prop("checked");
				var themeInfo = {"themeUsed" : themeUsed, "themeDefault" : themeDefault, "themeId" : themeId};
				
				//현재 전체적으로 기본테마가 있는지 확인
				if (!$("input[name='themeDefault']").is(":checked")) {
					alert("설정된 기본 테마가 없습니다.");
					return;
				}
				
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
		var updateDefaultTheme = function(event) {
			var themeId = event.data.themeId;
	 		var companiesObj = document.getElementById("ListCompany");
			var companyId = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updateCompanyDefaultTheme.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
			request.onload = function() {
				$(".theme").removeClass("defaultTheme");
				$("#theme" + themeId).addClass("defaultTheme");
				$("#themeDetails" + themeId).find(".themeDefault").find("input").prop("checked", true);
			}
			
			var data = JSON.stringify({
				companyId : companyId,
				themeId : themeId
			});
			
			request.send(data);
		}
	</script>
</html>