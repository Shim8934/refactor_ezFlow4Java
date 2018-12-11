var SurveyItem = function() {
	var surveyPreview  = null;
	var crrPreMode     = null;
	var surveyNavi     = null;
	var surveyTable    = null;
	var searchMode     = "0"; //0: normal, 1: simple, 2: detail
	var startDateStr   = "";
	var endDateStr     = "";
	var recursiveMode  = "";
	var titelStr       = "";
	var summaryStr     = "";
	var creatorNameStr = "";
	var minWPercent    = 40;
	var maxWPercent    = 75;
	var minHPercent    = 30;
	var maxHPercent    = 65;
	var sharePopup     = null;
	var addPopup       = null;
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
	
	function initEvents(height, width, prevMode) {
		setData(height, width, prevMode);
		
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
			headerId : "cabinetInfo",
			callback : startSearchCabinet
		});
		
		//Initial table
		surveyTable = new SurveyTable({normal : "bnkCabNormal", selected : "bnkCabSelect"});
		
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
		
		document.getElementById("preViewNone").addEventListener("click"  , function(e) {changePreview("off")   ;}, false);
		document.getElementById("preViewBottom").addEventListener("click", function(e) {changePreview("h")     ;}, false);
		document.getElementById("preViewleft").addEventListener("click"  , function(e) {changePreview("w")     ;}, false);
		document.getElementById("sltView").addEventListener("click"      , function(e) {toggleOptionView(this) ;}, false);
		document.getElementById("listcount").addEventListener("change"   , function(e) {startSearchCabinet("1");}, false);
		
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
		
		var addBttn  = document.getElementById("createBttn");
		var delBttn  = document.getElementById("deleteBttn");
		var ruseBttn = document.getElementById("reuseBttn");
		var srchBttn = document.getElementById("searchBttn");
		if (addBttn)  {addBttn.firstElementChild.onclick  = function(e) {createNewSurvey()  ;};}
		if (delBttn)  {delBttn.firstElementChild.onclick  = function(e) {deleteFileConfirm();};}
		if (ruseBttn) {ruseBttn.firstElementChild.onclick = function(e) {reuseSurvey()      ;};}
		if (srchBttn) {srchBttn.firstElementChild.onclick = function(e) {toggleSearchPanel();};}
		
		$("#Sdatepicker").datepicker(datepickerSt);
		$("#Edatepicker").datepicker(datepickerSt);
		
		//startSearchCabinet("1");
		preProcessing();
	}
	
	/* Search Panel */
	function toggleSearchPanel() {
		var rightFrame  = window.parent.frames["right"].document;
		var searchPanel = rightFrame.getElementById("searchPanel");
		if (searchPanel.className == "searchPanel off") {
			addFogPanel("search");
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
		rightFrame.getElementById("Sdatepicker").value = "";
		rightFrame.getElementById("Edatepicker").value = "";
		rightFrame.getElementById("dCheckBox").checked = false;
		rightFrame.getElementById("sUserName").value   = "";
		rightFrame.getElementById("sCabTitle").value   = "";
		rightFrame.getElementById("sCabSum").value     = "";
	}
	
	function addFogPanel(mode) {
		var handleClickFunct = null;
		
		switch(mode) {
			case "search": handleClickFunct = toggleSearchPanel; break;
			case "move"  : handleClickFunct = toggleMovePopup  ; break;
			default      : alert(SurveyMessages.strError)      ; return;
		}
		
		var fogPanel                 = document.createElement("div");
		fogPanel.className           = "rfogPanel";
		var leftFogPanel             = document.createElement("div");
		leftFogPanel.className       = "blockLeft";
		fogPanel.onclick             = function(e) {handleClickFunct();};
		leftFogPanel.onclick         = function(e) {handleClickFunct();};
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
		startSearchCabinet(crrPage);
	}
	
	function refreshAllFrames() {
		searchCallBack();
		var leftFrame = window.parent.frames["left"];
		if (leftFrame) {leftFrame.CabUserLeft.draw();}
		
		//Check preview
		if (crrPreMode != "off") {
			removePreviewDiv();
		}
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
	function startSearchCabinet(pPage) {
		ShowMailProgress();
		
		var orderInf  = surveyTable.getOrderInfo();
		var listCnt   = document.getElementById("listcount").value;
		var searchOpt = document.getElementById("searchCheck").value;
		
		$.ajax({
			type: "POST",
			url: "/ezCabinet/getCabinetItems.do",
			data: {
				"currentPage" : pPage,
				"title"       : titelStr,
				"summary"     : summaryStr,
				"recursive"   : recursiveMode,
				"creatorName" : creatorNameStr,
				"startDate"   : startDateStr,
				"endDate"     : endDateStr,
				"column"      : orderInf.col ? orderInf.col : "",
				"order"       : orderInf.ord ? orderInf.ord : "",
				"srchMode"    : searchMode,
				"srchOption"  : searchOpt,
				"listCntSize" : listCnt
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
		
		CompleteProgress();
	}
	
	//2018-09-27 문성업 - 프로그래스바		
	function ShowMailProgress() {
	    startTime = new Date();//프로그래스바 시작시간
		CurrenWidth = document.body.clientWidth;
	
	    document.getElementById("mailPanel").style.display = "";
	    document.getElementById("MailProgress").style.top = "400px";
	    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
	    document.getElementById("MailProgress").style.display = "";
	}
	
	function CompleteProgress() {
		//2018-09-27 문성업 - 프로그레스바
        endTime = new Date();//프로그래스바 종료시간
		var timeDiff = endTime - startTime;
		timeDiff /= 1000;
		var seconds = (timeDiff % 60).toFixed(1);
		
		if (seconds <= 0.3) { //0.3초보다 적으면
			seconds = 300 - (timeDiff * 1000);
			setTimeout(function() {
				HiddenMailProgress();
			}, seconds);
		} else {
	        HiddenMailProgress();
		}
	}
	
	function HiddenMailProgress() {
	    document.getElementById("mailPanel").style.display = "none";
	    document.getElementById("MailProgress").style.display = "none";
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
				/*var trElmt  = document.createElement("tr");
				var tdElmt1 = document.createElement("td");
				var tdElmt2 = document.createElement("td");
				var tdElmt3 = document.createElement("td");
				var tdElmt4 = document.createElement("td");
				var tdElmt5 = document.createElement("td");
				var tdElmt6 = document.createElement("td");
				
				trElmt.setAttribute("class", unselectClass);
				trElmt.setAttribute("role",  itemList[i]["itemId"]);
				trElmt.onclick    = function(event) {clickRowFunct(event);};
				trElmt.ondblclick = function(event) {itemDblClickHandler(this);};
				
				var inputElmt  = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				inputElmt.onclick = function(event) {getCheckedFunct(event);};
				tdElmt1.appendChild(inputElmt);
				
				tdElmt2.textContent = getItemType(itemList[i]["itemType"]);
				tdElmt2.setAttribute("title", tdElmt2.textContent);
				
				tdElmt3.textContent = itemList[i]["title"];
				tdElmt3.setAttribute("title", tdElmt3.textContent);
				
				tdElmt4.textContent = itemList[i]["creatorName"];
				tdElmt4.setAttribute("title", tdElmt4.textContent);
				
				tdElmt5.textContent = itemList[i]["createdDate"].substring(0, 19);
				tdElmt5.setAttribute("title", tdElmt5.textContent);
				
				tdElmt6.textContent = getFileSize(itemList[i]["itemSize"]);
				
				tdElmt1.className = "inputTh";
				tdElmt2.className = "typeTh";
				tdElmt3.className = "ttlTh cabTxtOver";
				tdElmt4.className = "userTh cabTxtOver";
				tdElmt5.className = "dateTh cabTxtOver";
				tdElmt6.className = "sizeTh cabTxtOver";
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt3);
				trElmt.appendChild(tdElmt4);
				trElmt.appendChild(tdElmt5);
				trElmt.appendChild(tdElmt6);
				tableDataElmt.appendChild(trElmt);*/
			}
		}
	}
	
	function onMainSearch() {
		var title      = document.getElementById("sCabTitle").value;
		var summary    = document.getElementById("sCabSum").value;
		var userName   = document.getElementById("sUserName").value;
		var sRecursive = document.getElementById("dCheckBox").checked ? "1" : "0";
		var sDate      = document.getElementById("Sdatepicker").value;
		var eDate      = document.getElementById("Edatepicker").value;
		
		if (!title && !summary && !userName && !sDate && !eDate) {alert(SurveyMessages.strSearch); return;}
		if ((!sDate && eDate)) {alert(SurveyMessages.strDate3); return;}
		if ((sDate && !eDate)) {alert(SurveyMessages.strDate2); return;}
		if (sDate && eDate)    {if (sDate > eDate) {alert(SurveyMessages.strDate1); return;}}
		
		titelStr       = title;
		summaryStr     = summary;
		creatorNameStr = userName;
		recursiveMode  = sRecursive;
		startDateStr   = sDate;
		endDateStr     = eDate;
		
		searchMode = "2";
		toggleSearchPanel();
		startSearchCabinet("1");
	}
	/* Main search end*/
	
	/* Simple Search Part */
	function onStartSimpleSearch(event) {if(event.keyCode == "13") {startSimpleSearch();}}
	
	function startSimpleSearch() {
		var searchStr = document.getElementById("ssInput").value;
		
		if (!searchStr.replace(/\s/g,'')) {alert(SurveyMessages.strNoInput); return;}
		
		searchMode    = "1";
		var searchOpt = document.getElementById("searchCheck").value;
		if (searchOpt == "title") {titelStr = searchStr;} else {summaryStr = searchStr;}
		
		startSearchCabinet("1");
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
		if (getSelectedItems().length == 0) {alert(SurveyMessages.strItemErr); return;}
		if (confirm(SurveyMessages.strDelete)) {
			var url  = "/ezCabinet/deleteItems.do";
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
	
	function openFileDetail(itemId) {
		if(itemPopup) {itemPopup.close();}
		itemPopup = window.open("/ezCabinet/cabinetFileDetail.do?itemId=" + itemId, "fileDetail", getOpenWindowfeature(780, 750));
	}
	
	function getSelectedItems() {
		var result        = [];
		var itemListElmt  = document.getElementById("surveyList");
		var selectedItems = itemListElmt.querySelectorAll("tr[class='bnkCabSelect']");
		
		for (var i = 0, len = selectedItems.length; i< len; i++) {
			result.push(selectedItems[i].getAttribute("role"));
		}
		
		return result;
	}
	
	function itemClickHandler(trObj) {
		var itemId   = trObj.getAttribute("role");
		var crrClass = trObj.className;
		
		if (crrClass == "bnkCabSelect") {
			if (crrPreMode == "off") {return;}
			
			var url  = "/ezCabinet/getFileDetail.do";
			var data = {itemId : itemId};
			makeAjaxCall(data, "GET", url, afterGetItemInfo, null, true, null);
		}
	}
	
	function itemDblClickHandler(trObj) {
		var itemId   = trObj.getAttribute("role");
		openFileDetail(itemId);
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
		
		spanIcon.onclick        = function(e) {openFileDetail(itemInfo["itemId"]);};
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
				spanChild2.textContent  = getFileSize(fileSize);
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
	
	function isImage(fileName) {
		var fileExt  = (/[.]/.exec(fileName)) ? /[^.]+$/.exec(fileName) : "";
		var imgCheck = false;
		var urlImg   = "";
		
		switch (fileExt.toString().toLowerCase()) {
			case "jpg"  :
			case "gif"  :
			case "bmp"  :
			case "png"  :
			case "jpeg" : imgCheck = true                       ; break;
			case "pdf"  : urlImg   = "/images/cabinet/pdf.png"  ; break;
			case "ppt"  : urlImg   = "/images/cabinet/ppt.png"  ; break;
			case "pptx" : urlImg   = "/images/cabinet/pptx.png" ; break;
			case "doc"  : urlImg   = "/images/cabinet/doc.png"  ; break;
			case "docx" : urlImg   = "/images/cabinet/docx.png" ; break;
			case "xls"  : urlImg   = "/images/cabinet/xls.png"  ; break;
			case "xlsx" : urlImg   = "/images/cabinet/xlsx.png" ; break;
			case "hwp"  : urlImg   = "/images/cabinet/hwp.png"  ; break;
			case "txt"  : urlImg   = "/images/cabinet/txt.png"  ; break;
			case "mp4"  : urlImg   = "/images/cabinet/mp4.png"  ; break;
			case "flv"  : urlImg   = "/images/cabinet/flv.png"  ; break;
			case "mkv"  : urlImg   = "/images/cabinet/mkv.png"  ; break;
			case "iso"  : urlImg   = "/images/cabinet/iso.png"  ; break;
			case "rar"  : urlImg   = "/images/cabinet/rar.png"  ; break;
			case "zip"  : urlImg   = "/images/cabinet/zip.png"  ; break;
			default     : urlImg   = "/images/cabinet/none.png" ; break;
		}
		
		return {
			isImage  : imgCheck,
			urlImage : urlImg
		};
	}
	
	function showUserInfoFromId(userId) {
		var feature = "height=500px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
		feature = feature + getOpenWindowfeature(420, 500);
		userWindow = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
	}
	
	function getFileSize(fileSize) {
		var result = fileSize + "B";
		
		switch(true) {
			case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
			case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2)    + "MB"; break;
			case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2)       + "KB"; break;
		}
		return result;
	}
	
	function closeAllPopups() {
		if(itemPopup)  {itemPopup.close();}
		if(sharePopup) {sharePopup.close();}
		if(addPopup)   {addPopup.close();}
		if(userWindow) {userWindow.close();}
	}
	
	function createNewSurvey()  {window.parent.frames["right"].location.href = "/ezSurvey/createSurvey.do";}
	function getIframeContent() {return documentCont;}
	
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
