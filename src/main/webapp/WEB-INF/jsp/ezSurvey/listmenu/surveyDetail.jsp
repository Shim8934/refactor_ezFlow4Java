<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
	<title><spring:message code="ezSurvey.t01"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
	<style type="text/css">
		#ppContent h1, #ppContent h2 , #ppContent h3 , #ppContent h4 , #ppContent h5 , #ppContent h6 {
			margin-left:0px;
			margin-right:0px;
			color:#000000;
		}
		#ppContent h1 {font-size:2em; margin-top:0.67em; margin-bottom:0.67em;}
		#ppContent h2  {font-size:1.5em; margin-top:0.83em; margin-bottom:0.83em;}
		#ppContent h3 {font-size:1.17em; margin-top:1em; margin-bottom:1em;}
		#ppContent h4 {font-size:1em; margin-top:1.33em; margin-bottom:1.33em;}
		#ppContent h5 {font-size:0.83em; margin-top:1.67em; margin-bottom:1.67em;}
		#ppContent h6 {font-size:0.67em; margin-top:2.33em; margin-bottom:2.33em;}
		#ppContent img {height:auto !important;}
	</style>
		
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js'   )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js'        )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.ddslick.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg'              )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script>
		if ('2' == "<c:out value='${survey.useStatus}'/>" && 'N' == "<c:out value='${adminYN}'/>" && "<c:out value='${user}'/>" != "<c:out value='${creator.id}'/>") {
			alert(SurveyMessages.strPauseMsg03);
			window.close();
		}		
	</script>
</head>
	
<body class="surveyBody">
	<div class="header-wrapper">
		<div class="surveydetail-header">
			<ul class="on">	
				<c:if test="${(finishYN eq 'N') && ((survey.draftFlag ne 1) && (participation eq 'yes') && (resStatus ne true) || (survey.multiAnswerFlag ne 0)) && survey.useStatus != '2'}">
					<li class="off"><span id="saveResult"><spring:message code="ezSurvey.t17"/></span></li>
				</c:if>
				<c:if test="${user == creator.id}">
					<li class="off"><span id="suvyDlt"><spring:message code="ezSurvey.t21"/></span></li>
				</c:if>
				<c:if test="${(finishYN eq 'N') && (user == creator.id || adminYN eq 'Y')}">
					<li class="off"><span id="suvyEnd"><spring:message code="ezSurvey.endSurv01"/></span></li>
					<c:choose>
						<c:when test="${survey.useStatus == '1'}">
							<li class="off"><span id="suvyPause"><spring:message code="ezSurvey.survPause"/></span></li>
						</c:when>
						<c:when test="${survey.useStatus == '2'}">
							<li class="off"><span id="suvyResume"><spring:message code="ezSurvey.survResume"/></span></li>
						</c:when>
					</c:choose>
				</c:if>
				<c:if test="${(finishYN eq 'N') && (survey.draftFlag ne 1) && (participation eq 'yes') && (survey.multiAnswerFlag eq 0) && (resStatus eq true) && survey.useStatus != '2'}">
					<li class="off"><span id="suvyUdt"><spring:message code="ezSurvey.t118"/></span></li>
					<li class="off"><span id="suvyDel"><spring:message code="ezSurvey.t117"/></span></li>
				</c:if>
			</ul>
		</div>
		<c:if test="${empty mode}">
			<div id="close"><ul><li><span id="cancelBttn"></span></li></ul></div>
		</c:if>
	</div>
	
	<ul id="upage-ul" class="upage-ul off" style="display: none;">
		<li><span class="srvyInfo srvyInfo01"></span><span><spring:message code="ezSurvey.t32" /> : </span>
			<span><spring:message code="${survey.anonymousFlag == 1 ? 'ezSurvey.t48' : 'ezSurvey.t47'}"/></span>
			<c:if test="${survey.anonymousFlag == 0}"><%--기명인 경우에만 참여자 공개여부 표출--%>
				<span>(<spring:message code="ezSurvey.t105"/>&nbsp;<spring:message code="${survey.userExposedFlag == 1 ? 'ezSurvey.t42' : 'ezSurvey.t43'}"/>)</span>
			</c:if>
		</li>
		<li><span class="srvyInfo srvyInfo02"></span><span><spring:message code="ezSurvey.t52" /> : </span>
			<span><spring:message code="${survey.paritipateFlag == 1 ? 'ezSurvey.t54' : 'ezSurvey.t53'}"/></span>
		</li>
		<li><span class="srvyInfo srvyInfo03"></span><span><spring:message code="ezSurvey.t41" /> : </span>
			<span>
			    <c:if test="${survey.resultPublicFlag == 0}"><spring:message code="ezSurvey.t43"/></c:if>
			    <c:if test="${survey.resultPublicFlag == 1}"><spring:message code="ezSurvey.t42"/></c:if>
			    <c:if test="${survey.resultPublicFlag == 2}"><spring:message code="ezSurvey.jih01"/></c:if>
			</span>
		</li>
		<c:if test="${survey.resultPublicFlag == 1}">
			<li><span class="srvyInfo srvyInfo04"></span><span><spring:message code="ezSurvey.t96" /> : </span>
				<span><spring:message code="ezSurvey.t97"/><c:out value=" ${survey.openDays}"/> <spring:message code="ezSurvey.t45"/></span>
			</li>
		</c:if>
		<li><span class="srvyInfo srvyInfo05"></span><span><spring:message code="ezSurvey.t112" /> : </span>
			<span><spring:message code="${survey.mailFlag == 1 ? 'ezSurvey.t114' : 'ezSurvey.t115'}"/></span>
		</li>
		<li><span class="srvyInfo srvyInfo06"></span><span><spring:message code="ezSurvey.t113" /> : </span>
			<span><spring:message code="${survey.popupFlag == 1 ? 'ezSurvey.t114' : 'ezSurvey.t115'}"/></span>
		</li>
	</ul>
	
	<div class="surveydetail-body" id="mainSurveyBody">
		<div id="svTitle" class="survey-title"><c:out value="${survey.title}"></c:out><span class="srvyTitle_info" id="surveyInfBttn"><img src="/images/ezSurvey/srvyTitle_info.png"></span></div>
		
		<div id="svPurpose" class="svPurpose">
			<div class="survey-otherinf">
				<table class="content surveyDtl">
					<tr>
						<th class="left-Th"><spring:message code="ezSurvey.t24"/></th> <%-- creator name setting --%>
						<td class="right-Td">
							<div class="surveyinf-divcf"><c:out value="${survey.creatorName}"/></div>
						</td>
						<th class="left-Th"><spring:message code="ezSurvey.t94"/></th> <%-- create date setting --%>
						<td class="right-Td">
							<div class="surveyinf-divcf"><c:out value="${fn:substring(survey.createDate, 0, 16)}"/></div> <%--16을 19로 변경하면 초까지 표기--%>
						</td>
					</tr>
					<tr>
						<th class="left-Th"><spring:message code="ezSurvey.t38"/></th> <%-- start date && end date setting --%>
						<td class="right-Td">
							<div class="surveyinf-divcf">
								<span id="cf-startDate"><c:out value="${fn:substring(survey.startDate, 0, 10)}"/></span>
								<img class="ui-datepicker-trigger bnk" src="/images/ezSurvey/calendar-month.png">
								&nbsp;~&nbsp;
								<span id="cf-endDate"><c:out value="${fn:substring(survey.endDate, 0, 10)}"/></span>
								<img class="ui-datepicker-trigger bnk" src="/images/ezSurvey/calendar-month.png">
							</div>
						</td>
						<th class="left-Th"><spring:message code="ezSurvey.t49"/></th> <%-- multiple select setting --%>
						<td class="right-Td">
							<div id="cf-multiple" class="surveyinf-divcf"><spring:message code="${survey.multiAnswerFlag == 1 ? 'ezSurvey.t51' : 'ezSurvey.t50'}"/></div>
						</td>
					</tr>
				</table>
			</div>
			<div id="ppContent" class="ppContent" style="font-family:${defaultFontFamily}; font-size:${defaultFontSize};">${survey.purpose}</div>
			<div class="attach-zone2 off" id="surveyAtt">
				<div class="mainzone2">
					<div class="fileList">
						<ul class="user-pageul" id="attachUl"></ul>
					</div>
				</div>
			</div>
		</div>
		
		<div class="prevQsArea" id="prevQsAreaDIV"></div>

		<%--맺음말--%>
		<c:if test="${(survey.closingText ne '') && (survey.closingText ne null)}">
			<div id="svClosing" class="svPurpose">
				<div id="ppClosing" class="ppContent" style="font-family:${defaultFontFamily}; font-size:${defaultFontSize};"></div>
			</div>
		</c:if>
		
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
	</div>
</body>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/survey.js')}    "></script>
<script type="text/javascript" src="${util.addVer('/js/ezPoll/stomp.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPoll/sockjs.min.js')}"></script>
<script type="text/javascript">
	/* 2021-10-28 홍승비 - 초기 표출 시 다른 분기처리를 위하여 전역변수 설정 */
	var isFirstEvent = true; // 초기 슬라이드값은 반드시 최소값이므로, 비활성화 방지용 변수

	window.onunload = function() {
		if (stompClient !== null) {
			stompClient.disconnect();
		}
	};
	
	$(function() {
		var survey       = ${survey};
		var surveyId     = survey.surveyId;
		var logicmap     = null;
		var surveyPath   = [];
		var questionFile = new SurveyFile("images");
		var resposeObj = {
			surveyId : surveyId,
			responses : []
		};
		// 20.05.06 강승구 : 설문응답여부 코드추가
		var resStatus	 = ${resStatus};

		getCmtSockConnect(); /* 수정상태 확인을 위해 웹소켓 연결추가 */
		stompDisConnProcess(); /* 웹소켓 끊어짐 처리 */
		userEvent();
		
		var jsonResult;
		
		function getQuestions() {
			$.ajax({
				type: "GET",
				url: "/ezSurvey/getSurveyQuestions.do",
				data: {surveyId : surveyId, logic : "logic"},
				contentType: "application/json; charset=utf-8",
				dataType: "JSON",
				async: false,
				cache: false,
				success : function(data) {
					var question  = JSON.parse(JSON.stringify(data["questions"]));
					if (data["logicmap"]) {logicmap = JSON.parse(JSON.stringify(data["logicmap" ]));}
					
					for (var i = 0; i < question.length; i++) {
						SurveyCreate.setQs(question[i]);
					}
					
					SurveyCreate.setQsForm(0);
					
					/* 2021-10-27 홍승비 - 전자설문 분기처리 전체적으로 수정 (firstpath 사용하지 않고 페이지 내부의 함수로 처리) */
	 				/*	if (data["firstpath"]) {
						toggleQuestionList(JSON.parse(JSON.stringify(data["firstpath"])));
					} */
					toggleQuestionList_New("1"); // 가장 첫번째 질문인 "prevQstn1"을 의미함 (첫번째 질문은 반드시 활성화됨)
				},
				error : function(error) {
					alert(SurveyMessages.strError);
				}
			});
			
			/* 2020-07-16 홍승비 - IE 브라우저에서 하단 패딩 추가 */
			if (navigator.userAgent.toLowerCase().indexOf('chrome') == -1) {
				document.getElementById("prevQsAreaDIV").style.paddingBottom = "10px";
			}
		}
		// 분기 노드 처리 함수
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
		// 분기 설정에 따라 mask 생성/제거
		function toggleQuestionList(checkList) {
			var listQstDiv = document.getElementsByClassName("prevQsWrapper");
			var startPoint = checkList[0] - 1 > 0 ? checkList[0] - 1 : 0;
			for (var i = startPoint, len = listQstDiv.length; i < len; i++) {
				var qstLevel = parseInt(listQstDiv[i].id.replace("prevQstn", ""));
				
				if (checkList.indexOf(qstLevel) == -1) {
					var checkMask = $("#mask" + qstLevel).length;
					
					if (checkMask == 0) {
						var mask = $("<div class='mask' id='mask" + qstLevel + "'></div>");
						var wrapper = $("#prevQstn" + qstLevel);
						var height = wrapper.height();
						var width = wrapper.width();
						wrapper.prepend(mask);
						
						$("#mask" + qstLevel).css({"height": height, "width": width, "background-color": "gray", "opacity": "0.3", "position" : "absolute"})
					}
				}
				else {
					$("#prevQstn" + qstLevel).find("#mask" + qstLevel).remove();
				}
			}
		}
		
		function traverNode(nodeLevel, currentPath, totalPath) {
			if (nodeLevel == 0) {
				totalPath.push(currentPath);
			}
			else {
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
		}
		// 설문 정보 토글
		function toggleSurveyInformation() {
			var ulInf    = document.getElementById("upage-ul");
			var crrClass = ulInf.className;
			ulInf.className = crrClass == "upage-ul" ? "upage-ul off" : "upage-ul";
		}
		
		function setBodyHeight() {
			var wdHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			document.getElementById("mainSurveyBody").style.height = (wdHeight - 74) + "px";
		}
		
		// 20.05.06 강승구 : 설문응답에 따라 데이터 셋팅
		function checkQuestionAnswer() {
			if(survey.multiAnswerFlag == 0 && resStatus){
				$.ajax({
					type: "GET",
					url: "/ezSurvey/getSurveyQuestions.do",
					data: {surveyId : surveyId, logic : "answer"},
					contentType: "application/json; charset=utf-8",
					dataType: "JSON",
					async: false,
					cache: false,
					success : function(data) {
						previousQuestionSetting(data);
					},
					error : function(error) {
						alert(SurveyMessages.strError);
					}
				});
			}
		}

		// 20.05.07 강승구 : 설문의 각 질문 하나씩 처리
		function previousQuestionSetting(questionsData) {
			if(questionsData) {
				if(questionsData.questions.length > 0) {
					for (var i = 0; i < questionsData.questions.length; i++) {
						showQuestionSetting(questionsData.questions[i]);
					}
				}
			}
		}

		// 20.05.07 강승구 : 설문의 보기(option) 유형별 처리
		function showQuestionSetting(question) {
			if(question) {
				var questionType = parseInt(question["type"]);
				switch(questionType) {
					case 1:
					case 2:
					case 9:
					case 10:
					case 11:
						checkQuestions(question["option"], question["level"], questionType);
						break;
					case 3:
					case 4:
					case 7:
					case 8:
						controlQuestions(question);
						break;
					case 5:
					case 6:
						writeQuestionsText(question);
						break;
				}
			}
		}

		// 20.05.07 강승구 : 선택형(단일선택, 다중선택, 드롭다운, 일정유형[단일/다중]) 질문에 대한 값 세팅처리
		function checkQuestions(options, level, type) {
			var userId = "${user}";
			
			for (var i = 0; i < options.length; i++) {
				var responses     = options[i]["responses"];
				var otherFlag     = options[i]["otherFlag"];
				var responsesCnt  = responses ? responses.length : 0;
				
				if(responses) {
					if (otherFlag == 1) {		// 기타사항
						responses.filter(function(item){
							if(item.responsorId == userId) {
								document.getElementById('othInput' + level).value = item["texts"];
								document.getElementById('prevQstn' + level).querySelector("input[otherflag]").checked = true;
								document.getElementById('prevQstn' + level).querySelector("input[otherflag]").setAttribute('responseId', item["responseId"]);
							}
						});
					} else {
						responses.filter(function(item){
							if(item.responsorId == userId) {
								if(type == 9) { // 드롭다운 유형
									//document.getElementById('prevQstn' + level).querySelector("option[value='" + i + "']").selected = true;
									$('#prevQstn' + level).find('select').val(i).trigger('change');
									document.getElementById('prevQstn' + level).querySelector("select").setAttribute('responseId', item["responseId"]);
								} else {
									document.getElementById('prevQstn' + level).querySelector("div[level='" + i + "']").querySelector("input").click();
									document.getElementById('prevQstn' + level).querySelector("div[level='" + i + "']").querySelector("input").setAttribute('responseId', item["responseId"]);
								}
							}
						});
					}
				}
			}
		}

		// 20.05.08 강승구 : 기타유형(단일행렬, 다중선택행렬, 슬라이드형, 순위형)
		function controlQuestions(question) {
			var userId = "${user}";

			if(question) {
				var type     = parseInt(question["type"]);
				var questionRes = question["responses"];
				var optionLevel = question["level"];
				var returnObj   = "";

				if (type == 3 || type == 4) {			// 행렬형태
					returnObj = getMtrDataSet(question, userId);
					
					for(i = 0; i < returnObj.length; i++) {
						for(j = 0; j < returnObj[i]["matrixData"].length; j++) {
							document.getElementById('prevQstn' + optionLevel).querySelector("input[value='" + returnObj[i]["matrixData"][j] + "']").checked = true;
							document.getElementById('prevQstn' + optionLevel).querySelector("input[value='" + returnObj[i]["matrixData"][j] + "']").setAttribute('responseId', returnObj[i]["responseId"]);
						}
					}
				} else if (type == 7) {					// 슬라이드 형태
					if(questionRes) {
						for(i = 0; i < questionRes.length; i++) {
							if(questionRes[i]["responsorId"] == userId) {
								// document.getElementById('prevQstn' + optionLevel).querySelector("input").value = questionRes[i]["sliderValue"];
								// document.getElementById('prevQstn' + optionLevel).querySelector("output").innerText = questionRes[i]["sliderValue"];
								// document.getElementById('prevQstn' + optionLevel).querySelector("output").setAttribute('responseId', questionRes[i]["responseId"]);
								$('#prevQstn' + optionLevel).find('input').val(questionRes[i]["sliderValue"]).trigger('change');
							}
						}
					}
				} else if (type == 8) {					// 순위 형태
					if(questionRes) {
						for(i = 0; i < questionRes.length; i++) {
							if(questionRes[i]["responsorId"] == userId) {
								var optionRank = 'rank-order' + questionRes[i]["rankingLevel"];
								var resOptionId = questionRes[i]["optionId"];
								
								document.getElementById('prevQstn' + optionLevel).querySelector("span[id='" + optionRank + "']").parentNode.querySelector("option[optionid='" + resOptionId + "']").selected = true;
								document.getElementById('prevQstn' + optionLevel).querySelector("span[id='" + optionRank + "']").parentNode.querySelector("select").setAttribute('responseId', questionRes[i]["responseId"]);
							}
						}
					}
				}
			}			
		}

		// 20.05.08 강승구 : 행렬정보 반환
		function getMtrDataSet(question, userId) {
			var options     = question["option"];
			var responses   = question["responses"];
			var rows        = [];
			var cols        = [];
			var dataSetArr  = [];
			var maxYValue   = 0;
			
			if(responses) {
				// 단일데이터에서 행렬구분([0,1,2,3] -> [0,1],[2,3])
				for (var i = 0; i < options.length; i++) {
					if (options[i]["colLevel"] == -1) {
						rows.push(options[i]);
					}
					else if (options[i]["rowLevel"] == -1) {
						cols.push(options[i]);
					}
				}
				
				// 행/렬 정보 정렬
				rows.sort(function(rowA, rowB) {return rowA["rowLevel"] - rowB["rowLevel"]});
				cols.sort(function(colA, colB) {return colA["colLevel"] - colA["colLevel"]});
				
				// 행(ROW)단위로 데이터 구분
				for (i = 0; i < rows.length; i++) {
					var dataset      = {};
					var rowData      = [];
					var rowId        = rows[i]["optionId"];
					dataset["name"]  = rows[i]["content"];		// 디버그 확인용 변수[지워서 따로 커스터마이징 하셔도 됩니다.]

					for (j = 0; j < cols.length; j++) {
						var colId     = cols[j]["optionId"];
						
						for(k = 0; k < responses.length; k++) {
							if(responses[k]["rowId"] == rowId && responses[k]["columnId"] == colId && responses[k]["responsorId"] == userId) {
								rowData.push(i + "," + j);
								dataset["responseId"] = responses[k]["responseId"];
							}
						}
					}

					dataset["matrixData"] = rowData;
					dataSetArr.push(dataset);
				}
			}

			return dataSetArr;
		}

		// 20.05.07 강승구 : 텍스트형(단답형, 문장형) 질문에 대한 값 세팅처리
		function writeQuestionsText(question) {
			var userId = "${user}";
			var responses = question["responses"];
			var level = question["level"];
			var type = question["type"];

			if(responses && level) {
				for (i = 0; i < responses.length; i++) {
					if (responses[i].responsorId == userId) {
						if(type == 5) {
							document.getElementById('prevQstn' + level).querySelector("input").value = responses[i].texts;
							document.getElementById('prevQstn' + level).querySelector("input").setAttribute('responseId', responses[i]["responseId"]);
						} else {
							document.getElementById('prevQstn' + level).querySelector("textarea").value = responses[i].texts;
							document.getElementById('prevQstn' + level).querySelector("textarea").setAttribute('responseId', responses[i]["responseId"]);
						}
					}
				}
			}
		}
		
		/* 2021-10-27 홍승비 - 질문 응답에 변경이 일어나는 경우, 새로운 분기처리 함수 동작 */
		function userEvent() {
			SurveyCreate.changeMode(true); //change download mode
			getQuestions();
			showAttachList();
			setBodyHeight();
			
			window.addEventListener("load", function(e) {setBodyHeight();}, false);
			window.addEventListener("resize", function(e) {setBodyHeight();}, false);
			document.getElementById("surveyInfBttn").onclick = function(e) {toggleSurveyInformation();};
			
			// 단일 선택 질문 및 일정 단일 질문 버튼 클릭 이벤트 (type 1, type 10)
			$(".prevQsArea").on("click", ".optRdo", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				var logicNum = parseInt($(this).attr("logic"));
				
				//if (!isNaN(logicNum) && logicNum != -1 && logicmap) {processLogicNode(prId, logicNum);}
				toggleQuestionList_New(prId);
			});
			// 드롭다운 질문 셀렉트 박스 이벤트 (type 9)
			$(".prevQsArea").on("change", ".dropdown-wrap", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				var logicNum = parseInt($("select[name=drdw" + prId + "] option:selected").attr("logic"));
				//if (!isNaN(logicNum) && logicNum != -1 && logicmap) {processLogicNode(prId, logicNum);}
				toggleQuestionList_New(prId);
			});
			
			// 슬라이드 질문 슬라이드값 변경 이벤트 (type 7)
			$(".prevQsArea").on("change", ".slider-range", function() {
				var outputElmt         = this.parentElement.parentElement.querySelector("output[class='slider-output']");
				outputElmt.textContent = this.value;
				
				var prId       = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				var logicNum   = parseInt($("#slider" + prId).attr("logic"));
				var logicPoint = parseInt($("#slider" + prId).attr("logicPoint"));
				var currentVal = parseInt(this.value);
				
/* 				if (!isNaN(logicNum) && logicNum != -1 && logicmap) {
					if (currentVal >= logicPoint) {
						processLogicNode(prId, logicNum);
					}
					else {
						processLogicNode(prId, prId + 1);
					}
				} */
				
				toggleQuestionList_New(prId);
			});
			// 다중선택 질문 및 일정 다중 선택 버튼 클릭 이벤트 (type 2, type 11)
			$(".prevQsArea").on("click", ".optChb", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				toggleQuestionList_New(prId);
			});
			// 행렬 단일선택 질문 버튼 클릭 이벤트 (type 3)
			$(".prevQsArea").on("click", ".matrix input:radio", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				toggleQuestionList_New(prId);
			});
			// 행렬 다중선택 질문 버튼 클릭 이벤트 (type 4)
			$(".prevQsArea").on("click", ".matrix input:checkbox", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				toggleQuestionList_New(prId);
			});
			// 단답형 입력 이벤트 (type 5)
			$(".prevQsArea").on("keyup", ".shortanswer", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				toggleQuestionList_New(prId);
			});
			// 문장형 입력 이벤트 (type 6)
			$(".prevQsArea").on("keyup", ".paragraph", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				toggleQuestionList_New(prId);
			});
			// ranking 셀렉트 박스 옵션 선택시 값 비교 (type 8)
			$(".prevQsArea").on("change", "select[name^=ranking]", function() {
				var length = $(this).parents(".ranking-wrap").find(".ranking-select").length;
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				// 내가 선택한 값
				var thisValue = $(this).val();
				// 내가 선택한 셀렉트 박스의 순번
				var orders = $(this).attr("name").replace("ranking" + id, "");
				// 위 아래의 모든 셀렉트 박스 값과 비교
				for (var i = 0; i < length; i++) {
					// 내가 클릭한 셀렉트 박스는 비교 skip 
					if (orders == i) {continue;}
					// 비교할 값
					var neighborValue = $("select[name=ranking" + id + i + "]").val();
					if (thisValue != "" && thisValue == neighborValue) {
						alert(SurveyMessages.strNoSameRsps);
						// 셀렉트 박스 값 초기화
						$("select[name=ranking" + id + orders + "]").val("").prop("selected", true);
					}
				}
				
				toggleQuestionList_New(parseInt(id));
			});
			
			// 설문 정보 버튼 클릭 이벤트
			$("#surveyInfBttn").click(function() {
				var infoElmt = $("#upage-ul");
				var status = infoElmt.css("display");
				
				if (status == "none") {
					infoElmt.show();
				} else {
					infoElmt.hide();
				}
			})
			
			var delBttn = document.getElementById("suvyDlt");
			if (delBttn) {delBttn.onclick = function(e) {deleteFileConfirm();};}
			
			var cancelBttn = document.getElementById("cancelBttn");
			var saveResult = document.getElementById("saveResult");
			if (cancelBttn) {cancelBttn.onclick = function(e) {window.close();};}
			if (saveResult) {saveResult.onclick = function(e) {saveSurveyResponses();};}

			// 20.05.08 강승구 : 설문정보 수정버튼
			var updateBttn = document.getElementById("suvyUdt");
			if (updateBttn) {updateBttn.onclick = function(e) {saveSurveyResponses();};}

			var deleteBttn = document.getElementById("suvyDel");
			if (updateBttn) {deleteBttn.onclick = function(e) {deleteSurveyResponses();};}

			/* 2025-06-13 양지혜 - 설문종료 버튼 */
			var closeBttn = document.getElementById("suvyEnd");
			if (closeBttn) {closeBttn.onclick = function(e) {endSurvey();};}
			/* 설문 일시정지 */
			var pauseBttn = document.getElementById("suvyPause");
			var resumeBttn = document.getElementById("suvyResume");
			if (pauseBttn) {pauseBttn.onclick = function(e) {pauseSurvey("P");};}
			if (resumeBttn) {resumeBttn.onclick = function(e) {pauseSurvey("R");};}
			
			// 20.05.06 강승구 : 설문응답여부에 따른 처리 코드추가
			checkQuestionAnswer();
			isFirstEvent = false;

			if (survey.closingText != null && survey.closingText != "") {
				document.getElementById("ppClosing").innerHTML = escapeHtml(survey.closingText).replace(/(\r\n|\n|\r)/g, "<br/>");
			}
		}
		// 첨부파일 리스트 나타내기
		function showAttachList() {
			var attachList = survey["attachList"];
			if (attachList && attachList.length > 0) {
				var ulElmt = document.getElementById("attachUl");
				ulElmt.innerHTML = "";
				
				for (var i = 0; i < attachList.length; i++) {
					var filename     = attachList[i]["fname"];
					var furl         = attachList[i]["furl"];
					var liElmt       = document.createElement("li");
					var divWrp       = document.createElement("div");
					var divImg       = document.createElement("div");
					var imgElmt      = document.createElement("img");
					var divInf       = document.createElement("div");
					divWrp.className = "attDivFile";
					divImg.className = "attImgAva";
					imgElmt.src      = questionFile.getImage(attachList[i])["imageSrc"];
					
					if (furl) {
						divInf.className    = "attFileInf2";
						divInf.textContent  = attachList[i]["fname"];
						divInf.setAttribute("title", attachList[i]["fname"]);
						liElmt.onclick      = (function(url) {return function() {window.open(url);};})(furl);
					}
					else {
						var spanTtl         = document.createElement("span");
						var spanSz          = document.createElement("span");
						spanTtl.textContent = filename;
						spanSz.textContent  = questionFile.getSize(attachList[i]["fileSize"]);
						spanTtl.setAttribute("title", filename);
						divInf.className  = "attFileInf";
						divInf.appendChild(spanTtl);
						divInf.appendChild(spanSz);
						liElmt.onclick      = (function(name, path) {return function() {questionFile.download(name, path);};})(attachList[i]["fname"], attachList[i]["fpath"]);
					}
					
					divImg.appendChild(imgElmt);
					divWrp.appendChild(divImg);
					divWrp.appendChild(divInf);
					liElmt.appendChild(divWrp);
					ulElmt.appendChild(liElmt);
				}
				
				document.getElementById("surveyAtt").className = "attach-zone2";
			}
			else {
				document.getElementById("surveyAtt").className = "attach-zone2 off";
			}
		}
		// 설문 응답값 획득
		function saveSurveyResponses() {
			/* 2023-09-15 홍승비 - 설문 응답 기간이 아닌 경우, 이후 동작을 하지 않고 리턴하도록 수정 */
			// 설문 기간 체크
			var periodResult = checkDate();
			if (periodResult == "fail") {
				return;
			}
			
			// 필수 답변에 응답 여부 체크
			var requiredResult = checkRequired();
			var responseResult = "success";
			
			if (periodResult != "fail" && requiredResult != "fail") {
				var qsWrappers = $(".prevQsArea").find(".prevQsWrapper");
				
				for (var i = 0; i < qsWrappers.length; i++) {
					var wrapper = qsWrappers[i];
					var mask = wrapper.querySelector("div[class=mask]");
					
					if (mask == null) {
						var qstnId = wrapper.getAttribute("id");
						var id     = parseInt(qstnId.replace("prevQstn", ""));
						var type   = parseInt(wrapper.getAttribute("type"));
						
						switch (type) {
							case 1:
								responseResult = getSingleSltRespose(id, type);
								break;
							case 2:
								responseResult = getMultiSltRespose(id, type);
								break;
							case 3:
								getSingleMtrRespose(id, type);
								break;
							case 4:
								getMultiMtrRespose(id, type);
								break;
							case 5:
								getTxtRespose(id, type);
								break;
							case 6:
								getTxtRespose(id, type);
								break;
							case 7:
								getSliderRespose(id, type);
								break;
							case 8:
								responseResult = getRankingRespose(id, type);
								break;
							case 9:
								getDrdwRespose(id, type);
								break;
							case 10:
								getSingleScheduleRespose(id, type);
								break;
							case 11:
								getMultiScheduleRespose(id, type);
								break;
						}
						
					}
					if (responseResult == 'fail') {
					    // 응답 획득에 실패할 경우, 응답 배열을 초기화 함
						resposeObj.responses = [];
						return;
					}
				}
			}
			
			/* 2020-07-16 홍승비 - 중복응답(multiAnswerFlag = 1)을 사용하는 경우, 필수응답 알러트와 답변 알러트가 같이 나타나는 오류 수정 */
			if ((periodResult != "fail" && requiredResult != "fail" && responseResult != "fail" && !resStatus) || (survey.multiAnswerFlag != 0 && requiredResult != "fail")) {
				saveResponse();
			} else if (periodResult != "fail" && requiredResult != "fail" && responseResult != "fail" && survey.multiAnswerFlag == 0 && resStatus) {
				console.log(resposeObj);
				updateResponse();
			}
		}
		// 응답 저장
		function saveResponse() {
			if (resposeObj.responses.length > 0) {
				$.ajax({
					type: "POST",
					url: "/ezSurvey/saveResponse.do",
					data: JSON.stringify(resposeObj),
					contentType: "application/json; charset=utf-8",
					dataType: "JSON",
					async: false,
					cache: false,
					success : function(data) {
						afterSaveSuccessfully(data);
					},
					error : function(error) {
						alert(SurveyMessages.strError);
					}
				});
			}
			else {
				alert(SurveyMessages.strNoResponse);
				resposeObj.responses = [];
			}
		}

		// 20.05.08 강승구 : 응답 수정
		function updateResponse() {
			if (resposeObj.responses.length > 0) {
				$.ajax({
					type: "POST",
					url: "/ezSurvey/updateResponse.do",
					data: JSON.stringify(resposeObj),
					contentType: "application/json; charset=utf-8",
					dataType: "JSON",
					async: false,
					cache: false,
					success : function(data) {
						afterSaveSuccessfully(data);
					},
					error : function(error) {
						alert(SurveyMessages.strError);
					}
				});
			}
			else {
				alert(SurveyMessages.strNoResponse);
				resposeObj.responses = [];
			}
		}

		/* 2025-05-23 양지혜 - 응답삭제 */
		function deleteSurveyResponses() {
			if (confirm(SurveyMessages.strDelResponse)) {
				$.ajax({
					type: "POST",
					url: "/ezSurvey/deleteResponse.do",
					data: JSON.stringify(resposeObj),
					contentType: "application/json; charset=utf-8",
					dataType: "JSON",
					async: false,
					cache: false,
					success : function(data) {
						afterSaveSuccessfully(data);
					},
					error : function() {
						alert(SurveyMessages.strError);
					}
				});
			};
		}
		
		function refreshOpenerAndClose(closeYN) {
			if (window.opener.reloadSurveyPage != undefined) {
				window.opener.reloadSurveyPage();
				// 일단 현 상황에 맞춰 주석처리 나중에 필요하면 주석 풀면 됨
				// window.opener.getUnreadCounts('YES', 'YES', 'YES', 'YES', 'YES');
			}

			if (window.opener.SurveyItem != null) {
				if (window.opener && window.opener.SurveyItem) {window.opener.SurveyItem.reload();}
				if (window.opener && window.opener.openSurveyPopup)	{window.opener.openSurveyPopup("", 600, 600, 0, window.opener.surveyPopupIndex);}
				if (parent && parent.SurveyItem)               {parent.SurveyItem.reload();}
			}

			if (closeYN == 'Y') {
				window.close();
			} else {
				window.location.reload();
			}
		}
		
		function afterSaveSuccessfully(data) {
			var code = data.code;
			
			switch(code) {
				case 0 : alert(SurveyMessages.strSave2)     ; resposeObj.responses = []; refreshOpenerAndClose("Y"); break;
				case 1 : alert(SurveyMessages.strParamErr)  ; resposeObj.responses = []; break;
				case 2 : alert(SurveyMessages.strError)     ; resposeObj.responses = []; break;
				case 5 : alert(SurveyMessages.strMultiple3) ; resposeObj.responses = []; break;
				case 6 : alert(SurveyMessages.strNotResp)   ; resposeObj.responses = []; break;
				case 7 : alert(SurveyMessages.strNotPeriod2); resposeObj.responses = []; break;
				case 8 :
					alert(data.status === 'editing' ? SurveyMessages.strEditingErr01 : (data.status === 'deleted' ? SurveyMessages.strDeletedErr : SurveyMessages.strPauseMsg04));
					resposeObj.responses = []; 
					refreshOpenerAndClose("Y"); 
					break;
				case 9 : alert(SurveyMessages.strDelEnd)	; resposeObj.responses = []; refreshOpenerAndClose("N"); break;
				default: alert(SurveyMessages.strError)     ; resposeObj.responses = []; return;
			}
		}
		// 단일 선택 질문 응답 획득
		function getSingleSltRespose(id, type) {
			var answerObj  = {};
			var optionId   = {};
			var answer     = [];
			var result     = "success";
			var wrapper    = $("#prevQstn" + id);
			var checkedBtn = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]:checked");
			var optId      = parseInt(checkedBtn.attr("optionid"));
			var responseId = parseInt(checkedBtn.attr("responseId"));
			
			if (!isNaN(optId)) {
				if (checkedBtn.attr("otherFlag") == 1) {
					var checked = checkedBtn.prop("checked");
					var otherValue = $("#othInput" + id).val().trim();
					
					if (checked && otherValue != "") {
						optionId['otherFlag'] = 1;
						optionId['texts'] = otherValue;
					} else {
						result = "fail";
						alert(id + SurveyMessages.writeOthers);
					}
				}

				if (result !== "fail") {
					optionId['optionId'] = optId;
					optionId['responseId'] = responseId;
					answer.push(optionId);
					answerObj['answers'] = answer;
					answerObj['type'] = type;
					answerObj['questionLevel'] = id;
					resposeObj.responses.push(answerObj);
				}
			}
			
			return result;
		}
		// 다중 선택 질문 응답 획득
		function getMultiSltRespose(id, type) {
			var answerObj = {};
			var answer    = [];
			var result    = "success";
			var wrapper   = $("#prevQstn" + id);
			var checkBox  = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]");
			var length    = checkBox.length;
			
			for (var i = 0; i < length; i++) {
				if (checkBox[i].checked == true) {
					//var optLevel = parseInt(checkBox[i].value);
					var optId    = parseInt(checkBox[i].getAttribute('optionid'));
					var responseId = parseInt(checkBox[i].getAttribute('responseId'));
					var optionId = {};
					
					if (!isNaN(optId)) {
						if (checkBox[i].getAttribute('otherFlag') == 1) {
							var checked = checkBox[i].checked;
							var otherValue = $("#othInput" + id).val().trim();
							
							if (checked && otherValue != "") {
								optionId['otherFlag'] = 1;
								optionId['texts']     = otherValue;
							} else {
								result = "fail";
								alert(id + SurveyMessages.writeOthers);
							}
						}
						// 기타추가가 현재 1개만 생성 가능하게 되어있으므로 하위 로직은 분기처리 안하고 일단 둔다.
						optionId['optionId'] = optId;
						optionId['responseId'] = responseId;
						answer.push(optionId);
					}
				}
			}
			
			if (answer.length > 0 && result !== "fail") {
				answerObj['answers']       = answer;
				answerObj['type']          = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			
			return result;
		}
		// 행렬(단일 선택) 질문 응답 획득
		function getSingleMtrRespose(id, type) {
			var answerObj = {};
			var answer    = [];
			var wrapper   = $("#prevQstn" + id);
			var trLength  = wrapper.find("tbody").find("tr").length;
			
			for (var i = 0; i < trLength; i++) {
				var rowColObj = {};
				var rowColIds = $("input[name = qstn" + id + "opt" + i + "]:checked").attr("optionid");
				var responseId = $("input[name = qstn" + id + "opt" + i + "]:checked").attr("responseId");
				
				if (rowColIds != undefined) {
					var rowColArray = rowColIds.split(",");
					var row = rowColArray[0];
					var col = rowColArray[1];
					
					rowColObj['rowId'] = parseInt(row);
					rowColObj['colId'] = parseInt(col);
					rowColObj['responseId'] = responseId;
					answer.push(rowColObj);
				}
			}
			
			if (answer.length > 0) {
				answerObj['answers']       = answer;
				answerObj['type']          = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
		}
		// 행렬(다중 선택) 질문 응답 획득
		function getMultiMtrRespose(id, type) {
			var answerObj = {};
			var answer    = [];
			var wrapper   = $("#prevQstn" + id);
			var rowLength = wrapper.find("tbody").find("tr").length;
			var colLength = wrapper.find("thead").find("td").length;
			var checkedOpts = $("input[name^=qstn" + id + "opt]:checked");
			
			for (var i = 0; i < checkedOpts.length; i++) {
				var rowColObj = {};
				var rowColIds = checkedOpts[i].getAttribute("optionid");
				var rowColArray = rowColIds.split(",");
				var row         = rowColArray[0];
				var col         = rowColArray[1];
				
				rowColObj['rowId'] = parseInt(row);
				rowColObj['colId'] = parseInt(col);
				rowColObj['responseId'] = checkedOpts[i].getAttribute("responseId");
				answer.push(rowColObj);
			}
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
		}
		// 텍스트 질문 응답 획득
		function getTxtRespose(id, type) {
			var answerObj = {};
			var txtObj    = {};
			var answer    = [];
			var wrapper   = $("#prevQstn" + id);
			var txtAnswer = "";
			var optionId  = "";
			var responseId = "";
			
			if (type == 5) {
				txtAnswer = wrapper.find(".shortanswer").val();
				optionId = parseInt(wrapper.find(".shortanswer").attr("optionid"));
				responseId = parseInt(wrapper.find(".shortanswer").attr("responseId"));
			}
			else if (type == 6) {
				txtAnswer = wrapper.find(".paragraph").val();
				optionId = parseInt(wrapper.find(".paragraph").attr("optionid"));
				responseId = parseInt(wrapper.find(".paragraph").attr("responseId"));
			}
			
			if (txtAnswer != "") {
				txtObj['texts'] = txtAnswer;
				txtObj['optionId'] = optionId;
				txtObj['responseId'] = responseId;
				answer.push(txtObj);
			}
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
		}
		// 슬라이드 질문 응답 획득
		function getSliderRespose(id, type) {
			var answerObj = {};
			var sliderObj = {};
			var answer    = [];
			var wrapper   = $("#prevQstn" + id);
			var outputVal = parseInt(document.getElementById("slider" + id).textContent);
			var optionId  = parseInt($("#slider" + id).attr("optionid"));
			var responseId = parseInt($("#slider" + id).attr("responseid"));
			
			if (!isNaN(outputVal)) {
				sliderObj['sliderValue'] = outputVal;
				sliderObj['optionId'] = optionId;
				sliderObj['responseId'] = responseId;
				answer.push(sliderObj);
			}
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
		}
		// 순위 질문 응답 획득
		function getRankingRespose(id, type) {
			var answerObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var selectLengh = wrapper.find(".ranking-select").length;
			var result = "success";
			var count = 0;
			
			for (var i = 0; i < selectLengh; i++) {
				var optLevel = $("select[name^=ranking" + id + i + "]").val();
				if (optLevel != "") {
					count++;
				}
				
			}
			
			if (count > 0 && count != selectLengh) {
				alert(id + SurveyMessages.strIncomplete);
				return "fail";
				
			}
			else {
				for (var i = 0; i < selectLengh; i++) {
					var rankingObj = {};
					var rankNum = i + 1;
					var optionId = parseInt($("select[name='ranking" + id + i + "'] option:selected").attr("optionid"));
					var responseId = parseInt($("select[name='ranking" + id + i + "']").attr("responseid"));
					
					if (!isNaN(optionId)) {
						rankingObj['rankingLevel'] = rankNum;
						rankingObj['optionId'] = optionId;
						rankingObj['responseId'] = responseId;
						answer.push(rankingObj);
					}
					
				}
				
				if (answer.length > 0) {
					answerObj['answers'] = answer;
					answerObj['type'] = type;
					answerObj['questionLevel'] = id;
					resposeObj.responses.push(answerObj);
				}
			}
			
			return result;
		}
		// 드롭다운 질문 응답 획득
		function getDrdwRespose(id, type) {
			var answerObj = {};
			var drdwObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var optId = parseInt($("select[name=drdw" + id + "] option:selected").attr("optionid"));
			var responseId = parseInt($("select[name=drdw" + id + "]").attr("responseid"));
			
			if (!isNaN(optId)) {
				drdwObj['optionId'] = optId;
				drdwObj['responseId'] = responseId;
				answer.push(drdwObj);
			}
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
		}
		
		function getSingleScheduleRespose(id, type) {
			var answerObj  = {};
			var optionId   = {};
			var answer     = [];
			var result     = "success";
			var wrapper    = $("#prevQstn" + id);
			var checkedBtn = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]:checked");
			var optId      = parseInt(checkedBtn.attr("optionid"));
			var responseId = parseInt(checkedBtn.attr("responseId"));
			
			if (!isNaN(optId)) {
				optionId['optionId'] = optId;
				optionId['responseId'] = responseId;
				answer.push(optionId);
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			
			return result;
		}
		
		function getMultiScheduleRespose(id, type) {
			var answerObj = {};
			var answer    = [];
			var result    = "success";
			var wrapper   = $("#prevQstn" + id);
			var checkBox  = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]");
			var length    = checkBox.length;
			
			for (var i = 0; i < length; i++) {
				if (checkBox[i].checked == true) {
					//var optLevel = parseInt(checkBox[i].value);
					var optId    = parseInt(checkBox[i].getAttribute('optionid'));
					var responseId = parseInt(checkBox[i].getAttribute('responseId'));
					var optionId = {};
					
					if (!isNaN(optId)) {
						optionId['optionId'] = optId;
						optionId['responseId'] = responseId;
						answer.push(optionId);
					}
				}
			}
			
			if (answer.length > 0 && result !== "fail") {
				answerObj['answers']       = answer;
				answerObj['type']          = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			
			return result;
		}
		
		function deleteFileConfirm() {
			var itemArr = [];
			itemArr.push(surveyId);
			
			if (confirm(SurveyMessages.strDelete)) {
				var url  = "/ezSurvey/deleteItems.do";
				var data = {itemList : itemArr.toString()};
				
				makeAjaxCall(data, "GET", url, afterDeleteItem, null, true, null);
			}
		}
		
		function afterDeleteItem(data) {
			var code = data.code;
			switch(code) {
				case 0 : afterActionComplete(SurveyMessages.strDel) ; break;
				case 1 : alert(SurveyMessages.strParamErr); break;
				case 2 : alert(SurveyMessages.strError)   ; break;
				case 3 : alert(SurveyMessages.strPerm)    ; break;
				default: alert(SurveyMessages.strError)   ; return;
			}
		}
		
		function afterActionComplete(msg) {
			alert(msg);
			if (window.opener && window.opener.openSurveyPopup)    {window.opener.openSurveyPopup("", 600, 600, 0, window.opener.surveyPopupIndex);}
			
			if (window.opener != null && window.opener.reloadSurveyPage != undefined) {
				 window.opener.reloadSurveyPage();
				 // 일단 현 상황에 맞춰 주석처리
				 // 나중에 필요하면 주석 풀면 됌
				 // window.opener.getUnreadCounts('YES', 'YES', 'YES', 'YES', 'YES');
				 window.close();
			 }
			
			//2021-04-20 김정언 - (#76806) 설문 > 미리보기화면에서는 삭제버튼없고, 읽기창에선 삭제버튼있음
			if(window.opener != null) {				
				if (window.opener.SurveyItem) {window.opener.SurveyItem.reload();}
				window.close();
			} else {
				window.parent.SurveyItem.reload();
			}
		}
		
		function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode, moreParam) {
			$.ajax({
				type: ajaxType,
				url: ajaxUrl,
				data: ajaxData,
				dataType: "JSON",
				async: asyncMode != false ? true : false,
				cache: false,
				success : function(data) {
					handleSuccess(data, moreParam);
				},
				error : function(error) {
					if (handleError != null) {handleError();}
					
					alert(SurveyMessages.strError);
				}
			});
		}
		// 설문 가능 기간과 오늘 날짜 비교
		function checkDate() {
			var startDate = survey.startDate.substr(0, 10);
			var endDate   = survey.endDate.substr(0, 10);
			var today     = new Date();
			var yyyy      = today.getFullYear();
			var MM        = today.getMonth() + 1;
			var dd        = today.getDate();
			var result    = "success";
			
			if (dd < 10) {dd = '0' + dd;}
			if (MM < 10) {MM = '0' + MM;}
			
			today = yyyy + "-" + MM + "-" + dd;
			
			// 시작일이 오늘 이후이거나, 종료일이 오늘 이전인 경우 설문 응답 불가능
			if (startDate > today || endDate < today) {
				alert(SurveyMessages.strNotPeriod + startDate + "~" + endDate);
				result = "fail";
			}
			
			return result;
		}
		// 필수 응답 질문 유무 체크
		function checkRequired() {
			var result      = "success";
			var qsWrappers  = $(".prevQsArea").find(".prevQsWrapper");
			var arr         = [];
			var checkResult = "success";
			
			for (var i = 0; i < qsWrappers.length; i++) {
				var maskCnt = qsWrappers[i].querySelector("div[class=mask]");
				var required = qsWrappers[i].querySelector("strong[class='imptt']");
				
				if (maskCnt == null && required != null) {
					var id = i + 1;
					var type = parseInt(qsWrappers[i].getAttribute("type"));
					
					switch(type) {
						case 1 : 
						case 2 :
							checkResult = checkSltResponse(id);
							break;
						case 3 : 
						case 4 :
							checkResult = checkMtrResponse(id, type);
							break;
						case 5 : 
						case 6 :
							checkResult = checkTxtResponse(id, type);
							break;
						case 7 : 
							checkResult = checkSliderResponse(id);
							break;
						case 8 : 
							checkResult = checkRankingResponse(id);
							break;
						case 9 : 
							checkResult = checkDrdwResponse(id);
							break;
						case 10:
						case 11:
							checkResult = checkScheduleResponse(id);
							break;
					}
				}
				
				if (type != 9 && (checkResult == 0 || checkResult == "")) {
					alert(id + SurveyMessages.strIncomplete);
					result = "fail";
					break;
				}
				
				/*드롭다운 첫번째 허용 */
				if(type == 9 && checkResult == ""){
					alert(id + SurveyMessages.strIncomplete);
					result = "fail";
					break;
				}
				
				if (checkResult == 'break') {
					result = "fail";
					break;
				}
			}
			
			return result;
			
		}
		// 선택 질문 답변 유무 체크
		function checkSltResponse(id) {
			var cnt = $("input[name^=qstn" + id+ "]:checked").length;
			var wrapper = $("#prevQstn" + id);
			var checkedBtn = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]:checked");
			var checkedCnt = checkedBtn.length;
			var flag = checkedBtn.attr('otherFlag');
			var stop = "break";
			
			if (flag == 1) {
				var otherInput = $("#othInput" + id).val().trim();
				if (otherInput == "") {
					alert(id + SurveyMessages.writeOthers);
					return stop;
				}
			}
			return checkedCnt;
		}
		
		// 행렬 질문 답변 유무 체크
		function checkMtrResponse(id, type) {
			var checkedCnt = $("input[name^=qstn" + id + "opt]:checked").length;
			return checkedCnt;
		}
		
		// 단답, 문장형 질문 답변 유무 체크
		function checkTxtResponse(id, type) {
			var wrapper = $("#prevQstn" + id);
			var txtAnswer = "";
			
			if (type == 5) {
				txtAnswer = wrapper.find(".shortanswer").val().trim();
				
			} else if (type == 6) {
				txtAnswer = wrapper.find(".paragraph").val().trim();
			}
			return txtAnswer;
		}
		
		// 슬라이더 질문 답변 유무 체크
		function checkSliderResponse(id) {
			// IE 버그로 수정
			// var sliderValue = $("#slider" + id).val();
			var sliderValue = $("#slider" + id)[0].textContent;
			return sliderValue;
		}
		
		// 순위 질문 답변 유무 체크
		function checkRankingResponse(id) {
			var length = $("#prevQstn" + id).find(".rank-order").length;
			var result = "";
			
			for (var i = 0; i < length; i++) {
				var optLevel = $("select[name^=ranking" + id + i + "]").val();
				
				if (optLevel == "") {
					return result;
				}
			}
		}
		// 드롭다운 질문 답변 유무 체크
		function checkDrdwResponse(id) {
			var selectedValue = $("select[name = drdw" + id + "]").val();
			return selectedValue;
		}
		
		//일정 유형 질문 답변 유무 체크
		function checkScheduleResponse(id) {
			var checkedCnt = $("input[name^=qstn" + id + "opt]:checked").length;
			return checkedCnt;
		}
		
		/* 2021-05-27 전자설문 이미지 확대 개선 */
		$(document).on("mouseenter mouseleave", ".qstnImg", function(event) {
            event.target.style.backgroundUrl = event.target.src;
            event.target.style.backgroundRepeat = "no-repeat";
            
            // 이미지 파일이 아닌, 다른 첨부로 인한 이미지가 있는 경우 확대 안 시키기 위해!
            if (event.target.src.indexOf("/images/ezSurvey/pdf.png") != -1) {
                return;
            }
            
            if (event.type == "mouseenter") {
                console.log("imgEnter");
                event.target.style.transform = "translate(150px, 0) scale(4)";
                event.target.style.opacity = 1;
                event.target.style.zIndex = 1;
                event.target.style.transition = "all 0.5s";
            }
            else {
                console.log("imgLeave");
                event.target.style.transform = "none";
                event.target.style.zIndex = 0;
                event.target.style.transition = "all 0.5s";
            }
        })
        
        $(document).on("mouseenter mouseleave", ".optImg", function(event) {
            event.target.style.backgroundUrl = event.target.src;
            event.target.style.backgroundRepeat = "no-repeat";
            
            if (event.target.src.indexOf("/images/ezSurvey/pdf.png") != -1) {
                return;
            }
            
            if (event.type == "mouseenter") {
                console.log("imgEnter");
                event.target.style.transform = "translate(50px, -50px) scale(5)";
                event.target.style.opacity = 1;
                event.target.style.zIndex = 1;
                event.target.style.transition = "all 0.5s";
            }
            else {
                console.log("imgLeave");
                event.target.style.transform = "none";
                event.target.style.zIndex = 0;
                event.target.style.transition = "all 0.5s";
            }
        })

		/* 수정 이벤트 수신을 위한 WebSocket subscribe 설정 */
		function getCmtSockConnect() {
			var tenantID = "${tenantId}";
			var socket = new SockJS('/hello');
			stompClient = Stomp.over(socket);
			stompClient.connect({}, function (frame) {
				stompClient.subscribe('/reply/getSeenUpdateForSurvey' + surveyId + "+" + tenantID, function (updatedInfo) {
					var status = JSON.parse(updatedInfo.body).status;
					var updatedSurveyId = JSON.parse(updatedInfo.body).surveyId;

					if (status == "MODIFY" && updatedSurveyId == surveyId) {
						alert(SurveyMessages.strEditingErr02);
						refreshOpenerAndClose("N");
						window.location.reload();
					} else if (status = "END" && updatedSurveyId == surveyId && actionUserYN != "Y") {
						alert(SurveyMessages.strEndSurv03);
						refreshOpenerAndClose("Y");
					}
				});
			});
		}
		function stompDisConnProcess() {
			setInterval(function(){
				if(stompClient.connected === false){
					window.location.reload();
				}
			}, 10000);
		}

		var actionUserYN = "N";
		function endSurvey() {
			actionUserYN = "Y";
			
			if (confirm(SurveyMessages.strEndSurv01)) {
				$.ajax({
					type: "POST",
					url: "/ezSurvey/endSurveyItem.do",
					data: {surveyID : surveyId},
					dataType: "text",
					async: false,
					success : function() {
						afterActionComplete(SurveyMessages.strEndSurv02);
					},
					error : function() {
						alert(SurveyMessages.strError);
					}
				});
			}
		}
		
		if (resStatus && 'Y' == '${finishYN}') {
			$('#prevQsAreaDIV input, #prevQsAreaDIV textarea, #prevQsAreaDIV select').prop('disabled', true).css('cursor', 'default');
		}

		/* 2025-07-01 양지혜 - 진행중설문 > 일시정지/일시정지해제 */
		function pauseSurvey(type) {
			var confirmTxt = type === "P" ? SurveyMessages.strPauseMsg01 : SurveyMessages.strResumeMsg01;
			if (confirm(confirmTxt)) {
				$.ajax({
					type: "POST",
					url: "/ezSurvey/pauseSurvey.do",
					data: {surveyID : surveyId, type : type},
					dataType: "text",
					async: false,
					success : function() {
						alert(type === "P" ? SurveyMessages.strPauseMsg02 : SurveyMessages.strResumeMsg02);
						window.opener.location.reload();
						window.close();
					},
					error : function() {
						alert(SurveyMessages.strError);
					}
				});
			}
		}
	});
	
	/* 2021-10-27 홍승비 - 전자설문 분기처리 전체적으로 수정 */
	function toggleQuestionList_New(startID) { // startID는 현재 선택한 질문을 의미함 (prevQstn을 공백으로 치환한 숫자값만을 전달)
		var allQuestionWrapper = $(".prevQsWrapper"); // 질문 하나마다 래퍼 클래스 덩어리째로 가져온다. type값을 가지고 있으며, 하위에 질문 세부항목이 존재하여 find로 접근이 가능하다.
		
		// 분기처리 이전, 해당 질문 다음 순서인 모든 질문을 임시로 활성화시킨다. (설문종료 이후 다시 다른 분기를 선택하는 경우 대응)
		// enableAllQuestion() 동작 후, 아래의 allQuestionWrapper.each 루프를 돌면서 질문의 비활성/활성이 다시 설정된다.
		enableAllQuestion("prevQstn" + startID);
		
		// 실제 접근이 가능한 질문들. each 루프를 돌며 startID와 같거나 큰 값일때만 동작한다. (분기설정은 자신 이후의 질문만 대상자로 선택 가능하므로)
		allQuestionWrapper.each (function(index, element) {
			var id = $(this).attr("id"); // prevQstn1과 같은 질문 래퍼 클래스의 아이디
			var qstIdx = id.replace("prevQstn", ""); // 각 질문의 고유 순번 저장
			
			if (qstIdx >= parseInt(startID)) { // 자신과 같거나 그 이후의 질문인 경우, 아래 코드를 실행
				var type = $(this).attr("type"); // 설문 유형
				var skip = $(this).attr("skip"); // 단일분기가 설정된 설문의 경우, 대상 분기 설문 순서값 (id에서 prevQstn 없앤 값이랑 동일)
				
				// 단일분기가 존재하는 경우
				if (skip != "-1") {
					// 현재 질문에 유효한 답변이 존재하지 않는다면, 목표 분기 질문을 비활성화시킨다.
					// 체크박스, 라디오 : 체크된 값이 존재하는지 여부
					// 단일, 문장 : 입력한 값이 존재하는지 여부 (공백이 아닌 경우)
					// 슬라이드 : 무조건 초기 값이 존재하므로, 항상 목표 분기를 활성화함
					// 순위 : 모든 순위를 선택했는지 여부
					// 셀렉트 옵션 : 선택한 값이 있는지 여부
					if (isResponseExist(id, type) == false) {
						if (skip != "0") {
							disableQuestion("prevQstn" + skip); // 목표 단일분기질문 비활성화
						}
					} else {
						if (skip == "0") { // 설문종료
							disableAllQuestion(id);
						} else { // 목표 단일분기질문 활성화
							enableQuestion("prevQstn" + skip);
						}
					}
				}
				// 하위 항목에 세부 분기가 존재하는 경우, 또는 특정 값 이상인 경우 이동하는 슬라이드 질문의 경우 분기처리
				// logic이 0인 경우 설문종료이므로, 자신 이후의 모든 질문을 disabled 처리
				// logic이 -1이면 분기없음이므로 이후 처리 없음
				else { // skip == -1
					if (type == "1" || type == "2" || type == "10" || type == "11") { // 단일선택 , 다중선택, 일정 단일 선택, 일정 다중 선택
						// 현재 루프 중인 질문 자기 자신에 대해, 모든 답변이 가질 수 있는 분기를 체크
						var qstOptions = $(this).find("[name = 'qstn" + qstIdx + "opt'][logic != '-1']"); // 분기가 설정된 세부 항목이 존재 (예 : qstn1opt)
						if (qstOptions.length > 0) {
							qstOptions.each (function(index, element) {
								if ($(this).attr("logic") != "0") { // 해당 목표 분기 비활성화 또는 활성화
									if ($(this).prop("checked") == false) {
										disableQuestion("prevQstn" + $(this).attr("logic"));
									} else {
										enableQuestion("prevQstn" + $(this).attr("logic"));
									}
								} else { // 설문종료
									if ($(this).prop("checked") == true) {
										disableAllQuestion(id);
									}
								}
							});
						}
					} else if (type == "7") { // 슬라이드
						var sliderRange = $(this).find(".slider-range"); // 슬라이더 값
						var sliderOut = $(this).find(".slider-output[logic != '-1']"); // 분기 등 설정값
						if (sliderOut.length > 0) {
							if (sliderOut.attr("logic") != "0") { // 해당 목표 분기 비활성화 또는 활성화
								if (parseInt(sliderRange.val()) < parseInt(sliderOut.attr("logicpoint"))) { // 특정 값 이상인 경우 목표 분기 활성화
									disableQuestion("prevQstn" + sliderOut.attr("logic"));
								} else { // 특정 값 미만인 경우 목표 분기 비활성화
									enableQuestion("prevQstn" + sliderOut.attr("logic"));
								}
							} else { // 특정 값 이상인 경우 설문종료
								if (parseInt(sliderRange.val()) >= parseInt(sliderOut.attr("logicpoint"))) {
									disableAllQuestion(id);
								}
							}
						}
					} else if (type == "9") { // 드롭다운
						var qstOptions = $(this).find("option[logic != '-1']"); // 분기가 설정된 세부 옵션 항목이 존재  (가장 첫번째 옵션의 경우, 디폴트 옵션이므로 logic undefined 체크 진행)
						if (qstOptions.length > 0) {
							qstOptions.each (function(index, element) {
								if (typeof($(this).attr("logic")) != "undefined") {
									if ($(this).attr("logic") != "0") { // 해당 목표 분기 비활성화 또는 활성화
										if ($(this).prop("selected") == false) {
											disableQuestion("prevQstn" + $(this).attr("logic"));
										} else {
											enableQuestion("prevQstn" + $(this).attr("logic"));
										}
									} else { // 설문종료
										if ($(this).prop("selected") == true) {
											disableAllQuestion(id);
										}
									}
								}
							});
						}
					}
				}
				// 분기 설정이 아예 없는 경우, 아무 동작 없음 + 현재 선택한 질문 이전의 질문에 대해서는 처리하지 않는다.
			}
		});
	}
	
	/* 2021-10-27 홍승비 - 단일분기 질문에 대하여 현재 질문에 유효한 응답이 존재하는지 체크하는 함수 (true/false) */
	function isResponseExist(qstWrapperID, type) {
		var result = false;
		var qstWrapper = $("#" + qstWrapperID);
		
		if (type == "1" || type == "2" || type == "3" || type == "4" || type == "10" || type == "11") { // 단일선택, 다중선택, 행렬(단일/다중)
			if (qstWrapper.find("input:checked").length > 0) {
				result = true;
			}
		} else if (type == "5") { // 단답형
			if (qstWrapper.find("input").val() != "") {
				result = true;
			}
		} else if (type == "6") { // 문장형
			if (qstWrapper.find("textarea").val() != "") {
				result = true;
			}
		} else if (type == "7") { // 슬라이드 (무조건 기본 값이 존재하므로, 항상 true를 반환)
			result = true;
		} else if (type == "8") { // 순위 (모든 순위가 선택된 경우에만 유효하다고 판단)
			var isNotSelected = false;
			qstWrapper.find("select").each (function(index, element) {
				if ($(this).prop("selectedIndex") == 0) {
					isNotSelected = true; // 순위 중 하나라도 선택되지 않은 경우(첫번째 placeholder 역할인 옵션이 선택된 경우) 유효하지 않음
				}
			});
			if (isNotSelected == false) {
				result = true;
			}
		} else if (type == "9") { // 드롭다운
			if (qstWrapper.find("select").prop("selectedIndex") > 0) {
				result = true;
			}
		}
		
		return result;
	}
	
	/* 2021-10-27 홍승비 - 질문 비활성화 함수 분리 (래퍼 ID를 전달하여 해당 질문을 disable 처리, 선택한 응답 해제) */
	function disableQuestion(qstWrapperID) {
		var allQuestionWrapper = $(".prevQsWrapper");
		var qstLevel = parseInt(qstWrapperID.replace("prevQstn", ""));
		var qstWrapper = $("#" + qstWrapperID);
		
		// 설문 비활성화가 가능한 상태인지 다시 한번 체크 (자신의 상위 분기 질문에 대한 응답이 유효하지 않은 상태여야 함)
		// 상위 분기 부모 중 하나라도 유효한 응답을 가지고 있다면 비활성화 불가능
		// 예) 1번 질문에 5번 질문 단일분기 설정 + 3번 질문에 5번 질문 단일분기 설정
		//	=> 1번이나 3번 질문 중 유효한 응답이 하나라도 존재한다면 5번은 비활성화 불가능
		var parentResponseExist = false;
		var parentWrapper1 = $(".prevQsWrapper[skip = '" + qstLevel + "']") // 상위 단일분기
		var parentWrapper2 = allQuestionWrapper.find("[logic = '" + qstLevel + "']").parents(".prevQsWrapper"); // 상위 항목별 세부분기
		
		if (parentWrapper1.length > 0) {
			parentWrapper1.each (function(index, element) {
				var id = $(this).attr("id");
				var type = $(this).attr("type");
				if (isResponseExist(id, type) == true) { // 단일분기에 대해 유효한 응답이 존재하는지 체크
					parentResponseExist = true;
				}
			});
		}
		if (parentWrapper2.length > 0) {
			parentWrapper2.each (function(index, element) {
				var id = $(this).attr("id");
				var type = $(this).attr("type");
				
				// 항목 별 세부분기 > 질문의 유형 별로 응답이 유효한지 체크
				if (type == "1" || type == "10") { // 단일선택
					if ($(this).find(".optRdo[logic='" + qstLevel + "']:checked").length > 0) {
						parentResponseExist = true;
					}
                } else if (type == "2" || type == "11") { // 다중선택
					if ($(this).find(".optChb[logic='" + qstLevel + "']:checked").length > 0) {
						parentResponseExist = true;
					}  
				} else if (type == "7") { // 슬라이드
					var sliderVal = $(this).find("slider-range").val();
					var sliderLogicPoint = $(this).find("slider-output").attr("logicpoint");
					if (sliderVal >= sliderLogicPoint) {
						parentResponseExist = true;
					}
				} else if (type == "9") { // 드롭박스
					var logicNum = $(this).find("select option:selected").attr("logic");
					// 선택된 셀렉트 옵션 값의 목표 분기가 비활성화할 질문의 순서와 일치한다면 비활성화 불가능 
					if (typeof(logicNum) != "undefined" && qstLevel == logicNum) {
						parentResponseExist = true;
					}
				}
			});
		}
		// 자신을 하위 분기로 지정한 상위 분기 질문이 하나라도 존재 + 해당 상위 분기가 유효한 응답을 가지고 있다면 비활성화 중단
		if ((parentWrapper1.length > 0 || parentWrapper2.length > 0) && parentResponseExist == true) {
			return;
		}
		
		if (qstWrapper.length > 0) {
			var type = qstWrapper.attr("type");
			var checkMask = $("#mask" + qstLevel).length;
			
			if (checkMask == 0) { // 비활성화 영역이 없는 경우에만 새로 만들어서 붙여준다.
				var mask = $("<div class='mask' id='mask" + qstLevel + "'></div>");
				var wrapper = $("#prevQstn" + qstLevel);
				var height = wrapper.height();
				var width = wrapper.width();
				wrapper.prepend(mask);
				
				$("#mask" + qstLevel).css({"height": height, "width": width, "background-color": "gray", "opacity": "0.3", "position" : "absolute"});
				
				// 비활성화한 해당 질문에 응답이 존재하면 없애기 (슬라이드의 경우 값 초기화)
				if (type == "1" || type == "2" || type == "3" || type == "4" || type == "10" || type == "11") { // 단일선택, 다중선택, 행렬(단일/다중), 일정(단일/다중)
					qstWrapper.find("input").prop("checked", false); // 체크박스 맟 라디오 체크된 값 일괄해제
				} else if (type == "5") { // 단답형
					qstWrapper.find("input").val("");
				} else if (type == "6") { // 문장형
					qstWrapper.find("textarea").val("");
				} else if (type == "7") { // 슬라이드
					var minVal = qstWrapper.find(".slider-range").attr("min");
					qstWrapper.find(".slider-range").val(minVal);
					qstWrapper.find(".slider-output").text("");
				} else if (type == "8" || type == "9") { // 순위, 드롭다운
					qstWrapper.find("select").prop("selectedIndex", 0);
				}
			}
		}
	}
	
	/* 2021-10-27 홍승비 - 질문 활성화 함수 분리 (래퍼 ID를 전달하여 해당 질문을 enable 처리) */
	function enableQuestion(qstWrapperID) {
		var qstLevel = parseInt(qstWrapperID.replace("prevQstn", ""));
		var maskDiv = $("#prevQstn" + qstLevel).find("#mask" + qstLevel);
		
		if (maskDiv.length > 0) {
			maskDiv.remove();
		}
	}
	
	/* 2021-10-27 홍승비 - 자신 이후의 모든 설문 비활성화 처리 (설문종료) */
	function disableAllQuestion(qstWrapperID) {
		var allQuestionWrapper = $(".prevQsWrapper");
		var qstLevel = parseInt(qstWrapperID.replace("prevQstn", ""));
		
		for (var  i = qstLevel + 1; i <= allQuestionWrapper.length; i++) {
			var qstWrapper = $("#prevQstn" + i);
			
			if (qstWrapper.length > 0) {
				var type = qstWrapper.attr("type");
				var checkMask = $("#mask" + i).length;
				
				if (checkMask == 0) { // 비활성화 영역이 없는 경우에만 새로 만들어서 붙여준다.
					var mask = $("<div class='mask' id='mask" + i + "'></div>");
					var wrapper = $("#prevQstn" + i);
					var height = wrapper.height();
					var width = wrapper.width();
					wrapper.prepend(mask);
					
					$("#mask" + i).css({"height": height, "width": width, "background-color": "gray", "opacity": "0.3", "position" : "absolute"});
					
					// 비활성화한 해당 질문에 응답이 존재하면 없애기 (슬라이드의 경우 값 초기화)
					if (type == "1" || type == "2" || type == "3" || type == "4" || type == "10" || type == "11") { // 단일선택, 다중선택, 행렬(단일/다중), 일정(단일/다중) 
						qstWrapper.find("input").prop("checked", false); // 체크박스 맟 라디오 체크된 값 일괄해제
					} else if (type == "5") { // 단답형
						qstWrapper.find("input").val("");
					} else if (type == "6") { // 문장형
						qstWrapper.find("textarea").val("");
					} else if (type == "7") { // 슬라이드
						var minVal = qstWrapper.find(".slider-range").attr("min");
						qstWrapper.find(".slider-range").val(minVal);
					} else if (type == "8" || type == "9") { // 순위, 드롭다운
						qstWrapper.find("select").prop('selectedIndex', 0);
					}
				}
			}
		}
	}
	
	/* 2021-10-28 홍승비 - 자신 이후의 모든 설문 활성화 처리 (*설문종료 이후 다시 다른 선택지 선택하는 경우* 대응을 위한 함수) */
	function enableAllQuestion(qstWrapperID) {
		var allQuestionWrapper = $(".prevQsWrapper");
		var qstLevel = parseInt(qstWrapperID.replace("prevQstn", ""));
		var qstWrapper = $("#" + qstWrapperID);
		var type = qstWrapper.attr("type");
		var canEnableAll = false; // 모든 설문 활성화 가능한지 1차 체크
		
		if (type == "1" || type == "3" || type == "10") { // 단일선택, 행렬(단일), 일정 단일
			// 설문종료 이외에 체크된 값이 있는가?
			if (qstWrapper.find("input:checked").length > 0) {
				canEnableAll = true;
			}
		} else if (type == "2" || type == "11") { // 다중선택, 일정 (다중)
			// 설문종료 값이 체크되어 있는가?
			if (qstWrapper.find("input[logic='0']:checked").length == 0) {
				canEnableAll = true;
			}
		} else if (type == "4") { //  행렬(다중)
			// 모든 선택지가 선택 해제되어있는가?
			if (qstWrapper.find("input:checked").length == 0) {
				canEnableAll = true;
			}
		} else if (type == "5") { // 단답형
			 // 응답이 공백인가?
			if (qstWrapper.find("input").val() == "") {
				canEnableAll = true;
			}
		} else if (type == "6") { // 문장형
			// 응답이 공백인가?
			if (qstWrapper.find("textarea").val() == "") {
				canEnableAll = true;
			}
		} else if (type == "7") { // 슬라이드
			var minVal = qstWrapper.find(".slider-range").attr("min"); // 특정 값 미만인가?
			var logicPoint = qstWrapper.find(".slider-output").attr("logicpoint");
			if (isFirstEvent == false && qstWrapper.find(".slider-range").val() < logicPoint) { // 초기 표출 시에는 해당 동작 없음
				canEnableAll = true;
			}
		} else if (type == "8" || type == "9") { // 순위, 드롭다운
			// 설문종료 이외에 체크된 값이 있는가? (0번 인덱스 제외)
			if (qstWrapper.find("select").prop("selectedIndex") != 0) {
				canEnableAll = true;
			}
		}
		
		// 모든 설문 활성화 가능한지 1차 체크 확인
		if (canEnableAll == true) {
			for (var  i = qstLevel + 1; i <= allQuestionWrapper.length; i++) {
				var qstWrapper = $("#prevQstn" + i);
				var maskDiv = qstWrapper.find("#mask" + i);
				
				// 자신을 하위 분기로 지정한 상위 분기 질문이 없는 경우, 계속 활성화 진행
				// 자신을 하위 분기로 지정한 상위 분기 질문이 존재 + 상위 분기가 유효한 응답을 가지고 있지 않다면 활성화 중단
				// 상위 분기 부모가 여럿일 수 있으며, 그 중 하나라도 유효한 응답을 가지고 있다면 활성화 진행
				var parentResponseExist = false;
				var parentWrapper1 = $(".prevQsWrapper[skip = '" + i + "']") // 상위 단일분기
				var parentWrapper2 = allQuestionWrapper.find("[logic = '" + i + "']").parents(".prevQsWrapper"); // 상위 항목별 세부분기
				
				if (parentWrapper1.length > 0) {
					parentWrapper1.each (function(index, element) {
						var id = $(this).attr("id");
						var type = $(this).attr("type");
						if (isResponseExist(id, type) == true) {
							parentResponseExist = true;
						}
					});
				}
				if (parentWrapper2.length > 0) {
					parentWrapper2.each (function(index, element) {
						var id = $(this).attr("id");
						var type = $(this).attr("type");
						
						// 질문의 유형 별로 응답이 유효한지 체크 (항목 별 세부분기)
						if (type == "1" || type == "10") { // 단일선택, 일정 단일 선택
							if ($(this).find(".optRdo[logic='" + i + "']:checked").length > 0) {
								parentResponseExist = true;
							}
						} else if (type == "2" || type == "11") { // 다중선택
							if ($(this).find(".optChb[logic='" + i + "']:checked").length > 0) {
								parentResponseExist = true;
							}
						} else if (type == "7") { // 슬라이드
							var sliderVal = $(this).find("slider-range").val();
							var sliderLogicPoint = $(this).find("slider-output").attr("logicpoint");
							if (sliderVal >= sliderLogicPoint) {
								parentResponseExist = true;
							}
						} else if (type == "9") { // 드롭박스
							var logicNum = $(this).find("select option:selected").attr("logic");
							if (typeof(logicNum) != "undefined" && qstLevel == logicNum) {
								parentResponseExist = true;
							}
						}
					});
				}
				// 자신을 하위 분기로 지정한 상위 분기 질문이 없거나, 상위 분기가 유효한 응답을 가지고 있다면 활성화 진행
				if ((parentWrapper1.length == 0 && parentWrapper2.length == 0) || parentResponseExist == true) {
					if (maskDiv.length > 0) {
						maskDiv.remove();
					}
				}
			}
		}
	}

	function escapeHtml(text) {
		var map = {
			'&': '&amp;',
			'<': '&lt;',
			'>': '&gt;',
			'"': '&quot;',
			"'": '&#039;'
		};

		return text.replace(/[&<>"']/g, function(m) { return map[m]; });
	}
</script>
</html>