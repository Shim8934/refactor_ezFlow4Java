
function GetDocumentElement(HwpCtrl, CharName)
{
	var fChar = CharName.substring(0,1);
	
	if( !isNaN(fChar) )
		CharName = "r" + CharName;
	
	var DocumentInfo = createXmlDom();
	DocumentInfo.loadXML(HwpCtrl.GetDocumentInfo());
	
	if (DocumentInfo.getElementsByTagName("KEYWORD").length > 0)
	{
	    if (getNodeText(DocumentInfo.getElementsByTagName("KEYWORD").item(0)) == "")
	        setNodeText(DocumentInfo.getElementsByTagName("KEYWORD").item(0), "<CONN></CONN>");
		var DocumentKeywordInfo = createXmlDom();
		DocumentKeywordInfo.loadXML(getNodeText(DocumentInfo.getElementsByTagName("KEYWORD").item(0)));
		
		if (DocumentKeywordInfo.getElementsByTagName(CharName).length > 0)
		{
		    return getNodeText(DocumentKeywordInfo.getElementsByTagName(CharName).item(0));
		}
		else
		{
			return "";
		}
	}
	else
	{
		return "";
	}
}

function SetDocumentElement(HwpCtrl, CharName, value)
{
	var fChar = CharName.substring(0,1);
	
	if( !isNaN(fChar) )
		CharName = "r" + CharName;
	
	var DocumentInfo = createXmlDom();
	DocumentInfo.loadXML(HwpCtrl.GetDocumentInfo());	
	if (DocumentInfo.getElementsByTagName("KEYWORD").length > 0)
	{
	    if (getNodeText(DocumentInfo.getElementsByTagName("KEYWORD").item(0)) == "")
	        setNodeText(DocumentInfo.getElementsByTagName("KEYWORD").item(0), "<CONN></CONN>");
		var DocumentKeywordInfo = createXmlDom();
		DocumentKeywordInfo.loadXML(getNodeText(DocumentInfo.getElementsByTagName("KEYWORD").item(0)));
		
		if (DocumentKeywordInfo.getElementsByTagName(CharName).length > 0)
		{
		    setNodeText(DocumentKeywordInfo.getElementsByTagName(CharName).item(0) , value);
			HwpCtrl.SetDocumentInfo("NULL", "NULL", "NULL", DocumentKeywordInfo.xml);
			return true;
		}
		else
		{
			var objNode;
			objNode = DocumentKeywordInfo.createNode(1,CharName,"");		
			setNodeText(objNode , value);
			DocumentKeywordInfo.documentElement.appendChild(objNode);
			
			HwpCtrl.SetDocumentInfo("NULL", "NULL", "NULL", DocumentKeywordInfo.xml);
			return true;
		}
	}
	else
	{
		return true;
	}
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
function ExcuteInfo(pprocessIdx, currTD) {
    var connString, connFlag, queryString, queryType;
    var connNodes, connNode, keyNodes;
    var i, findFlag;
    var processIdx;
    var rtnVal;

    rtnVal = true;

    var ConnRootText = GetDocumentElement(HwpCtrl, "CONNROOT");
    if (ConnRootText == "")
        return true;

    try {
        var xmlData = createXmlDom();
        xmlData.async = false;
        xmlData.load(document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + encodeURI(ConnRootText));
    } catch (e) {
        return true;
    }
    if (xmlData.xml == "")
        return true;

    findFlag = false;
    connNodes = xmlData.documentElement.childNodes

    for (i = 0; i < connNodes.length; i++) {
        processIdx = GetAttribute(connNodes(i),"processidx")
        processTime = GetAttribute(connNodes(i),"processtime")

        if (processIdx == pprocessIdx && processTime == pDraftFlag) {
            findFlag = true;
            connNode = connNodes(i)
            break;
        }
    }

    if (findFlag) {
        connFlag = GetAttribute(connNode.childNodes(0),"flag");
        connString = getNodeText(connNode.childNodes(0));
        queryType = GetAttribute(connNode.childNodes(1),"qtype");
        queryString = getNodeText(connNode.childNodes(1));

        var strItemNames = "SA_DocID";
        var arrItemNames = strItemNames.split(",");
        var objNewItem;
        for (i = 0; i < arrItemNames.length; i++) {
            objNewItem = xmlData.createElement("key");
            objNewItem.setAttribute("kind", "single");
            setNodeText(objNewItem , arrItemNames[i]);
            connNode.childNodes(2).appendChild(objNewItem);
        }
        keyNodes = connNode.childNodes(2).childNodes;

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
    setMenuBar("btnHelper", true);
    return rtnVal;
}
function callQuery(pconnFlag, pconnString, pqueryString, pkeyNodes) {
    var xmlpara = createXmlDom();
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
function callNoneUIASP(pqueryString, pkeyNodes) {
    var xmlpara = createXmlDom();

    var objRoot = makeKeyValue(pkeyNodes, "A")
    xmlpara.appendChild(objRoot);

    xmlhttp.open("POST", pqueryString, false);
    xmlhttp.send(xmlpara);

    return loadXMLString(xmlhttp.responseText);
}
function callUIASP(pconnString, pqueryString, pkeyNodes) {
    var xmlsend = createXmlDom();
    var xmlpara = createXmlDom();

    var objRoot = makeKeyValue(pkeyNodes, "A")
    xmlsend.appendChild(objRoot);

    var url = pqueryString;
    var parameter = xmlsend.xml;

    var feature = pconnString
    parameter = window.showModalDialog(url, parameter, feature);

    xmlpara.loadXML(parameter)
    return xmlpara;
}
function callUIASP_EX(pconnString, pqueryString, pkeyNodes) {
    var xmlsend = createXmlDom();
    var xmlpara = createXmlDom();

    var objRoot = makeKeyValue(pkeyNodes, "A")
    xmlsend.appendChild(objRoot);

    var url = pqueryString;
    var feature = pconnString
    parameter = window.showModalDialog(url, xmlsend, feature);

    xmlpara.loadXML(parameter)
    return xmlpara;
}
function getKeyValue(fieldID, num) {
    var rtnVal = "";
    if (num != "")
        fieldID = num + fieldID;

    if (fieldID == "SA_DocID") {
        try {
            return pDocID;
        }
        catch (e) { }
    }
    else if (fieldID == "SA_AprType") {
        try {
            return pAprLineType;
        }
        catch (e) { }
    }

    if (HwpCtrl.CheckFieldExist(fieldID)) {
        rtnVal = trim(HwpCtrl.GetFieldText(fieldID));
    }
    else {
        rtnVal = trim(GetDocumentElement(HwpCtrl, fieldID));
    }
    return rtnVal;
}
function HwpCtrl_FieldClickNotify(name, fieldtype, access) {
    rtnVal = ExcuteInfo(name, "");
}
function checkValidation(xmlPath) {
    var XMLURL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(xmlPath);
    var xmlpara = createXmlDom();
    xmlpara.async = false;
    xmlpara.load(XMLURL);

    var chkflag = true;
    var objNodes = xmlpara.selectNodes("WORKFLOW/VALIDATIONS/VALIDATION");
    if (objNodes.length > 0) {
        for (i = 0; i < objNodes.length; i++) {
            if (chkflag) {
                var pField = getNodeText(objNodes.item(i).selectSingleNode("FIELD"))
                var pValue = getNodeText(objNodes.item(i).selectSingleNode("CLASS"))
                var pDesc = getNodeText(objNodes.item(i).selectSingleNode("DESC"))
                chkflag = checkValid(pField, pValue, pDesc);
            }
        }
    }

    if (!chkflag)
        return "FALSE";

    var objNodes = xmlpara.selectNodes("WORKFLOW/STATUS/CHECK");
    if (objNodes.length > 0) {
        for (i = 0; i < objNodes.length; i++) {
            var objCASES = objNodes.item(i).selectNodes("CASES");
            var caseflag = true;
            for (j = 0; j < objCASES.length; j++) {
                var objCASE = objCASES.item(j).selectNodes("CASE");
                for (k = 0; k < objCASE.length; k++) {
                    var pField = getNodeText(objCASE.item(k).selectSingleNode("FIELD"))
                    var pValue = getNodeText(objCASE.item(k).selectSingleNode("VALUE"))
                    var pType = getNodeText(objCASE.item(k).selectSingleNode("TYPE"))

                    if (HwpCtrl.CheckFieldExist(pField)) {
                        switch (pType) {
                            case "BIGGER":
                                var tempValue = HwpCtrl.GetFieldText(pField);
                                for (p = 0; p < 10; p++)
                                    tempValue = tempValue.replace(",", "");
                                tempValue = parseInt(tempValue);
                                if (tempValue <= pValue)
                                    caseflag = false;
                                break;

                            case "SMALLER":
                                var tempValue = HwpCtrl.GetFieldText(pField);
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
                var rtnVal = chkAprLine(objNodes.item(i));

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
    xmldom.loadXML(TempsaveAprlineinfo);

    var objLines = xmldom.selectNodes("LISTVIEWDATA/ROWS/ROW");
    var objCheck = objNodes.selectNodes("APRLINES/APRLINE");

    var rtnMessage = "";

    for (m = 0; m < objCheck.length; m++) {
        var pAprType = getNodeText(objCheck.item(m).selectSingleNode("APRTYPE"))
        var pClass = getNodeText(objCheck.item(m).selectSingleNode("CLASS"))
        var pValue = getNodeText(objCheck.item(m).selectSingleNode("VALUE"))
        var pDesc = getNodeText(objCheck.item(m).selectSingleNode("DESC"))

        var chkflag;
        var tempValue = "";

        chkflag = false;
        for (n = 0; n < objLines.length; n++) {
            switch (pClass) {
                case "JOBTITLE":
                    tempValue = getNodeText(objLines.item(n).childNodes(2));
                    break;

                case "USERID":
                    tempValue = getNodeText(objLines.item(n).childNodes(9));
                    break;

            }
            if (tempValue == pValue && getNodeText(objLines.item(n).childNodes(4)) == pAprType)
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
    if (HwpCtrl.CheckFieldExist(pField)) {
        switch (pValue) {
            case "NUM":
                var tempValue = HwpCtrl.GetFieldText(pField);
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
                if (HwpCtrl.GetFieldText(pField) != "")
                    chkFlag = true;
                else
                    chkFlag = false;
                break;

            case "NULL":
                if (HwpCtrl.GetFieldText(pField) == "")
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
function makeKeyValue(pkeyNodes, flag) {
    var xmlpara = createXmlDom();
    var xmlTbl = createXmlDom();
    var i, j, k, customData, listCol, fieldVal, tblid, listKeyRow, tabObject
    var fieldName, colidx, tblinfoRow, cellValue, listnode

    var prowNum = "";
    if (flag == "A")
        var objRow = xmlpara.createNode(1, "PARAMETER", "");
    else
        var objRow = xmlpara.createNode(1, "ROW", "");

    for (i = 0; i < pkeyNodes.length; i++) {
        if (GetAttribute(pkeyNodes(i),"kind") == "single") {
            customData = xmlpara.createNode(1, getNodeText(pkeyNodes(i)), "");
            objRow.appendChild(customData)
            fieldVal = getKeyValue(getNodeText(pkeyNodes(i)), prowNum)
            setNodeText(customData, fieldVal);
        }
        else {
            if (GetDocumentElement(HwpCtrl, "tblinfo") != "") {
                xmlTbl.loadXML(GetDocumentElement(HwpCtrl, "tblinfo"))

                tblid = GetAttribute(pkeyNodes(i),"tableid")

                tblObject = fields.item(tblid).TagObject

                listKeyRow = pkeyNodes(i).childNodes
                customData = xmlpara.createNode(1, "RECORDROOT", "");
                objRow.appendChild(customData);

                var TagIdx = 0;
                for (j = 0; j < tblObject.rows.length; j++) {
                    if (GetAttribute(tblObject.rows(j),"header") || GetAttribute(tblObject.rows(j),"tail"))
                        continue;

                    listnode = xmlpara.createNode(1, "R" + TagIdx, "");
                    customData.appendChild(listnode);

                    for (k = 0; k < listKeyRow.length; k++) {
                        fieldName = getNodeText(listKeyRow(k))
                        tblinfoRow = xmlTbl.documentElement.selectSingleNode("/TableInfo/" + tblid)
                        var rowCnt;
                        var offset = tblinfoRow.childNodes.length;
                        for (rowCnt = 0; rowCnt < offset; rowCnt++) {
                            if (GetAttribute(tblinfoRow.childNodes(rowCnt),fieldName)) {
                                colidx = GetAttribute(tblinfoRow.childNodes(rowCnt),fieldName);
                                break;
                            }
                        }

                        if (!colidx) cellValue = getKeyValue(fieldName, "")
                        else cellValue = getNodeText(tblObject.rows(j + rowCnt).cells(parseInt(colidx)));

                        listnode.setAttribute(fieldName, cellValue);
                    }
                    j = j + (offset - 1);
                    TagIdx = TagIdx + 1;
                }
            }
        }
    }
    return objRow;
}
function setData(pobjXml, currTD) {
    var flag, i, j, k, field;
    var offset = 1;
    var rows, row, rowBefore, nfield, fieldName, tblid, tblObject, tblRow;
    var tblinfoNodes, currTR, currTRidx, cellnode, cellidx, isinsTR;
    flag = "false";

    var xmlTbl = createXmlDom();
    if (pobjXml.documentElement)
        flag = GetAttribute(pobjXml.documentElement,"RESULT")

    if (flag == "false" || flag == "FALSE") {
        if (pobjXml.documentElement) {
            if (GetAttribute(pobjXml.documentElement,"STAGE") == "socket" || GetAttribute(pobjXml.documentElement,"STAGE") == "db") {
                var pAlertContent = strLang99;
                if (getNodeText(pobjXml.documentElement) != "")
                    pAlertContent = pAlertContent + "<BR>" + strLang100 + getNodeText(pobjXml.documentElement);
                OpenAlertUI(pAlertContent);
            }
        }
        return false;
    }

    var tblRowIdx = 0
    rows = pobjXml.documentElement.childNodes
    if (rows.length > 0) {
        for (i = 0; i < rows.length; i++) {
            row = rows(i).childNodes;

            if (i > 0) {
                rowBefore = rows(i - 1).childNodes;
                if (GetAttribute(row(0),"name") != GetAttribute(rowBefore(0),"name"))
                    tblRowIdx = 0;
            }
            if (GetDocumentElement(HwpCtrl, "tblinfo") != "") {
                xmlTbl.loadXML(GetDocumentElement(HwpCtrl, "tblinfo"));
                tblinfoNodes = xmlTbl.documentElement.childNodes

                fieldName = GetAttribute(row(0),"name")
                if (!fieldName)
                    fieldName = GetAttribute(row(0),"fname")

                var breakFlag = false;
                for (j = 0; j < tblinfoNodes.length; j++) {
                    offset = tblinfoNodes(j).childNodes.length;

                    for (k = 0; k < offset; k++) {
                        tblid = GetAttribute(tblinfoNodes(j).childNodes(k),fieldName)
                        if (tblid) {
                            tblid = tblinfoNodes(j);
                            breakFlag = true;
                            break;
                        }
                    }
                    if (breakFlag) break;
                }
            }

            if (tblid) {
                tblObject = fields.item(tblid.tagName).TagObject

                if (currTD && rows.length == 1) {
                    currTR = currTD.parentElement
                    currTRidx = currTR.rowIndex;

                    for (k = 0; k < row.length; k++) {
                        fieldName = GetAttribute(row(k),"name")
                        if (!fieldName) fieldName = GetAttribute(row(k),"fname")

                        cellidx = parseInt(GetAttribute(tblid,fieldName))
                        cellnode = currTR.cells(cellidx)
                        if (cellnode) {
                            setNodeText(cellnode , getNodeText(row(k)));
                        }
                    }
                }
                else {

                    if (GetAttribute(tblid,"color1"))
                        color1 = GetAttribute(tblid,"color1")
                    else
                        color1 = "white"

                    if (GetAttribute(tblid,"color2"))
                        color2 = GetAttribute(tblid,"color2")
                    else
                        color2 = "white"

                    isinsTR = false;
                    pzFormProc.specialTableObject = tblObject
                    currTR = tblObject.rows(tblRowIdx)
                    if (currTR) {
                        if (GetAttribute(currTR,"header")) {
                            currTR = tblObject.rows(tblRowIdx + offset)
                            if (currTR) {
                                var k;
                                for (k = tblObject.rows.length; k > (tblRowIdx + offset) ; k--) {
                                    pzFormProc.tableFlexibleRemoveRow(k, 1);
                                }
                                isinsTR = true;
                            }
                            else {
                                isinsTR = true;
                            }
                        }
                        else {
                        }
                    }
                    else {
                        isinsTR = true;
                        tblRowIdx = tblRowIdx - offset;
                    }

                    if (isinsTR) {
                        currTR = pzFormProc.tableFlexibleAddRow(tblRowIdx + 1, 1, offset);
                        if (currTR) {
                            var idx
                            for (j = 0; j < offset; j++) {
                                var newRow = tblObject.rows(tblRowIdx + offset + j);
                                if (bgFlag)
                                    newRow.bgColor = color1;
                                else
                                    newRow.bgColor = color2;

                                for (idx = 0; idx < currTR.cells.length; idx++) {

                                    attVal = GetAttribute(currTR.cells(idx),"processkey")
                                    if (attVal) newRow.cells(idx).setAttribute("processkey", attVal)

                                    attVal = GetAttribute(currTR.cells(idx),"processchange")
                                    if (attVal) newRow.cells(idx).setAttribute("processchange", attVal)

                                    attVal = GetAttribute(currTR.cells(idx),"lastnext")
                                    if (attVal) newRow.cells(idx).setAttribute("lastnext", attVal)
                                }
                            }
                            if (bgFlag) bgFlag = false;
                            else bgFlag = true;
                        }
                        tblRowIdx = tblRowIdx + offset;
                    }

                    for (k = 0; k < row.length; k++) {
                        fieldName = GetAttribute(row(k),"name")
                        if (!fieldName) fieldName = GetAttribute(row(k),"fname")

                        for (j = 0; j < offset; j++) {
                            if (GetAttribute(tblid.childNodes(j),fieldName)) {
                                cellidx = parseInt(GetAttribute(tblid.childNodes(j),fieldName))
                                break;
                            }
                        }

                        currTR = tblObject.rows(tblRowIdx + j);
                        cellnode = currTR.cells(cellidx)
                        if (cellnode) {
                            setNodeText(cellnode , getNodeText(row(k)));
                        }
                    }
                    tblRowIdx = tblRowIdx + offset;
                }
            }
            else {

                for (j = 0; j < row.length; j++) {
                    nfield = row(j)
                    fieldName = GetAttribute(nfield, "name")
                    if (!fieldName)
                        fieldName = GetAttribute(nfield, "fname")

                    var fieldHTML = GetAttribute(nfield, "HTML");

                    if (HwpCtrl.CheckFieldExist(fieldName)) {
                        if (fieldHTML == "Y") {
                            HwpCtrl.SetFieldText(fieldName, "");
                            HwpCtrl.AppendFieldText(fieldName, getNodeText(nfield), true, true);
                        }
                        else {
                            HwpCtrl.SetFieldText(fieldName, getNodeText(nfield));
                        }
                    }
                    //else
                    //    SetDocumentElement(HwpCtrl, fieldname, getNodeText(nfield));
                }
            }
        }
    }
    return true;
}