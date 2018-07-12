var CabinetItem = function() {
	var cabinetPreview = null;
	var crrPreMode     = null;
	var cabinetNavi    = null;
	var cabinetTable   = null;
	var startDateStr   = "";
	var endDateStr     = "";
	var recursiveMode  = "Y";
	var cabinetId      = null;
	var minWPercent    = 30;
	var maxWPercent    = 70;
	var minHPercent    = 20;
	var maxHPercent    = 80;
	
	/* Preview option */
	//setData(50, 50, 30, 70, 20, 80);
	function setData(height, width, prevMode) {
		var cabinetGeneral = {
			height    : height,
			width     : width,
			minWidth  : minWPercent,
			maxWidth  : maxWPercent,
			minHeight : minHPercent,
			maxHeight : maxHPercent
		};
		
		cabinetPreview = new CabinetPreview({
			percent     : cabinetGeneral,
			prevDivH    : "previewCabH",
			prevDivW    : "previewCabW",
			tableId     : "cabinetFileList",
			wraperId    : "cabWraperDiv",
			preContentH : "preContentH",
			preContentW : "preContentW"
		});
		
		switch(prevMode) {
			case "w"   : cabinetPreview.resizeByWidth() ; break;
			case "h"   : cabinetPreview.resizeByHeight(); break;
		}
	}
	
	function changePreview(mode) {
		if (mode == crrPreMode) {return;}
		
		switch(mode) {
			case "None":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_onnoframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_bottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_leftframe.gif";
				cabinetPreview.resizeDestroy();
				break;
			case "W":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_noframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_bottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_onleftframe.gif";
				cabinetPreview.resizeByWidth();
				break;
			case "H":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_noframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_onbottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_leftframe.gif";
				cabinetPreview.resizeByHeight();
				break;
			default:
				return;
		}
	}
	/* Preview option end */
	
	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	
	function windowResize() {closeViewPopUp(); cabinetPreview.resizeByWidth();}
	function keyPress(e) {if (e.which == 27) {if (document.getElementById("searchPanel").className == "cabSearchPanel") {toggleSearchPanel();}}}
	
	function initEvents(cabId, height, width, prevMode) {
		setData(50, 50, prevMode);
		window.addEventListener("resize", function(e) {windowResize();}, false);
		window.addEventListener("keydown", function(e) {keyPress(e);}, false);
		cabinetId              = cabId;
		document.onselectstart = function() {return false;};
		var sSearchInputElmt   = document.getElementById("ssInput");
		sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
		sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
		
		var searchBttnElmt = document.getElementById("searchBttn");
		searchBttnElmt.addEventListener("click", function(e) {startSimpleSearch();}, false);
		
		var preViewNoneElmt   = document.getElementById("preViewNone");
		var preViewBottomElmt = document.getElementById("preViewBottom");
		var preViewleftElmt   = document.getElementById("preViewleft");
		var optionViewElmt    = document.getElementById("sltView");
		
		preViewNoneElmt.addEventListener("click", function(e)   {changePreview("None");}, false);
		preViewBottomElmt.addEventListener("click", function(e) {changePreview("H");}, false);
		preViewleftElmt.addEventListener("click", function(e)   {changePreview("W");}, false);
		optionViewElmt.addEventListener("click", function(e)    {toggleOptionView(this);}, false);
		
		var closeSearchBttn     = document.getElementsByClassName("cabCloseBttn")[0];
		closeSearchBttn.onclick = function() {toggleSearchPanel();};
		var cabdivBttnElmt      = document.getElementById("searchDivBttn");
		var listBttns           = cabdivBttnElmt.children;
		listBttns[0].onclick    = function(e) {clearSearchDate();};
		listBttns[1].onclick    = function(e) {}; //*Note add main search function here
		listBttns[2].onclick    = function(e) {toggleSearchPanel();};
		
		var cabDelBttnElmt      = document.getElementById("delDivBttn");
		var dellistBttns        = cabDelBttnElmt.children;
		dellistBttns[0].onclick = function(e) {deleteFile();};
		dellistBttns[1].onclick = function(e) {toggleDeletePopup();};
		
		var cabMoveBttnElmt     = document.getElementById("moveDivBttn");
		var movlistBttns        = cabMoveBttnElmt.children;
		movlistBttns[0].onclick = function(e) {moveFile("copy");};
		movlistBttns[1].onclick = function(e) {moveFile("move");};
		movlistBttns[2].onclick = function(e) {toggleMovePopup();};
		
		var libttns = document.getElementById("mainmenu").firstElementChild.children;
		libttns[0].firstElementChild.onclick  = function() {addFile();};
		libttns[2].firstElementChild.onclick  = function() {deleteFileConfirm();};
		libttns[3].firstElementChild.onclick  = function() {moveFileConfirm();};
		libttns[5].firstElementChild.onclick  = function() {refresh();};
		libttns[6].firstElementChild.onclick  = function() {toggleSearchPanel();};
		libttns[8].firstElementChild.onclick  = function() {openSharePopup();};
		libttns[9].firstElementChild.onclick  = function() {getFileDetail();};
		libttns[10].firstElementChild.onclick = function() {addRelatedCabinet();};
		
		$("#Sdatepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			autoSize: true,
			showOn: "both",
			buttonImage: "/images/ImgIcon/calendar-month.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		});
		
		$("#Edatepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			autoSize: true,
			showOn: "both",
			buttonImage: "/images/ImgIcon/calendar-month.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		});
		
		//Initial page navigation
		var naviMessages = {
			next     : CabinetMessages.strNext,
			previous : CabinetMessages.strPrev,
			item     : CabinetMessages.strItem,
			total    : CabinetMessages.strTotal
		};
		
		cabinetNavi = new CabinetNavi({
			messages : naviMessages,
			divId    : "tblPageRayer",
			divClass : "cabpagenavi",
			headerId : "",
			callback : startSearchCabinet
		});
		
		//Initial table
		cabinetTable = new CabinetTable({
			normal   : "bnkCabNormal",
			selected : "bnkCabSelect"
		});
		cabinetTable.setTableType("cabinet");
		cabinetTable.setTableElement("tblCabinetList", "id");
		cabinetTable.setCallBack(searchCallBack);
		cabinetTable.setRenderFunct(renderCabinetTable);
	}
	
	/* Search Panel */
	function toggleSearchPanel() {
		var rightFrame  = window.parent.frames["right"].document;
		var searchPanel = rightFrame.getElementById("searchPanel");
		if (searchPanel.className == "cabSearchPanel off") {
			addFogPanel("search");
			var position            = getPosition(426, 278);
			searchPanel.style.top   = position[0] + "px";
			searchPanel.style.right = position[1] + "px";
			searchPanel.className   = "cabSearchPanel";
		}
		else {
			removeFogPanel();
			searchPanel.className   = "cabSearchPanel off";
		}
		
		//Clear all fields
		rightFrame.getElementById("Sdatepicker").value = "";
		rightFrame.getElementById("Edatepicker").value = "";
		rightFrame.getElementById("dCheckBox").checked = true;
		rightFrame.getElementById("sUserName").value   = "";
		rightFrame.getElementById("sCabTitle").value   = "";
		rightFrame.getElementById("sCabIntro").value   = "";
	}
	
	function addFogPanel(mode) {
		var handleClickFunct = null;
		
		switch(mode) {
			case "search": handleClickFunct = toggleSearchPanel; break;
			case "del"   : handleClickFunct = toggleDeletePopup; break;
			case "move"  : handleClickFunct = toggleMovePopup  ; break;
			default      : alert(CabinetMessages.strError); return;
		}
		
		var fogPanel                 = document.createElement("div");
		fogPanel.className           = "cabFogPanel";
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
		var fogPanel     = rightFrame.querySelector("div[class='cabFogPanel']");
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
		
		var pleftpos = parseInt(width) - popUpW;
		heigth       = parseInt(heigth) - popUpH;
		
		if (heigth < (popUpH + 50)) {
			returnValue[0] = (heigth / 2);
		}
		else {
			returnValue[0] = (heigth / 2) - 50;
		}
		
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
		var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
		return feature;
	}
	
	function searchCallBack() {
		//*Note add code here
	}
	/* Search Panel end*/
	
	/* Main search */
	function startSearchCabinet(pPage) {
		var orderInf = tableView.getOrderInfo();
		var listCnt  = document.getElementById("listCount").value;
		
		$.ajax({
			type: "POST",
			url: "",
			data: {
				"currentPage" : pPage,
				"startDate"   : startDateStr,
				"endDate"     : endDateStr,
				"column"      : orderInf.col ? orderInf.col : "",
				"order"       : orderInf.ord ? orderInf.ord : "",
				"listCntSize" : listCnt
			},
			dataType: "JSON",
			async: false,
			success : function(data) {
				cabinetTable.setDataSource(result.cabinetList);
				cabinetTable.renderTable();
			},
			error : function(error) {
				alert(CabinetMessages.strError + error);
			}
		});
	}
	
	function renderCabinetTable(dataSource, unselectClass, tableDataElmt, getCheckedFunc, clickRowFunct) {
		//*Note add code here
	}
	
	function onMainSearch() {
		toggleSearchPanel();
		startSearchCabinet("1");
	}
	/* Main search end*/
	
	/* Simple Search Part */
	function onStartSimpleSearch(event) {if(event.keyCode == "13") {startSimpleSearch();}}
	
	function startSimpleSearch() {
		
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
	/* Option View end */
	
	function addFile() {
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		var addPopup = window.open("/ezCabinet/addCabinetFile.do?cabId=" + cabinetId, "addFile", getOpenWindowfeature(600, 470));
	}
	
	function deleteFileConfirm() {
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		var fileId = null;
		
		//*Note: add checking conditions before open popup
		toggleDeletePopup();
	}
	
	function toggleDeletePopup() {
		var rightFrame  = window.parent.frames["right"].document;
		var deletePanel = rightFrame.getElementById("cabFileDel");
		if (deletePanel.className == "popup cabFileDeloff") {
			addFogPanel("del");
			var position            = getPosition(450, 180);
			deletePanel.style.top   = position[0] + "px";
			deletePanel.style.right = position[1] + "px";
			deletePanel.className   = "popup cabFileDelon";
		}
		else {
			removeFogPanel();
			deletePanel.className   = "popup cabFileDeloff";
		}
	}
	
	function deleteFile() {
		//*Note add code here
	}
	
	function moveFileConfirm() {
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		var fileId = null;
		
		//Show folder Tree then toggle popup
		toggleMovePopup();
	}
	
	function toggleMovePopup() {
		var rightFrame  = window.parent.frames["right"].document;
		var movePanel = rightFrame.getElementById("cabFileMove");
		if (movePanel.className == "popup cabFileMoveoff") {
			addFogPanel("move");
			var position          = getPosition(260, 350);
			movePanel.style.top   = position[0] + "px";
			movePanel.style.right = position[1] + "px";
			movePanel.className   = "popup cabFileMoveon";
		}
		else {
			removeFogPanel();
			movePanel.className   = "popup cabFileMoveoff";
		}
	}
	
	function moveFile(mode) {
		//*Note implement here
	}
	
	function openSharePopup() {
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		var sharePopup = window.open("/ezCabinet/shareCabinet.do?cabId=" + cabinetId, "shareFile", getOpenWindowfeature(1000, 600));
	}
	
	function addRelatedCabinet() {
		//* blank 2018.07.09
		var cabId  = document.getElementById("cabInfo").getAttribute("role");
		window.open("/ezCabinet/cabinetAddRelated.do", "addRelated", getOpenWindowfeature(600, 690));
	}
	
	function getFileDetail() {window.open("/ezCabinet/cabinetFileDetail.do", "fileDetail", getOpenWindowfeature(600, 670));}
	
	return {start : initEvents};
}();