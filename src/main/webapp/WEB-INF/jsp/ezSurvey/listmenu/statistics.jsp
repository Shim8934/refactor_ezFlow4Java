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
			<div id="surveyRespondents" style="position: relative; box-shadow: rgba(0, 0, 0, 0.69) 0px 1px 5px 0px; margin-bottom: 10px;">
				<div style="padding: 0px 20px; box-sizing:border-box; display: flex;">
					<div id="userLegendDiv" class="bnk-legend"></div>
					<canvas id="respondentPie" height="240" width="240" style="height: 240px;"></canvas>
				</div>
			</div>
			<div id="barChart" style="display: none; height: 460px; box-shadow: rgba(0, 0, 0, 0.69) 0px 1px 5px 0px; margin-bottom: 10px;"></div>
		</div>
		
		<div id="respondentPanel" class="respondentPanel off">
			<div class="popup-header">
				<div class="popup-title" id="user-header"><spring:message code='ezSurvey.t87'/></div>
				<div id="closeRespondentl" class="closeImgBttn"><ul><li><span></span></li></ul></div>
			</div>
			<div class="popup-body">
				<div class="user-wrapdiv">
					<table class="mainlist users" id="userTable">
					</table>
				</div>
			</div>
		</div>
		
		<div id="textPanel" class="textPanel off">
			<div class="popup-header">
				<div class="popup-title" id="txt-header"><spring:message code='ezSurvey.t88'/></div>
				<div id="closeTxtResponse" class="closeImgBttn"><ul><li><span></span></li></ul></div>
			</div>
			<div class="popup-body">
				<div class="div-txtanswer">
					<ul id="txtTable" class="txt-respul"></ul>
				</div>
			</div>
		</div>
		
		<script type="text/javascript">
		(function() {
			var colors = ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89", "#90d4f7", "#71e096", "#f5a26f",
						  "#668de5", "#ed6d79", "#5ad0e5", "#da97e0", "#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924",
						  "#d41e47", "#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431", "#d41e47", "#eb148d"];
			var userWindow        = null;
			var surveyStatistic   = ${data};
			var questionStatistic = ${questions};
			
			//console.log(surveyStatistic);
			//console.log(questionStatistic);
			
			startStatistic(questionStatistic);
			
			function startStatistic(questions) {
				document.getElementById("closeRespondentl").onclick  = function(e) {togglePanel("respondentPanel");};
				document.getElementById("closeTxtResponse").onclick  = function(e) {togglePanel("textPanel");};
				window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
				
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
				
				//Get users for each question
				var userQuestion  = getUsersForQuestion(question);
				question["users"] = userQuestion["users"];
				var divHeader     = createHeaderDiv(question, userQuestion["respCnt"]);
				divElmt.appendChild(divHeader);
				mainDivElmt.appendChild(divElmt);
				
				if (!question["users"] || question["users"].length == 0) {
					//Empty data
					var noDataElmt = document.createElement("div");
					var childElmt1 = document.createElement("div");
					var childElmt2 = document.createElement("div");
					var noDataImg = document.createElement("img");
					noDataImg.src = "/images/ezSurvey/nodata.png";
					childElmt1.appendChild(noDataImg);
					childElmt2.textContent = "데이터가 없습니다";
					childElmt1.className   = "no-data-img";
					childElmt2.className   = "no-data-txt";
					noDataElmt.className   = "no-data";
					noDataElmt.appendChild(childElmt1);
					noDataElmt.appendChild(childElmt2);
					divElmt.appendChild(noDataElmt);
				}
				else {
					//Create question statistic for each type
					var questionType = parseInt(question["type"]);
					switch(questionType) {
						case 1:
						case 2:
						case 9:
							createQuestionPie(question, divElmt);
							break;
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
							var divText = document.createElement("div");
							divText.className = "textDiv";
							divElmt.appendChild(divText);
							createTextQuestion(question, divText);
							break;
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
						case 8:
							break;
					}
				}
			}
			
			function createTextQuestion(question, divText) {
				var responses    = question["responses"];
				var ulElmt       = document.createElement("ul");
				ulElmt.className = "txt-respul";
				var respCnt      = responses.length <= 3 ? responses.length : 3;
				
				if (responses.length > 3) {
					var spanUserCnt      = divText.parentElement.querySelector("span[class='response-usercnt']");
					var viewMore         = document.createElement("span");
					viewMore.textContent = SurveyMessages.strViewOther;
					viewMore.className   = "txt-viewmore";
					viewMore.onclick     = function(e) {showAllTextResponse(question["questionId"]);};
					spanUserCnt.parentElement.appendChild(viewMore);
				}
				
				createTextList(respCnt, responses, ulElmt);
				divText.appendChild(ulElmt);
			}
			
			function createTextList(respCnt, responses, ulElmt) {
				for (var i = 0; i < respCnt; i++) {
					var liResp          = document.createElement("li");
					var userAva         = document.createElement("img");
					var txtCont         = document.createElement("span");
					userAva.src         = responses[i]["image"] ? responses[i]["image"] : "/images/default_pic.jpg";
					userAva.onclick     = (function(userId) {return function() {showUserInfoFromId(userId);};})(responses[i]["responsorId"]);
					txtCont.textContent = responses[i]["texts"];
					liResp.className    = "txt-response";
					liResp.appendChild(userAva);
					liResp.appendChild(txtCont);
					ulElmt.appendChild(liResp);
				}
			}
			
			function showAllMoreOthers(qstId) {
				var options         = questionStatistic.filter(function(qst) {return qst["questionId"] == qstId})[0]["option"];
				var others          = options.filter(function(opt) {return opt["otherFlag"] == 1})[0]["responses"];
				var ulTxt           = document.getElementById("txtTable");
				var divHeader       = document.getElementById("txt-header");
				ulTxt.innerHTML     = "";
				divHeader.innerHTML = SurveyMessages.strOtherList1 + " [<span>" + others.length + " " + SurveyMessages.strOtherList2 + "</span>]";
				
				createTextList(others.length, others, ulTxt);
				togglePanel("textPanel", 640, 480);
			}
			
			function showAllTextResponse(qstId) {
				var responseList    = questionStatistic.filter(function(qst) {return qst["questionId"] == qstId})[0]["responses"];
				var ulTxt           = document.getElementById("txtTable");
				var divHeader       = document.getElementById("txt-header");
				ulTxt.innerHTML     = "";
				divHeader.innerHTML = SurveyMessages.strTxtList1 + " [<span>" + responseList.length + " " + SurveyMessages.strTxtList2 + "</span>]";
				
				createTextList(responseList.length, responseList, ulTxt);
				togglePanel("textPanel", 640, 480);
			}
			
			function getUsersForQuestion(question) {
				var userList     = [];
				var respCnt      = 0;
				var questionType = question["type"];
				var options      = question["option"];
				
				if (questionType == 1 || questionType == 2 || questionType == 9) {
					for (var i = 0; i < options.length; i++) {
						if (options[i]["responses"] && options[i]["responses"].length > 0) {
							getUserFromResponses(options[i]["responses"], userList);
							respCnt += options[i]["responses"].length;
						}
					}
				}
				else {
					if (question["responses"] && question["responses"].length > 0) {
						getUserFromResponses(question["responses"], userList);
						respCnt += question["responses"].length;
					}
				}
				
				return {users: userList, respCnt: respCnt};
			}
			
			function getUserFromResponses(responses, userList) {
				for (var i = 0; i < responses.length; i++) {
					if (!containUser(userList, responses[i]["responsorId"])) {
						userList.push({
							userId : responses[i]["responsorId"],
							userName: responses[i]["userName"],
							deptName: responses[i]["deptName"],
							userImage: responses[i]["image"],
							respDate: responses[i]["responseDate"].substring(0, 19)
						});
					}
				}
			}
			
			function containUser(userList, userId) {
				return userList.filter(function(elem) {return elem["userId"] == userId }).length > 0 ? true : false;
			}
			
			function createHeaderDiv(question, responsesCnt) {
				var mainDiv    = document.createElement("div");
				var divElemt1  = document.createElement("div");
				var divElemt2  = document.createElement("div");
				var ulElmt     = document.createElement("ul");
				var liElmt     = document.createElement("li");
				var spanElmt   = document.createElement("span");
				var divRespCnt = document.createElement("div");
				var totalCnt   = question["users"].length;
				divElemt1.className    = "response-header";
				divElemt2.className    = "response-users";
				divElemt1.textContent  = question["level"] + "." + question["content"];
				spanElmt.textContent   = SurveyMessages.strRespondent + " " + totalCnt;
				divRespCnt.textContent = responsesCnt <= 999 ? responsesCnt : 999 + "+";
				spanElmt.className     = "response-usercnt";
				
				if (totalCnt > 0) {
					spanElmt.onclick  = (function(qstId) {return function() {showRespondentList(qstId);};})(question["questionId"]);
				}
				
				liElmt.appendChild(spanElmt);
				ulElmt.appendChild(liElmt);
				divElemt1.appendChild(divRespCnt);
				divElemt2.appendChild(ulElmt);
				mainDiv.appendChild(divElemt1);
				mainDiv.appendChild(divElemt2);
				return mainDiv;
			}
			
			function showRespondentList(qstId) {
				createUserTableForQuestion(qstId);
				togglePanel("respondentPanel", 450, 320);
			}
			
			function togglePanel(panelId, width, height) {
				var respondentPanel = document.getElementById(panelId);
				var showClass       = panelId;
				var offClass        = panelId + " off";
				if (respondentPanel.className == offClass) {
					addFogPanel(togglePanel, panelId);
					var wdWidth                 = width  ? width  : 460;
					var wdHeight                = height ? height : 210;
					var position                = getPosition(wdWidth, wdHeight);
					respondentPanel.style.top   = position[0] + "px";
					respondentPanel.style.right = position[1] + "px";
					respondentPanel.className   = showClass;
				}
				else {
					removeFogPanel();
					respondentPanel.className   = offClass;
				}
			}
			
			function generateUserTable(dataFormat, userList) {
				var tableUser       = document.getElementById("userTable");
				tableUser.innerHTML = "";
				var userId          = dataFormat["userId"];
				var userImage       = dataFormat["userImage"];
				var userName        = dataFormat["userName"];
				var deptName        = dataFormat["deptName"];
				var respDate        = dataFormat["respDate"];
				
				for (var i = 0; i < userList.length; i++) {
					var trElmt  = document.createElement("tr");
					var tdElmt1 = document.createElement("td");
					var tdElmt2 = document.createElement("td");
					var tdElmt3 = document.createElement("td");
					var tdElmt4 = document.createElement("td");
					var imgElmt = document.createElement("img");
					imgElmt.src = userList[i][userImage] ? userList[i][userImage] : "/images/default_pic.jpg";
					tdElmt1.appendChild(imgElmt);
					tdElmt2.textContent = userList[i][userName];
					tdElmt3.textContent = userList[i][deptName];
					tdElmt4.textContent = userList[i][respDate].substring(0, 19);
					tdElmt2.className   = "mainTd";
					tdElmt3.className   = "mainTd";
					tdElmt4.className   = "respDate";
					tdElmt2.setAttribute("title", tdElmt2.textContent);
					tdElmt3.setAttribute("title", tdElmt3.textContent);
					trElmt.onclick      =  (function(userId) {return function() {showUserInfoFromId(userId);};})(userList[i][userId]);
					trElmt.className    = "usersTr";
					trElmt.appendChild(tdElmt1);
					trElmt.appendChild(tdElmt2);
					trElmt.appendChild(tdElmt3);
					trElmt.appendChild(tdElmt4);
					tableUser.appendChild(trElmt);
				}
				
				var divHeader       = document.getElementById("user-header");
				divHeader.innerHTML = SurveyMessages.strAllUsers + " [<span>" + userList.length + " " + SurveyMessages.strUser3 + "</span>]";
			}
			
			function showSelectedUsers(responseList) {
				console.log(responseList);
				var dataFormat = {
					userName  : "userName",
					deptName  : "deptName",
					respDate  : "responseDate",
					userId    : "responsorId",
					userImage : "image"
				};
				
				generateUserTable(dataFormat, responseList);
				togglePanel("respondentPanel", 450, 320);
			}
			
			function createUserTableForQuestion(qstId) {
				var userList = questionStatistic.filter(function(qst) {return qst["questionId"] == qstId})[0]["users"];
				var dataFormat = {
					userName  : "userName",
					deptName  : "deptName",
					respDate  : "respDate",
					userId    : "userId",
					userImage : "userImage"
				};
				generateUserTable(dataFormat, userList);
			}
			
			function showUserInfoFromId(userId) {
				var feature = "height=500px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
				feature = feature + getOpenWindowfeature(420, 500);
				userWindow = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
			}
			
			function createQuestionPie(question, divElmt) {
				var divChart        = document.createElement("div");
				divChart.className  = "pieDiv";
				var canvasElmt      = document.createElement("canvas");
				var divLegend       = document.createElement("div");
				var canvasId        = "question" + question["level"];
				divLegend.className = "bnk-legend";
				canvasElmt.setAttribute("height", 240);
				canvasElmt.setAttribute("id", canvasId);
				divChart.appendChild(divLegend);
				divChart.appendChild(canvasElmt);
				divElmt.appendChild(divChart);
				
				var options = question["option"];
				var values  = [];
				var labels  = [];
				var mores   = [];
				var others  = [];
				
				for (var i = 0; i < options.length; i++) {
					var responses     = options[i]["responses"];
					var otherFlag     = options[i]["otherFlag"];
					var responsesCnt  = responses ? responses.length : 0;
					var optionContent = "";
					
					
					if (responses && responses.length > 0) {
						mores.push(responses)
					}
					else {
						mores.push(null);
					}
					
					if (otherFlag == 1) {
						others = responses;
					}
					
					values.push(responsesCnt);
					labels.push(options[i]["content"]);
				}
				
				createPieChart(labels, values, canvasId, divLegend, mores);
				
				if (others && others.length > 0) {
					var wrapDivElmt       = document.createElement("div");
					var otherHeader       = document.createElement("div");
					var ulElmt            = document.createElement("ul");
					var spanElmt1         = document.createElement("span");
					otherHeader.className = "others-div";
					spanElmt1.textContent = SurveyMessages.strViewOther;
					otherHeader.appendChild(spanElmt1);
					ulElmt.className      = "txt-respul";
					wrapDivElmt.className = "other-wrap";
					otherHeader.className = "other-header";
					var respCnt           = responses.length <= 3 ? responses.length : 3;
					
					if (responses.length > 3) {
						var viewMore         = document.createElement("span");
						viewMore.textContent = SurveyMessages.strViewAll;
						viewMore.className   = "txt-viewmore";
						viewMore.onclick     = function(e) {showAllMoreOthers(question["questionId"]);};
						otherHeader.appendChild(viewMore);
					}
					
					createTextList(respCnt, responses, ulElmt);
					wrapDivElmt.appendChild(otherHeader);
					wrapDivElmt.appendChild(ulElmt);
					divElmt.appendChild(wrapDivElmt);
				}
			}
			
			function test() {
				var values      = [];
				var lables      = [];
				var totalUsers  = parseInt(surveyStatistic["usersCnt"]);
				var respondents = parseInt(surveyStatistic["respondentCnt"]);
				var notTakePart = totalUsers - respondents;
				var legendDiv   = document.getElementById("userLegendDiv");
				
				values.push(notTakePart);
				values.push(respondents);
				lables.push(SurveyMessages.strJoin1 + " [" + respondents + SurveyMessages.strUser3 + "]");
				lables.push(SurveyMessages.strJoin2 + " [" + notTakePart + SurveyMessages.strUser3 + "]");
				
				document.getElementById("totalUserCnt").innerHTML = totalUsers;
				createPieChart(lables, values,  "respondentPie", legendDiv);
			}
			
			function createPieChart(labels, values, elmtId, legendElmt, moreparams) {
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
						}],
						mores : moreparams
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
						legendCallback: function(chart) {
							var ul       = document.createElement("ul");
							ul.className = "legend-ul";
							for (var i = 0; i < chart.data.datasets[0].data.length; i++) {
								var liElmt   = document.createElement("li");
								var divElmt1 = document.createElement("div");
								var divElmt2 = document.createElement("div");
								divElmt1.className   = "legend-circle";
								divElmt2.className   = "legend-label";
								divElmt2.textContent = chart.data.labels[i];
								divElmt1.setAttribute("style", "background-color: " + chart.data.datasets[0].backgroundColor[i]);
								liElmt.appendChild(divElmt1);
								liElmt.appendChild(divElmt2);
								
								if (chart.data["mores"] && chart.data["mores"][i] && chart.data["mores"][i].length > 0) {
									liElmt.onclick = (function(responses) {return function() {showSelectedUsers(responses);};})(chart.data["mores"][i]);
								}
								
								ul.appendChild(liElmt);
							}
							
							return ul;
						},
						legend: {
							display: false,
						},
						onClick : function (evt, item) {
							var itemIdx = item[0]["_index"];
							var data    = myPieChart.data["mores"][itemIdx];
							if (data && data.length > 0) {
								showSelectedUsers(data);
							}
						},
/* 						legend: {
							position: 'left',
							onHover: function(e, legendItem) {
								e.target.style.cursor = 'pointer';
							}
						}, */
						hover: {
							onHover: function(e) {
								var point = this.getElementAtEvent(e);
								if (point.length) e.target.style.cursor = 'pointer';
								else e.target.style.cursor = 'default';
							}
						},
						responsive: false,
					}
				});
				
				//legendElmt.innerHTML = myPieChart.generateLegend();
				legendElmt.appendChild(myPieChart.generateLegend());
			}
			
			function createQuestionBar(question, canvasId) {
				//console.log(question);
				var returnObj = "";
				//console.log(question.responses);
				var response = question.responses;
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
			
			function addFogPanel(togglePanel, elmtId) {
				var fogPanel                 = document.createElement("div");
				fogPanel.className           = "rfogPanel";
				fogPanel.onclick             = function(e) {togglePanel(elmtId);};
				document.body.style.overflow = "hidden";
				document.body.appendChild(fogPanel);
			}
			
			function removeFogPanel() {
				var fogPanel     = document.querySelector("div[class='rfogPanel']");
				if (fogPanel) {document.body.removeChild(fogPanel);}
				if (document.getElementById("ui-datepicker-div")) {document.getElementById("ui-datepicker-div").style.display = "none";}
				document.body.style.overflow = "auto";
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
			
			function getPosition(popUpW, popUpH) {
				var returnValue = new Array();
				var heigth      = document.documentElement.clientHeight;
				if (heigth == 0) {heigth = document.body.clientHeight;}
				
				var width = document.documentElement.clientWidth;
				if (width == 0) {width = document.body.clientWidth;}
				
				var pleftpos   = parseInt(width) - popUpW;
				heigth         = parseInt(heigth) - popUpH;
				returnValue[0] = heigth / 2;
				returnValue[1] = pleftpos / 2;
				
				return returnValue;
			}
			
			function closeAllPopups() {
				if(userWindow)  {userWindow.close();}
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
		})();
	</script>
</html>