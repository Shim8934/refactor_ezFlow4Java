<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
	<title><spring:message code="ezSurvey.t34"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
	
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js'   )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js'        )}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.ddslick.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg'              )}"></script>
</head>
	
<body class="surveyBody">
	<div class="header-wrapper">
		<div class="surveydetail-header">
			<ul class="on">	
				<li class="off"><span id="saveResult"><spring:message code="ezSurvey.t17"/></span></li>
				<c:if test="${empty mode and user == creator.id}">
					<li class="off"><span id="suvyDlt"><spring:message code="ezSurvey.t21"/></span></li>
				</c:if>
			</ul>
		</div>
		<c:if test="${empty mode}">
			<div id="close"><ul><li><span id="cancelBttn"></span></li></ul></div>
		</c:if>
	</div>
	
	<ul id="upage-ul"class="upage-ul" style="display: none;">
		<li>
			<c:choose>
				<c:when test="${survey.resultPublicFlag eq 1}">
					<span id="isPublic">공개</span>
				</c:when>
				<c:otherwise>
					<span id="isPublic">비공개</span>
				</c:otherwise>
			</c:choose>
		</li>
		<li>
			<img src="/images/poll/seeResultBeforeVote_On.png" class="voteIconImg_info" title="투표 종료 전 결과보기">
			<span id="openDays">완료 후 개시 일수 : ${survey.openDays}</span>
		</li>
		<li>
			<img src="/images/poll/anonymousVote_Off.png" class="voteIconImg_info" title="기명 투표">
			<c:choose>
				<c:when test="${survey.anonymousFlag eq 0}">
					<span id="isAnonymous">기명</span>
				</c:when>
				<c:otherwise>
					<span id="isAnonymous">무기명</span>
				</c:otherwise>
			</c:choose>
		</li>
		<li>
			<img src="/images/poll/selOnlyOnce_Off.png" class="voteIconImg_info" title="낙장불입 미적용">
			<c:choose>
				<c:when test="${survey.multiAnswerFlag eq 0}">
					<span id="isAgain">중복 응답 불가</span>
				</c:when>
				<c:otherwise>
					<span id="isAgain">중복 응답 가능</span>
				</c:otherwise>
			</c:choose>
		</li>
	</ul>
	
	<div class="surveydetail-body" id="mainSurveyBody">
		<div id="svTitle" class="survey-title">${survey.title}</div>
		
		<div id="svPurpose" class="svPurpose">
			<div id="ppContent" class="ppContent">${survey.purpose}</div>
			<div class="survey-otherinf">
				<table class="content surveyDtl">
					<tr>
						<th class="left-Th"><spring:message code="ezSurvey.t24"/></th> <%-- creator name setting --%>
						<td class="right-Td">
							<div class="surveyinf-divcf"><c:out value="${survey.creatorName}"/></div>
						</td>
						<th class="left-Th"><spring:message code="ezSurvey.t94"/></th> <%-- create date setting --%>
						<td class="right-Td">
							<div class="surveyinf-divcf"><c:out value="${fn:substring(survey.createDate, 0, 19)}"/></div>
						</td>
					</tr>
					<tr>
						<th class="left-Th"><spring:message code="ezSurvey.t38"/></th> <%-- start date && end date setting --%>
						<td class="right-Td">
							<div class="surveyinf-divcf">
								<span id="cf-startDate"><c:out value="${fn:substring(survey.startDate, 0, 10)}"/></span>
								<img class="ui-datepicker-trigger" src="/images/ezSurvey/calendar-month.png">
								&nbsp;~&nbsp;
								<span id="cf-endDate"><c:out value="${fn:substring(survey.endDate, 0, 10)}"/></span>
								<img class="ui-datepicker-trigger" src="/images/ezSurvey/calendar-month.png">
							</div>
						</td>
						<th class="left-Th"><spring:message code="ezSurvey.t46"/></th> <%-- anonymous setting --%>
						<td class="right-Td">
							<div id="cf-anoynymous" class="surveyinf-divcf"><spring:message code="${survey.anonymousFlag == 1 ? 'ezSurvey.t48' : 'ezSurvey.t47'}"/></div>
						</td>
					</tr>
					<tr>
						<th class="left-Th"><spring:message code="ezSurvey.t52"/></th> <%-- respondent setting --%>
						<td class="right-Td">
							<div id="cf-userdiv" class="surveyinf-divcf flex-cf"><spring:message code="${survey.paritipateFlag == 1 ? 'ezSurvey.t54' : 'ezSurvey.t53'}"/></div>
						</td>
						<th class="left-Th"><spring:message code="ezSurvey.t49"/></th> <%-- multiple select setting --%>
						<td class="right-Td">
							<div id="cf-multiple" class="surveyinf-divcf"><spring:message code="${survey.multiAnswerFlag == 1 ? 'ezSurvey.t51' : 'ezSurvey.t50'}"/></div>
						</td>
					</tr>
					<tr>
						<th class="left-Th"><spring:message code="ezSurvey.t41"/></th> <%-- public setting --%>
						<td class="right-Td">
							<div id="public-cfdiv" class="surveyinf-divcf"><spring:message code="${survey.resultPublicFlag == 1 ? 'ezSurvey.t42' : 'ezSurvey.t43'}"/></div>
						</td>
						<th class="left-Th"><spring:message code="ezSurvey.t44"/></th> <%-- open public result days setting --%>
						<td class="right-Td">
							<c:if test="${survey.resultPublicFlag == 1}">
								<div id="public-days" class="surveyinf-divcf"><c:out value="${survey.openDays}"/>&nbsp;<spring:message code="ezSurvey.t45"/></div>
							</c:if>
						</td>
					</tr>
				</table>
			</div>
			<div class="attach-zone2 off" id="surveyAtt">
				<div class="mainzone2">
					<div class="fileList">
						<ul class="user-pageul" id="attachUl"></ul>
					</div>
				</div>
			</div>
		</div>
		
		<div class="prevQsArea"></div>
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
	</div>
</body>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezSurvey/survey.js')}    "></script>
<script type="text/javascript">
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
		
		userEvent();
		
		function getQuestions() {
			$.ajax({
				type: "GET",
				url: "/ezSurvey/getSurveyQuestions.do",
				data: {surveyId : surveyId, logic : "logic"},
				contentType: "application/json; charset=utf-8",
				dataType: "JSON",
				async: true,
				cache: false,
				success : function(data) {
					var question  = JSON.parse(JSON.stringify(data["questions"]));
					if (data["logicmap"]) {logicmap = JSON.parse(JSON.stringify(data["logicmap" ]));}
					
					for (var i = 0; i < question.length; i++) {
						SurveyCreate.setQs(question[i]);
					}
					
					SurveyCreate.setQsForm(0);
					
					if (data["firstpath"]) {
						toggleQuestionList(JSON.parse(JSON.stringify(data["firstpath"])));
					}
				},
				error : function(error) {
					alert(SurveyMessages.strError);
				}
			});
		}
		
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
		
		function toggleQuestionList(checkList) {
			var listQstDiv = document.getElementsByClassName("prevQsWrapper");
			for (var i = 0, len = listQstDiv.length; i < len; i++) {
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
		
		function setBodyHeight() {
			var wdHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			document.getElementById("mainSurveyBody").style.height = (wdHeight - 74) + "px";
		}
		
		function userEvent() {
			getQuestions();
			showAttachList();
			setBodyHeight();
			window.addEventListener("load", function(e) {setBodyHeight();}, false);
			window.addEventListener("resize", function(e) {setBodyHeight();}, false);
			
			// 라디오 버튼 클릭 이벤트
			$(".prevQsArea").on("click", ".optRdo", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				var logicNum = parseInt($(this).attr("logic"));
				
				if (logicNum && logicNum != -1 && logicmap) {processLogicNode(prId, logicNum);}
			});
			
			$(".prevQsArea").on("change", ".dropdown-wrap", function() {
				var prId     = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				var logicNum = parseInt($("select[name=drdw" + prId + "] option:selected").attr("logic"));
				if (logicNum && logicNum != -1 && logicmap) {processLogicNode(prId, logicNum);}
			});
			
			// 슬라이드 질문 트리거
			$(".prevQsArea").on("input", ".slider-range", function() {
				var outputElmt         = this.parentElement.parentElement.querySelector("output[class='slider-output']");
				outputElmt.textContent = this.value;
			}).trigger("change");
			
			// 슬라이드 질문 답변 표시
			$(".prevQsArea").on("change", ".slider-range", function() {
				var prId       = parseInt($(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", ""));
				var logicNum   = parseInt($("#slider" + prId).attr("logic"));
				var logicPoint = parseInt($("#slider" + prId).attr("logicPoint"));
				var currentVal = parseInt(this.value);
				
				if (logicNum && logicNum != -1 && logicmap) {
					if (currentVal > logicPoint) {
						processLogicNode(prId, logicNum);
					}
					else {
						processLogicNode(prId, prId + 1);
					}
				}
			});
			
			// ranking 셀렉트 박스 옵션 선택시 값 비교
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
			});
			
			var delBttn = document.getElementById("suvyDlt");
			if (delBttn) {delBttn.onclick = function(e) {deleteFileConfirm();};}
			
			var cancelBttn = document.getElementById("cancelBttn");
			var saveResult = document.getElementById("saveResult");
			if (cancelBttn) {cancelBttn.onclick = function(e) {window.close();};}
			if (saveResult) {saveResult.onclick = function(e) {saveSurveyResponses();};}
		}
		
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
		
		function saveSurveyResponses() {
			var periodResult   = checkDate(); // 설문 기간 체크
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
						var id = parseInt(qstnId.replace("prevQstn", ""));
						var type = parseInt(wrapper.getAttribute("type"));
						
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
						}
						
					}
					if (responseResult == 'fail') {
						break;
					}
				}
			}
			
			if (periodResult != "fail" && requiredResult != "fail" && responseResult != "fail") {
				saveResponse();
			}
		}
		
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
		
		function afterSaveSuccessfully(data) {
			var code = data.code;
			switch(code) {
				case 0 : alert(SurveyMessages.strSave)     ;
						 resposeObj.responses = [];
						 if (window.opener.SurveyItem) {window.opener.SurveyItem.reload(); window.close();}
						 break;
				case 1 : alert(SurveyMessages.strParamErr) ; break;
				case 2 : alert(SurveyMessages.strError)    ; break;
				case 5 : alert(SurveyMessages.strMultiple3); break;
				default: alert(SurveyMessages.strError)    ; return;
			}
		}
		
		function getSingleSltRespose(id, type) {
			var answerObj  = {};
			var optionId   = {};
			var answer     = [];
			var result     = "success";
			var wrapper    = $("#prevQstn" + id);
			var checkedBtn = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]:checked");
			var optId      = parseInt(checkedBtn.attr("optionid"));
			
			if (!isNaN(optId)) {
				if (checkedBtn.attr("otherFlag") == 1) {
					var otherValue = $("#othInput" + id).val().trim();
					
					if (otherValue != "") {
						optionId['otherFlag'] = 1;
						optionId['texts'] = otherValue;
					}
					else {
						result = "fail";
						alert(id + SurveyMessages.writeOthers);
					}
				}
				optionId['optionId'] = optId;
				answer.push(optionId);
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			
			return result;
		}
		
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
					var optionId = {};
					
					if (!isNaN(optId)) {
						if (checkBox[i].getAttribute('otherFlag') == 1) {
							var otherValue = $("#othInput" + id).val().trim();
							
							if (otherValue != "") {
								optionId['otherFlag'] = 1;
								optionId['texts']     = otherValue;
							}
							else {
								result = "fail";
								alert(id + SurveyMessages.writeOthers);
							}
						}
						optionId['optionId'] = optId;
						answer.push(optionId);
					}
				}
			}
			
			if (answer.length > 0) {
				answerObj['answers']       = answer;
				answerObj['type']          = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			
			return result;
		}
		
		function getSingleMtrRespose(id, type) {
			var answerObj = {};
			var answer    = [];
			var wrapper   = $("#prevQstn" + id);
			var trLength  = wrapper.find("tbody").find("tr").length;
			
			for (var i = 0; i < trLength; i++) {
				var rowColObj = {};
				var rowColIds = $("input[name = qstn" + id + "opt" + i + "]:checked").attr("optionid");
				
				if (rowColIds != undefined) {
					var rowColArray = rowColIds.split(",");
					var row = rowColArray[0];
					var col = rowColArray[1];
					
					rowColObj['rowId'] = parseInt(row);
					rowColObj['colId'] = parseInt(col);
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
		
		function getMultiMtrRespose(id, type) {
			var answerObj = {};
			var answer    = [];
			var wrapper   = $("#prevQstn" + id);
			var rowLength = wrapper.find("tbody").find("tr").length;
			var colLength = wrapper.find("thead").find("td").length;
			
			for (var i = 0; i < rowLength; i++) {
				for (var j = 0; j < colLength; j++) {
					var rowColObj = {};
					var checkBox = $("input[id = qstn" + id + "opt" + i + j + "]");
					
					if (checkBox.prop("checked") == true) {
						var rowColIds   = checkBox.attr("optionid");
						var rowColArray = rowColIds.split(",");
						var row         = rowColArray[0];
						var col         = rowColArray[1];
						
						rowColObj['rowId'] = parseInt(row);
						rowColObj['colId'] = parseInt(col);
						answer.push(rowColObj);
					}
				}
			}
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
		}
		
		function getTxtRespose(id, type) {
			var answerObj = {};
			var txtObj    = {};
			var answer    = [];
			var wrapper   = $("#prevQstn" + id);
			var txtAnswer = "";
			var optionId  = "";
			
			if (type == 5) {
				txtAnswer = wrapper.find(".shortanswer").val();
				optionId = parseInt(wrapper.find(".shortanswer").attr("optionid"));
			}
			else if (type == 6) {
				txtAnswer = wrapper.find(".paragraph").val();
				optionId = parseInt(wrapper.find(".paragraph").attr("optionid"));
				
			}
			
			if (txtAnswer != "") {
				txtObj['texts'] = txtAnswer;
				txtObj['optionId'] = optionId;
				answer.push(txtObj);
			}
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
		}
		
		function getSliderRespose(id, type) {
			var answerObj = {};
			var sliderObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var outputVal = parseInt($("#slider" + id).val());
			var optionId = parseInt($("#slider" + id).attr("optionid"));
			
			if (!isNaN(outputVal)) {
				sliderObj['sliderValue'] = outputVal;
				sliderObj['optionId'] = optionId;
				answer.push(sliderObj);
			}
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
		}
		
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
				
			} else {
				for (var i = 0; i < selectLengh; i++) {
					var rankingObj = {};
					var rankNum = i + 1;
					var optionId = parseInt($("select[name='ranking" + id + i + "'] option:selected").attr("optionid"));
					
					if (!isNaN(optionId)) {
						rankingObj['rankingLevel'] = rankNum;
						rankingObj['optionId'] = optionId;
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
		
		function getDrdwRespose(id, type) {
			var answerObj = {};
			var drdwObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var optId = parseInt($("select[name=drdw" + id + "] option:selected").attr("optionid"));
			
			if (!isNaN(optId)) {
				drdwObj['optionId'] = optId;
				answer.push(drdwObj);
			}
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
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
				case 0 : afterDeleteSuccessfully()        ; break;
				case 1 : alert(SurveyMessages.strParamErr); break;
				case 2 : alert(SurveyMessages.strError)   ; break;
				case 3 : alert(SurveyMessages.strPerm)    ; break;
				default: alert(SurveyMessages.strError)   ; return;
			}
		}
		
		function afterDeleteSuccessfully() {
			alert(SurveyMessages.strDel);
			if (window.opener.SurveyItem) {window.opener.SurveyItem.reload();}
			window.close();
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
			
			if (startDate > today) {
				alert(SurveyMessages.strNotPeriod + startDate + "~" + endDate);
				result = "fail";
			}
			
			if (endDate < today) {
				alert(SurveyMessages.strNotPeriod + startDate + "~" + endDate);
				result = "fail";
			}
			
			return result;
		}
		
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
					}
					
				}
				if (checkResult == 0 || checkResult == "") {
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
			var sliderValue = $("#slider" + id).val();
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
	});
</script>
</html>