<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>

<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezSurvey.css', 'msg'                    )}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezMemo/jquery.mCustomScrollbar.css')}" type="text/css">
		<script type="text/javascript">
			var surveyId = -1;
		</script>
	</head>
	
	<body class="newLeft over-fl">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="left_title" title="<spring:message code='ezSurvey.t01'/>">
				<spring:message code='ezSurvey.t01'/>
				<span id="surveyConfig" class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezSurvey.t06"/>"></span>
			</div>
			<div class="btn_writeBox">
				<c:if test="${mode == 1}">
					<p class="btn_write01" id="createBttn"><span class="sub_iconLNB tree_write"></span><spring:message code='ezSurvey.t19'/></p>
				</c:if>
			</div>
			
			<div class="surveyList">
				<ul class="lnbUL">
					<li id="totalSurvey"><span class="sub_iconLNB tree_srvy_all"></span><span class="list_text"><spring:message code='ezSurvey.t80'/></span></li>
					<li id="processingSurvey"><span class="sub_iconLNB tree_srvy_ing"></span><span class="list_text"><spring:message code='ezSurvey.t02'/></span></li>
					<li id="finishedSurvey"><span class="sub_iconLNB tree_srvy_ok"></span><span class="list_text"><spring:message code='ezSurvey.t03'/></span></li>
					<c:if test="${mode == 1}">
						<li id="mySurvey"><span class="sub_iconLNB tree_srvy_my"></span><span class="list_text"><spring:message code='ezSurvey.t04'/></span></li>
						<li id="draftSurvey"><span class="sub_iconLNB tree_srvy_draft"></span><span class="list_text"><spring:message code='ezSurvey.t05'/></span></li>
					</c:if>
				</ul>
			</div>
			
			<%-- 
				<!-- 전체 설문 -->
				<h2 id="totalSurvey"><span><spring:message code='ezSurvey.t80'/></span></h2>
				
				<!-- 진행중 설문 -->
				<h2 id="processingSurvey"><span><spring:message code='ezSurvey.t02'/></span></h2>
				
				<!-- 완료된 설문 -->
				<h2 id="finishedSurvey"><span><spring:message code='ezSurvey.t03'/></span></h2>
				
				<!-- 내가 작성한 설문 -->
				<h2 id="mySurvey"><span><spring:message code='ezSurvey.t04'/></span></h2>
				
				<!-- 임시 보관함 -->
				<h2 id="draftSurvey"><span><spring:message code='ezSurvey.t05'/></span></h2>
			 --%>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js'                   )}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js'      )}"></script>
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg'                 )}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript">
			var SurveyLeft = function() {
				setButtonEvents();
				
				function setButtonEvents() {
					document.onselectstart = function(e) {return false;}
					var draftSurvey = document.getElementById("draftSurvey");
					var mySurvey    = document.getElementById("mySurvey");
					var createBttn  = document.getElementById("createBttn");
					
					if (draftSurvey) {draftSurvey.onclick = function(e) {
						// 2020.04.24 강승구 : 설문수정 도중 메뉴클릭시 modifyFlag수정 및 메시지처리 추가(모든 서브메뉴 적용)
						if(surveyId != -1){
							if(confirm(SurveyMessages.strCancelMsg)){
								changeSurveyState();
								getDraftSurveyPage();
							}
						} else {
							getDraftSurveyPage();	
						}
					};}
					if (mySurvey)    {mySurvey.onclick    = function(e) {
						if(surveyId != -1){
							if(confirm(SurveyMessages.strCancelMsg)){
								changeSurveyState();	
								getMySurveyPage();
							}
						} else {
							getMySurveyPage();	
						}
					};}
					if (createBttn)  {createBttn.onclick  = function(e) {
						if(surveyId != -1){
							if(confirm(SurveyMessages.strCancelMsg)){
								changeSurveyState();
								createNewSurvey();
							}
						} else {
							createNewSurvey();	
						}
					};}
					
					document.getElementById("totalSurvey"     ).addEventListener("click", function(e) {
						if(surveyId != -1){
							if(confirm(SurveyMessages.strCancelMsg)){
								changeSurveyState();	
								getAllSurveyList();	
							}
						} else {
							getAllSurveyList();	
						}
					});
					document.getElementById("surveyConfig"    ).addEventListener("click", function(e) {
						if(surveyId != -1){
							if(confirm(SurveyMessages.strCancelMsg)){
								changeSurveyState();	
								getConfigPage();
							}
						} else {
							getConfigPage();	
						}
					});
					document.getElementById("processingSurvey").addEventListener("click", function(e) {
						if(surveyId != -1){
							if(confirm(SurveyMessages.strCancelMsg)){
								changeSurveyState();		
								getProcessingSurveyList();
							}
						} else {
							getProcessingSurveyList();	
						}
					});
					document.getElementById("finishedSurvey"  ).addEventListener("click", function(e) {
						if(surveyId != -1){
							if(confirm(SurveyMessages.strCancelMsg)){
								changeSurveyState();		
								getFinishedSurveyPage();
							}
						} else {
							getFinishedSurveyPage();
						}
					});
					window.addEventListener("resize", function(e) {windowResize();}, false);
					//getAllSurveyList();
					getProcessingSurveyList();
					windowResize();
					$(".surveyList").mCustomScrollbar({theme : "dark"});
				}
				
				function getConfigPage()           {window.parent.frames["right"].location.href = "/ezSurvey/surveyConfig.do";}
				function getAllSurveyList()        {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=all";}
				function getProcessingSurveyList() {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=processing";}
				function getFinishedSurveyPage()   {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=finish";}
				function getMySurveyPage()         {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=my";}
				function getDraftSurveyPage()      {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=draft";}
				function createNewSurvey()         {window.parent.frames["right"].location.href = "/ezSurvey/createSurvey.do";}
				function changeSurveyState() {
					$.ajax({
						type: "GET",
						url: "/ezSurvey/changeSurveyState.do",
						data: {surveyId : surveyId},
						contentType: "application/json; charset=utf-8",
						dataType: "JSON",
						async: false,
						cache: false,
						success : function(data) {
							surveyId = -1;
						},
						error : function(error) {}
					});
				}
				
				function windowResize() {$(".surveyList").height(window.innerHeight - 105);}
				
				return {
					
				};
			}();
		</script>
	</body>
	
	<%-- <body class="leftbody" style="overflow: auto; height: 100%;">
		<div id="left">
			<div class="left_survey"><span><spring:message code='ezSurvey.t01'/></span></div>
			
			<!-- 전체 설문 -->
			<h2 id="totalSurvey"><span><spring:message code='ezSurvey.t80'/></span></h2>
			
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
					document.getElementById("totalSurvey"     ).addEventListener("click", function(e) {getAllSurveyList()       ;});
					document.getElementById("surveyConfig"    ).addEventListener("click", function(e) {getConfigPage()          ;});
					document.getElementById("processingSurvey").addEventListener("click", function(e) {getProcessingSurveyList();});
					document.getElementById("finishedSurvey"  ).addEventListener("click", function(e) {getFinishedSurveyPage()  ;});
					document.getElementById("mySurvey"        ).addEventListener("click", function(e) {getMySurveyPage()        ;});
					document.getElementById("draftSurvey"     ).addEventListener("click", function(e) {getDraftSurveyPage()     ;});
					getAllSurveyList();
				}
				
				function getConfigPage()           {window.parent.frames["right"].location.href = "/ezSurvey/surveyConfig.do";}
				function getAllSurveyList()        {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=all";}
				function getProcessingSurveyList() {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=processing";}
				function getFinishedSurveyPage()   {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=finish";}
				function getMySurveyPage()         {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=my";}
				function getDraftSurveyPage()      {window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=draft";}
				
				return {
					
				};
			}();
		</script>
	</body> --%>
</html>