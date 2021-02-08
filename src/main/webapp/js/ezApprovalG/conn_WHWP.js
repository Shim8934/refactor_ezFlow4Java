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
        errMsg: "[연동실패] 결재연동에 실패하였습니다.",
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

            keywordStr = getXmlString(keywordXml).replace(/<[/]?KEYWORD>/gi, "");
            message.SetDocumentInfo("NULL", "NULL", "NULL", keywordStr, "NULL");
        }
    } catch (e) {
        alert("연동정보를 저장하던 도중 오류가 발생했습니다.");
        return false;
    }
    return true;
}

// pAttr 형식 : ["검사할노드이름;검사할속성이름;검사할속성값"]
function ConnExist(pAttr) {
    var keywordXml = loadXMLString(GetDocumentElement("CONNROOT", true));
    var connNodes = SelectNodes(keywordXml, "CONNROOT/conn");

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
            case "BIGGER":
                tempValue = +tempValue;
                pValue = +pValue;

                if (tempValue < pValue) {
                    chkFlag = false;
                }
                break;
            case "SMALLER":
                tempValue = +tempValue;
                pValue = +pValue;

                if (tempValue > pValue) {
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
function setData(pobjXml, currTD) {
    if (!pobjXml) {
        return true;
    }

    var flag, i, j, k, field;
    var offset = 1;
    var rows, row, rowBefore, nfield, fieldName, tblid, tblObject, tblRow;
    var tblinfoNodes, currTR, currTRidx, cellnode, cellidx, isinsTR;
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
                var pAlertContent = "연동에 실패하여 결재를 완료할 수 없습니다!";
            }
            if (getNodeText(connRootXml)) {
                pAlertContent = pAlertContent + "<br/>" + strLang100 + getNodeText(connRootXml);
            }
            OpenAlertUI(pAlertContent);
        }
        return false;
    }

    var xmlTbl, tblRowIdx = 0;
    rows = connRootXml.childNodes;
    if (rows.length > 0) {
        for (i = 0; i < rows.length; i++) {
            row = rows[i].childNodes;

            // if (i > 0) { // 테이블연동 주석
            //     rowBefore = rows[i - 1].childNodes;
            //     if (GetAttribute(row[0],"name") != GetAttribute(rowBefore[0],"name"))
            //         tblRowIdx = 0;
            // } 
            // if (GetDocumentElement("tblinfo", true) != "") { 
            //     xmlTbl = loadXMLString(GetDocumentElement("tblinfo", true));
            //     tblinfoNodes = xmlTbl.documentElement.childNodes

            //     fieldName = GetAttribute(row[0],"name")
            //     if (!fieldName)
            //         fieldName = GetAttribute(row[0],"fname")

            //     var breakFlag = false;
            //     for (j = 0; j < tblinfoNodes.length; j++) {
            //         offset = tblinfoNodes[j].childNodes.length;

            //         for (k = 0; k < offset; k++) {
            //             tblid = GetAttribute(tblinfoNodes[j].childNodes[k],fieldName)
            //             if (tblid) {
            //                 tblid = tblinfoNodes[j];
            //                 breakFlag = true;
            //                 break;
            //             }
            //         }
            //         if (breakFlag) break;
            //     }
            // }

            // if (tblid) {
            //     tblObject = fields.item(tblid.tagName).TagObject

            //     if (currTD && rows.length == 1) {
            //         currTR = currTD.parentElement
            //         currTRidx = currTR.rowIndex;

            //         for (k = 0; k < row.length; k++) {
            //             fieldName = GetAttribute(row[k],"name")
            //             if (!fieldName) fieldName = GetAttribute(row[k],"fname")

            //             cellidx = parseInt(GetAttribute(tblid,fieldName))
            //             cellnode = currTR.cells(cellidx)
            //             if (cellnode) {
            //             	cellnode.text = getNodeText(row[k]);
            //             }
            //         }
            //     } else {

            //         if (GetAttribute(tblid,"color1"))
            //             color1 = GetAttribute(tblid,"color1")
            //         else
            //             color1 = "white"

            //         if (GetAttribute(tblid,"color2"))
            //             color2 = GetAttribute(tblid,"color2")
            //         else
            //             color2 = "white"

            //         isinsTR = false;
            //         pzFormProc.specialTableObject = tblObject
            //         currTR = tblObject.rows[tblRowIdx]
            //         if (currTR) {
            //             if (GetAttribute(currTR,"header")) {
            //                 currTR = tblObject.rows[tblRowIdx + offset]
            //                 if (currTR) {
            //                     var k;
            //                     for (k = tblObject.rows.length; k > (tblRowIdx + offset) ; k--) {
            //                         pzFormProc.tableFlexibleRemoveRow(k, 1);
            //                     }
            //                     isinsTR = true;
            //                 }
            //                 else {
            //                     isinsTR = true;
            //                 }
            //             }
            //             else {
            //             }
            //         }
            //         else {
            //             isinsTR = true;
            //             tblRowIdx = tblRowIdx - offset;
            //         }

            //         if (isinsTR) {
            //             currTR = pzFormProc.tableFlexibleAddRow(tblRowIdx + 1, 1, offset);
            //             if (currTR) {
            //                 var idx
            //                 for (j = 0; j < offset; j++) {
            //                     var newRow = tblObject.rows[tblRowIdx + offset + j];
            //                     if (bgFlag)
            //                         newRow.bgColor = color1;
            //                     else
            //                         newRow.bgColor = color2;

            //                     for (idx = 0; idx < currTR.cells.length; idx++) {

            //                         attVal = GetAttribute(currTR.cells(idx),"processkey")
            //                         if (attVal) newRow.cells(idx).setAttribute("processkey", attVal)

            //                         attVal = GetAttribute(currTR.cells(idx),"processchange")
            //                         if (attVal) newRow.cells(idx).setAttribute("processchange", attVal)

            //                         attVal = GetAttribute(currTR.cells(idx),"lastnext")
            //                         if (attVal) newRow.cells(idx).setAttribute("lastnext", attVal)
            //                     }
            //                 }
            //                 if (bgFlag) bgFlag = false;
            //                 else bgFlag = true;
            //             }
            //             tblRowIdx = tblRowIdx + offset;
            //         }

            //         for (k = 0; k < row.length; k++) {
            //             fieldName = GetAttribute(row[k],"name")
            //             if (!fieldName) fieldName = GetAttribute(row[k],"fname")

            //             for (j = 0; j < offset; j++) {
            //                 if (GetAttribute(tblid.childNodes[j],fieldName)) {
            //                     cellidx = parseInt(GetAttribute(tblid.childNodes[j],fieldName))
            //                     break;
            //                 }
            //             }

            //             currTR = tblObject.rows(tblRowIdx + j);
            //             cellnode = currTR.cells(cellidx)
            //             if (cellnode) {
            //             	cellnode.text = getNodeText(row[k]);
            //             }
            //         }
            //         tblRowIdx = tblRowIdx + offset;
            //     }
            // } else {
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
            // }
        }
    }
    return true;
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
        SetDocumentElement("c_connkey", typeof connKey !== "undefined" ? connKey : "");
        SetDocumentElement("c_connformcode", typeof connFormCode !== "undefined" ? connFormCode : "");
    } else if (pDraftFlag === "SUSIN") {
        SetDocumentElement("c_susinid", pDocID);
    }
}