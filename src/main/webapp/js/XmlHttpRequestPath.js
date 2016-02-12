



//XMLHttpRequest객체를 생성합니다.
function createXMLHttpRequest() {
    var xhttp;
    if (window.XMLHttpRequest) {
        xhttp = new XMLHttpRequest();
    }
    else {
        xhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    return xhttp;
}
//DOM 객체를 생성합니다.
function createXmlDom() {
    var xmlDocument;

    if (window.ActiveXObject) {
        xmlDocument = new ActiveXObject("Microsoft.XMLDOM");
    }
    else if (document.implementation && document.implementation.createDocument) {
        xmlDocument = document.implementation.createDocument("", "", null);
    }

    return xmlDocument;
}

//XMLFile을 DOM 객채로 반환합니다.
//filename:파일 경로및 xml파일명을 인자값으로 받습니다.
function loadXMLFile(filename) {

    var xhttp;
    if (window.ActiveXObject) {
        xhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else {
        xhttp = new XMLHttpRequest();
    }

    xhttp.open("GET", filename, false);
    xhttp.send();
    return xhttp.responseXML;
}
//XMLString을 DOM 객채로 반환합니다.
function loadXMLString(xmlstring) {
    var xmlDoc;
    if (window.DOMParser) {
        parser = new DOMParser();
        xmlDoc = parser.parseFromString(xmlstring, "text/xml");
    }
    else // Internet Explorer
    {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = "false";
        xmlDoc.loadXML(xmlstring);
    }
    return xmlDoc;
}
//노드를 생성합니다.
function createNode(node, tagName) {

    if (window.ActiveXObject) {
        return node.createNode(1, tagName, "");
    }
    else if (document.implementation && document.implementation.createDocument) {
        return node.createElement(tagName);
    }
}
//text를 추가합니다.
function InsertText(xmlDoc, node, value) {

    if (window.ActiveXObject) {
        node.text = value;
        xmlDoc.documentElement.appendChild(node);
    }
    else if (document.implementation && document.implementation.createDocument) {
        var newText = document.createTextNode(value);
        node.appendChild(newText);
        xmlDoc.documentElement.appendChild(node);
    }
    return node;
}
//text 추가후 target에 노드를 추가합니다.
function appendChildText(targetNode, node, value) {
    if (window.ActiveXObject) {

        node.text = value;
        targetNode.appendChild(node);
    }
    else if (document.implementation && document.implementation.createDocument) {

        var newText = document.createTextNode(value);
        node.appendChild(newText);
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


//태그명으로 노드객체의 Element를 가져옵니다.
function GetElementsByTagName(node, tagName) {
    var elements = new Array();

    var idx = 0;
    if (window.DOMParser) {
        for (var i = 0; i < node.childNodes.length; i++) {
            if (node.childNodes[i].nodeType == 1 && node.childNodes[i].tagName == tagName) {
                elements[idx++] = node.childNodes[i];
            }
        }
    }
    else if (window.ActiveXObject) {
        return node.getElementsByTagName(tagName);
    }

    return elements;
}
function SelectNodes(xmlDoc, path) {
    // code for IE
    if (window.ActiveXObject) {
        var nodes = xml.selectNodes(path);
    }
    // code for Mozilla, Firefox, Opera, etc.
    else if (document.implementation && document.implementation.createDocument) {
        var nodes = xml.evaluate(path, xmlDoc, null, XPathResult.ANY_TYPE, null);
    }
}
//해당 노드의 패스를 가져옵니다. 
function SelectNodes(xmlDoc, elementPath) {

    var parentPath = "";
    var nodeName = "";
    var parentNode = null;
    //("DOCLIST/LISTVIEWDATA/HEADERS/HEADER").substr(0,("DOCLIST/LISTVIEWDATA/HEADERS/HEADER").lastIndexOf("/"))
    //("DOCLIST/LISTVIEWDATA/HEADERS/HEADER").substr(("DOCLIST/LISTVIEWDATA/HEADERS/HEADER").lastIndexOf("/")+1)
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

//해당 태그네임으로 노드를 가져옵니다.
function SelectSingleNode(node, tagName) {
    var objNode = null;

    if (window.DOMParser) {
        objNode = node.firstChild;

        while (objNode) {

            //element 타입이면서 동일한 태그명 인경우
            if (objNode.nodeType == 1 && objNode.tagName == tagName)
                break;
            else
                objNode = objNode.nextSibling;
        }
    }
    else if (window.ActiveXObject) {
        return node.selectSingleNode(tagName);
    }

    return objNode;
}
//기존과 동일하게 path로 가져올수 있습니다. "DOCLIST/TREEVIEW" 
//xmlDoc 이 Document 타입인 경우만 가능합니다. 
function SelectSingleNodeNew(xmlDoc, elementPath) {
    //fireFox
    if (document.implementation && document.implementation.createDocument) {
        if (elementPath.indexOf("//") != 0) {
            if (elementPath.indexOf("/") == 0) {
                elementPath = "/" + elementPath;
            } else {
                elementPath = "//" + elementPath;
            }
        }
        var nsResolver = xmlDoc.createNSResolver(xmlDoc.ownerDocument == null ? xmlDoc.documentElement : xmlDoc.ownerDocument.documentElement);
        var xpathResult = xmlDoc.evaluate(elementPath, xmlDoc, nsResolver, XPathResult.ANY_TYPE, null);

        //var elements = [];
        var elements = null;
        var count = 0;

        try {
            var thisNode = xpathResult.iterateNext();
            while (thisNode) {
                if (thisNode != null) {
                    //elements[count++] = thisNode;
                    elements = thisNode;
                    break;
                }
                thisNode = xpathResult.iterateNext();
            }
        }
        catch (e) {
            //alert( 'Error: Document tree modified during iteraton ' + e );
        }
    }
    else//IE
    {
        var elements = xmlDoc.selectSingleNode(elementPath);
    }
    return elements;
}
//해당 태그네임으로 nodeValue를 가져옵니다.
function SelectSingleNodeValue(node, tagName) {
    var strValue = "";

    if (window.DOMParser) {
        var objNode = node.firstChild;

        while (objNode) {
            if (objNode.nodeType == 1 && objNode.tagName == tagName) {
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
    else if (window.ActiveXObject) {
        if (node.selectSingleNode(tagName))
            return node.selectSingleNode(tagName).text;
    }

    return strValue;
}
//기존과 동일하게 path로 가져올수 있습니다. "DOCLIST/TREEVIEW"
//xmlDoc 이 Document 타입인 경우만 가능합니다.
function SelectSingleNodeValueNew(xmlDoc, elementPath) {

    var strValue = "";
    //fireFox
    if (document.implementation && document.implementation.createDocument) {
        if (elementPath.indexOf("//") != 0) {
            if (elementPath.indexOf("/") == 0) {
                elementPath = "/" + elementPath;
            } else {
                elementPath = "//" + elementPath;
            }
        }
        var nsResolver = xmlDoc.createNSResolver(xmlDoc.ownerDocument == null ? xmlDoc.documentElement : xmlDoc.ownerDocument.documentElement);
        var xpathResult = xmlDoc.evaluate(elementPath, xmlDoc, nsResolver, XPathResult.ANY_TYPE, null);

        var elements = null;
        var count = 0;

        try {
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
            alert('Error: Document tree modified during iteraton ' + e);
        }
        if (elements != null) {
            strValue = elements.firstChild.nodeValue;
        }
    }
    else//IE
    {
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

    if (window.DOMParser) {
        objNode = node.firstChild;

        var idx = 0;
        while (objNode) {
            if (objNode.nodeType == 1) {
                elements[idx++] = objNode;
            }

            objNode = objNode.nextSibling;
        }
    }
    else if (window.ActiveXObject) {
        return node.childNodes;
    }

    return elements;
}
//자식노드들을 가져옵니다.
//자식 노드중 특정 노드명의 자식만 가져옵니다.
function GetChildNodesByNodeName(node, nodeName) {

    var elements = new Array();

    if (window.DOMParser) {
        //var objNode = node.firstChild;
        var parentNode = SelectSingleNodeNew(node, "//" + nodeName).parentNode;
        elements = GetElementsByTagName(parentNode, nodeName);

        /* var idx = 0;
        while (objNode) 
        {
        if (objNode.nodeType == 1) 
        {
        //노드명이 같은것만 가져옵니다.
        if (objNode.nodeName == nodeName) 
        {
        elements[idx++] = objNode;
        }
        }

            objNode = objNode.nextSibling;
        }
        */
    }
    else if (window.ActiveXObject) {
        return node.getElementByTagName(nodeName);
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

//documentElement에서 xmlString을 가져옵니다.
function getXmlString(xmlDoc) {

    if (xmlDoc.nodeType == 9) {
        xmlDoc = xmlDoc.documentElement;
    }
    var resultXML = "";
    if (xmlDoc.__proto__ && window.XMLSerializer) {
        xmlDoc.__proto__.__defineGetter__("xml", function() { return (new XMLSerializer()).serializeToString(xmlDoc); });
    }

    if (xmlDoc.nodeType == 9) {
        resultXML = getFirstChild(xmlDoc).xml;
    } else {
        resultXML = xmlDoc.xml;
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
//노드를 텍스트를 가져옵니다.ㅏ
function getNodeText(node) {

    var result = "";
    if (document.implementation && document.implementation.createDocument) {
        result = trim(node.textContent);
    }
    else {
        result = trim(node.text);
    }

    return result;
}

function setNodeText(node, value) {

    if (document.implementation && document.implementation.createDocument) {
        node.textContent = value;
    }
    else {
        node.text = value;
    }
}

String.prototype.trim = function() {
    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
function trim(value) {
    if (value == null || value == "undefind" || value == "") {
        return "";
    }
    return value.trim();
}

