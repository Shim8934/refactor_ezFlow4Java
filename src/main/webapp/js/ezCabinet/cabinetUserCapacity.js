(function() {
	var cabinetTable = null;
	var cabinetNavi  = null;
	var searchStr    = "";
	var searchOpt    = "";
	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	initEvents();
	startSearch(1);
	preProcessing();
	
	function keyPress(e)    {if (e.which == 27) {if (document.getElementById("searchPanel").className == "cabSearchPanel2") {toggleSearchPanel();}}}
	function isValid(value) {if (!isNaN(value) && parseFloat(value) > 0) {return true;} else {return false;}}
	function windowResize() {closeViewPopUp(); preProcessing();}
	
	function preProcessing() {
		var divList           = document.getElementById("mainSetting");
		var divChild          = divList.querySelector("div[class='tableDataDiv']");
		var reheight          = document.documentElement.clientHeight - 220;
		divChild.style.height = reheight + "px";
		divList.style.height  = "auto";
	}
	
	function initEvents() {
		document.onselectstart = function() {return false;};
		window.addEventListener("resize", function(e) {windowResize();}, false);
		window.addEventListener("keydown", function(e) {keyPress(e);}, false);
		
		var libttns = document.getElementById("mainmenu").firstElementChild.children;
		libttns[0].firstElementChild.onclick  = function(e) {refreshPage();};
		libttns[1].firstElementChild.onclick  = function(e) {toggleSearchPanel();};
		libttns[2].firstElementChild.onclick  = function(e) {onOpenChangePanel();};
		
		var cabdivBttnElmt      = document.getElementById("searchDivBttn");
		var listBttns           = cabdivBttnElmt.children;
		listBttns[0].onclick    = function(e) {onStartSearch();};
		listBttns[1].onclick    = function(e) {toggleSearchPanel();};
		
		var cabChgBttnElmt      = document.getElementById("chgDivBttn");
		var chglistBttns        = cabChgBttnElmt.children;
		chglistBttns[0].onclick = function(e) {changeCapacity();};
		chglistBttns[1].onclick = function(e) {toggleChangePanel();};
		
		var cabChgCloseBttn     = document.getElementById("cabPChClose").firstElementChild.firstElementChild.firstElementChild;
		cabChgCloseBttn.onclick = function(e) {toggleChangePanel();};
		
		var radioBttns = document.getElementsByName("capType");
		for (var i = 0, len = radioBttns.length; i < len; i++) {
			radioBttns[i].onchange = function(e) {changeCapacityType(this)};
		}
		
		document.getElementById("sltView").addEventListener("click", function(e) {toggleOptionView(this);}, false);
		document.getElementsByClassName("cabCloseBttn")[0].addEventListener("click", function(e) {toggleSearchPanel();}, false);
		document.getElementById("listcount").addEventListener("change", function(e) {startSearch(1);}, false);
		document.getElementById("companyList").addEventListener("change", function(e) {clearAllParamAndRefresh();}, false);
		
		//Set table view
		cabinetTable = new CabinetTable({
			normal   : "bnkCabNormal",
			selected : "bnkCabSelect"
		});
		
		cabinetTable.setTableElement("userCapacityTbl", "id");
		cabinetTable.setTableType("capacity");
		cabinetTable.setCallBack(refreshPage);
		cabinetTable.setRenderFunct(renderCapacityTable);
		
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
			headerId : "cabinetTtlInf",
			callback : startSearch
		});
	}
	
	function onStartSearch() {
		var inputVal = document.getElementById("inputSearch").value;
		
		if (!inputVal.replace(/\s/g,'')) {
			alert(CabinetMessages.strNoInput);
			document.getElementById("inputSearch").value = "";
			document.getElementById("inputSearch").focus;
			return;
		}
		
		searchStr = inputVal;
		searchOpt = document.getElementById("searchOption").value;
		toggleSearchPanel();
		startSearch(1);
	}
	
	function onOpenChangePanel() {
		var checkedList = getSelectedRowsInfo();
		if (checkedList == null) {alert(CabinetMessages.strNoUser); return;}
		toggleChangePanel();
	}
	
	function changeCapacity() {
		var checkedList  = getSelectedRowsInfo();
		var userIdList   = checkedList["userList"];
		var amountList   = checkedList["usedAmountList"];
		var capacityType = document.querySelector('input[name="capType"]:checked').getAttribute("role");
		var newCapacity  = "";
		var basicElmt    = document.getElementById("basicValue");
		
		if (capacityType == "limit") {
			newCapacity = basicElmt.value;
			if (!isValid(newCapacity)) {alert(CabinetMessages.strInvalid); basicElmt.value = ""; basicElmt.focus(); return;}
			
			for (var i = 0; i < amountList.length; i++) {
				if (parseFloat(amountList[i]) > parseFloat(newCapacity) * 1048576) {alert(CabinetMessages.strOverUsed); return;}
			}
		}
		
		var url  = "/admin/ezCabinet/saveUserCapacity.do";
		var data = {
			type      : capacityType == "limit" ? "1" : "0",
			capacity  : newCapacity,
			userList  : userIdList.toString(),
			companyId : document.getElementById("companyList").value
		};
		
		makeAjaxCall(data, "GET", url, afterChangeCapacity, null, true);
	}
	
	function afterChangeCapacity(data) {
		var code = data.code;
		switch(code) {
			case 0 : changeCapacitySuccess();            break;
			case 1 : alert(CabinetMessages.strParamErr); break;
			case 2 : alert(CabinetMessages.strError);    break;
			default: alert(CabinetMessages.strError);    return; 
		}
	}
	
	function getSelectedRowsInfo() {
		var listOfSelectedRows = document.getElementsByClassName("bnkCabSelect");
		var userList       = [];
		var usedAmountList = [];
		if (listOfSelectedRows.length == 0) {
			return null;
		}
		
		for (var i = 0; i < listOfSelectedRows.length; i++) {
			userList.push(listOfSelectedRows[i].getAttribute("userId"));
			usedAmountList.push(listOfSelectedRows[i].getAttribute("usedAmount"));
		}
		
		return {userList: userList, usedAmountList: usedAmountList};
	}
	
	function toggleSearchPanel() {
		var searchPanel = document.getElementById("searchPanel");
		
		if (searchPanel.className == "cabSearchPanel2 off") {
			addFogPanel("search");
			var position            = getPosition(500, 148);
			searchPanel.style.top   = position[0] + "px";
			searchPanel.style.right = position[1] + "px";
			searchPanel.className   = "cabSearchPanel2";
		}
		else {
			removeFogPanel();
			searchPanel.className   = "cabSearchPanel2 off";
		}
		
		document.getElementById("inputSearch").value                = "";
		document.getElementById("searchOption").options[0].selected = 'selected';
	}
	
	function toggleChangePanel() {
		var rightFrame  = window.parent.frames["right"].document;
		var changePanel = rightFrame.getElementById("perSettingPanel");
		if (changePanel.className == "popup cabChgoff") {
			addFogPanel("change");
			var position            = getPosition(320, 186);
			changePanel.style.top   = position[0] + "px";
			changePanel.style.right = position[1] + "px";
			changePanel.className   = "popup cabChgon";
		}
		else {
			removeFogPanel();
			changePanel.className   = "popup cabChgoff";
		}
		
		document.getElementById("basicValue").value                           = "";
		document.querySelector("input[name='capType'][role='limit']").checked = true;
	}
	
	function addFogPanel(mode) {
		var handleClickFunct = null;
		
		switch(mode) {
			case "search": handleClickFunct = toggleSearchPanel; break;
			case "change": handleClickFunct = toggleChangePanel; break;
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
		
		leftFrame.body.style.overflow = "auto";
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
	
	function startSearch(pPage) {
		var orderInf = cabinetTable.getOrderInfo();
		var url      = "/admin/ezCabinet/getUserCapacity.do";
		var data     = {
			"currentPage" : pPage,
			"searchStr"   : searchStr,
			"searchOpt"   : searchOpt,
			"column"      : orderInf.col ? orderInf.col : "",
			"order"       : orderInf.ord ? orderInf.ord : "",
			"listCnt"     : document.getElementById("listcount").value,
			"companyId"   : document.getElementById("companyList").value
		};
		
		makeAjaxCall (data, "GET", url, checkingData, null, true);
	}
	
	function checkingData(data) {
		var code = data.code;
		switch(code) {
			case 0 : processData(data);                  break;
			case 1 : alert(CabinetMessages.strParamErr); break;
			case 2 : alert(CabinetMessages.strError);    break;
			default: alert(CabinetMessages.strError);    return; 
		}
	}
	
	function processData(data) {
		cabinetTable.setDataSource(data.capacity);
		cabinetTable.renderTable();
		cabinetNavi.init(data.currentPage, data.totalUsers, data.totalPages);
	}
	
	function renderCapacityTable(capacityList, unselectClass, tableDataElmt, getCheckedFunct, clickRowFunct) {
		if (capacityList == null || capacityList.length == 0) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			tdElmt.setAttribute("colspan", "9");
			tdElmt.setAttribute("align", "center");
			tdElmt.setAttribute("bgcolor", "#FFFFFF");
			tdElmt.innerHTML = CabinetMessages.strNoData;
			
			trElmt.appendChild(tdElmt);
			tableDataElmt.appendChild(trElmt);
		}
		else {
			var len = capacityList.length;
			for (var i = 0; i < len; i++) {
				var trElmt  = document.createElement("tr");
				var tdElmt1 = document.createElement("td");
				var tdElmt2 = document.createElement("td");
				var tdElmt3 = document.createElement("td");
				var tdElmt4 = document.createElement("td");
				var tdElmt5 = document.createElement("td");
				var tdElmt6 = document.createElement("td");
				var tdElmt7 = document.createElement("td");
				var tdElmt8 = document.createElement("td");
				var tdElmt9 = document.createElement("td");
				
				trElmt.setAttribute("class", unselectClass);
				trElmt.setAttribute("usedAmount", capacityList[i]["totalUsed"]);
				trElmt.setAttribute("userId", capacityList[i]["userId"]);
				trElmt.onclick = function(event) {clickRowFunct(event);};
				
				var inputElmt  = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				inputElmt.onclick = function(event) {getCheckedFunct(event);};
				tdElmt1.className = "checkBnk";
				tdElmt1.appendChild(inputElmt);
				
				tdElmt2.textContent = capacityList[i]["companyName"];
				tdElmt2.setAttribute("title", tdElmt2.textContent);
				
				tdElmt3.textContent = capacityList[i]["departmentName"];
				tdElmt3.setAttribute("title", tdElmt3.textContent);
				
				tdElmt4.textContent = capacityList[i]["userName"];
				tdElmt4.setAttribute("title", tdElmt4.textContent);
				
				tdElmt5.textContent = capacityList[i]["jobTitle"];
				tdElmt5.setAttribute("title", tdElmt5.textContent);
				
				tdElmt6.textContent = getFileSize(capacityList[i]["totalUsed"]);
				tdElmt7.textContent = capacityList[i]["capacityType"] == 0 ? "-" : capacityList[i]["totalCapacity"] + "MB";
				tdElmt8.textContent = capacityList[i]["capacityType"] == 0 ? "무제한" : "제한";
				
				var span        = document.createElement("span");
				span.className  = "workProgressBar";
				span.innerHTML += "<span class='bar' usedrate='rategrogressBar" + i + "'></span>&nbsp;";
				
				var span2           = document.createElement("span");
				span2.style.display = "inline-block";
				span.appendChild(span2);
				tdElmt9.appendChild(span);
				
				tdElmt1.className = "checkBnk";
				tdElmt2.className = "cabTd8 cabTxtOver";
				tdElmt3.className = "cabTd8 cabTxtOver";
				tdElmt4.className = "cabTd8 cabTxtOver";
				tdElmt5.className = "cabTd6 cabTxtOver";
				tdElmt6.className = "cabTd7 cabCenter";
				tdElmt7.className = "cabTd7 cabCenter";
				tdElmt8.className = "cabTd8 cabCenter";
				tdElmt9.className = "cabTd8 cabCenter cabTxtOver";
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt3);
				trElmt.appendChild(tdElmt4);
				trElmt.appendChild(tdElmt5);
				trElmt.appendChild(tdElmt6);
				trElmt.appendChild(tdElmt7);
				trElmt.appendChild(tdElmt8);
				trElmt.appendChild(tdElmt9);
				tableDataElmt.appendChild(trElmt);
				
				initProgressBar("rategrogressBar" + i, "3", capacityList[i]["usedRate"]);
			}
		}
	}
	
	function initProgressBar(barID, color, completerate) {
		completerate = completerate > 100 ? 100 : completerate;
		duration     = completerate == '0' ? 0 : 500;
		
		if (color == '1') {
			$(".bar[usedrate='" + barID + "']").find("div[class=percentCount]").css("color", delayColor);
			$(".bar[usedrate='" + barID + "']").LineProgressbar({
				percentage: completerate,
				fillBackgroundColor: delayColor,
				backgroundColor: '#EEEEEE',
				radius: '10px',
				height: '10px',
				width: '70%',
				duration : duration
			});
		}
		else if (color == '2') {
			$(".bar[usedrate='" + barID + "']").LineProgressbar({
				percentage: completerate,
				fillBackgroundColor: completeColor,
				backgroundColor: '#EEEEEE',
				radius: '10px',
				height: '10px',
				width: '70%',
				duration : duration
			});
		}
		else {
			$(".bar[usedrate='" + barID + "']").LineProgressbar({
				percentage: completerate,
				fillBackgroundColor: '#3498db',
				backgroundColor: '#EEEEEE',
				radius: '10px',
				height: '10px',
				width: '70%',
				duration : duration
			});
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
	
	function refreshPage() {
		var crrPage = cabinetNavi.get().currentPage;
		crrPage     = crrPage ? crrPage : 1;
		startSearch(crrPage);
	}
	
	function clearAllParamAndRefresh() {
		searchStr = "";
		searchOpt = "";
		startSearch(1);
	}
	
	function getUserCapacities() {
		var url  = "/admin/ezCabinet/getCompanyCapacity.do";
		var data = {companyId : document.getElementById("companyList").value};
		makeAjaxCall(data, "GET", url, processData, null, true);
	}
	
	function changeCapacitySuccess()       {alert(CabinetMessages.strSave); refreshPage(); toggleChangePanel();}
	function toggleOptionView(optElmt)     {if (optElmt.getAttribute("role") == "off") {showViewPopUp();} else {closeViewPopUp();}}
	function changeCapacityType(radioElmt) {changeBttnStatus(radioElmt.getAttribute("role"));}
	
	function changeBttnStatus(capacityType) {
		var inputElmt      = document.getElementById("basicValue");
		inputElmt.value    = "";
		inputElmt.disabled = capacityType == "unlimit" ? true : false;
	}
	
	function showViewPopUp() {
		var optElmt             = document.getElementById("sltView");
		var viewPopup           = document.getElementById("layerPopup");
		viewPopup.style.left    = document.documentElement.clientWidth - 160 + "px";
		viewPopup.style.top     = "128px";
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
	
	function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode) {
		$.ajax({
			type: ajaxType,
			url: ajaxUrl,
			data: ajaxData,
			dataType: "JSON",
			async: asyncMode != false ? true : false,
			success : function(data) {
				handleSuccess(data);
			},
			error : function(error) {
				if (handleError != null) {handleError();}
				
				alert(CabinetMessages.strError);
			}
		});
	}
})();