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

var color1, color2;
var bgFlag = true;
var colSignCnt = 10;

function GetDocumentElement(pCharName, pGubun) {
    try {
        if (!pCharName) {
            return "";
        }

        var mhtInfo = message.GetDocumentInfo();

        var root = mhtInfo.documentElement;
        if (root) {
            var connData = GetElementsByTagName(root, pCharName);
            if (connData.length > 0) {
                return getNodeText(connData[0]);
            } else {
                var fields = message.GetFieldsList();
                var bodyField = message.GetListItem(fields, "body");
                if (pGubun) {
                    return "<" + pCharName + ">" + GetAttribute(bodyField, pCharName) + "</" + pCharName + ">";
                } else {
                    return GetAttribute(bodyField, pCharName);
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

        var fields = message.GetFieldsList();
        var bodyField = message.GetListItem(fields, "body");

        if (bodyField) {
            SetAttribute(bodyField, pCharName, pValue);
        }
    } catch (e) {
        alert("연동정보를 저장하던 도중 오류가 발생했습니다.");
        return false;
    }
    return true;
}

// pAttr 형식 : ["검사할노드이름;검사할속성이름;검사할속성값"]
function ConnExist(pAttr) {
    var connInfoXml = loadXMLString(GetDocumentElement("CONNROOT"));
    var connNodes = SelectNodes(connInfoXml, "connroot/conn");

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
// function ConnExist(pprocessIdx, currTD) {
//     var xmlData = createXmlDom();
//     xmlData.async = false;
//     if (message.CONNINFO.getElementsByTagName("XML").length > 0)
//     	xmlData = loadXMLString(message.CONNINFO.getElementsByTagName("XML").item(0).outerHTML.replace("<!--[CDATA[", "<![CDATA[").replace("-->", ">"));
//     else
//         return false;

//     try {
//         if (GetElementsByTagName(xmlData, "conninfo").length == 0) return false;
//     } catch (e) {
//         return false;
//     }

//     if (GetElementsByTagName(xmlData, "confilepath").length > 0) {
//         try {
//             var ConnRootText = getNodeText(GetElementsByTagName(xmlData, "confilepath").item(0));
//             xmlData = loadXMLFile("/ezCommon/downloadAttach.do?filePath=" + encodeURI(ConnRootText));
//         } catch (e) {
//             return false;
//         }
//     }
//     findFlag = false;
//     var conninfoxml = GetElementsByTagName(xmlData, "conninfo");
//     connNodes = GetChildNodes(conninfoxml.item(0));
//     for (i = 0; i < connNodes.length; i++) {
//         processIdx = GetAttribute(connNodes[i], "processidx");
//         processTime = GetAttribute(connNodes[i], "processtime");

//         if (processIdx == pprocessIdx && processTime == pDraftFlag) {
//             findFlag = true;
//             break;
//         }
//         else if (processIdx == pprocessIdx && pprocessIdx == "FINAL_BEFORE") {
//             if (isLast()) {
//                 findFlag = true;
//                 connNode = connNodes[i]
//                 break;
//             }
//         }
//         else if (processIdx == pprocessIdx && pprocessIdx == "FINAL_AFTER") {
//             if (isLastAfter()) {
//                 findFlag = true;
//                 connNode = connNodes[i]
//                 break;
//             }
//         }
//         else if (processIdx == pprocessIdx && processIdx.substring(0, 6) == "TONGJE") {
//             findFlag = true;
//             connNode = connNodes[i]
//             break;
//         }
//         else if (pDraftFlag == "HAPYUI") {
//             if (HapyuiSN != "") {
//                 if (processIdx == pprocessIdx && processTime == pDraftFlag + HapyuiSN) {
//                     findFlag = true;
//                     connNode = connNodes[i]
//                     break;
//                 }
//             }
//         }
//         else if (pDraftFlag == "GAMSABU") {
//             if (processIdx == pprocessIdx && processTime == "B_GAMSA") {
//                 findFlag = true;
//                 break;
//             }
//         }
//     }
//     return findFlag;
// }

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

    var connRootText = GetDocumentElement("CONNROOT");
    if (!connRootText) {
        return true;
    }

    xmlData = loadXMLString(connRootText);
    findFlag = false;
    connNodes = SelectNodes(xmlData, "connroot/conn");
    
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

    // xmlData = loadXMLString(message.GetTagList("CONNINFO")[0].parentNode.innerHTML);
    // findFlag = false;
    // connNodes = GetChildNodes(xmlData.documentElement);
    // for (i = 0; i < connNodes.length; i++) {
    //     processIdx = GetAttribute(connNodes[i], "processidx");
    //     processTime = GetAttribute(connNodes[i], "processtime");

    //     if (processIdx == pprocessIdx && processTime == pDraftFlag) {
    //         findFlag = true;
    //         connNode = connNodes[i];
    //         break;
    //     }
    // }

    // if (findFlag) {
    //     var subNodes = GetChildNodes(connNode);
    //     connFlag = GetAttribute(subNodes[0], "flag");
    //     connString = getNodeText(subNodes[0]);
    //     queryType = GetAttribute(subNodes[1], "qtype");
    //     queryString = getNodeText(subNodes[1]);

    //     var strItemNames = "SA_DocID";
    //     var arrItemNames = strItemNames.split(",");
    //     var objNewItem;
    //     for (i = 0; i < arrItemNames.length; i++) {
    //         objNewItem = createNodeAndInsertText(xmlData, objNewItem, "key", arrItemNames[i]);
    //         SetAttribute(objNewItem, "kind", "single");
    //         subNodes[2].appendChild(objNewItem);
    //     }
    //     keyNodes = GetChildNodes(subNodes[2]);

    //     switch (queryType) {
    //         case "Q":
    //             xmlData = callQuery(connFlag, connString, queryString, keyNodes);
    //             break;

    //         case "NA":
    //             xmlData = callNoneUIASP(queryString, keyNodes);
    //             break;

    //         case "UA":
    //             xmlData = callUIASP(connString, queryString, keyNodes);
    //             break;

    //         case "UA_EX":
    //             xmlData = callUIASP_EX(connString, queryString, keyNodes);
    //             break;
    //     }
    //     rtnVal = setData(xmlData, currTD);
    // }
    // message.Conn_after();
    // return rtnVal;
}
function callQuery(pconnFlag, pconnString, pqueryString, pkeyNodes) {
    var xmlpara = createXmlDom();
    var i;
    var objRoot;
    var objNode;
    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    objRoot = createNodeInsert(xmlpara, objNode, "ROW");
    createNodeAndInsertText(xmlpara, objNode, "DATA1", pconnFlag);
    createNodeAndInsertText(xmlpara, objNode, "DATA2", pconnString);
    createNodeAndInsertText(xmlpara, objNode, "DATA3", pqueryString);

    var objRow = makeKeyValue(pkeyNodes, "Q");
    objRoot.appendChild(objRow);

    xmlhttp.open("POST", "aspx/getQueryData.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
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

    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, fieldID);

    if (field) {
        switch (field.tagName) {
            case "TD":
                rtnVal = getNodeText(field);
                break;
            case "SELECT":
                rtnVal = field.value;
                break;
            case "INPUT":
                var type = GetAttribute(field, "type");
                if (type === "radio") {
                } else if (type === "checkbox") {
                } else {
                    rtnVal = field.value;
                }
                break;
        }
    } else {
        rtnVal = GetDocumentElement(fieldID, false);
    }

    return trim(rtnVal);
}
// function getKeyValue(fieldID, num) {
//     var rtnVal;
//     var field;
//     var fields;
//     //이쪽에서  GetFieldsList 이거타면 전체체크  Get_ConnFieldList이거 탈땐 body(에디터) 내부에 써진 거만 체크함
//     //message.DocumentBodyGetAttribute(fieldID) 여긴 왜 계속 null
//     if (pPageType == "APPROVUI" || pPageType == "SUSIN")
//         fields = message.GetFieldsList();
//     else
//         fields = message.Get_ConnFieldList();

//     if (num != "") fieldID = num + fieldID;
//     field = message.GetListItem(fields, fieldID);
    
//     if (field == undefined)
//     {
//         fields = message.GetFieldsList();
//         field = message.GetListItem(fields, fieldID);
//     }
    
//     rtnVal = "";
//     if (field && field != null) {
//         switch (field.tagName) {
//             case "TD":
//                 if (field._ez_mode == "html") {
//                     rtnVal = field.innerHTML;
//                 }
//                 else
//                     rtnVal = field.textContent;
//                 break;
//             case "SELECT":
//                 rtnVal = field.textContent;
//                 break;
//         }
//     }
//     else {
//         rtnVal = message.DocumentBodyGetAttribute(fieldID);
//     }
//     if (rtnVal) rtnVal = trim(rtnVal);
//     else rtnVal = "";
//     return rtnVal;
// }
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
        //     if (message.GetTagList("XML")[1]) {
        //         xmlTbl = loadXMLString(message.GetTagList("XML")[1].innerHTML);

        //         tblid = GetAttribute(pkeyNodes[i], "tableid");
        //         tblObject = message.GetListItem(fields, tblid);

        //         listKeyRow = GetChildNodes(pkeyNodes[i]);
        //         customData = createNodeAndAppandNode(xmlpara, objRow, customData, "RECORDROOT");
        //         SetAttribute(customData, "id", tblid);

        //         var TagIdx = 0;
        //         for (j = 0; j < tblObject.rows.length; j++) {
        //             if (tblObject.rows[j].getAttribute("header") || tblObject.rows[j].getAttribute("tail"))
        //                 continue;

        //             listnode = createNodeAndAppandNode(xmlpara, customData, listnode, "R" + TagIdx);

        //             for (k = 0; k < listKeyRow.length; k++) {

        //                 fieldName = listKeyRow[k].textContent;
        //                 tblinfoRow = SelectSingleNodeNew(xmlTbl, "/tableinfo/" + tblid);
        //                 var rowCnt;
        //                 var row = GetChildNodes(tblinfoRow);
        //                 var offset = row.length;
        //                 colidx = "";
        //                 for (rowCnt = 0; rowCnt < offset; rowCnt++) {
        //                     if (row[rowCnt].getAttribute(fieldName)) {
        //                         colidx = row[rowCnt].getAttribute(fieldName);
        //                         break;
        //                     }
        //                 }
        //                 if (colidx == "")
        //                     cellValue = getKeyValue(fieldName, TagIdx + 1)
        //                 else
        //                     cellValue = tblObject.rows[j + rowCnt].cells[parseInt(colidx)].innerText;

        //                 SetAttribute(listnode, fieldName, cellValue);
        //             }
        //             j = j + (offset - 1);
        //             TagIdx = TagIdx + 1;
        //         }
        //     }
        // }
    }

    return xmlpara.documentElement;
}
function setData(pobjXml) {
    if (!pobjXml) {
        return true;
    }

    try {
        var flag, i, j, field;
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

        var fields = message.GetFieldsList();

        rows = connRootXml.childNodes;
        if (rows.length > 0) {
            for (i = 0; i < rows.length; i++) {
                row = rows[i].children;
                for (j = 0; j < row.length; j++) {
                    nfield = row[j];
                    fieldName = GetAttribute(nfield, "name");
                    if (!fieldName) {
                        fieldName = nfield.tagName;
                    }
                    fieldName = fieldName.toLowerCase();

                    var fieldHTML = GetAttribute(nfield, "HTML");

                    var field = message.GetListItem(fields, fieldName);
                    var fieldValue = getNodeText(nfield);
                    if (field) {
                        switch (field.tagName) {
                            case "TD":
                                if (!fieldValue) {
                                    setNodeText(field, " ");
                                }

                                if (fieldHTML === "Y") {
                                    field.innerHTML = fieldValue;
                                } else {
                                    setNodeText(field, fieldValue);
                                }
                                break;
                            case "SELECT":
                                break;
                            case "INPUT":
                                var type = GetAttribute(field, "type");
                                if (type === "radio" || type === "checkbox") {
                                    if (fieldValue === "CHECKED") {
                                        field.checked = true;
                                        SetAttribute(field, "checked", "");
                                    } else {
                                        field.checked = false;
                                        RemoveAttribute(field, "checked");
                                    }
                                } else {
                                    field.value = fieldValue;
                                    SetAttribute(field, "value", fieldValue);
                                }
                                break;
                            case "TEXTAREA":
                                field.value = fieldValue;
                                SetAttribute(field, "value", fieldValue);
                                break;
                        }
                    } else {
                        SetDocumentElement(fieldName, fieldValue);
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
function getdocnumgroupid() {
    var url = "../docnum/docnumui.htm";
    var parameter = ""
    var feature = "status:no;dialogWidth:657px;dialogHeight:375px;edge:sunken";
    feature = feature + GetShowModalPosition(657, 375);
    var ret = window.showModalDialog(url, parameter, feature);

    if (ret[0] == "cancle") return

    var distributeDoc = ret[0];
    var doclimit = ret[1];

    if (doclimit != strLang105 && doclimit != "")
        doclimit = doclimit + strLang106

    var field = message.GetListItem(fields, "grouping");
    if (field) {
        field.value = distributeDoc;

    }

    var field = message.GetListItem(fields, "docnumber");
    if (field) {
        if (field.tagName == "INPUT") {
            var type = field.getAttribute("displayType")

            switch (type) {
                case "deptdistribute":
                    field.textContent = DeptSymbol + ":" + distributeDoc;
                    break;

                case "dept":
                    field.textContent = DeptSymbol
                    break;

                case "distribute":
                    field.textContent = distributeDoc;
                    break;

                default:
                    var value = message.CKEDITOR.instances.editor1.document.$.body.getAttribute("docnum", 0);

                    field.textContent = value.replace(strLang88, distributeDoc);
                    break;
            }

            var cfield = message.GetListItem(fields, "docnumcolor");
            if (cfield)
                field.style.backgroundColor = cfield.bgColor;
        }
        else
            field.textContent = DeptSymbol + ":" + distributeDoc;
    }


    var field = message.GetListItem(fields, "keepperiod");
    if (field) {
        field.textContent = doclimit;
    }
}
function checkValidation() {
    var workflowXmlStr = GetDocumentElement("WORKFLOW");

    if (!workflowXmlStr) {
        return "TRUE";
    }

    var workflowXml = loadXMLString(workflowXmlStr);

    var chkflag = true;
    var validations = SelectNodes(workflowXml, "workflow/validations/validation");
    for (var i = 0, ilen = validations.length; i < ilen; i++) {
        var validation = validations[i];
        var pField = SelectSingleNodeValue(validation, "field");
        var pClass = SelectSingleNodeValue(validation, "class");
        var pDesc = SelectSingleNodeValue(validation, "desc");
        chkflag = checkValid(pField, pClass, pDesc);

        if (!chkflag) {
            return "FALSE";
        }
    }

    var aprlines = SelectNodes(workflowXml, "workflow/aprlines/aprline");
    for (var i = 0, ilen = aprlines.length; i < ilen; i++) {
        var aprline = aprlines[i];
        var pAprtype = SelectSingleNodeValue(aprline, "aprtype");
        var pClass = SelectSingleNodeValue(aprline, "class");
        var pValue = SelectSingleNodeValue(aprline, "value");
        var pDesc = SelectSingleNodeValue(aprline, "desc");
        chkflag = chkAprLine(pAprtype, pClass, pValue, pDesc);

        if (!chkflag) {
            return "FALSE";
        }
    }

    return "TRUE";
}
// function checkValidation(xmlPath) {
//     var XMLURL = "/ezCommon/downloadAttach.do?filePath=" + encodeURI(xmlPath);
//     var xmlpara = createXmlDom();
//     xmlpara.async = false;
//     xmlpara = loadXMLString(xmlPath.innerHTML);

//     var chkflag = true;
//     var objNodes = SelectNodes(xmlpara, "WORKFLOW/VALIDATIONS/VALIDATION");
//     if (objNodes.length > 0) {
//         for (i = 0; i < objNodes.length; i++) {
//             if (chkflag) {
//                 var pField = getNodeText(SelectSingleNode(objNodes[i], "FIELD"));
//                 var pValue = getNodeText(SelectSingleNode(objNodes[i], "CLASS"));
//                 var pDesc = getNodeText(SelectSingleNode(objNodes[i], "DESC"));
//                 chkflag = checkValid(pField, pValue, pDesc);
//             }
//         }
//     }

//     if (!chkflag)
//         return "FALSE";

//     var objNodes = SelectNodes(xmlpara, "WORKFLOW/STATUS/CHECK");
//     if (objNodes.length > 0) {
//         for (i = 0; i < objNodes.length; i++) {
//             var objCASES = GetElementsByTagName(objNodes[i], "CASES");
//             var caseflag = true;
//             for (j = 0; j < objCASES.length; j++) {
//                 var objCASE = GetElementsByTagName(objCASES[j], "CASE");
//                 for (k = 0; k < objCASE.length; k++) {
//                     var pField = getNodeText(SelectSingleNode(objCASE[k], "FIELD"));
//                     var pValue = getNodeText(SelectSingleNode(objCASE[k], "VALUE"));
//                     var pType = getNodeText(SelectSingleNode(objCASE[k], "TYPE"));

//                     var field = message.GetListItem(fields, pField);
//                     if (field) {
//                         switch (pType) {
//                             case "BIGGER":
//                                 var tempValue = field.textContent;
//                                 var p = 0;
//                                 for (p = 0; p < 10; p++)
//                                     tempValue = tempValue.replace(",", "");
//                                 tempValue = parseInt(tempValue);
//                                 if (tempValue <= pValue)
//                                     caseflag = false;
//                                 break;

//                             case "SMALLER":
//                                 var tempValue = field.textContent;
//                                 var p = 0;
//                                 for (p = 0; p < 10; p++)
//                                     tempValue = tempValue.replace(",", "");
//                                 tempValue = parseInt(tempValue);
//                                 if (tempValue > pValue)
//                                     caseflag = false;
//                                 break;
//                         }
//                     }
//                 }
//             }
//             if (caseflag) {
//                 var rtnVal = chkAprLine(objNodes[i]);

//                 if (rtnVal == "") {
//                     chkflag = true;
//                     return "TRUE";
//                 }
//                 else {
//                     chkflag = false;
//                     return rtnVal;
//                 }
//             }
//         }
//     }
//     if (chkFlag)
//         return "TRUE"
//     else
//         return "FALSE";
// }
function checkValid(pField, pValue, pDesc) {
    var chkFlag = true;
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, pField);
    if (field) {
        var tempValue = getNodeText(field);

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
function CheckSignImg() {
    try {
        var obj = message.GetTagList("IMG");
        for (var i = 0 ; i < obj.length ; i++) {
            if (obj[i].parentNode.id.indexOf("sign") >= 0) {
                if (!obj[i].complete) {

                    if (typeof (obj[i].spath) != "undefined") {
                    	obj[i].src = "/ezCommon/downloadAttach.do?filePath=" + obj[i].spath;
                    }
                }
            }
        }
    }
    catch (e)
    { }
}

function DrawAutoAprLine(ret, pDraftFlag) {
    var SignCnt = 0; 
    var HapyCnt = 0; 
    var SSignCnt = 0;
    var SHapyCnt = 0;
    var SignHTML = "";
    var HapyHTML = "";
    var SSignHTML = "";
    var SHapyHTML = "";
    var pFormTagName = new Array(); 
    var i, j, p, k, z;

    var xmldom = createXmlDom();
    xmldom =loadXMLString(ret);

    var susinSN = "";
    var Recv = "";

    if (pDraftFlag == "SUSIN") {
        susinSN = pSusinSN;
        Recv = pSusinSN + "Recv";
    }

    objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    var fields = message.GetFieldsList();
    count = objNodes.length;

    for (i = 0; i < count; i++) {
        var KyljeaType = getNodeText(GetChildNodes(objNodes[i])[16]);

        if (KyljeaType == "001" || KyljeaType == "003" || KyljeaType == "004" || KyljeaType == "015" || KyljeaType == "040") {
            SignCnt = SignCnt + 1;
        }

        if (KyljeaType == "008" || KyljeaType == "009"  || KyljeaType == "011" || KyljeaType == "012") {
            HapyCnt = HapyCnt + 1;
        }
    }


    var tempLen = 0;
    var SignLen = 0;
    var tempLen1 = parseInt(SignCnt / colSignCnt);
    SignLen = (SignCnt % colSignCnt > 0) ? tempLen1 + 1 : tempLen1;

    var HapyLen = 0;
    var tempLen2 = parseInt(HapyCnt / colSignCnt);
    HapyLen = (HapyCnt % colSignCnt > 0) ? tempLen2 + 1 : tempLen2;
    
    var BODYElement = message.GetListItem(fields, "body");
    if(colSignCnt == "" || colSignCnt == null)
        colSignCnt = 10;
    else
        colSignCnt = parseInt(colSignCnt);

    field = message.GetListItem(fields, Recv + "AprLine");
    if (field && SignCnt > 0) {
        if (Recv != "")
            pFormTagName[0] = "<P align=center>수</P><P align=center>신</P><P align=center>결</P><P align=center>재</P>";
        else
            pFormTagName[0] = "<P align=center>기</P><P align=center>안</P><P align=center>결</P><P align=center>재</P>";

        pFormTagName[1] = "18";

        var strHTML = "";
        k = 1;
        z = (SignCnt >= colSignCnt) ? colSignCnt : SignCnt;

        strHTML = "<TABLE style='FONT-SIZE: 0pt' cellSpacing=0 cellPadding=0 align=right valign=top>";
        for (p = 1; SignLen >= p; p++) {
            strHTML += "<TR><TD>";
            if (p >= SignLen) {
                z = SignCnt;
            }

            strHTML += "<TABLE style='TABLE-LAYOUT:fixed; FONT-SIZE:9pt; FONT-FAMILY:굴림체; Design_Time_Lock:true' cellSpacing='0' borderColorDark='white' cellPadding='0' borderColorLight='black' border='1' align='right'>";
            for (i = 1; i <= 3; i++) {
                strHTML += "<TR>";
                for (j = k; j <= z; j++) {
                    if (i == "1" && (j % colSignCnt) == "1") {
                        strHTML += "<TD vAlign='middle' width='" + pFormTagName[1] + "' rowSpan='4' align='center' bgColor='#d2e2fd'><STRONG>" + pFormTagName[0] + "</STRONG></TD>";
                    }

                    switch (i.toString()) {
                        case "1":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "jikwe" + j + "' vAlign='middle' align='center' width='64' height='17' >";
                            
                            field = message.GetListItem(fields,susinSN + "jikwe" + j);                            
                            if (field)
                                strHTML += field.innerHTML  + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        
                        case "2":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "sign" + j + "' vAlign='middle' align='center' width='64' height='50'>";
                           
                            field = message.GetListItem(fields, susinSN + "sign" + j);                            
                            if (field)
                                strHTML += field.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "3":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "seumyungdate" + j + "' vAlign='middle' align='center' width='64' height='17'>";

                           
                            field = message.GetListItem(fields, susinSN + "seumyungdate" + j);                            
                            if (field)
                                strHTML += field.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                    }
                }

                strHTML += "</TR>";
            }
            strHTML += "</TABLE>";
            strHTML += "</TD></TR>";

            if (SignCnt > (p * colSignCnt)) {
                k = k + colSignCnt;
                z = z + colSignCnt;
            }
        }
        strHTML += "</TABLE>";
        field = message.GetListItem(fields, Recv + "AprLine");
        field.innerHTML = strHTML;

    }

    if (field && SignCnt <= 0) {
        field.innerHTML = "&nbsp;";
    }

    field = message.GetListItem(fields, Recv + "AprHapuiLine");

    if (field && HapyCnt <= 0) {
        field.innerHTML = "&nbsp;";
    }

    if (field && HapyCnt > 0) {
        pFormTagName[0] = "<P align=center>합</P><P align=center>의</P><P align=center>결</P><P align=center>재</P>";
        pFormTagName[1] = "18";


        k = 1;
        z = (HapyCnt >= colSignCnt) ? colSignCnt : HapyCnt;
        strHTML = "<TABLE style='FONT-SIZE: 0pt' cellSpacing=0 cellPadding=0 align=right valign=top>";

        for (p = 1; HapyLen >= p; p++) {
            strHTML += "<TR><TD>";
            if (p >= HapyLen) {
                z = HapyCnt;
            }
            strHTML += "<TABLE style='TABLE-LAYOUT:fixed; FONT-SIZE:9pt; FONT-FAMILY:굴림체; Design_Time_Lock:true' cellSpacing='0' borderColorDark='white' cellPadding='0' borderColorLight='black' border='1' align='right'>";
            for (i = 1; i <= 4; i++) {
                strHTML += "<TR>";
                for (j = k; j <= z; j++) {
                    if (i == "1" && (j % colSignCnt) == "1") {
                        strHTML += "<TD vAlign='middle' width='" + pFormTagName[1] + "' rowSpan='4' align='center' bgColor='#d2e2fd'><STRONG>" + pFormTagName[0] + "</STRONG></TD>";
                    }

                    switch (i.toString()) {
                        
                        case "1": 
                            strHTML += "<TD class='FIELD' id='" + susinSN + "habyui" + j + "' vAlign='middle' align='center' width='64' height='17' >"; 
                            field = message.GetListItem(fields, susinSN + "habyui" + j);         
                            if (field) 
                                strHTML += field.innerHTML + "</TD>"; 
                            else 
                                strHTML += "&nbsp;</TD>"; 
                            break; 
                        case "2":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "habyuipositon" + j + "' vAlign='middle' align='center' width='64' height='17'>";
                            
                            field = message.GetListItem(fields, susinSN + "habyuipositon" + j);                            
                            if (field)                         
                                strHTML += field.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "3":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "habyuisign" + j + "' vAlign='middle' align='center' width='64' height='50'>";
                            field = message.GetListItem(fields, susinSN + "habyuisign" + j);                            
                            if (field)                              
                                strHTML += field.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "4":
                            strHTML += "<TD class='FIELD' id='" + susinSN + "habyuidate" + j + "' vAlign='middle' align='center' width='64' height='17'>";
                           
                            field = message.GetListItem(fields, susinSN + "habyuidate" + j);                            
                            if (field)  
                                strHTML += field.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                    }
                }
                strHTML += "</TR>";
            }

            strHTML += "</TABLE>";
            strHTML += "</TD></TR>";

            if (HapyCnt > (p * colSignCnt)) {
                k = k + colSignCnt;
                z = z + colSignCnt;
            }

        }
        strHTML += "</TABLE>";
        field = message.GetListItem(fields, Recv + "AprHapuiLine");
        field.innerHTML = strHTML;
    }
  
}

function New_DrawAutoLine(ret, pDraftFlag) {
	try {
		var signCnt = 0;
		var habyCnt = 0;
		var reSignCnt = 0;
		var reHabyCnt = 0;
		
		var xmlDom = createXmlDom();
			xmlDom = loadXMLString(ret);
			
		var oRows = SelectNodes(xmlDom, "LISTVIEWDATA/ROWS/ROW");
		for (var i = 0; i < oRows.length; i++) {
			var tempAprSn = getNodeText(GetChildNodes(oRows[i])[0]);
			var tempAprType = getNodeText(GetChildNodes(oRows[i])[16]);
			var tempAprStat = getNodeText(GetChildNodes(oRows[i])[17]);

			//2021-02-19 박희찬 G버전도 사용하기 위해 AprType 조건 추가
		if (tempAprType == "001" || tempAprType == "003" || tempAprType == "004" || tempAprType == "015" || tempAprType == "040" || tempAprType == '019' || tempAprType == '018') {
				signCnt++;
				
				if (tempAprStat == "003") {
					reSignCnt++;
				}
				//기결재통과 결재정보 세팅 시, 사인칸 다시 그릴때 기안자는 진행이라 추가
				if (tempAprStat == "002" && tempAprSn == "1") {
					reSignCnt++;
				}
			} else if (tempAprType == "008" || tempAprType == "009" || tempAprType == "011" || tempAprType == "012") {
				habyCnt++;

				if (tempAprStat == "003") {
					reHabyCnt++;
				}
			}
		}

		var aprLineRowCnt = parseInt(signCnt / 10);
		if (signCnt % 10 > 0) {
			aprLineRowCnt++;
		}
		
		var habyRowCnt = parseInt(habyCnt / 10);
		if (habyCnt % 10 > 0) {
			habyRowCnt++;
		}
		
		var Recv = "";
		var SusinSN = "";
		if (pDraftFlag == "SUSIN") {
			Recv = "Recv";
			SusinSN = "1";
		}

        var reDrawSignFlag = false;
        var arrayReSign = new Map();
        var arrayReHaby = new Map();

        if (reSignCnt > 0 || reHabyCnt > 0) {
            fields = message.GetFieldsList();

            for (var i = 1; i <= reSignCnt; i++) {
                field = message.GetListItem(fields, SusinSN + "sign" + i);
                if (field) {
                    arrayReSign.set(SusinSN + "sign" + i, message.GetListItem(fields, SusinSN + "sign" + i).innerHTML);
                }

                field = message.GetListItem(fields, SusinSN + "jikwe" + i);
                if (field) {
                    arrayReSign.set(SusinSN + "jikwe" + i, getNodeText(message.GetListItem(fields, SusinSN + "jikwe" + i)));
                }

                field = message.GetListItem(fields, SusinSN + "seumyung" + i);
                if (field) {
                    arrayReSign.set(SusinSN + "seumyung" + i, getNodeText(message.GetListItem(fields, SusinSN + "seumyung" + i)));
                }

                /* 2021-08-23 홍승비 - IE 브라우저에서 최초 결재선 생성 시 결재일자 undefiend로 삽입되는 오류 수정 */
                field = message.GetListItem(fields, SusinSN + "seumyungdate" + i);
                if (field) {
                	if (getNodeText(message.GetListItem(fields, SusinSN + "seumyungdate" + i)) == "undefined") {
                		arrayReSign.set(SusinSN + "seumyungdate" + i, " ");
                	} else {
                		arrayReSign.set(SusinSN + "seumyungdate" + i, getNodeText(message.GetListItem(fields, SusinSN + "seumyungdate" + i)));
                	}
                }
                
            }

            for (var i = 1; i <= reHabyCnt; i++) {
                field = message.GetListItem(fields, SusinSN + "habyuisign" + i);
                if (field) {
                    arrayReHaby.set(SusinSN + "habyuisign" + i, message.GetListItem(fields, SusinSN + "habyuisign" + i).innerHTML);
                }

                field = message.GetListItem(fields, SusinSN + "habyuipositon" + i);
                if (field) {
                    arrayReHaby.set(SusinSN + "habyuipositon" + i, getNodeText(message.GetListItem(fields, SusinSN + "habyuipositon" + i)));
                }

                field = message.GetListItem(fields, SusinSN + "habyuija" + i);
                if (field) {
                    arrayReHaby.set(SusinSN + "habyuija" + i, getNodeText(message.GetListItem(fields, SusinSN + "habyuija" + i)));
                }

                field = message.GetListItem(fields, SusinSN + "habyuidate" + i);
                if (field) {
                    arrayReHaby.set(SusinSN + "habyuidate" + i, getNodeText(message.GetListItem(fields, SusinSN + "habyuidate" + i)));
                }
            }

            reDrawSignFlag = true;
        }

		var fields = message.GetFieldsList();
		var field = message.GetListItem(fields, Recv + "autoAprLine");

        //수신 테이블 그릴때 결재, 합의 개수를 가져오기 위하여 작성
        try {
            var apr = message.GetListItem(fields, "autoAprLine").children.item(0).tBodies.item(0).rows[1].children.length;
            var habapr = message.GetListItem(fields, "autoHabyLine").children.item(0).tBodies.item(0).rows[1].children.length;
        } catch (error) {
            var apr, habapr = 0;
        }

		if (field && signCnt > 0) {
			field.innerHTML = "";
			
			var signIdx = 1;
			var signMax = 0;

			//2021-02-19 박희찬 - tablewidth를 동적으로 지정해주기 위해 코드 순서 변경
			for (var r = 0; r < aprLineRowCnt; r++) {
                if (r == 0) {
                    if (signCnt > 10) {
                        signMax = 10;
                    } else {
                        signMax = signCnt;
                    }
                } else {
                    signIdx++;
                    signMax = signCnt;
                }

			    var oTable = document.createElement("TABLE");

                //float나 inline-flex가 적용되어 있으면 offsetWidth가 0처리되어 임시로 제거하고 하단에서 추가함
                field.style.float = "";
                field.style.display = "";
                var tempWidth = field.offsetWidth;
                tempWidth = Math.round((tempWidth - 30) / 10);

                var tablewidth = "";
                if (signMax > 10) {
                    tablewidth = (((signMax - 10) * tempWidth) + 30) + "px";
                } else {
                    tablewidth = ((signMax * tempWidth) + 30) + "px";
                }

                //결재선 한줄 표시 위한 style 지정
                //사이트 양식크기마다 설정
                if (pDraftFlag != "SUSIN" && signCnt + habyCnt <= 8) {
                    field.style.float = "left";
                }

                //수신결재 테이블 style 지정
                if (pDraftFlag == "SUSIN" && signCnt + apr > 8 && habapr == 0) {
                    //결재와 수신결재를 한줄에 그리지 못하여 내려야 할때 결재칸의 float style을 삭제한다.
                    message.GetListItem(fields, "autoAprLine").style.float = "";
                } else if (pDraftFlag == "SUSIN" && apr + habapr + signCnt <= 9) {
                    //접수자 전결시 수신이 가운데 뜨도록 css 적용
                    field.style.display = "inline-flex";
                    if (habapr == 0) {
                        message.GetListItem(fields, "autoAprLine").style.float = "left";
                        field.style.float = "right";
                    }
                } else if (pDraftFlag == "SUSIN" && habapr == 0 && 1 < apr + signCnt <= 9) {
                    //합의 테이블이 존재하지 않고 결재 개수와 수신결재 가수가 한줄에 표시되는것이 가능할때
                    message.GetListItem(fields, "autoAprLine").style.float = "left";
                    field.style.float = "right";
                } else if(pDraftFlag =="SUSIN"){
                    //합의 테이블이 존재하고 모든 결재 테이블이 분리되어있을때 수신테이블 style 지정
                    field.style.float = "left";
                }

				oTable.style.width = tablewidth;
				oTable.style.marginTop = "10px";
				oTable.style.tableLayout = "fixed";
				oTable.style.border = "1px solid black";
				oTable.style.borderCollapse = "collapse";

				
				for (var i = 0; i < 4; i++) {
					var oTr = document.createElement("TR");
					
					switch (i) {
						case 0 : 
							oTr.style.height = "20px";
							break;
						case 1 : 
							oTr.style.height = "60px";
							break;
						case 2 : 
							oTr.style.height = "20px";
							break;
						case 3 : 
							oTr.style.height = "20px";
							oTr.style.display = "none";
							break;
					}
					
					if (i == 0) {
						var oTd = document.createElement("TD");
						oTd.style.width = "30px";
						oTd.style.background = "#def7ff";
						oTd.style.border = "1px solid black";
						oTd.setAttribute("rowspan", 4);
						
						for (var p = 0; p < 3; p++) {
							var oP = document.createElement("P");
							oP.style.textAlign = "center";
							oP.style.fontFamily = "굴림";
							oP.style.fontSize = "9pt";
							oP.style.marginTop = "0pt";
							oP.style.marginBottom = "0pt";
							
							if (pDraftFlag == "SUSIN") {
								switch (p) {
								case 0 : 
									oP.innerHTML = "수";
									break;
								case 1 : 
									oP.innerHTML = "&nbsp;";
									break;
								case 2 : 
									oP.innerHTML = "신";
									break;
								}
							} else {
								switch (p) {
								case 0 : 
									oP.innerHTML = "결";
									break;
								case 1 : 
									oP.innerHTML = "&nbsp;";
									break;
								case 2 : 
									oP.innerHTML = "재";
									break;
								}
							}
							oTd.appendChild(oP);
						}
						oTr.appendChild(oTd);
					}
					
					for (var j = signIdx; j <= signMax; j++) {
						var oTd = document.createElement("TD");
						oTd.className = "FIELD";
						//padding 때문에 3을 빼줌
                        oTd.style.width = (tempWidth - 3) + "px";
						oTd.style.textAlign = "center";
						oTd.style.border = "1px solid black";
						oTd.style.fontFamily = "굴림";
						oTd.style.fontSize = "9pt";
						
						switch (i) {
							case 0 : 
								oTd.id = SusinSN + "jikwe" + j;
								break;
							case 1 : 
								oTd.id = SusinSN + "sign" + j;
								break;
							case 2 : 
								oTd.id = SusinSN + "seumyungdate" + j;
								break;
							case 3 : 
								oTd.id = SusinSN + "seumyung" + j;
								break;
						}
						oTr.appendChild(oTd);
					}
					oTable.appendChild(oTr);
				}
				
				signIdx = signMax;
				field.appendChild(oTable);
			}
		}
		
		field = message.GetListItem(fields, Recv + "autoHabyLine");
		if (field && habyCnt > 0) {
			field.innerHTML = "";
			
			var habyIdx = 1;
			var habyMax = 0;
			
			for (var r = 0; r < habyRowCnt; r++) {
                //tablewidth를 동적으로 지정하기 위해 소스코드 순서변경
			    if (r == 0) {
                    if (habyCnt > 10) {
                        habyMax = 10;
                    } else {
                        habyMax = habyCnt;
                    }
                } else {
                    habyIdx++;
                    habyMax = habyCnt;
                }

                var habtablewidth = "";
                field.style.float = "";
                var habtempWidth = Math.round((field.offsetWidth - 30) / 10);


                if (habyMax > 10) {
                    habtablewidth = (((habyMax - 10) * habtempWidth) + 30) + "px";
                } else {
                    habtablewidth = ((habyMax * habtempWidth) + 30) + "px";
                }

                //결재선 한줄 표시 위한 style 지정
                //사이트 양식크기마다 설정
                if (habyCnt != 0 && signCnt + habyCnt <= 8) {
                    field.style.float = "right";
                }

			    var oTable = document.createElement("TABLE");
				oTable.style.width = habtablewidth;
				oTable.style.marginTop = "10px";
				oTable.style.tableLayout = "fixed";
				oTable.style.border = "1px solid black";
				oTable.style.borderCollapse = "collapse";
	

				
				for (var i = 0; i < 4; i++) {
					var oTr = document.createElement("TR");
					
					switch (i) {
						case 0 : 
							oTr.style.height = "20px";
							break;
						case 1 : 
							oTr.style.height = "60px";
							break;
						case 2 : 
							oTr.style.height = "20px";
							break;
						case 3 : 
							oTr.style.height = "20px";
							oTr.style.display = "none";
							break;
					}
					
					if (i == 0) {
						var oTd = document.createElement("TD");
						oTd.style.width = "30px";
						oTd.style.background = "#def7ff";
						oTd.style.border = "1px solid black";
						oTd.setAttribute("rowspan", 4);
						
						for (var p = 0; p < 3; p++) {
							var oP = document.createElement("P");
							oP.style.textAlign = "center";
							oP.style.fontFamily = "굴림";
							oP.style.fontSize = "9pt";
							oP.style.marginTop = "0pt";
							oP.style.marginBottom = "0pt";
							
							switch (p) {
								case 0 : 
									oP.innerHTML = "협";
									break;
								case 1 : 
									oP.innerHTML = "&nbsp;";
									break;
								case 2 : 
									oP.innerHTML = "의";
									break;
							}
							oTd.appendChild(oP);
						}
						oTr.appendChild(oTd);
					}
					
					for (var j = habyIdx; j <= habyMax; j++) {
						var oTd = document.createElement("TD");
						oTd.className = "FIELD";
                        oTd.style.width = (habtempWidth - 3) + "px";
                        oTd.style.border = "1px solid black";
						oTd.style.textAlign = "center";
						oTd.style.fontFamily = "굴림";
						oTd.style.fontSize = "9pt";
						
						switch (i) {
							case 0 : 
								oTd.id = SusinSN + "habyuipositon" + j;
								break;
							case 1 : 
								oTd.id = SusinSN + "habyuisign" + j;
								break;
							case 2 : 
								oTd.id = SusinSN + "habyuidate" + j;
								break;
							case 3 : 
								oTd.id = SusinSN + "habyuija" + j;
								break;
						}
						oTr.appendChild(oTd);
					}
					oTable.appendChild(oTr);
				}
				
				habyIdx = habyMax;
				field.appendChild(oTable);
			}
		} else {
			if (field) {
				field.innerHTML = "";
			}
		}
		
		if (reDrawSignFlag) {
			var fields = message.GetFieldsList();
			var field;

			for (var i = 1; i <= reSignCnt; i++) {
				field = message.GetListItem(fields, SusinSN + "sign" + i);
				if (field) {
					field.innerHTML = arrayReSign.get(SusinSN + "sign" + i);
				}
				
				field = message.GetListItem(fields, SusinSN + "jikwe" + i);
				if (field) {
					setNodeText(field, arrayReSign.get(SusinSN + "jikwe" + i));
				}
				
				field = message.GetListItem(fields, SusinSN + "seumyung" + i);
				if (field) {
					setNodeText(field, arrayReSign.get(SusinSN + "seumyung" + i));
				}
				
                /* 2021-08-23 홍승비 - IE 브라우저에서 최초 결재선 생성 시 양식에 결재일자 undefiend로 삽입되는 오류 수정 */
				field = message.GetListItem(fields, SusinSN + "seumyungdate" + i);
				if (field) {
					if (typeof(arrayReSign.get(SusinSN + "seumyungdate" + i)) == "undefined") {
                		setNodeText(field, " ");
                	} else {
                		setNodeText(field, arrayReSign.get(SusinSN + "seumyungdate" + i));
                	}
				}
			}
			
			for (var i = 1; i <= reHabyCnt; i++) {
				field = message.GetListItem(fields, SusinSN + "habyuisign" + i);
				if (field) {
					field.innerHTML = arrayReHaby.get(SusinSN + "habyuisign" + i);
				}
				
				field = message.GetListItem(fields, SusinSN + "habyuipositon" + i);
				if (field) {
					setNodeText(field, arrayReHaby.get(SusinSN + "habyuipositon" + i));
				}
				
				field = message.GetListItem(fields, SusinSN + "habyuija" + i);
				if (field) {
					setNodeText(field, arrayReHaby.get(SusinSN + "habyuija" + i));
				}
				
				field = message.GetListItem(fields, SusinSN + "habyuidate" + i);
				if (field) {
					setNodeText(field, arrayReHaby.get(SusinSN + "habyuidate" + i));
				}
			}
		}
    } catch (e) {
		alert("New_DrawAutoLine ERROR!!");
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

function insertInitConnAttach() {
    $.ajax({
        type : "POST",
        url : "/ezConn/insertInitConnAttach.do",
        async : false,
        data : {
            connKey : pConnKey,
            docID : pDocID
        },
        success: function(result){
            setAttachInfo(pDocID, "APR", lstAttachLink);
        }        			
    });
}