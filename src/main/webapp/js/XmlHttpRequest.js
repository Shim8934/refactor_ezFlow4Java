/* XMLHttpRequest객체를 생성합니다. */ 
function createXMLHttpRequest() {
    var oXmlRequest;
    try {
        //파폭,크롬,오페라,사파리등등
        oXmlRequest = new XMLHttpRequest();
    }
    catch (trymicrosoft) {
        try {
            oXmlRequest = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (failed) {
            oXmlRequest = false;
        }
    }

    return oXmlRequest;
}

//DOM 객체를 생성합니다.
function createXmlDom() {
    var xmlDoc;    
    if (CrossYN()) {
        xmlDoc = document.implementation.createDocument("", "", null);
    }
    else {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    }    
    return xmlDoc;
}

//XMLFile을 DOM 객채로 반환합니다.
//filename:파일 경로및 xml파일명을 인자값으로 받습니다.
function loadXMLFile(filename) {
    var xmlhttp;    
    if (CrossYN()) {
        xmlhttp = new XMLHttpRequest();
    }
    else {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }    
    xmlhttp.open("GET", filename, false);
    xmlhttp.send();
    return loadXMLString(xmlhttp.responseText);
}
//XMLString을 DOM 객채로 반환합니다.
function loadXMLString(xmlstring) {
    var xmlDoc;  
    if (CrossYN()) {
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
//노드를 생성합니다.
function createNode(node, tagName) {
    if (CrossYN()) {
        return node.createElement(tagName);
    }
    else {
        return node.createNode(1, tagName, "");        
    }    
}
//text를 추가합니다.
function InsertText(xmlDoc, node, value) {
    if (CrossYN()) {
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
//text 추가후 target에 노드를 추가합니다.
function appendChildText(targetNode, node, value) {
    if (CrossYN()) {
        var newText = document.createTextNode(value);
        node.appendChild(newText);
        targetNode.appendChild(node);
    }
    else {
        node.text = value == null ? "" : value;
        targetNode.appendChild(node);        
    }    
    return node;
}

function appendChildCDataText(targetNode, node, value, xmlDoc) {
    if (CrossYN()) {
/*        var newText = document.createTextNode(value);
        node.appendChild(newText);
        targetNode.appendChild(node);*/
        var CDATA = xmlDoc.createCDATASection(value);
        node.appendChild(CDATA);
        targetNode.appendChild(node);
    }
    else {
        var CDATA = xmlDoc.createCDATASection(value);
        node.appendChild(CDATA);
        targetNode.appendChild(node);
    }    
    return node;
}

//노드를 생성하고  rootNode를 추가합니다
function createNodeInsert(xmlparam, node, tagName) {

    node = createNode(xmlparam, tagName);
    xmlparam.appendChild(node);
    return node;
}

//노드를 생성하고 text를 추가합니다.
function createNodeAndInsertText(xmlparam, node, tagName, value) {

    node = createNode(xmlparam, tagName);
    InsertText(xmlparam, node, value);
    return node;
}

//노드를 생성하고 text를 추가합니다.
function createNodeAndInsertCDataText(xmlparam, node, tagName, value) {

    node = createNode(xmlparam, tagName);
    InsertCDataText(xmlparam, node, value);
    return node;
}

//text를 추가합니다.
function InsertCDataText(xmlDoc, node, value) {
    if (CrossYN()) {
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

//노드를 생성하고 targetNode에 추가합니다.
function createNodeAndAppandNode(xmlparam, targetNode, node, tagName) {
    node = createNode(xmlparam, tagName);
    targetNode.appendChild(node);
    return node;
}

//노드를 생성하고 text 추가 후 targetNode 추가합니다.
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

//태그명으로 노드객체의 Element를 가져옵니다.
function GetElementsByTagName(node, tagName) {
    return node.getElementsByTagName(tagName);    
}

function SelectNodesNew(xmlDoc, path) {
    var nodes;
    if (CrossYN()) {
        nodes = xml.evaluate(path, xmlDoc, null, XPathResult.ANY_TYPE, null);
    }
    else {
        nodes = xmlDoc.selectNodes(path);
    }    
    return nodes;    
}

//해당 노드의 패스를 가져옵니다. 
function SelectNodes(xmlDoc, elementPath) {

    var parentPath = "";
    var nodeName = "";
    var parentNode = null;
    //공백이거나 널인경우 반환
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
        //Document 인경우
        if (xmlDoc != null) {
	        if (xmlDoc.nodeType == 9) {
	            parentNode = SelectSingleNodeNew(xmlDoc, parentPath);
	        }
	        else {
	            parentNode = SelectSingleNodeNew(xmlDoc, parentPath);
	        }
        }
    }
    if (parentNode == null) return false;

    return GetElementsByTagName(parentNode, nodeName);
}

//해당 태그네임으로 노드를 가져옵니다.
function SelectSingleNode(node, tagName) {
    var objNode = null;
    if (CrossYN()) {
    	if(node != null) {
    		objNode = node.firstChild;
            while (objNode) {
                if (objNode.nodeType == 1 && objNode.tagName == tagName)
                    break;
                else
                    objNode = objNode.nextSibling;
            }
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

//기존과 동일하게 path로 가져올수 있습니다. "DOCLIST/TREEVIEW" 
//xmlDoc 이 Document 타입인 경우만 가능합니다. 
function SelectSingleNodeNew(xmlDoc, elementPath) {
    if (CrossYN()) {
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

//해당 태그네임으로 nodeValue를 가져옵니다.
function SelectSingleNodeValue(node, tagName) {
    var strValue = "";
    if (CrossYN()) {
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

//기존과 동일하게 path로 가져올수 있습니다. "DOCLIST/TREEVIEW"
//xmlDoc 이 Document 타입인 경우만 가능합니다.
function SelectSingleNodeValueNew(xmlDoc, elementPath) {
    var strValue = "";    
    if (CrossYN()) {
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
        if (elements != null) {
        	if (elements.firstChild != null) {
        		strValue = elements.firstChild.nodeValue;
        	}
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

//자식노드들을 가져옵니다.
function GetChildNodes(node) {
    var elements = new Array();
    var objNode = node.firstChild;

    var idx = 0;
    while (objNode) {
        if (objNode.nodeType == 1) {
            elements[idx++] = objNode;
        }
        objNode = objNode.nextSibling;
    }
    return elements;
}
    //자식노드들을 가져옵니다.
    //자식 노드중 특정 노드명의 자식만 가져옵니다.
function GetChildNodesByNodeName(node, nodeName) {
    var elements = new Array();
    if (CrossYN()) {
        var parentNode = SelectSingleNodeNew(node, "//" + nodeName).parentNode;
        elements = GetElementsByTagName(parentNode, nodeName);
    }
    else {
        return node.getElementsByTagName(nodeName);
    }    
    return elements;
}

//맨 마지막 아이템의 ChildNodes를 가져옵니다.
//node: Element,params: array==>순차적으로 인덱스값을 이용하여 childNodes를 가져옵니다. 
function GetLastChildNodes(node, params) {
    var resultNodes = GetChildNodes(node);
    if (params == null || params.length == 0) return resultNodes;
    //params의 배열값을 순차적으로 돌아가며 최종 childNodes의 결과값을 가져옵니다. 
    for (var i = 0; i < params.length; i++) {
        var idx = parseInt(params[i], 10);
        resultNodes = GetChildNodes(resultNodes[idx]);
    }
    return resultNodes;
}

function SetChildNodeText(objDoc, params, inputIdx, value) {
    //배열의 끝에 할당하고자 하는 인자값을 추가합니다.
    params.push(inputIdx);

    var arrNode = new Array();
    if (params == null || params.length == 0) return;

    var resultNode = objDoc;
    //params의 배열값을 순차적으로 돌아가며 최종 childNodes의 결과값을 가져옵니다. 
    for (var i = 0; i < params.length; i++) {
        var idx = parseInt(params[i], 10);
        resultNode = GetNodeLevel(resultNode, arrNode, idx);
    }
    //재사용을 위하여 추가된 마지막 파라메터의 인자를 삭제한다.
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
    //자식노드들을 가져옵니다.
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

//속성요소를 가져옵니다
function GetAttribute(node, name) {
    var result = "";
    if (node != null && name != null && node.getAttribute(name) != null) {
        result = node.getAttribute(name);
    }

    return String(result);
}

//노드에 속성을 추가하거나 변경합니다. 
function SetAttribute(node, name, value) {

    if (node != null) node.setAttribute(name, value);
}

//노드 속성을 제거합니다.
function RemoveAttribute(node, name) {
    if (node) {
        node.removeAttribute(name);
    }
}

 //documentElement에서 xmlString을 가져옵니다.
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

    /******************************************************************************
    * 현재 노드에 포함되어 있는 모든 XML 직렬화(IE에서 xml속성). 
    * IE가 아닌 타 브라우서에서 사용.
    *****************************************************************************/
function GetSerializeXml(oNode) {
    var oSerializer = new XMLSerializer();
    return oSerializer.serializeToString(oNode);
}

//첫번째 노드를 가져옵니다.
function getFirstChild(node) {
    var child1 = node.firstChild;
    while (child1.nodeType != 1) {
        child1 = child1.nextSibling;
    }

    return child1;
}
    //Cross 마지막 노드를 가져옵니다.
function getLastChild(node) {
    var lchild = node.lastChild;
    while (lchild.nodeType != 1) {
        lchild = lchild.previousSibling;
    }
    return lchild;
}
    //노드를 텍스트를 가져옵니다.
function getNodeText(node) {
    var result = "";
    if (node != null) {
        if (CrossYN()) {
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
    if (CrossYN()) {
    	if (typeof (node.textContent) != "undefined") {
    		node.textContent = value;
    	} else {
    		node.text = value;
    	}
    } else {
        if (typeof (node.innerText) == "undefined") {
            node.text = value;
        } else {
            node.innerText = value;
        }
    }
}

String.prototype.trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

function trim_Cross(value) {
    value = String(value);
    value = value.trim();
    if (value == null || value == "undefind" || value == "" || value == "\n") {
        return "";
    }
    return value.trim();
}
//사용하지 않음 기존분서 호환성을 위해 남겨둠
/////////////////////////////////////////////////////////////////////////////
function getXmlFromHttp(req) {
    if (CrossYN()) {
        return (new DOMParser()).parseFromString(req.responseText, "text/xml");
    }
    else {
        return req.responseXML;
    }    
}

function createXMLDomFromXmlString(pXML) {
    var xmlDoc;
    if (CrossYN()) {
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
////////////////////////////////////////////////////////////////////////
// CrossBrowser적용
function CrossYN() {
	var ua = navigator.userAgent;
	var result = true;

    // 크로스 브라우저 IE9이하:false IE외: true
    if (/msie 10/i.test(ua)){
        result = true;	
    }else if (/msie/i.test(ua)){
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
}

///////////////////////////////////////////////////////////////////////
// CK Editer 관련 함수 ////////////////////////////////////////////////
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
    /* 2024-05-08 양지혜 - 공개문서에서 파라미터 조작으로 접근 취약점 보완. 권한 없을 시 권한없음 페이지 노출 */
    if (rtnVal == "NoAccess") {
        window.parent.location.replace('/ezApprovalG/accessWarning.do');
    } else {
        return rtnVal;
    }
}

function ConvertHTMLtoMHT(pContent) {
//	var rtnVal = '';
//    $.ajax({
//		type : "POST",
//		dataType : "text",
//		async : false,
//		url : "/ezCommon/htmlToMHT.do",
//		data : { strHTML   : encodeURIComponent(pContent)},
//		success: function(result){
//			rtnVal = result;
//		}        			
//	});
//    
    return ConvertHTMLtoMHT(pContent, "");
}

function ConvertHTMLtoMHT(pContent, pType) {
	var rtnVal = '';
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezCommon/htmlToMHT.do",
		data : { strHTML   : encodeURIComponent(pContent), type	: pType },
		success: function(result){
			rtnVal = result;
		},
		error: function(request, status, error){
			throw new Error("code : " + request.status + ", message : " + request.responseText + ", error : " + error);
		}
	});
    
    return rtnVal;
}

//에디터 Read 프레임 관련 사용함수
function CKediter_Trim(value) {
    var temp = trim_Cross(value);
    temp = temp.replace(/\n/g, "");     // 행바꿈제거
    temp = temp.replace(/\r/g, "");      // 엔터제거 
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
    
    var doc = iframePage.contentWindow.document;
    count = doc.getElementsByTagName("*").length;
    
    for (i = 0; i < count; i++) {
        if (doc.getElementsByTagName("*")[i].tagName == 'BODY') {
            BODYTag = doc.getElementsByTagName("*")[i];
        }
    }
    
    var styleTags = doc.getElementsByTagName("style");
    // 뒤에서부터 제거
    for (i = styleTags.length - 1; i >= 0; i--) {
        styleTags[i].parentNode.removeChild(styleTags[i]);
    }
    
    return BODYTag;
}

//CKEDITOR
function GetListItem(pList, str) {
	var index = -1;
    for (i = 0; i < pList.length; i++) {
        if (pList[i].id.toUpperCase() == str.toUpperCase()) {
        	index = i;
        	break;
        }
    }
    return pList[index];
}

// 웹에디터의 필드 값을 리턴
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
    //2011.07.28 FireFox는 ShowModalDialog() 호출시 화면 중앙에 뜨지 않아 top, left를 지정해 줘야한다.
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
    //2011.07.28 FireFox는 ShowModalDialog() 호출시 화면 중앙에 뜨지 않아 top, left를 지정해 줘야한다.
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var pTop = (heigth - popUpH) / 2;
    var pLeft = (width - popUpW) / 2;

   	var dualScreenTop = window.screenY;
    var dualScreenLeft = window.screenX;
    	
   	pTop += dualScreenTop;
   	pLeft += dualScreenLeft;
   				
	if (/MSIE|Trident/.test(window.navigator.userAgent)) {
   		if (window.screenLeft > window.screen.width) {
   			pTop -= 223;
   			pLeft -= 375;
   		}
   	}

    var feature = ",left=" + pLeft + ",top=" + pTop;

    return feature
}

//브라우져를 통한 로컬 언어 값 가져오는 함수
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
    //return "<HEAD><META content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\"><STYLE title=\"ezform_style_1\">P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} </STYLE></HEAD>";
    return "<HEAD><META content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\"><STYLE title=\"ezform_style_1\">P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:normal;font-size:10pt;} DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;} </STYLE></HEAD>";
}
    // 사파리 버그 수정용 함수 2012.09.07
function KeEventControl(obj) {
    useragt = navigator.userAgent.toUpperCase();
    if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
    {
        return;
        //useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
        //if (parseInt(useragt) > 5) {
        //}
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

function GetOpenWindowJun(popUpW, popUpH) {
    var xPos = (document.body.clientWidth / 2) - (popUpW / 2); 
    xPos += window.screenLeft;  //듀얼 모니터일때....
    var yPos = (screen.availHeight - popUpH) / 2;

    var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + xPos + ",top=" + yPos + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
    return feature;
}

function GetOpenWindowfeature(popUpW, popUpH, resizable) {

	var resiableAttr = !!resizable ? ',resizable=yes' : ',resizable=no';
	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	// var left = 0;
	// var top = 0;
	var pleftpos;
	pleftpos = parseInt(width) - popUpW;
	heigth = parseInt(heigth) - popUpH;
	width = parseInt(width) - pleftpos;
	// left = pleftpos / 2;
	// top = heigth / 2;
    var left = window.outerWidth / 2 + window.screenX - (popUpW / 2);
    var top = window.outerHeight / 2 + window.screenY - (popUpH / 2);
	var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, scrollbars=yes" + resiableAttr;
	return feature;
}
function GetOpenWindow(url, target, popUpW, popUpH, resizeFlag) {
    var resize;
    if (MACSAFARIYN())
        popUpH = popUpH + 50;

    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var pTop = (heigth - popUpH) / 2;
    var pLeft = (width - popUpW) / 2;

    var left = window.outerWidth / 2 + window.screenX - (popUpW / 2);
    var top = window.outerHeight / 2 + window.screenY - (popUpH / 2);

    if (resizeFlag == undefined || resizeFlag.toUpperCase() == "NO")
        resize = "resizable=no";
    else
        resize = "resizable=yes";
    
    var feature = "height=" + popUpH + ",width=" + popUpW + ",left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no," + resize;
    var result;
    if(url.includes("approve.do") || url.includes("view.do")){
        var param = new URLSearchParams(url.substring(url.indexOf("?")));
        target = target ? target : param.get("docID");
        var data = url.includes("approve.do") ? ["docID", "share", "isPreview", "allFlag"] : 
                    ["docID", "share", "isPreview", "listSusin", "docAttachParent", "admin", "listType", "pageType", "isOpinion", "callBackType"];
        result = window.open("", target, feature);
        const form = document.createElement("form");
        form.method = "post";
        form.action = url.substring(0,url.indexOf("?"));
        form.target = target;
        for(const key of data){
            if(param.get(key)){
                const hidden = document.createElement("input");
                hidden.type = "hidden";
                hidden.name = key;
                hidden.value = param.get(key);
                form.appendChild(hidden);
            }
        }
        document.body.appendChild(form);
        form.submit();
        document.body.removeChild(form);
    }else
        result = window.open(url, target, feature);
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

function DivPopUpShow(popUpW, popUpH, URL, flag) {
    try {
    	
    	if (navigator.maxTouchPoints > 4) {
    		
    		if (popUpW > document.documentElement.clientWidth) {
    			popUpW = document.documentElement.clientWidth;
    		}
    		
    		if (popUpH > document.documentElement.clientHeight) {
    			popUpH = document.documentElement.clientHeight;
    		}
    	} 
    	
        // 레이어팝업 전환 함수 showPopup 호출 시에만 layerpopup_top 클래스 부여
        if (isTeamsDesktop() && typeof flag == "boolean" && flag) {
            if (popUpW > document.documentElement.clientWidth) {
                popUpW = document.documentElement.clientWidth * 0.95;
            }
            if (popUpH > document.documentElement.clientHeight) {
                popUpH = document.documentElement.clientHeight * 0.95;
            }
            document.getElementById("iFramePanel").classList.remove("layerpopup");
            document.getElementById("iFramePanel").classList.add("layerpopup_top");
        }
        
        var Position = DivPopUpPosition(popUpW, popUpH);
        document.getElementById("iFrameLayer").src = URL;
        document.getElementById("iFramePanel").style.top = Position[0] + "px";
        document.getElementById("iFramePanel").style.left = Position[1] + "px";
        document.getElementById("iFramePanel").style.height = popUpH + "px";
        document.getElementById("iFrameLayer").style.width = popUpW + "px";
        document.getElementById("iFrameLayer").style.height = popUpH + "px";
        //2020-05-06 : right frame 리스트에서 divPopup 사용 시 left frame 영역도 적용
        try {
            if (typeof(window.parent.frames.left) == "object") {
                window.parent.frames.left.document.getElementById("mailPanel_left").style.display = "";
            }
        } catch(e) {}
        
        document.getElementById("mailPanel").style.display = "";
        document.getElementById("iFramePanel").style.display = "";
    } catch (e) {}

    return document.getElementById("iFrameLayer");
}

function DivPopUpHidden() {
    try {
        //2020-05-06 : right frame 리스트에서 divPopup 사용 시 left frame 영역도 적용
        try{
            if(typeof(window.parent.frames.left) == "object")
                window.parent.frames.left.document.getElementById("mailPanel_left").style.display = "none";
        }catch(e){}        
        document.getElementById("mailPanel").style.display = "none";
        document.getElementById("iFramePanel").style.display = "none";
        document.getElementById("iFrameLayer").src = "/blank.htm";
        
        if (isTeamsDesktop()) {
            document.getElementById("iFramePanel").classList.remove("layerpopup_top");
            document.getElementById("iFramePanel").classList.add("layerpopup");
            document.body.style.overflow = "";
        }
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

var hidingFrame = false;
var resizeTimer = null;
var clickDebounceTime = 500;
function hideLeftFrame(obj) {
    if (window.location.href.includes('admin')) return;
    var frame = parent.document.getElementById("left");
    if (!!frame) {
        hidingFrame = true;
        
        if (obj.classList.contains('on')) {
            frame.style.width = '220px';
            obj.classList.remove("on");
        } else {
            frame.style.width = '0';
            obj.classList.add("on");
        }
        
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            hidingFrame = false;
        }, clickDebounceTime);
    }
}

function hideLeftFrameOnResize() {
    if (window.location.href.includes('admin')) return;
    if (parent.document.querySelector("#left.fold") != null) {
        // hideLeftFrame 함수에 의해 left frame이 숨겨질 때에도
        // resize 콜백이 실행되어 수동으로 사용자가 버튼을 누른 경우에 대한
        // 플래그를 둠
        if (hidingFrame) return;
        var leftBtn = document.getElementsByClassName('left_btn')[0];
        var leftFrame = parent.document.getElementById("left");
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            if (top.outerWidth < 1180) {
                leftFrame.style.width = '0';
                leftBtn.classList.add("on");
            } else {
                leftFrame.style.width = '220px';
                leftBtn.classList.remove("on");
            }
        }, 150);
    }
}

function printPopUpHidden() {
    try {
        document.getElementById("mailPanel").style.display = "none";
        document.getElementById("iFramePanel").style.display = "none";
        document.getElementById("iFrameLayer").src = "/blank.htm";
        document.getElementById("iFramePanel").classList.remove("layerpopup_top");
        document.getElementById("iFramePanel").classList.add("layerpopup");
        document.body.style.overflow = "";
    } catch (e) {}
}

window.addEventListener("load", function () {
    try { void window.parent.document; } catch (e) { return; }
    if (parent.document.querySelector("#left.fold") != null) {
        var rightFrameDoc = window.parent.document.getElementById("right").contentDocument;

        var rightFirstChild = rightFrameDoc.body.firstElementChild;

        if (rightFirstChild) {
            if (rightFirstChild.classList.contains("left_btn")){
                return;
            }
        }

        var leftBtn = rightFrameDoc.createElement("span");

        leftBtn.className = "left_btn";

        leftBtn.addEventListener("click", function() {
            hideLeftFrame(this);
        });
        if (!window.location.href.includes('admin')) rightFrameDoc.body.insertBefore(leftBtn, rightFirstChild);
        rightFrameDoc.body.insertBefore(leftBtn, rightFirstChild);
    }

    window.addEventListener("resize", function() {
        if (window.name === "right") {
            hideLeftFrameOnResize();
        }
    });

});

function modalPopUp(popupId) {
    $(popupId).modal();

    $(popupId).css("visibility", "hidden");

    var popupX = window.innerWidth / 2 - $(popupId)[0].clientWidth / 2 - 20

    $(popupId).css("left", popupX);

    $(popupId).css("visibility", "");
}

// window.addEventListener("load", toggleHideLeftFrameButton);

// 2002-11-05 >> return 20021105
function CalToDate(p_strCal) {
    return p_strCal.substr(0, 4) + p_strCal.substr(5, 2) + p_strCal.substr(8, 2);
}

// 20021105 >> return 2002-11-05
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
	if (orgStr != undefined) {
		var re = new RegExp(findStr, "gi");
		return (orgStr.replace(re, replaceStr));
	} else {
		return orgStr;
	}
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
    var hour = 1000 * 3600;          //1시간이다.

    var returnval = parseFloat((date2 - date1) / hour);
    return returnval.toFixed(2);
}

function toTimeObject(time) { //YYYYMMDDHHMI 형태
    var year = time.substr(0, 4);
    var month = time.substr(4, 2) - 1; // 1월=0, 12월=11
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
    // 크로스 브라우저 IE:false IE외: true
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

/**
 * DatePicker에서 현재날짜 구할때 사용하면 좋다.
 * @param offset UserInfo에 있는 offset 사용
 * @returns yyyy-mm-dd 형식의 offset적용된 현재날짜
 */
function getDatePickerTime(offset, type) {
	var returnDate = "";
	var pOffset = offset.split("|")[1];
	var pOffsetHour = pOffset.split(":")[0];
	var pOffsetMinute = pOffset.split(":")[1];
	var tempDate = new Date();
	
	tempDate.setUTCHours(Number(tempDate.getUTCHours()) + Number(pOffsetHour), Number(tempDate.getUTCMinutes()) + Number(pOffsetMinute), tempDate.getUTCSeconds());
	
	var rYear = tempDate.getFullYear();
	var rMonth = addzero(tempDate.getMonth() + 1);
	var rDate = addzero(tempDate.getDate());
	var rHour = addzero(tempDate.getHours());
	var rMin = addzero(tempDate.getMinutes());
	var rSec = addzero(tempDate.getSeconds());
	
	if (type) {
		returnDate = rYear + "-" + rMonth + "-" + rDate + " " + rHour + ":" + rMin + ":" + rSec;
	} else {
		returnDate = rYear + "-" + rMonth + "-" + rDate;
	}
	
	return returnDate;
}

//UTC Time -> Real Time(Offset)
function GetLocalTime(Offset , pDateTime)
{
    if (pDateTime == "")
        return "";

    var pOffset = Offset.split("|")[1];
	var pOffsetHour = pOffset.split(":")[0];
	var pOffsetMinute = pOffset.split(":")[1];
	
	var szYear = pDateTime.substring(0,4);
	var szMonth = pDateTime.substring(5,7);
	var szDay = pDateTime.substring(8,10);
	var szHr = Number(pDateTime.substring(11,13)) + Number(pOffsetHour);
	var szMin = Number(pDateTime.substring(14,16)) + Number(pOffsetMinute);
	var szSec = pDateTime.substring(17,19)
	var ibjD = new Date();	
	
	ibjD.setFullYear(szYear ,szMonth-1 , szDay );
	ibjD.setHours(szHr ,szMin , szSec );
	
	var rYear = ibjD.getFullYear();
	var rMonth = addzero(ibjD.getMonth() + 1);
	var rDate = addzero(ibjD.getDate());
	var rHour = addzero(ibjD.getHours());
	var rMin = addzero(ibjD.getMinutes());
	var rSec = addzero(ibjD.getSeconds());	
	
	//javascript 31 보정
	/*if (szDay =="31" && (Number(pDateTime.substring(11,13)) + Number(pOffsetHour) < 24))
	{
		rMonth = addzero(Number(rMonth) -1) ;
		rDate = 31 ;		
	}
	*/

	return rYear + "-" + rMonth + "-" + rDate + " " + rHour + ":" + rMin + ":" + rSec;
}

function addzero(arg)
{
	if (arg < 10)
	{
		arg = "0" + arg;
	}
	return arg;

}

function isIE(){
	var ua = navigator.userAgent;
  	var isIE = false;

    if (/msie 10/i.test(ua)) {
        isIE = true;	
    } else if (/msie/i.test(ua)) {
		isIE = true;
	} else if (/trident/i.test(ua)) {
		isIE = true;
	}
    return isIE;
}

//board 페이징 중복 함수
function makePageSelPageBrd() {
	var strtext;
    var PagingHTML = "";
    document.getElementById("tblPageRayer").innerHTML = "";
    if (pAdminType != "y")
        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + pTotalCnt + " </span>";
    else
        parent.document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + pTotalCnt + " </span>";
    strtext = "<div class='pagenavi'>";
    PagingHTML += strtext;
    var pageNum = CurPage;
    if (totalPage > 1 && pageNum != 1) {
        strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
        PagingHTML += strtext;
    }
    else {
        strtext = "<span class='btnimg first disabled'></span>"
        PagingHTML += strtext;
    }
    if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
            strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg prev disabled'></span>";
            PagingHTML += strtext;
        }
    }
    else {
        strtext = "<span class='btnimg prev disabled'></span>";
        PagingHTML += strtext;
    }
    var MaxNum;
    var i;
    var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
    if (totalPage >= (startNum + parseInt(BlockSize))) {
        MaxNum = (startNum + parseInt(BlockSize)) - 1;
    }
    else {
        MaxNum = totalPage;
    }
    for (i = startNum; i <= MaxNum; i++) {
        if (i == pageNum) {
            strtext = "<span class='on'>" + i + "</span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
            PagingHTML += strtext;
        }
    }
    if (i == 1) {
    	strtext = "<span class='on'>" + i + "</span>";
        PagingHTML += strtext;
    }
    if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
            strtext = "";
            strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "";
            strtext = strtext + "<span class='btnimg next disabled'></span>";
            PagingHTML += strtext;
        }
    }
    else {
        strtext = "";
        strtext = strtext + "<span class='btnimg next disabled'></span>";
        PagingHTML += strtext;
    }
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
        PagingHTML += strtext;
    }
    else {
        strtext = "<span class='btnimg last disabled'></span>";
        PagingHTML += strtext;
    }
    
    PagingHTML += "</div>";
    td_Create1(PagingHTML);
}

function compareExtension(check, extension) {
    var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
    for (var i = 0; i < filterExtension.length; i++) {
        if (extension.toLowerCase() == filterExtension[i]) {
            check = true;
            break;
        }
    }
    
    return check;
}


//무적의 자바 인코더
function javaURLEncode(str) {
	  return encodeURIComponent(str)
	    .replace(/\+/g, "%2b")
	    .replace(/\;/g, "%3b")
	    .replace(/!/g, "%21")
	    .replace(/'/g, "%27")
	    .replace(/\(/g, "%28")
	    .replace(/\)/g, "%29")
	    .replace(/~/g, "%7E");
}

function BroswerAndNonActiveXCheck() {
    if (typeof(pNoneActiveX) == "undefined") {        
        if (window.ActiveXObject || "ActiveXObject" in window) {
            return "IE";
        } else if (window.DOMParser) {
            return "CROSS";
        }
    } else { 
        if (pNoneActiveX == "YES") {
            return "CROSS";
        } else {
            if (window.ActiveXObject || "ActiveXObject" in window) {
                return "IE";
            } else if (window.DOMParser) {
                return "CROSS";
            }
        }
    }    
}

// 특정 컬럼명 기준으로 xml 정렬하는 함수 (정렬할 xml, 정렬할 컬럼명, 예외처리(~가 아닌것), 정렬방법)
// 필수 파라미터 (xmlRows, colName)
function sortNode(xmlRows, colName, exception, orderby) {
	var least = '';
	var i = 0;
	var j = 0;
	
	if (exception == null) {
		exception = '';
	}
	
	if (orderby == '' || orderby == null) {
		orderby = 'ASC';
	}
	
	
	
	if (xmlRows != null && colName != null) {
		if (orderby == 'ASC') {
			for (i = 0; i < xmlRows.length - 1; i++) {
	     		least = i;
	    		
	    		for (j = i + 1; j < xmlRows.length; j++) {
	    			if (SelectSingleNodeValue(xmlRows[j], colName) < SelectSingleNodeValue(xmlRows[least], colName)) {
	    				least = j;
	    			}
	    		}
	    		
	    		if (i != least) {
	    			var temp = '';
	    			
	    			for (var t = 0; t < xmlRows[0].childNodes.length; t++) {
	    				temp = SelectSingleNodeValue(xmlRows[i], xmlRows[i].childNodes[t].nodeName);
	    				setNodeText(xmlRows[i].childNodes[t], SelectSingleNodeValue(xmlRows[least], xmlRows[i].childNodes[t].nodeName));
	    				setNodeText(xmlRows[least].childNodes[t], temp);
	    			}
	    			
	    		}
	    		
	    	}
	    	return xmlRows;
		} else {
			for (i = 0; i < xmlRows.length - 1; i++) {
	     		least = i;
	    		
	    		for (j = i + 1; j < xmlRows.length; j++) {
	    			if (SelectSingleNodeValue(xmlRows[j], colName) != exception && SelectSingleNodeValue(xmlRows[j], colName) > SelectSingleNodeValue(xmlRows[least], colName)) {
	    				least = j;
	    			}
	    		}
	    		
	    		if (i != least) {
	    			var temp = '';
	    			
	    			for (var t = 0; t < xmlRows[0].childNodes.length; t++) {
	    				temp = SelectSingleNodeValue(xmlRows[i], xmlRows[i].childNodes[t].nodeName);
	    				setNodeText(xmlRows[i].childNodes[t], SelectSingleNodeValue(xmlRows[least], xmlRows[i].childNodes[t].nodeName));
	    				setNodeText(xmlRows[least].childNodes[t], temp);
	    			}
	    			
	    		}
	    		
	    	}
	    	return xmlRows;
		}
		
	}	
}

//<c:out>를 통해 변환된 값을 원복시킨다 2019-04-05 임민석
function replaceEntityCodeToStr(str) {
	return str.replace(/&amp;/g, "&")
			  .replace(/&lt;/g, "<")
			  .replace(/&gt;/g, ">")
			  .replace(/&#039;/g, "\'")
			  .replace(/&#034;/g, "\"");
}

function ReplaceHTML(str) {
    str = ReplaceAll(str, "&#39;", "'");
    str = ReplaceAll(str, "&amp;", "&");
    str = ReplaceAll(str, "&lt;", "<");
    str = ReplaceAll(str, "&gt;", ">");
    str = ReplaceAll(str, "&apos;", "'");
    str = ReplaceAll(str, "&quot;", "\"");
    str = ReplaceAll(str, '&#40;', '(');
    str = ReplaceAll(str, '&#41;', ')');
    return str;
}

function ReplaceAll(pStrContent, pStrOrg, pStrRep) {
    return pStrContent.split(pStrOrg).join(pStrRep);
}


//리스트 로딩
function listLoading(pType){
    try{
        if(pType){
            if(document.getElementById("listload_div") == null){
                var divEle = document.createElement("DIV");
                divEle.setAttribute("class", "loadingBox2");
                divEle.setAttribute("id", "listload_div");

                var loadHtml = "<div class=\"loader loader-3\">";
                loadHtml += "<div class=\"dot dot1\"></div>";
                loadHtml += "<div class=\"dot dot2\"></div>";
                loadHtml += "<div class=\"dot dot3\"></div>";
                loadHtml += "<div class=\"dot dot4\"></div>";
                loadHtml += "</div>";

                divEle.innerHTML = loadHtml;

                if(document.getElementsByTagName("body").length > 0){
                    document.getElementsByTagName("body").item(0).appendChild(divEle);
                }
            }else{
                document.getElementById("listload_div").style.display = "";
            }
        }else{
            if(document.getElementById("listload_div") != null)
                document.getElementById("listload_div").style.display = "none";
        }
    }catch(e){}
}

function getControlList() {
	var controls = [];

	var controlListElem = document.getElementById("__reform_control_list");
	if (controlListElem) {
		var controlIdStr = controlListElem.getAttribute("value");
		if (controlIdStr) {
			controlIds = JSON.parse(controlIdStr);
            controls = controlIds.filter(function(id) {
                return document.getElementById(id) != null;
            }).map(function(id) {
                return document.getElementById(id);
            });
		}
	}

	return controls;
}

/* 2021-12-09 홍승비 - 파일 업로드 시 서버단에서 USE_FileExtension 확장자 체크하는 함수 추가 */
function checkUseFileExtension(pFileExt) {
	var res = "";
	
	$.ajax({
		type : "GET",
		async : false,
		data : {fileExt : pFileExt},
		url : "/ezCommon/checkUseFileExtension.do",
		success : function(result) {
			res = result;
		},
		error : function(){}
	});
	return res;
}

/* 2021-12-09 홍승비 - 이미지 업로드 시 서버단에서 확장자 체크하는 함수 추가 (USE_FileExtension 체크 포함) */
function checkImgExtension(pFileExt) {
	var res = "";
	
	$.ajax({
		type : "GET",
		async : false,
		data : {fileExt : pFileExt},
		url : "/ezCommon/checkImgExtension.do",
		success : function(result) {
			res = result;
		},
		error : function(){}
	});
	return res;
}

/* 2022-01-03 박성빈 채번 년도 기산일(회계년도)에 맞춰 가져오기 */
function getAccountingYear() {
    var res = "";

    $.ajax({
        type : "GET",
        async : false,
        url : "/ezApprovalG/getAccountingYear.do",
        success : function(result) {
            res = result;
        },
        error : function(e) {
        	console.log(e);
        }
    });
    return res;
}

function showLoadingProgress() {
	document.querySelector("#mailPanel").style.display = "";

    var loadingLayer = document.querySelector("#loadingLayer");

    loadingLayer.style.display = "";

    var llWidth = loadingLayer.clientWidth;
    var llHeight = loadingLayer.clientHeight;
    var winWidth = window.innerWidth;
    var winHeight = window.innerHeight;

    loadingLayer.style.left = ((winWidth / 2) - (llWidth / 2)) + "px";
    loadingLayer.style.top = ((winHeight / 2) - (llHeight / 2)) + "px";
}

function hideLoadingProgress() {
    document.querySelector("#loadingLayer").style.display = "none";
    document.querySelector("#mailPanel").style.display = "none";
}

// 2022-08-25 박기범 - 분석을 위해 서버 로그로 에러 메세지 전송
// frontLogging(로깅구분을 위한 제목, e, e.stack)
function frontLogging(title, msg, stack) {
    try {
        $.ajax({
            type : "POST",
            dataType : "text",
            url : "/ezcommon/logging",
            data : {
                logTitle : title,
                logMsg : msg,
                stack : stack
            },
            success: function(string){
                console.log("logging: " + string);
                console.log("msg: " + msg);
                console.log("stack: " + stack);
            }
        });
    } catch (e) {
        console.log("frontLogging 이 동작 안함");
    }
}






// pageTotalNum, pageStartNum, pageBlockSize, goToPageByNum, selbeforeBlock, selafterBlock 따로 설정
function mkPageSelPage() {
	var pageRayer = document.getElementById("tblPageRayer");

	var totalPage 		= parseInt(pageTotalNum);
	var pageNum 		= parseInt(pageStartNum);
	var BlockSize 		= parseInt(pageBlockSize);
	var MaxNum;
	var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	if (totalPage >= (startNum + parseInt(BlockSize))) {
		MaxNum = (startNum + parseInt(BlockSize)) - 1;
	} else {
		MaxNum = totalPage;
	}
	
    // 이미지
    const pprevImg_able = "/images/kr/cm/btn_p_prev.gif";
    const pprevImg_disable = "/images/kr/cm/btn_p_prev01.gif";
    const prevImg_able = "/images/kr/cm/btn_prev.gif";
    const prevImg_disable = "/images/kr/cm/btn_prev01.gif";
    const nnextImg_able = "/images/kr/cm/btn_n_next.gif";
    const nnextImg_disable = "/images/kr/cm/btn_n_next01.gif";
    const nextImg_able = "/images/kr/cm/btn_next.gif";
    const nextImg_disable = "/images/kr/cm/btn_next01.gif";
    
    // 사용 요소
    var imgSPAN = document.createElement("span");
    	imgSPAN.classList.add("btnimg");
    	
    var pprevEle = imgSPAN.cloneNode(true);
    if (totalPage > 1 && pageNum != 1) {
    	pprevEle.setAttribute("onClick", "goToPageByNum(1)");
    	pprevEle.classList.add("first");
    } else {
    	pprevEle.classList.add("first", "disabled");
    }
    	
    var prevEle = imgSPAN.cloneNode(true);
    if (totalPage > BlockSize && pageNum > BlockSize) {
    	prevEle.setAttribute("onClick", "selbeforeBlock()");
    	prevEle.classList.add("prev");
    } else {
    	prevEle.classList.add("prev", "disabled");
    }

    var nnextEle = imgSPAN.cloneNode(true);
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
    	nnextEle.setAttribute("onClick", "goToPageByNum("+totalPage+")");
    	nnextEle.classList.add("last");
    } else {
    	nnextEle.classList.add("last", "disabled");
    }

    var nextEle = imgSPAN.cloneNode(true);
    if (totalPage > BlockSize && totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
    	nextEle.setAttribute("onClick", "selafterBlock()");
    	nextEle.classList.add("next");
    } else {
    	nextEle.classList.add("next", "disabled");
    }
    
    // pagenavi
    var pagenaviDIV = document.createElement("div");
    	pagenaviDIV.classList.add("pagenavi");
    	
    	pagenaviDIV.appendChild(pprevEle);
    	pagenaviDIV.appendChild(prevEle);
    	if (MaxNum == 0) {
    	    var pageSPAN = document.createElement("span");
    		pageSPAN.classList.add("on");    		
    		pageSPAN.append(1);
    		
    		pagenaviDIV.appendChild(pageSPAN);
    	} else {
    		for (var i = startNum; i <= MaxNum; i++) {
        	    var pageSPAN = document.createElement("span");
        	    
    	        if (i == pageNum) {
    	    		pageSPAN.classList.add("on");    		
    	    		pageSPAN.append(i);
    	        } else {
    	    		pageSPAN.setAttribute("onClick", "goToPageByNum("+i+")");    		
    	    		pageSPAN.append(i);
    	        }
        		pagenaviDIV.appendChild(pageSPAN);
    	    }
    	}
    	pagenaviDIV.appendChild(nextEle);
    	pagenaviDIV.appendChild(nnextEle);
    
    // append
    pageRayer.innerHTML = "";
    pageRayer.appendChild(pagenaviDIV);
}

function escapeForJson(inputString) {
    return inputString.replace(/[\b\f\n\r\t\"\\]/g, function (char) {
        switch (char) {
            case '\b':
                return '\\b';
            case '\f':
                return '\\f';
            case '\n':
                return '\\n';
            case '\r':
                return '\\r';
            case '\t':
                return '\\t';
            default:
                return char;
        }
    });
}

function unescapeForJson(inputString) {
    return inputString.replace(/\\[bfnrt\"\\]/g, function (char) {
        switch (char) {
            case '\\b':
                return '\b';
            case '\\f':
                return '\f';
            case '\\n':
                return '\n';
            case '\\r':
                return '\r';
            case '\\t':
                return '\t';
            default:
                return char;
        }
    });
}

function getCookie(name) {
    const cookies = document.cookie.split('; ');
    
    for (const cookie of cookies) {
        const [cookieName, cookieValue] = cookie.split('=');
        if (cookieName === name) {
            return decodeURIComponent(cookieValue);
        }
    }
    
    return null;
}

var cssMap = new Map();
cssMap.set('1', '/css/ezPortal/skin_blue.css');
cssMap.set('2', '/css/ezPortal/skin_red.css');
cssMap.set('3', '/css/ezPortal/skin_dark.css');

function setColorMode() {
	
	if (window.location.href.split('?')[0].indexOf('/admin/') > 0) { // 관리자 페이지를 제외하기 위한 것이므로(commit a5e39f367ee) ? 이전 url만 파악한다. (파라메터에 admin이 있는 경우를 제외하기 위함)
		return;
	}

	var useColor = getCookie('useColor');
	if (!useColor) {
		return;
	}

	var link = document.createElement('link');
	link.rel = 'stylesheet';
	link.id = "skinCss";
	const cssMapValue = cssMap.get(useColor);
	if (cssMapValue) link.href = cssMapValue;

	document.head.appendChild(link);
}

document.addEventListener('DOMContentLoaded', function() {
    setColorMode();
    
    // 2025-01-08 조수빈 - 태블릿에서 조회 시 팝업이 잘리는 현상 임시 조치
    if (navigator.maxTouchPoints > 4 && document.body.classList.contains('popup')) {
        document.body.style.overflow = '';
    }
    
    var currentUrl = window.location.href;
    if ((currentUrl.includes("ezBoard") || currentUrl.includes("ezResource") || 
    currentUrl.includes("ezSurvey") || currentUrl.includes("ezMemo") || currentUrl.includes("ezTask") || 
    currentUrl.includes("ezPMS") || currentUrl.includes("ezAttitude"))  && document.getElementById("mainmenu")) {
        resizableMenu(currentUrl);
    }
});

// 2024-11-21 한태훈 > resize시 dim처리된 layer판넬 위에 표출 되는 알림창의 위치 가운데로 재설정
function adjustLayerAlertPosition(alertElemId) {
	var iframePanel = document.getElementById(alertElemId);
	if (!!iframePanel && iframePanel.style.display != "none") {
		var iframePanelHeight = iframePanel.offsetHeight;
		var iframePanelWidth = iframePanel.offsetWidth;
    	var alertPostion = DivPopUpPosition(iframePanelWidth, iframePanelHeight);
    	iframePanel.style.top = alertPostion[0] + "px";
    	iframePanel.style.left = alertPostion[1] + "px";
	}
}

// 기존의 window.open 메서드를 저장하여 재정의
const originWindowOpen = window.open;

window.open = function (url, target, features) {
    var urlObj;
    if (url.startsWith('/')) {
        urlObj = new URL(url, window.location.origin);
    } else if (!url.includes('://')) {
        var basePath = window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/'));
        urlObj = new URL(basePath + '/' + url, window.location.origin);
    } else {
        urlObj = new URL(url);
    }
    
    try {
        urlObj.searchParams.set('__wwidth', top.outerWidth);
    } catch (e) {console.log(e);}
    return originWindowOpen.call(window, urlObj.toString(), target, features);
};

// 2025-01-02 황인경 > 게시판, 자원관리, 일정관리, 업무일지, 근태관리, 전자설문, 투표, 회람판, 메모 resize에 따른 more 버튼 표출
function resizableMenu(url) {
    var mainmenu = document.getElementById("mainmenu");
    var buttonContainer = mainmenu.querySelector("ul");

    var existingMoreBtn = document.getElementById("moreBoardIcon");
    if (existingMoreBtn) {
        existingMoreBtn.remove();
    }

    var createMoreBtnLi = document.createElement("li");
    var createMoreBtnSpan = document.createElement("span");
    var createMoreBtnImg = document.createElement("img");
    var createMoreBtnUl = document.createElement("ul");
    
    createMoreBtnLi.id = "moreBoardIcon";
    createMoreBtnLi.classList = "view_more";
    createMoreBtnSpan.classList = "view_icon";
    createMoreBtnSpan.setAttribute("onclick", "this.parentNode.classList.toggle('on')");
    createMoreBtnImg.src = "/images/ImgIcon/view_more.png";
    createMoreBtnUl.classList = "layer_select";
    buttonContainer.style.overflow = "unset";
    
    if (url !== "undefined" && url !== null && url !== undefined && url.indexOf("ezAttitude") !== -1) {
        if (url.indexOf("attitudeUserAnnual.do") === -1 && url.indexOf("attitudeManage.do") === -1) { // ... 이 위로 붙는 페이지 css 변경
            createMoreBtnSpan.style.paddingTop = "13px";
        }
    }
    
    createMoreBtnSpan.appendChild(createMoreBtnImg);
    createMoreBtnLi.appendChild(createMoreBtnSpan);
    createMoreBtnLi.appendChild(createMoreBtnUl);
    buttonContainer.appendChild(createMoreBtnLi);
    
    var moreButton = createMoreBtnLi;
    var dropdownMenu = createMoreBtnUl;
    var buttons = [];
    var hiddenButtons = [];
    var timer = null;
    var btns = buttonContainer.querySelectorAll("li");
    
    for (var i = 0; i < btns.length; i++) {
        var btn = btns[i];
        if (!btn.classList.contains("view_more") && !btn.classList.contains("layer_select") && window.getComputedStyle(btn).display !== "none" && window.getComputedStyle(btn).float !== "right" && btn.children[0].tagName !== "SELECT") {
            buttons.push(btn);
        }
    }

    function resizeBtn() {
        var mainMenuWidth = buttonContainer.offsetWidth;
    
        var rightSectionWidth = 0;
        var rightDiv = document.querySelector("#right"); // 프레임 아이콘
        
        if (rightDiv) {
            rightSectionWidth += rightDiv.offsetWidth;
        }
    
        var floatRightButtons = document.querySelectorAll("li[style*='float: right']");
        floatRightButtons.forEach(function (li) {
            rightSectionWidth += li.offsetWidth;
        });
    
        var remainingWidth = mainMenuWidth - rightSectionWidth;
    
        var moreButtonWidth;
        var urlMapping = { // 관리자 페이지의 영역이 더 좁아 비율 상이
            "admin": 0.8,
            "ezBoard": 0.5
        };
        
        if (url !== "undefined" && url !== null && url !== undefined) {
            moreButtonWidth = remainingWidth * 0.6;
            if (url.indexOf("/admin/") !== -1) {
                moreButtonWidth = remainingWidth * 0.8;
            } else if (url.indexOf("ezBoard") !== -1) {
                moreButtonWidth = remainingWidth * 0.5;
            } else if (url.indexOf("ezResource") !== -1) {
                moreButtonWidth = remainingWidth * 0.7; 
            }
        } else {
            moreButtonWidth = remainingWidth * 0.6;
        }
        
        var mainMenuWidthCal = remainingWidth - moreButtonWidth;
        var totalWidth = 0;
    
        hiddenButtons = [];
        buttons.forEach(function (btn) {
            btn.style.display = "block";
        });
    
        buttons.forEach(function (button) {
            totalWidth += button.offsetWidth;
    
            if (totalWidth > mainMenuWidthCal) {
                hiddenButtons.push(button);
                button.style.display = "none";
            }
        });
    
        dropdownMenu.innerHTML = "";
    
        if (hiddenButtons.length > 0) {
            moreButton.style.display = "block"; 
    
            hiddenButtons.forEach(function (btn) {
                var clone = btn.cloneNode(true);
                clone.style.display = "";
                dropdownMenu.appendChild(clone);
            });
        } else {
            moreButton.style.display = "none";
        }
        
        if (url.includes("ezSurvey") && !url.includes("showParticipantsList.do")) {
            SurveyItem.btnResize();
        } 
        if (url.includes("/ezResource/scheduleApprovList.do")) {
            btnSet();
        }
    }

    window.addEventListener("resize", function () {
        clearTimeout(timer);
        timer = setTimeout(resizeBtn, 100); // 딜레이를 주지 않으면 버튼 내려감 
    });

    resizeBtn();
    
    var viewMore = null;

    function hideLayer(event) {
        if (viewMore && !event.target.closest('.view_more')) {
            viewMore.classList.remove('on');
        }
    }

    function setUpHideLayerEvent() {
        viewMore = document.getElementsByClassName('view_more')[0];

        window.parent.parent.parent.frames['topFrame'].contentWindow.document.getElementById('top')
                .addEventListener('click', hideLayer);
        
        window.parent.frames['left'].document.addEventListener('click', hideLayer);

        document.addEventListener('click', hideLayer);
    }
    setUpHideLayerEvent();
}

function decodeHtml(str) {
    // HTML 문자 엔티티 변환
    var entities = {
        "lt": "<",
        "gt": ">",
        "amp": "&",
        "quot": "\"",
        "apos": "'",
        "nbsp": " ",
        // 추가적인 HTML 엔티티가 필요하면 여기에 추가
    };

    // 문자 이름 엔티티를 변환
    str = str.replace(/&(\w+);/g, function(match, entity) {
        return entities[entity] || match;  // entities에서 변환이 가능하면 변환, 아니면 원본 그대로
    })
	.replace(/&#(\d+);/g, function(match, num) {
        return String.fromCharCode(num);
    })
	.replace(/&#x([0-9A-Fa-f]+);/g, function(match, num) {
        return String.fromCharCode(parseInt(num, 16));
    });

    return str;
}

/* 브라우저 기본 대화창 공통 변수, 함수 */
/** 다른 jsp에서 필요한 파라미터 전달용 배열 변수 (보통 [0]은 파라미터, [1]은 callback) */
var ezCommon_cross_dialogArguments = new Array();
/** callback에서 필요한 파라미터 배열 변수 (ezCommon_cross_dialogArguments[2]) */
var ezCommon_cross_dialogParams = new Array();
/** 새 창(window.open)객체를 저장하는 변수 */
var ezCommon_cross_openWin = null;

// 사용자 실행 환경이 Teams 데스크톱 앱인지 확인
function isTeamsDesktop(){
    if (/Teams\/|Electron\//i.test(navigator.userAgent)) {
        return true;
    } else {
        return false;
    }
}

/**
 * alert 보여주기
 * @param {string} msg - 메시지
 * @param {string|function} callback - 바깥 팝업도 함께 닫아줘야 하는 경우
 */
function showAlert(msg, callback) {
    if (isTeamsDesktop()) {
        // 결재환경설정 페이지에서 요청 시 부모(right)의 showAlert 함수 요청
        if (window.name === "mainFrame") {
            parent.showAlert(msg, callback);
            return;
        }

        if (hasIframeFunction("OpenAlertUI")) { // 레이어팝업 영역에 동일한 함수 있는지 확인
            document.getElementById("iFrameLayer").contentWindow["OpenAlertUI"](msg);
        } else if (hasIframeFunction("showAlertUI")) { // 레이어팝업 영역에 대체 함수 있는지 확인
            document.getElementById("iFrameLayer").contentWindow["showAlertUI"](msg, callback);
        } else if (typeof OpenAlertUI == "function"
            && typeof callback == "undefined"
        ) { // 기존에 사용 중인 OpenAlertUI 함수가 있는지 확인
            if (isIframeExists()) OpenAlertUI(msg);
        } else { // 없는 경우 현재 js에 있는 대체 함수 요청
            if (isIframeExists()) showAlertUI(msg, callback);
        }
        document.body.style.overflow = "hidden";
    } else {
        alert(msg);
        if (typeof callback == "function") {
            callback();
        }
    }
}

/**
 * alert 숨기기
 * @param {string|function} callback - 바깥 팝업도 함께 닫아줘야 하는 경우
 */
function hideAlert(callback) {
    DivPopUpHidden();
    ezCommon_cross_dialogArguments.length = 0;
    ezCommon_cross_dialogParams.length = 0;
    if (typeof callback == "string") {
        // parent.hidePopup(closeParent);
        btnClose_onclick(callback);
    } else if (typeof callback == "function") {
        callback();
    }
}

/**
 * alert 페이지 요청
 * @param {string} msg - 메시지
 * @param {string|function} callback - 바깥 팝업도 함께 닫아줘야 하는 경우
 */
function showAlertUI(msg, callback) {
    // 기존 alert 레이어팝업의 크기보다 부모 레이어팝업이 작은 경우 -20 처리
    var width = 340;
    var height = 200;
    if (width > document.documentElement.clientWidth) {
        width = document.documentElement.clientWidth - 20;
    }
    if (height > document.documentElement.clientHeight) {
        height = document.documentElement.clientHeight - 20;
    }
    
    ezCommon_cross_dialogArguments[0] = msg;
    ezCommon_cross_dialogArguments[1] = hideAlert;
    ezCommon_cross_dialogArguments[3] = callback;
    DivPopUpShow(width, height, "/ezApprovalG/ezAprAlert.do");
}

/**
 * confirm 보여주기
 * @param {string} msg - 메시지
 * @param {() => void} callback - confirm 이후 실행할 콜백 함수
 */
function showConfirm(msg, callback) {
    if (isTeamsDesktop()) {
        // 결재환경설정 페이지에서 요청 시 부모(right)의 showConfirm 함수 요청
        if (window.name === "mainFrame") {
            parent.showConfirm(msg, callback);
            return;
        }
        if (isIframeExists()) showConfirmUI(msg, callback);
        document.body.style.overflow = "hidden";
    } else {
        if (msg) {
            msg = msg.replaceAll("<br>","\n");
        }
        if (confirm(msg)) {
            callback(true);
        } else {
            callback(false);
        }
    }
}

// confirm 숨기기
function hideConfirm() {
    if (isTeamsDesktop()) {
    	if (window.name === "mainFrame") {
            parent.hideConfirm();
            return;
        }
        DivPopUpHidden();
        document.body.style.overflow = "";
    }
    ezCommon_cross_dialogArguments.length = 0;
    ezCommon_cross_dialogParams.length = 0;
}

/**
 * confirm 페이지 요청
 * @param {string} msg - 메시지
 * @param {() => void} callback - confirm 이후 실행할 콜백 함수
 */
function showConfirmUI(msg, callback) {
    ezCommon_cross_dialogArguments[0] = msg;
    ezCommon_cross_dialogArguments[1] = callback;
    ezCommon_cross_dialogArguments[2] = ezCommon_cross_dialogParams;
    DivPopUpShow(330, 205, "/ezCommon/ezConfirm.do");
}

/**
 * popup 보여주기
 * @param {string} url - 팝업으로 요청할 페이지 경로
 * @param {number} width - 팝업 창의 너비(px)
 * @param {number} height - 팝업 창의 높이(px)
 * @param {string} target - 팝업 창의 이름
 * @param {string} feature - 팝업의 상세 설정
 * @param {() => void} callback - 팝업이 사라지고 실행할 콜백 함수
 */
function showPopup(url, width, height, target, feature, callback) {
    if (isTeamsDesktop()) {
        if (window.name === "left") { // left에서 요청할 경우 right의 레이어팝업이 열리도록 함
            parent.right.ezCommon_cross_dialogArguments = ezCommon_cross_dialogArguments.slice(); // 현재 변수를 복사하여 덮어쓰기
            ezCommon_cross_dialogArguments.length = 0; // 현재 변수 비우기
            
            parent.document.getElementById("right").contentWindow.showPopup(url, width, height, target, feature, callback);
        } else if (window.name === "mainFrame") { // 결재환경설정 페이지(mainFrame)에서 요청할 경우 right의 레이어팝업이 열리도록 함
            parent.ezCommon_cross_dialogArguments = ezCommon_cross_dialogArguments.slice();
            ezCommon_cross_dialogArguments.length = 0;

            parent.showPopup(url, width, height, target, feature, callback);
        } else if (window.document.location.href.indexOf("ezAprHistory") > 0 
            && url.indexOf("showPersonInfo") < 0
        ) { // 결재문서이력 페이지에서 요청할 경우 main의 레이어팝업이 열리도록 함
            var mainIframe = parent.parent.parent; // Teams Desktop에서 main을 찾지 못해 박아줌
            mainIframe.ezCommon_cross_dialogArguments = ezCommon_cross_dialogArguments.slice();
            ezCommon_cross_dialogArguments.length = 0;

            mainIframe.showPopup(url, width, height, target, feature, callback);
        } else {
            ezCommon_cross_dialogArguments[1] = callback;
            
            document.documentElement.scrollTop = 0;
            document.body.style.overflow = "hidden";
            DivPopUpShow(width, height, url, true); // 클래스 부여를 위해 flag true
        }
    } else {
        ezCommon_cross_dialogArguments[1] = callback;
        
        ezCommon_cross_openWin = window.open(url, target, feature);
        try { ezCommon_cross_openWin.focus(); } catch (e) { }
    }
}

// popup 숨기기
function hidePopup() {
    if (isTeamsDesktop()) {
        if (window.name === "left") {
            parent.document.getElementById("right").contentWindow.hidePopup();
            return;
        } else if (window.name === "mainFrame") {
            parent.hidePopup();
            return;
        } else if (window.document.location.href.indexOf("ezAprHistory") > 0
            && isIframeExists()
            && window.document.getElementById("iFrameLayer").src.indexOf("showPersonInfo") < 0
        ) {
            var mainIframe = parent.parent.parent;

            mainIframe.hidePopup();
            return;
        } else {
            DivPopUpHidden();
        }
        document.body.style.overflow = ""; // 스크롤 허용
    }
    ezCommon_cross_dialogArguments.length = 0;
    ezCommon_cross_dialogParams.length = 0;
    
    if (ezCommon_cross_openWin != null) {
        ezCommon_cross_openWin.close();
        ezCommon_cross_openWin = null;
    }
}

// 부모창에서 파라미터 전달용 배열 변수가 사용되었는지 확인
function isParentCommonArgsUsed() {
    if (typeof parent.ezCommon_cross_dialogArguments != "undefined"
        && parent.ezCommon_cross_dialogArguments.length > 0
    ) {
        return true;
    } else if (opener != null
        && typeof opener.ezCommon_cross_dialogArguments != "undefined"
        && opener.ezCommon_cross_dialogArguments.length > 0
    ) {
        return true;
    } else {
        return false;
    }
}

// 자식 레이어팝업이 존재하고 동일한 함수가 존재하는지 확인
function hasIframeFunction(funcName) {
    var iframe = document.getElementById("iFrameLayer");
    
    if (iframe
        && iframe.contentWindow
        && iframe.contentWindow.document.getElementById("iFrameLayer")
        && typeof iframe.contentWindow[funcName] === "function"
    ) {
        return true;
    } else {
        return false;
    }
}

/**
 * popup 보여주기 (우측 슬라이드 ver.)
 * @param {string} url - 팝업으로 요청할 페이지 경로
 * @param {number} width - 팝업 창의 너비(px)
 * @param {number} height - 팝업 창의 높이(px)
 * @param {string} target - 팝업 창의 이름
 * @param {string} feature - 팝업의 상세 설정
 * @param {() => void} callback - 팝업이 사라지고 실행할 콜백 함수
 * @param {number|undefined} i
 */
function showPopupSlide(url, width, height, target, feature, callback, i) {
    if (isTeamsDesktop()) {
        if (window.name === "left") { // left에서 요청할 경우 right의 레이어팝업이 열리도록 함
            parent.right.ezCommon_cross_dialogArguments = ezCommon_cross_dialogArguments.slice(); // 현재 변수를 복사하여 덮어쓰기
            ezCommon_cross_dialogArguments.length = 0; // 현재 변수 비우기

            parent.document.getElementById("right").contentWindow.showPopupSlide(url, width, height, target, feature, callback, i);
            return;
        } else if (window.document.location.href.indexOf("aprDocAttach") > 0) {
            var mainIframe = parent.parent;
            mainIframe.ezCommon_cross_dialogArguments = ezCommon_cross_dialogArguments.slice();
            ezCommon_cross_dialogArguments.length = 0;
            
            mainIframe.showPopupSlide(url, width, height, target, feature, callback, 2);
        } else {
            ezCommon_cross_dialogArguments[1] = callback;
            document.documentElement.scrollTop = 0;
            document.body.style.overflow = "hidden";
            DivPopUpShowSlide(width, height, url, i);
        }
    } else {
        ezCommon_cross_dialogArguments[1] = callback;

        if(url.includes("approve.do") || url.includes("view.do")){
            var param = new URLSearchParams(url.substring(url.indexOf("?")));
            target = target ? target : param.get("docID");
            var data = url.includes("approve.do") ? ["docID", "share", "isPreview", "allFlag"] : 
                        ["docID", "share", "isPreview", "listSusin", "docAttachParent", "admin", "listType", "pageType", "isOpinion", "callBackType"];
            ezCommon_cross_openWin = window.open("", target, feature);
            const form = document.createElement("form");
            form.method = "post";
            form.action = url.substring(0,url.indexOf("?"));
            form.target = target;
            for(const key of data){
                if(param.get(key)){
                    const hidden = document.createElement("input");
                    hidden.type = "hidden";
                    hidden.name = key;
                    hidden.value = param.get(key);
                    form.appendChild(hidden);
                }
            }
            document.body.appendChild(form);
            form.submit();
            document.body.removeChild(form);
        }else
            ezCommon_cross_openWin = window.open(url, target, feature);
        try { ezCommon_cross_openWin.focus(); } catch (e) { }
    }
}

/**
 * popup 숨기기 (우측 슬라이드 ver.)
 * @param {number|undefined} i
 */
function hidePopupSlide(i) {
    if (isTeamsDesktop()) {
        if (window.name === "left") {
            parent.document.getElementById("right").contentWindow.hidePopupSlide(i);
            return;
        } else if (window.document.location.href.indexOf("aprDocAttach") > 0) {
            var mainIframe = parent.parent;
            
            mainIframe.DivPopUpHiddenSlide(2);
        } else {
            DivPopUpHiddenSlide(i);
        }
    }
    ezCommon_cross_dialogArguments.length = 0;
    ezCommon_cross_dialogParams.length = 0;

    if (ezCommon_cross_openWin != null) {
        ezCommon_cross_openWin.close();
        ezCommon_cross_openWin = null;
    }
}

/**
 * DivPopUpShow 함수 (우측 슬라이드 ver.)
 * @param {number|undefined} i
 */
function DivPopUpShowSlide(popUpW, popUpH, URL, i) {
    if (typeof i != "number") {
        try {
            document.getElementById("iFrameLayer").src = URL;
    
            document.getElementById("iFramePanel").classList.remove("layerpopup");
            document.getElementById("iFramePanel").classList.add("layerpopup_slider");
            document.getElementById("iFramePanel").classList.add("active");
    
            document.getElementById("iFramePanel").style.left = "";
            document.getElementById("iFrameLayer").style.width = "100%";
            document.getElementById("iFrameLayer").style.height = "100%";
            try {
                if (typeof(window.parent.frames.left) == "object") {
                    window.parent.frames.left.document.getElementById("mailPanel_left").style.display = "";
                }
            } catch(e) {}
    
            document.body.style.overflow = "hidden"; // 스크롤 막기
            document.getElementById("mailPanel").style.display = "";
            document.getElementById("iFramePanel").style.display = "";
        } catch (e) {}
    
        return document.getElementById("iFrameLayer");
    } else {
        try {
            document.getElementById("iFrameLayer" + i).src = URL;

            document.getElementById("iFramePanel" + i).classList.remove("layerpopup");
            document.getElementById("iFramePanel" + i).classList.add("layerpopup_slider");
            document.getElementById("iFramePanel" + i).classList.add("active");

            document.getElementById("iFramePanel" + i).style.left = "";
            document.getElementById("iFrameLayer" + i).style.width = "100%";
            document.getElementById("iFrameLayer" + i).style.height = "100%";
            document.getElementById("iFramePanel" + i).style.display = "";
        } catch (e) {}

        return document.getElementById("iFrameLayer" + i);
    }
}

/**
 * DivPopUpHidden 함수 (우측 슬라이드 ver.)
 * @param {number|undefined} i
 */
function DivPopUpHiddenSlide(i) {
    if (typeof i != "number") {
        try {
            document.getElementById("iFramePanel").classList.remove("active");
    
            setTimeout(function() {
                try {
                    if (typeof(window.parent.frames.left) == "object") {
                        window.parent.frames.left.document.getElementById("mailPanel_left").style.display = "none";
                    }
                } catch(e) {}
                document.getElementById("mailPanel").style.display = "none";
                document.getElementById("iFramePanel").style.display = "none";
                document.body.style.overflow = ""; // 스크롤 허용
                
                document.getElementById("iFrameLayer").src = "/blank.htm";
    
                document.getElementById("iFramePanel").classList.remove("layerpopup_slider");
                document.getElementById("iFramePanel").classList.add("layerpopup");
            }, 500);
        } catch (e) {}
    } else {
        try {
            document.getElementById("iFramePanel" + i).classList.remove("active");

            setTimeout(function() {
                document.getElementById("iFramePanel" + i).style.display = "none";

                document.getElementById("iFrameLayer" + i).src = "/blank.htm";

                document.getElementById("iFramePanel" + i).classList.remove("layerpopup_slider");
                document.getElementById("iFramePanel" + i).classList.add("layerpopup");
            }, 500);
        } catch (e) {}
    }
}

// jsp에서 alert, confirm을 mailPanel_sub, iFramePanel_sub로 사용하는 경우를 위해 분리
// alert 보여주기
function showAlert_sub(msg) {
    if (isTeamsDesktop()) {
        showAlertUI_sub(msg);
    } else {
        alert(msg);
    }
}

// alert 숨기기
function hideAlert_sub() {
    DivPopUpHidden_sub();
    ezCommon_cross_dialogArguments.length = 0;
    ezCommon_cross_dialogParams.length = 0;
}

// alert 페이지 요청
function showAlertUI_sub(msg) {
    // 기존 alert 레이어팝업의 크기보다 부모 레이어팝업이 작은 경우 -20 처리
    var width = 330;
    var height = 205;
    if (width > document.documentElement.clientWidth) {
        width = document.documentElement.clientWidth - 20;
    }
    if (height > document.documentElement.clientHeight) {
        height = document.documentElement.clientHeight - 20;
    }

    ezCommon_cross_dialogArguments[0] = msg;
    ezCommon_cross_dialogArguments[1] = hideAlert_sub;
    DivPopUpShow_sub(width, height, "/ezApprovalG/ezAprAlert.do");
}

// confirm 보여주기
function showConfirm_sub(msg, callback) {
    if (isTeamsDesktop()) {
        showConfirmUI_sub(msg, callback);
    } else {
        if (confirm(msg)) {
            callback(true);
        } else {
            callback(false);
        }
    }
}

// confirm 숨기기
function hideConfirm_sub() {
    if (isTeamsDesktop()) {
        DivPopUpHidden_sub();
    }
    ezCommon_cross_dialogArguments.length = 0;
    ezCommon_cross_dialogParams.length = 0;
}

// confirm 페이지 요청
function showConfirmUI_sub(msg, callback) {
    ezCommon_cross_dialogArguments[0] = msg;
    ezCommon_cross_dialogArguments[1] = callback;
    ezCommon_cross_dialogArguments[2] = ezCommon_cross_dialogParams;
    DivPopUpShow_sub(330, 205, "/ezCommon/ezConfirm.do");
}

/**
 * X버튼 온클릭 메소드
 * @param {string|undefined} rtn - 반환값
 */
function btnClose_onclick(rtn) {
    if (typeof ReturnFunction == "function") {
        if (typeof rtn != "undefined") {
            ReturnFunction(rtn);
        } else {
            ReturnFunction("cancel");
        }
    }
    if (typeof rtn == "string" && rtn != "") {
        window.returnValue = rtn;
    }
    window.close();
}

/**
 * X버튼 온클릭 메소드2 (btnClose_onclick 함수가 jsp에 이미 존재하며 대체할 수 없는 경우 사용)
 * @param {string|undefined} rtn - 반환값
 */
function btnClose_onclick2(rtn) {
    if (typeof ReturnFunction == "function") {
        if (typeof rtn != "undefined") {
            ReturnFunction(rtn);
        } else {
            ReturnFunction("cancel");
        }
    }
    if (typeof rtn == "undefined") {
        window.returnValue = rtn;
    }
    window.close();
}

// 레이어팝업 영역이 존재하는지 확인
function isIframeExists() {
    var iframe = document.getElementById("iFrameLayer");

    if (iframe) {
        return true;
    } else {
        console.log("There is no div #iFrameLayer in " + window.document.location.href);
        return false;
    }
}

function innerIfrmaeOffset() {
    if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
        window.addEventListener("message", function (event) {
            if (event.data && event.data.type == "width") {
                if (event.data.value >= 947) {
                    maxWidth = event.data.value;
                    var innerIframe = window.parent.document.querySelector("iframe#iFrameLayer");
                    var innerFrameWidth = event.data.value * 0.95; 
                    innerIframe.style.width = innerFrameWidth + "px";
                }
            }
        });
    }
}

// tag명, 클래스이름(다수일 경우 ' '로 구분), 속성을 입력하면 객체를 만들어 반환함
function createEl(tag, className, attrs = {}) {
    const el = document.createElement(tag);
    if (className) {
        const classes = className.split(' ');
        for (var i = 0; i < classes.length; i++) {
            if (classes[i]) el.classList.add(classes[i]);
        }
    }

    if (attrs) {
        for (var key in attrs) {
            el.setAttribute(key, attrs[key]);
        }
    }
    
    return el;
}

function escapeForHTML(str) {
    const div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
}