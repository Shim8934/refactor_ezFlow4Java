<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/survey.css')                 }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		<style type="text/css">
		</style>
	</head>
	<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')}               "></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}    "></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/chart.min.js')}"></script>
	<body class="statBody">
		<div class="surveyCrtTt3">
			<div class="sryFirst2"></div>
			<div class="sryTxt"><spring:message code='ezSurvey.t34'/></div>
			<img src="/images/ezSurvey/partiCount.png">
			<span id="totalUserCnt"></span>
		</div>
		
		<div id="contentsBox">
			<div id="surveyRespondents" style="height: 240px; position: relative; box-shadow: rgba(0, 0, 0, 0.69) 0px 1px 5px 0px; margin-bottom: 10px;">
				<div style="position: absolute; top: 0px; right: 0px; padding: 8px; font-size: 14px;" id="totalRespondents"></div>
				<div id="respondentPie" style="height: 100%;"></div>
			</div>
			<div id="barChart" style=" height: 460px; box-shadow: rgba(0, 0, 0, 0.69) 0px 1px 5px 0px; margin-bottom: 10px;"></div>
		</div>
		
		<script type="text/javascript">
		(function() {
			var colors = ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89", "#90d4f7", "#71e096", "#f5a26f",
						  "#668de5", "#ed6d79", "#5ad0e5", "#da97e0", "#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924",
						  "#d41e47", "#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431", "#d41e47", "#eb148d"];
			
			var surveyStatistic   = ${data};
			var questionStatistic = ${questions};
			
			console.log(surveyStatistic);
			console.log(questionStatistic);
			
			startStatistic(questionStatistic);
			
			function startStatistic(questions) {
				test();
				for (var i = 0; i < questions.length; i++) {
					showQuestionStatistic(questions[i]);
				}
			}
			
			function showQuestionStatistic(question) {
				//Create question header here
				var mainDivElmt   = document.getElementById("contentsBox");
				var divElmt       = document.createElement("div");
				var divId         = "question" + question["level"];
				divElmt.setAttribute("id", divId);
				mainDivElmt.appendChild(divElmt);
				
				//Create question statistic for each type
				var questionType = parseInt(question["type"]);
				switch(questionType) {
					case 1:
					case 2:
						divElmt.className = "pieDiv";
						//createQuestionPie(question, divId);
						break;
					case 3:
					case 4:
						divElmt.className = "barDiv";
						createQuestionBar(question, divId);
						break;
					case 5:
					case 6:
						break;
					case 7:
						break;
					case 8:
					case 9:
						break;
				}
			}
			
			function createQuestionPie(question, divId) {
				var options = question["option"];
				var data    = [];
				var hasResp = false;
				
				for (var i = 0; i < options.length; i++) {
					var optResponse     = {};
					var responses       = options[i]["responses"];
					var responsesCnt    = 0;
					if (responses && responses.length > 0) {
						responsesCnt = responses.length;
						hasResp      = true;
					} 
					
					optResponse["name"] = options[i]["content"];
					optResponse["y"]    = responsesCnt;
					optResponse["more"] = options[i]["responses"];
					data.push(optResponse);
				}
				
				if (hasResp) {
					console.log(data);
					createPieChart(data, divId);
				}
				else {
					//Show empty responses question image
					var imgElmt = document.createElement("img");
					imgElmt.src = "/images/ezSurvey/nores";
					document.getElementById(divId).appendChild(imgElmt);
				}
			}
			
			function test() {
				var data        = [];
				var totalUsers  = parseInt(surveyStatistic["usersCnt"]);
				var respondents = parseInt(surveyStatistic["respondentCnt"]);
				var notTakePart = totalUsers - respondents;
				
				data.push({
					name : '참석한 사람 [' + respondents + SurveyMessages.strUser3 +']',
					y    : respondents
				});
				
				data.push({
					name : '참석하 지않은 사람 [' + notTakePart + SurveyMessages.strUser3 +']',
					y    : notTakePart
				});
				
				document.getElementById("totalUserCnt").innerHTML     = totalUsers;
				document.getElementById("totalRespondents").innerHTML = SurveyMessages.strTotal + " " + totalUsers + SurveyMessages.strUser3;
				createPieChart(data, "respondentPie");
			}
			/* 
			function createPieChart(userData, elmtId) {
				Highcharts.chart(elmtId, {
					chart: {
						plotBackgroundColor: null,
						plotBorderWidth: null,
						plotShadow: false,
						type: 'pie'
					},
					title:{
						text: null
					},
					tooltip: {
						pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
					},
					legend: {
						layout: 'vertical',
						align: 'right',
						verticalAlign: 'middle',
						labelFormatter: function() {return this.name + " (" + this.percentage.toFixed(1) + "%)";},
						itemMarginTop: 10,
						itemMarginBottom: 10
					},
					plotOptions: {
						pie: {
							allowPointSelect: true,
							cursor: 'pointer',
							dataLabels: {enabled: true, align: 'left'},
							showInLegend: true
						},
						// series: {
						//	point: {
						//	events: {
						//		legendItemClick: function () {return false;}}
						//	}
						//}
					},
					credits: {enabled: false},
					series: [{
						name: '',
						colorByPoint: true,
						data: userData
					}]
				});
			}
			 */
			function createQuestionBar(question, divId) {
				console.log(question);
				console.log(divId);
			}
			
			function showMoreDetail() {
				alert("Show more detail");
			}
			
			function createChartStr(value, string, cnt) {return value + " - %%.%% [" + cnt + string + "]";}
		})();
	</script>
</html>