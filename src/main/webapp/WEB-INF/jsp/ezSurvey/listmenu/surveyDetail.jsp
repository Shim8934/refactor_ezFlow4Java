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
			<img id="suvyDlt"  class="suvyDlt"  src="/images/ezSurvey/delete2.png"/>
			<img id="suvyInfo" class="suvyInfo" src="/images/ezSurvey/info.png"   />
			
			<ul id="upage-ul"class="upage-ul" style="display: none;">
				<li>
					<!-- <img src="/images/poll/numberOfSelect_1.png" class="voteIconImg_info" title="투표 가능 회수 : 1"> -->
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
					
					SurveyCreate.setQsForm(4);
					
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
					listQstDiv[i].style.display = "none";
				}
				else {
					listQstDiv[i].style.display = "";
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
			$(".prevQsArea").on("click", ".optRdo", function() {
				var prId     = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logicNum = $(this).attr("logic");
				
				if (logicNum && logicmap) {
					processLogicNode(parseInt(prId), parseInt(logicNum));
				}
			});
			
			$(".prevQsArea").on("click", ".optChb", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logicNum = $(this).attr("logic");
				
				if (logicNum && logicmap) {
					processLogicNode(parseInt(id), parseInt(logicNum));
				}
			});
			
			$(".prevQsArea").on("change", ".dropdown-wrap", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logic = $("select[name=drdw" + id + "] option:selected").attr("logic");
				
				if (logicNum && logicmap) {
					processLogicNode(parseInt(id), parseInt(logicNum));
				}
			});
			
			$(".prevQsArea").on("input", ".slider-range", function() {
				var outputElmt         = this.parentElement.parentElement.querySelector("output[class='slider-output']");
				outputElmt.textContent = this.value;
			}).trigger("change");
			
			$(".prevQsArea").on("change", ".slider-range", function() {
				var id = $(this).parents(".prevQsWrapper").attr("id").replace("prevQstn", "");
				var logic = $("#slider" + id).attr("logic");
				var logicPoint = $("#slider" + id).attr("logicPoint");
				
				
			});
			
			var delBttn = document.getElementById("suvyDlt");
			if (delBttn) {delBttn.onclick = function(e) {deleteFileConfirm();};}
			
			document.getElementById("suvyInfo").onclick   = function(e) {showSurveyInfo();}
			document.getElementById("cancelBttn").onclick = function(e) {window.close();}
			document.getElementById("saveResult").onclick = function(e) {saveSurveyResponses();}
		}
		
		function showAttachList() {
			var attachList = survey["attachList"];
			if (attachList && attachList.length > 0) {
				var ulElmt = document.getElementById("attachUl");
				for (var i = 0; i < attachList.length; i++) {
					var filename  = attachList[i]["fname"];
					var checkName = questionFile.chImage(filename);
					var imgSrc    = checkName.isImage == true ? attachList[i]["fpath"] : checkImageFile.urlImage;
					var liElmt    = document.createElement("li");
					var divWrp    = document.createElement("div");
					var divImg    = document.createElement("div");
					var imgElmt   = document.createElement("img");
					var divInf    = document.createElement("div");
					var spanTtl   = document.createElement("span");
					var spanSz    = document.createElement("span");
					
					divWrp.className    = "attDivFile";
					divImg.className    = "attImgAva";
					divInf.className    = "attFileInf";
					imgElmt.src         = imgSrc;
					spanTtl.textContent = filename;
					spanSz.textContent  = attachList[i]["fsize"];
					spanTtl.setAttribute("title", filename);
					divImg.appendChild(imgElmt);
					divInf.appendChild(spanTtl);
					divInf.appendChild(spanSz);
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
			var qsWrappers = $(".prevQsArea").find(".prevQsWrapper");
			console.log(qsWrappers);
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
						getMultiMtrRespose();
						break;
					case 5:
						getShorTxtRespose();
						break;
					case 6:
						getLongTxtRespose();
						break;
					case 7:
						getSliderRespose();
						break;
					case 8:
						geRankingRespose();
						break;
					case 9:
						getDrdwRespose();
						break;
					}
					
				}
			}
		}
		
		function getSingleSltRespose(id, type) {
			var obj = {};
			var wrapper = $("#prevQstn" + id);
			var optionLevel = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]:checked").val();
			var answer = [];
			
			answer.push(optionLevel);
			
			obj['questionLevel'] = id;
			obj['optionLevels'] = answer;
			obj['type'] = type;
			resposeObj.responses.push(obj);
			console.log(resposeObj.responses);
		}
		
		function getMultiSltRespose(id, type) {
			var obj = {};
			var wrapper = $("#prevQstn" + id);
			var boxes = wrapper.find(".prevQsOpt").find("input[name^=qstn" + id+ "]");
			var length = boxes.length;
			var answer = [];
			
			for (var i = 0; i < length; i++) {
				if (boxes[i].checked == true) {
					var level = i;
					var optionLevel = boxes[i].value;
					console.log(optionLevel);
					answer.push(optionLevel);
				}
			}
			
			obj['questionLevels'] = id;
			obj['optionLevels'] = answer;
			obj['type'] = type;
			resposeObj.responses.push(obj);
			console.log(resposeObj.responses);
		}
		
		function getSingleMtrRespose(id, type) {
			var obj = {};
			var wrapper = $("#prevQstn" + id);
			var trLength = wrapper.find("tbody").find("tr").length;
			var answer = [];

			for (var i = 0; i < trLength; i++) {
				var value = $("input[name = qstn" + id + "opt" + i + "]:checked").val();
				console.log(value);
				answer.push(value);
			}
			
			obj['questionLevels'] = id;
			obj['optionLevels'] = answer;
			obj['type'] = type;
			resposeObj.responses.push(obj);
			console.log(resposeObj.responses);
		}
		
		function getMultiMtrRespose(id, type) {
			var obj = {};
			var wrapper = $("#prevQstn" + id);
			var rowLength = wrapper.find("tbody").find("tr").length;
			var colLength = wrapper.find("thead").find("td").length;
			var answer = [];

			for (var i = 0; i < rowLength; i++) {
				for (var j = 0; j < colLength; j++) {
					var value = $("input[id = qstn" + id + "opt" + i + j + "]:checked").val();
					console.log(value);
					answer.push(value);
				}
			}
			
			obj['questionLevels'] = id;
			obj['optionLevels'] = answer;
			obj['type'] = type;
			resposeObj.responses.push(obj);
			console.log(resposeObj.responses);
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
	});
</script>
</html>