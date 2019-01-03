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
			<img id="wtImg" class="wtImg" alt="" src="" style="background-color: white;"/>
		</div>
		<div id="wtInfo" class="wtInfo">
			<strong id="wtName" class="wtName" >작성자 이름</strong>
			<strong id="wtTime" class="wtTime" >설문 작성 시간</strong>
		</div>
	</div>
	
	<div id="infoBtns" class="infoBtns" style="float:right;width: 220px;height: 100%;">
		<img id="suvyMdf" class="suvyMdf" alt="" src="/images/ezSurvey/xBtn.png" style="width: 50px;height: 50px;padding: 10px;" />
		<img id="suvyDlt" class="suvyDlt" alt="" src="/images/ezSurvey/xBtn.png" style="width: 50px;height: 50px;padding: 10px;" />
		<img id="suvyInfo" class="suvyInfo" alt="" src="/images/ezSurvey/xBtn.png" style="width: 50px;height: 50px;padding: 10px;" />
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
		<!-- <div id="" class=""><img src="/images/ezSurvey/prevstep.png"></div> -->
		<div>
			<button id="saveResult">결과 저장</button>
			<button>취소</button>
		</div>
	</div>
	
</body>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/survey.js')} }"></script>
<script type="text/javascript">
	$(function() {
		var survey   = ${survey};
		var surveyId = survey.surveyId;
		var logicmap = null;
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
					var firstpath = JSON.parse(JSON.stringify(data["firstpath"]));
					
					if (data["logicmap"]) {logicmap = JSON.parse(JSON.stringify(data["logicmap"]));}
					
					for (var i = 0; i < question.length; i++) {
						SurveyCreate.setQs(question[i]);
					}
					
					SurveyCreate.setQsForm(4);
					
					var listQstDiv = document.getElementsByClassName("prevQsWrapper");
					for (var i = 0, len = listQstDiv.length; i < len; i++) {
						var qstLevel = parseInt(listQstDiv[i].id.replace("prevQstn", ""));
						if (firstpath.indexOf(qstLevel) == -1) {
							listQstDiv[i].style.display = "none";
						}
					}
					
					console.log(JSON.stringify(data["logicmap"]));
				},
				error : function(error) {
					alert(SurveyMessages.strError);
				}
			});
		}
		
		function traverNode(nodeLevel, currentPath, totalPath) {
			var nodeList = logicmap[nodeLevel];
			currentPath.push(nodeLevel);
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
					
				}
			}
		}
		
		function userEvent() {
			$(".prevQsArea").on("click", ".optRdo", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logicNum = $(this).attr("logic");
				
			});
			
			$(".prevQsArea").on("click", ".optChk", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logicNum = $(this).attr("logic");
				
			});
			
			$(".prevQsArea").on("change", ".dropdown-wrap", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logic = $("select[name=drdw" + id + "] option:selected").attr("logic");
				
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