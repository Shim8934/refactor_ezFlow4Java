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
			.themeImg {position:relative;background-color : white; width : 400px; height : 270px; text-align : center; border: 1px solid #949292;}
			.themeHr {margin-top : 10px;width : 85%;margin-left : 30px;}
			.themeTitle {margin-top : 9px;}
			.themeNotUsed {display:none;width:100%; height:100%;background-color:#e1e1e180; z-index:99;position:absolute; right:0; top:0;}
			.themeName {margin-left : 40px;font-size : 14px;font-weight : bold;}
			.themeDetails {display : none; float:left; width:98%; border:1px solid black;position : relative;margin-left:10px;}
			.themeSetting {float : right;margin-right : 27px;cursor:pointer;}
			.themeSetting img {width : 17px;height : 17px;}
			.switch {position: relative;display: inline-block;width: 60px;height: 25px;margin-left:10px;}
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
			.themeActive{margin-top : 20px; font-size : 15px; font-weight : bold; display : inline-block;}
			.btnpositionJsp {float : right; margin-top : 0px;padding-right:35px; padding-top:0px;}
			.close {margin-top : 6px;}
			.btnpositionJsp a {margin-left : 5px;}
			.themeDefault {font-size : 15px; font-weight:bold; margin-top : 12px;}
			.themeContent{overflow-y:auto; width:50%; height : 60px; display:inline-block; margin-top:15px; border : 1px solid #928686; padding : 10px;}
			.frameInfo p {font-size : 15px; font-weight : bold;}
			.frameList {clear : none !important; width:50%; margin-bottom:20px;}
			.frameList tr {height:40px;}
			.frameList tr:first-child {height : 78px;}
			.frameList tr:first-child th {border : none; background-color:white;}
			.frameList td {text-align : center; border:1px solid #e1e1e1;}
			.frameList th {width:61px;}
		</style>
	</head>
	
	<body class="mainbody">
		<h1>테마관리</h1>
		
		<div id="mainmenu">    
		    <span><b>회사선택 :</b> 
			    <select id="ListCompany">
			    </select><br /><br />
		    </span>
		</div>
		
		<ul id="themeList">
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
		
		function openThemeDetail(event) {
			var themeId = event.data.themeId;
			var nowShowDetails = $(".showDetails").attr("id");
			
			if (nowShowDetails == "themeDetails" + themeId) { 
				$(".themeDetails").slideUp();
			} else {
				$(".themeDetails").hide();
			}
			
			$(".themeDetails").attr("class", "themeDetails hideDetails");
			
			if (nowShowDetails != "themeDetails" + themeId) {
				getThemeDetail(themeId);
				
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
					
					themes.forEach(function (item, index) {
						themesHTML += "<li>";
						themesHTML += "<div class='themeImg'>";
						themesHTML += "<img src='/images/ezNewPortal/Theme1.GIF' class='themeThumbnails' alt='img02'/>";
						themesHTML += "<hr class='themeHr'/>";
						themesHTML += "<div class='themeTitle' id='themeTitle" + item.themeId + "'>";
						themesHTML += "<span class='themeName'>" + item.themeName + "</span>";
						themesHTML += "<span class='themeSetting'><img src='/images/kr/left/icon_setup.gif'/></span>";
						themesHTML += "</div>";
						themesHTML += "<div class='themeNotUsed'>&nbsp;</div>";
						themesHTML += "</div>";
						themesHTML += "</li>";
						
						themesHTML += "<div class='themeDetails' id='themeDetails" + item.themeId + "'>";
						themesHTML += "<img src='' class='themesImgDetails' alt='img02'/>";
						themesHTML += "<div class='themeInfo'>";
						themesHTML += "<div class='themeActive'>테마 활성화 : <label class='switch'><input type='checkbox'><span class='slider round'></span></label></div>";
						themesHTML += "<div class='btnpositionJsp'><a class='imgbtn previewBtn'><span>미리보기</span></a><a class='imgbtn updateThemeBtn'><span>저장</span></a><div id='close' class='close'><ul><li><span></li></ul></div></div>";
						themesHTML += "<div class='themeDefault'><input type='radio'/>기본테마설정</div>";
						themesHTML += "<div class='themeContent'></div>";
						themesHTML += "</div>";
						themesHTML += "<div class='frameInfo'>";
						themesHTML += "<p>[프레임설정]</p>";
						themesHTML += "<table class='frameList'></table>";
						themesHTML += "</div>";
						themesHTML += "</div>";
					});
					

					themesHTML += "<li>";
					themesHTML += "<div class='themeImg'>";
					themesHTML += "<img src='/images/ezNewPortal/Theme1.GIF' class='themeThumbnails' alt='img02'/>";
					themesHTML += "<hr class='themeHr'/>";
					themesHTML += "<div class='themeTitle'>";
					themesHTML += "<span class='themeName'>얜 안눌림</span>";
					themesHTML += "<span class='themeSetting'><img src='/images/kr/left/icon_setup.gif'/></span>";
					themesHTML += "</div>";
					themesHTML += "</div>";
					themesHTML += "</li>";

					themesHTML += "<li>";
					themesHTML += "<div class='themeImg'>";
					themesHTML += "<img src='/images/ezNewPortal/Theme1.GIF' class='themeThumbnails' alt='img02'/>";
					themesHTML += "<hr class='themeHr'/>";
					themesHTML += "<div class='themeTitle'>";
					themesHTML += "<span class='themeName'>얜 안눌림</span>";
					themesHTML += "<span class='themeSetting'><img src='/images/kr/left/icon_setup.gif'/></span>";
					themesHTML += "</div>";
					themesHTML += "</div>";
					themesHTML += "</li>";

					themesHTML += "<li>";
					themesHTML += "<div class='themeImg'>";
					themesHTML += "<img src='/images/ezNewPortal/Theme1.GIF' class='themeThumbnails' alt='img02'/>";
					themesHTML += "<hr class='themeHr'/>";
					themesHTML += "<div class='themeTitle'>";
					themesHTML += "<span class='themeName'>얜 안눌림</span>";
					themesHTML += "<span class='themeSetting'><img src='/images/kr/left/icon_setup.gif'/></span>";
					themesHTML += "</div>";
					themesHTML += "</div>";
					themesHTML += "</li>";
					
					document.getElementById("themeList").innerHTML = themesHTML;
					
					//event setting
					themes.forEach(function (item, index) {
						$("#themeTitle" + item.themeId).find(".themeSetting").on("click", {"themeId" : item.themeId}, openThemeDetail);
						$("#themeDetails" + item.themeId).find(".updateThemeBtn").on("click", {"themeId" : item.themeId}, updateTheme);
						
						if (!item.themeUsed) {
							$("#themeTitle" + item.themeId).parent().find(".themeNotUsed").css("display", "");
						}
						
						if (item.themeDefault) {
							$("#themeTitle" + item.themeId).parent().css("background-color", "rgb(182, 226, 255)");
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
					
					$("#themeDetails" + theme.themeId).find(".themesImgDetails").attr("src", "/images/ezNewPortal/Theme1.GIF");
					$("#themeDetails" + theme.themeId).find(".themeContent").text(theme.themeContent);
					
					if (theme.themeUsed) {
						$("#themeDetails" + theme.themeId).find(".switch").find("input").prop("checked", true);
					}
					
					if (theme.themeDefault) {
						$("#themeDetails" + theme.themeId).find(".themeDefault").find("input").prop("checked", true);
					}
					
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
					if (request.status >= 200 && request.status < 400) {
						
					} else {
						// We reached our target server, but it returned an error
					}
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
	</script>
</html>