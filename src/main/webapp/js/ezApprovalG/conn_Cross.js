var color1, color2
var bgFlag = true;

function ConnExist(pprocessIdx, currTD) {
    var xmlData = createXmlDom();
    xmlData.async = false;
    if (message.CONNINFO.getElementsByTagName("XML").length > 0)
        xmlData = loadXMLString(message.CONNINFO.getElementsByTagName("XML").item(0).outerHTML);
    else
        return false;

    try {
        if (GetElementsByTagName(xmlData, "conninfo").length == 0) return false;
    } catch (e) {
        return false;
    }

    if (GetElementsByTagName(xmlData, "confilepath").length > 0) {
        try {
            var ConnRootText = getNodeText(GetElementsByTagName(xmlData, "confilepath").item(0));
            xmlData = loadXMLFile("/ezCommon/downloadAttach.do?filePath=" + encodeURI(ConnRootText));
        } catch (e) {
            return false;
        }
    }
    findFlag = false;
    var conninfoxml = GetElementsByTagName(xmlData, "conninfo");
    connNodes = GetChildNodes(conninfoxml.item(0));
    for (i = 0; i < connNodes.length; i++) {
        processIdx = GetAttribute(connNodes[i], "processidx");
        processTime = GetAttribute(connNodes[i], "processtime");

        if (processIdx == pprocessIdx && processTime == pDraftFlag) {
            findFlag = true;
            break;
        }
        else if (processIdx == pprocessIdx && pprocessIdx == "FINAL_BEFORE") {
            if (isLast()) {
                findFlag = true;
                connNode = connNodes[i]
                break;
            }
        }
        else if (processIdx == pprocessIdx && pprocessIdx == "FINAL_AFTER") {
            if (isLastAfter()) {
                findFlag = true;
                connNode = connNodes[i]
                break;
            }
        }
        else if (processIdx == pprocessIdx && processIdx.substring(0, 6) == "TONGJE") {
            findFlag = true;
            connNode = connNodes[i]
            break;
        }
        else if (pDraftFlag == "HAPYUI") {
            if (HapyuiSN != "") {
                if (processIdx == pprocessIdx && processTime == pDraftFlag + HapyuiSN) {
                    findFlag = true;
                    connNode = connNodes[i]
                    break;
                }
            }
        }
        else if (pDraftFlag == "GAMSABU") {
            if (processIdx == pprocessIdx && processTime == "B_GAMSA") {
                findFlag = true;
                break;
            }
        }
    }
    return findFlag;
}

function ExcuteInfo(pprocessIdx, currTD) {
    var connString, connFlag, queryString, queryType;
    var connNodes, connNode, keyNodes;
    var i, findFlag;
    var processIdx;
    var rtnVal;

    rtnVal = true;
    var xmlData = createXmlDom();

    try {
        if (!message.GetTagList("CONNINFO")[0]) return rtnVal;
    } catch (e) {
        return true;
    }
    xmlData = loadXMLString(message.GetTagList("CONNINFO")[0].parentNode.innerHTML);
    findFlag = false;
    connNodes = GetChildNodes(xmlData.documentElement);
    for (i = 0; i < connNodes.length; i++) {
        processIdx = GetAttribute(connNodes[i], "processidx");
        processTime = GetAttribute(connNodes[i], "processtime");

        if (processIdx == pprocessIdx && processTime == pDraftFlag) {
            findFlag = true;
            connNode = connNodes[i];
            break;
        }
    }

    if (findFlag) {
        var subNodes = GetChildNodes(connNode);
        connFlag = GetAttribute(subNodes[0], "flag");
        connString = getNodeText(subNodes[0]);
        queryType = GetAttribute(subNodes[1], "qtype");
        queryString = getNodeText(subNodes[1]);

        var strItemNames = "SA_DocID";
        var arrItemNames = strItemNames.split(",");
        var objNewItem;
        for (i = 0; i < arrItemNames.length; i++) {
            objNewItem = createNodeAndInsertText(xmlData, objNewItem, "key", arrItemNames[i]);
            SetAttribute(objNewItem, "kind", "single");
            subNodes[2].appendChild(objNewItem);
        }
        keyNodes = GetChildNodes(subNodes[2]);

        switch (queryType) {
            case "Q":
                xmlData = callQuery(connFlag, connString, queryString, keyNodes);
                break;

            case "NA":
                xmlData = callNoneUIASP(queryString, keyNodes);
                break;

            case "UA":
                xmlData = callUIASP(connString, queryString, keyNodes);
                break;

            case "UA_EX":
                xmlData = callUIASP_EX(connString, queryString, keyNodes);
                break;
        }
        rtnVal = setData(xmlData, currTD);
    }
    message.Conn_after();
    return rtnVal;
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
function makeKeyValue(pkeyNodes, flag) {
    var xmlpara = createXmlDom();
    var xmlTbl = createXmlDom();
    var i, j, k, customData, listCol, fieldVal, tblid, listKeyRow, tabObject;
    var fieldName, colidx, tblinfoRow, cellValue, listnode;
    var objRow, customData;

    var prowNum = "";
    var fields;
    if (pPageType == "APPROVUI" || pPageType == "SUSIN")
        fields = message.GetFieldsList();
    else {
        fields = message.Get_ConnFieldList();
        if (fields.length == 0)
            fields = message.GetFieldsList();
    }

    if (flag == "A")
        objRow = createNodeInsert(xmlpara, objRow, "PARAMETER");
    else
        objRow = createNodeInsert(xmlpara, objRow, "ROW");

    for (i = 0; i < pkeyNodes.length; i++) {
        if (GetAttribute(pkeyNodes[i], "kind") == "single") {
            var keyName = getNodeText(pkeyNodes[i]);
            fieldVal = getKeyValue(keyName, prowNum);
            createNodeAndInsertText(xmlpara, customData, keyName, fieldVal);
        }
        else {
            if (message.GetTagList("XML")[1]) {
                xmlTbl = loadXMLString(message.GetTagList("XML")[1].innerHTML);

                tblid = GetAttribute(pkeyNodes[i], "tableid");
                tblObject = message.GetListItem(fields, tblid);

                listKeyRow = GetChildNodes(pkeyNodes[i]);
                customData = createNodeAndAppandNode(xmlpara, objRow, customData, "RECORDROOT");
                SetAttribute(customData, "id", tblid);

                var TagIdx = 0;
                for (j = 0; j < tblObject.rows.length; j++) {
                    if (tblObject.rows[j].getAttribute("header") || tblObject.rows[j].getAttribute("tail"))
                        continue;

                    listnode = createNodeAndAppandNode(xmlpara, customData, listnode, "R" + TagIdx);

                    for (k = 0; k < listKeyRow.length; k++) {

                        fieldName = listKeyRow[k].textContent;
                        tblinfoRow = SelectSingleNodeNew(xmlTbl, "/tableinfo/" + tblid);
                        var rowCnt;
                        var row = GetChildNodes(tblinfoRow);
                        var offset = row.length;
                        colidx = "";
                        for (rowCnt = 0; rowCnt < offset; rowCnt++) {
                            if (row[rowCnt].getAttribute(fieldName)) {
                                colidx = row[rowCnt].getAttribute(fieldName);
                                break;
                            }
                        }
                        if (colidx == "")
                            cellValue = getKeyValue(fieldName, TagIdx + 1)
                        else
                            cellValue = tblObject.rows[j + rowCnt].cells[parseInt(colidx)].innerText;

                        SetAttribute(listnode, fieldName, cellValue);
                    }
                    j = j + (offset - 1);
                    TagIdx = TagIdx + 1;
                }
            }
        }
    }
    return objRow;
}
function callNoneUIASP(pqueryString, pkeyNodes) {
    var xmlpara = createXmlDom();
    var objRoot = makeKeyValue(pkeyNodes, "A");
    xmlpara.appendChild(objRoot);

    xmlhttp.open("POST", pqueryString, false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
function callUIASP(pconnString, pqueryString, pkeyNodes) {
    var xmlsend = createXmlDom();
    var xmlpara = createXmlDom();
    var objRoot = makeKeyValue(pkeyNodes, "A");
    xmlsend.appendChild(objRoot);

    var url = pqueryString;
    var feature = pconnString;
    parameter = window.showModalDialog(url, xmlsend, feature);

    xmlpara = parameter;
    return xmlpara;
}
function callUIASP_EX(pconnString, pqueryString, pkeyNodes) {
    var xmlsend = createXmlDom();
    var xmlpara = createXmlDom();
    var fields = message.GetFieldsList();

    var objRoot = makeKeyValue(pkeyNodes, "A");
    
    if (CrossYN()) {
    	var objRootToImport = xmlsend.importNode(objRoot, true);
    	
    	xmlsend.appendChild(objRootToImport);
    } else {
    	xmlsend.appendChild(objRoot);
    }

    var url = pqueryString;
    var feature = pconnString;
    parameter = window.showModalDialog(url, xmlsend, feature);
    xmlpara = parameter;
    return xmlpara;
}
function getKeyValue(fieldID, num) {
    var rtnVal;
    var fields;
    if (pPageType == "APPROVUI" || pPageType == "SUSIN")
        fields = message.GetFieldsList();
    else
        fields = message.Get_ConnFieldList();

    if (num != "") fieldID = num + fieldID;
    var field = message.GetListItem(fields, fieldID);
    rtnVal = "";
    if (field && field != null) {
        switch (field.tagName) {
            case "TD":
                if (field._ez_mode == "html") {
                    rtnVal = field.innerHTML;
                }
                else
                    rtnVal = field.textContent;
                break;
            case "SELECT":
                rtnVal = field.textContent;
                break;
        }
    }
    else {
        rtnVal = message.DocumentBodyGetAttribute(fieldID);
    }
    if (rtnVal) rtnVal = trim(rtnVal);
    else rtnVal = "";
    return rtnVal;
}
function setData(pobjXml, currTD) {
    BeforeConflict = document.body.getAttribute("CONFLICTWORKFLOW", 0);
    if (BeforeConflict == "null" || BeforeConflict == null)
        BeforeConflict = "";

    var flag, i, j, k, field;

    if (pPageType == "APPROVUI" || pPageType == "SUSIN")
        fields = message.GetFieldsList();
    else {
        fields = message.Get_ConnFieldList();
        if (fields.length == 0)
            fields = message.GetFieldsList();
    }

    var offset = 1;

    var rows, row, rowBefore, nfield, fieldName, tblid, tblObject, tblRow;
    var tblinfoNodes, currTR, currTRidx, cellnode, cellidx, isinsTR;
    flag = "false";

    var xmlTbl = createXmlDom();
    var xmlData = loadXMLString(pobjXml);
    var root = xmlData.documentElement;

    if (root) {
        flag = GetAttribute(root, "RESULT");
    }

    if (flag == "false" || flag == "FALSE") {
        if (root) {
            var pAlertContent = "";
            var rootText = getNodeText(root);

            if (GetAttribute(root, "STAGE") == "socket" || GetAttribute(root, "STAGE") == "db") {
                var pAlertContent = strLang99;
                if (rootText != "")
                    pAlertContent = pAlertContent + "<BR>" + strLang100 + rootText;
                OpenAlertUI(pAlertContent);
            }
        }
        return false;
    }

    if (flag == "confirm" || flag == "CONFIRM") {
        rows_EC = GetChildNodes(xmlData.documentElement);
        if (rows_EC.length > 0) {
            var row_EC_Child = GetChildNodes(rows_EC[0]);
            tmp_name = GetAttribute(row_EC_Child[0], "name");
            tmp_value = getNodeText(row_EC_Child[0]);
            if (tmp_name == "msg") {
                if (OpenInformationUI(tmp_value)) {
                    tmp_name1 = GetAttribute(row_EC_Child[1], "name");
                    tmp_value1 = getNodeText(row_EC_Child[1]);
                    message.DocumentBodySetAttribute(tmp_name1, tmp_value1);
                    tmp_procesidx = getNodeText(row_EC_Child[2]);

                    tmp_rtnval = ExcuteInfo(tmp_procesidx, "");
                    return tmp_rtnval;
                }
                else
                    return false;
            }
        }
    }

    if (flag == "winclose" || flag == "WINCLOSE") {
        window.close();
    }

    var tblRowIdx = 0;
    rows = GetChildNodes(xmlData.documentElement);
    if (rows.length > 0) {
        for (i = 0; i < rows.length; i++) {
            row = GetChildNodes(rows[i]);

            if (i > 0) {
                rowBefore = GetChildNodes(rows[i - 1]);
                if (row[0].getAttribute("name") != rowBefore[0].getAttribute("name"))
                    tblRowIdx = 0;
            }
            if (message.GetTagList("XML")[1]) {
                xmlTbl = loadXMLString(message.GetTagList("XML")[1].innerHTML);
                tblinfoNodes = GetChildNodes(xmlTbl.documentElement);

                fieldName = GetAttribute(row[0], "name").toLowerCase();
                if (!fieldName) fieldName = GetAttribute(row[0], "fname").toLowerCase();

                var breakFlag = false;
                for (j = 0; j < tblinfoNodes.length; j++) {
                    var tblinfoChild = GetChildNodes(tblinfoNodes[j]);
                    offset = tblinfoChild.length;

                    for (k = 0; k < offset; k++) {
                        tblid = GetAttribute(tblinfoChild[k], fieldName);
                        if (tblid) {
                            tblid = tblinfoNodes[j];
                            breakFlag = true;
                            break;
                        }
                    }
                    if (breakFlag) break;
                }
            }

            if (tblid) {
                tblObject = message.GetListItem(fields, tblid.tagName);

                if (currTD && rows.length == 1) {

                    currTR = currTD.parentElement
                    currTRidx = currTR.rowIndex;

                    for (k = 0; k < row.length; k++) {
                        fieldName = GetAttribute(row[k], "name");
                        if (!fieldName) fieldName = GetAttribute(row[k], "fname");

                        cellidx = parseInt(GetAttribute(tblid, fieldName));
                        cellnode = currTR.cells[cellidx];
                        if (cellnode) {
                            cellnode.innerText = getNodeText(row[k]);
                        }
                        else {
                            message.DocumentBodySetAttribute("x_1" + fieldName, row[k].text);
                        }
                    }
                }
                else {

                    if (GetAttribute(tblid, "color1"))
                        color1 = GetAttribute(tblid, "color1");
                    else
                        color1 = "white"

                    if (GetAttribute(tblid, "color2"))
                        color2 = GetAttribute(tblid, "color2");
                    else
                        color2 = "white";

                    isinsTR = false;

                    currTR = tblObject.rows[tblRowIdx];
                    if (currTR) {
                        if (currTR.getAttribute("header")) {
                            currTR = tblObject.rows[tblRowIdx + offset];
                            if (currTR) {
                                var k;
                                for (k = tblObject.rows.length; k > (tblRowIdx + offset) ; k--) {
                                    tblObject.deleteRow(k - 1);
                                }
                                isinsTR = true;
                            }
                            else {
                                isinsTR = true;
                            }
                        }
                        else {
                            currTR = tblObject.rows[tblRowIdx + offset];
                            if (currTR) {
                                var k;
                                for (k = tblObject.rows.length; k > (tblRowIdx + offset) ; k--) {
                                    tblObject.deleteRow(k - 1);
                                }
                                isinsTR = true;
                            }
                            else {
                                isinsTR = true;
                            }
                        }
                    }
                    else {
                        isinsTR = true;
                        tblRowIdx = tblRowIdx - offset;
                    }

                    //2014.03.06 ROW 연동시 헤더가 2개 이상인 경우
                    if (isinsTR) {
                        var td;
                        for (j = 0; j < offset; j++) {
                            currTR = document.createElement("TR");
                            tblObject.appendChild(currTR);
                            for (td = 0; td < tblObject.rows[j].cells.length ; td++) {
                                currTR.insertCell(td);
                            }

                            if (currTR) {
                                var idx;
                                currTR = tblObject.rows[j];
                                var newRow = tblObject.rows[tblRowIdx + offset + j];

                                if (bgFlag)
                                    newRow.bgColor = color1;
                                else
                                    newRow.bgColor = color2;

                                for (idx = 0; idx < currTR.cells.length; idx++) {
                                    attVal = currTR.cells[idx].getAttribute("processkey");
                                    if (attVal) newRow.cells[idx].setAttribute("processkey", attVal)

                                    attVal = currTR.cells[idx].getAttribute("processchange");
                                    if (attVal) newRow.cells[idx].setAttribute("processchange", attVal)

                                    attVal = currTR.cells[idx].getAttribute("lastnext");
                                    if (attVal) newRow.cells[idx].setAttribute("lastnext", attVal);

                                    attVal = currTR.cells[idx].getAttribute("EnterTab");
                                    if (attVal) newRow.cells[idx].setAttribute("EnterTab", attVal);

                                    attVal = currTR.cells[idx].getAttribute("rowspan");
                                    if (attVal) newRow.cells[idx].setAttribute("rowspan", attVal);

                                    attVal = currTR.cells[idx].getAttribute("colspan");
                                    if (attVal) newRow.cells[idx].setAttribute("colspan", attVal);

                                    try {
                                        newRow.cells[idx].style.cssText = "word-break:break-all";
                                    } catch (e) { }

                                    attVal = currTR.cells[idx].getAttribute("height");
                                    if (attVal) newRow.cells[idx].setAttribute("height", attVal)
                                }
                                if (bgFlag) bgFlag = false;
                                else bgFlag = true;
                            }
                        }
                        tblRowIdx = tblRowIdx + offset;
                    }
                    //2014.03.06

                    for (k = 0; k < row.length; k++) {
                        fieldName = row[k].getAttribute("name").toLowerCase();
                        if (!fieldName) fieldName = row[k].getAttribute("fname").toLowerCase();

                        var fieldAlign = row[k].getAttribute("align");
                        var fieldHTML = row[k].getAttribute("HTML");

                        for (j = 0; j < offset; j++) {
                            var node = GetChildNodes(tblid)[j];
                            if (GetAttribute(node, fieldName)) {
                                cellidx = parseInt(GetAttribute(node, fieldName))
                                break;
                            }
                            else
                                cellidx = -1;
                        }

                        if (cellidx < 0 && k > 0) {
                            var tempSN = tblRowIdx;
                            try {
                                tempSN = parseInt(tblRowIdx / GetChildNodes(tblid).length);
                            } catch (e) { }
                            message.DocumentBodySetAttribute("x_" + tempSN + fieldName, row[k].text);
                        }
                        else {
                            currTR = tblObject.rows[tblRowIdx + j];
                            cellnode = currTR.cells[cellidx];
                            if (cellnode) {
                                if (getNodeText(row[k]) == "")
                                    cellnode.textContent = " ";
                                else {
                                    if (fieldHTML == "Y") {
                                        cellnode.innerHTML = getNodeText(row[k]);
                                    }
                                    else if (fieldHTML == "T")
                                        field.textContent = getNodeText(nfield);
                                    else {
                                        cellnode.textContent = getNodeText(row[k]);
                                    }
                                }
                                if (fieldAlign != null && fieldAlign != "")
                                    cellnode.align = fieldAlign;
                            }

                        }
                    }
                    tblRowIdx = tblRowIdx + offset;
                }
            }
            else {
                for (j = 0; j < row.length; j++) {
                    nfield = row[j]
                    fieldName = GetAttribute(nfield, "name");
                    if (!fieldName) fieldName = GetAttribute(nfield, "fname");

                    var fieldHTML = GetAttribute(nfield, "HTML");

                    field = message.GetListItem(fields, fieldName);
                    if (field) {
                        switch (field.tagName) {
                            case "TD":
                                if (getNodeText(nfield) == "NONEDISPLAY_OPTION") {
                                    field.textContent = "";
                                    field.style.display = "none";
                                }
                                else {
                                    if (getNodeText(nfield) == "")
                                        field.innerHTML = "&nbsp;";
                                    else {
                                        if (fieldHTML == "Y")
                                            message.div_BODY.innerHTML = getNodeText(nfield);
                                        else if (fieldHTML == "T") {
                                            if (pPageType == "APPROVUI" || pPageType == "SUSIN")
                                                field.textContent = getNodeText(nfield);
                                            else
                                                message.Conn_BodyFieldWrite(fieldName, getNodeText(nfield));
                                        }
                                        else {
                                            if (pPageType == "APPROVUI" || pPageType == "SUSIN")
                                                field.textContent = getNodeText(nfield);
                                            else
                                                message.Conn_BodyFieldWrite(fieldName, getNodeText(nfield));
                                        }
                                    }

                                    if (GetAttribute(nfield, "DISPLAY") != "NONE")
                                        field.style.display = "";
                                }
                                break;
                            case "SELECT":
                                field.textContent = getNodeText(nfield);
                                break;

                            case "INPUT":
                                if (getNodeText(nfield) == "CHECKED") {
                                    field.checked = true;
                                    SetAttribute(field, "CHECKED", "true");
                                }
                                else if (getNodeText(nfield) == "ENABLE") {
                                    field.disabled = false;
                                    SetAttribute(field, "ENABLE", "true");
                                }
                                else if (getNodeText(nfield) == "DISABLE") {
                                    field.disabled = true;
                                    SetAttribute(field, "DISABLE", "true");
                                }
                                else {
                                    field.checked = false;
                                    RemoveAttribute(nfield, "CHECKED");
                                }
                                break;
                        }
                    }
                    else {
                        message.DocumentBodySetAttribute(fieldName, getNodeText(nfield));
                    }
                }
            }
        }
    }
    return true;
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
function checkValidation(xmlPath) {
    var XMLURL = "/ezCommon/downloadAttach.do?filePath=" + encodeURI(xmlPath);
    var xmlpara = createXmlDom();
    xmlpara.async = false;
    xmlpara = loadXMLString(xmlPath.innerHTML);

    var chkflag = true;
    var objNodes = SelectNodes(xmlpara, "WORKFLOW/VALIDATIONS/VALIDATION");
    if (objNodes.length > 0) {
        for (i = 0; i < objNodes.length; i++) {
            if (chkflag) {
                var pField = getNodeText(SelectSingleNode(objNodes[i], "FIELD"));
                var pValue = getNodeText(SelectSingleNode(objNodes[i], "CLASS"));
                var pDesc = getNodeText(SelectSingleNode(objNodes[i], "DESC"));
                chkflag = checkValid(pField, pValue, pDesc);
            }
        }
    }

    if (!chkflag)
        return "FALSE";

    var objNodes = SelectNodes(xmlpara, "WORKFLOW/STATUS/CHECK");
    if (objNodes.length > 0) {
        for (i = 0; i < objNodes.length; i++) {
            var objCASES = GetElementsByTagName(objNodes[i], "CASES");
            var caseflag = true;
            for (j = 0; j < objCASES.length; j++) {
                var objCASE = GetElementsByTagName(objCASES[j], "CASE");
                for (k = 0; k < objCASE.length; k++) {
                    var pField = getNodeText(SelectSingleNode(objCASE[k], "FIELD"));
                    var pValue = getNodeText(SelectSingleNode(objCASE[k], "VALUE"));
                    var pType = getNodeText(SelectSingleNode(objCASE[k], "TYPE"));

                    var field = message.GetListItem(fields, pField);
                    if (field) {
                        switch (pType) {
                            case "BIGGER":
                                var tempValue = field.textContent;
                                var p = 0;
                                for (p = 0; p < 10; p++)
                                    tempValue = tempValue.replace(",", "");
                                tempValue = parseInt(tempValue);
                                if (tempValue <= pValue)
                                    caseflag = false;
                                break;

                            case "SMALLER":
                                var tempValue = field.textContent;
                                var p = 0;
                                for (p = 0; p < 10; p++)
                                    tempValue = tempValue.replace(",", "");
                                tempValue = parseInt(tempValue);
                                if (tempValue > pValue)
                                    caseflag = false;
                                break;
                        }
                    }
                }
            }
            if (caseflag) {
                var rtnVal = chkAprLine(objNodes[i]);

                if (rtnVal == "") {
                    chkflag = true;
                    return "TRUE";
                }
                else {
                    chkflag = false;
                    return rtnVal;
                }
            }
        }
    }
    if (chkFlag)
        return "TRUE"
    else
        return "FALSE";
}
function chkAprLine(objNodes) {
    var xmldom = createXmlDom();
    xmldom.async = false;
    xmldom = loadXMLString(TempsaveAprlineinfo);

    var objLines = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    var objCheck = GetChildNodesByNodeName(objNodes, "APRLINE");

    var rtnMessage = "";

    for (m = 0; m < objCheck.length; m++) {
        var pAprType = getNodeText(SelectSingleNode(objCheck[m], "APRTYPE"));
        var pClass = getNodeText(SelectSingleNode(objCheck[m], "CLASS"));
        var pValue = getNodeText(SelectSingleNode(objCheck[m], "VALUE"));
        var pDesc = getNodeText(SelectSingleNode(objCheck[m], "DESC"));

        var chkflag;
        var tempValue = "";

        chkflag = false;
        for (n = 0; n < objLines.length; n++) {
            var chiildNode = GetChildNodes(objLines[n]);
            switch (pClass) {
                case "JOBTITLE":
                    tempValue = getNodeText(chiildNode[2]);
                    break;

                case "USERID":
                    tempValue = getNodeText(chiildNode[9]);
                    break;
            }
            if (tempValue.toLowerCase() == pValue.toLowerCase() && getNodeText(chiildNode[4]) == pAprType)
                chkflag = true;
        }

        if (!chkflag) {
            rtnMessage = rtnMessage + pDesc + "<br>";
        }
    }
    return rtnMessage;
}
function checkValid(pField, pValue, pDesc) {
    var chkFlag = true;
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, pField);
    var i = 0;
    if (field) {
        switch (pValue) {
            case "NUM":
                var tempValue = trim(field.textContent);
                for (i = 0; i < 10; i++)
                    tempValue = tempValue.replace(",", "");

                if (tempValue == "")
                    chkFlag = false;
                else if (tempValue == parseInt(tempValue))
                    chkFlag = true;
                else
                    chkFlag = false;
                break;

            case "NOTNULL":
                var tempValue = trim(field.textContent);
                if (tempValue != "")
                    chkFlag = true;
                else
                    chkFlag = false;
                break;

            case "NULL":
                var tempValue = trim(field.textContent);
                if (tempValue == "")
                    chkFlag = true;
                else
                    chkFlag = false;
                break;

            case "DATE":
                chkFlag = true;
                break;
        }
        if (!chkFlag) {
            OpenAlertUI(pDesc);
            return false;
        }
    }
    return true;
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