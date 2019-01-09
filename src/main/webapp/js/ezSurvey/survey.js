var SurveyCreate     = function() {
	var surveyFile   = new SurveyFile();
	var surveyItem   = null;
	var selectPopup  = null;
	var finishStep   = null;
	var lastStep     = 1;
	var userWindow   = null;
	var lastScrollY  = 0;
	var scrolled     = true;
	var questionFile = new SurveyFile("images");
	var config       = {modify : "modify", required : "required", action : "action",}
	// 로직 설정 단계를 건너뛰었는가 여부, 확인 클릭시 Y로 변경
	var skipLogic    = 'N';
	// 로직 설정 단계에 진입했었는가 여부, 진입한 적이 있으면 Y로 변경
	var enterLogic   = 'N'; 
		
	// 셀렉트 박스에 들어갈 질문 유형 데이터 
	var optionData = 
		[{ text : SurveyMessages.strSlOne   , value: 1, selected: false, imageSrc: "/images/ezSurvey/qsType01.png"},
		 { text : SurveyMessages.strSlMtp   , value: 2, selected: false, imageSrc: "/images/ezSurvey/qsType02.png"},
		 { text : SurveyMessages.strTblOne  , value: 3, selected: false, imageSrc: "/images/ezSurvey/qsType03.png"},
		 { text : SurveyMessages.strTblMtp  , value: 4, selected: false, imageSrc: "/images/ezSurvey/qsType04.png"},
		 { text : SurveyMessages.strShortQs , value: 5, selected: false, imageSrc: "/images/ezSurvey/qsType05.png"},
		 { text : SurveyMessages.strLongQs  , value: 6, selected: false, imageSrc: "/images/ezSurvey/qsType06.png"},
		 { text : SurveyMessages.strSlider  , value: 7, selected: false, imageSrc: "/images/ezSurvey/qsType07.png"},
		 { text : SurveyMessages.strRanking , value: 8, selected: false, imageSrc: "/images/ezSurvey/qsType08.png"},
		 { text : SurveyMessages.strDropdown, value: 9, selected: false, imageSrc: "/images/ezSurvey/qsType09.png"}];
	
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
	
	var bnk = null;
	
	function initEvents(reuseSurvey) {
		console.log(reuseSurvey);
		surveyItem            = reuseSurvey     ? reuseSurvey.surveyId    : null;
		var modifyFlag        = reuseSurvey     ? reuseSurvey.modifyFlag  : 0;
		surveyObj["surveyId"] = modifyFlag == 1 ? reuseSurvey["surveyId"] : -1;
		var fileDivElmt       = document.getElementById("fileDiv");
		
		$("#startDate").datepicker(datepickerSt);
		$("#endDate").datepicker(datepickerSt);
		
		if (!surveyItem) {
			var today = new Date();
			$("#startDate").datepicker("setDate", today);
			$("#endDate").datepicker("setDate", today);
			fileDivElmt.onclick = function(e) {startUpload();};
		}
		else {
			if (reuseSurvey["paritipateFlag"] == 1) {setSurveyUsers(reuseSurvey["userList"]);}
			if (reuseSurvey["attachFlag"] == 1) {surveyFile.render(reuseSurvey["attachList"]);}
			if (reuseSurvey["purpose"]) {surveyObj["infor"]["purpose"] = reuseSurvey["purpose"];}
			getReuseQuestions();
		}
		
		fileDivElmt.addEventListener("dragenter", function(e) {surveyFile.dragEnter(e);}, false);
		fileDivElmt.addEventListener("dragover" , function(e) {surveyFile.dragOver(e);} , false);
		fileDivElmt.addEventListener("drop"     , function(e) {surveyFile.upload(e);}   , false);
		
		var listTabElmt = document.getElementsByClassName("headpanel")[0].children;
		for (var i = 0, len = listTabElmt.length; i < len; i++) {
			var tabElmt      = listTabElmt[i];
			var spanElmt     = tabElmt.querySelector("span[class='arrow']");
			tabElmt.onclick  = (function(idx, elmt) {return function() {selectStep(idx, elmt);};})(i + 1, tabElmt);
			spanElmt.onclick = (function(idx, elmt) {return function() {selectStep(idx, elmt);};})(i + 1, tabElmt);
		}
		
		var fileUploadBttn      = document.getElementById("fileBttn");
		fileUploadBttn.onchange = function(e) {surveyFile.upload();};
		var userMoreElmt        = document.querySelector("span[class='user-more']");
		if (userMoreElmt) {userMoreElmt.onclick = function(e) {toggleUserPreview();};}
		var draftBttn           = document.getElementById("draftBttn");
		if (draftBttn) {draftBttn.onclick = function(e) {saveDraftSurvey();};}
		
		document.getElementById("addUrlClose").onclick  = function(e) {toggleUrlPanel();};
		document.getElementById("addUrlBttn").onclick   = function(e) {toggleUrlPanel();};
		document.getElementById("addFileBttn").onclick  = function(e) {startUpload();};
		document.getElementById("userListDiv").onscroll = function(e) {scrollListOfUser(this);}
		document.onselectstart = function() {return false;};
		window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
		document.getElementById("selectTarget" ).addEventListener("change", toggleSelectTargetBttn, false);
		document.getElementById("targetBttn"   ).addEventListener("click" , showSelectPopUp       , false);
		document.getElementById("gotoFirstTab" ).addEventListener("click" , gotoFirstStep         , false);
		
		var secondTab = document.getElementsByClassName("gotoSecondTab");
		var thirdTab  = document.getElementsByClassName("gotoThirdTab");
		var forthTab  = document.getElementsByClassName("gotoForthTab");
		var cancelSv1 = document.getElementsByClassName("cancelSurvey1");
		
		for (var i = 0; i < secondTab.length; i++) {
			secondTab[i].addEventListener("click", gotoSecondStep, false);
		}
		
		for (var i = 0; i < thirdTab.length; i++) {
			thirdTab[i].addEventListener("click",  gotoThirdStep, false);
		}
		
		for (var i = 0; i < forthTab.length; i++) {
			forthTab[i].addEventListener("click",  gotoForthStep, false);
		}
		
		for (var i = 0; i < cancelSv1.length; i++) {
			cancelSv1[i].addEventListener("click",  cancelThisSurvey, false);
		}
		
		document.getElementById("public-slbox"  ).addEventListener("change", toggleDaysInput  , false);
		document.getElementById("closeUserPanel").addEventListener("click",  toggleUserPreview, false);
		document.getElementById("saveSurvey"    ).addEventListener("click",  saveSurvey       , false);
		
		if (!surveyItem) {
			// question input 및 img 생성
			createQuestionDiv();
			
			// question selectBox 생성
			createQuestionSelectBox();
			addOptEvent();
		}
		
		if (surveyObj["surveyId"] && surveyObj["surveyId"] != -1) {
			window.addEventListener("beforeunload", function(e) {changeSurveyState();}, false);
		}
	}
	
	function saveDraftSurvey() {
		//Check survey information
		var returnObj = checkStep1();
		if (returnObj["error"]) {alert(returnObj["error"]); return;}
		surveyObj["draft"] = 1;
		
		$.ajax({
			type: "POST",
			url: "/ezSurvey/saveSurvey.do",
			data: JSON.stringify(surveyObj),
			contentType: "application/json; charset=utf-8",
			dataType: "JSON",
			async: false,
			success : function(data) {
				afterSaveDraftSuccessfully(data);
			},
			error : function(error) {
				alert(SurveyMessages.strError);
			}
		});
	}
	
	function changeSurveyState() {
		$.ajax({
			type: "GET",
			url: "/ezSurvey/changeSurveyState.do",
			data: {surveyId : surveyObj["surveyId"]},
			contentType: "application/json; charset=utf-8",
			dataType: "JSON",
			async: true,
			success : function(data) {},
			error : function(error) {}
		});
	}
	
	function startUpload() {document.getElementById("fileBttn").click();}
	function cancelThisSurvey() { 
		surveyObj['infor'] = {};
		surveyObj['questions'] = [];
		window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=processing";
	}
	
	function saveSurvey() {
		if(confirm(SurveyMessages.strSaveAsk) == true) {
			
			console.log(JSON.stringify(surveyObj));
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
	}
	
	function saveSurveyInformation() {
		var surveyInfoWrap = document.querySelector("div[class='surveyinfo-wrap']");
		var surveyAttWrap  = document.querySelector("div[class='survey-attach']");
		var surveyTitle    = document.getElementById("info-input-ttl").value;
		var surveyPurpose  = document.getElementById("info-input-pp").contentWindow.GetEditorContent();
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
				var fileName = liFileList[i].getAttribute("fname");
				var filePath = liFileList[i].getAttribute("path");
				var fileSize = liFileList[i].getAttribute("fsize");
				var fileUrl  = liFileList[i].getAttribute("furl");
				var attach   = {};
				
				if (fileName) {attach["fname"] = fileName;}
				if (fileUrl)  {attach["furl"]  = fileUrl;}
				if (fileSize) {attach["fsize"] = fileSize;}
				if (filePath) {attach["fpath"] = filePath;}
				
				attachList.push(attach);
			}
		}
		
		surveyObj["infor"]["attach"] = attachList;
		console.log(JSON.stringify(surveyObj["infor"]["users"]));
	}
	
	function afterSaveDraftSuccessfully(data) {
		var code = data.code;
		switch(code) {
			case 0 : alert(SurveyMessages.strSaveDraft);
					 window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=draft";
					 break;
			case 1 : alert(SurveyMessages.strParamErr) ; break;
			case 2 : alert(SurveyMessages.strError)    ; break;
			default: alert(SurveyMessages.strError)    ; return;
		}
	}
	
	function afterSaveSuccessfully(data) {
		var code = data.code;
		switch(code) {
			case 0 : alert(SurveyMessages.strSave)    ;
					 window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=processing";
					 break;
			case 1 : alert(SurveyMessages.strParamErr); break;
			case 2 : alert(SurveyMessages.strError)   ; break;
			default: alert(SurveyMessages.strError)   ; return;
		}
	}
	
	function gotoFirstStep() {
		var listTabElmt          = document.getElementsByClassName("headpanel")[0].children;
		listTabElmt[0].className = "crust selected";
		listTabElmt[1].className = "crust";
		listTabElmt[2].className = "crust";
		listTabElmt[3].className = "crust";
		
		$("div[id^=tab]").attr("class", "hidden-tab");
		document.getElementById("tab1").className = "select-tab";
		lastStep = 1;
	}
	
	function gotoSecondStep() {
		if (enterLogic == 'Y') {deleteAllLogics();}	// 로직 설정 단계에 진입했는지 확인
		var checkObj = prepareForStep2();
		if (checkObj["error"]) {alert(checkObj["error"]); return;}
		var listTabElmt          = document.getElementsByClassName("headpanel")[0].children;
		listTabElmt[0].className = "crust";
		listTabElmt[1].className = "crust selected";
		listTabElmt[2].className = "crust";
		listTabElmt[3].className = "crust";
		
		$("div[id^=tab]").attr("class", "hidden-tab");
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
		listTabElmt[3].className = "crust";
		
		$("div[id^=tab]").attr("class", "hidden-tab");
		document.getElementById("tab3").className = "select-tab";
		enterLogic = 'Y';
		lastStep = 3;
		getSurveyPreview(lastStep);
	}
	
	function gotoForthStep() {
		var checkObj = prepareForStep4();
		if (checkObj["error"]) {alert(checkObj["error"]); return;}
		
		var listTabElmt          = document.getElementsByClassName("headpanel")[0].children;
		listTabElmt[0].className = "crust";
		listTabElmt[1].className = "crust";
		listTabElmt[2].className = "crust";
		listTabElmt[3].className = "crust selected";
		
		$("div[id^=tab]").attr("class", "hidden-tab");
		document.getElementById("tab4").className = "select-tab";
		lastStep = 4;
		getSurveyPreview(lastStep);
	}
	
	function selectStep(tabIdx, spanElemt) {
		var crrSpan = document.querySelector("span[class='crust selected']");
		if (crrSpan == spanElemt) {return;}
		var checkObj = null;
		
		switch(parseInt(tabIdx)) {
			case 1: focusonQuestionTitleStep1(); 
					toggleStep(spanElemt, crrSpan, tabIdx);
					lastStep = 1; break;
			case 2: if (enterLogic == 'Y') {deleteAllLogics();}	// 로직 설정 단계에 진입했는지 확인
					checkObj = prepareForStep2();
					if (checkObj["error"]) {alert(checkObj["error"]); return;}
					toggleStep(spanElemt, crrSpan, tabIdx);
					focusonQuestionTitleStep2();
					lastStep = 2; break;
			case 3: checkObj = prepareForStep3();
					if (checkObj["error"]) {alert(checkObj["error"]); return;}
					toggleStep(spanElemt, crrSpan, tabIdx);
					getSurveyPreview(tabIdx);
					showLogicMap();
					enterLogic = 'Y';
					lastStep = 3; break;
			case 4: checkObj = prepareForStep4();
					if (checkObj["error"]) {alert(checkObj["error"]); return;}
					toggleStep(spanElemt, crrSpan, tabIdx);
					getSurveyPreview(tabIdx);
					lastStep = 4; break;
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
	
	function focusonQuestionTitleStep1() {document.getElementById("info-input-ttl").focus();}
	function focusonQuestionTitleStep2() {document.querySelector("div[class='quesDiv']").querySelector("input[class='questnTitle']").focus();}
	function getSurveyPreview(step) {prevQstn(step);}
	
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
			returnObj = checkQsCount();
			if (returnObj["error"]) {return returnObj;}
		}
		
		document.querySelector("div[class='quesDiv']").querySelector("input[class='questnTitle']").focus();
		return returnObj;
	}
	
	function prepareForStep4() {
		var returnObj = {};
		
		if (finishStep < 3) {
			returnObj = checkStep1();
			if (returnObj["error"]) {return returnObj;}
			returnObj = checkStep2();
			if (returnObj["error"]) {return returnObj;}
			returnObj = checkStep3();
			if (returnObj["error"]) {return returnObj;}
		}
		
		return returnObj;
	}
	
	function checkStep1() {
		var returnObj  = {};
		var surveyTtl  = document.getElementById("info-input-ttl");
		var surveyPp   = document.getElementById("info-input-pp").contentWindow;
		var ppContent  = surveyPp.GetBodyValue();
		var sDate      = document.getElementById("startDate").value;
		var eDate      = document.getElementById("endDate").value;
		var publicFlag = 1 - document.getElementById("public-slbox").selectedIndex;
		var userFlag   = document.getElementById("selectTarget").selectedIndex;
		var userList   = surveyObj["infor"]["users"];
		ppContent      = replaceAll(ppContent, '<p style="font-family:맑은 고딕;font-size:12px;"><br></p>', '');
		var ttlValue   = replaceAll(surveyTtl.value, " ", "");
		
		if (!ttlValue)     {returnObj["error"] = SurveyMessages.strTitle  ; surveyTtl.value = ""; surveyTtl.focus(); return returnObj;}
		if (!ppContent)    {returnObj["error"] = SurveyMessages.strPurpose; surveyPp.focus() ; return returnObj;}
		if (!sDate)        {returnObj["error"] = SurveyMessages.strSvDate3; return returnObj;}
		if (!eDate)        {returnObj["error"] = SurveyMessages.strSvDate2; return returnObj;}
		if (sDate > eDate) {returnObj["error"] = SurveyMessages.strSvDate1; return returnObj;}
		
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
	
	function checkQsCount() {
		var returnObj    = {};
		var questionList = getSurveyQuestions();
		
		if (questionList.length == 1) {returnObj["error"] = SurveyMessages.strQsCount; return returnObj;}
		return returnObj;
	}
	
	function checkStep3() {
		var returnObj = {};
		
		if (lastStep == 2) {
			if (skipLogic == 'N') {
				if (confirm(SurveyMessages.strSkipLogic) == true) {
					skipLogic = 'Y';
					
				} else {
					returnObj["error"] = SurveyMessages.strLogic;
					return returnObj; 
				}
			}
		}
		return returnObj;
	}
	// 분기 설정 이후 step2로 되돌아갈 시, 질문의 모든 로직 삭제
	function deleteAllLogics() {
		var questionList = surveyObj.questions;
		var questionLength = questionList.length;
		var result = checkAllLogicAndSkip(questionList, questionLength);
		
		if (result == 'Y') {
			if (confirm("질문 작성 단계로 이동시, 모든 분기와 건너뛰기가 초기화됩니다.") == true) {
				for (var i = 0; i < questionLength; i++) {
					var qstn = questionList[i];
					var level = qstn.level;
					var type = qstn.type;
					var logicFlag = qstn.logicFlag;
					var skipFlag = qstn.skipFlag;
					if (logicFlag == 1) {
						// 질문의 로직 번호 삭제
						if (type == 1 || type == 9) {
							var opt = qstn['option'];
							var optLength = opt.length;
							
							for (var j = 0; j < optLength; j++) {
								qstn.option[j]['logic'] = -1; 
							}
						} else {
							qstn.option[0]['logic']  = -1;
							
							if (type == 7) {
								qstn.sliderLogicPoint = -1;
							}
						}
						// logic flag 변경
						qstn.logicFlag = 0;
						var id = level + 1;
						if ($("#imptt" + id).length != 0) {
							qstn['required'] = 0;
						}
					}
					
					if (skipFlag == 1) {
						qstn['skipFlag'] = 0;
						qstn['skip']     = -1;
					}
					
				}
			}
		}
	}
	
	function checkAllLogicAndSkip(questions, length) {
		var result = "";
		
		for (var i = 0; i < length; i++) {
			var logicFlag = questions[i].logicFlag;
			var skipFlag = questions[i].skipFlag;
			
			if (logicFlag == 1) {
				result = 'Y';
				break;
			}
			if (skipFlag == 1) {
				result = 'Y';
				break;
			}
		}
		
		return result;
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
			addFogPanel(toggleUserPreview);
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
	
	function addFogPanel(togglePanel) {
		var fogPanel                  = document.createElement("div");
		fogPanel.className            = "rfogPanel";
		var leftFogPanel              = document.createElement("div");
		leftFogPanel.className        = "blockLeft";
		fogPanel.onclick              = function(e) {togglePanel();};
		leftFogPanel.onclick          = function(e) {togglePanel();};
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
			if (userArr[i]["userId"] == userId && userArr[i]["userType"] == userType) {userArr.splice(i, 1);}
		}
		
		surveyObj["infor"]["users"] = userArr;
		var spanElmt = imgElmt.parentElement;
		spanElmt.parentElement.removeChild(spanElmt);
	}
	
	function getReuseQuestions() {
		$.ajax({
			type: "GET",
			url: "/ezSurvey/getSurveyQuestions.do",
			data: {surveyId : surveyItem},
			contentType: "application/json; charset=utf-8",
			dataType: "JSON",
			async: true,
			success : function(data) {
				afterGetSurveyQuestions(data);
			},
			error : function(error) {
				alert(SurveyMessages.strError);
			}
		});
	}
	
	function afterGetSurveyQuestions(data) {
		var code = data.code;
		switch(code) {
			case 0 : convertQuestions(data)           ; break;
			case 1 : alert(SurveyMessages.strParamErr); break;
			case 2 : alert(SurveyMessages.strError)   ; break;
			default: alert(SurveyMessages.strError)   ; return;
		}
	}
	
	function convertQuestions(data) {
		surveyObj["questions"] = JSON.parse(JSON.stringify(data["questions"]));
		
		reuseQstns(surveyObj["questions"]);
		// question input 및 img 생성
		createQuestionDiv();
		
		// question selectBox 생성
		createQuestionSelectBox();
		addOptEvent();
		
	}
	
	function showLogicMap() {
		if (!bnk) {
			bnk = cytoscape({
				container: document.getElementById("logicMap"),
				boxSelectionEnabled: false,
				ready: function(){},
				style: [
					{selector: 'node', css: {"content": "data(name)", "font-size": 10, "width" : 16,"height" : 16,}},
					{selector: 'edge', css: {"target-arrow-shape": "triangle"}}
				],
				minZoom: 1,
				maxZoom: 5,
				wheelSensitivity: 1,
			});
		}
		
		var jsonElmt = createJsonElements();
		bnk.elements().remove();
		bnk.add(jsonElmt); 
		bnk.layout({name: 'dagre',rankDir: 'LR',}).run();
		bnk.resize();
		bnk.fit();
		bnk.center();
		
		bnk.elements().qtip({
			content: {
				 text: function(){
					/*var divElmt  = document.createElement("div");
					var divElmt1 = document.createElement("div");
					var divElmt2 = document.createElement("div");
					divElmt1.textContent = "Test1 => Question 1";
					divElmt2.textContent = "Test1 => Question 9";
					divElmt.appendChild(divElmt1);
					divElmt.appendChild(divElmt2);
					return divElmt;*/
					return this.data("title");
				}
			 },
			position: {
				my: "top center",
				at: "bottom center"
			},
			style: {
				classes: "qtip-bootstrap",
				tip: {width: 16,height: 8}
			}
		});
	}
	
	function createJsonElements() {
		var questions = surveyObj["questions"];
		var elements  = {};
		var nodes     = [];
		var edges     = [];
		
		for (var i = 0; i < questions.length; i++) {
			var node        = {};
			var qsData      = {};
			qsData["id"]    = questions[i]["level"];
			qsData["name"]  = SurveyMessages.strQs + " " + questions[i]["level"];
			qsData["title"] = questions[i]["content"];
			node["data"]    = qsData;
			nodes.push(node);
			
			if (questions[i]["skipFlag"] == 1) {
				var skipQst = questions[i]["skip"];
				if (skipQst) {
					if (skipQst != 0) {
						edges.push({data: {source : questions[i]["level"], target: skipQst}});
					}
				}
				else {
					if (questions[i]["level"] == questions.length) {
						continue;
					}
					else {
						edges.push({data: {source : questions[i]["level"], target: questions[i]["level"] + 1}});
					}
				}
			}
			else if (questions[i]["logicFlag"] == 1) {
				var options = questions[i]["option"];
				for (var j = 0; j < options.length; j++) {
					var logicNum = options[j]["logic"];
					var destQst  = -1;
					
					if (!logicNum || logicNum == -1 ) {
						if (questions[i]["level"] == questions.length) {
							continue;
						}
						else {
							destQst = questions[i]["level"] + 1;
						}
					}
					else {
						destQst  = logicNum;
					}
					
					var nlink = {source : questions[i]["level"], target: destQst};
					edges.push({data: nlink});
				}
			}
			else {
				if (questions[i]["level"] < questions.length) {
					edges.push({data: {source : questions[i]["level"], target: questions[i]["level"] + 1}});
				}
			}
		}
		
		elements["nodes"] = nodes;
		elements["edges"] = edges;
		
		return elements;
	}
	
	function showSelectPopUp() {selectPopup = window.open("/ezSurvey/selectUsers.do", "selectUser", getOpenWindowfeature(964, 700));}
	function getSurveyQuestions() {return surveyObj["questions"];}
	function setSurveyQuestions(question) {surveyObj["questions"].push(question);}
	function getSurveyUsers() {return surveyObj["infor"]["users"];}
	function setSurveyUsers(userList) {surveyObj["infor"]["users"] = JSON.parse(JSON.stringify(userList)); showUserList();}
	function getSurveyInfo() {return surveyObj["infor"];}
	function isValid(value) {if (!isNaN(value) && parseFloat(value) >= 0 && value % 1 === 0) {return true;} else {return false;}}
	
	// question input 및 img 생성
	function createQuestionDiv(qstnWrapper, question) {
		var qstId      = "";
		var qstContent = "";
		var qstAtt     = "";
		
		if (question) {
			qstId      = question.level;
			qstContent = question.content;
			qstAtt     = mkImgTag(question.attach);
		}
		
		var wrapper      = $("<div class='qstnWrapper' id='" + qstId + "'></div>");
		var quesDiv      = $("<div class='quesDiv'></div>");
		var qstnRow      = $("<div class='qstnRow'></div>");
		var questnTitle  = $("<input class='questnTitle' value='" + qstContent + "' placeholder='" + SurveyMessages.strContent + "' />");
		var atchImg      = $("<img class='atchImg' src='/images/ezSurvey/attach.png'/>");
		var atchVdo      = $("<img class='atchVdo' src='/images/ezSurvey/video.png' />");
		var atchMsic     = $("<img class='atchMsic' src='/images/ezSurvey/music.png'/>");
		var atchUrl      = $("<img class='atchUrl' src='/images/ezSurvey/link.png'  />");
		var selectBox    = $("<div class='selectBox'></div>");
		var qstnFileInfo = $("<div class='qstnFileInfo'></div>");
		var fileList     = $("<div class='fileList'></div>");
		var qstUl        = $("<ul class='qstUl'></ul>");
		var qstnImgFile  = $("<input type='file' class='qstnImgFile' accept='image/*'/>");
		var qstnAudFile  = $("<input type='file' class='qstnAudFile' accept='audio/*'/>");
		var qstnVidFile  = $("<input type='file' class='qstnVidFile' accept='video/*'/>");
		
		qstnRow.append(questnTitle);
		qstnRow.append(atchImg);
		qstnRow.append(atchVdo);
		qstnRow.append(atchMsic);
		qstnRow.append(atchUrl);
		qstnRow.append(selectBox);
		quesDiv.append(qstnRow);
		
		qstUl.append(qstAtt);
		fileList.append(qstUl);
		fileList.append(qstnImgFile);
		fileList.append(qstnAudFile);
		fileList.append(qstnVidFile);
		qstnFileInfo.append(fileList);
		
		quesDiv.append(qstnFileInfo);
		wrapper.append(quesDiv);
		
		if (qstnWrapper) {
			qstnWrapper.after(wrapper);
			qstnWrapper.next().find(".questnTitle")[0].focus();
		}
		else {
			$(".quesBacgr").append(wrapper);
			$(".quesBacgr").find(".qstnWrapper").find(".questnTitle")[0].focus();
		}
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
		var QuestionForm = makeQuestionForm(questionType);
		var slt = handleModifySelectQuestion();
		var addtional = mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);

		QuestionForm.append(slt);
		QuestionForm.append(addtional);
		grandParent.append(QuestionForm);
		
	}
	
	// 셀렉트 박스 선택시 만들어지는 질문 폼 행렬 질문 생성
	function makeMatrixQuestion(grandParent, questionType, checkResult) {
		var QuestionForm = makeQuestionForm(questionType);
		var mtr = handleModifyMatrixQuestion();
		var addtional = mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
		
		QuestionForm.append(mtr);
		QuestionForm.append(addtional);
		grandParent.append(QuestionForm);
	}
	
	// 버튼 이벤트
	function addOptEvent() {
		// question 첨부파일 트리거
		$(".quesBacgr").on("click", ".atchImg", function() {
			var li = $(this).closest(".quesDiv").find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			$(this).parent().next().find(".qstnImgFile").click();
		});
		
		$(".quesBacgr").on("click", ".atchVdo", function() {
			var li = $(this).closest(".quesDiv").find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			$(this).parent().next().find(".qstnVidFile").click();
		});
		
		$(".quesBacgr").on("click", ".atchMsic", function() {
			var li = $(this).closest(".quesDiv").find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			$(this).parent().next().find(".qstnAudFile").click();
		});
		
		$(".quesBacgr").on("click", ".atchUrl", function() {
			var li = $(this).closest(".quesDiv").find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			
			toggleUrlPanel($(this).parent().next().find(".fileList")[0]);
		});
		
		$("#removeUrlPopup").click(function() {toggleUrlPanel();})
		// question 첨부파일 추가
		$(".quesBacgr").on("change", ".qstnImgFile", function(e) {fileUpload(this, "image");});
		$(".quesBacgr").on("change", ".qstnVidFile", function(e) {fileUpload(this, "video");});
		$(".quesBacgr").on("change", ".qstnAudFile", function(e) {fileUpload(this, "music");});
		
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
			optArea.find(".optionImgFile").click();
		});
		$(".quesBacgr").on("click", ".attVideo", function() {
			var optArea = $(this).closest(".optArea");
			var li      = optArea.find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			optArea.find(".optionVideoFile").click();
		});
		$(".quesBacgr").on("click", ".attMusic", function() {
			var optArea = $(this).closest(".optArea");
			var li      = optArea.find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			optArea.find(".optionMusicFile").click();
		});
		
		// 첨부파일 버튼 이벤트
		$(".quesBacgr").on("change", ".optionImgFile"  , function (e) {fileUpload(this, "image");});
		$(".quesBacgr").on("change", ".optionVideoFile", function (e) {fileUpload(this, "video");});
		$(".quesBacgr").on("change", ".optionMusicFile", function (e) {fileUpload(this, "music");});
		
		// 질문 생성 폼의 취소 버튼 클릭
		$(".quesBacgr").on("click", ".cancel", function() {
			var thisWrapper = $(this).closest(".qstnWrapper");
			thisWrapper.find(".quesDiv").find(".questnTitle").val(""); // 질문 내용 삭제
			clickXButton(thisWrapper);                                 // 첨부 파일 삭제
			setSelectBox(thisWrapper);                                 // 셀렉트 박스  내용 변경
			thisWrapper.find(".qstnForm").remove();                    // 질문 폼 삭제
		});
		
		// 저장 버튼 클릭 이벤트
		$(".quesBacgr").on("click", ".save", function() {mkQstnObj("save", $(this));});
		
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
			deepCopy.level  = nextId;
			
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
			var id = $(this).attr("id").replace("addLogic", "");
			
			mkLogicForm(id);
			
			$("#frstBtnGrp" + id).css("display", "none");
			$("#scndBtnGrp" + id).css("display", "");
			$("#thrdBtnGrp" + id).css("display", "none");
		});
		
		// 로직 저장 버튼 이벤트
		$(".prevQsArea").on("click", ".saveLogic", function() {
			var id = parseInt($(this).attr("id").replace("saveLogic", ""));
			// 로직 flag 저장
			var qstnList = SurveyCreate.getQs();
			var qstn = qstnList[id - 1];
			var type = qstn.type;
			var result = "";
			var pf = "";
			
			// 로직 추가, ui 변경
			switch(type) {
			case 1 :
				pf = checkLogicNum(id, qstn, type);
				result = pf == "success" ? addSltLogic(id, qstn) : ""; 
				break;
			case 7:
				result = addSlidLogic(id, qstn);
				break;
			case 9:
				pf = checkLogicNum(id, qstn, type);
				result = pf == "success" ? addDrdwLogic(id, qstn) : "";
				break;
			}
			
			if (result == "success") {
				var logicFlag = qstn['logicFlag'];
				var required = qstn['required'];
				
				if (required == 0) {
					required = 1;
					addImptMark(id);
				}
				if (logicFlag == undefined || logicFlag == 0) {
					qstn['logicFlag'] = 1;
				}
				$("#frstBtnGrp" + id).css("display", "none");
				$("#scndBtnGrp" + id).css("display", "none");
				$("#thrdBtnGrp" + id).css("display", "");
			}
			
			showLogicMap();
		});
		
		// 로직 취소 버튼 이벤트
		$(".prevQsArea").on("click", ".cancelLogic", function() {
			var prevWrapper = $(this).parents(".prevQsWrapper");
			var type = parseInt(prevWrapper.attr("type"));
			var id = parseInt(prevWrapper.attr("id").replace("prevQstn", ""));

			var qstnList = surveyObj["questions"];
			var qstn = qstnList[id - 1];
			var logicFlag = qstn.logicFlag;
			
			// 질문에 로직이 있는 경우
			if (logicFlag == 1) {
				cnclLogicMdf(id, qstn, type);
				
				$("#frstBtnGrp" + id).css("display", "none");
				$("#scndBtnGrp" + id).css("display", "none");
				$("#thrdBtnGrp" + id).css("display", "");
			
			// 질문에 로직이 없는 경우
			} else if (logicFlag == undefined || logicFlag == 0) {
				dltLogicForm(type, id);
				
				$("#frstBtnGrp" + id).css("display", "");
				$("#scndBtnGrp" + id).css("display", "none");
				$("#thrdBtnGrp" + id).css("display", "none");
			}
			
			showLogicMap();
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
				showSltLogicForm(id, qstn);
				break;
			case 7:
				showSlidLogicForm(id, qstn);
				break;
			case 9:
				showDrdwLogicForm(id, qstn);
				break;
			}
			$("#frstBtnGrp" + id).css("display", "none");
			$("#scndBtnGrp" + id).css("display", "");
			$("#thrdBtnGrp" + id).css("display", "none");
		});
		
		
		// 로직 삭제 버튼 이벤트
		$(".prevQsArea").on("click", ".delLogic", function() {
			var id = parseInt($(this).attr("id").replace("delLogic", ""));
			
			var prevWrapper = $(this).parents(".prevQsWrapper");
			var type = parseInt(prevWrapper.attr("type"));
			
			var qstnList = SurveyCreate.getQs();
			var qstn = qstnList[id - 1];
			
			// 로직 삭제, ui 변경
			if (type == 1) {
				var opt = prevWrapper.find(".opt");
				var optLength = opt.length;
				
				for (var i = 0; i < optLength; i++) {
					qstn.option[i]['logic'] = -1; 
					$("#logic" + id + i).remove();
				}
			
			} else {
				if (type == 7) {
					qstn.option[0].logic  = -1;
					qstn.sliderLogicPoint = -1;
					
				} else if (type == 9) {
					var row = prevWrapper.find(".drdwLogicRow");
					var optLength = row.length;
					
					for (var i = 0; i < optLength; i++) {
						qstn.option[i]['logic'] = -1; 
						$("#logic" + id + i).remove();
					}
					
				} 
				$("#logic" + id).remove();
			}
			qstn.logicFlag = 0;
			
			if ($("#imptt" + id).length != 0) {
				qstn['required'] = 0;
				$("#imptt" + id).remove(); 
			}
			
			$("#frstBtnGrp" + id).css("display", "");
			$("#scndBtnGrp" + id).css("display", "none");
			$("#thrdBtnGrp" + id).css("display", "none");
		});
		
		// skip 폼 생성 이벤트
		$(".prevQsArea").on("click", ".addSkip", function() {
			var id = parseInt($(this).attr("id").replace("addSkip", ""));
			
			mkSkipForm(id);
			
			$("#frstBtnGrp" + id).css("display", "none");
			$("#skipScndBtnGrp" + id).css("display", "");
			$("#skipThrdBtnGrp" + id).css("display", "none");
			
		});
		
		// skip 저장 버튼 이벤트
		$(".prevQsArea").on("click", ".saveSkip", function() {
			var id = parseInt($(this).attr("id").replace("saveSkip", ""));
			// 로직 flag 저장
			var qstnList = SurveyCreate.getQs();
			var qstn = qstnList[id - 1];
			var type = qstn.type;
			var result = "";
			var pf = "";
			var skip = "";
			var skipNum = $("select[name=skip" + id  + "] option:selected").val();
			
			// option 객체에 logic 추가
			qstn['skipFlag'] = 1;
			qstn['skip'] = parseInt(skipNum);
			qstn['logicFlag'] = 0;

			if (skipNum != "" && skipNum != 0) {
				skip = SurveyMessages.strQs + " " + skipNum;
				
			} else if (skipNum == 0) {
				skip = SurveyMessages.strLast;
			}
			$("select[name=skip" + id + "]").css("display", "none");
			$("#skipVal" + id).text(skip).css("display", "");
			$("#frstBtnGrp" + id).css("display", "none");
			$("#skipScndBtnGrp" + id).css("display", "none");
			$("#skipThrdBtnGrp" + id).css("display", "");
			
			showLogicMap();
		});
		
		// skip 취소 버튼 이벤트
		$(".prevQsArea").on("click", ".cancelSkip", function() {
			var id = $(this).attr("id").replace("cancelSkip", "");
			var qstnList = SurveyCreate.getQs();
			var qstn = qstnList[id - 1];
			
			if (qstn['skipFlag'] == undefined || qstn['skipFlag'] == 0) {
				$("#skip" + id).remove();
			} else {
				var skip = "";
				var skipNum = qstn['skip'];

				if (skipNum != -1) {
					skip = SurveyMessages.strQs + " " + skipNum;
					$("#skipVal" + id).text(skip).css("display", "");
				}
				$("select[name=skip" + id + "]").css("display", "none");
			}
			
			$("#frstBtnGrp" + id).css("display", "");
			$("#skipScndBtnGrp" + id).css("display", "none");
			$("#skipThrdBtnGrp" + id).css("display", "none");
			showLogicMap();
		});
		
		// skip 삭제 버튼 이벤트
		$(".prevQsArea").on("click", ".delSkip", function() {
			var id = $(this).attr("id").replace("delSkip", "");
			var qstnList = SurveyCreate.getQs();
			var qstn = qstnList[id - 1];

			qstn['skipFlag'] = 0;
			qstn['skip'] = -1;
			$("#skip" + id).remove();
			
			$("#frstBtnGrp" + id).css("display", "");
			$("#skipScndBtnGrp" + id).css("display", "none");
			$("#skipThrdBtnGrp" + id).css("display", "none");
		});
		
		$(".prevQsArea").on("click", ".mdfSkip", function() {
			var id = $(this).attr("id").replace("mdfSkip", "");
			var qstnList = SurveyCreate.getQs();
			var qstn = qstnList[id - 1];
			
			if (qstn['skipFlag'] != 0) {
				var skipNum = qstn['skip'];
				!isNaN(skipNum) ? $("select[name=skip" + id + "]").val(skipNum).prop("selected", true).css("display", "") : "";  
				$("#skipVal" + id).css("display", "none");
			}
			$("#frstBtnGrp" + id).css("display", "none");
			$("#skipScndBtnGrp" + id).css("display", "");
			$("#skipThrdBtnGrp" + id).css("display", "none");
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
				catchedQsObj.level = comparedQsId;
				// 그 객체 복사
				var deepCopy       = JSON.parse(JSON.stringify(catchedQsObj));
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
	}
	
	function addImptMark(id) {
		var wrapper = $("#prevQstn" + id);
		var impttTag = "";

		if (wrapper.find(".question-header").find(".imptt").length == 0) {
			impttTag = $("<strong id='imptt" + id + "' class='imptt'>*</strong>");
			//wrapper.find(".question-content").find("span[id^=frstBtnGrp]").before(impttTag);
			wrapper.find(".question-header").prepend(impttTag);
		}
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
		var oldId       = qstn["level"];
		var type        = qstn["type"];
		var newId       = "";
		var thisWrapper = "";
		
		if (action == "delete" || action == "reOrder" && result == -1) {
			newId             = oldId - 1;
		} else if (action == "copy" || action == "reOrder" && result == 1) {
			newId             = oldId + 1;
		}
		qstn["level"] = newId;
		
		// old id의 form 변경
		thisWrapper = $("#qstn" + oldId);
		thisWrapper.html("");
		thisWrapper.attr("id", "qstn" + newId);
		
		mkQstnsByType(thisWrapper, type, qstn);
	}
	
	// 사용자용 질문 폼 생성
	function mkQstnsByType(qstnWrapper, qstnType, question, prev) {
		var header = makeQuestionHeaderPanel(question);
		var body = "";
		
		switch(parseInt(qstnType)) {
			case 1  :
			case 2  : body = mkSelectQstn(question)             ; break;
			case 3  : 
			case 4  : body = mkMatrixQstn(question)             ; break;
			case 5  : body = mkTextQstn(question, "shortanswer"); break;
			case 6  : body = mkTextQstn(question, "paragraph")  ; break;
			case 7  : body = mkSliderQstn(question)             ; break;
			case 8  : body = mkRankingQstn(question)            ; break;
			case 9  : body = mkDropDownQstn(question)           ; break;
			default : alert(SurveyMessages.strError)            ; return;
		}
		
		header.append(body[0]);
		qstnWrapper.append(header);
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
		var body = "";
		var additional = "";
		var QuestionForm = makeQuestionForm(qstType);
		
		switch(parseInt(qstType)) {
			case 1  :
			case 2  : body = handleModifySelectQuestion(question)                 ; break;
			case 3  : 
			case 4  : body = handleModifyMatrixQuestion(question)                 ; break;
			case 5  : body = handleModifyTextQuesion("shortanswer", "make")       ; break;
			case 6  : body = handleModifyTextQuesion("paragraph"  , "make")       ; break;
			case 7  : body = handleModifySliderQuesion(question)                  ; break;
			case 8  : body = handleModifyRankDropDownQuesion("ranking" , question); break;
			case 9  : body = handleModifyRankDropDownQuesion("dropdown", question); break;
			default : alert(SurveyMessages.strError)                               ; return;
		}
		additional = mkAddtionalPart(mode, question.required);

		QuestionForm.append(body);
		QuestionForm.append(additional);
		qstnWrapper.next().append(QuestionForm);
	}
	// 수정시 새로 생성하는 선택질문
	function handleModifySelectQuestion(question) {
		var optionWrapper = $("<div class='optionWrapper'></div>");
		
		if (question) {
			var opts    = question.option;
			var options = opts.filter(function(opt) {return opt["otherFlag"] == 0;});
			var others  = opts.filter(function(opt) {return opt["otherFlag"] == 1;});
			var other   = (others && others.length > 0) ? others[0] : null;
			
			var opt = "";
			
			if (options) {
				for (var i = 0, len = options.length; i < len; i++) {
					opt = mkOpt("opt", options[i]);
					optionWrapper.append(opt);
				}
			}
			
			if (other) {
				opt = mkOpt("other", other);
				optionWrapper.append(opt);
			}
		}
		else {
			for (var i = 0; i < 2; i++) {
				opt = mkOpt("opt");
				optionWrapper.append(opt);
			}
		}
		
		var htmlTxt = "<div class='addBtns'>";
		htmlTxt += "<button class='addOpt'>" + SurveyMessages.strAdd + "</button>";
		htmlTxt += "<button class='addOther'>" + SurveyMessages.strAddOther + "</button>";
		htmlTxt += "</div>";
		
		optionWrapper.append(htmlTxt);
		
		return optionWrapper;
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
		
		return $(html);
	}
	
	function handleModifyTextQuesion(type, mode) {
		var className = mode == "make" ? type + "-wrap" : "question-" + type;
		var textQstnDiv = $("<div class='" + className + "'>");
		
		if (type == "paragraph") {
			var textarea = $("<textarea class='" + type +"' maxlength='500' placeholder='" + SurveyMessages.strContent + "'></textarea>");
			textQstnDiv.append(textarea);
		}
		else {
			var input = $("<input class='" + type +"' maxlength='80' placeholder='" + SurveyMessages.strContent + "'/>");
			textQstnDiv.append(input);
		}
		
		return textQstnDiv;
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
		var slidWrap = $("<div class='silder-wrap'></div>");
		var sliderLw = $("<input type='input' class='slider-lw' value='" + lowest  + "'/>");
		slidWrap.append(sliderLw);
		
		var slideMain = $("<input type='range' class='slider-main'/>");
		slidWrap.append(slideMain);
		
		var sliderUp = $("<input type='input' class='slider-up' value='" + highest + "'/>");
		slidWrap.append(sliderUp);
		
		return slidWrap;
	}
	
	function handleModifyRankDropDownQuesion(type, question) {
		var wrap = $("<div class='" + type + "-wrap'></div>");
		var option = "";
		
		if (question) {
			var optionList = question["option"];
			
			for (var i = 0, len = optionList.length; i < len; i++) {
				option = mkOptions(type, i + 1, optionList[i]["content"]);
				wrap.append(option);
			}
		}
		else {
			for (var i = 0; i < 3; i++) {
				option = mkOptions(type, i + 1, "");
				wrap.append(option);
			}
		}
		
		var htmlTxt = "<div class='addBtns'>";
		htmlTxt += "<button class='addOpttions'>" + SurveyMessages.strAdd + "</button>";
		htmlTxt += "</div>";
		wrap.append($(htmlTxt));
		
		return wrap;
	}
	
	// 첨부파일 있을 시 태그 생성
	function mkImgTag(qstnAtt) {
		if (!qstnAtt) {return "";}
		return questionFile.mkImgTag(qstnAtt);
	}
	
	// option 첨부파일 업로드
	function fileUpload(thisEl, uploadMode) {questionFile.upload(thisEl, uploadMode);}
	
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
		var qstnId       = question.level;
		var qstnType     = question.type;
		var questionOpts = $("<div class='question-opts'></div>");
		var opt          = "";
		var optRdo       = "";
		var optChb       = "";
		var optAttach    = "";
		var optContent   = "";
		var span         = "";
		var othInput     = "";
		
		// 보기
		if (options) {
			for (var i = 0; i < options.length; i++) {
				var option = options[i];
				opt = $("<div class='opt' level='" + option.level + "'></div>");
				if (qstnType == 2) {
					optChb = $("<input class='optChb' type='checkbox' name='qstn" + qstnId + "opt' value='" + option.level + "' logic='" + option.logic + "' />");
					opt.append(optChb);
				}
				else {
					optRdo = $("<input class='optRdo' type='radio' name='qstn" + qstnId + "opt' value='" + option.level + "' logic='" + option.logic + "' />");
					opt.append(optRdo);
				}
				
				if (option["attach"]) {
					optAttach = $("<img alt='' src='" + questionFile.getImage(option["attach"])["imageSrc"] + "' class='optImg'>");
					opt.append(optAttach);
				}
				
				optContent = option["content"] ? option["content"] : "";
				optSpan    = $("<span class='optSpan'></span>");
				optSpan[0].textContent = optContent;
				opt.append(optSpan);
				
				questionOpts.append(opt);
			}
		}
		
		// 기타
		if (other) {
			opt = $("<div class='opt'></div>");
			
			if (qstnType == 2) {
				optChb = $("<input class='optChb' type='checkbox' name='qstn" + qstnId + "opt' value='" + other.level + "' logic='" + option.logic + "' />");
				opt.append(optChb);
			}
			else {
				optRdo = $("<input class='optRdo' type='radio' name='qstn" + qstnId + "opt' value='" + other.level + "' logic='" + option.logic + "' />");
				opt.append(optRdo);
			}
			
			optAttach = other["attach"] ? $("<img alt='' src='" + questionFile.getImage(other["attach"])["imageSrc"] + "' class='optImg'>") : "";
			opt.append(optAttach);
			optSpan = $("<span class='optSpan'></span>");
			optSpan[0].textContent = other["content"];
			opt.append(optSpan);
			othInput = $("<input class='othInput' type='text'/>");
			opt.append(othInput);
			questionOpts.append(opt);
		}
		
		return questionOpts;
	}
	
	function mkMatrixQstn(question) {
		var id       = question.level;
		var inpType  = question.type == 3 ? "radio" : "checkbox";
		var opts     = question["option"];
		var col      = opts.filter(function(col) {return col["rowLevel"] == -1;});
		var row      = opts.filter(function(row) {return row["colLevel"] == -1;});
		
		var questionOpts = $("<div class='question-opts'></div>");
		var table = $("<table class='matrix'></table>");
		var head = $("<thead></head>");
		var headTr = $("<tr><td></td></tr>");
		
		var dynamicTd = "";
		var body = "";
		var bodyTr = "";
		var bodyTd = "";
		var inputTd = "";
		var Input = "";
		
		for (var i = 0; i < col.length; i++) {
			dynamicTd = $("<td></td>");
			dynamicTd[0].textContent = col[i]["content"];
			headTr.append(dynamicTd);
		}
		head.append(headTr);
		table.append(head);
		body = $("<tbody></body>");
		
		for (var i = 0; i < row.length; i++) {
			bodyTr = $("<tr></tr>");
			
			bodyTd = $("<td></td>");
			bodyTd[0].textContent = row[i]["content"];
			bodyTr.append(bodyTd);
			
			for (var j = 0; j < col.length; j++) {
				inputTd = $("<td></td>");
				Input = $("<input type='" + inpType + "' name='qstn" + id + "opt" + i + "' id='qstn" + id + "opt" + i + j + "'>");
				//Input.val("(" + row[i]["rowLevel"] + ", " + col[j]["colLevel"] + ")");
				Input.val(row[i]["rowLevel"] + "," + col[j]["colLevel"]);
				inputTd.append(Input);
				bodyTr.append(inputTd);
			}
			body.append(bodyTr);
		}
		table.append(body);
		questionOpts.append(table);
		
		return questionOpts;
	}
	// 이전 요소 삭제
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
		question[config["required"]] = rqrd.is(":checked") == true ? 1 : 0;
		
		//Check question attach files
		var qstnFObj = qstnArea.find(".qstnFileInfo")[0].childNodes[0].childNodes[0].childNodes[0];
		if (qstnFObj) {question["attach"] = getAttachFileInfo(qstnFObj);}
		
		//Question order
		var qstId         = qstnWrapper.attr("id") ? parseInt(qstnWrapper.attr("id")) : questionList.length + 1;
		question["level"] = qstId;
		//Set id
		qstnWrapper.attr("id", "qstn" + qstId);
		
		var header       = makeQuestionHeaderPanel(question);
		var body         = "";
		
		switch(parseInt(qstnType)) {
			case 1  :
			case 2  : var sltObj = mkSltObj(qstnForm);
					  if (sltObj.error)  {alert(SurveyMessages[sltObj.error]); return;}
					  if (sltObj.option) {question["option"] = sltObj.option;}
					  body = mkSelectQstn(question); break;
			case 3  : 
			case 4  : var mtrObj = mkMtrObj(qstnForm);
					  if (mtrObj.error)  {alert(SurveyMessages[mtrObj.error]); return;}
					  if (mtrObj.option) {question["option"] = mtrObj.option;}
					  body = mkMatrixQstn(question); break;
			case 5  : var shortAnswerObj = mkTxtObj();
					  question["option"] = shortAnswerObj.option;
					  body = mkTextQstn(question, "shortanswer"); break;
			case 6  : var paragraphObj   = mkTxtObj();
					  question["option"] = paragraphObj.option;
					  body = mkTextQstn(question, "paragraph"  ); break;
			case 7  : var sliderObj = mkSliderObj(qstnForm[0]);
					  if (sliderObj.error) {alert(SurveyMessages[sliderObj.error]); return;}
					  if (sliderObj.option) {question["option"] = sliderObj.option;}
					  body = mkSliderQstn(question); break;
			case 8  : var rankingObj = mkRankingDropDownObj("ranking", qstnForm);
					  if (rankingObj.error) {alert(SurveyMessages[rankingObj.error]); return;}
					  question["option"] = rankingObj.option;
					  body = mkRankingQstn(question); break;
			case 9  : var dropDownObj = mkRankingDropDownObj("dropdown", qstnForm);
					  if (dropDownObj.error) {alert(SurveyMessages[rankingObj.error]); return;}
					  question["option"] = dropDownObj.option;
					  body = mkDropDownQstn(question); break;
			default : alert(SurveyMessages.strError); return;
		}
		
		header.append(body[0]);
		qstnWrapper.prepend(header);
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
	// 재사용시 질문 폼 생성
	function reuseQstns(questions) {
		var qstn = questions;
		var qstnLength = qstn.length;
		
		for (var i = 0; i < qstnLength; i++) {
			var question = qstn[i];
			var qstnId = question.level;
			var qstnType = question.type;
			
			var wrapper = $("<div class='qstnWrapper' id='qstn" + question.level + "' ></div>");
			
			mkQstnsByType(wrapper, qstnType, question);
			
			$(".quesBacgr").append(wrapper);
			
			if(question.logicFlag == 1) {
				mkLogicForm(qstnId);
			}
		}
	}
	
	function mkTextQstn(question, type) {
		var html = handleModifyTextQuesion(type, config["modify"]);
		return html;
	}
	
	function mkSliderQstn(question) {
		var options = question.option;
		var sliderLogicPoint = question.sliderLogicPoint;
		var qstnId = question.level;
		var logic = options[0].logic;
		var lowest  = options.filter(function(val) {return val["level"] == 0;})[0]["content"];
		var highest = options.filter(function(val) {return val["level"] == 1;})[0]["content"];
		
		var questionSilder = $("<div class='question-silder'></div>");
		var silderWrap = $("<div class='silder-wrap'></div>");
		var low = $("<span>" + lowest + "</span>");
		var input = $("<input type='range' class='slider-range' name='slider" + question["level"] + "' min='" + lowest + "' max='" + highest + "'/>");
		var high = $("<span>" + highest + "</span>");
		var output = $("<output for='slider" + question["level"] + "' id='slider" + question["level"] + "' class='slider-output' logic='" + logic + "' logicPoint='" + sliderLogicPoint + "'></output>");

		silderWrap.append(low);
		silderWrap.append(input);
		silderWrap.append(high);
		
		questionSilder.append(silderWrap);
		questionSilder.append(output);
		
		return questionSilder;
	}
	
	function mkRankingQstn(question) {
		var options = question["option"];
		var id = question["level"];
		//console.log(options);
		var questionRanking = $("<div class='question-ranking'>");
		var rankingWrap = $("<div class='ranking-wrap'>");
		var opt = "";
		
		for (var i = 0, len = options.length; i < len; i++) {
			var rankingSelect = $("<div class='ranking-select'></div>");
			var rankOrder = $("<span class='rank-order' id='rank-order" + (i + 1) + "'>" + (i + 1) + ".</span>");
			
			var strSlct = "<select name='slt" + id + i + "'>";
			strSlct    += "<option selected>" + SurveyMessages.strSelect + "</option>";
			
			for (var j = 0, len = options.length; j < len; j++) {
				strSlct += "<option value='" + options[j]['level'] + "'>" + options[j]["content"] + "</option>";
			}
			strSlct += "</select>";
			
			rankingSelect.append(rankOrder);
			rankingSelect.append(strSlct);
			rankingWrap.append(rankingSelect);
		}
		questionRanking.append(rankingWrap);
		
		return questionRanking;
	}
	
	function mkDropDownQstn(question) {
		var options = question["option"];
		var id = question["level"];
		
		var questionDropdown = $("<div class='question-dropdown'></div>");
		var dropdownWrap = $("<div class='dropdown-wrap'></div>");
		
		var select = $("<select name='drdw" + id + "'></select>");
		var defaultOpt = $("<option selected>" + SurveyMessages.strSelect + "</option>");
		select.append(defaultOpt);
		
		for (var j = 0, len = options.length; j < len; j++) {
			var opt = $("<option value='" + options[j]["content"] + "' logic='" + options[j]["logic"] + "'></option>");
			
			opt[0].textContent = options[j]["content"];
			select.append(opt);
		}
		dropdownWrap.append(select);
		questionDropdown.append(dropdownWrap);
		
		return questionDropdown;
	}
	
	// 질문 헤더 생성
	function makeQuestionHeaderPanel(question) {
		var qstId         = question.level;
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
		if (required == 1) {
			var strongElmt         = document.createElement("strong");
			strongElmt.className   = "imptt";
			strongElmt.textContent = "*";
			divHeader.appendChild(strongElmt);
		}
		
		divQsContent.textContent = qstId + ". " + content;
		divQsContent.className   = "question-content";
		
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
			var attachInf    = questionFile.getImage(qstnAtt);
			attImg.src       = attachInf["imageSrc"];
			attImg.className = "qstnImg";
			attDiv.className = "question-attach";
			attDiv.appendChild(attImg);
			
			if (attachInf["isImage"] == 0) {
				var spanElmt         = document.createElement("span");
				spanElmt.textContent = qstnAtt["fname"];
				spanElmt.setAttribute("title", qstnAtt["fname"]);
				attDiv.appendChild(spanElmt);
			}
			
			divPanel.appendChild(attDiv);
		}
		
		moveBttn.className = "mvBtn";
		divPanel.className = "question-panel";
		wrapDiv.className  = "usrQstnWrapper";
		wrapDiv.setAttribute("qstnType", qstnType);
		wrapDiv.appendChild(divPanel);
		
		return wrapDiv;
	}
	
	// 순위, dropdown 질문 객체 생성
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
	
	// 단, 장문형 질문 객체 생성
	function mkTxtObj() {
		var textObj = {};
		var option  = [];
		option.push({content : "", level : 0});
		textObj["option"] = option;
		return textObj;
	}
	
	// 슬라이더 질문 객체 생성
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
		var options = $("<div class='" + type + "-select'></div>");
		var span = $("<span class='" + type + "-order'>" + order + "</span>");
		options.append(span);
		
		var contents = $("<input class='textInput' type='text' value='" + content + "' placeholder='" + SurveyMessages.strContent + "'/>");
		options.append(contents);
		
		var delOption = $("<span class='delOption'></span>");
		options.append(delOption);
		
		return options;
	}
	
	// selection 질문의 보기 생성
	function mkOpt(type, options) {
		var optAtt = "";
		var attEl  = "";
		var opt = "";
		var textInput = "";
		var optArea = $("<div class='optArea'></div>");
		var option = $("<div class='option'></div>");
		
		if (type == "other") {
			opt = $("<div class='other'></div>");
			if (options) {
				textInput = $("<input class='textInput' type='text' value='" + options["content"] + "' maxlength='40' placeholder='" + SurveyMessages.strOther + "'/>");
			}
			else {
				textInput = $("<input class='textInput' type='text' maxlength='40' placeholder='" + SurveyMessages.strOther + "'>");
			}
		} else {
			opt = $("<div class='optPart'></div>");
			if (options) {
				textInput = $("<input class='textInput' type='text' value='" + options["content"] + "' maxlength='40' placeholder='" + SurveyMessages.strContent + "' />");
				optAtt = options["attach"];
				
			}
			else {
				textInput = $("<input class='textInput' type='text' maxlength='40' placeholder='" + SurveyMessages.strContent + "'/>");
			}
		}
		
		var attImg   = $("<img src='/images/ezSurvey/attach.png' class='attImg'  >");
		/*var attVideo = $("<img src='/images/ezSurvey/video.png'  class='attVideo'>");
		var attMusic = $("<img src='/images/ezSurvey/music.png'  class='attMusic'>");
		var attLink  = $("<img src='/images/ezSurvey/link.png'   class='attLink' >");*/
		var minsImg  = $("<img src='/images/ezSurvey/minus.png'  class='delImg'  >");
		
		option.append(textInput);
		option.append(attImg);
		/*option.append(attVideo);
		option.append(attMusic);
		option.append(attLink);*/
		option.append(minsImg);
		
		var optFileInfo = $("<div class='optFileInfo'></div>");
		var fileList = $("<div class='fileList'></div>");

		if (optAtt) {attEl = mkImgTag(optAtt);}
		
		var optUl           = $("<ul class='optUl'></ul>");
		var optionImgFile   = $("<input type='file' class='optionImgFile'   accept='image/*'/>");
		/*var optionVideoFile = $("<input type='file' class='optionVideoFile' accept='video/*'/>");
		var optionMusicFile = $("<input type='file' class='optionMusicFile' accept='audio/*'/>");*/
		optUl.append(attEl);
		
		fileList.append(optUl);
		fileList.append(optionImgFile);
		/*fileList.append(optionVideoFile);
		fileList.append(optionMusicFile);*/
		
		optFileInfo.append(fileList);
		
		optArea.append(option);
		optArea.append(optFileInfo);
		
		opt.append(optArea);
		
		return opt;
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
			html += "<img alt='' src='/images/ezSurvey/minus.png' class='" + elClass + "' style='width: 30px;height: 30px; cursor: pointer;'>";
			html += "</div>";
			
		return html;
	}
	
	// 필수, 저장, 수정, 취소 버튼 생성
	function mkAddtionalPart(action, required) {
		var html = "<div class='additionalPart'>";
			html += "<div class='required'>";
			html += required == 1 ? "<input type='checkbox' name='checkbox' checked='checked'>" : "<input type='checkbox' name='checkbox'>";
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
		return $(html);
	}
	
	function makeQuestionForm(questionType) {return $("<div class='qstnForm' questionType='" + questionType + "'>");}
	
	function makeTextQuestion(mainDivElmt, questionType, type, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var textQs = handleModifyTextQuesion(type, "make");
		var addtional = mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
		
		questionForm.append(textQs);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
	}
	
	function makeSliderQuestion(mainDivElmt, questionType, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var slider = handleModifySliderQuesion();
		var addtional = mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
		
		questionForm.append(slider);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
	}
	
	function makeRankingQuestion(mainDivElmt, questionType, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var raking       =  handleModifyRankDropDownQuesion("ranking");
		var addtional    = mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
		questionForm.append(raking);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
	}
	
	function makeDropdownQuestion(mainDivElmt, questionType, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var drdw         = handleModifyRankDropDownQuesion("dropdown");
		var addtional    = mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
		questionForm.append(drdw);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
	}
	
	function getAttachFileInfo(elmtObj) {
		var attchObj      = {};
		attchObj["fname"] = elmtObj.getAttribute("fname");
		
		if (elmtObj.getAttribute("furl")) {
			attchObj["furl"] = elmtObj.getAttribute("furl");
		}
		else {
			attchObj["fpath"] = elmtObj.getAttribute("path");
		}
		
		return attchObj;
	}
	
	function isValid(value) {if (!isNaN(value) && parseFloat(value) >= 0 && value % 1 === 0) {return true;} else {return false;}}
	
	// 미리보기 질문 폼 생성
	function prevQstn(step) {
		var prevQsArea = $(".prevQsArea");
		prevQsArea.html("");
		
		var qstnList = SurveyCreate.getQs();
		
		if (step == 4) {
			var qstInf = SurveyCreate.getInfo();
			confirmSurveyInfo(qstInf);
		}
		
		if (qstnList.length != 0) {
			for (var i = 0; i < qstnList.length; i++) {
				var question = qstnList[i];
				var qstnId = question.level;
				var qstnType = question.type;
				var wrapper = $("<div class='prevQsWrapper' id='prevQstn" + qstnId + "'type='" + qstnType + "'></div>");
				
				var header = prevQsHeader(question, qstnList, step);
				var prevQsOpt = $("<div class='prevQsOpt'></div>");
				
				var body = "";
				switch(parseInt(qstnType)) {
					case 1  :
					case 2  : body = mkSelectQstn(question)             ; break;
					case 3  : 
					case 4  : body = mkMatrixQstn(question)             ; break;
					case 5  : body = mkTextQstn(question, "shortanswer"); break;
					case 6  : body = mkTextQstn(question, "paragraph")  ; break;
					case 7  : body = mkSliderQstn(question)             ; break;
					case 8  : body = mkRankingQstn(question)            ; break;
					case 9  : body = mkDropDownQstn(question)           ; break;
					default : alert(SurveyMessages.strError)            ; return;
				}
				
				wrapper.append(header);
				prevQsOpt.append(body);
				wrapper.append(prevQsOpt);
				prevQsArea.append(wrapper);
				
				if (step == 3) {
					if (question.logicFlag == 1) {
						mkLogicForm(qstnId);
					}
					else if (question.skipFlag == 1) {
						mkSkipForm(qstnId)
					}
				}
			}
		}
	}
	
	// 미리보기 질문의 헤더
	function prevQsHeader(question, qstnList, step) {
		var qstId           = question.level;
		var content         = question.content;
		var qstnType        = question.type;
		var required        = question.required;
		var qstnAtt         = question.attach;
		var prevQsContent   = $("<div class='prevQsContent'></div>");
		var questionPanel   = $("<div class='question-panel'></div>");
		var questionHeader  = $("<div class='question-header'></div>");
		var questionContent = $("<div class='question-content'></div>");
		var qstnHeader      = "";
		var questionAttach  = "";
		var imptt           = required == 1 ? "<strong class='imptt'>*</strong>" : "";
		
		questionContent[0].textContent = qstId + ". " + content;
		
		if (step == 3) {
			var frstBtnGrp = $("<span id='frstBtnGrp" + qstId + "' class='frstBtnGrp'></span>");
			var addSkip = $("<img id='addSkip" + qstId + "' class='addSkip' src='/images/ezSurvey/skip.png'/>");
			frstBtnGrp.append(addSkip);
			
			qstnHeader += "<span id='skipScndBtnGrp" + qstId + "' class='skipScndBtnGrp' style='display:none;'>"
			qstnHeader += "<img id='saveSkip" + qstId + "' class='saveSkip' src='/images/ezSurvey/save.png'/>";
			qstnHeader += "<img id='cancelSkip" + qstId + "' class='cancelSkip' src='/images/ezSurvey/cancel.png' />";
			qstnHeader += "</span>"
			qstnHeader += "<span id='skipThrdBtnGrp" + qstId + "' class='skipThrdBtnGrp' style='display:none;'>"
			qstnHeader += "<img id='mdfSkip" + qstId + "' class='mdfSkip' src='/images/ezSurvey/correct.png'/>";
			qstnHeader += "<img id='delSkip" + qstId + "' class='delSkip' src='/images/ezSurvey/trash.png'/>";
			qstnHeader += "</span>"
			
			if (qstnType == 1 || qstnType == 7 || qstnType == 9) {
				var addLogic = $("<img id='addLogic" + qstId + "' class='addLogic' src='/images/ezSurvey/shuffle.png'/>");
				frstBtnGrp.append(addLogic);
				
				qstnHeader += "<span id='scndBtnGrp" + qstId + "' class='scndBtnGrp' style='display:none;'>"
				qstnHeader += "<img id='saveLogic" + qstId + "' class='saveLogic' src='/images/ezSurvey/save.png'/>";
				qstnHeader += "<img id='cancelLogic" + qstId + "' class='cancelLogic' src='/images/ezSurvey/cancel.png' />";
				qstnHeader += "</span>"
				qstnHeader += "<span id='thrdBtnGrp" + qstId + "' class='thrdBtnGrp' style='display:none;'>"
				qstnHeader += "<img id='mdfLogic" + qstId + "' class='mdfLogic' src='/images/ezSurvey/correct.png'/>";
				qstnHeader += "<img id='delLogic" + qstId + "' class='delLogic' src='/images/ezSurvey/trash.png'/>";
				qstnHeader += "</span>"
			}
		}
		
		if (qstnAtt) {
			questionAttach      = $("<div class='question-attach'></div>");
			var attachInf       = questionFile.getImage(qstnAtt);
			var imageElmt       = document.createElement("img");
			imageElmt.src       = questionFile.getImage(qstnAtt)["imageSrc"];
			imageElmt.className = "qstnImg";
			
			//Add events if in survey detail
			if (step == 0) {
				if (attachInf["isUrl"]) {
					imageElmt.onclick = (function(url) {return function() {window.open(url);};})(qstnAtt["furl"]);
				}
				else {
					imageElmt.onclick = (function(name, path) {return function() {questionFile.download(name, path);};})(qstnAtt["fname"], qstnAtt["fpath"]);
				}
			}
			
			questionAttach.append(imageElmt);
			
			if (attachInf["isImage"] == 0) {
				var spanElmt         = document.createElement("span");
				spanElmt.textContent = qstnAtt["fname"];
				spanElmt.setAttribute("title", qstnAtt["fname"]);
				questionAttach.append(spanElmt);
			}
		}
		
		questionContent.append(frstBtnGrp);
		questionContent.append(qstnHeader);
		questionHeader.append(imptt);
		questionHeader.append(questionContent);
		questionPanel.append(questionHeader);
		questionPanel.append(questionAttach);
		prevQsContent.append(questionPanel);
		
		return prevQsContent;
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
			var qstnId = qstnList[i]["level"];
			if (qstnId > id) {
				htmlOption += "<option value='" + qstnId + "'>" + qstnId + "</option>"; 
			}
		}
		htmlOption += "<option value='0'>" + SurveyMessages.strLast + "</option>"; 
		
		switch(type) {
		case 1 :
			sltLogicForm(prevWrapper, htmlOption, thisQstn, id);
			break;
		case 7 :
			slidLogicForm(prevWrapper, htmlOption, thisQstn, id);
			break;
		case 9 :
			drdwLogicForm(prevWrapper, htmlOption, thisQstn, id);
			break;
		}
	}
	
	// select 질문에 logic form 추가
	function sltLogicForm(prevWrapper, htmlOption, question, qstnId) {
		var id = "";
		var logicNum = "";

		var qstnOpt = question.option;
		var opts = prevWrapper.find(".prevQsOpt").find(".opt");
		var optLength = opts.length;
		
		if (qstnId) {
			id = qstnId;
		}

		for (var i = 0; i < optLength; i++) {
			var logic = "";
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
			
			if (question.logicFlag == 1) {
				$("#frstBtnGrp" + id).css("display", "none");
				$("#thrdBtnGrp" + id).css("display", "");
				
				logicNum = qstnOpt[i].logic;
				
				if (!isNaN(logicNum) && logicNum != -1 && logicNum != 0) {
					logic = SurveyMessages.strQs + " " + logicNum;
					
				} else if (logicNum == 0) {
					logic = SurveyMessages.strLast;
					
				} else {
					logic = SurveyMessages.strNoLogic;
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
		
		if (question.logicFlag == 1) {
			logicNum = qstnOpt[0].logic;
			logic = SurveyMessages.strQs + " " + logicNum;
			
			$("#frstBtnGrp" + id).css("display", "none");
			$("#thrdBtnGrp" + id).css("display", "");
			
			$("#slidLogicInput" + id).val(logicPoint).css("display", "none");
			$("#LogicPoint" + id).text(logicPoint).css("display", "");
			
			$("#slt" + id).val(logicNum).prop("selected", true).css("display", "none");
			$("#sltVal" + id).text(logic).css("dispaly", "");
		}
	}
	
	// dropdown 질문에 logic form 추가
	function drdwLogicForm(prevWrapper, htmlOption, question, qstnId) {
		var id = "";
		if (qstnId) {
			id = qstnId;
		}
		var prevQsOpt = prevWrapper.find(".prevQsOpt");
		var drdwOpt = question.option;
		var optLength = drdwOpt.length;
		
		var drdwLogicArea = $("<div id='logic" + id + "' class='drdwLogicArea'>");
		
		for (var i = 0; i < optLength; i++) {
			var logic = "";
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
			
			if (question.logicFlag == 1) {
				logicNum = opt.logic;
				//logic = (!isNaN(logicNum) && logicNum != -1) ? SurveyMessages.strQs + " " + logicNum : SurveyMessages.strNoLogic; 
				if (!isNaN(logicNum) && logicNum != -1 && logicNum != 0) {
					logic = SurveyMessages.strQs + " " + logicNum;
					
				} else if (logicNum == 0) {
					logic = SurveyMessages.strLast;
					
				} else {
					logic = SurveyMessages.strNoLogic;
				}
				
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

			!isNaN(logicNum) ? $("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "") : $("#slt" + id + i).val('').prop("selected", true).css("display", "");  
			$("#sltVal" + id + i).css("display", "none");
		}
	}
	
	// select 질문 객체, ui에 로직 value 추가
	function addSltLogic(id, qstn) {
		var wrapper = $("#prevQstn"+id);
		var opt = wrapper.find(".opt");
		var optLength = opt.length;
		
		for (var i = 0; i < optLength; i++) {
			var logic = "";
			var logicNum = $("select[name=slt" + id  + i +"] option:selected").val();
			// option 객체에 logic 추가
			qstn.option[i]['logic'] = parseInt(logicNum);
			
			if (logicNum != "" && logicNum != 0) {
				logic = SurveyMessages.strQs + " " + logicNum;
				
			} else if (logicNum == "") {
				logic = SurveyMessages.strNoLogic;
				
			} else {
				logic = SurveyMessages.strLast;
			}

			$("select[name=slt" + id + i + "]").css("display", "none");
			$("#sltVal" + id + i).text(logic).css("display", "");
		}
		return "success";
	}
	
	// slider 질문 logic form 나타내기
	function showSlidLogicForm(id, qstn) {
		var prevQsWrapper = $("#prevQstn" + id);
		
		var logicPoint = qstn['sliderLogicPoint'];
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
		
		if (inputVal != -1 && inputVal < maxVal) {
			if (!isNaN(logicNum)) {
				qstn['sliderLogicPoint'] = inputVal;
				qstn.option[0]['logic'] = parseInt(logicNum);
				
				$("#slidLogicInput" + id).css("display", "none");
				$("#LogicPoint" + id).text(inputVal).css("display", "");
				
				if (logicNum != 0) {
					logic = SurveyMessages.strQs + " " + logicNum;
					
				} else {
					logic = SurveyMessages.strLast; 
				}
				$("select[name=slt" + id + "]").css("display", "none");
				$("#sltVal" + id).text(logic).css("display", "");
				
				return "success";
				
			} else {
				alert(SurveyMessages.strchooseNum);
				return "fail";
			}
		} else {
			alert(SurveyMessages.strBetweenNum);
			return "fail";
		}
	}
	
	// dropdown 질문 logic form 나타내기
	function showDrdwLogicForm(id, qstn) {
		var prevQsWrapper = $("#prevQstn" + id);
		var logicRow = prevQsWrapper.find("#logic" + id).find(".drdwLogicRow");
		var RowLength = logicRow.length;
		
		var qstnOpt = qstn.option;
		
		for (var i = 0; i < RowLength; i++) {
			var logicNum = qstnOpt[i]['logic'];
			
			!isNaN(logicNum) ? $("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "") : $("#slt" + id + i).val('').prop("selected", true).css("display", "");
			$("#sltVal" + id + i).css("display", "none");
		}
	}
	
	// dropdown 질문 객체, ui에 로직 value 추가
	function addDrdwLogic(id, qstn) {
		var logicArea = $("#logic" + id);
		var rows = logicArea.find(".drdwLogicRow");
		var optLength = rows.length;
		
		for (var i = 0; i < optLength; i++) {
			var logic = "";
			var logicNum = $("select[name=slt" + id  + i +"] option:selected").val();
			qstn.option[i]['logic'] = parseInt(logicNum);
			
			if (logicNum != "" && logicNum != 0) {
				logic = SurveyMessages.strQs + " " + logicNum;
				
			} else if (logicNum == "") {
				logic = SurveyMessages.strNoLogic;
				
			} else {
				logic = SurveyMessages.strLast;
			}
			$("select[name=slt" + id + i + "]").css("display", "none");
			$("#sltVal" + id + i).text(logic).css("display", "");
		}
		return "success";
	}
	
	function mkSkipForm(id) {
		var prevWrapper = $("#prevQstn" + id);
		var qstnContent = prevWrapper.find(".question-content");
		var qstnList = SurveyCreate.getQs();
		var qstn = qstnList[id-1];
		var skipFlag = qstn['skipFlag'];
		
		var htmlOption = "";
		htmlOption += "<option value=''>" + SurveyMessages.strNoLogic + "</option>"; 
		
		for (var i = 0; i < qstnList.length; i++) {
			var qstnId = qstnList[i]["level"];
			if (qstnId > id) {
				htmlOption += "<option value='" + qstnId + "'>" + qstnId + "</option>"; 
			}
		}
		htmlOption += "<option value='0'>" + SurveyMessages.strLast + "</option>"; 
		
		var html = "";
		html += "<span id='skip" + id + "' class='skipArea'>";
		html += "<img class='skipArrow' src='/images/ezSurvey/arrow.png'>";
		html += "<select class='skipSelect' name='skip" + id + "'>";
		html += htmlOption;
		html += "</select>";
		html += "<span class='skipSpan' id='skipVal" + id + "'></span>";
		html += "</span>";
		
		qstnContent.append($(html)[0]);
		
		if (skipFlag == 1) {
			var skip = "";
			var skipNum = qstn['skip'];

			if (skipNum != "" && skipNum != 0) {
				skip = SurveyMessages.strQs + " " + skipNum;
				
			} else if (skipNum == 0) {
				skip = SurveyMessages.strLast;
			}
			
			$("select[name=skip" + id + "]").css("display", "none");
			$("#skipVal" + id).text(skip).css("display", "");
			
			$("#frstBtnGrp" + id).css("display", "none");
			$("#skipThrdBtnGrp" + id).css("display", "");
		}
	}
	
	// 로직 폼 제거
	function dltLogicForm(type, id) {
		if (type == 1 || type == 2) {
			var prevWrapper = $("#prevQstn" + id);
			var opt = prevWrapper.find(".opt");
			var optLength = opt.length;
			
			for (var i = 0; i < optLength; i++) {
				$("#logic" + id + i).remove();
			}

		} else {
			$("#logic" + id).remove();
		}
	}
	
	// 기존의 logicNum 나타냄
	function cnclLogicMdf(id, qstn, type) {
		if (type == 7) {
			var inputVal = qstn['sliderLogicPoint'];
			var logicNum = qstn.option[0]['logic'];
			var logic = "";
			
			$("#slidLogicInput" + id).val(inputVal).css("display", "none");
			$("#LogicPoint" + id).text(inputVal).css("display", "");
			
			logic = SurveyMessages.strQs + " " + logicNum;
			$("select[name=slt" + id + "]").css("display", "none");
			$("#sltVal" + id).text(logic).css("display", "");
			
		} else if (type == 1 || type == 2 || type == 9){
			var wrapper = $("#prevQstn"+id);
			var opt = "";
			var optLength = "";
			
			if (type == 1 || type == 2) {
				opt = wrapper.find(".opt");
				optLength = opt.length;
				
			} else if (type == 9) {
				opt = wrapper.find(".drdwLogicRow");
				optLength = opt.length;
			}
			
			for (var i = 0; i < optLength; i++) {
				var logic = "";
				var logicNum = qstn.option[i]['logic'];
				logic = (logicNum != "") ? SurveyMessages.strQs + " " + logicNum : SurveyMessages.strNoLogic;

				!isNaN(logicNum) ? $("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "none") : $("#slt" + id + i).val('').prop("selected", true).css("display", "none");
				$("#sltVal" + id + i).text(logic).css("display", "");
			}
		} else {
			var logicNum = qstn.option[0]['logic'];
			var logic = "";
			
			logic = SurveyMessages.strQs + " " + logicNum;
			$("select[name=slt" + id + "]").css("display", "none");
			$("#sltVal" + id).text(logic).css("display", "");
		}
		
	}
	
	function checkLogicNum(id, qstn, type) {
		var logicArr = []; 
		var wrapper = $("#prevQstn"+id);
		var opt = "";
		var optLength = "";
		var valI = "";
		var valJ = "";
		var result = "";
		
		if (type == 1 || type == 2) {
			opt = wrapper.find(".opt");
			optLength = opt.length;
			
		} else if (type == 9) {
			opt = wrapper.find(".drdwLogicRow");
			optLength = opt.length;
		}
		
		for (var i = 0; i < optLength; i++) {
			var logicNum = $("select[name=slt" + id  + i +"] option:selected").val();
			if (logicNum != "") {
				logicArr.push(logicNum);
			}
		}
		var arrLnegh = logicArr.length;
		
		for (var i = 0; i < arrLnegh; i++) {
			valI = logicArr[i];
			
			for (var j = i+1; j < arrLnegh; j++) {
				valJ = logicArr[j];
				
				if (valI == valJ) {
					if (confirm(SurveyMessages.strSameNum) == true) {
					result = 'Y';
					break;
					} else {
						return "fail";
					}
				}
			}
			if (result == 'Y') {
				break;
			}
		}
		
		return "success";
	}
	
	function confirmSurveyInfo(qstInf) {
		console.log(qstInf);
		var surveyInfWrap = document.getElementById("surveyInfConfirm");
		document.getElementById("cf-purpose").innerHTML      = qstInf["purpose"];
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
			var ulElmt       = document.getElementById("cf-attach");
			ulElmt.innerHTML = "";
			
			for (var i = 0; i < qstInf["attach"].length; i++) {
				var filename     = qstInf["attach"][i]["fname"];
				var furl         = qstInf["attach"][i]["furl"];
				var liElmt       = document.createElement("li");
				var divWrp       = document.createElement("div");
				var divImg       = document.createElement("div");
				var imgElmt      = document.createElement("img");
				var divInf       = document.createElement("div");
				divWrp.className = "attDivFile";
				divImg.className = "attImgAva";
				imgElmt.src      = questionFile.getImage(qstInf["attach"][i])["imageSrc"];
				
				if (furl) {
					divInf.className   = "attFileInf2";
					divInf.textContent = qstInf["attach"][i]["fname"];
					divInf.setAttribute("title", qstInf["attach"][i]["fname"]);
				}
				else {
					var spanTtl         = document.createElement("span");
					var spanSz          = document.createElement("span");
					spanTtl.textContent = filename;
					spanSz.textContent  = questionFile.getSize(qstInf["attach"][i]["fsize"]);
					spanTtl.setAttribute("title", filename);
					divInf.className  = "attFileInf";
					divInf.appendChild(spanTtl);
					divInf.appendChild(spanSz);
				}
				
				divImg.appendChild(imgElmt);
				divWrp.appendChild(divImg);
				divWrp.appendChild(divInf);
				liElmt.appendChild(divWrp);
				ulElmt.appendChild(liElmt);
			}
			
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
	
	function checkUrl(str) {var pattern = new RegExp("^(http|https)://", "i"); return pattern.test(str);}
	
	function saveLinkAttach(elmt) {
		var attachName = document.getElementById("attfileName");
		var attachUrl  = document.getElementById("attfileUrl");
		
		if (!replaceAll(attachName.value, " ", "")) {alert(SurveyMessages.strURL1); attachName.focus(); return;}
		if (!replaceAll(attachUrl.value, " ", ""))  {alert(SurveyMessages.strURL2); attachUrl.focus() ; return;}
		if (!checkUrl(attachUrl.value))             {alert(SurveyMessages.strURL3); attachUrl.focus() ; return;}
		var mainUlElmt = elmt ? elmt.querySelector("ul[class='qstUl']") : document.getElementById("fileDiv").querySelector("ul[class='ulFiles']");
		
		//Create liElmt for link
		var liElmt               = document.createElement("li");
		var divMainElmt          = document.createElement("div");
		var divChildElmt1        = document.createElement("div");
		var imgElmt              = document.createElement("img");
		var delImgElmt           = document.createElement("img");
		var divChildElmt2        = document.createElement("div");
		var spanChild1           = document.createElement("span");
		imgElmt.src              = "/images/ezSurvey/link.png";
		delImgElmt.src           = "/images/ezSurvey/file_del.gif";
		delImgElmt.addEventListener("click", function(e) {deleteUrlFile(e);}, false);
		divChildElmt1.className  = "attImgAva";
		divMainElmt.className    = "attDivFile";
		divChildElmt2.className  = "attFileInf2";
		divChildElmt2.textContent = attachName.value;
		divChildElmt2.setAttribute("title", attachName.value);
		divChildElmt1.appendChild(imgElmt);
		divMainElmt.appendChild(divChildElmt1);
		divMainElmt.appendChild(divChildElmt2);
		liElmt.appendChild(divMainElmt);
		liElmt.appendChild(delImgElmt);
		liElmt.setAttribute("fname", attachName.value);
		liElmt.setAttribute("furl", attachUrl.value);
		mainUlElmt.appendChild(liElmt);
		toggleUrlPanel();
	}
	
	function deleteUrlFile(event) {
		event.stopPropagation();
		var liElmt = event.currentTarget.parentElement;
		liElmt.parentElement.removeChild(liElmt);
	}
	
	function toggleUrlPanel(elmt) {
		var rightFrame  = window.parent.frames["right"].document;
		var urlPanel    = rightFrame.getElementById("addURLPanel");
		if (urlPanel.className == "searchPanel off") {
			addFogPanel(toggleUrlPanel);
			var position         = getPosition(466, 210);
			urlPanel.style.top   = position[0] + "px";
			urlPanel.style.right = position[1] + "px";
			urlPanel.className   = "searchPanel";
			document.getElementById("addUrlAttach").onclick = function(e) {saveLinkAttach(elmt);};
		}
		else {
			removeFogPanel();
			urlPanel.className   = "searchPanel off";
		}
		
		//Clear all fields
		rightFrame.getElementById("attfileName").value = "";
		rightFrame.getElementById("attfileUrl").value  = "";
	}
	
	function replaceAll(str, find, replace) {return str.replace(new RegExp(find, 'g'), replace);}
	
	function getSurveyPurpose() {
		var purpose = surveyObj["infor"]["purpose"] ? surveyObj["infor"]["purpose"] : "";
		return purpose;
	}
	
	return {
		getUsers   : getSurveyUsers,
		setUsers   : setSurveyUsers,
		getQs      : getSurveyQuestions,
		setQs      : setSurveyQuestions,
		getInfo    : getSurveyInfo,
		userMore   : toggleUserPreview,
		showUser   : showUserInfoFromId,
		start      : initEvents,
		setQsForm  : prevQstn,
		convertQs  : getReuseQuestions,
		getPurpose : getSurveyPurpose
	};
}();

function Editor_Complete() {
	document.getElementById("info-input-pp").contentWindow.SetEditorContent(SurveyCreate.getPurpose());
}