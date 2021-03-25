"use strict";
var rowContext = (function() {
	var className = {
		selected: "bnkWebFolder2",
		unselected: "bnkWebFolder"
	};
	
	var selectedClassNameRegExp = new RegExp("\\b" + className.selected + "\\b");
	
	var rowWrapElement;
	var firstSelected;
	
	window.addEventListener("load", function() {
		rowWrapElement = document.getElementById("tblFileList");
	});
	
	function onRowClick(event, rowElement) {
		event.stopPropagation();
		
		if (isFirstSelected()) {
			firstSelected = rowElement;
			setSelectState(rowElement, true);
			
			if ((typeof filePickArr) != "undefined"){
				var selectedFile = folderId + "/" + rowElement.getAttribute("targetId");
				if (!filePickArr.indexOf(selectedFile) > -1){
					filePickArr.push(selectedFile);
				}
			}
			
			return;
		}
		
		if (event.shiftKey) {
			var rows = Array.prototype.slice.call(rowWrapElement.children);
			var startIndex = rows.indexOf(firstSelected);
			var endIndex = rows.indexOf(rowElement);
			var temp;
			
			if (startIndex > endIndex) {
				temp = startIndex;
				startIndex = endIndex;
				endIndex = temp;
			}
			
			clearFocus();
			
			for (var i = startIndex; i <= endIndex; i++) {
				setSelectState(rows[i], true);
				
				if ((typeof filePickArr) != "undefined"){
					var selectedFile = folderId + "/" + rows[i].getAttribute("targetId");
					if (!filePickArr.indexOf(selectedFile) > -1){
						filePickArr.push(selectedFile);
					}
				}	
			}
			
			return;
		}
		
		var selectedLength = getSelectedRows().length;
		var isDuplicateFocus = (selectedLength === 1 && firstSelected === rowElement);
		if (folderType =="S") {
			var selectedRows = rowContext.getSelectedRows();
			var rowInfo = rowContext.getRowInfo(selectedRows[0]);
			
			folderType = rowInfo.targetFunction;
		}
		
		if (event.ctrlKey || isDuplicateFocus) {
			setSelectState(rowElement, !isSelected(rowElement));
			
			if ((typeof filePickArr) != "undefined"){
				var selectedFile = folderId + "/" + rowElement.getAttribute("targetId");
				if (!filePickArr.indexOf(selectedFile) > -1){
					filePickArr.push(selectedFile);
				}
				
				var seletedCheck = folderId + "/" + rowElement.firstChild.firstChild.getAttribute("value");
				if (!rowElement.firstChild.firstChild.checked){
					var index = filePickArr.indexOf(selectedFile);
					if (index != -1){
						filePickArr.splice(index,1);
					}
				}
			}
		} else {
			clearFocus();
			setSelectState(rowElement, true);
			
			firstSelected = rowElement;
			
			if ((typeof filePickArr) != "undefined"){
				filePickArr = new Array();
				var selectedFile = folderId + "/" + rowElement.getAttribute("targetId");
				if (!filePickArr.indexOf(selectedFile) > -1){
					filePickArr.push(selectedFile);
				}
			}
		}
	}
	
	function onCheckboxChange(event) {
		event.stopPropagation();
		
		var element = event.target;
		var rowElement = element.parentElement.parentElement;
		
		if (isFirstSelected()) {
			firstSelected = rowElement;
		}
		
		setSelectState(rowElement, element.checked);
		
		if (typeof filePickArr != "undefined"){
			var selectedFile = folderId + "/" + rowElement.firstChild.firstChild.getAttribute("value");
			if (rowElement.firstChild.firstChild.checked){
				if (!filePickArr.indexOf(selectedFile) > -1){
					filePickArr.push(selectedFile);
				}
			} else {
				var index = filePickArr.indexOf(selectedFile);
				if (index != -1){
					filePickArr.splice(index,1);
				}
			}
		}
	}
	
	function isFirstSelected() {
		return (firstSelected === undefined || getSelectedRows().length === 0);
	}
	
	function getSelectedRows() {
		return rowWrapElement.querySelectorAll("tr." + className.selected);
	}
	
	function getUnselectedRows() {
		return rowWrapElement.querySelectorAll("tr." + className.unselected);
	}
	
	function getRowInfo(rowElement) {
		var targetId = rowElement.getAttribute("targetId");
		var targetType = rowElement.getAttribute("targetType");
		var isFavorite = rowElement.hasAttribute("favorite");
		var creator = rowElement.getAttribute("targetCreater");
		var targetType2 = rowElement.getAttribute("targetFunction");
		var targetPath = rowElement.getAttribute("targetPath");
		
		return {
			id: targetId,
			type: targetType,
			isFavorite: isFavorite,
			creator : creator,
			targetFunction : targetType2,
			targetPath :targetPath
		}
	}
	
	function isSelected(rowElement) {
		return rowElement.className.search(selectedClassNameRegExp) >= 0;
	}
	
	function clearFocus() {
		var selectedRows = getSelectedRows();
		var length = selectedRows.length;
		
		for (var i = 0; i < length; i++) {
			setSelectState(selectedRows[i], false);
		}
	}
	
	function setSelectState(rowElement, isSelect) {
		var checkboxElement = rowElement.firstChild.firstChild;
		
		checkboxElement.checked = isSelect;
		rowElement.setAttribute("class", isSelect ? className.selected : className.unselected);
	}
	
	function selectAll(isEnable) {
		var targetRows = isEnable ? getUnselectedRows() : getSelectedRows();
		var length = targetRows.length;
		
		for (var i = 0; i < length; i++) {
			setSelectState(targetRows[i], isEnable);
			
			if ((typeof filePickArr) != "undefined"){
				if(isEnable){
					var selectedFile = folderId + "/" + targetRows[i].getAttribute("targetid");
					if (!filePickArr.indexOf(selectedFile) > -1){
						filePickArr.push(selectedFile);
					}
				} else {
					filePickArr = new Array();
				}
			}
		}
	}
	
	return {
		onRowClick: onRowClick,
		onCheckboxChange: onCheckboxChange,
		getSelectedRows: getSelectedRows,
		getUnselectedRows: getSelectedRows,
		getRowInfo: getRowInfo,
		setSelectState: setSelectState,
		clearFocus: clearFocus,
		selectAll: selectAll
	};
}());