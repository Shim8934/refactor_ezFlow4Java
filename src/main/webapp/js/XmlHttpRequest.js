function BroswerAndNonActiveXCheck() {
    if (CrossYN()) {
        return "CROSS";
    } else {
        return "IE";
    }
    
    /*
    if (typeof(pNoneActiveX) == "undefined")
    {        
        if (window.ActiveXObject || "ActiveXObject" in window) {
            return "IE";
        }       
        else if (window.DOMParser) {
            return "CROSS";
        }
    }
    else
    { 
        if (pNoneActiveX == "YES") {
            return "CROSS";
        }
        else {
            if (window.ActiveXObject || "ActiveXObject" in window) {
                return "IE";
            }
            else if (window.DOMParser) {
                return "CROSS";
            }
        }
    }    
    */
}

function createXMLHttpRequest() {
    var oXmlRequest;
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        oXmlRequest = new XMLHttpRequest(); 
    }
    else {
        oXmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
    }    
    return oXmlRequest;
}

function createXmlDom() {
    var xmlDoc;    
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        xmlDoc = document.implementation.createDocument("", "", null);
    }
    else {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    }    
    return xmlDoc;
}

function loadXMLFile(filename) {
    var xmlhttp;    
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        xmlhttp = new XMLHttpRequest();
    }
    else {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }    
    xmlhttp.open("GET", filename, false);
    xmlhttp.send();
    return loadXMLString(xmlhttp.responseText);
}
function loadXMLString(xmlstring) {
    var xmlDoc;  
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        var parser = new DOMParser();
        xmlDoc = parser.parseFromString(xmlstring, "text/xml");
        parser = null;
    }
    else {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = "false";
        xmlDoc.loadXML(xmlstring);
    }
    return xmlDoc;
}
function createNode(node, tagName) {
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        return node.createElement(tagName);
    }
    else {
        return node.createNode(1, tagName, "");        
    }    
}
function InsertText(xmlDoc, node, value) {
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        var newText = document.createTextNode(value);
        node.appendChild(newText);
        xmlDoc.documentElement.appendChild(node);
    }
    else {
        node.text = value;
        xmlDoc.documentElement.appendChild(node);        
    }
    return node;
}
function appendChildText(targetNode, node, value) {
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        var newText = document.createTextNode(value);
        node.appendChild(newText);
        targetNode.appendChild(node);
    }
    else {
        node.text = value;
        targetNode.appendChild(node);        
    }    
    return node;
}

function appendChildCDataText(targetNode, node, value, xmlDoc) {    
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        var newText = document.createTextNode(value);
        node.appendChild(newText);
        targetNode.appendChild(node);
    }
    else {
        var CDATA = xmlDoc.createCDATASection(value);
        node.appendChild(CDATA);
        targetNode.appendChild(node);
    }    
    return node;
}

function createNodeInsert(xmlparam, node, tagName) {
    node = createNode(xmlparam, tagName);
    xmlparam.appendChild(node);
    return node;
}

function createNodeAndInsertText(xmlparam, node, tagName, value) {
    node = createNode(xmlparam, tagName);
    InsertText(xmlparam, node, value);
    return node;
}

function createNodeAndInsertCDataText(xmlparam, node, tagName, value) {
    node = createNode(xmlparam, tagName);
    InsertCDataText(xmlparam, node, value);
    return node;
}

function InsertCDataText(xmlDoc, node, value) {    
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        var newText = document.createTextNode(value);
        node.appendChild(newText);
        xmlDoc.documentElement.appendChild(node);
    }
    else {
        var CDATA = xmlDoc.createCDATASection(value);
        node.appendChild(CDATA);
        xmlDoc.documentElement.appendChild(node);
    }    
    return node;
}

function createNodeAndAppandNode(xmlparam, targetNode, node, tagName) {
    node = createNode(xmlparam, tagName);
    targetNode.appendChild(node);
    return node;
}

function createNodeAndAppandNodeText(xmlparam, targetNode, node, tagName, value) {
    node = createNode(xmlparam, tagName);
    appendChildText(targetNode, node, value);
    return node;
}

function createNodeAndAppandNodeCDataText(xmlparam, targetNode, node, tagName, value) {
    node = createNode(xmlparam, tagName);
    appendChildCDataText(targetNode, node, value, xmlparam);
    return node;
}

function GetElementsByTagName(node, tagName) {
    return node.getElementsByTagName(tagName);
}

function SelectNodesNew(xmlDoc, path) {
    var nodes;
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        nodes = xml.evaluate(path, xmlDoc, null, XPathResult.ANY_TYPE, null);
    }
    else {
        nodes = xmlDoc.selectNodes(path);
    }    
    return nodes;
}

function SelectNodes(xmlDoc, elementPath) {
    var parentPath = "";
    var nodeName = "";
    var parentNode = null;
    if (elementPath == null || elementPath == "" || elementPath == "undfined") return false;
    if (elementPath.indexOf("/") == -1) {
        parentPath = elementPath;
        nodeName = elementPath;
        parentNode = xmlDoc.ownerDocument == null ? xmlDoc : xmlDoc.ownerDocument;
    } else {
        parentPath = elementPath.substr(0, elementPath.lastIndexOf("/"));
        nodeName = elementPath.substr(elementPath.lastIndexOf("/") + 1);

        if (parentPath.indexOf("//") != 0) {
            if (parentPath.indexOf("/") == 0) {
                parentPath = "/" + parentPath;
            } else {
                parentPath = "//" + parentPath;
            }
        }
        if (xmlDoc.nodeType == 9) {
            parentNode = SelectSingleNodeNew(xmlDoc, parentPath);
        }
        else {
            parentNode = SelectSingleNodeNew(xmlDoc, parentPath);
        }
    }
    if (parentNode == null) return false;

    return GetElementsByTagName(parentNode, nodeName);
}

function SelectSingleNode(node, tagName) {
    var objNode = null;
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        objNode = node.firstChild;
        while (objNode) {
            if (objNode.nodeType == 1 && objNode.tagName == tagName)
                break;
            else
                objNode = objNode.nextSibling;
        }
    }
    else {
        if(node != null)
        {
            if (node.selectSingleNode(tagName))
                return node.selectSingleNode(tagName);
        }
    }
    return objNode;
}

function SelectSingleNodeNew(xmlDoc, elementPath) {
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        if (elementPath.indexOf("//") != 0) {
            if (elementPath.indexOf("/") == 0) {
                elementPath = "/" + elementPath;
            } else {
                elementPath = "//" + elementPath;
            }
        }
        var nsResolver;
        try {
            nsResolver = xmlDoc.createNSResolver(xmlDoc.ownerDocument == null ? xmlDoc.documentElement : xmlDoc.ownerDocument.documentElement);
        } catch (e) {
            nsResolver = null;
        }
        try {
            var xpathResult = xmlDoc.evaluate(elementPath, xmlDoc, nsResolver, XPathResult.ANY_TYPE, null);
            var elements = null;
            var count = 0;

            var thisNode = xpathResult.iterateNext();
            while (thisNode) {
                if (thisNode != null) {
                    elements = thisNode;
                    break;
                }
                thisNode = xpathResult.iterateNext();
            }
        } catch (e) {
            var elementPathArry = elementPath.split("/");
            var selNode = xmlDoc;

            for (var i = 0; i < elementPathArry.length; i++) {
                if (elementPathArry[i] != "") {
                    selNode = SelectSingleNode(selNode, elementPathArry[i]);
                }
            }
            elements = selNode;
        }
    }
    else {
        try {
            var elements = xmlDoc.selectSingleNode(elementPath);
        } catch (e) { }
    }    
    return elements;
}

function SelectSingleNodeValue(node, tagName) {
    var strValue = "";
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        var objNode = node.firstChild;

        while (objNode) {
            if (objNode.nodeType == 1 && objNode.tagName.toUpperCase() == tagName.toUpperCase()) {
                if (objNode.firstChild != null && objNode.firstChild.nodeValue != null) {
                    strValue = objNode.firstChild.nodeValue;
                }
                break;
            }
            else {
                objNode = objNode.nextSibling;
            }
        }
    }
    else {
        if (node != null)
            if (node.selectSingleNode(tagName))
                return node.selectSingleNode(tagName).text;
    }
    return strValue;
}

function SelectSingleNodeValueNew(xmlDoc, elementPath) {
    var strValue = "";    
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        if (elementPath.indexOf("//") != 0) {
            if (elementPath.indexOf("/") == 0) {
                elementPath = "/" + elementPath;
            } else {
                elementPath = "//" + elementPath;
            }
        }
        try {
            var nsResolver = xmlDoc.createNSResolver(xmlDoc.ownerDocument == null ? xmlDoc.documentElement : xmlDoc.ownerDocument.documentElement);
            var xpathResult = xmlDoc.evaluate(elementPath, xmlDoc, nsResolver, XPathResult.ANY_TYPE, null);
            var elements = null;
            var count = 0;
            var thisNode = xpathResult.iterateNext();
            while (thisNode) {
                if (thisNode != null) {
                    elements = thisNode;
                    break;
                }
                thisNode = xpathResult.iterateNext();
            }
        }
        catch (e) {
            var elementPathArry = elementPath.split("/");
            var selNode = xmlDoc;

            for (var i = 0; i < elementPathArry.length; i++) {
                if (elementPathArry[i] != "") {
                    selNode = SelectSingleNode(selNode, elementPathArry[i]);
                }
            }
            strValue = getNodeText(selNode);
        }
        
        if (elements != null && elements.firstChild != null && elements.firstChild.nodeValue != null) {
            strValue = elements.firstChild.nodeValue;
        }        
    }
    else {
        if (xmlDoc.selectSingleNode(elementPath))
            return xmlDoc.selectSingleNode(elementPath).text;
    }    
    return strValue;
}
function GetSelectSingleNode(nodes, value) {
    var result;
    if (nodes == null || nodes.length == 0) return null;
    for (var i = 0; i < nodes.length; i++) {
        if (nodes[i].nodeName == value) {
            result = nodes[i]; break;
        }
    }
    return result;
}

function GetChildNodes(node) {
    var elements = new Array();

    objNode = node.firstChild;

    var idx = 0;
    while (objNode) {
        if (objNode.nodeType == 1) {
            elements[idx++] = objNode;
        }
        objNode = objNode.nextSibling;
    }

    return elements;

    /*
    var elements = new Array();
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        objNode = node.firstChild;

        var idx = 0;
        while (objNode) {
            if (objNode.nodeType == 1) {
                elements[idx++] = objNode;
            }
            objNode = objNode.nextSibling;
        }
    }
    else {
        return node.childNodes;
    }    
    return elements;
    */
}

function GetChildNodesByNodeName(node, nodeName) {
    var elements = new Array();
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        var parentNode = SelectSingleNodeNew(node, "//" + nodeName).parentNode;
        elements = GetElementsByTagName(parentNode, nodeName);
    }
    else {
        return node.getElementsByTagName(nodeName);
    }    
    return elements;
}

function GetLastChildNodes(node, params) {
    var resultNodes = GetChildNodes(node);
    if (params == null || params.length == 0) return resultNodes;
    for (var i = 0; i < params.length; i++) {
        var idx = parseInt(params[i], 10);
        resultNodes = GetChildNodes(resultNodes[idx]);
    }
    return resultNodes;
}

function SetChildNodeText(objDoc, params, inputIdx, value) {
    params.push(inputIdx);
    var arrNode = new Array();
    if (params == null || params.length == 0) return;

    var resultNode = objDoc;
    for (var i = 0; i < params.length; i++) {
        var idx = parseInt(params[i], 10);
        resultNode = GetNodeLevel(resultNode, arrNode, idx);
    }
    params.pop();

    if (arrNode == null || arrNode.length == 0) return;
    var nodecnt = arrNode.length;
    var idx0 = 0;
    var idx1 = 1;
    var idx2 = 2;
    var idx3 = 3;
    var idx4 = 4;
    var idx5 = 5;
    var idx6 = 6;
    var idx7 = 7;
    var idx8 = 8;
    var idx9 = 9;

    for (var i = 0; i < arrNode.length; i++) {
        var idx = parseInt(arrNode[i], 10);
        switch (i) {
            case 0: idx0 = idx; break;
            case 1: idx1 = idx; break;
            case 2: idx2 = idx; break;
            case 3: idx3 = idx; break;
            case 4: idx4 = idx; break;
            case 5: idx5 = idx; break;
            case 6: idx6 = idx; break;
            case 7: idx7 = idx; break;
            case 8: idx8 = idx; break;
            case 9: idx9 = idx; break;
        }
    }
    switch (nodecnt) {
        case 1: setNodeText(objDoc.childNodes[idx0], value); break;
        case 2: setNodeText(objDoc.childNodes[idx0].childNodes[idx1], value); break;
        case 3: setNodeText(objDoc.childNodes[idx0].childNodes[idx1].childNodes[idx2], value); break;
        case 4: setNodeText(objDoc.childNodes[idx0].childNodes[idx1].childNodes[idx2].childNodes[idx3], value); break;
        case 5: setNodeText(objDoc.childNodes[idx0].childNodes[idx1].childNodes[idx2].childNodes[idx3].childNodes[idx4], value); break;
        case 6: setNodeText(objDoc.childNodes[idx0].childNodes[idx1].childNodes[idx2].childNodes[idx3].childNodes[idx4].childNodes[idx5], value); break;
        case 7: setNodeText(objDoc.childNodes[idx0].childNodes[idx1].childNodes[idx2].childNodes[idx3].childNodes[idx4].childNodes[idx5].childNodes[idx6], value); break;
        case 8: setNodeText(objDoc.childNodes[idx0].childNodes[idx1].childNodes[idx2].childNodes[idx3].childNodes[idx4].childNodes[idx5].childNodes[idx6].childNodes[idx7], value); break;
        case 9: setNodeText(objDoc.childNodes[idx0].childNodes[idx1].childNodes[idx2].childNodes[idx3].childNodes[idx4].childNodes[idx5].childNodes[idx6].childNodes[idx7].childNodes[idx8], value); break;
        case 10: setNodeText(objDoc.childNodes[idx0].childNodes[idx1].childNodes[idx2].childNodes[idx3].childNodes[idx4].childNodes[idx5].childNodes[idx6].childNodes[idx7].childNodes[idx8].childNodes[idx9], value); break;
    }
    return true;
}
function GetNodeLevel(node, arrNode, paraIdx) {
    objNode = node.firstChild;
    var idx = 0;
    var nodeIdx = 0;
    while (objNode) {
        if (objNode.nodeType == 1) {
            if (idx == paraIdx) {
                arrNode.push(nodeIdx);
                return objNode;
                break;
            } else {
                idx++;
            }
        }
        objNode = objNode.nextSibling;
        nodeIdx++;
    }
    return objNode;
}

function GetAttribute(node, name) {
    var result = "";

    if (node != null && name != null) {
        if (node.getAttribute(name) == null || node.getAttribute(name) == "undefined") {
            return null;
        }
        else {
            result = node.getAttribute(name);
            return String(result);
        }
    }
    else {
        return result;
    }
}

function SetAttribute(node, name, value) {

    if (node != null) node.setAttribute(name, value);
}

function getXmlString(xmlDoc) {

    if (xmlDoc.nodeType == 9) {
        xmlDoc = xmlDoc.documentElement;
    }
    var resultXML = "";
    if (xmlDoc.__proto__ && window.XMLSerializer) {
        xmlDoc.__proto__.__defineGetter__("xml", function () { return (new XMLSerializer()).serializeToString(xmlDoc); });
    }

    if (xmlDoc.nodeType == 9) {
        resultXML = trim_Cross(getFirstChild(xmlDoc).xml);
    }
    else if (xmlDoc.nodeType == 1) {
        if (typeof (xmlDoc.xml) != "undefined")
            resultXML = trim_Cross(xmlDoc.xml);
        else
            resultXML = trim_Cross((new XMLSerializer()).serializeToString(xmlDoc));
    }
    else {
        resultXML = trim_Cross(xmlDoc.xml);
    }
    return resultXML;
}

function GetSerializeXml(oNode) {
    var oSerializer = new XMLSerializer();
    return oSerializer.serializeToString(oNode);
}

function getFirstChild(node) {
    var child1 = node.firstChild;
    while (child1.nodeType != 1) {
        child1 = child1.nextSibling;
    }

    return child1;
}
function getLastChild(node) {
    var lchild = node.lastChild;
    while (lchild.nodeType != 1) {
        lchild = lchild.previousSibling;
    }
    return lchild;
}
function getNodeText(node) {
    var result = "";
    if (node != null) {
        if (BroswerAndNonActiveXCheck() == "CROSS") {
            if (typeof (node.textContent) != "undefined") {
                result = trim_Cross(node.textContent);
            }
            else {
                result = trim_Cross(node.text);
            }
        }
        else {
            if (typeof (node.innerText) == "undefined") {
                result = trim_Cross(node.text);
            }
            else {
                result = trim_Cross(node.innerText);
            }

        }
    }
    return result;
}

function setNodeText(node, value) {
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        node.textContent = value;
    }
    else {
        if (typeof (node.innerText) == "undefined") {
            node.text = value;
        }
        else {
            node.innerText = value;
        }
    }
}

function getFieldText(node) {
    var result = "";
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        result = trim_Cross(node.textContent);
    }
    else {
        result = trim_Cross(node.innerText);
    }    
    return result;
}

function setFieldText(node, value) {
    var result = "";   
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        node.textContent = value;
    }
    else {
        node.innerText = value;
    }    
}

String.prototype.trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

function trim_Cross(value) {
    value = String(value);
    value = value.trim();
    if (value == null || value == "undefined" || value == "" || value == "\n") {
        return "";
    }
    return value.trim();
}
function getXmlFromHttp(req) {    
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        return (new DOMParser()).parseFromString(req.responseText, "text/xml");
    }
    else {
        return req.responseXML;
    }    
}

function createXMLDomFromXmlString(pXML) {
    var xmlDoc;
    if (BroswerAndNonActiveXCheck() == "CROSS") {
        var parser = new DOMParser();
        xmlDoc = parser.parseFromString(pXML, "text/xml");
        parser = null;
        return xmlDoc;
    }
    else {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.loadXML(pXML);
        return xmlDoc;
    }    
}

function CrossYN() {
    var ua = navigator.userAgent;
    var result = true;

    // 크로스 브라우저 IE:false IE외: true    
    if (/msie/i.test(ua)){
        result = false;
    }else if (/firefox/i.test(ua)){
        result = true;
    }else if (/chrome/i.test(ua)){
        result = true;
    }else if (/safari/i.test(ua)){
        result = true;
    }else if (/opera/i.test(ua)){
        result = true;
    }else if (/trident/i.test(ua)){
        result = true;
    }
    
    return result;

    /*
    var result = true;
    if (navigator.appName.indexOf("Microsoft") > -1) {
        result = false;
    } else {
        if (navigator.userAgent.indexOf("Trident") > 0)
            result = false;
        else
            result = true;
    }
    return result;
    */
}

function ConvertMHTtoHTML(pURL) {
    var rtnVal = '';
    
    $.ajax({
        type : "POST",
        dataType : "text",
        async : false,
        url : "/ezCommon/mhtToHTML.do",
        data : { strURL   : pURL },        
        success: function(result){
            rtnVal = result;
        }                   
    });
    return rtnVal;    
}

function ConvertHTMLtoMHT(pContent) {
    var rtnVal = '';
    $.ajax({
        type : "POST",
        dataType : "text",
        async : false,
        url : "/ezCommon/htmlToMHT.do",
        data : { strHTML   : encodeURIComponent(pContent) },        
        success: function(result){
            rtnVal = result;
        }                   
    });
    
    return rtnVal;    
}

function CKediter_Trim(value) {
    var temp = trim_Cross(value);
    temp = temp.replace(/\n/g, "");     
    temp = temp.replace(/\r/g, "");     
    return temp;
}

function GetFieldsList(iframePage) {
    var FieldsList = new Array();
    var FieldCount = 0;
    var count = 0;
    var i = 0;
    count = iframePage.contentWindow.document.getElementsByTagName("*").length;
    for (i = 0; i < count; i++) {
        if (iframePage.contentWindow.document.getElementsByTagName("*")[i].className == "FIELD") {
            FieldsList[FieldCount] = iframePage.contentWindow.document.getElementsByTagName("*")[i];
            FieldCount++;
        }
    }
    return FieldsList;
}

function GetBODY(iframePage) {
    var count = 0;
    var BODYTag;
    var i = 0;
    count = iframePage.contentWindow.document.getElementsByTagName("*").length;
    for (i = 0; i < count; i++) {
        if (iframePage.contentWindow.document.getElementsByTagName("*")[i].tagName == 'BODY') {
            BODYTag = iframePage.contentWindow.document.getElementsByTagName("*")[i];
        }
    }
    return BODYTag;
}

function GetListItem(pList, str) {
    for (i = 0; i < pList.length; i++) {
        if (pList[i].id == str)
            return pList[i];
    }
}

function GetNamedItem(iframePage, id, index) {
    var rtnVal = null;
    var tmp = null;

    if (index) {
        tmp = iframePage.contentWindow.document.getElementById(id)[index];
        if (tmp && tmp.className.toUpperCase() == "FIELD") {
            if (!tmp.FieldID)
                tmp.FieldID = tmp.id;
            rtnVal = tmp;
        }
    }
    else {
        tmp = iframePage.contentWindow.document.getElementById(id);
        if (tmp && tmp.className.toUpperCase() == "FIELD") {
            if (!tmp.FieldID)
                tmp.FieldID = tmp.id;
            rtnVal = tmp;
        }
    }
    return rtnVal
}

function GetMhtContentHTML(pfilepath) {
    var Result = "";
    try {
        var fullPath = document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filepath=" + escape(pfilepath);
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/ezCommon/mhtToHTMLContent.do?href=" + fullPath, false);
        xmlhttp.send();
        Result = xmlhttp.responseText;
    } catch (e) {
        Result = e.description;
    }
    return Result;    
}

function setpause(numberMillis) {
    var now = new Date();
    var exitTime = now.getTime() + numberMillis;
    while (true) {
        now = new Date();
        if (now.getTime() > exitTime)
            return;
    }
}

function GetShowModalPosition(popUpW, popUpH) {
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;

    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;

    left = pleftpos / 2;
    top = heigth / 2;

    var feature = ";dialogLeft:" + left + "px;dialogTop:" + top + "px;";

    return feature
}

function GetOpenPosition(popUpW, popUpH) {
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;
    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;
    left = pleftpos / 2;
    top = heigth / 2;
    var feature = ",left=" + left + ",top=" + top;
    return feature
}

function GetbrowserLanguage() {
    var strReturn = "";
    var strLang = "";
    if (window.navigator.language == undefined) {
        strLang = window.navigator.browserLanguage;
    }
    else
        strLang = window.navigator.language;

    switch (strLang) {
        case "ko": strReturn = "949";
            break;
        case "ko-KR": strReturn = "949";
            break;
    }
    return strReturn;
}

function GetCKEditerHeader() {
    return "<HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type><META name=GENERATOR content=\"MSHTML 8.00.7601.17622\"></HEAD>";
}
function KeEventControl(obj) {
    useragt = navigator.userAgent.toUpperCase();
    if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) 
    {
        return;
    }
    obj.onkeydown = function () {
        if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
            return false;
        if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
                parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
                parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
                parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 || parseInt(window.event.keyCode) == 13 ||
                parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32 ||
                 parseInt(window.event.keyCode) == 191)
            return false;
    };
}

function ReplaceText(orgStr, findStr, replaceStr) {
    try {
        if (findStr == ".") {
            var a = 0;
            for (a = 0; a < 10; a++)
                orgStr = orgStr.replace(".", replaceStr);
            return orgStr;
        }
        else {
            var re = new RegExp(findStr, "gi");
            return (orgStr.replace(re, replaceStr));
        }
    } catch (e) {
        return orgStr
    }
}

function ReplaceAll(pStrContent, pStrOrg, pStrRep) {
    return pStrContent.split(pStrOrg).join(pStrRep);
}

function GetOpenWindowfeature(popUpW, popUpH, scrollFlag) {
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;
    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;
    left = pleftpos / 2;
    top = heigth / 2;

    if (scrollFlag == undefined || scrollFlag == "NO" || !scrollFlag)
        var feature = "height=" + popUpH + "px,width=" + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no";
    else
        var feature = "height=" + popUpH + "px,width=" + popUpW + "px,left=" + left + ",top=" + top + ",scrollbars=yes, status=no, toolbar=no, menubar=no,location=no, resizable=no";
    return feature
}

function GetOpenWindow(url, target, popUpW, popUpH, resizeFlag) {
    var resize;
    if (MACSAFARIYN())
        popUpH = popUpH + 50;

    var left = (screen.width / 2) - (popUpW / 2);
    var top = (screen.height / 2) - (popUpH / 2);

    if (resizeFlag == undefined || resizeFlag == "NO" || !resizeFlag)
        resize = "resizable=no";
    else
        resize = "resizable=yes";
    
    var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + "px ,top=" + top + "px, status = no, toolbar=no, menubar=no,location=no," + resize;
    var result = window.open(url, target, feature);
    result.focus();
    return result;
}

function DivPopUpPosition(popUpW, popUpH) {
    var ReturnValue = new Array();
    var heigth = document.documentElement.clientHeight;
    if (heigth == 0)
        heigth = document.body.clientHeight;

    var width = document.documentElement.clientWidth;
    if (width == 0)
        width = document.body.clientWidth;

    var left = 0;
    var top = 0;
    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;
    if (heigth < (popUpH + 50))
        ReturnValue[0] = (heigth / 2);
    else
        ReturnValue[0] = (heigth / 2) - 50;
    ReturnValue[1] = pleftpos / 2;
    return ReturnValue
}

function DivPopUpPosition_Layer(popUpW, popUpH) {
    var ReturnValue = new Array();
    var heigth = document.documentElement.clientHeight;
    if (heigth == 0)
        heigth = document.body.clientHeight;

    var width = document.documentElement.clientWidth;
    if (width == 0)
        width = document.body.clientWidth;
    var left = 0;
    var top = 0;
    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;
    ReturnValue[0] = (heigth / 2) - 50;
    ReturnValue[1] = pleftpos / 2;
    return ReturnValue
}

function DivPopUpShow(popUpW, popUpH, URL) {
    try {
        var Position = DivPopUpPosition(popUpW, popUpH);
        document.getElementById("iFrameLayer").src = URL;
        document.getElementById("iFramePanel").style.top = Position[0] + "px";
        document.getElementById("iFramePanel").style.left = Position[1] + "px";
        document.getElementById("iFramePanel").style.height = popUpH + "px";
        document.getElementById("iFrameLayer").style.width = popUpW + "px";
        document.getElementById("iFrameLayer").style.height = popUpH + "px";
        document.getElementById("mailPanel").style.display = "";
        document.getElementById("iFramePanel").style.display = "";
    } catch (e) {}
}

function DivPopUpHidden() {
    try {
        document.getElementById("mailPanel").style.display = "none";
        document.getElementById("iFramePanel").style.display = "none";
        document.getElementById("iFrameLayer").src = "/blank.htm";
    } catch (e) {}
}

function DivPopUpShow_sub(popUpW, popUpH, URL) {
    try {
        var Position = DivPopUpPosition(popUpW, popUpH);
        document.getElementById("iFrameLayer_sub").src = URL;
        document.getElementById("iFramePanel_sub").style.top = Position[0] + "px";
        document.getElementById("iFramePanel_sub").style.left = Position[1] + "px";
        document.getElementById("iFramePanel_sub").style.height = popUpH + "px";
        document.getElementById("iFrameLayer_sub").style.width = popUpW + "px";
        document.getElementById("iFrameLayer_sub").style.height = popUpH + "px";
        document.getElementById("mailPanel_sub").style.display = "";
        document.getElementById("iFramePanel_sub").style.display = "";
    } catch (e) { }
}

function DivPopUpHidden_sub() {
    try {
        document.getElementById("mailPanel_sub").style.display = "none";
        document.getElementById("iFramePanel_sub").style.display = "none";
        document.getElementById("iFrameLayer_sub").src = "/blank.htm";
    } catch (e) { }
}
function CalToDate(p_strCal) {
    return p_strCal.substr(0, 4) + p_strCal.substr(5, 2) + p_strCal.substr(8, 2);
}

function CalToDate2(p_strCal) {
    return p_strCal.substr(0, 4) + "-" + p_strCal.substr(4, 2) + "-" + p_strCal.substr(6, 2);
}

function SetSelectVal(p_strObjId, p_strVal) {
    var Options = document.getElementById(p_strObjId).options;
    var i;
    for (i = 0; i < Options.length; i++) {
        if (Options[i].value == p_strVal) { document.getElementById(p_strObjId).selectedIndex = i; Options[i].selected = true; break; }
    }
}

function SetSelectText(p_strObjId, p_strVal) {
    var Options = document.getElementById(p_strObjId).options;
    var i;
    for (i = 0; i < Options.length; i++) {
        if (Options[i].text == p_strVal) { document.getElementById(p_strObjId).selectedIndex = i; Options[i].selected = true; break; }
    }
}

function GetSelectVal(p_strObjId) {
    return document.getElementById(p_strObjId).options[document.getElementById(p_strObjId).selectedIndex].value;
}

function GetSelectid(p_strObjId) {
    return document.getElementById(p_strObjId).options[document.getElementById(p_strObjId).selectedIndex].id;
}

function GetSelectText(p_strObjId) {
    return document.getElementById(p_strObjId).options[document.getElementById(p_strObjId).selectedIndex].text;
}

function SetRadioVal(p_strObjId, p_strVal) {
    var RadioBtns = document.getElementById(p_strObjId);
    var i;
    for (i = 0; i < RadioBtns.length; i++) {
        if (RadioBtns[i].value == p_strVal) { RadioBtns[i].checked = true; break; }
    }
}

function SetRadioNull(p_strObjId) {
    var RadioBtns = document.getElementById(p_strObjId);
    var i;
    for (i = 0; i < RadioBtns.length; i++) {
        RadioBtns[i].checked = false;
    }
}

function GetRadioVal(p_strObjId) {
    var RadioBtns = document.getElementById(p_strObjId);
    var strReturn = "";
    var i;
    for (i = 0; i < RadioBtns.length; i++) {
        if (RadioBtns[i].checked) { strReturn = RadioBtns[i].value; break; }
    }
    return strReturn;
}

function GetRadioText(p_strObjId) {
    var RadioBtns = document.getElementById(p_strObjId);
    var strReturn = "";
    var i;
    for (i = 0; i < RadioBtns.length; i++) {
        if (RadioBtns[i].checked) { strReturn = RadioBtns[i].text; break; }
    }
    return strReturn;
}

function SetCheckVal(p_strObjId, p_strVal) {
    var chkBoxes = document.getElementById(p_strObjId);
    var strCheckVals = p_strVal.split(",");
    var i, j;
    for (i = 0; i < chkBoxes.length; i++) {
        for (j = 0; j < strCheckVals.length; j++) {
            if (chkBoxes[i].value == strCheckVals[j]) {
                chkBoxes[i].checked = true; break;
            }
        }
    }
}

function GetCheckVal(p_strObjId) {
    var chkBoxes = document.getElementById(p_strObjId);
    var strReturn = "";
    var i, j;
    for (i = 0; i < chkBoxes.length; i++) {
        if (chkBoxes[i].checked) {
            strReturn = strReturn + chkBoxes[i].value + ",";
        }
    }
    return (strReturn.length == 0) ? "" : strReturn.substr(0, strReturn.length - 1);
}

function GetCheckText(p_strObjId) {
    var chkBoxes = document.getElementById(p_strObjId);
    var strReturn = "";
    var i, j;
    for (i = 0; i < chkBoxes.length; i++) {
        if (chkBoxes[i].checked) {
            strReturn = strReturn + chkBoxes[i].text + ",";
        }
    }
    return (strReturn.length == 0) ? "" : strReturn.substr(0, strReturn.length - 1);
}

function CheckString(p_strCal, p_strAlert) {
    var isString = 1;
    if (p_strCal == parseInt(p_strCal)) {
        return isString;
    } else {
        isString = 0;
        alert(p_strAlert);
        return isString;
    }
}

function ConvertCharToEntityReference(szData) {
    if (typeof (szData) == "undefined" || szData == null || szData == "") return "";

    var tempStr = new String(szData);
    tempStr = ReplaceText(tempStr, "&", "&amp;");
    tempStr = ReplaceText(tempStr, "<", "&lt;");
    tempStr = ReplaceText(tempStr, ">", "&gt;");
    return tempStr;
}

function ConvertEntityReferenceToChar(szData) {
    if (typeof (szData) == "undefined" || szData == null || szData == "") return "";

    var tempStr = new String(szData);
    tempStr = ReplaceText(tempStr, "&gt;", ">");
    tempStr = ReplaceText(tempStr, "&lt;", "<");
    tempStr = ReplaceText(tempStr, "&amp;", "&");
    return tempStr;
}

function Replace2HTML(orgStr) {
    var tempStr = new String(orgStr);
    tempStr = ReplaceText(tempStr, "&", "&amp;");
    tempStr = ReplaceText(tempStr, String.fromCharCode(9), "&nbsp;&nbsp;&nbsp;&nbsp;");
    tempStr = ReplaceText(tempStr, "<", "&lt;");
    tempStr = ReplaceText(tempStr, ">", "&gt;");
    tempStr = ReplaceText(tempStr, String.fromCharCode(13), "<BR>");
    tempStr = ReplaceText(tempStr, " ", "&nbsp;");
    return tempStr;
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}

function Mark1000Sep(p_nMoney) {
    var strReturn = "";
    var nHeadCnt;
    var strAll = new String(p_nMoney);
    var strRight = (strAll.indexOf(".") >= 0 ? strAll.substr(strAll.indexOf("."), strAll.length) : "");
    var strMoney = (strAll.indexOf(".") >= 0 ? strAll.substr(0, strAll.indexOf(".")) : strAll);
    strMoney = strMoney.replace(/,/g, "");
    var nCommaCnt = Math.floor((strMoney.length - 1) / 3);
    nHeadCnt = strMoney.length - nCommaCnt * 3
    for (i = nCommaCnt; i >= 0; i--) {
        if (i == nCommaCnt) strReturn = strReturn + strMoney.substr(0, nHeadCnt);
        else strReturn = strReturn + "," + strMoney.substr(nHeadCnt + (nCommaCnt - i - 1) * 3, 3);
    }
    strReturn = strReturn + (strRight != "" ? strRight : "");
    return strReturn;
}

function Remove1000Sep(p_nMoney) {
    return p_nMoney.replace(/,/g, "");
}

function CheckTimeRevision(szTime) {
    if (parseInt(szTime) == 0) {
        szTime = "00";
    } else if (parseInt(szTime) > 0 && parseInt(szTime) < 10) {
        szTime = "0" + szTime;
    }

    return szTime;
}

function CheckStartDateOnly(p_objCal) {
    if (p_objCal == "" || p_objCal == null) p_objCal = idDatepicker;
    start = p_objCal.startFullYear + "-"
            + CheckTimeRevision((parseInt(p_objCal.startMonth) + 1)) + "-"
            + CheckTimeRevision(p_objCal.startDate);

    end = p_objCal.endFullYear + "-"
            + CheckTimeRevision((parseInt(p_objCal.endMonth) + 1)) + "-"
            + CheckTimeRevision(p_objCal.endDate);

    if (start < end)
        return false;
    else
        return true;
}

function CheckNull(toCheck) {
    var chkstr = toCheck + "";
    var is_Space = true;
    if ((chkstr == "") || (chkstr == null))
        return (true);

    for (j = 0 ; is_Space && (j < chkstr.length) ; j++) {
        if (chkstr.substring(j, j + 1) != " ") {
            is_Space = false;
        }
    }
    return (is_Space);
}

function CheckNumber(toCheck) {
    var chkstr = toCheck + "";
    toCheck = toCheck.replace(/,/g, "");
    var isNum = true;

    if (CheckNull(toCheck))
        return false;

    for (j = 0 ; isNum && (j < toCheck.length) ; j++) {
        if ((toCheck.substring(j, j + 1) < "0") || (toCheck.substring(j, j + 1) > "9")) {
            if (toCheck.substring(j, j + 1) == "-" || toCheck.substring(j, j + 1) == "+") {
                if (j != 0) {
                    isNum = false;
                }
            }
            else
                isNum = false;
        }
    }
    if (chkstr == "+" || chkstr == "-") isNum = false;
    return isNum;
}

function input_check() {
    var ICheck = document.all.tags("input");
    if (ICheck != null) {
        for (i = 0; i < ICheck.length; i++) {
            if ((ICheck[i].value == null) || (ICheck[i].value == ""))
                ICheck[i].value = "-";
        }
    }
    var TCheck = document.all.tags("TEXTAREA");
    if (TCheck != null) {
        for (j = 0; j < TCheck.length; j++) {
            if ((TCheck[j].value == null) || (TCheck[j].value == ""))
                TCheck[j].value = "-";
        }
    }
}


function fnCalStartDateSet(p_objCal, p_newVal) {
    p_objCal.startFullYear = parseInt(p_newVal.substr(0, 4), 10);
    p_objCal.startMonth = parseInt(p_newVal.substr(5, 2), 10) - 1;
    p_objCal.startDate = parseInt(p_newVal.substr(8, 2), 10);
    return;
}

function fnCalEndDateSet(p_objCal, p_newVal) {
    p_objCal.endFullYear = parseInt(p_newVal.substr(0, 4), 10);
    p_objCal.endMonth = parseInt(p_newVal.substr(5, 2), 10) - 1;
    p_objCal.endDate = parseInt(p_newVal.substr(8, 2), 10);
    return;
}

function CalDateSet(p_objCal, p_newVal1, p_newVal2) {
    p_objCal.startFullYear = parseInt(p_newVal1.substr(0, 4), 10);
    p_objCal.startMonth = parseInt(p_newVal1.substr(5, 2), 10) - 1;
    p_objCal.startDate = parseInt(p_newVal1.substr(8, 2), 10);

    if (p_newVal2 == "") return;
    p_objCal.endFullYear = parseInt(p_newVal2.substr(0, 4), 10);
    p_objCal.endMonth = parseInt(p_newVal2.substr(5, 2), 10) - 1;
    p_objCal.endDate = parseInt(p_newVal2.substr(8, 2), 10);
    return;
}


function CalDateSet1(p_objCal, p_newVal1, p_newVal2) {
    p_objCal.startFullYear = parseInt(p_newVal1.substr(0, 4), 10);
    p_objCal.startMonth = parseInt(p_newVal1.substr(4, 2), 10) - 1;
    p_objCal.startDate = parseInt(p_newVal1.substr(6, 2), 10);

    if (p_newVal2 == "") return;
    p_objCal.endFullYear = parseInt(p_newVal2.substr(0, 4), 10);
    p_objCal.endMonth = parseInt(p_newVal2.substr(4, 2), 10) - 1;
    p_objCal.endDate = parseInt(p_newVal2.substr(6, 2), 10);
    return;
}

function getToday() {
    var d = new Date();
    var strTime;
    strTime = d.getFullYear() + "" + (d.getMonth() + 1) + "" + d.getDate();
    return strTime;
}

function Button_Check(p_objRadio) {
    var strObj = document.getElementById(p_objRadio);
    var i = 0;
    for (i = 0; i < strObj.length; i++) {
        if (strObj[i].checked == true) {
            return i;
        }
    }
}

function C_Check(p_objRadio, p_check) {
    var i = 0;
    var strObj = document.getElementById(p_objRadio);
    for (i = 0; i < strObj.length; i++) {
        if (strObj[i].value == p_check) {
            strObj[i].checked = true;
        }
    }
}

function LenUnicode(pstrUnicode) {
    var intLenCnt = 0;
    var i;
    for (i = 0; i < pstrUnicode.length; i++)
        if (pstrUnicode.charCodeAt(i) < 128)
            intLenCnt += 1;
        else
            intLenCnt += 2;
    return intLenCnt
}


function trim(parm_str) {
    if (parm_str == "")
        return ""
    else
        return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
    str_temp = parm_str;

    while (str_temp.length != 0) {
        if (str_temp.substring(0, 1) == " ") {
            str_temp = str_temp.substring(1, str_temp.length);
        } else {
            return str_temp;
        }
    }
    return str_temp;
}

function rtrim(parm_str) {
    str_temp = parm_str;

    while (str_temp.length != 0) {
        int_last_blnk_pos = str_temp.lastIndexOf(" ");

        if ((str_temp.length - 1) == int_last_blnk_pos) {
            str_temp = str_temp.substring(0, str_temp.length - 1);
        } else {
            return str_temp;
        }
    }
    return str_temp;
}

function AddOption(objselect, objtext, objvalue) {
    var objOption = document.createElement("OPTION");
    objOption.text = objtext;
    objOption.value = objvalue;
    objselect.add(objOption);
}

function MakeXMLString(pOrgString) {
    if (pOrgString == "undefined" || pOrgString == undefined) {
        return "";
    }
    return ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"), "'", "&apos;"), "\"", "&quot;");
}

function CompareDate(sdate, edate) {
    if (edate - sdate < 0)
        return false;
    else
        return true;
}

function getHourInterval(time1, time2) {
    var date1 = toTimeObject(time1);
    var date2 = toTimeObject(time2);
    var hour = 1000 * 3600;          

    var returnval = parseFloat((date2 - date1) / hour);
    return returnval.toFixed(2);
}

function toTimeObject(time) { 
    var year = time.substr(0, 4);
    var month = time.substr(4, 2) - 1; 
    var day = time.substr(6, 2);
    var hour = time.substr(8, 2);
    var min = time.substr(10, 2);
    return new Date(year, month, day, hour, min);
}

function formatDate(d) {
    return new Date(d.substr(0, 4), Number(d.substr(4, 2)) - 1, Number(d.substr(6)));
}

function OnlyNum() {
    if ((event.keyCode < 48) || (event.keyCode > 57))
        event.returnValue = false;
}

function ChkNum(obj, msg) {
    if (obj.value == "") {
        alert(msg);
        obj.focus();
        return (1);
    }
    else {
        for (i = 0; i < obj.value.length; i++) {
            chr = obj.value.charAt(i);
            if (!(chr >= "0" && chr <= "9")) {
                alert(msg);
                obj.focus();
                return (1);
            }
        }
    }
}

function GetPlusDate(targetDate, PlusDayInt) {
    var newDate = new Date();
    var returnDate = targetDate.getTime() - (parseInt(PlusDayInt) * 24 * 60 * 60 * 1000);
    newDate.setTime(returnDate);
    return newDate;
}

function TimeToStr(targetDate) {
    var strTime;
    var strYear = targetDate.getFullYear();
    var strMonth = targetDate.getMonth() + 1
    var strDay = targetDate.getDate();
    if (strMonth < 10)
        strMonth = "0" + strMonth;
    if (strDay < 10)
        strDay = "0" + strDay;

    strTime = strYear + "-" + strMonth + "-" + strDay;
    return strTime;
}

function HTMLtoMHT_MakeTag(ContnetHTML) {
    var HTML = document.createElement("HTML");
    var HEAD = document.createElement("HEAD");
    var META = document.createElement("META");
    META.content = "text/html; charset=utf-8";
    META.httpEquiv = "Content-Type";
    HEAD.appendChild(META);

    var STYLE = document.createElement("STYLE");
    STYLE.type = "text/css";

    try {
        STYLE.innerHTML = "P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                        + "DIV { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }"
                        + "TD { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                        + "UL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                        + "OL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                        + "LI { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                        + "BODY { MARGIN-RIGHT: 10px; FONT-SIZE:10PT; LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic } "
                        + "TABLE TD { text-indent: 0px } "
                        + "BLOCKQUOTE { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}";
    } catch (e) {
        STYLE.styleSheet.cssText = "P { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                                 + "DIV { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; }"
                                 + "TD { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                                 + "UL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                                 + "OL { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                                 + "LI { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; } "
                                 + "BODY { MARGIN-RIGHT: 10px; FONT-SIZE:10PT; LINE-HEIGHT:1.3; FONT-FAMILY:Malgun Gothic } "
                                 + "TABLE TD { text-indent: 0px } "
                                 + "BLOCKQUOTE { MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px;}";
    }
    HEAD.appendChild(STYLE);
    HTML.appendChild(HEAD);
    var BODY = document.createElement("BODY");
    BODY.appendChild(ContnetHTML);
    HTML.appendChild(BODY);
    return HTML.outerHTML;
}

function MACSAFARIYN() {
    var result = true;
    if (navigator.userAgent.toUpperCase().indexOf("MACINTOSH") > -1) {
        if (navigator.userAgent.toUpperCase().indexOf("CHROME") > -1) {
            result = false;
        } else {
            result = true;
        }
    } else {
        result = false;
    }
    return result;
}

function CustomRandom() {
    var now = new Date();
    var seed = now.getMilliseconds();
    return Math.random(seed) + 1;
}

function S4() {
    return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
}

function GetGUID() {
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

function DelComment(pContent) {
    pContent = ReplaceAll(pContent, "<!--[if-->", "");
    pContent = ReplaceAll(pContent, "<!--![if-->", "");
    pContent = ReplaceAll(pContent, "&lt;!--[if--&gt;", "");
    pContent = ReplaceAll(pContent, "&lt;!--![if--&gt;", "");
    pContent = ReplaceAll(pContent, "<!--[endif]-->", "");
    pContent = ReplaceAll(pContent, "<!--![endif]-->", "");
    pContent = ReplaceAll(pContent, "&lt;!--[endif]--&gt;", "");
    pContent = ReplaceAll(pContent, "&lt;!--![endif]--&gt;", "");
    return pContent;
}