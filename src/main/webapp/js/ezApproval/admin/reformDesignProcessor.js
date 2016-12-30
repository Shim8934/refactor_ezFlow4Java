function onLoadHandler() {
    //for (var i = 0; i < params.length; i++) {
    //    var param = params[i].split('=');
    //    if (param[0] == "formID") {
    //        formID = param[1];
    //    }
    //    else if (param[0] == "companyID") {
    //        companyID = param[1];
    //    }
    //}

    //webEditor = document.getElementById('webEditor');
    //webEditor.src = iFrameUrl;
}
// notice that this function is called 3 times by the Form Processor Web Editor
function onFormDocumentLoadHandler() {
    //pzFormProc = webEditor.contentDocument.getElementById('pzFormProc_reform');
    webEditorDocument = pzFormProc_reform.editor.DOM;

	    // for IE 5 compatible mode
	    if (!Array.prototype.indexOf) {
	        Array.prototype.indexOf = function (item) {
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
	    resetUIDataBindControlList();
	    unloadControlProperties();

	    var nextAutoIDElement = webEditorDocument.getElementById("__reform_next_auto_id");
	    if (nextAutoIDElement != null) {
	        nextAutoID = parseInt(nextAutoIDElement.getAttribute("value"));
	    }

	    var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
	    if (dataBindControlList != null) {
	        var list = JSON.parse(dataBindControlList.getAttribute("value"));
	        for (var i = 0; i < list.length; i++) {
	            addToUIDataBindControlList(list[i]);
	        }
	    }

	    var inputElement = webEditorDocument.getElementById("__reform_control_list");
	    if (inputElement != null) {
	        var controlList = JSON.parse(inputElement.getAttribute("value"));
	        for (var i = 0; i < controlList.length; i++) {
	            var controlID = controlList[i];
	            var controlElement = webEditorDocument.getElementById(controlID);
	            if (controlElement != null) {
	                controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	            }
	        }
	    }

	    if (webEditorDocument.addEventListener) {
	        isIE11Mode = true;
	        // this event handler is required for the case the user deletes a control directly using the web editor.
	        webEditorDocument.addEventListener("DOMNodeRemoved", function (e) {
	            if (e.target.nodeType == 1) {
	                var attValue = e.target.getAttribute("data-reform_flag");
	                if (attValue == "1") {
	                    if (e.target.nodeName == "SPAN") {
	                        // strangely, this event also happens when the user presses the enter key at the end of a label control
	                        // with the control's innerHTML kept. we just return in this case.
	                        if (e.target.innerHTML != "") {
	                            return;
	                        }
	                    }

	                    removeControlFromManagementData(e.target);
	                }
	            }
	        }, false);
	        webEditorDocument.addEventListener("DOMNodeInserted", function (e) {
	            if (e.target.nodeType == 1) {
	                if (e.target.nodeName == "P") {
	                    // to consider later
                        /*
	                    var attValue = e.target.getAttribute("style");
	                    if (attValue == null || attValue == "") {
	                        e.target.setAttribute("style", "margin: 0px;");
	                    }
                        */
	                }
	                else if (e.target.nodeName == "SPAN") {
	                    // when the user presses the enter key at the end of the current selected label control,
	                    // a copy of the label control(SPAN tag) with an outline is automatically created by the web editor.
	                    // this code block is for removing the outline.
	                    var styleAttValue = e.target.getAttribute("style");
	                    if (styleAttValue != null) {
	                        if (e.target.style.outline != "" && e.target.innerHTML == "") {
	                            var reformFlag = e.target.getAttribute("data-reform_flag");
	                            if (reformFlag == "1") {
	                                e.target.style.outline = "";
	                                e.target.removeAttribute("data-reform_flag");
	                                e.target.removeAttribute("data-type");
	                                e.target.removeAttribute("onclick");
	                            }
	                        }
	                    }
	                }
	            }
	        }, false);
	    }
	    else if (webEditorDocument.attachEvent) {
	        isIE11Mode = false;
	        // this event handler is required for the case the user deletes a control directly using the web editor.
	        webEditorDocument.attachEvent("DOMNodeRemoved", function (e) {
	            if (e.target.nodeType == 1) {
	                var attValue = e.target.getAttribute("data-reform_flag");
	                if (attValue == "1") {
	                    if (e.target.nodeName == "SPAN") {
	                        // strangely, this event also happens when the user presses the enter key at the end of a label control
	                        // with the control's innerHTML kept. we just return in this case.
	                        if (e.target.innerHTML != "") {
	                            return;
	                        }
	                    }

	                    removeControlFromManagementData(e.target);
	                }
	            }
	        });
	        webEditorDocument.attachEvent("DOMNodeInserted", function (e) {
	            if (e.target.nodeType == 1) {
	                if (e.target.nodeName == "P") {
	                    // to consider later
                        /*
	                    var attValue = e.target.getAttribute("style");
	                    if (attValue == null || attValue == "") {
	                        e.target.setAttribute("style", "margin: 0px;");
	                    }
                        */
	                }
	                else if (e.target.nodeName == "SPAN") {
	                    // when the user presses the enter key at the end of the current selected label control,
	                    // a copy of the label control(SPAN tag) with an outline is automatically created by the web editor.
	                    // this code block is for removing the outline.
	                    var styleAttValue = e.target.getAttribute("style");
	                    if (styleAttValue != null) {
	                        if (e.target.style.outline != "" && e.target.innerHTML == "") {
	                            var reformFlag = e.target.getAttribute("data-reform_flag");
	                            if (reformFlag == "1") {
	                                e.target.style.outline = "";
	                                e.target.removeAttribute("data-reform_flag");
	                                e.target.removeAttribute("data-type");
	                                e.target.removeAttribute("onclick");
	                            }
	                        }
	                    }
	                }
	            }
	        });
	    }
}

	function processForSaving() {
	    if (currentControlElement != null) {
	        currentControlElement.style.outline = "";
	    }
	}

	function reform_onClickHandler(event) {

	    var target = null;
	    if (event.target) {
	        target = event.target;
	    }
	    else if (event.srcElement) {
	        target = event.srcElement;
	    }
	    var orgTarget = target;

	    if (target.tagName == "OPTION") {
	        return true;
	    }

	    if (currentControlElement != null) {
	        currentControlElement.style.outline = "";
	    }

	    var parentNode = orgTarget.parentNode;
	    if (parentNode.tagName == "SPAN") {
	        parentNode = parentNode.parentNode;
	    }
	    if (parentNode.tagName == "TD") {
	        var tableElement = parentNode.parentNode.parentNode.parentNode;
	        var dataType = tableElement.getAttribute("data-type");
	        if (dataType == "grid") {
	            if (currentControlElement == target) {
	                target = parentNode;
	            }
	            else if (currentControlElement == parentNode) {
	                target = tableElement;
	            }
	        }
	    }
	    else if (parentNode.tagName == "TR") {
	        var tableElement = parentNode.parentNode.parentNode;
	        var dataType = tableElement.getAttribute("data-type");
	        if (dataType == "grid") {
	            if (currentControlElement == target) {
	                target = tableElement;
	            }
	        }
	    }

	    currentControlElement = target;
	    if (isIE11Mode) {
	        currentControlElement.style.outline = kSelectionOutlineSytle;
	    }

		unloadControlProperties();
		loadControlProperties(currentControlElement);
		showControlProperties(currentControlElement);

		event.cancelBubble = true;
		if (event.stopPropagation) {
		    event.stopPropagation();
		}

		if (orgTarget.type == "checkbox"
            || orgTarget.type == "radio") {
		    return false;
		}

		return true;
	}

	function reform_onKeyPressHandler(event) {
	    var keyCode = event.which || event.keyCode;
	    if (keyCode == 8) {
//	        removeControl(event.target);
	    }
	}

	function reform_removeCurrentControl() {
	    if (currentControlElement != null) {
	        removeControl(currentControlElement);
	    }
	}

	function reform_moveCopiedNode() {
	    if (currentControlElement != null) {
	        var controlType = currentControlElement.type;
	        if (typeof (currentControlElement.type) === "undefined") {
	            controlType = currentControlElement.getAttribute("data-type");
	        }
	        if (controlType == null) {
	            return;
	        }

	        // every control is supposed to be surrounded by a span element with 'contenteditable' set to false.
	        var spanElement = currentControlElement.parentNode;
	        insertElementToDocument(spanElement);
	    }
	}

	function reform_pasteCopiedNode() {
	    if (currentControlElement != null) {
	        var controlType = currentControlElement.type;
	        if (typeof (currentControlElement.type) === "undefined") {
	            controlType = currentControlElement.getAttribute("data-type");
	        }
	        if (controlType == null) {
	            return;
	        }

	        // every control is supposed to be surrounded by a span element with 'contenteditable' set to false.
	        var spanElement = currentControlElement.parentNode.cloneNode(true);
	        var controlElement = spanElement.children[0];
	        if (controlType != "radio") {
	            controlElement.id = getNextAutoID();
	        }

	        controlElement.removeAttribute("data-reform_data_bind_source");
	        controlElement.removeAttribute("data-reform_param_control_list");
	        controlElement.removeAttribute("data-reform_referencing_control_list");

	        insertElementToDocument(spanElement);
	        addControlToManagementDataAndMakeItCurrent(controlElement);
	    }
	}

    // returns the data source list configured in the Reform Tomcat server.
	function getDataSourceList() {
	    var reformServerUrl = "/reform/reformServer.aspx/getDataSourceList";
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
	        webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	        webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	    }
	    else {
	        nextAutoIDElement.setAttribute("value", nextAutoID);
	    }

	    return controlID;
	}

	function insertElementToDocument(element) {
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
	    }
	    else {
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
	        }
	        else {
	            containerNode.parentNode.appendChild(element);
	        }
	    }
	    else {
	        if (containerNode.nodeType == 3) {
	            if (webEditorDocument.getSelection().anchorOffset == 0) {
	                containerNode.parentNode.insertBefore(element, containerNode);
	                return;
	            }

	            if (containerNode.nextSibling != null) {
	                containerNode.parentNode.insertBefore(element, containerNode.nextSibling);
	            }
	            else {
	                containerNode.parentNode.appendChild(element);
	            }
	        }
	        else {	            
	            containerNode.appendChild(element);
	        }
	    }
	}

	function addSelectBox() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
	    var controlElement = webEditorDocument.createElement("select");
	    controlElement.setAttribute("data-reform_flag", "1");
	    controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	    controlElement.setAttribute("style", "width: 100px; overflow: auto;");
	    controlElement.setAttribute("size", "0");
	    var optionElement = webEditorDocument.createElement("OPTION");
	    optionElement.text = "";
	    optionElement.value = kNullIndexValue;
	    controlElement.add(optionElement);
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addTextBox() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
	    var controlElement = webEditorDocument.createElement("input");
	    controlElement.setAttribute("data-reform_flag", "1");
	    controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	    controlElement.type = "text";
	    controlElement.setAttribute("style", "width: 100px;");
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addCheckbox() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
	    var controlElement = webEditorDocument.createElement("input");
	    controlElement.setAttribute("data-reform_flag", "1");
	    controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	    controlElement.type = "checkbox";
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addRadioButton() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
	    var controlElement = webEditorDocument.createElement("input");
	    controlElement.setAttribute("data-reform_flag", "1");
	    controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	    controlElement.type = "radio";
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("name", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addButton() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
	    var controlElement = webEditorDocument.createElement("input");
	    controlElement.setAttribute("data-reform_flag", "1");
	    controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	    controlElement.type = "button";
	    controlElement.value = "Button";
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addLabel() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
	    var controlElement = webEditorDocument.createElement("span");
	    controlElement.setAttribute("data-reform_flag", "1");
	    controlElement.innerText = "Label";
	    controlElement.setAttribute("data-type", "label");
	    controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addGrid() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
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
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addDatePicker() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
	    var controlElement = webEditorDocument.createElement("input");
	    controlElement.setAttribute("data-reform_flag", "1");
	    controlElement.setAttribute("data-reform_date_picker_flag", "1");
	    controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	    controlElement.type = "text";
	    controlElement.setAttribute("style", "width: 80px;");
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addTimePicker() {
	    if (webEditorDocument.getSelection) {
	        if (webEditorDocument.getSelection().anchorNode == null) {
	            return;
	        }
	    }
	    else {
	        if (webEditorDocument.selection.createRange().parentElement() == null) {
	            return;
	        }
	    }

	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
	    var controlElement = webEditorDocument.createElement("input");
	    controlElement.setAttribute("data-reform_flag", "1");
	    controlElement.setAttribute("data-reform_time_picker_flag", "1");
	    controlElement.setAttribute("data-reform_time_gap", "10");
	    controlElement.setAttribute("onclick", "return reform_onClickHandler(event);");
	    controlElement.type = "text";
	    controlElement.setAttribute("style", "width: 43px;");
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

	    addControlToManagementDataAndMakeItCurrent(controlElement);
	}

	function addHiddenControl() {
	    var spanElement = webEditorDocument.createElement("span");
	    spanElement.setAttribute("contenteditable", "false");
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
	    spanElement.appendChild(controlElement);

	    insertElementToDocument(spanElement);

	    var controlID = getNextAutoID();
	    controlElement.setAttribute("id", controlID);

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

	    currentControlElement = controlElement;
	    if (isIE11Mode) {
	        currentControlElement.style.outline = kSelectionOutlineSytle;
	    }

	    // when the user presses the enter key near a label control, a wrong 'DOMNodeRemoved' event happens
        // so, we don't add a label control to management lists.
	    if (controlType != "label") {
	        addToControlList(controlID);
	        addToNoDataBoundControlList(controlID);
	    }

	    if (controlType == "text") {
	        var attValue = controlElement.getAttribute("data-reform_date_picker_flag");
	        if (attValue == "1") {
	            addToDatePickerList(controlID);
	        }
	        else {
	            attValue = controlElement.getAttribute("data-reform_time_picker_flag");
	            if (attValue == "1") {
	                addToTimePickerList(controlID);
	            }
	            else {
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

	    removeControlFromManagementData(controlElement);

	    var attValue = controlElement.getAttribute("data-reform_hidden_control_flag");

	    // every control is supposed to be surrounded by a span element with 'contenteditable' set to false.
	    var spanElement = controlElement.parentNode;
	    spanElement.parentNode.removeChild(spanElement);

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
	        }
	        else {
	            var attValue = controlElement.getAttribute("data-reform_time_picker_flag");
	            if (attValue == "1") {
	                removeFromTimePickerList(controlID);
	            }
	            else {
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
	        element.innerHTML = "스타일";
	        element = document.getElementById("prop1_value");
	        element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	        element = document.getElementById("prop2_name");
	        element.innerHTML = "값";
	        element = document.getElementById("prop2_value");
	        element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
	    }
	    else if (controlType == "select-one") {
	        element = document.getElementById("prop1_name");
	        element.innerHTML = "콘트롤아이디";
	        element = document.getElementById("prop1_value");
	        element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop2_name");
	        element.innerHTML = "스타일";
	        element = document.getElementById("prop2_value");
	        element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	        element = document.getElementById("prop3_name");
	        element.innerHTML = "값";
	        element = document.getElementById("prop3_value");
	        element.innerHTML = '<input id="prop_value" type="text" readonly="readonly" onclick="showSelectValueDialog()" />';

	        element = document.getElementById("prop4_name");
	        element.innerHTML = "크기";
	        element = document.getElementById("prop4_value");
	        element.innerHTML = '<input id="prop_size" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop5_name");
	        element.innerHTML = "데이터연동소스";
	        element = document.getElementById("prop5_value");
	        element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';

	        element = document.getElementById("prop6_name");
	        element.innerHTML = "데이터연동 값컬럼";
	        element = document.getElementById("prop6_value");
	        element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop7_name");
	        element.innerHTML = "데이터연동 표시컬럼";
	        element = document.getElementById("prop7_value");
	        element.innerHTML = '<input id="prop_data_bind_display_column" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop8_name");
	        element.innerHTML = "인자콘트롤목록";
	        element = document.getElementById("prop8_value");
	        element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';

	        element = document.getElementById("prop9_name");
	        element.innerHTML = "헤더";
	        element = document.getElementById("prop9_value");
	        element.innerHTML = '<input id="prop_header" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop10_name");
	        element.innerHTML = "탭순서";
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
	    }
	    else if (controlType == "text") {
	        var attValue = controlElement.getAttribute("data-reform_date_picker_flag");
	        var attValue2 = controlElement.getAttribute("data-reform_time_picker_flag");
	        var attValue3 = controlElement.getAttribute("data-reform_hidden_control_flag");
	        if (attValue == "1") {
	            element = document.getElementById("prop1_name");
	            element.innerHTML = "콘트롤아이디";
	            element = document.getElementById("prop1_value");
	            element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop2_name");
	            element.innerHTML = "스타일";
	            element = document.getElementById("prop2_value");
	            element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	            element = document.getElementById("prop3_name");
	            element.innerHTML = "탭순서";
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
	        }
	        else if (attValue2 == "1") {
	            element = document.getElementById("prop1_name");
	            element.innerHTML = "콘트롤아이디";
	            element = document.getElementById("prop1_value");
	            element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop2_name");
	            element.innerHTML = "스타일";
	            element = document.getElementById("prop2_value");
	            element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	            element = document.getElementById("prop3_name");
	            element.innerHTML = "간격";
	            element = document.getElementById("prop3_value");
	            element.innerHTML = '<input id="prop_time_gap" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop4_name");
	            element.innerHTML = "탭순서";
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
	        }
	        else if (attValue3 == "1") {
	            element = document.getElementById("prop1_name");
	            element.innerHTML = "콘트롤아이디";
	            element = document.getElementById("prop1_value");
	            element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop2_name");
	            element.innerHTML = "값";
	            element = document.getElementById("prop2_value");
	            element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop3_name");
	            element.innerHTML = "데이터연동소스";
	            element = document.getElementById("prop3_value");
	            element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';

	            element = document.getElementById("prop4_name");
	            element.innerHTML = "데이터연동 값컬럼";
	            element = document.getElementById("prop4_value");
	            element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop5_name");
	            element.innerHTML = "인자콘트롤목록";
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
	        }
	        else {
	            element = document.getElementById("prop1_name");
	            element.innerHTML = "콘트롤아이디";
	            element = document.getElementById("prop1_value");
	            element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop2_name");
	            element.innerHTML = "스타일";
	            element = document.getElementById("prop2_value");
	            element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	            element = document.getElementById("prop3_name");
	            element.innerHTML = "값";
	            element = document.getElementById("prop3_value");
	            element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop4_name");
	            element.innerHTML = "읽기전용";
	            element = document.getElementById("prop4_value");
	            element.innerHTML = '<input id="prop_read_only" type="checkbox" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop5_name");
	            element.innerHTML = "데이터연동소스";
	            element = document.getElementById("prop5_value");
	            element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';

	            element = document.getElementById("prop6_name");
	            element.innerHTML = "데이터연동 값컬럼";
	            element = document.getElementById("prop6_value");
	            element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';

	            element = document.getElementById("prop7_name");
	            element.innerHTML = "인자콘트롤목록";
	            element = document.getElementById("prop7_value");
	            element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';

	            element = document.getElementById("prop8_name");
	            element.innerHTML = "탭순서";
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
	        }
	    }
	    else if (controlType == "checkbox") {
	        element = document.getElementById("prop1_name");
	        element.innerHTML = "콘트롤아이디";
	        element = document.getElementById("prop1_value");
	        element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop2_name");
	        element.innerHTML = "스타일";
	        element = document.getElementById("prop2_value");
	        element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	        element = document.getElementById("prop3_name");
	        element.innerHTML = "값";
	        element = document.getElementById("prop3_value");
	        element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop4_name");
	        element.innerHTML = "읽기전용";
	        element = document.getElementById("prop4_value");
	        element.innerHTML = '<input id="prop_read_only" type="checkbox" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop5_name");
	        element.innerHTML = "체크상태";
	        element = document.getElementById("prop5_value");
	        element.innerHTML = '<input id="prop_checked_state" type="checkbox" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop6_name");
	        element.innerHTML = "데이터연동소스";
	        element = document.getElementById("prop6_value");
	        element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';

	        element = document.getElementById("prop7_name");
	        element.innerHTML = "데이터연동 값컬럼";
	        element = document.getElementById("prop7_value");
	        element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop8_name");
	        element.innerHTML = "인자콘트롤목록";
	        element = document.getElementById("prop8_value");
	        element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';

	        element = document.getElementById("prop9_name");
	        element.innerHTML = "탭순서";
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
	    }
	    else if (controlType == "radio") {
	        element = document.getElementById("prop1_name");
	        element.innerHTML = "콘트롤아이디";
	        element = document.getElementById("prop1_value");
	        element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop2_name");
	        element.innerHTML = "스타일";
	        element = document.getElementById("prop2_value");
	        element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	        element = document.getElementById("prop3_name");
	        element.innerHTML = "값";
	        element = document.getElementById("prop3_value");
	        element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop4_name");
	        element.innerHTML = "읽기전용";
	        element = document.getElementById("prop4_value");
	        element.innerHTML = '<input id="prop_read_only" type="checkbox" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop5_name");
	        element.innerHTML = "체크상태";
	        element = document.getElementById("prop5_value");
	        element.innerHTML = '<input id="prop_checked_state" type="checkbox" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop6_name");
	        element.innerHTML = "데이터연동소스";
	        element = document.getElementById("prop6_value");
	        element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';

	        element = document.getElementById("prop7_name");
	        element.innerHTML = "데이터연동 값컬럼";
	        element = document.getElementById("prop7_value");
	        element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop8_name");
	        element.innerHTML = "인자콘트롤목록";
	        element = document.getElementById("prop8_value");
	        element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';

	        element = document.getElementById("prop9_name");
	        element.innerHTML = "탭순서";
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
	    }
	    else if (controlType == "button") {
	        element = document.getElementById("prop1_name");
	        element.innerHTML = "콘트롤아이디";
	        element = document.getElementById("prop1_value");
	        element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop2_name");
	        element.innerHTML = "스타일";
	        element = document.getElementById("prop2_value");
	        element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	        element = document.getElementById("prop3_name");
	        element.innerHTML = "값";
	        element = document.getElementById("prop3_value");
	        element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop4_name");
	        element.innerHTML = "탭순서";
	        element = document.getElementById("prop4_value");
	        element.innerHTML = '<input id="prop_tabindex" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("event1_name");
	        element.innerHTML = "onClick";
	        element = document.getElementById("event1_value");
	        element.innerHTML = '<input id="event_on_click" type="text" onchange="propValueChanged(this)" />';
	    }
	    else if (controlType == "label") {
	        element = document.getElementById("prop1_name");
	        element.innerHTML = "콘트롤아이디";
	        element = document.getElementById("prop1_value");
	        element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop2_name");
	        element.innerHTML = "스타일";
	        element = document.getElementById("prop2_value");
	        element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	        element = document.getElementById("prop3_name");
	        element.innerHTML = "값";
	        element = document.getElementById("prop3_value");
	        element.innerHTML = '<input id="prop_value" type="text" onchange="propValueChanged(this)" />';
	    }
	    else if (controlType == "grid") {
	        element = document.getElementById("prop1_name");
	        element.innerHTML = "콘트롤아이디";
	        element = document.getElementById("prop1_value");
	        element.innerHTML = '<input id="prop_id" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop2_name");
	        element.innerHTML = "스타일";
	        element = document.getElementById("prop2_value");
	        element.innerHTML = '<input id="prop_style" type="text" readonly="readonly" onclick="showStyleDialog()" />';

	        element = document.getElementById("prop3_name");
	        element.innerHTML = "헤더";
	        element = document.getElementById("prop3_value");
	        element.innerHTML = '<input id="prop_has_header" type="checkbox" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop4_name");
	        element.innerHTML = "컬럼수";
	        element = document.getElementById("prop4_value");
	        element.innerHTML = '<input id="prop_column_count" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop5_name");
	        element.innerHTML = "데이터연동소스";
	        element = document.getElementById("prop5_value");
	        element.innerHTML = '<select id="prop_data_bind_source" onchange="propValueChanged(this)">\
                                        <option value=""></option>\
                                    </select>';

	        element = document.getElementById("prop6_name");
	        element.innerHTML = "데이터연동 값컬럼";
	        element = document.getElementById("prop6_value");
	        element.innerHTML = '<input id="prop_data_bind_value_column" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop7_name");
	        element.innerHTML = "데이터연동 표시컬럼";
	        element = document.getElementById("prop7_value");
	        element.innerHTML = '<input id="prop_data_bind_display_column" type="text" onchange="propValueChanged(this)" />';

	        element = document.getElementById("prop8_name");
	        element.innerHTML = "인자콘트롤목록";
	        element = document.getElementById("prop8_value");
	        element.innerHTML = '<input id="prop_param_control_list" type="text" readonly="readonly" onclick="showParamControlListDialog()" />';

	        var dataBindControlList = webEditorDocument.getElementById("__reform_data_bind_list");
	        if (dataBindControlList != null) {
	            var value = dataBindControlList.getAttribute("value");
	            var list = JSON.parse(value);
	            for (var i = 0; i < list.length; i++) {
	                addToUIDataBindSourceList(list[i]);
	            }
	        }
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
	    }
	    else {
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

	function removeGridHeader(grid) {
	    grid.deleteRow(0);
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
		}
		else if (controlType == "select-one") {
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

			valueElement = document.getElementById("prop_data_bind_display_column");
			attValue = controlElement.getAttribute("data-reform_data_bind_display_column");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;

			valueElement = document.getElementById("prop_param_control_list");
			attValue = controlElement.getAttribute("data-reform_param_control_list");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;

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

			valueElement = document.getElementById("event_on_post_change");
			attValue = controlElement.getAttribute("data-reform_on_post_change");
			attValue = attValue != null ? attValue : "";
			valueElement.value = attValue;
		}
		else if (controlType == "text") {
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

		        valueElement = document.getElementById("event_on_post_change");
		        attValue = controlElement.getAttribute("data-reform_on_post_change");
		        attValue = attValue != null ? attValue : "";
		        valueElement.value = attValue;
		    }
		    else if (attValue2 == "1") {
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

		        valueElement = document.getElementById("event_on_post_change");
		        attValue = controlElement.getAttribute("data-reform_on_post_change");
		        attValue = attValue != null ? attValue : "";
		        valueElement.value = attValue;
		    }
		    else if (attValue3 == "1") {
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

		        valueElement = document.getElementById("prop_param_control_list");
		        attValue = controlElement.getAttribute("data-reform_param_control_list");
		        attValue = attValue != null ? attValue : "";
		        valueElement.value = attValue;

		        valueElement = document.getElementById("event_on_pre_change");
		        attValue = controlElement.getAttribute("data-reform_on_pre_change");
		        attValue = attValue != null ? attValue : "";
		        valueElement.value = attValue;

		        valueElement = document.getElementById("event_on_post_change");
		        attValue = controlElement.getAttribute("data-reform_on_post_change");
		        attValue = attValue != null ? attValue : "";
		        valueElement.value = attValue;
		    }
		    else {
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

		        valueElement = document.getElementById("prop_param_control_list");
		        attValue = controlElement.getAttribute("data-reform_param_control_list");
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

		        valueElement = document.getElementById("event_on_post_change");
		        attValue = controlElement.getAttribute("data-reform_on_post_change");
		        attValue = attValue != null ? attValue : "";
		        valueElement.value = attValue;
		    }
		}
		else if (controlType == "checkbox") {
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
		    attValue = controlElement.getAttribute("checked");
		    valueElement.checked = attValue == "checked";

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

		    valueElement = document.getElementById("prop_param_control_list");
		    attValue = controlElement.getAttribute("data-reform_param_control_list");
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

		    valueElement = document.getElementById("event_on_post_change");
		    attValue = controlElement.getAttribute("data-reform_on_post_change");
		    attValue = attValue != null ? attValue : "";
		    valueElement.value = attValue;
		}
		else if (controlType == "radio") {
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
		    attValue = controlElement.getAttribute("checked");
		    valueElement.checked = attValue == "checked";

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

		    valueElement = document.getElementById("prop_param_control_list");
		    attValue = controlElement.getAttribute("data-reform_param_control_list");
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

		    valueElement = document.getElementById("event_on_post_change");
		    attValue = controlElement.getAttribute("data-reform_on_post_change");
		    attValue = attValue != null ? attValue : "";
		    valueElement.value = attValue;
		}
		else if (controlType == "button") {
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
		}
		else if (controlType == "label") {
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
		}
		else if (controlType == "grid") {
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

		    valueElement = document.getElementById("prop_data_bind_display_column");
		    attValue = controlElement.getAttribute("data-reform_data_bind_display_column");
		    attValue = attValue != null ? attValue : "";
		    valueElement.value = attValue;

		    valueElement = document.getElementById("prop_param_control_list");
		    attValue = controlElement.getAttribute("data-reform_param_control_list");
		    attValue = attValue != null ? attValue : "";
		    valueElement.value = attValue;
		}
	}

	function propValueChanged(propControlElement) {
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
		        alert("이미 사용 중인 아이디입니다. 다른 아이디를 입력해 주세요.");
		        propControlElement.value = currentControlID;
		        return;
		    }

		    propControlElement.value = newControlID;

		    if (currentControlID != newControlID) {
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
		            }
		            else {
		                attValue = currentControlElement.getAttribute("data-reform_time_picker_flag");
		                if (attValue == "1") {
		                    modifyTimePickerList(currentControlID, newControlID);
		                }
		                else {
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
		    }
		    else {
		        currentControlElement.setAttribute("id", newControlID);
		    }
		}
		else if (propControlID == "prop_value") {
		    if (currentControlType == "text"
                || currentControlType == "checkbox"
                || currentControlType == "radio"
                || currentControlType == "button") {
		        propControlElement.value = propControlElement.value.trim();
		        currentControlElement.setAttribute("value", propControlElement.value);
		        currentControlElement.value = propControlElement.value;
		    }
		    else if (currentControlType == "label") {
		        propControlElement.value = propControlElement.value.trim();
                currentControlElement.innerText = propControlElement.value;
		    }
		    else if (tagName == "TH" || tagName == "TD") {
		        propControlElement.value = propControlElement.value.trim();
		        currentControlElement.innerText = propControlElement.value;
		    }
		}
		else if (propControlID == "prop_read_only") {
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
		    }
		    else {
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
		}
		else if (propControlID == "prop_checked_state") {
		    if (propControlElement.checked) {
		        currentControlElement.setAttribute("checked", "checked");
		    }
		    else {
		        currentControlElement.removeAttribute("checked");
		    }
		    currentControlElement.checked = propControlElement.checked;
		}
		else if (propControlID == "prop_has_header") {
		    if (propControlElement.checked) {
		        addGridHeader(currentControlElement);
		    }
		    else {
		        removeGridHeader(currentControlElement);
		    }
		}
		else if (propControlID == "prop_size") {
		    propControlElement.value = propControlElement.value.trim();
			currentControlElement.setAttribute("size", propControlElement.value);
			if (currentControlElement.size > 1) {
			    if (currentControlElement.options[0].value == kNullIndexValue) {
			        currentControlElement.removeChild(currentControlElement.firstChild);
			    }
			}
			else {			        
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
		}
		else if (propControlID == "prop_column_count") {
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
		        }
		        else if (newColumnCount < currentColumnCount) {
		            var delta = currentColumnCount - newColumnCount;
		            for (var i = 1; i <= delta; i++) {
		                row.deleteCell(currentColumnCount - i);
		            }
		        }
		    }
		}
		else if (propControlID == "prop_data_bind_source") {
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
		        }
		        else {
		            removeFromPageLoadControlList(currentControlID);
		        }

		        removeFromNoDataBoundControlList(currentControlID);
		    }
		    else {
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
		}
		else if (propControlID == "prop_data_bind_value_column") {
		    propControlElement.value = propControlElement.value.trim();
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
		}
		else if (propControlID == "prop_data_bind_display_column") {
		    propControlElement.value = propControlElement.value.trim();
		    currentControlElement.setAttribute("data-reform_data_bind_display_column", propControlElement.value);
		}
		else if (propControlID == "prop_time_gap") {
		    propControlElement.value = propControlElement.value.trim();
		    if (isNaN(propControlElement.value)) {
		        alert("숫자를 입력해 주세요.")

		        propControlElement.value = currentControlElement.getAttribute("data-reform_time_gap");
		        return;
		    }
		    currentControlElement.setAttribute("data-reform_time_gap", propControlElement.value);
		}
		else if (propControlID == "prop_header") {
		    propControlElement.value = propControlElement.value.trim();
		    currentControlElement.setAttribute("data-reform_header", propControlElement.value);
		    if (currentControlElement.size == 0 || currentControlElement.size == 1) {
		        currentControlElement.options[0].text = propControlElement.value;
		    }
		}
		else if (propControlID == "prop_tabindex") {
		    propControlElement.value = propControlElement.value.trim();
		    if (propControlElement.value != "") {
		        currentControlElement.setAttribute("tabindex", propControlElement.value);
		    }
		    else {
		        currentControlElement.removeAttribute("tabindex");
		    }
		}
		else if (propControlID == "event_on_pre_change") {
		    propControlElement.value = propControlElement.value.trim();
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
		}
		else if (propControlID == "event_on_post_change") {
		    propControlElement.value = propControlElement.value.trim();
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
		}
		else if (propControlID == "event_on_click") {
		    propControlElement.value = propControlElement.value.trim();
		    currentControlElement.setAttribute("data-reform_on_click", propControlElement.value);
		}
	}

	function showPreview() {
	    var args = {};
	    args.webEditorDocument = webEditorDocument;
	    var txt_reformFunction = parent.document.getElementById("txt_reformFunction");
	    args.reformScriptCode = txt_reformFunction != null ? txt_reformFunction.value : null;
 
	    var url = "reformPreview.aspx";
	    if (currentControlElement != null) {
	        var attValue = currentControlElement.getAttribute("style");
	        attValue = attValue != null ? attValue : "";
	        attValue = removeOutlineStyle(attValue);
	        currentControlElement.setAttribute("style", attValue);
	    }
		window.showModalDialog(url, args, "dialogWidth:1000px;dialogHeight:900px;status:no;help:no;scroll:no;edge:sunken");
		if (currentControlElement != null) {
		    if (isIE11Mode) {
		        var attValue = currentControlElement.getAttribute("style");
		        attValue = attValue != null ? attValue : "";
		        var styleValue = attValue + " outline: " + kSelectionOutlineSytle + ";";
		        currentControlElement.setAttribute("style", styleValue);
		    }
		}
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
	        webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	        webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	        dataBindList = [dataBindID];
	    }
	    else {
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
	    webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
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
	        webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	        webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	        pageLoadControlList = [controlID];
	    }
	    else {
	        pageLoadControlList = JSON.parse(element.getAttribute("value"));
	        if (pageLoadControlList.indexOf(controlID) == -1) {
	            pageLoadControlList.push(controlID);
	        }

	        checkElementExistenceAndCorrectList(pageLoadControlList);
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
	            }
	            else {
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
	        webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	        webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	        noDataBoundControlList = [controlID];
	    }
	    else {
	        noDataBoundControlList = JSON.parse(element.getAttribute("value"));
	        if (noDataBoundControlList.indexOf(controlID) == -1) {
	            noDataBoundControlList.push(controlID);
	        }

	        checkElementExistenceAndCorrectList(noDataBoundControlList);
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
	            }
	            else {
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
	        webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	        webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	        controlList = [controlID];
	    }
	    else {
	        controlList = JSON.parse(element.getAttribute("value"));
	        if (controlList.indexOf(controlID) == -1) {
	            controlList.push(controlID);
	        }		

	        checkElementExistenceAndCorrectList(controlList);
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
	            }
	            else {
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
	        webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	        webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	        controlList = [controlID];
	    }
	    else {
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
	            }
	            else {
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
	        webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	        webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	        controlList = [controlID];
	    }
	    else {
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
	            }
	            else {
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
	        webEditorDocument.body.insertBefore(webEditorDocument.createTextNode("\n"), webEditorDocument.body.firstChild);
	        webEditorDocument.body.insertBefore(element, webEditorDocument.body.firstChild);
	        controlList = [controlID];
	    }
	    else {
	        controlList = JSON.parse(element.getAttribute("value"));
	        if (controlList.indexOf(controlID) == -1) {
	            controlList.push(controlID);
	        }

	        checkElementExistenceAndCorrectList(controlList);
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
	            }
	            else {
	                var referencingControlList = attValue.split(',');
	                if (referencingControlList.indexOf(controlID) == -1) {
	                    referencingControlList.push(controlID);
	                    referencedControlElement.setAttribute("data-reform_referencing_control_list", referencingControlList.toString());
	                }
	            }
	        }
	        else if (referencedControlElements != null) {
	            if (referencedControlElements.length > 0) {
	                referencedControlElement = referencedControlElements[0];
	                var attValue = referencedControlElement.getAttribute("data-reform_referencing_control_list");
	                if (attValue == null || attValue == "") {
	                    referencedControlElement.setAttribute("data-reform_referencing_control_list", controlID);
	                }
	                else {
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
	        }
	        else {
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
	                }
	            }
	        }
	    }
	}

	function showAddDataBindControlDialog() {
	    var url = "reformDataBindControlDialog.aspx";
	    var args = {};
	    args.command = "add";
	    args.webEditorDocument = webEditorDocument;
	    args.dataSourceList = getDataSourceList();
	    var result = window.showModalDialog(url, args, "status:no;dialogWidth:700px;dialogHeight:395px;edge:sunken;scroll:no");
	    if (result != null) {
	        var dataBindInfo = JSON.parse(result);
	        addDataBindControl(dataBindInfo);

	        var controlElement = document.getElementById("data_bind_control_list");
	        controlElement.selectedIndex = controlElement.options.length - 1;
	    }
	}

	function showModifyDataBindControlDialog() {
	    var controlElement = document.getElementById("data_bind_control_list");
	    if (controlElement.options.length > 0) {
	        var dataBindID = controlElement.options[controlElement.selectedIndex].value;
	        var dataBindControl = webEditorDocument.getElementById(dataBindID);
	        if (dataBindControl != null) {
	            var dataBindControlInfo = JSON.parse(dataBindControl.getAttribute("value"));
	            var url = "reformDataBindControlDialog.aspx";
	            var args = {};
	            args.command = "modify";
	            args.webEditorDocument = webEditorDocument;
	            args.dataSourceList = getDataSourceList();
	            args.dataBindID = dataBindID;
	            args.dataBindControlInfo = dataBindControlInfo;
	            var result = window.showModalDialog(url, args, "status:no;dialogWidth:700px;dialogHeight:395px;edge:sunken;scroll:no");
	            if (result != null) {
	                var newDataBindInfo = JSON.parse(result);
	                modifyDataBindControl(dataBindID, newDataBindInfo);
	            }
	        }
	    }
	}

	function showDeleteDataBindControlDialog() {
	    var controlElement = document.getElementById("data_bind_control_list");
	    if (controlElement.options.length > 0) {
	        var response = confirm("정말로 삭제하시겠습니까?");
	        if (response == true) {
	            var dataBindID = controlElement.options[controlElement.selectedIndex].value;
	            removeDataBindControl(dataBindID);
	        }
	    }
	}

	function showStyleDialog() {
	    var url = "reformStyleDialog.aspx";
	    var args = {};
	    args.controlElement = currentControlElement;
	    args.isIE11Mode = isIE11Mode;
	    var result = window.showModalDialog(url, args, "status:no;dialogWidth:600px;dialogHeight:224px;edge:sunken;scroll:no");
	    var valueElement = document.getElementById("prop_style");
	    var attValue = currentControlElement.getAttribute("style");
	    attValue = attValue != null ? attValue : "";
	    attValue = removeOutlineStyle(attValue);
	    valueElement.value = attValue;
	}

	function showSelectValueDialog() {
	    var url = "reformSelectValueDialog.aspx";
	    var valueElement = document.getElementById("prop_value");
	    var args = {};
	    var selectValueList = [];
	    for (var i = 0; i < currentControlElement.options.length; i++) {
	        if (currentControlElement.options[i].value != kNullIndexValue) {
	            selectValueList.push(currentControlElement.options[i].text);
	        }
	    }
	    args.selectValueList = selectValueList;
	    var result = window.showModalDialog(url, args, "status:no;dialogWidth:450px;dialogHeight:185px;edge:sunken;scroll:no");
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
	}

	function showParamControlListDialog() {
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
	        var url = "reformParamControlListDialog.aspx";
	        var args = {};
	        args.currentControlElement = currentControlElement;
	        args.controlList = controlList;
	        args.paramControlList = paramControlList;
	        var result = window.showModalDialog(url, args, "status:no;dialogWidth:450px;dialogHeight:221px;edge:sunken;scroll:no");
	        if (result != null) {
	            var newParamControlList = result.split(',');
	            valueElement.value = result;

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
	            }
	            else {
	                removeFromPageLoadControlList(currentControlID);
	            }

	            removeFromReferencedControls(currentControlID, paramControlList);
	            if (result != "") {
	                addToReferencedControls(currentControlID, newParamControlList);
	            }
	        }
	    }
	}