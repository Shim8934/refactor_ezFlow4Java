<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>

<head>
	<title><spring:message code="ezSurvey.t34"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/survey.css')                 }">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
	
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}   "></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }   "></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.ddslick.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')}              "></script>
</head>
	
<body class="mainbody srvey">
	<div id="svInfoWrapper" class="svInfoWrapper">
	<div id="wtInfoArea" class="wtInfoArea">
		<div id="wtImgArea" class="wtImgArea">
			<img id="wtImg" class="wtImg" src="${not empty creator.userFileUrl ? creator.userFileUrl : '/images/default_pic.jpg'}"/>
		</div>
		<div id="wtInfo" class="wtInfo">
			<strong id="wtName" class="wtName"><c:out value="${creator.displayName}"/></strong>
			<strong id="wtTime" class="wtTime"><c:out value="${survey.createDate}"/></strong>
		</div>
	</div>
	
	<div id="infoBtns" class="infoBtns">
		<img id="suvyDlt"  class="suvyDlt"  src="/images/ezSurvey/delete2.png"/>
		<img id="suvyInfo" class="suvyInfo" src="/images/ezSurvey/info.png"   />
	</div>
	
	</div>

	<div id="svTitle" class="svTitle">
		<div class="sryFirst2"></div>
		<span id="title" class="sryTxt">${survey.title}</span>
	</div>
	
	<div id="svPurpose" class="svPurpose">
		<div id="ppContent" class="ppContent">${survey.purpose}</div>
	</div>
	
	<div class="prevQsArea"></div>
	
	<div class="detailBtns" style="text-align: right;">
		<div class="survey-bttn-wrp">
			<img id="saveResult" src="/images/ezSurvey/save2.png"/>
			<img id="cancelBttn" src="/images/ezSurvey/cancel2.png"/>
		</div>
	</div>
	
</body>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/survey.js')} }"></script>
<script type="text/javascript">
	$(function() {
		var survey     = ${survey};
		var surveyId   = survey.surveyId;
		var logicmap   = null;
		var surveyPath = [];
		getQuestions();
		userEvent();
		
		function getQuestions() {
			$.ajax({
				type: "GET",
				url: "/ezSurvey/getSurveyQuestions.do",
				data: {surveyId : surveyId},
				contentType: "application/json; charset=utf-8",
				dataType: "JSON",
				async: true,
				success : function(data) {
					var question  = JSON.parse(JSON.stringify(data["questions"]));
					if (data["logicmap"]) {logicmap = JSON.parse(JSON.stringify(data["logicmap" ]));}
					
					for (var i = 0; i < question.length; i++) {
						SurveyCreate.setQs(question[i]);
					}
					
					SurveyCreate.setQsForm(4);
					
					if (data["firstpath"]) {
						toggleQuestionList(JSON.parse(JSON.stringify(data["firstpath"])));
					}
				},
				error : function(error) {
					alert(SurveyMessages.strError);
				}
			});
		}
		
		function processLogicNode(parentNode, nodeLevel) {
			var path      = [];
			var totalPath = [];
			traverNode(nodeLevel, path, totalPath);
			
			//Get remain nodes
			var mainNodes = totalPath[0];
			for (var i = 1; i < totalPath.length; i++) {
				mainNodes = mainNodes.filter(function(value) {if (-1 !== totalPath[i].indexOf(value)) {return value;}});
			}
			
			if (surveyPath.length == 0) {
				surveyPath.push(parentNode);
			}
			else {
				var parentPos = surveyPath.indexOf(parentNode);
				surveyPath.length = parentPos + 1;
			}
			
			surveyPath = surveyPath.concat(mainNodes);
			
			//Show/hide questions
			toggleQuestionList(surveyPath);
			
			surveyPath.sort(function(a, b) {return a - b}); //sort surveyPath
		}
		
		function toggleQuestionList(checkList) {
			var listQstDiv = document.getElementsByClassName("prevQsWrapper");
			for (var i = 0, len = listQstDiv.length; i < len; i++) {
				var qstLevel = parseInt(listQstDiv[i].id.replace("prevQstn", ""));
				if (checkList.indexOf(qstLevel) == -1) {
					listQstDiv[i].style.display = "none";
				}
				else {
					listQstDiv[i].style.display = "";
				}
			}
		}
		
		function traverNode(nodeLevel, currentPath, totalPath) {
			var nodeList = logicmap[nodeLevel];
			currentPath.push(parseInt(nodeLevel));
			if (nodeList.length == 1) {
				var nxtQst = parseInt(nodeList[0]);
				if (nxtQst == 0) {
					totalPath.push(currentPath);
				}
				else {
					traverNode(nxtQst, currentPath, totalPath);
				}
			}
			else {
				for (var i = 0; i < nodeList.length; i++) {
					var clonePath = currentPath.slice(0);
					traverNode(parseInt(nodeList[i]), clonePath, totalPath);
				}
			}
		}
		
		function userEvent() {
			$(".prevQsArea").on("click", ".optRdo", function() {
				var prId     = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logicNum = $(this).attr("logic");
				
				if (logicNum && logicmap) {
					processLogicNode(parseInt(prId), parseInt(logicNum));
				}
			});
			
			$(".prevQsArea").on("click", ".optChk", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logicNum = $(this).attr("logic");
				
				if (logicNum && logicmap) {
					processLogicNode(parseInt(id), parseInt(logicNum));
				}
			});
			
			$(".prevQsArea").on("change", ".dropdown-wrap", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logic = $("select[name=drdw" + id + "] option:selected").attr("logic");
				
				if (logicNum && logicmap) {
					processLogicNode(parseInt(id), parseInt(logicNum));
				}
			});
			
			$(".prevQsArea").on("input", ".slider-range", function() {
				var outputElmt         = this.parentElement.parentElement.querySelector("output[class='slider-output']");
				outputElmt.textContent = this.value;
			}).trigger("change");
			
			$(".prevQsArea").on("change", ".slider-range", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logic = $("#slider" + id).attr("logic");
				var logicPoint = $("#slider" + id).attr("logicPoint");
				
				
			});
		}
		
	});
</script>
</html>