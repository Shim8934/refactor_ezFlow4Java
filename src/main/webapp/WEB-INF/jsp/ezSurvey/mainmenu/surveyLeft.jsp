<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>

<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezMemo/jquery.mCustomScrollbar.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<script type="text/javascript">
			var surveyId = -1;
			var isInCreateSurvey = false;
		</script>
	</head>
	
	<body class="newLeft over-fl">
		<div id="left" class="lnb survey_left" style="overflow: auto">
			<div class="left_title" title="<spring:message code='ezSurvey.t01'/>">
				<spring:message code='ezSurvey.t01'/>
				<span id="surveyConfig" class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezSurvey.t06"/>"></span>
			</div>
			<c:if test="${mode == 1}">
				<div class="btn_writeBox">
					<div class="surveyList mCustomScrollbar _mCS_1 mCS_no_scrollbar" style="height: 911px;">
						<div id="mCSB_1" class="mCustomScrollBox mCS-dark mCSB_vertical mCSB_inside" tabindex="0" style="max-height: none;">
							<div id="mCSB_1_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y" style="position:relative; top:0; left:0;" dir="ltr">
								<p class="btn_write01" id="createBttn"><spring:message code='ezSurvey.t19'/></p>
							</div>
						</div>
					</div>
				</div>
			</c:if>
			
			<div class="surveyList mCustomScrollbar _mCS_1 mCS_no_scrollbar" style="height: 911px;">
				<div id="mCSB_1" class="mCustomScrollBox mCS-dark mCSB_vertical mCSB_inside" tabindex="0" style="max-height: none;">
					<div id="mCSB_1_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y" style="position:relative; top:0; left:0;" dir="ltr">
						<ul class="lnbUL surveyUL">
							<li id="totalSurvey"><span class="list_text"><spring:message code='ezSurvey.t80'/></span></li>
							<li id="processingSurvey"><span class="list_text node_selected"><spring:message code='ezSurvey.t02'/></span></li>
							<li id="finishedSurvey"><span class="list_text"><spring:message code='ezSurvey.t03'/></span></li>
							<c:if test="${mode == 1}">
								<li id="mySurvey"><span class="list_text"><spring:message code='ezSurvey.t04'/></span></li>
								<li id="draftSurvey"><span class="list_text"><spring:message code='ezSurvey.t05'/></span></li>
							</c:if>
						</ul>
					</div>
				</div>
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
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
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
					
					/* 2021-08-27 홍승비 - 설문조사 신규작성 도중 메뉴클릭 시 취소여부 메세지 표출하도록 수정 (상태변경 동작은 수정 시에만 동작함) */
					if (draftSurvey) {draftSurvey.onclick = function(e) {
						// 2020.04.24 강승구 : 설문수정 도중 메뉴클릭시 modifyFlag수정 및 메시지처리 추가(모든 서브메뉴 적용)
						if (surveyId != -1 || isInCreateSurvey == true) {
							if (confirm(SurveyMessages.strCancelMsg)) {
								if (surveyId != -1) {
									changeSurveyState();
								}
								getDraftSurveyPage();
								isInCreateSurvey = false;
							}
						} else {
							getDraftSurveyPage();
							isInCreateSurvey = false;
						}
						liSelected();
					};}
					if (mySurvey)    {mySurvey.onclick    = function(e) {
						if (surveyId != -1 || isInCreateSurvey == true) {
							if (confirm(SurveyMessages.strCancelMsg)) {
								if (surveyId != -1) {
									changeSurveyState();
								}
								getMySurveyPage();
								isInCreateSurvey = false;
							}
						} else {
							getMySurveyPage();
							isInCreateSurvey = false;
						}
						liSelected();
					};}
					if (createBttn)  {createBttn.onclick  = function(e) {
						if (surveyId != -1 || isInCreateSurvey == true) {
							if (confirm(SurveyMessages.strCancelMsg)) {
								if (surveyId != -1) {
									changeSurveyState();
								}
								createNewSurvey();
								isInCreateSurvey = true;
							}
						} else {
							createNewSurvey();
							isInCreateSurvey = true;
						}
					};}
					
					document.getElementById("totalSurvey").addEventListener("click", function(e) {
						if (surveyId != -1 || isInCreateSurvey == true) {
							if (confirm(SurveyMessages.strCancelMsg)){
								if (surveyId != -1) {
									changeSurveyState();
								}
								getAllSurveyList();
								isInCreateSurvey = false;
							}
						} else {
							getAllSurveyList();
							isInCreateSurvey = false;
						}
						liSelected();
					});
					document.getElementById("surveyConfig").addEventListener("click", function(e) {
						if (surveyId != -1 || isInCreateSurvey == true) {
							if (confirm(SurveyMessages.strCancelMsg)) {
								if (surveyId != -1) {
									changeSurveyState();
								}
								getConfigPage();
								isInCreateSurvey = false;
							}
						} else {
							getConfigPage();
							isInCreateSurvey = false;
						}
					});
					document.getElementById("processingSurvey").addEventListener("click", function(e) {
						if (surveyId != -1 || isInCreateSurvey == true) {
							if (confirm(SurveyMessages.strCancelMsg)) {
								if (surveyId != -1) {
									changeSurveyState();
								}
								getProcessingSurveyList();
								isInCreateSurvey = false;
							}
						} else {
							getProcessingSurveyList();
							isInCreateSurvey = false;
						}
						liSelected();
					});
					document.getElementById("finishedSurvey").addEventListener("click", function(e) {
						if (surveyId != -1 || isInCreateSurvey == true) {
							if (confirm(SurveyMessages.strCancelMsg)) {
								if (surveyId != -1) {
									changeSurveyState();
								}
								getFinishedSurveyPage();
								isInCreateSurvey = false;
							}
						} else {
							getFinishedSurveyPage();
							isInCreateSurvey = false;
						}
						liSelected();
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
				
				function cancelSurvey (id) {
					if (surveyId != -1 || isInCreateSurvey == true) {
						if (surveyId != -1) {
							changeSurveyState();
						}
						switch (id) {
							case 'surveyConfig':
								getConfigPage();
								break;
							case 'totalSurvey':
								getAllSurveyList();
								break;
							case 'processingSurvey':
								getProcessingSurveyList();
								break;
							case 'finishedSurvey':
								getFinishedSurveyPage();
								break;
							case 'mySurvey':
								getMySurveyPage();
								break;
						}
						isInCreateSurvey = false;
					}
				}
				
				return {
					cancelSurvey:cancelSurvey
				};
			}();
			
			// 2023-06-15 황인경 - 디자인 개선 > 전자설문 > 좌측메뉴 > 메뉴선택 클래스 제어
			function liSelected() {
				if (event.target.classList.contains("list_text")) {
					$(".node_selected").attr("class", "list_text");
					
					if (event.target.tagName == "LI") {
						var liChangeSpan = event.target.querySelector(".list_text");
						liChangeSpan.setAttribute("class", "list_text node_selected");
					} else {
						event.target.setAttribute("class", "list_text node_selected");
					}
				}
			}
			
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