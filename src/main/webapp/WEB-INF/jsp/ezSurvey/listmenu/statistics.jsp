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
	<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg'               )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js'    )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/chart.min.js')}"></script>
	<body class="surveyBody">
		<div class="header-wrapper">
			<div class="surveydetail-header">
				<ul class="on">	
					<li class="off"><span id="showRespondedUsers"><spring:message code="ezSurvey.t95"/></span></li>
				</ul>
			</div>
			<div id="close"><ul><li><span id="cancelBttn"></span></li></ul></div>
		</div>
		<div class="surveydetail-body" id="mainSurveyBody">
			<div class="surveyinfo-wrap">
				<div class="survey-nminfo">
					<div class="survey-title"><c:out value="${data.title}"/></div>
				</div>
			</div>
			
			<div id="contentsBox">
				<div id="surveyRespondents" class="respondents-div off">
					<div class="response-header"><spring:message code="ezSurvey.t95"/><div id="totalUserCnt"></div></div>
					<div class="pieDiv">
						<div id="userLegendDiv" class="bnk-legend"></div>
						<canvas id="respondentPie" height="240"></canvas>
					</div>
				</div>
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
		</div>
		
		<script type="text/javascript">
		(function() {
			var colors = ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89", "#90d4f7", "#71e096", "#f5a26f",
						  "#668de5", "#ed6d79", "#5ad0e5", "#da97e0", "#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924",
						  "#d41e47", "#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431", "#d41e47", "#eb148d"];
			var userWindow        = null;
			var surveyStatistic   = ${data};
			var questionStatistic = ${questions};
			
			startStatistic(questionStatistic);
			
			function startStatistic(questions) {
				setBodyHeight();
				window.addEventListener("load", function(e) {setBodyHeight();}, false);
				window.addEventListener("resize", function(e) {setBodyHeight();}, false);
				document.getElementById("showRespondedUsers").onclick = function(e) {toggleUserPanel();};
				document.getElementById("closeRespondentl").onclick   = function(e) {togglePanel("respondentPanel");};
				document.getElementById("closeTxtResponse").onclick   = function(e) {togglePanel("textPanel");};
				window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
				
				for (var i = 0; i < questions.length; i++) {
					showQuestionStatistic(questions[i]);
				}
				
				showRespondentStatistic();
			}
			
			function setBodyHeight() {
				var wdHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
				document.getElementById("mainSurveyBody").style.height = (wdHeight - 74) + "px";
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
						case 7:
						case 8: 
							createQuestionBar(question, divElmt);
							break;
						case 5:
						case 6:
							var divText = document.createElement("div");
							divText.className = "textDiv";
							divElmt.appendChild(divText);
							createTextQuestion(question, divText);
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
					viewMore.textContent = SurveyMessages.strViewAll;
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
					var txtCont         = document.createElement("span");
					
					if (surveyStatistic["annoynymous"] == 0) {
						var userAva     = document.createElement("img");
						userAva.src     = responses[i]["image"] ? responses[i]["image"] : "/images/default_pic.jpg";
						userAva.onclick = (function(userId) {return function() {showUserInfoFromId(userId);};})(responses[i]["responsorId"]);
						liResp.appendChild(userAva);
					}
					
					txtCont.textContent = responses[i]["texts"];
					liResp.className    = "txt-response";
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
							userId   : responses[i]["responsorId"],
							userName : responses[i]["userName"],
							deptName : responses[i]["deptName"],
							userImage: responses[i]["image"],
							respDate : responses[i]["responseDate"].substring(0, 19)
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
				
				if (surveyStatistic["annoynymous"] == 0 && totalCnt > 0) {
					spanElmt.onclick = (function(qstId) {return function() {showRespondentList(qstId);};})(question["questionId"]);
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
			
			function showSelectedUsersForPie(questionId, optId) {
				var option = questionStatistic.filter(function(qst) {return qst["questionId"] == questionId})[0]["option"][optId];
					
				if (!option["responses"] || option["responses"].length == 0) {
					return;
				}
					
				showSelectedUsers(option["responses"]);
			}
			
			function showSelectedUsers(responses) {
				var dataFormat = {
					userName  : "userName",
					deptName  : "deptName",
					respDate  : "responseDate",
					userId    : "responsorId",
					userImage : "image"
				};
				
				generateUserTable(dataFormat, responses);
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
				var moreParam       = surveyStatistic["annoynymous"] == 0 ? question["questionId"] : null;
				divLegend.className = "bnk-legend";
				canvasElmt.setAttribute("height", 240);
				canvasElmt.setAttribute("id", canvasId);
				divChart.appendChild(divLegend);
				divChart.appendChild(canvasElmt);
				divElmt.appendChild(divChart);
				
				var options = question["option"];
				var values  = [];
				var labels  = [];
				var others  = [];
				
				for (var i = 0; i < options.length; i++) {
					var responses     = options[i]["responses"];
					var otherFlag     = options[i]["otherFlag"];
					var responsesCnt  = responses ? responses.length : 0;
					
					if (otherFlag == 1) {
						others = responses;
					}
					
					values.push(responsesCnt);
					labels.push(options[i]["content"]);
				}
				
				createPieChart(labels, values, canvasId, divLegend, moreParam);
				
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
			
			function showRespondentStatistic() {
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
				document.getElementById("totalUserCnt").innerHTML = surveyStatistic["usersCnt"];
				
				createPieChart(lables, values,  "respondentPie", legendDiv);
			}
			
			function createPieChart(labels, values, elmtId, legendElmt, questionId) {
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
						question : questionId
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
							return createLegend(chart.data);
						},
						legend: {
							display: false,
						},
						onClick : function (evt, item) {
							var itemIdx = item[0]["_index"];
							var data    = myPieChart.data["question"];
							if (data) {
								showSelectedUsersForPie(data, itemIdx);
							}
						},
						hover: {
							onHover: function(e) {
								var point = this.getElementAtEvent(e);
								e.target.style.cursor = point.length ? "pointer" : "default";
							}
						},
						responsive: false,
					}
				});
				
				legendElmt.appendChild(myPieChart.generateLegend());
			}
			
			function createQuestionBar(question, divElmt) {
				var divChart        = document.createElement("div");
				var divWrap         = document.createElement("div");
				divChart.className  = "chartWrapper";
				var canvasElmt      = document.createElement("canvas");
				var canvasId        = "question" + question["level"];
				var moreParam       = surveyStatistic["annoynymous"] == 0 ? question["questionId"] : null;
				divWrap.className   = "chartAreaWrapper";
				canvasElmt.setAttribute("height", 400);
				canvasElmt.setAttribute("id", canvasId);
				divWrap.appendChild(canvasElmt);
				divChart.appendChild(divWrap);
				divElmt.appendChild(divChart);
				
				var returnObj   = "";
				var response    = question.responses;
				var content     = question.content;
				var dataSets    = [];
				var labels      = "";
				var canvasWidth = 0;
				var legendFlag  = true;
				
				if (question["type"] == 3 || question["type"] == 4) {
					returnObj = getMtrDataSet(question);
					labels    = returnObj["labels"];
					dataSets  = returnObj["dataSetArr"];
					canvasWidth = returnObj["width"];
				}
				else if (question["type"] == 7) {
					returnObj   = getSliderDataSet(question);
					labels      = returnObj["labels"];
					legendFlag  = false;
					var dataObj = {};
					dataObj["backgroundColor"]  = colors;
					dataObj["hoverBorderWidth"] = 8;
					dataObj["borderWidth"]      = 2;
					dataObj["data"]             = returnObj["dataSetArr"];
					canvasWidth                 = returnObj["width"];
					dataSets.push(dataObj);
				}
				else if (question["type"] == 8) {
					returnObj   = getRankingDataSet(question);
					labels      = returnObj["labels"];
					dataSets    = returnObj["dataSetArr"];
					canvasWidth = returnObj["width"];
				}
				
				if (canvasWidth < divWrap.clientWidth) {
					canvasElmt.setAttribute("width", divWrap.clientWidth);
					divWrap.className = "chartAreaWrapper bnk-wrap";
				}
				else {
					canvasElmt.setAttribute("width", canvasWidth);
				}
				
				createBarChart(labels, dataSets, canvasId, moreParam, legendFlag);
			}
			
			function createBarChart(labels, dataSets, canvasId, questionId, legendFlag) {
				var ctx = document.getElementById(canvasId);
				var myBarChart = new Chart(ctx, {
					type: "bar",
					data: {
						labels: labels,
						datasets: dataSets,
						question : questionId
					},
					options: {
						tooltips: {
							callbacks: {
								label: function(tooltipItem, data) {
									var dataIdx  = tooltipItem.datasetIndex;
									var itemCnt  = data.datasets[dataIdx].data[tooltipItem.index];
									var colLabel = data.datasets[dataIdx].label;
									
									return colLabel ? colLabel + ": " + itemCnt : itemCnt;
								},
								// remove title
								title: function(tooltipItem, data) {
									var itemIdx = tooltipItem[0]["index"];
									return data.labels[itemIdx];
								}
							}
						},
						legend: {
							display: legendFlag,
						},
						onClick : function (evt, item) {
							var data = myBarChart.data["question"];
							if (data) {
								var question = questionStatistic.filter(function(qst) {return qst["questionId"] == questionId})[0];
								var type     = parseInt(question["type"]);
								if (type == 7) {
									var itemValue = parseInt(item[0]["_model"]["label"]);
									var responses = question["responses"].filter(function(res) {return res["sliderValue"] == itemValue});
									showSelectedUsers(responses);
								}
								else if (type == 3 || type == 4) {
									var active = myBarChart.getElementAtEvent(evt);
									
									if (!active || active.length == 0) {return;}
									
									var columnIdx = active[0]["_datasetIndex"];
									var rowIdx    = item[columnIdx]["_index"];
									var option    = question["option"];
									var columId   = option.filter(function(opt) {return opt["colLevel"] == columnIdx})[0]["optionId"];
									var rowId     = option.filter(function(opt) {return opt["rowLevel"] == rowIdx})[0]["optionId"];
									
									var responses = question["responses"].filter(function(res) {
										return res["rowId"] == rowId && res["columnId"] == columId;
									});
									
									showSelectedUsers(responses);
								}
								else if (type == 8) {
									var active = myBarChart.getElementAtEvent(evt);
									
									if (!active || active.length == 0) {return;}
									
									var rankingIdx = active[0]['_datasetIndex'];
									var crrItem    = item[rankingIdx];
									var optionIdx  = crrItem["_index"];
									var option     = question["option"];
									var optionId   = option.filter(function(opt) {return opt["level"] == optionIdx})[0]["optionId"];
									var responses  = question["responses"].filter(function(res) {
										return res["rankingLevel"] == rankingIdx + 1 && res["optionId"] == optionId;
									});
									
									showSelectedUsers(responses);
								}
							}
						},
						hover: {
							onHover: function(e) {
								var point = this.getElementAtEvent(e);
								e.target.style.cursor = point.length ? "pointer" : "default";
							}
						},
						responsive: false,
						maintainAspectRatio: false,
						scales: {
							xAxes: [{
								ticks: {
									autoSkip: false,
									fontSize: 12
								},
								barThickness: 30,
							}],
							yAxes: [{
								ticks: {
									beginAtZero: true,
									fontSize: 12
								}
							}]
						}
					}
				});
			}
			
			function createLegend(data) {
				var ul       = document.createElement("ul");
				ul.className = "legend-ul";
				var datasets = data["datasets"];
				
				for (var i = 0; i < datasets[0].data.length; i++) {
					var liElmt           = document.createElement("li");
					var divElmt1         = document.createElement("div");
					var divElmt2         = document.createElement("div");
					divElmt1.className   = "legend-circle";
					divElmt2.className   = "legend-label";
					divElmt2.textContent = data["labels"][i];
					divElmt2.setAttribute("title", divElmt2.textContent);
					divElmt1.setAttribute("style", "background-color: " + datasets[0].backgroundColor[i]);
					liElmt.appendChild(divElmt1);
					liElmt.appendChild(divElmt2);
					
					if (data["question"]) {
						liElmt.onclick = (function(questionId, optId) {return function() {showSelectedUsersForPie(questionId, optId);};})(data["question"], i);
					}
					
					ul.appendChild(liElmt);
				}
				
				return ul;
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
			
			function closeAllPopups() {if(userWindow)  {userWindow.close();}}
			
			function getMtrDataSet(question) {
				var options     = question["option"];
				var responses   = question["responses"];
 				var rows        = [];
				var cols        = [];
				var rowLabels   = [];
				var dataSetArr  = [];
				var dataSetObj  = {};
				var maxLabelLen = 0;
				
				for (var i = 0; i < options.length; i++) {
					if (options[i]["colLevel"] == -1) {
						rows.push(options[i]);
					}
					else if (options[i]["rowLevel"] == -1) {
						cols.push(options[i]);
					}
				}
				
				rows.sort(function(rowA, rowB) {return rowA["rowLevel"] - rowB["rowLevel"]});
				cols.sort(function(colA, colB) {return colA["colLevel"] - colA["colLevel"]});
				
				for (var j = 0; j < rows.length; j++) {
					if (rows[j]["content"].length > maxLabelLen) {
						maxLabelLen = rows[j]["content"].length;
					}
					
					rowLabels.push(rows[j]["content"]);
				}
				
				for (var i = 0; i < cols.length; i++) {
					var dataset      = {};
					var colData      = [];
					var colId        = cols[i]["optionId"];
					dataset["label"] = cols[i]["content"];
					
					for (var j = 0; j < rows.length; j++) {
						var rowId     = rows[j]["optionId"];
						var rowColRes = responses.filter(function(res) {
							return res["rowId"] == rowId && res["columnId"] == colId;
						});
						var rowColResCnt = rowColRes && rowColRes.length > 0 ? rowColRes.length : 0;
						colData.push(rowColResCnt);
					}
					
					dataset["data"]             = colData;
					dataset["backgroundColor"]  = colors[i];
					dataset["hoverBorderWidth"] = 8;
					dataset["borderWidth"]      = 2;
					dataSetArr.push(dataset);
				}
				
				var minLabelWidth        = maxLabelLen * 10 > cols.length * 40 ? maxLabelLen * 10 : cols.length * 40;
				dataSetObj["labels"]     = rowLabels;
				dataSetObj["dataSetArr"] = dataSetArr;
				dataSetObj["width"]      = minLabelWidth * rows.length;
				
				return dataSetObj;
			}
			
			function getSliderDataSet(question) {
				var responses   = question['responses'];
				var options     = question['option'];
				var startPoint  = parseInt(options[0]['content']);
				var endPoint    = parseInt(options[1]['content']);
				var unitArr     = [];
				var dataSetArr  = [];
				var dataSetObj  = {};
				var maxLabelLen = 0;
				
				for (var i = startPoint; i < endPoint + 1; i++) {
					var unitlabel = i + "";
					if (unitlabel.length > maxLabelLen) {
						maxLabelLen = unitlabel.length;
					}
					unitArr.push(unitlabel);
					var unitRes    = responses.filter(function(res) {return res["sliderValue"] == i;});
					var unitResCnt = unitRes && unitRes.length > 0 ? unitRes.length : 0;
					dataSetArr.push(unitResCnt);
				}
				
				var minLabelWidth        = maxLabelLen * 10 > 40 ? maxLabelLen * 10 : 40;
				dataSetObj["labels"]     = unitArr;
				dataSetObj["dataSetArr"] = dataSetArr;
				dataSetObj["width"]      = (endPoint - startPoint + 1) * minLabelWidth;
				
				return dataSetObj;
			}
			
			function getRankingDataSet(question) {
				var responses   = question["responses"];
				var options     = question["option"];
				var rowLabels   = [];
				var dataSetArr  = [];
				var dataSetObj  = {};
				var optionLen   = options.length;
				var maxLabelLen = 0;
				
				for (var i = 0; i < optionLen; i++) {
					var rank         = i + 1;
					var rankLabel    = rank + "";
					var dataset      = {};
					var colData      = [];
					dataset["label"] = options[i]["content"];
					
					if (rankLabel.length > maxLabelLen) {
						maxLabelLen = rankLabel.length;
					}
					
					for (var j = 0; j < optionLen; j++) {
						var rowId = options[j]["optionId"];
						var rowColRes = responses.filter(function(res) {
							return res["optionId"] == rowId && res["rankingLevel"] == rank;
						});
						var rowColResCnt = rowColRes && rowColRes.length > 0 ? rowColRes.length : 0;
						colData.push(rowColResCnt);
					}
					
					dataset["data"]             = colData;
					dataset["backgroundColor"]  = colors[i];
					dataset["hoverBorderWidth"] = 8;
					dataset["borderWidth"]      = 2;
					rowLabels.push(rankLabel);
					dataSetArr.push(dataset);
				}
				
				var minLabelWidth        = maxLabelLen * 10 > optionLen * 40 ? maxLabelLen * 10 : optionLen * 40;
				dataSetObj["labels"]     = rowLabels;
				dataSetObj["dataSetArr"] = dataSetArr;
				dataSetObj["width"]      = optionLen * minLabelWidth;
				
				return dataSetObj;
			}
			
			function toggleUserPanel() {
				var userPanel       = document.getElementById("surveyRespondents");
				var crrClass        = userPanel.className;
				userPanel.className = crrClass == "respondents-div off" ? "respondents-div" : "respondents-div off";
			}
		})();
	</script>
</html>