function InitListView() {
    try {
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
        createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID);

        xmlhttp.open("Post", "aspx/AprLineRequest.aspx", false);
        xmlhttp.send(xmlpara);

        var NodeList = SelectNodes(xmlhttp.responseXML, "LISTVIEWDATA/ROWS/ROW");

        if (NodeList.length == 0) {
            pAprLineXml[0] = "cancel";
            pAprLineXml[1] = "cancel";
            pAprLineXml[2] = "";
            pAprLineXml[3] = "";
        } else {
            pAprLineXml[0] = "EXIST";
            pAprLineXml[1] = "EXIST";
            pAprLineXml[2] = "";
            pAprLineXml[3] = "";
        }
        var pAPRLINE = new ListView();
        pAPRLINE.SetID("pAPRLINE");
        pAPRLINE.SetMulSelectable(false);
        pAPRLINE.SetRowOnClick("OnSelChange_onclick");
        pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
        pAPRLINE.SetSelectFlag(false);

        window.returnValue = pAprLineXml;

        if (NodeList.length <= 1) {
            var DraftXml;
            DraftXml = AddDraftUserFirst();

            Resultxml = loadXMLString(DraftXml);
            pAPRLINE.DataSource(Resultxml);
            pAPRLINE.DataBind("APRLINE");
        }
        else {
            pAPRLINE.DataSource(xmlhttp.responseXML);
            pAPRLINE.DataBind("APRLINE");
        }

        var Row;
        for (i = 0; i < pAPRLINE.GetDataRows().length; i++) {
            Row = pAPRLINE.GetDataRows()[i]

            if (Row) {
                if (CrossYN()) {
                    if (GetAttribute(Row, "DATA8") == "Y") {
                        Row.cells[0].textContent = "" + strLang75 + "" + Row.cells[0].innerText
                        chkSuggester = true;
                    }
                    if (GetAttribute(Row, "DATA9") == "Y") {
                        Row.cells[0].textContent = "" + strLang76 + "" + Row.cells[0].innerText
                        chkReporter = true;
                    }
                }
                else {
                    if (GetAttribute(Row, "DATA8") == "Y") {
                        Row.cells[0].innerText = "" + strLang75 + "" + Row.cells[0].innerText
                        chkSuggester = true;
                    }
                    if (GetAttribute(Row, "DATA9") == "Y") {
                        Row.cells[0].innerText = "" + strLang76 + "" + Row.cells[0].innerText
                        chkReporter = true;
                    }
                }
            }
        }
    } catch (e) {
        alert("InitListView :: " + e.description);
    }
}
function OnSelChangeDoEvent(pSelectedRow) {
    try {
        if (pSelectedRow.length != "0") {
            var p_CurAprStat = pSelectedRow[0].cells[5].innerText;
            var Proposer;
            var BriefUser;
            var ClickValue = pSelectedRow[0].cells[4].innerText;
            var ReasonNo = GetAttribute(pSelectedRow[0], "DATA7");
            var pClickValue;

            pSelAprLineType = ConvertAprLineState(p_CurAprStat, "Code")
            pClickValue = ConvertAprLineType(ClickValue, "Code")

            if (pSelAprLineType == "003" && pReDraftFlag != "REDRAFT")
            {
                AprlineType.disabled = true;
                Reporter.disabled = true;
                Suggester.disabled = true;
            }
            else if (pSelAprLineType != "003" && pReDraftFlag != "REDRAFT")
            {
                if (pReDraftAprLineFlag)
                {
                    if (pSelAprLineType == "002")
                    {
                        AprlineType.disabled = true;
                        Reporter.disabled = true;
                        Suggester.disabled = true;
                    }
                    else if (pSelAprLineType == "005") {
                        AprlineType.disabled = true;
                        Reporter.disabled = true;
                        Suggester.disabled = true;
                    }
                    else {
                        AprlineType.disabled = false;
                        Reporter.disabled = false;
                        Suggester.disabled = false;
                    }
                }
                else {
                    if (pClickValue == "003") {
                        var RtnVal = CheckJunGyulState();
                        if (RtnVal) {
                            AprlineType.disabled = true;
                            Reporter.disabled = true;
                            Suggester.disabled = true;
                        }
                        else {
                            AprlineType.disabled = false;
                            Reporter.disabled = false;
                            Suggester.disabled = false;
                        }
                    }
                    else {
                        AprlineType.disabled = false;
                        Reporter.disabled = false;
                        Suggester.disabled = false;
                    }
                }
            }
            else {
                AprlineType.disabled = false;
                Reporter.disabled = false;
                Suggester.disabled = false;
            }
            ReasonNoAprTxt.value = "";
            var opCheck = false;
            for (cnt = 0; cnt < AprlineType.options.length; cnt++) {
                if (AprlineType.options[cnt].value == ClickValue) {
                    opCheck = true;
                    break;
                }
            }
            if (opCheck)
                AprlineType.value = ClickValue;
            else AprlineType.selectedIndex = -1;

            if (pClickValue == "003" && pSelAprLineType != "003") {
                ReasonNoAprTxt.value = ReasonNo;
                ReasonNoAprTxt.disabled = false;
                ReasonNoApr.disabled = false;
            }
        }
    }
    catch (e) {
        alert("OnSelChangeDoEvent :: " + e.description);
    }
}
function CheckJunGyulState() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("pAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;
        var i;

        for (i = 0 ; i < pTotalRowsLen ; i++) {
            var pTmpAprLineType = pTotalRows[i].cells[4].innerText;
            pTmpAprLineType = ConvertAprLineType(pTmpAprLineType, "Code");
            if (pTmpAprLineType == "004") {
                return true;
            }
        }
    } catch (e) {
        alert("CheckJunGyulState :: " + e.description);
    }
}
function GetDocInfo() {
    pDocID = dialogArguments[0];        
    pFormID = dialogArguments[1];        
    pSignCount = dialogArguments[2];        
    pSignInfo = dialogArguments[3];        
    pHapYuiCount = dialogArguments[4];
    pReDraftFlag = dialogArguments[5];
    pSuSinFlag = dialogArguments[6];
    pChamJoFlag = dialogArguments[7];
    pGongramCount = dialogArguments[8];
    pReDraftAprLineFlag = dialogArguments[9];
    pGamSaCount = dialogArguments[11];
    chkReDraft = dialogArguments[13];
    if (pReDraftAprLineFlag) pOrgApruserid = dialogArguments[13];
}

function AprLineTypeCheck(p_AprLineValue, CurSelRow) {
    if (CurSelRow != null) {
        if (p_AprLineValue != "" + strLang279 + "") {
            var ReasonNoCheck;
            var p_AprlineTypeVal;
            var p_AprlineTypeValCode;
            var p_AprLineValueCode;
            var RtnVal = true;

            p_AprlineTypeVal = CurSelRow[0].cells[4].innerText;
            p_AprLineValueCode = ConvertAprLineType(p_AprLineValue, "Code");
            p_AprlineTypeValCode = ConvertAprLineType(p_AprlineTypeVal, "Code");

            if (RtnVal) {
                if (p_AprLineValueCode == "003")
                    ReasonNoCheck = ReasonNocheck(CurSelRow, p_AprlineTypeVal, p_AprLineValue);

                if (ReasonNoCheck == "YES") {
                    if (CrossYN()) {
                        CurSelRow[0].cells[3].textContent = p_AprLineValue;
                    }
                    else {
                        CurSelRow[0].cells[3].innerText = p_AprLineValue;
                    }
                }
                else if (ReasonNoCheck == "NO") {
                    AprlineType.value = p_AprlineTypeVal;
                }
                else {
                    if (p_AprLineValueCode == "003") {
                        var pAlertContent = "" + strLang285 + "";
                        OpenAlertUI(pAlertContent);

                        ReasonNoAprTxt.disabled = false;
                        ReasonNoApr.disabled = false;
                        ReasonNoApr.focus();
                        ReasonNoAprTxt.focus();
                    }

                    if (CrossYN()) {
                        CurSelRow[0].cells[4].textContent = p_AprLineValue;
                    }
                    else {
                        CurSelRow[0].cells[4].innerText = p_AprLineValue;
                    }

                    SetAttribute(CurSelRow[0], "DATA11", p_AprLineValueCode);

                    try {
                        if (p_AprLineValue == "" + strLang22 + "" || p_AprLineValue == "" + strLang6 + "") {
                            var pAPRLINE = new ListView();
                            pAPRLINE.LoadFromID("pAPRLINE");

                            var objRows = pAPRLINE.GetDataRows();

                            for (var n = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) + 1 ; n < objRows.length ; n++) {
                                var Row = objRows[n];
                                if (GetAttribute(Row[0], "DATA11") == strAprType1) {
                                    if (CrossYN()) {
                                        Row.cells[4].textContent = "" + strLang21 + "";
                                    }
                                    else {
                                        Row.cells[4].innerText = "" + strLang21 + "";
                                    }
                                    GetAttribute(Row, "DATA11");
                                }
                            }
                        }
                    }
                    catch (e) { }
                }
            }
        }
    }
}
function ApplyJunGyulFunction(pCurSelIndex, pTmpAprLineType) {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("pAPRLINE");

    var pAprLineRow = pAPRLINE.GetDataRows();
    var pAprLineRowLen = pAprLineRow.length;

    var i;
    var flag;
    for (i = 0 ; i < pAprLineRowLen ; i++) {
        flag = "uncheck";
        if (parseInt(pAprLineRow[i].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "")) > parseInt(pCurSelIndex) && (pAprLineRow[i].cells[4].innerText.replace("" + strLang2 + "", "") != pAprLineRow[i].cells[4].innerText || pAprLineRow[i].cells[4].innerText.replace("" + strLang3 + "", "") != pAprLineRow[i].cells[4].innerText)) {
            flag = "check";
            var pAlertContent = "" + strLang286 + "<br>" + strLang287 + "";
            OpenAlertUI(pAlertContent);
            return flag;
        }
        else if (pAprLineRow[i].cells[4].innerText == "" + strLang288 + "" || pAprLineRow[i].cells[4].innerText == "" + strLang14 + "" || pAprLineRow[i].cells[4].innerText == "" + strLang289 + "") {
            flag = "check";
            var pAlertContent = "" + strLang286 + "<br>" + strLang287 + "";
            OpenAlertUI(pAlertContent);
            return flag;
        }
    }

    for (i = 0 ; i < pAprLineRowLen ; i++) {
        if (parseInt(pAprLineRow[i].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "")) > parseInt(pCurSelIndex)) {
            if (pAprLineRow[i].cells[4].innerText == pAprLineRow[i].cells[4].innerText.replace("" + strLang2 + "", "") && pAprLineRow[i].cells[4].innerText == pAprLineRow[i].cells[4].innerText.replace("" + strLang3 + "", "")) {
                if (CrossYN()) {
                    pAprLineRow[i].cells[4].textContent = pTmpAprLineType;
                }
                else {
                    pAprLineRow[i].cells[4].innerText = pTmpAprLineType;
                }
            }
        } else {
            break;
        }
    }
}

function ReasonNocheck(CurSelRow, p_AprlineTypeVal, p_AprLineValue) {
    var checkvalue = "NREASON";
    var NoReasonVal = GetAttribute(CurSelRow[0], "DATA7");

    if (p_AprlineTypeVal == "003" && p_AprLineValue != "003" && NoReasonVal != "") {
        var pInformationContent = "" + strLang290 + "";
        var Ans = OpenInformationUI(pInformationContent);
        if (Ans) {
            checkvalue = "YES";
            GetAttribute(CurSelRow[0], "DATA7");
            ReasonNoAprTxt.value = "";
        } else {
            checkvalue = "NO";
        }
    }
    return checkvalue;
}

function AprLineAddUser(Mode, tr, pSelectedRow) {
    if (pSelectedRow != null) {
        var pparsingXML;
        var i
        var chkDuplflag = false;

        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");

        var selnode = treeView.GetSelectNode();
        if (Mode == "DEPT") {
            if (!isgetUser(selnode.GetNodeData("CN"))) {
                var pAlertContent = "" + strLang291 + "<br>" + strLang292 + "";
                OpenAlertUI(pAlertContent);
                return;
            }
        }

        if (Mode == "PERSON") {
            if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2")) {
                var pAlertContent = "" + strLang293 + "";
                OpenAlertUI(pAlertContent);
                return;
            }
        }
        else if (Mode == "DEPT") {
            if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2")) {
                var pAlertContent = "" + strLang294 + "<br>" + strLang295 + "";
                OpenAlertUI(pAlertContent);
                return;
            }
        }

        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("pAPRLINE");

        var totalRow = pAPRLINE.GetDataRows();

        for (i = 0; i < totalRow.length; i++) {
            if (Mode == "DEPT") {
                if (GetAttribute(totalRow[i], "DATA4") == selnode.GetNodeData("CN")) {
                    chkDuplflag = true;
                    break;
                }
            }
            else {
                if (GetAttribute(totalRow[i], "DATA4") == GetAttribute(pSelectedRow[0], "DATA2")) {
                    if (GetAttribute(totalRow[i], "DATA4") == optGamsabu) {
                        if (totalRow[i].cells[4].innerText == totalRow[i].cells[4].innerText.replace("" + strLang2 + "", "") && totalRow[i].cells[4].innerText == totalRow[i].cells[4].innerText.replace("" + strLang3 + "", "")) {
                            chkDuplflag = true;
                            break;
                        }
                    }
                    else {
                        chkDuplflag = true;
                        break;
                    }
                }
            }
        }

        if (chkDuplflag) {
            var pInformationContent = "" + strLang296 + "<br>" + strLang297 + "";
            var Ans = OpenInformationUI(pInformationContent);
            if (Ans) {
            }
            else {
                return;
            }
        }
        var AprLineRow = pAPRLINE.GetDataRows();
        AprLineAddIndex = AprLineRow.length;
        AprLineAddIndex = AprLineAddIndex + 1;

        if (AprLineAddIndex > 1) {
            if (AprLineRow[0].cells[4].innerText == "" + strLang6 + "" || AprLineRow[0].cells[4].innerText == "" + strLang74 + "") {
                var pAlertContent = "" + strLang298 + "<br>" + strLang299 + "";
                OpenAlertUI(pAlertContent);
                return;
            }
        }
        var pCompanyNAME;

        if (selnode.GetNodeData("EXTENSIONATTRIBUTE3") == "TopGroup")
            pCompanyNAME = selnode.GetNodeData("VALUE");
        else
            pCompanyNAME = selnode.GetNodeData("EXTENSIONATTRIBUTE3");

        var pDeptNm = pSelectedRow.value;

        if (selnode.GetNodeData("EXTENSIONATTRIBUTE2") != companyID) {
            pDeptNm = pSelectedRow.value + "(" + pCompanyNAME + ")";
        }

        var tr = pAPRLINE.GetSelectedRows();
        if (tr.length > 0 && InsertMode != "Add") {
            AprLineAddIndex = parseInt(tr[0].cells[0].innerText);
        }

        if (Mode == "PERSON") {
            var preDeptID = GetAttribute(pSelectedRow[0], "DATA3");
            var preDeptName = pSelectedRow[0].childNodes[1].innerText;
            var preDeptJobTitle = pSelectedRow[0].childNodes[2].innerText;
            var preDeptName1 = GetAttribute(pSelectedRow[0], "DATA11");
            var preDeptName2 = GetAttribute(pSelectedRow[0], "DATA12");
            var preWriterName1 = GetAttribute(pSelectedRow[0], "DATA9");
            var preWriterName2 = GetAttribute(pSelectedRow[0], "DATA10");
            var preDeptJobTitle1 = GetAttribute(pSelectedRow[0], "DATA13");
            var preDeptJobTitle2 = GetAttribute(pSelectedRow[0], "DATA14");

            if (trim(GetAttribute(pSelectedRow[0], "DATA7")) != "")
                if (trim(GetAttribute(pSelectedRow[0], "DATA7")).length > 1) {
                    var RtnVal = selectSubTitles(GetAttribute(pSelectedRow[0], "DATA2"));
                    if (RtnVal[0] == "OK") {
                        preDeptID = RtnVal[1];
                        preDeptName = RtnVal[2];
                        preDeptJobTitle = RtnVal[3];
                        preDeptName1 = RtnVal[4];
                        preDeptName2 = RtnVal[5];
                        preDeptJobTitle1 = RtnVal[6];
                        preDeptJobTitle2 = RtnVal[7];
                    }
                    else {
                        return;
                    }
                }
            pparsingXML = "<LISTVIEWDATA><HEADERS>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>30</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>60</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
            pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
            pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
            pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>"
            pparsingXML = pparsingXML + "<DATA4>" + GetAttribute(pSelectedRow[0], "DATA2") + "</DATA4>";
            pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
            pparsingXML = pparsingXML + "<DATA6>" + preDeptID + "</DATA6>";
            pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
            pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
            pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
            pparsingXML = pparsingXML + "<DATA10>" + selnode.GetNodeData("EXTENSIONATTRIBUTE2") + "</DATA10>";

            var tempName = getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[0].getElementsByTagName("NAME")[0]);

            var tempCode = "";
            for (i = 0; i < GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES")).length; i++) {
                if (getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[i].getElementsByTagName("CODE")[0]) == "019") {
                    tempName = getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[i].getElementsByTagName("NAME")[0]);
                    tempCode = "019"
                }
            }
            if (preDeptJobTitle == "" + strLang302 + "") {
                for (i = 0; i < GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES")).length; i++)
                    if (getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[i].getElementsByTagName("CODE")[0]) == "013")
                        tempName = getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[i].getElementsByTagName("NAME")[0]);
            }

            if (AprLineAddIndex > 1) {
                if (AprLineRow[0].cells[0].DATA11 == strAprType4 || AprLineRow[0].cells[0].DATA11 == strAprType3) {
                    pparsingXML = pparsingXML + "<DATA11>" + strAprType3 + "</DATA11>";
                }
                else {
                    if (tempCode != "019")
                        tempCode = getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[0].getElementsByTagName("CODE")[0]);
                    pparsingXML = pparsingXML + "<DATA11>" + tempCode + "</DATA11>";
                }
            }
            else {
                pparsingXML = pparsingXML + "<DATA11>" + "018" + "</DATA11>";

            }
            pparsingXML = pparsingXML + "<DATA12>" + strAprState1 + "</DATA12>";

            pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA9")) + "</DATA13>";		
            pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(GetAttribute(pSelectedRow[0], "DATA10")) + "</DATA14>";		
            pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(preDeptName1) + "</DATA15>";		
            pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(preDeptName2) + "</DATA16>";	
            pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(preDeptJobTitle1) + "</DATA17>";	
            pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(preDeptJobTitle2) + "</DATA18>";	

            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + pSelectedRow[0].childNodes[0].innerText + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(preDeptJobTitle) + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(preDeptName) + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + tempName + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + "" + strLang72 + "" + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL></CELL></ROW></ROWS></LISTVIEWDATA>";
        }
        else if (Mode == "DEPT") {
            pparsingXML = "<LISTVIEWDATA><HEADERS>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>30</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>50</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>60</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>80</WIDTH></HEADER>";
            pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
            pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
            pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
            pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
            pparsingXML = pparsingXML + "<DATA4>" + selnode.GetNodeData("CN") + "</DATA4>";
            pparsingXML = pparsingXML + "<DATA5>" + "Y" + "</DATA5>";
            pparsingXML = pparsingXML + "<DATA6>" + selnode.GetNodeData("CN") + "</DATA6>";
            pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
            pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
            pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
            pparsingXML = pparsingXML + "<DATA10>" + selnode.GetNodeData("EXTENSIONATTRIBUTE2") + "</DATA10>";

            if (pGamSaCount > 0 && pHapYuiCount <= 0) {
                pparsingXML = pparsingXML + "<DATA11>" + getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES"))[GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES")).length - 1].getElementsByTagName("CODE")[0]) + "</DATA11>";
            }
            else {
                pparsingXML = pparsingXML + "<DATA11>" + getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES"))[0].getElementsByTagName("CODE")[0]) + "</DATA11>";
            }
            pparsingXML = pparsingXML + "<DATA12>" + strAprState1 + "</DATA12>";

            pparsingXML = pparsingXML + "<DATA13>-</DATA13>";		
            pparsingXML = pparsingXML + "<DATA14>-</DATA14>";		
            pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(selnode.GetNodeData("DISPLAYNAME1")) + "</DATA15>";		
            pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(selnode.GetNodeData("DISPLAYNAME2")) + "</DATA16>";	
            pparsingXML = pparsingXML + "<DATA17>-</DATA17>";	
            pparsingXML = pparsingXML + "<DATA18>-</DATA18>";	

            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + "-" + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + "-" + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(selnode.GetNodeData("VALUE")) + "</VALUE>";

            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES"))[0].getElementsByTagName("NAME")[0]) + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL><CELL>";
            pparsingXML = pparsingXML + "<VALUE>" + "" + strLang72 + "" + "</VALUE>";
            pparsingXML = pparsingXML + "</CELL></ROW></ROWS></LISTVIEWDATA>";
        }
        Resultxml = loadXMLString(pparsingXML);

        var tr = pAPRLINE.GetSelectedRows();
        var InitTr = pAPRLINE.GetDataRows();
        var MaxID = 0;

        for (var j = 0  ; j < InitTr.length  ; j++) {
            var curnum = Number(pAPRLINE.GetSelectedRowID(j).substring(pAPRLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAPRLINE.GetSelectedRowID(j).length);
            if (MaxID < curnum)
                MaxID = curnum;
        }

        if (tr.length == 0 || InsertMode == "Add") {
            if (InitTr.length == 0) {
                if (document.getElementById("APRLINE").innerHTML != "")
                    document.getElementById("APRLINE").innerHTML = "";

                var pAPRLINE = new ListView();
                pAPRLINE.SetID("pAPRLINE");
                pAPRLINE.SetMulSelectable(false);
                pAPRLINE.SetRowOnClick("OnSelChange_onclick");
                pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
                pAPRLINE.SetSelectFlag(false);
                pAPRLINE.DataSource(Resultxml);
                pAPRLINE.DataBind("APRLINE");
                if (CrossYN()) {
                    pAPRLINE.GetDataRows()[0].cells[4].textContent = "" + strLang20 + "";
                }
                else {
                    pAPRLINE.GetDataRows()[0].cells[4].innerText = "" + strLang20 + "";
                }
            }
            else {
                var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));

                pAPRLINE.AddDataRow(objTr, Resultxml);
            }

            AprLineAddIndex = AprLineAddIndex + 1;
        }
        else {
            var idx = parseInt(pAPRLINE.GetSelectedIndexes().split(",")[0]);
            var selIdx = pAPRLINE.GetSelectedRows()[0].getAttribute("id");
            pAPRLINE.DeleteRow(selIdx);

            var objTr = pAPRLINE.NewAddRow(idx, selIdx);
            pAPRLINE.AddDataRow(objTr, Resultxml);
            pAPRLINE.SetSelectedID(selIdx);

        }
    }
    setRep_Suggester();
}


function ReporterCheck(RCheckVal, CurSelRow) {
    if (RCheckVal) {
        SetAttribute(CurSelRow[0], "DATA9", "Y");
    } else {
        SetAttribute(CurSelRow[0], "DATA9", "N");
    }
}


function SuggesterCheck(SCheckVal, CurSelRow) {
    if (SCheckVal) {
        SetAttribute(CurSelRow[0], "DATA8", "Y");
    } else {
        SetAttribute(CurSelRow[0], "DATA8", "N");
    }
}

function ChangeAprlineType(CheckGPerson) {
    try {
        document.getElementById("AprlineType").innerHTML = "";

        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("pAPRLINE");

        if (CheckGPerson == "group") {
            var selDeptID = GetAttribute(pAPRLINE.GetSelectedRows()[0], "DATA4");
            var p_AprlineValue = new Array();
            var i = 0;
            var j = 0;

            for (i = 0; i < SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE").length; i++) {
                if (pHapYuiCount != "0") {
                    p_AprlineValue[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "NAME");

                    j = j + 1;
                }
            }

            var p_Aprlinelen = p_AprlineValue.length;
            for (i = 0 ; i < p_Aprlinelen ; i++) {
                var p_Option = document.createElement("OPTION");

                p_Option.text = p_AprlineValue[i];
                p_Option.value = p_AprlineValue[i];

                if (i == 0)
                    p_Option.selected = true;

                if (CrossYN())
                    document.getElementById("AprlineType").appendChild(p_Option);
                else
                    document.getElementById("AprlineType").add(p_Option);

            }
        }
        else if (CheckGPerson == "user") {
            var selUserID = GetAttribute(pAPRLINE.GetSelectedRows()[0], "DATA4");
            var selUserSN = pAPRLINE.GetSelectedRows()[0].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "");
            var lastUserSN = pAPRLINE.GetDataRows()[0].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "");

            if (pAPRLINE.GetSelectedRows()[0].cells[4].innerText != "" + strLang14 + "") {
                var p_AprlineValue = new Array();
                var i = 0;
                var j = 0;
                var tempName = "";
                var tempCode = "";

                for (i = 0; i < GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES")).length; i++) {
                    tempName = getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[i].getElementsByTagName("NAME")[0]);
                    tempCode = getNodeText(GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/USERTYPES"))[i].getElementsByTagName("CODE")[0]);

                    switch (tempCode) {
                        case "001":		
                            if (selUserSN == lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        case "002":		
                            p_AprlineValue[j] = tempName;
                            j = j + 1;
                            break;

                        case "003":
                            if (selUserID != pUserID) {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        case "004":
                            if (selUserSN == lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        case "007":
                            if (pChamJoFlag == "Y" && pReDraftFlag != "GAMSABU") {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        case "008":
                            if (pHapYuiCount != "0" && selUserSN != "1" && selUserSN != lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        case "009":
                            if (pHapYuiCount != "0" && selUserSN != "1" && selUserSN != lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        case "016":
                            if (selUserSN == lastUserSN || selUserSN == (lastUserSN - 1)) {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        case "018":
                            if (selUserSN == "1") {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        case "019":
                            if (selUserSN != "1" && selUserSN != lastUserSN) {
                                p_AprlineValue[j] = tempName;
                                j = j + 1;
                            }
                            break;

                        default:
                            p_AprlineValue[j] = tempName;
                            j = j + 1;
                            break;
                    }
                }

                var p_Aprlinelen = p_AprlineValue.length;
                for (i = 0 ; i < p_Aprlinelen ; i++) {
                    var p_Option = document.createElement("OPTION");
                    p_Option.text = p_AprlineValue[i];
                    p_Option.value = p_AprlineValue[i];

                    if (i == 0)
                        p_Option.selected = true;

                    if (CrossYN())
                        document.getElementById("AprlineType").appendChild(p_Option);
                    else
                        document.getElementById("AprlineType").add(p_Option);

                }

                if (GetAttribute(pAPRLINE.GetSelectedRows()[0], "DATA9") == "Y") {
                    if (chkReporter)
                        Reporter.readOnly = true;
                    else
                        Reporter.readOnly = false;
                    Reporter.checked = true;
                }
                else {
                    if (chkReporter)
                        Reporter.readOnly = true;
                    else
                        Reporter.readOnly = false;
                    Reporter.checked = false;
                }

                if (GetAttribute(pAPRLINE.GetSelectedRows()[0], "DATA8") == "Y") {
                    if (chkSuggester)
                        Suggester.readOnly = true;
                    else
                        Suggester.readOnly = false;

                    Suggester.checked = true;
                }
                else {
                    if (chkSuggester)
                        Suggester.readOnly = true;
                    else
                        Suggester.readOnly = false;

                    Suggester.checked = false;
                }
            }
        }
    } catch (e) {
        alert("ChangeAprlineType :: " + e.description);
    }
}

function InitBtn_FunctionAbled() {
    document.getElementById("ReasonNoAprTxt").disabled = true;
    document.getElementById("ReasonNoApr").disabled = true;
    document.getElementById("AprlineType").disabled = true;
}

function APRLINESNDownFunction() {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");

        var pSelectedRow = pAPRLINE.GetSelectedRows();

        if (pSelectedRow.length != 0) {
            var p_NextSelRow = pAPRLINE.GetDataRows()[Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) + 1];
            if (p_NextSelRow != null) {
                var p_NextAprStat = p_NextSelRow.cells[5].innerText;
                p_NextAprStat = ConvertAprLineState(p_NextAprStat, "Code");

                if (p_NextSelRow.cells[4].innerText == "" + strLang20 + "") {
                    var pAlertContent = "" + strLang306 + "";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if ((pSelAprLineType == "003" || p_NextAprStat == "003") && pReDraftFlag == "DRAFT") {
                    var pAlertContent = "" + strLang307 + "";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else if (pReDraftFlag == "REDRAFT") {
                    if (pSelAprLineType == "002" || pSelAprLineType == "003" || pSelAprLineType == "004") {
                        Ans = true;
                        if (Ans) {
                            AprLineChangeType();
                            DoAprLineDown(pSelectedRow);
                            pReDraftAprLineChangeFlag = true;
                        }
                    }
                    else {
                        DoAprLineDown(pSelectedRow);
                    }
                }
                else {
                    if (pReDraftAprLineFlag)
                    {
                        if (((p_NextAprStat == "002" || p_NextAprStat == "005") && GetAttribute(p_NextSelRow, "DATA4") == pUserID || p_NextAprStat == "003"))
                        {
                            var pAlertContent = "" + strLang310 + "";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                        else {
                            DoAprLineDown(pSelectedRow);
                        }
                    }
                    else {
                        DoAprLineDown(pSelectedRow);
                    }
                }
            }
        }
    }
    catch (e) {
        alert("APRLINESNDownFunction :: " + e.description);
    }
}

function ChangeAprLineDown(CurSelRow, p_NextSelRow) {
    var p_NextAprStat = p_NextSelRow.cells[5].innerText;
    p_NextAprStat = ConvertAprLineState(p_NextAprStat, "Code");
    if ((pSelAprLineType == "003" || p_NextAprStat == "003") && pReDraftFlag == "DRAFT") {
        var pAlertContent = "" + strLang307 + "";
        OpenAlertUI(pAlertContent);
        return;
    }
    else if (pReDraftFlag == "REDRAFT") {
        if (pSelAprLineType == "002" || pSelAprLineType == "003" || pSelAprLineType == "004") {
            Ans = true;
            if (Ans) {
                AprLineChangeType();
                DoAprLineDown(CurSelRow);
                pReDraftAprLineChangeFlag = true;
            }
        }
        else {
            DoAprLineDown(CurSelRow);
        }
    }
    else {
        if (pReDraftAprLineFlag)
        {
            if ((p_NextAprStat == "002" && GetAttribute(p_NextSelRow, "DATA4") == pUserID))
            {
                var pAlertContent = "" + strLang311 + "";
                OpenAlertUI(pAlertContent);
                return;
            } else {
                DoAprLineDown(CurSelRow);
            }
        } else {
            DoAprLineDown(CurSelRow);
        }
    }
}

function DoAprLineDown(pSelectedRow) {
    try {
        var RowDownCheck;
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("pAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;

        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

        var CIndex = pSelectedIndex;
        var NIndex;
        var Rtnval = "N";

        NIndex = pSelectedIndex + 1;
        if (NIndex < pTotalRowsLen) {
            RowDownCheck = pTotalRows[NIndex].cells[0].innerText;
            if (CrossYN()) {
                pTotalRows[NIndex].childNodes[0].textContent = pTotalRows[CIndex].cells[0].innerText;
                pTotalRows[CIndex].childNodes[0].textContent = RowDownCheck;
            }
            else {
                pTotalRows[NIndex].cells[0].innerText = pTotalRows[CIndex].cells[0].innerText;
                pTotalRows[CIndex].cells[0].innerText = RowDownCheck;
            }

            Rtnval = "Y";
        }
        if (Rtnval == "Y") {
            pAPRLINE.RowMoveDown();
            var Row;

            for (i = 0; i < pTotalRows.length; i++) {
                Row = pTotalRows[i];
                if (Row) {
                    if (CrossYN()) {
                        Row.cells[0].textContent = Row.cells[0].innerText.replace("" + strLang75 + "", "")
                        Row.cells[0].textContent = Row.cells[0].innerText.replace("" + strLang76 + "", "")
                    }
                    else {
                        Row.cells[0].innerText = Row.cells[0].innerText.replace("" + strLang75 + "", "")
                        Row.cells[0].innerText = Row.cells[0].innerText.replace("" + strLang76 + "", "")
                    }

                    if (GetAttribute(Row, "DATA8") == "Y") {
                        if (CrossYN()) {
                            Row.cells[0].textContent = "" + strLang75 + "" + Row.cells[0].innerText
                        }
                        else {
                            Row.cells[0].innerText = "" + strLang75 + "" + Row.cells[0].innerText
                        }
                        chkSuggester = true;
                    }

                    if (GetAttribute(Row, "DATA9") == "Y") {
                        if (CrossYN()) {
                            Row.cells[0].textContent = "" + strLang76 + "" + Row.cells[0].innerText
                        }
                        else {
                            Row.cells[0].innerText = "" + strLang76 + "" + Row.cells[0].innerText
                        }

                        chkReporter = true;
                    }
                }
            }
        }
    } catch (e) {
        alert("DoAprLineDown :: " + e.description);
    }
}

function APRLINESNUPPERFunction() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("pAPRLINE");
        var pSelectedRows = pAPRLINE.GetSelectedRows();

        if (pSelectedRows.length != 0) {
            if (pSelectedRows[0].cells[4].innerText == "" + strLang20 + "") {
                var pAlertContent = "" + strLang306 + "";
                OpenAlertUI(pAlertContent);
                return;
            }

            if (pSelAprLineType == "003" && pReDraftFlag == "DRAFT")  
            {
                var pAlertContent = "" + strLang307 + "";
                OpenAlertUI(pAlertContent);
                return;
            }
            else if (pReDraftFlag == "REDRAFT")
            {
                if (pSelAprLineType == "002" || pSelAprLineType == "003" || pSelAprLineType == "004" || GetAttribute(pSelectedRows[0], "DATA4") == pUserID) {
                    Ans = true;
                    if (Ans) {
                        UpperAprLineSN(pSelectedRows);
                        AprLineChangeType();
                        pReDraftAprLineChangeFlag = true;
                    }
                } else {
                    UpperAprLineSN(pSelectedRows);
                }
            } else {
                if (pReDraftAprLineFlag)
                {
                    var TmpAprLineState = pSelectedRows[0].cells[5].innerText;
                    TmpAprLineState = ConvertAprLineState(TmpAprLineState, "Code");

                    if (((TmpAprLineState == "002" || TmpAprLineState == "005") && GetAttribute(pSelectedRows[0], "DATA4") == pUserID || pSelectedRows[0].cells[0].innerText == "1"))  //다음결재자가 결재선변경자인경우
                    {
                        var pAlertContent = "" + strLang310 + "";
                        OpenAlertUI(pAlertContent);
                        return;
                    } else {
                        UpperAprLineSN(pSelectedRows);
                    }
                } else {
                    UpperAprLineSN(pSelectedRows);
                }
            }
        }
    } catch (e) {
        alert("APRLINESNUPPERFunction :: " + e.description);
    }
}

function UpperAprLineSN(pSelectedRow) {
    try {
        var pAPRLINE = new ListView();     
        pAPRLINE.LoadFromID("pAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

        var RowUpCheck;
        var NIndex = pSelectedIndex - 1;
        var CIndex = pSelectedIndex;
        var Rtnval = "N";

        if (NIndex >= 0) {
            RowUpCheck = pTotalRows[NIndex].cells[0].innerText;
            if (CrossYN()) {
                pTotalRows[NIndex].childNodes[0].textContent = pTotalRows[CIndex].cells[0].innerText;
                pTotalRows[CIndex].childNodes[0].textContent = RowUpCheck;
            }
            else {
                pTotalRows[NIndex].cells[0].innerText = pTotalRows[CIndex].cells[0].innerText;
                pTotalRows[CIndex].cells[0].innerText = RowUpCheck;
            }
            Rtnval = "Y";
        }

        if (Rtnval == "Y") {
            pAPRLINE.RowMoveUp();

            var Row;
            for (i = 0; i < pTotalRows.length; i++) {
                Row = pTotalRows[i];
                if (Row) {
                    if (CrossYN()) {
                        Row.cells[0].textContent = Row.cells[0].innerText.replace("" + strLang75 + "", "")
                        Row.cells[0].textContent = Row.cells[0].innerText.replace("" + strLang76 + "", "")
                    }
                    else {
                        Row.cells[0].innerText = Row.cells[0].innerText.replace("" + strLang75 + "", "")
                        Row.cells[0].innerText = Row.cells[0].innerText.replace("" + strLang76 + "", "")
                    }

                    if (GetAttribute(Row, "DATA8") == "Y") {
                        if (CrossYN()) {
                            Row.cells[0].textContent = "" + strLang75 + "" + Row.cells[0].innerText
                        }
                        else {
                            Row.cells[0].innerText = "" + strLang75 + "" + Row.cells[0].innerText
                        }
                        chkSuggester = true;
                    }

                    if (GetAttribute(Row, "DATA9") == "Y") {
                        if (CrossYN()) {
                            Row.cells[0].textContent = "" + strLang76 + "" + Row.cells[0].innerText
                        }
                        else {
                            Row.cells[0].innerText = "" + strLang76 + "" + Row.cells[0].innerText
                        }

                        chkReporter = true;
                    }
                }
            }
        }

    } catch (e) {
        alert("UpperAprLineSN :: " + e.description);
    }
}

function APRLINEATTENDERDELFunction() {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");
        var pSelectedRow = pAPRLINE.GetSelectedRows();

        if (pSelectedRow.length != 0 && pSelectedRow != null && pAPRLINE.GetSelectedIndexes().split(',')[0] != -1) {
            if (pSelAprLineType == "003" && pReDraftFlag == "DRAFT")  
            {
                var pAlertContent = "" + strLang315 + "";
                OpenAlertUI(pAlertContent);
                return;
            }
            else if (pReDraftFlag == "REDRAFT")
            {
                var pDraftSN = pSelectedRow[0].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "");
                if (pSelAprLineType == "002" || pSelAprLineType == "003" || pSelAprLineType == "004" || pDraftSN == "1") {
                    Ans = true;
                    if (Ans)
                    {
                        AprLineChangeType();
                        DoDelete(pSelectedRow);
                        pReDraftAprLineChangeFlag = true;
                    }
                } else {
                    DoDelete(pSelectedRow);
                }
            } else {
                if (pReDraftAprLineFlag)
                {
                    var TmpAprLineState = pSelectedRow[0].cells[5].innerText;
                    TmpAprLineState = ConvertAprLineState(TmpAprLineState, "Code");
                    if ((TmpAprLineState == "002" || TmpAprLineState == "005") && GetAttribute(pSelectedRow[0], "DATA4").toLowerCase() == pUserID.toLowerCase() || pSelectedRow[0].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "") == "1") {
                        var pAlertContent = "" + strLang317 + "";
                        OpenAlertUI(pAlertContent);
                        return;
                    } else {
                        DoDelete(pSelectedRow)
                    }
                } else {
                    DoDelete(pSelectedRow)
                }
            }
        }
    } catch (e) {
        alert("APRLINEATTENDERDELFunction :: " + e.description);
    }
}

function DoDelete(pSelectedRow) {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

        var RowDelCheck;
        var Rtnval = "N";
        TIndex = pTotalRows.length;
        NIndex = pSelectedIndex;

        for (i = 0 ; i <= NIndex ; i++) {
            if (CrossYN()) {
                pTotalRows[i].cells[0].textContent = pTotalRows[i].cells[0].innerText.replace("" + strLang75 + "", "");
                pTotalRows[i].cells[0].textContent = pTotalRows[i].cells[0].innerText.replace("" + strLang76 + "", "");

                RowDelCheck = pTotalRows[i].cells[0].innerText;
                pTotalRows[i].cells[0].textContent = RowDelCheck - 1;
            }
            else {
                pTotalRows[i].cells[0].innerText = pTotalRows[i].cells[0].innerText.replace("" + strLang75 + "", "");
                pTotalRows[i].cells[0].innerText = pTotalRows[i].cells[0].innerText.replace("" + strLang76 + "", "");

                RowDelCheck = pTotalRows[i].cells[0].innerText;
                pTotalRows[i].cells[0].innerText = RowDelCheck - 1;
            }
            Rtnval = "Y";
        }

        if (Rtnval == "Y") {
            var selIdx = pAPRLINE.GetSelectedRows()[0].getAttribute("id");
            pAPRLINE.DeleteRow(selIdx);

            document.getElementById("AprlineType").innerHTML = "";
            document.getElementById("AprlineType").disabled = true;

        }
    } catch (e) {
        alert("DoDelete :: " + e.description);
    }
}

function DoDeleteGamsa(GamsaType, GamsaType2) {
    try {
        var pTotalRows = APRLINE.Rows;
        for (i = pTotalRows.length - 1 ; i >= 0 ; i--) {
            if (pTotalRows.item(i).cells(4).innerText == GamsaType || pTotalRows.item(i).cells(4).innerText == GamsaType2) {
                pTotalRows.item(i).Remove();
            }
        }
    }
    catch (e) {
        alert("DoDelete :: " + e.description);
    }
}


function APRLINEATTENDCLICKFunction() {
    var pCurSel = window.event.result;
    pSelAprLineType = pCurSel.cells(4).innerText;
    pSelAprLineType = ConvertAprLineState(pSelAprLineType, "Code");
    CheckAprLineType(pCurSel);
}

function CheckAprLineType(pCurSel) {
    var pAprLineTypeLen = document.getElementById("AprlineType").length;
    var i;
    var TmpAprLineType = pCurSel[0].cells[4].innerText;
    TmpAprLineType = ConvertAprLineType(TmpAprLineType, "Code");

    if (TmpAprLineType == "002") {
        var TmpAprLineType1 = "001";
        TmpAprLineType1 = ConvertAprLineState(TmpAprLineType1, "Value");

    }

    for (i = 0 ; i < pAprLineTypeLen ; i++) {
        if (AprLineType(i).value == pCurSel.cells(4).innerText) {
            if (!AprLineType(i).disabled) {
                AprLineType(i).checked = true;
                break;
            }
        }
    }

    if (pSelAprLineType == "003" && pReDraftFlag == "DRAFT")
    {
        for (i = 0 ; i < pAprLineTypeLen ; i++)
            AprLineType(i).disabled = true;
    }
    else if (pSelAprLineType != "003" && pReDraftFlag == "DRAFT")
    {
        if (pReDraftAprLineFlag)
        {
            if (pSelAprLineType == "002" && pCurSel.cells(0).DATA4 == pUserID)
            {
                for (i = 0 ; i < pAprLineTypeLen ; i++)
                    AprLineType(i).disabled = true;
            } else {
                for (i = 0 ; i < pAprLineTypeLen ; i++)
                    AprLineType(i).disabled = false;
                CheckDocCellInfoAprLineType();
            }
        } else {
            for (i = 0 ; i < pAprLineTypeLen ; i++)
                AprLineType(i).disabled = false;
            CheckDocCellInfoAprLineType();
        }
    } else {
        for (i = 0 ; i < pAprLineTypeLen ; i++)
            if (!AprLineType(i).disabled)
                AprLineType(i).disabled = false;
    }
}

function APRLINEATTENDADDFunction(pCurSelectedRow, Mode) {
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("pAPRLINE");

    var pCurSelRow = pAPRLINE.GetSelectedRows(); 

    var treeView = new TreeView(); 
    treeView.LoadFromID("FromTreeView");

    var selnode = treeView.GetSelectNode();
    if (pCurSelectedRow == null) {
        if (Mode == "PERSON") {
            var pCurSelectedRow = pCurSelRow[0];
            if (companyID != selnode.GetNodeData("EXTENSIONATTRIBUTE2"))
            {
                var pAlertContent = strLang250 + "<br> " + strLang251;
                OpenAlertUI(pAlertContent);
            }
        }
        else if (Mode == "DEPT") {
            var pCurSelectedRow = selnode;
            var pAlertContent = strLang250 + "<br> " + strLang251;
            OpenAlertUI(pAlertContent);
        }
    }

    
    var p_PrevAprStat = "";
    if (pCurSelRow.length != 0) {
        var p_PrevRow = null;//
        if (p_PrevRow != null) {
            var p_PrevAprStat = p_PrevRow[5].innerText;
            p_PrevAprStat = ConvertAprLineState(p_PrevAprStat, "Code");
        }
    }
    if (p_PrevAprStat == "003" && pReDraftFlag == "DRAFT")    
    {
        var pAlertContent = "" + strLang293 + "";
        OpenAlertUI(pAlertContent);
    }
    else if (pReDraftFlag == "REDRAFT")
    {
        if (p_PrevAprStat == "003" || p_PrevAprStat == "004" || p_PrevAprStat == "002") {
            AprLineChangeType();
            AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
            pReDraftAprLineChangeFlag = true;
        } else {
            AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
        }
    } else {
        if (pReDraftAprLineFlag)
        {
            if (p_PrevRow != null)
            {
                if (p_PrevAprStat == "002" && GetAttribute(p_PrevRow[0], "DATA4") == pUserID) {
                    var pAlertContent = "" + strLang319 + "";
                    OpenAlertUI(pAlertContent);
                } else {
                    AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
                }
            } else {
                AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
            }
        } else {
            AprLineAddUser(Mode, pCurSelRow, pCurSelectedRow);
        }
    }
}

function APRLINEATTENDSAVEFunction() {
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("pAPRLINE");

    var Listlen = pAPRLINE.GetDataRows();

    if (Listlen.length == 0) {
        var pAlertContent = "" + strLang320 + "";
        OpenAlertUI(pAlertContent);
    } else {
        ReDraftSaveAprLine();
    }
}

function ReDraftSaveAprLine() {
    if (pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "WHOKYUL") {
        if (pReDraftAprLineFlag) {
            AlterAprLineType();
        }

        if (pReDraftFlag == "SUSIN" && chkReDraft == "REDRAFT" && !pReDraftAprLineFlag)
            AprLineChangeType();

        SaveAprLineInfo();
    }
    else if (pReDraftFlag == "REDRAFT") {
        if (!pReDraftAprLineChangeFlag) {
            Ans = true;
            if (Ans) {
                AprLineChangeType();
                SaveAprLineInfo();
                pReDraftAprLineChangeFlag = true;
            }
            else {
                AprLineBanSongChangeType();
                SaveAprLineInfo();
            }
        }
        else {
            SaveAprLineInfo();
        }
        if (pReDraftAprLineChangeFlag) {
            pAprLineXml[2] = "R";
        }
        else {
            pAprLineXml[2] = "C";
        }
    }
}

function AlterAprLineType() {

    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("pAPRLINE");

    var pAprRow = pAPRLINE.GetDataRows();
    var pAprRowLen = pAprRow.length;

    var i;
    var TmpAprLineStateReady;
    var TmpAprLineStateJinhang;

    TmpAprLineStateReady = "001";
    TmpAprLineStateReady = ConvertAprLineState(TmpAprLineStateReady, "Value")

    TmpAprLineStateJinhang = "002";
    TmpAprLineStateJinhang = ConvertAprLineState(TmpAprLineStateJinhang, "Value")

    for (i = 0 ; i < pAprRowLen ; i++) {
        var TmpAprLineState = pAprRow[i].cells[5].innerText;
        TmpAprLineState = ConvertAprLineState(TmpAprLineState, "Code");
        if (TmpAprLineState != "003" && TmpAprLineState != "000")
        {
            if (CrossYN()) {
                pAprRow[i].cells[5].textContent = TmpAprLineStateReady;
            }
            else {
                pAprRow[i].cells[5].innerText = TmpAprLineStateReady;
            }

        } else {
            if (CrossYN()) {
                pAprRow[i - 1].cells[5].textContent = TmpAprLineStateJinhang;
            }
            else {
                pAprRow[i - 1].cells[5].innerText = TmpAprLineStateJinhang;
            }

            break;
        }
    }
}
function SaveAprLineInfo() {
    SaveAprLineList();  
}


function SaveAprLineList() {
    var Resultxml = APRLINEXMLParsing();
    if (Resultxml != "FALSE") {

        xmlhttp.open("Post", "aspx/aprlinesave.aspx", false);
        xmlhttp.send(Resultxml);

        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        var ret = getNodeText(dataNodes[0]);

        if (ret == "TRUE") {
            window.returnValue = pAprLineXml;
            window.close();
        } else {
            alert(strLang326);
        }
    }
}

function APRLINEXMLParsing() {
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("pAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;
    var CurCellLen = AprLineRow[0].cells.length;

    var i;
    var j;
    var k = 0;
    var GetXml;
    var AprLineTotalLen;
    var pAprTypeFlag = "001";
    pAprTypeFlag = ConvertAprLineType(pAprTypeFlag, "Value");

    pDraftUser = CheckDraftUser(pAprTypeFlag);
    if (!pDraftUser && !pReDraftAprLineFlag) {
        var pAlertContent = "" + strLang327 + "<br>" + strLang328 + "";
        OpenAlertUI(pAlertContent);
        return "FALSE";
    }

    if (!pDraftUser && !pReDraftAprLineFlag)
    {
        AprLineTotalLen = CurListLen + 1;
    } else {
        AprLineTotalLen = CurListLen;
    }

    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang331 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang29 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang32 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang61 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang125 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang332 + "</NAME><WIDTH>120</WIDTH></HEADER><HEADER><NAME>" + strLang333 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>";
    GetXml = GetXml + "<ROWS>";

    var addWhokyul = chkWhokyulAddChk();
    if (addWhokyul) {
        AprLineTotalLen = AprLineTotalLen + 1
    }

    for (i = 0 ; i < CurListLen ; i++) {
        if (i == 0 && GetAttribute(AprLineRow[i], "DATA11") != strAprType15) {
            if (addWhokyul) {
                DraftXml = addGamsabu(AprLineTotalLen - k, "" + strLang14 + "", false, "" + strLang72 + "");
                GetXml = GetXml + DraftXml;
                k = k + 1;
            }
        }
        GetXml = GetXml + "<ROW>";
        GetXml = GetXml + "<COLUMN>" + (AprLineTotalLen - k) + "</COLUMN>";
        for (j = 1 ; j < CurCellLen - 1; j++)
            GetXml = GetXml + "<COLUMN>" + MakeXMLString(AprLineRow[i].cells[j].innerText) + "</COLUMN>";

        switch (pReDraftFlag) {
            case "REDRAFT":

                GetXml = GetXml + "<DATA name='ProcessDate'></DATA>";
                GetXml = GetXml + "<DATA name='ReceivedDate'></DATA>";
                break;

            default:

                if (chkReDraft == "REDRAFT") {
                    GetXml = GetXml + "<DATA name='ProcessDate'></DATA>";
                    GetXml = GetXml + "<DATA name='ReceivedDate'></DATA>";
                }
                else {
                    GetXml = GetXml + "<DATA name='ProcessDate'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA1")) + "</DATA>";
                    GetXml = GetXml + "<DATA name='ReceivedDate'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA2")) + "</DATA>";
                }
                break;
        }


        if (trim_Cross(GetAttribute(AprLineRow[i], "DATA3")) != "") {
            GetXml = GetXml + "<DATA name='DocID'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA3")) + "</DATA>";
        } else {
            GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
        }
        GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA4")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA5")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA6")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA7")) + "</DATA>";
        GetXml = GetXml + "<DATA name='isProposerYN'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA8")) + "</DATA>";
        GetXml = GetXml + "<DATA name='isBriefUserYN'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA9")) + "</DATA>";
        GetXml = GetXml + "<DATA name='isCompanyID'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA10")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprType'>" + GetAttribute(AprLineRow[i], "DATA11") + "</DATA>";

        if (pReDraftFlag == "REDRAFT" && (CurListLen - 1) == i)
            GetXml = GetXml + "<DATA name='AprState'>" + strAprState2 + "</DATA>";
        else
            GetXml = GetXml + "<DATA name='AprState'>" + GetAttribute(AprLineRow[i], "DATA12") + "</DATA>";

        GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA13")) + "</DATA>";		
        GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA14")) + "</DATA>";		
        GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA15")) + "</DATA>";		
        GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA16")) + "</DATA>";	
        GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA17")) + "</DATA>";	
        GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(GetAttribute(AprLineRow[i], "DATA18")) + "</DATA>";	

        GetXml = GetXml + "</ROW>";

        k = k + 1;
    }

    if (!pDraftUser && !pReDraftAprLineFlag) {
        var DraftXml;
        DraftXml = AddDraftUser("1", "" + strLang22 + "", true, "" + strLang18 + "");
        GetXml = GetXml + DraftXml;
    }
    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
    pAprLineXml[0] = GetXml;

    if (pDraftUser && !pReDraftAprLineFlag) {
        var TmpAprLineState = strAprState2;
        var TmpAprLineStateName = strLangAprState2;
        if (pReDraftAprLineChangeFlag) {
            var ChangeXml = createXmlDom();
            ChangeXml = loadXMLString(GetXml);
            var NodeList = SelectNodes(ChangeXml, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0) {
                var pDraftDay = getGyulJeDate();
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[17], TmpAprLineState);
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[5], TmpAprLineStateName);
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[7], pDraftDay);
                pAprLineXml[0] = getXmlString(ChangeXml);
            }
        }
        else if (pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "HABYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "WHOKYUL") {
            var ChangeXml = createXmlDom();
            ChangeXml = loadXMLString(GetXml);
            var NodeList = SelectNodes(ChangeXml, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0) {
                var pDraftDay = getGyulJeDate();
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[17], TmpAprLineState);
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[5], TmpAprLineStateName);
                setNodeText(GetChildNodes(NodeList[(NodeList.length - 1)])[7], pDraftDay);

                pAprLineXml[0] = getXmlString(ChangeXml);
            }
        }
    }

    return pAprLineXml[0];
}

function chknoApproval() {
    var chkFlag = false;
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("pAPRLINE");

    var Row = APRLINE.GetSelectedRows();
    var totalRow = APRLINE.GetDataRows();
    if (Row) {
        if (Row[0].cells[4].innerText == "" + strLang74 + "") {
            if (trim(document.getElementById("ReasonNoAprTxt").value) != "")
                SetAttribute(Row[0], "DATA7", document.getElementById("ReasonNoAprTxt").value);
        }
    }

    var i;
    for (i = 0; i < totalRow.length; i++) {
        if (totalRow[i].cells[4].innerText == strAprType3 && trim_Cross(GetAttribute(totalRow[i], "DATA7")) == "") {
            var pAlertContent = totalRow[i].cells[1].innerText + "" + strLang334 + "";
            OpenAlertUI(pAlertContent);
            chkFlag = true;
        }
    }
    return chkFlag;
}

function chkWhokyulAddChk() {
    if (pGamSaCount == 0) return false;
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("pAPRLINE");

    var listRows = APRLINE.GetDataRows();
    var listLength = listRows.length

    var sunkyulFlag = false
    var isChifFlag = false
    var whokyulFlag = false

    var i;
    for (i = 0; i < listLength; i++) {
        if (listRows[i].cells[4].innerText == "" + strLang14 + "" && !whokyulFlag) whokyulFlag = true;
        if (listRows[i].cells[4].innerText == "" + strLang288 + "" && !sunkyulFlag) sunkyulFlag = true;
        if (!isChifFlag) {
            if (GetAttribute(listRows[i], "DATA5") == "Y") continue;
        }
    }

    if (!sunkyulFlag && isChifFlag && !whokyulFlag) return true;
    else return false;
}

function APRLINETEMPLETXMLParsing() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("pAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;
    var CurCellLen = AprLineRow[0].cells.length;

    var i;
    var j;
    var k = 0;
    var GetXml;
    var AprLineTotalLen;
    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang331 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang29 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang32 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang61 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang125 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang332 + "</NAME><WIDTH>120</WIDTH></HEADER><HEADER><NAME>" + strLang333 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>";
    GetXml = GetXml + "<ROWS>";

    for (i = 0 ; i < CurListLen ; i++) {
        var tr = AprLineRow[i];
        GetXml = GetXml + "<ROW>";

        for (j = 0 ; j < CurCellLen - 1 ; j++) {
            colVal = tr.cells[j].innerText.replace("" + strLang75 + "", "");
            colVal = colVal.replace("" + strLang76 + "", "");
            GetXml = GetXml + "<COLUMN>" + MakeXMLString(colVal) + "</COLUMN>";
        }

        GetXml = GetXml + "<DATA name='ProcessDate'>" + MakeXMLString(GetAttribute(tr, "DATA1")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReceivedDate'>" + MakeXMLString(GetAttribute(tr, "DATA2")) + "</DATA>";

        if (GetAttribute(tr, "DATA3") != "") {
            GetXml = GetXml + "<DATA name='DocID'>" + MakeXMLString(GetAttribute(tr, "DATA3")) + "</DATA>";
        } else {
            GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
        }
        GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(GetAttribute(tr, "DATA4")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + MakeXMLString(GetAttribute(tr, "DATA5")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(GetAttribute(tr, "DATA6")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + MakeXMLString(GetAttribute(tr, "DATA7")) + "</DATA>";
        GetXml = GetXml + "<DATA name='isProposerYN'>" + MakeXMLString(GetAttribute(tr, "DATA8")) + "</DATA>";
        GetXml = GetXml + "<DATA name='isBriefUserYN'>" + MakeXMLString(GetAttribute(tr, "DATA9")) + "</DATA>";
        GetXml = GetXml + "<DATA name='isCompanyID'>" + GetAttribute(tr, "DATA10") + "</DATA>";
        GetXml = GetXml + "<DATA name='AprType'>" + GetAttribute(tr, "DATA11") + "</DATA>";
        GetXml = GetXml + "<DATA name='AprState'>A04001</DATA>";
        GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(GetAttribute(tr, "DATA13")) + "</DATA>";		
        GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(GetAttribute(tr, "DATA14")) + "</DATA>";		
        GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(GetAttribute(tr, "DATA15")) + "</DATA>";		
        GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(GetAttribute(tr, "DATA16")) + "</DATA>";	
        GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(GetAttribute(tr, "DATA17")) + "</DATA>";	
        GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(GetAttribute(tr, "DATA18")) + "</DATA>";	
        GetXml = GetXml + "</ROW>";
    }
    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";

    return GetXml;
}

function AddDraftUser(pSN, pAprType, pDraftDayFlag, pAprState) {
    var GetXml;
    var pDraftDay = "";
    if (pDraftDayFlag)
        pDraftDay = getGyulJeDate();

    GetXml = "<ROW>";
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(pSN) + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(arr_userinfo[2]) + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(arr_userinfo[3]) + "</COLUMN>";
    
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(arr_userinfo[5]) + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(pAprType) + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(pAprState) + "</COLUMN>";
    GetXml = GetXml + "<DATA name='ProcessDate'>" + "" + "</DATA>";
    GetXml = GetXml + "<DATA name='ReceivedDate'>" + MakeXMLString(pDraftDay) + "</DATA>";
    GetXml = GetXml + "<DATA name='DocID'>" + MakeXMLString(pDocID) + "</DATA>";
    GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(pUserID) + "</DATA>";
    GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + "N" + "</DATA>";
    GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(arr_userinfo[4]) + "</DATA>";
    GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + "" + "</DATA>";
    GetXml = GetXml + "<DATA name='isProposerYN'>" + "N" + "</DATA>";
    GetXml = GetXml + "<DATA name='isBriefUserYN'>" + "N" + "</DATA>";
    GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(arr_userinfo[11]) + "</DATA>";		
    GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(arr_userinfo[12]) + "</DATA>";		
    GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(arr_userinfo[15]) + "</DATA>";	
    GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(arr_userinfo[16]) + "</DATA>";	
    GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(arr_userinfo[13]) + "</DATA>";	
    GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(arr_userinfo[14]) + "</DATA>";	
    GetXml = GetXml + "</ROW>";
    return GetXml;
}

function AddDraftUserFirst() {
    var pparsingXML;
    pparsingXML = "<LISTVIEWDATA><HEADERS>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>30</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>60</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + "1" + "</VALUE>";
    pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
    pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
    pparsingXML = pparsingXML + "<DATA3>" + "" + "</DATA3>";
    pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(arr_userinfo[1]) + "</DATA4>";
    pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
    pparsingXML = pparsingXML + "<DATA6>" + MakeXMLString(arr_userinfo[4]) + "</DATA6>";
    pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
    pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
    pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
    pparsingXML = pparsingXML + "<DATA10>" + MakeXMLString(companyID) + "</DATA10>";
    pparsingXML = pparsingXML + "<DATA11>" + strAprType18 + "</DATA11>";
    pparsingXML = pparsingXML + "<DATA12>" + strAprState1 + "</DATA12>";
    pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(arr_userinfo[11]) + "</DATA13>";		
    pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(arr_userinfo[12]) + "</DATA14>";		
    pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(arr_userinfo[15]) + "</DATA15>";		
    pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(arr_userinfo[16]) + "</DATA16>";		
    pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(arr_userinfo[13]) + "</DATA17>";		
    pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(arr_userinfo[14]) + "</DATA18>";		

    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[2]) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[3]) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(arr_userinfo[5]) + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + "" + strLang20 + "" + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + "" + strLang72 + "" + "</VALUE>";
    pparsingXML = pparsingXML + "</CELL><CELL></CELL></ROW></ROWS></LISTVIEWDATA>";

    return pparsingXML;
}

function addGamsabu(pSN, pAprType, pDraftDayFlag, pAprState) {
    var GetXml;
    var pDraftDay = "";
    if (pDraftDayFlag)
        pDraftDay = getGyulJeDate();

    var GamsabuName = getDeptInfo_nodName(optGamsabu, "DisplayName");
    var GamsabuName1 = getDeptInfo_nodName(optGamsabu, "DisplayName1");
    var GamsabuName2 = getDeptInfo_nodName(optGamsabu, "DisplayName2");
    GetXml = "<ROW>";
    GetXml = GetXml + "<COLUMN>" + pSN + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(GamsabuName) + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(GamsabuName) + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + MakeXMLString(GamsabuName) + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + pAprType + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + pAprState + "</COLUMN>";
    GetXml = GetXml + "<DATA name='ProcessDate'>" + "" + "</DATA>";
    GetXml = GetXml + "<DATA name='ReceivedDate'>" + pDraftDay + "</DATA>";
    GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
    GetXml = GetXml + "<DATA name='AprMemberID'>" + optGamsabu + "</DATA>";
    GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + "Y" + "</DATA>";
    GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + optGamsabu + "</DATA>";
    GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + "" + "</DATA>";
    GetXml = GetXml + "<DATA name='isProposerYN'>" + "N" + "</DATA>";
    GetXml = GetXml + "<DATA name='isBriefUserYN'>" + "N" + "</DATA>";

    GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(GamsabuName1) + "</DATA>";		
    GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(GamsabuName2) + "</DATA>";		
    GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(GamsabuName1) + "</DATA>";	
    GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(GamsabuName2) + "</DATA>";	
    GetXml = GetXml + "<DATA name='PMemberJobTitle'></DATA>";	
    GetXml = GetXml + "<DATA name='SMemberJobTitle'></DATA>";	
    GetXml = GetXml + "</ROW>";
    return GetXml;
}

function CheckSignCellValue() {
    return true;
}

function CheckSignCellValueLast() {
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("pAPRLINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    var CurListLen = AprLineRow.length;

    if (CurListLen <= 0) {
        OpenAlertUI("" + strLang335 + "<br>" + strLang336 + "");
        return false;
    }

    var pCurDraft = 0;
    var pCurSign = 0;
    var pCurAprove = 0;
    var pCurJunkyul = 0;
    var pCurDekyul = 0;
    var pCurHapyui = 0;
    var pCurGamsa = 0;
    var i;
    var pCurSignFlag = false;
    var pCurHSignFlag = false;
    var pCurGamsaFlag = false;

    var pFirstAprType = GetAttribute(AprLineRow[CurListLen - 1], "DATA11");
    for (i = 0 ; i < CurListLen ; i++) {
        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType18)
            pCurDraft = pCurDraft + 1;
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType19)
            pCurSign = pCurSign + 1;
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType13)
            pCurGamsa = pCurGamsa + 1;
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType1) {
            pCurAprove = pCurAprove + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            if (pCurGamsa > 0)
                pCurGamsaFlag = true;
        }
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType16) {
            pCurDekyul = pCurDekyul + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            if (pCurGamsa > 0)
                pCurGamsaFlag = true;
        }
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType4) {
            pCurJunkyul = pCurJunkyul + 1;
            if (pCurSign > 0)
                pCurSignFlag = true;
            if (pCurHapyui > 0)
                pCurHSignFlag = true;
            if (pCurGamsa > 0)
                pCurGamsaFlag = true;
        }
        else if (GetAttribute(AprLineRow[i], "DATA11") == strAprType9 || GetAttribute(AprLineRow[i], "DATA11") == strAprType8 || GetAttribute(AprLineRow[i], "DATA11") == strAprType11 || GetAttribute(AprLineRow[i], "DATA11") == strAprType12)
            pCurHapyui = pCurHapyui + 1;
    }

    var pAlertContent = "";
    if ((pCurDraft + pCurSign + pCurAprove + pCurDekyul + pCurJunkyul + pCurGamsa) > pSignCount) {
        pAlertContent = pAlertContent + "" + strLang349 + "" + pSignCount + "" + strLang350 + "<br>";
    }

    if (pCurHapyui > pHapYuiCount) {
        pAlertContent = pAlertContent + "" + strLang351 + "" + pHapYuiCount + "" + strLang350 + "<br> ";
    }

    if (pCurAprove >= 1 && (pCurDekyul >= 1 || pCurJunkyul >= 1)) {
        pAlertContent = pAlertContent + "" + strLang352 + "<br> ";
    }

    if (pCurAprove > 1) {
        pAlertContent = pAlertContent + "" + strLang353 + "<br> ";
    }

    if (pCurDekyul > 1) {
        pAlertContent = pAlertContent + "" + strLang354 + "<br> ";
    }

    if (pCurGamsa > 1) {
        pAlertContent = pAlertContent + "" + strLang355 + "<br> ";
    }

    if (pCurAprove == 0 && pCurDekyul == 0 && pCurJunkyul == 0) {
        pAlertContent = pAlertContent + "" + strLang356 + "<br> ";
    }

    if (pCurDekyul > 0 && pCurJunkyul > 0)
    {
        if (AprLineRow[0].cells[4].innerText == "" + strLang7 + "") {
            pAlertContent = pAlertContent + "" + strLang358 + "<br> ";
        }
    }

    if (pCurSignFlag) {
        pAlertContent = pAlertContent + "" + strLang359 + "<br> ";
    }

    if (pCurHSignFlag) {
        pAlertContent = pAlertContent + "" + strLang360 + "<br> ";
    }

    if (pCurGamsaFlag) {
        pAlertContent = pAlertContent + "" + strLang361 + "<br> ";
    }

    if (pFirstAprType != strAprType18 && pFirstAprType != strAprType1 && pFirstAprType != strAprType4 && pFirstAprType != strAprType16)
        pAlertContent = pAlertContent + "" + strLang362 + "" + ConvertAprLineType(pFirstAprType, "Value") + "" + strLang363 + "<br> ";

    var pChkFlag = CheckDraftDeptID(AprLineRow);
    if (!pChkFlag)
        pAlertContent = pAlertContent + " " + strLang364 + "<br>";

    if (pAlertContent != "") {
        pAlertContent = pAlertContent + "" + strLang336 + "";
        OpenAlertUI(pAlertContent);
        return false;
    }

    if (pCurSign >= 3) {
        var pInformationContent = "" + strLang365 + "<br>" + strLang366 + "";
        var Ans = OpenInformationUI(pInformationContent);
        if (!Ans)
            return false;
    }

    return true;
}

function CheckHapYuiCellValue() {
    try {
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");

        var AprLineRow = pAPRLINE.GetDataRows();
        var CurListLen = AprLineRow.length;
        var CurAprLen = 0;
        var pCurAprDeptLen = 0;
        var pAprTypeFlag = "008";
        pAprTypeFlag = ConvertAprLineType(pAprTypeFlag, "Value");
        CurAprLen = getAprLineGyulJeLen(AprLineRow, CurListLen, pAprTypeFlag);

        pAprTypeFlag = "012";
        pAprTypeFlag = ConvertAprLineType(pAprTypeFlag, "Value");
        pCurAprDeptLen = getAprLineGyulJeLen(AprLineRow, CurListLen, pAprTypeFlag);

        if (pHapYuiCount == "0") {
            var pAlertContent = "" + strLang369 + "<br>  " + strLang371 + "";
            OpenAlertUI(pAlertContent);
            return false;
        }
        return true;
    } catch (e) {
        alert("CheckHapYuiCellValue :: " + e.description);
    }
}

function getAprLineGyulJeLen(AprLineRow, CurListLen, pAprTypeFlag) {
    pTotalIndex = 0;
    var i;
    for (i = 0 ; i < CurListLen ; i++) {
        if (AprLineRow[i].cells[4].innerText == pAprTypeFlag)
            pTotalIndex = pTotalIndex + 1;
    }
    return pTotalIndex;
}

function chkWakin(AprLineRow) {
    var startHapyui;
    var cnt_Wakin;
    var i;
    var rowLength = AprLineRow.length - 1;
    var rtnVal;
    cnt_Wakin = 0;
    startHapyui = false;
    rtnVal = true;

    for (i = rowLength; i >= 0; i--) {
        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType9) {
            if (!startHapyui) startHapyui = true;
            else {
                if (cnt_Wakin > 0) {
                    rtnVal = false;
                    break;
                }
            }
        }

        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType2) {
            if (!startHapyui) {
                rtnVal = false;
                break;
            }
            else
                cnt_Wakin = cnt_Wakin + 1;
        }
    }
    return rtnVal;
}

function chkJunkyul(AprLineRow) {
    var afterApr;
    var afterAprflag;
    var i;
    var rtnVal;
    afterApr = 0;
    afterAprflag = false;
    rtnVal = true;

    for (i = AprLineRow.length - 1; i >= 0; i--) {
        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType4) {
            afterAprflag = true;
        }
        if (afterAprflag) 
        {
            if (GetAttribute(AprLineRow[i], "DATA11") == strAprType3)
                afterApr = afterApr + 1;
        }
    }

    if (afterAprflag) {
        if (afterApr > 0) {
            rtnVal = true;
        }
        else {
            rtnVal = false;
        }
    }
    return rtnVal;
}

function chkbeforeGamSa(AprLineRow) {
    var afterApr;
    var afterAprflag;
    var i;
    var rtnVal;
    afterApr = 0;
    afterAprflag = false;
    rtnVal = true;

    for (i = AprLineRow.length - 1; i >= 0; i--) {
        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType13) {
            afterAprflag = true;
        }

        if (afterAprflag)
        {
            if (GetAttribute(AprLineRow[i], "DATA11") == strAprType15 || GetAttribute(AprLineRow[i], "DATA11") == strAprType13) afterApr = 0;
            else
                afterApr = afterApr + 1;
        }
    }

    if (afterAprflag) {
        if (afterApr > 0) rtnVal = true;
        else
            rtnVal = false;
    }
    return rtnVal
}

function chkafterdeptHabyui(AprLineRow) {
    var afterApr = 0;
    var afterAprflag = 0;
    var i, j, k;
    var rtnVal;
    afterApr = 0;
    afterAprflag = false;
    rtnVal = true;

    for (i = AprLineRow.length - 1; i >= 0; i--) {
        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType11 || GetAttribute(AprLineRow[i], "DATA11") == strAprType12 || GetAttribute(AprLineRow[i], "DATA11") == strAprType11) {
            afterAprflag = i;
            break;
        }
    }

    for (j = AprLineRow.length - 1; j >= 0; j--) {
        if (AprLineRow[j].cells[4].innerText == "" + strLang347 + "" || AprLineRow[j].cells[4].innerText == "" + strLang374 + "" || AprLineRow[j].cells[4].innerText == "" + strLang375 + "") {
            afterApr = j;
        }
    }

    if (afterApr != afterAprflag) {
        for (afterAprflag ; afterAprflag >= afterApr ; afterAprflag--) {
            if (AprLineRow[afterAprflag].cells[4].innerText != "" + strLang347 + "" && AprLineRow[afterAprflag].cells[4].innerText != "" + strLang375 + "" && AprLineRow.item(afterAprflag).cells(4).innerText != "" + strLang374 + "") {
                rtnVal = false;
                break;
            }
        }
    }
    return rtnVal;
}

function chkafterGamSa(AprLineRow) {
    var afterApr;
    var afterAprflag;
    var i;
    var rtnVal;
    afterApr = 0;
    afterAprflag = false;
    rtnVal = true;

    for (i = AprLineRow.length - 1; i >= 0; i--) {
        if (GetAttribute(AprLineRow[i], "DATA11") == strAprType15) {
            afterAprflag = true;
        }

        if (afterAprflag)
        {
            afterApr = afterApr + 1;
        }
    }

    if (afterAprflag) {
        if (afterApr > 1) rtnVal = false;
        else
            rtnVal = true;
    }
    return rtnVal
}

function chkLastKyuljea(AprLineRow) {
    var i, rtnVal;
    var aprtype;
    rtnVal = true;

    for (i = 0; i < AprLineRow.length - 1; i++) {
        aprtype = GetAttribute(AprLineRow[i], "DATA11");
        if (aprtype == "" + strLang126 + "" || aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strAprType13) break;
        if (aprtype == strAprType9 || aprtype == strAprType8 || aprtype == trAprType12 || aprtype == strAprType11) {
            rtnVal = false;
            break;
        }
    }
    return rtnVal;
}

function chkHabyuiGamsa(AprLineRow) {
    var i, rtnVal;
    var aprtype, H, G;
    H = 0;
    G = 0;
    rtnVal = true;

    for (i = 0; i < AprLineRow.length - 1; i++) {
        aprtype = GetAttribute(AprLineRow[i], "DATA11");
        if (aprtype == strAprType11 || aprtype == strAprType12)
            H = H + 1;
        if (aprtype == "" + strLang288 + "" || aprtype == "" + strLang289 + "")
            G = G + 1;
    }
    if (H > 0 && G > 0)
        rtnVal = false;
    return rtnVal;
}

function chkLastKyuljeaJOP(AprLineRow) {
    var i, rtnVal;
    var aprtype, aprtype1;
    rtnVal = true;

    for (i = AprLineRow.length - 1; i >= 0; i--) {
        aprtype = AprLineRow[i].cells[2].innerText;
        if (aprtype == "" + strLang376 + "" || aprtype == "" + strLang377 + "" || aprtype == "" + strLang378 + "" || aprtype == "" + strLang379 + "" || aprtype == "" + strLang380 + "" || aprtype.substring(0, 3) == "" + strLang377 + "" || aprtype.substring(0, 2) == "" + strLang376 + "" || aprtype.substring(0, 2) == "" + strLang379 + "")
            rtnVal = true;
        else
            rtnVal = false;
    }
    return rtnVal;
}

function chkLastKyuljeaCF(AprLineRow) {
    var i, rtnVal;
    var aprtype;
    rtnVal = true;

    for (i = 0; i < AprLineRow.length - 1; i++) {
        aprtype = GetAttribute(AprLineRow[i], "DATA11");
        if (aprtype == "" + strLang126 + "" || aprtype == strAprType1 || aprtype == strAprType4 || aprtype == strAprType15 || aprtype == strAprType13) break;
        if (aprtype == strAprType2) {
            rtnVal = false;
            break;
        }
    }
    return rtnVal;
}

function CheckDraftUser(pFlag) {
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("pAPRLINE");

    var NodeList = pAPRLINE.GetDataRows();
    var NodeListLen = NodeList.length;
    var i;

    if (NodeListLen != 0) {
        if (GetAttribute(NodeList[NodeListLen - 1], "DATA4").toLowerCase() == pUserID.toLowerCase()) {
            if (GetAttribute(NodeList[NodeListLen - 1], "DATA6").toLowerCase() == arr_userinfo[4].toLowerCase())
                return true;
            else
                return false;
        }
        else {
            return false;
        }
    }
}

function getGyulJeDate() {
    var GyulJeDate;
    var xmlpara = createXmlDom();
    var objNode;

    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);

    xmlhttp.open("POST", "../aspx/GetDate.aspx", false);
    xmlhttp.send(xmlpara);
    GyulJeDate = xmlhttp.responseText;
    return GyulJeDate;
}
function AprLineChangeType() {
    try {
        var i;
        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("pAPRLINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;

        var pTmpAprLineState = "001";
        pTmpAprLineState = ConvertAprLineState(pTmpAprLineState, "Value");

        for (i = 0 ; i < pTotalRowsLen - 1 ; i++) {
            if (CrossYN()) {
                pTotalRows[i].cells[5].textContent = pTmpAprLineState;
            }
            else {
                pTotalRows[i].cells[5].innerText = pTmpAprLineState;
            }
        }

        pTmpAprLineState = "002";
        pTmpAprLineState = ConvertAprLineState(pTmpAprLineState, "Value");
        if (CrossYN()) {
            pTotalRows[i].cells[5].textContent = pTmpAprLineState;
        }
        else {
            pTotalRows[i].cells[5].innerText = pTmpAprLineState;
        }

    } catch (e) {
        alert("AprLineChangeType :: " + e.description);
    }
}

function AprLineBanSongChangeType() {
    var i;
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("pAPRLINE");

    var pSelRow = pAPRLINE.GetDataRows();
    var pSelRowLen = pSelRow.length;

    var pBansongAprLineSate;
    var pJinHangAprLineSate;
    var pSungInAprLineSate;

    var pTmpAprLineState = "004";
    pBansongAprLineSate = ConvertAprLineState(pTmpAprLineState, "Value");

    var pTmpAprLineState = "002";
    pJinHangAprLineSate = ConvertAprLineState(pTmpAprLineState, "Value");

    var pTmpAprLineState = "003";
    pSungInAprLineSate = ConvertAprLineState(pTmpAprLineState, "Value");

    for (i = 0 ; i < pSelRowLen ; i++) {
        if (pSelRow[i].cells[5].innerText == pBansongAprLineSate) {
            if (CrossYN()) {
                pSelRow[i].cells[5].textContent = pJinHangAprLineSate;
            }
            else {
                pSelRow[i].cells[5].innerText = pJinHangAprLineSate;
            }

            break;
        }
    }
    if (CrossYN()) {
        pSelRow[pSelRowLen - 1].cells[5].textContent = pSungInAprLineSate;
    }
    else {
        pSelRow[pSelRowLen - 1].cells[5].innerText = pSungInAprLineSate;
    }
}

function OpenInformationUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
    return RtnVal;
}

function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

function APRLINETYPECHANGEFunction() {
    var p_AprLineValue;
    var CurSelRow;
    var p_CurAprlineStat;

    document.getElementById("ReasonNoAprTxt").disabled = true;
    document.getElementById("ReasonNoApr").disabled = true;

    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("pAPRLINE");

    CurSelRow = pAPRLINE.GetSelectedRows();

    if (CurSelRow.length == 0)
        return false;

    p_CurAprlineStat = CurSelRow[0].cells[5].innerText;

    p_AprLineValue = document.getElementById("AprlineType").value;

    if (document.getElementById("ReasonNoAprTxt").value != "")
        document.getElementById("ReasonNoAprTxt").value = "";

    if (pSelAprLineType != "003" && (pReDraftFlag == "DRAFT" || pReDraftFlag == "SUSIN" || pReDraftFlag == "HAPYUI" || pReDraftFlag == "GAMSABU" || pReDraftFlag == "HABYUI"))  //기안시 결재방법 Display
    {
        if (pReDraftAprLineFlag) {
            if (pSelAprLineType == "002" && GetAttribute(CurSelRow[0], "DATA4").toLowerCase() == pUserID.toLowerCase()) {
                var pAlertContent = "" + strLang383 + "";
                OpenAlertUI(pAlertContent);
            } else {
                AprLineTypeCheck(p_AprLineValue, CurSelRow);
            }
        } else {
            AprLineTypeCheck(p_AprLineValue, CurSelRow);
        }
    }
    else if (pReDraftFlag == "REDRAFT") {
        if (pSelAprLineType == "003" || pSelAprLineType == "004" || CurSelRow[0].cells[0].innerText.replace("" + strLang75 + "", "").replace("" + strLang76 + "", "") == "1") {
            Ans = true;
            if (Ans) {
                AprLineTypeCheck(p_AprLineValue, CurSelRow);
                pReDraftAprLineChangeFlag = true;
            }
        } else {
            AprLineTypeCheck(p_AprLineValue, CurSelRow);
        }
    }
}

function trim(parm_str) {
    if (parm_str == "")
        return ""
    else
        return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
    var str_temp = parm_str;
    while (str_temp.length != 0) {
        if (str_temp.substring(0, 1) == " ")
            str_temp = str_temp.substring(1, str_temp.length);
        else
            return str_temp;
    }
    return str_temp;
}

function rtrim(parm_str) {
    var str_temp = parm_str;
    while (str_temp.length != 0) {
        int_last_blnk_pos = str_temp.lastIndexOf(" ");

        if ((str_temp.length - 1) == int_last_blnk_pos)
            str_temp = str_temp.substring(0, str_temp.length - 1);
        else
            return str_temp;
    }
    return str_temp;
}

function RefreshSN() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("pAPRLINE");

        var pTotalRows = APRLINE.GetDataRows();

        var idx = 1;

        for (i = pTotalRows.length - 1 ; i >= 0 ; i--) {
            pTotalRows[i].cells[0].innerHTML = idx;
            idx = idx + 1;
        }
    }
    catch (e) {
        alert("RefreshSN :: " + e.description);
    }
}

function getDeptInfo_nodName(pDeptID, NodeName) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CN", pDeptID);
    createNodeAndInsertText(xmlpara, objNode, "PROP", NodeName);
    createNodeAndInsertText(xmlpara, objNode, "CATE", "group");

    xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetADInfos.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseXML.text;
}

var g_progresswin = null;
function showProgress() {
    g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape("" + strLang384 + ""), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
}
function hideProgress() {
    try {
        if (g_progresswin)
            g_progresswin.close();
    } catch (e) { }
}


function setRep_Suggester() {
    var pAPRLINE = new ListView();      
    pAPRLINE.LoadFromID("pAPRLINE");

    var Row = pAPRLINE.GetDataRows();
    var CurListLen = Row.length;

    var i;
    for (i = 0; i < CurListLen; i++) {
        if (Row[i]) {
            if (CrossYN()) {
                Row[i].cells[0].textContent = Row[i].cells[0].innerText.replace("" + strLang75 + "", "")
                Row[i].cells[0].textContent = Row[i].cells[0].innerText.replace("" + strLang76 + "", "")

                if (GetAttribute(Row[i], "DATA8") == "Y") {
                    Row[i].cells[0].textContent = "" + strLang75 + "" + Row[i].cells[0].innerText
                    chkSuggester = true;
                }

                if (GetAttribute(Row[i], "DATA8") == "") {
                    SetAttribute(Row[i], "DATA8", "N");
                    Suggester.checked = false;
                }

                if (GetAttribute(Row[i], "DATA9") == "Y") {
                    Row[i].cells[0].textContent = "" + strLang76 + "" + Row[i].cells[0].innerText
                    chkReporter = true;
                }

                if (GetAttribute(Row[i], "DATA9") == "") {
                    SetAttribute(Row[i], "DATA9", "N");
                    Reporter.checked = false;
                }
            }
            else {
                Row[i].cells[0].innerText = Row[i].cells[0].innerText.replace("" + strLang75 + "", "")
                Row[i].cells[0].innerText = Row[i].cells[0].innerText.replace("" + strLang76 + "", "")

                if (GetAttribute(Row[i], "DATA8") == "Y") {
                    Row[i].cells[0].innerText = "" + strLang75 + "" + Row[i].cells[0].innerText
                    chkSuggester = true;
                }

                if (GetAttribute(Row[i], "DATA8") == "") {
                    SetAttribute(Row[i], "DATA8", "N");
                    Suggester.checked = false;
                }

                if (GetAttribute(Row[i], "DATA9") == "Y") {
                    Row[i].cells[0].innerText = "" + strLang76 + "" + Row[i].cells[0].innerText
                    chkReporter = true;
                }

                if (GetAttribute(Row[i], "DATA9") == "") {
                    SetAttribute(Row[i], "DATA9", "N");
                    Reporter.checked = false;
                }
            }
        }
    }
}
function CheckDraftDeptID(AprLineRow) {
    if (GetAttribute(AprLineRow[AprLineRow.length - 1], "DATA6") != arr_userinfo[4]
		&& (AprLineRow[AprLineRow.length - 1].cells[5].innerText == "" + strLang18 + "" || AprLineRow[AprLineRow.length - 1].cells[5].innerText == "" + strLang72 + ""))
        return false;

    return true;
}
function check_presence3() {
    for (i = 0; i < APRLINE.rows.length; i++) {
        var presence;
        var mData = "";
        mData = Udomain.split("@");
        presence = APRLINE.rows.item(i).childNodes[0].DATA4;

        APRLINE.rows.item(i).cells(1).innerHTML = "<span><img src='/images/presence/unknown.gif' id= '" + mData[0] + i + "'  onload='PresenceControl(\"" + presence + "@" + mData[1] + "\", this);'/></span>" + APRLINE.rows.item(i).cells(1).innerHTML;
    }
}

