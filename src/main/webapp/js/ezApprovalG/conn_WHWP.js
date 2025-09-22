var connVal = {
    defaultVal: {
        key: [
            "c_docid",
            "c_susinid",
            "c_formid",
            "c_draft_userid",
            "c_draft_username",
            "c_draft_position",
            "c_draft_deptid",
            "c_draft_deptname",
            "c_processidx",
            "c_processtime",
            "c_connkey",
            "c_connformcode"
        ],
        errMsg: "연동에 실패하여 결재를 진행할 수 없습니다!",
    }
}

function GetDocumentElement(pCharName, pGubun) {
    try {
        if (!pCharName) {
            return "";
        }

        var whwpInfo = loadXMLString(message.GetDocumentInfo());
        var keywordStr = ConvertEntityReferenceToChar(getXmlString(SelectSingleNodeNew(whwpInfo, "DATA/KEYWORD")));
        var keywordXml = loadXMLString(keywordStr);

        var root = keywordXml.documentElement;
        if (root) {
            var connData = GetElementsByTagName(root, pCharName);
            if (connData.length > 0) {
                if (pGubun) {
                    return getXmlString(connData[0]);
                } else {
                    return getNodeText(connData[0]);
                }
            } else {
                return "";
            }
        } else {
            return "";
        }
    } catch (e) {
        alert("연동정보를 불러오던 도중 오류가 발생했습니다.");
        return "";
    }
}

function SetDocumentElement(pCharName, pValue) {
    try {
        if (!pCharName) {
            return true;
        }
        
        var whwpInfo = loadXMLString(message.GetDocumentInfo());
        var keywordStr = ConvertEntityReferenceToChar(getXmlString(SelectSingleNodeNew(whwpInfo, "DATA/KEYWORD")));
        var keywordXml = loadXMLString(keywordStr);

        var connRoot = SelectSingleNodeNew(keywordXml, "KEYWORD/CONNROOT");
        if (connRoot) {
            var connData = GetElementsByTagName(connRoot, pCharName);
            if (connData.length > 0) {
                setNodeText(connData[0], pValue);
            } else {
                createNodeAndAppandNodeCDataText(keywordXml, connRoot, null, pCharName, pValue);
            }

        } else {
            if(keywordXml.getElementsByTagName("connroot").length == 0){
                objNode = document.createElement("CONNROOT");
                setNodeText(objNode , "");
                keywordXml.getElementsByTagName("KEYWORD")[0].appendChild(objNode);
            }
            if (keywordXml.getElementsByTagName(pCharName).length > 0) {
                objNode = keywordXml.getElementsByTagName(pCharName)[0];
                setNodeText(objNode , pValue);
                keywordXml.documentElement.appendChild(objNode);
            } else {
                //createNodeAndAppandNodeCDataText(keywordXml, connRoot, null, pCharName, pValue);
                objNode = document.createElement(pCharName);
                setNodeText(objNode , pValue);
                keywordXml.documentElement.appendChild(objNode);
            }
        }
        keywordStr = getXmlString(keywordXml).replace(/<[/]?KEYWORD>/gi, "");
        message.SetDocumentInfo("NULL", "NULL", "NULL", keywordStr, "NULL");
    } catch (e) {
        parent.HiddenMailProgress();
        console.log(e);
        console.log(e.stack);
        alert("연동정보를 저장하던 도중 오류가 발생했습니다.");
        return false;
    }
    return true;
}

// pAttr 형식 : ["검사할노드이름;검사할속성이름;검사할속성값"]
function ConnExist(pAttr) {
    var keywordXml = loadXMLString(GetDocumentElement("CONNROOT", true));
    var connNodes = SelectNodes(keywordXml, "CONNROOT/conn");

    if (connNodes) {
        var findFlag = true;
        for (var i = 0, ilen = connNodes.length; i < ilen; i++) {
            for (var j = 0, jlen = pAttr.length; j < jlen; j++) {
                var findAttrArr = pAttr[j].split(";");
                var attrValue = findAttribute(connNodes[0], findAttrArr[0], findAttrArr[1]);
                if (attrValue !== findAttrArr[2]) {
                    findFlag = findFlag * false;
                } else {
                    findFlag = findFlag * true;
                }
            }
        }
    }
    
    return Boolean(findFlag);
}

function findAttribute(node, nodeName, attrName) {
    var attrValue = "";

    if (node.tagName === nodeName) {
        attrValue = GetAttribute(node, attrName);
    }

    if (!attrValue) {
        var childNodes = GetChildNodes(node);
        for (var i = 0, ilen = childNodes.length; i < ilen; i++) {
            attrValue = findAttribute(childNodes[i], nodeName, attrName);
            if (attrValue) {
                break;
            }
        }
    }

    return attrValue;
}

var g_progresswin = null;
function showProgress(inforstring) {
	g_progresswin = window.showModelessDialog("/ezApprovalG/showProgress.do?fileInfo=" + encodeURI(inforstring) , "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
}

function hideProgress() {
  try {
	if (g_progresswin)
		g_progresswin.close();
  } catch(e) {}
}

var color1, color2
var bgFlag = true;
function ExcuteInfo(pProcessIdx, pProcessTime) {
    var connStringNode, queryNode, serviceQueryNode, keysNode;
    var connString, connFlag, queryString, queryType;
    var connNodes, connNode, keyNodes;
    var i, ilen, findFlag;
    var processIdx, processTime;
    var rtnVal;

    rtnVal = true;

    if (!pProcessTime) {
        pProcessTime = pDraftFlag;
    }

    var connRootText = GetDocumentElement("CONNROOT", true);
    if (!connRootText) {
        return true;
    }
    
    xmlData = loadXMLString(connRootText);
    findFlag = false;
    connNodes = SelectNodes(xmlData, "CONNROOT/conn");
    
    for (i = 0, ilen = connNodes.length; i < ilen; i++) {
        var tempConnNode = connNodes[i]
        processIdx = GetAttribute(tempConnNode,"processidx");
        processTime = GetAttribute(tempConnNode,"processtime");

        if (processIdx == pProcessIdx && processTime == pProcessTime) {
            SetDocumentElement("c_processidx", pProcessIdx);
            SetDocumentElement("c_processtime", pProcessTime);
            findFlag = true;
            connNode = tempConnNode;
            break;
        }
    }
    
    if (findFlag) {
        connStringNode = SelectSingleNode(connNode, "connstring");
        queryNode = SelectSingleNode(connNode, "query")
        serviceQueryNode = SelectSingleNode(connNode, "servicequery")
        keysNode = SelectSingleNode(connNode, "keys")

        connString = getNodeText(connStringNode);
        connFlag = GetAttribute(connStringNode, "flag");
        queryString = getNodeText(queryNode);
        queryType = GetAttribute(queryNode, "qtype");
        
        var defaultKeys = connVal.defaultVal.key;
        var objNewItem;
        
        for (i = 0, ilen = defaultKeys.length; i < ilen; i++) {
            objNewItem = xmlData.createElement("key");
            objNewItem.setAttribute("kind", "single");
            setNodeText(objNewItem, defaultKeys[i]);
            keysNode.appendChild(objNewItem);
        }
        
        keyNodes = GetChildNodes(keysNode);

        switch (queryType) {
            case "Q":
                xmlData = callQuery(connFlag, connString, queryString, keyNodes);
                break;

            case "NA":
                xmlData = callNoneUIJSP(queryString, keyNodes);
                rtnVal = setData(xmlData);
                break;

            case "UA":
                xmlData = callPopupUIJSP(connString, queryString, keyNodes);
                break;

            case "UA_EX":
                xmlData = callDivPopupUIJSP(connString, queryString, keyNodes);
                break;
        }

    }
    
    return rtnVal;
}
function callQuery(pconnFlag, pconnString, pqueryString, pkeyNodes) {
    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
    var i;
    for (i = 0; i < pkeyNodes.length; i++) {
        arr_key[i] = getKeyValue(getNodeText(pkeyNodes(i)), prowNum)
    }

    var arr_key = new Array();
    var objRoot;
    var objNode;
    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    objRoot = createNodeInsert(xmlpara, objNode, "ROW");
    createNodeAndInsertText(xmlpara, objNode, "DATA1", pconnFlag);
    createNodeAndInsertText(xmlpara, objNode, "DATA2", pconnString);
    createNodeAndInsertText(xmlpara, objNode, "DATA3", pqueryString);

    var objRow = makeKeyValue(pkeyNodes, "Q");
    objRoot.appendChild(objRow);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/conn/aspx/getQueryData.aspx", false);
    xmlhttp.send(xmlpara);

    return loadXMLString(xmlhttp.responseText);
}
function callNoneUIJSP(pQueryString, pKeyNodes) {
    var objRoot = makeKeyValue(pKeyNodes, "A");
    
    var req = new XMLHttpRequest();
    req.open("POST", pQueryString, false);
    req.send(getXmlString(objRoot));

    var res = null;
    if (req.responseText) {
        res = loadXMLString(req.responseText);
    }

	return res;
}
var popup = null;
function callPopupUIJSP(pConnString, pQueryString, pKeyNodes) {
    var objRoot = makeKeyValue(pKeyNodes, "A")

    var feature = "width=800px, height=800px";
    if (pConnString) {
        feature = "width=" + pConnString.split(";")[0] + "px, height=" + pConnString.split(";")[1] + "px";
    }
    popup = window.open(pQueryString, "conn_popup", feature);
    popup.focus();

    window.addEventListener("message", function(e) {
        console.log("postmessage response::", e);
        if (e.data) {
            var res = e.data;
            if (res === "load") {
                popup.postMessage(getXmlString(objRoot), "*");
            } else if (res === "cancel") {
                popup.close();
            } else {
                popup.close();
                res = loadXMLString(e.data);

                setData(res);
            }
        }
    });
}
function callDivPopupUIJSP(pConnString, pQueryString, pKeyNodes) {
    var objRoot = makeKeyValue(pKeyNodes, "A")

    var width = 800;
    var height = 800;
    if (pConnString) {
        width = +pConnString.split(";")[0];
        height = +pConnString.split(";")[1];
    }
    popup = DivPopUpShow(width, height, pQueryString);

    window.addEventListener("message", function(e) {
        console.log("postmessage response::", e);
        if (e.data) {
            var res = e.data;
            if (res === "load") {
                popup.contentWindow.postMessage(getXmlString(objRoot), "*");
            } else if (res === "cancel") {
                DivPopUpHidden();
            } else {
                DivPopUpHidden();
                res = loadXMLString(e.data);

                setData(res);
            }
        }
    });
}
function getKeyValue(fieldID, num) {
    var rtnVal = "";

    if (num) {
        fieldID = num + fieldID;
    }

    if (message.FieldExist(fieldID)) {
        rtnVal = trim(message.GetFieldText(fieldID));
    } else {
        rtnVal = trim(GetDocumentElement(fieldID));
    }

    return rtnVal;
}
function HwpCtrl_FieldClickNotify(name, fieldtype, access) {
    rtnVal = ExcuteInfo(name, "");
}
function checkValidation() {
    var whwpInfo = loadXMLString(message.GetDocumentInfo());
    var keywordStr = ConvertEntityReferenceToChar(getXmlString(SelectSingleNodeNew(whwpInfo, "DATA/KEYWORD")));
    var keywordXml = loadXMLString(keywordStr);

    var chkflag = true;
    var workflowRoot = SelectSingleNodeNew(keywordXml, "KEYWORD/WORKFLOW");
    if (workflowRoot) {
        var validations = SelectNodes(keywordXml, "KEYWORD/WORKFLOW/VALIDATIONS/VALIDATION");
        for (var i = 0, ilen = validations.length; i < ilen; i++) {
            var validation = validations[i];
            var pField = SelectSingleNodeValue(validation, "FIELD");
            var pClass = SelectSingleNodeValue(validation, "CLASS");
            var pDesc = SelectSingleNodeValue(validation, "DESC");
            chkflag = checkValid(pField, pClass, pDesc);

            if (!chkflag) {
                return "FALSE";
            }
        }

        var aprlines = SelectNodes(keywordXml, "KEYWORD/WORKFLOW/APRLINES/APRLINE");
        for (var i = 0, ilen = aprlines.length; i < ilen; i++) {
            var aprline = aprlines[i];
            var pAprtype = SelectSingleNodeValue(aprline, "APRTYPE");
            var pClass = SelectSingleNodeValue(aprline, "CLASS");
            var pValue = SelectSingleNodeValue(aprline, "VALUE");
            var pDesc = SelectSingleNodeValue(aprline, "DESC");
            chkflag = chkAprLine(pAprtype, pClass, pValue, pDesc);

            if (!chkflag) {
                return "FALSE";
            }
        }

        return "TRUE";
    }
}
function chkAprLine(pAprtype, pClass, pValue, pDesc) {
    var xmldom = loadXMLString(getAprLinefor("APR", pDocID));

    var objLines = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");

    var chkflag = false;
    for (var i = 0, ilen = objLines.length; i < ilen; i++) {
        var objLine = objLines[i];
        var cell = GetElementsByTagName(objLine, "CELL")[0];

        var tempValue = "";
        switch (pClass) {
            case "JOBTITLE":
                tempValue = SelectSingleNodeValue(cell, "DATA17");
                break;
            case "USERID":
                tempValue = SelectSingleNodeValue(cell, "DATA4");
                break;
            // 추가적으로 필요한건 추가해서 쓸것
        }

        if (tempValue === pValue && SelectSingleNodeValue(cell, "DATA11") === pAprtype) {
            chkflag = true;
            break;
        }
    }

    if (!chkflag) {
        OpenAlertUI(pDesc);
    }

    return chkflag;
}
function checkValid(pField, pValue, pDesc) {
    var chkFlag = true;
    if (message.FieldExist(pField)) {
        var tempValue = message.GetFieldText(pField);

        switch (pValue) {
            case "NUM":
                if (!tempValue) {
                    chkFlag = false;
                }

                tempValue = tempValue.replace(/[0-9]/g, "");

                if (tempValue) {
                    chkFlag = false;
                }
                break;
            case "NOTNULL":
                if (!tempValue) {
                    chkFlag = false;
                }
                break;
            case "NULL":
                if (tempValue) {
                    chkFlag = false;
                }
                break;
            // 추가적으로 필요한건 추가해서 쓸것
        }

        if (!chkFlag) {
            OpenAlertUI(pDesc);
        }
    }

    return chkFlag;
}
function makeKeyValue(pKeyNodes, flag) {
    var i, ilen, fieldId, fieldVal;
    
    var xmlpara = createXmlDom();

    if (flag == "A") {
        var objRow = createNodeInsert(xmlpara, null, "PARAMETER");
    } else {
        var objRow = createNodeInsert(xmlpara, null, "ROW");
    }
    
    for (i = 0, ilen = pKeyNodes.length; i < ilen; i++) {
        var keyNode = pKeyNodes[i];
        if (GetAttribute(keyNode, "kind") === "single") {
            fieldId = getNodeText(keyNode);
            fieldVal = getKeyValue(fieldId);
            createNodeAndAppandNodeCDataText(xmlpara, objRow, null, fieldId, fieldVal);
        } 
        // else { // 현재 테이블 연동은 xslt를 쓴다고 알고있음 -> 주석처리
            // if (GetDocumentElement(HwpCtrl, "tblinfo") != "") { 
            //     xmlTbl = loadXMLString(GetDocumentElement(HwpCtrl, "tblinfo"))

            //     tblid = GetAttribute(keyNode,"tableid")

            //     tblObject = fields.item(tblid).TagObject

            //     listKeyRow = keyNode.childNodes
            //     customData = xmlpara.createNode(1, "RECORDROOT", "");
            //     objRow.appendChild(customData);

            //     var TagIdx = 0;
            //     for (j = 0; j < tblObject.rows.length; j++) {
            //         if (GetAttribute(tblObject.rows[j],"header") || GetAttribute(tblObject.rows[j],"tail"))
            //             continue;

            //         listnode = xmlpara.createNode(1, "R" + TagIdx, "");
            //         customData.appendChild(listnode);

            //         for (k = 0; k < listKeyRow.length; k++) {
            //             fieldName = getNodeText(listKeyRow[k])
            //             tblinfoRow = xmlTbl.documentElement.selectSingleNode("/TableInfo/" + tblid)
            //             var rowCnt;
            //             var offset = tblinfoRow.childNodes.length;
            //             for (rowCnt = 0; rowCnt < offset; rowCnt++) {
            //                 if (GetAttribute(tblinfoRow.childNodes[rowCnt],fieldName)) {
            //                     colidx = GetAttribute(tblinfoRow.childNodes[rowCnt],fieldName);
            //                     break;
            //                 }
            //             }

            //             if (!colidx) cellValue = getKeyValue(fieldName, "")
            //             else cellValue = getNodeText(tblObject.rows[j + rowCnt].cells(parseInt(colidx)));

            //             listnode.setAttribute(fieldName, cellValue);
            //         }
            //         j = j + (offset - 1);
            //         TagIdx = TagIdx + 1;
            //     }
            // }
        // }
    }

    return xmlpara.documentElement;
}
function setData(pobjXml) {
    if (!pobjXml) {
        return true;
    }

    try {
        var flag, i, j;
        var rows, row, nfield, fieldName;
        flag = "false";

        var connRootXml = pobjXml.documentElement;
        if (connRootXml) {
            flag = GetAttribute(connRootXml, "RESULT");
        }

        if (flag.toUpperCase() === "FALSE") {
            if (connRootXml) {
                if (GetAttribute(connRootXml, "STAGE") === "socket" || GetAttribute(connRootXml, "STAGE") === "db") {
                    var pAlertContent = strLang99;
                } else {
                    var pAlertContent = connVal.defaultVal.errMsg;
                }
                if (getNodeText(connRootXml)) {
                    pAlertContent = pAlertContent + "<br/>" + strLang100 + getNodeText(connRootXml);
                }
                OpenAlertUI(pAlertContent);
            }
            return false;
        }

        rows = connRootXml.childNodes;
        if (rows.length > 0) {
            for (i = 0; i < rows.length; i++) {
                row = rows[i].childNodes;
                for (j = 0; j < row.length; j++) {
                    nfield = row[j];
                    fieldName = GetAttribute(nfield, "name");
                    if (!fieldName) {
                        fieldName = nfield.tagName;
                    }
                    fieldName = fieldName.toLowerCase();

                    var fieldHTML = GetAttribute(nfield, "HTML");

                    if (message.FieldExist(fieldName)) {
                        if (fieldHTML == "Y") {
                            message.PutFieldText(fieldName, "");
                            message.AppendFieldText(fieldName, getNodeText(nfield), true, true, false, function() {
                                message.MoveToField("doctitle");
                            });
                        } else {
                            message.PutFieldText(fieldName, getNodeText(nfield));
                        }
                    } else {
                        if (fieldHTML == "Y") {
                            SetDocumentElement(fieldName, "<![CDATA[" + getNodeText(nfield) + "]]>");
                        } else {
                            SetDocumentElement(fieldName, getNodeText(nfield));
                        }
                    }
                }
            }
        }
        return true;
    } catch (e) {
        var pAlertContent = connVal.defaultVal.errMsg;
        OpenAlertUI(pAlertContent);
        return false;
    }
}

function setConnDefaultKey(pDraftFlag) {
    if (pDraftFlag === "DRAFT") {
        SetDocumentElement("c_docid", pDocID);
        SetDocumentElement("c_susinid", "");
        SetDocumentElement("c_formid", pFormID);
        SetDocumentElement("c_draft_userid", arr_userinfo[1]);
        SetDocumentElement("c_draft_username", arr_userinfo[2]);
        SetDocumentElement("c_draft_position", arr_userinfo[3]);
        SetDocumentElement("c_draft_deptid", arr_userinfo[4]);
        SetDocumentElement("c_draft_deptname", arr_userinfo[5]);
        SetDocumentElement("c_connkey", typeof pConnKey !== "undefined" ? pConnKey : "");
        SetDocumentElement("c_connformcode", typeof pConnFormCode !== "undefined" ? pConnFormCode : "");
    } else if (pDraftFlag === "SUSIN") {
        SetDocumentElement("c_susinid", pDocID);
    }
}

/* 2022-01-13 홍승비 - 일괄기안 전용 연동정보&분리첨부정보 설정 함수 (message iframe 접근 없음) */
function SetDocumentElementForDraftAll(pCharName, pValue) {
    try {
        if (!pCharName) {
            return true;
        }
        
        var whwpInfo = loadXMLString(GetDocumentInfo());
        var keywordStr = ConvertEntityReferenceToChar(getXmlString(SelectSingleNodeNew(whwpInfo, "DATA/KEYWORD")));
        var keywordXml = loadXMLString(keywordStr);
        
        var connRoot = SelectSingleNodeNew(keywordXml, "KEYWORD/CONNROOT");
        if (connRoot) {
            var connData = GetElementsByTagName(connRoot, pCharName);
            if (connData.length > 0) {
                setNodeText(connData[0], pValue);
            } else {
                createNodeAndAppandNodeCDataText(keywordXml, connRoot, null, pCharName, pValue);
            }

        } else {
            if (keywordXml.getElementsByTagName("connroot").length == 0){
                objNode = document.createElement("CONNROOT");
                setNodeText(objNode , "");
                keywordXml.getElementsByTagName("KEYWORD")[0].appendChild(objNode);
            }
            if (keywordXml.getElementsByTagName(pCharName).length > 0) {
                objNode = keywordXml.getElementsByTagName(pCharName)[0];
                setNodeText(objNode , pValue);
                keywordXml.documentElement.appendChild(objNode);
            } else {
                //createNodeAndAppandNodeCDataText(keywordXml, connRoot, null, pCharName, pValue);
                objNode = document.createElement(pCharName);
                setNodeText(objNode , pValue);
                keywordXml.documentElement.appendChild(objNode);
            }
        }
        keywordStr = getXmlString(keywordXml).replace(/<[/]?KEYWORD>/gi, "");
        SetDocumentInfo("NULL", "NULL", "NULL", keywordStr, "NULL"); // 다른 정보는 저장하지 않고, keywordStr을 저장한다. (연동정보, 수신문서번호 정보 등을 세팅)
    } catch (e) {
    	parent.HiddenMailProgress();
        console.log(e);
        console.log(e.stack);
        alert("연동정보를 저장하던 도중 오류가 발생했습니다.");
        return false;
    }
    return true;
}

function GetDocumentElementForDraftAll(pCharName, pGubun) {
    try {
        if (!pCharName) {
            return "";
        }

        var whwpInfo = loadXMLString(GetDocumentInfo());
        var keywordStr = ConvertEntityReferenceToChar(getXmlString(SelectSingleNodeNew(whwpInfo, "DATA/KEYWORD")));
        var keywordXml = loadXMLString(keywordStr);

        var root = keywordXml.documentElement;
        if (root) {
            var connData = GetElementsByTagName(root, pCharName);
            
            if (connData.length > 0) {
                if (pGubun) {
                    return getXmlString(connData[0]);
                } else {
                    return getNodeText(connData[0]);
                }
            } else {
                return "";
            }
        } else {
            return "";
        }
    } catch (e) {
        alert("연동정보를 불러오던 도중 오류가 발생했습니다.");
        return "";
    }
}

function localHWPLoad(frame, formPath, callback) {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", formPath.substring(formPath.indexOf("/ezApprovalG/downloadAttachForHwp")), true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
    xhr.responseType = 'blob';

    xhr.onload = (e) => {
        if (e.target.status === 200) {
            frame.HwpCtrl.Open(e.target.response, "", "", function (res) {
                callback(res);
            }, null);
        }
    }
    xhr.send();
}

var saveCallback;
function lastAnSave(callback){
    if($(".lastAn").length == 0){
        $("body").append("<iframe class=\"lastAn\" name=\"lastAn\" id=\"lastAn\" style=\"width:0px; height:0px; border:0px\" src=\"/ezApprovalG/WHWPEditor.do?type=lastAn\"></iframe>");
        saveCallback = callback;
        return;
    }
    if(saveCallback){
        callback = saveCallback;
        saveCallback = null;
    }
    
    message.HwpCtrl.GetTextFile("HWP", "", function(data){
        lastAnSave2(callback, data, 1);
    });
}

function lastAnSave2(callback, hwp, lidx){
    try{
        lastAn.SetTextFile(hwp, "HWP", "", function(){
            try{
                for(var i = 1; i <= an.options.length; i++){
                    if(lidx == i)
                        continue;
                    deleteAn_B(lastAn.HwpCtrl, i > lidx ? 1 : 0);
                }
                lastAn.HwpCtrl.GetTextFile("HWP", "", function(html){
                    var data = {
                        docID : pDocIDAry[lidx],
                        html  : html,
                        draftAllB : lidx == 1 ? "OA" : ""
                    }
                    
                    $.ajax({
                        type : "POST",
                        dataType : "text",
                        async : false,
                        url : "/ezApprovalG/saveFileHWP.do",
                        contentType : "application/json",
                        data : JSON.stringify(data),
                        success: function(text){
                            if(an.options.length >= ++lidx)
                                lastAnSave2(callback, hwp, lidx);
                            else{
                                var tmp = pDocID;
                                pDocID = pDocIDAry[1];
                                callback(hwp);
                                pDocID = tmp;
                            }
                        },
                        error: function(e){
                            console.log(e);
                            OpenAlertUI("일괄기안 문서 저장중 오류가 발생했습니다.");
                        }
                    });
                });
            }catch(e){
                OpenAlertUI("일괄기안 문서 저장중 오류가 발생했습니다.");
            }
        });
    }catch(e){
        OpenAlertUI("일괄기안 문서 저장중 오류가 발생했습니다.");
    }
}

function deleteAn_B(HwpCtrl, anIndex){
    HwpCtrl.MoveToField("headcampaign{{"+anIndex+"}}");
    HwpCtrl.DeleteCtrl(HwpCtrl.ParentCtrl);
    var now = HwpCtrl.KeyIndicator().prnpageno;
    var next = 0;
    if(HwpCtrl.MoveToField("headcampaign{{"+anIndex+"}}")){
        next = HwpCtrl.KeyIndicator().prnpageno;
    }
    if(next){
        HwpCtrl.Run("MoveDocBegin");
        for(var i = 1; i < now; i++){
            HwpCtrl.Run("MovePageDown");
        }
        for(var i = now; i < next; i++){
            HwpCtrl.Run("MovePageBegin");
            HwpCtrl.Run("Select");
            HwpCtrl.Run("MovePageEnd");
            HwpCtrl.Run("DeleteBack");
            HwpCtrl.Run("DeleteBack");
        }
    }else{
        HwpCtrl.Run("MovePageBegin");
        HwpCtrl.Run("Select");
        HwpCtrl.Run("MoveDocEnd");
        HwpCtrl.Run("DeleteBack");
        HwpCtrl.Run("DeleteBack");
    }
}

/*
function deleteAn_B(HwpCtrl, anIndex){
    HwpCtrl.MoveToField("headcampaign{{"+anIndex+"}}");
    HwpCtrl.DeleteCtrl(HwpCtrl.ParentCtrl);
    HwpCtrl.Run("MovePageBegin");
    HwpCtrl.Run("Select");
    HwpCtrl.Run("MovePageEnd");
    var now = HwpCtrl.KeyIndicator().prnpageno;
    var beforePos = message.HwpCtrl.GetPos();
    var afterPos;
    HwpCtrl.Run("Delete");
    do{
        HwpCtrl.Run("DeleteBack");
        HwpCtrl.Run("DeleteBack");
        if(now == 1)
            afterPos = message.HwpCtrl.GetPos();
    }while((now == HwpCtrl.KeyIndicator().prnpageno && now != 1) || (afterPos && beforePos.list == afterPos.list && beforePos.para == afterPos.para && beforePos.pos == afterPos.pos))
}
*/
var scrollPos = new Array();
var pos;
function scrollSetBefore(idx, start){
    if(message.HwpCtrl.ScrollPosInfo.Item("VertPos") != 0 && !start){
        message.ScrollPosInfo(0,0);
        //setTimeout(() => scrollSetBefore(idx), 10);
        hwpChange(() => scrollSetBefore(idx));
        return;
    }
    message.MoveToFieldEx("headcampaign{{" + idx + "}}");
    //setTimeout(() => scrollSet(idx), 10);
    hwpChange(() => scrollSet(idx));
}

var before = 0;
function scrollSet(idx){
    var next = message.HwpCtrl.ScrollPosInfo.Item("VertPos");
    if(before == next){
        //setTimeout(() => scrollSet(idx), 10);
        message.MoveToFieldEx("headcampaign{{" + idx + "}}");
        hwpChange(() => scrollSet(idx));
        return;
    }
    scrollPos[idx] = next;
    before = next;
    if(++idx >= an.options.length){
        if(pos)
            message.HwpCtrl.SetPos(pos.list, pos.para, pos.pos);
        else
            message.ScrollPosInfo(0,0);
        pos = null;
        before = 0;
    }else{
        //setTimeout(() => scrollSetBefore(idx), 10);
        scrollSetBefore(idx);
    }
}

function changeAn(para, isScroll){
    var anIndex = para ? para - 1 : an.selectedIndex;
    selTab(anIndex);
    if(!isScroll){
        message.ScrollPosInfo(0,scrollPos[anIndex]);
        /*message.HwpCtrl.MovePos(3);
        message.MoveToFieldEx("headcampaign{{"+anIndex+"}}");
        message.HwpCtrl.MovePos(27);*/
        //setTimeout(function(){message.MoveToField("body{{"+anIndex+"}}");}, 1);
        hwpChange(() => message.MoveToField("body{{"+anIndex+"}}"));
    }
    an.selectedIndex = anIndex;
}

function selTab(idx) {
    currentTabIdx = idx + 1;
    pDocID = pDocIDAry[currentTabIdx];
    if(!attachLoad[currentTabIdx]){
        setAttachInfo(an.options[idx].value, "APR", lstAttachLink, draftAllTypeB);
        attachHTMLSave(currentTabIdx);
    } else{
        lstAttachLink.innerHTML = attachHTML[currentTabIdx];
        lstAttachLinkDoc.innerHTML = docAttachHTML[currentTabIdx];
    }
    
    var tmp = message.document.getElementById("hwpctrl_frame");
    if (tmp) {
        tmp.contentDocument.getElementById("ImeWrapper_Elm").focus();
    }
}

function hwpChange(nextFun){
    requestAnimationFrame(() => requestAnimationFrame(() => nextFun()));
}