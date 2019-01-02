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
		var logicFlagQs = [];
		//var allLogics = [];
		var allLogics = {};

		getQuestions();
		
		event();
		
		function event() {
			$(".prevQsArea").on("click", "input[name^=qstn]", function () {
				var logic = $(this) .attr("logic");
				/* 
				var qstnList = SurveyCreate.getQs;
				for (var i = logic + 1; i < qstnList.length; i++) {
					var logicFlag = qstnList[i]['logicFlag'];
					if (logicFlag == undefined || logicFlag == 0) {
						$("#mask" + (i + 1)).remove();
					}
				}
				 */
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
					
					setAllLogicFlagQs();
					// console.log(logicFlagQs);
					console.log(allLogics);
				},
				error : function(error) {
					alert(SurveyMessages.strError);
				}
			});
		}
		// logicFlag가 1인 question id 수집
		function setAllLogicFlagQs() {
			var qstnList = SurveyCreate.getQs();
			
			for (var i = 0; i < qstnList.length; i++) {
				var qstn = qstnList[i];
				var logicFlag = qstn['logicFlag'];
				
				if (logicFlag == 1) {
					logicFlagQs.push(i + 1);
				}
			}
			
			for (var i = 0; i < logicFlagQs.length; i++) {
				var logicQsNum = logicFlagQs[i] - 1;
				getLogicNums(logicQsNum);
			}
		}
		// logic을 가진 질문들의 logic number 수집
		function getLogicNums(qstnNo) {
			var qstn = SurveyCreate.getQs()[qstnNo];
			var options = qstn['option'];
			var arr = [];
			
			for (var j = 0; j < options.length; j++) {
				var option = options[j];
				var logic = option['logic'];
				
				if (logic != -1) {
					if (j == 0) {
						arr.push(logic);
					
					} else if (j != 0 && arr[0] != logic) {
						arr.push(logic);
					}
				}
			}
			test(qstnNo + 1, arr);
		}
		// 다음 분기 이전까지의 질문 묶음 생성
		function test(qstnLevel, array) {
			array.sort(function(f, n) {return f-n;});
			
			var QsList = SurveyCreate.getQs();
			//var bigArr = [];
			var bigArr = {};
			var reArr = [];
			
			for (var i = 0; i < array.length; i++) {
				var start = array[i] - 1;
				
				var smallArr = [];
				for (var j = start; j < QsList.length; j++) {
					var logicFlag = QsList[j]['logicFlag'];
					
					if (logicFlag != 1) {
						smallArr.push(j + 1);
					} else {
						smallArr.push(j + 1);
						//reArr.push(j + 1);
						break;
					}
				}
				//smallArr.splice(0, 0, qstnLevel);
				//bigArr.push(smallArr);
				var length = smallArr.length - 1;
				var lastNum = smallArr[length];
				bigArr[lastNum] = smallArr;
			}
			//allLogics.push(bigArr);
			allLogics[qstnLevel] = bigArr;
		}
		
		/* 
		function qsDisable(array) {
			array.sort(function(f, n) {return f-n;});
			console.log(array);
			//var arrLength = parseInt(array.length);
			
			var orders = "";
			var wrapper = "";
			var height = "";
			var width = "";
			var startNum = array[0];
			var endNum = array[array.length -1] + 1;
			//var endNum = lastNum + 1; 
			
			for (var i = startNum; i < endNum; i++) {
				wrapper = $("#prevQstn" + i);
				
				var result = checkMask(wrapper);

				if (result == "make") {
					height = wrapper.height();
					width = wrapper.width();
					
					var mask = $("<div id='mask" + i + "'></div>");
					wrapper.prepend(mask);
					wrapper.find("#mask" + i).css({'width': width, 'height': height, 'background-color' : 'gray', 'opacity' : '0.5', 'position' : 'absolute'});
				}
			}
		}
		 */
		function checkMask(wrapper) {
			var mask = wrapper.find("div[id^=mask]");
			
			if (mask.length == 0) {
				return "make";

			} else {
				return "pass";
			}
		}
		
	});
</script>
</html>