var SurveyItem = function() {
	var surveyPreview  = null;
	var crrPreMode     = null;
	var surveyNavi     = null;
	var surveyTable    = null;
	var pageMode       = null;
	var startTime      = null;
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
		
		switch(prevMode) {
			case "w"   : surveyPreview.resizeByWidth()      ; break;
			case "h"   : surveyPreview.resizeByHeight()     ; break;
			case "off" : surveyPreview.resizeDestroy("init"); break;
		}
		
		crrPreMode = prevMode;
	}
	
	function changePreview(mode) {
		if (mode == crrPreMode) {return;}
		var slTrElmt = surveyTable.getSelectedRow();
		crrPreMode   = mode;
		
		switch(mode) {
			case "off":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_onnoframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_bottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_leftframe.gif";
				surveyPreview.resizeDestroy();
				break;
			case "w":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_noframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_bottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_onleftframe.gif";
				surveyPreview.resizeByWidth();
				if (slTrElmt) {itemClickHandler(slTrElmt);}
				break;
			case "h":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_noframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_onbottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_leftframe.gif";
				surveyPreview.resizeByHeight();
				if (slTrElmt) {itemClickHandler(slTrElmt);}
				break;
			default:
				return;
		}
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
		var divList  = document.getElementById("wraperDiv");
		var divChild = divList.querySelector("div[class='tableDataDiv']");
		var reheight = 0;
		
		if (crrPreMode == "h") {
			reheight              = divChild.parentElement.parentElement.clientHeight - 80;
			divChild.style.height = reheight + "px";
		}
		else {
			reheight              = document.documentElement.clientHeight - 120;
			divList.style.height  = reheight + "px";
			divChild.style.height = reheight - 70 + "px";
		}
	}
	
	function initEvents(height, width, prevMode, mode) {
		setData(height, width, prevMode);
		pageMode = mode;
		
		//Initial page navigation
		var naviMessages = {
			next     : SurveyMessages.strNext,
			previous : SurveyMessages.strPrev,
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
		surveyTable.setRenderFunct(renderCabinetTable);
		
		window.addEventListener("resize", function(e) {windowResize();}, false);
		window.addEventListener("keydown", function(e) {keyPress(e);}, false);
		window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
		
		document.onselectstart = function() {return false;};
		var sSearchInputElmt   = document.getElementById("ssInput");
		sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
		sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
		
		var searchBttnElmt = document.getElementById("searchBttnSp");
		searchBttnElmt.addEventListener("click", function(e) {startSimpleSearch();}, false);
		
		document.getElementById("preViewNone").addEventListener("click"  , function(e) {changePreview("off")  ;}, false);
		document.getElementById("preViewBottom").addEventListener("click", function(e) {changePreview("h")    ;}, false);
		document.getElementById("preViewleft").addEventListener("click"  , function(e) {changePreview("w")    ;}, false);
		document.getElementById("sltView").addEventListener("click"      , function(e) {toggleOptionView(this);}, false);
		document.getElementById("listcount").addEventListener("change"   , function(e) {startSearchSurvey("1");}, false);
		
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
		
		var addBttn   = document.getElementById("createBttn");
		var delBttn   = document.getElementById("deleteBttn");
		var reuseBttn = document.getElementById("reuseBttn");
		var srchBttn  = document.getElementById("searchBttn");
		var modifyBttn  = document.getElementById("modifyBttn");
		if (addBttn)    {addBttn.firstElementChild.onclick       = function(e) {createNewSurvey()    ;};}
		if (delBttn)    {delBttn.firstElementChild.onclick       = function(e) {deleteFileConfirm()  ;};}
		if (reuseBttn)  {reuseBttn.firstElementChild.onclick     = function(e) {reuseSurveyConfirm() ;};}
		if (srchBttn)   {srchBttn.firstElementChild.onclick      = function(e) {toggleSearchPanel()  ;};}
		if (modifyBttn) {modifyBttn.firstElementChild.onclick    = function(e) {modifySurveyConfirm();};}
		
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
		var parentElmt = prevHElmt.parentElement;
		while (parentElmt.childElementCount > 1) {
			parentElmt.removeChild(parentElmt.lastElementChild);
		}
		
		prevHElmt.innerHTML = "<span class='notSelected'>" + SurveyMessages.strSelect4 + "</span>";
	}
	/* Search Panel end*/
	
	/* Main search */
	function startSearchSurvey(pPage) {
		showProgressPanel();
		
		var orderInf  = surveyTable.getOrderInfo();
		var listCnt   = document.getElementById("listcount").value;
		var searchOpt = document.getElementById("searchCheck").value;
		
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
				listCntSize : listCnt
			},
			dataType: "JSON",
			async: false,
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
	
	function renderCabinetTable(itemList, unselectClass, tableDataElmt, getCheckedFunct, clickRowFunct) {
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
				var trElmt   = document.createElement("tr");
				var tdElmt1  = document.createElement("td");
				var tdElmt2  = document.createElement("td");
				var tdElmt3  = document.createElement("td");
				var tdElmt4  = document.createElement("td");
				var tdElmt5  = document.createElement("td");
				var tdElmt6  = document.createElement("td");
				var tdElmt7  = document.createElement("td");
				var tdElmt8  = document.createElement("td");
				var tdElmt9  = document.createElement("td");
				var tdElmt10 = document.createElement("td");
				
				trElmt.setAttribute("class", unselectClass);
				trElmt.setAttribute("role",  itemList[i]["surveyId"]);
				trElmt.onclick    = function(event) {clickRowFunct(event);};
				trElmt.ondblclick = function(event) {itemDblClickHandler(this);};
				
				var inputElmt  = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				inputElmt.onclick = function(event) {getCheckedFunct(event);};
				tdElmt1.appendChild(inputElmt);
				
				if (itemList[i]["attachFlag"] == 1) {
					var imgAttch  = document.createElement("img");
					imgAttch.src  = "/images/newAttach.gif";
					tdElmt2.appendChild(imgAttch);
				}
				
				if (itemList[i]["useStatus"] == 1) {
					var imgStatus  = document.createElement("img");
					imgStatus.src  = "/images/ImgIcon/view-importance.gif";
					tdElmt3.appendChild(imgStatus);
				}
				else if (itemList[i]["useStatus"] == 2) {
					var imgStatistic  = document.createElement("img");
					imgStatistic.src  = "/images/ezSurvey/statistic.png";
					tdElmt10.appendChild(imgStatistic);
				}
				
				tdElmt4.textContent  = itemList[i]["title"];
				tdElmt5.textContent  = itemList[i]["endDate"].substring(0, 19);
				tdElmt6.textContent  = itemList[i]["paritipateFlag"] == 0   ? SurveyMessages.strUser7    : SurveyMessages.strUser8;
				tdElmt7.textContent  = itemList[i]["creatorName"];
				tdElmt8.textContent  = itemList[i]["resultPublicFlag"] == 1 ? SurveyMessages.strPublic1  : SurveyMessages.strPublic2;
				tdElmt9.textContent  = itemList[i]["anonymousFlag"]    == 1 ? SurveyMessages.strAnoynym1 : SurveyMessages.strAnoynym2;
				tdElmt4.setAttribute("title", tdElmt4.textContent);
				tdElmt7.setAttribute("title", tdElmt7.textContent);
				
				tdElmt1.className  = "inputTh";
				tdElmt2.className  = "inputTh";
				tdElmt3.className  = "inputTh";
				tdElmt4.className  = "ttlTh";
				tdElmt5.className  = "endDateTh";
				tdElmt6.className  = "targetTh";
				tdElmt7.className  = "createTh";
				tdElmt8.className  = "publicTh";
				tdElmt9.className  = "anoynmTh";
				tdElmt10.className = "statisTh";
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt3);
				trElmt.appendChild(tdElmt4);
				trElmt.appendChild(tdElmt5);
				trElmt.appendChild(tdElmt6);
				trElmt.appendChild(tdElmt7);
				trElmt.appendChild(tdElmt8);
				trElmt.appendChild(tdElmt9);
				trElmt.appendChild(tdElmt10);
				tableDataElmt.appendChild(trElmt);
			}
		}
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
		var viewPopup           = document.getElementById("layerPopup");
		viewPopup.style.left    = document.documentElement.clientWidth - 160 + "px";
		viewPopup.style.top     = "100px";
		viewPopup.style.display = "";
		optElmt.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
		optElmt.setAttribute("role", "on");
	}
	
	function closeViewPopUp() {
		var optElmt = document.getElementById("sltView");
		document.getElementById("layerPopup").style.display = "none";
		optElmt.setAttribute("role", "off");
		optElmt.setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
	}
	
	function closeViewPopupOutside(e) {
		var viewPopup = document.getElementById("layerPopup");
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
	
	function reuseSurveyConfirm() {
		var itemArr = getSelectedItems();
		if (itemArr.length == 0) {alert(SurveyMessages.strItemErr) ; return;}
		if (itemArr.length > 1)  {alert(SurveyMessages.strItemErr1); return;}
		window.parent.frames["right"].location.href = "/ezSurvey/reuseItem.do?itemId=" + itemArr[0];
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
			case 0 : afterCheckSuccessfully(itemId)    ; break;
			case 1 : alert(SurveyMessages.strParamErr) ; break;
			case 2 : alert(SurveyMessages.strError)    ; break;
			case 3 : alert(SurveyMessages.strPerm)     ; break;
			case 4 : alert(SurveyMessages.strModifying); break;
			default: alert(SurveyMessages.strError)    ; return;
		}
	}
	
	function afterCheckSuccessfully(itemId) {
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
		var itemId   = trObj.getAttribute("role");
		var crrClass = trObj.className;
		
		if (crrClass == "bnkSurveySl") {
			if (crrPreMode == "off") {return;}
			
			var url  = "/ezCabinet/getFileDetail.do";
			var data = {itemId : itemId};
			makeAjaxCall(data, "GET", url, afterGetItemInfo, null, true, null);
		}
	}
	
	function itemDblClickHandler(trObj) {
		var itemId   = trObj.getAttribute("role");
		openSurveyDetail(itemId);
	}
	
	function openSurveyDetail(itemId) {
		if(itemPopup) {itemPopup.close();}
		itemPopup = window.open("/ezCabinet/surveyDetail.do?itemId=" + itemId, "fileDetail", getOpenWindowfeature(780, 750));
	}
	
	function generatePreviewElmt(divElmt) {
		var parentDiv  = divElmt.parentElement;
		var divChild   = document.createElement("div");
		var pElmt      = document.createElement("p");
		var spanElmt   = document.createElement("span");
		var dlElmt     = document.createElement("dl");
		var pSpanElmt1 = document.createElement("span");
		var pSpanElmt2 = document.createElement("span");
		
		pElmt.className      = "cabPrevTitle";
		spanElmt.className   = "cabPreDate";
		dlElmt.className     = "cabPrevItem";
		pSpanElmt1.className = "cabPrevIcon";
		pSpanElmt2.className = "cabTitleTxt";
		
		pElmt.appendChild(pSpanElmt1);
		pElmt.appendChild(pSpanElmt2);
		pElmt.appendChild(spanElmt);
		divChild.appendChild(pElmt);
		divChild.appendChild(dlElmt);
		divElmt.appendChild(divChild);
	}
	
	function afterGetItemInfo(data) {
		var itemInfo    = data.fileDetail;
		var itemType    = itemInfo["itemType"];
		var divPrevId   = crrPreMode == "w" ? "previewHeaderW" : "previewHeaderH";
		var divElmt     = document.getElementById(divPrevId);
		var noDataSpan  = divElmt.querySelector("span[class='notSelected']");
		
		if (noDataSpan) {divElmt.removeChild(noDataSpan); generatePreviewElmt(divElmt);}
		
		var spanIcon    = divElmt.querySelector("span[class='cabPrevIcon']");
		var spanSubject = divElmt.querySelector("span[class='cabTitleTxt']");
		var spanDate    = divElmt.querySelector("span[class='cabPreDate']");
		var dlElmt      = divElmt.querySelector("dl[class='cabPrevItem']");
		var parentDiv   = divElmt.parentElement;
		
		spanIcon.onclick        = function(e) {openSurveyDetail(itemInfo["itemId"]);};
		spanSubject.textContent = itemInfo["title"];
		spanDate.textContent    = itemInfo["createdDate"].substring(0, 19);
		spanSubject.setAttribute("title", itemInfo["title"]);
		
		while(dlElmt.firstElementChild) {dlElmt.removeChild(dlElmt.firstElementChild);}
		
		if (itemType != 0) {
			var iframeId    = crrPreMode == "w" ? "mainContentIframeW" : "mainContentIframeH";
			var prevId      = crrPreMode == "w" ? "itemContentW" : "itemContentH";
			var prevCont    = document.getElementById(prevId);
			if (prevCont) {parentDiv.removeChild(prevCont);}
			
			var ifameContent = document.getElementById(iframeId);
			
			if (!ifameContent) {
				ifameContent           = document.createElement("iframe");
				ifameContent.id        = iframeId;
				ifameContent.className = "cabrlframe";
				var fileDivId          = crrPreMode == "w" ? "itemContentW" : "itemContentH";
				var fileDivElmt        = document.getElementById(fileDivId);
				
				if (fileDivElmt) {
					parentDiv.replaceChild(ifameContent, fileDivElmt);
				}
				else {
					parentDiv.appendChild(ifameContent);
				}
			}
			
			switch(itemType) {
				case 1 : showMailPreview(data, dlElmt)     ; break;
				case 2 : showApprovalPreview(data, dlElmt) ; break;
				case 3 : showBoardPreview(data, dlElmt)    ; break;
				case 4 : showSchedulePreview(data, dlElmt) ; break;
				case 5 : showTodoPreview(data, dlElmt)     ; break;
				case 6 : showOptionPreview(data, dlElmt)   ; break;
				case 7 : showCommunityPreview(data, dlElmt); break;
				case 8 : showAddressPreview(data, dlElmt)  ; break;
				case 9 : showJournalPreview(data, dlElmt)  ; break;
				case 10: showProjectPreview(data, dlElmt)  ; break;
				case 11: showResourcePreview(data, dlElmt) ; break;
			}
			
			ifameContent.addEventListener("load", function(e) {
				var ifameContentWd = ifameContent.contentWindow || ifameContent.contentDocument;
				ifameContentWd.addEventListener("mouseup", function(e) {closeViewPopupOutside(e);}, false);
			}, false); 
		}
		else {
			showGeneralItemPreview(data, dlElmt, itemInfo, parentDiv);
		}
	}
	
	function showGeneralItemPreview(data, dlElmt, itemInfo, parentDiv) {
		var prevId       = crrPreMode == "w" ? "itemContentW" : "itemContentH";
		var prevCont     = document.getElementById(prevId);
		var iframeId     = crrPreMode == "w" ? "mainContentIframeW" : "mainContentIframeH";
		var ifameContent = document.getElementById(iframeId);
		
		if (ifameContent) {parentDiv.removeChild(ifameContent);}
		
		if (!prevCont) {
			prevCont           = document.createElement("div");
			prevCont.id        = prevId;
			prevCont.className = prevId;
			parentDiv.appendChild(prevCont);
		}
		
		var attachList  = data.attachFileList;
		generateCreatorTitle(dlElmt, itemInfo["creatorName"], itemInfo["creatorId"]);
		generalItemContent(attachList, itemInfo["itemSize"]);
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
	
	function generalItemContent(attachList, itemSize) {
		var fileDivId      = crrPreMode == "w" ? "itemContentW" : "itemContentH";
		var fileDivElmt    = document.getElementById(fileDivId);
		
		while (fileDivElmt.firstElementChild) {fileDivElmt.removeChild(fileDivElmt.firstElementChild);}
		
		var fileWrap       = document.createElement("div");
		fileWrap.className = "cabWrapFile";
		var fileList       = document.createElement("div");
		fileList.className = "fileDetailDiv";
		fileDivElmt.appendChild(fileWrap);
		fileWrap.appendChild(fileList);
		
		if(attachList == null || attachList.length == 0) {
			var divInform        = document.createElement("div");
			divInform.className  = "divInform";
			var spanElmt         = document.createElement("span");
			spanElmt.className   = "nofile";
			divInform.appendChild(spanElmt);
			fileList.appendChild(divInform);
		}
		else {
			var divfileListElmt       = document.createElement("div");
			divfileListElmt.className = "fileList";
			var ulElmt                = document.createElement("ul");
			ulElmt.className          = "ulFiles";
			fileList.appendChild(divfileListElmt);
			divfileListElmt.appendChild(ulElmt);
			
			for (var i = 0, len = attachList.length; i < len; i++) {
				var liElmt         = document.createElement("li");
				var divMainElmt    = document.createElement("div");
				var divChildElmt1  = document.createElement("div");
				var divChildElmt2  = document.createElement("div");
				var spanChild1     = document.createElement("span");
				var spanChild2     = document.createElement("span");
				var imgElmt        = document.createElement("img");
				var fileName       = attachList[i]["fileName"];
				var filePath       = attachList[i]["filePath"];
				var fileSize       = attachList[i]["fileSize"];
				var checkImageFile = isImage(fileName);
				imgElmt.src        = checkImageFile.isImage == true ? filePath : checkImageFile.urlImage;
				
				divChildElmt1.className = "cabImgAva";
				divChildElmt1.appendChild(imgElmt);
				
				spanChild1.textContent  = fileName;
				spanChild2.textContent  = fileSize;
				divChildElmt2.className = "cabFileInf";
				divChildElmt2.appendChild(spanChild1);
				divChildElmt2.appendChild(spanChild2);
				
				divMainElmt.className   = "cabDivFile";
				divMainElmt.appendChild(divChildElmt1);
				divMainElmt.appendChild(divChildElmt2);
				
				liElmt.onclick = (function(name, path) {return function() {downloadFileAttach(name, path);}; })(attachList[i]["fileName"], attachList[i]["filePath"]);
				liElmt.appendChild(divMainElmt);
				ulElmt.appendChild(liElmt);
			}	
		}
	}
	
	function downloadFileAttach(fileName, filePath) {
		var downloadUrl = "/ezCabinet/downloadAttachFile?filePath=" + encodeURIComponent(filePath) + "&fileName=" + encodeURIComponent(fileName);
		var attachFrame = document.getElementById("attachFrame");
		attachFrame.src = downloadUrl;
	}
	
	function showUserInfoFromId(userId) {
		var feature = "height=500px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
		feature = feature + getOpenWindowfeature(420, 500);
		userWindow = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
	}
	
	function closeAllPopups() {
		if(itemPopup)  {itemPopup.close();}
		if(userWindow) {userWindow.close();}
	}
	
	function createNewSurvey()   {window.parent.frames["right"].location.href = "/ezSurvey/createSurvey.do";}
	function getIframeContent()  {return documentCont;}
	
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
	
	return {
		start      : initEvents,
		reload     : refreshAllFrames,
		getContent : getIframeContent
	};
}();
