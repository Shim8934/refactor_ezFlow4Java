<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/tui-chart.min.css')          }">
	</head>
	<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg'                   )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js'        )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/bnk-core.js'     )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/bnk-2.js'        )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/bnk-1.js'        )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/tui-chart.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/chart.min.js'    )}"></script>
	
	<body class="surveyBody">
		<div class="header-wrapper">
			<div class="surveydetail-header" style="font-weight:bold"><spring:message code="ezSurvey.t33"/></div>
			<div id="close"><ul><li><span id="cancelBttn"></span></li></ul></div>
		</div>
		<div class="surveydetail-body" id="mainSurveyBody">
			<div class="surveyinfo-wrap">
				<div class="survey-nminfo">
					<div class="survey-title">
						<c:out value="${data.title}"/>
						<c:if test = "${adminYN eq 'Y' }">
							<span id="downloadBtn" style="cursor:pointer;float:right;">
								<img src="/images/icon_adddownload.gif" width="16" height="16" style="vertical-align:middle">
							</span>
						</c:if>
					</div>
				</div>
			</div>
			
			<div id="contentsBox">
				<div id="surveyRespondents" class="respondents-div">
					<div class="response-header"><div><spring:message code="ezSurvey.t95"/></div><div id="totalUserCnt"></div></div>
					<div class="pieDiv">
						<div id="userLegendDiv" class="bnk-legend"></div>
						<canvas id="respondentPie" height="300"></canvas>
						<div id="respondentTool" class="bnk-tooltip"></div>
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
		<form id="exportSurvey" name="exportSurvey" method="post" style="display:none;">
			<input name="surveyId">
		</form>
		
		<script type="text/javascript">
		var LegenNavi = function() {
			return function(divNavi) {
				var currentPage = 1;
				var blockNum    = 10;
				
				function getTotalLies() {
					var ulElmt = divNavi.parentElement.querySelector("ul[class='legend-ul']");
					return ulElmt.children;
				}
				
				function getNextLengend() {
					var liList  = getTotalLies();
					if (currentPage * blockNum >= liList.length) {return;}
					currentPage += 1;
					toggleLegendList(liList);
				}
				
				function getPreviousLengend() {
					var liList  = getTotalLies();
					if (currentPage == 1) {return;}
					currentPage -= 1;
					toggleLegendList(liList);
				}
				
				function toggleLegendList(liList) {
					var startPoint = (currentPage - 1) * blockNum;
					var endPoint   = startPoint + blockNum - 1;
					
					for (var i = 0, len = liList.length; i < len; i++) {
						liList[i].className = (i >= startPoint && i <= endPoint) ? "lengen-on" : "lengen-off";
					}
				}
				
				return {
					next : getNextLengend,
					previous : getPreviousLengend,
				}
			};
		}();
		
		(function() {
			var userWindow        = null;
			var surveyStatistic   = ${data};
			var questionStatistic = ${questions};
			var adminYN			  = "<c:out value='${adminYN}'/>";
			
			var colors = ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89", "#90d4f7", "#71e096", "#f5a26f",
						  "#668de5", "#ed6d79", "#5ad0e5", "#da97e0", "#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924",
						  "#d41e47", "#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431", "#d41e47", "#eb148d"];
			
			startStatistic(questionStatistic);

			function exportData() {
				$("input[name='surveyId']").val(questionStatistic[0]["surveyId"]);
				document.exportSurvey.action = "/ezSurvey/exportResultExcel.do";
				document.exportSurvey.method = "POST";
				document.exportSurvey.submit();
			}

			function startStatistic(questions) {
				setBodyHeight();
				window.addEventListener("load", function(e) {setBodyHeight();}, false);
				window.addEventListener("resize", function(e) {setBodyHeight();}, false);
				document.getElementById("closeRespondentl").onclick   = function(e) {togglePanel("respondentPanel");};
				document.getElementById("closeTxtResponse").onclick   = function(e) {togglePanel("textPanel");};
				
				if(document.getElementById("downloadBtn")) {
					document.getElementById("downloadBtn").addEventListener("click", function(e) {exportData();}, false);
				}

				window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
				
				showRespondentStatistic();
				
				for (var i = 0; i < questions.length; i++) {
					showQuestionStatistic(questions[i]);
				}
				
				var cancelBttn = document.getElementById("cancelBttn");
				if (cancelBttn) {cancelBttn.onclick = function(e) {window.close();};}
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
					childElmt2.textContent = SurveyMessages.strNoData;
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
						case 10:
						case 11:
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
				
				/* 2025-06-18 양지혜 - 주관식 결과비공개 사용 시, 결과표출 분기처리 추가 */
				if (question.resOpenFlag == 1 && !(surveyStatistic.isCreator == 1 || adminYN == "Y")) {
					var txtDiv = document.createElement("div");
					txtDiv.className = "txtDiv";
					txtDiv.innerHTML = SurveyMessages.strResOpen03;
					divText.appendChild(txtDiv);
				} else {
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
			}
			
			function createTextList(respCnt, responses, ulElmt) {
				for (var i = 0; i < respCnt; i++) {
					var liResp          = document.createElement("li");
					var txtCont         = document.createElement("span");
					txtCont.textContent = responses[i]["texts"];
					
					if (surveyStatistic["annoynymous"] == 0 && (surveyStatistic["userExposed"] == 1 || adminYN == 'Y')) {
						/* 프로필사진 */
						var userAva     = document.createElement("img");
						userAva.src     = responses[i]["image"] ? "/admin/ezOrgan/getPersonalInfo.do?fileName=" + responses[i]["image"] : "/images/default_pic.jpg";
						userAva.onclick = (function(userId) {return function() {showUserInfoFromId(userId);};})(responses[i]["responsorId"]);
						liResp.appendChild(userAva);
						/* 이름 */
						var spanElm1 = document.createElement("span");
						spanElm1.className = "userInfoSpan";
						spanElm1.textContent = responses[i]["userName"];
						spanElm1.title = responses[i]["userName"];
						spanElm1.style.flex = "1";
						liResp.appendChild(spanElm1);
						/* 부서명 */
						var spanElm2 = document.createElement("span");
						spanElm2.className = "userInfoSpan";
						spanElm2.textContent = responses[i]["deptName"];
						spanElm2.title = responses[i]["deptName"];
						spanElm2.style.flex = "2";
						liResp.appendChild(spanElm2);

						txtCont.style.flex = "7";
					}
					
					liResp.className    = "txt-response";
					liResp.style.whiteSpace = "pre-wrap";
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
				
				if (questionType == 1 || questionType == 2 || questionType == 9 || questionType == 10 || questionType == 11) {
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
				var divChild1  = document.createElement("div");
				var divRespCnt = document.createElement("div");
				var totalCnt   = question["users"].length;
				var imgTitle   = question["imgTitle"];
				var imgTitleDiv = null;
				divElemt1.className    = "response-header";
				divElemt2.className    = "response-users";
				if (imgTitle) {
					imgTitleDiv = document.createElement("div");
					imgTitleDiv.className = "imgTitleDiv";
					var img = document.createElement("img");
					img = document.createElement("img");
					img.className = "imgTitle";
					img.src = imgTitle["fpath"];
					imgTitleDiv.appendChild(img);
				}
				
				divChild1.textContent  = question["level"] + "." + question["content"];
				
				spanElmt.textContent   = SurveyMessages.strRespondent + " " + totalCnt;
				divRespCnt.textContent = responsesCnt <= 999 ? responsesCnt : 999 + "+";
				spanElmt.className     = "response-usercnt";
				
				if (surveyStatistic["annoynymous"] == 0 && totalCnt > 0 && (surveyStatistic["userExposed"] == 1 || adminYN == 'Y')) {
					spanElmt.onclick = (function(qstId) {return function() {showRespondentList(qstId);};})(question["questionId"]);
				}
				
				liElmt.appendChild(spanElmt);
				ulElmt.appendChild(liElmt);
				divElemt1.appendChild(divChild1);
				divElemt1.appendChild(divRespCnt);
				divElemt2.appendChild(ulElmt);
				mainDiv.appendChild(divElemt1);
				if (imgTitle) {
					mainDiv.appendChild(imgTitleDiv);
				}
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
					imgElmt.src = userList[i][userImage] ?  "/admin/ezOrgan/getPersonalInfo.do?fileName=" + userList[i][userImage] : "/images/default_pic.jpg";
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
				if (!responses || responses.length == 0) {return;}
				
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
				var feature = "height=450px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
				feature = feature + getOpenWindowfeature(420, 450);
				userWindow = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
			}
			
			/* function createQuestionPie(question, divElmt) {
				var divChart        = document.createElement("div");
				divChart.className  = "pieDiv";
				var divId           = "question" + question["level"];
				var moreParam       = surveyStatistic["annoynymous"] == 0 ? question["questionId"] : null;
				divChart.setAttribute("id", divId);
				divElmt.appendChild(divChart);
				
				var options = question["option"];
				var values  = [];
				var labels  = [];
				var others  = [];
				var dataset = [];
				
				for (var i = 0; i < options.length; i++) {
					var responses     = options[i]["responses"];
					var otherFlag     = options[i]["otherFlag"];
					var responsesCnt  = responses ? responses.length : 0;
					
					if (otherFlag == 1) {
						others = responses;
					}
					
					dataset.push({
						name: options[i]["content"],
						data: responsesCnt
					});
				}
				
				createPieChart(dataset, divId, moreParam);
				
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
			} */
			
			function createQuestionPie(question, divElmt) {
				var divChart         = document.createElement("div");
				divChart.className   = "pieDiv";
				var canvasElmt       = document.createElement("canvas");
				var divLegend        = document.createElement("div");
				var canvasId         = "question" + question["level"];
				var toolTipDiv       = document.createElement("div");
				var toolTipId        = "tooltip" + question["level"];
				var moreParam        = surveyStatistic["annoynymous"] == 0 ? question["questionId"] : null;
				divLegend.className  = "bnk-legend";
				toolTipDiv.className = "bnk-tooltip";
				canvasElmt.setAttribute("height", 300);
				canvasElmt.setAttribute("id", canvasId);
				toolTipDiv.setAttribute("id", toolTipId);
				divChart.appendChild(divLegend);
				divChart.appendChild(canvasElmt);
				divChart.appendChild(toolTipDiv);
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
				
				createPieChart(labels, values, canvasElmt, divLegend, toolTipDiv, moreParam);
				
				if (others && others.length > 0) {
					var wrapDivElmt       = document.createElement("div");
					var otherHeader       = document.createElement("div");
					var ulElmt            = document.createElement("ul");
					var spanElmt1         = document.createElement("span");
					otherHeader.className = "others-div";

					// 20.05.13 강승구 : IE, Edge에서 undefined로 표시되는 문제 해결
					if(SurveyMessages.strViewOther) {
						spanElmt1.textContent = SurveyMessages.strViewOther;
					}
					
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
				var canvasElmt  = document.getElementById("respondentPie");
				var toolTipDiv  = document.getElementById("respondentTool");
				
				values.push(respondents);
				values.push(notTakePart);
				lables.push(SurveyMessages.strJoin1);
				lables.push(SurveyMessages.strJoin2);
				document.getElementById("totalUserCnt").innerHTML = surveyStatistic["usersCnt"];
				
				createPieChart(lables, values, canvasElmt, legendDiv, toolTipDiv);
			}
			
			/* function showRespondentStatistic() {
				var data        = [];
				var totalUsers  = parseInt(surveyStatistic["usersCnt"]);
				var respondents = parseInt(surveyStatistic["respondentCnt"]);
				var notTakePart = totalUsers - respondents;
				
				data.push({
					name : SurveyMessages.strJoin2 + " [" + notTakePart + SurveyMessages.strUser3 + "]",
					data : notTakePart
				});
				
				data.push({
					name : SurveyMessages.strJoin1 + " [" + respondents + SurveyMessages.strUser3 + "]",
					data : respondents
				});
				
				document.getElementById("totalUserCnt").innerHTML  = surveyStatistic["usersCnt"];
				document.getElementById("respondentPie").innerHTML = "";
				
				createPieChart(data, "respondentPie");
			} */
			
			/* function createBnkPieChart(dataset, elmtId, questionId) {
				var container = document.getElementById(elmtId);
				var data = {series: dataset};
				
				var options = {
					chart: {width: 600, height: 360},
					tooltip: {},
					legend: {align : 'left', showCheckbox : false},
					chartExportMenu: {visible : false},
					usageStatistics: false
				};
				
				var piechart = tui.chart.pieChart(container, data, options);
				piechart.on('selectSeries', function(info) {
					var question = questionStatistic.filter(function(qst) {return qst["questionId"] == questionId})[0];
					if (questionId) {
						var itemIdx = info["legendIndex"];
						showSelectedUsersForPie(questionId, itemIdx);
					}
				});
				
				piechart.on('selectLegend', function(info) {
					var question = questionStatistic.filter(function(qst) {return qst["questionId"] == questionId})[0];
					if (question) {
						var itemIdx = info["index"];
						showSelectedUsersForPie(questionId, itemIdx);
					}
				});
			} */
			
			function generateRandomColor() {
				var letters = '0123456789ABCDEF';
				var color   = '#';
				
				for (var i = 0; i < 6; i++) {
					color += letters[Math.floor(Math.random() * 16)];
				}
				
				return color;
			}
			
			function addNewColor() {
				var color = generateRandomColor();
				while (colors.indexOf(color) > -1) {
					color = generateRandomColor();
				}
				
				return color;
			}
			
			function createPieChart(labels, values, canvasElmt, legendElmt, tooltipEl, questionId) {
				if (labels.length > colors.length) {
					for (var i = colors.length; i < labels.length; i++) {
						var newColor = generateRandomColor();
						colors.push(addNewColor());
					}
				}
				
				var ctx = canvasElmt.getContext("2d");
				var myPieChart = new Chart(ctx, {
					type: "pie",
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
							},
							enabled: false,
							custom: function (tooltip) {
								// Hide if no tooltip
								if (tooltip.opacity === 0) {
									tooltipEl.style.opacity = 0;
									return;
								}
								
								// Set caret Position
								tooltipEl.classList.remove("above", "below", "no-transform");
								
								if (tooltip.yAlign) {
									tooltipEl.classList.add(tooltip.yAlign);
								}
								else {
									tooltipEl.classList.add("no-transform");
								}
								
								function getBody(bodyItem) {
									return bodyItem.lines;
								}
								
								// Set Text
								if (tooltip.body) {
									var titleLines = tooltip.title || [];
									var bodyLines  = tooltip.body.map(getBody);
									var trElmt     = document.createElement("tr");
									var tdElmt     = document.createElement("td");
									var tableElmt  = tooltipEl.querySelector('table');
									
									bodyLines.forEach(function(body, i) {
										var colors    = tooltip.labelColors[i];
										var spanElmt1 = document.createElement("span");
										var spanElmt2 = document.createElement("span");
										var style     = "background:" + colors.backgroundColor + "; border-color:" + colors.borderColor + "; border-width: 2px";
										spanElmt1.setAttribute("class", "chartjs-tooltip-key");
										spanElmt1.setAttribute("style", style);
										spanElmt2.textContent = body;
										tdElmt.appendChild(spanElmt1);
										tdElmt.appendChild(spanElmt2);
										trElmt.appendChild(tdElmt);
									});
									
									if (!tableElmt) {
										tableElmt = document.createElement("table");
										tooltipEl.appendChild(tableElmt);
									}
									
									tableElmt.innerHTML = "";
									tableElmt.appendChild(trElmt);
								}
								
								//Set tooltip position
								var position                  = this._chart.canvas.getBoundingClientRect();
								tooltipEl.style.opacity       = 1;
								tooltipEl.style.position      = "absolute";
								tooltipEl.style.left          = position.left + window.pageXOffset + tooltip.caretX + "px";
								tooltipEl.style.top           = position.top + window.pageYOffset + tooltip.caretY + "px";
								tooltipEl.style.fontFamily    = tooltip._bodyFontFamily;
								tooltipEl.style.fontSize      = tooltip.bodyFontSize + "px";
								tooltipEl.style.fontStyle     = tooltip._bodyFontStyle;
								tooltipEl.style.padding       = tooltip.yPadding + "px " + tooltip.xPadding + "px";
								tooltipEl.style.pointerEvents = "none";
							}
						} ,
						legendCallback: function(chart) {
							return createLegend(chart.data);
						},
						legend: {
							display: false,
						},
						onClick : function (evt, item) {
							var itemIdx = item[0]["_index"];
							var data    = myPieChart.data["question"];
							if (data && surveyStatistic["annoynymous"] == 0 && (surveyStatistic["userExposed"] == 1 || adminYN == 'Y')) {
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
			
			function getTotalCnt(data) {
				var totalCnt = 0;
				for (var i = 0; i < data.length; i++) {
					totalCnt += data[i];
				}
				
				return totalCnt;
			}
			
			function createLegend(data) {
				var divMain  = document.createElement("div");
				var ul       = document.createElement("ul");
				ul.className = "legend-ul";
				var datasets = data["datasets"];
				var totalCnt = getTotalCnt(datasets[0].data);
				
				for (var i = 0; i < datasets[0].data.length; i++) {
					var crrValue          = datasets[0].data[i];
					var liElmt            = document.createElement("li");
					var divElmt1          = document.createElement("div");
					var divElmt2          = document.createElement("div");
					var spanElmt1         = document.createElement("div");
					var spanElmt2         = document.createElement("div");
					divElmt1.className    = "legend-circle";
					divElmt2.className    = "legend-label-wrap";
					spanElmt1.className   = "legend-label";
					spanElmt2.className   = "legend-percent";
					spanElmt1.textContent = data["labels"][i];
					spanElmt2.textContent = "[" + (crrValue/totalCnt * 100).toFixed(1) + "% - " + crrValue + SurveyMessages.strUser3 + "]";
					spanElmt1.setAttribute("title", spanElmt1.textContent);
					divElmt1.setAttribute("style", "background-color: " + datasets[0].backgroundColor[i]);
					divElmt2.appendChild(spanElmt1);
					divElmt2.appendChild(spanElmt2);
					liElmt.appendChild(divElmt1);
					liElmt.appendChild(divElmt2);
					
					if (data["question"] && surveyStatistic["annoynymous"] == 0 && (surveyStatistic["userExposed"] == 1 || adminYN == 'Y')) {
						liElmt.onclick = (function(questionId, optId) {return function() {showSelectedUsersForPie(questionId, optId);};})(data["question"], i);
					}
					
					liElmt.className = i >= 10 ? "lengen-off" : "lengen-on";
					
					ul.appendChild(liElmt);
				}
				
				divMain.appendChild(ul);
				
				if (datasets[0].data.length > 10) {
					var newLegendNavi  = new LegenNavi(divMain);
					var divBttn        = document.createElement("div");
					var spanElmt1      = document.createElement("span");
					var spanElmt2       = document.createElement("span");
					divBttn.className   = "lengen-navi";
					spanElmt1.className = "lengen-previous";
					spanElmt2.className = "lengen-next";
					spanElmt1.onclick = function(e) {newLegendNavi.previous();}
					spanElmt2.onclick = function(e) {newLegendNavi.next();}
					
					divBttn.appendChild(spanElmt1);
					divBttn.appendChild(spanElmt2);
					divMain.appendChild(divBttn);
				}
				
				return divMain;
			}
			
			function createQuestionBar(question, divElmt) {
				var divChart        = document.createElement("div");
				var divWrap         = document.createElement("div");
				divChart.className  = "chartWrapper";
				var divId           = "question" + question["level"];
				var moreParam       = surveyStatistic["annoynymous"] == 0 ? question["questionId"] : null;
				divWrap.className   = "chartAreaWrapper";
				divWrap.setAttribute("id", divId);
				divChart.appendChild(divWrap);
				divElmt.appendChild(divChart);
				
				var returnObj   = "";
				var response    = question.responses;
				var content     = question.content;
				var dataSets    = [];
				var labels      = "";
				var divWidth    = 0;
				var legendFlag  = true;
				var maxYValue   = 0;
				
				if (question["type"] == 3 || question["type"] == 4) {
					returnObj = getMtrDataSet(question);
					labels    = returnObj["labels"];
					dataSets  = returnObj["dataSetArr"];
					divWidth  = returnObj["width"];
					maxYValue = returnObj["maxY"];
				}
				else if (question["type"] == 7) {
					returnObj       = getSliderDataSet(question);
					labels          = returnObj["labels"];
					legendFlag      = false;
					maxYValue       = returnObj["maxY"];
					var dataObj     = {};
					dataObj["data"] = returnObj["dataSetArr"];
					dataObj["name"] = SurveyMessages.strSliderCnt;
					divWidth        = returnObj["width"];
					dataSets.push(dataObj);
				}
				else if (question["type"] == 8) {
					returnObj   = getRankingDataSet(question);
					labels      = returnObj["labels"];
					dataSets    = returnObj["dataSetArr"];
					divWidth    = returnObj["width"];
					maxYValue   = returnObj["maxY"];
				}
				
				if (divWidth < divWrap.clientWidth) {
					divWidth = divWrap.clientWidth;
					divWrap.className = "chartAreaWrapper bnk-wrap";
				}
				
				if (maxYValue == 0) {maxYValue = 2;}
				
				createBnkBarChart(labels, dataSets, divId, divWidth, legendFlag, maxYValue, moreParam);
			}
			
			function createBnkBarChart(labels, dataSets, divId, chartWidth, legendFlag, maxYValue, questionId) {
				var divElmt = document.getElementById(divId);
				var data = {
					categories: labels,
					series: dataSets,
					questionId: questionId
				};
				
				var options = {
					chart: {
						width: chartWidth,
						height: 400,
						format: '1,000'
					},
					
					yAxis: {title: '', min: 0, max: maxYValue},
					xAxis: {title: 'x'},
					legend: {align: 'top', showCheckbox: false, visible: legendFlag},
					series: {barWidth : 40},
					chartExportMenu: {visible : false},
					usageStatistics: false
				};
				
				var chart = tui.chart.columnChart(divElmt, data, options);
				chart.on('selectSeries', function(info) {
					var question = questionStatistic.filter(function(qst) {return qst["questionId"] == questionId})[0];
					
					if (question && surveyStatistic["annoynymous"] == 0 && (surveyStatistic["userExposed"] == 1 || adminYN == 'Y')) {
						var type     = parseInt(question["type"]);
						if (type == 7) {
							var indexVal  = info["index"];
							var itemValue = parseInt(labels[indexVal]);
							var responses = question["responses"].filter(function(res) {return res["sliderValue"] == itemValue});
							
							if (responses && responses.length > 0) {
								showSelectedUsers(responses);
							}
						}
						else if (type == 3 || type == 4) {
							var columnIdx = parseInt(info["legendIndex"]);
							var rowIdx    = parseInt(info["index"]);
							var option    = question["option"];
							var columId   = option.filter(function(opt) {return opt["colLevel"] == columnIdx})[0]["optionId"];
							var rowId     = option.filter(function(opt) {return opt["rowLevel"] == rowIdx})[0]["optionId"];
							
							var responses = question["responses"].filter(function(res) {
								return res["rowId"] == rowId && res["columnId"] == columId;
							});
							
							showSelectedUsers(responses);
						}
						else if (type == 8) {
							var rankingIdx = parseInt(info["index"]);
							var optionIdx  = parseInt(info["legendIndex"]);
							var option     = question["option"];
							var optionId   = option.filter(function(opt) {return opt["level"] == optionIdx})[0]["optionId"];
							var responses  = question["responses"].filter(function(res) {
								return res["rankingLevel"] == rankingIdx + 1 && res["optionId"] == optionId;
							});
							
							showSelectedUsers(responses);
						}
					}
				});
				
				chart.on('selectLegend', function(info) {
					var question = questionStatistic.filter(function(qst) {return qst["questionId"] == questionId})[0];
					
					if (question && surveyStatistic["annoynymous"] == 0 && (surveyStatistic["userExposed"] == 1 || adminYN == 'Y')) {
						var type = parseInt(question["type"]);
						if (type == 3 || type == 4) {
							var columnIdx = parseInt(info["index"]);
							var option    = question["option"];
							var columId   = option.filter(function(opt) {return opt["colLevel"] == columnIdx})[0]["optionId"];
							
							var responses = question["responses"].filter(function(res) {
								return res["columnId"] == columId;
							});
							
							showSelectedUsers(responses);
						}
						else if (type == 8) {
							var optionIdx  = parseInt(info["index"]);
							var option     = question["option"];
							var optionId   = option.filter(function(opt) {return opt["level"] == optionIdx})[0]["optionId"];
							var responses  = question["responses"].filter(function(res) {
								return res["optionId"] == optionId;
							});
							
							showSelectedUsers(responses);
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
				var maxYValue   = 0;
				
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
					dataset["name"]  = cols[i]["content"];
					
					for (var j = 0; j < rows.length; j++) {
						var rowId     = rows[j]["optionId"];
						var rowColRes = responses.filter(function(res) {
							return res["rowId"] == rowId && res["columnId"] == colId;
						});
						var rowColResCnt = rowColRes && rowColRes.length > 0 ? rowColRes.length : 0;
						
						if (maxYValue < rowColResCnt) {maxYValue = rowColResCnt;}
						
						colData.push(rowColResCnt);
					}
					
					dataset["data"] = colData;
					dataSetArr.push(dataset);
				}
				
				var minLabelWidth        = maxLabelLen * 12 > cols.length * 40 ? maxLabelLen * 12 : cols.length * 40;
				dataSetObj["labels"]     = rowLabels;
				dataSetObj["dataSetArr"] = dataSetArr;
				dataSetObj["width"]      = minLabelWidth * rows.length;
				dataSetObj["maxY"]       = maxYValue;
				
				return dataSetObj;
			}
			
			function getSliderDataSet(question) {
				var responses   = question["responses"];
				var options     = question["option"];
				var startPoint  = parseInt(options[0]["content"]);
				var endPoint    = parseInt(options[1]["content"]);
				var unitValue   = parseInt(question["unit"]);
				var unitArr     = [];
				var dataSetArr  = [];
				var dataSetObj  = {};
				var maxLabelLen = 0;
				var maxYValue   = 0;
				var numCnt      = (endPoint - startPoint) / unitValue;
				
				for (var i = startPoint; i <= endPoint; i+= unitValue) {
					var unitlabel = i + "";
					if (unitlabel.length > maxLabelLen) {
						maxLabelLen = unitlabel.length;
					}
					unitArr.push(unitlabel);
					var unitRes    = responses.filter(function(res) {return res["sliderValue"] == i;});
					var unitResCnt = unitRes && unitRes.length > 0 ? unitRes.length : 0;
					
					if (maxYValue < unitResCnt) {maxYValue = unitResCnt;}
					
					dataSetArr.push(unitResCnt);
				}
				
				var minLabelWidth        = maxLabelLen * 12 > 40 ? maxLabelLen * 12 : 40;
				dataSetObj["labels"]     = unitArr;
				dataSetObj["dataSetArr"] = dataSetArr;
				dataSetObj["width"]      = numCnt * minLabelWidth;
				dataSetObj["maxY"]       = maxYValue;
				
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
				var maxYValue   = 0;
				
				for (var i = 0; i < optionLen; i++) {
					var dataset      = {};
					var colData      = [];
					var optionId     = options[i]["optionId"];
					dataset["name"]  = options[i]["content"];
					var rankLabel    = (i + 1) + "";
					
					if (rankLabel.length > maxLabelLen) {
						maxLabelLen = rankLabel.length;
					}
					
					for (var j = 0; j < optionLen; j++) {
						var rowColRes = responses.filter(function(res) {
							return res["optionId"] == optionId && res["rankingLevel"] == (j + 1);
						});
						
						var rowColResCnt = rowColRes && rowColRes.length > 0 ? rowColRes.length : 0;
						colData.push(rowColResCnt);
						
						if (maxYValue < rowColResCnt) {maxYValue = rowColResCnt;}
					}
					
					dataset["data"] = colData;
					rowLabels.push(rankLabel);
					dataSetArr.push(dataset);
				}
				
				var minLabelWidth        = maxLabelLen * 12 > optionLen * 40 ? maxLabelLen * 12 : optionLen * 40;
				dataSetObj["labels"]     = rowLabels;
				dataSetObj["dataSetArr"] = dataSetArr;
				dataSetObj["width"]      = optionLen * minLabelWidth;
				dataSetObj["maxY"]       = maxYValue;
				
				return dataSetObj;
			}
		})();
	</script>
</html>