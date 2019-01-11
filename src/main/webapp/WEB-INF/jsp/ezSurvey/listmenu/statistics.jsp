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
				mainDivElmt.appendChild(divElmt);
				
				//Create question statistic for each type
				var questionType = parseInt(question["type"]);
				switch(questionType) {
				/* 
					case 1:
					case 2:
					case 9:
						divElmt.className = "pieDiv";
						var canvasElmt = document.createElement("canvas");
						var canvasId   = "question" + question["level"];
						canvasElmt.setAttribute("height", 240);
						canvasElmt.setAttribute("width", 640);
						canvasElmt.setAttribute("id", canvasId);
						divElmt.appendChild(canvasElmt);
						createQuestionPie(question, canvasId);
						break;
						 */
					case 3:
					case 4:
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
					case 7:
						break;
					case 8:
						break;
				}
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
				console.log(question.responses);
				var response = question.responses;
				var content = question.content;
				var arr = [];
				var data = [];
				
				
				
				for (var i = 0; i < response.length; i++) {
					var rowId = response[i]['rowId'];
					var columnId = response[i]['columnId'];
				}
				
				var ctx = document.getElementById(canvasId);
				var myChart = new Chart(ctx, {
				    type: 'bar',
				    data: {
				        labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
				        datasets: [{
				            label: content,
				            data: [12, 19, 3, 5, 2, 3],
				            backgroundColor: [
				                'rgba(255, 99, 132, 0.2)',
				                'rgba(54, 162, 235, 0.2)',
				                'rgba(255, 206, 86, 0.2)',
				                'rgba(75, 192, 192, 0.2)',
				                'rgba(153, 102, 255, 0.2)',
				                'rgba(255, 159, 64, 0.2)'
				            ],
				            borderColor: [
				                'rgba(255,99,132,1)',
				                'rgba(54, 162, 235, 1)',
				                'rgba(255, 206, 86, 1)',
				                'rgba(75, 192, 192, 1)',
				                'rgba(153, 102, 255, 1)',
				                'rgba(255, 159, 64, 1)'
				            ],
				            borderWidth: 1
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
			
			function createChartStr(value, string, cnt) {return value + " - %%.%% [" + cnt + string + "]";}
		})();
	</script>
</html>