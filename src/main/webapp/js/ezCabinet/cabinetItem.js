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
	var sharePopup     = null;
	var addPopup       = null;
	var itemPopup      = null;
	var documentCont   = null;
	var userWindow     = null;
	
	/* Preview option */
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
		var slTrElmt = cabinetTable.getSelectedRow();
		crrPreMode   = mode;
		
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
				if (slTrElmt) {itemClickHandler(slTrElmt);}
				break;
			case "h":
				document.getElementById("preViewNone").src   = "/images/kr/cm/btn_noframe.gif";
				document.getElementById("preViewBottom").src = "/images/kr/cm/btn_onbottomframe.gif";
				document.getElementById("preViewleft").src   = "/images/kr/cm/btn_leftframe.gif";
				cabinetPreview.resizeByHeight();
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
			case "w"  : cabinetPreview.resizeByWidth()  ; break;
			case "h"  : cabinetPreview.resizeByHeight() ; break;
		}
	}
	
	function keyPress(e) {if (e.which == 27) {if (document.getElementById("searchPanel").className == "cabSearchPanel") {toggleSearchPanel();}}}
	
	function preProcessing() {
		var divList           = document.getElementById("cabWraperDiv");
		var divChild          = divList.querySelector("div[class='tableDataDiv']");
		var reheight          = document.documentElement.clientHeight - 120;
		divList.style.height  = reheight + "px";
		divChild.style.height = reheight - 70 + "px";
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
			divClass : "pagenavi",
			headerId : "cabinetInfo",
			callback : startSearchCabinet
		});
		
		//Initial table
		cabinetTable = new CabinetTable({normal : "bnkCabNormal", selected : "bnkCabSelect"});
		
		cabinetTable.setTableType("cabinet");
		cabinetTable.setTableElement("tblCabinetList", "id");
		cabinetTable.setClickHandler(itemClickHandler);
		cabinetTable.setCallBack(searchCallBack);
		cabinetTable.setRenderFunct(renderCabinetTable);
		
		window.addEventListener("resize", function(e) {windowResize();}, false);
		window.addEventListener("keydown", function(e) {keyPress(e);}, false);
		window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
		
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
		
		var closeSearchBttn     = document.getElementById("cabSearchClose");
		closeSearchBttn.onclick = function() {toggleSearchPanel();};
		var cabdivBttnElmt      = document.getElementById("searchDivBttn");
		var listBttns           = cabdivBttnElmt.children;
		listBttns[0].onclick    = function(e) {clearSearchDate();};
		listBttns[1].onclick    = function(e) {onMainSearch();};
		listBttns[2].onclick    = function(e) {toggleSearchPanel();};
		
		var addBttn = document.getElementById("addBttn");
		var delBttn = document.getElementById("delBttn");
		var movBttn = document.getElementById("movBttn");
		var shaBttn = document.getElementById("shaBttn");
		if (addBttn) {addBttn.firstElementChild.onclick = function(e) {addFile();};}
		
		if (delBttn) {
			var cabDelBttnElmt                              = document.getElementById("delDivBttn");
			var dellistBttns                                = cabDelBttnElmt.children;
			dellistBttns[0].onclick                         = function(e) {deleteFile();};
			dellistBttns[1].onclick                         = function(e) {toggleDeletePopup();};
			document.getElementById("cabDelClose").onclick  = function(e) {toggleDeletePopup();};
			delBttn.firstElementChild.onclick               = function(e) {deleteFileConfirm();};
		}
		
		if (movBttn) {
			var cabMoveBttnElmt                             = document.getElementById("moveDivBttn");
			var movlistBttns                                = cabMoveBttnElmt.children;
			movlistBttns[0].onclick                         = function(e) {moveFile("move");};
			movlistBttns[1].onclick                         = function(e) {moveFile("copy");};
			movlistBttns[2].onclick                         = function(e) {toggleMovePopup();};
			document.getElementById("cabMoveClose").onclick = function(e) {toggleMovePopup();};
			movBttn.firstElementChild.onclick               = function(e) {moveFileConfirm();};
		}
		
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
			var position            = getPosition(464, 278);
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
		
		prevHElmt.innerHTML = "<span class='notSelected'>" + CabinetMessages.strSelect4 + "</span>";
	}
	/* Search Panel end*/
	
	/* Main search */
	function startSearchCabinet(pPage) {
		var orderInf  = cabinetTable.getOrderInfo();
		var listCnt   = document.getElementById("listcount").value;
		var searchOpt = document.getElementById("searchCheck").value;
		
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
			case 2 : result = "전자결재"    ; break;
			case 3 : result = "게시판"    ; break;
			case 4 : result = "일정관리"   ; break;
			case 5 : result = "업무관리"   ; break;
			case 6 : result = "회람판"     ; break;
			case 7 : result = "커뮤니티"   ; break;
			case 8 : result = "주소록"     ; break;
			case 9 : result = "업무일지"   ; break;
			case 10: result = "프로젝트 관리"; break;
			case 11: result = "자원관리"   ; break;
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
	/* Option View end */
	
	function addFile() {
		if (!cabinetId) {alert(CabinetMessages.strError); return;}
		if (addPopup) {addPopup.close();}
		addPopup = window.open("/ezCabinet/addCabinetFile.do?cabId=" + cabinetId, "addFile", getOpenWindowfeature(780, 660)); //수정
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
			case 5 : alert(CabinetMessages.strMovErr1) ; break;
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
		if (sharePopup) {sharePopup.close();}
		sharePopup = window.open("/ezCabinet/shareCabinet.do?cabId=" + cabinetId, "shareFile", getOpenWindowfeature(1125, 700));
	}
	
	function openFileDetail(itemId) {
		if(itemPopup) {itemPopup.close();}
		itemPopup = window.open("/ezCabinet/cabinetFileDetail.do?itemId=" + itemId, "fileDetail", getOpenWindowfeature(780, 750));
	}
	
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
		}
		else {
			showGeneralItemPreview(data, dlElmt, itemInfo, parentDiv);
		}
	}
	
	function showTodoPreview(data, dlElmt) {
		var itemInfo    = data.fileDetail;
		var relatedList = data.relatedFileList;
		var attachList  = data.attachFileList;
		var columnList  = data.columns;
		var typeColumn  = columnList.filter(function(col) {return col["columnId"] == "tasktype";})[0];
		
		generateTodoTitle(itemInfo, relatedList, typeColumn, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, null, null);
	}
	
	function generateTodoTitle(itemInfo, relatedList, typeColumn, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Schedule type
		generateColumnTitle(dlElmt, typeColumn);
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
	}
	
	function showSchedulePreview(data, dlElmt) {
		var itemInfo    = data.fileDetail;
		var relatedList = data.relatedFileList;
		var attachList  = data.attachFileList;
		var columnList  = data.columns;
		var typeColumn  = columnList.filter(function(col) {return col["columnId"] == "scheduletype";})[0];
		
		generateScheduleTitle(itemInfo, relatedList, typeColumn, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, null, null);
	}
	
	function generateScheduleTitle(itemInfo, relatedList, typeColumn, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Schedule type
		generateColumnTitle(dlElmt, typeColumn);
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
	}
	
	function showAddressPreview(data, dlElmt) {
		var itemInfo    = data.fileDetail;
		var attachList  = data.attachFileList;
		var relatedList = data.relatedFileList;
		
		generateAddressTitle(itemInfo, relatedList, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, null, null);
	}
	
	function generateAddressTitle(itemInfo, relatedList, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
	}
	
	function showJournalPreview(data, dlElmt){
		var itemInfo    = data.fileDetail;
		var attachList  = data.attachFileList;
		var relatedList = data.relatedFileList;
		
		generateJournalTitle(itemInfo, relatedList, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, "mjounl", null);
	}
	
	function generateJournalTitle(itemInfo, relatedList, dlElmt){
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
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
		var relatedList = data.relatedFileList;
		generalItemTitle(relatedList,  itemInfo["creatorName"], itemInfo["creatorId"], itemInfo["summary"], dlElmt);
		generalItemContent(attachList, itemInfo["itemSize"]);
	}
	
	function showMailPreview(data, dlElmt) {
		var itemInfo       = data.fileDetail;
		var attachList     = data.attachFileList;
		var relatedList    = data.relatedFileList;
		var columnList     = data.columns;
		var receiverList   = data.receivers;
		var forwardList    = data.forwards;
		var senderUser     = data.sender;
		var senderColumn   = columnList.filter(function(col) {return col["columnId"] == "sender";})[0];
		var receiverColumn = columnList.filter(function(col) {return col["columnId"] == "receiver";})[0];
		var forwardColumn  = columnList.filter(function(col) {return col["columnId"] == "forward";})[0];
		
		generateEmailTitle(itemInfo, relatedList, senderColumn, receiverColumn, forwardColumn, senderUser, receiverList, forwardList, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, null, null);
	}
	
	function generateEmailTitle(itemInfo, relatedList, senderColumn, receiverColumn, forwardColumn, senderUser, receiverList, forwardList, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Sender title
		var sdtElmt = document.createElement("dt");
		var sddElmt = document.createElement("dd");
		sdtElmt.textContent = senderColumn["columnName"] + ": ";
		var senderElmt = document.createElement("span");
		senderElmt.textContent = senderUser["userName"];
		senderElmt.setAttribute("title", senderUser["userEmail"]);
		senderElmt.className   = "txtSpan";
		senderElmt.addEventListener("click", function(e) {showUserInfoFromEmail(senderUser["userEmail"]);}, false);
		sddElmt.appendChild(senderElmt);
		
		dlElmt.appendChild(sdtElmt);
		dlElmt.appendChild(sddElmt);
		
		//Receiver title
		createEmailFieldTitle(receiverColumn, receiverList, dlElmt);
		
		//Forward
		if (forwardList && forwardList.length > 0) {
			createEmailFieldTitle(forwardColumn, forwardList, dlElmt);
		}
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
	}
	
	function createEmailFieldTitle(columnJsonObj, fieldList, dlElmt) {
		var fdtElmt         = document.createElement("dt");
		var fddElmt         = document.createElement("dd");
		fdtElmt.textContent = columnJsonObj["columnName"] + ": ";
		var totalField      = fieldList.length;
		
		if (totalField == 1) {
			var spanElmt = document.createElement("span");
			var userMail = fieldList[0]["userEmail"];
			spanElmt.textContent = fieldList[0]["userName"];
			spanElmt.setAttribute("title", userMail);
			spanElmt.className   = "txtSpan";
			spanElmt.addEventListener("click", function(e) {showUserInfoFromEmail(userMail);}, false);
			fddElmt.appendChild(spanElmt);
		}
		else {
			var spanElmt1 = document.createElement("span");
			var spanElmt2 = document.createElement("span");
			var spanElmt3 = document.createElement("span");
			var pElmt     = document.createElement("p");
			
			spanElmt1.addEventListener("click", function(e) {showUserInfoFromEmail(fieldList[0]["userEmail"]);}, false);
			spanElmt1.textContent = fieldList[0]["userName"];
			spanElmt1.className   = "txtSpan";
			spanElmt1.setAttribute("title", fieldList[0]["userEmail"]);
			spanElmt2.textContent = " (" + CabinetMessages.strTotal + " " + totalField + CabinetMessages.strPeople + ")";
			spanElmt3.className   = "icDown";
			spanElmt3.addEventListener("click", function(e) {showRelatedList(this);}, false);
			pElmt.className       = "relateList hide";
			
			for (var i = 0; i < totalField; i++) {
				var spanChild = document.createElement("span");
				spanChild.className   = "txtSpan";
				spanChild.textContent = fieldList[i]["userName"];
				spanChild.setAttribute("title", fieldList[i]["userEmail"]);
				spanChild.onclick     = (function(receiver) {
					return function() {showUserInfoFromEmail(receiver["userEmail"]);};
				})(fieldList[i]);
				
				pElmt.appendChild(spanChild);
				
				if (i != totalField - 1) {
					var divideEm         = document.createElement("em");
					divideEm.textContent = "; ";
					pElmt.appendChild(divideEm);
				}
			}
			
			fddElmt.appendChild(spanElmt1);
			fddElmt.appendChild(spanElmt2);
			fddElmt.appendChild(spanElmt3);
			fddElmt.appendChild(pElmt);
		}
		
		dlElmt.appendChild(fdtElmt);
		dlElmt.appendChild(fddElmt);
	}
	
	function showResourcePreview(data, dlElmt) {
		var itemInfo      = data.fileDetail;
		var relatedList   = data.relatedFileList;
		var attachList    = data.attachFileList;
		var columnList    = data.columns;
		var resItemColumn = columnList.filter(function(col) {return col["columnId"] == "resourceitem";})[0];
		
		generateResourceTitle(itemInfo, relatedList, resItemColumn, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, null, null);
	}
	
	function generateResourceTitle(itemInfo, relatedList, resItemColumn, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Resource name
		generateColumnTitle(dlElmt, resItemColumn);
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
	}
	
	function showApprovalPreview(data, dlElmt){
		var itemInfo       = data.fileDetail;
		var attachList     = data.attachFileList;
		var relatedList    = data.relatedFileList;
		
		generateApprovalTitle(itemInfo, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, "mapprv", null);
	}
	
	function generateApprovalTitle(itemInfo, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
	}
	
	function showBoardPreview(data, dlElmt) {
		var itemInfo    = data.fileDetail;
		var attachList  = data.attachFileList;
		var relatedList = data.relatedFileList;
		var writer      = data.writerVO;
		var boardType   = data.boardType;
		
		if (boardType == "normal") {
			generateBoardTitle(itemInfo, relatedList, dlElmt);
			generateRelatedModuleContent(itemInfo, attachList, null, null);
		}
		else {
			generateBoardTitle(itemInfo, relatedList, dlElmt);
			generatePhotoContent(itemInfo, attachList);
		}
	}
	
	function generatePhotoContent(itemInfo, attachList) {
		var totalFiles       = attachList.length;
		var iframeId         = crrPreMode == "w" ? "mainContentIframeW" : "mainContentIframeH";
		var ifameContent     = document.getElementById(iframeId);
		ifameContent.src     = "/ezCabinet/getPreviewPhoto.do";
		documentCont         = {};
		documentCont.attach  = attachList;
	}
	
	function generateBoardTitle(itemInfo, relatedList, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
	}
	
	function generateRelatedModuleContent(itemInfo, attachList, moduleName, moduleType) {
		var totalFiles       = attachList.length;
		var iframeId         = crrPreMode == "w" ? "mainContentIframeW" : "mainContentIframeH";
		var ifameContent     = document.getElementById(iframeId);
		var moreparams       = moduleName ? "?module=" + moduleName : "";
		ifameContent.src     = "/ezCabinet/getPreviewContent.do" + moreparams;
		documentCont         = {};
		documentCont.content = itemInfo["contentPath"];
		documentCont.size    = itemInfo["itemSize"];
		documentCont.attach  = attachList;
		
		if (moduleType) {documentCont.type  = moduleType}
	}
	
	function showOptionPreview(data, dlElmt) {
		var itemInfo    = data.fileDetail;
		var attachList  = data.attachFileList;
		var relatedList = data.relatedFileList;
		var writer      = data.writerVO;
		
		generateOptionTitle(itemInfo, relatedList, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, null, null);
	}
	
	function generateOptionTitle(itemInfo, relatedList, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
	}
	
	function showCommunityPreview(data, dlElmt) {
		var itemInfo    = data.fileDetail;
		var attachList  = data.attachFileList;
		var relatedList = data.relatedFileList;
		var writer      = data.writerVO;
		
		generateCommunityTitle(itemInfo, relatedList, dlElmt);
		generateRelatedModuleContent(itemInfo, attachList, null, null);
	}
	
	function generateCommunityTitle(itemInfo, relatedList, dlElmt) {
		var creatorName = itemInfo["creatorName"];
		var creatorId   = itemInfo["creatorId"];
		
		//Creator title
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		//Related documents title
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
	}
	
	function generateCreatorTitle(dlElmt, creatorName, creatorId) {
		var dtElmt       = document.createElement("dt");
		var ddElmt       = document.createElement("dd");
		var spanElmt     = document.createElement("span");
		dtElmt.textContent   = CabinetMessages.strCreator + ": ";
		spanElmt.className   = "txtSpan";
		spanElmt.textContent = creatorName;
		spanElmt.addEventListener("click", function(e) {showUserInfoFromId(creatorId);}, false);
		ddElmt.appendChild(spanElmt);
		dlElmt.appendChild(dtElmt);
		dlElmt.appendChild(ddElmt);
	}
	
	function generateColumnTitle(dlElmt, itemColumn) {
		var dtElmt           = document.createElement("dt");
		var ddElmt           = document.createElement("dd");
		var spanElmt         = document.createElement("span");
		dtElmt.textContent   = itemColumn["columnName"] + ": ";
		spanElmt.textContent = itemColumn["columnValue"];
		ddElmt.appendChild(spanElmt);
		dlElmt.appendChild(dtElmt);
		dlElmt.appendChild(ddElmt);
	}
	
	function generateRelatedListTitle(dlElmt, relatedList) {
		var totalCnt = relatedList.length;
		var dtElmt2  = document.createElement("dt");
		var ddElmt2  = document.createElement("dd");
		dtElmt2.textContent = CabinetMessages.strRelated + ": ";
		
		if (totalCnt == 1) {
			var spanElmt = document.createElement("span");
			spanElmt.textContent = relatedList[0]["title"];
			spanElmt.setAttribute("title",  relatedList[0]["title"]);
			spanElmt.className   = "txtSpan";
			spanElmt.onclick     = function(e) {readRelatedItem(relatedList[0]["relatedItemId"], relatedList[0]["useStatus"]);};
			ddElmt2.appendChild(spanElmt);
		}
		else {
			var spanElmt1 = document.createElement("span");
			var spanElmt2 = document.createElement("span");
			var spanElmt3 = document.createElement("span");
			var pElmt     = document.createElement("p");
			
			spanElmt1.onclick     = function(e) {readRelatedItem(relatedList[0]["relatedItemId"], relatedList[0]["useStatus"]);};
			spanElmt1.setAttribute("title",  relatedList[0]["title"]);
			spanElmt1.textContent = relatedList[0]["title"];
			spanElmt1.className   = "txtSpan";
			spanElmt2.textContent = " (" + CabinetMessages.strTotal + " " + totalCnt + CabinetMessages.strItem + ")";
			spanElmt3.className   = "icDown";
			spanElmt3.addEventListener("click", function(e) {showRelatedList(this);}, false);
			pElmt.className       = "relateList hide";
			
			for (var i = 0; i < totalCnt; i++) {
				var spanChild = document.createElement("span");
				spanChild.className   = "txtSpan";
				spanChild.textContent = relatedList[i]["title"];
				spanChild.setAttribute("title",  relatedList[i]["title"]);
				spanChild.onclick     = (function(itemId, useStatus) {return function() {readRelatedItem(itemId, useStatus);};})(relatedList[i]["relatedItemId"], relatedList[i]["useStatus"]);
				pElmt.appendChild(spanChild);
				
				if (i != totalCnt - 1) {
					var divideEm         = document.createElement("em");
					divideEm.textContent = "; ";
					pElmt.appendChild(divideEm);
				}
			}
			
			ddElmt2.appendChild(spanElmt1);
			ddElmt2.appendChild(spanElmt2);
			ddElmt2.appendChild(spanElmt3);
			ddElmt2.appendChild(pElmt);
		}
		
		dlElmt.appendChild(dtElmt2);
		dlElmt.appendChild(ddElmt2);
	}
	
	function generalItemTitle(relatedList, creatorName, creatorId, summary, dlElmt) {
		generateCreatorTitle(dlElmt, creatorName, creatorId);
		
		if (summary && summary.replace(/\s/g,'')) {
			var sDtElmt         = document.createElement("dt");
			var sDdElmt         = document.createElement("dd");
			sDtElmt.textContent = CabinetMessages.strSummary + ": ";
			sDdElmt.textContent = summary;
			dlElmt.appendChild(sDtElmt);
			dlElmt.appendChild(sDdElmt);
		}
		
		if(relatedList && relatedList.length > 0) {generateRelatedListTitle(dlElmt, relatedList);}
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
			spanElmt.textContent = CabinetMessages.strNoAttach;
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
		
		var storageDiv          = document.createElement("div");
		storageDiv.className    = "storageDiv";
		var storageSpan         = document.createElement("span");
		storageSpan.textContent = CabinetMessages.strStorage + getFileSize(itemSize);
		storageDiv.appendChild(storageSpan);
		fileWrap.appendChild(storageDiv);
	}
	
	function downloadFileAttach(fileName, filePath) {
		var downloadUrl = "/ezCabinet/downloadAttachFile?filePath=" + encodeURIComponent(filePath) + "&fileName=" + encodeURIComponent(fileName);
		var attachFrame = document.getElementById("attachFrame");
		attachFrame.src = downloadUrl;
	}
	
	function showRelatedList(spanElmt) {
		var currentClass = spanElmt.className;
		var pElmt        = spanElmt.nextElementSibling;
		if (currentClass == "icDown") {
			spanElmt.className = "icUp";
			pElmt.className    = "relateList";
		}
		else {
			spanElmt.className = "icDown";
			pElmt.className    = "relateList hide";
		}
	}
	
	function readRelatedItem(itemId, useStatus) {
		if(useStatus == 0) {alert(CabinetMessages.strNoRelated); return;}
		openFileDetail(itemId);
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
			case "jpeg" : imgCheck = true                               ; break;
			case "pdf"  : urlImg   = "/images/cabinet/pdf.png"          ; break;
			case "ppt"  : urlImg   = "/images/cabinet/msPowerpoint.png" ; break;
			case "pptx" : urlImg   = "/images/cabinet/pptx.png"         ; break;
			case "doc"  : urlImg   = "/images/cabinet/msWord.png"       ; break;
			case "docx" : urlImg   = "/images/cabinet/docx.png"         ; break;
			case "xls"  : urlImg   = "/images/cabinet/msExcel.png"      ; break;
			case "xlsx" : urlImg   = "/images/cabinet/xlsx.png"         ; break;
			case "hwp"  : urlImg   = "/images/cabinet/hwp.png"          ; break;
			case "txt"  : urlImg   = "/images/cabinet/txt.png"          ; break;
			case "mp4"  : urlImg   = "/images/cabinet/mp4.png"          ; break;
			case "flv"  : urlImg   = "/images/cabinet/flv.png"          ; break;
			case "mkv"  : urlImg   = "/images/cabinet/mkv.png"          ; break;
			case "iso"  : urlImg   = "/images/cabinet/iso.png"          ; break;
			case "rar"  : urlImg   = "/images/cabinet/rar.png"          ; break;
			default     : urlImg   = "/images/cabinet/unknown.png"      ; break;
		}
		
		return {
			isImage  : imgCheck,
			urlImage : urlImg
		};
	}
	
	function showUserInfoFromEmail(userMail) {
		var feature = "height=500px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
		feature = feature + getOpenWindowfeature(420, 500);
		userWindow = window.open("/ezCommon/showPersonInfo.do?email=" + encodeURIComponent(userMail), "userInfo", feature);
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
			case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2) + "MB"   ; break;
			case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2) + "KB"      ; break;
		}
		return result;
	}
	
	function closeAllPopups() {
		if(itemPopup)  {itemPopup.close();}
		if(sharePopup) {sharePopup.close();}
		if(addPopup)   {addPopup.close();}
		if(userWindow) {userWindow.close();}
	}
	
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
				
				alert(CabinetMessages.strError);
			}
		});
	}
	
	return {
		start      : initEvents,
		reload     : refreshAllFrames,
		getContent : getIframeContent
	};
}();
