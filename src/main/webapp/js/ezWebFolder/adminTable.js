//Baonk 2018/04/26

function TableView() {
	//set public functions
	this.setTableId       = setTableId;
	this.setSelectedClass = setSelectedClass;
	this.setUnselectClass = setUnselectClass;
	this.setDataSource    = setDataSource;
	this.setTableType     = setTableType;
	this.renderTable      = renderTable;
	
	//private variables
	var _tableId         = null;
	var _selectedClass   = "";
	var _unselectClass   = "";
	var _lastSelectedRow = null;
	var _dataSource      = "";
	var _tableType       = "";
	
	function setDataSource(dataSource) {_dataSource = dataSource;}
	
	function setTableId(tableId) {
		_tableId         = tableId;
		var tableList    = document.getElementById(_tableId);
		var currentStyle = tableList.getAttribute("style");
		tableList.setAttribute("style", "-webkit-touch-callout: none;-webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; " + currentStyle);
	}
	
	function setTableType(tableType) {_tableType = tableType;}
	
	function setSelectedClass(selectedClass) {_selectedClass = selectedClass;}
	
	function setUnselectClass(unselectClass) {_unselectClass = unselectClass;}
	
	//Row process functions
	function clickRow(event) {
		var currentRow = event.currentTarget;
		var crrClass   = currentRow.className;
		var rowClass   = crrClass == _selectedClass ? _unselectClass : _selectedClass;
		
		if (event.ctrlKey) {toggleRow(currentRow, rowClass); _lastSelectedRow = currentRow;}
		
		if (!event.ctrlKey && !event.shiftKey) {
			var listOfRows = document.getElementsByClassName(_selectedClass);
			
			if (listOfRows.length > 1) {
				toggleAllRow(false);
				toggleRow(currentRow, _selectedClass);
			}
			else {
				toggleAllRow(false);
				toggleRow(currentRow, rowClass);
			}
			
			_lastSelectedRow = currentRow;
		}
		
		if (event.shiftKey) {
			var currentIdx = currentRow.rowIndex;
			switch (checkFirstSelect()) {
				case 0:
					toggleAllRow(false);
					selectRowsBetweenIndexes([_lastSelectedRow.rowIndex, currentIdx]);
					break;
				case 1:
					toggleRow(currentRow, rowClass); _lastSelectedRow = currentRow;
					break;
				case 2:
					toggleAllRow(false);
					selectRowsBetweenIndexes([1, currentIdx]);
					break;
			}
		}
	}
	
	function checkFirstSelect() {
		var listOfSelectedRows = document.getElementsByClassName(_selectedClass);
		if (_lastSelectedRow == null) {
			return listOfSelectedRows.length == 0 ? 1 : 2;
		}
		
		return 0;
	}
	
	function toggleAllRow(flag) {
		var rowClass = flag == true ? _unselectClass : _selectedClass;
		var setClass = flag == true ? _selectedClass : _unselectClass;
		
		var listOfRows = document.getElementsByClassName(rowClass);
		
		for (var i = listOfRows.length - 1; i >= 0; i--) {
			toggleRow(listOfRows[i], setClass);
		}
	}
	
	function toggleRow(row, rowClass) {
		if (rowClass == _unselectClass) {
			var tableList              = document.getElementById(_tableId);
			var firstInputCheckBox     = tableList.rows[0].firstElementChild.firstElementChild;
			firstInputCheckBox.checked = false;
		}
		
		var checkboxElmt     = row.firstElementChild.firstElementChild;
		checkboxElmt.checked = rowClass == _selectedClass ? true : false;
		row.className        = rowClass;
	}

	function selectRowsBetweenIndexes(indexArr) {
		indexArr.sort(function(a, b) {return a - b;});
		
		var listOfRows = document.getElementById(_tableId).rows;
		
		for (var i = indexArr[0] + 1; i <= indexArr[1] + 1; i++) {
			toggleRow(listOfRows[i-1], _selectedClass);
		}
	}
	
	// process checkbox
	function getChecked(event) {
		event.stopPropagation();
		
		var checkboxElmt     = event.currentTarget;
		var currentRow       = checkboxElmt.parentElement.parentElement;
		_lastSelectedRow     = currentRow;
		currentRow.className = checkboxElmt.checked ? _selectedClass : _unselectClass;
	} 
	
	// process table function
	function renderTable() {
		switch (_tableType) {
			case 'filelist'   : setFileListTable(); break;
			case 'filelog'    : setFileLogTable();  break;
			case 'configTable': setConfigTable();   break;
		}
	}
	
	function setFileLogTable() {
		var tableList = document.getElementById(_tableId);
		
		while (tableList.rows.length > 1) {
			tableList.deleteRow(1);
		}
		
		if (_dataSource == null || _dataSource.length == 0) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			tdElmt.setAttribute("colspan", "6");
			tdElmt.setAttribute("align", "center");
			tdElmt.setAttribute("bgcolor", "#FFFFFF");
			tdElmt.innerHTML = strNoData;
			
			trElmt.appendChild(tdElmt);
			tableList.appendChild(trElmt);
		}
		else {
			var len = _dataSource.length;
			for (var i = 0; i < len; i++) {
				var trElmt  = document.createElement("tr");
				var tdElmt1 = document.createElement("td");
				var tdElmt2 = document.createElement("td");
				var tdElmt3 = document.createElement("td");
				var tdElmt4 = document.createElement("td");
				var tdElmt5 = document.createElement("td");
				var tdElmt6 = document.createElement("td");
				
				trElmt.setAttribute("class", "bnkWebFolder");
				tdElmt1.textContent = _dataSource[i]["fileType"];
				
				tdElmt2.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
				tdElmt2.textContent = _dataSource[i]["fileName"];
				
				tdElmt3.textContent = getFileSize(_dataSource[i]["fileSize"]);
				
				tdElmt4.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
				
				if (primary == "1") {
					tdElmt4.textContent = _dataSource[i]["createName1"];
				}
				else {
					tdElmt4.textContent = _dataSource[i]["createName2"];
				}
				
				switch(_dataSource[i]["logType"]) {
					case "C":
						tdElmt5.textContent = strActType1;
						break;
					case "D":
						tdElmt5.textContent = strActType2;
						break;
					case "U":
						tdElmt5.textContent = strActType3;
						break;
					case "R":
						tdElmt5.textContent = strActType4;
						break;
					case "P":
						tdElmt5.textContent = strActType5;
						break;
					case "RE":
						tdElmt5.textContent = strActType6;
						break;
				}
				
				tdElmt6.setAttribute("style","text-align: center; overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
				tdElmt6.textContent = _dataSource[i]["createDate"].substring(0, 19);
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt3);
				trElmt.appendChild(tdElmt4);
				trElmt.appendChild(tdElmt5);
				trElmt.appendChild(tdElmt6);
				tableList.appendChild(trElmt);
			}
		}
	}
	
	function setConfigTable() {
		var tableList               = document.getElementById(_tableId);
		var firstInputCheckBox      = tableList.rows[0].firstElementChild.firstElementChild;
		firstInputCheckBox.checked  = false; //Clear first input check box
		firstInputCheckBox.onclick  = function(e) {toggleAllRow(this.checked);};
		
		while (tableList.rows.length > 1) {
			tableList.deleteRow(1);
		}
		
		if (_dataSource == null || _dataSource.length == 0) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			tdElmt.setAttribute("colspan", "8");
			tdElmt.setAttribute("align", "center");
			tdElmt.setAttribute("bgcolor", "#FFFFFF");
			tdElmt.innerHTML = strNoData;
			
			trElmt.appendChild(tdElmt);
			tableList.appendChild(trElmt);
		}
		else {
			var len = _dataSource.length;
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
				
				trElmt.setAttribute("class", _unselectClass);
				trElmt.setAttribute("usedAmount", _dataSource[i]["totalUsed"]);
				trElmt.setAttribute("userId", _dataSource[i]["userId"]);
				trElmt.onclick = function(event) {clickRow(event);};
				
				var inputElmt = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				inputElmt.setAttribute("class", "checkBnk");
				inputElmt.setAttribute("value", "0");
				inputElmt.setAttribute("usedAmount", _dataSource[i]["totalUsed"]);
				inputElmt.setAttribute("userId", _dataSource[i]["userId"]);
				inputElmt.onclick = function(event) {getChecked(event);};
				
				tdElmt1.appendChild(inputElmt);
				
				tdElmt2.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
				tdElmt2.textContent = _dataSource[i]["companyName"];
				
				tdElmt3.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
				tdElmt3.textContent = _dataSource[i]["departmentName"];
				
				tdElmt4.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
				tdElmt4.textContent = _dataSource[i]["userName"];
				
				tdElmt5.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
				tdElmt5.textContent = _dataSource[i]["jobTitle"];
				
				tdElmt6.setAttribute("style","text-align: center;");
				tdElmt6.textContent = getFileSize(_dataSource[i]["totalUsed"]);
				
				tdElmt7.setAttribute("style","text-align: center;");
				tdElmt7.textContent = _dataSource[i]["totalCapacity"] + "GB";
				
				tdElmt8.setAttribute("style","white-space:nowrap; text-align:center;");
				
				var span = document.createElement("span");
				span.className  = "workProgressBar";
				span.innerHTML += "<span class='bar' usedrate='rategrogressBar" + i + "'></span>&nbsp;";
				
				var span2 = document.createElement("span");
				span2.style.display = "inline-block";
				span.appendChild(span2);
				tdElmt8.appendChild(span);
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt3);
				trElmt.appendChild(tdElmt4);
				trElmt.appendChild(tdElmt5);
				trElmt.appendChild(tdElmt6);
				trElmt.appendChild(tdElmt7);
				trElmt.appendChild(tdElmt8);
				tableList.appendChild(trElmt);
				
				initProgressBar("rategrogressBar" + i, "3", _dataSource[i]["usedRate"]);
			}
		}
	}
	
	function setFileListTable() {
		var tableList               = document.getElementById(_tableId);
		var firstInputCheckBox      = tableList.rows[0].firstElementChild.firstElementChild;
		firstInputCheckBox.checked  = false; //Clear first input check box
		firstInputCheckBox.onclick  = function(e) {toggleAllRow(this.checked);};
		
		while (tableList.rows.length > 1) {
			tableList.deleteRow(1);
		}
		
		if (_dataSource == null || _dataSource.length == 0) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			tdElmt.setAttribute("colspan", "9");
			tdElmt.setAttribute("align", "center");
			tdElmt.setAttribute("bgcolor", "#FFFFFF");
			tdElmt.textContent = strNoData;
			tdElmt.setAttribute("id", "nodataRow");
			
			trElmt.appendChild(tdElmt);
			tableList.appendChild(trElmt);
		}
		else {
			var len = _dataSource.length;
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
				
				trElmt.setAttribute("class", _unselectClass);
				trElmt.setAttribute("_fileId", _dataSource[i]["fileId"]);
				trElmt.setAttribute("_filePath", _dataSource[i]["filePath"]);
				trElmt.onclick = function(event) {clickRow(event);};
				trElmt.ondblclick = function(event) {downloadFileByDbClick(event);};
				
				var inputElmt = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				inputElmt.setAttribute("value", _dataSource[i]["fileId"]);
				inputElmt.setAttribute("class", "checkBnk");
				inputElmt.onclick = function(e) {getChecked(e);};
				tdElmt1.appendChild(inputElmt);
				
				var fileIconElmt = document.createElement("img");
				fileIconElmt.setAttribute("class", "webFolderImg");
				fileIconElmt.src = _dataSource[i]["fileIconUrl"];
				tdElmt2.appendChild(fileIconElmt);
				tdElmt3.textContent = _dataSource[i]["fileName"];
				tdElmt3.setAttribute("title", _dataSource[i]["fileName"]);
				tdElmt3.setAttribute("style", "overflow: hidden;text-overflow: ellipsis;white-space: nowrap;");
				tdElmt4.textContent = getFileSize(_dataSource[i]["fileSize"]);
				
				if (primary == "1") {
					tdElmt5.textContent = _dataSource[i]["createName1"];
				}
				else {
					tdElmt5.textContent = _dataSource[i]["createName2"];
				}
				
				tdElmt6.textContent = _dataSource[i]["createDate"].substring(0, 10);
				tdElmt7.textContent = _dataSource[i]["updateDate"].substring(0, 10);
				tdElmt8.textContent = _dataSource[i]["filePosition"];
				tdElmt8.setAttribute("title", _dataSource[i]["filePosition"]);
				tdElmt8.setAttribute("style", "overflow: hidden;text-overflow: ellipsis;white-space: nowrap;");
				tdElmt9.textContent = _dataSource[i]["downloadCnt"];
				tdElmt9.setAttribute("style","text-align: center;");
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt3);
				trElmt.appendChild(tdElmt4);
				trElmt.appendChild(tdElmt5);
				trElmt.appendChild(tdElmt6);
				trElmt.appendChild(tdElmt7);
				trElmt.appendChild(tdElmt8);
				trElmt.appendChild(tdElmt9);
				tableList.appendChild(trElmt);
			}
		}
	}
	
	function downloadFileByDbClick(event) {
		event.stopPropagation();
		event.preventDefault();
		var trElmt       = event.currentTarget;
		var fileFolderId = trElmt.getAttribute("_fileId");
		var filesList    = [];
		filesList.push(fileFolderId);
		
		var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
		AttachDownFrame.location.href = downloadUrl;
	}
	
}