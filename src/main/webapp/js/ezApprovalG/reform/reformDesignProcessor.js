var webEditorDocument;
var currentControlElement = null;
var currentControlElementId = null;
var propertyMaxNumber = 10;
var eventMaxNumber = 4;
var kNullIndexValue = "-9753579";
var nextAutoID = 1;
var kSelectionOutlineSytle = "#00FF00 dotted medium";
var kNoBorderControlShowBorderSytle = "dashed";
var kNoBorderControlShowBorderColor = "red";
var kNoBorderControlShowBorderWidth = "1px";
var isIE11Mode = false;
var isDEXT = false;
var isFormProcessor = false;
var isNamo = false;
var isTagfree = false;
var isKukudocs = false;
var selectedNodeToMoveOrCopy = null;
var selectedNodeIdToMoveOrCopy = null;
var lastSelectedElement = null;
var savedRanges = [];

function saveSelection() {
	var selection = webEditorDocument.getSelection();
	savedRanges = [];
	
	if (selection.rangeCount) {
		for (var i = 0, len = selection.rangeCount; i < len; i++) {
			savedRanges.push(selection.getRangeAt(i));
		}
	}
}

function restoreSelection() {
	var selection = webEditorDocument.getSelection();
	
	selection.removeAllRanges();
	
	for (var i = 0, len = savedRanges.length; i < len; i++) {
		selection.addRange(savedRanges[i]);
	}
}

function moveCursorToElement(element) {
	var selection = webEditorDocument.getSelection();
	var parentElement = element.parentElement;
	
	if (selection != null && parentElement != null) {
		var selectionIndex = Array.prototype.indexOf.call(parentElement.childNodes, element);
		
		selection.collapse(parentElement, selectionIndex + 1);
		saveSelection();
	}
}

function onFormDocumentLoadHandlerForFormProcessor() {
	isFormProcessor = true;
	onFormDocumentLoadHandler();
}

function onFormDocumentLoadHandlerForDEXT5() {
	isDEXT = true;
	onFormDocumentLoadHandler();
}

function onFormDocumentLoadHandlerForNamo() {
	isNamo = true;
	onFormDocumentLoadHandler();
}

function onFormDocumentLoadHandlerForTagfree() {
	isTagfree = true;
	onFormDocumentLoadHandler();
	
	xfe.xfeDocumentEvent.oldXfeMouseDown = xfe.xfeDocumentEvent.xfeMouseDown;
	xfe.xfeDocumentEvent.oldXfeMouseUp = xfe.xfeDocumentEvent.xfeMouseUp;
	
	xfe.xfeDocumentEvent.xfeMouseDown = function(event) {
		var targetElement = xfeEventUtil.getTarget(event);
		
		if (targetElement != undefined && targetElement.getAttribute("data-reform_flag") === "1") {
			event.preventDefault();
			event.stopPropagation();
			
			mouseDown(event);
		} else {
			xfe.xfeDocumentEvent.oldXfeMouseDown(event);
		}
	}

	xfe.xfeDocumentEvent.xfeMouseUp = function(event) {
		var targetElement = xfeEventUtil.getTarget(event);
		
		if (targetElement != undefined && targetElement.getAttribute("data-reform_flag") === "1") {
			event.preventDefault();
			event.stopPropagation();
			
			mouseDown(event);
		} else {
			xfe.xfeDocumentEvent.oldXfeMouseUp(event);
		}
	}
}

function onFormDocumentLoadHandlerForKukudocs() {
	isKukudocs = true;
	onFormDocumentLoadHandler();
}

function onFormDocumentLoadHandler() {
	if (isDEXT) {
		webEditorDocument = DEXT5.getDext5Dom().ownerDocument;
	} else if (isNamo) {
		webEditorDocument = CrossEditor2.GetEditorDocument('doc');
	} else if (isFormProcessor) {
		webEditorDocument = pzFormProc_reform.editor.DOM;
	} else if (isTagfree) {
		webEditorDocument = xfe.getDom();
	} else if (isKukudocs) {
		webEditorDocument = kukudocsEditor.editorDocument;
	}
	
	webEditorDocument.reform_onClickHandler = reform_onClickHandler;
	webEditorDocument.reform_onKeyUpHandler = reform_onKeyUpHandler;
	
	// for IE 5 compatible mode
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function(item) {
			var pos = -1;
			for (var i = 0; i < this.length; i++) {
				if (this[i] == item) {
					pos = i;
					break;
				}
			}
			
			return pos;
		};
	}
	
	currentControlElement = null;
	currentControlElementId = null;
	resetUIDataBindControlList();
	unloadControlProperties();
	
	var nextAutoIDElement = webEditorDocument.getElementById("__reform_next_auto_id");
	if (nextAutoIDElement != null) {
		nextAutoID = parseInt(nextAutoIDElement.getAttribute("value"));
	}
	
	addDataBindControlListToUIDataBindControlList();
	
	var inputElement = webEditorDocument.getElementById("__reform_control_list");
	if (inputElement != null) {
		var controlList = JSON.parse(inputElement.getAttribute("value"));
		for (var i = 0; i < controlList.length; i++) {
			var controlID = controlList[i];
			var controlElement = webEditorDocument.getElementById(controlID);
			if (controlElement != null) {
				controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
				
				if (controlElement.style.borderWidth == "0px") {
					controlElement.style.borderStyle = kNoBorderControlShowBorderSytle;
					controlElement.style.borderColor = kNoBorderControlShowBorderColor;
					controlElement.style.borderWidth = kNoBorderControlShowBorderWidth;
				}
			}
		}
	}
	
	if (webEditorDocument.addEventListener) {
		isIE11Mode = true;
		
		if (!isFormProcessor) {
			return;
		}
		
		// this event handler is required for the case the user deletes a control directly using the web editor.
		webEditorDocument.addEventListener("DOMNodeRemoved", function(e) {
			var target = null;
			if (e.target) {
				target = e.target;
			} else if (e.srcElement) {
				target = e.srcElement;
			}
			
			if (target != null && target.nodeType == 1) {
				var attValue = target.getAttribute("data-reform_flag");
				if (attValue == "1") {
					if (target.nodeName == "SPAN") {
						// strangely, this event also happens when the user presses the enter key at the end of a label control
						// with the control's innerHTML kept. we just return in this case.
						if (target.innerHTML != "") {
							return;
						}
					}
					
					removeControlFromManagementData(target);
				}
			}
		}, false);
		
		webEditorDocument.addEventListener("DOMNodeInserted", function(e) {
			var target = null;
			if (e.target) {
				target = e.target;
			} else if (e.srcElement) {
				target = e.srcElement;
			}
			
			if (target != null && target.nodeType == 1) {
				if (target.nodeName == "SPAN") {
					// when the user presses the enter key at the end of the current selected label control,
					// a copy of the label control(SPAN tag) with an outline is automatically created by the web editor.
					// this code block is for removing the outline.
					var styleAttValue = target.getAttribute("style");
					if (styleAttValue != null) {
						if (target.style.outline != "" && target.innerHTML == "") {
							var reformFlag = target.getAttribute("data-reform_flag");
							if (reformFlag == "1") {
								target.style.outline = "";
								target.removeAttribute("data-reform_flag");
								target.removeAttribute("data-type");
								target.removeAttribute("onclick");
							}
						}
					}
				}
			}
		}, false);
	} else if (webEditorDocument.attachEvent) {
		isIE11Mode = false;
		
		if (!isFormProcessor) {
			return;
		}
		
		// this event handler is required for the case the user deletes a control directly using the web editor.
		webEditorDocument.attachEvent("DOMNodeRemoved", function(e) {
			var target = null;
			if (e.target) {
				target = e.target;
			} else if (e.srcElement) {
				target = e.srcElement;
			}
			
			if (target.nodeType == 1) {
				var attValue = target.getAttribute("data-reform_flag");
				if (attValue == "1") {
					if (target.nodeName == "SPAN") {
						// strangely, this event also happens when the user presses the enter key at the end of a label control
						// with the control's innerHTML kept. we just return in this case.
						if (target.innerHTML != "") {
							return;
						}
					}
					
					removeControlFromManagementData(target);
				}
			}
		});
		webEditorDocument.attachEvent("DOMNodeInserted", function(e) {
			var target = null;
			if (e.target) {
				target = e.target;
			} else if (e.srcElement) {
				target = e.srcElement;
			}
			
			if (target.nodeType == 1) {
				if (target.nodeName == "SPAN") {
					// when the user presses the enter key at the end of the current selected label control,
					// a copy of the label control(SPAN tag) with an outline is automatically created by the web editor.
					// this code block is for removing the outline.
					var styleAttValue = target.getAttribute("style");
					if (styleAttValue != null) {
						if (target.style.outline != "" && target.innerHTML == "") {
							var reformFlag = target.getAttribute("data-reform_flag");
							if (reformFlag == "1") {
								target.style.outline = "";
								target.removeAttribute("data-reform_flag");
								target.removeAttribute("data-type");
								target.removeAttribute("onclick");
							}
						}
					}
				}
			}
		});
	}
}

function getControlType(controlElement) {
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	
	return controlType;
}

function processForSaving() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
	}
	
	if (currentControlElement != null) {
		currentControlElement.style.outline = "";
	}
	
	var inputElement = webEditorDocument.getElementById("__reform_control_list");
	if (inputElement != null) {
		var controlList = JSON.parse(inputElement.getAttribute("value"));
		for (var i = 0; i < controlList.length; i++) {
			var controlID = controlList[i];
			var controlElement = webEditorDocument.getElementById(controlID);
			if (controlElement != null) {
				if (controlElement.style.borderStyle == kNoBorderControlShowBorderSytle && controlElement.style.borderColor == kNoBorderControlShowBorderColor && controlElement.style.borderWidth == kNoBorderControlShowBorderWidth) {
					controlElement.style.borderWidth = "0px";
				}
			}
		}
	}
}

function processAfterSaving() {
	if (isIE11Mode) {
		if (currentControlElement != null) {
			currentControlElement.style.outline = kSelectionOutlineSytle;
		}
	}
	
	var inputElement = webEditorDocument.getElementById("__reform_control_list");
	if (inputElement != null) {
		var controlList = JSON.parse(inputElement.getAttribute("value"));
		for (var i = 0; i < controlList.length; i++) {
			var controlID = controlList[i];
			var controlElement = webEditorDocument.getElementById(controlID);
			if (controlElement != null) {
				if (controlElement.style.borderWidth == "0px") {
					controlElement.style.borderStyle = kNoBorderControlShowBorderSytle;
					controlElement.style.borderColor = kNoBorderControlShowBorderColor;
					controlElement.style.borderWidth = kNoBorderControlShowBorderWidth;
				}
			}
		}
	}
}

function removeFromParamAndReferencingControlList(controlElement, controlIDToRemove) {
	var attValue = controlElement.getAttribute("data-reform_param_control_list");
	if (attValue != null && attValue != "") {
		var paramControlList = attValue.split(',');
		var index = paramControlList.indexOf(controlIDToRemove);
		if (index != -1) {
			paramControlList.splice(index, 1);
			controlElement.setAttribute("data-reform_param_control_list", paramControlList.toString());
		}
	}
	
	attValue = controlElement.getAttribute("data-reform_referencing_control_list");
	if (attValue != null && attValue != "") {
		var referencingControlList = attValue.split(',');
		var index = referencingControlList.indexOf(controlIDToRemove);
		if (index != -1) {
			referencingControlList.splice(index, 1);
			controlElement.setAttribute("data-reform_referencing_control_list", referencingControlList.toString());
		}
	}
}

function checkAndCorrectExistenceOfAllControls() {
	var listElement = webEditorDocument.getElementById("__reform_control_list");
	if (listElement != null) {
		var controlList = JSON.parse(listElement.getAttribute("value"));
		for (var i = controlList.length - 1; i >= 0; i--) {
			var controlID = controlList[i];
			var control = webEditorDocument.getElementById(controlID);
			if (control == null) {
				control = webEditorDocument.getElementsByName(controlID);
				// getElementsByName always returns a non-null object even if no elements exist.
				// the length should be checked.
				if (control.length == 0) {
					control = null;
				}
			}
			if (control == null) {
				controlList.splice(i, 1);
				listElement.setAttribute("value", JSON.stringify(controlList));
				
				removeFromNoDataBoundControlList(controlID);
				removeFromPageLoadControlList(controlID);
				removeFromDatePickerList(controlID);
				removeFromTimePickerList(controlID);
				removeFromHiddenControlList(controlID);
				
				for (var j = 0; j < controlList.length; j++) {
					var controlElement = webEditorDocument.getElementById(controlList[j]);
					if (controlElement != null) {
						removeFromParamAndReferencingControlList(controlElement, controlID);
					} else {
						var controlElements = webEditorDocument.getElementsByName(controlList[j]);
						if (controlElements != null) {
							for (var k = 0; k < controlElements.length; k++) {
								var controlElement = controlElements[k];
								if (controlElement != null) {
									removeFromParamAndReferencingControlList(controlElement, controlID);
								}
							}
						}
					}
				}
			}
		}
	}
}

function checkOfAvailableDataBindElements() {
	var listElement = webEditorDocument.getElementById("__reform_data_bind_list");
	
	if (listElement == null) {
		resetUIDataBindControlList();
		return;
	}
}

function restoreAfterHTMLSourceEditInDEXT5() {
	checkAndCorrectExistenceOfAllControls();
	
	if (webEditorDocument.reform_onClickHandler) {} else {
		webEditorDocument.reform_onClickHandler = reform_onClickHandler;
		
		currentControlElement = webEditorDocument.getElementById(currentControlElementId);
		if (currentControlElement == null) {
			var radioElements = webEditorDocument.getElementsByName(currentControlElementId);
			if (radioElements != null && radioElements.length > 0) {
				currentControlElement = radioElements[radioElements.length - 1];
				
				if (isIE11Mode) {
					for (var i = 0; i < radioElements.length; i++) {
						var element = radioElements[i];
						element.style.outline = "";
					}
					currentControlElement.style.outline = kSelectionOutlineSytle;
				}
			}
			// this is the case of a td element in a grid control.
			else if (currentControlElementId == "") {
				var tdElements = webEditorDocument.getElementsByTagName("TD");
				if (tdElements != null && tdElements.length > 0) {
					for (var i = 0; i < tdElements.length; i++) {
						var element = tdElements[i];
						if (element.style.outline != null) {
							element.style.outline = "";
						}
					}
					unloadControlProperties();
					
					currentControlElement = null;
					currentControlElementId = null;
				}
			}
		}
		
		selectedNodeToMoveOrCopy = webEditorDocument.getElementById(selectedNodeIdToMoveOrCopy);
	}
}

function restoreAfterHTMLSourceEditInNamo() {
	checkAndCorrectExistenceOfAllControls();
	checkOfAvailableDataBindElements();
	
	if (currentControlElementId != null && currentControlElementId != "") {
		var currentControl = webEditorDocument.getElementById(currentControlElementId);
		
		if (currentControl != null) {
			currentControlElement = currentControl;
		}
		
		/*
		 * if (currentControlElement == null) { var radioElements = webEditorDocument.getElementsByName(currentControlElementId); if (radioElements != null && radioElements.length > 0) { currentControlElement = radioElements[radioElements.length - 1];
		 * 
		 * if (isIE11Mode) { for (var i = 0; i < radioElements.length; i++) { var element = radioElements[i]; element.style.outline = ""; } currentControlElement.style.outline = kSelectionOutlineSytle; } } // this is the case of a td element in a grid control. else if (currentControlElementId == "") {
		 * var tdElements = webEditorDocument.getElementsByTagName("TD"); if (tdElements != null && tdElements.length > 0) { for (var i = 0; i < tdElements.length; i++) { var element = tdElements[i]; if (element.style.outline != null) { element.style.outline = ""; } } unloadControlProperties();
		 * 
		 * currentControlElement = null; currentControlElementId = null; } } }
		 */
	}
	
	if (selectedNodeIdToMoveOrCopy != null && selectedNodeIdToMoveOrCopy != "") {
		var selectedNode = webEditorDocument.getElementById(selectedNodeIdToMoveOrCopy);
		
		if (selectedNode != null) {
			selectedNodeToMoveOrCopy = selectedNode;
		}
	}
}

function reform_onKeyUpHandler(event) {}

function reform_onClickHandler(event) {
	if (isDEXT) {
		var target = null;
		if (event.target) {
			target = event.target;
		} else if (event.srcElement) {
			target = event.srcElement;
		}
		var currElem = target;
		
		if (currElem.tagName == "TD" || currElem.tagName == "TH") {
			var tableElement = currElem.parentNode.parentNode.parentNode;
			var dataType = tableElement.getAttribute("data-type");
			if (dataType == "grid") {
				return true;
			}
		} else if (currElem.parentNode.tagName == "TD" || currElem.parentNode.tagName == "TH") {
			var tableElement = currElem.parentNode.parentNode.parentNode.parentNode;
			var dataType = tableElement.getAttribute("data-type");
			if (dataType == "grid") {
				return true;
			}
		}
	}
	
	reform_actualOnClickHandler(event);
}

function reform_onClickHandlerForGridInDEXT5(event) {
	reform_actualOnClickHandler(event);
}

function reform_actualOnClickHandler(event) {
	
	var target = null;
	if (event.target) {
		target = event.target;
	} else if (event.srcElement) {
		target = event.srcElement;
	}
	var orgTarget = target;
	
	if (target.tagName == "OPTION") {
		return true;
	}
	
	var controlType = orgTarget.type;
	if (typeof (orgTarget.type) === "undefined") {
		controlType = orgTarget.getAttribute("data-type");
	}
	
	if (currentControlElement != null) {
		currentControlElement.style.outline = "";
	}
	
	var parentNode = orgTarget.parentNode;
	
	if (parentNode.tagName == "SPAN" && isFormProcessor) {
		parentNode = parentNode.parentNode;
	}
	
	if (parentNode.tagName == "TD" || parentNode.tagName == "TH") {
		var tableElement = parentNode.parentNode.parentNode.parentNode;
		var dataType = tableElement.getAttribute("data-type");
		if (dataType == "grid") {
			if (target.tagName == "P") {
				if (currentControlElement == parentNode) {
					target = tableElement;
				} else {
					target = parentNode;
				}
			}
		}
	} else if (parentNode.tagName == "TR") {
		var tableElement = parentNode.parentNode.parentNode;
		var dataType = tableElement.getAttribute("data-type");
		if (dataType == "grid") {
			if (currentControlElement == target) {
				target = tableElement;
			}
		}
	}
	
	if (target.tagName == "TABLE") {
		moveCursorToElement(target);
		saveSelection();
	}
	
	currentControlElement = target;
	currentControlElementId = currentControlElement.id;
	if (currentControlElementId == null || currentControlElementId == "") {
		if (controlType == "radio") {
			currentControlElementId = currentControlElement.name;
		}
	}
	
	if (isIE11Mode) {
		currentControlElement.style.outline = kSelectionOutlineSytle;
	}
	
	unloadControlProperties();
	loadControlProperties(currentControlElement);
	showControlProperties(currentControlElement);
	
	event.preventDefault();
	event.cancelBubble = true;
	if (event.stopPropagation) {
		event.stopPropagation();
	}
	
	if (orgTarget.type == "checkbox" || orgTarget.type == "radio") {
		return false;
	}
	
	return true;
}

function reform_removeCurrentControl() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
	}
	
	if (currentControlElement != null) {
		removeControl(currentControlElement);
	}
}

function reform_selectNodeToMoveOrCopy() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
	}
	
	if (currentControlElement != null) {
		var controlType = currentControlElement.type;
		if (typeof (currentControlElement.type) === "undefined") {
			controlType = currentControlElement.getAttribute("data-type");
		}
		if (controlType == null) {
			return;
		}
		
		if (currentControlElement.getAttribute("data-reform_hidden_control_flag") == "1") {
			return;
		}
		
		selectedNodeToMoveOrCopy = currentControlElement;
		selectedNodeIdToMoveOrCopy = currentControlElementId;
	}
}

function reform_moveCopiedNode() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (lastSelectedElement == null || isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (lastSelectedElement == null || isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var targetElement = selectedNodeToMoveOrCopy;
	var targetElementId = selectedNodeIdToMoveOrCopy;
	if (targetElement != null) {
		var controlType = targetElement.type;
		if (typeof (targetElement.type) === "undefined") {
			controlType = targetElement.getAttribute("data-type");
		}
		if (controlType == null) {
			return;
		}
		
		if (targetElement.getAttribute("data-reform_hidden_control_flag") == "1") {
			return;
		}
		
		if (isFormProcessor) {
			var spanElement = targetElement.parentNode;
			insertElementToDocument(spanElement);
		} else {
			insertElementToDocument(targetElement);
		}
		
		if (isDEXT) {
			removeControlElementOnly(targetElement);
			setTimeout(function() {
				if (currentControlElement != null) {
					currentControlElement.style.outline = "";
				}
				
				currentControlElementId = targetElementId;
				currentControlElement = webEditorDocument.getElementById(targetElementId);
				if (currentControlElement == null) {
					var radioElements = webEditorDocument.getElementsByName(targetElementId);
					currentControlElement = radioElements[radioElements.length - 1];
				}
				
				selectedNodeToMoveOrCopy = currentControlElement;
				if (currentControlElement != null) {
					loadControlProperties(currentControlElement);
					showControlProperties(currentControlElement);
					
					if (isIE11Mode) {
						currentControlElement.style.outline = kSelectionOutlineSytle;
					}
				}
			}, 200);
		}
	}
}

function reform_pasteCopiedNode() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var targetElement = selectedNodeToMoveOrCopy;
	if (targetElement != null) {
		var controlType = targetElement.type;
		if (typeof (targetElement.type) === "undefined") {
			controlType = targetElement.getAttribute("data-type");
		}
		if (controlType == null) {
			return;
		}
		
		if (controlType == "grid") {
			if (isGridControlHasChildControl(targetElement)) {
				alert(message["invalid.grid.copy"]);
				return;
			}
		}
		
		if (targetElement.getAttribute("data-reform_hidden_control_flag") == "1") {
			return;
		}
		
		var spanElement = null;
		var controlElement = null;
		
		if (isFormProcessor) {
			spanElement = targetElement.parentNode.cloneNode(true);
			controlElement = spanElement.children[0];
		} else {
			controlElement = targetElement.cloneNode(true);
		}
		
		if (controlType != "radio") {
			controlElement.id = getNextAutoID();
		}
		
		// 2016.04.28: commented out
		// controlElement.removeAttribute("data-reform_data_bind_source");
		// controlElement.removeAttribute("data-reform_param_control_list");
		controlElement.removeAttribute("data-reform_referencing_control_list");
		
		if (isFormProcessor) {
			insertElementToDocument(spanElement);
		} else {
			insertElementToDocument(controlElement);
		}
		
		addControlToManagementDataAndMakeItCurrent(controlElement);
	}
}

// returns the data source list configured in the Reform Tomcat server.
function getDataSourceList() {
	var reformServerUrl = "/reform/getDataSourceList.do";
	var xmlhttp = createXMLHttpRequest();
	xmlhttp.open("GET", reformServerUrl, false);
	xmlhttp.send();
	if (xmlhttp.readyState == 4) {
		var list = null;
		if (xmlhttp.status == 200) {
			list = JSON.parse(xmlhttp.responseText);
		}
		
		return list;
	}
};

function getNextAutoID() {
	var controlID;
	do {
		controlID = "control" + nextAutoID++;
	} while (webEditorDocument.getElementById(controlID) != null);
	
	var nextAutoIDElement = webEditorDocument.getElementById("__reform_next_auto_id");
	if (nextAutoIDElement == null) {
		var element = webEditorDocument.createElement("span");
		element.id = "__reform_next_auto_id";
		element.setAttribute("value", nextAutoID);
		element.style.display = "none";
		element.innerHTML = "r";
		
		if (isFormProcessor) {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
		}
		
		webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	} else {
		nextAutoIDElement.setAttribute("value", nextAutoID);
	}
	
	return controlID;
}

function insertElementToDocument(element) {
	if (isDEXT) {
		if (element.getAttribute("data-reform_hidden_control_flag") == "1") {
			webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
			return;
		}
		
		// Label 콘트롤 뒤에 키보드 입력 시 Label 콘트롤 안에 입력되는 것을 방지하기 위해 빈공간 삽입
		DEXT5.setInsertHTML(element.outerHTML + "&nbsp;");
	} else if (isNamo) {
		// if (element.getAttribute("data-reform_hidden_control_flag") == "1") {
		// webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
		// return;
		// }
		//		
		// containerNode = CrossEditor2.GetCaretObject();
		// containerNode.appendChild(element);
		// // Label 콘트롤 뒤에 키보드 입력 시 Label 콘트롤 안에 입력되는 것을 방지하기 위해 빈공간 삽입
		// containerNode.appendChild(webEditorDocument.createTextNode('\u00A0'));
		
		if (element.getAttribute("data-reform_hidden_control_flag") == "1") {
			webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
			moveCursorToElement(element);
			return;
		}
		
		var selection = null;
		var containerNode = null;
		
		if (webEditorDocument.getSelection) {
			restoreSelection();
			
			selection = webEditorDocument.getSelection();
			containerNode = selection.anchorNode;
		} else {
			return;
		}
		
		if (containerNode == null) {
			webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
			moveCursorToElement(element);
			return;
		}
		
		if (containerNode.nodeType == 3) {
			// test node head
			if (webEditorDocument.getSelection().anchorOffset == 0) {
				containerNode.parentNode.insertBefore(element, containerNode);
			} else {
				containerNode.parentNode.insertBefore(element, containerNode.nextSibling);
			}
		} else {
			var childNodes = containerNode.childNodes;
			
			if (childNodes.length == 0) {
				containerNode.appendChild(element);
			} else if (childNodes.length == 1 && childNodes.item(0).nodeName == "BR") {
				containerNode.replaceChild(element, childNodes.item(0));
			} else {
				containerNode.insertBefore(element, childNodes.item(selection.anchorOffset));
			}
		}
		
		moveCursorToElement(element);
	} else if (isTagfree) {
		if (element.getAttribute("data-reform_hidden_control_flag") == "1") {
			webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
			moveCursorToElement(element);
			return;
		}
		
		var selection = null;
		var containerNode = null;
		
		if (webEditorDocument.getSelection) {
			restoreSelection();
			
			selection = webEditorDocument.getSelection();
			containerNode = selection.anchorNode;
		} else {
			return;
		}
		
		if (containerNode == null) {
			webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
			moveCursorToElement(element);
			return;
		}
		
		if (containerNode.nodeType == 3) {
			// test node head
			if (webEditorDocument.getSelection().anchorOffset == 0) {
				containerNode.parentNode.insertBefore(element, containerNode);
			} else {
				containerNode.parentNode.insertBefore(element, containerNode.nextSibling);
			}
		} else {
			var childNodes = containerNode.childNodes;
			
			if (childNodes.length == 0) {
				containerNode.appendChild(element);
			} else if (childNodes.length == 1 && childNodes.item(0).nodeName == "BR") {
				containerNode.replaceChild(element, childNodes.item(0));
			} else {
				containerNode.insertBefore(element, childNodes.item(selection.anchorOffset));
			}
		}
		
		moveCursorToElement(element);
	} else if (isKukudocs) {
		if (element.getAttribute("data-reform_hidden_control_flag") == "1") {
			webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
			moveCursorToElement(element);
			return;
		}
		
		var selection = null;
		var containerNode = null;
		
		if (webEditorDocument.getSelection) {
			restoreSelection();
			
			selection = webEditorDocument.getSelection();
			containerNode = selection.anchorNode;
		} else {
			return;
		}
		
		if (containerNode == null) {
			webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
			moveCursorToElement(element);
			return;
		}
		
		if (containerNode.nodeType == 3) {
			// test node head
			if (webEditorDocument.getSelection().anchorOffset == 0) {
				containerNode.parentNode.insertBefore(element, containerNode);
			} else {
				containerNode.parentNode.insertBefore(element, containerNode.nextSibling);
			}
		} else {
			var childNodes = containerNode.childNodes;
			
			if (childNodes.length == 0) {
				containerNode.appendChild(element);
			} else if (childNodes.length == 1 && childNodes.item(0).nodeName == "BR") {
				containerNode.replaceChild(element, childNodes.item(0));
			} else {
				containerNode.insertBefore(element, childNodes.item(selection.anchorOffset));
			}
		}
		
		moveCursorToElement(element);
	} else {
		var firstElementChild = element.firstElementChild;
		if (firstElementChild != null && firstElementChild.getAttribute("data-reform_hidden_control_flag") == "1") {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
			webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
			return;
		}
		
		var attValue;
		var containerNode = null;
		
		if (webEditorDocument.getSelection) {
			containerNode = webEditorDocument.getSelection().anchorNode;
		} else {
			containerNode = webEditorDocument.selection.createRange().parentElement();
		}
		
		if (containerNode.nodeType == 3) { // TEXT_NODE
			if (containerNode.parentNode.nodeName == "SPAN") {
				// if it's the text node of a SPAN element, move to that SPAN element.
				// This SPAN element may be a label control or a surrounding SPAN element.
				containerNode = containerNode.parentNode;
			}
		}
		
		if (containerNode.nodeName == "SPAN") {
			var firstElementChild = containerNode.firstElementChild;
			if (firstElementChild != null) {
				attValue = firstElementChild.getAttribute("data-reform_flag");
				if (attValue == "1") {
					if (webEditorDocument.getSelection().anchorOffset == 0) {
						containerNode.parentNode.insertBefore(element, containerNode);
						return;
					}
				}
			}
			
			attValue = containerNode.getAttribute("data-type");
			if (attValue == "label") {
				// if it's a label control, move to its surrounding SPAN tag
				containerNode = containerNode.parentNode;
				
				if (webEditorDocument.getSelection().anchorOffset == 0) {
					containerNode.parentNode.insertBefore(element, containerNode);
					return;
				}
			}
			
			if (containerNode.nextSibling != null) {
				containerNode.parentNode.insertBefore(element, containerNode.nextSibling);
			} else {
				containerNode.parentNode.appendChild(element);
			}
		} else {
			if (containerNode.nodeType == 3) {
				if (webEditorDocument.getSelection().anchorOffset == 0) {
					containerNode.parentNode.insertBefore(element, containerNode);
					return;
				}
				
				if (containerNode.nextSibling != null) {
					containerNode.parentNode.insertBefore(element, containerNode.nextSibling);
				} else {
					containerNode.parentNode.appendChild(element);
				}
			} else {
				containerNode.appendChild(element);
			}
		}
	}
}

// Label 콘트롤 내부에 콘트롤이 삽입되는 것을 방지하기 위한 함수
function isInPositionNoControlCreation() {
	var rc = false;
	
	try {
		if (lastSelectedElement != null) {
			if (lastSelectedElement.tagName == "SPAN") {
				var controlType = lastSelectedElement.type;
				if (typeof (lastSelectedElement.type) === "undefined") {
					controlType = lastSelectedElement.getAttribute("data-type");
				}
				if (controlType == "label") {
					rc = true;
				}
			}
		}
	} catch (e) {}
	
	return rc;
}

function addSelectBox() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("select");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.setAttribute("style", "width: 100px; overflow: auto;");
	controlElement.setAttribute("size", "0");
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	var optionElement = webEditorDocument.createElement("OPTION");
	optionElement.text = "";
	optionElement.value = kNullIndexValue;
	controlElement.add(optionElement);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addTextBox() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("input");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.setAttribute("onkeyup", "reform_onKeyUpHandler(event);");
	controlElement.type = "text";
	controlElement.setAttribute("style", "width: 100px;");
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addCheckbox() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("input");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.type = "checkbox";
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addRadioButton() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("input");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.type = "radio";
	var controlID = getNextAutoID();
	controlElement.setAttribute("name", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addButton() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("input");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.type = "button";
	controlElement.value = "Button";
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addLabel() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("span");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.innerText = "Label";
	controlElement.setAttribute("data-type", "label");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addGrid() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("TABLE");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("data-type", "grid");
	controlElement.setAttribute("class", "reform_grid");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.setAttribute("style", "width: 100px; border: 1px solid black; border-collapse: collapse; word-break: break-all;");
	var row = controlElement.insertRow(-1);
	var headerCell = webEditorDocument.createElement("TH");
	headerCell.setAttribute("style", "border: 1px solid black; width: 100px; height: 25px;");
	headerCell.setAttribute("onclick", "return reform_onClickHandler(event);");
	row.appendChild(headerCell);
	
	row = controlElement.insertRow(-1);
	var cell = row.insertCell(0);
	cell.setAttribute("style", "border: 1px solid black; width: 100px; height: 25px;");
	cell.setAttribute("onclick", "return reform_onClickHandler(event);");
	
	var footer = controlElement.createTFoot();
	row = footer.insertRow(-1);
	var footerCell = row.insertCell(0);
	footerCell.setAttribute("style", "border: 1px solid black; width: 100px; height: 25px;");
	footerCell.setAttribute("onclick", "return reform_onClickHandler(event);");
	
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addDatePicker() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("input");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("data-reform_date_picker_flag", "1");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.setAttribute("onkeyup", "reform_onKeyUpHandler(event);");
	controlElement.type = "text";
	controlElement.setAttribute("style", "width: 80px;");
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addTimePicker() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("input");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("data-reform_time_picker_flag", "1");
	controlElement.setAttribute("data-reform_time_gap", "10");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.setAttribute("onkeyup", "reform_onKeyUpHandler(event);");
	controlElement.type = "text";
	controlElement.setAttribute("style", "width: 43px;");
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addHiddenControl() {
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var controlElement = webEditorDocument.createElement("input");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("data-reform_hidden_control_flag", "1");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.type = "text";
	controlElement.setAttribute("readonly", "readonly");
	
	var count = 0;
	var hiddenControlListElement = webEditorDocument.getElementById("__reform_hidden_control_list");
	if (hiddenControlListElement != null) {
		var hiddenControlList = JSON.parse(hiddenControlListElement.getAttribute("value"));
		count = hiddenControlList.length;
	}
	var top = "top: " + (5 + 25 * count) + "px;";
	controlElement.setAttribute("style", "position: absolute; width: 50px; left: 5px; border: 1px dotted red; " + top);
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addTextarea() {
	if (isFormProcessor) {
		if (webEditorDocument.getSelection) {
			if (webEditorDocument.getSelection().anchorNode == null) {
				return;
			}
		} else {
			if (webEditorDocument.selection.createRange().parentElement() == null) {
				return;
			}
		}
	} else if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		if (isInPositionNoControlCreation()) {
			return;
		}
	}
	
	var spanElement = null;
	if (isFormProcessor) {
		spanElement = webEditorDocument.createElement("span");
		spanElement.setAttribute("contenteditable", "false");
	}
	
	var controlElement = webEditorDocument.createElement("textarea");
	controlElement.setAttribute("data-reform_flag", "1");
	controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	controlElement.setAttribute("style", "width: 100px; resize: none;");
	var controlID = getNextAutoID();
	controlElement.setAttribute("id", controlID);
	
	if (isFormProcessor) {
		spanElement.appendChild(controlElement);
		insertElementToDocument(spanElement);
	} else {
		insertElementToDocument(controlElement);
	}
	
	addControlToManagementDataAndMakeItCurrent(controlElement);
}

function addControlToManagementDataAndMakeItCurrent(controlElement) {
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	var controlID = (controlType == "radio") ? controlElement.name : controlElement.id;
	
	if (currentControlElement != null) {
		currentControlElement.style.outline = "";
	}
	
	if (isDEXT) {
		setTimeout(function() {
			if (controlType == "radio") {
				var radioElements = webEditorDocument.getElementsByName(controlID);
				currentControlElement = radioElements[radioElements.length - 1];
			} else {
				currentControlElement = webEditorDocument.getElementById(controlID);
			}
			currentControlElementId = controlID;
			
			if (isIE11Mode) {
				currentControlElement.style.outline = kSelectionOutlineSytle;
			}
		}, 200);
	} else {
		currentControlElement = controlElement;
		currentControlElementId = controlID;
		
		if (isIE11Mode) {
			currentControlElement.style.outline = kSelectionOutlineSytle;
		}
	}
	
	// when the user presses the enter key near a label control, a wrong 'DOMNodeRemoved' event happens
	// so, we don't add a label control to management lists.
	if (controlType != "label") {
		addToControlList(controlID);
		
		// 2016.04.28: modified to maintain the data bind source when copied.
		var attValue = controlElement.getAttribute("data-reform_data_bind_source");
		if (attValue != null && attValue != "") {
			var attValue2 = controlElement.getAttribute("data-reform_param_control_list");
			if (attValue2 == null || attValue2 == "") {
				addToPageLoadControlList(controlID);
			} else {
				var paramControlList = attValue2.split(',');
				addToReferencedControls(controlID, paramControlList);
			}
		} else {
			addToNoDataBoundControlList(controlID);
		}
	}
	
	if (controlType == "text") {
		var attValue = controlElement.getAttribute("data-reform_date_picker_flag");
		if (attValue == "1") {
			addToDatePickerList(controlID);
		} else {
			attValue = controlElement.getAttribute("data-reform_time_picker_flag");
			if (attValue == "1") {
				addToTimePickerList(controlID);
			} else {
				attValue = controlElement.getAttribute("data-reform_hidden_control_flag");
				if (attValue == "1") {
					addToHiddenControlList(controlID);
				}
			}
		}
	}
	
	unloadControlProperties();
	loadControlProperties(controlElement);
	showControlProperties(controlElement);
}

function isGridControlHasChildControl(controlElement) {
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
}

function removeControlElementOnly(controlElement) {
	try {
		if (isFormProcessor) {
			var spanElement = controlElement.parentNode;
			spanElement.parentNode.removeChild(spanElement);
		} else {
			var parentElement = controlElement.parentNode;
			parentElement.removeChild(controlElement);
		}
	} catch (e) {}
}

function removeControl(controlElement) {
	if (controlElement == null || controlElement.parentNode == null) {
		return;
	}
	
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	if (controlType == null) {
		return;
	}
	
	if (controlType == "grid") {
		if (isGridControlHasChildControl(controlElement)) {
			alert(message["invalid.grid.remove"]);
			return;
		}
	}
	
	removeControlFromManagementData(controlElement);
	
	var attValue = controlElement.getAttribute("data-reform_hidden_control_flag");
	
	removeControlElementOnly(controlElement);
	
	if (attValue == "1") {
		rearrangeHiddenControls();
	}
}

function removeControlFromManagementData(controlElement) {
	if (controlElement == null) {
		return;
	}
	
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	var controlID = (controlType == "radio") ? controlElement.name : controlElement.id;
	if (controlType == "radio") {
		var radioButtons = webEditorDocument.getElementsByName(controlID);
		if (radioButtons.length > 1) {
			if (controlElement == currentControlElement) {
				unloadControlProperties();
				
				currentControlElement = null;
			}
			
			return;
		}
	}
	
	if (controlType != "label") {
		var attValue = controlElement.getAttribute("data-reform_param_control_list");
		if (attValue != null && attValue != "") {
			var paramControlList = attValue.split(',');
			removeFromReferencedControls(controlID, paramControlList);
		}
		
		attValue = controlElement.getAttribute("data-reform_referencing_control_list");
		if (attValue != null && attValue != "") {
			var referencingControlList = attValue.split(',');
			removeFromReferencingControls(controlID, referencingControlList);
		}
		
		removeFromControlList(controlID);
		removeFromNoDataBoundControlList(controlID);
		removeFromPageLoadControlList(controlID);
	}
	
	if (controlType == "text") {
		var attValue = controlElement.getAttribute("data-reform_date_picker_flag");
		if (attValue == "1") {
			removeFromDatePickerList(controlID);
		} else {
			var attValue = controlElement.getAttribute("data-reform_time_picker_flag");
			if (attValue == "1") {
				removeFromTimePickerList(controlID);
			} else {
				attValue = controlElement.getAttribute("data-reform_hidden_control_flag");
				if (attValue == "1") {
					removeFromHiddenControlList(controlID);
				}
			}
		}
	}
	
	if (controlElement == currentControlElement) {
		unloadControlProperties();
		
		currentControlElement = null;
	}
}

function unloadControlProperties() {
	for (var i = 1; i <= propertyMaxNumber; i++) {
		var element = document.getElementById("prop" + i + "_name");
		while (element.hasChildNodes()) {
			element.removeChild(element.lastChild);
		}
		element = document.getElementById("prop" + i + "_value");
		while (element.hasChildNodes()) {
			element.removeChild(element.lastChild);
		}
	}
	
	for (var i = 1; i <= eventMaxNumber; i++) {
		var element = document.getElementById("event" + i + "_name");
		while (element.hasChildNodes()) {
			element.removeChild(element.lastChild);
		}
		element = document.getElementById("event" + i + "_value");
		while (element.hasChildNodes()) {
			element.removeChild(element.lastChild);
		}
	}
}

function loadControlProperties(controlElement) {
	var tagName = controlElement.tagName;
	
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	
	var element;
	var childElement;
	
	if (tagName == "TH" || tagName == "TD") {
		element = document.getElementById("prop1_name");
		element.innerHTML = message["attr.style"];
		element = document.getElementById("prop1_value");
		element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
		
		element = document.getElementById("prop2_name");
		element.innerHTML = message["attr.value"];
		element = document.getElementById("prop2_value");
		element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
	} else if (controlType == "select-one") {
		element = document.getElementById("prop1_name");
		element.innerHTML = message["attr.id"];
		element = document.getElementById("prop1_value");
		element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop2_name");
		element.innerHTML = message["attr.style"];
		element = document.getElementById("prop2_value");
		element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
		
		element = document.getElementById("prop3_name");
		element.innerHTML = message["attr.value"];
		element = document.getElementById("prop3_value");
		element.innerHTML = '<input id="prop_value" type="text" readonly="readonly" onclick="showSelectValueDialog()" />';
		
		element = document.getElementById("prop4_name");
		element.innerHTML = message["attr.size"];
		element = document.getElementById("prop4_value");
		element.innerHTML = '<input id="prop_size" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop5_name");
		element.innerHTML = message["attr.databind.source"];
		element = document.getElementById("prop5_value");
		element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';
		
		element = document.getElementById("prop6_name");
		element.innerHTML = message["attr.databind.value"];
		element = document.getElementById("prop6_value");
		element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop7_name");
		element.innerHTML = message["attr.databind.display"];
		element = document.getElementById("prop7_value");
		element.innerHTML = '<input id="prop_data_bind_display_column" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop8_name");
		element.innerHTML = message["attr.databind.param"];
		element = document.getElementById("prop8_value");
		element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';
		
		element = document.getElementById("prop9_name");
		element.innerHTML = message["attr.header"];
		element = document.getElementById("prop9_value");
		element.innerHTML = '<input id="prop_header" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop10_name");
		element.innerHTML = message["attr.tabindex"];
		element = document.getElementById("prop10_value");
		element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';
		
		var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
		if (dataBindControlList != null) {
			var value = dataBindControlList.getAttribute("value");
			var list = JSON.parse(value);
			for (var i = 0; i < list.length; i++) {
				addToUIDataBindSourceList(list[i]);
			}
		}
		
		element = document.getElementById("event1_name");
		element.innerHTML = "onPreProcess";
		element = document.getElementById("event1_value");
		element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("event2_name");
		element.innerHTML = "onPostProcess";
		element = document.getElementById("event2_value");
		element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
	} else if (controlType == "text") {
		var attValue = controlElement.getAttribute("data-reform_date_picker_flag");
		var attValue2 = controlElement.getAttribute("data-reform_time_picker_flag");
		var attValue3 = controlElement.getAttribute("data-reform_hidden_control_flag");
		if (attValue == "1") {
			element = document.getElementById("prop1_name");
			element.innerHTML = message["attr.id"];
			element = document.getElementById("prop1_value");
			element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop2_name");
			element.innerHTML = message["attr.style"];
			element = document.getElementById("prop2_value");
			element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
			
			element = document.getElementById("prop3_name");
			element.innerHTML = message["attr.tabindex"];
			element = document.getElementById("prop3_value");
			element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event1_name");
			element.innerHTML = "onPreProcess";
			element = document.getElementById("event1_value");
			element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event2_name");
			element.innerHTML = "onPostProcess";
			element = document.getElementById("event2_value");
			element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event3_name");
			element.innerHTML = "onKeyUp";
			element = document.getElementById("event3_value");
			element.innerHTML = '<input id="event_on_key_up" type="text" onchange="propValueChanged(this)" />';
		} else if (attValue2 == "1") {
			element = document.getElementById("prop1_name");
			element.innerHTML = message["attr.id"];
			element = document.getElementById("prop1_value");
			element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop2_name");
			element.innerHTML = message["attr.style"];
			element = document.getElementById("prop2_value");
			element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
			
			element = document.getElementById("prop3_name");
			element.innerHTML = message["attr.timegap"];
			element = document.getElementById("prop3_value");
			element.innerHTML = '<input id="prop_time_gap" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop4_name");
			element.innerHTML = message["attr.tabindex"];
			element = document.getElementById("prop4_value");
			element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event1_name");
			element.innerHTML = "onPreProcess";
			element = document.getElementById("event1_value");
			element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event2_name");
			element.innerHTML = "onPostProcess";
			element = document.getElementById("event2_value");
			element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event3_name");
			element.innerHTML = "onKeyUp";
			element = document.getElementById("event3_value");
			element.innerHTML = '<input id="event_on_key_up" type="text" onchange="propValueChanged(this)" />';
		} else if (attValue3 == "1") {
			element = document.getElementById("prop1_name");
			element.innerHTML = message["attr.id"];
			element = document.getElementById("prop1_value");
			element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop2_name");
			element.innerHTML = message["attr.value"];
			element = document.getElementById("prop2_value");
			element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop3_name");
			element.innerHTML = message["attr.databind.source"];
			element = document.getElementById("prop3_value");
			element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';
			
			element = document.getElementById("prop4_name");
			element.innerHTML = message["attr.databind.value"];
			element = document.getElementById("prop4_value");
			element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop5_name");
			element.innerHTML = message["attr.databind.param"];
			element = document.getElementById("prop5_value");
			element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';
			
			var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
			if (dataBindControlList != null) {
				var value = dataBindControlList.getAttribute("value");
				var list = JSON.parse(value);
				for (var i = 0; i < list.length; i++) {
					addToUIDataBindSourceList(list[i]);
				}
			}
			
			element = document.getElementById("event1_name");
			element.innerHTML = "onPreProcess";
			element = document.getElementById("event1_value");
			element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event2_name");
			element.innerHTML = "onPostProcess";
			element = document.getElementById("event2_value");
			element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
		} else {
			element = document.getElementById("prop1_name");
			element.innerHTML = message["attr.id"];
			element = document.getElementById("prop1_value");
			element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop2_name");
			element.innerHTML = message["attr.style"];
			element = document.getElementById("prop2_value");
			element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
			
			element = document.getElementById("prop3_name");
			element.innerHTML = message["attr.value"];
			element = document.getElementById("prop3_value");
			element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop4_name");
			element.innerHTML = message["attr.readonly"];
			element = document.getElementById("prop4_value");
			element.innerHTML = '<input id="prop_read_only" type="checkbox" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop5_name");
			element.innerHTML = message["attr.databind.source"];
			element = document.getElementById("prop5_value");
			element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';
			
			element = document.getElementById("prop6_name");
			element.innerHTML = message["attr.databind.value"];
			element = document.getElementById("prop6_value");
			element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("prop7_name");
			element.innerHTML = message["attr.databind.param"];
			element = document.getElementById("prop7_value");
			element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';
			
			element = document.getElementById("prop8_name");
			element.innerHTML = message["attr.tabindex"];
			element = document.getElementById("prop8_value");
			element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';
			
			var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
			if (dataBindControlList != null) {
				var value = dataBindControlList.getAttribute("value");
				var list = JSON.parse(value);
				for (var i = 0; i < list.length; i++) {
					addToUIDataBindSourceList(list[i]);
				}
			}
			
			element = document.getElementById("event1_name");
			element.innerHTML = "onPreProcess";
			element = document.getElementById("event1_value");
			element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event2_name");
			element.innerHTML = "onPostProcess";
			element = document.getElementById("event2_value");
			element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
			
			element = document.getElementById("event3_name");
			element.innerHTML = "onKeyUp";
			element = document.getElementById("event3_value");
			element.innerHTML = '<input id="event_on_key_up" type="text" onchange="propValueChanged(this)" />';
		}
	} else if (controlType == "checkbox") {
		element = document.getElementById("prop1_name");
		element.innerHTML = message["attr.id"];
		element = document.getElementById("prop1_value");
		element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop2_name");
		element.innerHTML = message["attr.style"];
		element = document.getElementById("prop2_value");
		element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
		
		element = document.getElementById("prop3_name");
		element.innerHTML = message["attr.value"];
		element = document.getElementById("prop3_value");
		element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop4_name");
		element.innerHTML = message["attr.readonly"];
		element = document.getElementById("prop4_value");
		element.innerHTML = '<input id="prop_read_only" type="checkbox" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop5_name");
		element.innerHTML = message["attr.check"];
		element = document.getElementById("prop5_value");
		element.innerHTML = '<input id="prop_checked_state" type="checkbox" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop6_name");
		element.innerHTML = message["attr.databind.source"];
		element = document.getElementById("prop6_value");
		element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';
		
		element = document.getElementById("prop7_name");
		element.innerHTML = message["attr.databind.value"];
		element = document.getElementById("prop7_value");
		element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop8_name");
		element.innerHTML = message["attr.databind.param"];
		element = document.getElementById("prop8_value");
		element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';
		
		element = document.getElementById("prop9_name");
		element.innerHTML = message["attr.tabindex"];
		element = document.getElementById("prop9_value");
		element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';
		
		var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
		if (dataBindControlList != null) {
			var value = dataBindControlList.getAttribute("value");
			var list = JSON.parse(value);
			for (var i = 0; i < list.length; i++) {
				addToUIDataBindSourceList(list[i]);
			}
		}
		
		element = document.getElementById("event1_name");
		element.innerHTML = "onPreProcess";
		element = document.getElementById("event1_value");
		element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("event2_name");
		element.innerHTML = "onPostProcess";
		element = document.getElementById("event2_value");
		element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
	} else if (controlType == "radio") {
		element = document.getElementById("prop1_name");
		element.innerHTML = message["attr.id"];
		element = document.getElementById("prop1_value");
		element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop2_name");
		element.innerHTML = message["attr.style"];
		element = document.getElementById("prop2_value");
		element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
		
		element = document.getElementById("prop3_name");
		element.innerHTML = message["attr.value"];
		element = document.getElementById("prop3_value");
		element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop4_name");
		element.innerHTML = message["attr.readonly"];
		element = document.getElementById("prop4_value");
		element.innerHTML = '<input id="prop_read_only" type="checkbox" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop5_name");
		element.innerHTML = message["attr.check"];
		element = document.getElementById("prop5_value");
		element.innerHTML = '<input id="prop_checked_state" type="checkbox" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop6_name");
		element.innerHTML = message["attr.databind.source"];
		element = document.getElementById("prop6_value");
		element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';
		
		element = document.getElementById("prop7_name");
		element.innerHTML = message["attr.databind.value"];
		element = document.getElementById("prop7_value");
		element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop8_name");
		element.innerHTML = message["attr.databind.param"];
		element = document.getElementById("prop8_value");
		element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';
		
		element = document.getElementById("prop9_name");
		element.innerHTML = message["attr.tabindex"];
		element = document.getElementById("prop9_value");
		element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';
		
		var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
		if (dataBindControlList != null) {
			var value = dataBindControlList.getAttribute("value");
			var list = JSON.parse(value);
			for (var i = 0; i < list.length; i++) {
				addToUIDataBindSourceList(list[i]);
			}
		}
		
		element = document.getElementById("event1_name");
		element.innerHTML = "onPreProcess";
		element = document.getElementById("event1_value");
		element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("event2_name");
		element.innerHTML = "onPostProcess";
		element = document.getElementById("event2_value");
		element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
	} else if (controlType == "button") {
		element = document.getElementById("prop1_name");
		element.innerHTML = message["attr.id"];
		element = document.getElementById("prop1_value");
		element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop2_name");
		element.innerHTML = message["attr.style"];
		element = document.getElementById("prop2_value");
		element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
		
		element = document.getElementById("prop3_name");
		element.innerHTML = message["attr.value"];
		element = document.getElementById("prop3_value");
		element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop4_name");
		element.innerHTML = message["attr.tabindex"];
		element = document.getElementById("prop4_value");
		element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("event1_name");
		element.innerHTML = "onClick";
		element = document.getElementById("event1_value");
		element.innerHTML = '<input id="event_on_click" type="text" onchange="propValueChanged(this)" />';
	} else if (controlType == "label") {
		element = document.getElementById("prop1_name");
		element.innerHTML = message["attr.id"];
		element = document.getElementById("prop1_value");
		element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop2_name");
		element.innerHTML = message["attr.style"];
		element = document.getElementById("prop2_value");
		element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
		
		element = document.getElementById("prop3_name");
		element.innerHTML = message["attr.value"];
		element = document.getElementById("prop3_value");
		element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
	} else if (controlType == "grid") {
		element = document.getElementById("prop1_name");
		element.innerHTML = message["attr.id"];
		element = document.getElementById("prop1_value");
		element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop2_name");
		element.innerHTML = message["attr.style"];
		element = document.getElementById("prop2_value");
		element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
		
		element = document.getElementById("prop3_name");
		element.innerHTML = message["attr.header"];
		element = document.getElementById("prop3_value");
		element.innerHTML = '<input id="prop_has_header" type="checkbox" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop4_name");
		element.innerHTML = message["attr.footer"];
		element = document.getElementById("prop4_value");
		element.innerHTML = '<input id="prop_has_footer" type="checkbox" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop5_name");
		element.innerHTML = message["attr.columncount"];
		element = document.getElementById("prop5_value");
		element.innerHTML = '<input id="prop_column_count" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop6_name");
		element.innerHTML = message["attr.databind.source"];
		element = document.getElementById("prop6_value");
		element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';
		
		element = document.getElementById("prop7_name");
		element.innerHTML = message["attr.databind.value"];
		element = document.getElementById("prop7_value");
		element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop8_name");
		element.innerHTML = message["attr.databind.display"];
		element = document.getElementById("prop8_value");
		element.innerHTML = '<input id="prop_data_bind_display_column" type="text" readonly="readonly" onclick="showDisplayColumnDialog()" />';
		
		element = document.getElementById("prop9_name");
		element.innerHTML = message["attr.databind.param"];
		element = document.getElementById("prop9_value");
		element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';
		
		var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
		if (dataBindControlList != null) {
			var value = dataBindControlList.getAttribute("value");
			var list = JSON.parse(value);
			for (var i = 0; i < list.length; i++) {
				addToUIDataBindSourceList(list[i]);
			}
		}
		
		element = document.getElementById("event1_name");
		element.innerHTML = "onPreProcess";
		element = document.getElementById("event1_value");
		element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("event2_name");
		element.innerHTML = "onPostProcess";
		element = document.getElementById("event2_value");
		element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("event3_name");
		element.innerHTML = "onDataLoaded";
		element = document.getElementById("event3_value");
		element.innerHTML = '<input id="event_on_data_loaded" type="text" onchange="propValueChanged(this)" />';
	} else if (controlType == "textarea") {
		element = document.getElementById("prop1_name");
		element.innerHTML = message["attr.id"];
		element = document.getElementById("prop1_value");
		element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop2_name");
		element.innerHTML = message["attr.style"];
		element = document.getElementById("prop2_value");
		element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';
		
		element = document.getElementById("prop3_name");
		element.innerHTML = message["attr.value"];
		element = document.getElementById("prop3_value");
		element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop4_name");
		element.innerHTML = message["attr.readonly"];
		element = document.getElementById("prop4_value");
		element.innerHTML = '<input id="prop_read_only" type="checkbox" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop5_name");
		element.innerHTML = message["attr.databind.source"];
		element = document.getElementById("prop5_value");
		element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';
		
		element = document.getElementById("prop6_name");
		element.innerHTML = message["attr.databind.value"];
		element = document.getElementById("prop6_value");
		element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("prop7_name");
		element.innerHTML = message["attr.databind.param"];
		element = document.getElementById("prop7_value");
		element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';
		
		element = document.getElementById("prop8_name");
		element.innerHTML = message["attr.tabindex"];
		element = document.getElementById("prop8_value");
		element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';
		
		var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
		if (dataBindControlList != null) {
			var value = dataBindControlList.getAttribute("value");
			var list = JSON.parse(value);
			for (var i = 0; i < list.length; i++) {
				addToUIDataBindSourceList(list[i]);
			}
		}
		
		element = document.getElementById("event1_name");
		element.innerHTML = "onPreProcess";
		element = document.getElementById("event1_value");
		element.innerHTML = '<input id="event_on_pre_change" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("event2_name");
		element.innerHTML = "onPostProcess";
		element = document.getElementById("event2_value");
		element.innerHTML = '<input id="event_on_post_change" type="text" onchange="propValueChanged(this)" />';
		
		element = document.getElementById("event3_name");
		element.innerHTML = "onKeyUp";
		element = document.getElementById("event3_value");
		element.innerHTML = '<input id="event_on_key_up" type="text" onchange="propValueChanged(this)" />';
	}
}

function removeOutlineStyle(styleValue) {
	if (isIE11Mode) {
		var styleList = styleValue.split(";");
		for (var i = 0; i < styleList.length; i++) {
			if (styleList[i].trim().substr(0, 7) == "outline") {
				styleList.splice(i, 1);
				break;
			}
		}
		
		return styleList.join(";").trim();
	} else {
		return styleValue;
	}
}

function hasGridHeader(grid) {
	var zeroIndexRow = grid.rows[0];
	var zeroIndexRowFirstCell = zeroIndexRow.cells[0];
	var hasHeader = false;
	if (zeroIndexRowFirstCell.tagName == "TH") {
		hasHeader = true;
	}
	
	return hasHeader;
}

function hasGridFooter(grid) {
	return grid.tFoot != null;
}

function addGridHeader(grid) {
	var colCount = grid.rows[0].cells.length;
	var row = grid.insertRow(0);
	
	for (var i = 0; i < colCount; i++) {
		var headerCell = webEditorDocument.createElement("TH");
		headerCell.setAttribute("style", "border: 1px solid black; width: 100px; height: 25px;");
		headerCell.setAttribute("onclick", "return reform_onClickHandler(event);");
		row.appendChild(headerCell);
	}
}

function addGridFooter(grid) {
	var colCount = grid.rows[0].cells.length;
	var footer = grid.createTFoot();
	var row = footer.insertRow(-1);
	
	for (var i = 0; i < colCount; i++) {
		var footerCell = row.insertCell(i);
		footerCell.setAttribute("style", "border: 1px solid black; width: 100px; height: 25px;");
		footerCell.setAttribute("onclick", "return reform_onClickHandler(event);");
	}
}

function removeGridHeader(grid) {
	grid.deleteRow(0);
}

function removeGridFooter(grid) {
	grid.deleteTFoot();
}

function showControlProperties(controlElement) {
	var tagName = controlElement.tagName;
	
	var controlType = controlElement.type;
	if (typeof (controlElement.type) === "undefined") {
		controlType = controlElement.getAttribute("data-type");
	}
	
	var valueElement;
	var attValue;
	if (tagName == "TH" || tagName == "TD") {
		valueElement = document.getElementById("prop_style");
		attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_value");
		valueElement.value = controlElement.innerText;
	} else if (controlType == "select-one") {
		valueElement = document.getElementById("prop_id");
		attValue = controlElement.getAttribute("id");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_style");
		attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		var selectValueList = [];
		for (var i = 0; i < controlElement.options.length; i++) {
			if (controlElement.options[i].value != kNullIndexValue) {
				selectValueList.push(controlElement.options[i].text);
			}
		}
		var valueStr = selectValueList.join(" ");
		valueElement = document.getElementById("prop_value");
		valueElement.value = valueStr;
		
		valueElement = document.getElementById("prop_size");
		attValue = controlElement.getAttribute("size");
		attValue = attValue != null ? attValue : 0;
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_data_bind_source");
		attValue = controlElement.getAttribute("data-reform_data_bind_source");
		if (attValue != null) {
			for (var i = 1; i < valueElement.options.length; i++) {
				if (valueElement.options[i].value == attValue) {
					valueElement.selectedIndex = i;
					break;
				}
			}
		}
		
		valueElement = document.getElementById("prop_data_bind_value_column");
		attValue = controlElement.getAttribute("data-reform_data_bind_value_column");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_data_bind_display_column");
		attValue = controlElement.getAttribute("data-reform_data_bind_display_column");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_param_control_list");
		attValue = controlElement.getAttribute("data-reform_param_control_list");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_header");
		attValue = controlElement.getAttribute("data-reform_header");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_tabindex");
		attValue = controlElement.getAttribute("tabindex");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("event_on_pre_change");
		attValue = controlElement.getAttribute("data-reform_on_pre_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("event_on_post_change");
		attValue = controlElement.getAttribute("data-reform_on_post_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
	} else if (controlType == "text") {
		var attValue = controlElement.getAttribute("data-reform_date_picker_flag");
		var attValue2 = controlElement.getAttribute("data-reform_time_picker_flag");
		var attValue3 = controlElement.getAttribute("data-reform_hidden_control_flag");
		if (attValue == "1") {
			valueElement = document.getElementById("prop_id");
			attValue = controlElement.getAttribute("id");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_style");
			attValue = controlElement.getAttribute("style");
			attValue = attValue != null ? attValue : "";
			attValue = removeOutlineStyle(attValue);
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_tabindex");
			attValue = controlElement.getAttribute("tabindex");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("event_on_pre_change");
			attValue = controlElement.getAttribute("data-reform_on_pre_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("event_on_post_change");
			attValue = controlElement.getAttribute("data-reform_on_post_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("event_on_key_up");
			attValue = controlElement.getAttribute("data-reform_on_key_up");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
		} else if (attValue2 == "1") {
			valueElement = document.getElementById("prop_id");
			attValue = controlElement.getAttribute("id");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_style");
			attValue = controlElement.getAttribute("style");
			attValue = attValue != null ? attValue : "";
			attValue = removeOutlineStyle(attValue);
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_time_gap");
			attValue = controlElement.getAttribute("data-reform_time_gap");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_tabindex");
			attValue = controlElement.getAttribute("tabindex");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("event_on_pre_change");
			attValue = controlElement.getAttribute("data-reform_on_pre_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("event_on_post_change");
			attValue = controlElement.getAttribute("data-reform_on_post_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("event_on_key_up");
			attValue = controlElement.getAttribute("data-reform_on_key_up");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
		} else if (attValue3 == "1") {
			valueElement = document.getElementById("prop_id");
			attValue = controlElement.getAttribute("id");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_value");
			attValue = controlElement.getAttribute("value");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_data_bind_source");
			attValue = controlElement.getAttribute("data-reform_data_bind_source");
			if (attValue != null) {
				for (var i = 1; i < valueElement.options.length; i++) {
					if (valueElement.options[i].value == attValue) {
						valueElement.selectedIndex = i;
						break;
					}
				}
			}
			
			valueElement = document.getElementById("prop_data_bind_value_column");
			attValue = controlElement.getAttribute("data-reform_data_bind_value_column");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("prop_param_control_list");
			attValue = controlElement.getAttribute("data-reform_param_control_list");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("event_on_pre_change");
			attValue = controlElement.getAttribute("data-reform_on_pre_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("event_on_post_change");
			attValue = controlElement.getAttribute("data-reform_on_post_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
		} else {
			valueElement = document.getElementById("prop_id");
			attValue = controlElement.getAttribute("id");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_style");
			attValue = controlElement.getAttribute("style");
			attValue = attValue != null ? attValue : "";
			attValue = removeOutlineStyle(attValue);
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_value");
			attValue = controlElement.getAttribute("value");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("prop_read_only");
			attValue = controlElement.getAttribute("readonly");
			valueElement.checked = attValue != null;
			
			valueElement = document.getElementById("prop_data_bind_source");
			attValue = controlElement.getAttribute("data-reform_data_bind_source");
			if (attValue != null) {
				for (var i = 1; i < valueElement.options.length; i++) {
					if (valueElement.options[i].value == attValue) {
						valueElement.selectedIndex = i;
						break;
					}
				}
			}
			
			valueElement = document.getElementById("prop_data_bind_value_column");
			attValue = controlElement.getAttribute("data-reform_data_bind_value_column");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("prop_param_control_list");
			attValue = controlElement.getAttribute("data-reform_param_control_list");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("prop_tabindex");
			attValue = controlElement.getAttribute("tabindex");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			
			valueElement = document.getElementById("event_on_pre_change");
			attValue = controlElement.getAttribute("data-reform_on_pre_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("event_on_post_change");
			attValue = controlElement.getAttribute("data-reform_on_post_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
			
			valueElement = document.getElementById("event_on_key_up");
			attValue = controlElement.getAttribute("data-reform_on_key_up");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
			valueElement.setAttribute("title", attValue); // for tooltip
		}
	} else if (controlType == "checkbox") {
		valueElement = document.getElementById("prop_id");
		attValue = controlElement.getAttribute("id");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_style");
		attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_value");
		attValue = controlElement.getAttribute("value");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_read_only");
		attValue = controlElement.getAttribute("readonly");
		valueElement.checked = (attValue != null && attValue != "");
		
		valueElement = document.getElementById("prop_checked_state");
		valueElement.checked = controlElement.hasAttribute("checked");
		
		valueElement = document.getElementById("prop_data_bind_source");
		attValue = controlElement.getAttribute("data-reform_data_bind_source");
		if (attValue != null) {
			for (var i = 1; i < valueElement.options.length; i++) {
				if (valueElement.options[i].value == attValue) {
					valueElement.selectedIndex = i;
					break;
				}
			}
		}
		
		valueElement = document.getElementById("prop_data_bind_value_column");
		attValue = controlElement.getAttribute("data-reform_data_bind_value_column");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_param_control_list");
		attValue = controlElement.getAttribute("data-reform_param_control_list");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_tabindex");
		attValue = controlElement.getAttribute("tabindex");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("event_on_pre_change");
		attValue = controlElement.getAttribute("data-reform_on_pre_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("event_on_post_change");
		attValue = controlElement.getAttribute("data-reform_on_post_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
	} else if (controlType == "radio") {
		valueElement = document.getElementById("prop_id");
		attValue = controlElement.getAttribute("name");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_style");
		attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_value");
		attValue = controlElement.getAttribute("value");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_read_only");
		attValue = controlElement.getAttribute("readonly");
		valueElement.checked = (attValue != null && attValue != "");
		
		valueElement = document.getElementById("prop_checked_state");
		valueElement.checked = controlElement.hasAttribute("checked");
		
		valueElement = document.getElementById("prop_data_bind_source");
		attValue = controlElement.getAttribute("data-reform_data_bind_source");
		if (attValue != null) {
			for (var i = 1; i < valueElement.options.length; i++) {
				if (valueElement.options[i].value == attValue) {
					valueElement.selectedIndex = i;
					break;
				}
			}
		}
		
		valueElement = document.getElementById("prop_data_bind_value_column");
		attValue = controlElement.getAttribute("data-reform_data_bind_value_column");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_param_control_list");
		attValue = controlElement.getAttribute("data-reform_param_control_list");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_tabindex");
		attValue = controlElement.getAttribute("tabindex");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("event_on_pre_change");
		attValue = controlElement.getAttribute("data-reform_on_pre_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("event_on_post_change");
		attValue = controlElement.getAttribute("data-reform_on_post_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
	} else if (controlType == "button") {
		valueElement = document.getElementById("prop_id");
		attValue = controlElement.getAttribute("id");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_style");
		attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_value");
		valueElement.value = controlElement.value;
		
		valueElement = document.getElementById("prop_tabindex");
		attValue = controlElement.getAttribute("tabindex");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("event_on_click");
		attValue = controlElement.getAttribute("data-reform_on_click");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
	} else if (controlType == "label") {
		valueElement = document.getElementById("prop_id");
		attValue = controlElement.getAttribute("id");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_style");
		attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_value");
		valueElement.value = controlElement.innerHTML;
	} else if (controlType == "grid") {
		valueElement = document.getElementById("prop_id");
		attValue = controlElement.getAttribute("id");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_style");
		attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_has_header");
		valueElement.checked = hasGridHeader(controlElement);
		
		valueElement = document.getElementById("prop_has_footer");
		valueElement.checked = hasGridFooter(controlElement);
		
		valueElement = document.getElementById("prop_column_count");
		var row = controlElement.rows[0];
		valueElement.value = row.cells.length;
		
		valueElement = document.getElementById("prop_data_bind_source");
		attValue = controlElement.getAttribute("data-reform_data_bind_source");
		if (attValue != null) {
			for (var i = 1; i < valueElement.options.length; i++) {
				if (valueElement.options[i].value == attValue) {
					valueElement.selectedIndex = i;
					break;
				}
			}
		}
		
		valueElement = document.getElementById("prop_data_bind_value_column");
		attValue = controlElement.getAttribute("data-reform_data_bind_value_column");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_data_bind_display_column");
		attValue = controlElement.getAttribute("data-reform_data_bind_display_column");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_param_control_list");
		attValue = controlElement.getAttribute("data-reform_param_control_list");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("event_on_pre_change");
		attValue = controlElement.getAttribute("data-reform_on_pre_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("event_on_post_change");
		attValue = controlElement.getAttribute("data-reform_on_post_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("event_on_data_loaded");
		attValue = controlElement.getAttribute("data-reform_on_data_loaded");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
	} else if (controlType == "textarea") {
		valueElement = document.getElementById("prop_id");
		attValue = controlElement.getAttribute("id");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_style");
		attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_value");
		attValue = controlElement.getAttribute("value");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("prop_read_only");
		attValue = controlElement.getAttribute("readonly");
		valueElement.checked = attValue != null;
		
		valueElement = document.getElementById("prop_data_bind_source");
		attValue = controlElement.getAttribute("data-reform_data_bind_source");
		if (attValue != null) {
			for (var i = 1; i < valueElement.options.length; i++) {
				if (valueElement.options[i].value == attValue) {
					valueElement.selectedIndex = i;
					break;
				}
			}
		}
		
		valueElement = document.getElementById("prop_data_bind_value_column");
		attValue = controlElement.getAttribute("data-reform_data_bind_value_column");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_param_control_list");
		attValue = controlElement.getAttribute("data-reform_param_control_list");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("prop_tabindex");
		attValue = controlElement.getAttribute("tabindex");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		
		valueElement = document.getElementById("event_on_pre_change");
		attValue = controlElement.getAttribute("data-reform_on_pre_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("event_on_post_change");
		attValue = controlElement.getAttribute("data-reform_on_post_change");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
		
		valueElement = document.getElementById("event_on_key_up");
		attValue = controlElement.getAttribute("data-reform_on_key_up");
		attValue = attValue != null ? attValue : "";
		valueElement.value = attValue;
		valueElement.setAttribute("title", attValue); // for tooltip
	}
}

function propValueChanged(propControlElement) {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
	}
	
	var tagName = currentControlElement.tagName;
	
	var currentControlType = currentControlElement.type;
	if (typeof (currentControlElement.type) === "undefined") {
		currentControlType = currentControlElement.getAttribute("data-type");
	}
	var currentControlID = (currentControlType == "radio") ? currentControlElement.name : currentControlElement.id;
	
	var propControlID = propControlElement.id;
	if (propControlID == "prop_id") {
		var newControlID = propControlElement.value.trim();
		if (newControlID == "" || newControlID == currentControlID) {
			propControlElement.value = currentControlID;
			return;
		}
		
		var existingElement = webEditorDocument.getElementById(newControlID);
		if (existingElement == null) {
			// only radio buttons have the same name
			if (currentControlType != "radio") {
				var elements = webEditorDocument.getElementsByName(newControlID);
				if (elements.length > 0) {
					existingElement = elements;
				}
			}
		}
		if (existingElement != null) {
			alert(message["invalid.id.duplicated"]);
			propControlElement.value = currentControlID;
			return;
		}
		
		propControlElement.value = newControlID;
		
		if (currentControlID != newControlID) {
			if (currentControlElementId == currentControlID) {
				currentControlElementId = newControlID;
			}
			if (selectedNodeIdToMoveOrCopy == currentControlID) {
				selectedNodeIdToMoveOrCopy = newControlID;
			}
			
			var attValue = currentControlElement.getAttribute("data-reform_param_control_list");
			if (attValue != null && attValue != "") {
				var paramControlList = attValue.split(',');
				modifyReferencedControls(currentControlID, newControlID, paramControlList);
			}
			
			attValue = currentControlElement.getAttribute("data-reform_referencing_control_list");
			if (attValue != null && attValue != "") {
				var referencingControlList = attValue.split(',');
				modifyReferencingControls(currentControlID, newControlID, referencingControlList);
			}
			
			modifyControlList(currentControlID, newControlID);
			modifyPageLoadControlList(currentControlID, newControlID);
			modifyNoDataBoundControlList(currentControlID, newControlID);
			
			if (currentControlType == "text") {
				var attValue = currentControlElement.getAttribute("data-reform_date_picker_flag");
				if (attValue == "1") {
					modifyDatePickerList(currentControlID, newControlID);
				} else {
					attValue = currentControlElement.getAttribute("data-reform_time_picker_flag");
					if (attValue == "1") {
						modifyTimePickerList(currentControlID, newControlID);
					} else {
						attValue = currentControlElement.getAttribute("data-reform_hidden_control_flag");
						if (attValue == "1") {
							modifyHiddenControlList(currentControlID, newControlID);
						}
					}
				}
			}
		}
		
		if (currentControlType == "radio") {
			var radioButtons = webEditorDocument.getElementsByName(currentControlID);
			var existingElements = webEditorDocument.getElementsByName(newControlID);
			// if there are existing elements with newControID,
			// change the value of some attributes of all elements with currentControlID
			// based on the first element with newControlID
			if (existingElements != null && existingElements.length > 0) {
				var firstElement = existingElements[0];
				// change all elements with currentControlID together
				for (var i = 0; i < radioButtons.length; i++) {
					var element = radioButtons[i];
					var attValue = firstElement.getAttribute("data-reform_data_bind_source");
					element.setAttribute("data-reform_data_bind_source", attValue);
					attValue = firstElement.getAttribute("data-reform_data_bind_value_column");
					element.setAttribute("data-reform_data_bind_value_column", attValue);
					attValue = firstElement.getAttribute("data-reform_param_control_list");
					element.setAttribute("data-reform_param_control_list", attValue);
					attValue = firstElement.getAttribute("data-reform_referencing_control_list");
					element.setAttribute("data-reform_referencing_control_list", attValue);
					
					attValue = firstElement.getAttribute("data-reform_on_pre_change");
					element.setAttribute("data-reform_on_pre_change", attValue);
					attValue = firstElement.getAttribute("data-reform_on_post_change");
					element.setAttribute("data-reform_on_post_change", attValue);
				}
			}
			
			// change the name of all elements with currentControlID together
			// the operation should be done from the last element since the radioButtons array
			// changes each time the name attribute is set.
			for (var i = radioButtons.length - 1; i >= 0; i--) {
				var element = radioButtons[i];
				element.setAttribute("name", newControlID);
			}
			
			if (existingElements != null && existingElements.length > 0) {
				unloadControlProperties();
				loadControlProperties(currentControlElement);
				showControlProperties(currentControlElement);
			}
		} else {
			currentControlElement.setAttribute("id", newControlID);
		}
	} else if (propControlID == "prop_value") {
		if (currentControlType == "text" || currentControlType == "checkbox" || currentControlType == "radio" || currentControlType == "button" || currentControlType == "textarea") {
			propControlElement.value = propControlElement.value.trim();
			currentControlElement.setAttribute("value", propControlElement.value);
			currentControlElement.value = propControlElement.value;
		} else if (currentControlType == "label") {
			propControlElement.value = propControlElement.value.trim();
			currentControlElement.innerText = propControlElement.value;
		} else if (tagName == "TH" || tagName == "TD") {
			propControlElement.value = propControlElement.value.trim();
			currentControlElement.innerText = propControlElement.value;
		}
	} else if (propControlID == "prop_read_only") {
		if (propControlElement.checked) {
			currentControlElement.setAttribute("readonly", "readonly");
			if (currentControlType == "radio") {
				var elements = webEditorDocument.getElementsByName(currentControlID);
				for (var i = 0; i < elements.length; i++) {
					var element = elements[i];
					if (element != currentControlElement) {
						element.setAttribute("readonly", "readonly");
					}
				}
			}
		} else {
			currentControlElement.removeAttribute("readonly");
			if (currentControlType == "radio") {
				var elements = webEditorDocument.getElementsByName(currentControlID);
				for (var i = 0; i < elements.length; i++) {
					var element = elements[i];
					if (element != currentControlElement) {
						element.removeAttribute("readonly");
					}
				}
			}
		}
	} else if (propControlID == "prop_checked_state") {
		if (propControlElement.checked) {
			// DEXT5와 Namo에서는 setAttribute("checked", "checked")가 동작하지 않아 ""로 설정하도록 함
			currentControlElement.setAttribute("checked", "");
		} else {
			currentControlElement.removeAttribute("checked");
		}
		currentControlElement.checked = propControlElement.checked;
	} else if (propControlID == "prop_has_header") {
		if (propControlElement.checked) {
			addGridHeader(currentControlElement);
		} else {
			removeGridHeader(currentControlElement);
		}
	} else if (propControlID == "prop_has_footer") {
		if (propControlElement.checked) {
			addGridFooter(currentControlElement);
		} else {
			removeGridFooter(currentControlElement);
		}
	} else if (propControlID == "prop_size") {
		propControlElement.value = propControlElement.value.trim();
		currentControlElement.setAttribute("size", propControlElement.value);
		if (currentControlElement.size > 1) {
			if (currentControlElement.options[0].value == kNullIndexValue) {
				currentControlElement.removeChild(currentControlElement.firstChild);
			}
		} else {
			if (currentControlElement.options.length == 0 || currentControlElement.options[0].value != kNullIndexValue) {
				var optionElement = webEditorDocument.createElement("OPTION");
				var attValue = currentControlElement.getAttribute("data-reform_header");
				attValue = attValue != null ? attValue : "";
				var textNode = webEditorDocument.createTextNode(attValue);
				optionElement.appendChild(textNode);
				optionElement.setAttribute("value", kNullIndexValue);
				currentControlElement.insertBefore(optionElement, currentControlElement.firstChild);
			}
		}
	} else if (propControlID == "prop_column_count") {
		propControlElement.value = propControlElement.value.trim();
		var row = currentControlElement.rows[0];
		var currentColumnCount = row.cells.length;
		var newColumnCount = parseInt(propControlElement.value);
		if (newColumnCount < 1) {
			propControlElement.value = currentColumnCount;
			return;
		}
		
		for (var rowIndex = 0; rowIndex < currentControlElement.rows.length; rowIndex++) {
			row = currentControlElement.rows[rowIndex];
			if (newColumnCount > currentColumnCount) {
				var delta = newColumnCount - currentColumnCount;
				for (var i = 0; i < delta; i++) {
					var cell = row.cells[currentColumnCount - 1].cloneNode(false);
					row.appendChild(cell);
				}
			} else if (newColumnCount < currentColumnCount) {
				var delta = currentColumnCount - newColumnCount;
				for (var i = 1; i <= delta; i++) {
					row.deleteCell(currentColumnCount - i);
				}
			}
		}
	} else if (propControlID == "prop_data_bind_source") {
		var value = propControlElement.options[propControlElement.selectedIndex].value;
		if (value != "") {
			currentControlElement.setAttribute("data-reform_data_bind_source", value);
			if (currentControlType == "radio") {
				var elements = webEditorDocument.getElementsByName(currentControlID);
				for (var i = 0; i < elements.length; i++) {
					var element = elements[i];
					if (element != currentControlElement) {
						element.setAttribute("data-reform_data_bind_source", value);
					}
				}
			}
			
			var attValue = currentControlElement.getAttribute("data-reform_param_control_list");
			if (attValue == null || attValue == "") {
				addToPageLoadControlList(currentControlID);
			} else {
				removeFromPageLoadControlList(currentControlID);
			}
			
			removeFromNoDataBoundControlList(currentControlID);
		} else {
			currentControlElement.removeAttribute("data-reform_data_bind_source");
			if (currentControlType == "radio") {
				var elements = webEditorDocument.getElementsByName(currentControlID);
				for (var i = 0; i < elements.length; i++) {
					var element = elements[i];
					if (element != currentControlElement) {
						element.removeAttribute("data-reform_data_bind_source");
					}
				}
			}
			
			removeFromPageLoadControlList(currentControlID);
			addToNoDataBoundControlList(currentControlID);
		}
	} else if (propControlID == "prop_data_bind_value_column") {
		propControlElement.value = propControlElement.value.trim();
		propControlElement.setAttribute("title", propControlElement.value); // for tooltip
		currentControlElement.setAttribute("data-reform_data_bind_value_column", propControlElement.value);
		if (currentControlType == "radio") {
			var elements = webEditorDocument.getElementsByName(currentControlID);
			for (var i = 0; i < elements.length; i++) {
				var element = elements[i];
				if (element != currentControlElement) {
					element.setAttribute("data-reform_data_bind_value_column", propControlElement.value);
				}
			}
		}
	} else if (propControlID == "prop_data_bind_display_column") {
		propControlElement.value = propControlElement.value.trim();
		propControlElement.setAttribute("title", propControlElement.value); // for tooltip
		currentControlElement.setAttribute("data-reform_data_bind_display_column", propControlElement.value);
	} else if (propControlID == "prop_time_gap") {
		propControlElement.value = propControlElement.value.trim();
		if (isNaN(propControlElement.value)) {
			alert(message["invalid.nan"])

			propControlElement.value = currentControlElement.getAttribute("data-reform_time_gap");
			return;
		}
		currentControlElement.setAttribute("data-reform_time_gap", propControlElement.value);
	} else if (propControlID == "prop_header") {
		propControlElement.value = propControlElement.value.trim();
		currentControlElement.setAttribute("data-reform_header", propControlElement.value);
		if (currentControlElement.size == 0 || currentControlElement.size == 1) {
			currentControlElement.options[0].text = propControlElement.value;
		}
	} else if (propControlID == "prop_tabindex") {
		propControlElement.value = propControlElement.value.trim();
		if (propControlElement.value != "") {
			currentControlElement.setAttribute("tabindex", propControlElement.value);
		} else {
			currentControlElement.removeAttribute("tabindex");
		}
	} else if (propControlID == "event_on_pre_change") {
		propControlElement.value = propControlElement.value.trim();
		propControlElement.setAttribute("title", propControlElement.value); // for tooltip
		currentControlElement.setAttribute("data-reform_on_pre_change", propControlElement.value);
		if (currentControlType == "radio") {
			var elements = webEditorDocument.getElementsByName(currentControlID);
			for (var i = 0; i < elements.length; i++) {
				var element = elements[i];
				if (element != currentControlElement) {
					element.setAttribute("data-reform_on_pre_change", propControlElement.value);
				}
			}
		}
	} else if (propControlID == "event_on_post_change") {
		propControlElement.value = propControlElement.value.trim();
		propControlElement.setAttribute("title", propControlElement.value); // for tooltip
		currentControlElement.setAttribute("data-reform_on_post_change", propControlElement.value);
		if (currentControlType == "radio") {
			var elements = webEditorDocument.getElementsByName(currentControlID);
			for (var i = 0; i < elements.length; i++) {
				var element = elements[i];
				if (element != currentControlElement) {
					element.setAttribute("data-reform_on_post_change", propControlElement.value);
				}
			}
		}
	} else if (propControlID == "event_on_click") {
		propControlElement.value = propControlElement.value.trim();
		propControlElement.setAttribute("title", propControlElement.value); // for tooltip
		currentControlElement.setAttribute("data-reform_on_click", propControlElement.value);
	} else if (propControlID == "event_on_key_up") {
		propControlElement.value = propControlElement.value.trim();
		propControlElement.setAttribute("title", propControlElement.value); // for tooltip
		currentControlElement.setAttribute("data-reform_on_key_up", propControlElement.value);
		currentControlElement.setAttribute("onkeyup", "reform_onKeyUpHandler(event);");
	} else if (propControlID == "event_on_data_loaded") {
		propControlElement.value = propControlElement.value.trim();
		propControlElement.setAttribute("title", propControlElement.value); // for tooltip
		currentControlElement.setAttribute("data-reform_on_data_loaded", propControlElement.value);
	}
}

function showPreview() {
	var mainHtml = null;
	
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
		
		var messageFrame = parent.document.getElementById("message");
		mainHtml = messageFrame.contentWindow.GetEditorContent();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
		
		var messageFrame = parent.document.getElementById("message");
		mainHtml = messageFrame.contentWindow.GetEditorContent();
	} else if (isTagfree) {
		restoreAfterHTMLSourceEditInNamo();
		
		var messageFrame = parent.document.getElementById("message");
		mainHtml = messageFrame.contentWindow.GetEditorContent();
	} else if (isKukudocs) {
		restoreAfterHTMLSourceEditInNamo();
		
		var messageFrame = parent.document.getElementById("message");
		mainHtml = messageFrame.contentWindow.GetEditorContent();
	} else {
		mainHtml = parent.pzFormProc.editor.DOM.body.innerHTML;
	}
	
	var args = {};
	
	args.webEditorDocument = webEditorDocument;
	
	if (isDEXT) {
		// this code is necessary in order for the editor's style to be applied to the document as an inline style.
		args.bodyValue = DEXT5.getBodyValue();
	} else if (isNamo) {
		args.isNamo = isNamo;
		args.CrossEditor2 = CrossEditor2;
	}
	
	args.mainHtml = mainHtml;
	
	var txt_reformFunction = parent.document.getElementById("txt_reformFunction");
	args.reformScriptCode = txt_reformFunction != null ? txt_reformFunction.value : null;
	
	args.completionHandlerForDialog = processAfterSaving;
	
	var url = "reformPreview.do";
	processForSaving();
	
	window.argsForDialog = args;
	
	GetOpenWindow(url, "", 1100, 1000, "NO");
}

function addToUIDataBindControlList(dataBindID) {
	var controlElement = document.getElementById("data_bind_control_list");
	var optionElement = document.createElement("OPTION");
	optionElement.text = dataBindID;
	optionElement.value = dataBindID;
	controlElement.add(optionElement);
}

function modifyUIDataBindControlList(oldDataBindID, newDataBindID) {
	if (oldDataBindID != newDataBindID) {
		var controlElement = document.getElementById("data_bind_control_list");
		for (var i = 0; i < controlElement.options.length; i++) {
			if (controlElement.options[i].value == oldDataBindID) {
				controlElement.options[i].text = newDataBindID;
				controlElement.options[i].value = newDataBindID;
				break;
			}
		}
	}
}

function removeFromUIDataBindControlList(dataBindID) {
	var controlElement = document.getElementById("data_bind_control_list");
	for (var i = 0; i < controlElement.options.length; i++) {
		if (controlElement.options[i].value == dataBindID) {
			controlElement.remove(i);
			break;
		}
	}
}

function resetUIDataBindControlList() {
	var controlElement = document.getElementById("data_bind_control_list");
	while (controlElement.hasChildNodes()) {
		controlElement.removeChild(controlElement.lastChild);
	}
}

function IsUIDataBindControlListEmpty() {
	var controlElement = document.getElementById("data_bind_control_list");
	if (controlElement.options.length > 0) {
		return false;
	} else {
		return true;
	}
}

function addDataBindControlListToUIDataBindControlList() {
	var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
	if (dataBindControlList != null) {
		var list = JSON.parse(dataBindControlList.getAttribute("value"));
		for (var i = 0; i < list.length; i++) {
			addToUIDataBindControlList(list[i]);
		}
	}
}

function addToUIDataBindSourceList(dataBindID) {
	var controlElement = document.getElementById("prop_data_bind_source");
	if (controlElement != null) {
		var optionElement = document.createElement("OPTION");
		optionElement.text = dataBindID;
		optionElement.value = dataBindID;
		controlElement.add(optionElement);
	}
}

function modifyUIDataBindSourceList(oldDataBindID, newDataBindID) {
	if (oldDataBindID != newDataBindID) {
		var controlElement = document.getElementById("prop_data_bind_source");
		if (controlElement != null) {
			for (var i = 0; i < controlElement.options.length; i++) {
				if (controlElement.options[i].value == oldDataBindID) {
					controlElement.options[i].text = newDataBindID;
					controlElement.options[i].value = newDataBindID;
					break;
				}
			}
		}
	}
}

function removeFromUIDataBindSourceList(dataBindID) {
	var controlElement = document.getElementById("prop_data_bind_source");
	if (controlElement != null) {
		for (var i = 0; i < controlElement.options.length; i++) {
			if (controlElement.options[i].value == dataBindID) {
				controlElement.remove(i);
				break;
			}
		}
	}
}

function checkElementExistenceAndCorrectList(elementList) {
	for (var i = elementList.length - 1; i >= 0; i--) {
		var elementID = elementList[i];
		var element = webEditorDocument.getElementById(elementID);
		if (element == null) {
			element = webEditorDocument.getElementsByName(elementID);
			// getElementsByName always returns a non-null object even if no elements exist.
			// the length should be checked.
			if (element.length == 0) {
				element = null;
			}
		}
		if (element == null) {
			elementList.splice(i, 1);
		}
	}
}

function addToDataBindControlList(dataBindID) {
	var dataBindList;
	var element = webEditorDocument.getElementById("__reform_data_bind_list");
	if (element == null) {
		element = webEditorDocument.createElement("span");
		element.id = "__reform_data_bind_list";
		element.style.display = "none";
		element.innerHTML = "r";
		
		if (isFormProcessor) {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
		}
		
		webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
		dataBindList = [ dataBindID ];
	} else {
		dataBindList = JSON.parse(element.getAttribute("value"));
		if (dataBindList.indexOf(dataBindID) == -1) {
			dataBindList.push(dataBindID);
		}
	}
	
	element.setAttribute("value", JSON.stringify(dataBindList));
}

function modifyDataBindControlList(oldDataBindID, newDataBindID) {
	if (oldDataBindID != newDataBindID) {
		var dataBindList;
		var element = webEditorDocument.getElementById("__reform_data_bind_list");
		if (element != null) {
			dataBindList = JSON.parse(element.getAttribute("value"));
			for (var i = 0; i < dataBindList.length; i++) {
				if (oldDataBindID == dataBindList[i]) {
					dataBindList[i] = newDataBindID;
					break;
				}
			}
			
			element.setAttribute("value", JSON.stringify(dataBindList));
		}
	}
}

function removeFromDataBindControlList(dataBindID) {
	var dataBindList;
	var element = webEditorDocument.getElementById("__reform_data_bind_list");
	if (element != null) {
		dataBindList = JSON.parse(element.getAttribute("value"));
		for (var i = 0; i < dataBindList.length; i++) {
			if (dataBindList[i] == dataBindID) {
				dataBindList.splice(i, 1);
				break;
			}
		}
		
		element.setAttribute("value", JSON.stringify(dataBindList));
	}
}

function modifyDataBindDependentControls(oldDataBindID, newDataBindID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		for (var i = 0; i < controlList.length; i++) {
			var controlID = controlList[i];
			var controlElement = webEditorDocument.getElementById(controlID);
			if (controlElement != null) {
				var dataBindSource = controlElement.getAttribute("data-reform_data_bind_source");
				if (dataBindSource != null) {
					if (dataBindSource == oldDataBindID) {
						controlElement.setAttribute("data-reform_data_bind_source", newDataBindID);
					}
				}
			}
		}
	}
}

function removeFromDataBindDependentControls(dataBindID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		for (var i = 0; i < controlList.length; i++) {
			var controlID = controlList[i];
			var controlElement = webEditorDocument.getElementById(controlID);
			if (controlElement != null) {
				var dataBindSource = controlElement.getAttribute("data-reform_data_bind_source");
				if (dataBindSource != null) {
					if (dataBindSource == dataBindID) {
						controlElement.removeAttribute("data-reform_data_bind_source");
						removeFromPageLoadControlList(controlID);
						addToNoDataBoundControlList(controlID);
					}
				}
			}
		}
	}
}

function addDataBindControl(dataBindInfo) {
	var element = webEditorDocument.createElement("span");
	element.id = dataBindInfo[0];
	element.setAttribute("data-reform_flag", "1");
	var dataBindValue = {};
	dataBindValue["dataSource"] = dataBindInfo[1];
	dataBindValue["sql"] = dataBindInfo[2];
	element.setAttribute("value", JSON.stringify(dataBindValue));
	element.style.display = "none";
	element.innerHTML = "r";
	
	if (isFormProcessor) {
		webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	}
	
	webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	
	addToDataBindControlList(dataBindInfo[0]);
	addToUIDataBindControlList(dataBindInfo[0]);
	addToUIDataBindSourceList(dataBindInfo[0]);
}

function modifyDataBindControl(oldDataBindID, newDataBindInfo) {
	var element = webEditorDocument.getElementById(oldDataBindID);
	if (element != null) {
		element.id = newDataBindInfo[0];
		var dataBindValue = {};
		dataBindValue["dataSource"] = newDataBindInfo[1];
		dataBindValue["sql"] = newDataBindInfo[2];
		element.setAttribute("value", JSON.stringify(dataBindValue));
		
		modifyDataBindControlList(oldDataBindID, newDataBindInfo[0]);
		modifyUIDataBindControlList(oldDataBindID, newDataBindInfo[0]);
		modifyUIDataBindSourceList(oldDataBindID, newDataBindInfo[0]);
		modifyDataBindDependentControls(oldDataBindID, newDataBindInfo[0]);
	}
}

function removeDataBindControl(dataBindID) {
	var dataBindControl = webEditorDocument.getElementById(dataBindID);
	if (dataBindControl != null) {
		dataBindControl.parentNode.removeChild(dataBindControl);
		
		removeFromDataBindControlList(dataBindID);
		removeFromUIDataBindControlList(dataBindID);
		removeFromUIDataBindSourceList(dataBindID);
		removeFromDataBindDependentControls(dataBindID);
	}
}

function addToPageLoadControlList(controlID) {
	var pageLoadControlList;
	var element = webEditorDocument.getElementById("__reform_page_load_control_list");
	if (element == null) {
		element = webEditorDocument.createElement("span");
		element.id = "__reform_page_load_control_list";
		element.style.display = "none";
		element.innerHTML = "r";
		
		if (isFormProcessor) {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
		}
		
		webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
		pageLoadControlList = [ controlID ];
	} else {
		pageLoadControlList = JSON.parse(element.getAttribute("value"));
		checkElementExistenceAndCorrectList(pageLoadControlList);
		
		if (pageLoadControlList.indexOf(controlID) == -1) {
			pageLoadControlList.push(controlID);
		}
	}
	
	element.setAttribute("value", JSON.stringify(pageLoadControlList));
}

function modifyPageLoadControlList(oldControlID, newControlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_page_load_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(oldControlID);
		if (index >= 0) {
			var index2 = controlList.indexOf(newControlID);
			if (index2 >= 0) {
				controlList.splice(index, 1);
			} else {
				controlList[index] = newControlID;
			}
			
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function removeFromPageLoadControlList(controlID) {
	var pageLoadControlList;
	var element = webEditorDocument.getElementById("__reform_page_load_control_list");
	if (element != null) {
		pageLoadControlList = JSON.parse(element.getAttribute("value"));
		for (var i = 0; i < pageLoadControlList.length; i++) {
			if (pageLoadControlList[i] == controlID) {
				pageLoadControlList.splice(i, 1);
				break;
			}
		}
		
		checkElementExistenceAndCorrectList(pageLoadControlList);
		element.setAttribute("value", JSON.stringify(pageLoadControlList));
	}
}

function addToNoDataBoundControlList(controlID) {
	var noDataBoundControlList;
	var element = webEditorDocument.getElementById("__reform_no_data_bound_control_list");
	if (element == null) {
		element = webEditorDocument.createElement("span");
		element.id = "__reform_no_data_bound_control_list";
		element.style.display = "none";
		element.innerHTML = "r";
		
		if (isFormProcessor) {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
		}
		
		webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
		noDataBoundControlList = [ controlID ];
	} else {
		noDataBoundControlList = JSON.parse(element.getAttribute("value"));
		checkElementExistenceAndCorrectList(noDataBoundControlList);
		
		if (noDataBoundControlList.indexOf(controlID) == -1) {
			noDataBoundControlList.push(controlID);
		}
	}
	
	element.setAttribute("value", JSON.stringify(noDataBoundControlList));
}

function modifyNoDataBoundControlList(oldControlID, newControlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_no_data_bound_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(oldControlID);
		if (index >= 0) {
			var index2 = controlList.indexOf(newControlID);
			if (index2 >= 0) {
				controlList.splice(index, 1);
			} else {
				controlList[index] = newControlID;
			}
			
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function removeFromNoDataBoundControlList(controlID) {
	var noDataBoundControlList;
	var element = webEditorDocument.getElementById("__reform_no_data_bound_control_list");
	if (element != null) {
		noDataBoundControlList = JSON.parse(element.getAttribute("value"));
		for (var i = 0; i < noDataBoundControlList.length; i++) {
			if (noDataBoundControlList[i] == controlID) {
				noDataBoundControlList.splice(i, 1);
				break;
			}
		}
		
		checkElementExistenceAndCorrectList(noDataBoundControlList);
		element.setAttribute("value", JSON.stringify(noDataBoundControlList));
	}
}

function addToControlList(controlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_control_list");
	if (element == null) {
		element = webEditorDocument.createElement("span");
		element.id = "__reform_control_list";
		element.style.display = "none";
		element.innerHTML = "r";
		
		if (isFormProcessor) {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
		}
		
		webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
		controlList = [ controlID ];
	} else {
		controlList = JSON.parse(element.getAttribute("value"));
		checkElementExistenceAndCorrectList(controlList);
		
		if (controlList.indexOf(controlID) == -1) {
			controlList.push(controlID);
		}
	}
	
	element.setAttribute("value", JSON.stringify(controlList));
}

function modifyControlList(oldControlID, newControlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(oldControlID);
		if (index >= 0) {
			var index2 = controlList.indexOf(newControlID);
			if (index2 >= 0) {
				// if newControlID is already in the list, just delete oldControlID
				// this case may happen when newControlID is a name of existing radio buttons.
				controlList.splice(index, 1);
			} else {
				controlList[index] = newControlID;
			}
			
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function removeFromControlList(controlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(controlID);
		if (index >= 0) {
			controlList.splice(index, 1);
			
			checkElementExistenceAndCorrectList(controlList);
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function addToDatePickerList(controlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_date_picker_list");
	if (element == null) {
		element = webEditorDocument.createElement("span");
		element.id = "__reform_date_picker_list";
		element.style.display = "none";
		element.innerHTML = "r";
		
		if (isFormProcessor) {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
		}
		
		webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
		controlList = [ controlID ];
	} else {
		controlList = JSON.parse(element.getAttribute("value"));
		if (controlList.indexOf(controlID) == -1) {
			controlList.push(controlID);
		}
	}
	
	element.setAttribute("value", JSON.stringify(controlList));
}

function modifyDatePickerList(oldControlID, newControlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_date_picker_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(oldControlID);
		if (index >= 0) {
			var index2 = controlList.indexOf(newControlID);
			if (index2 >= 0) {
				controlList.splice(index, 1);
			} else {
				controlList[index] = newControlID;
			}
			
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function removeFromDatePickerList(controlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_date_picker_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(controlID);
		if (index >= 0) {
			controlList.splice(index, 1);
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function addToTimePickerList(controlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_time_picker_list");
	if (element == null) {
		element = webEditorDocument.createElement("span");
		element.id = "__reform_time_picker_list";
		element.style.display = "none";
		element.innerHTML = "r";
		
		if (isFormProcessor) {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
		}
		
		webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
		controlList = [ controlID ];
	} else {
		controlList = JSON.parse(element.getAttribute("value"));
		if (controlList.indexOf(controlID) == -1) {
			controlList.push(controlID);
		}
	}
	
	element.setAttribute("value", JSON.stringify(controlList));
}

function modifyTimePickerList(oldControlID, newControlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_time_picker_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(oldControlID);
		if (index >= 0) {
			var index2 = controlList.indexOf(newControlID);
			if (index2 >= 0) {
				controlList.splice(index, 1);
			} else {
				controlList[index] = newControlID;
			}
			
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function removeFromTimePickerList(controlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_time_picker_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(controlID);
		if (index >= 0) {
			controlList.splice(index, 1);
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function addToHiddenControlList(controlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_hidden_control_list");
	if (element == null) {
		element = webEditorDocument.createElement("span");
		element.id = "__reform_hidden_control_list";
		element.style.display = "none";
		element.innerHTML = "r";
		
		if (isFormProcessor) {
			webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
		}
		
		webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
		controlList = [ controlID ];
	} else {
		controlList = JSON.parse(element.getAttribute("value"));
		checkElementExistenceAndCorrectList(controlList);
		
		if (controlList.indexOf(controlID) == -1) {
			controlList.push(controlID);
		}
	}
	
	element.setAttribute("value", JSON.stringify(controlList));
}

function modifyHiddenControlList(oldControlID, newControlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_hidden_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(oldControlID);
		if (index >= 0) {
			controlList[index] = newControlID;
			
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function removeFromHiddenControlList(controlID) {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_hidden_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		var index = controlList.indexOf(controlID);
		if (index >= 0) {
			controlList.splice(index, 1);
			
			checkElementExistenceAndCorrectList(controlList);
			element.setAttribute("value", JSON.stringify(controlList));
		}
	}
}

function rearrangeHiddenControls() {
	var controlList;
	var element = webEditorDocument.getElementById("__reform_hidden_control_list");
	if (element != null) {
		controlList = JSON.parse(element.getAttribute("value"));
		for (var i = 0; i < controlList.length; i++) {
			var element = webEditorDocument.getElementById(controlList[i]);
			if (element != null) {
				element.style.top = (5 + 25 * i);
			}
		}
	}
}

function addToReferencedControls(controlID, referencedControlList) {
	for (var i = 0; i < referencedControlList.length; i++) {
		var referencedControlElements = null;
		var referencedControlElement = webEditorDocument.getElementById(referencedControlList[i]);
		if (referencedControlElement == null) {
			referencedControlElements = webEditorDocument.getElementsByName(referencedControlList[i]);
		}
		
		if (referencedControlElement != null) {
			var attValue = referencedControlElement.getAttribute("data-reform_referencing_control_list");
			if (attValue == null || attValue == "") {
				referencedControlElement.setAttribute("data-reform_referencing_control_list", controlID);
			} else {
				var referencingControlList = attValue.split(',');
				if (referencingControlList.indexOf(controlID) == -1) {
					referencingControlList.push(controlID);
					referencedControlElement.setAttribute("data-reform_referencing_control_list", referencingControlList.toString());
				}
			}
		} else if (referencedControlElements != null) {
			if (referencedControlElements.length > 0) {
				referencedControlElement = referencedControlElements[0];
				var attValue = referencedControlElement.getAttribute("data-reform_referencing_control_list");
				if (attValue == null || attValue == "") {
					referencedControlElement.setAttribute("data-reform_referencing_control_list", controlID);
				} else {
					var referencingControlList = attValue.split(',');
					if (referencingControlList.indexOf(controlID) == -1) {
						referencingControlList.push(controlID);
						referencedControlElement.setAttribute("data-reform_referencing_control_list", referencingControlList.toString());
					}
				}
				
				attValue = referencedControlElement.getAttribute("data-reform_referencing_control_list");
				for (var j = 1; j < referencedControlElements.length; j++) {
					referencedControlElement = referencedControlElements[j];
					referencedControlElement.setAttribute("data-reform_referencing_control_list", attValue);
				}
			}
		}
	}
}

function modifyReferencedControls(oldControlID, newControlID, referencedControlList) {
	for (var i = 0; i < referencedControlList.length; i++) {
		var referencedControlElement = webEditorDocument.getElementById(referencedControlList[i]);
		if (referencedControlElement != null) {
			var attValue = referencedControlElement.getAttribute("data-reform_referencing_control_list");
			if (attValue != null && attValue != "") {
				var referencingControlList = attValue.split(',');
				var index = referencingControlList.indexOf(oldControlID);
				if (index != -1) {
					referencingControlList[index] = newControlID;
					referencedControlElement.setAttribute("data-reform_referencing_control_list", referencingControlList.toString());
				}
			}
		}
	}
}

function removeFromReferencedControls(controlID, referencedControlList) {
	for (var i = 0; i < referencedControlList.length; i++) {
		var referencedControlElement = webEditorDocument.getElementById(referencedControlList[i]);
		if (referencedControlElement != null) {
			var attValue = referencedControlElement.getAttribute("data-reform_referencing_control_list");
			if (attValue != null && attValue != "") {
				var referencingControlList = attValue.split(',');
				var index = referencingControlList.indexOf(controlID);
				if (index != -1) {
					referencingControlList.splice(index, 1);
					referencedControlElement.setAttribute("data-reform_referencing_control_list", referencingControlList.toString());
				}
			}
		} else {
			var referencedControlElements = webEditorDocument.getElementsByName(referencedControlList[i]);
			if (referencedControlElements != null) {
				for (var j = 0; j < referencedControlElements.length; j++) {
					var referencedControlElement = referencedControlElements[j];
					var attValue = referencedControlElement.getAttribute("data-reform_referencing_control_list");
					if (attValue != null && attValue != "") {
						var referencingControlList = attValue.split(',');
						var index = referencingControlList.indexOf(controlID);
						if (index != -1) {
							referencingControlList.splice(index, 1);
							referencedControlElement.setAttribute("data-reform_referencing_control_list", referencingControlList.toString());
						}
					}
				}
			}
		}
	}
}

function modifyReferencingControls(oldControlID, newControlID, referencingControlList) {
	for (var i = 0; i < referencingControlList.length; i++) {
		var referencingControlElement = webEditorDocument.getElementById(referencingControlList[i]);
		if (referencingControlElement != null) {
			var attValue = referencingControlElement.getAttribute("data-reform_param_control_list");
			if (attValue != null && attValue != "") {
				var paramControlList = attValue.split(',');
				var index = paramControlList.indexOf(oldControlID);
				if (index != -1) {
					paramControlList[index] = newControlID;
					referencingControlElement.setAttribute("data-reform_param_control_list", paramControlList.toString());
				}
			}
		}
	}
}

function removeFromReferencingControls(controlID, referencingControlList) {
	for (var i = 0; i < referencingControlList.length; i++) {
		var referencingControlElement = webEditorDocument.getElementById(referencingControlList[i]);
		if (referencingControlElement != null) {
			var attValue = referencingControlElement.getAttribute("data-reform_param_control_list");
			if (attValue != null && attValue != "") {
				var paramControlList = attValue.split(',');
				var index = paramControlList.indexOf(controlID);
				if (index != -1) {
					paramControlList.splice(index, 1);
					referencingControlElement.setAttribute("data-reform_param_control_list", paramControlList.toString());
					
					// if the referencing control's param control list has become empty,
					// check and add it to the page load control list if needed.
					if (paramControlList.toString() == "") {
						var attValue = referencingControlElement.getAttribute("data-reform_data_bind_source");
						if (attValue != null && attValue != "") {
							addToPageLoadControlList(referencingControlList[i]);
						}
					}
				}
			}
		}
	}
}

function showAddDataBindControlDialog() {
	var url = "reformDataBindControlDialog.do";
	var args = {};
	args.command = "add";
	args.webEditorDocument = webEditorDocument;
	args.dataSourceList = getDataSourceList();
	args.completionHandlerForDialog = function(result) {
		if (result != null) {
			var dataBindInfo = JSON.parse(result);
			addDataBindControl(dataBindInfo);
			
			var controlElement = document.getElementById("data_bind_control_list");
			controlElement.selectedIndex = controlElement.options.length - 1;
		}
	};
	
	window.argsForDialog = args;
	
	GetOpenWindow(url, "", 700, 395, "NO");
}

function showModifyDataBindControlDialog() {
	var controlElement = document.getElementById("data_bind_control_list");
	if (controlElement.options.length > 0) {
		var dataBindID = controlElement.options[controlElement.selectedIndex].value;
		var dataBindControl = webEditorDocument.getElementById(dataBindID);
		if (dataBindControl != null) {
			var dataBindControlInfo = JSON.parse(dataBindControl.getAttribute("value"));
			var url = "reformDataBindControlDialog.do";
			var args = {};
			args.command = "modify";
			args.webEditorDocument = webEditorDocument;
			args.dataSourceList = getDataSourceList();
			args.dataBindID = dataBindID;
			args.dataBindControlInfo = dataBindControlInfo;
			args.completionHandlerForDialog = function(result) {
				if (result != null) {
					var newDataBindInfo = JSON.parse(result);
					modifyDataBindControl(dataBindID, newDataBindInfo);
				}
			};
			
			window.argsForDialog = args;
			
			GetOpenWindow(url, "", 700, 395, "NO");
		}
	}
}

function showDeleteDataBindControlDialog() {
	var controlElement = document.getElementById("data_bind_control_list");
	if (controlElement.options.length > 0) {
		var response = confirm(message["confirm.delete"]);
		if (response == true) {
			var dataBindID = controlElement.options[controlElement.selectedIndex].value;
			removeDataBindControl(dataBindID);
		}
	}
}

function showStyleDialog() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo || isTagfree) {
		restoreAfterHTMLSourceEditInNamo();
	}
	
	var url = "reformStyleDialog.do";
	var args = {};
	args.controlElement = currentControlElement;
	args.isIE11Mode = isIE11Mode;
	args.completionHandlerForDialog = function() {
		var valueElement = document.getElementById("prop_style");
		var attValue = currentControlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		valueElement.value = attValue;
		
		processAfterSaving();
	};
	
	window.argsForDialog = args;
	
	GetOpenWindow(url, "", 600, 258, "NO");
}

function showDisplayColumnDialog() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
	}
	
	var url = "reformDisplayColumnDialog.do";
	var args = {};
	var attValue = currentControlElement.getAttribute("data-reform_data_bind_display_column");
	attValue = attValue != null ? attValue : "";
	args.currentValue = attValue;
	args.completionHandlerForDialog = function(result) {
		if (result != null) {
			var newValue = result.trim();
			var valueElement = document.getElementById("prop_data_bind_display_column");
			valueElement.value = newValue;
			currentControlElement.setAttribute("data-reform_data_bind_display_column", newValue);
		}
	};
	
	window.argsForDialog = args;
	
	GetOpenWindow(url, "", 600, 224, "NO");
}

function showSelectValueDialog() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
	}
	
	var url = "reformSelectValueDialog.do";
	var valueElement = document.getElementById("prop_value");
	var args = {};
	var selectValueList = [];
	for (var i = 0; i < currentControlElement.options.length; i++) {
		if (currentControlElement.options[i].value != kNullIndexValue) {
			selectValueList.push(currentControlElement.options[i].text);
		}
	}
	args.selectValueList = selectValueList;
	args.completionHandlerForDialog = function(result) {
		if (result != null) {
			// remove the current data
			for (var i = currentControlElement.options.length - 1; i >= 0; i--) {
				if (currentControlElement.options[i].value != kNullIndexValue) {
					currentControlElement.remove(i);
				}
			}
			
			var valueList = result.split('\n');
			var valueListStr = "";
			for (var i = 0; i < valueList.length; i++) {
				var value = valueList[i].trim();
				if (value != "") {
					valueListStr += value;
					var optionElement = webEditorDocument.createElement("OPTION");
					optionElement.text = value;
					optionElement.value = value;
					currentControlElement.add(optionElement);
				}
			}
			
			valueElement.value = valueListStr;
		}
	};
	
	window.argsForDialog = args;
	
	GetOpenWindow(url, "", 450, 185, "NO");
}

function showParamControlListDialog() {
	if (isDEXT) {
		restoreAfterHTMLSourceEditInDEXT5();
	} else if (isNamo) {
		restoreAfterHTMLSourceEditInNamo();
	}
	
	var controlElement = webEditorDocument.getElementById("__reform_control_list");
	if (controlElement != null) {
		var controlList = JSON.parse(controlElement.getAttribute("value"));
		for (var i = controlList.length - 1; i >= 0; i--) {
			var controlID = controlList[i];
			var control = webEditorDocument.getElementById(controlID);
			if (control != null) {
				var type = control.getAttribute("type");
				if (type == null) {
					type = control.getAttribute("data-type");
				}
			}
		}
		
		var valueElement = document.getElementById("prop_param_control_list");
		var paramControlList = valueElement.value.split(',');
		var url = "reformParamControlListDialog.do";
		var args = {};
		args.currentControlElement = currentControlElement;
		args.controlList = controlList;
		args.paramControlList = paramControlList;
		args.completionHandlerForDialog = function(result) {
			if (result != null) {
				var newParamControlList = result.split(',');
				valueElement.value = result;
				valueElement.setAttribute("title", valueElement.value); // for tooltip
				
				var currentControlType = currentControlElement.type;
				if (typeof (currentControlElement.type) === "undefined") {
					currentControlType = currentControlElement.getAttribute("data-type");
				}
				var currentControlID = (currentControlType == "radio") ? currentControlElement.name : currentControlElement.id;
				currentControlElement.setAttribute("data-reform_param_control_list", result);
				if (currentControlType == "radio") {
					var elements = webEditorDocument.getElementsByName(currentControlID);
					for (var i = 0; i < elements.length; i++) {
						var element = elements[i];
						if (element != currentControlElement) {
							element.setAttribute("data-reform_param_control_list", result);
						}
					}
				}
				
				if (result == "") {
					var attValue = currentControlElement.getAttribute("data-reform_data_bind_source");
					if (attValue != null && attValue != "") {
						addToPageLoadControlList(currentControlID);
					}
				} else {
					removeFromPageLoadControlList(currentControlID);
				}
				
				removeFromReferencedControls(currentControlID, paramControlList);
				if (result != "") {
					addToReferencedControls(currentControlID, newParamControlList);
				}
			}
		};
		
		window.argsForDialog = args;
		
		GetOpenWindow(url, "", 450, 221, "NO");
	}
}