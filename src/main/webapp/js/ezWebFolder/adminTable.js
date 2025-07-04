//Baonk 2018/04/26

function TableView() {
	//set public functions
	this.setTableId       = setTableId;
	this.setTabledHeader  = setTabledHeader;
	this.setSelectedClass = setSelectedClass;
	this.setUnselectClass = setUnselectClass;
	this.setDataSource    = setDataSource;
	this.setTableType     = setTableType;
	this.renderTable      = renderTable;
	this.setCallBack      = setCallBack;
	this.getOrderInfo     = getOrderInfo;
	this.clearHeaders     = clearHeaders;
	
	//private variables
	var _tableId         = null;
	var _tableheader     = null;
	var _selectedClass   = "";
	var _unselectClass   = "";
	var _lastSelectedRow = null;
	var _dataSource      = "";
	var _tableType       = "";
	var _selectedCell    = null;
	var _cellInfo        = {};
	var _callBackSearch  = null;
	
	//privileged functions
	function setCallBack(callBackName) {_callBackSearch = callBackName;}
	function setTabledHeader(headerId) {_tableheader    = headerId;}
	function getOrderInfo() {return _cellInfo;}
	
	function clearHeaders() {
		_cellInfo     = {};
		_selectedCell = null;
		
		var spanUpList   = document.getElementsByClassName("spanUp");
		var spanDownList = document.getElementsByClassName("spanDown");
		var len1         = spanUpList.length;
		var len2         = spanDownList.length;
		
		for (var i = len1 - 1; i >= 0; i--) {
			var parentElmt = spanUpList[i].parentElement;
			parentElmt.removeChild(spanUpList[i]);
		}
		
		for (var j = len2 - 1; j >= 0; j--) {
			var parentElmt = spanDownList[j].parentElement;
			parentElmt.removeChild(spanDownList[j]);
		}
	}
	
	function setTableId(tableId) {
		_tableId         = tableId;
		var tableList    = document.getElementById(_tableId);
		var currentStyle = tableList.getAttribute("style");
		tableList.setAttribute("style", "-webkit-touch-callout: none;-webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; " + currentStyle);
		
		/*var headerRow    = tableList.rows[0];
		var len          = headerRow.cells.length;
		var firstTd      = headerRow.cells[0];
		var firstTdChild = firstTd.firstElementChild;
		
		if (!firstTdChild || (firstTdChild.tagName).toLowerCase() != "input") {
			firstTd.onclick = function() {sortByHeader(this);};
		}
		
		for (var i = 1; i < len; i++) {
			var cell     = headerRow.cells[i];
			cell.onclick = function() {sortByHeader(this);};
		}*/
	}
	
	function setDataSource(dataSource)       {_dataSource = dataSource;}
	function setTableType(tableType)         {_tableType = tableType;}
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
			toggleAllRow(false);
			
			if (listOfRows.length > 1) {
				toggleRow(currentRow, _selectedClass);
			}
			else {
				toggleRow(currentRow, rowClass);
			}
			
			_lastSelectedRow = currentRow;
			return;
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
	
	/*function toggleAllRow(flag) {
		var rowClass   = flag == true ? _unselectClass : _selectedClass;
		var setClass   = flag == true ? _selectedClass : _unselectClass;
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
	}*/
	
    function toggleAllRow(flag) {
        const allRows = Array.from(document.querySelectorAll(`#${_tableId} tr`));

        allRows.forEach(function(row) {
            toggleRow(row, flag ? _selectedClass : _unselectClass);
        });
    
        // 헤더 체크박스 상태도 함께 동기화
        const headerCheckbox = document.querySelector(`#${_tableheader}  thead tr th div input[type="checkbox"]`);
        if (headerCheckbox) {
            headerCheckbox.checked = flag;
        }
    }

    function toggleRow(row, rowClass) {
    	row.className = rowClass;
    
    	const checkboxElmt = row.querySelector('input[type="checkbox"]');
    	checkboxElmt.checked = (rowClass === _selectedClass);
        
    	const currentRow = checkboxElmt.closest('tr');
    	currentRow.classList.remove(_selectedClass, _unselectClass);
        currentRow.classList.add(checkboxElmt.checked ? _selectedClass : _unselectClass);
    }

/*function selectRowsBetweenIndexes(indexArr) {
		indexArr.sort(function(a, b) {return a - b;});
		
		var listOfRows = document.getElementById(_tableId).rows;
		
		for (var i = indexArr[0] + 1; i <= indexArr[1] + 1; i++) {
			toggleRow(listOfRows[i-1], _selectedClass);
		}
	}*/
	
	function selectRowsBetweenIndexes(indexArr) {
        indexArr.sort((a, b) => a - b);
        const rows = document.getElementById(_tableId).rows;
    
        for (let i = indexArr[0]; i <= indexArr[1]; i++) {
            toggleRow(rows[i], _selectedClass);
        }
    }
	
	// process checkbox
	function getChecked(event) {
		event.stopPropagation();
		
		var checkboxElmt     = event.currentTarget;
		//var currentRow       = checkboxElmt.parentElement.parentElement;
		const currentRow = checkboxElmt.closest('tr');
        
        if (!currentRow) { return };
        	
		_lastSelectedRow     = currentRow;
		
		// 선택 스타일 처리
		//currentRow.className = checkboxElmt.checked ? _selectedClass : _unselectClass;
        currentRow.classList.remove(_selectedClass, _unselectClass);
        currentRow.classList.add(checkboxElmt.checked ? _selectedClass : _unselectClass);
	}
	
	function sortByHeader(cell) {
		var _tableElmt = document.getElementById(_tableId);
		var column     = cell.getAttribute("headers");
		
		if (!column) {return;}
		
		if (_selectedCell != null) {
			var orderOption = cell.getAttribute("orderoption") == "DESC" ? "ASC" : "DESC";
			cell.setAttribute("orderoption", orderOption);
			
			if (cell.cellIndex != _selectedCell) {
				var lastSelectedCell = _tableElmt.rows[0].cells[_selectedCell];
				lastSelectedCell.removeChild(lastSelectedCell.firstElementChild);
				var spanElmt = document.createElement("span");
				cell.appendChild(spanElmt);
			}
			
			var spanElmt       = cell.firstElementChild;
			spanElmt.className = orderOption == "DESC" ? "spanDown" : "spanUp";
		}
		else {
			cell.setAttribute("orderoption", "DESC");
			var spanElmt       = document.createElement("span");
			spanElmt.className = "spanDown";
			cell.appendChild(spanElmt);
		}
		
		_selectedCell = cell.cellIndex;
		var order     = cell.getAttribute("orderoption");
		_cellInfo.col = column;
		_cellInfo.ord = order;
		_callBackSearch();
	}
	
	// process table function
	function renderTable() {
		switch (_tableType) {
			case 'filelist'   : setFileListTable();                   break;
			case 'filelog'    : setFileLogTable();                    break;
			case 'userConfigTable': setUserConfigTable();             break;
			case 'departmentConfigTable': setDepartmentConfigTable(); break;
			case 'companyConfigTable': setCompanyConfigTable();       break;
			case 'deletedfile': setDeletedFileTable();                break;
		}
	}
	
	function setFileLogTable() {
		var tableList = document.getElementById(_tableId);
		
		while (tableList.rows.length > 0) {
			tableList.deleteRow(0);
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
				var tdElmt2_path = document.createElement("td");
				var tdElmt3_version = document.createElement("td");
				var tdElmt3 = document.createElement("td");
				var tdElmt4 = document.createElement("td");
				var tdElmt5 = document.createElement("td");
				var tdElmt6 = document.createElement("td");
				
				tdElmt1.setAttribute("class", "wfFileType");
				tdElmt2.setAttribute("class", "wfFileLogName");
				tdElmt2_path.setAttribute("class", "wfFileLogName");
				tdElmt3.setAttribute("class", "wfFileFavoriteSize");
				tdElmt3_version.setAttribute("class", "wfFileFavoriteSize");
				tdElmt4.setAttribute("class", "wfFileLogMember");
				tdElmt5.setAttribute("class", "wfActive");
				tdElmt6.setAttribute("class", "wfFileLogDate");
				
				trElmt.setAttribute("class", _unselectClass);
				var fileIconElmt = document.createElement("img");
				fileIconElmt.setAttribute("class", "webFolderImg");
				fileIconElmt.src = _dataSource[i]["fileType"];
				tdElmt1.setAttribute("style", "text-align: center;");
				tdElmt1.appendChild(fileIconElmt);
				
				tdElmt2.setAttribute("style", "word-break: break-all;white-space: pre-wrap;cursor: pointer; word-wrap: normal;");
				tdElmt2.setAttribute("title", _dataSource[i]["fileName"]);
				tdElmt2.textContent = _dataSource[i]["fileName"];
				
				var folderpathName = _dataSource[i]["folderPathName"];
				tdElmt2_path.setAttribute("style", "word-break: break-all;white-space: pre-wrap;cursor: pointer; word-wrap: normal;");
				tdElmt2_path.setAttribute("title", _dataSource[i]["folderPathName"] == null ? '-' : folderpathName.substring(0, folderpathName.length-1));
				tdElmt2_path.textContent = _dataSource[i]["folderPathName"] == null ? '-' : folderpathName.substring(0, folderpathName.length-1);
				
				tdElmt3_version.textContent = _dataSource[i]["version"] == 0 ? '-' : _dataSource[i]["version"] + ".0";
				tdElmt3.textContent = getFileSize(_dataSource[i]["fileSize"]);
				
				tdElmt4.setAttribute("style","word-break: break-all;white-space: pre-wrap;cursor: pointer; word-wrap: normal;");
				tdElmt4.textContent = primary == "1" ? _dataSource[i]["createName1"] : _dataSource[i]["createName2"];
				tdElmt4.setAttribute("title", tdElmt4.textContent);
				
				switch(_dataSource[i]["logType"]) {
					case "C" : tdElmt5.textContent = strActType1; break;
					case "D" : tdElmt5.textContent = strActType2; break;
					case "U" : tdElmt5.textContent = strActType3; break;
					case "R" : tdElmt5.textContent = strActType4; break;
					case "P" : tdElmt5.textContent = strActType5; break;
					case "RE": tdElmt5.textContent = strActType6; break;
					case "MV": tdElmt5.textContent = strActType7; break;
					case "CP": tdElmt5.textContent = strActType8; break;
					case "WR": tdElmt5.textContent = strActType9; break;
					case "V" : tdElmt5.textContent = strActType10; break;
				}
				
				tdElmt6.setAttribute("style", "text-align: center; word-break: break-all;white-space: pre-wrap;cursor: pointer; word-wrap: normal;");
				tdElmt6.textContent = _dataSource[i]["createDate"].substring(0, 19);
				tdElmt6.setAttribute("title", tdElmt6.textContent);
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt2_path);
				trElmt.appendChild(tdElmt3_version);
				trElmt.appendChild(tdElmt3);
				trElmt.appendChild(tdElmt4);
				trElmt.appendChild(tdElmt5);  
				trElmt.appendChild(tdElmt6);
				tableList.appendChild(trElmt);
			}
		}
	}
	
	function setUserConfigTable() {
		var tableList              = document.getElementById(_tableId);
		var tableHeader            = document.getElementById(_tableheader);
		//var firstInputCheckBox     = tableHeader.rows[0].firstElementChild.firstElementChild;
		//firstInputCheckBox.checked = false;
		//firstInputCheckBox.onclick = function(e) {toggleAllRow(this.checked);};
		
		var firstInputCheckBox = tableHeader.querySelector('input[type="checkbox"]');
        
        if (firstInputCheckBox) {
        	firstInputCheckBox.checked = false;
        	firstInputCheckBox.onclick = function(e) {
        		e.stopPropagation(); // 혹시라도 상위 이벤트 방지
        		toggleAllRow(this.checked);
        	};
        }
		
		while (tableList.rows.length > 0) {
			tableList.deleteRow(0);
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
				
				tdElmt1.setAttribute("class", "wfFilecheck");
				tdElmt2.setAttribute("class", "wfConfigCompany");
				tdElmt3.setAttribute("class", "wfConfigCompany");
				tdElmt4.setAttribute("class", "wfActive");
				tdElmt5.setAttribute("class", "wfActive");
				tdElmt6.setAttribute("class", "wfConfigCapacity");
				tdElmt7.setAttribute("class", "wfConfigCapacity");
				tdElmt8.setAttribute("class", "wfConfigCompany");
				
				trElmt.setAttribute("class", _unselectClass);
				trElmt.setAttribute("usedAmount", _dataSource[i]["totalUsed"]);
				trElmt.setAttribute("cn", _dataSource[i]["cn"]);
				trElmt.onclick = function(event) {clickRow(event);};
				
				var inputElmt  = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				//inputElmt.setAttribute("class", "checkBnk");
				inputElmt.setAttribute("value", "0");
				inputElmt.setAttribute("usedAmount", _dataSource[i]["totalUsed"]);
				inputElmt.setAttribute("cn", _dataSource[i]["cn"]);
				inputElmt.onclick = function(event) {getChecked(event);};
				
				var customDiv = document.createElement("div");
                customDiv.className = "custom_checkbox";
                customDiv.appendChild(inputElmt);
                
                tdElmt1.appendChild(customDiv);
				
				tdElmt2.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
				tdElmt2.textContent = _dataSource[i]["companyName"];
				tdElmt2.setAttribute("title", tdElmt2.textContent);
				
				tdElmt3.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
				tdElmt3.textContent = _dataSource[i]["departmentName"];
				tdElmt3.setAttribute("title", tdElmt3.textContent);
				
				tdElmt4.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
				tdElmt4.textContent = _dataSource[i]["displayName"] + "(" + _dataSource[i]["cn"] + ")";
				tdElmt4.setAttribute("title", tdElmt4.textContent);
				
				tdElmt5.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
				tdElmt5.textContent = _dataSource[i]["jobTitle"];
				tdElmt5.setAttribute("title", tdElmt5.textContent);
				
				tdElmt6.setAttribute("style", "text-align: center;");
				tdElmt6.textContent = getFileSize(_dataSource[i]["totalUsed"]) + "(" + strLang41 + " " + _dataSource[i]["totalCount"] + "" + strLang42 + ")";
				
				tdElmt7.setAttribute("style", "text-align: center;");
				tdElmt7.textContent = _dataSource[i]["totalCapacity"] + "GB";
				
				tdElmt8.setAttribute("style", "white-space:nowrap; text-align:center; word-wrap: normal;");
				
				var span        = document.createElement("span");
				span.className  = "workProgressBar";
				span.innerHTML += "<span class='bar' usedrate='rategrogressBar" + i + "'></span>&nbsp;";
				
				var span2           = document.createElement("span");
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
	
	function setDepartmentConfigTable() {
		var tableList              = document.getElementById(_tableId);
		var tableHeader            = document.getElementById(_tableheader);
		//var firstInputCheckBox     = tableHeader.rows[0].firstElementChild.firstElementChild;
		//firstInputCheckBox.checked = false;
		//firstInputCheckBox.onclick = function(e) {toggleAllRow(this.checked);};
		
		var firstInputCheckBox = tableHeader.querySelector('input[type="checkbox"]');
        
        if (firstInputCheckBox) {
        	firstInputCheckBox.checked = false;
        	firstInputCheckBox.onclick = function(e) {
        		e.stopPropagation(); // 혹시라도 상위 이벤트 방지
        		toggleAllRow(this.checked);
        	};
        }
        
		while (tableList.rows.length > 0) {
			tableList.deleteRow(0);
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
//				var tdElmt4 = document.createElement("td");
//				var tdElmt5 = document.createElement("td");
				var tdElmt6 = document.createElement("td");
				var tdElmt7 = document.createElement("td");
				var tdElmt8 = document.createElement("td");
				
				tdElmt1.setAttribute("class", "wfFilecheck");
				tdElmt2.setAttribute("class", "wfConfigCompany");
				tdElmt3.setAttribute("class", "wfConfigCompany");
//				tdElmt4.setAttribute("class", "wfActive");
//				tdElmt5.setAttribute("class", "wfActive");
				tdElmt6.setAttribute("class", "wfConfigCapacity");
				tdElmt7.setAttribute("class", "wfConfigCapacity");
				tdElmt8.setAttribute("class", "wfConfigCompany");
				
				trElmt.setAttribute("class", _unselectClass);
				trElmt.setAttribute("usedAmount", _dataSource[i]["totalUsed"]);
				trElmt.setAttribute("cn", _dataSource[i]["cn"]);
				trElmt.onclick = function(event) {clickRow(event);};
				
				var inputElmt  = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				//inputElmt.setAttribute("class", "checkBnk");
				inputElmt.setAttribute("value", "0");
				inputElmt.setAttribute("usedAmount", _dataSource[i]["totalUsed"]);
				inputElmt.setAttribute("cn", _dataSource[i]["cn"]);
				inputElmt.onclick = function(event) {getChecked(event);};
				
				// custom_checkbox div 추가
				var customCheckboxDiv = document.createElement("div");
                customCheckboxDiv.className = "custom_checkbox";
                customCheckboxDiv.appendChild(inputElmt);
                
                tdElmt1.appendChild(customCheckboxDiv);
				
				tdElmt2.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
				tdElmt2.textContent = _dataSource[i]["companyName"];
				tdElmt2.setAttribute("title", tdElmt2.textContent);
				
				tdElmt3.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
				tdElmt3.textContent = _dataSource[i]["displayName"] + "(" + _dataSource[i]["cn"] + ")";
				tdElmt3.setAttribute("title", tdElmt3.textContent);
				
//				tdElmt4.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
//				tdElmt4.textContent = _dataSource[i]["cn"];
//				tdElmt4.setAttribute("title", tdElmt4.textContent);
				
//				tdElmt5.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
//				tdElmt5.textContent = _dataSource[i]["jobTitle"];
//				tdElmt5.setAttribute("title", tdElmt5.textContent);
				
				tdElmt6.setAttribute("style", "text-align: center;");
				tdElmt6.textContent = getFileSize(_dataSource[i]["totalUsed"]) + "(" + strLang41 + " " + _dataSource[i]["totalCount"] + "" + strLang42 + ")";
				
				tdElmt7.setAttribute("style", "text-align: center;");
				tdElmt7.textContent = _dataSource[i]["totalCapacity"] + "GB";
				
				tdElmt8.setAttribute("style", "white-space:nowrap; text-align:center; word-wrap: normal;");
				
				var span        = document.createElement("span");
				span.className  = "workProgressBar";
				span.innerHTML += "<span class='bar' usedrate='rategrogressBar" + i + "'></span>&nbsp;";
				
				var span2           = document.createElement("span");
				span2.style.display = "inline-block";
				span.appendChild(span2);
				tdElmt8.appendChild(span);
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt3);
//				trElmt.appendChild(tdElmt4);
//				trElmt.appendChild(tdElmt5);
				trElmt.appendChild(tdElmt6);
				trElmt.appendChild(tdElmt7);
				trElmt.appendChild(tdElmt8);
				tableList.appendChild(trElmt);
				
				initProgressBar("rategrogressBar" + i, "3", _dataSource[i]["usedRate"]);
			}
		}
	}
	
	function setCompanyConfigTable() {
		var tableList              = document.getElementById(_tableId);
		var tableHeader            = document.getElementById(_tableheader);
		//var firstInputCheckBox     = tableHeader.rows[0].firstElementChild.firstElementChild;
		//firstInputCheckBox.checked = false;
		//firstInputCheckBox.onclick = function(e) {toggleAllRow(this.checked);};
		
		var firstInputCheckBox = tableHeader.querySelector('input[type="checkbox"]');
        
        if (firstInputCheckBox) {
        	firstInputCheckBox.checked = false;
        	firstInputCheckBox.onclick = function(e) {
        		e.stopPropagation(); // 혹시라도 상위 이벤트 방지
        		toggleAllRow(this.checked);
        	};
        }
		
		while (tableList.rows.length > 0) {
			tableList.deleteRow(0);
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
//				var tdElmt3 = document.createElement("td");
//				var tdElmt4 = document.createElement("td");
//				var tdElmt5 = document.createElement("td");
				var tdElmt6 = document.createElement("td");
				var tdElmt7 = document.createElement("td");
				var tdElmt8 = document.createElement("td");
				
				tdElmt1.setAttribute("class", "wfFilecheck");
				tdElmt2.setAttribute("class", "wfConfigCompany");
//				tdElmt3.setAttribute("class", "wfConfigCompany");
//				tdElmt4.setAttribute("class", "wfActive");
//				tdElmt5.setAttribute("class", "wfActive");
				tdElmt6.setAttribute("class", "wfConfigCapacity");
				tdElmt7.setAttribute("class", "wfConfigCapacity");
				tdElmt8.setAttribute("class", "wfConfigCompany");
				
				trElmt.setAttribute("class", _unselectClass);
				trElmt.setAttribute("usedAmount", _dataSource[i]["totalUsed"]);
				trElmt.setAttribute("cn", _dataSource[i]["cn"]);
				trElmt.onclick = function(event) {clickRow(event);};
				
				var inputElmt  = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				//inputElmt.setAttribute("class", "checkBnk");
				inputElmt.setAttribute("value", "0");
				inputElmt.setAttribute("usedAmount", _dataSource[i]["totalUsed"]);
				inputElmt.setAttribute("cn", _dataSource[i]["cn"]);
				inputElmt.onclick = function(event) {getChecked(event);};
				
				var customDiv = document.createElement("div");
                customDiv.className = "custom_checkbox";
                customDiv.appendChild(inputElmt);
                
                tdElmt1.appendChild(customDiv);
				
				tdElmt2.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
				tdElmt2.textContent = _dataSource[i]["displayName"] + "(" + _dataSource[i]["cn"] + ")";
				tdElmt2.setAttribute("title", tdElmt2.textContent);
				
//				tdElmt3.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
//				tdElmt3.textContent = _dataSource[i]["displayName"] + "(" + _dataSource[i]["cn"] + ")";
//				tdElmt3.setAttribute("title", tdElmt3.textContent);
				
//				tdElmt4.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
//				tdElmt4.textContent = _dataSource[i]["cn"];
//				tdElmt4.setAttribute("title", tdElmt4.textContent);
				
//				tdElmt5.setAttribute("style", "overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap; word-wrap: normal;");
//				tdElmt5.textContent = _dataSource[i]["jobTitle"];
//				tdElmt5.setAttribute("title", tdElmt5.textContent);
				
				tdElmt6.setAttribute("style", "text-align: center;");
				tdElmt6.textContent = getFileSize(_dataSource[i]["totalUsed"]) + "(" + strLang41 + " " + _dataSource[i]["totalCount"] + "" + strLang42 + ")";
				
				tdElmt7.setAttribute("style", "text-align: center;");
				tdElmt7.textContent = _dataSource[i]["totalCapacity"] + "GB"; 
				
				tdElmt8.setAttribute("style", "white-space:nowrap; text-align:center; word-wrap: normal;");
				
				var span        = document.createElement("span");
				span.className  = "workProgressBar";
				span.innerHTML += "<span class='bar' usedrate='rategrogressBar" + i + "'></span>&nbsp;";
				
				var span2           = document.createElement("span");
				span2.style.display = "inline-block";
				span.appendChild(span2);
				tdElmt8.appendChild(span);
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
//				trElmt.appendChild(tdElmt3);
//				trElmt.appendChild(tdElmt4);
//				trElmt.appendChild(tdElmt5);
				trElmt.appendChild(tdElmt6);
				trElmt.appendChild(tdElmt7);
				trElmt.appendChild(tdElmt8);
				tableList.appendChild(trElmt);
				
				initProgressBar("rategrogressBar" + i, "3", _dataSource[i]["usedRate"]);
			}
		}
	}
	
	function setFileListTable() {
		var tableList              = document.getElementById(_tableId);
		var tableHeader            = document.getElementById(_tableheader);
		//var firstInputCheckBox     = tableHeader.rows[0].firstElementChild.firstElementChild;
		//firstInputCheckBox.checked = false;
		//firstInputCheckBox.onclick = function(e) {toggleAllRow(this.checked);};
		
		var firstInputCheckBox = tableHeader.querySelector('input[type="checkbox"]');
        
        if (firstInputCheckBox) {
        	firstInputCheckBox.checked = false;
        	firstInputCheckBox.onclick = function(e) {
        		e.stopPropagation(); // 혹시라도 상위 이벤트 방지
        		toggleAllRow(this.checked);
        	};
        }
		
		while (tableList.rows.length > 0) {
			tableList.deleteRow(0);
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
				
				var encryptedFlag = _dataSource[i]["encryptedFlag"];
				var fileName = _dataSource[i]["fileName"];
				var depth = _dataSource[i]["depth"];
				var ext = _dataSource[i]["fileExt"];
				
				tdElmt1.setAttribute("class", "wfFilecheck");
				tdElmt2.setAttribute("class", "wfFileType");
				tdElmt3.setAttribute("class", "wfFileName");
				tdElmt4.setAttribute("class", "wfFileSize");
				tdElmt5.setAttribute("class", "wfFileCreator");
				tdElmt6.setAttribute("class", "wfFileAdminDate");
				tdElmt7.setAttribute("class", "wfFileAdminDate");
				tdElmt8.setAttribute("class", "wfFilePath");
				tdElmt9.setAttribute("class", "wfFileDownload");
				
				trElmt.setAttribute("class", _unselectClass);
				trElmt.setAttribute("_fileId", _dataSource[i]["fileId"]);
				trElmt.setAttribute("_filePath", _dataSource[i]["filePath"]);
				trElmt.setAttribute("encryptedFlag", _dataSource[i]["encryptedFlag"]);
				trElmt.setAttribute("targetType", 'F');
				trElmt.setAttribute("depth", depth);
				trElmt.onclick = function(event) {clickRow(event);};
				trElmt.addEventListener("dblclick", function(event) {
//					if (this.getAttribute("encryptedFlag") == "1") {
//						unidocsWebViewer(event);
//					} else {
						downloadFileByDbClick(event);
//					}
					rowContext.setSelectState(this, true);
				});
				trElmt.addEventListener("contextmenu", openContextMenu);
				
				var inputElmt = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				inputElmt.setAttribute("value", _dataSource[i]["fileId"]);
				//inputElmt.setAttribute("class", "checkBnk");
				inputElmt.onclick = function(e) {getChecked(e);};
				
				var customDiv = document.createElement("div");
                customDiv.className = "custom_checkbox";
                customDiv.appendChild(inputElmt);
                
                tdElmt1.appendChild(customDiv);
				
				var fileIconElmt = document.createElement("img");
				fileIconElmt.setAttribute("class", "webFolderImg");
				fileIconElmt.src = _dataSource[i]["fileIconUrl"];
				tdElmt2.appendChild(fileIconElmt);
				tdElmt2.setAttribute("style", "text-align: center;");
				tdElmt3.textContent = fileName;
				tdElmt3.setAttribute("title", fileName);
				tdElmt3.setAttribute("ext", ext);
				tdElmt3.setAttribute("style", "overflow: hidden;text-overflow: ellipsis;white-space: nowrap; word-wrap: normal; text-align: left;");

				// 계층 구조 표시
				if (depth > 1) {
					var additional = "↪ ";

					for (var j = 0; j < depth - 1; j++) {
						additional = " " + additional;
					}

					tdElmt3.innerHTML = additional + tdElmt3.innerHTML;
				}

				if (encryptedFlag == 1) {
					tdElmt3.innerHTML = "<img src='/images/email/secureMail/security_icon.gif' width='12' /> " + tdElmt3.innerHTML;
				}
				
				tdElmt4.textContent = getFileSize(_dataSource[i]["fileSize"]);
				tdElmt4.setAttribute("style", "text-align: center;");
				tdElmt5.textContent = primary == "1" ? _dataSource[i]["createName1"] : _dataSource[i]["createName2"];
				tdElmt6.textContent = _dataSource[i]["createDate"].substring(0, 10);
				tdElmt7.textContent = _dataSource[i]["updateDate"].substring(0, 10);
				tdElmt8.textContent = _dataSource[i]["filePosition"];
				tdElmt8.setAttribute("title", _dataSource[i]["filePosition"]);
				tdElmt8.setAttribute("style", "overflow: hidden;text-overflow: ellipsis;white-space: nowrap; word-wrap: normal;");
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
	
	function setDeletedFileTable() {
		var tableList               = document.getElementById(_tableId);
		var tableHeader            = document.getElementById(_tableheader);
		//var firstInputCheckBox     = tableHeader.rows[0].firstElementChild.firstElementChild;
		var firstInputCheckBox     = tableHeader.querySelector("tr th input[type='checkbox']");
		firstInputCheckBox.checked = false;
		firstInputCheckBox.onclick = function(e) {toggleAllRow(this.checked);};

		while (tableList.rows.length > 0) {
			tableList.deleteRow(0);
		}
		
		if (_dataSource == null || _dataSource.length == 0) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			
			tdElmt.setAttribute("colspan", "8");
			tdElmt.setAttribute("align", "center");
			tdElmt.setAttribute("bgcolor", "#FFFFFF");
			tdElmt.innerHTML = strNoData;
			tdElmt.setAttribute("id", "nodataRow");
			
			trElmt.appendChild(tdElmt);
			tableList.appendChild(trElmt);
		}
		else {
			var len = _dataSource.length;
			var resultElement;
			
			for (var i = 0; i < len; i++) {
				resultElement = _dataSource[i];
				
				var trElement  = document.createElement("tr");
				
				var tdCheckbox		= document.createElement("td");
				var tdFavoriteIcon	= document.createElement("td");
				var tdFileIcon		= document.createElement("td");
				var tdName			= document.createElement("td");
				var tdSize			= document.createElement("td");
				var tdCreator		= document.createElement("td");
				var tdCreateDate	= document.createElement("td");	
				var tdUpdateDate	= document.createElement("td");	
				var tdAbsolutePath	= document.createElement("td");	
				
				tdCheckbox.setAttribute("class", "wfFilecheck");
				tdFavoriteIcon.setAttribute("class", "wfFileFavorite");
				tdFileIcon.setAttribute("class", "wfFileType");
				tdName.setAttribute("class", "wfFileName");
				tdSize.setAttribute("class", "wfFileSize");
				tdCreator.setAttribute("class", "wfFileCreator");
				tdCreateDate.setAttribute("class", "wfFileFavoriteDate");
				tdUpdateDate.setAttribute("class", "wfFileFavoriteDate");
				tdAbsolutePath.setAttribute("class", "wfFilePath");
				
				trElement.setAttribute("class", "bnkWebFolder");
				trElement.setAttribute("targetid", resultElement["trashCanId"]);
				trElement.setAttribute("targetPath", resultElement["trashCanPath"]);
				trElement.setAttribute("ext", resultElement["trashCanExt"]);
				// version이 1 이상이라면 버전 파일이다.
				trElement.setAttribute("version", resultElement["version"]);
				trElement.onclick = function(event) {clickRow(event);};
				
				var inputElmt = document.createElement("input");
				inputElmt.setAttribute("type", "checkbox");
				inputElmt.setAttribute("value", resultElement["trashCanId"]);
				//inputElmt.setAttribute("class", "checkBnk");			
				inputElmt.onclick = function(e) {getChecked(e);};
				
				var customDiv = document.createElement("div");
                customDiv.className = "custom_checkbox";
                customDiv.appendChild(inputElmt);
                
                tdCheckbox.appendChild(customDiv);
				
				var fileIconElmt = document.createElement("img");
				fileIconElmt = document.createElement("img");
				fileIconElmt.setAttribute("class", "webFolderImg");
				fileIconElmt.src = resultElement["trashCanIconUrl"];
				
				tdFileIcon.appendChild(fileIconElmt);
				tdFileIcon.setAttribute("style", "text-align: center;");
				
				tdName.textContent         = resultElement["trashCanName"];
				tdSize.textContent         = resultElement["trashCanExt"] != 'folder' ? getFileSize(resultElement["trashCanSize"]) : "-";
				tdSize.setAttribute("style", "overflow: hidden;text-overflow: ellipsis;white-space: nowrap;text-align: center; word-wrap: normal;");
				tdName.setAttribute("style", "overflow: hidden;text-overflow: ellipsis;white-space: nowrap; word-wrap: normal; text-align: left;");
				tdName.setAttribute("title", resultElement["trashCanName"]);
				tdCreator.textContent      = lang == "1" ? resultElement["createName1"] : resultElement["createName2"];
				tdUpdateDate.textContent   = resultElement["updateDate"].substring(0, 10);
				tdCreateDate.textContent   = resultElement["createDate"].substring(0, 10);
				tdAbsolutePath.textContent = resultElement["trashCanPath"];
				tdAbsolutePath.setAttribute("style", "overflow: hidden;text-overflow: ellipsis;white-space: nowrap; word-wrap: normal;");
				tdAbsolutePath.setAttribute("title", resultElement["trashCanPath"]);
				
				trElement.appendChild(tdCheckbox);
				trElement.appendChild(tdFileIcon);
				trElement.appendChild(tdName);
				trElement.appendChild(tdSize);
				trElement.appendChild(tdCreator);
				trElement.appendChild(tdCreateDate);
				trElement.appendChild(tdUpdateDate);
				trElement.appendChild(tdAbsolutePath);
				
				tableList.appendChild(trElement);
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
		search_Set(currentPage);
	}
	function scroll() {
		var BoardList_BODYHeight = document.getElementById("dragDropArea").clientHeight;
		var BoardListDivHeight = document.getElementById("tblFileList").clientHeight;
		
		 if (BoardList_BODYHeight > BoardListDivHeight) {
			if ($("#tblFileList1 tr th#forScroll").length > 0) {
				$("#tblFileList1 tr th#forScroll").remove();
			}
		} else {
			if ($("#tblFileList1 tr th#forScroll").length < 1) {
				$("#tblFileList1 tr th#forScroll").remove();
				$("#tblFileList1 tr").append("<th></th>");
				
					var lastTh = $("#tblFileList1 tr th").last();
					lastTh.attr("id", "forScroll");
					lastTh.css("width", "15px");
					
			}
		}
		 
		/*var lastTh = $("#BoardList_TH th").last();
		if (lastTh.attr("id") == null) {
			lastTh.css("display", "none");
		}*/
	}
}
function optionView(obj) {
	if (obj.getAttribute("mode") == "off") {
		var a_left = $("#wfOptionDiv").offset().left - ($("#layer_Viewpopup").width() - $("#wfOptionDiv").outerWidth());
		var a_top = $("#wfOptionDiv").offset().top + $("#wfOptionDiv").outerHeight() + 2;
		document.getElementById("layer_Viewpopup").style.display = "";
		obj.setAttribute("class", "icon16 btn_onarrow_down");
		obj.setAttribute("mode", "on");
		$("#layer_Viewpopup").css({"left":a_left, "top":a_top});
	} else {
		optionHidden();
	}
}

function optionHidden() {
	document.getElementById("layer_Viewpopup").style.display = "none";
	document.getElementById("webfolderlistoptiondiv").setAttribute("mode", "off");
	document.getElementById("webfolderlistoptiondiv").setAttribute("class", "icon16 btn_arrow_down");
}