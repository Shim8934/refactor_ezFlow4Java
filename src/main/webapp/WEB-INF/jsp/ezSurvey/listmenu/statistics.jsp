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
		<style type="text/css"></style>
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
				<div style="padding: 0px 60px; box-sizing:border-box;"><canvas id="respondentPie"  height="240" width="640"></canvas></div>
			</div>
			<div id="barChart" style="display: none; height: 460px; box-shadow: rgba(0, 0, 0, 0.69) 0px 1px 5px 0px; margin-bottom: 10px;"></div>
		</div>
		
		<script type="text/javascript">
		(function() {
			var colors = ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89", "#90d4f7", "#71e096", "#f5a26f",
						  "#668de5", "#ed6d79", "#5ad0e5", "#da97e0", "#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924",
						  "#d41e47", "#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431", "#d41e47", "#eb148d"];
			
			var surveyStatistic   = ${data};
			var questionStatistic = ${questions};
			
			//console.log(surveyStatistic);
			//console.log(questionStatistic);
			
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
				divElmt.className = "response-wrap";
				var questionType  = question["type"];
				var options       = question["option"];
				var responses     = [];
				
				//Get users for each question
				if (questionType == 1 || questionType == 2 || questionType == 9) {
					for (var i = 0; i < options.length; i++) {
						if (options[i]["responses"]) {
							responses = responses.concat(options[i]["responses"]);
						}
					}
				}
				else {
					responses = question["responses"];
				}
				
				//console.log("Response");
				//console.log(responses);
				
				var userQuestion  = getUsersForQuestion(responses);
				
				//console.log("Users");
				//console.log(userQuestion);
				
				var divHeader     = createHeaderDiv(question, userQuestion);
				divElmt.appendChild(divHeader);
				mainDivElmt.appendChild(divElmt);
				
				//Create question statistic for each type
				var questionType = parseInt(question["type"]);
				switch(questionType) {
					case 1:
					case 2:
					case 9:
						var divChart       = document.createElement("div");
						divChart.className = "pieDiv";
						var canvasElmt     = document.createElement("canvas");
						var canvasId       = "question" + question["level"];
						canvasElmt.setAttribute("height", 240);
						canvasElmt.setAttribute("width", 640);
						canvasElmt.setAttribute("id", canvasId);
						divChart.appendChild(canvasElmt);
						divElmt.appendChild(divChart);
						createQuestionPie(question, canvasId);
						break;
					case 3:
					//case 4:
					case 7:
						divElmt.className = "barDiv";
						var canvasElmt = document.createElement("canvas");
						var canvasId   = "question" + question["level"];
						canvasElmt.setAttribute("height", 240);
						canvasElmt.setAttribute("width", 640);
						canvasElmt.setAttribute("id", canvasId);
						divElmt.appendChild(canvasElmt);
						createQuestionBar(question, canvasId);
						break;
					case 5:
					case 6:
						break;
					case 8:
						break;
				}
			}
			
			function getUsersForQuestion(responses) {
				if (!responses || responses.length == 0) {
					return [];
				}
				else {
					var userList = [];
					for (var i = 0; i < responses.length; i++) {
						if (!userList.includes(responses[i]["responsorId"])) {
							userList.push(responses[i]);
						}
					}
					
					return userList;
				}
			}
			
			function createHeaderDiv(question, userList) {
				var divElemt = document.createElement("div");
				divElemt.className = "reponse-header";
				var childDiv1 = document.createElement("div");
				var childDiv2 = document.createElement("div");
				childDiv1.textContent = question["level"] + "." + question["content"];
				childDiv2.textContent = "응답자 " + userList.length;
				divElemt.appendChild(childDiv1);
				divElemt.appendChild(childDiv2);
				return divElemt;
			}
			
			function createQuestionPie(question, canvasId) {
				var options = question["option"];
				var values  = [];
				var labels  = [];
				var hasResp = false;
				
				for (var i = 0; i < options.length; i++) {
					var responses       = options[i]["responses"];
					var responsesCnt    = 0;
					var optionContent   = "";
					
					if (responses && responses.length > 0) {
						responsesCnt = responses.length;
						hasResp      = true;
					} 
					
					if (options[i]["content"].length > 50) {
						optionContent = options[i]["content"].substring(0, 47) + "...";
					}
					else {
						optionContent = options[i]["content"];
					}
					
					values.push(responsesCnt);
					labels.push(optionContent);
				}
				
				if (hasResp) {
					createPieChart(labels, values, canvasId);
				}
				else {
					//Show empty responses question image
					//var imgElmt = document.createElement("img");
					//imgElmt.src = "/images/ezSurvey/nores";
					//document.getElementById(divId).appendChild(imgElmt);
				}
			}
			
			function test() {
				var values      = [];
				var lables      = [];
				var totalUsers  = parseInt(surveyStatistic["usersCnt"]);
				var respondents = parseInt(surveyStatistic["respondentCnt"]);
				var notTakePart = totalUsers - respondents;
				
				values.push(notTakePart);
				values.push(respondents);
				lables.push('참석한 사람 [' + respondents + SurveyMessages.strUser3 +']');
				lables.push('참석하 지않은 사람 [' + notTakePart + SurveyMessages.strUser3 +']');
				
				document.getElementById("totalUserCnt").innerHTML     = totalUsers;
				document.getElementById("totalRespondents").innerHTML = SurveyMessages.strTotal + " " + totalUsers + SurveyMessages.strUser3;
				createPieChart(lables, values,  "respondentPie");
			}
			
			function createPieChart(labels, values, elmtId) {
				var ctx = document.getElementById(elmtId).getContext("2d");
				var myPieChart = new Chart(ctx, {
					type: 'pie',
					data: {
						labels: labels,
						datasets: [{
							borderWidth: 2,
							hoverBorderWidth: 8,
							backgroundColor: colors,
							data: values
						}]
					},
					options: {
						tooltips: {
							callbacks: {
								label: function(tooltipItem, data) {
									var allData      = data.datasets[tooltipItem.datasetIndex].data;
									var tooltipLabel = data.labels[tooltipItem.index];
									var tooltipData  = allData[tooltipItem.index];
									var total        = 0;
									for (var i in allData) {
										total += parseFloat(allData[i]);
									}
									var tooltipPercentage = ((tooltipData / total) * 100).toFixed(1);
									return tooltipLabel + ': ' + tooltipData + ' (' + tooltipPercentage + '%)';
								}
							}
						},
						legend: {
							position: 'right'
						},
						responsive: true,
					}
				});
				 
				 $("#chartjs-legend").html(myPieChart.generateLegend());
			}
			
			function createQuestionBar(question, canvasId) {
				//console.log(question);
				var returnObj = "";
				var content = question.content;
				var dataSet = [];
				
				if (question['type'] == 3 || question['type'] == 4) {
					returnObj = getMtrDataSet(question);
					
				} else if(question['type'] == 7) {
					returnObj = getSliderDataSet(question);
				}
				
				console.log(returnObj);
				
				var ctx = document.getElementById(canvasId);
				var myChart = new Chart(ctx, {
				    type: 'bar',
				    data: {
				        labels: returnObj['label'],
				        datasets: [{
							data: returnObj['data']
						}]
				    },
				    options: {
				        scales: {
				            yAxes: [{
				                ticks: {
				                    beginAtZero:true
				                }
				            }]
				        }
				    }
				});
				
			}
			
			function showMoreDetail() {
				alert("Show more detail");
			}
			
			function getMtrDataSet(question) {
				var dataSet = [];
				var returnObj = {};
				
				var rows = [];
				var rowsOptionId = [];
				
				var cols = [];
				var colsOptionId = [];
				
				var combinationsArr = [];
				var combinationsObj = {};
				
				var options = question['option'];
				var response = question['responses'];
				// 행과 열의 이름, id 획득
				for (var i = 0; i < options.length; i++) {
					if (options[i]['colLevel'] == -1) {
						var row = options[i]['content'];
						var rowOptionId = options[i]['optionId'];
						
						rows.push(row);
						rowsOptionId.push(rowOptionId);
						
					} else if (options[i]['rowLevel'] == -1) {
						var col = options[i]['content'];
						var colOptionId = options[i]['optionId'];
						
						cols.push(col);
						colsOptionId.push(colOptionId);
					} 
				}
				console.log(rowsOptionId);
				console.log(colsOptionId);
				
				// 행열 조합 생성
				for (var i = 0; i < rowsOptionId.length; i++) {
					for (var j = 0; j < colsOptionId.length; j++) {
						var name = String(rowsOptionId[i]) + "," +  String(colsOptionId[j]);
						combinationsArr.push(name);
						combinationsObj[name] = 0;
					}
				}
				// 해당되는 행열 조합의 개수 생성
				for (var i = 0; i < response.length; i++) {
					var rowId = response[i]['rowId'];
					var columnId = response[i]['columnId'];
					var rowColCombination = String(rowId) + "," + String(columnId);
					
					for (var j = 0; j < combinationsArr.length; j++) {
						if (combinationsArr[j] == rowColCombination) {
							var cnt = combinationsObj[rowColCombination];
							combinationsObj[rowColCombination] = cnt + 1;
						}
					}
				}
				
				/*  
				for (var i = 0; i < rowsOptionId.length; i++) {
					for (var j = 0; j < combinationsArr.length; j++) {
						
					}
				}
				 */
				returnObj['rows'] = rows;
				returnObj['cols'] = cols;
				
				returnObj['combinationsArr'] = combinationsArr;
				returnObj['combinationsObj'] = combinationsObj;
				
				return returnObj;
			}
			
			function getSliderDataSet(question) {
				//console.log(question);
				//console.log(question.responses);
				var responses = question['responses'];
				var options = question['option'];
				var start = parseInt(options[0]['content']);
				var end = parseInt(options[1]['content']);
				
				var dataSet = [];
				
				var unit = [];
				var unitObj = {};
				var dataSet = {};
				for (var i = start; i < end + 1; i++) {
					unit.push(i);
					unitObj[i] = 0;
				}
				
				for (var j = 0; j < responses.length; j++) {
					var sliderVal = responses[j]['sliderValue'];
					
					for (var j = 0; j < unit.length; j++) {
						var unitVal = unit[j];
						if (sliderVal == unitVal) {
							var oldVal = unitObj[sliderVal];
							unitObj[sliderVal] = oldVal + 1;
						}
						
					}
				}
				console.log("after");
				console.log(unitObj);
				
				var dataArr = [];
				for (var i = start; i < end + 1; i++) {
					var value = unitObj[i];
					dataArr.push(value);
				}
				dataSet['label'] = unit;
				dataSet['data'] = dataArr;
				console.log(dataSet);
				
				return dataSet;
			}
			
			function createChartStr(value, string, cnt) {return value + " - %%.%% [" + cnt + string + "]";}
		})();
	</script>
</html>