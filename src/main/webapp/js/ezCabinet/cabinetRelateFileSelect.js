var CabinetRlFileSelect = function() {
	var cabinetId     = null;
	var cabCrrItemId  = null;
	var searchTtl     = "";
	var searchMode    = "normal";
	var cabinetNavi   = null;
	var module        = null;
	var cabinetTree   = new CabinetTree();
	var fileTable     = new CabinetTable({
		normal   : "bnkCabNormal",
		selected : "bnkCabSelect",
		mode     : "normal",
		render   : renderFileList
	});
	var selectedFiles = new CabinetTable({
		normal   : "bnkCabNormal",
		selected : "bnkCabSelect",
		mode     : "received",
		dblclick : removeFile
	});
	
	function initEvents(itemid, moduleName) {
		module                 = moduleName;
		cabCrrItemId           = itemid;
		document.onselectstart = function() {return false;};
		var closeBttn          = document.getElementById("cabRlClose").firstElementChild.firstElementChild.firstElementChild;
		closeBttn.onclick      = function(e) {closeWindow();};
		
		var cabRlBttnElmt      = document.getElementById("cabRlBttn");
		var listRlBttns        = cabRlBttnElmt.children;
		listRlBttns[0].onclick = function(e) {saveRelatedFiles();};
		listRlBttns[1].onclick = function(e) {closeWindow();};
		document.getElementById("addBttn").onclick    = function(e) {addFiles();};
		document.getElementById("removeBttn").onclick = function(e) {removeFiles();};
		
		var sSearchInputElmt   = document.getElementById("ssInput");
		sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
		sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
		
		var searchBttnElmt = document.getElementById("searchBttn");
		searchBttnElmt.addEventListener("click", function(e) {startSimpleSearch();}, false);
		
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
			callback : searchItem
		});
		
		cabinetNavi.setBlock(3);
		
		cabinetTree.setTreeInfo({
			treeId     : "cabinetTree",
			treeType   : "cabinet",
			type       : "list",
			initialUrl : "/ezCabinet/getAllCabinetTree.do",
			extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
			click      : getAllItems,
			dblClick   : null
		});
		
		cabinetTree.makeTree();
		
		//Set file tables 
		fileTable.setTableType("files");
		fileTable.setTableElement("tableFiles", "id");
		
		//Set selected tables 
		selectedFiles.setTableElement("selectedTable", "id");
		
		setSelectedItem();
	}
	
	function setSelectedItem() {
		var parentWd    = window.opener;
		var selectedArr = null;
		
		switch (module) {
			case "normal" : if (parentWd && parentWd.CabinetItemDetail)    {selectedArr = parentWd.CabinetItemDetail.get()    ;} break;
			case "mail"   : if (parentWd && parentWd.CabinetEmailFile)     {selectedArr = parentWd.CabinetEmailFile.get()     ;} break;
			case "apprv"  : if (parentWd && parentWd.CabinetApprovalFile)  {selectedArr = parentWd.CabinetApprovalFile.get()  ;} break;
			case "board"  : if (parentWd && parentWd.CabinetBoardFile)     {selectedArr = parentWd.CabinetBoardFile.get()     ;} break;
			case "option" : if (parentWd && parentWd.CabinetOptionFile)    {selectedArr = parentWd.CabinetOptionFile.get()    ;} break;
			case "commu"  : if (parentWd && parentWd.CabinetCommunityFile) {selectedArr = parentWd.CabinetCommunityFile.get() ;} break;
			case "gaddr"  : if (parentWd && parentWd.CabinetGroupAddress)  {selectedArr = parentWd.CabinetGroupAddress.get()  ;} break;
			case "naddr"  : if (parentWd && parentWd.CabinetNormalAddress) {selectedArr = parentWd.CabinetNormalAddress.get() ;} break;
			case "resrc"  : if (parentWd && parentWd.CabinetResourceFile)  {selectedArr = parentWd.CabinetResourceFile.get()  ;} break;
			case "schedl" : if (parentWd && parentWd.CabinetScheduleFile)  {selectedArr = parentWd.CabinetScheduleFile.get()  ;} break;
			case "todo"   : if (parentWd && parentWd.CabinetTodoFile)      {selectedArr = parentWd.CabinetTodoFile.get()      ;} break;
			case "jounl"  : if (parentWd && parentWd.CabinetJournalFile)   {selectedArr = parentWd.CabinetJournalFile.get()   ;} break;
			case "photo"  : if (parentWd && parentWd.CabinetBoardPhoto)    {selectedArr = parentWd.CabinetBoardPhoto.get()    ;} break;
			default       : if (parentWd && parentWd.CabinetAddFile)       {selectedArr = parentWd.CabinetAddFile.get()       ;}
		}
		
		if (selectedArr != null && selectedArr.length != 0) {
			var tableElmt = document.getElementById("selectedTable");
			for (var i = 0, len = selectedArr.length; i < len; i++) {
				var item    = selectedArr[i];
				var trElmt  = document.createElement("tr");
				var tdElmt1 = document.createElement("td");
				var tdElmt2 = document.createElement("td");
				var spMName = document.createElement("span");
				spMName.textContent = getModuleName(item["itemType"]);
				tdElmt1.appendChild(spMName);
				tdElmt2.textContent = item["itemTitle"];
				tdElmt2.setAttribute("title", item["itemTitle"]);
				tdElmt2.className   = "tdLeft";
				trElmt.setAttribute("role", item["itemId"]);
				trElmt.setAttribute("type", item["itemType"]);
				trElmt.className = "bnkCabNormal";
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				
				tableElmt.appendChild(trElmt);
			}
			
			selectedFiles.resetEvents();
		}
	}
	
	function saveRelatedFiles() {
		var data      = [];
		var tableElmt = document.getElementById("selectedTable");
		var trList    = tableElmt.rows;
		
		for (var i = 1, len = trList.length; i < len; i++) {
			var itemId    = trList[i].getAttribute("role");
			var itemType  = trList[i].getAttribute("type");
			var itemTitle = trList[i].lastElementChild.getAttribute("title");
			data.push({
				itemId    : itemId,
				itemType  : itemType,
				itemTitle : itemTitle
			});
		}
		
		var parentWd = window.opener;
		
		switch (module) {
			case "normal" : if (parentWd && parentWd.CabinetItemDetail)    {parentWd.CabinetItemDetail.save(data)   ;} break;
			case "mail"   : if (parentWd && parentWd.CabinetEmailFile)     {parentWd.CabinetEmailFile.save(data)    ;} break;
			case "apprv"  : if (parentWd && parentWd.CabinetApprovalFile)  {parentWd.CabinetApprovalFile.save(data) ;} break;
			case "board"  : if (parentWd && parentWd.CabinetBoardFile)     {parentWd.CabinetBoardFile.save(data)    ;} break;
			case "option" : if (parentWd && parentWd.CabinetOptionFile)    {parentWd.CabinetOptionFile.save(data)   ;} break;
			case "commu"  : if (parentWd && parentWd.CabinetCommunityFile) {parentWd.CabinetCommunityFile.save(data);} break;
			case "gaddr"  : if (parentWd && parentWd.CabinetGroupAddress)  {parentWd.CabinetGroupAddress.save(data) ;} break;
			case "naddr"  : if (parentWd && parentWd.CabinetNormalAddress) {parentWd.CabinetNormalAddress.save(data);} break;
			case "resrc"  : if (parentWd && parentWd.CabinetResourceFile)  {parentWd.CabinetResourceFile.save(data) ;} break;
			case "schedl" : if (parentWd && parentWd.CabinetScheduleFile)  {parentWd.CabinetScheduleFile.save(data) ;} break;
			case "todo"   : if (parentWd && parentWd.CabinetTodoFile)      {parentWd.CabinetTodoFile.save(data)     ;} break;
			case "jounl"  : if (parentWd && parentWd.CabinetJournalFile)   {parentWd.CabinetJournalFile.save(data)  ;} break;
			case "photo"  : if (parentWd && parentWd.CabinetBoardPhoto)    {parentWd.CabinetBoardPhoto.save(data)   ;} break;
			default       : if (parentWd && parentWd.CabinetAddFile)       {parentWd.CabinetAddFile.save(data)      ;}
		}
		
		closeWindow();
	}
	
	function getAllItems(nodeElmt) {
		document.getElementById("bnkDivMain").textContent = nodeElmt.textContent;
		cabinetId = nodeElmt.getAttribute("role");
		searchMode = "normal";
		searchItem("1");
	}
	
	function searchItem(page) {
		var url  = "";
		var data = null;
		
		switch(searchMode) {
			case "normal" : url  = "/ezCabinet/getCabinetFiles.do";
							data = {cabinetId : cabinetId, currentPage : page};
							makeAjaxCall(data, "GET", url, afterGetData, null, true, null);
							break;
			case "search" : url  = "/ezCabinet/getFilesBySearching.do";
							data = {title : searchTtl, currentPage : page};
							makeAjaxCall(data, "POST", url, afterGetData, null, true, null);
							break;
		}
	}
	
	function afterGetData(data) {
		var code = data.code;
		switch(code) {
			case 0 : getDataSuccessfully(data); break;
			case 1 : alert(CabinetMessages.strParamErr); break;
			case 2 : alert(CabinetMessages.strError)   ; break;
			case 3 : alert(CabinetMessages.strPerm)    ; break;
			default: alert(CabinetMessages.strError)   ; return; 
		}
	}
	
	function getDataSuccessfully(data) {
		cabinetNavi.init(data.currentPage, data.totalRows, data.totalPages);
		fileTable.setDataSource(data.itemList);
		fileTable.renderTable();
	}
	
	function renderFileList(itemList, unselectClass, tableElmt, clickRow) {
		if (itemList == null || itemList.length == 0) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			tdElmt.setAttribute("colspan", "2");
			tdElmt.setAttribute("style", "text-align: center; background-color: #fff;");
			tdElmt.innerHTML = CabinetMessages.strNoData;
			
			trElmt.appendChild(tdElmt);
			tableElmt.appendChild(trElmt);
		}
		else {
			var len = itemList.length;
			for (var i = 0; i < len; i++) {
				var trElmt  = document.createElement("tr");
				var tdElmt1 = document.createElement("td");
				var tdElmt2 = document.createElement("td");
				var sMdName = document.createElement("span");
				sMdName.textContent = getModuleName(itemList[i]["itemType"]);
                if (document.getElementById("userLang").value == 6) {
                    sMdName.setAttribute("title", getModuleName(itemList[i]["itemType"]));
                }

                tdElmt1.appendChild(sMdName);
				tdElmt2.textContent = itemList[i]["title"];
				tdElmt2.setAttribute("title", itemList[i]["title"]);
				tdElmt2.className   = "tdLeft";
				trElmt.setAttribute("role", itemList[i]["itemId"]);
				trElmt.setAttribute("type", itemList[i]["itemType"]);
				trElmt.className = unselectClass;
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.addEventListener("click", function(e) {clickRow(e);}, false);
				trElmt.addEventListener("dblclick", function(e) {addFile(this, "one")}, false);
				
				tableElmt.appendChild(trElmt);
			}
		}
	}
	
	function addFile(trElmt, mode) {
		var selectedTable = document.getElementById("selectedTable");
		var itemId        = trElmt.getAttribute("role");
		var checkElmt     = selectedTable.querySelector("tr[role='" + itemId + "']");
		
		if (cabCrrItemId && cabCrrItemId == itemId) {if(mode) {alert(CabinetMessages.strSame);} return;}
		
		if (checkElmt) {if(mode) {alert(CabinetMessages.strExist);} return;}
			
		var cloneTr       = trElmt.cloneNode(true);
		cloneTr.className = "bnkCabNormal";
		selectedTable.appendChild(cloneTr);
		selectedFiles.resetEvents();
	}
	
	function addFiles() {
		var listTableElmt  = document.getElementById("tableFiles");
		var selectedTrList = listTableElmt.querySelectorAll("tr[class='bnkCabSelect']");
		
		for (var i = 0, len = selectedTrList.length; i < len; i++) {
			addFile(selectedTrList[i]);
		}
	}
	
	function removeFile(trElmt) {
		var selectedTable = document.getElementById("selectedTable");
		selectedTable.removeChild(trElmt);
	}
	
	function removeFiles() {
		var selectedTblElmt = document.getElementById("selectedTable");
		var selectedTrList  = selectedTblElmt.querySelectorAll("tr[class='bnkCabSelect']");
		
		for (var i = 0, len = selectedTrList.length; i < len; i++) {
			removeFile(selectedTrList[i]);
		}
	}
	
	function getModuleName(moduleType) {
		var result = "";
		
		switch(parseInt(moduleType)) {
			case 0 : result = CabinetMessages.strNormal ; break;
			case 1 : result = CabinetMessages.strEmail  ; break;
			case 2 : result = CabinetMessages.strApprv  ; break;
			case 3 : result = CabinetMessages.strBoard  ; break;
			case 4 : result = CabinetMessages.strSchedl ; break;
			case 5 : result = CabinetMessages.strTodo   ; break;
			case 6 : result = CabinetMessages.strOption ; break;
			case 7 : result = CabinetMessages.strCommu  ; break;
			case 8 : result = CabinetMessages.strAddrs  ; break;
			case 9 : result = CabinetMessages.strJournal; break;
			case 10: result = CabinetMessages.strProjt  ; break;
			case 11: result = CabinetMessages.strResrc  ; break;
		}
		
		return result;
	}
	
	function onStartSimpleSearch(event) {if(event.keyCode == "13") {startSimpleSearch();}}
	
	function startSimpleSearch() {
		var searchStr = document.getElementById("ssInput").value;
		if (!searchStr.replace(/\s/g,'')) {alert(CabinetMessages.strNoInput); return;}
		document.getElementById("bnkDivMain").textContent = CabinetMessages.strResult;
		searchTtl  = searchStr;
		searchMode = "search";
		searchItem("1");
	}
	
	function clearKeyword(inputElmt) {inputElmt.value = "";}
	
	function closeWindow() {window.close();}
	
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
				
				alert(CabinetMessages.strError);
			}
		});
	}
	
	return {init : initEvents};
}();