<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezSurvey.t34"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezSurvey.css', 'msg')}"       type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezSurvey/survey.css')}"  type="text/css">
	</head>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript">
	$(function() {
		
		$(".quesTypeSelect").click(function() {
			$(".option_wrap").show().animate({height: "300px"});
		});
		
		$(".select_op").mouseleave(function() {
			$(".option_wrap").hide();
			$(".option_wrap").css("height", "0");
		});
		
		$(".atchImg").click(function(e) {
			
			var clickObj = $(this).next();
			clickObj.click();
		});
		
		$(".sryTxt").click(function() {
			window.open("/ezSurvey/statisticsPage.do", "", GetOpenWindowfeature(500, 500));
		});
		 
	});
	</script>
	<body class="surveyBody">
		<div class="surveyCrtTtl">
			<div class="sryFirst"></div>
			<div class="sryTxt"><spring:message code='ezSurvey.t34'/></div>
		</div>
		
		<div class="headpanel">
			<span class="crust selected">
				<a class="crumb"><span><spring:message code='ezSurvey.t35'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t36'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t37'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
		</div>
		<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyInfomation.jsp"></jsp:include>
		<script type="text/javascript">
			(function() {
				var selectPopup = null;
				
				initEvents();
				
				function initEvents() {
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					document.getElementById("selectTarget").addEventListener("change", toggleSelectTargetBttn, false);
					document.getElementById("targetBttn"  ).addEventListener("click" , showSelectPopUp       , false);
				}
				
				function toggleSelectTargetBttn() {
					var sltBoxElmt       = document.getElementById("selectTarget");
					var targetBttn       = document.getElementById("targetBttn");
					var sltedIdx         = sltBoxElmt.selectedIndex;
					targetBttn.className = sltedIdx == 0 ? "target-select" : "target-select on";
				}
				
				function showSelectPopUp() {
					selectPopup = window.open("/ezSurvey/selectUsers.do", "selectUser", getOpenWindowfeature(1125, 700));
				}
				
				function getOpenWindowfeature(popUpW, popUpH) {
					var heigth   = window.screen.availHeight;
					var width    = window.screen.availWidth;
					var left     = 0;
					var top      = 0;
					var pleftpos = parseInt(width) - popUpW;
					heigth       = parseInt(heigth) - popUpH;
					left         = pleftpos / 2;
					top          = heigth / 2;
					var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
					return feature;
				}
				
				function closeAllPopups() {if(selectPopup) {selectPopup.close();}}
			})();
		</script>
	</body>
</html>