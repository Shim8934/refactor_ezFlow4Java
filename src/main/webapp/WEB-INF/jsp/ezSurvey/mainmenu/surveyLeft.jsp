<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>

<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezSurvey.css', 'msg')}"      type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezSurvey/survey.css')}" type="text/css">
	</head>
	
	<body class="leftbody" style="overflow: auto; height: 100%;">
		<div id="left">
			<div class="left_survey"><span><spring:message code='ezSurvey.t01'/></span></div>
			
			<!-- 진행중 설문 -->
			<h2 id="processingSurvey"><span><spring:message code='ezSurvey.t02'/></span></h2>
			
			<!-- 완료된 설문 -->
			<h2 id="finishedSurvey"><span><spring:message code='ezSurvey.t03'/></span></h2>
			
			<!-- 내가 작성한 설문 -->
			<h2 id="mySurvey"><span><spring:message code='ezSurvey.t04'/></span></h2>
			
			<!-- 임시 보관함 -->
			<h2 id="draftSurvey"><span><spring:message code='ezSurvey.t05'/></span></h2>
			
			<!-- 환경설정 -->
			<h3 id="surveyConfig"><span><spring:message code="ezSurvey.t06"/></span></h3>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')             }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')           }"></script>
		<script type="text/javascript">
			var SurveyLeft = function() {
				setButtonEvents();
				
				function setButtonEvents() {
					document.onselectstart = function(e) {return false;}
					/* initToggleList(document.getElementById("left"), "h2", "ul", "li"); */
					document.getElementById("surveyConfig"    ).addEventListener("click", function(e) {getConfigPage()          ;});
					document.getElementById("processingSurvey").addEventListener("click", function(e) {getProcessingSurveyList();});
					document.getElementById("finishedSurvey"  ).addEventListener("click", function(e) {getCreateSurveyPage()    ;});
				}
				
				function getConfigPage()           {window.parent.frames["right"].location.href = "/ezSurvey/surveyConfig.do";}
				function getProcessingSurveyList() {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=process";}
				function getCreateSurveyPage()     {window.parent.frames["right"].location.href = "/ezSurvey/createSurvey.do";}
				
				return {
					
				};
			}();
		</script>
	</body>
</html>