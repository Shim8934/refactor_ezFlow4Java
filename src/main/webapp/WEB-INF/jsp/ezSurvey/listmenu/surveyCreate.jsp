<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

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
		<div class="surveyCrtTtl">
			<div class="sryFirst"></div>
			<div class="sryTxt"><spring:message code='ezSurvey.t34'/></div>
		</div>
		
		<div class="headpanel">
			<span class="crust selected">
				<a class="crumb"><span><spring:message code='ezSurvey.t35'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t36'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t37'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
		</div>
		
		<div id="bodyPanel">
			<div id="tab1" class="select-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyInfomation.jsp"></jsp:include>
			</div>
			<div id="tab2" class="hidden-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/questionCreate.jsp"></jsp:include>
			</div>
			<div id="tab3" class="hidden-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/preview.jsp"></jsp:include>
			</div>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
		<script type="text/javascript">
			var SurveyCreate    = function() {
				var surveyFile  = new SurveyFile();
				var selectPopup = null;
				var finishStep  = null;
				var lastStep    = 1;
				var userWindow  = null;
				var lastScrollY = 0;
				var scrolled    = true;
				var surveyObj   = {
					infor     : {},
					questions : []
				};
				
				var datepickerSt   = {
					changeMonth    : true,
					changeYear     : true,
					autoSize       : true,
					showOn         : "both",
					buttonImage    : "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly: true,
					minDate        : 0,
					dateFormat     : "yy-mm-dd"
				};
				
				$.datepicker.regional[SurveyMessages["strLocale"]] = {
					closeText         : SurveyMessages["strClose"],
					prevText          : SurveyMessages["prevMonth"],
					nextText          : SurveyMessages["nextMonth"],
					currentText       : SurveyMessages["strToday"],
					monthNames        : SurveyMessages["monthNames"],
					monthNamesShort   : SurveyMessages["monthNames"],
					dayNames          : SurveyMessages["dayNames"],
					dayNamesShort     : SurveyMessages["dayNames"],
					dayNamesMin       : SurveyMessages["dayNames"],
					weekHeader        : "Wk",
					dateFormat        : "yy-mm-dd",
					firstDay          : 0,
					isRTL             : false,
					duration          : 200,
					showAnim          : "show",
					showMonthAfterYear: true
				};
					
				$.datepicker.setDefaults($.datepicker.regional[SurveyMessages["strLocale"]]);
				
				initEvents();
				
				function initEvents() {
					document.onselectstart = function() {return false;};
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					document.getElementById("selectTarget" ).addEventListener("change", toggleSelectTargetBttn, false);
					document.getElementById("targetBttn"   ).addEventListener("click" , showSelectPopUp       , false);
					document.getElementById("gotoSecondTab").addEventListener("click" , gotoSecondStep        , false);
					document.getElementById("gotoThirdTab" ).addEventListener("click" , gotoThirdStep         , false);
					document.getElementById("cancelSurvey1").addEventListener("click" , cancleThisSurvey      , false);
					document.getElementById("public-slbox" ).addEventListener("change", toggleDaysInput       , false);
					document.getElementById("closeUserPanel").addEventListener("click", toggleUserPreview     , false);
					
					var today = new Date();
					$("#startDate").datepicker(datepickerSt);
					$("#endDate").datepicker(datepickerSt);
					$("#startDate").datepicker("setDate", today);
					$("#endDate").datepicker("setDate", today);
					
					var listTabElmt = document.getElementsByClassName("headpanel")[0].children;
					for (var i = 0, len = listTabElmt.length; i < len; i++) {
						var tabElmt      = listTabElmt[i];
						var spanElmt     = tabElmt.querySelector("span[class='arrow']");
						tabElmt.onclick  = (function(idx, elmt) {return function() {selectStep(idx, elmt);};})(i + 1, tabElmt);
						spanElmt.onclick = (function(idx, elmt) {return function() {selectStep(idx, elmt);};})(i + 1, tabElmt);
					}
					
					var fileUploadBttn      = document.getElementById("fileBttn");
					fileUploadBttn.onchange = function(e) {surveyFile.upload();};
					var addFileBttn         = document.getElementById("addFileBttn");
					addFileBttn.onclick     = function(e) {startUpload();};
					var fileDivElmt         = document.getElementById("fileDiv");
					fileDivElmt.onclick     = function(e) {startUpload();};
					
					fileDivElmt.addEventListener("dragenter", function(e) {surveyFile.dragEnter(e);}, false);
					fileDivElmt.addEventListener("dragover" , function(e) {surveyFile.dragOver(e);} , false);
					fileDivElmt.addEventListener("drop"     , function(e) {surveyFile.upload(e);}   , false);
					
					var userMoreElmt = document.querySelector("span[class='user-more']");
					if (userMoreElmt) {userMoreElmt.onclick = function(e) {toggleUserPreview();};}
					document.getElementById("userListDiv").onscroll = function(e) {scrollListOfUser(this);}
				}
				
				function startUpload() {document.getElementById("fileBttn").click();}
				function cancleThisSurvey() {saveSurvey();/* Add function later */}
				
				function saveSurvey() {
					$.ajax({
						type: "POST",
						url: "/ezSurvey/saveSurvey.do",
						data: JSON.stringify(surveyObj),
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
				
				function saveSurveyInformation() {
					var surveyInfoWrap = document.querySelector("div[class='surveyinfo-wrap']");
					var surveyAttWrap  = document.querySelector("div[class='survey-attach']");
					var surveyTitle    = surveyInfoWrap.querySelector("input[class='info-input-ttl']").value;
					var surveyPurpose  = surveyInfoWrap.querySelector("input[class='info-input-pp']").value;
					var startDate      = document.getElementById("startDate").value;
					var endDate        = document.getElementById("endDate").value;
					var publicFlag     = 1 - document.getElementById("public-slbox").selectedIndex;
					var anonymousFlag  = document.getElementById("anonymous-slbox").selectedIndex;
					var multipleFlag   = document.getElementById("multiple-slbox").selectedIndex;
					var userFlag       = document.getElementById("selectTarget").selectedIndex;
					var liFileList     = surveyAttWrap.querySelector("ul[class='ulFiles']").children;
					var attachList     = [];
					
					if (publicFlag == 1) {
						var daysVal                      = surveyInfoWrap.querySelector("input[class='date-input']").value;
						surveyObj["infor"]["publicDays"] = parseInt(daysVal);
					}
					
					surveyObj["infor"]["title"]     = surveyTitle;
					surveyObj["infor"]["purpose"]   = surveyPurpose;
					surveyObj["infor"]["public"]    = publicFlag;
					surveyObj["infor"]["anonymous"] = anonymousFlag;
					surveyObj["infor"]["multiple"]  = multipleFlag;
					surveyObj["infor"]["startDate"] = startDate;
					surveyObj["infor"]["endDate"]   = endDate;
					surveyObj["infor"]["userflag"]  = userFlag;
					
					if (liFileList.length > 0) {
						for (var i = 0, len = liFileList.length; i < len; i++) {
							attachList.push({
								fname : liFileList[i].getAttribute("fname"),
								fsize : liFileList[i].getAttribute("fsize"),
								fpath : liFileList[i].getAttribute("path"),
							});
						}
					}
					
					surveyObj["infor"]["attach"] = attachList;
					console.log(JSON.stringify(surveyObj["infor"]["users"]));
				}
				
				function afterSaveSuccessfully(data) {
					var code = data.code;
					switch(code) {
						case 0 : alert(SurveyMessages.strSave)    ; break;
						case 1 : alert(SurveyMessages.strParamErr); break;
						case 2 : alert(SurveyMessages.strError)   ; break;
						default: alert(SurveyMessages.strError)   ; return;
					}
				}
				
				function gotoSecondStep() {
					var checkObj = prepareForStep2();
					if (checkObj["error"]) {alert(checkObj["error"]); return;}
					
					var listTabElmt          = document.getElementsByClassName("headpanel")[0].children;
					listTabElmt[0].className = "crust";
					listTabElmt[1].className = "crust selected";
					document.getElementById("tab1").className = "hidden-tab";
					document.getElementById("tab2").className = "select-tab";
					lastStep = 2;
				}
				
				function gotoThirdStep() {
					var checkObj = prepareForStep3();
					if (checkObj["error"]) {alert(checkObj["error"]); return;}
					
					var listTabElmt          = document.getElementsByClassName("headpanel")[0].children;
					listTabElmt[0].className = "crust";
					listTabElmt[1].className = "crust";
					listTabElmt[2].className = "crust selected";
					document.getElementById("tab2").className = "hidden-tab";
					document.getElementById("tab3").className = "select-tab";
					lastStep = 3;
				}
				
				function selectStep(tabIdx, spanElemt) {
					var crrSpan = document.querySelector("span[class='crust selected']");
					if (crrSpan == spanElemt) {return;}
					var checkObj = null;
					
					switch(parseInt(tabIdx)) {
						case 1: focusonQuestionTitleStep1(); 
								toggleStep(spanElemt, crrSpan, tabIdx);
								lastStep = 1; break;
						case 2: checkObj = prepareForStep2()
								if (checkObj["error"]) {alert(checkObj["error"]); return;}
								toggleStep(spanElemt, crrSpan, tabIdx);
								focusonQuestionTitleStep2();
								lastStep = 2; break;
						case 3: checkObj = prepareForStep3();
								if (checkObj["error"]) {alert(checkObj["error"]); return;}
								toggleStep(spanElemt, crrSpan, tabIdx);
								getSurveyPreview();
								lastStep = 3; break;
					}
				}
				
				function toggleStep(spanElemt, crrSpan, tabIdx) {
					spanElemt.className = "crust selected";
					crrSpan.className   = "crust";
					var tabElmt         = document.getElementById("tab" + tabIdx);
					var selectTab       = document.querySelector("div[class='select-tab']");
					tabElmt.className   = "select-tab";
					selectTab.className = "hidden-tab";
				}
				
				function focusonQuestionTitleStep1() {document.querySelector("input[class='info-input-ttl']").focus();}
				function focusonQuestionTitleStep2() {document.querySelector("div[class='quesDiv']").querySelector("input[class='questnTitle']").focus();}
				function getSurveyPreview() {/* prevQstn(); */}
				
				function prepareForStep2() {
					var returnObj = {};
					
					if (finishStep < 2) {
						returnObj = checkStep1();
						if (returnObj["error"]) {return returnObj;}
					}
					
					return returnObj;
				}
				
				function prepareForStep3() {
					var returnObj = {};
					
					if (finishStep < 3) {
						returnObj = checkStep1();
						if (returnObj["error"]) {return returnObj;}
						returnObj = checkStep2();
						if (returnObj["error"]) {return returnObj;}
					}
					
					document.querySelector("div[class='quesDiv']").querySelector("input[class='questnTitle']").focus();
					return returnObj;
				}
				
				function checkStep1() {
					var returnObj  = {};
					var surveyTtl  = document.querySelector("input[class='info-input-ttl']");
					var surveyPp   = document.querySelector("input[class='info-input-pp' ]");
					var sDate      = document.getElementById("startDate").value;
					var eDate      = document.getElementById("endDate").value;
					var publicFlag = 1 - document.getElementById("public-slbox").selectedIndex;
					var userFlag   = document.getElementById("selectTarget").selectedIndex;
					var userList   = surveyObj["infor"]["users"];
					
					if (!surveyTtl.value) {returnObj["error"] = SurveyMessages.strTitle  ; surveyTtl.focus(); return returnObj;}
					if (!surveyPp.value)  {returnObj["error"] = SurveyMessages.strPurpose; surveyPp.focus() ; return returnObj;}
					if (!sDate)           {returnObj["error"] = SurveyMessages.strSvDate3; return returnObj;}
					if (!eDate)           {returnObj["error"] = SurveyMessages.strSvDate2; return returnObj;}
					if (sDate > eDate)    {returnObj["error"] = SurveyMessages.strSvDate1; return returnObj;}
					
					if (publicFlag == 1) {
						var daysInput = document.querySelector("input[class='date-input']");
						if (!isValid(daysInput.value)) {returnObj["error"] = SurveyMessages.strInvalid; daysInput.focus(); return returnObj;}
					}
					
					if (userFlag == 1 && !userList) {returnObj["error"] = SurveyMessages.strUser1; return returnObj;}
					
					var surveyttlList = document.querySelectorAll("span[class='sryTxt']");
					for (var i = 0, len = surveyttlList.length; i < len; i++) {
						surveyttlList[i].textContent = surveyTtl.value;
					}
					
					if (lastStep == 1) {saveSurveyInformation();}
					
					return returnObj;
				}
				
				function checkStep2() {
					var returnObj    = {};
					var questionList = getSurveyQuestions();
					if (questionList.length == 0) {returnObj["error"] = SurveyMessages.strQuestion; return returnObj;}
					return returnObj;
				}
				
				function toggleSelectTargetBttn() {
					var sltBoxElmt = document.getElementById("selectTarget");
					var divUserWrp = document.getElementById("userWrapDiv");
					var sltedIdx   = sltBoxElmt.selectedIndex;
					
					if (sltedIdx == 0) {
						divUserWrp.className        = "user-mainDiv";
						surveyObj["infor"]["users"] = null;
					}
					else {
						divUserWrp.className = "user-mainDiv on";
					}
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
				
				function toggleDaysInput() {
					var slxIdx    = document.getElementById("public-slbox").selectedIndex;
					var inputElmt = document.querySelector("input[class='date-input']");
					
					if (slxIdx == 1) {
						inputElmt.value    = "";
						inputElmt.disabled = true;
					}
					else {
						inputElmt.value    = "0";
						inputElmt.disabled = false;
					}
				}
				
				function toggleUserPreview() {
					var userPanel = document.getElementById("userPanel");
					if (userPanel.className == "userPanel off") {
						addFogPanel();
						var position          = getPosition(466, 210);
						userPanel.style.top   = position[0] + "px";
						userPanel.style.right = position[1] + "px";
						userPanel.className   = "userPanel";
					}
					else {
						removeFogPanel();
						userPanel.className   = "userPanel off";
						if(userWindow) {userWindow.close();}
					}
				}
				
				function addFogPanel() {
					var fogPanel                  = document.createElement("div");
					fogPanel.className            = "rfogPanel";
					var leftFogPanel              = document.createElement("div");
					leftFogPanel.className        = "blockLeft";
					fogPanel.onclick              = function(e) {toggleUserPreview();};
					leftFogPanel.onclick          = function(e) {toggleUserPreview();};
					var leftFrameBody             = window.parent.frames["left"].document.body;
					var rightFrameBody            = window.parent.frames["right"].document.body;
					leftFrameBody.style.overflow  = "hidden";
					rightFrameBody.style.overflow = "hidden";
					
					leftFrameBody.appendChild(leftFogPanel);
					document.body.appendChild(fogPanel);
				}
				
				function removeFogPanel() {
					var leftFrame    = window.parent.frames["left"].document;
					var rightFrame   = window.parent.frames["right"].document;
					var fogPanel     = rightFrame.querySelector("div[class='rfogPanel']");
					var leftFogPanel = leftFrame.querySelector("div[class='blockLeft']");
					
					if (fogPanel) {rightFrame.body.removeChild(fogPanel);}
					if (leftFogPanel) {leftFrame.body.removeChild(leftFogPanel);}
					if (rightFrame.getElementById("ui-datepicker-div")) {rightFrame.getElementById("ui-datepicker-div").style.display = "none";}
					
					leftFrame.body.style.overflow  = "auto";
					rightFrame.body.style.overflow = "";
				}
				
				function getPosition(popUpW, popUpH) {
					var returnValue = new Array();
					var heigth      = window.parent.document.documentElement.clientHeight;
					if (heigth == 0) {heigth = window.parent.document.body.clientHeight;}
					
					var width = window.parent.document.documentElement.clientWidth;
					if (width == 0) {width = window.parent.document.body.clientWidth;}
					
					var pleftpos   = parseInt(width) - popUpW;
					heigth         = parseInt(heigth) - popUpH;
					returnValue[0] = heigth < (popUpH + 50) ? (heigth / 2) : (heigth / 2) - 50;
					returnValue[1] = pleftpos / 2;
					
					return returnValue;
				}
				
				function showUserInfoFromId(userId) {
					var feature = "height=500px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
					feature = feature + getOpenWindowfeature(420, 500);
					userWindow = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
				}
				
				function closeAllPopups() {
					if(selectPopup) {selectPopup.close();}
					if(userWindow)  {userWindow.close();}
				}
				
				function scrollListOfUser(divElmt) {
					if (scrolled) {
						scrolled          = false;
						var distance      = divElmt.scrollTop < lastScrollY ? -25 : 25;
						divElmt.scrollTop = lastScrollY + distance;
						setTimeout(function () {scrolled = true; lastScrollY = divElmt.scrollTop;}, 500);
					}
				}
				
				function showUserList() {
					var userArr = surveyObj["infor"]["users"];
					var divElmt = document.getElementById("userListDiv");
					
					while (divElmt.firstElementChild) {
						divElmt.removeChild(divElmt.firstElementChild);
					}
					
					for (var i = 0, len = userArr.length; i < len; i++) {
						var spanElmt = document.createElement("span");
						var uElmt    = document.createElement("u");
						var imgElmt  = document.createElement("img");
						var divideEm = document.createElement("em");
						uElmt.setAttribute("role", userArr[i]["userId"]);
						uElmt.textContent    = userArr[i]["userName"];
						uElmt.onclick        = (function(userId){return function() {showUserInfoFromId(userId);};})(userArr[i]["userId"]);
						imgElmt.onclick      = (function(userId, userType){return function() {removeUser(this, userId, userType);};})(userArr[i]["userId"], userArr[i]["userType"]);
						spanElmt.className   = "rlSpanBnk";
						divideEm.textContent = ";";
						imgElmt.src          = "/images/icon/oneline_delete.gif";
						spanElmt.appendChild(uElmt);
						spanElmt.appendChild(divideEm);
						spanElmt.appendChild(imgElmt);
						divElmt.appendChild(spanElmt);
					}
				}
				
				function removeUser(imgElmt, userId, userType) {
					var userArr = surveyObj["infor"]["users"];
					
					for (var i = 0 ; i < userArr.length; i++) {
						if (userArr[i]["userId"] == userId && userArr[i]["userType"] == userType) {console.log("Here!"); userArr.splice(i, 1);}
					}
					
					surveyObj["infor"]["users"] = userArr;
					var spanElmt = imgElmt.parentElement;
					spanElmt.parentElement.removeChild(spanElmt);
				}
				
				function showSelectPopUp() {selectPopup = window.open("/ezSurvey/selectUsers.do", "selectUser", getOpenWindowfeature(964, 700));}
				function getSurveyQuestions() {return surveyObj["questions"];}
				function setSurveyQuestions(question) {surveyObj["questions"].push(question);}
				function getSurveyUsers() {return surveyObj["infor"]["users"];}
				function setSurveyUsers(userList) {surveyObj["infor"]["users"] = JSON.parse(JSON.stringify(userList)); showUserList();}
				function getSurveyInfo() {return surveyObj["infor"];}
				function isValid(value) {if (!isNaN(value) && parseFloat(value) >= 0 && value % 1 === 0) {return true;} else {return false;}}
				
				return {
					getUsers : getSurveyUsers,
					setUsers : setSurveyUsers,
					getQs    : getSurveyQuestions,
					setQs    : setSurveyQuestions,
					getInfo  : getSurveyInfo,
					userMore : toggleUserPreview,
					showUser : showUserInfoFromId,
				};
			}();
			
			$(function() {
				var questionFile = new SurveyFile("images");
				var config       = {modify : "modify", required : "required", action : "action",}
					
				// 셀렉트 박스에 들어갈 질문 유형 데이터 
				var optionData = 
					[{ text : SurveyMessages.strSlOne   , value: 1, selected: false, imageSrc: "/images/ezSurvey/oneselect.png"  },
					 { text : SurveyMessages.strSlMtp   , value: 2, selected: false, imageSrc: "/images/ezSurvey/multiplesl.png" },
					 { text : SurveyMessages.strTblOne  , value: 3, selected: false, imageSrc: "/images/ezSurvey/tblone.png"     },
					 { text : SurveyMessages.strTblMtp  , value: 4, selected: false, imageSrc: "/images/ezSurvey/tblmultiple.png"},
					 { text : SurveyMessages.strShortQs , value: 5, selected: false, imageSrc: "/images/ezSurvey/shorttext.png"  },
					 { text : SurveyMessages.strLongQs  , value: 6, selected: false, imageSrc: "/images/ezSurvey/paragraph.png"  },
					 { text : SurveyMessages.strSlider  , value: 7, selected: false, imageSrc: "/images/ezSurvey/slider.png"     },
					 { text : SurveyMessages.strRanking , value: 8, selected: false, imageSrc: "/images/ezSurvey/ranking.png"    },
					 { text : SurveyMessages.strDropdown, value: 9, selected: false, imageSrc: "/images/ezSurvey/dropdown.png"   }];
				
				// question input 및 img 생성
				createQuestionDiv();
				addQstnEvent();
				
				// question selectBox 생성
				createQuestionSelectBox();
				addOptEvent();
				
				// question input 및 img 생성
				function createQuestionDiv(qstnWrapper, question) {
					var html       = "";
					var qstId      = "";
					var qstContent = "";
					var qstAtt     = "";
					
					if (question) {
						qstId      = question.id;
						qstContent = question.content;
						qstAtt     = mkImgTag(question.attach);
					}
					
					html += "<div class='qstnWrapper' id='" + qstId + "'>";
					html += "<div class='quesDiv'>";
					html += "<div class='qstnRow'>";
					html += "<input class='questnTitle' value='" + qstContent + "' placeholder='" + SurveyMessages.strContent + "'/>";
					html += "<img alt='' src='/images/ezSurvey/attach.png' class='atchImg'>";
					html += "<div class='selectBox'></div>";
					html += "</div>";
					html += "<div class='qstnFileInfo'>";
					html += "<div class='fileList'>";
					html += "<ul class='qstUl'>" + qstAtt + "</ul>";
					html += "<input type='file' class='qstnFile' accept='image/*'/>";
					html += "</div></div></div></div>";
					
					if (qstnWrapper) {
						qstnWrapper.after(html);
						qstnWrapper.next().find(".questnTitle")[0].focus();
					}
					else {
						$(".quesBacgr").append(html);
						$(".quesBacgr").find(".qstnWrapper").find(".questnTitle")[0].focus();
					}
				}
				
				// question event 추가
				function addQstnEvent() {
					// question 첨부파일 트리거
					$(".quesBacgr").on("click", ".atchImg", function() {
						var li = $(this).closest(".quesDiv").find(".fileList").find("li");
						if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
						$(this).parent().next().find(".qstnFile").click();
					});
					
					// question 첨부파일 추가
					$(".quesBacgr").on("change", ".qstnFile", function(e) {fileUpload(this);});
				}
				// selectBox 생성
				function createQuestionSelectBox(question) {
					$(".selectBox").ddslick({
						data :optionData,
						imagePosition: "left",
						selectText: SurveyMessages.strQselect,
						onSelected: function(data) {
							var selectedEl   = data.selectedItem;
							var grandParent  = selectedEl.parents(".qstnWrapper");
							var questionType = data.selectedData.value;
							
							rmQstnFormBfSave(grandParent);
							var checkResult = checkPrevWrapper(grandParent);
							
							switch (parseInt(questionType)) {
								case 1: 
								case 2: makeSelectQuestion(grandParent, questionType, checkResult)              ; break;
								case 3: 
								case 4: makeMatrixQuestion(grandParent, questionType, checkResult)              ; break;
								case 5: makeTextQuestion(grandParent, questionType, "shortanswer", checkResult) ; break;
								case 6: makeTextQuestion(grandParent, questionType, "paragraph"  , checkResult) ; break;
								case 7: makeSliderQuestion(grandParent, questionType, checkResult)              ; break;
								case 8: makeRankingQuestion(grandParent, questionType, checkResult)             ; break;
								case 9: makeDropdownQuestion(grandParent, questionType, checkResult)            ; break;
							}
						}
					});
				}
				// 현재 상태(최초 저장인지 수정 중인지) 체크
				function checkPrevWrapper(grandParent) {
					var checkResult = {};
					var thisId      = parseInt(grandParent.attr("id"));
					
					if (thisId) {
						var qstnObj = SurveyCreate.getQs();
						checkResult[config["action"]]   = config["modify"];
						checkResult[config["required"]] = qstnObj[thisId - 1].required;
					}
					
					return checkResult;
				}
				// 셀렉트 박스 선택시
				// 셀렉트 박스 아래의 질문 폼 삭제
				function rmQstnFormBfSave(grandParent) {
					var qstnForm = grandParent.find(".qstnForm");
					if (qstnForm.length != 0) {qstnForm.remove();}
				}
				
				// 셀렉트 박스 선택시 만들어지는 질문 폼 선택 질문 생성
				function makeSelectQuestion(grandParent, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifySelectQuestion();
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					grandParent.append(html);
				}
				
				// 셀렉트 박스 선택시 만들어지는 질문 폼 행렬 질문 생성
				function makeMatrixQuestion(grandParent, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifyMatrixQuestion();
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					grandParent.append(html);
				}
				
				// 버튼 이벤트
				function addOptEvent() {
					$(".quesBacgr").on("click", ".addOpttions", function() {
						var thisEl    = $(this).parents(".qstnForm");
						var classType = parseInt(thisEl.attr("questiontype")) == 8 ? "ranking" : "dropdown";
						var optCnt    = thisEl.find(".textInput").length;
						thisEl.find("." + classType + "-select").last().after(mkOptions(classType, optCnt + 1, ""));
					});
					
					$(".quesBacgr").on("click", ".delOption", function() {
						var thisElmt  = $(this);
						var qstForm   = thisElmt.parents(".qstnForm");
						var classType = parseInt(qstForm.attr("questiontype")) == 8 ? "ranking" : "dropdown";
						var optCnt    = qstForm.find(".textInput").length;
						
						if (optCnt <= 2) {alert(SurveyMessages.strOptErr); return;}
						thisElmt.parents("." + classType + "-select").remove();
					});
					
					// 보기 추가
					$(".quesBacgr").on("click", ".addOpt", function() {
						var thisEl = $(this).parents(".qstnForm");
						thisEl.find(".optPart").last().after(mkOpt("opt"));
					});
					
					// 기타 추가
					$(".quesBacgr").on("click", ".addOther", function() {
						var thisEl = $(this).parents(".qstnForm");
						if (thisEl.find(".other").length > 0) {alert(SurveyMessages.strOneOther); return;}
						thisEl.find(".optPart").last().after(mkOpt("other"));
					});
					
					// 보기, 기타 삭제
					$(".quesBacgr").on("click", ".delImg", function() {
						var thisEl        = $(this);
						var optAreaLength = thisEl.parents(".qstnForm").find(".optArea").length;
						
						if (optAreaLength <= 2) {alert(SurveyMessages.strOptErr); return}
						
						// 삭제할 요소가 option인지 other인지 확인
						if (thisEl.parents(".optPart").length == 1) {
							thisEl.parents(".optPart").remove();
						}
						else {
							thisEl.parents(".other").remove();
						}
					});
					
					// matrix 행 추가
					$(".quesBacgr").on("click", ".addRow", function() {
						$(this).parents(".rowArea").find(".rows").append(mkRowCol("row"));
					});
					// matrix 열 추가
					$(".quesBacgr").on("click", ".addCol", function() {
						var cols = $(this).parents(".colArea").find(".cols");
						var colLength = cols.find(".col").length;
						
						if (colLength > 10) {alert(SurveyMessages.strColumnLm); return;}
						cols.append(mkRowCol("col"));
					});
					// matrix 행 삭제
					$(".quesBacgr").on("click", ".delRow", function(e) {
						var lowLength = $(this).closest(".rows").find(".row").length;
						if (lowLength <= 1) {alert(SurveyMessages.strMaxtrix1); return;}
						$(this).closest(".row").remove();
					});
					// matrix 열 삭제
					$(".quesBacgr").on("click", ".delCol", function() {
						var colLength = $(this).closest(".cols").find(".col").length;
						if (colLength <= 1) {alert(SurveyMessages.strMaxtrix2); return;}
						$(this).closest(".col").remove();
					});
					
					// 첨부파일 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".attImg", function() {
						var optArea = $(this).closest(".optArea");
						var li      = optArea.find(".fileList").find("li");
						if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
						optArea.find(".optionFile").click();
					});
					
					$(".quesBacgr").on("change", ".optionFile", function (e) {fileUpload(this);}); // 첨부파일 버튼 이벤트
					
					// 질문 생성 폼의 취소 버튼 클릭
					$(".quesBacgr").on("click", ".cancel", function() {
						var thisWrapper = $(this).closest(".qstnWrapper");
						thisWrapper.find(".quesDiv").find(".questnTitle").val(""); // 질문 내용 삭제
						clickXButton(thisWrapper);                                 // 첨부 파일 삭제
						setSelectBox(thisWrapper);                                 // 셀렉트 박스  내용 변경
						thisWrapper.find(".qstnForm").remove();                    // 질문 폼 삭제
					});
					
					// 저장 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".save", function() {mkQstnObj("save", $(this));});// 해당 질문의 객체 생성
					
					// 우상단 수정 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".modifyBtn", function() {
						var tmpQstnWpr  = $(this).parents(".usrQstnWrapper");
						var qstnWrapper = $(this).parents(".qstnWrapper");
						// 수정할 질문 id와 타입
						var qstnId      = parseInt(qstnWrapper.attr("id").replace("qstn", ""));
						var qstnType    = tmpQstnWpr.attr("qstntype");
						// 넘길 질문 객체
						var qstnList    = SurveyCreate.getQs();
						var qstn        = qstnList[qstnId - 1];
						
						createQuestionDiv(qstnWrapper, qstn);
						createQuestionSelectBox(qstn);
						setSelectBox(qstnWrapper, config["modify"], qstnType);
						handleModifyQuestion(qstnWrapper, qstn, config["modify"]);
						
						//수정을 취소할 경우를 고려해 숨김 처리
						qstnWrapper.css("display", "none");
					});
					
					// 우상단 복사 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".copyBtn", function() {
						var tmpQstnWpr  = $(this).parents(".usrQstnWrapper");
						var qstnWrapper = $(this).parents(".qstnWrapper");
						// 수정할 질문 id와 타입
						var qstnId      = parseInt(qstnWrapper.attr("id").replace("qstn", ""));
						var qstnType    = tmpQstnWpr.attr("qstntype");
						// 넘길 질문 객체
						var qstnList    = SurveyCreate.getQs();
						var qstn        = qstnList[qstnId - 1];
						var nextId      = qstnId + 1;
						var deepCopy    = JSON.parse(JSON.stringify(qstn));
						deepCopy.id     = nextId;
						
						// 복사한 질문 객체 이후의 객체들 아이디값 +1
						checkActionForNewId(qstnId, qstnList, "copy");
						
						// 복사한 질문 객체를 배열에 추가
						qstnList.splice(qstnId, 0, deepCopy);
						
						// 복사한 객체로 사용자용 질문폼 생성
						qstnWrapper.after("<div class='qstnWrapper' id='qstn" + nextId + "'></div>");
						mkQstnsByType(qstnWrapper.next(), qstnType, deepCopy);
					});
					
					// 우상단 삭제 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".deleteBtn", function() {
						var thisWrapper = $(this).parents(".qstnWrapper");
						var qstnId      = parseInt(thisWrapper.attr("id").replace("qstn", ""));
						var qstnList    = SurveyCreate.getQs();
						
						qstnList.splice(qstnId - 1, 1); // 질문 배열에서 해당 순번의 질문객체 삭제
						thisWrapper.remove();           // 질문 폼 삭제
						checkActionForNewId(qstnId, qstnList, "delete");
					});
					
					// 수정 버튼 클릭 이벤트 질문 객체 수정
					$(".quesBacgr").on("click", ".modify", function (e) {
						mkQstnObj(config["modify"], $(this));
					});
					
					// 수정 취소 버튼 클릭 이벤트 수정 폼 삭제
					$(".quesBacgr").on("click", ".mdfCancel", function() {
						var thisWrapper = $(this).parents(".qstnWrapper");
						thisWrapper.prev().css("display", ""); // 숨김 처리했던 사용자 폼 다시 보임 처리
						thisWrapper.remove();                  // 수정 폼 삭제
					});
					
					// 로직 폼 생성 버튼 이벤트
					$(".prevQsArea").on("click", ".addLogic", function() {
						var thisId = $(this).attr("id").replace("addLogic", "");
						
						mkLogicForm(thisId);
						
						$("#frstBtnGrp" + thisId).css("display", "none");
						$("#scndBtnGrp" + thisId).css("display", "");
						
					});
					
					// 로직 저장 버튼 이벤트
					$(".prevQsArea").on("click", ".saveLogic", function() {
						var id = parseInt($(this).attr("id").replace("saveLogic", ""));
						// 로직 flag 저장
						var qstnList = SurveyCreate.getQs();
						var qstn = qstnList[id - 1];
						var thisType = qstn.type;
						
						// 로직 추가, ui 변경
						switch(thisType) {
						case 1 :
						case 2 :
							addSltLogic(id, qstn);
							break;
						case 7:
							addSlidLogic(id, qstn);
							break;
						case 9:
							addDrdwLogic(id, qstn);
							break;
						}
						
						var logicFlag = qstn['logicFlag'];
						
						if (logicFlag == undefined) {
							qstn['logicFlag'] = 'Y';
						}
						
						$("#thrdBtnGrp" + id).siblings().css("display", "none");
						$("#thrdBtnGrp" + id).css("display", "");
					});
					
					// 로직 취소 버튼 이벤트
					$(".prevQsArea").on("click", ".cancelLogic", function() {
						var prevWrapper = $(this).parents(".prevQsWrapper");
						var type = parseInt(prevWrapper.attr("type"));
						var id = parseInt(prevWrapper.attr("id").replace("prevQstn", ""));
						
						// 로직 ui 변경
						if (type == 1 || type == 2) {
							var opt = prevWrapper.find(".opt");
							var optLength = opt.length;
							
							for (var i = 0; i < optLength; i++) {
								$("#logic" + id + i).remove();
							}

						} else if (type == 7 || type == 9) {
							$("#logic" + id).remove();
						}
						
						$("#frstBtnGrp" + id).siblings().css("display", "none");
						$("#frstBtnGrp" + id).css("display", "");
					});
					
					// 로직 수정 버튼 이벤트
					$(".prevQsArea").on("click", ".mdfLogic", function() {
						var id = parseInt($(this).attr("id").replace("mdfLogic", ""));
						// 로직 flag 저장
						var qstnList = SurveyCreate.getQs();
						var qstn = qstnList[id - 1];
						var type = qstn.type;
						
						// 로직 수정, ui 변경
						switch(type) {
						case 1 :
						case 2 :
							showSltLogicForm(id, qstn);
							break;
						case 7:
							showSlidLogicForm(id, qstn);
							break;
						case 9:
							showDrdwLogicForm(id, qstn);
							break;
						}
						$("#scndBtnGrp" + id).siblings().css("display", "none");
						$("#scndBtnGrp" + id).css("display", "");
					});
					
					
					// 로직 삭제 버튼 이벤트
					$(".prevQsArea").on("click", ".delLogic", function() {
						var id = parseInt($(this).attr("id").replace("delLogic", ""));
						
						var prevWrapper = $(this).parents(".prevQsWrapper");
						var type = parseInt(prevWrapper.attr("type"));
						
						var qstnList = SurveyCreate.getQs();
						var qstn = qstnList[id - 1];
						
						// 로직 삭제, ui 변경
						if (type == 1 || type == 2) {
							var opt = prevWrapper.find(".opt");
							var optLength = opt.length;
							
							for (var i = 0; i < optLength; i++) {
								qstn.option[i]['logic'] = undefined; 
								$("#logic" + id + i).remove();
							}
							
						} else if (type == 7) {
							qstn.option[0].logic = undefined;
							qstn.slidLogicPoint = undefined;
							$("#logic" + id).remove();
							
						} else if (type == 9) {
							var row = prevWrapper.find(".drdwLogicRow");
							var optLength = row.length;
							
							for (var i = 0; i < optLength; i++) {
								qstn.option[i]['logic'] = undefined; 
								$("#logic" + id + i).remove();
							}
							$("#logic" + id).remove();
						}
						qstn.logicFlag = undefined;
						
						$("#frstBtnGrp" + id).siblings().css("display", "none");
						$("#frstBtnGrp" + id).css("display", "");
					});
					
					$(".quesBacgr").on("input", ".slider-range", function() {
						var outputElmt         = this.parentElement.parentElement.querySelector("output[class='slider-output']");
						outputElmt.textContent = this.value;
					}).trigger("change");
					
					$(".quesBacgr").sortable({
						handle: ".mvBtn",
						cursor: "move",
						containment: "parent",
						tolerance: "pointer",
						axis: "y",
						update: function(event, ui) {
							
							var catchedWrapper = ui.item;
							var catchedQsId = parseInt(catchedWrapper.attr("id").replace("qstn", ""));
							var prevQsId = "";
							var nextQsId = "";
							var prev = catchedWrapper.prev();
							var next = catchedWrapper.next();
							
							if (prev.length != 0) {
								prevQsId = parseInt(prev.attr("id").replace("qstn", ""));
							}

							if (next.length != 0) {
								if (next.attr("id") != "") {
									nextQsId = parseInt(next.attr("id").replace("qstn", ""));
								}
							}
							
							var comparedQsId = "";
							var qstnList    = SurveyCreate.getQs();
							var catchedQsObj = qstnList[catchedQsId-1];
							var type = catchedQsObj["type"];
							
							if (nextQsId != "") {
								if (prevQsId != "") {
									if (prevQsId > catchedQsId && nextQsId > catchedQsId) {
										comparedQsId = prevQsId;
									} else {
										comparedQsId = nextQsId;
									}
								} else {
									comparedQsId = nextQsId;
								}
							} else {
								comparedQsId = prevQsId;
							}
							// drag & drop된 객체 이외의 객체 id 및 ui 변경
							checkActionForNewId(catchedQsId, qstnList, 'reOrder', comparedQsId);
							
							// drag & drop된 객체 아이디 변경
							catchedQsObj.id = comparedQsId;
							// 그 객체 복사
							var deepCopy    = JSON.parse(JSON.stringify(catchedQsObj));
							// 그 객체 삭제
							qstnList.splice(catchedQsId - 1, 1);
							// 그 객체 제자리에 끼워넣기
							qstnList.splice(comparedQsId - 1, 0, deepCopy);
							
							// 그 객체 ui 변경 작업
							catchedWrapper.html("");
							catchedWrapper.attr("id", "qstn" + comparedQsId);
							
							mkQstnsByType(catchedWrapper, type, deepCopy);
						}
					});
					
					$(".quesBacgr").on("click", ".delImage", function() {questionFile.deleteFile(this);});
					
					// 임시 이벤트
					$("#prevQsButton").click(function() {
						prevQstn();
					});
				}
				
				// 아이디 변경을 위한 action체크
				function checkActionForNewId(qstnId, qstnList, action, compareId) {
					
					if (action == "delete") {
						for (var i = qstnId - 1, len = qstnList.length; i < len; i++) {
							remkFormAfterSetNewId(qstnList[i], action);
						}
					} else if (action == "copy") {
						for (var i = qstnList.length - 1; i >= qstnId; i--) {
								remkFormAfterSetNewId(qstnList[i], action);
						}
					} else if (action == "reOrder") {
						// 아래에서 위으로 이동한 경우
						if (qstnId > compareId) {
							var result = 1;
							// 현 위치의 아래 id 객체부터 기존 위치의 바로 위 id객체까지 변경
							for (var i = qstnId - 2; i >= compareId - 1; i--) {
								remkFormAfterSetNewId(qstnList[i], action, result);
							}
						// 앞에서 뒤로 이동한 경우
						} else if(compareId > qstnId) {
							var result = -1;
							// 기존 위치의 바로 아래 id객체부터 현 위치의 위 id 객체까지 변경
							for (var i = qstnId; i < compareId; i++) {
								remkFormAfterSetNewId(qstnList[i], action, result);
							}
						}
					}
				}
				// 아이디 세팅 및 폼 변경
				function remkFormAfterSetNewId(qstn, action, result) {
					var oldId       = qstn["id"];
					var type        = qstn["type"];
					var newId       = "";
					var thisWrapper = "";
					
					if (action == "delete" || action == "reOrder" && result == -1) {
						newId             = oldId - 1;
					} else if (action == "copy" || action == "reOrder" && result == 1) {
						newId             = oldId + 1;
					}
					qstn["id"] = newId;
					
					// old id의 form 변경
					thisWrapper = $("#qstn" + oldId);
					thisWrapper.html("");
					thisWrapper.attr("id", "qstn" + newId);
					
					mkQstnsByType(thisWrapper, type, qstn);
				}
				
				// 사용자용 질문 폼 생성
				function mkQstnsByType(qstnWrapper, qstnType, question, prev) {
					var newQsDiv = makeQuestionHeaderPanel(question);
					var qsPanel  = newQsDiv.querySelector("div[class='question-panel']");
					qstnWrapper.appendChild(newQsDiv);
					
					switch(parseInt(qstnType)) {
						case 1  :
						case 2  : html += mkSelectQstn(question)             ; break;
						case 3  : 
						case 4  : html += mkMatrixQstn(question)             ; break;
						case 5  : html += mkTextQstn(question, "shortanswer"); break;
						case 6  : html += mkTextQstn(question, "paragraph")  ; break;
						case 7  : html += mkSliderQstn(question)             ; break;
						case 8  : html += mkRankingQstn(question)            ; break;
						case 9  : html += mkDropDownQstn(question)           ; break;
						default : alert(SurveyMessages.strError)                  ; return;
					}
					
					qstnWrapper.prepend(html);
				}
				// 첨부파일의 x버튼 클릭
				function clickXButton(thisWrapper) {
					var li = thisWrapper.find(".fileList").find("li");
					
					if (li) {
						for (var i = 0, len = li.length; i < len; i++) {
							li[i].childNodes[0].childNodes[0].click();
						}
					}
				}
				
				// 설문 작성 취소, 수정시 셀렉트 박스 내용 변경
				function setSelectBox(thisWrapper, modify, qstnType) {
					var ddSelected = ""; // dd-selected 태그의 html 제거 후 내용 변경 
					
					if (modify) {
						ddSelected  = thisWrapper.next().find(".dd-selected").html("");
						var optData = optionData[parseInt(qstnType - 1)];
						var text    = optData.text;
						var img     = optData.imageSrc;
						var html    = "<img class='dd-selected-image' src='" + img + "'>";
						html       += "<label class='dd-selected-text'>" + text + "</label>";
						ddSelected.append(html);
					}
					else {
						ddSelected = thisWrapper.find(".dd-selected").html("");
						ddSelected[0].innerText = SurveyMessages.strQselect;
					}
				}
				// 생성된 질문을 붙일 부분과 질문 유형을 파라미터로 받아 질문 영역 생성
				function handleModifyQuestion(qstnWrapper, question, mode) {
					var qstType = question.type;
					var html    = makeQuestionForm(qstType);
					
					switch(parseInt(qstType)) {
						case 1  :
						case 2  : html += handleModifySelectQuestion(question)                 ; break;
						case 3  : 
						case 4  : html += handleModifyMatrixQuestion(question)                 ; break;
						case 5  : html += handleModifyTextQuesion("shortanswer", "make")       ; break;
						case 6  : html += handleModifyTextQuesion("paragraph"  , "make")       ; break;
						case 7  : html += handleModifySliderQuesion(question)                  ; break;
						case 8  : html += handleModifyRankDropDownQuesion("ranking" , question); break;
						case 9  : html += handleModifyRankDropDownQuesion("dropdown", question); break;
						default : alert(SurveyMessages.strError)                               ; return;
					}
					
					html += mkAddtionalPart(mode, question.required);
					
					qstnWrapper.next().append(html);
				}
				// 수정시 새로 생성하는 선택질문
				function handleModifySelectQuestion(question) {
					var htmlTxt = "";
					
					if (question) {
						var opts    = question.option;
						var options = opts.filter(function(opt) {return opt["otherFlag"] == 0;});
						var others  = opts.filter(function(opt) {return opt["otherFlag"] == 1;});
						var other   = (others && others.length > 0) ? others[0] : null;
						
						if (options) {
							for (var i = 0, len = options.length; i < len; i++) {
								htmlTxt += mkOpt("opt", options[i]);
							}
						}
						
						if (other) {htmlTxt += mkOpt("other", other);}
					}
					else {
						for (var i = 0; i < 2; i++) {
							htmlTxt += mkOpt("opt");
						}
					}
					
					htmlTxt += "<div class='addBtns'>";
					htmlTxt += "<button class='addOpt'>" + SurveyMessages.strAdd + "</button>";
					htmlTxt += "<button class='addOther'>" + SurveyMessages.strAddOther + "</button>";
					htmlTxt += "</div>";
					
					return htmlTxt;
				}
				
				// 수정시 새로 생성하는 행렬질문 
				function handleModifyMatrixQuestion(question) {
					var html = "";
					var row  = null;
					var col  = null;
					
					if (question) {
						var options = question["option"];
						row         = options.filter(function(row) {return row["colLevel"] == -1;});
						col         = options.filter(function(col) {return col["rowLevel"] == -1;});
					}
					
					html += "<div class='mtrPart'>";
					html += "<div class='rowArea'>";
					html += "<div class='rName'>";
					html += "<span>" + SurveyMessages.strRow + "</span>";
					html += "</div>";
					html += "<div class='rows'>";
					
					if (row) {
						for (var i = 0; i < row.length; i++) {
							html += mkRowCol("row", row[i]);
						}
					}
					else {
						for (var i = 0; i < 2; i++) {
							html += mkRowCol("row");
						}
					}
					
					html += "</div>";
					html += "<div class='rowBtn'>";
					html += "<button class='addRow'>" + SurveyMessages.strAdd + "</button>";
					html += "</div></div>";
					html += "<div class='colArea'>";
					html += "<div class='cName'>";
					html += "<span>" + SurveyMessages.strColumn + "</span>";
					html += "</div>";
					html += "<div class='cols'>";
					
					if (col) {
						for (var i = 0; i < col.length; i++) {
							html += mkRowCol("col", col[i]);
						}
					}
					else {
						for (var i = 0; i < 2; i++) {
							html += mkRowCol("col");
						}
					}
					
					html += "</div>";
					html += "<div class='colBtn'>";
					html += "<button class='addCol'>" + SurveyMessages.strAdd + "</button>";
					html += "</div></div></div>";
					
					return html;
				}
				
				function handleModifyTextQuesion(type, mode) {
					var className = mode == "make" ? type + "-wrap" : "question-" + type;
					var htmlTxt   = "<div class='" + className + "'>";
					
					if (type == "paragraph") {
						htmlTxt  += "<textarea class='" + type +"' maxlength='500' placeholder='" + SurveyMessages.strContent + "'></textarea>";
					}
					else {
						htmlTxt  += "<input class='" + type +"' maxlength='80' placeholder='" + SurveyMessages.strContent + "'/>";
					}
					
					htmlTxt += "</div>";
					return htmlTxt;
				}
				
				function handleModifySliderQuesion(question) {
					var htmlTxt = "";
					var lowest  = "";
					var highest = "";
					
					if (question) {
						var options = question.option;
						lowest      = options.filter(function(val) {return val["level"] == 0;})[0]["content"];
						highest     = options.filter(function(val) {return val["level"] == 1;})[0]["content"];
					}
					
					htmlTxt    += "<div class='silder-wrap'>";
					htmlTxt    += "<input type='input' class='slider-lw' value='" + lowest  + "'/>";
					htmlTxt    += "<input type='range' class='slider-main'/>";
					htmlTxt    += "<input type='input' class='slider-up' value='" + highest + "'/>";
					htmlTxt    += "</div>";
					return htmlTxt;
				}
				
				function handleModifyRankDropDownQuesion(type, question) {
					var htmlTxt = "<div class='" + type + "-wrap'>";
					
					if (question) {
						var optionList = question["option"];
						
						for (var i = 0, len = optionList.length; i < len; i++) {
							htmlTxt += mkOptions(type, i + 1, optionList[i]["content"]);
						}
					}
					else {
						for (var i = 0; i < 3; i++) {
							htmlTxt += mkOptions(type, i + 1, "");
						}
					}
					
					htmlTxt += "<div class='addBtns'>";
					htmlTxt += "<button class='addOpttions'>" + SurveyMessages.strAdd + "</button>";
					htmlTxt += "</div></div>";
					return htmlTxt;
				}
				
				// 첨부파일 있을 시 태그 생성
				function mkImgTag(qstnAtt) {
					if (!qstnAtt) {return "";}
					return questionFile.mkImgTag(qstnAtt);
				}
				
				// option 첨부파일 업로드
				function fileUpload(thisEl) {
					questionFile.upload(thisEl);
				}
				
				// 설문 생성 폼 삭제
				function rmQstnForm(wrapper) {
					//question input 및 selectBox 제거
					wrapper.find(".quesDiv").remove();
					wrapper.find(".qstnForm").remove();
				}
				
				// 단일선택 질문 생성 
				function mkSelectQstn(question) {
					var totalOptions = question.option;
					var options      = totalOptions.filter(function(opt) {return opt["otherFlag"] == 0;});
					var others       = totalOptions.filter(function(opt) {return opt["otherFlag"] == 1;});
					var other        = (others && others.length > 0) ? others[0] : null;
					var qstnType     = question.type;
					var html         = "";
					html            += "<div class='question-opts'>";
					var divOpts       = document.createElement("div");
					divOpts.className = "question-opts";
					
					// 보기
					if (options) {
						for (var i = 0; i < options.length; i++) {
							html += "<div class='opt' level='" + options[i].level + "'>";
							
							if (qstnType == 2) {
								html += "<input class='optChb' type='checkbox' value='" + options[i].level + "'/>";
							}
							else {
								html += "<input class='optRdo' type='radio' value='" + options[i].level + "'/>";
							}
							
							// 첨부파일이 있는지 확인
							html          += options[i]["attach"]  ? "<img alt='' src='" + options[i]["attach"].fpath + "' class='optImg'>" : "";
							var optContent = options[i]["content"] ? options[i]["content"] : "";
							html          += "<span class='optSpan'>" + optContent + "</span>";
							html          += "</div>";
						}
					}
					
					// 기타
					if (other) {
						html += "<div class='opt'>";
						
						if (qstnType == 2) {
							html += "<input class='optChb' type='checkbox' value='" + other.level + "'/>";
						}
						else {
							html += "<input class='optRdo' type='radio' value='" + other.level + "'/>";
						}
						
						html += other["attach"] ? "<img alt='' src='" + other["attach"].fpath + "' class='optImg'>" : ""; // 첨부파일이 있는지 확인
						html += "<span class='optSpan'>" + other["content"] + "</span>";
						html += "<input class='othInput' type='text'/>";
						html += "</div></div>";
					}
					
					html += "</div>";
					return html;
				}
				
				function mkMatrixQstn(question) {
					var inpType  = question.type == 3 ? "radio" : "checkbox";
					var opts     = question["option"];
					var col      = opts.filter(function(col) {return col["rowLevel"] == -1;});
					var row      = opts.filter(function(row) {return row["colLevel"] == -1;});
					
					var html  = "";
						html += "<div class='question-opts'>";
						html += "<table class='matrix'>";
						html += "<thead>";
						html += "<tr>";
						html += "<td></td>";
						
					for (var i = 0; i < col.length; i++) {
						html += "<td>" + col[i]["content"] + "</td>";
					}
					
					html += "</tr>";
					html += "</thead>";
					html += "<tbody>";
					
					for (var i = 0; i < row.length; i++) {
						html += "<tr>";
						html += "<td>" + row[i]["content"] + "</td>";
						
						for (var j = 0; j < col.length; j++) {
							html += "<td><input type='" + inpType + "' value='(" + row[i]["rowLevel"] + ", " + col[j]["colLevel"] + ")'></td>";
						}
						
						html += "</tr>";
					}
					
					html += "</tbody>";
					html += "</table>";
					html += "</div>";
					
					return html;
				}
				
				function rmPrevEl(wrapperElmt) {wrapperElmt.prev().remove();}
				
				// 질문 객체 생성
				function mkQstnObj(status, thisEl) {
					var question     = {};
					var qstnWrapper  = thisEl.parents(".qstnWrapper");
					var qstnArea     = qstnWrapper.find(".quesDiv");
					var qstnContent  = qstnArea.find(".questnTitle").val();
					var questionList = SurveyCreate.getQs();
					
					//Save common question information
					if (!qstnContent) {alert(SurveyMessages.strQsContent); return;}
					
					question["content"]  = qstnContent;
					var qstnForm         = qstnWrapper.find(".quesDiv").next();
					var qstnType         = qstnForm.attr("questiontype");
					question["type"]     = parseInt(qstnType);
					var rqrd             = qstnForm.find(".additionalPart").find("input[name='checkbox']");
					question[config["required"]] = rqrd.is(":checked") == true ? "Y" : "N";
					
					//Check question attach files
					var qstnFObj = qstnArea.find(".qstnFileInfo")[0].childNodes[0].childNodes[0].childNodes[0];
					if (qstnFObj) {question["attach"]  = getAttachFileInfo(qstnFObj);}
					
					//Question order
					var qstId      = qstnWrapper.attr("id") ? parseInt(qstnWrapper.attr("id")) : questionList.length + 1;
					question["id"] = qstId;
					//Set id
					qstnWrapper.attr("id", "qstn" + qstId);
					
					var html       = makeQuestionHeaderPanel(question);
					
					switch(parseInt(qstnType)) {
						case 1  :
						case 2  : var sltObj = mkSltObj(qstnForm);
								  if (sltObj.error)  {alert(SurveyMessages[sltObj.error]); return;}
								  if (sltObj.option) {question["option"] = sltObj.option;}
								  html += mkSelectQstn(question); 
								  break;
						case 3  : 
						case 4  : var mtrObj = mkMtrObj(qstnForm);
								  if (mtrObj.error)  {alert(SurveyMessages[mtrObj.error]); return;}
								  if (mtrObj.option) {question["option"] = mtrObj.option;}
								  html += mkMatrixQstn(question); break;
						case 5  : var shortAnswerObj = mkTxtObj();
								  question["option"] = shortAnswerObj.option;
								  html += mkTextQstn(question, "shortanswer"); break;
						case 6  : var paragraphObj   = mkTxtObj();
								  question["option"] = paragraphObj.option;
								  html += mkTextQstn(question, "paragraph"  ); break;
						case 7  : var sliderObj = mkSliderObj(qstnForm[0]);
								  if (sliderObj.error) {alert(SurveyMessages[sliderObj.error]); return;}
								  if (sliderObj.option) {question["option"] = sliderObj.option;}
								  html += mkSliderQstn(question); break;
						case 8  : var rankingObj = mkRankingDropDownObj("ranking", qstnForm);
								  if (rankingObj.error) {alert(SurveyMessages[rankingObj.error]); return;}
								  question["option"] = rankingObj.option;
								  html += mkRankingQstn(question); break;
						case 9  : var dropDownObj = mkRankingDropDownObj("dropdown", qstnForm);
								  if (dropDownObj.error) {alert(SurveyMessages[rankingObj.error]); return;}
								  question["option"] = dropDownObj.option;
								  html += mkDropDownQstn(question); break;
						default : alert(SurveyMessages.strError); return;
					}
					qstnWrapper.prepend(html);
					
					rmQstnForm(qstnWrapper);
					
					if (status == "save") {
						createQuestionDiv();
						createQuestionSelectBox();
						SurveyCreate.setQs(question);
					}
					else if (status == config["modify"]) {
						rmPrevEl(qstnWrapper);
						questionList.splice(qstId - 1, 1);           // 질문 배열에서 해당 순번의 객체 삭제
						questionList.splice(qstId - 1, 0, question); // 질문 배열에 해당 순번에 추가
					}
				}
				
				function mkTextQstn(question, type) {
					var html = handleModifyTextQuesion(type, config["modify"]);
					return html;
				}
				
				function mkSliderQstn(question) {
					var options = question.option;
					var lowest  = options.filter(function(val) {return val["level"] == 0;})[0]["content"];
					var highest = options.filter(function(val) {return val["level"] == 1;})[0]["content"];
					var html    = "";
					html    += "<div class='question-silder'>";
					html    += "<div class='silder-wrap'>";
					html    += "<span>" + lowest + "</span>";
					html    += "<input type='range' class='slider-range' name='slider" + question.id + "' min='" + lowest + "' max='" + highest + "'/>";
					html    += "<span>" + highest + "</span>";
					html    += "</div>";
					html    += "<output for='slider" + question.id + "' class='slider-output'></output>";
					html    += "</div>";
					
					return html;
				}
				
				function mkRankingQstn(question) {
					var options = question["option"];
					var html    = "";
					html       += "<div class='question-ranking'>";
					html       += "<div class='ranking-wrap'>";
					var strSlct = "<select>";
					strSlct    += "<option selected>" + SurveyMessages.strSelect + "</option>";
					
					for (var j = 0, len = options.length; j < len; j++) {
						strSlct += "<option>" + options[j]["content"] + "</option>";
					}
					
					strSlct += "</select>";
					
					for (var i = 0, len = options.length; i < len; i++) {
						html += "<div class='ranking-select'>";
						html += "<span class='rank-order'>" + (i + 1) + ".</span>";
						html += strSlct;
						html += "</div>";
					}
					
					html += "</div></div>";
					return html;
				}
				
				function mkDropDownQstn(question) {
					var options = question["option"];
					var html    = "";
					html       += "<div class='question-dropdown'>";
					html       += "<div class='dropdown-wrap'>";
					html       += "<select>";
					html       += "<option selected>" + SurveyMessages.strSelect + "</option>";
					
					for (var j = 0, len = options.length; j < len; j++) {
						html += "<option>" + options[j]["content"] + "</option>";
					}
					
					html += "</select>";
					html += "</div></div>";
					return html;
				}
				
				function makeQuestionHeaderPanel(question) {
					var qstId         = question.id;
					var content       = question.content;
					var qstnType      = question.type;
					var required      = question.required;
					var qstnAtt       = question.attach;
					var wrapDiv       = document.createElement("div");
					var divPanel      = document.createElement("div");
					var moveBttn      = document.createElement("div");
					var divHeader     = document.createElement("div");
					var divQsContent  = document.createElement("div");
					var divTools      = document.createElement("div");
					var modSpan       = document.createElement("span");
					var copSpan       = document.createElement("span");
					var delSpan       = document.createElement("span");
					
					//question content process
					divQsContent.textContent = qstId + ". " + content;
					divQsContent.className   = "question-content";
					
					if (required == "Y") {
						var strongElmt         = document.createElement("strong");
						strongElmt.className   = "imptt";
						strongElmt.textContent = "*";
						divQsContent.appendChild(strongElmt);
					}
					
					//Tools div process
					modSpan.className   = "modifyBtn";
					copSpan.className   = "copyBtn";
					delSpan.className   = "deleteBtn";
					divTools.className  = "tooltip-bttns";
					divHeader.className = "question-header";
					divTools.appendChild(modSpan);
					divTools.appendChild(copSpan);
					divTools.appendChild(delSpan);
					divHeader.appendChild(divQsContent);
					divHeader.appendChild(divTools);
					divPanel.appendChild(moveBttn);
					divPanel.appendChild(divHeader);
					
					if (qstnAtt) {
						var attDiv       = document.createElement("div");
						var attImg       = document.createElement("img");
						attImg.src       = qstnAtt["fpath"];
						attImg.className = "qstnImg";
						attDiv.className = "question-attach";
						attDiv.appendChild(attImg);
						divPanel.appendChild(attDiv);
					}
					
					moveBttn.className = "mvBtn";
					divPanel.className = "question-panel";
					wrapDiv.className  = "usrQstnWrapper";
					wrapDiv.setAttribute("qstnType", qstnType);
					wrapDiv.appendChild(divPanel);
					
					return wrapDiv;
				}
				
				function mkRankingDropDownObj(type, qstnForm) {
					var returnObj = {};
					var optList   = qstnForm.find("." + type + "-select");
					var optCnt    = optList.length;
					var option    = [];
					
					for (var i = 0; i < optCnt; i++) {
						var optObj   = {};
						var optValue = optList[i].querySelector("input[class='textInput']").value;
						
						if (optValue) {
							optObj["content"] = optValue;
							optObj["level"]   = i;
							option.push(optObj);
						}
					}
					
					if (option.length < 2) {returnObj['error'] = "strOptErr"; return returnObj;}
					
					returnObj["option"] = option;
					return returnObj;
				}
				
				function mkTxtObj() {
					var textObj = {};
					var option  = [];
					option.push({content : "", level : 0});
					textObj["option"] = option;
					return textObj;
				}
				
				function mkSliderObj(qstnForm) {
					var sliderObj    = {};
					var lowestInput  = qstnForm.querySelector("input[class='slider-lw']");
					var highestInput = qstnForm.querySelector("input[class='slider-up']");
					var lowestValue  = lowestInput  ? parseInt(lowestInput.value)  : -1;
					var highestValue = highestInput ? parseInt(highestInput.value) : -1;
					
					//Check slider requirements
					if (!isValid(lowestValue))       {sliderObj.error = "strSlider1"; return sliderObj;}
					if (!isValid(highestValue))      {sliderObj.error = "strSlider2"; return sliderObj;}
					if (lowestValue >= highestValue) {sliderObj.error = "strSlider3"; return sliderObj;}
					
					var option = [];
					option.push({content : lowestValue, level : 0});
					option.push({content : highestValue, level : 1});
					
					sliderObj["option"]  = option;
					return sliderObj;
				}
				
				// select 질문 객체 생성
				function mkSltObj(qstnForm) {
					var sltObj   = {};
					var opt      = qstnForm.find(".optPart");
					var oth      = qstnForm.find(".other");
					var optCnt   = opt.length;
					var option   = [];
					
					// 보기의 개수 확인
					if (optCnt > 0) {
						for (var i = 0; i < optCnt; i++) {
							var optVal = opt[i].childNodes[0].childNodes[0].childNodes[0].value; // 보기가 비어있는지 확인
							var fObj   = opt[i].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
							
							if (optVal || fObj) {
								var optObj          = {};
								optObj["level"]     = option.length;
								optObj["otherFlag"] = 0;
								
								if (optVal) {optObj["content"] = optVal                 ;}
								if (fObj)   {optObj["attach"]  = getAttachFileInfo(fObj);}
								
								option.push(optObj);
							}
						}
					}
					
					// 기타의 유무 확인
					if (oth.length != 0) {
						var other          = {};
						var othVal         = oth[0].childNodes[0].childNodes[0].childNodes[0].value;
						var othObj         = oth[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
						other["content"]   = othVal ? othVal : SurveyMessages.strOther;
						other["otherFlag"] = 1;
						other["level"]     = option.length;
						
						if (othObj) {other["attach"] = getAttachFileInfo(othObj);}
						
						option.push(other);
					}
					
					if (option.length < 2) {sltObj["error"] = "strOptErr";}
					
					sltObj["option"] = option;
					return sltObj;
				}
				
				// matrix 질문 객체 생성
				function mkMtrObj(qstnForm) {
					var rows   = qstnForm.find(".row");
					var cols   = qstnForm.find(".col");
					var mtrObj = {};
					var option = [];
					
					if (rows) {
						var row = [];
						
						for (var i = 0, len = rows.length; i < len; i++) {
							var rowObj = {};
							var rowVal = rows[i].childNodes[0].value;
							
							if (rowVal) {
								rowObj["colLevel"] = -1;
								rowObj["rowLevel"] = row.length;
								rowObj["content"]  = rowVal;
								row.push(rowObj);
							}
						}
						
						if (row.length == 0) {mtrObj["error"] = "strMaxtrix1"; return mtrObj;}
						Array.prototype.push.apply(option, row);
					}
					
					if (cols) {
						var col = [];
						
						for (var i = 0, len = cols.length; i < len; i++) {
							var colObj = {};
							var colVal = cols[i].childNodes[0].value;
							
							if (colVal) {
								colObj["colLevel"] = col.length;
								colObj["rowLevel"] = -1;
								colObj["content"]  = colVal;
								col.push(colObj);
							}
						}
						
						if (col.length == 0) {mtrObj["error"] = "strMaxtrix2"; return mtrObj;}
						Array.prototype.push.apply(option, col);
					}
					
					mtrObj["option"] = option;
					return mtrObj;
				}
				
				// make ranking/dropdown options
				function mkOptions(type, order, content) {
					var html  = "<div class='" + type + "-select'>";
					html     += "<span class='" + type + "-order'>" + order + "</span>";
					html     += "<input class='textInput' type='text' value='" + content + "' placeholder='" + SurveyMessages.strContent + "'/>";
					html     += "<span class='delOption'></span>";
					html     += "</div>";
					return html;
				}
				
				// selection 질문의 보기 생성
				function mkOpt(type, options) {
					var optAtt = "";
					var attEl  = "";
					var html   = "<div class='optArea'>";
						html  += "<div class='option'>";
						
					if (type == "other") {
						html = "<div class='other'>" + html;
						
						if (options) {
							html  += "<input class='textInput' type='text' value='" + options["content"] + "' maxlength='40' placeholder='" + SurveyMessages.strOther + "'/>";
							optAtt = options["attach"];
						}
						else {
							html += "<input class='textInput' type='text' maxlength='40' placeholder='" + SurveyMessages.strOther + "'>";
						}
					}
					else {
						html = "<div class='optPart'>" + html;
						
						if (options) {
							html  += "<input class='textInput' type='text' value='" + options["content"] + "' maxlength='40' placeholder='" + SurveyMessages.strContent + "' />";
							optAtt = options["attach"];
						}
						else {
							html += "<input class='textInput' type='text' maxlength='40' placeholder='" + SurveyMessages.strContent + "'/>";
						}
					}
					
					html += "<img src='/images/ezSurvey/attach.png' class='attImg'>";
					html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
					html += "</div>";
					html += "<div class='optFileInfo'>";
					html += "<div class='fileList'>";
					
					if (optAtt) {attEl = mkImgTag(optAtt);}
					
					html += "<ul class='optUl'>" + attEl + "</ul>";
					html += "<input type='file' class='optionFile' accept='image/*'/>";
					html += "</div></div></div></div>";
					
					return html;
				}
				
				// 행렬 질문의 row, col 생성
				function mkRowCol(type, elment) {
					var content = "";
					var level   = "";
					var elClass = type == "row" ? "delRow" : "delCol";
					
					if (elment) {
						level   = elment["level"];
						content = elment["content"];
					}
					
					var html = "<div class='" + type + "' level='" + level + "'>";
						html += "<input class='" + type + "Input' maxlength='33' value='" + content + "'>";
						html += "<img alt='' src='/images/ezSurvey/minus.jpg' class='" + elClass + "' style='width: 30px;height: 30px; cursor: pointer;'>";
						html += "</div>";
						
					return html;
				}
				
				// 필수, 저장, 수정, 취소 버튼 생성
				function mkAddtionalPart(action, required) {
					var html = "<div class='additionalPart'>";
						html += "<div class='required'>";
						html += required == 'Y' ? "<input type='checkbox' name='checkbox' checked='checked'>" : "<input type='checkbox' name='checkbox'>";
						html += "<strong>" + SurveyMessages.strRequired + "</strong>";
						html += "</div>";
						html += "<div class='btns'>";
						
					if (action == config["modify"]) {
						html += "<button class='modify'>" + SurveyMessages.strModify + "</button>";
						html += "<button class='mdfCancel'>" + SurveyMessages.strCancel + "</button>";
					}
					else {
						html += "<button class='save'>" + SurveyMessages.strSaveTxt + "</button>";
						html += "<button class='cancel'>" + SurveyMessages.strCancel + "</button>";
					}
					
					html += "</div>";
					return html;
				}
				
				function makeQuestionForm(questionType) {return "<div class='qstnForm' questionType='" + questionType + "'>";}
				
				function makeTextQuestion(mainDivElmt, questionType, type, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifyTextQuesion(type, "make");
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					
					mainDivElmt.append(html);
				}
				
				function makeSliderQuestion(mainDivElmt, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifySliderQuesion();
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					
					mainDivElmt.append(html);
				}
				
				function makeRankingQuestion(mainDivElmt, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifyRankDropDownQuesion("ranking");
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					
					mainDivElmt.append(html);
				}
				
				function makeDropdownQuestion(mainDivElmt, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifyRankDropDownQuesion("dropdown");
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					
					mainDivElmt.append(html);
				}
				
				function getAttachFileInfo(elmtObj) {
					var attchObj      = {};
					attchObj["fname"] = elmtObj.getAttribute("fname");
					attchObj["fpath"] = elmtObj.getAttribute("path");
					return attchObj;
				}
				
				function isValid(value) {if (!isNaN(value) && parseFloat(value) >= 0 && value % 1 === 0) {return true;} else {return false;}}
				
				// 미리보기 질문 폼 생성
				function prevQstn() {
					$(".prevQsArea").html("");
					
					var qstnList = SurveyCreate.getQs();
					var qstInf   = SurveyCreate.getInfo();
					confirmSurveyInfo(qstInf);
					
					if (qstnList.length != 0) {
						for (var i = 0; i < qstnList.length; i++) {
							var html = "";
							var question = qstnList[i];
							var qstnId = question.id;
							var qstnType = question.type;
							html += "<div class='prevQsWrapper' id='prevQstn" + qstnId + "'type='" + qstnType + "'>";
							
							html += prevQsHeader(question, qstnList);
							
							html += "<div class='prevQsOpt'>";
							switch(parseInt(qstnType)) {
								case 1  :
								case 2  : html += mkSelectQstn(question)             ; break;
								case 3  : 
								case 4  : html += mkMatrixQstn(question)             ; break;
								case 5  : html += mkTextQstn(question, "shortanswer"); break;
								case 6  : html += mkTextQstn(question, "paragraph")  ; break;
								case 7  : html += mkSliderQstn(question)             ; break;
								case 8  : html += mkRankingQstn(question)            ; break;
								case 9  : html += mkDropDownQstn(question)           ; break;
								default : alert(SurveyMessages.strError)             ; return;
							}
							html += "</div></div>";

							$(".prevQsArea").append(html);
							
							if (question.logicFlag == 'Y') {
								mkLogicForm(qstnId);
							}
						}
					}
				}
				
				// 미리보기 질문의 헤더
				function prevQsHeader(question, qstnList) {
					var qstId    = question.id;
					var content  = question.content;
					var qstnType = question.type;
					var required = question.required;
					var qstnAtt  = question.attach;
					
					var html = "<div class='prevQsContent'>";
					html += "<div class='question-panel'>";
					html += "<div class='question-header'>";
					html += "<div class='question-content'>" + qstId + ". " + content;

					if (required == 'Y') {
						html += "<strong class='imptt'>*</strong>";
					}
					if (qstId < qstnList.length) {
						if (qstnType == 1 || qstnType == 2 || qstnType == 7 || qstnType == 9) {
							html += "<span id='frstBtnGrp" + qstId + "' class='frstBtnGrp'>"
							html += "<img id='addLogic" + qstId + "' class='addLogic' src='/images/ezSurvey/shuffle.png'/>";
							html += "</span>"
							
							html += "<span id='scndBtnGrp" + qstId + "' class='scndBtnGrp' style='display:none;'>"
							html += "<img id='saveLogic" + qstId + "' class='saveLogic' src='/images/ezSurvey/save.png'/>";
							html += "<img id='cancelLogic" + qstId + "' class='cancelLogic' src='/images/ezSurvey/xBtn.png' />";
							html += "</span>"
							
							html += "<span id='thrdBtnGrp" + qstId + "' class='thrdBtnGrp' style='display:none;'>"
							html += "<img id='mdfLogic" + qstId + "' class='mdfLogic' src='/images/ezSurvey/correct.png'/>";
							html += "<img id='delLogic" + qstId + "' class='delLogic' src='/images/ezSurvey/trash.png'/>";
							html += "</span>"
						}
					}
					html += "</div></div></div></div>";
					
					if (qstnAtt) {
						html += "<div class='question-attach'>"
						html += "<img alt='' src='" + qstnAtt.fpath + "' class='qstnImg'>";
						html += "</div>"
					}
					return html;
				}
				
				// 로직 폼 생성
				function mkLogicForm(id) {
					var prevWrapper = $("#prevQstn" + id);
					
					var qstnList = SurveyCreate.getQs();
					var thisQstn = qstnList[id - 1];
					var type = thisQstn.type;
					
					var htmlOption = "";
					htmlOption += "<option value=''>" + SurveyMessages.strNoLogic + "</option>"; 
					
					for (var i = 0; i < qstnList.length; i++) {
						var qstnId = qstnList[i]['id'];
						if (qstnId > id) {
							htmlOption += "<option value='" + qstnId + "'>" + qstnId + "</option>"; 
						}
					}
					
					switch(type) {
					case 1 :
					case 2 :
						sltLogicForm(prevWrapper, htmlOption, thisQstn, id);
						break;
					case 7:
						slidLogicForm(prevWrapper, htmlOption, thisQstn, id);
						break;
					case 9:
						drdwLogicForm(prevWrapper, htmlOption, thisQstn, id);
						break;
					}
				}
				
				// select 질문에 logic form 추가
				function sltLogicForm(prevWrapper, htmlOption, question, qstnId) {
					var id = "";
					var logicNum = "";
					var logic = "";

					var qstnOpt = question.option;
					var opts = prevWrapper.find(".prevQsOpt").find(".opt");
					var optLength = opts.length;
					
					if (qstnId) {
						id = qstnId;
					}

					for (var i = 0; i < optLength; i++) {
						var optLevel = qstnOpt[i].level;
	
						var html = "";
						html += "<div id='logic" + id + optLevel + "' class='sltLogicArea'>";
						html += "<img class='prevSltArrow' src='/images/ezSurvey/arrow.png'>";
						html += "<select class='logicSelect' name='slt" + id + optLevel + "' id='slt" + id + optLevel + "'>";
						html += htmlOption;
						html += "</select>";
						html += "<span class='logicSpan' id='sltVal" + id + i + "'></span>";
						html += "</div>";
						
						var opt = opts[i];
						opt.append($(html)[0]);
						
						if (question.logicFlag == 'Y') {
							$("#frstBtnGrp" + id).css("display", "none");
							$("#thrdBtnGrp" + id).css("display", "");
							
							logicNum = qstnOpt[i].logic;
							
							if (logicNum != "") {
								logic = SurveyMessages.strQs + " " + logicNum; 
							}
							$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "none");
							$("#sltVal" + id + i).text(logic).css("dispaly", "");
						}
					}
				}
				// slider 질문에 logic form 추가
				function slidLogicForm(prevWrapper, htmlOption, question, qstnId) {
					var id = "";
					var qstnOpt = question.option;
					var prevQsOpt = prevWrapper.find(".prevQsOpt");
					var logicPoint = "";
					
					if (qstnId) {
						id = qstnId;
						logicPoint = question.option[0]['logic'];
					}
					
					var minVal = "";
					var maxVal = "";

					for (var i = 0; i < qstnOpt.length; i++) {
						if (i == 0) {
							minVal = qstnOpt[0].content;
						} else {
							maxVal = qstnOpt[1].content;
						}
					}
					
					var html = "";
						html += "<div id='logic" + id + "' class='slidLogicArea'>";
						html += "<input id='slidLogicInput" + id + "' class='prevSlidInput' type='text'>";
						html += "<span id='LogicPoint" + id + "' class='logicSpan'></span>";
						html += "<span class='logicSpan'>" + SurveyMessages.strMore + "</span>";
						html += "<img class='prevSlidArrow' src='/images/ezSurvey/arrow.png'>";
						html += "<select id='slt" + id + "' class='logicSelect' name='slt" + id + "'>";
						html += htmlOption;
						html += "</select>";
						html += "<span class='logicSpan' id='sltVal" + id + "'></span>";
						html += "</div>";
					
					prevQsOpt.append($(html)[0]);
					
					if (question.logicFlag == 'Y') {
						logicNum = qstnOpt[0].logic;
						logic = (logicNum != "") ? SurveyMessages.strQs + " " + logicNum : "";
						
						$("#frstBtnGrp" + id).css("display", "none");
						$("#thrdBtnGrp" + id).css("display", "");
						
						$("#slidLogicInput" + id).val(logicPoint).css("display", "none");
						$("#LogicPoint" + id).text(logicPoint).css("display", "");
						
						$("#slt" + id).val(logicNum).prop("selected", true).css("display", "none");
						$("#sltVal" + id).text(logic).css("dispaly", "");
					}
				}
				
				// 로직 들어갈 시 이상해짐
				/* function rankQsLogic(prevWrapper, option) {
					var prevQsOpt = prevWrapper.find(".prevQsOpt");
					var rankingSelect = prevQsOpt.find(".ranking-select");
					var rankingLength = rankingSelect.length;
					
					for (var i = 0; i < rankingLength; i++) {
						var rkSelect = rankingSelect[i];
						var selectBox = $("<select class='logicSelect'></select>");
						
						selectBox.html(option);
						rkSelect.append(selectBox[0]);
					}
					
				} */
				
				// dropdown 질문에 logic form 추가
				function drdwLogicForm(prevWrapper, htmlOption, question, qstnId) {
					var id = "";
					if (qstnId) {
						id = qstnId;
					}
					var prevQsOpt = prevWrapper.find(".prevQsOpt");
					var drdwOpt = question.option;
					var optLength = drdwOpt.length;
					var logic = "";
					
					var drdwLogicArea = $("<div id='logic" + id + "' class='drdwLogicArea'>");
					
					for (var i = 0; i < optLength; i++) {
						var opt = drdwOpt[i];
						var optLevel = opt.level;
						
						var html = "";
						html += "<div class='drdwLogicRow' id='drdw" + id + i + "'>";
						html += "<span class='prevDrdwSpan'>" + opt.content + "</span>";
						html += "<img class='prevDrdwArrow' src='/images/ezSurvey/arrow.png'>";
						html += "<select id='slt" + id + i + "' class='logicSelect' name='slt" + id + i + "'>";
						html += htmlOption;
						html += "</select>";
						html += "<span class='logicSpan' id='sltVal" + id + i + "'></span>";
						html += "</div>";
						
						drdwLogicArea.append($(html)[0]);
						prevQsOpt.append(drdwLogicArea);
						
						if (question.logicFlag == 'Y') {
							logicNum = opt.logic;
							logic = (logicNum != "") ? "질문 " + logicNum : ""; 

							$("#frstBtnGrp" + id).css("display", "none");
							$("#thrdBtnGrp" + id).css("display", "");
							
							$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "none");
							$("#sltVal" + id + i).text(logic).css("dispaly", "");
						}
					}
				}
				// select 질문 logic form 나타내기
				function showSltLogicForm(id, qstn) {
					var prevQsWrapper = $("#prevQstn" + id);
					var opt = prevQsWrapper.find(".prevQsOpt").find(".opt");
					
					var qstnOpt = qstn.option;
					
					for (var i = 0; i < opt.length; i++) {
						var logicNum = qstnOpt[i]['logic'];
						$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "");
						$("#sltVal" + id + i).css("display", "none");
					}
				}
				
				// select 질문 객체, ui에 로직 value 추가
				function addSltLogic(id, qstn) {
					var wrapper = $("#prevQstn"+id);
					var opt = wrapper.find(".opt");
					var optLength = opt.length;
					var logic = "";
					
					for (var i = 0; i < optLength; i++) {
						var logicNum = $("select[name=slt" + id  + i +"] option:selected").val();
						// option 객체에 logic 추가
						qstn.option[i]['logic'] = logicNum;
						
						logic = (logicNum == "") ? SurveyMessages.strNoLogic : "질문 " + logicNum;
						$("select[name=slt" + id + i + "]").css("display", "none");
						$("#sltVal" + id + i).text(logic).css("display", "");
					}
					console.log(qstn);
				}
				
				// slider 질문 logic form 나타내기
				function showSlidLogicForm(id, qstn) {
					var prevQsWrapper = $("#prevQstn" + id);
					
					var logicPoint = qstn['slidLogicPoint'];
					var logicNum = qstn.option[0]['logic'];
					
					$("#slidLogicInput" + id).val(logicPoint).css("display", "");
					$("#LogicPoint" + id).css("display", "none");
					
					$("#sltVal" + id).css("display", "none");
					$("#slt" + id).val(logicNum).prop("selected", true).css("display", "");
				}
				
				// slider 질문 객체, ui에 로직 value 추가
				function addSlidLogic(id, qstn) {
					var inputVal = parseInt($("#slidLogicInput" + id).val());
					var maxVal = parseInt(qstn.option[1]['content']);
					var logicNum = parseInt($("select[name=slt" + id + "] option:selected").val());
					var logic = "";
					
					if (!isNaN(inputVal) && inputVal < maxVal) {
						if (!isNaN(logicNum)) {
							qstn['slidLogicPoint'] = inputVal;
							qstn.option[0]['logic'] = logicNum;
							
							$("#slidLogicInput" + id).css("display", "none");
							$("#LogicPoint" + id).text(inputVal).css("display", "");
							
							logic = (logicNum == "") ? "" : "질문 " + logicNum;
							$("select[name=slt" + id + "]").css("display", "none");
							$("#sltVal" + id).text(logic).css("display", "");
						} else {
							alert(SurveyMessages.strchooseNum);
							return;
						}
					} else {
						alert(SurveyMessages.strBetweenNum);
						return;
					}
					console.log(qstn);
				}
				
				// dropdown 질문 logic form 나타내기
				function showDrdwLogicForm(id, qstn) {
					var prevQsWrapper = $("#prevQstn" + id);
					var logicRow = prevQsWrapper.find("#logic" + id).find(".drdwLogicRow");
					var RowLength = logicRow.length;
					
					var qstnOpt = qstn.option;
					
					for (var i = 0; i < RowLength; i++) {
						var logicNum = qstnOpt[i]['logic'];
						$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "");
						$("#sltVal" + id + i).css("display", "none");
					}
				}
				
				// dropdown 질문 객체, ui에 로직 value 추가
				function addDrdwLogic(id, qstn) {
					var logicArea = $("#logic" + id);
					var rows = logicArea.find(".drdwLogicRow");
					var optLength = rows.length;
					var logic = "";
					
					for (var i = 0; i < optLength; i++) {
						var logicNum = $("select[name=slt" + id  + i +"] option:selected").val();
						qstn.option[i]['logic'] = logicNum;
						
						logic = (logicNum == "") ? SurveyMessages.strNoLogic : SurveyMessages.strQs + " " + logicNum;
						$("select[name=slt" + id + i + "]").css("display", "none");
						$("#sltVal" + id + i).text(logic).css("display", "");
					}
					console.log(qstn);
				}
				
				function confirmSurveyInfo(qstInf) {
					var surveyInfWrap = document.getElementById("surveyInfConfirm");
					document.getElementById("cf-purpose").textContent    = qstInf["purpose"];
					document.getElementById("cf-startDate").textContent  = qstInf["startDate"];
					document.getElementById("cf-endDate").textContent    = qstInf["endDate"];
					document.getElementById("cf-anoynymous").textContent = qstInf["anonymous"] == 0 ? SurveyMessages.strAnoynym1  : SurveyMessages.strAnoynym2;
					document.getElementById("cf-multiple").textContent   = qstInf["multiple"]  == 0 ? SurveyMessages.strMultiple1 : SurveyMessages.strMultiple2;
					
					var surveyUserElmt = document.getElementById("cf-userdiv");
					var publicStr      = "<span class='survey-bold'>" + SurveyMessages.strPublic3 + "</span>";
					
					if (qstInf["public"] == 1) {
						publicStr += "<span class='inf-survey'>"  + SurveyMessages.strPublic1 + "</span>";
						publicStr += "<span class='survey-bold'>" + SurveyMessages.strPublic4 + "</span>";
						publicStr += "<span class='inf-survey'>" + qstInf["publicDays"] + "</span>";
						publicStr += "<span class='survey-bold survey-pass'>" + SurveyMessages.strPublic5 + "</span>";
					}
					else {
						publicStr += "<span class='inf-survey'>" + SurveyMessages.strPublic2 + "</span>";
					}
					
					document.getElementById("public-cfdiv").innerHTML = publicStr;
					surveyUserElmt.innerHTML                          = "";
					
					if (qstInf["userflag"] == 0) {
						surveyUserElmt.innerHTML = "<span class='inf-survey'> " + SurveyMessages.strUser2 + "</span>";
					}
					else {
						var userList = qstInf["users"];
						if (userList.length < 5) {
							for (var i = 0 ; i < userList.length; i++) {
								var spanElmt = document.createElement("span");
								spanElmt.textContent = userList[i]["userName"];
								spanElmt.className   = "user-inf";
								spanElmt.onclick     = (function(userId) {
									return function() {SurveyCreate.showUser(userId);};
								})(userList[i]["userId"]);
								
								surveyUserElmt.appendChild(spanElmt);
								
								if (i != userList.length - 1) {
									var divideEm         = document.createElement("em");
									divideEm.textContent = "; ";
									surveyUserElmt.appendChild(divideEm);
								}
							}
							
							var spanElmt2         = document.createElement("span");
							spanElmt2.className   = "total-user";
							spanElmt2.textContent = "[" + SurveyMessages.strTotal + " " + userList.length + " " + SurveyMessages.strUser3 + "]";
							surveyUserElmt.appendChild(spanElmt2);
						}
						else {
							var spanElmt1 = document.createElement("span");
							var spanElmt2 = document.createElement("span");
							var spanElmt3 = document.createElement("span");
							
							spanElmt1.className   = "user-inf";
							spanElmt1.textContent = userList[0]["userName"];
							spanElmt2.className   = "total-user";
							spanElmt2.textContent = "[" + SurveyMessages.strTotal + " " + userList.length + " " + SurveyMessages.strUser3 + "]";
							spanElmt3.className   = "user-more";
							spanElmt3.onclick     = function(e) {SurveyCreate.userMore()};
							spanElmt1.onclick     = function(e) {SurveyCreate.showUser(userList[0]["userId"]);};
							
							surveyUserElmt.appendChild(spanElmt1);
							surveyUserElmt.appendChild(spanElmt2);
							surveyUserElmt.appendChild(spanElmt3);
							
							//Set user for user panel
							var userTableElmt       = document.getElementById("user-tblmain");
							userTableElmt.innerHTML = "";
							
							for (var i = 0 ; i < userList.length; i++) {
								var trElmt      = document.createElement("tr");
								var tdElmt1     = document.createElement("td");
								var tdElmt2     = document.createElement("td");
								tdElmt1.onclick = (function(userId) {
									return function() {SurveyCreate.showUser(userId);};
								})(userList[i]["userId"]);
								
								tdElmt1.textContent = userList[i]["userName"];
								tdElmt2.textContent = getUserType(userList[i]["userType"]);
								tdElmt1.className   = "user-field";
								tdElmt2.className   = "center-field";
								trElmt.appendChild(tdElmt1);
								trElmt.appendChild(tdElmt2);
								userTableElmt.appendChild(trElmt);
							}
							
							document.getElementById("th-usertype").className  = userList.length == 5 ? "center-field" : "center-field right-field";
						}
					}
					
					//attach list
					if (qstInf["attach"] && qstInf["attach"].length > 0) {
						var htmlStr = "";
						
						for (var i = 0; i < qstInf["attach"].length; i++) {
							var filename       = qstInf["attach"][i]["fname"];
							var checkImageFile = questionFile.chImage(filename);
							var imgSrc         = checkImageFile.isImage == true ? qstInf["attach"][i]["fpath"] : checkImageFile.urlImage;
							
							htmlStr += "<li><div class='attDivFile'>";
							htmlStr += "<div class='attImgAva'><img src='" + imgSrc + "'></div>";
							htmlStr += "<div class='attFileInf'>";
							htmlStr += "<span title='" + filename + "'>" + filename + "</span>";
							htmlStr += "<span>" + qstInf["attach"][i]["fsize"] + "</span>";
							htmlStr += "</div></div></li>";
						}
						
						document.getElementById("cf-attach").innerHTML        = htmlStr;
						document.getElementById("surveyAttConfirm").className = "attach-zone"; //show attach list
					}
					else {
						document.getElementById("surveyAttConfirm").className = "attach-zone off"; //hide attach list
					}
				}
				
				function getUserType(userType) {
					var stUserType = "";
					switch(userType) {
						case "user" : stUserType = SurveyMessages.strUser4; break;
						case "dept" : stUserType = SurveyMessages.strUser5; break;
						case "comp" : stUserType = SurveyMessages.strUser6; break;
						default     : stUserType = SurveyMessages.strUser4; break;
					}
					
					return stUserType;
				}
			}());
		</script>
	</body>
</html>


