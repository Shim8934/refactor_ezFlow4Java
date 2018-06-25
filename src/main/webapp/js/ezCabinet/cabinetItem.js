var CabinetItem = function() {
	var cabinetPreview = null;
	var crrPreMode     = null;
	var cabinetNavi    = null;
	var cabinetTable   = null;
	var startDateStr   = "";
	var endDateStr     = "";
	var recursiveMode  = "Y";
	
	/* Preview option */
	setData(50, 50, 30, 70, 20, 80);
	function setData(height, width, minWPercent, maxWPercent, minHPercent, maxHPercent) {
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
		
		cabinetPreview.resizeByWidth();
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
	
	window.addEventListener("resize", function(e) {windowResize();}, false);
	window.addEventListener("keydown", function(e) {keyPress(e);}, false);
	
	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	initEvents();
	
	function windowResize() {closeViewPopUp(); cabinetPreview.resizeByWidth();}
	function keyPress(e) {if (e.which == 27) {if (document.getElementById("searchPanel").className == "cabSearchPanel") {openSearchPanel();}}}
	
	function initEvents() {
		document.onselectstart = function () { return false;};
		var sSearchInputElmt   = document.getElementById("ssInput");
		sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
		sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
		
		var searchBttnElmt = document.getElementById("searchBttn");
		searchBttnElmt.addEventListener("click", function(e) {startSimpleSearch();}, false);
		
		var preViewNoneElmt   = document.getElementById("preViewNone");
		var preViewBottomElmt = document.getElementById("preViewBottom");
		var preViewleftElmt   = document.getElementById("preViewleft");
		var optionViewElmt    = document.getElementById("sltView");
		
		preViewNoneElmt.addEventListener("click", function(e) {changePreview("None");}, false);
		preViewBottomElmt.addEventListener("click", function(e) {changePreview("H");}, false);
		preViewleftElmt.addEventListener("click", function(e) {changePreview("W");}, false);
		optionViewElmt.addEventListener("click", function(e) {toggleOptionView(this);}, false);
		
		var closeSearchBttn     = document.getElementsByClassName("cabCloseBttn")[0];
		closeSearchBttn.onclick = function() {openSearchPanel();};
		var cabdivBttnElmt      = document.getElementsByClassName("cabdivBttn")[0];
		var listBttns           = cabdivBttnElmt.children;
		listBttns[0].onclick    = function(e) {};
		listBttns[1].onclick    = function(e) {};
		listBttns[2].onclick    = function(e) {openSearchPanel();};
		
		var libttns = document.getElementById("mainmenu").firstElementChild.children;
		libttns[0].firstElementChild.onclick  = function() {addFile();};
		libttns[2].firstElementChild.onclick  = function() {deleteFile();};
		libttns[3].firstElementChild.onclick  = function() {moveFile();};
		libttns[5].firstElementChild.onclick  = function() {refresh();};
		libttns[6].firstElementChild.onclick  = function() {openSearchPanel();};
		libttns[8].firstElementChild.onclick  = function() {openSharePanel();};
		
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
		cabinetNavi = CabinetNavi.getInstance();
		cabinetNavi.setMessages({
			next     : CabinetMessages.strNext,
			previous : CabinetMessages.strPrev,
			item     : CabinetMessages.strItem,
			total    : CabinetMessages.strTotal
		});
		cabinetNavi.search(startSearchCabinet);
		
		//Initial table
		cabinetTable = new CabinetTable();
		cabinetTable.setTableType("cabinet");
		cabinetTable.setTableElement("tblCabinetList", "id");
		cabinetTable.setRenderFunct(renderCabinetTable);
	}
	
	/* Search Panel */
	function openSearchPanel() {
		var rightFrame  = window.parent.frames["right"].document;
		var searchPanel = rightFrame.getElementById("searchPanel");
		if (searchPanel.className == "cabSearchPanel off") {
			addFogPanel();
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
	
	function addFogPanel() {
		var fogPanel               = document.createElement("div");
		fogPanel.onclick           = function(e) {openSearchPanel();};
		fogPanel.className         = "cabFogPanel";
		document.body.appendChild(fogPanel);
		var leftFogPanel           = document.createElement("div");
		leftFogPanel.onclick       = function(e) {openSearchPanel();};
		leftFogPanel.className     = "blockLeft";
		var leftFrameBody          = window.parent.frames["left"].document.body;
		leftFrameBody.appendChild(leftFogPanel);
	}
	
	function removeFogPanel() {
		var leftFrame  = window.parent.frames["left"].document;
		var rightFrame = window.parent.frames["right"].document;
		var fogPanel   = rightFrame.querySelector("div[class='cabFogPanel']");
		if (fogPanel) {rightFrame.body.removeChild(fogPanel);}
		
		var leftFogPanel = leftFrame.querySelector("div[class='blockLeft']");
		if (leftFogPanel) {leftFrame.body.removeChild(leftFogPanel);}
		
		if (rightFrame.getElementById("ui-datepicker-div")) {rightFrame.getElementById("ui-datepicker-div").style.display = "none";}
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
				alert(strError + error);
			}
		});
	}
	
	function renderCabinetTable(dataSource, unselectClass, tableDataElmt, getCheckedFunc, clickRowFunct) {
		
	}
	
	function onMainSearch() {
		openSearchPanel();
		startSearchCabinet("1");
	}
	/* Main search */
	
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
		var viewPopup           = document.getElementById("layer_popup");
		viewPopup.style.left    = document.documentElement.clientWidth - 160 + "px";
		viewPopup.style.top     = "100px";
		viewPopup.style.display = "";
		optElmt.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
		optElmt.setAttribute("role", "on");
	}
	
	function closeViewPopUp() {
		var optElmt = document.getElementById("sltView");
		document.getElementById("layer_popup").style.display = "none";
		optElmt.setAttribute("role", "off");
		optElmt.setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
	}
	/* Option View end */
	
	function addFile() {
		var cabId = document.getElementById("cabInfo").getAttribute("role");
		var popup = window.open("/ezCabinet/addCabinetFile.do?cabId=" + cabId, "addFile", getOpenWindowfeature(600, 450));
	}
	
	return {
		
	};
}();