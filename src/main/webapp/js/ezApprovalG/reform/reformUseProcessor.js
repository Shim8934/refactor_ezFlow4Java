var reformUseProc = {};
var kNullIndexValue = "-9753579";
var isIE10 = navigator.appVersion.indexOf("MSIE 10") !== -1;

reformUseProc.isLoaded = false;
reformUseProc.dataBindCache = {};

reformUseProc.executeQuery = function(dataBindControlID, documentOfDataBindControl, sqlParamList, completionHandler, errorHandler) {
	var reformServerUrl = "/reform/executeQuery.do";
	
	var dataBindControl = documentOfDataBindControl.getElementById(dataBindControlID);
	if (dataBindControl == null) {
		alert(dataBindControlID + message["error.notfound.databindcontrol"]);
		return;
	}
	
	var dataBindControlObject = JSON.parse(dataBindControl.getAttribute("value"));
	var dataSource = dataBindControlObject.dataSource;
	var sqlQuery = dataBindControlObject.sql;
	
	if (sqlParamList == null) {
		sqlParamList = [];
	}
	var paramListInJSON = JSON.stringify(sqlParamList);
	var postData = "dataSource=" + encodeURIComponent(dataSource) + "&sqlQuery=" + encodeURIComponent(sqlQuery) + "&sqlParamList=" + encodeURIComponent(paramListInJSON);
	var dataBindkey = dataBindControlID + sqlParamList;
	if (reformUseProc.dataBindCache[dataBindkey] != null) {
		return completionHandler(reformUseProc.dataBindCache[dataBindkey]);
	} else {
		var xmlhttp = createXMLHttpRequest();
		xmlhttp.open("POST", reformServerUrl, false);
		xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
		xmlhttp.send(postData);
		if (xmlhttp.readyState == 4) {
			if (xmlhttp.status == 200) {
				var resultSet = JSON.parse(xmlhttp.responseText);
				reformUseProc.dataBindCache[dataBindkey] = resultSet;
				
				return completionHandler(resultSet);
			} else {
				errorHandler(xmlhttp.status);
				return false;
			}
		}
	}
};

reformUseProc.showSelectionDialog = function(gridData, headerData, completionHandler) {
	var url = "/ezApprovalG/reform/selectionDialog.do";
	var args = {};
	args.gridData = gridData;
	args.headerData = headerData;
	var result = null;
	if (window.showModalDialog) {
		result = window.showModalDialog(url, args, "status:no;dialogWidth:500px;dialogHeight:300px;edge:sunken;scroll:no");
		completionHandler(result);
	} else {
		window.argsForSelectionDialog = args;
		window.completionHandlerForSelectionDialog = completionHandler;
		GetOpenWindow(url, "", 500, 300, "NO");
	}
};

reformUseProc.isRadioButtons = function(controls) {
	if (reformUseProc.isIE8OrBelow()) {
		return (controls + "") == "[object HTMLCollection]"
	} else {
		return controls.toString() == "[object HTMLCollection]" || controls.toString() == "[object NodeList]";
	}
};

reformUseProc.getFirstDataRowIndex = function(grid) {
	var firstDataRowIndex;
	var firstCell;
	for (var i = 0; i < grid.rows.length; i++) {
		firstCell = grid.rows[i].cells[0];
		if (firstCell.tagName != "TH") {
			firstDataRowIndex = i;
			break;
		}
	}
	
	return firstDataRowIndex;
};

reformUseProc.restoreGridColor = function(grid) {
	for (var i = 0; i < grid.rows.length; i++) {
		var row = grid.rows[i];
		for (var j = 0; j < row.cells.length; j++) {
			var cell = row.cells[j];
			var attValue = cell.getAttribute("data-reform_background_color");
			if (attValue != null) {
				cell.style.backgroundColor = attValue;
			}
			attValue = cell.getAttribute("data-reform_color");
			if (attValue != null) {
				cell.style.color = attValue;
			}
		}
	}
};

reformUseProc.getControlType = function(controlElement) {
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	
	return controlType;
};

reformUseProc.isGridControlHasChildControl = function(controlElement) {
	var rc = false;
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	
	if (controlType == "grid") {
		for (var i = 0; i < controlElement.rows.length; i++) {
			var row = controlElement.rows[i];
			for (var j = 0; j < row.cells.length; j++) {
				var cell = row.cells[j];
				for (var k = 0; k < cell.children.length; k++) {
					var child = cell.children[k];
					var attValue = child.getAttribute("data-reform_flag");
					if (attValue == "1") {
						return true;
					}
					
					for (var m = 0; m < child.children.length; m++) {
						var subchild = child.children[m];
						var attValue = subchild.getAttribute("data-reform_flag");
						if (attValue == "1") {
							return true;
						}
					}
				}
			}
		}
	}
	
	return rc;
};

reformUseProc.setChildControlInGridCell = function(child, rowData, rowIndex) {
	var controlType = reformUseProc.getControlType(child);
	if (controlType == "text" || controlType == "grid") {
		var dbValueColumn = "";
		var dbValueColumnValue = child.getAttribute("data-reform_data_bind_value_column");
		if (dbValueColumnValue != null) {
			dbValueColumn = dbValueColumnValue.toUpperCase();
		}
		
		if (dbValueColumn != "") {
			var colData = (dbValueColumn == "__REFORM_SEQNO") ? (rowIndex + 1).toString() : (rowData != null) ? rowData[dbValueColumn] : "";
			
			if (controlType == "grid") {
				var cell = child.rows[0].cells[0];
				cell.innerHTML = colData;
			} else if (controlType == "text") {
				reformUseProc.setControlValue(child, colData);
			}
		}
	}
};

reformUseProc.setAllChildControlsInGridCell = function(cell, rowData, rowIndex) {
	for (var childIndex = 0; childIndex < cell.children.length; childIndex++) {
		var child = cell.children[childIndex];
		var attValue = child.getAttribute("data-reform_flag");
		// in case of a reform control
		if (attValue == "1") {
			reformUseProc.setChildControlInGridCell(child, rowData, rowIndex)
		}
		// in case of non-reform control like p tag
		else {
			// check if it contains reform controls.
			for (var subChildIndex = 0; subChildIndex < child.children.length; subChildIndex++) {
				var subchild = child.children[subChildIndex];
				attValue = subchild.getAttribute("data-reform_flag");
				if (attValue == "1") {
					reformUseProc.setChildControlInGridCell(subchild, rowData, rowIndex)
				}
			}
		}
	}
};

reformUseProc.updateChildControlIdInGridCell = function(child) {
	var controlType = reformUseProc.getControlType(child);
	var newId = (controlType == "radio") ? child.name : child.id;
	var orgId = child.getAttribute("data-reform_org_id");
	
	if (orgId == null) {
		child.setAttribute("data-reform_org_id", newId);
		orgId = newId;
	}
	
	var reformRowIndex = child.getAttribute("data-reform_row_index");
	
	// in case it's in the first cloned row, it's given the row index of 1.
	if (reformRowIndex == null) {
		child.setAttribute("data-reform_row_index", "1");
		reformRowIndex = "1";
	}
	// in case it's in the non-first cloned row.
	else {
		reformRowIndex = parseInt(reformRowIndex) + 1;
		reformRowIndex = reformRowIndex.toString();
		child.setAttribute("data-reform_row_index", reformRowIndex);
	}
	
	newId = orgId + "_" + reformRowIndex;
	
	if (controlType == "radio") {
		child.name = newId;
	} else {
		child.id = newId;
	}
};

reformUseProc.updateAllChildControlIdsAndReturnFirstControlInGridRow = function(row) {
	var firstControl = null;
	for (var i = 0; i < row.cells.length; i++) {
		var cell = row.cells[i];
		for (var j = 0; j < cell.children.length; j++) {
			var child = cell.children[j];
			var attValue = child.getAttribute("data-reform_flag");
			if (attValue == "1") {
				reformUseProc.updateChildControlIdInGridCell(child);
				if (reformUseProc.getControlType(child) == "text") {
					var attValue = child.getAttribute("data-reform_date_picker_flag");
					if (attValue == "1") {
						// this is required in order to reinstall a date picker
						// after this control is used for a date picker since
						// a date picker isn't installed when the value of the class is 'hasDatepicker'.
						child.removeAttribute("class");
						
						var dateFormatAttValue = child.getAttribute("data-reform_date_format");
						$(child).datepicker({
							changeMonth: true,
							changeYear: true,
							autoSize: true,
							dateFormat: dateFormatAttValue ? dateFormatAttValue : "yy-mm-dd"
						});
					} else {
						attValue = child.getAttribute("data-reform_time_picker_flag");
						if (attValue == "1") {
							child.removeAttribute("class");
							
							var timeFormatAttValue = child.getAttribute("data-reform_time_format");
							var timeGapAttValue = child.getAttribute("data-reform_time_gap");
							var timeGap = parseInt(timeGapAttValue);
							$(child).timepicker({
								'timeFormat': timeFormatAttValue ? timeFormatAttValue : 'H:i',
								'step': timeGap
							});
						}
					}
					
					reformUseProc.setTextBoxValue(child, "");
				} else if (reformUseProc.getControlType(child) == "grid") {
					child.rows[0].cells[0].innerHTML = "";
				} else if (reformUseProc.getControlType(child) == "radio") {
					child.removeAttribute("checked");
					child.checked = false;
				} else if (reformUseProc.getControlType(child) == "textarea") {
					reformUseProc.setControlValue(child, "");
				}
				
				if (firstControl == null) {
					firstControl = child;
				}
			} else {
				if (child.tagName == "TABLE") {
					for (var tr = 0; tr < child.rows.length; tr++) {
						var trow = child.rows[tr];
						var trFirstControl = reformUseProc.updateAllChildControlIdsAndReturnFirstControlInGridRow(trow);
						
						if (firstControl == null) {
							firstControl = trFirstControl;
						}
					}
				} else {
					for (var k = 0; k < child.children.length; k++) {
						var subchild = child.children[k];
						var attValue = subchild.getAttribute("data-reform_flag");
						if (attValue == "1") {
							reformUseProc.updateChildControlIdInGridCell(subchild);
							if (reformUseProc.getControlType(subchild) == "text") {
								var attValue = subchild.getAttribute("data-reform_date_picker_flag");
								if (attValue == "1") {
									// this is required in order to reinstall a date picker
									// after this control is used for a date picker since
									// a date picker isn't installed when the value of the class is 'hasDatepicker'.
									subchild.removeAttribute("class");
									
									var dateFormatAttValue = subchild.getAttribute("data-reform_date_format");
									$(subchild).datepicker({
										changeMonth: true,
										changeYear: true,
										autoSize: true,
										dateFormat: dateFormatAttValue ? dateFormatAttValue : "yy-mm-dd"
									});
								} else {
									attValue = subchild.getAttribute("data-reform_time_picker_flag");
									if (attValue == "1") {
										subchild.removeAttribute("class");
										
										var timeFormatAttValue = subchild.getAttribute("data-reform_time_format");
										var timeGapAttValue = subchild.getAttribute("data-reform_time_gap");
										var timeGap = parseInt(timeGapAttValue);
										$(subchild).timepicker({
											'timeFormat': timeFormatAttValue ? timeFormatAttValue : 'H:i',
											'step': timeGap
										});
									}
								}
								
								reformUseProc.setTextBoxValue(subchild, "");
							} else if (reformUseProc.getControlType(subchild) == "grid") {
								subchild.rows[0].cells[0].innerHTML = "";
							} else if (reformUseProc.getControlType(subchild) == "radio") {
								subchild.removeAttribute("checked");
								subchild.checked = false;
							} else if (reformUseProc.getControlType(subchild) == "textarea") {
								reformUseProc.setControlValue(subchild, "");
							}
							
							if (firstControl == null) {
								firstControl = subchild;
							}
						} else {
							if (subchild.tagName == "TABLE") {
								for (var tr = 0; tr < subchild.rows.length; tr++) {
									var trow = subchild.rows[tr];
									var trFirstControl = reformUseProc.updateAllChildControlIdsAndReturnFirstControlInGridRow(trow);
									
									if (firstControl == null) {
										firstControl = trFirstControl;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	return firstControl;
};

reformUseProc.updateChildControlIdInGridCellForRemoving = function(child) {
	var controlType = reformUseProc.getControlType(child);
	var reformRowIndex = child.getAttribute("data-reform_row_index");
	var orgId = child.getAttribute("data-reform_org_id");
	
	if (reformRowIndex != null && orgId != null) {
		reformRowIndex = parseInt(reformRowIndex) - 1;
		reformRowIndex = reformRowIndex.toString();
		child.setAttribute("data-reform_row_index", reformRowIndex);
		var newId = orgId + "_" + reformRowIndex;
		
		if (controlType == "radio") {
			child.name = newId;
		} else {
			child.id = newId;
		}
	}
};

reformUseProc.updateAllChildControlIdsInGridRowForRemoving = function(row) {
	for (var i = 0; i < row.cells.length; i++) {
		var cell = row.cells[i];
		for (var j = 0; j < cell.children.length; j++) {
			var child = cell.children[j];
			var attValue = child.getAttribute("data-reform_flag");
			if (attValue == "1") {
				reformUseProc.updateChildControlIdInGridCellForRemoving(child);
			} else {
				for (var k = 0; k < child.children.length; k++) {
					var subchild = child.children[k];
					var attValue = subchild.getAttribute("data-reform_flag");
					if (attValue == "1") {
						reformUseProc.updateChildControlIdInGridCellForRemoving(subchild);
					}
				}
			}
		}
	}
};

// invoke the specified data loaded event handler
reformUseProc.callDataLoadedHandler = function(controlElement) {
	var dataLoadedHandler = controlElement.getAttribute("data-reform_on_data_loaded");
	if (dataLoadedHandler != null && dataLoadedHandler != "") {
		var handler = new Function("controlElement", "return " + dataLoadedHandler + "(controlElement);");
		try {
			handler(controlElement);
		} catch (e) {}
	}
};

reformUseProc.doDataLoad = function(controls) {
	var controlElement;
	var controlID;
	if (reformUseProc.isRadioButtons(controls)) {
		controlElement = controls[0];
		controlID = controlElement.name;
	} else {
		controlElement = controls;
		controlID = controlElement.id;
	}
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") { // in case of grid control
		controlType = controlElement.getAttribute("data-type");
	}
	var dataBindControlID = controlElement.getAttribute("data-reform_data_bind_source");
	if (dataBindControlID == null) {
		return;
	}
	
	var dataBindValueColumn = "";
	var dataBindValueColumnValue = controlElement.getAttribute("data-reform_data_bind_value_column");
	if (dataBindValueColumnValue != null) {
		dataBindValueColumn = dataBindValueColumnValue.toUpperCase();
	}
	
	var dataBindDisplayColumn = "";
	var dataBindDisplayColumnValue = controlElement.getAttribute("data-reform_data_bind_display_column");
	if (dataBindDisplayColumnValue != null) {
		dataBindDisplayColumn = dataBindDisplayColumnValue.toUpperCase();
	}
	
	var paramControlListValue = controlElement.getAttribute("data-reform_param_control_list");
	var paramList = [];
	if (paramControlListValue != null && paramControlListValue != "") {
		var paramControlList = paramControlListValue.split(",");
		for (var i = 0; i < paramControlList.length; i++) {
			var isGrid = false;
			var paramControlId = paramControlList[i];
			var paramControl = document.getElementById(paramControlId);
			if (paramControl == null) {
				paramControl = document.getElementsByName(paramControlId);
			} else {
				var dataType = paramControl.getAttribute("data-type");
				if (dataType == "grid") {
					isGrid = true;
				}
			}
			
			if (paramControl != null) {
				if (isGrid) {
					var gridValue = paramControl.getAttribute("data-reform_value");
					if (gridValue != null) {
						paramList[i] = gridValue;
					} else {
						return;
					}
				} else if (reformUseProc.isRadioButtons(paramControl)) {
					var radioControl;
					var isFound = false;
					for (var radioIndex = 0; radioIndex < paramControl.length; radioIndex++) {
						radioControl = paramControl[radioIndex];
						if (radioControl.checked) {
							paramList[i] = radioControl.value;
							isFound = true;
							break;
						}
					}
					if (!isFound) {
						return;
					}
				} else if (paramControl.value != null) {
					if (paramControl.type == "checkbox") {
						if (paramControl.checked) {
							paramList[i] = paramControl.value;
						} else {
							paramList[i] = kNullIndexValue;
						}
					} else if (paramControl.type == "button") {
						var buttonValue = paramControl.getAttribute("data-reform_value");
						if (buttonValue != null) {
							paramControl.removeAttribute("data-reform_value");
						} else {
							return;
						}
					} else {
						paramList[i] = paramControl.value;
					}
				} else {
					return;
				}
			} else {
				return;
			}
		}
	}
	
	this.executeQuery(dataBindControlID, document, paramList, function(resultSet) {
		var error = resultSet["error"];
		if (typeof (error) !== "undefined") {
			// Result Set을 반환하지 않는 Stored Procedure를 호출한 경우에는
			// error가 null이 되며, 이 경우에는 alert 창을 표시하지 않는다.
			if (error != null) {
				alert(controlID + ": " + error);
			}
			return;
		}
		
		if (controlType == "select-one") {
			controlElement.setAttribute("onchange", "reformUseProc.defaultChangeHandler(this);");
			
			// remove the current data
			while (controlElement.hasChildNodes()) {
				controlElement.removeChild(controlElement.lastChild);
			}
			
			if (resultSet.length > 0) {
				var sizeValue = controlElement.getAttribute("size");
				
				// add a header if it's a drop-down list box.
				if (sizeValue == null || sizeValue == 0 || sizeValue == 1) {
					var header = controlElement.getAttribute("data-reform_header");
					var valueCol = kNullIndexValue;
					var displayCol = header != null ? header : "";
					
					var optionElement = document.createElement("OPTION");
					optionElement.text = displayCol;
					optionElement.value = valueCol;
					controlElement.appendChild(optionElement);
				}
				// end
				
				for (var j = 0; j < resultSet.length; j++) {
					var row = resultSet[j];
					var valueCol = row[dataBindValueColumn];
					var displayCol = row[dataBindDisplayColumn];
					
					optionElement = document.createElement("OPTION");
					textNode = document.createTextNode(displayCol);
					optionElement.appendChild(textNode);
					optionElement.setAttribute("value", valueCol);
					
					controlElement.appendChild(optionElement);
				}
			}
			
			var referencingControlListValue = controlElement.getAttribute("data-reform_referencing_control_list");
			if (referencingControlListValue != null && referencingControlListValue != "") {
				var referencingControlList = referencingControlListValue.split(",");
				for (var i = 0; i < referencingControlList.length; i++) {
					var referencingControlId = referencingControlList[i];
					var referencingControl = document.getElementById(referencingControlId);
					if (referencingControl == null) {
						referencingControl = document.getElementsByName(referencingControlId);
					}
					if (referencingControl != null) {
						reformUseProc.doReset(referencingControl);
					}
				}
			}
		} else if (controlType == "text" || controlType == "textarea") {
			var eventName = "";
			
			if (controlElement.hasAttribute("data-reform_date_picker_flag") || controlElement.hasAttribute("data-reform_time_picker_flag")) {
				eventName = "onchange";
			} else {
				eventName = "oninput";
			}
			
			controlElement.setAttribute(eventName, "reformUseProc.defaultChangeHandler(this);");
			
			// remove the current data
			controlElement.value = "";
			
			// number of rows must be 1.
			if (resultSet.length == 1) {
				var row = resultSet[0];
				var valueCol = row[dataBindValueColumn];
				controlElement.value = valueCol;
			}
			
			reformUseProc.defaultChangeHandler(controlElement);
		} else if (controlType == "checkbox") {
			var attValue = controlElement.getAttribute("readonly");
			if (attValue == null || attValue == "") {
				if (!reformUseProc.isIE8OrBelow()) {
					controlElement.setAttribute("onchange", "reformUseProc.defaultChangeHandler(this);");
				}
			}
			
			// number of rows must be 1.
			if (resultSet.length == 1) {
				var row = resultSet[0];
				var valueCol = row[dataBindValueColumn];
				if (controlElement.value == valueCol) {
					controlElement.checked = true;
				} else {
					controlElement.checked = false;
				}
			}
			
			reformUseProc.defaultChangeHandler(controlElement);
		} else if (controlType == "radio") {
			var radioControl;
			for (var i = 0; i < controls.length; i++) {
				radioControl = controls[i];
				if (!reformUseProc.isIE8OrBelow()) {
					radioControl.setAttribute("onchange", "reformUseProc.defaultChangeHandler(document.getElementsByName(this.name));");
				}
				
				// remove the current selection
				radioControl.checked = false;
			}
			
			// number of rows must be 1.
			if (resultSet.length == 1) {
				var row = resultSet[0];
				var valueCol = row[dataBindValueColumn];
				
				for (var i = 0; i < controls.length; i++) {
					radioControl = controls[i];
					if (radioControl.value == valueCol) {
						radioControl.checked = true;
					}
				}
			}
			
			reformUseProc.defaultChangeHandler(controls);
		} else if (controlType == "grid") {
			reformUseProc.restoreGridColor(controlElement);
			
			var firstRowIndex = reformUseProc.getFirstDataRowIndex(controlElement);
			var firstRow = controlElement.rows[firstRowIndex];
			
			var footer = controlElement.tFoot;
			var footerRowCount = (footer != null) ? footer.rows.length : 0;
			
			controlElement.setAttribute("data-reform_row_count", resultSet.length.toString());
			
			var displayColumns = (dataBindDisplayColumn != "") ? dataBindDisplayColumn.split(",") : null;
			var gridRowCount = controlElement.rows.length - firstRowIndex - footerRowCount;
			for (var rowIndex = 0; rowIndex < resultSet.length; rowIndex++) {
				var rowData = resultSet[rowIndex];
				var row;
				// reuse the existing rows
				if (rowIndex < gridRowCount) {
					row = controlElement.rows[rowIndex + firstRowIndex];
				}
				// create new rows
				else {
					row = controlElement.rows[rowIndex + firstRowIndex - 1].cloneNode(true);
					
					if (displayColumns == null) {
						reformUseProc.updateAllChildControlIdsAndReturnFirstControlInGridRow(row);
					}
					
					// children[0] is a tbody element
					controlElement.children[0].appendChild(row);
				}
				
				// set the key value
				var keyValue = (dataBindValueColumn != "") ? rowData[dataBindValueColumn] : "";
				row.setAttribute("data-reform_value", keyValue);
				
				// show the display columns
				if (displayColumns != null) {
					for (var colIndex = 0; colIndex < displayColumns.length; colIndex++) {
						var columnName = displayColumns[colIndex].trim();
						var colData = (columnName == "__REFORM_SEQNO") ? (rowIndex + 1).toString() : rowData[columnName];
						var cell = row.cells[colIndex];
						
						cell.innerHTML = colData;
					}
				} else {
					for (var colIndex = 0; colIndex < row.cells.length; colIndex++) {
						var cell = row.cells[colIndex];
						reformUseProc.setAllChildControlsInGridCell(cell, rowData, rowIndex);
					}
				}
			}
			
			rowIndex += firstRowIndex;
			for (var i = controlElement.rows.length - 1 - footerRowCount; i >= rowIndex; i--) {
				if (i == firstRowIndex) {
					var row = controlElement.rows[i];
					row.removeAttribute("data-reform_value");
					
					for (var j = 0; j < row.cells.length; j++) {
						var cell = row.cells[j];
						
						if (displayColumns != null) {
							cell.innerHTML = "";
						} else {
							reformUseProc.setAllChildControlsInGridCell(cell, null, -1);
						}
					}
				} else {
					controlElement.deleteRow(i);
				}
			}
			
			// invoke the specified data loaded event handler
			reformUseProc.callDataLoadedHandler(controlElement);
			
			var referencingControlListValue = controlElement.getAttribute("data-reform_referencing_control_list");
			if (referencingControlListValue != null && referencingControlListValue != "") {
				var referencingControlList = referencingControlListValue.split(",");
				for (var i = 0; i < referencingControlList.length; i++) {
					var referencingControlId = referencingControlList[i];
					var referencingControl = document.getElementById(referencingControlId);
					if (referencingControl == null) {
						referencingControl = document.getElementsByName(referencingControlId);
					}
					if (referencingControl != null) {
						reformUseProc.doReset(referencingControl);
					}
				}
			}
		}
	}, function(httpStatusCode) {
		alert("An error happend. httpStatusCode=" + httpStatusCode);
	});
};

reformUseProc.doReset = function(controls) {
	var controlElement;
	if (reformUseProc.isRadioButtons(controls)) {
		controlElement = controls[0];
	} else {
		controlElement = controls;
	}
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	
	if (controlType == "select-one") {
		while (controlElement.hasChildNodes()) {
			controlElement.removeChild(controlElement.lastChild);
		}
	} else if (controlType == "text") {
		controlElement.value = "";
		controlElement.setAttribute("value", controlElement.value);
	} else if (controlType == "checkbox") {
		controlElement.checked = false;
		controlElement.removeAttribute("checked");
	} else if (controlType == "radio") {
		var radioControl;
		for (var i = 0; i < controls.length; i++) {
			radioControl = controls[i];
			radioControl.checked = false;
			radioControl.removeAttribute("checked");
		}
	} else if (controlType == "grid") {
		var dataBindDisplayColumn = controlElement.getAttribute("data-reform_data_bind_display_column");
		dataBindDisplayColumn = (dataBindDisplayColumn != null) ? dataBindDisplayColumn : "";
		
		reformUseProc.restoreGridColor(controlElement);
		var firstDataRowIndex = reformUseProc.getFirstDataRowIndex(controlElement);
		var startIndex = firstDataRowIndex + 1;
		
		controlElement.setAttribute("data-reform_row_count", "0");
		
		var footer = controlElement.tFoot;
		var footerRowCount = (footer != null) ? footer.rows.length : 0;
		
		for (var i = controlElement.rows.length - 1 - footerRowCount; i >= startIndex; i--) {
			controlElement.deleteRow(i);
		}
		
		var row = controlElement.rows[firstDataRowIndex];
		row.removeAttribute("data-reform_value");
		
		for (var i = 0; i < row.cells.length; i++) {
			var cell = row.cells[i];
			
			if (dataBindDisplayColumn != "") {
				cell.innerHTML = "";
			} else {
				reformUseProc.setAllChildControlsInGridCell(cell, null, -1);
			}
		}
		
		// invoke the specified data loaded event handler
		reformUseProc.callDataLoadedHandler(controlElement);
	}
	
	var referencingControlListValue = controlElement.getAttribute("data-reform_referencing_control_list");
	if (referencingControlListValue != null && referencingControlListValue != "") {
		var referencingControlList = referencingControlListValue.split(",");
		for (var i = 0; i < referencingControlList.length; i++) {
			var referencingControlId = referencingControlList[i];
			var referencingControl = document.getElementById(referencingControlId);
			if (referencingControl == null) {
				referencingControl = document.getElementsByName(referencingControlId);
			}
			if (referencingControl != null) {
				this.doReset(referencingControl);
			}
		}
	}
	
	reformUseProc.resizeFrame();
};

reformUseProc.removeOnClickHandlerFromGrid = function(controlElement) {
	if (reformUseProc.getControlType(controlElement) == "grid") {
		controlElement.removeAttribute("onclick");
		controlElement.style.outline = "";
		
		for (var i = 0; i < controlElement.rows.length; i++) {
			var row = controlElement.rows[i];
			for (var j = 0; j < row.cells.length; j++) {
				var cell = row.cells[j];
				cell.removeAttribute("onclick");
				cell.style.outline = "";
			}
		}
	}
}

reformUseProc.addOnClickHandlerToGrid = function(controlElement) {
	if (reformUseProc.getControlType(controlElement) == "grid") {
		controlElement.onclick = reform_onClickHandler;
		
		for (var i = 0; i < controlElement.rows.length; i++) {
			var row = controlElement.rows[i];
			for (var j = 0; j < row.cells.length; j++) {
				var cell = row.cells[j];
				cell.onclick = reform_onClickHandler;
			}
		}
	}
}

reformUseProc.onBeforeLoadHandler = function() {
	if (typeof (reform_onBeforeLoadHandler) !== "undefined") {
		reform_onBeforeLoadHandler();
	}
};

// performs the page init on page load.
reformUseProc.onLoadHandler = function() {
	reformUseProc.isLoaded = true;
	
	var stageName = reformUseProc.getCurrentStage();
	var isRedraft = false;
	var isReuse = false;
	
	if (window.parent && parent.parent) {
		isRedraft = parent.parent.pDraftFlag === "REDRAFT";
		isReuse = parent.parent.isUsed === "reuse";
	}
	
	// hide hidden controls
	var listSrc = document.getElementById("__reform_hidden_control_list");
	if (listSrc) {
		var reform_control_list = JSON.parse(listSrc.getAttribute("value"));
		
		for (var i = 0; i < reform_control_list.length; i++) {
			var controlId = reform_control_list[i];
			var controlElement = document.getElementById(controlId);
			if (controlElement != null) {
				controlElement.style.display = "none";
			}
		}
	}
	
	// reformScriptCode only exists when called in the 'reformPreviewContent.aspx'
	if (typeof (reformScriptCode) !== "undefined" && reformScriptCode != null) {
		// this dynamically adds script code for Preview mode.
		reformUseProc.addScriptCode(reformScriptCode);
	}
	
	if (typeof (reform_onBeforeLoadHandler) !== "undefined") {
		reform_onBeforeLoadHandler();
	}
	
	// set the value of the controls specified by passed in query parameters.
	if (location.search != null && location.search != "") {
		var queryString = location.search.substring(1);
		var pairs = queryString.split("&");
		for (var i = 0; i < pairs.length; i++) {
			var keyAndValue = pairs[i].split("=");
			if (keyAndValue[0] != "client_script") {
				var controlId = keyAndValue[0];
				var value = keyAndValue[1];
				var controlElement = document.getElementById(controlId);
				if (controlElement != null) {
					var controlType = controlElement.type;
					if (controlType == "text") {
						// at present, only text type controls can be set by query parameters.
						controlElement.value = value;
						controlElement.setAttribute("value", value);
					}
				}
			}
		}
	}
	
	listSrc = document.getElementById("__reform_no_data_bound_control_list");
	var reform_no_data_bound_control_list;
	if (listSrc) {
		reform_no_data_bound_control_list = JSON.parse(listSrc.getAttribute("value"));
		
		for (var i = 0; i < reform_no_data_bound_control_list.length; i++) {
			var controlID = reform_no_data_bound_control_list[i];
			var controlElement = document.getElementById(controlID);
			if (controlElement == null) {
				controlElement = document.getElementsByName(controlID);
			}
			if (controlElement != null) {
				if (reformUseProc.isRadioButtons(controlElement)) {
					var radioControl;
					for (var j = 0; j < controlElement.length; j++) {
						radioControl = controlElement[j];
						var attValue = radioControl.getAttribute("readonly");
						if (attValue == null || attValue == "") {
							if (!reformUseProc.isIE8OrBelow()) {
								radioControl.setAttribute("onchange", "reformUseProc.defaultChangeHandler(document.getElementsByName(this.name));");
							}
						}
					}
				} else if (controlElement.type == "checkbox") {
					var attValue = controlElement.getAttribute("readonly");
					if (attValue == null || attValue == "") {
						// in IE 8, onchange event for checkbox & radio button happens when it loses the focus after the user clicks
						// the control, so for those controls, onchange handler isn't used, but onclick handler is used instead.
						if (!reformUseProc.isIE8OrBelow()) {
							controlElement.setAttribute("onchange", "reformUseProc.defaultChangeHandler(this);");
						}
					}
				} else if (typeof (controlElement.type) !== "undefined" && controlElement.type != "button") {
					var eventName;
					if (controlElement.type == "text" || controlElement.type === "textarea") {
						if (controlElement.hasAttribute("data-reform_date_picker_flag") || controlElement.hasAttribute("data-reform_time_picker_flag")) {
							eventName = "onchange";
						} else {
							eventName = "oninput";
						}
					} else {
						eventName = "onchange";
					}
					
					controlElement.setAttribute(eventName, "reformUseProc.defaultChangeHandler(this);");
					
					if (controlElement.type == "textarea") {
						controlElement.addEventListener("blur", function(e) {
							var target = e.target;
							if (target.hasAttribute("value")) {
								target.innerHTML = target.getAttribute("value");
							}
						});
					}
				}
			}
		}
	}
	
	listSrc = document.getElementById("__reform_control_list");
	if (listSrc) {
		var reform_control_list = JSON.parse(listSrc.getAttribute("value"));
		
		for (var i = 0; i < reform_control_list.length; i++) {
			var controlId = reform_control_list[i];
			var controlElement = document.getElementById(controlId);
			if (controlElement != null) {
				controlElement.style.outline = "";
				
				var dataType = controlElement.getAttribute("data-type");
				if (dataType == "grid") {
					if (reformUseProc.getFirstDataRowIndex(controlElement) == 0) {
						var row = controlElement.rows[0];
						// if grid has no header and only have one column,
						// this grid is regarded to be used for loading HTML data
						// and its class is removed here.
						if (row.cells.length == 1) {
							controlElement.removeAttribute("class");
						}
					}
					
					if (reformUseProc.isGridControlHasChildControl(controlElement)) {
						// if grid has a child control, this grid is regarded to be
						// used for containing other controls instead of data
						// and its class is removed here.
						controlElement.removeAttribute("class");
					}
					
					// remove the onclick attributes and just install the onclick handler using property
					// so that the onclick attributes aren't saved with HTML tags.
					reformUseProc.removeOnClickHandlerFromGrid(controlElement);
					reformUseProc.addOnClickHandlerToGrid(controlElement);
				}
			}
		}
	}
	
	// set up date picker controls
	listSrc = document.getElementById("__reform_date_picker_list");
	if (listSrc) {
	
		var lang = "ko";
		if (stageName == "draft" && typeof(userLang) != "undefined") {
			switch (userLang) {
		    	case "1": 
		    		lang = "ko";
		    		break;
				case "2": 
		    		lang = "en";
		    		break;
		    	case "3": 
		    		lang = "ja";
		    		break;
		    	default :
		    		lang = "ko";
		    		break;
	    	}
		}
		
		$.datepicker.regional['ko'] = {
			closeText: '닫기',
			prevText: '이전달',
			nextText: '다음달',
			currentText: '오늘',
			monthNames: [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			monthNamesShort: [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			dayNames: [ '일', '월', '화', '수', '목', '금', '토' ],
			dayNamesShort: [ '일', '월', '화', '수', '목', '금', '토' ],
			dayNamesMin: [ '일', '월', '화', '수', '목', '금', '토' ],
			weekHeader: 'Wk',
			dateFormat: 'yy-mm-dd',
			firstDay: 0,
			isRTL: false,
			duration: 200,
			showAnim: 'show',
			showMonthAfterYear: true
		};
		
		$.datepicker.regional['ja'] = {
			closeText: '閉じる',
			prevText: '前月',
			nextText: '来月',
			currentText: '今日',
			monthNames: [ '1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月' ],
			monthNamesShort: [ '1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月' ],
			dayNames: [ '日', '月', '火', '水', '木', '金', '土' ],
			dayNamesShort: [ '日', '月', '火', '水', '木', '金', '土'  ],
			dayNamesMin: [ '日', '月', '火', '水', '木', '金', '土'  ],
			weekHeader: 'Wk',
			dateFormat: 'yy-mm-dd',
			firstDay: 0,
			isRTL: false,
			duration: 200,
			showAnim: 'show',
			showMonthAfterYear: true
		};
		
		$.datepicker.regional['en'] = {
			closeText: "Close",
			prevText: "Previous month",
			nextText: "Next month",
			currentText: "Today",
			monthNames: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
			monthNamesShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
			dayNames: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
			dayNamesShort: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
			dayNamesMin: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" ],
			weekHeader: 'Wk',
			dateFormat: 'yy-mm-dd',
			firstDay: 0,
			isRTL: false,
			duration: 200,
			showAnim: 'show',
			showMonthAfterYear: true
		};
		$.datepicker.setDefaults($.datepicker.regional[lang]);
		
		var reform_date_picker_list = JSON.parse(listSrc.getAttribute("value"));
		
		for (var i = 0; i < reform_date_picker_list.length; i++) {
			var controlId = reform_date_picker_list[i];
			var controlElement = document.getElementById(controlId);
			if (controlElement != null) {
				// this is required in order to reinstall a date picker
				// after this control is used for a date picker since
				// a date picker isn't installed when the value of the class is 'hasDatepicker'.
				controlElement.removeAttribute("class");
				
				if (document.getElementById('attitude_annual_conn') || parent.document.getElementById('attitude_annual_conn')) {//근태관리 휴가계 연동양식일 경우
					$(controlElement).datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						dateFormat: "yy-mm-dd",
						beforeShowDay: disableSomeDay
					});									
				} else {
					var dateFormatAttValue = controlElement.getAttribute("data-reform_date_format");
					$(controlElement).datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						dateFormat: dateFormatAttValue ? dateFormatAttValue : "yy-mm-dd"
							/*
							 * showOn: "both", buttonImage: "/images/imgicon/calendar-month.gif", buttonImageOnly: true
							 */
					});					
				}
				
				if (stageName == "draft" && (!(isRedraft || isReuse) || $(controlElement).val() === "")) {
					$(controlElement).datepicker('setDate', new Date());
				}
			}
		}
	}
	
	// set up time picker controls
	listSrc = document.getElementById("__reform_time_picker_list");
	if (listSrc) {
		var reform_time_picker_list = JSON.parse(listSrc.getAttribute("value"));
		
		for (var i = 0; i < reform_time_picker_list.length; i++) {
			var controlId = reform_time_picker_list[i];
			var controlElement = document.getElementById(controlId);
			if (controlElement != null) {
				controlElement.removeAttribute("class");
				
				var timeFormatAttValue = controlElement.getAttribute("data-reform_time_format");
				var timeGapAttValue = controlElement.getAttribute("data-reform_time_gap");
				var timeGap = parseInt(timeGapAttValue);
				$(controlElement).timepicker({
					'timeFormat': timeFormatAttValue ? timeFormatAttValue : 'H:i',
					'step': timeGap
				});
				
				if (stageName == "draft" && (!(isRedraft || isReuse) || $(controlElement).val() === "")) {
					$(controlElement).timepicker('setTime', new Date());
				}
			}
		}
	}
	
	// if it is in the approve stage, just leave the data intact at the load time.
	if (stageName != "draft" && !reformUseProc.isEditMode()) {
		reformUseProc.resizeFrame();
		return;
	}
	
	listSrc = document.getElementById("__reform_page_load_control_list");
	if (listSrc) {
		var reform_page_load_control_list = JSON.parse(listSrc.getAttribute("value"));
		
		for (var i = 0; i < reform_page_load_control_list.length; i++) {
			var controlId = reform_page_load_control_list[i];
			var controlElement = document.getElementById(controlId);
			if (controlElement == null) {
				controlElement = document.getElementsByName(controlId);
			}
			if (controlElement != null) {
				this.doDataLoad(controlElement);
			}
		}
	}
	
	if (reform_no_data_bound_control_list != null) {
		for (var i = 0; i < reform_no_data_bound_control_list.length; i++) {
			var controlId = reform_no_data_bound_control_list[i];
			var controlElement = document.getElementById(controlId);
			if (controlElement == null) {
				controlElement = document.getElementsByName(controlId);
			}
			if (controlElement != null) {
				if (reformUseProc.isRadioButtons(controlElement)) { // radio buttons
					this.defaultChangeHandler(controlElement);
				} else if (controlElement.type == "checkbox") {
					this.defaultChangeHandler(controlElement);
				} else if (controlElement.type == "text") {
					if (controlElement.value != null & controlElement.value != "") {
						var dataBindValueColumn = "";
						var dataBindValueColumnValue = controlElement.getAttribute("data-reform_data_bind_value_column");
						if (dataBindValueColumnValue != null) {
							dataBindValueColumn = dataBindValueColumnValue.toUpperCase();
						}
						
						if (dataBindValueColumn == "") {
							this.defaultChangeHandler(controlElement);
						}
					}
				}
			}
		}
	}
	
	if (typeof (reform_onAfterLoadHandler) !== "undefined") {
		reform_onAfterLoadHandler();
	}
	
	reformUseProc.resizeFrame();
};

reformUseProc.onUnloadHandler = function() {
	reformUseProc.isLoaded = false;
};

reformUseProc.defaultChangeHandler = function(controls) {
	var controlElement;
	if (reformUseProc.isRadioButtons(controls)) {
		controlElement = controls[0];
	} else {
		controlElement = controls;
	}
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	
	if (controlType == "select-one") {
		//근태관리 추가
		var changeHandler = controlElement.getAttribute("data-reform_on_change");
		if (changeHandler != null && changeHandler != "") {
			var handler = new Function("controlElement", "return " + changeHandler + "(controlElement);");
			try {
				handler(controlElement);
			} catch (e) {}
		}
		
		for (var i = 0; i < controlElement.options.length; i++) {
			controlElement.options[i].removeAttribute("selected");
		}
		
		var option = controlElement.options[controlElement.selectedIndex];
		option.setAttribute("selected", "selected");
	} else if (controlType == "text" || controlType == "textarea") {
		controlElement.setAttribute("value", controlElement.value);
		controlElement.defaultValue = controlElement.value;
	} else if (controlType == "checkbox") {
		if (controlElement.checked) {
			controlElement.setAttribute("checked", "checked");
		} else {
			controlElement.removeAttribute("checked");
		}
	} else if (controlType == "radio") {
		var radioControl;
		var checkedIndex = -1;
		for (var i = 0; i < controls.length; i++) {
			radioControl = controls[i];
			if (radioControl.checked) {
				checkedIndex = i;
				break;
			}
		}
		for (var i = 0; i < controls.length; i++) {
			radioControl = controls[i];
			radioControl.removeAttribute("checked");
			radioControl.checked = false;
		}
		if (checkedIndex >= 0) {
			radioControl = controls[checkedIndex];
			radioControl.setAttribute("checked", "checked");
			radioControl.checked = true;
		}
	} else if (controlType == "button") {
		controlElement.setAttribute("data-reform_value", "1");
	}
	
	var referencingControlListValue = controlElement.getAttribute("data-reform_referencing_control_list");
	var isPerformDefaultDataBindAction = true;
	
	var preChangeHandler = controlElement.getAttribute("data-reform_on_pre_change");
	if (preChangeHandler != null && preChangeHandler != "") {
		var handler = new Function("controlElement", "return " + preChangeHandler + "(controlElement);");
		try {
			var rc = handler(controlElement);
			if (!rc) {
				isPerformDefaultDataBindAction = false;
			}
		} catch (e) {}
	}
	
	// perform the default data bind action.
	if (isPerformDefaultDataBindAction && referencingControlListValue != null && referencingControlListValue != "") {
		var referencingControlList = referencingControlListValue.split(",");
		for (var i = 0; i < referencingControlList.length; i++) {
			var referencingControlId = referencingControlList[i];
			var referencingControl = document.getElementById(referencingControlId);
			if (referencingControl == null) {
				referencingControl = document.getElementsByName(referencingControlId);
			}
			if (referencingControl != null) {
				if (controlType == "select-one") {
					if (controlElement.value != kNullIndexValue) {
						this.doDataLoad(referencingControl);
					} else {
						this.doReset(referencingControl);
					}
				} else if (controlType == "text" || controlType == "textarea" || controlType == "checkbox" || controlType == "radio" || controlType == "grid" || controlType == "button") {
					this.doDataLoad(referencingControl);
				}
			}
		}
	}
	// end
	
	var postChangeHandler = controlElement.getAttribute("data-reform_on_post_change");
	if (postChangeHandler != null && postChangeHandler != "") {
		var handler = new Function("controlElement", "return " + postChangeHandler + "(controlElement);");
		try {
			handler(controlElement);
		} catch (e) {}
	}
	
	reformUseProc.resizeFrame();
};

reformUseProc.setControlValue = function(controlElement, value) {
	controlElement.value = value;
	this.defaultChangeHandler(controlElement);
};

reformUseProc.addScriptCode = function(scriptCode) {
	var scriptElement = document.createElement('script');
	scriptElement.text = scriptCode;
	document.body.appendChild(scriptElement);
};

reformUseProc.isIE8OrBelow = function() {
	var _MSIE = 'MSIE';
	var useragentstr = navigator.userAgent; // "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; WOW64; Trident/5.0; SLCC1; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729)"
	if (useragentstr.indexOf(_MSIE) != -1) {
		var str1 = useragentstr.substring(useragentstr.indexOf(_MSIE), useragentstr.length);
		var arr = str1.split(';');
		var verstr = arr[0].split(' ')[1];
		var version = parseFloat(verstr);
		if (version < 9) { // IE9
			return true;
		} else {
			return false;
		}
	}
	
	return false;
};

function reform_onClickHandler(event) {
	var controlElement = null;
	if (event.target) {
		controlElement = event.target;
	} else if (event.srcElement) {
		controlElement = event.srcElement;
	}
	
	event.cancelBubble = true;
	if (event.stopPropagation) {
		event.stopPropagation();
	}
	
	if (reformUseProc.isLoaded == true && controlElement.tagName == "TD") {
		var tableElement = controlElement.parentNode.parentNode;
		if (tableElement.tagName == "TBODY") {
			tableElement = tableElement.parentNode;
			
			var dataType = tableElement.getAttribute("data-type");
			if (dataType == "grid") {
				var selectedRow = controlElement.parentNode;
				var selectedRowValue = selectedRow.getAttribute("data-reform_value");
				if (selectedRowValue != null) {
					var selectedIndex = selectedRow.rowIndex - reformUseProc.getFirstDataRowIndex(tableElement);
					// TODO:
					// reformUseProc.restoreGridColor(tableElement);
					
					tableElement.setAttribute("data-reform_selected_index", selectedIndex);
					tableElement.setAttribute("data-reform_value", selectedRowValue);
					/*
					 * for (var i = 0; i < selectedRow.cells.length; i++) { var cell = selectedRow.cells[i]; cell.setAttribute("data-reform_background_color", cell.style.backgroundColor); cell.setAttribute("data-reform_color", cell.style.color); cell.style.backgroundColor = "#f0f0f0";
					 * cell.style.color = "black"; }
					 */

					reformUseProc.defaultChangeHandler(tableElement);
				}
			}
		}
	} else if (controlElement.type == "checkbox" || controlElement.type == "radio") {
		if (reformUseProc.isIE8OrBelow()) {
			if (controlElement.type == "radio") {
				var controls = document.getElementsByName(controlElement.name);
				reformUseProc.defaultChangeHandler(controls);
			} else {
				reformUseProc.defaultChangeHandler(controlElement);
			}
		}
		
		var attValue = controlElement.getAttribute("readonly");
		if (attValue != null && attValue != "") {
			return false;
		}
	} else if (controlElement.type == "button") {
		
		var clickHandler = controlElement.getAttribute("data-reform_on_click");
		if (clickHandler != null && clickHandler != "") {
			var handler = new Function("controlElement", "return " + clickHandler + "(controlElement);");
			try {
				handler(controlElement);
			} catch (e) {}
		}
		
		// 리사이즈 관련 버그로 인해 defaultChangeHandler의 호출 순서를 뒤로 변경 2019-09-05 임민석
		reformUseProc.defaultChangeHandler(controlElement);
	} else if (controlElement.type == "text") {
		controlElement.focus();
		
		var clickHandler = controlElement.getAttribute("data-reform_on_click");
		if (clickHandler != null && clickHandler != "") {
			var handler = new Function("controlElement", "return " + clickHandler + "(controlElement);");
			try {
				handler(controlElement);
			} catch (e) {}
		}
	}
	
	return true;
}

function reform_onKeyUpHandler(event) {
	var controlElement = null;
	if (event.target) {
		controlElement = event.target;
	} else if (event.srcElement) {
		controlElement = event.srcElement;
	}
	
	event.cancelBubble = true;
	if (event.stopPropagation) {
		event.stopPropagation();
	}
	
	if (controlElement.type == "text" || controlElement.type == "textarea") {
		var key = event.keyCode;
		if (key == 13) {
			reformUseProc.defaultChangeHandler(controlElement);
		}
		
		var onKeyUpHandler = controlElement.getAttribute("data-reform_on_key_up");
		if (onKeyUpHandler != null && onKeyUpHandler != "") {
			var handler = new Function("controlElement", "return " + onKeyUpHandler + "(controlElement);");
			try {
				handler(controlElement);
			} catch (e) {}
		}
	}
	
	return true;
}

// functions that are available to users

reformUseProc.mark1000Sep = function(p_nMoney) {
	var strReturn = "";
	var nHeadCnt;
	var minus = "";
	
	var strAll = new String(p_nMoney);
	// 2015.05.11 코오롱 마이너스일 경우 - 제외 후 , 찍도록
	if (strAll.indexOf('-') >= 0) {
		minus = "-";
		strAll = strAll.replace(/-/g, "");
	}
	
	var strRight = (strAll.indexOf(".") >= 0 ? strAll.substr(strAll.indexOf("."), strAll.length) : "");
	var strMoney = (strAll.indexOf(".") >= 0 ? strAll.substr(0, strAll.indexOf(".")) : strAll);
	strMoney = strMoney.replace(/,/g, "");
	var nCommaCnt = Math.floor((strMoney.length - 1) / 3);
	nHeadCnt = strMoney.length - nCommaCnt * 3
	for (i = nCommaCnt; i >= 0; i--) {
		if (i == nCommaCnt)
			strReturn = strReturn + strMoney.substr(0, nHeadCnt);
		else
			strReturn = strReturn + "," + strMoney.substr(nHeadCnt + (nCommaCnt - i - 1) * 3, 3);
	}
	strReturn = strReturn + (strRight != "" ? strRight : "");
	
	return minus + strReturn;
};

reformUseProc.extendGridRow = function(controlElement) {
	var key = event.keyCode;
	if (key == 13) {
		var parentElement = controlElement.parentElement;
		if (parentElement.parentElement.tagName == "TD") {
			parentElement = parentElement.parentElement;
		}
		
		if (parentElement.tagName == "TD") {
			var rowElement = parentElement.parentElement;
			var tbodyElement = rowElement.parentElement;
			var gridElement = tbodyElement;
			if (gridElement.tagName != "TABLE") {
				gridElement = gridElement.parentElement;
			}
			
			if (gridElement.tagName == "TABLE") {
				if (tbodyElement.rows.length - 1 == rowElement.rowIndex) {
					var newRow = rowElement.cloneNode(true);
					
					var firstControl = reformUseProc.updateAllChildControlIdsAndReturnFirstControlInGridRow(newRow);
					
					tbodyElement.appendChild(newRow);
					
					if (gridElement.id != "") {
						var rowCount = reformUseProc.getGridRowCount(gridElement.id);
						rowCount = (rowCount > 0) ? rowCount : 1;
						rowCount++;
						gridElement.setAttribute("data-reform_row_count", rowCount.toString());
					}
					
					if (firstControl != null) {
						firstControl.focus();
					}

					reformUseProc.resizeFrame();
				}
			}
		}
	}
	// Ctrl + DEL key is pressed.
	else if ((key == 46 || key == 110) && event.ctrlKey) {
		var parentElement = controlElement.parentElement;
		if (parentElement.parentElement.tagName == "TD") {
			parentElement = parentElement.parentElement;
		}
		
		if (parentElement.tagName == "TD") {
			var rowElement = parentElement.parentElement;
			var tbodyElement = rowElement.parentElement;
			var gridElement = tbodyElement;
			if (gridElement.tagName != "TABLE") {
				gridElement = gridElement.parentElement;
			}
			
			if (gridElement.tagName == "TABLE") {
				var rowIndex = reformUseProc.getRowIndexOfControlInGrid(controlElement.id);
				if (rowIndex != 0) {
					var rc ="";
					if(userLang == '2'){
						rc = confirm("Do you want to delete the row?");
					} else {
						rc = confirm("해당 행을 삭제하시겠습니까?");
					}
					if (rc == true) {
						if (gridElement.id != "") {
							var rowCount = reformUseProc.getGridRowCount(gridElement.id);
							rowCount = (rowCount > 0) ? rowCount : 1;
							rowCount--;
							gridElement.setAttribute("data-reform_row_count", rowCount.toString());
						}
						
						var currentRowIndex = rowElement.rowIndex;
						for (var i = currentRowIndex + 1; i < tbodyElement.rows.length; i++) {
							var row = tbodyElement.rows[i];
							reformUseProc.updateAllChildControlIdsInGridRowForRemoving(row);
						}
						
						tbodyElement.removeChild(rowElement);
						reformUseProc.resizeFrame();
					}
				}
			}
		}
	}
};

reformUseProc.extendGridRows = function(controlElement, extendRowCount) {
	var key = event.keyCode;
	if (key == 13) {
		var parentElement = controlElement.parentElement;
		if (parentElement.parentElement.tagName == "TD") {
			parentElement = parentElement.parentElement;
		}
		
		if (parentElement.tagName == "TD") {
			var rowElement = parentElement.parentElement;
			var tbodyElement = rowElement.parentElement;
			var gridElement = tbodyElement;
			if (gridElement.tagName != "TABLE") {
				gridElement = gridElement.parentElement;
			}
			
			if (gridElement.tagName == "TABLE") {
				var currentRowIndex = rowElement.rowIndex + parentElement.rowSpan - 1;
				if (tbodyElement.rows.length - 1 == currentRowIndex) {
					var firstControl = null;
					
					for (var i = extendRowCount - 1; i >= 0; i--) {
						var extendRow = gridElement.rows[currentRowIndex - i];
						var newRow = extendRow.cloneNode(true);
						
						var returnedFirstControl = reformUseProc.updateAllChildControlIdsAndReturnFirstControlInGridRow(newRow);
						
						if (firstControl == null) {
							firstControl = returnedFirstControl;
						}
						
						tbodyElement.appendChild(newRow);
					}
					
					if (gridElement.id != "") {
						var rowCount = reformUseProc.getGridRowCount(gridElement.id);
						rowCount = (rowCount > 0) ? rowCount : extendRowCount;
						rowCount += extendRowCount;
						gridElement.setAttribute("data-reform_row_count", rowCount.toString());
					}
					
					if (firstControl != null) {
						firstControl.focus();
					}
				}
			}
		}
	}
	// Ctrl + DEL key is pressed.
	else if ((key == 46 || key == 110) && event.ctrlKey) {
		var parentElement = controlElement.parentElement;
		if (parentElement.parentElement.tagName == "TD") {
			parentElement = parentElement.parentElement;
		}
		
		if (parentElement.tagName == "TD") {
			var rowElement = parentElement.parentElement;
			var tbodyElement = rowElement.parentElement;
			var gridElement = tbodyElement;
			if (gridElement.tagName != "TABLE") {
				gridElement = gridElement.parentElement;
			}
			
			if (gridElement.tagName == "TABLE") {
				var rowIndex = reformUseProc.getRowIndexOfControlInGrid(controlElement.id);
				if (rowIndex != 0) {
					var rc ="";
					if(userLang == '2'){
						rc = confirm("Do you want to delete the row?");
					} else {
						rc = confirm("해당 행을 삭제하시겠습니까?");
					}
					if (rc == true) {
						if (gridElement.id != "") {
							var rowCount = reformUseProc.getGridRowCount(gridElement.id);
							rowCount = (rowCount > 0) ? rowCount : 1;
							rowCount -= extendRowCount;
							gridElement.setAttribute("data-reform_row_count", rowCount.toString());
						}
						
						var currentRowIndex = rowElement.rowIndex;
						var row;
						for (var i = currentRowIndex + 1; i < tbodyElement.rows.length; i++) {
							row = tbodyElement.rows[i];
							reformUseProc.updateAllChildControlIdsInGridRowForRemoving(row);
						}
						
						for (var i = 0; i < extendRowCount; i++) {
							row = tbodyElement.rows[currentRowIndex - i];
							tbodyElement.removeChild(row);
						}
					}
				}
			}
		}
	}
};

reformUseProc.extendGridRowWithSeqNo = function(controlElement, seqNoColumnIndex) {
	var key = event.keyCode;
	if (key == 13) {
		var parentElement = controlElement.parentElement;
		if (parentElement.parentElement.tagName == "TD") {
			parentElement = parentElement.parentElement;
		}
		
		if (parentElement.tagName == "TD") {
			var rowElement = parentElement.parentElement;
			var tbodyElement = rowElement.parentElement;
			var gridElement = tbodyElement;
			if (gridElement.tagName != "TABLE") {
				gridElement = gridElement.parentElement;
			}
			
			if (gridElement.tagName == "TABLE") {
				if (tbodyElement.rows.length - 1 == rowElement.rowIndex) {
					var newRow = rowElement.cloneNode(true);
					
					var firstControl = reformUseProc.updateAllChildControlIdsAndReturnFirstControlInGridRow(newRow);
					
					tbodyElement.appendChild(newRow);
					
					if (gridElement.id != "") {
						var rowCount = reformUseProc.getGridRowCount(gridElement.id);
						rowCount = (rowCount > 0) ? rowCount : 1;
						rowCount++;
						gridElement.setAttribute("data-reform_row_count", rowCount.toString());
						newRow.cells[seqNoColumnIndex].innerText = rowCount;
					}
					
					if (firstControl != null) {
						firstControl.focus();
					}
				}
			}
		}
	}
	// Ctrl + DEL key is pressed.
	else if ((key == 46 || key == 110) && event.ctrlKey) {
		var parentElement = controlElement.parentElement;
		if (parentElement.parentElement.tagName == "TD") {
			parentElement = parentElement.parentElement;
		}
		
		if (parentElement.tagName == "TD") {
			var rowElement = parentElement.parentElement;
			var tbodyElement = rowElement.parentElement;
			var gridElement = tbodyElement;
			if (gridElement.tagName != "TABLE") {
				gridElement = gridElement.parentElement;
			}
			
			if (gridElement.tagName == "TABLE") {
				var rowIndex = reformUseProc.getRowIndexOfControlInGrid(controlElement.id);
				if (rowIndex != 0) {
					var rc ="";
					if(userLang == '2'){
						rc = confirm("Do you want to delete the row?");
					} else {
						rc = confirm("해당 행을 삭제하시겠습니까?");
					}
					if (rc == true) {
						if (gridElement.id != "") {
							var rowCount = reformUseProc.getGridRowCount(gridElement.id);
							rowCount = (rowCount > 0) ? rowCount : 1;
							rowCount--;
							gridElement.setAttribute("data-reform_row_count", rowCount.toString());
						}
						
						var currentRowIndex = rowElement.rowIndex;
						for (var i = currentRowIndex + 1; i < tbodyElement.rows.length; i++) {
							var row = tbodyElement.rows[i];
							reformUseProc.updateAllChildControlIdsInGridRowForRemoving(row);
							var curNo = parseInt(row.cells[seqNoColumnIndex].innerText);
							row.cells[seqNoColumnIndex].innerText = curNo - 1;
						}
						
						tbodyElement.removeChild(rowElement);
					}
				}
			}
		}
	}
}

reformUseProc.getGridRowCount = function(gridControlID) {
	var gridControl = document.getElementById(gridControlID);
	var attValue = gridControl.getAttribute("data-reform_row_count");
	var gridRowCount = (attValue != null && attValue != "") ? parseInt(attValue) : 0;
	
	return gridRowCount;
};

// 2016.05.10 결재연동시 사용하기 위해 id만 TableID 던지는 함수 추가
reformUseProc.getGridFirstDataRowIndex = function(gridControlID) {
	var gridControl = document.getElementById(gridControlID);
	var firstDataRowIndex;
	var firstCell;
	for (var i = 0; i < gridControl.rows.length; i++) {
		firstCell = grid.rows[i].cells[0];
		if (firstCell.tagName != "TH") {
			firstDataRowIndex = i;
			break;
		}
	}
	
	return firstDataRowIndex;
};

// 2016.05.10 결재연동시 사용하기 위해 TableID로 Grid 데이터를 배열로 리턴하도록 추가
reformUseProc.getGridData = function(gridControlID) {
	var gridControl = document.getElementById(gridControlID);
	var gridRowCount = reformUseProc.getGridRowCount(gridControlID);
	var firstRowIndex = reformUseProc.getFirstDataRowIndex(gridControl);
	var array = new Array(gridRowCount - firstRowIndex);
	
	for (var i = firstRowIndex; i < gridRowCount; i++) {
		var row = gridControl.rows[i];
		array[i] = row;
	}
	return array;
};

reformUseProc.getFloatValueOfControl = function(controlID) {
	var value = 0;
	
	var element = document.getElementById(controlID);
	if (element != null) {
		var elementValue = element.value.replace(/,/g, '');
		elementValue = elementValue.replace(/%/g, '');
		elementValue = elementValue.trim();
		
		if (!isNaN(elementValue)) {
			if (elementValue != "") {
				value = parseFloat(elementValue);
			}
		}
	}
	
	return value;
};

reformUseProc.getFloatValueOfCell = function(cell) {
	var elementValue = cell.innerText;
	elementValue = elementValue.replace(/,/g, '');
	elementValue = elementValue.replace(/%/g, '');
	elementValue = elementValue.trim();
	var value = 0;
	
	if (!isNaN(elementValue)) {
		if (elementValue != "") {
			value = parseFloat(elementValue);
		}
	}
	
	return value;
};

reformUseProc.getSumOfControlsInGrid = function(gridControlID, controlID) {
	var gridRowCount = reformUseProc.getGridRowCount(gridControlID);
	var sumOfControls = reformUseProc.getFloatValueOfControl(controlID);
	
	var controlID2;
	for (var i = 1; i < gridRowCount; i++) {
		controlID2 = controlID + "_" + i;
		sumOfControls += reformUseProc.getFloatValueOfControl(controlID2);
	}
	
	return sumOfControls;
};

reformUseProc.getSumOfCellsInGrid = function(gridControlID, colIndex) {
	var gridControl = document.getElementById(gridControlID);
	var gridRowCount = reformUseProc.getGridRowCount(gridControlID);
	var firstRowIndex = reformUseProc.getFirstDataRowIndex(gridControl);
	
	var sumOfCells = 0;
	for (var i = 0; i < gridRowCount; i++) {
		var row = gridControl.rows[firstRowIndex + i];
		var cell = row.cells[colIndex];
		sumOfCells += reformUseProc.getFloatValueOfCell(cell);
	}
	
	return sumOfCells;
};

reformUseProc.getRowIndexOfControlInGrid = function(controlID) {
	var element = document.getElementById(controlID);
	var reformRowIndex = 0;
	var attValue = element.getAttribute("data-reform_row_index");
	if (attValue != null && attValue != "") {
		reformRowIndex = parseInt(attValue);
	}
	
	return reformRowIndex;
};

reformUseProc.getValueOfControlInGrid = function(controlID, rowIndex) {
	var targetControlID = (rowIndex == 0) ? controlID : (controlID + "_" + rowIndex);
	var element = document.getElementById(targetControlID);
	
	return element.value;
};

reformUseProc.getTextBoxValueInGrid = function(controlID, rowIndex) {
	var targetControlID = (rowIndex == 0) ? controlID : (controlID + "_" + rowIndex);
	var element = document.getElementById(targetControlID);
	
	return element.value;
};

reformUseProc.getCurrentStage = function() {
	var lastpos = location.pathname.lastIndexOf("/");
	var pageName = location.pathname.substr(lastpos + 1).toLowerCase();
	
	var stageName = "";
	if (pageName.substr(0, 6) == "approv") {
		stageName = "approve";
	} else if (pageName.substr(0, 5) == "recev") {
		stageName = "recev";
	} else {
		stageName = "draft";
	}
	
	return stageName;
};

reformUseProc.isEditMode = function() {
	var lastpos = location.pathname.lastIndexOf("/");
	var pageName = location.pathname.substr(lastpos + 1).toLowerCase();
	
	var isEditMode = false;
	
	if (pageName.toLowerCase().indexOf("html") >= 0) {
		isEditMode = true;
	}
	
	return isEditMode;
};

reformUseProc.setTextBoxValue = function(controlElement, value) {
	controlElement.value = value;
	controlElement.setAttribute("value", value);
};

reformUseProc.setTextBoxValueWithId = function(controlId, value) {
	var controlElement = document.getElementById(controlId);
	controlElement.value = value;
	controlElement.setAttribute("value", value);
};

reformUseProc.setTextBoxValueInGridWithId = function(controlId, rowIndex, value) {
	var targetControlID = (rowIndex == 0) ? controlId : (controlId + "_" + rowIndex);
	
	reformUseProc.setTextBoxValueWithId(targetControlID, value);
};

reformUseProc.setOneCellGridValueInGridWithId = function(oneCellGridControlId, rowIndex, value) {
	var targetControlID = (rowIndex == 0) ? oneCellGridControlId : (oneCellGridControlId + "_" + rowIndex);
	var oneCellGridControl = document.getElementById(targetControlID);
	
	var cell = oneCellGridControl.rows[0].cells[0];
	
	cell.innerHTML = value;
};

reformUseProc.disableControls = function(controlList) {
	for (var i = 0; i < controlList.length; i++) {
		var controlID = controlList[i];
		var control = document.getElementById(controlID);
		if (control != null) {
			control.disabled = true;
			
			var j = 1;
			do {
				control = document.getElementById(controlID + "_" + j++);
				if (control != null) {
					control.disabled = true;
				}
			} while (control != null);
		}
	}
};

reformUseProc.enableControls = function(controlList) {
	for (var i = 0; i < controlList.length; i++) {
		var controlID = controlList[i];
		var control = document.getElementById(controlID);
		if (control != null) {
			control.disabled = false;
			
			var j = 1;
			do {
				control = document.getElementById(controlID + "_" + j++);
				if (control != null) {
					control.disabled = false;
				}
			} while (control != null);
		}
	}
};

reformUseProc.dateFormat = function(dateStr, separator) {
	if (dateStr.length == 8) {
		dateStr = dateStr.substr(0, 4) + separator + dateStr.substr(4, 2) + separator + dateStr.substr(6, 2);
	}
	
	return dateStr;
};

/**
 * 해당 함수를 사용한 textarea는 무조건 overflow: hidden 처리 됩니다.
 * */
reformUseProc.resizeTextArea = function(textarea) {
	var parentWindow = window.parent;
	var parentWindowScroll = parentWindow.pageYOffset;
	var prevScrollHeight = textarea.scrollHeight;
	var gap = textarea.scrollTop;

	// alert(gap);

	if (isIE10) {
		textarea.style.overflow = "";
	}

	textarea.style.height = "";
	// IE 호환 때문에 꼭 넣어야 함, 크롬에서 늘어지더라도 어쩔 수 없음
	textarea.style.height = (10 + textarea.scrollHeight) + "px";
	// IE10 에서 스크롤이 보이지 않도록 처리
	textarea.style.overflow = "hidden";

	gap += textarea.scrollHeight - prevScrollHeight;

	reformUseProc.resizeFrame();
	parentWindow.scrollTo(parentWindow.pageXOffset, parentWindowScroll + gap);
};

reformUseProc.setListBoxSelectedIndex = function(controlElement, selectedIndex) {
	controlElement.selectedIndex = selectedIndex;
	this.defaultChangeHandler(controlElement);
};

reformUseProc.resizeFrame = function() {
	if (parent === null) {
		return;
	}
	
	// iframe의 크기를 리폼 양식의 크기에 맞게 재조정
	var iframeContent = parent.document.getElementById("iframe_content");
	var parentElement = iframeContent.parentElement;
	
	var scrollHeight = iframeContent.contentWindow.document.body.scrollHeight;
	
	iframeContent.style.height = scrollHeight + "px";
};
