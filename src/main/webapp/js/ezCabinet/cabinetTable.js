//Baonk 2018-06-25
function CabinetTable(data) {
	//set public functions
	this.setTableElement  = setTableElement;
	this.setDataSource    = setDataSource;
	this.setTableType     = setTableType;
	this.renderTable      = renderTable;
	this.setCallBack      = setCallBack;
	this.getOrderInfo     = getOrderInfo;
	this.setRenderFunct   = setRenderFunct;
	this.setClickHandler  = setClickHandler;
	this.resetEvents      = resetRowEvents;
	this.getSelectedRow   = getSelectedRow;
	
	//private variables
	var _tableElmt       = null;
	var _tableDataElmt   = null;
	var _selectedClass   = data.selected ? data.selected : "bnkCabSelect";
	var _unselectClass   = data.normal   ? data.normal   : "bnkCabNormal";
	var _lastSelectedRow = null;
	var _dataSource      = null;
	var _tableType       = data.tableType ? data.tableType : "";
	var _callBackSearch  = data.callBack  ? data.callBack  : null;
	var _clickHandler    = data.click     ? data.click     : null;
	var _dblClickHandler = data.dblclick  ? data.dblclick  : null;
	var _renderFunction  = data.render    ? data.render    : null;
	var _cellInfo        = {};
	var _selectedCell    = null;
	var _tableMode       = data.mode ? data.mode : null;
	
	//private functions
	function getOrderInfo() {return _cellInfo;}
	function setRenderFunct(renderFunctName) {_renderFunction = renderFunctName;}
	function setClickHandler(clickHandler) {_clickHandler = clickHandler;}
	function setTableMode(tableMode) {_tableMode = tableMode;}
	function setCallBack(callBackName) {_callBackSearch = callBackName;}
	function setTableType(tableType) {_tableType = tableType;}
	function getSelectedRow() {return _lastSelectedRow;}
	
	function setTableElement(identify, type) {
		switch(type.toLowerCase()) {
			case "class": _tableElmt = document.getElementsByClassName(identify)[0]; break;
			case "id"   : _tableElmt = document.getElementById(identify);break;
		}
		
		if (_tableElmt == null) {throw new Error('Table not found'); return;}
		
		var currentStyle = _tableElmt.getAttribute("style");
		_tableElmt.setAttribute("style", "-webkit-touch-callout: none;-webkit-user-select: none; -khtml-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; " + currentStyle);
		
		if (_tableMode == null) {
			var headerRow    = _tableElmt.rows[0];
			var len          = headerRow.cells.length;
			var firstTd      = headerRow.cells[0];
			var firstTdChild = firstTd.querySelector('input');
			
			if (!firstTdChild || (firstTdChild.tagName).toLowerCase() != "input") {
				firstTd.onclick = function() {sortByHeader(this);};
			}
			
			for (var i = 1; i < len; i++) {
				var cell     = headerRow.cells[i];
				cell.onclick = function() {sortByHeader(this);};
			}
			
			_cellInfo     = {};
			_selectedCell = null;
			
			setTableData();
		}
	}
	
	function setTableData() {
		var parentElmt = _tableElmt.parentElement;
		var tableDataDivElmt = parentElmt.querySelector("div[class='tableDataDiv']");
		if (tableDataDivElmt) {parentElmt.removeChild(tableDataDivElmt);}
		
		var newDivElmt       = document.createElement("div");
		var dataTable        = document.createElement("table");
		newDivElmt.className = "tableDataDiv";
		newDivElmt.appendChild(dataTable);
		parentElmt.appendChild(newDivElmt);
		
		_tableDataElmt = dataTable;
		cloneAttributes(_tableDataElmt, _tableElmt);
	}
	
	function cloneAttributes(destNode, sourceNode) {
		for (var i = 0, atts = sourceNode.attributes, n = atts.length; i < n; i++) {
			destNode.setAttribute(atts[i].nodeName, atts[i].nodeValue);
		}
		
		destNode.removeAttribute("id");
	}
	
	function setDataSource(dataSource) {
		_dataSource = dataSource;
		cleanTable();
	}
	
	//Row process functions
	function sortByHeader(cell) {
		var column = cell.getAttribute("headers");
		
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
				case 0: toggleAllRow(false); selectRowsBetweenIndexes([_lastSelectedRow.rowIndex, currentIdx]); break;
				case 1: toggleRow(currentRow, rowClass); _lastSelectedRow = currentRow; break;
				case 2: toggleAllRow(false); selectRowsBetweenIndexes([0, currentIdx]); break;
			}
		}
	}
	
	function clickRowType2(event) {
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
				toggleRow(currentRow, _selectedClass);
			}
			
			_lastSelectedRow = currentRow;
		}
		
		if (event.shiftKey) {
			var currentIdx = currentRow.rowIndex;
			switch (checkFirstSelect()) {
				case 0: toggleAllRow(false); selectRowsBetweenIndexes([_lastSelectedRow.rowIndex, currentIdx]); break;
				case 1: toggleRow(currentRow, _selectedClass); _lastSelectedRow = currentRow; break;
				case 2: toggleAllRow(false); selectRowsBetweenIndexes([0, currentIdx]); break;
			}
		}
		
		if (_clickHandler != null) {_clickHandler(_lastSelectedRow);}
	}
	
	function checkFirstSelect() {
		var listOfSelectedRows = document.getElementsByClassName(_selectedClass);
		if (_lastSelectedRow == null) {return listOfSelectedRows.length == 0 ? 1 : 2;}
		
		return 0;
	}
	
	function toggleAllRow(flag) {
		var rowClass   = flag == true ? _unselectClass : _selectedClass;
		var setClass   = flag == true ? _selectedClass : _unselectClass;
		var listOfRows = document.getElementsByClassName(rowClass);
		
		for (var i = listOfRows.length - 1; i >= 0; i--) {
			toggleRow(listOfRows[i], setClass);
		}
	}
	
	function toggleRow(row, rowClass) {
		if (_tableMode == null) {
			if (rowClass == _unselectClass) {
				var firstInputCheckBox     = _tableElmt.rows[0].firstElementChild.firstElementChild.querySelector("input");
				firstInputCheckBox.checked = false;
			}
			
			var checkboxElmt     = row.firstElementChild.firstElementChild.querySelector("input");
			checkboxElmt.checked = rowClass == _selectedClass ? true : false;
		}
		
		row.className = rowClass;
	}
	
	function selectRowsBetweenIndexes(indexArr) {
		indexArr.sort(function(a, b) {return a - b;});
		var tableMainELmt = _tableMode == null ? _tableDataElmt : _tableElmt;
		
		var listOfRows = tableMainELmt.rows;
		
		for (var i = indexArr[0] + 1; i <= indexArr[1] + 1; i++) {
			toggleRow(listOfRows[i-1], _selectedClass);
		}
	}
	
	// process checkbox
	function getChecked(event) {
		event.stopPropagation();
		
		var checkboxElmt     = event.currentTarget;
		var currentRow       = checkboxElmt.parentElement.closest('tr');
		_lastSelectedRow     = currentRow;
		currentRow.className = checkboxElmt.checked ? _selectedClass : _unselectClass;
	} 
	
	// process table function
	function renderTable() {
		switch (_tableType) {
			case 'cabinet'  : _renderFunction(_dataSource, _unselectClass, _tableDataElmt, getChecked, clickRowType2); break;
			case 'capacity' : _renderFunction(_dataSource, _unselectClass, _tableDataElmt, getChecked, clickRow)     ; break;
			case 'files'    : _renderFunction(_dataSource, _unselectClass, _tableElmt, clickRow)                     ; break;
		}
		
		_lastSelectedRow = null;
	}
	
	function cleanTable() {
		if (_tableMode == null) {
			var firstInputCheckBox = _tableElmt.rows[0].firstElementChild.firstElementChild.querySelector("input");
			if (firstInputCheckBox) {
				firstInputCheckBox.checked = false; //Clear first input check box
				firstInputCheckBox.onclick = function(e) {toggleAllRow(this.checked);};
			}
			
			while (_tableDataElmt.rows.length > 0) {
				_tableDataElmt.deleteRow(0);
			}
		}
		else {
			while (_tableElmt.rows.length > 1) {
				_tableElmt.deleteRow(1);
			}
		}
	}
	
	function resetRowEvents() {
		if (_tableMode != "received") {return;}
		
		var listOfRows = _tableElmt.rows;
		
		for (var i = 0, len = listOfRows.length; i < len; i++) {
			listOfRows[i].onclick = function(e) {clickRow(e);};
			listOfRows[i].ondblclick = function(e) {_dblClickHandler(this);};
		}
	}
}
