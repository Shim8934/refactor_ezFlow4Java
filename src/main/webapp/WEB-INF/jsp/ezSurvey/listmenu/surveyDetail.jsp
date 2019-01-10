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
				<img id="wtImg" class="wtImg" src="${not empty creator.userFileUrl ? creator.userFileUrl : '/images/default_pic.jpg'}"/>
			</div>
			<div id="wtInfo" class="wtInfo">
				<strong id="wtName" class="wtName"><c:out value="${creator.displayName}"/></strong>
				<strong id="wtTime" class="wtTime"><c:out value="${fn:substring(survey.createDate, 0, 19)}"/></strong>
			</div>
		</div>
		
		<div id="infoBtns" class="infoBtns">
			<c:if test="${empty mode and user == creator.id}">
				<img id="suvyDlt" class="suvyDlt"  src="/images/ezSurvey/delete2.png"/>
			</c:if>
			
			<img id="suvyInfo" class="suvyInfo" src="/images/ezSurvey/info.png"   />
			
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
					<!-- <img src="/images/poll/seeResultBeforeVote_On.png" class="voteIconImg_info" title="투표 종료 전 결과보기"> -->
					<span id="openDays">완료 후 개시 일수 : ${survey.openDays}</span>
				</li>
				<li>
					<!-- <img src="/images/poll/anonymousVote_Off.png" class="voteIconImg_info" title="기명 투표"> -->
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
					<!-- <img src="/images/poll/selOnlyOnce_Off.png" class="voteIconImg_info" title="낙장불입 미적용"> -->
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
			
		</div>
	</div>
	
	<div id="svTitle" class="svTitle">
		<div class="sryFirst2"></div>
		<span id="title" class="sryTxt">${survey.title}</span>
	</div>
	
	<div id="svPurpose" class="svPurpose">
		<div id="ppContent" class="ppContent">${survey.purpose}</div>
		<div class="attach-zone2 off" id="surveyAtt">
			<div class="mainzone2">
				<div class="fileList">
					<ul class="user-pageul" id="attachUl"></ul>
				</div>
			</div>
		</div>
	</div>
	
	<div class="prevQsArea"></div>
	
	<div class="detailBtns" style="text-align: right;">
		<div class="survey-bttn-wrp">
			<img id="saveResult" src="/images/ezSurvey/save2.png"/>
			<img id="cancelBttn" src="/images/ezSurvey/cancel2.png"/>
		</div>
	</div>
	<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
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
		
		getQuestions();
		userEvent();
		
		function getQuestions() {
			$.ajax({
				type: "GET",
				url: "/ezSurvey/getSurveyQuestions.do",
				data: {surveyId : surveyId},
				contentType: "application/json; charset=utf-8",
				dataType: "JSON",
				async: true,
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
					
					//console.log(JSON.parse(JSON.stringify(data["logicmap" ])));
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
					//listQstDiv[i].style.display = "none";
				}
				else {
					$("#prevQstn" + qstLevel).find("#mask" + qstLevel).remove();
					//listQstDiv[i].style.display = "";
				}
			}
		}
		
		function traverNode(nodeLevel, currentPath, totalPath) {
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
		
		function userEvent() {
			showAttachList();
			// 라디오 버튼 클릭 이벤트
			$(".prevQsArea").on("click", ".optRdo", function() {
				var prId     = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logicNum = $(this).attr("logic");
				
				if (logicNum && logicmap) {
					processLogicNode(parseInt(prId), parseInt(logicNum));
				}
			});
			
			$(".prevQsArea").on("change", ".dropdown-wrap", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logic = $("select[name=drdw" + id + "] option:selected").attr("logic");
				
			});
			
			// 슬라이드 질문 트리거
			$(".prevQsArea").on("input", ".slider-range", function() {
				var outputElmt         = this.parentElement.parentElement.querySelector("output[class='slider-output']");
				outputElmt.textContent = this.value;
			}).trigger("change");
			
			// 슬라이드 질문 답변 표시
			$(".prevQsArea").on("change", ".slider-range", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logic = $("#slider" + id).attr("logic");
				var logicPoint = $("#slider" + id).attr("logicPoint");
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
					if (orders == i) {
						continue;
					}
					// 비교할 값
					var neighborValue = $("select[name=ranking" + id + i + "]").val();
					if (thisValue == neighborValue) {
						alert("같은 값을 선택할 수 없습니다.");
						// 셀렉트 박스 값 초기화
						$("select[name=ranking" + id + orders + "]").val("").prop("selected", true);
					}
					
				}
				
			});
			
			var delBttn = document.getElementById("suvyDlt");
			if (delBttn) {delBttn.onclick = function(e) {deleteFileConfirm();};}
			
			document.getElementById("suvyInfo").onclick   = function(e) {showSurveyInfo(); checkRequired();}
			
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
		
		function showSurveyInfo() {
			var status = $(".upage-ul").css("display");
			status == "none" ? $(".upage-ul").css("display", "") : $(".upage-ul").css("display", "none");
		}
		
		function saveSurveyResponses() {
			var result = "";
			result = checkDate();

			if (result != "") {
				var qsWrappers = $(".prevQsArea").find(".prevQsWrapper");
				
				for (var i = 0; i < qsWrappers.length; i++) {
					var wrapper = qsWrappers[i];
					var displayValue = wrapper.style.display;
	
					if (displayValue != "none") {
						var qstnId = wrapper.getAttribute("id");
						var id = parseInt(qstnId.replace("prevQstn", ""));
						var type = parseInt(wrapper.getAttribute("type"));
						
						switch (type) {
						case 1:
							getSingleSltRespose(id, type);
							break;
						case 2:
							getMultiSltRespose(id, type);
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
							getRankingRespose(id, type);
							break;
						case 9:
							getDrdwRespose(id, type);
							break;
						}
						
					}
					
				}
				saveResponse();
			}
			
		}
		
		function saveResponse() {
			console.log(JSON.stringify(resposeObj));
			
			$.ajax({
				type: "POST",
				url: "/ezSurvey/saveResponse.do",
				data: JSON.stringify(resposeObj),
				contentType: "application/json; charset=utf-8",
				dataType: "JSON",
				async: false,
				success : function(data) {
					afterSaveSuccessfully(data);
				},
				error : function(error) {
					alert(SurveyMessages.strError);
				}
			});
			
		}
		
		function afterSaveSuccessfully(data) {
			var code = data.code;
			switch(code) {
				case 0 : alert(SurveyMessages.strSave)    ;
						 window.close();
						 break;
				case 1 : alert(SurveyMessages.strParamErr); break;
				case 2 : alert(SurveyMessages.strError)   ; break;
				default: alert(SurveyMessages.strError)   ; return;
			}
		}
		
		function getSingleSltRespose(id, type) {
			var answerObj = {};
			var optionLevel = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var optLevel = parseInt(wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]:checked").val());

			if (optLevel != undefined) {
				optionLevel['optionLevel'] = optLevel;
				answer.push(optionLevel);
				
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}

			//console.log(resposeObj.responses);
		}
		
		function getMultiSltRespose(id, type) {
			var answerObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var checkBox = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]");
			var length = checkBox.length;
			
			for (var i = 0; i < length; i++) {
				if (checkBox[i].checked == true) {
					var optLevel = parseInt(checkBox[i].value);
					var optionLevel = {};
					optionLevel['optionLevel'] = optLevel;
					answer.push(optionLevel);
				}
			}

			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			//console.log(resposeObj.responses);
		}
		
		function getSingleMtrRespose(id, type) {
			var answerObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var trLength = wrapper.find("tbody").find("tr").length;

			for (var i = 0; i < trLength; i++) {
				var rowColObj = {};
				var rowColLevels = $("input[name = qstn" + id + "opt" + i + "]:checked").val();
				
				if (rowColLevels != undefined) {
					console.log(rowColLevels);
					var rowColArray = rowColLevels.split(",");
					var row = rowColArray[0];
					var col = rowColArray[1];
					
					rowColObj['row'] = parseInt(row);
					rowColObj['col'] = parseInt(col);
					answer.push(rowColObj);
				}
			}
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			//console.log(resposeObj.responses);
		}
		
		function getMultiMtrRespose(id, type) {
			var answerObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var rowLength = wrapper.find("tbody").find("tr").length;
			var colLength = wrapper.find("thead").find("td").length;

			for (var i = 0; i < rowLength; i++) {
				for (var j = 0; j < colLength; j++) {
					var rowColObj = {};
					var checkBox = $("input[id = qstn" + id + "opt" + i + j + "]");
					
					if (checkBox.prop("checked") == true) {
						var rowColLevels = checkBox.val();
						var rowColArray = rowColLevels.split(",");
						var row = rowColArray[0];
						var col = rowColArray[1];
						
						rowColObj['row'] = parseInt(row);
						rowColObj['col'] = parseInt(col);
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
			//console.log(resposeObj.responses);
		}
		
		function getTxtRespose(id, type) {
			var answerObj = {};
			var txtObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var txtAnswer = "";
			if (type == 5) {
				txtAnswer = wrapper.find(".shortanswer").val();

			} else if (type == 6) {
				txtAnswer = wrapper.find(".paragraph").val();
				
			}
			txtObj['texts'] = txtAnswer;
			answer.push(txtObj);
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			//console.log(resposeObj.responses);
		}
		
		function getSliderRespose(id, type) {
			var answerObj = {};
			var sliderObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var outputVal = $("#slider" + id).val();
			
			sliderObj['sliderValue'] = parseInt(outputVal);
			answer.push(sliderObj);
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			//console.log(resposeObj.responses);
		}
		
		function getRankingRespose(id, type) {
			var answerObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var selectLengh = wrapper.find(".ranking-select").length;

			for (var i = 0; i < selectLengh; i++) {
				var rankingObj = {};
				var rankNum = i + 1;
				var optionLevel = $("select[name='ranking" + id + i + "'] option:selected").val();
				
				rankingObj['rankingLevel'] = rankNum;
				rankingObj['rankingOptionLevel'] = parseInt(optionLevel);
				answer.push(rankingObj);
			}
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			//console.log(resposeObj.responses);
		}
		
		function getDrdwRespose(id, type) {
			var answerObj = {};
			var drdwObj = {};
			var answer = [];
			var wrapper = $("#prevQstn" + id);
			var optLevel = $("select[name=drdw" + id + "] option:selected").val();
			
			drdwObj['optionLevel'] = parseInt(optLevel);
			answer.push(drdwObj);
			
			if (answer.length > 0) {
				answerObj['answers'] = answer;
				answerObj['type'] = type;
				answerObj['questionLevel'] = id;
				resposeObj.responses.push(answerObj);
			}
			//console.log(resposeObj.responses);
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
			window.close();
		}
		
		function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode, moreParam) {
			$.ajax({
				type: ajaxType,
				url: ajaxUrl,
				data: ajaxData,
				dataType: "JSON",
				async: asyncMode != false ? true : false,
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
			var endDate = survey.endDate.substr(0, 10);
			var today = new Date();
			var yyyy = today.getFullYear();
			var MM = today.getMonth() + 1;
			var dd = today.getDate();
			var result = "";
			
			if (dd < 10) {
				dd = '0' + dd;
			}
			if (MM < 10) {
				MM = '0' + MM;
			}
			today = yyyy + "-" + MM + "-" + dd;
			
			if (startDate > today) {
				alert("설문 기간이 아닙니다. 설문 가능 기간: " + startDate + "~" + endDate);
				result = "false";
			}
			if (endDate < today) {
				alert("설문 기간이 아닙니다. 설문 가능 기간: " + startDate + "~" + endDate);
				result = "false";
			}
			
			return result;
		}
		
		function checkRequired() {
			var qsWrappers = $(".prevQsArea").find(".prevQsWrapper");
			var arr = [];

			for (var i = 0; i < qsWrappers.length; i++) {
				var display = qsWrappers[i].style.display;
				var required = qsWrappers[i].querySelector("strong[class='imptt']");
				
				if (display != "none" && required != null) {
					var id = i + 1;
					var type = qsWrappers[i].getAttribute("type");
					
					switch(type) {
					case 1 : 
					case 2 :
						checkSltResponse(id);
						break;
					case 3 : 
					case 4 :
						checkMtrResponse(id, type);
						break;
					}
					
				}
			}
			
		}
		
		function checkSltResponse(id) {
			
			var cnt = $("input[name^=qstn" + id+ "]:checked").length;
			console.log(cnt);
			
			var wrapper = $("#prevQstn" + id);
			var checkedCnt = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]:checked").length;
			if (checkedCnt == 0) {
				alert(id + "번 질문은 필수 답변 질문입니다.");
			}
		}
		function checkMtrResponse(id, type) {
			var wrapper = $("#prevQstn" + id);
		}
	});
</script>
</html>