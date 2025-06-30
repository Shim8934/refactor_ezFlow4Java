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
	var downloadMode = false;
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
		 { text : SurveyMessages.strDropdown, value: 9, selected: false, imageSrc: "/images/ezSurvey/qsType09.png"},
		 { text : SurveyMessages.strScheduleOne, value: 10, selected: false, imageSrc: "/images/ezSurvey/qsType10.png"},
		 { text : SurveyMessages.strScheduleMtp, value: 11, selected: false, imageSrc: "/images/ezSurvey/qsType11.png"}];
	// 설문 저장 및 설문 정보 불러올 시 사용되는 설문 객체
	var surveyObj   = {
		// 설문 정보 관련 사항
		infor     : {},
		// 질문 관련 사항
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
	
	var datepickerSchedule   = {
		changeMonth    : true,
		changeYear     : true,
		autoSize       : true,
		showOn         : "both",
		buttonImage    : "/images/ImgIcon/calendar-month.gif",
		buttonImageOnly: true,
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
		// 2020.04.23 강승구 : 수정작업 중 다른메뉴 클릭시 modifyflag 수정하는 코드추가
		if(reuseSurvey){		window.parent.frames["left"].surveyId = reuseSurvey.surveyId;	}
		surveyItem            = reuseSurvey     ? reuseSurvey.surveyId    : null;
		var modifyFlag        = reuseSurvey     ? reuseSurvey.modifyFlag  : 0;
		surveyObj["surveyId"] = modifyFlag == 1 ? reuseSurvey["surveyId"] : -1;
		var fileDivElmt       = document.getElementById("fileDiv");
		
		$("#startDate").datepicker(datepickerSt);
		$("#endDate").datepicker(datepickerSt);
		// 설문 생성시, 재사용인지 처음 생성하는 것인지 확인
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
            // 설문 수정/재사용 > 설문결과 > 지정공개 대상자 정보 삽입
            if (reuseSurvey["resultPublicFlag"] == 2) {
                setSurveyResultUsers(reuseSurvey["resultViewTarget"]);
                $("#rspdtList2").addClass('on');
            }
			if (reuseSurvey["closingText"] != "") {surveyObj["infor"]["closing"] = reuseSurvey["closingText"];}
			
			getReuseQuestions();
		}
		
		window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
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
		// 설문 작성 > 설문대상 지정자, 설문결과 지정공개 대상자 조회팝업 호출 버튼 이벤트 삽입
		var userMoreElmt        = document.querySelector("#cf-userdiv span[class='user-more']");
		if (userMoreElmt) {userMoreElmt.onclick = function(e) {toggleUserPreview('survey');};}
        var userMoreResultElmt        = document.querySelector("#public-cfdiv span[class='user-more']");
        if (userMoreResultElmt) {userMoreElmt.onclick = function(e) {toggleUserPreview('result');};}
		var draftBttn           = document.getElementById("draftBttn");
		if (draftBttn) {draftBttn.onclick = function(e) {saveDraftSurvey();};}
		
		document.getElementById("addUrlClose").onclick   = function(e) {toggleUrlPanel();};
		document.getElementById("addUrlBttn").onclick    = function(e) {toggleUrlPanel();};
		document.getElementById("addFileBttn").onclick   = function(e) {startUpload();};
		document.getElementById("closeLogicPl").onclick  = function(e) {toggleLogicPanel();};
		document.getElementById("showLogicMap").onclick  = function(e) {toggleLogicPanel();};
		document.getElementById("userListDiv").onscroll  = function(e) {scrollListOfUser(this);}
		document.getElementById("logicMapWrap").onscroll = function(e) {hideQtipDiv();}
		
		document.onselectstart = function() {return false;};
		var targetSpanList     = document.getElementsByName("targetSpan");
		var publicSpanList     = document.getElementsByName("publicSpan");
		
		for (var i = 0, len = targetSpanList.length; i < len; i++) {
			targetSpanList[i].onchange = function(e) {toggleSelectTargetBttn(this)};
		}
		
		for (var i = 0, len = publicSpanList.length; i < len; i++) {
			publicSpanList[i].onchange = function(e) {toggleDaysInput(this)};
		}
		
		var firstTab  = document.getElementsByClassName("gotoFirstTab");
		var secondTab = document.getElementsByClassName("gotoSecondTab");
		var thirdTab  = document.getElementsByClassName("gotoThirdTab");
		var forthTab  = document.getElementsByClassName("gotoForthTab");
		var cancelSv  = document.getElementsByClassName("cancelSurvey");
		
		for (var i = 0, len = firstTab.length; i < len; i++) {
			firstTab[i].addEventListener("click", gotoFirstStep, false);
		}
		
		for (var i = 0, len = secondTab.length; i < len; i++) {
			secondTab[i].addEventListener("click", gotoSecondStep, false);
		}
		
		for (var i = 0, len = thirdTab.length; i < len; i++) {
			thirdTab[i].addEventListener("click", gotoThirdStep, false);
		}
		
		for (var i = 0, len = forthTab.length; i < len; i++) {
			forthTab[i].addEventListener("click", gotoForthStep, false);
		}
		
		for (var i = 0, len = cancelSv.length; i < len; i++) {
			cancelSv[i].addEventListener("click", cancelThisSurvey, false);
		}
		
		// 설문 작성 > 설문대상 지정자, 설문결과 지정공개 대상자 선택 팝업 호출
		document.getElementById("targetBttn"    ).addEventListener("click" , () => {showSelectPopUp('survey')} , false);
		document.getElementById("selectResultTargetBtn"    ).addEventListener("click" , () => {showSelectPopUp('result')} , false);
		// 설문 작성 > 설문대상 지정자, 설문결과 지정공개 대상자 리스트 조회 팝업창 닫기
		document.getElementById("closeUserPanel").addEventListener("click",  () => {toggleUserPreview('close')}, false);		
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
	// 설문 임시저장
	function saveDraftSurvey() {
		//Check survey information
		returnObj = checkStep1();
		if (returnObj["error"]) {alert(returnObj["error"]); return;}
		surveyObj["draft"] = 1;
		
		$.ajax({
			type: "POST",
			url: "/ezSurvey/saveSurvey.do",
			data: JSON.stringify(surveyObj),
			contentType: "application/json; charset=utf-8",
			dataType: "JSON",
			async: false,
			cache: false,
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
			async: false,
			cache: false,
			success : function(data) {},
			error : function(error) {}
		});
	}
	
	function startUpload() {document.getElementById("fileBttn").click();}
	function cancelThisSurvey() { 
		// 2020.04.23 강승구 : 취소 후 modifyflag 수정 및 취소메세지 추가
		if(confirm(SurveyMessages.strCancelMsg) == true) {
			surveyObj['infor'] = {};
			surveyObj['questions'] = [];
			changeSurveyState();
			window.parent.frames["left"].surveyId = -1;
			window.parent.frames["left"].isInCreateSurvey = false; // 신규 설문 생성 취소
			var ingSurveyLi = window.parent.frames["left"].document.getElementById("processingSurvey");
			if (ingSurveyLi.querySelector(".list_text") && ingSurveyLi.tagName == "LI") {
				window.parent.frames["left"].$(".node_selected").attr("class", "list_text");
				ingSurveyLi.querySelector(".list_text").setAttribute("class", "list_text node_selected");
			}
			window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=processing";
		}
	}
	// 설문 저장
	function saveSurvey() {
		if(confirm(SurveyMessages.strSaveAsk) == true) {
			var saveSurveybtn = document.getElementById('saveSurvey');
			saveSurveybtn.style.pointerEvents = 'none';
			$.ajax({
				type: "POST",
				url: "/ezSurvey/saveSurvey.do",
				data: JSON.stringify(surveyObj),
				contentType: "application/json; charset=utf-8",
				dataType: "JSON",
				async: false,
				cache: false,
				success : function(data) {
					afterSaveSuccessfully(data);
				},
				error : function(error) {
					saveSurveybtn.style.pointerEvents = '';
					alert(SurveyMessages.strError);
				}
			});
		}
	}
	// 설문 정보 저장
	function saveSurveyInformation() {
		var surveyInfoWrap = document.querySelector("div[class='surveyinfo-wrap']");
		var surveyAttWrap  = document.querySelector("div[class='survey-attach']");
		var surveyTitle    = document.getElementById("info-input-ttl").value;
		var surveyPurpose  = "";
		if (editor != "HWP") {
			surveyPurpose = replaceAll(document.getElementById("info-input-pp").contentWindow.GetEditorContent(), "(&lt;(\/?)(script|applet|object)&gt;)", "");
		} else {
			surveyPurpose = hwpHTML;
		}
		
		var startDate      = document.getElementById("startDate").value;
		var endDate        = document.getElementById("endDate").value;
		var publicFlag     = parseInt(document.querySelector('input[name="publicSpan"]:checked').value);
		var anonymousFlag  = parseInt(document.querySelector('input[name="anonymousSpan"]:checked').value);
		var multipleFlag   = parseInt(document.querySelector('input[name="multipleSpan"]:checked').value);
		var userFlag       = parseInt(document.querySelector('input[name="targetSpan"]:checked').value);
		var mailFlag       = parseInt(document.querySelector('input[name="mailSpan"]:checked').value);
		var popupFlag       = parseInt(document.querySelector('input[name="popupSpan"]:checked').value);
		var liFileList     = surveyAttWrap.querySelector("ul[class='ulFiles']").children;
		var attachList     = [];
		var closingText    = document.getElementById("closingText").value;
		
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
		surveyObj["infor"]["mail"]      = mailFlag;
		surveyObj["infor"]["popup"]     = popupFlag;
		surveyObj["infor"]["closing"]   = closingText;
		
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
	}
	
	function afterSaveDraftSuccessfully(data) {
		var code = data.code;
		switch(code) {
			case 0 : alert(SurveyMessages.strSaveDraft);
					 window.parent.frames["left"].surveyId = -1;
					 window.parent.frames["left"].isInCreateSurvey = false; // 신규 설문 임시저장 완료
					 window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=draft";
					 break;
			case 1 : alert(SurveyMessages.strParamErr) ; break;
			case 2 : alert(SurveyMessages.strError)    ; break;
			default: alert(SurveyMessages.strError)    ; return;
		}
	}
	
	function afterSaveSuccessfully(data) {
		var saveSurveybtn = document.getElementById('saveSurvey');
		var code = data.code;
		switch(code) {
			case 0 : window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=processing";
					 window.parent.frames["left"].surveyId = -1;
					 window.parent.frames["left"].isInCreateSurvey = false; // 신규 설문 생성 완료
					 break;
			case 1 : alert(SurveyMessages.strParamErr); saveSurveybtn.style.pointerEvents = ''; break;
			case 2 : alert(SurveyMessages.strError)   ; saveSurveybtn.style.pointerEvents = ''; break;
			default: alert(SurveyMessages.strError)   ; saveSurveybtn.style.pointerEvents = ''; return;
		}
	}
	// 설문 정보 입력 단계
	function gotoFirstStep() {
		hwpCheck = false;
		var listTabElmt          = document.getElementsByClassName("headpanel")[0].children;
		listTabElmt[0].className = "crust selected";
		listTabElmt[1].className = "crust";
		listTabElmt[2].className = "crust";
		listTabElmt[3].className = "crust";
		
		$("div[id^=tab]").attr("class", "hidden-tab");
		document.getElementById("tab1").className = "select-tab";
		lastStep = 1;
	}
	// 질문 생성 단계
	function gotoSecondStep() {
		if (editor == "HWP" && !hwpCheck) {
			getHTML(gotoSecondStep);
			return;
		}
		
		var backFlag = "";
		if (enterLogic == 'Y') {backFlag = deleteAllLogics();}	// 로직 설정 단계에 진입했는지 확인

		if (backFlag != 'N') {
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
	}
	// 분기 설정 단계
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
		showSurveyQuestions(lastStep);
	}
	// 설문 확인 단계
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
		showSurveyQuestions(lastStep);
	}
	
	function selectStep(tabIdx, spanElemt) {
		var crrSpan = document.querySelector("span[class='crust selected']");
		if (crrSpan == spanElemt) {return;}
		var checkObj = null;
		var backFlag = "";
		switch(parseInt(tabIdx)) {
			case 1: hwpCheck = false;
					focusonQuestionTitleStep1(); 
					toggleStep(spanElemt, crrSpan, tabIdx);
					lastStep = 1; break;
			case 2: if (enterLogic == 'Y') {
						backFlag = deleteAllLogics();
						if (backFlag == 'N') {break;}
					}	// 로직 설정 단계에 진입했는지 확인
					checkObj = prepareForStep2();
					if (checkObj["error"]) {alert(checkObj["error"]); return;}
					toggleStep(spanElemt, crrSpan, tabIdx);
					focusonQuestionTitleStep2();
					lastStep = 2; break;
			case 3: checkObj = prepareForStep3();
					if (checkObj["error"]) {alert(checkObj["error"]); return;}
					toggleStep(spanElemt, crrSpan, tabIdx);
					showSurveyQuestions(tabIdx);
					enterLogic = 'Y';
					lastStep = 3; break;
			case 4: if (editor == "HWP" && !hwpCheck) {
						getHTML4(selectStep, tabIdx, spanElemt);
						return;
					}
					checkObj = prepareForStep4();
					if (checkObj["error"]) {alert(checkObj["error"]); return;}
					toggleStep(spanElemt, crrSpan, tabIdx);
					showSurveyQuestions(tabIdx);
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
	function showSurveyQuestions(step) {prevQstn(step);}
	
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
			//returnObj = checkQsCount();
			//if (returnObj["error"]) {return returnObj;}
		}
		
		if (!!document.querySelector("div[class='quesDiv']").querySelector("input[class='questnTitle']")) {
			document.querySelector("div[class='quesDiv']").querySelector("input[class='questnTitle']").focus();
		}
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
		var ppContent  = "";
		if (editor != "HWP") {
			ppContent = surveyPp.GetEditorContent(); 
		} else {
			ppContent = hwpHTML;
		}
		
		var sDate      = document.getElementById("startDate").value;
		var eDate      = document.getElementById("endDate").value;
		var publicFlag = parseInt(document.querySelector('input[name="publicSpan"]:checked').value);
		var userFlag   = parseInt(document.querySelector('input[name="targetSpan"]:checked').value);
		
		var mailFlag   = parseInt(document.querySelector('input[name="mailSpan"]:checked').value);
		var popupFlag   = parseInt(document.querySelector('input[name="popupSpan"]:checked').value);
		
		var userList   = surveyObj["infor"]["users"];
		var userResultList = surveyObj["infor"]["resultViewTarget"]; // 설문결과 지정조회 대상자
		var ttlValue   = replaceAll(surveyTtl.value, " ", "");
		var today = getToday();
		
		if (!ttlValue)     {returnObj["error"] = SurveyMessages.strTitle  ; surveyTtl.value = ""; surveyTtl.focus(); return returnObj;}
		if (!sDate)        {returnObj["error"] = SurveyMessages.strSvDate3; return returnObj;}
		if (!eDate)        {returnObj["error"] = SurveyMessages.strSvDate2; return returnObj;}
		if (sDate < today) {returnObj["error"] = SurveyMessages.strSvDate4; return returnObj;}
		if (sDate > eDate) {returnObj["error"] = SurveyMessages.strSvDate1; return returnObj;}
		
		if (publicFlag == 1) {
			var daysInput = document.querySelector("input[class='date-input']");
			if (!isValid(daysInput.value)) {returnObj["error"] = SurveyMessages.strInvalid; daysInput.focus(); return returnObj;}
		}
		
		if (userFlag == 1 && !userList) {returnObj["error"] = SurveyMessages.strUser1; return returnObj;}
		if (publicFlag == 2 && !userResultList) {returnObj["error"] = SurveyMessages.strUser1; return returnObj;}
		
		//Check attach file progress
		var divFileList = document.getElementById("fileDiv");
		var canvasList  = divFileList.querySelectorAll("canvas");
		if (canvasList && canvasList.length > 0) {returnObj["error"] = SurveyMessages.strAttachErr; return returnObj;}
		
		var surveyttlList = document.querySelectorAll("div[class='survey-title']");
		for (var i = 0, len = surveyttlList.length; i < len; i++) {
			surveyttlList[i].textContent = replaceAll(surveyTtl.value, "(<(\/?)(script|applet|object)>)", "");
		}
		
		if (lastStep == 1) {
			saveSurveyInformation();
		}
		return returnObj;
	}
	
	function getToday() {
		var today     = new Date();
		var yyyy      = today.getFullYear();
		var MM        = today.getMonth() + 1;
		var dd        = today.getDate();
		
		if (dd < 10) {dd = '0' + dd;}
		if (MM < 10) {MM = '0' + MM;}
		
		today = yyyy + "-" + MM + "-" + dd;
		return today;
	}
	
	function checkStep2() {
		var returnObj    = {};
		var questionList = getSurveyQuestions();
		if (questionList.length == 0) {returnObj["error"] = SurveyMessages.strQuestion; return returnObj;}
		
		return returnObj;
	}
	/*
	function checkQsCount() {
		var returnObj    = {};
		var questionList = getSurveyQuestions();
		
		if (questionList.length < 1) {returnObj["error"] = SurveyMessages.strQsCount; return returnObj;}
		return returnObj;
	}
	*/
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
	// 분기 설정 이후 step2로 되돌아갈 시, 질문의 모든 분기 삭제
	function deleteAllLogics() {
		var questionList = surveyObj.questions;
		var questionLength = questionList.length;
		var result = checkAllLogicAndSkip(questionList, questionLength);
		var backFlag = 'Y';
		
		if (result == 'Y') {
			if (confirm(SurveyMessages.strBack) == true) {
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
			} else {
				backFlag = 'N';
			}
			return backFlag;
		}
	}
	// 분기 유무 체크
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
	
	function toggleSelectTargetBttn(inputElmt) {
		var sltedIdx = inputElmt.getAttribute("value");
		
		if (sltedIdx == 0) {
			document.getElementById("rspdtList").setAttribute("class", "rspdtList");
			surveyObj["infor"]["users"] = null;
			document.getElementById("userListDiv").innerHTML = "";
		}
		else {
			document.getElementById("rspdtList").setAttribute("class", "rspdtList on");
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
	
	// 설문 > 설문결과 타입 선택 라디오박스 동작
	function toggleDaysInput(inputElmt) {
        var slxIdx    = inputElmt.getAttribute("value");
        var inputElmt = document.querySelector("input[class='date-input']");
        
        if (slxIdx == 1) {
            $(inputElmt).attr('disabled', false);
            $(inputElmt).val("0");
            $('#userResultList_div').text("");
            $("#rspdtList2").removeClass("on"); 
            surveyObj["infor"]["resultViewTarget"] = null;
        } else if (slxIdx == 2) {
            $(inputElmt).attr('disabled', true);
            $(inputElmt).val("");
            $("#rspdtList2").addClass("on");
        } else {
            $(inputElmt).attr('disabled', true);
            $(inputElmt).val("");
            $('#userResultList_div').text("");
            $("#rspdtList2").removeClass("on");
            surveyObj["infor"]["resultViewTarget"] = null;
        }
	}
	
	// 설문 > 설문대상 지정자, 설문결과 지정공개 대상자 리스트 조회 팝업 호출
	// mode: survey : 설문대상 / result: 설문결과 / close: 창 닫기
	function toggleUserPreview(mode) {
		var userPanel = document.getElementById("userPanel");
		if (mode == 'survey') {
		    $('#user-tblmain').show();
		    $('#userResult-tblmain').hide();
		} else if (mode == 'result') {
		    $('#user-tblmain').hide();
        	$('#userResult-tblmain').show();
		}
		
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
		fogPanel.onclick              = function(e) {togglePanel('close');};
		leftFogPanel.onclick          = function(e) {togglePanel('close');};
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
		hideQtipDiv();
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
	
	/* 2021-08-27 홍승비 - 직위/직책/권한그룹인 경우 이름만 표출하도록 수정 (함수에서 이름을 그대로 전달하여 표출), 사간겸직 대응 추가 */
	function showUserInfoFromId(userId, userType, userName, deptId) {
		var feature = "height=450px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
		feature = feature + getOpenWindowfeature(420, 450);
		userWindow = window.open("/ezCommon/showPersonInfo.do?id=" + userId + "&userType=" + userType + "&userName=" + userName + "&dept=" + deptId, "userInfo", feature);
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
	
	// 설문대상 지정자, 설문결과 지정공개 대상자 리스트 간단표출
	function showUserList(mode) {
		var userTempArr;
		var divElmt;
		if (mode == 'survey') {
		   userTempArr = surveyObj["infor"]["users"];
		   divElmt = document.getElementById("userListDiv");
		} else if (mode == 'result') {
		    userTempArr = surveyObj["infor"]["resultViewTarget"];
		    divElmt = document.getElementById("userResultList_div");
		} 
		
		while (divElmt.firstElementChild) {
			divElmt.removeChild(divElmt.firstElementChild);
		}
		
		for (var i = 0, len = userTempArr.length; i < len; i++) {
			var spanElmt = document.createElement("span");
			var uElmt    = document.createElement("u");
			var imgElmt  = document.createElement("img");
			var divideSpan = document.createElement("span");
			uElmt.setAttribute("role", userTempArr[i]["userId"]);
			uElmt.setAttribute("type", userTempArr[i]["userType"]);
			uElmt.textContent    = userTempArr[i]["userName"];
			uElmt.onclick        = (function(userId, userType, userName, deptId){return function() {showUserInfoFromId(userId, userType, userName, deptId);};})(userTempArr[i]["userId"], userTempArr[i]["userType"], userTempArr[i]["userName"], userTempArr[i]["deptId"]);
			imgElmt.onclick      = (function(userId, userType){return function() {removeUser(this, userId, userType);};})(userTempArr[i]["userId"], userTempArr[i]["userType"]);
			spanElmt.className   = "rlSpanBnk";
			divideSpan.textContent = ";";
			imgElmt.src          = "/images/icon/oneline_delete.gif";
			spanElmt.appendChild(uElmt);
			spanElmt.appendChild(divideSpan);
			spanElmt.appendChild(imgElmt);
			divElmt.appendChild(spanElmt);
		}
	}
	
	// 설문대상 지정자, 설문결과 지정공개 대상자 리스트 간단삭제
	function removeUser(imgElmt, userId, userType) {
		var id = imgElmt.closest("div").id;
		var userArr;
		if (id == 'userListDiv') {
		    userArr = surveyObj["infor"]["users"];
		} else if (id == 'userResultList_div') {
		    userArr = surveyObj["infor"]["resultViewTarget"];
		}
		
		for (var i = 0 ; i < userArr.length; i++) {
			if (userArr[i]["userId"] == userId && userArr[i]["userType"] == userType) {userArr.splice(i, 1);}
		}
		
        if (id == 'userList_div') {
            surveyObj["infor"]["users"] = userArr;
        } else if (id == 'userResultList_div') {
            surveyObj["infor"]["resultViewTarget"] = userArr;
        }
        
		var spanElmt = imgElmt.parentElement;
		spanElmt.parentElement.removeChild(spanElmt);
	}
	// 재사용할 설문 정보 획득
	function getReuseQuestions() {
		$.ajax({
			type: "GET",
			url: "/ezSurvey/getSurveyQuestions.do",
			data: {surveyId : surveyItem},
			contentType: "application/json; charset=utf-8",
			dataType: "JSON",
			async: true,
			cache: false,
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
		if (data["questions"] && data["questions"].length > 0) {
			surveyObj["questions"] = JSON.parse(JSON.stringify(data["questions"]));
		}
		else {
			surveyObj["questions"] = [];
		}
		
		reuseQstns(surveyObj["questions"]);
		// question input 및 img 생성
		createQuestionDiv();
		
		// question selectBox 생성
		createQuestionSelectBox();
		addOptEvent();
	}
	
	function toggleLogicPanel() {
		var userPanel = document.getElementById("logicPanel");
		if (userPanel.className == "logicPanel off") {
			addFogPanel(toggleLogicPanel);
			var position          = getPosition(600, 640);
			userPanel.style.top   = position[0] + "px";
			userPanel.style.right = position[1] + "px";
			userPanel.className   = "logicPanel";
			showLogicMap();
		}
		else {
			removeFogPanel();
			userPanel.className   = "logicPanel off";
		}
	}
	// 분기맵 나타내기
	function showLogicMap() {
		if (!bnk) {
			bnk = cytoscape({
				container: document.getElementById("logicMap"),
				boxSelectionEnabled: false,
				ready: function(){},
				style: [
					{selector: 'node', css: {"content": "data(name)", "font-size": 12, "width" : 27,"height" : 27, "background-color": "#3d8fea"}},
					{selector: 'edge', css: {"target-arrow-shape": "triangle", "width" : 10, "line-color": "#aeaeae"}},
					{selector: 'node:selected', css: {'background-color': '#b32d00',}},
					{selector: 'edge:selected', css: {"width" : 13, "line-color": "#b32d00"}},
				],
				//minZoom: 1,
				//maxZoom: 5,
				//wheelSensitivity: 1,
				zoomingEnabled: false,
			});
		}
		
		var data = createJsonElements();
		
		bnk.elements().remove();
		bnk.add(data["elements"]); 
		bnk.layout({name: 'dagre', rankDir: 'TB', nodeSep: 100,}).run();
		
		bnk.on('mouseover', 'node', function(e){$('#logicMap').css('cursor', 'pointer');});
		bnk.on('mouseout' , 'node', function(e){$('#logicMap').css('cursor', 'default');});
		bnk.on('mouseover', 'edge', function(e){$('#logicMap').css('cursor', 'pointer');});
		bnk.on('mouseout' , 'edge', function(e){$('#logicMap').css('cursor', 'default');});
		// cytoscape 범위 블락 초기화
		bnk.on('mouseup', function(event) {
			
			var len      = bnk.elements().size()*50;
			var curPan   = bnk.pan();
			var initFlag = false;
			
			if(len*(-1) > curPan.x) initFlag = true;
			if(len*(-1) > curPan.y) initFlag = true;
			if(len < curPan.x) initFlag = true;
			if(len < curPan.y) initFlag = true;
			
			if(initFlag) {
				bnk.resize();
				bnk.fit();
				bnk.center();
			}
		});
		
		bnk.elements('node').qtip({
			content: {
				 text: function(){
					return generateMapTreeNode(this.id());
				}
			},
			show: {event: 'click'},
			hide: {event: 'mouseout'},
			position: {
				my: "top center",
				at: "bottom center"
			},
			style: {
				classes: "qtip-bootstrap",
				tip: {width: 16, height: 8}
			}
		});
		
		bnk.elements('edge').qtip({
			content: {
				 text: function(){
					var edgeData = this.data();
					return generateMapTreeEdge(parseInt(edgeData["source"]), parseInt(edgeData["target"]), data["questionsWithoutTarget"]);
				}
			},
			show: {event: 'click'},
			hide: {event: 'mouseout'},
			position: {
				my: "top center",
				at: "bottom center"
			},
			style: {
				classes: "qtip-bootstrap",
				tip: {width: 16, height: 8}
			}
		});
		
		var bounds = bnk.elements().boundingBox();
		var height = (bounds.h + 60) > 2000 ? 2000 : bounds.h + 60;
		document.getElementById("logicMap").style.height = height + "px";
		bnk.resize();
		bnk.fit();
		bnk.center();
	}
	
	function generateMapTreeEdge(sourceId, targetId, questionsWithoutTarget) {
		var sourceQst = surveyObj["questions"].filter(function(qst) {return qst["level"] == sourceId;})[0];
		var table     = document.createElement("table");
		var trTitle   = document.createElement("tr");
		var thTitle   = document.createElement("th");
		thTitle.setAttribute("colspan", 2);
		thTitle.textContent = SurveyMessages.strOptionAll;
		trTitle.appendChild(thTitle);
		table.appendChild(trTitle);
		
		var options = sourceQst["option"];
		var optList = [];
		
		var defaultTarget = -1;
		for (var i = 0; i < questionsWithoutTarget.length; i++) {
			if (sourceQst["level"] < questionsWithoutTarget[i]) {
				defaultTarget = questionsWithoutTarget[i];
				break;
			}
		}
		
		if (sourceQst["logicFlag"] == 1) {
			for (var j = 0; j < options.length; j++) {
				var logicNum = options[j]["logic"];
				var destQst  = -1;
				
				if (isNaN(logicNum) || logicNum == -1 ) {
					destQst = defaultTarget;
				}
				else {
					destQst  = logicNum;
				}
				
				if (destQst == targetId) {
					optList.push(JSON.parse(JSON.stringify(options[j])));
				}
			}
			
			generateLogicpEdgeTip(table, optList, sourceQst, targetId);
		}
		else {
			generateSkipEdgeTip(table);
		}
		
		table.className = "bnk-qtiptable";
		return table;
	}
	
	function generateLogicpEdgeTip(table, optList, sourceQst, targetId) {
		switch (parseInt(sourceQst["type"])) {
			case 1: makeCommonToolTip(table, optList)                           ; break;
			case 7: makeSliderEdgeToolTip(table, sourceQst, targetId) 			; break;
			case 8: makeCommonToolTip(table, optList)                           ; break;
			case 10: makeCommonToolTip(table, optList)                           ; break;
		}
	}
	
	function makeSliderEdgeToolTip(table, sourceQst, targetId) {
		var sliderLogic = sourceQst["sliderLogicPoint"];
		var qstLevel    = parseInt(sourceQst["level"]);
		var distance    = targetId - qstLevel;
		var sliderStr   = (distance == 1) ? sliderLogic + " " + SurveyMessages.strLessThan : sliderLogic + " " + SurveyMessages.strMore;
		
		var trElmt  = document.createElement("tr");
		var tdElmt1 = document.createElement("td");
		tdElmt1.setAttribute("colspan", 2);
		tdElmt1.className   = "tip-maininf";
		tdElmt1.textContent = sliderStr;
		tdElmt1.setAttribute("title", tdElmt1.textContent);
		trElmt.appendChild(tdElmt1);
		table.appendChild(trElmt);
	}
	
	function generateSkipEdgeTip(table) {
		var trOption   = document.createElement("tr");
		var tdOption   = document.createElement("td");
		tdOption.setAttribute("colspan", 2);
		tdOption.className   = "tip-maininf";
		tdOption.textContent = SurveyMessages.strViewAll;
		trOption.appendChild(tdOption);
		table.appendChild(trOption);
	}
	
	function generateMapTreeNode(qstLevel) {
		var question  = surveyObj["questions"].filter(function(qst) {return qst["level"] == qstLevel;})[0];
		var questType = parseInt(question["type"]);
		var table     = document.createElement("table");
		var trTitle   = document.createElement("tr");
		var thTitle   = document.createElement("th");
		thTitle.setAttribute("colspan", 2);
		thTitle.textContent = SurveyMessages.strQs + qstLevel + ". " + question["content"];
		trTitle.appendChild(thTitle);
		table.appendChild(trTitle);
		
		switch (questType) {
			case 1: 
			case 2: makeCommonToolTip(table, question["option"])        ; break;
			case 3: 
			case 4: makeMatrixNodeToolTip(table, question["option"])    ; break;
			case 5: makeTextNodeToolTip(table,SurveyMessages.strShortQs); break;
			case 6: makeTextNodeToolTip(table,SurveyMessages.strLongQs) ; break;
			case 7: makeSliderNodeToolTip(table, question["option"])    ; break;
			case 8: 
			case 9: makeCommonToolTip(table, question["option"])        ; break;
			case 10:
			case 11: makeCommonToolTip(table, question["option"])        ; break;
		}
		
		table.className = "bnk-qtiptable";
		return table;
	}
	
	function hideQtipDiv() {
		var qtipDiv = document.querySelector("div[class='qtip qtip-default qtip-bootstrap qtip-pos-tc qtip-focus']");
		if (qtipDiv) {qtipDiv.style.opacity = 0;}
	}
	
	function makeRankingDropDownNodeToolTip(table, options) {
		for (var i = 0; i < options.length; i++) {
			var trElmt  = document.createElement("tr");
			var tdElmt1 = document.createElement("td");
			var tdElmt2 = document.createElement("td");
			tdElmt1.className   = "tip-inf";
			tdElmt2.className   = "tip-maininf";
			tdElmt1.textContent = SurveyMessages.strOption + " " + (options[i]["level"] + 1) + ": ";
			tdElmt2.textContent = options[i]["content"];
			tdElmt2.setAttribute("title", tdElmt2.textContent);
			trElmt.appendChild(tdElmt1);
			trElmt.appendChild(tdElmt2);
			table.appendChild(trElmt);
		}
	}
	
	function makeSliderNodeToolTip(table, options) {
		for (var i = 0; i < options.length; i++) {
			var trElmt    = document.createElement("tr");
			var tdElmt1   = document.createElement("td");
			var tdElmt2   = document.createElement("td");
			var strSlider = options[i]["level"] == 0 ? SurveyMessages.strSlider8 : SurveyMessages.strSlider9;
			tdElmt1.className   = "tip-inf";
			tdElmt2.className   = "tip-maininf";
			tdElmt1.textContent = strSlider;
			tdElmt2.textContent = options[i]["content"];
			tdElmt2.setAttribute("title", tdElmt2.textContent);
			trElmt.appendChild(tdElmt1);
			trElmt.appendChild(tdElmt2);
			table.appendChild(trElmt);
		}
	}
	
	function makeTextNodeToolTip(table, strType) {
		var trElmt    = document.createElement("tr");
		var tdElmt1   = document.createElement("td");
		var tdElmt2   = document.createElement("td");
		tdElmt1.className   = "tip-inf";
		tdElmt2.className   = "tip-maininf";
		tdElmt1.textContent = SurveyMessages.strOption + ": ";
		tdElmt2.textContent = strType;
		tdElmt2.setAttribute("title", tdElmt2.textContent);
		trElmt.appendChild(tdElmt1);
		trElmt.appendChild(tdElmt2);
		table.appendChild(trElmt);
	}
	
	function makeMatrixNodeToolTip(table, options) {
		for (var i = 0; i < options.length; i++) {
			var trElmt    = document.createElement("tr");
			var tdElmt1   = document.createElement("td");
			var tdElmt2   = document.createElement("td");
			var strColRow = options[i]["colLevel"] == -1 ? SurveyMessages.strRow + " " + (options[i]["rowLevel"] + 1) + ": " : SurveyMessages.strColumn + " " + (options[i]["colLevel"] + 1) + ": ";
			tdElmt1.className   = "tip-inf";
			tdElmt2.className   = "tip-maininf";
			tdElmt1.textContent = strColRow;
			tdElmt2.textContent = options[i]["content"];
			tdElmt2.setAttribute("title", tdElmt2.textContent);
			trElmt.appendChild(tdElmt1);
			trElmt.appendChild(tdElmt2);
			table.appendChild(trElmt);
		}
	}
	
	function makeCommonToolTip(table, options) {
		for (var i = 0; i < options.length; i++) {
			var trElmt  = document.createElement("tr");
			var tdElmt1 = document.createElement("td");
			var tdElmt2 = document.createElement("td");
			tdElmt1.className   = "tip-inf";
			tdElmt2.className   = "tip-maininf";
			tdElmt1.textContent = SurveyMessages.strOption + " " + (options[i]["level"] + 1) + ": ";
			tdElmt2.textContent = options[i]["content"];
			tdElmt2.setAttribute("title", tdElmt2.textContent);
			trElmt.appendChild(tdElmt1);
			trElmt.appendChild(tdElmt2);
			table.appendChild(trElmt);
		}
	}
	
	function createJsonElements() {
		var questions = surveyObj["questions"];
		var data = {};
		var elements  = {};
		var nodes = [];
		var edges = [];
		var questionsWithTarget = [];
		var allQuestionsLevel = [];
		var questionsWithoutTarget = [];
		for (var k = 0; k < questions.length; k++) {
			allQuestionsLevel.push(questions[k]["level"]);
			if (questions[k]["logicFlag"] == "1") {
				var tmpOptions = questions[k]["option"];
				for (l = 0; l < tmpOptions.length; l++) {
					var tmpLogicNum = tmpOptions[l]["logic"];
					if (!!tmpLogicNum && tmpLogicNum > 0 && questionsWithTarget.indexOf(tmpLogicNum) < 0) {
						questionsWithTarget.push(tmpLogicNum);
					}
				}
			} else if (questions[k]["skipFlag"] == "1") {
				var tmpSkipNum = questions[k]["skip"];
				if (!!tmpSkipNum && tmpSkipNum > 0 && questionsWithTarget.indexOf(tmpSkipNum) < 0) {
					questionsWithTarget.push(tmpSkipNum);
				}
			}
		}
		
		for (var m = 0; m < allQuestionsLevel.length; m++) {
			if (questionsWithTarget.indexOf(allQuestionsLevel[m]) < 0) {
				questionsWithoutTarget.push(allQuestionsLevel[m]);
			} else {
				continue;
			}
		}
		
		questionsWithoutTarget.sort(function (a,b) {return a - b});
		
		for (var i = 0; i < questions.length; i++) {
			var node        = {};
			var qsData      = {};
			qsData["id"]    = questions[i]["level"];
			qsData["name"]  = SurveyMessages.strQs + " " + questions[i]["level"];
			qsData["title"] = questions[i]["content"];
			node["data"]    = qsData;
			nodes.push(node);
			var questionLevel = questions[i]["level"];
			
			var defaultTarget = -1;
			for (var n = 0; n < questionsWithoutTarget.length; n++) {
				if (questions[i]["level"] < questionsWithoutTarget[n]) {
					defaultTarget = questionsWithoutTarget[n];
					break;
				}
			}
			
			if (questions[i]["skipFlag"] == 1) {
				var skipQst = questions[i]["skip"];
				if (!isNaN(skipQst) && (skipQst != 0)) {
					edges.push({data: {source : questionLevel, target: skipQst}});
				}
				else {
					if (questions[i]["level"] == questions.length) {
						continue;
					}
					else {
						edges.push({data: {source : questionLevel, target: defaultTarget}});
					}
				}
			}
			else if (questions[i]["logicFlag"] == 1) {
				var options = questions[i]["option"];
				
				for (var j = 0; j < options.length; j++) {
					var logicNum = options[j]["logic"];
					var destQst  = -1;
					
					if (isNaN(logicNum) || logicNum == -1 ) {
						destQst = defaultTarget;
					}
					else {
						destQst  = logicNum;
					}
					
					if (destQst != -1 && destQst != 0) {
						var nlink = {source : questionLevel, target: destQst};
						edges.push({data: nlink});	
					}
				}
			}
			else {
				if (questions[i]["level"] < questions.length && defaultTarget != -1 && defaultTarget != 0) {
					edges.push({data: {source : questionLevel, target: defaultTarget}});
				}
			}
		}
		
		elements["nodes"] = nodes;
		elements["edges"] = edges;
		data["elements"] = elements;
		data["questionsWithoutTarget"] = questionsWithoutTarget;
		
		return data;
	}
	
	function showSelectPopUp(mode) {selectPopup = window.open("/ezSurvey/selectUsers.do?mode=" + mode, "selectUser", getOpenWindowfeature(964, 645));}
	function getSurveyQuestions() {return surveyObj["questions"];}
	function setSurveyQuestions(question) {surveyObj["questions"].push(question);}
	function getSurveyUsers() {return surveyObj["infor"]["users"];}
	function getSurveyResultUsers() {return surveyObj["infor"]["resultViewTarget"] ;}
	function setSurveyUsers(userList) {surveyObj["infor"]["users"] = JSON.parse(JSON.stringify(userList)); showUserList('survey');}
	function setSurveyResultUsers(userList) {surveyObj["infor"]["resultViewTarget"] = JSON.parse(JSON.stringify(userList)); showUserList('result');}
	function getSurveyInfo() {return surveyObj["infor"];}
	function isValid(value) {if (!isNaN(value) && parseFloat(value) >= 0 && value % 1 === 0) {return true;} else {return false;}}
	
	// question input 및 img 생성
	function createQuestionDiv(qstnWrapper, question) {
		var qstId      = "";
		var qstContent = "";
		var qstAtt     = "";
		var qstImgTitle = "";
		if (question) {
			qstId      = question.level;
			qstContent = question.content;
			qstAtt     = mkImgTag(question.attach);
			qstImgTitle = question.imgTitle;
		}
		
		var wrapper      = $("<div class='qstnWrapper' id='" + qstId + "'></div>");
		var quesDiv      = $("<div class='quesDiv'></div>");
		var qstnRow      = $("<div class='qstnRow'></div>");
		var questnTitle  = $("<input class='questnTitle' value='" + escapeHtml(qstContent) + "' maxLength='250' placeholder='" + SurveyMessages.strQsContent + "' />");
		var ulToolTip    = $("<ul class='survey_atchBtn'></ul>");
		var fileAttToolTip = $("<div class='fileAttTooltip'><div class='fileAttTooltipContent'><div class='fileAttTooltipLine' mode='questionImg'>" + SurveyMessages.strQuestionImage +"</div><div class='fileAttTooltipDivider'></div><div class='fileAttTooltipLine' mode='fileAttach'>" + SurveyMessages.strQuestionFileAttach +"</div></div></div>")
		var liAttImg     = $("<li class='off atchLiImg'><span class='survey_icon atchImg'></span></li>");
		var liAttUrl     = $("<li class='off atchLiUrl'><span class=''>" + SurveyMessages.strAttUrl + "</span></li>");
		var divRequired  = $("<div class='required'><div class='custom_checkbox'><input type='checkbox'><label>" + SurveyMessages.strRequired + "</label></div></div>");
		var selectBox    = $("<div class='selectBox'></div>");
		var qstnFileInfo = $("<div class='qstnFileInfo'></div>");
		var fileList     = $("<div class='fileList'></div>");
		var qstUl        = $("<ul class='qstUl'></ul>");
		var qstnImgFile  = $("<input type='file' class='qstnImgFile' accept='.png, .jpeg, .jpg'/>");
		var imgQuestionInfo = $("<div class='imgQuestionInfo noImg'></div>");
		var imgQuestionList = $("<div class='imgQuestionList'></div>");
		var imgQstUl        = $("<ul class='imgQstUl'></ul>");
		var imgQuestionFile = $("<input type='file' class='imgQuestionFile' accept='/*'/>");
		var changeQstTextBtn = $("<input type='button' class='changeQstText' value='" + SurveyMessages.strQuestionImageDel + "'/>");
		if (qstImgTitle) {
			imgQuestionInfo.removeClass("noImg");
			imgQstUl.append(makeImgTitle(question.imgTitle));
			changeQstTextBtn.css("display", "block");
			questnTitle.addClass("hasImg");
		}
		liAttImg.append(fileAttToolTip);
		ulToolTip.append(liAttImg);
		ulToolTip.append(liAttUrl);
		imgQuestionList.append(imgQstUl);
		imgQuestionList.append(imgQuestionFile);
		imgQuestionInfo.append(imgQuestionList);
		quesDiv.append(imgQuestionInfo);
		
		qstnRow.append(questnTitle);
		qstnRow.append(changeQstTextBtn);
		qstnRow.append(divRequired);
		qstnRow.append(ulToolTip);
		qstnRow.append(selectBox);
		quesDiv.append(qstnRow);
		
		qstUl.append(qstAtt);
		fileList.append(qstUl);
		fileList.append(qstnImgFile);
		qstnFileInfo.append(fileList);
		
		quesDiv.append(qstnFileInfo);
		wrapper.append(quesDiv);
		
		if (qstnWrapper) {
			qstnWrapper.after(wrapper);
			questnTitle.focus();
		}
		else {
			$(".quesBacgr").append(wrapper);
			questnTitle.focus();
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
					case 10 :
					case 11 : makeScheduleQuestion(grandParent, questionType, checkResult)       	; break;
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
		var addtional = mkAddtionalPart(checkResult[config["action"]]);

		QuestionForm.append(slt);
		QuestionForm.append(addtional);
		grandParent.append(QuestionForm);
		
	}
	
	// 셀렉트 박스 선택시 만들어지는 질문 폼 행렬 질문 생성
	function makeMatrixQuestion(grandParent, questionType, checkResult) {
		var QuestionForm = makeQuestionForm(questionType);
		var mtr = handleModifyMatrixQuestion();
		var addtional = mkAddtionalPart(checkResult[config["action"]]);
		
		QuestionForm.append(mtr);
		QuestionForm.append(addtional);
		grandParent.append(QuestionForm);
	}
	
	// 버튼 이벤트
	function addOptEvent() {
		// question required button click
		$(".quesBacgr").on("click", ".required", function() {
			var inputElmt = this.querySelector("input[type='checkbox']");
			var crrState  = inputElmt.checked;
			inputElmt.checked = crrState ? false : true;
		});
		
		// question 첨부파일 트리거
		
		$(".quesBacgr").on("click", ".atchLiImg", function() {
			$(this).find('.fileAttTooltip').toggle();
		});
		
		$(".quesBacgr").on("click", ".fileAttTooltipLine", function() {
			var fileAttTooltipLine = $(this);
			var quesDiv = fileAttTooltipLine.closest(".quesDiv");
			if (fileAttTooltipLine.attr("mode") == "fileAttach") {
				var li = quesDiv.find(".fileList").find("li");
				if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
				quesDiv.find(".fileList").find(".qstnImgFile").click();
			} else if (fileAttTooltipLine.attr("mode") == "questionImg") {
				var li = quesDiv.find(".imgQuestionList").find("li");
				if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
				quesDiv.find(".imgQuestionList").find(".imgQuestionFile").click();
			}
			quesDiv.find(".fileAttTooltip").hide();
		});
		
		$(".quesBacgr").on("click", ".changeQstText", function() {
			$(this).css('display', 'none');
			questionFile.deleteFile($(this).closest(".quesDiv").find(".imgQstUl").find(".delInput").first().get(0));
		});
		
		$(document).on('click', function(event) {
	        if (!$(event.target).closest('.atchLiImg').length || $(event.target).closest('.fileAttTooltip').length) {
	            $('.fileAttTooltip').hide();
	        }
			
	    });
		
		$(".quesBacgr").on("click", ".atchLiVdo", function() {
			var li = $(this).closest(".quesDiv").find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			$(this).parent().parent().next().find(".qstnVidFile").click();
		});
		
		$(".quesBacgr").on("click", ".atchLiMsic", function() {
			var li = $(this).closest(".quesDiv").find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			$(this).parent().parent().next().find(".qstnAudFile").click();
		});
		
		$(".quesBacgr").on("click", ".atchLiUrl", function() {
			var li = $(this).closest(".quesDiv").find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			
			toggleUrlPanel($(this).parent().parent().next().find(".fileList")[0], "qstUl");
		});
		
		$("#removeUrlPopup").click(function() {toggleUrlPanel();})
		$(".quesBacgr").on("change", ".qstnImgFile", function(e) {fileUpload(this, "all");});
		$(".quesBacgr").on("change", ".qstnVidFile", function(e) {fileUpload(this, "video");});
		$(".quesBacgr").on("change", ".qstnAudFile", function(e) {fileUpload(this, "music");});
		$(".quesBacgr").on("change", ".imgQuestionFile", function(e) {fileUpload(this, "imgTitle");});
		
		$(".quesBacgr").on("click", ".addOpttions", function() {
			var thisEl    = $(this).parents(".qstnForm");
			var classType = parseInt(thisEl.attr("questiontype")) == 8 ? "ranking" : "dropdown";
			var optCnt    = thisEl.find(".textInput").length;
			
			if (classType == "ranking" && optCnt == 25) {alert(SurveyMessages.strRnkOpt); return;}
			
			thisEl.find("." + classType + "-select").last().after(mkOptions(classType, optCnt + 1, ""));
		});
		
		$(".quesBacgr").on("click", ".delOption", function() {
			var thisElmt  = $(this);
			var qstForm   = thisElmt.parents(".qstnForm");
			var classType = parseInt(qstForm.attr("questiontype")) == 8 ? "ranking" : "dropdown";
			var optCnt    = qstForm.find(".textInput").length;
			
			if (optCnt <= 2) {alert(SurveyMessages.strOptErr); return;}
			thisElmt.parents("." + classType + "-select").remove();
			
			//Update order of spanElement
			var spanList = qstForm[0].querySelectorAll("span[class='" + classType + "-order']");
			
			for (var i = 0, len = spanList.length; i < len; i++) {
				spanList[i].textContent = i + 1;
			}
		});
		
		// 일정 유형 보기 추가
		$(".quesBacgr").on("click", ".scheAddOption", function() {
			var thisEl    = $(this).parents(".qstnForm");
			var optCnt    = thisEl.find(".schedule-option").length;
			
			if (optCnt == 20) {alert(SurveyMessages.strScheduleOpt); return;}
			var lastOpt = thisEl.find(".schedule-option").last();
			var addScheduleInput = mkScheduleOptions();
			lastOpt.after(addScheduleInput);
			var nowDate = new Date();
			var sDate = addScheduleInput.find('.sDate');
			var eDate = addScheduleInput.find('.eDate');
			sDate.datepicker(datepickerSchedule);
			eDate.datepicker(datepickerSchedule);
			eDate.next().hide();
			sDate.datepicker("setDate", nowDate);
			eDate.datepicker("setDate", nowDate);
		});
		
		// 일정 유형 보기 삭제
		$(".quesBacgr").on("click", ".scheDelOption", function() {
			var thisElmt  = $(this);
			var qstForm   = thisElmt.parents(".qstnForm");
			var optCnt    = qstForm.find(".schedule-option").length;
			
			if (optCnt <= 2) {alert(SurveyMessages.strOptErr); return;}
			thisElmt.parents(".schedule-option").remove();
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
			var rows = $(this).parents(".rowArea").find(".rows");
			var rowLength = rows.find(".row").length;
			if (rowLength == 50) {alert(SurveyMessages.strRowLm); return;}
			$(this).parents(".rowArea").find(".rows").append(mkRowCol("row"));
		});
		// matrix 열 추가
		$(".quesBacgr").on("click", ".addCol", function() {
			var cols = $(this).parents(".colArea").find(".cols");
			var colLength = cols.find(".col").length;
			if (colLength == 10) {alert(SurveyMessages.strColumnLm); return;}
			cols.append(mkRowCol("col"));
		});
		// matrix 행 삭제
		$(".quesBacgr").on("click", ".delRow", function(e) {
			var lowLength = $(this).closest(".rows").find(".row").length;
			if (lowLength <= 2) {alert(SurveyMessages.strMaxtrix1); return;}
			$(this).closest(".row").remove();
		});
		// matrix 열 삭제
		$(".quesBacgr").on("click", ".delCol", function() {
			var colLength = $(this).closest(".cols").find(".col").length;
			if (colLength <= 2) {alert(SurveyMessages.strMaxtrix2); return;}
			$(this).closest(".col").remove();
		});
		
		// 첨부파일 버튼 클릭 이벤트
		$(".quesBacgr").on("click", ".attImg", function() {
			var optArea = $(this).closest(".optArea");
			var li      = optArea.find(".fileList").find("li");
			if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			optArea.find(".optionImgFile").click();
		});
		
		$(".quesBacgr").on("click", ".attUrl", function() {
			var optArea  = $(this).closest(".optArea");
			var fileList = optArea.find(".fileList");
			if (fileList.find("li").length > 0) {alert(SurveyMessages.strOnlyOne); return;}
			toggleUrlPanel(fileList[0], "optUl");
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
		$(".quesBacgr").on("change", ".optionImgFile"  , function (e) {fileUpload(this, "all");});
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
		$(".quesBacgr").on("click", ".modifyBtnLi", function() {
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
		$(".quesBacgr").on("click", ".copyBtnLi", function() {
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
		$(".quesBacgr").on("click", ".deleteBtnLi", function() {
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
			case 2 :
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
			case 10:
				pf = checkLogicNum(id, qstn, type);
				result = pf == "success" ? addScheduleLogic(id, qstn) : ""; 
				break;
			case 11:
				pf = checkLogicNum(id, qstn, type);
				result = pf == "success" ? addScheduleLogic(id, qstn) : ""; 
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
			}
			else if (logicFlag == undefined || logicFlag == 0) {
				dltLogicForm(type, id);
				
				$("#frstBtnGrp" + id).css("display", "");
				$("#scndBtnGrp" + id).css("display", "none");
				$("#thrdBtnGrp" + id).css("display", "none");
			}
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
			case 2 :
				showSltLogicForm(id, qstn);
				break;
			case 7:
				showSlidLogicForm(id, qstn);
				break;
			case 9:
				showDrdwLogicForm(id, qstn);
				break;
			case 10:
				showScheduleLogicForm(id, qstn);
				break;
			case 11:
				showScheduleLogicForm(id, qstn);
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
			if ([1, 2, 10, 11].includes(type)) {
				var opt = prevWrapper.find(".opt");
				var optLength = opt.length;
				
				for (var i = 0; i < optLength; i++) {
					qstn.option[i]['logic'] = -1; 
					$("#logic" + id + i).remove();
				}
			
			}
			else {
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
			var mode = "skip";
			
			mkSkipForm(id, mode);
			
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
			
			if (skipNum == "") {
				alert(SurveyMessages.strChooseNext);
				return;
			}
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
		});
		
		// skip 취소 버튼 이벤트
		$(".prevQsArea").on("click", ".cancelSkip", function() {
			var id = $(this).attr("id").replace("cancelSkip", "");
			var qstnList = SurveyCreate.getQs();
			var qstn = qstnList[id - 1];
			
			if (qstn['skipFlag'] == undefined || qstn['skipFlag'] == 0) {
				$("#skip" + id).remove();
				
				$("#frstBtnGrp" + id).css("display", "");
				$("#skipScndBtnGrp" + id).css("display", "none");
				$("#skipThrdBtnGrp" + id).css("display", "none");
			}
			else {
				var skip = "";
				var skipNum = qstn['skip'];
				
				if (skipNum == 0) {
					$("#skipVal" + id).text(SurveyMessages.strLast).css("display", "");
				}
				else if (skipNum != -1) {
					skip = SurveyMessages.strQs + " " + skipNum;
					$("#skipVal" + id).text(skip).css("display", "");
				}
				
				$("select[name=skip" + id + "]").css("display", "none");
				
				$("#frstBtnGrp" + id).css("display", "none");
				$("#skipScndBtnGrp" + id).css("display", "none");
				$("#skipThrdBtnGrp" + id).css("display", "");
			}
			
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
		// skip 수정 버튼 이벤트
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
		
		$(".quesBacgr").on("change", ".slider-range", function() {
			var outputElmt         = this.parentElement.parentElement.querySelector("output[class='slider-output']");
			outputElmt.textContent = this.value;
		});
		// 질문 정렬
		$(".quesBacgr").sortable({
			handle: ".mvBtn",
			cursor: "move",
			containment: "parent",
			tolerance: "pointer",
			axis: "y",
			update: function(event, ui) {
				var selectedDivList = ui.item;
				var nxtQstDivList   = selectedDivList.next();
				var prevDivList     = selectedDivList.prev();
				var nextQstDiv      = (nxtQstDivList.length != 0) ? nxtQstDivList[0] : null;
				var prevQstDiv      = (prevDivList.length   != 0) ? prevDivList[0]   : null;
				
				if (nextQstDiv != null &&  prevQstDiv != null) {
					var nexQstDivId  = nextQstDiv.getAttribute("id");
					
					if (nexQstDivId.indexOf("qstn") == -1) {
						var prevQstLevel = prevQstDiv.getAttribute("id").replace("qstn", "");
						
						if (nexQstDivId == prevQstLevel) {
							//Insert between modifying question divs
							selectedDivList[0].parentElement.insertBefore(prevQstDiv, nextQstDiv);
						}
					}
				}
				
				sortDivElementList();
			}
		});
		
		$(".quesBacgr").on("click", ".delImage", function() {questionFile.deleteFile(this);});
	}
	
	function addScheduleInputEvents() {
		var nowDate = new Date();
		var sDateElem = $(".sDate");
		var eDateElem = $(".eDate");
		sDateElem.datepicker(datepickerSchedule);
		eDateElem.datepicker(datepickerSchedule);
		sDateElem.datepicker("setDate", nowDate);
		eDateElem.datepicker("setDate", nowDate);
		eDateElem.next().hide();
	}
	
	function addScheduleInputEventsForMod() {
		var scheduleInputElem = $('.schedule-input');
		var nowDate = new Date();
		for (var i = 0; i < scheduleInputElem.length; i++) {
			var dateString = scheduleInputElem.eq(i).find('.contentInput').val();
			var sDateElem = scheduleInputElem.eq(i).find('.sDate').eq(0);
			var betweenElem = scheduleInputElem.eq(i).find('.betweenSpan').eq(0);
			var eDateElem = scheduleInputElem.eq(i).find('.eDate').eq(0);
			var txtElem = scheduleInputElem.eq(i).find('.scheduleTxt').eq(0);
			var dateOptElem = scheduleInputElem.eq(i).find('.dateOpt').eq(0);
			sDateElem.datepicker(datepickerSchedule);
			eDateElem.datepicker(datepickerSchedule);
			
			if (dateString != "") {
				const singleDatePattern = /^\d{4}-\d{2}-\d{2}$/; // yyyy-mm-dd
			    const rangeDatePattern = /^\d{4}-\d{2}-\d{2} ~ \d{4}-\d{2}-\d{2}$/; // yyyy-mm-dd
																					// ~
																					// yyyy-mm-dd
			    var dateOpt = "";
			    if (singleDatePattern.test(dateString)) {
			    	var sDateStr = dateString;
			    	
			    	if (!isValidDate(dateString)) {
			    		sDateElem.datepicker("setDate", nowDate);
						eDateElem.datepicker("setDate", nowDate);
						txtElem.val(dateString);
						dateOpt = "txt";
			    	} else {
			    		sDateElem.datepicker("setDate", sDateStr);
				    	eDateElem.datepicker("setDate", nowDate);
				    	dateOpt = "one";
			    	}			    	
			    	
			    } else if (rangeDatePattern.test(dateString)) {
			    	if (!isValidDate(dateString.split(" ~ ")[0]) || !isValidDate(dateString.split(" ~ ")[1])) {
			    		sDateElem.datepicker("setDate", nowDate);
						eDateElem.datepicker("setDate", nowDate);
						txtElem.val(dateString);
						dateOpt = "txt";
			    	} else {
			    		var sDateStr = dateString.split(" ~ ")[0];
				    	var eDateStr = dateString.split(" ~ ")[1];
				    	sDateElem.datepicker("setDate", sDateStr);
				    	eDateElem.datepicker("setDate", eDateStr);
				    	dateOpt = "mul";
			    	}
			    	
			    } else {
			    	sDateElem.datepicker("setDate", nowDate);
					eDateElem.datepicker("setDate", nowDate);
					txtElem.val(dateString);
					dateOpt = "txt";
			    }
			    
			    displayScheduleInputs(dateOpt, sDateElem, betweenElem, eDateElem, txtElem);
			    dateOptElem.val(dateOpt).change();
			} else {
				sDateElem.datepicker("setDate", nowDate);
				eDateElem.datepicker("setDate", nowDate);
				eDateElem.next().hide();
			}
		}
	}
	
	function isValidDate(dateStr) {
		var date = new Date(dateStr);
    
		return date instanceof Date && !isNaN(date) && dateStr === date.toISOString().split('T')[0];
	}
	
	function sortDivElementList() {
		var backGroundDiv    = document.getElementById("mainQsCreateDiv");
		var questionDivList  = backGroundDiv.querySelectorAll("div[class='qstnWrapper']");
		var questionList     = JSON.parse(JSON.stringify(surveyObj["questions"]));
		var newQstList       = [];
		var crrListLen       = questionDivList.length - 1; //last div is not a question yet
		
		for (var i = 0; i < crrListLen; i++) {
			var crrElmtId = questionDivList[i].getAttribute("id");
			var newLevel  = newQstList.length + 1;
			var crrLevel  = crrElmtId.replace("qstn", "");
			
			if (crrElmtId.indexOf("qstn") != -1) {
				var crrQuestion = JSON.parse(JSON.stringify(questionList.filter(function(qst){return qst["level"] == crrLevel;})[0]));
				crrQuestion["level"] = newLevel;
				questionDivList[i].setAttribute("id", "qstn" + newLevel);
				if (crrQuestion.imgTitle) {
					questionDivList[i].querySelector(".question-content span").textContent = newLevel + ". "; 
				} else {
					questionDivList[i].querySelector("div[class='question-content']").textContent = newLevel + ". " + crrQuestion["content"];
				}
				newQstList.push(crrQuestion);
			}
			else {
				questionDivList[i].setAttribute("id", newLevel == 1 ? 1 : newLevel - 1);
			}
		}
		
		//Update new questions list
		surveyObj["questions"] = JSON.parse(JSON.stringify(newQstList));
	}
	// 필수 답변 표시(*) 추가 함수
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
			case 10 : 
			case 11 : body = mkScheduleQstn(question)           ; break;
			default : alert(SurveyMessages.strError)            ; return;
		}
		
		header.appendChild(body[0]);
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
		var qstType       = question.type;
		var body          = "";
		var additional    = "";
		var questionForm  = makeQuestionForm(qstType);
		var hiddenWrapeer = qstnWrapper.next();
		
		handleRequiredQuestion(hiddenWrapeer, question.required);
		
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
			case 10 :
			case 11 : body = handleModifyScheduleQuestion(question)   ; break;
			default : alert(SurveyMessages.strError)                               ; return;
		}
		
		additional = mkAddtionalPart(mode);
		
		questionForm.append(body);
		questionForm.append(additional);
		hiddenWrapeer.append(questionForm);
		
		if (qstType == "10" || qstType == "11") {
			addScheduleInputEventsForMod();
		}
		
	}
	
	function handleRequiredQuestion(qstnWrapper, required) {
		var qstnArea      = qstnWrapper.find(".quesDiv");
		var inputElmt     = qstnArea.find(".required").find("input[type='checkbox']")[0];
		inputElmt.checked = required ? true : false;
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
		
		var htmlTxt = "<ul class='survey_atchBtn srvyAddBtn'>";
		htmlTxt    += "<li class='off addOpt'><span class='survey_icon srvyAddFile'></span></li>";
		htmlTxt    += "<li class='off addOther'><span class='survey_text'>" + SurveyMessages.strAddOther + "</span></li>";
		htmlTxt    += "</ul>";
		optionWrapper.append(htmlTxt);
		
		return optionWrapper;
	}
	
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
		html += "<div class='colrow-wrap'>";
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
		html += "<ul class='survey_atchBtn srvyAddBtn'>";
		html += "<li class='off addRow'><span class='survey_icon srvyAddFile'></span></li>";
		html += "</ul></div></div></div>";
		
		html += "<div class='colArea'>";
		html += "<div class='cName'>";
		html += "<span>" + SurveyMessages.strColumn + "</span>";
		html += "</div>";
		html += "<div class='colrow-wrap'>";
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
		html += "<ul class='survey_atchBtn srvyAddBtn'>";
		html += "<li class='off addCol'><span class='survey_icon srvyAddFile'></span></li>";
		html += "</ul></div></div></div></div>";
		
		return $(html);
	}
	
	function handleModifyTextQuesion(type, mode, optionId) {
		var className = mode == "make" ? type + "-wrap" : "question-" + type;
		var textQstnDiv = $("<div class='" + className + "'>");
		
		if (type == "paragraph") {
			var textarea = $("<textarea class='" + type +"' maxlength='500' placeholder='" + SurveyMessages.strTxtContent + "' optionId = '" + optionId + "'></textarea>");
			textQstnDiv.append(textarea);
		}
		else {
			var input = $("<input class='" + type +"' maxlength='80' placeholder='" + SurveyMessages.strTxtContent + "' optionId = '" + optionId + "'/>");
			textQstnDiv.append(input);
		}
		
		return textQstnDiv;
	}
	
	function handleModifySliderQuesion(question) {
		var htmlTxt = "";
		var lowest  = "";
		var highest = "";
		var unit    = "";
		
		if (question) {
			var options = question.option;
			lowest      = options.filter(function(val) {return val["level"] == 0;})[0]["content"];
			highest     = options.filter(function(val) {return val["level"] == 1;})[0]["content"];
			unit        = question["unit"];
		}
		
		var divWrap    = $("<div class='silder-container'></div>");
		var sliderUnit = $("<div class='silder-unit'></div>");
		var unitTxt    = $("<span class='slider-span'>" + SurveyMessages.strSlider7 + "</span>");
		var unitInput  = $("<input type='input' class='slider-input' value='" + unit  + "'/>");
		var cntTxt    = $("<span class='slider-span'>" + SurveyMessages.strNumber  +"</span>");
		var cnt = (highest - lowest) / unit;
		cnt = !!cnt ? cnt : 1;
		var cntInput  = $("<input type='input' class='slider-cnt' value='" + cnt  + "'/>");
		var slidWrap   = $("<div class='silder-wrap'></div>");
		var slideMain = $("<input type='range' class='slider-main' value='0'/>");
		slidWrap.append(slideMain);
		var span = $("<p></p>");
		var output = $("<output class='slider-output'></output>");

		var sliderLw   = $("<span class='slider-span'>" + SurveyMessages.strSlider8 + "</span>");
		var lowInput = $("<input type='input' class='slider-lw' onKeyup=this.value=this.value.replace(/[^0-9]/g,''); value='" + lowest  + "'/>");
		var sliderUp = $("<span class='slider-span'>" + SurveyMessages.strSlider9 + "</span>");
		var upInput = $("<input type='input' class='slider-up' style='background-color:#cccccc;' onKeyup=this.value=this.value.replace(/[^0-9]/g,''); readonly value='" + highest + "'/>");

		sliderUnit.append(sliderLw);
		sliderUnit.append(lowInput);
		sliderUnit.append(unitTxt);
		sliderUnit.append(unitInput);
		sliderUnit.append(cntTxt);
		sliderUnit.append(cntInput);
		sliderUnit.append(sliderUp);
		sliderUnit.append(upInput);

		// slidWrap.append(sliderUp);
		divWrap.append(slidWrap);
		divWrap.append(span);
		span.append(output);
		// divWrap.append(lwUpDiv);
		divWrap.append(sliderUnit);

		addChangeEvent(lowInput, unitInput, cntInput, upInput, slideMain, output);
		return divWrap;
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
		
		//Add add button
		var htmlTxt = "<ul class='survey_atchBtn srvyAddBtn'><li class='off addOpttions'><span class='survey_icon srvyAddFile'></span></li></ul>";
		wrap.append($(htmlTxt));
		
		return wrap;
	}
	
	function handleModifyScheduleQuestion(question) {
		var wrap = $("<div class='schedule-wrap'></div>");
		if (question) {
			var optionList = question["option"];
			
			for (var i = 0, len = optionList.length; i < len; i++) {
				option = mkScheduleOptions(optionList[i].content);
				wrap.append(option);
			}
		} else {
			for (var i = 0; i < 2; i++) {
				wrap.append(mkScheduleOptions());
			}
		}
		
		var htmlTxt = "<ul class='survey_atchBtn srvyAddBtn'><li class='off scheAddOption'><span class='survey_icon srvyAddFile'></span></li></ul>";
		wrap.append($(htmlTxt));
		return wrap;
	}
	
	// 첨부파일 있을 시 태그 생성
	function mkImgTag(qstnAtt) {
		if (!qstnAtt) {return "";}
		return questionFile.mkImgTag(qstnAtt);
	}
	
	function makeImgTitle(imgTitle) {
		if (!imgTitle) {return "";}
		return questionFile.makeImgTitle(imgTitle);
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
				var optionId = "";
				
				if (option['optionId'] != undefined) {
					optionId = option['optionId'];
				}
				
				opt = $("<div class='opt' level='" + option.level + "'></div>");
				
				if (qstnType == 2) {
					optChb = $("<div class='custom_checkbox'><input class='optChb' type='checkbox' name='qstn" + qstnId + "opt' value='" + option.level + "' logic='" + option.logic + "' optionId='" + optionId + "' /></div>");
					opt.append(optChb);
				}
				else {
					optRdo = $("<div class='custom_radio'><input class='optRdo' type='radio' name='qstn" + qstnId + "opt' value='" + option.level + "' logic='" + option.logic + "' optionId='" + optionId + "' /></div>");
					opt.append(optRdo);
				}
				
				if (option["attach"]) {
					var attachInf = questionFile.getImage(option["attach"]);
					optAttach = $("<img alt='' src='" + attachInf["imageSrc"] + "' class='optImg' />");
					
					if (attachInf["isImage"] == 0) {optAttach.attr("title", option["attach"]["fname"]);}
					
					if (downloadMode) {
						if (option["attach"]["furl"]) {
							optAttach[0].onclick = (function(url) {return function() {window.open(url);};})(option["attach"]["furl"]);
						}
						else {
							optAttach[0].onclick = (function(name, path) {return function() {questionFile.download(name, path);};})(option["attach"]["fname"], option["attach"]["fpath"]);
						}
					}
					
					opt.append(optAttach);
				}
				
				optContent = option["content"] ? option["content"] : "";
				optSpan    = $("<span class='optSpan'></span>");
				optSpan[0].textContent = optContent;
				opt.append(optSpan);
				
				questionOpts.append(opt);
			}
		}
		
		// 기타 (하나만 존재 가능)
		if (other) {
			var optionId = "";
			
			if (option['optionId'] != undefined) {
				optionId = other['optionId'];
			}
			
			opt = $("<div class='opt'></div>");
			
			if (qstnType == 2) {
				optChb = $("<div class='custom_checkbox'><input class='optChb' type='checkbox' name='qstn" + qstnId + "opt' value='" + other.level + "' logic='" + other.logic + "' otherFlag='" + other.otherFlag +"' optionId='" + optionId + "'/></div>");
				opt.append(optChb);
			}
			else {
				optRdo = $("<div class='custom_radio'><input class='optRdo' type='radio' name='qstn" + qstnId + "opt' value='" + other.level + "' logic='" + other.logic + "' otherFlag='" + other.otherFlag +"' optionId='" + optionId + "'/></div>");
				opt.append(optRdo);
			}
			
			if (other["attach"]) {
				var attachInf = questionFile.getImage(other["attach"]);
				optAttach     = $("<img alt='' src='" + attachInf["imageSrc"] + "' class='optImg'>");
				if (attachInf["isImage"] == 0) {optAttach.attr("title", other["attach"]["fname"]);}
				if (downloadMode) {
					if (other["attach"]["furl"]) {
						optAttach[0].onclick = (function(url) {return function() {window.open(url);};})(other["attach"]["furl"]);
					}
					else {
						optAttach[0].onclick = (function(name, path) {return function() {questionFile.download(name, path);};})(other["attach"]["fname"], other["attach"]["fpath"]);
					}
				}
				
				opt.append(optAttach);
			}
			
			optSpan = $("<span class='optSpan'></span>");
			optSpan[0].textContent = other["content"];
			opt.append(optSpan);
			othInput = $("<input id='othInput" + qstnId + "' class='othInput' type='text'/>");
			opt.append(othInput);
			questionOpts.append(opt);
		}
		
		return questionOpts;
	}
	// 행렬 질문 생성
	function mkMatrixQstn(question) {
		var id         = question.level;
		var inpType    = question.type == 3 ? "radio" : "checkbox";
		var opts       = question["option"];
		var optsLength = question["option"].length;
		var col        = opts.filter(function(col) {return col["rowLevel"] == -1;});
		var row        = opts.filter(function(row) {return row["colLevel"] == -1;});
		
		var questionOpts = $("<div class='question-opts'></div>");
		var table        = $("<table class='matrix'></table>");
		var head         = $("<thead></head>");
		var headTr       = $("<tr><td></td></tr>");
		
		var dynamicTd = "";
		var body = "";
		var bodyTr = "";
		var bodyTd = "";
		var inputTd = "";
		var Input = "";
		var divInput = "";
		
		for (var i = 0; i < col.length; i++) {
			dynamicTd = $("<td></td>");
			dynamicTd[0].textContent = col[i]["content"];
			headTr.append(dynamicTd);
		}
		
		head.append(headTr);
		table.append(head);
		body = $("<tbody></body>");
		
		for (var i = 0; i < row.length; i++) {
			var rowOptionId = "";
			if (opts[i]['optionId'] != undefined) {
				rowOptionId = opts[i]['optionId'];
			}
			bodyTr = $("<tr></tr>");
			bodyTd = $("<td></td>");
			bodyTd[0].textContent = row[i]["content"];
			bodyTr.append(bodyTd);
			
			var colNum = optsLength - col.length;
			for (var j = colNum; j < optsLength; j++) {
				var colOptionId = "";
				
				if (opts[j]['optionId'] != undefined) {
					colOptionId = opts[j]['optionId'];
				}
				
				inputTd = $("<td></td>");
                
                if (inpType == "radio") {
                    divInput = $("<div class='custom_radio'></div>");
                } else if (inpType == "checkbox") {
                    divInput = $("<div class='custom_checkbox'></div>");
                }
                
				Input = $("<input type='" + inpType + "' name='qstn" + id + "opt" + i + "' id='qstn" + id + "opt" + i + j + "' OptionId='" + rowOptionId + "," + colOptionId +"'>");
				Input.val(row[i]["rowLevel"] + "," + col[j - row.length]["colLevel"]);
				divInput.append(Input);
				inputTd.append(divInput);
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
		var qstnWrapper  =  thisEl.parents(".qstnWrapper");
		
		//Check attach file upload progress
		var canvasList   = qstnWrapper.find("canvas");
		if (canvasList && canvasList.length > 0) {alert(SurveyMessages.strAttachErr); return;}
		
		var qstnArea     = qstnWrapper.find(".quesDiv");
		var qstnContent  = replaceAll(qstnArea.find(".questnTitle").val(), "(<(\/?)(script|applet|object)>)", "");
		var qstnImgTitle = qstnArea.find(".imgQuestionInfo")[0].querySelector("li");
		var qstnImgTitleFlag = qstnArea.find(".questnTitle").hasClass("hasImg");
		if (qstnImgTitle) {
			question["imgTitle"] = getImgTitleInfo(qstnImgTitle);
			qstnContent = "";
		}
		
		var questionList = SurveyCreate.getQs();
		
		//Save common question information
		if ((!qstnContent && !qstnImgTitleFlag) || (qstnImgTitleFlag && !qstnImgTitle)) {
			alert(SurveyMessages.strQsContent);
			return;
		}
		
		question["content"]  = qstnContent;
		var qstnForm         = qstnArea.next();
		var qstnType         = qstnForm.attr("questiontype");
		question["type"]     = parseInt(qstnType);
		var rqrd             = qstnArea.find(".required").find("input[type='checkbox']");
		question[config["required"]] = rqrd.is(":checked") == true ? 1 : 0;
		
		//Check question attach files
		var qstnFObj = qstnArea.find(".qstnFileInfo")[0].querySelector("li");
		if (qstnFObj) {question["attach"] = getAttachFileInfo(qstnFObj);}
		
		//Question order
		var qstId = "";
		if (status == "modify") {
			qstId = qstnWrapper.prev().attr("id").replace("qstn", "") ? parseInt(qstnWrapper.prev().attr("id").replace("qstn", "")) : questionList.length + 1;
			
		} else {
			qstId = qstnWrapper.attr("id").replace("qstn", "") ? parseInt(qstnWrapper.attr("id").replace("qstn", "")) : questionList.length + 1;
		}
		question["level"] = qstId;
		
		//Set id
		qstnWrapper.attr("id", "qstn" + qstId);
		
		var header = makeQuestionHeaderPanel(question);
		var body   = "";
		
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
					  if (sliderObj.unit)   {question["unit"]   = sliderObj.unit;}
					  body = mkSliderQstn(question); break;
			case 8  : var rankingObj = mkRankingDropDownObj("ranking", qstnForm);
					  if (rankingObj.error) {alert(SurveyMessages[rankingObj.error]); return;}
					  question["option"] = rankingObj.option;
					  body = mkRankingQstn(question); break;
			case 9  : var dropDownObj = mkRankingDropDownObj("dropdown", qstnForm);
					  if (dropDownObj.error) {alert(SurveyMessages[dropDownObj.error]); return;}
					  question["option"] = dropDownObj.option;
					  body = mkDropDownQstn(question); break;
			case 10 : 
			case 11 : var scheduleObj = mkScheduleObj(qstnForm);
					  if (scheduleObj.error) {alert(SurveyMessages[scheduleObj.error]); return;}
					  question["option"] = scheduleObj.option;
					  body = mkScheduleQstn(question); break;
			default : alert(SurveyMessages.strError); return;
		}
		
		header.appendChild(body[0]);
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
		var optionId = question.option[0].optionId
		
		var html = handleModifyTextQuesion(type, config["modify"], optionId);
		return html;
	}
	
	function mkSliderQstn(question) {
		var options          = question.option;
		var sliderLogicPoint = question.sliderLogicPoint;
		var qstnId           = question.level;
		var sliderUnit       = question.unit;
		var logic            = options[0].logic;
		var lowest           = options.filter(function(val) {return val["level"] == 0;})[0]["content"];
		var highest          = options.filter(function(val) {return val["level"] == 1;})[0]["content"];
		var optionId         = "";
		if (options[0]['optionId'] != undefined) {
			optionId = options[0]['optionId'];
		}
		var questionSilder = $("<div class='question-silder'></div>");
		var silderWrap     = $("<div class='silder-wrap'></div>");
		var low            = $("<span>" + lowest + "</span>");
		var input          = $("<input type='range' class='slider-range' value='" + lowest + "' name='slider" + question["level"] + "' min='" + lowest + "' max='" + highest + "' step='" + sliderUnit + "'/>");
		var high           = $("<span>" + highest + "</span>");
		var output         = $("<output for='slider" + question["level"] + "' id='slider" + question["level"] + "' class='slider-output' logic='" + logic + "' logicPoint='" + sliderLogicPoint + "' optionId = '" + optionId + "'></output>");
		
		silderWrap.append(low);
		silderWrap.append(input);
		silderWrap.append(high);
		
		questionSilder.append(silderWrap);
		questionSilder.append(output);
		
		return questionSilder;
	}
	
	function mkRankingQstn(question) {
		var options         = question["option"];
		var id              = question["level"];
		var questionRanking = $("<div class='question-ranking'>");
		var rankingWrap     = $("<div class='ranking-wrap'>");
		var opt             = "";
		var optionId        = "";
		
		for (var i = 0, len = options.length; i < len; i++) {
			var rankingSelect = $("<div class='ranking-select'></div>");
			var rankOrder = $("<span class='rank-order' id='rank-order" + (i + 1) + "'>" + (i + 1) + "</span>");
			var select = $("<select name='ranking" + id + i + "' class='srvySelect'></select>");
			var defaultOpt = $("<option value='' selected>" + SurveyMessages.strSelect + "</option>");
			select.append(defaultOpt);
			
			for (var j = 0, len = options.length; j < len; j++) {
				if (options[j]['optionId'] != undefined) {
					optionId = options[j]['optionId'];
				}
				var opt = $("<option value='" + options[j]['level'] + "' optionId='" + optionId + "'>" + options[j]["content"] + "</option>");
				opt[0].textContent = options[j]["content"];
				select.append(opt);
			}
			rankingSelect.append(rankOrder);
			rankingSelect.append(select);
			rankingWrap.append(rankingSelect);
		}
		
		questionRanking.append(rankingWrap);
		
		return questionRanking;
	}
	
	function mkDropDownQstn(question) {
		var options          = question["option"];
		var id               = question["level"];
		var questionDropdown = $("<div class='question-dropdown'></div>");
		var dropdownWrap     = $("<div class='dropdown-wrap'></div>");
		var select           = $("<select name='drdw" + id + "' class='srvySelect'></select>");
		var defaultOpt       = $("<option value='' selected>" + SurveyMessages.strSelect + "</option>");
		select.append(defaultOpt);
		
		for (var j = 0, len = options.length; j < len; j++) {
			var optionId = "";
			if (options[j]['optionId'] != undefined) {
				optionId = options[j]['optionId'];
			}
			var opt = $("<option value='" + options[j]["level"] + "' logic='" + options[j]["logic"] + "' optionId='" + optionId + "'></option>");
			
			opt[0].textContent = options[j]["content"];
			select.append(opt);
		}
		
		dropdownWrap.append(select);
		questionDropdown.append(dropdownWrap);
		
		return questionDropdown;
	}
	
	function mkScheduleQstn(question) {
		var options = question.option;
		var qstnId       = question.level;
		var qstnType     = question.type;
		var questionOpts = $("<div class='question-opts'></div>");
		var opt          = "";
		var optRdo       = "";
		var optChb       = "";
		var optAttach    = "";
		var optContent   = "";
		var span         = "";
		// 보기
		for (var i = 0; i < options.length; i++) {
			var option = options[i];
			var optionId = "";
			
			if (option['optionId'] != undefined) {
				optionId = option['optionId'];
			}
			
			opt = $("<div class='opt' level='" + option.level + "'></div>");
			
			// 일정 다중 선택
			if (qstnType == 11) {
				optChb = $("<div class='custom_checkbox'><input class='optChb' type='checkbox' name='qstn" + qstnId + "opt' value='" + option.level  + "' logic='" + option.logic + "' optionId='" + optionId + "' /></div>");
				opt.append(optChb);
			}
			else {
				optRdo = $("<div class='custom_radio'><input class='optRdo' type='radio' name='qstn" + qstnId + "opt' value='" + option.level + "' logic='" + option.logic + "' optionId='" + optionId + "' /></div>");
				opt.append(optRdo);
			}
									
			optContent = option["content"] ? option["content"] : "";
			optSpan    = $("<span class='optSpan'></span>");
			optSpan[0].textContent = optContent;
			opt.append(optSpan);
			
			questionOpts.append(opt);
		}
		return questionOpts;
	}
	
	function makeQuestionHeaderPanel(question) {
		var qstId          = question.level;
		var content        = question.content;
		var qstnType       = question.type;
		var required       = question.required;
		var qstnAtt        = question.attach;
		var imgTitle       = question.imgTitle;
		var wrapDiv        = document.createElement("div");
		var divPanel       = document.createElement("div");
		var moveBttn       = document.createElement("ul");
		var divHeader      = document.createElement("div");
		var divQsContent   = document.createElement("div");
		var divTools       = document.createElement("div");
		var atchBtnUl      = document.createElement("ul");
		
		for (var i = 0; i < 3; i++) {
			var btnLi         = document.createElement("li");
			var btnSpan       = document.createElement("span");
			
			switch (i) {
				case 0 :  btnSpan.className = "survey_icon modifyBtn";
						  btnLi.className   = "off modifyBtnLi"; break;
				case 1 :  btnSpan.className = "survey_icon copyBtn";
						  btnLi.className   = "off copyBtnLi"  ; break;
				case 2 :  btnSpan.className = "survey_icon deleteBtn";
						  btnLi.className   = "off deleteBtnLi"; break;
			}
			
			btnLi.appendChild(btnSpan);
			atchBtnUl.appendChild(btnLi);
		}
		
		moveBttn.innerHTML = "<li class='off'><span class='survey_icon srvyDrag'></span></li>";
		
		//question content process
		if (required == 1) {
			var strongElmt         = document.createElement("strong");
			strongElmt.className   = "imptt";
			strongElmt.textContent = "*";
			divHeader.appendChild(strongElmt);
		}
		
		if (!imgTitle) {
			divQsContent.textContent = qstId + ". " + content;
			
			divQsContent.className   = "question-content";
		} else {
			var span         = document.createElement("span");
			span.textContent = qstId +". ";
			var attDiv       = document.createElement("div");
			var attImg       = document.createElement("img");
			var attachInf    = questionFile.getImage(imgTitle);
			attImg.src       = attachInf["imageSrc"];
			attImg.className = "titleImg";
			attDiv.className = "question-attach questionImgTitle";
			attDiv.appendChild(attImg);
			attDiv.style.maxHeight = 'none';
			attDiv.style.padding = '10px 0px 0px 0px';
			attDiv.style.margin = '0px 35px'; 
			
			if (attachInf["isImage"] == 0) {
				var spanElmt         = document.createElement("span");
				spanElmt.textContent = qstnAtt["fname"];
				spanElmt.setAttribute("title", qstnAtt["fname"]);
				attDiv.appendChild(spanElmt);
			}
			
			divQsContent.appendChild(span);
			divQsContent.className   = "question-content questionImgContent";
			divPanel.appendChild(attDiv);
		}
		
		divHeader.className = "question-header";
		//Tools div process
		atchBtnUl.className = "survey_atchBtn";
		divTools.className  = "tooltip-bttns";
		
		divTools.appendChild(atchBtnUl);
		divHeader.appendChild(divQsContent);
		divHeader.appendChild(moveBttn);
		divHeader.appendChild(divTools);
		divPanel.appendChild(divHeader);
		
		if (qstnAtt) {
			var attDiv       = document.createElement("div");
			var attImg       = document.createElement("img");
			var attachInf    = questionFile.getImage(qstnAtt);
			attImg.src       = attachInf["imageSrc"];
			attImg.className = "qstnImg";
			attDiv.className = "question-attach";
			
			if (downloadMode) {
				if (qstnAtt["furl"]) {
					attImg.onclick = (function(url) {return function() {window.open(url);};})(qstnAtt["furl"]);
				}
				else {
					attImg.onclick = (function(name, path) {return function() {questionFile.download(name, path);};})(qstnAtt["fname"], qstnAtt["fpath"]);
				}
			}
			
			attDiv.appendChild(attImg);
			
			if (attachInf["isImage"] == 0) {
				var spanElmt         = document.createElement("span");
				spanElmt.textContent = qstnAtt["fname"];
				spanElmt.setAttribute("title", qstnAtt["fname"]);
				attDiv.appendChild(spanElmt);
			}
			
			divPanel.appendChild(attDiv);
		}
		
		moveBttn.className = "survey_atchBtn mvBtn srvyDragBtn";
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
		var optSet    = new Set(); // 중복값 확인.
		
		for (var i = 0; i < optCnt; i++) {
			var optObj   = {};
			var optValue = replaceAll(optList[i].querySelector("input[class='textInput']").value, "(<(\/?)(script|applet|object)>)", "").trim();
			
			if (optValue) {
				optObj["content"] = optValue;
				optObj["level"]   = i;
				option.push(optObj);
				optSet.add(optValue);
			}
		}
		
		if (option.length < 2) {returnObj['error'] = "strOptErr"; return returnObj;}
		if (optSet.size != option.length) {returnObj['error'] = "strOptErr1"; return returnObj;}
		
		returnObj["option"] = option;
		return returnObj;
	}
	
	// 일정 보기 질문 객체 생성
	function mkScheduleObj (qstnForm) {
		var returnObj = {};
		var optList   = qstnForm.find(".schedule-option");
		var optCnt    = optList.length;
		var option    = [];
		var optSet    = new Set(); // 중복값 확인.
		
		for (var i = 0; i < optCnt; i++) {
			var optObj   = {};
			var sDate = optList.eq(i).find(".sDate").val();
			var eDate = optList.eq(i).find(".eDate").val();
			var scheduleTxt = optList.eq(i).find(".scheduleTxt").val().trim();
			var dateOpt = optList.eq(i).find(".dateOpt").val();
			
			switch (dateOpt) {
			case "one":
				var inputDate = sDate;
				var date = new Date(inputDate);
				if (isNaN(date.getTime())) {
					returnObj['error'] = "strDateFormatValidation"; return returnObj;
				}
				
				optValue = sDate;
				break;
			case "mul":
				var inputSDate = sDate;
				var tmpSDate = new Date(inputSDate);
				if (isNaN(tmpSDate.getTime())) {
					returnObj['error'] = "strDateFormatValidation"; return returnObj;
				}
				
				var inputEDate = eDate;
				var tmpEDate = new Date(inputEDate);
				if (isNaN(tmpEDate.getTime())) {
					returnObj['error'] = "strDateFormatValidation"; return returnObj;
				}
				
				if (tmpSDate > tmpEDate || tmpSDate.getTime() == tmpEDate.getTime()) {
					returnObj['error'] = "strDateTimeValidation"; return returnObj;
				}
				
				optValue = sDate + " ~ " + eDate;
				break;
			case "txt":
				if (scheduleTxt.length == 0) {
					returnObj['error'] = "strContent"; return returnObj;
				}
				
				optValue = scheduleTxt;
				break;
			default:
				returnObj['error'] = "strError"; return returnObj;
				break;
			}
			
			if (optValue) {
				optObj["content"] = optValue;
				optObj["level"]   = i;
				option.push(optObj);
				optSet.add(optValue);
			}
		}
		
		if (option.length < 2) {returnObj['error'] = "strOptErr"; return returnObj;}
		if (optSet.size != option.length) {returnObj['error'] = "strOptErr1"; return returnObj;}
		
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
		var unitInput    = qstnForm.querySelector("input[class='slider-input']");
		var cntInput    = qstnForm.querySelector("input[class='slider-cnt']");
		var unitValue    = unitInput    ? parseInt(unitInput.value)    : -1;
		var lowestValue  = lowestInput  ? parseInt(lowestInput.value)  : -1;
		var highestValue = highestInput ? parseInt(highestInput.value) : -1;
		var cntValue = cntInput ? parseInt(cntInput.value) : -1;

		//Check slider requirements
		if (!isValid(lowestInput.value))       {sliderObj.error = "strSlider1"; return sliderObj;}
		if (!isValid(unitInput.value))         {sliderObj.error = "strSlider5"; return sliderObj;}
		if (!isValid(highestInput.value))      {sliderObj.error = "strSlider2"; return sliderObj;}
		if (lowestValue >= highestValue) {sliderObj.error = "strSlider3"; return sliderObj;}
		if (cntValue > 200) {sliderObj.error = "strSlider10"; return sliderObj;}
		
		var option = [];
		option.push({content : lowestValue, level : 0});
		option.push({content : highestValue, level : 1});
		
		sliderObj["option"]  = option;
		sliderObj["unit"]    = unitValue;
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
				var optVal = replaceAll(opt[i].childNodes[0].childNodes[0].childNodes[0].value, "(<(\/?)(script|applet|object)>)", ""); // 보기가 비어있는지 확인
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
			var othVal         = replaceAll(oth[0].childNodes[0].childNodes[0].childNodes[0].value, "(<(\/?)(script|applet|object)>)", "");
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
			var rowSet = new Set(); // 행 데이터 중복 체크
			
			for (var i = 0, len = rows.length; i < len; i++) {
				var rowObj = {};
				var rowVal = replaceAll(rows[i].childNodes[0].value, "(<(\/?)(script|applet|object)>)", "").trim();
				
				if (rowVal) {
					rowObj["colLevel"] = -1;
					rowObj["rowLevel"] = row.length;
					rowObj["content"]  = rowVal;
					row.push(rowObj);
					rowSet.add(rowVal);
				}
			}
			
			if (row.length == 0) {mtrObj["error"] = "strMaxtrix1"; return mtrObj;}
			if (rowSet.size != row.length) {mtrObj["error"] = "strMaxtrix3"; return mtrObj;}
			Array.prototype.push.apply(option, row);
		}
		
		if (cols) {
			var col = [];
			var colSet = new Set();
			
			for (var i = 0, len = cols.length; i < len; i++) {
				var colObj = {};
				var colVal = replaceAll(cols[i].childNodes[0].value, "(<(\/?)(script|applet|object)>)", "").trim();
				
				if (colVal) {
					colObj["colLevel"] = col.length;
					colObj["rowLevel"] = -1;
					colObj["content"]  = colVal;
					col.push(colObj);
					colSet.add(colVal);
				}
			}
			
			if (col.length == 0) {mtrObj["error"] = "strMaxtrix2"; return mtrObj;}
			if (colSet.size != col.length) {mtrObj["error"] = "strMaxtrix4"; return mtrObj;}
			Array.prototype.push.apply(option, col);
		}
		
		mtrObj["option"] = option;
		return mtrObj;
	}
	
	// make ranking/dropdown options
	function mkOptions(type, order, content) {
		var options   = $("<div class='" + type + "-select'></div>");
		var span      = $("<span class='" + type + "-order'>" + order + "</span>");
		
		/* 2022-08-02 홍승비 - 설문조사 순위, 드롭다운 수정 시 작은따옴표 ''가 포함될 때의 오류 및 특수문자 파싱되는 오류 수정 */
		var contents  = $("<input class='textInput' type='text' value='" + MakeXMLString(content) + "' maxlength='115' placeholder='" + SurveyMessages.strContent + "'/>");
		var delOption = $("<ul class='survey_atchBtn'><li class='off delOption'><span class='survey_icon srvyDel'></span></li></ul>");
		options.append(span);
		options.append(contents);
		options.append(delOption);
		
		return options;
	}
	
	function mkScheduleOptions(content) {
		content = content == null ? "" : content;
		var optionElems   = $("<div class='schedule-option'></div>");
		var scheduleInputDiv = $("<div class='schedule-input'></div>");
		var sDate     = $("<input type='text' class='sDate'/>");
		var betweenSpan = $("<span class='betweenSpan'>~</span>");
		var eDate     = $("<input type='text' class='eDate'/>");
		var txtInput  = $("<input type='text' maxlength='30' class='scheduleTxt'/>");
		var dateOpt   = $("<select class='dateOpt'><option value='one'>" + SurveyMessages.strScheduleOneDay + "</option><option value='mul'>" + SurveyMessages.strScheduleMtpDay + "</option><option value='txt'>" + SurveyMessages.strScheduleTxt + "</option></select>");
		var contentInput   = $("<input type='hidden' class='contentInput' value='" + content + "'/>");
		
		dateOpt.change(function() {
			var dateOptValue = $(this).val();
			displayScheduleInputs(dateOptValue, sDate, betweenSpan, eDate, txtInput);
		});
		
		var delOption = $("<ul class='survey_atchBtn'><li class='off scheDelOption'><span class='survey_icon srvyDel'></span></li></ul>");
		
		scheduleInputDiv.append(sDate);
		scheduleInputDiv.append(betweenSpan);
		scheduleInputDiv.append(eDate);
		scheduleInputDiv.append(txtInput);
		scheduleInputDiv.append(dateOpt);
		scheduleInputDiv.append(contentInput);
		optionElems.append(scheduleInputDiv);
		optionElems.append(delOption);
		return optionElems;
	}
	
	function displayScheduleInputs(dateOptValue, sDateElem, betweenElem, eDateElem, txtInputElem) {
		if (dateOptValue === 'one') {
			sDateElem.show();
			sDateElem.next().show();
			betweenElem.hide();
			eDateElem.hide();
			eDateElem.next().hide();
			txtInputElem.hide();
		} else if (dateOptValue === 'mul') {
			sDateElem.show();
			sDateElem.next().show();
			betweenElem.show();
			eDateElem.show();
			eDateElem.next().show();
			txtInputElem.hide();
		} else {
			sDateElem.hide();
			sDateElem.next().hide();
			betweenElem.hide();
			eDateElem.hide();
			eDateElem.next().hide();
			txtInputElem.show();
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
	
	// selection 질문의 보기 생성
	function mkOpt(type, options) {
		var optAtt    = "";
		var attEl     = "";
		var opt       = "";
		var textInput = "";
		var optArea   = $("<div class='optArea'></div>");
		var option    = $("<div class='option'></div>");
		
		if (type == "other") {
			opt = $("<div class='other'></div>");
			if (options) {
				textInput = $("<input class='textInput' type='text' value='" + escapeHtml(options["content"]) + "' maxlength='250' placeholder='" + SurveyMessages.strOther + "'/>");
				optAtt    = options["attach"];
			}
			else {
				textInput = $("<input class='textInput' type='text' maxLength='250' placeholder='" + SurveyMessages.strOther + "'>");
			}
		}
		else {
			opt = $("<div class='optPart'></div>");
			if (options) {
				textInput = $("<input class='textInput' type='text' value='" + escapeHtml(options["content"]) + "' maxlength='250' placeholder='" + SurveyMessages.strContent + "' />");
				optAtt = options["attach"];
			}
			else {
				textInput = $("<input class='textInput' type='text' maxlength='250' placeholder='" + SurveyMessages.strContent + "'/>");
			}
		}
		
		//Add attach and delete buttons
		var ulBttns  = $("<ul class='survey_atchBtn'></ul>");
		var liAttch  = $("<li class='off attImg'><span class='survey_icon atchImg'></span></li>");
		//var liUrl    = $("<li class='off attUrl'><span class='survey_icon atchUrl'></span></li>");
		var liUrl    = $("<li class='off attUrl'><span class=''>" + SurveyMessages.strAttUrl + "</span></li>");
		var liDel    = $("<li class='off delImg'><span class='survey_icon srvyDel'></span></li>");
		
		ulBttns.append(liAttch);
		ulBttns.append(liUrl);
		ulBttns.append(liDel);
		option.append(textInput);
		option.append(ulBttns);
		
		var optFileInfo = $("<div class='optFileInfo'></div>");
		var fileList = $("<div class='fileList'></div>");

		if (optAtt) {attEl = mkImgTag(optAtt);}
		
		var optUl         = $("<ul class='optUl'></ul>");
		var optionImgFile = $("<input type='file' class='optionImgFile' accept='/*'/>");
		optUl.append(attEl);
		
		fileList.append(optUl);
		fileList.append(optionImgFile);
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
		
		/* 2022-08-02 홍승비 - 설문조사 행렬 수정 시 작은따옴표 ''가 포함될 때의 오류 및 특수문자 파싱되는 오류 수정 */
		if (elment) {
			level   = elment["level"];
			content = MakeXMLString(elment["content"]);
		}
		
		var html  = "<div class='" + type + "' level='" + level + "'>";
			html += "<input class='" + type + "Input' maxlength='33' value='" + content + "'>";
			html += "<ul class='survey_atchBtn'><li class='off " + elClass + "'><span class='survey_icon srvyDel'></span></li></ul>";
			html += "</div>";
		return html;
	}
	
	function mkAddtionalPart(action) {
		var html = "<div class='survey-bttn-panel'>";
		html    += "<ul class='survey_qsbtn'>";
			
		if (action == config["modify"]) {
			html += "<li class='modify'><span>" + SurveyMessages.strModify + "</span></li>";
			html += "<li class='mdfCancel'><span>" + SurveyMessages.strCancel + "</span></li>";
		}
		else {
			html += "<li class='save'><span>" + SurveyMessages.strSaveTxt + "</span></li>";
			html += "<li class='cancel'><span>" + SurveyMessages.strCancel + "</span></li>";
		}
		
		html += "</ul></div>";
		return $(html);
	}
	
	function makeQuestionForm(questionType) {return $("<div class='qstnForm' questionType='" + questionType + "'>");}
	
	function makeTextQuestion(mainDivElmt, questionType, type, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var textQs = handleModifyTextQuesion(type, "make");
		var addtional = mkAddtionalPart(checkResult[config["action"]]);
		
		questionForm.append(textQs);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
	}
	
	function makeSliderQuestion(mainDivElmt, questionType, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var slider = handleModifySliderQuesion();
		var addtional = mkAddtionalPart(checkResult[config["action"]]);
		
		questionForm.append(slider);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
	}
	
	function makeRankingQuestion(mainDivElmt, questionType, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var raking       =  handleModifyRankDropDownQuesion("ranking");
		var addtional    = mkAddtionalPart(checkResult[config["action"]]);
		questionForm.append(raking);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
	}
	
	function makeDropdownQuestion(mainDivElmt, questionType, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var drdw         = handleModifyRankDropDownQuesion("dropdown");
		var addtional    = mkAddtionalPart(checkResult[config["action"]]);
		questionForm.append(drdw);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
	}
	
	function makeScheduleQuestion(mainDivElmt, questionType, checkResult) {
		var questionForm = makeQuestionForm(questionType);
		var schedule = handleModifyScheduleQuestion();
		var addtional    = mkAddtionalPart(checkResult[config["action"]]);
		questionForm.append(schedule);
		questionForm.append(addtional);
		mainDivElmt.append(questionForm);
		addScheduleInputEvents();
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
	
	function getImgTitleInfo(elmtObj) {
		var imgTitleObj      = {};
		imgTitleObj["fname"] = elmtObj.getAttribute("fname");
		
		if (elmtObj.getAttribute("furl")) {
			imgTitleObj["furl"] = elmtObj.getAttribute("furl");
		}
		else {
			imgTitleObj["fpath"] = elmtObj.getAttribute("path");
		}
		
		return imgTitleObj;
	}
	
	function isValid(value) {if (!isNaN(value) && parseFloat(value) >= 0 && value % 1 === 0) {return true;} else {return false;}}
	
	// 질문 생성
	function prevQstn(step) {
		var qstnList = SurveyCreate.getQs();
		var qsArea = "";
		
		if (step == 3 || step == 0) {
			qsArea = $(".prevQsArea");
			$(".confirmQsArea").html("");
			
		} else if (step == 4) {
			qsArea = $(".confirmQsArea");
			$(".prevQsArea").html("");
			
			var qstInf = SurveyCreate.getInfo();
			confirmSurveyInfo(qstInf);
		}
		qsArea.html("");
		
		if (qstnList.length != 0) {
			for (var i = 0; i < qstnList.length; i++) {
				var question = qstnList[i];
				var qstnId = question.level;
				var qstnType = question.type;
				var qstnSkip = question.skip; // 단일분기의 경우, 해당 질문 답변 시 대상 분기 질문 활성화 (skip = -1인 경우 단일분기 없음 / 항목 별 분기는 존재 가능함)
				var wrapper = $("<div class='prevQsWrapper' id='prevQstn" + qstnId + "'type='" + qstnType + "' skip='" + qstnSkip + "'></div>");
				
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
					case 10 : 
					case 11 : body = mkScheduleQstn(question)             ; break; 
					default : alert(SurveyMessages.strError)            ; return;
				}
				
				wrapper.append(header);
				prevQsOpt.append(body);
				wrapper.append(prevQsOpt);
				qsArea.append(wrapper);

				if (step != 0) {
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
		var imgTitle        = question.imgTitle;
		var prevQsContent   = $("<div class='prevQsContent'></div>");
		var questionPanel   = $("<div class='question-panel'></div>");
		var questionHeader  = $("<div class='question-header'></div>");
		var questionContent = $("<div class='question-content'></div>");
		var qstnHeader      = "";
		var questionAttach  = "";
		var imptt           = required == 1 ? "<strong class='imptt'>*</strong>" : "";
		
		if (imgTitle) {
			var span         = document.createElement("span");
			span.textContent = qstId +". ";
			var attDiv       = document.createElement("div");
			var attImg       = document.createElement("img");
			var attachInf    = questionFile.getImage(imgTitle);
			attImg.src       = attachInf["imageSrc"];
			attImg.className = "titleImg";
			attDiv.className = "question-attach questionImgTitle";
			attDiv.appendChild(attImg);
			attDiv.style.maxHeight = 'none';
			attDiv.style.padding = '10px 0px 0px 0px';
			attDiv.style.margin = '0px 35px'; 
			
			if (attachInf["isImage"] == 0) {
				var spanElmt         = document.createElement("span");
				spanElmt.textContent = qstnAtt["fname"];
				spanElmt.setAttribute("title", qstnAtt["fname"]);
				attDiv.appendChild(spanElmt);
			}
			
			questionContent[0].appendChild(span);
			questionPanel[0].appendChild(attDiv);
		} else {
			questionContent[0].textContent = qstId + ". " + content;
		}
		
		if (step == 3) {
			var frstBtnGrp = $("<ul id='frstBtnGrp" + qstId + "' class='srvyLogicbtn survey_atchBtn frstBtnGrp'></ul>");
			var addSkip = $("<li id='addSkip" + qstId + "' class='off addSkip'><span class='survey_icon logicSkip'></span></li>");
			frstBtnGrp.append(addSkip);
			
			qstnHeader += "<ul id='skipScndBtnGrp" + qstId + "' class='srvyLogicbtn survey_atchBtn skipScndBtnGrp' style='display:none;'>"
			qstnHeader += "<li id='saveSkip" + qstId + "' class='off saveSkip'><span class='survey_text'>" + SurveyMessages.strSaveTxt + "</span></li>";
			qstnHeader += "<li id='cancelSkip" + qstId + "' class='off cancelSkip'><span class='survey_icon logicCancel'></span></li>";
			qstnHeader += "</ul>";
			qstnHeader += "<ul id='skipThrdBtnGrp" + qstId + "' class='srvyLogicbtn survey_atchBtn skipThrdBtnGrp' style='display:none;'>"
			qstnHeader += "<li id='mdfSkip" + qstId + "' class='off mdfSkip'><span class='survey_text'>" + SurveyMessages.strModify + "</span></li>";
			qstnHeader += "<li id='delSkip" + qstId + "' class='off delSkip'><span class='survey_icon logicDel'></span></li>";
			qstnHeader += "</ul>";
			
			if ([1, 2, 7, 9, 10, 11].includes(qstnType)) {
				var addLogic = $("<li id='addLogic" + qstId + "' class='off addLogic'><span class='survey_icon logicShuffle'></span></li>");
				frstBtnGrp.append(addLogic);
				
				qstnHeader += "<ul id='scndBtnGrp" + qstId + "' class='srvyLogicbtn survey_atchBtn scndBtnGrp' style='display:none;'>"
				qstnHeader += "<li id='saveLogic" + qstId + "' class='off saveLogic'><span class='survey_text'>" + SurveyMessages.strSaveTxt + "</span></li>";
				qstnHeader += "<li id='cancelLogic" + qstId + "' class='off cancelLogic'><span class='survey_icon logicCancel'></span></li>";
				qstnHeader += "</ul>";
				qstnHeader += "<ul id='thrdBtnGrp" + qstId + "' class='srvyLogicbtn survey_atchBtn thrdBtnGrp' style='display:none;'>"
				qstnHeader += "<li id='mdfLogic" + qstId + "' class='off mdfLogic'><span class='survey_text'>" + SurveyMessages.strModify + "</span></li>";
				qstnHeader += "<li id='delLogic" + qstId + "' class='off delLogic'><span class='survey_icon logicDel'></span></li>";
				qstnHeader += "</ul>";
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
	
	// 분기 생성
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
		case 2 :
			sltLogicForm(prevWrapper, htmlOption, thisQstn, id);
			break;
		case 7 :
			slidLogicForm(prevWrapper, htmlOption, thisQstn, id);
			break;
		case 9 :
			drdwLogicForm(prevWrapper, htmlOption, thisQstn, id);
			break;
		case 10 :
			scheduleLogicForm(prevWrapper, htmlOption, thisQstn, id);
			break;
		case 11 :
			scheduleLogicForm(prevWrapper, htmlOption, thisQstn, id);
			break;
		}
	}
	
	// select 질문에 분기 추가
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
			opt.appendChild($(html)[0]);
			
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
				
				// logicNum = -1인 경우, 분기없음 선택되도록 수정
				if (logicNum = -1) {
					$("#slt" + id + i).val("").prop("selected", true).css("display", "none");
				} else {
					$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "none");
				}
				$("#sltVal" + id + i).text(logic).css("dispaly", "");
			}
		}
	}
	
	// slider 질문에 분기 추가
	function slidLogicForm(prevWrapper, htmlOption, question, qstnId) {
		var id = "";
		var qstnOpt = question.option;
		var prevQsOpt = prevWrapper.find(".prevQsOpt");
		var logicPoint = "";
		
		if (qstnId) {
			id = qstnId;
			logicPoint = question['sliderLogicPoint'];
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
			html += "<span id='LogicPoint" + id + "' class='logicSpan' style='display:none;'></span>";
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
			
			if (!isNaN(logicNum) && logicNum != -1 && logicNum != 0) {
				logic = SurveyMessages.strQs + " " + logicNum;
				
			} else if (logicNum == 0) {
				logic = SurveyMessages.strLast;
				
			} else {
				logic = SurveyMessages.strNoLogic;
			}
			
			$("#frstBtnGrp" + id).css("display", "none");
			$("#thrdBtnGrp" + id).css("display", "");
			
			$("#slidLogicInput" + id).val(logicPoint).css("display", "none");
			$("#LogicPoint" + id).text(logicPoint).css("display", "");
			
			if (logicNum = -1) {
				$("#slt" + id).val("").prop("selected", true).css("display", "none");
			} else {
				$("#slt" + id).val(logicNum).prop("selected", true).css("display", "none");
			}
			$("#sltVal" + id).text(logic).css("dispaly", "");
		}
	}
	
	// dropdown 질문에 분기 추가
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
				
				if (logicNum = -1) {
					$("#slt" + id + i).val("").prop("selected", true).css("display", "none");
				} else {
					$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "none");
				}
				$("#sltVal" + id + i).text(logic).css("dispaly", "");
			}
		}
	}
	
	function scheduleLogicForm(prevWrapper, htmlOption, question, qstnId) {
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
			html += "<div id='logic" + id + optLevel + "' class='scheduleLogicArea'>";
			html += "<img class='prevScheduleArrow' src='/images/ezSurvey/arrow.png'>";
			html += "<select class='logicSelect' name='slt" + id + optLevel + "' id='slt" + id + optLevel + "'>";
			html += htmlOption;
			html += "</select>";
			html += "<span class='logicSpan' id='sltVal" + id + i + "'></span>";
			html += "</div>";
			
			var opt = opts[i];
			opt.appendChild($(html)[0]);
			
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
				
				// logicNum = -1인 경우, 분기없음 선택되도록 수정
				if (logicNum = -1) {
					$("#slt" + id + i).val("").prop("selected", true).css("display", "none");
				} else {
					$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "none");
				}
				$("#sltVal" + id + i).text(logic).css("dispaly", "");
			}
		}
	}
	
	// select 질문 분기 나타내기
	function showSltLogicForm(id, qstn) {
		var prevQsWrapper = $("#prevQstn" + id);
		var opt = prevQsWrapper.find(".prevQsOpt").find(".opt");
		
		var qstnOpt = qstn.option;
		
		for (var i = 0; i < opt.length; i++) {
			var logicNum = qstnOpt[i]['logic'];

			if (!isNaN(logicNum) && logicNum != -1) { // 분기없음 대응 코드 추가
				$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "");
			} else {
				$("#slt" + id + i).val('').prop("selected", true).css("display", "");
			}
			$("#sltVal" + id + i).css("display", "none");
		}
	}
	
	// select 질문 객체, ui에 분기 번호 추가
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
	
	// slider 질문에 분기 나타내기
	function showSlidLogicForm(id, qstn) {
		var prevQsWrapper = $("#prevQstn" + id);
		
		var logicPoint = qstn['sliderLogicPoint'];
		var logicNum = qstn.option[0]['logic'];
		
		$("#slidLogicInput" + id).val(logicPoint).css("display", "");
		$("#LogicPoint" + id).css("display", "none");
		
		$("#sltVal" + id).css("display", "none");
		
		if (!isNaN(logicNum) && logicNum != -1) {
			$("#slt" + id).val(logicNum).prop("selected", true).css("display", "");
		} else {
			$("#slt" + id).val("").prop("selected", true).css("display", "");
		}
	}
	
	// slider 질문 객체, ui에 분기 번호 추가
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
	
	// dropdown 질문 분기 나타내기
	function showDrdwLogicForm(id, qstn) {
		var prevQsWrapper = $("#prevQstn" + id);
		var logicRow = prevQsWrapper.find("#logic" + id).find(".drdwLogicRow");
		var RowLength = logicRow.length;
		
		var qstnOpt = qstn.option;
		
		for (var i = 0; i < RowLength; i++) {
			var logicNum = qstnOpt[i]['logic'];
			
			if (!isNaN(logicNum) && logicNum != -1) {
				$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "");
			} else {
				$("#slt" + id + i).val('').prop("selected", true).css("display", "");
			}
			
			$("#sltVal" + id + i).css("display", "none");
		}
	}
	
	// dropdown 질문 객체, ui에 분기 번호 추가
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
	
	// 일정 질문 분기 나타내기
	function showScheduleLogicForm(id, qstn) {
		var prevQsWrapper = $("#prevQstn" + id);
		var opt = prevQsWrapper.find(".prevQsOpt").find(".opt");
		
		var qstnOpt = qstn.option;
		
		for (var i = 0; i < opt.length; i++) {
			var logicNum = qstnOpt[i]['logic'];

			if (!isNaN(logicNum) && logicNum != -1) { // 분기없음 대응 코드 추가
				$("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "");
			} else {
				$("#slt" + id + i).val('').prop("selected", true).css("display", "");
			}
			$("#sltVal" + id + i).css("display", "none");
		}
	}
	
	// 일정 질문 객체, ui에 분기 번호 추가
	function addScheduleLogic(id, qstn) {
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
	
	// 질문 헤더에 전체 분기 나타내기
	function mkSkipForm(id, mode) {
		var prevWrapper = $("#prevQstn" + id);
		var qstnContent = prevWrapper.find(".question-content");
		var qstnList = SurveyCreate.getQs();
		var qstn = qstnList[id-1];
		var skipFlag = qstn['skipFlag'];
		
		var htmlOption = "";
		if (mode == "skip") {
			htmlOption += "<option value=''>" + SurveyMessages.strSkipQs + "</option>"; 
			
		} else {
			htmlOption += "<option value=''>" + SurveyMessages.strNoLogic + "</option>"; 
		}
		
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
	
	// 분기 폼 제거
	function dltLogicForm(type, id) {
		if (type == 1 || type == 2 || type == 10) {
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
	
	function getLogicMessageFromLogicNum(logicNum) {
		var logic = "";
		
		if (isNaN(logicNum) || logicNum == -1) {
			logic = SurveyMessages.strNoLogic;
		}
		else {
			if (logicNum == 0 ) {
				logic = SurveyMessages.strLast;
			}
			else {
				logic = SurveyMessages.strQs + " " + logicNum;
			}
		}
		
		return logic;
	}
	
	// 기존의 logicNum 나타냄
	function cnclLogicMdf(id, qstn, type) {
		if (type == 7) {
			var inputVal = qstn['sliderLogicPoint'];
			var logicNum = qstn.option[0]['logic'];
			var logic    = getLogicMessageFromLogicNum(logicNum);
			
			$("#slidLogicInput" + id).val(inputVal).css("display", "none");
			$("#LogicPoint" + id).text(inputVal).css("display", "");
			$("select[name=slt" + id + "]").css("display", "none");
			$("#sltVal" + id).text(logic).css("display", "");
			
		}
		else if (type == 1 || type == 2 || type == 9 || type == 10) {
			var wrapper = $("#prevQstn"+id);
			var opt = "";
			var optLength = "";
			
			if (type == 1 || type == 2 || type == 10) {
				opt = wrapper.find(".opt");
				optLength = opt.length;
				
			}
			else if (type == 9) {
				opt = wrapper.find(".drdwLogicRow");
				optLength = opt.length;
			}
			
			for (var i = 0; i < optLength; i++) {
				var logicNum = qstn.option[i]['logic'];
				var logic    = getLogicMessageFromLogicNum(logicNum);
				
				!isNaN(logicNum) ? $("#slt" + id + i).val(logicNum).prop("selected", true).css("display", "none") : $("#slt" + id + i).val('').prop("selected", true).css("display", "none");
				$("#sltVal" + id + i).text(logic).css("display", "");
			}
		}
		else {
			var logicNum = qstn.option[0]['logic'];
			var logic    = getLogicMessageFromLogicNum(logicNum);
			$("select[name=slt" + id + "]").css("display", "none");
			$("#sltVal" + id).text(logic).css("display", "");
		}
	}
	
	function checkLogicNum(id, qstn, type) {
		var logicArr  = []; 
		var wrapper   = $("#prevQstn"+id);
		var opt       = "";
		var optLength = "";
		var valI      = "";
		var valJ      = "";
		var result    = "";
		var emptyCount = 0;
		
		if (type == 1 || type == 2 || type == 10 || type == 11) {
			opt       = wrapper.find(".opt");
			optLength = opt.length;
		}
		else if (type == 9) {
			opt       = wrapper.find(".drdwLogicRow");
			optLength = opt.length;
		}
		
		for (var i = 0; i < optLength; i++) {
			var logicNum = $("select[name=slt" + id  + i +"] option:selected").val();
			if (logicNum != "") {
				logicArr.push(logicNum);
			} else {
				emptyCount++;
			}
		}
		
		if (emptyCount == optLength) {
			alert(SurveyMessages.strLogic);
			return "fail";
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
					}
					else {
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
		var surveyInfWrap = document.getElementById("surveyInfConfirm");
		document.getElementById("cf-purpose").innerHTML      = replaceAll(qstInf["purpose"], "(&lt;(\/?)(script|applet|object)&gt;)", "");
		document.getElementById("cf-startDate").textContent  = qstInf["startDate"];
		document.getElementById("cf-endDate").textContent    = qstInf["endDate"];
		document.getElementById("cf-anoynymous").textContent = qstInf["anonymous"] == 0 ? SurveyMessages.strAnoynym1  : SurveyMessages.strAnoynym2;
		document.getElementById("cf-multiple").textContent   = qstInf["multiple"]  == 0 ? SurveyMessages.strMultiple1 : SurveyMessages.strMultiple2;
		document.getElementById("cf-mail").textContent   = qstInf["mail"]  == 0 ? SurveyMessages.strNotSend : SurveyMessages.strSend;
		document.getElementById("cf-popup").textContent   = qstInf["popup"]  == 0 ? SurveyMessages.strNotSend : SurveyMessages.strSend;
		
		if (qstInf["closing"] != "") {
			document.getElementById("closingArea").style.display = "";
			document.getElementById("cf-closing").innerHTML = escapeHtml(qstInf["closing"]).replace(/(\r\n|\n|\r)/g, "<br/>");
		} else {
			document.getElementById("closingArea").style.display = "none";
		}
		
		// 설문 최종확인 시 설문결과 타입 표출
		if (qstInf["public"] == 1) {
			document.getElementById("public-cfdiv").innerHTML = SurveyMessages.strPublic1;
			document.getElementById("public-days").innerHTML  = SurveyMessages.strPublic4 + " " + qstInf["publicDays"] + " " + SurveyMessages.strPublic5;
		} else if (qstInf["public"] == 2) {
        	document.getElementById("public-days").innerHTML  = "";
        	var resultUserList = qstInf["resultViewTarget"];
		    if (resultUserList.length != 0) {
		        openPreviewUserListPopup(resultUserList, 'result')
		    }
		} else {
			document.getElementById("public-cfdiv").innerHTML = SurveyMessages.strPublic2;
			document.getElementById("public-days").innerHTML  = "";
		}
		
		// 설문 최종확인 시 설문 대상자 표출
		if (qstInf["userflag"] == 0) {
			document.getElementById("cf-userdiv").innerHTML = "<span class='inf-survey'> " + SurveyMessages.strUser2 + "</span>";
		}
		else {
			var userList = qstInf["users"];
		    openPreviewUserListPopup(userList, 'survey');
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
	
	function checkUrl(str) {var pattern = new RegExp("^(http|https)://", "i"); return pattern.test(str);}
	// URL 첨부 추가
	function saveLinkAttach(elmt, ulClass) {
		var attachName = document.getElementById("attfileName");
		var attachUrl  = document.getElementById("attfileUrl");

		if (!replaceAll(attachName.value, " ", "")) {alert(SurveyMessages.strURL1); attachName.focus(); return;}
		if (!replaceAll(attachUrl.value, " ", ""))  {alert(SurveyMessages.strURL2); attachUrl.focus() ; return;}
		if (!checkUrl(attachUrl.value))             {alert(SurveyMessages.strURL3); attachUrl.focus() ; return;}
		var mainUlElmt = elmt ? elmt.querySelector("ul[class='" + ulClass + "']") : document.getElementById("fileDiv").querySelector("ul[class='ulFiles']");
		
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
        // 이유정 - URL 추가시, 파일 추가와 마찬가지로 "divInform" div 제거 후 파일추가창이 안뜨도록 함.
		var fileDivElmt         = document.getElementById("fileDiv");
		var divfileListElmt     = fileDivElmt.firstElementChild;
		var divInform = document.querySelector(".divInform");
		if (divInform) {
			divfileListElmt.className = "fileList";
			var divInformElmt         = fileDivElmt.querySelector("div[class='divInform']");
			var helpDivElmt           = document.getElementById("helpTxt");
			if (divInformElmt) {fileDivElmt.removeChild(divInformElmt);}
			if (helpDivElmt)   {helpDivElmt.className = "uploadHelp";}
			fileDivElmt.onclick = null;
		}
		toggleUrlPanel();
	}
	// URL 첨부 삭제
	function deleteUrlFile(event) {
		event.stopPropagation();
		var liElmt = event.currentTarget.parentElement;
		liElmt.parentElement.removeChild(liElmt);
	}
	// URL 레이어 팝업 토글 함수
	function toggleUrlPanel(elmt, ulClass) {
		var rightFrame  = window.parent.frames["right"].document;
		var urlPanel    = rightFrame.getElementById("addURLPanel");
		if (urlPanel.className == "searchPanel off") {
			addFogPanel(toggleUrlPanel);
			var position         = getPosition(466, 210);
			urlPanel.style.top   = position[0] + "px";
			urlPanel.style.right = position[1] + "px";
			urlPanel.className   = "searchPanel";
			document.getElementById("addUrlAttach").onclick = function(e) {saveLinkAttach(elmt, ulClass);};
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
	
	// 설문작성 > 최종확인 > 설문결과, 대상자 정보 표출
    function openPreviewUserListPopup(userList, mode) {
        var divId;
        var surveyUserElmt;
        var userTableElmt;
        if (mode == 'survey') {
            divId = 'cf-userdiv';
            surveyUserElmt = document.getElementById(divId);
            userTableElmt = document.getElementById("user-tblmain");
            surveyUserElmt.innerHTML = "";
        } else if (mode == "result") {
            divId = 'public-cfdiv';
            surveyUserElmt = document.getElementById(divId);
            userTableElmt = document.getElementById("userResult-tblmain");
            surveyUserElmt.innerHTML = SurveyMessages.strPublic3 + "  /  ";
        }
        
        if (userList.length < 1) {
            for (var i = 0 ; i < userList.length; i++) {
                var spanElmt = document.createElement("span");
                spanElmt.textContent = userList[i]["userName"];
                spanElmt.className   = "user-inf";
                spanElmt.onclick     = (function(userId, userType, userName, deptId) {
                    return function() {SurveyCreate.showUser(userId, userType, userName, deptId);};
                })(userList[i]["userId"], userList[i]["userType"], userList[i]["userName"], userList[i]["deptId"]);
                
                surveyUserElmt.appendChild(spanElmt);
                
                if (i != userList.length - 1) {
                    var divideSpan         = document.createElement("span");
                    divideSpan.textContent = "; ";
                    surveyUserElmt.appendChild(divideSpan);
                }
            }
            
            var spanElmt2         = document.createElement("span");
            spanElmt2.className   = "total-user";
            spanElmt2.textContent = "[" + SurveyMessages.strTotal + " " + userList.length + " " + SurveyMessages.strUser3 + "]";
            surveyUserElmt.appendChild(spanElmt2);
        } else {
            var spanElmt1 = document.createElement("span");
            var spanElmt2 = document.createElement("span");
            var spanElmt3 = document.createElement("span");
            
            spanElmt1.className   = "user-inf";
            spanElmt1.textContent = userList[0]["userName"];
            spanElmt2.className   = "total-user";
            spanElmt2.textContent = "[" + SurveyMessages.strTotal + " " + userList.length + " " + SurveyMessages.strUser3 + "]";
            spanElmt3.className   = "user-more";
            spanElmt3.onclick     = function(e) {SurveyCreate.userMore(mode)};
            spanElmt3.style.display       = "inline-block"
            spanElmt3.style.verticalAlign = "middle"
            
            spanElmt1.onclick     = function(e) {SurveyCreate.showUser(userList[0]["userId"], userList[0]["userType"], userList[0]["userName"], userList[0]["deptId"]);};
        
            surveyUserElmt.appendChild(spanElmt1);
            surveyUserElmt.appendChild(spanElmt2);
            surveyUserElmt.appendChild(spanElmt3);
            
            //Set user for user panel
            userTableElmt.innerHTML = "";
            
            for (var i = 0 ; i < userList.length; i++) {
                var trElmt      = document.createElement("tr");
                var tdElmt1     = document.createElement("td");
                var tdElmt2     = document.createElement("td");
                tdElmt1.onclick = (function(userId, userType, userName, deptId) {
                    return function() {SurveyCreate.showUser(userId, userType, userName, deptId);};
                })(userList[i]["userId"], userList[i]["userType"], userList[i]["userName"], userList[0]["deptId"]);
                
                tdElmt1.textContent = userList[i]["userName"];
                tdElmt2.textContent = getUserType(userList[i]["userType"]);
                tdElmt1.className   = "user-field";
                tdElmt2.className   = "center-field";
                trElmt.appendChild(tdElmt1);
                trElmt.appendChild(tdElmt2);
                userTableElmt.appendChild(trElmt);
            }
            document.getElementById("th-usertype").className  = userList.length < 4 ? "center-field" : "center-field right-field";
        }
    }
    
    // 유저 타입 텍스트 반환
    function getUserType(userType) {
        var stUserType = "";
        switch(userType) {
            case "user" : stUserType = SurveyMessages.strUser4; break;
            case "dept" : stUserType = SurveyMessages.strUser5; break;
            case "comp" : stUserType = SurveyMessages.strUser6; break;
            case "jikwi" : stUserType = SurveyMessages.strUser9; break;
            case "jikchek" : stUserType = SurveyMessages.strUser10; break;
            case "group" : stUserType = SurveyMessages.strUser11; break;
            default     : stUserType = SurveyMessages.strUser4; break;
        }
        return stUserType;
    }
	
	function changeDownloadMode(flag) {downloadMode = flag;}
	
	return {
		getUsers   : getSurveyUsers,
		setUsers   : setSurveyUsers,
		getResultUsers : getSurveyResultUsers,
		setResultUsers : setSurveyResultUsers,
		getQs      : getSurveyQuestions,
		setQs      : setSurveyQuestions,
		getInfo    : getSurveyInfo,
		userMore   : toggleUserPreview,
		showUser   : showUserInfoFromId,
		start      : initEvents,
		setQsForm  : prevQstn,
		convertQs  : getReuseQuestions,
		changeMode : changeDownloadMode,
		getPurpose : getSurveyPurpose
	};
}();

function Editor_Complete() {
	if (editor != "HWP") {
		document.getElementById("info-input-pp").contentWindow.SetEditorContent(SurveyCreate.getPurpose());
	} else {
		var URL;
        URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=";
        document.getElementById("info-input-pp").contentWindow.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
	}
}

function addChangeEvent(obLow, obUnit, obCnt, obMax, slideMain, output) {
    var arr = [obLow, obUnit, obCnt];
    for (var obj of arr) {
        obj.on("propertychange change keyup paste input", function() {
            var low = obLow.val();
            var unit = obUnit.val();
            var cnt = obCnt.val();

            if (low !== '' && unit !== '' && cnt !== '') {
                var max = low * 1 + unit * cnt;
                slideMain.attr('min',low);
                slideMain.attr('step',unit);
                slideMain.attr('max',max);
                output.val(slideMain.val());
                obMax.val(max);
            }
        });
    }

    slideMain.on("change", function() {
        output.val(this.value);
    });
}

/* 2024-03-26 양지혜 - 숫자 외 입력금지 및 게시기간 제한 */
$(".date-input").keyup(function(){
	var inputVal = $(this).val();
	$(this).val(inputVal.replace(/[^0-9.]/g,""));
	if(inputVal > maxPeriod) {
		alert(SurveyMessages.strLangYJH01 + maxPeriod + SurveyMessages.strLangYJH02);
		$(this).val("");
	}
});

function Editor_Modify_Complete() {
	var URL;
    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=";
    document.getElementById("info-input-pp").contentWindow.Open(URL, "", "", function (res) { FieldsModify(res.result) }, null);
}

function FieldsAvailable(isTrue) {
	if (isTrue) {
		document.getElementById("info-input-pp").contentWindow.SetMargin(3000);
		document.getElementById("info-input-pp").contentWindow.EditMode(1);
		document.getElementById("info-input-pp").contentWindow.SetViewProperties(2, 100);
        document.getElementById("info-input-pp").contentWindow.ScrollPosInfo(0, 0);
        document.getElementById("info-input-pp").contentWindow.ShowToolBar(true);
        document.getElementById("info-input-pp").contentWindow.ShowRibbon(true);
        document.getElementById("info-input-pp").contentWindow.FoldRibbon(true);
        window.onresize();
	}
}

function FieldsModify(isTrue) {
	if (isTrue) {
		var html = SurveyCreate.getPurpose();
		document.getElementById("info-input-pp").contentWindow.SetTextFile(html, "HTML", "", function() {
			document.getElementById("info-input-pp").contentWindow.SetMargin(3000);
			document.getElementById("info-input-pp").contentWindow.EditMode(1);
			document.getElementById("info-input-pp").contentWindow.SetViewProperties(2, 100);
	        document.getElementById("info-input-pp").contentWindow.ScrollPosInfo(0, 0);
	        document.getElementById("info-input-pp").contentWindow.ShowToolBar(true);
	        document.getElementById("info-input-pp").contentWindow.ShowRibbon(true);
	        document.getElementById("info-input-pp").contentWindow.FoldRibbon(true);
        	window.onresize();
		});
	}
}

window.onresize = function () {
	if (editor == "HWP") {
		var mHeight = document.getElementById("editorWrap").clientHeight - 5 + "px";
   		document.getElementById("info-input-pp").contentWindow.Resize(mHeight);
	}
};

function getHTML(callBack) {
	document.getElementById("info-input-pp").contentWindow.GetTextFile("HTML", "",
		function(data){
			hwpCheck = true;
			hwpHTML = data;
			callBack();
		});
}

function getHTML4(callBack, param1, param2) {
	document.getElementById("info-input-pp").contentWindow.GetTextFile("HTML", "",
		function(data){
			hwpCheck = true;
			hwpHTML = data;
			callBack(param1, param2);
		});
}
