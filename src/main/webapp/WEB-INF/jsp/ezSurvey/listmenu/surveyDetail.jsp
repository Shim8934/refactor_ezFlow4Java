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
				<strong id="wtName" class="wtName" >${survey.creatorName}</strong>
				<strong id="wtTime" class="wtTime" >${survey.updateDate}</strong>
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
		<div><button id="saveResult">결과 저장</button><button>취소</button></div>
	</div>
	
</body>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/survey.js')} }"></script>
<script type="text/javascript">
	$(function() {
		var survey = ${survey};
		var surveyId = survey.surveyId;
		getQuestions();
		
		event();
		
		function event() {
			$(".prevQsArea").on("click", "input[name^=qstn]", function () {
				var logic = $(this).attr("logic");
				console.log(logic);
			});
		}
		
		function getQuestions() {
			$.ajax({
				type: "GET",
				url: "/ezSurvey/getSurveyQuestions.do",
				data: {surveyId : surveyId},
				contentType: "application/json; charset=utf-8",
				dataType: "JSON",
				async: true,
				success : function(data) {
					var question = JSON.parse(JSON.stringify(data["questions"]));
					
					for (var i = 0; i < question.length; i++) {
						SurveyCreate.setQs(question[i]);
					}
					SurveyCreate.setQsForm(4);
					
					getAllLogicNums();
					
				},
				error : function(error) {
					alert(SurveyMessages.strError);
				}
			});
		}
		
		function getAllLogicNums() {
			var QsList = SurveyCreate.getQs();
			var stop = "";
			
			for (var i = 0; i < QsList.length; i++) {
				var array = [];
				var logicFlag = QsList[i]['logicFlag'];
				
				if (logicFlag == 1) {
					var options = QsList[i]['option'];
					
					for (var j = 0; j < options.length; j++) {
						var option = options[j];
						var logic = option['logic'];
						
						if (logic != -1) {
							array.push(logic);
							console.log(array);
						}
						
					}
					
					array.sort();
					qsDisable(array);
					console.log(array);
				}
			}
		}
		
		function qsDisable(array) {
			var orders = "";
			var wrapper = "";
			var height = "";
			var width = "";
			
			for (var i = 0; i < array.length; i++) {
				orders = array[i];
				wrapper = $("#prevQstn" + orders);
				
				var result = checkMask(wrapper);

				if (result == "make") {
					height = wrapper.height();
					width = wrapper.width();
					
					var mask = $("<div id='mask" + orders + "'></div>");
					wrapper.prepend(mask);
					wrapper.find("#mask" + orders).css({'width': width, 'height': height, 'background-color' : 'gray', 'opacity' : '0.5', 'position' : 'absolute'});
				}
			}
		}
		
		function checkMask(wrapper) {
			console.log(wrapper);
			var mask = wrapper.find("div[id^=mask]");
			
			if (mask.length != 0) {
				return "pass";

			} else {
				return "make";
			}
		}
		
	});
</script>
</html>