var SurveyItem = function() {
	var surveyPreview  = null;
	var crrPreMode     = null;
	var surveyNavi     = null;
	var surveyTable    = null;
	var pageMode       = null;
	var startTime      = null;
	var currentUser    = null;
	var searchMode     = "0"; //0: normal, 1: simple, 2: detail
	var startDateStr   = "";
	var endDateStr     = "";
	var titelStr       = "";
	var creatorNameStr = "";
	var minWPercent    = 40;
	var maxWPercent    = 75;
	var minHPercent    = 30;
	var maxHPercent    = 65;
	var itemPopup      = null;
	var documentCont   = null;
	var userWindow     = null;
	var statisticWd    = null;
	var datepickerSt   = {
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
	
	/* Preview option */
	function setData(height, width, prevMode) {
		var surveyGeneral = {
			height    : height,
			width     : width,
			minWidth  : minWPercent,
			maxWidth  : maxWPercent,
			minHeight : minHPercent,
			maxHeight : maxHPercent
		};
		
		surveyPreview = new SurveyPreview({
			percent     : surveyGeneral,
			prevDivH    : "previewH",
			prevDivW    : "previewW",
			tableId     : "surveyList",
			wraperId    : "wraperDiv",
			preContentH : "preContentH",
			preContentW : "preContentW"
		});
		
		var previewMode = pageMode == "draft" ? "off" : prevMode;
		
		switch(previewMode) {
			case "w"   : surveyPreview.resizeByWidth()      ; break;
			case "h"   : surveyPreview.resizeByHeight()     ; break;
			case "off" : surveyPreview.resizeDestroy("init"); break;
		}
		
		crrPreMode = previewMode;
	}
	
	function changePreview(mode) {
		if (mode == crrPreMode) {return;}
		var slTrElmt = surveyTable.getSelectedRow();
		crrPreMode   = mode;
		
		switch(mode) {
			case "off":
				document.getElementById("preViewNone").className   = "icon16 btn_onnoframe";
				document.getElementById("preViewBottom").className = "icon16 btn_bottomframe";
				document.getElementById("preViewleft").className   = "icon16 btn_leftframe";
				surveyPreview.resizeDestroy();
				break;
			case "w":
				document.getElementById("preViewNone").className   = "icon16 btn_noframe";
				document.getElementById("preViewBottom").className = "icon16 btn_bottomframe";
				document.getElementById("preViewleft").className   = "icon16 btn_onleftframe";
				surveyPreview.resizeByWidth();
				if (slTrElmt) {itemClickHandler(slTrElmt);}
				break;
			case "h":
				document.getElementById("preViewNone").className   = "icon16 btn_noframe";
				document.getElementById("preViewBottom").className = "icon16 btn_onbottomframe";
				document.getElementById("preViewleft").className   = "icon16 btn_leftframe";
				surveyPreview.resizeByHeight();
				if (slTrElmt) {itemClickHandler(slTrElmt);}
				break;
			default:
				return;
		}
		setPreviewFlag();
	}
	
	function setPreviewFlag() {
		var prevMode = crrPreMode;
		
		$.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : "/ezSurvey/setPreviewFlag.do",
			data : { prevMode : prevMode },
			success: function(result){
			}     			
		});
		
	}
	/* Preview option end */
	
	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	
	function windowResize() {
		preProcessing();
		closeViewPopUp();
		
		switch(crrPreMode) {
			case "w"  : surveyPreview.resizeByWidth()  ; break;
			case "h"  : surveyPreview.resizeByHeight() ; break;
		}
	}
	
	function keyPress(e) {if (e.which == 27) {if (document.getElementById("searchPanel").className == "cabSearchPanel") {toggleSearchPanel();}}}
	
	function preProcessing() {
		var divList   = document.getElementById("wraperDiv");
		var divChild  = divList.querySelector("div[class='tableDataDiv']");
		var dataTable = divChild.querySelector("table");
		var headerTbl = document.getElementById("tblSurveyList");
		var reheight  = 0;
		
		if (crrPreMode == "h") {
			reheight              = divChild.parentElement.parentElement.clientHeight - 80;
			divChild.style.height = reheight + "px";
		}
		else {
			reheight              = document.documentElement.clientHeight - 120;
			divList.style.height  = reheight + "px";
			divChild.style.height = reheight - 70 + "px";
		}
		
		if (divChild.clientHeight < dataTable.clientHeight) {
			if (!headerTbl.querySelector("th[class='scrollTh']")) {
				var thElemt       = document.createElement("th");
				thElemt.className = "scrollTh";
				headerTbl.rows[0].appendChild(thElemt);
			}
		}
		else {
			var thElmt = headerTbl.querySelector("th[class='scrollTh']");
			if (thElmt) {thElmt.parentElement.removeChild(thElmt);}
		}
	}
	
	function initEvents(height, width, prevMode, mode, crrUser) {
		currentUser = crrUser;
		pageMode    = mode;
		setData(height, width, prevMode);
		
		//Initial page navigation
		var naviMessages = {
//			next     : SurveyMessages.strNext,
//			previous : SurveyMessages.strPrev,
			item     : SurveyMessages.strItem,
			total    : SurveyMessages.strTotal
		};
		
		surveyNavi = new SurveyNavi({
			messages : naviMessages,
			divId    : "tblPageRayer",
			divClass : "pagenavi",
			headerId : "surveyInfo",
			callback : startSearchSurvey
		});
		
		//Initial table
		surveyTable = new SurveyTable({normal : "bnkSurveyNor", selected : "bnkSurveySl"});
		
		surveyTable.setTableType("cabinet");
		surveyTable.setTableElement("tblSurveyList", "id");
		surveyTable.setClickHandler(itemClickHandler);
		surveyTable.setCallBack(searchCallBack);
		surveyTable.setRenderFunct(renderTable);
		
		window.addEventListener("resize", function(e) {windowResize();}, false);
		window.addEventListener("keydown", function(e) {keyPress(e);}, false);
		window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
		
		document.onselectstart = function() {return false;};
		var sSearchInputElmt   = document.getElementById("ssInput");
		sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
		sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
		
		var searchBttnElmt = document.getElementById("searchBttnSp");
		searchBttnElmt.addEventListener("click", function(e) {startSimpleSearch();}, false);
		
		var previewNone   = document.getElementById("preViewNone");
		var previewBottom = document.getElementById("preViewBottom");
		var previewLeft   = document.getElementById("preViewleft");
		
		if (previewNone)   {previewNone.addEventListener("click"  , function(e) {changePreview("off");}, false);}
		if (previewBottom) {previewBottom.addEventListener("click", function(e) {changePreview("h")  ;}, false);}
		if (previewLeft)   {previewLeft.addEventListener("click"  , function(e) {changePreview("w")  ;}, false);}
		
		document.getElementById("sltView").addEventListener("click"      , function(e) {toggleOptionView(this);}, false);
		document.getElementById("listcount").addEventListener("change"   , function(e) {startSearchSurvey("1");}, false);
		
		var filterStatus = document.getElementById("filterStatus");
		if (filterStatus) {filterStatus.addEventListener("change"   , function(e) {startSearchSurvey("1");}, false);}
		
		var topFrame    = window.parent.parent.document.getElementById("topFrame"); 
		var leftFrame   = window.parent.document.getElementsByName("left")[0];
		var topFrameWd  = topFrame.contentWindow || topFrame.contentDocument;
		var leftFrameWd = leftFrame.contentWindow || leftFrame.contentDocument;
		
		topFrameWd.addEventListener("mouseup" , function(e) {closeViewPopUp()        ;}, false);
		leftFrameWd.addEventListener("mouseup", function(e) {closeViewPopUp()        ;}, false);
		document.addEventListener("mouseup"   , function(e) {closeViewPopupOutside(e);}, false);
		
		var closeSearchBttn     = document.getElementById("surveyClose");
		closeSearchBttn.onclick = function() {toggleSearchPanel();};
		var cabdivBttnElmt      = document.getElementById("searchDivBttn");
		var listBttns           = cabdivBttnElmt.children;
		listBttns[0].onclick    = function(e) {clearSearchDate();};
		listBttns[1].onclick    = function(e) {onMainSearch();};
		listBttns[2].onclick    = function(e) {toggleSearchPanel();};
		
		var delBttn      = document.getElementById("deleteBttn");
		var reuseBttn    = document.getElementById("reuseBttn");
		var analysisBttn = document.getElementById("analysisBttn");
		var srchBttn     = document.getElementById("searchBttn");
		var modifyBttn   = document.getElementById("modifyBttn");
		var usersBttn	 = document.getElementById("usersBttn");
		
		if (delBttn)      {delBttn.firstElementChild.onclick      = function(e) {deleteFileConfirm()     ;};}
		if (reuseBttn)    {reuseBttn.firstElementChild.onclick    = function(e) {reuseSurveyConfirm()    ;};}
		if (analysisBttn) {analysisBttn.firstElementChild.onclick = function(e) {analysisSurveyConfirm() ;};}
		if (srchBttn)     {srchBttn.firstElementChild.onclick     = function(e) {toggleSearchPanel()     ;};}
		if (modifyBttn)   {modifyBttn.firstElementChild.onclick   = function(e) {modifySurveyConfirm()   ;};}
		if (usersBttn)	  {usersBttn.firstElementChild.onclick 	  = function(e) {showParticipants() 	 ;};}
		
		$("#Sdatepicker").datepicker(datepickerSt);
		$("#Edatepicker").datepicker(datepickerSt);
		
		startSearchSurvey("1");
		preProcessing();
	}
	
	/* Search Panel */
	function toggleSearchPanel() {
		var rightFrame  = window.parent.frames["right"].document;
		var searchPanel = rightFrame.getElementById("searchPanel");
		if (searchPanel.className == "searchPanel off") {
			addFogPanel();
			var position            = getPosition(466, 210);
			searchPanel.style.top   = position[0] + "px";
			searchPanel.style.right = position[1] + "px";
			searchPanel.className   = "searchPanel";
		}
		else {
			removeFogPanel();
			searchPanel.className   = "searchPanel off";
		}
		
		//Clear all fields
		rightFrame.getElementById("Sdatepicker").value  = "";
		rightFrame.getElementById("Edatepicker").value  = "";
		rightFrame.getElementById("sCreatedUser").value = "";
		rightFrame.getElementById("sSurveyTtl").value   = "";
	}
	
	function addFogPanel() {
		var fogPanel                 = document.createElement("div");
		fogPanel.className           = "rfogPanel";
		var leftFogPanel             = document.createElement("div");
		leftFogPanel.className       = "blockLeft";
		fogPanel.onclick             = function(e) {toggleSearchPanel();};
		leftFogPanel.onclick         = function(e) {toggleSearchPanel();};
		var leftFrameBody            = window.parent.frames["left"].document.body;
		leftFrameBody.style.overflow = "hidden";
		
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
		
		leftFrame.body.style.overflow = "auto";
	}
	
	function clearSearchDate() {
		document.getElementById("Sdatepicker").value = "";
		document.getElementById("Edatepicker").value = "";
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
	
	function searchCallBack() {
		var crrPage = surveyNavi.get().currentPage;
		crrPage     = crrPage ? crrPage : 1;
		
		startSearchSurvey(crrPage);
	}
	
	function refreshAllFrames() {
		searchCallBack();
		
		//Check preview
		if (crrPreMode != "off") {removePreviewDiv();}
	}
	
	function removePreviewDiv() {
		var divElmtId  = crrPreMode == "w" ? "previewHeaderW" : "previewHeaderH";
		var prevHElmt  = document.getElementById(divElmtId);
		var frameElmt  = prevHElmt.parentElement.querySelector("iframe[class='pr-frame']");
		var prevHeader = prevHElmt.querySelector(".prevHeaderWwrapper");

		// IE에서는 remove() 함수 지원하지 않으므로 부모에 접근하여 미리보기 헤더 제거
		if (prevHeader != null) {
			prevHeader.parentNode.removeChild(prevHeader);
		}
		
		var divElmt = document.createElement("div");
		divElmt.className = "nodataDiv";
		
		var dlElmt = document.createElement("dl");
		var dtElmt = document.createElement("dt");
		var imgElmt = document.createElement("img");
		imgElmt.src = "/images/kr/main/noData_sIcon.png";
		
		var ddElmt = document.createElement("dd");
		ddElmt.textContent = SurveyMessages.strSelect4;
		
		dtElmt.appendChild(imgElmt);
		dlElmt.appendChild(dtElmt);
		dlElmt.appendChild(ddElmt);
		divElmt.appendChild(dlElmt);
		prevHElmt.appendChild(divElmt);
		
		if (frameElmt) {frameElmt.src = "";}
	}
	/* Search Panel end*/
	
	/* Main search */
	function startSearchSurvey(pPage) {
		showProgressPanel();
		
		var orderInf  = surveyTable.getOrderInfo();
		var listCnt   = document.getElementById("listcount").value;
		var searchOpt = document.getElementById("searchCheck").value;
		var filterStatus = document.getElementById("filterStatus") ? document.getElementById("filterStatus").value : "";
		
		$.ajax({
			type: "GET",
			url: "/ezSurvey/getSurveyItems.do",
			data: {
				pageMode    : pageMode,
				currentPage : pPage,
				title       : titelStr,
				creatorName : creatorNameStr,
				startDate   : startDateStr,
				endDate     : endDateStr,
				column      : orderInf.col ? orderInf.col : "",
				order       : orderInf.ord ? orderInf.ord : "",
				srchMode    : searchMode,
				srchOption  : searchOpt,
				listCntSize : listCnt,
				filterStatus : filterStatus
			},
			dataType: "JSON",
			async: false,
			cache: false,
			success : function(data) {
				checkingData(data);
			},
			error : function(error) {
				alert(SurveyMessages.strError + error);
			}
		});
		
		completeProgress();
	}
	
	function showProgressPanel() {
		startTime        = new Date();
		var currenWidth  = document.body.clientWidth;
		var progressImg  = document.getElementById("processImage");
		document.getElementById("progressPanel").className = "loadingPanel on";
		progressImg.style.top  = "400px";
		progressImg.style.left = (currenWidth / 2) - 100 + "px";
		progressImg.className  = "loadingProgress on";
	}
	
	function completeProgress() {
		var endTime  = new Date();
		var timeDiff = (endTime - startTime)/1000;
		var seconds  = (timeDiff % 60).toFixed(1);
		
		if (seconds <= 0.3) {
			seconds = 300 - (timeDiff * 1000);
			setTimeout(function() {hiddenProgressPanel();}, seconds);
		}
		else {
			hiddenProgressPanel();
		}
	}
	
	function hiddenProgressPanel() {
		document.getElementById("progressPanel").className = "loadingPanel";
		document.getElementById("processImage").className  = "loadingProgress";
	}
	
	function checkingData(data) {
		var code = data.code;
		switch(code) {
			case 0 : processData(data)                ; break;
			case 1 : alert(SurveyMessages.strParamErr); break;
			case 2 : alert(SurveyMessages.strError)   ; break;
			default: alert(SurveyMessages.strError)   ; return;
		}
	}
	
	function processData(data) {
		surveyTable.setDataSource(data.itemList);
		surveyTable.renderTable();
		surveyNavi.init(data.currentPage, data.totalRows, data.totalPages);
	}
	
	function renderTable(itemList, unselectClass, tableDataElmt, getCheckedFunct, clickRowFunct) {
		if (itemList == null || itemList.length == 0) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			tdElmt.setAttribute("colspan", "6");
			tdElmt.setAttribute("align", "center");
			tdElmt.setAttribute("bgcolor", "#FFFFFF");
			tdElmt.innerHTML = SurveyMessages.strNoData;
			
			trElmt.appendChild(tdElmt);
			tableDataElmt.appendChild(trElmt);
		}
		else {
			var len = itemList.length;
			for (var i = 0; i < len; i++) {
				var trElmt     = document.createElement("tr");
				var tdElmt1    = document.createElement("td");
				var tdElmt2    = document.createElement("td");
				var tdSurveyId = document.createElement("td");
				var tdElmt3    = document.createElement("td");
				var tdPeriod    = document.createElement("td");
				var tdElmt4    = document.createElement("td");
				var tdElmt5    = document.createElement("td");
				var tdElmt6    = document.createElement("td");
				var tdElmt7    = document.createElement("td");
				var tdElmt8    = document.createElement("td");
				var tdElmt9    = document.createElement("td");
				var tdElmt10   = document.createElement("td");
				// 참여자수
				var tdParticipants   = document.createElement("td");
				// 참여여부
				var tdParticipation   = document.createElement("td");
//				var tdElmt11   = document.createElement("td");
				var endDate = new Date(itemList[i]["endDate"].replace(' ', 'T').replace('.0',''));
				var endDateStr = itemList[i]["endDate"].substring(0, 10);
				var today      = new Date();
				var todayStr   = getStringFormatForDate(today);
				var statusStr  = "";
				
				trElmt.setAttribute("class"     , unselectClass);
				trElmt.setAttribute("role"      , itemList[i]["surveyId"]);
				trElmt.setAttribute("userName"  , itemList[i]["creatorName"]);
				trElmt.setAttribute("userId"    , itemList[i]["creatorId"]);
				trElmt.setAttribute("createDate", itemList[i]["createDate"].substring(0, 16)); /* 초단위표기 삭제, 16 > 19로 변경하면 초단위 복구*/
				trElmt.setAttribute("surveyTtl" , itemList[i]["title"]);
				trElmt.onclick    = function(event) {clickRowFunct(event);};
				trElmt.ondblclick = function(event) {itemDblClickHandler(this);};
				
                var divElmt = document.createElement("div");
                divElmt.className = "custom_checkbox";
                
				var inputElmt  = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				inputElmt.onclick = function(event) {getCheckedFunct(event);};
				divElmt.appendChild(inputElmt);
				tdElmt1.appendChild(divElmt);
				
				if (itemList[i]["attachFlag"] == 1) {
					var imgAttch  = document.createElement("img");
					imgAttch.src  = "/images/newAttach.gif";
					tdElmt2.appendChild(imgAttch);
				}

				tdSurveyId.textContent = itemList[i]["surveyId"];
				tdPeriod.textContent = itemList[i]["startDate"].substring(0, 10) + " ~ " + endDateStr;
				
				tdElmt3.textContent  = itemList[i]["title"];
				tdElmt4.textContent  = itemList[i]["creatorName"];
				tdElmt5.textContent  = itemList[i]["createDate"].substring(0, 10);
				tdElmt6.textContent  = itemList[i]["paritipateFlag"] == 0   ? SurveyMessages.strUser2    : SurveyMessages.strUser8;
				if (itemList[i]["resultPublicFlag"] == 0) {
				    tdElmt7.textContent = SurveyMessages.strPublic2;
				} else if (itemList[i]["resultPublicFlag"] == 1) {
				    tdElmt7.textContent = SurveyMessages.strPublic1;
				} else if (itemList[i]["resultPublicFlag"] == 2) {
				    tdElmt7.textContent = SurveyMessages.strPublic3;
				}
				tdElmt8.textContent  = itemList[i]["anonymousFlag"]    == 0 ? SurveyMessages.strAnoynym1 : SurveyMessages.strAnoynym2;
				tdElmt9.textContent  = endDateStr;
				var participantsCnt = itemList[i]["participants"] || '0';
				tdParticipants.textContent  = participantsCnt + ' ' + SurveyMessages.strUser3;
				var participationCnt = itemList[i]["participation"] || 0;
				tdParticipation.textContent  = participationCnt > 0 ? SurveyMessages.strLangPGB01 : SurveyMessages.strLangPGB02;

				tdSurveyId.setAttribute("title", tdSurveyId.textContent);
				tdPeriod.setAttribute("title", tdPeriod.textContent);
				tdParticipants.setAttribute("title", tdParticipants.textContent);
				tdParticipation.setAttribute("title", tdParticipation.textContent);
				tdElmt3.setAttribute("title", tdElmt3.textContent);
				tdElmt4.setAttribute("title", tdElmt4.textContent);
				tdElmt5.setAttribute("title", tdElmt5.textContent);
				tdElmt9.setAttribute("title", tdElmt9.textContent);
				
				/* 2021-03-24 홍승비 - 원클릭 이벤트를 "제목" 칼럼에만 적용 */
				tdElmt3.onclick = function () {
					itemDblClickHandler2(event, this.parentElement);
				}
				
				//Check statistic button
				if (currentUser == itemList[i]["creatorId"]) {
					if (itemList[i]["responseFlag"] == 1) {
						var statImg     = document.createElement("img");
						statImg.src     = "/images/ezSurvey/survey_result.png";
						statImg.onclick = function(e) {openSurveyStatistic(e);}
//						tdElmt11.appendChild(statImg);
					}
				}
				else {
					//if current user is not creator, check the result public flag and response flag
					if (itemList[i]["resultPublicFlag"] == 1 && itemList[i]["responseFlag"] == 1) {
						//Check public date
						var openDays = parseInt(itemList[i]["openDays"]);
						today.setDate(today.getDate() - openDays);
						var dateStr  = getStringFormatForDate(today);
						
						if (todayStr >= endDateStr && dateStr <= endDateStr) {
							var statImg     = document.createElement("img");
							statImg.src     = "/images/ezSurvey/survey_result.png";
							statImg.onclick = function(e) {openSurveyStatistic(e);}
//							tdElmt11.appendChild(statImg);
						}
					}
				}
				
				if (itemList[i]["draftFlag"] == 1) {
					statusStr = SurveyMessages.strDraft;
				}
				else {
					if (pageMode == "processing") {
						statusStr = itemList[i]["useStatus"] == 2 ? SurveyMessages.strPause : SurveyMessages.strProcess;
					}
					else if (pageMode == "finish") {
						statusStr = SurveyMessages.strFinish;
					}
					else {
						//Check time
						var startDateStr = itemList[i]["startDate"].substring(0, 10);
						var startDate = new Date(itemList[i]["startDate"].replace(' ', 'T').replace('.0',''));
						
						if (today < startDate) {
							//not started yet (대기)
							statusStr = SurveyMessages.strWaiting;
						}
						else {
							if (today <= endDate) {
								statusStr = itemList[i]["useStatus"] == 2 ? SurveyMessages.strPause : SurveyMessages.strProcess;
							}
							else {
								statusStr = SurveyMessages.strFinish;
							}
						}
					}
				}
				
				tdElmt10.textContent = statusStr;
				tdElmt1.className    = "inputTh";
				tdElmt2.className    = "inputTh";
				tdSurveyId.className    = "numTh";
				tdElmt3.className    = "ttlTh";
				tdPeriod.className 	= "createTh";
				tdElmt4.className    = "createTh";
				tdElmt5.className    = "endDateTh";
				tdElmt6.className    = "targetTh";
				tdElmt7.className    = "publicTh";
				tdElmt8.className    = "anoynmTh";
				tdElmt9.className    = "endDateTh";
				tdParticipants.className   = "statusTh";
				tdParticipation.className   = "statusTh";
				tdElmt10.className   = "statusTh";
//				tdElmt11.className   = "statisTh";
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdSurveyId);
				trElmt.appendChild(tdElmt3);
				// trElmt.appendChild(tdElmt4);
				// trElmt.appendChild(tdElmt5);
				// trElmt.appendChild(tdElmt9);
				trElmt.appendChild(tdPeriod);
				// trElmt.appendChild(tdElmt6);
				// trElmt.appendChild(tdElmt7);
				trElmt.appendChild(tdElmt8);
				trElmt.appendChild(tdParticipants);
				trElmt.appendChild(tdParticipation);
				trElmt.appendChild(tdElmt10);
//				trElmt.appendChild(tdElmt11);
				
				tableDataElmt.appendChild(trElmt);
			}
		}
	}
	
	function getStringFormatForDate(dateObj) {
		var year  = dateObj.getFullYear();
		var month = dateObj.getMonth() + 1;
		var day   = dateObj.getDate();
		
		if (day < 10) {day = "0" + day;}
		if (month < 10) {month = "0" + month;}
		
		return year + "-" + month + "-" + day;
	}
	
	function openSurveyStatistic(event) {
		event.stopPropagation();
		var trElmt   = event.currentTarget.parentElement.parentElement;
		var surveyId = trElmt.getAttribute("role");
		if(statisticWd) {statisticWd.close();}
		statisticWd  = window.open("/ezSurvey/showStatisticInfo.do?surveyId=" + surveyId, "statisticInfo", getOpenWindowfeature(780, 750));
	}
	
	function onMainSearch() {
		var title      = document.getElementById("sSurveyTtl").value;
		var userName   = document.getElementById("sCreatedUser").value;
		var sDate      = document.getElementById("Sdatepicker").value;
		var eDate      = document.getElementById("Edatepicker").value;
		
		if (!title && !userName && !sDate && !eDate) {alert(SurveyMessages.strSearch); return;}
		if ((!sDate && eDate)) {alert(SurveyMessages.strDate3); return;}
		if ((sDate && !eDate)) {alert(SurveyMessages.strDate2); return;}
		if (sDate && eDate)    {if (sDate > eDate) {alert(SurveyMessages.strDate1); return;}}
		
		titelStr       = title;
		creatorNameStr = userName;
		startDateStr   = sDate;
		endDateStr     = eDate;
		
		searchMode = "2";
		toggleSearchPanel();
		startSearchSurvey("1");
	}
	/* Main search end*/
	
	/* Simple Search Part */
	function onStartSimpleSearch(event) {if(event.keyCode == "13") {startSimpleSearch();}}
	
	function startSimpleSearch() {
		var searchStr = document.getElementById("ssInput").value;
		
		if (!searchStr.replace(/\s/g,'')) {alert(SurveyMessages.strNoInput); return;}
		
		searchMode    = "1";
		var searchOpt = document.getElementById("searchCheck").value;
		if (searchOpt == "title") {titelStr = searchStr;} else {creatorNameStr = searchStr;}
		
		startSearchSurvey("1");
	}
	
	function clearKeyword(inputElmt) {inputElmt.value = "";}
	/* Simple Search Part end*/
	
	/* Option View */
	function toggleOptionView(optElmt) {if (optElmt.getAttribute("role") == "off") {showViewPopUp();} else {closeViewPopUp();}}
	
	function showViewPopUp() {
		var optElmt             = document.getElementById("sltView");
		var viewPopup           = document.getElementById("layer_Viewpopup");
		viewPopup.style.left    = document.documentElement.clientWidth - 160 + "px";
		viewPopup.style.top     = "82px";
		viewPopup.style.display = "";
		optElmt.setAttribute("class", "icon16 btn_onarrow_down");
		optElmt.setAttribute("role", "on");
	}
	
	function closeViewPopUp() {
		var optElmt = document.getElementById("sltView");
		document.getElementById("layer_Viewpopup").style.display = "none";
		optElmt.setAttribute("role", "off");
		optElmt.setAttribute("class", "icon16 btn_arrow_down");
	}
	
	function closeViewPopupOutside(e) {
		var viewPopup = document.getElementById("layer_Viewpopup");
		var optElmt   = document.getElementById("sltView");
		var role      = optElmt.getAttribute("role");
		
		if(role == "on") {
			if(!viewPopup.contains(e.target) && e.target != optElmt) {
				closeViewPopUp();
			}
		}
	}
	
	/* Option View end */
	function deleteFileConfirm() {
		var itemArr = getSelectedItems();
		if (itemArr.length == 0) {alert(SurveyMessages.strItemErr); return;}
		
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
		refreshAllFrames();
	}
	
	function afterCheckReusePermission(data, itemId) {
		var code = data.code;
		switch(code) {
			case 0 : window.parent.frames["right"].location.href = "/ezSurvey/reuseItem.do?itemId=" + itemId; break;
			case 1 : alert(SurveyMessages.strParamErr); break;
			case 2 : alert(SurveyMessages.strError)   ; break;
			case 3 : alert(SurveyMessages.strPerm)    ; break;
			default: alert(SurveyMessages.strError)   ; return;
		}
	}
	
	function reuseSurveyConfirm() {
		var itemArr = getSelectedItems();
		if (itemArr.length == 0) {alert(SurveyMessages.strItemErr) ; return;}
		if (itemArr.length > 1)  {alert(SurveyMessages.strItemErr1); return;}
		
		makeAjaxCall({}, "POST", "/ezSurvey/checkReusePermission.do", afterCheckReusePermission, null, true, itemArr[0]);
	}
	
	function analysisSurveyConfirm() {
		var itemArr = getSelectedItems();
		if (itemArr.length == 0) {alert(SurveyMessages.strItemErr) ; return;}
		if (itemArr.length > 1)  {alert(SurveyMessages.strItemErr1); return;}

		var url  = "/ezSurvey/checkAnalysisPermission.do";
		var data = {surveyId : itemArr[0]};
		makeAjaxCall(data, "GET", url, afterCheckAnalysisItem, null, true, itemArr[0]);
	}
	
	function afterCheckAnalysisItem(data, itemId) {
		var code = data.code;
		switch(code) {
			case 1 : alert(SurveyMessages.strParamErr) ; break;
			case 2 : alert(SurveyMessages.strError)    ; break;
			case 3 : alert(SurveyMessages.strPerm)     ; break;
			case 4 : alert(SurveyMessages.strPrivate)  ; break;
			case 5 : alert(SurveyMessages.strNpbPeriod); break;
			case 0 : analysisPopup(itemId);
		}
	}

	function analysisPopup(itemId) {
		if(statisticWd) {statisticWd.close();}
		statisticWd  = window.open("/ezSurvey/showStatisticInfo.do?surveyId=" + itemId, "statisticInfo", getOpenWindowfeature(780, 750));		
	}
	
	function modifySurveyConfirm() {
		var itemArr = getSelectedItems();
		if (itemArr.length == 0) {alert(SurveyMessages.strItemErr) ; return;}
		if (itemArr.length > 1)  {alert(SurveyMessages.strItemErr1); return;}
		
		var url  = "/ezSurvey/checkProcessingSurvey.do";
		var data = {surveyId : itemArr[0]};
		
		makeAjaxCall(data, "GET", url, afterCheckItem, null, true, itemArr[0]);
	}
	
	function afterCheckItem(data, itemId) {
		var code = data.code;
		switch(code) {
			case 0 : modifySurveyItem(itemId)          ; break;
			case 1 : alert(SurveyMessages.strParamErr) ; break;
			case 2 : alert(SurveyMessages.strError)    ; break;
			case 3 : alert(SurveyMessages.strPerm)     ; break;
			case 4 : alert(SurveyMessages.strModifying); break;
			default: alert(SurveyMessages.strError)    ; return;
		}
	}
	
	function modifySurveyItem(itemId) {
		window.parent.frames["right"].location.href = "/ezSurvey/modifyItem.do?itemId=" + itemId;
	}
	
	function getSelectedItems() {
		var result        = [];
		var itemListElmt  = document.getElementById("surveyList");
		var selectedItems = itemListElmt.querySelectorAll("tr[class='bnkSurveySl']");
		
		for (var i = 0, len = selectedItems.length; i< len; i++) {
			result.push(selectedItems[i].getAttribute("role"));
		}
		
		return result;
	}
	
	function itemClickHandler(trObj) {
		if (pageMode == "draft") {return;}
		var itemId   = trObj.getAttribute("role");
		var crrClass = trObj.className;
		
		if (crrClass == "bnkSurveySl") {
			if (crrPreMode == "off") {return;}
			
			//Show survey information
			showPreviewInfo(trObj);
		}
	}
	
	function itemDblClickHandler(trObj) {
		if (pageMode != "draft") {
			openSurveyDetail(trObj.getAttribute("role"));
		}
		else {
			modifySurveyItem(trObj.getAttribute("role"));
		}
	}
	
	/* 2021-01-20 홍승비 - 원클릭 이벤트에 더블클릭 함수 추가 (미리보기 영역이 열려있지 않은 경우에만) */
	function itemDblClickHandler2(event, trObj) {
		if (document.getElementById("previewH").style.display == "none" && document.getElementById("previewW").style.display == "none") {
			if (!event.ctrlKey && !event.shiftKey) {
				if (pageMode != "draft") {
					openSurveyDetail(trObj.getAttribute("role"));
				}
				else {
					modifySurveyItem(trObj.getAttribute("role"));
				}
			}
		}
	}
	
	function openSurveyDetail(itemId) {
		if(itemPopup) {itemPopup.close();}
		itemPopup = window.open("/ezSurvey/surveyDetail.do?itemId=" + itemId, "fileDetail", getOpenWindowfeature(780, 750));
	}
	
	function generatePreviewElmt(divElmt) {
		var parentDiv  = divElmt.parentElement;
		var divChild   = document.createElement("div");
		var pElmt      = document.createElement("p");
		var spanElmt   = document.createElement("span");
		var dlElmt     = document.createElement("dl");
		var pSpanElmt1 = document.createElement("span");
		var pSpanElmt2 = document.createElement("span");
		
		divChild.className   = "prevHeaderWwrapper";
		pElmt.className      = "prevTitle";
		spanElmt.className   = "preDate";
		dlElmt.className     = "prevItem";
		pSpanElmt1.className = "prevIcon";
		pSpanElmt2.className = "titleTxt";
		
		pElmt.appendChild(pSpanElmt1);
		pElmt.appendChild(pSpanElmt2);
		pElmt.appendChild(spanElmt);
		divChild.appendChild(pElmt);
		divChild.appendChild(dlElmt);
		divElmt.appendChild(divChild);
	}
	
	function showPreviewInfo(trObj) {
		var createDate  = trObj.getAttribute("createDate");
		var surveyTtl   = trObj.getAttribute("surveyTtl");
		var surveyId    = trObj.getAttribute("role");
		var creatorName = trObj.getAttribute("userName");
		var creatorId   = trObj.getAttribute("userId");
		
		var divPrevId   = crrPreMode == "w" ? "previewHeaderW" : "previewHeaderH";
		var divElmt     = document.getElementById(divPrevId);
//		var noDataSpan  = divElmt.querySelector("span[class='notSelected']");
		var noDataSpan  = divElmt.querySelector("div[class='nodataDiv']");
		
		if (noDataSpan) {divElmt.removeChild(noDataSpan); generatePreviewElmt(divElmt);}
		
		var spanIcon    = divElmt.querySelector("span[class='prevIcon']");
		var spanSubject = divElmt.querySelector("span[class='titleTxt']");
		var spanDate    = divElmt.querySelector("span[class='preDate']");
		var dlElmt      = divElmt.querySelector("dl[class='prevItem']");
		
		spanIcon.onclick        = function(e) {openSurveyDetail(surveyId);};
		spanSubject.textContent = surveyTtl;
		spanDate.textContent    = createDate;
		spanSubject.setAttribute("title", surveyTtl);
		
		while(dlElmt.firstElementChild) {dlElmt.removeChild(dlElmt.firstElementChild);}
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		var iframeId     = crrPreMode == "w" ? "mainContentIframeW" : "mainContentIframeH";
		var ifameContent = document.getElementById(iframeId);
		
		ifameContent.src = "/ezSurvey/surveyDetail.do?mode=view&itemId=" + surveyId;
		
		ifameContent.addEventListener("load", function(e) {
			var ifameContentWd = ifameContent.contentWindow || ifameContent.contentDocument;
			ifameContentWd.addEventListener("mouseup", function(e) {closeViewPopupOutside(e);}, false);
		}, false);
	}
	
	function generateCreatorTitle(dlElmt, creatorName, creatorId) {
		var dtElmt           = document.createElement("dt");
		var ddElmt           = document.createElement("dd");
		var spanElmt         = document.createElement("span");
		dtElmt.innerHTML     = SurveyMessages.strCreator + ": ";
		spanElmt.className   = "txtSpan";
		spanElmt.textContent = creatorName;
		spanElmt.addEventListener("click", function(e) {showUserInfoFromId(creatorId);}, false);
		ddElmt.appendChild(spanElmt);
		dlElmt.appendChild(dtElmt);
		dlElmt.appendChild(ddElmt);
	}
	
	function showUserInfoFromId(userId) {
		var feature = "height=450px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
		feature = feature + getOpenWindowfeature(420, 450);
		userWindow = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
	}
	
	function closeAllPopups() {
		if(itemPopup)   {itemPopup.close();}
		if(userWindow)  {userWindow.close();}
		if(statisticWd) {statisticWd.close();}
	}
	
	function getIframeContent() {return documentCont;}
	
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
    
    function moreBtnResize() {
       var srchBttn2        = document.querySelector(".layer_select .searchBttn2");
       var delBttn2         = document.querySelector(".layer_select .deleteBttn2");
       var analysisBttn2    = document.querySelector(".layer_select .analysisBttn2");
	   var usersBttn2		= document.querySelector(".layer_select .usersBttn2");
       if (srchBttn2)       {srchBttn2.firstElementChild.onclick        = function(e) {toggleSearchPanel()     ;};}
       if (delBttn2)        {delBttn2.firstElementChild.onclick         = function(e) {deleteFileConfirm()     ;};}
       if (analysisBttn2)   {analysisBttn2.firstElementChild.onclick    = function(e) {analysisSurveyConfirm() ;};}
	   if (usersBttn2) 		{usersBttn2.firstElementChild.onclick 		= function(e) {showParticipants() ;};}
    }
	
	return {
		start      : initEvents,
		reload     : refreshAllFrames,
		getContent : getIframeContent,
		btnResize : moreBtnResize
	};
	
	/* 2025-07-08 양지혜 - 전자설문 > 참여자보기 호출 */
	function showParticipants() {
		var itemArr = getSelectedItems();
		if (itemArr.length == 0) {alert(SurveyMessages.strItemErr) ; return;}
		if (itemArr.length > 1)  {alert(SurveyMessages.strItemErr1); return;}
		
		if(statisticWd) {statisticWd.close();}
		statisticWd  = window.open("/ezSurvey/showParticipantsList.do?surveyId=" + encodeURIComponent(itemArr[0]), "ParticipantsList", getOpenWindowfeature(780, 750));
	}
}();
