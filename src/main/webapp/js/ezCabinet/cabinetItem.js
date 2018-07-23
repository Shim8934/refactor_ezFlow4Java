var CabinetItem = function() {
	var cabinetPreview = null;
	var crrPreMode     = null;
	var cabinetNavi    = null;
	var cabinetTable   = null;
	var searchMode     = "0"; //0: normal, 1: simple, 2: detail
	var startDateStr   = "";
	var endDateStr     = "";
	var recursiveMode  = "";
	var titelStr       = "";
	var summaryStr     = "";
	var creatorNameStr = "";
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
			case "w"   : cabinetPreview.resizeByWidth()      ; break;
			case "h"   : cabinetPreview.resizeByHeight()     ; break;
			case "off" : cabinetPreview.resizeDestroy("init"); break;
		}
		
		crrPreMode = prevMode;
	}
	
	function changePreview(mode) {
		if (mode == crrPreMode) {return;}
		
		switch(mode) {
			case "off":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_onnoframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_bottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_leftframe.gif";
				cabinetPreview.resizeDestroy();
				break;
			case "w":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_noframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_bottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_onleftframe.gif";
				cabinetPreview.resizeByWidth();
				break;
			case "h":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_noframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_onbottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_leftframe.gif";
				cabinetPreview.resizeByHeight();
				break;
			default:
				return;
		}
		
		crrPreMode = mode;
	}
	/* Preview option end */
	
	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	
	function windowResize() {
		preProcessing();
		closeViewPopUp();
		
		switch(crrPreMode) {
			case "w"  : cabinetPreview.resizeByWidth()  ; break;
			case "h"  : cabinetPreview.resizeByHeight() ; break;
		}
	}
	
	function keyPress(e) {if (e.which == 27) {if (document.getElementById("searchPanel").className == "cabSearchPanel") {toggleSearchPanel();}}}
	
	function ondblclick(e){
		window.open("/ezCabinet/cabinetFileDetail.do", "fileDetail", getOpenWindowfeature(600, 690));
	}
	
	function preProcessing() {
		var divList           = document.getElementById("cabWraperDiv");
		var divChild          = divList.querySelector("div[class='tableDataDiv']");
		var reheight          = document.documentElement.clientHeight - 150;
		divList.style.height  = reheight + "px";
		divChild.style.height = reheight - 40 + "px";
	}
	
	function initEvents(cabId, height, width, prevMode) {
		setData(height, width, prevMode);
		
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
			headerId : "cabinetInfo",
			callback : startSearchCabinet
		});
		
		//Initial table
		cabinetTable = new CabinetTable({
			normal   : "bnkCabNormal",
			selected : "bnkCabSelect"
		});
		
		cabinetTable.setTableType("cabinet");
		cabinetTable.setTableElement("tblCabinetList", "id");
		cabinetTable.setClickHandler(itemClickHandler);
		cabinetTable.setCallBack(searchCallBack);
		cabinetTable.setRenderFunct(renderCabinetTable);
		
		window.addEventListener("resize", function(e) {windowResize();}, false);
		window.addEventListener("keydown", function(e) {keyPress(e);}, false);
		
		cabinetId              = cabId;
		document.onselectstart = function() {return false;};
		var sSearchInputElmt   = document.getElementById("ssInput");
		sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
		sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
		
		var searchBttnElmt = document.getElementById("searchBttn");
		searchBttnElmt.addEventListener("click", function(e) {startSimpleSearch();}, false);
		
		document.getElementById("preViewNone").addEventListener("click", function(e)   {changePreview("off");}, false);
		document.getElementById("preViewBottom").addEventListener("click", function(e) {changePreview("h");}, false);
		document.getElementById("preViewleft").addEventListener("click", function(e)   {changePreview("w");}, false);
		document.getElementById("sltView").addEventListener("click", function(e)       {toggleOptionView(this);}, false);
		document.getElementById("listcount").addEventListener("change", function(e)    {startSearchCabinet("1");}, false);
		
		var closeSearchBttn     = document.getElementsByClassName("cabCloseBttn")[0];
		closeSearchBttn.onclick = function() {toggleSearchPanel();};
		var cabdivBttnElmt      = document.getElementById("searchDivBttn");
		var listBttns           = cabdivBttnElmt.children;
		listBttns[0].onclick    = function(e) {clearSearchDate();};
		listBttns[1].onclick    = function(e) {onMainSearch();};
		listBttns[2].onclick    = function(e) {toggleSearchPanel();};
		
		var cabDelBttnElmt      = document.getElementById("delDivBttn");
		var dellistBttns        = cabDelBttnElmt.children;
		dellistBttns[0].onclick = function(e) {deleteFile();};
		dellistBttns[1].onclick = function(e) {toggleDeletePopup();};
		
		var cabMoveBttnElmt     = document.getElementById("moveDivBttn");
		var movlistBttns        = cabMoveBttnElmt.children;
		movlistBttns[0].onclick = function(e) {moveFile("move");};
		movlistBttns[1].onclick = function(e) {moveFile("copy");};
		movlistBttns[2].onclick = function(e) {toggleMovePopup();};
		
		var addBttn = document.getElementById("addBttn");
		var delBttn = document.getElementById("delBttn");
		var movBttn = document.getElementById("movBttn");
		var shaBttn = document.getElementById("shaBttn");
		if (addBttn) {addBttn.firstElementChild.onclick = function(e) {addFile();};}
		if (delBttn) {delBttn.firstElementChild.onclick = function(e) {deleteFileConfirm();};}
		if (movBttn) {movBttn.firstElementChild.onclick = function(e) {moveFileConfirm();};}
		if (shaBttn) {shaBttn.firstElementChild.onclick = function(e) {openSharePopup();};}
		document.getElementById("refBttn").firstElementChild.onclick = function(e) {searchCallBack();};
		document.getElementById("schBttn").firstElementChild.onclick = function(e) {toggleSearchPanel();};
		
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
		
		startSearchCabinet("1");
		preProcessing();
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
		rightFrame.getElementById("dCheckBox").checked = false;
		rightFrame.getElementById("sUserName").value   = "";
		rightFrame.getElementById("sCabTitle").value   = "";
		rightFrame.getElementById("sCabSum").value     = "";
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
		var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
		return feature;
	}
	
	function searchCallBack() {
		var crrPage = cabinetNavi.get().currentPage;
		crrPage     = crrPage ? crrPage : 1;
		startSearchCabinet(crrPage);
	}
	
	function refreshAllFrames() {
		searchCallBack();
		var leftFrame = window.parent.frames["left"];
		if (leftFrame) {leftFrame.CabUserLeft.draw();}
	}
	/* Search Panel end*/
	
	/* Main search */
	function startSearchCabinet(pPage) {
		var orderInf  = cabinetTable.getOrderInfo();
		var listCnt   = document.getElementById("listcount").value;
		var searchOpt = document.querySelector("input[name='searchCheck']:checked").value;
		
		$.ajax({
			type: "POST",
			url: "/ezCabinet/getCabinetItems.do",
			data: {
				"currentPage" : pPage,
				"cabinetId"   : cabinetId,
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
				alert(CabinetMessages.strError + error);
			}
		});
	}
	
	function checkingData(data) {
		var code = data.code;
		switch(code) {
			case 0 : processData(data)                 ; break;
			case 1 : alert(CabinetMessages.strParamErr); break;
			case 2 : alert(CabinetMessages.strError)   ; break;
			default: alert(CabinetMessages.strError)   ; return; 
		}
	}
	
	function processData(data) {
		cabinetTable.setDataSource(data.itemList);
		cabinetTable.renderTable();
		cabinetNavi.init(data.currentPage, data.totalRows, data.totalPages);
	}
	
	function renderCabinetTable(itemList, unselectClass, tableDataElmt, getCheckedFunct, clickRowFunct) {
		if (itemList == null || itemList.length == 0) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			tdElmt.setAttribute("colspan", "6");
			tdElmt.setAttribute("align", "center");
			tdElmt.setAttribute("bgcolor", "#FFFFFF");
			tdElmt.innerHTML = CabinetMessages.strNoData;
			
			trElmt.appendChild(tdElmt);
			tableDataElmt.appendChild(trElmt);
		}
		else {
			var len = itemList.length;
			for (var i = 0; i < len; i++) {
				var trElmt  = document.createElement("tr");
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
				tableDataElmt.appendChild(trElmt);
			}
		}
	}
	
	function getFileSize(fileSize) {
		var result = fileSize + "B";
		
		switch(true) {
			case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
			case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2) + "MB"   ; break;
			case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2) + "KB"      ; break;
		}
		
		return result;
	}
	
	function getItemType(type) {
		var result = "";
		
		switch(type) {
			case 0 : result = "수동"      ; break;
			case 1 : result = "메일"      ; break;
			case 2 : result = "전자결재"   ; break;
			case 3 : result = "게시판"    ; break;
			case 4 : result = "일정관리"   ; break;
			case 5 : result = "업무관리"   ; break;
			case 6 : result = "회람판"    ; break;
			case 7 : result = "커뮤니티"   ; break;
			case 8 : result = "주소록"    ; break;
			case 9 : result = "업무일지"   ; break;
			case 10: result = "프로젝트 관리"; break;
		}
		
		return result;
	}
	
	function onMainSearch() {
		var title      = document.getElementById("sCabTitle").value;
		var summary    = document.getElementById("sCabSum").value;
		var userName   = document.getElementById("sUserName").value;
		var sRecursive = document.getElementById("dCheckBox").checked ? "1" : "0";
		var sDate      = document.getElementById("Sdatepicker").value;
		var eDate      = document.getElementById("Edatepicker").value;
		
		if (!title && !summary && !userName && !sDate && !eDate) {alert(CabinetMessages.strSearch); return;}
		if ((!sDate && eDate)) {alert(CabinetMessages.strDate3); return;}
		if ((sDate && !eDate)) {alert(CabinetMessages.strDate2); return;}
		if (sDate && eDate)    {if (sDate > eDate) {alert(CabinetMessages.strDate1); return;}}
		
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
		
		if (!searchStr.replace(/\s/g,'')) {alert(CabinetMessages.strNoInput); return;}
		
		searchMode    = "1";
		var searchOpt = document.querySelector("input[name='searchCheck']:checked").value;
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
	/* Option View end */
	
	function addFile() {
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		var addPopup = window.open("/ezCabinet/addCabinetFile.do?cabId=" + cabinetId, "addFile", getOpenWindowfeature(600, 470));
	}
	
	function deleteFileConfirm() {
		if (getSelectedItems().length == 0) {alert(CabinetMessages.strItemErr); return;}
		
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
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		var itemArr = getSelectedItems();
		if (itemArr.length == 0) {alert(CabinetMessages.strItemErr); return;}
		
		var url  = "/ezCabinet/deleteItems.do";
		var data = {itemList : itemArr.toString()};
		
		makeAjaxCall(data, "GET", url, afterDeleteItem, null, true, null);
	}
	
	function afterDeleteItem(data) {
		var code = data.code;
		switch(code) {
			case 0 : afterDeleteSuccessfully()         ; break;
			case 1 : alert(CabinetMessages.strParamErr); break;
			case 2 : alert(CabinetMessages.strError)   ; break;
			case 3 : alert(CabinetMessages.strPerm)    ; break;
			default: alert(CabinetMessages.strError)   ; return; 
		}
	}
	
	function afterDeleteSuccessfully() {
		alert(CabinetMessages.strDel);
		refreshAllFrames();
		toggleDeletePopup();
	}
	
	function moveFileConfirm() {
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		if (getSelectedItems().length == 0) {alert(CabinetMessages.strItemErr); return;}
		
		toggleMovePopup();
	}
	
	function toggleMovePopup() {
		var rightFrame  = window.parent.frames["right"].document;
		var movePanel = rightFrame.getElementById("cabFileMove");
		if (movePanel.className == "popup cabFileMoveoff") {
			addFogPanel("move");
			
			//Add new tree
			var subTree = new CabinetTree();
			
			subTree.setTreeInfo({
				treeId     : "moveCabTree",
				treeType   : "cabinet",
				type       : "list",
				initialUrl : "/ezCabinet/getAllCabinetTree.do",
				extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
				click      : null,
				dblClick   : null
			});
			
			subTree.makeTree();
			
			var position          = getPosition(320, 380);
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
		var moveTreeElmt = document.getElementById("moveCabTree");
		var selectedNode = moveTreeElmt.querySelector("span[class='selectedNode']");
		if (!selectedNode) {alert(CabinetMessages.strSelect); return;}
		
		var itemArr      = getSelectedItems();
		if (itemArr.length == 0) {alert(CabinetMessages.strItemErr); return;}
		
		var cabinetId    = selectedNode.getAttribute("role");
		var moveHandler  = null;
		
		var url  = "/ezCabinet/moveItems.do";
		var data = {
			cabinetId : cabinetId,
			mode      : mode,
			itemList  : itemArr.toString()
		};
		
		makeAjaxCall(data, "GET", url, afterMoveItem, null, true, mode);
	}
	
	function afterMoveItem(data, mode) {
		var code = data.code;
		switch(code) {
			case 0 : afterMoveItemSuccessfully(mode)   ; break;
			case 1 : alert(CabinetMessages.strParamErr); break;
			case 2 : alert(CabinetMessages.strError)   ; break;
			case 3 : alert(CabinetMessages.strPerm)    ; break;
			case 4 : alert(CabinetMessages.strCapacity); break;
			default: alert(CabinetMessages.strError)   ; return;
		}
	}
	
	function afterMoveItemSuccessfully(mode) {
		switch(mode) {
			case "copy": alert(CabinetMessages.strCopyItem); break;
			case "move": alert(CabinetMessages.strMoveItem); break;
		}
		
		refreshAllFrames();
		toggleMovePopup();
	}
	
	function openSharePopup() {
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		var sharePopup = window.open("/ezCabinet/shareCabinet.do?cabId=" + cabinetId, "shareFile", getOpenWindowfeature(1125, 700));
	}
	
	function openFileDetail(itemId) {window.open("/ezCabinet/cabinetFileDetail.do?itemId=" + itemId, "fileDetail", getOpenWindowfeature(600, 565));}
	
	function getSelectedItems() {
		var result        = [];
		var itemListElmt  = document.getElementById("cabinetFileList");
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
			//Add preview code here
			//openFileDetail(itemId);
		}
	}
	
	function itemDblClickHandler(trObj) {
		var itemId   = trObj.getAttribute("role");
		var crrClass = trObj.className;
		
		if (crrClass == "bnkCabSelect") {
			//Add preview code here
			openFileDetail(itemId);
		}
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
				
				alert(CabinetMessages.strError);
			}
		});
	}
	
	return {
		start  : initEvents,
		reload : refreshAllFrames
	};
}();
