var beforeJob = "0";
var pDocTypeValue = "A01000";
var pageSize = "10";
var CallPage = "Right";
var xmlhttp = createXMLHttpRequest();
var USE_OCS = "";
var emailDomain = "";
var m_objHTMLTarget = "";
var arrySubTab = new Array(0, 6, 4, 4, 3);
var totalPage = "";
var pTotalCnt = "";
function SetOCSInfo(uFlag, eDomain) {
    USE_OCS = uFlag;
    emailDomain = eDomain;
}
function MakeSubCondition() {
    var TYPE = "";
    var DATA = "";

    if (SearchCond[0] != "")
    {
        TYPE += "DOCNO;"
        DATA += "<DOCNO>" + SearchCond[0] + "</DOCNO>";
    }

    if (SearchCond[1] != "")
    {
        TYPE += "DOCTITLE;"
        DATA += "<DOCTITLE>" + SearchCond[1] + "</DOCTITLE>";
    }

    if (SearchCond[2] != "")
    {
        TYPE += "WRITERNAME;"
        DATA += "<WRITERNAME>" + SearchCond[2] + "</WRITERNAME>";
    }
   
    if (SearchCond[3] != "")
    {
        TYPE += "STARTDATEAF;"
        DATA += "<STARTDATEAF>" + SearchCond[3] + "</STARTDATEAF>";
    }

    if (SearchCond[4] != "")
    {
        TYPE += "STARTDATEBF;"
        DATA += "<STARTDATEBF>" + SearchCond[4] + "</STARTDATEBF>";
    }

    if (SearchCond[5] != "")
    {
        TYPE += "ENDDATEAF;"
        DATA += "<ENDDATEAF>" + SearchCond[5] + "</ENDDATEAF>";
    }

    if (SearchCond[6] != "")
    {
        TYPE += "ENDDATEBF;"
        DATA += "<ENDDATEBF>" + SearchCond[6] + "</ENDDATEBF>";
    }

    if (SearchCond[7] != "")
    {
        TYPE += "FORMID;"
        DATA += "<FORMID>" + SearchCond[7] + "</FORMID>";
    }

    if (SearchCond[9] != "")
    {
        TYPE += "WRITERDEPTNAME;"
        DATA += "<WRITERDEPTNAME>" + SearchCond[9] + "</WRITERDEPTNAME>";
    }

    if (SearchCond[10] != "")
    {
        TYPE += "KAPR;"
        DATA += "<KEYWORD>" + SearchCond[10] + "</KEYWORD>";
    }
    SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
}
function getDocList() {
    if (typeof (psearch) == "object")
        document.getElementById("psearch").style.display = "none";

    if (beforeJob != pListTypeValue || SelYearFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pListTypeName", pListTypeValue);
    createNodeAndInsertText(xmlpara, objNode, "pDocTypeName", pDocTypeValue);
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "pPageSize", pageSize);
    createNodeAndInsertText(xmlpara, objNode, "pPageNum", pageNum);
    createNodeAndInsertText(xmlpara, objNode, "companyID", companyID);
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "SearchQuery", SQLPARADATA);
    createNodeAndInsertText(xmlpara, objNode, "SubQuery", SubQuery);

    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getaprdoclist.aspx", true);
    xmlhttp.onreadystatechange = getDocList_after;
    xmlhttp.send(xmlpara);
}
function getDocList_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        if (xmlhttp.responseText == "") return;

        SelYearFlag = false;
        var XmlNode = loadXMLString(xmlhttp.responseText);
        var cntNode = SelectSingleNodeNew(XmlNode, "DOCLIST/TOTALCNT");
        var listNode = SelectSingleNodeNew(XmlNode, "DOCLIST/LISTVIEWDATA");
        if (listNode == null) return;

        var lstCnt = getNodeText(cntNode);

        totalPage = Math.ceil(new Number(lstCnt / pageSize));
        pTotalCnt = lstCnt;

        if (totalPage > 0) {
            if (pageNum > totalPage) {
                pageNum--;
                getDocList();
                return;
            }
        }

        makePageSelPage();

        var xmlDoc
        
        xmlDoc = createXmlDom();
        xmlDoc.appendChild(listNode);
        

        if (document.getElementById("lvDocList").innerHTML != "") document.getElementById("lvDocList").innerHTML = "";
        var DocList = new ListView();
        DocList.SetID("DocList");
        DocList.SetMulSelectable(true);
        DocList.SetHeaderOnClick("lvDocList_HeaderClick");
        DocList.SetRowOnClick("lvDocList_SelChange");
        DocList.SetRowOnDblClick("lvDocList_DBSelChange");
        DocList.SetTitleIdx(0);
        DocList.SetUrgentFlag(true);
        DocList.DataSource(xmlDoc);
        DocList.DataBind("lvDocList");
        DocList = null;

        var Rtnval = setbuttonenable();
        if (Rtnval) {           
            if (pDocInfoValue == "1" || pDocInfoValue == "6") {
                InitlvAprLine();
            }
            else {
                var DocList = new ListView();
                DocList.LoadFromID("DocList");
                var oArrRows = DocList.GetSelectedRows();
                var tr = oArrRows[0];
                if (oArrRows.length != 0) {
                    if (pDocInfoValue == "2") {
                        getAprDocAproveInfo(tr);
                    }
                    else if (pDocInfoValue == "3") {
                        getAprDocAproveInfo(tr);
                    }
                    else if (pDocInfoValue == "4") {
                        getAprDocAproveInfo(tr);
                    }
                    else if (pDocInfoValue == "5") {
                        getAprDocAproveInfo(tr);
                    }
                }
            }
        }

        try { document.getElementById("ifrm").src = "about:blank" } catch (e) { };

        if (USE_OCS == "YES" && lstCnt > 0) {
            check_presence_DocList();
        }     
        return Rtnval;
    }
    catch (e) {
        alert("getDocList_after : " + e.description);
    }
}
function ApplyTextOverflow() {
    var idxTitle = -1;
    var idxDept = -1;
    var idxView = -1;

    switch (pListTypeValue) {
        case "1":
            idxTitle = 0;
            idxDept = 1;
            break;
        case "2":
            idxTitle = 0;
            idxDept = 1;
            break;
        case "3":
            idxTitle = 0;
            idxDept = 1;
            break;
        case "4":
            idxTitle = 0;
            idxDept = 3;
            break;
        case "6":
        case "7":
            idxTitle = 0;
            idxDept = 3;
            break;
        case "9":
            idxTitle = 0;
            idxDept = 3;
            break;
    }

    var objRows = lvDocList.rows;

    for (var i = 0 ; i < objRows.length ; i++) {
        if (idxTitle > -1) {
            objRows.item(i).cells(idxTitle).style.overflow = "hidden";
            objRows.item(i).cells(idxTitle).style.textOverflow = "ellipsis";
            objRows.item(i).cells(idxTitle).title = getNodeText(objRows.item(i).cells(idxTitle));
            objRows.item(i).cells(idxTitle).innerHTML = "<NOBR>" + getNodeText(objRows.item(i).cells(idxTitle)) + "</NOBR>";
        }

        if (idxDept > -1) {
            objRows.item(i).cells(idxDept).style.overflow = "hidden";
            objRows.item(i).cells(idxDept).style.textOverflow = "ellipsis";
            objRows.item(i).cells(idxDept).title = getNodeText(objRows.item(i).cells(idxDept));
            objRows.item(i).cells(idxDept).innerHTML = "<NOBR>" + getNodeText(objRows.item(i).cells(idxDept)) + "</NOBR>";
        }
    }
}

var g_CurrentFormCd = "_DEF_1";
var CurrentDocList = "";
function getReceivedDocList(p_FormCd) {
    if (typeof (psearch) == "object")
        document.getElementById("psearch").style.display = "";

    var manager;

    pSelMenu = "all"

    if (pSelMenu == "hyubjo")
        manager = "admin";
    else
        manager = pSusinManagerFlag;

    if (beforeJob != pListTypeValue || SelYearFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }
    CurrentDocList = "Receive";

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "pSusinManagerFlag", manager);
    createNodeAndInsertText(xmlpara, objNode, "pDocState", pSelMenu);
    createNodeAndInsertText(xmlpara, objNode, "pPageSize", pageSize);
    createNodeAndInsertText(xmlpara, objNode, "pPageNum", pageNum);
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "SearchQuery", SQLPARADATA);
    createNodeAndInsertText(xmlpara, objNode, "SubQuery", SubQuery);

    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getReceivedDocList.aspx", true);
    xmlhttp.onreadystatechange = getReceivedDocList_after;
    xmlhttp.send(xmlpara);
}
function getReceivedDocList_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        if (xmlhttp.responseText == "") return;

        SelYearFlag = false;
        var XmlNode = loadXMLString(xmlhttp.responseText);
        var cntNode = SelectSingleNodeNew(XmlNode, "DOCLIST/TOTALCNT");
        var listNode = SelectSingleNodeNew(XmlNode, "DOCLIST/LISTVIEWDATA");
        var lstCnt = getNodeText(cntNode);

        totalPage = Math.ceil(new Number(lstCnt / pageSize));
        pTotalCnt = lstCnt;
        if (pageNum > totalPage) {
            pageNum--;
            if (CurrentDocList == "Receive")
                getReceivedDocList();
            else
                getSimsaDocList();
            return;
        }

        makePageSelPage();

        var xmlDoc
        xmlDoc = createXmlDom();
        xmlDoc.appendChild(listNode);
        

        if (document.getElementById("lvDocList").innerHTML != "") document.getElementById("lvDocList").innerHTML = "";
        var DocList = new ListView();
        DocList.SetID("DocList");
        DocList.SetMulSelectable(true);
        DocList.SetHeaderOnClick("lvDocList_HeaderClick");
        DocList.SetRowOnClick("lvDocList_SelChange");
        DocList.SetRowOnDblClick("lvDocList_DBSelChange");
        DocList.SetTitleIdx(0);
        DocList.SetUrgentFlag(true);
        DocList.DataSource(xmlDoc);
        DocList.DataBind("lvDocList");
        DocList = null;

        if (displayFlag) document.getElementById("tbtnUserInfo").style.display = "none";

        setbuttonenable();

        if (pDocInfoValue == "1") {
            InitlvAprLine();
        }
        else {
            var DocList = new ListView();
            DocList.LoadFromID("DocList");
            var oArrRows = DocList.GetSelectedRows();
            var tr = oArrRows[0];
            if (tr != null) {
                if (pDocInfoValue == "2") {
                    getAprDocAproveInfo(tr);
                }
                else if (pDocInfoValue == "3") {
                    getAprDocAproveInfo(tr);
                }
                else if (pDocInfoValue == "4") {
                    getAprDocAproveInfo(tr);
                }
            }
        }        
    }
    catch (e) {
        alert("getReceivedDocList_after" + " " + e.description);
    }
}
function getAprLine(tr) {
    var pDocID

    if (pSelMenu == "hyubjo" || pSelMenu == "gamsa")
        pDocID = GetAttribute(tr,"DATA7");
    else
        pDocID = GetAttribute(tr,"DATA1");

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

    if (pListTypeValue == "9")
        createNodeAndInsertText(xmlpara, objNode, "Mode", "TMP");
    else
        createNodeAndInsertText(xmlpara, objNode, "Mode", "APR");

    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezApproval/ezLine/aspx/GetLineList.aspx", true);
    xmlhttp.onreadystatechange = getAprovSub_after;
    xmlhttp.send(xmlpara);
}
function getAprovSub_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        if (xmlhttp.responseText == "") return;

        if (xmlhttp.responseText == "NOTPERMUSSTION") {
            document.getElementById("lvAprLine").style.textAlign = "center";
            document.getElementById("lvAprLine").innerHTML = "<img src='/images/warning02.gif' style='padding-top:10px' width='136' height='112'><h1 style='margin-top:0px'>" + strLang606 + "</h1>";
            return;
        }

        if (document.getElementById("lvAprLine").innerHTML != "") document.getElementById("lvAprLine").innerHTML = "";

        var listNode = SelectSingleNodeNew(loadXMLString(xmlhttp.responseText), "LISTVIEWDATA");
        var xmlDoc
        xmlDoc = createXmlDom();
        xmlDoc.appendChild(listNode);

        var AprLine = new ListView();
        AprLine.SetID("AprLine");
        AprLine.SetMulSelectable(false);
        AprLine.SetTitleIdx(arrySubTab[1]);
        AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");
        AprLine.SetRowOnClick("lvAprLine_SelChange"); 
        AprLine.DataSource(xmlDoc);  
        AprLine.DataBind("lvAprLine");

        if (AprLine.GetRowCount() > 0) {
            document.getElementById("tbtnUserInfo").style.display = "";
            if (displayFlag) document.getElementById("tbtnUserInfo").style.display = "none";

            if (USE_OCS == "YES") {
                    check_presence();
            }
        }
        else {
            document.getElementById("tbtnUserInfo").style.display = "none";
            if (displayFlag) document.getElementById("tbtnUserInfo").style.display = "none";
        }
    }
    catch (e) {
    }
}
function InitlvAprLine() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();

    if (oArrRows.length != 0) {
        var pCurSelRow = oArrRows[0];

        if (pListTypeValue == "2") {
            var DocID = GetAttribute(pCurSelRow,"DATA1");

            cancelYN(DocID);
        }
        else if (pListTypeValue == "3") {
            var DocID = GetAttribute(pCurSelRow,"DATA1");

            cancelYN(DocID);
        }

        SelectFlag = false;
        getAprLine(pCurSelRow);

    } else {
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DocID", "");

        if (pListTypeValue == "9")
            createNodeAndInsertText(xmlpara, objNode, "Mode", "TMP");
        else
            createNodeAndInsertText(xmlpara, objNode, "Mode", "APR");

        xmlhttp = null;
        xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/myoffice/ezApproval/ezLine/aspx/GetLineList.aspx", true);
        xmlhttp.onreadystatechange = getAprovSub_after;
        xmlhttp.send(xmlpara);
    }
}
function RemoveDoc() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    for (var i = 0; i < oArrRows.length; i++) {
        var pCurSelRow = oArrRows[i];
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", GetAttribute(pCurSelRow, "DATA1"));
        createNodeAndInsertText(xmlpara, objNode, "FIELD", "MUST");
        xmlhttp = null;
        xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/myoffice/ezApproval/ReceivUI/aspx/delDocInfo.aspx", false);
        xmlhttp.send(xmlpara);
        var RtnVal = getNodeText(loadXMLString(xmlhttp.responseText).documentElement);
        if (RtnVal == "false") {
            var pAlertContent = strLang458 + "<br> " + strLang459;
            OpenAlertUI(pAlertContent);
        }
        else {
            openergetDocInfo();
        }
    }
}
function setHeSongGamsaDocInfo(pSelectedRow) {
    try {
        var objRoot;
        var objNode;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "ASSIGN");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", GetAttribute(pSelectedRow, "DATA1"));
        createNodeAndInsertText(xmlpara, objNode, "pAprMemberDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pAprMemberID", pUserID);

        if (pListTypeValue == "4")
            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", GetAttribute(pSelectedRow, "DATA2"));
        else
            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", "1");

        xmlhttp.open("POST", "/myoffice/ezApproval/ezAPRRECEIVE/aspx/setHeSongGamsaDocInfo.aspx", false);
        xmlhttp.send(xmlpara);

        var RtnVal = getNodeText(loadXMLString(xmlhttp.responseText).documentElement);

        if (RtnVal != "TRUE") {
            var pAlertContent = strLang350;
            OpenAlertUI(pAlertContent);
            return;
        } else {
            var pAlertContent = strLang466;
            OpenAlertUI(pAlertContent);
            openergetDocInfo();
        }
    } catch (e) {
        alert("setHeSongHapyuiDocInfo :: " + e.description);
    }
}
function setHeSongHapyuiDocInfo(pSelectedRow) {
    try {
        var objRoot;
        var objNode;
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        createNodeInsert(xmlpara, objNode, "ASSIGN");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", GetAttribute(pSelectedRow, "DATA1"));
        createNodeAndInsertText(xmlpara, objNode, "pAprMemberDeptID", arr_userinfo[4]);
        createNodeAndInsertText(xmlpara, objNode, "pAprMemberID", pUserID);

        if (pListTypeValue == "4")
            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", GetAttribute(pSelectedRow, "DATA2"));
        else
            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", "1");

        xmlhttp.open("POST", "/myoffice/ezApproval/ezAPRRECEIVE/aspx/setHeSongHapyuiDocInfo.aspx", false);
        xmlhttp.send(xmlpara);

        if (getNodeText(loadXMLString(xmlhttp.responseText).documentElement) != "TRUE") {
            var pAlertContent = strLang350;
            OpenAlertUI(pAlertContent, "OPEN");
        }
        else {
            getHapyuitype(pSelectedRow, GetAttribute(pSelectedRow, "DATA7"));
            var pAlertContent = strLang466;
            OpenAlertUI(pAlertContent, "OPEN");
            openergetDocInfo();
        }
    } catch (e) {
        alert("setHeSongHapyuiDocInfo :: " + e.description);
    }
}
function setHeSongDocInfo(pCurSelRow) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "ASSIGN");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", GetAttribute(pCurSelRow, "DATA1"));
    if (pListTypeValue == "4")
        createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", GetAttribute(pCurSelRow, "DATA2"));
    else
        createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", GetAttribute(pCurSelRow, "DATA9"));

    createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

    if (GetAttribute(pCurSelRow, "DATA10") == strDocState32)
        createNodeAndInsertText(xmlpara, objNode, "pDocSate", "REBACK");
    else
        createNodeAndInsertText(xmlpara, objNode, "pDocSate", "RECEIVE");

    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
    createNodeAndInsertText(xmlpara, objNode, "pUserName2", arr_userinfo[12]);
    xmlhttp.open("POST", "/myoffice/ezApproval/ezAPRRECEIVE/aspx/setHeSongDocInfo.aspx", false);
    xmlhttp.send(xmlpara);
    var RtnVal = getNodeText(loadXMLString(xmlhttp.responseText).documentElement);
    if (RtnVal == "FALSE") {
        var pAlertContent = strLang350;
        OpenAlertUI(pAlertContent);
    }
    else {
        SendMailHesong(pCurSelRow); 
        var pAlertContent = strLang466;
        OpenAlertUI(pAlertContent);
        openergetDocInfo();
    }
}
function getAprDocAproveInfo(tr) {
    var pDocID;
    if (pSelMenu == "hyubjo" || pSelMenu == "gamsa" || pListTypeValue == "6")
        pDocID = GetAttribute(tr, "DATA7");
    else
        pDocID = GetAttribute(tr, "DATA1");

    var xmlhttp = createXMLHttpRequest();
    var RtnVal = createXmlDom();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "ASSIGN");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);

    if (pListTypeValue == "9")
        createNodeAndInsertText(xmlpara, objNode, "Flag", "TMP");
    else if (pListTypeValue == "6")
        createNodeAndInsertText(xmlpara, objNode, "Flag", "END");
    else
        createNodeAndInsertText(xmlpara, objNode, "Flag", "APR");

    if (pDocInfoValue == "4") {
        xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getTotalAttachInfo.aspx", false);
    }
    else if (pDocInfoValue == "3") {
        xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getOpinionInfo.aspx", false);
    }
    else if (pDocInfoValue == "2") {
        xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getReceiptinfo.aspx", false);
    }
    xmlhttp.send(xmlpara);
    RtnVal = loadXMLString(xmlhttp.responseText);

    if (xmlhttp.responseText == "NOTPERMUSSTION") {
        document.getElementById("lvAprLine").style.textAlign = "cneter";
        lvAprLine.innerHTML = "<img src='/images/warning02.gif' style='padding-top:10px' width='136' height='112'><h1 style='margin-top:0px'>" + strLang606 + "</h1>";
        return;
    }

    if (lvAprLine.innerHTML != "") lvAprLine.innerHTML = "";
    var AprLine = new ListView();
    AprLine.SetID("AprLine");
    AprLine.SetMulSelectable(false);
    AprLine.SetTitleIdx(arrySubTab[pDocInfoValue]);
    AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");
    AprLine.SetRowOnClick("lvAprLine_SelChange"); 
    AprLine.DataSource(RtnVal);
    AprLine.DataBind("lvAprLine");
}
function openergetDocInfo() {
    if (CallPage == "Left") return;
    try {
        if (pListTypeValue == "6") {
            getSimsaDocList();
        } else if (pListTypeValue == "4") {
            getReceivedDocList();
        } else {
            getDocList();
        }
        parent.frames["left"].getAprCount();
    } catch (e) {
        alert("openergetDocInfo :: " + e.description);
    }
}
function getDataInfo(jobState) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

    subTabLastCol = jobState;
    switch (jobState) {
        case "3":
            if (pListTypeValue == "9")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "TMP");
            else
                createNodeAndInsertText(xmlpara, objNode, "Flag", "APR");

            xmlhttp = null;
            xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getTotalAttachInfo.aspx", true);
            break;

        case "4":
            if (pListTypeValue == "9")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "TMP");
            else
                createNodeAndInsertText(xmlpara, objNode, "Flag", "APR");


            xmlhttp = null;
            xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getOpinionInfo.aspx", true);
            break;

        case "1":
            xmlhttp = null;
            xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getapprolineInfo.aspx", true);
            break;

        case "2":
            if (pListTypeValue == "9")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "TMP");
            else
                createNodeAndInsertText(xmlpara, objNode, "Flag", "APR");


            xmlhttp = null;
            xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getReceiptinfo.aspx", true);
            break;
    }
    xmlhttp.onreadystatechange = getdoclistSub_after;
    xmlhttp.send(xmlpara);
}
function getdoclistSub_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        if (document.getElementById("lvAprLine").innerHTML != "") document.getElementById("lvAprLine").innerHTML = "";
        var listNode = SelectSingleNodeNew(loadXMLString(xmlhttp.responseText), "LISTVIEWDATA");
        var xmlDoc
        
        xmlDoc = createXmlDom();
        xmlDoc.appendChild(listNode);
        
        var AprLine = new ListView();
        AprLine.SetID("AprLine");
        AprLine.SetMulSelectable(false);
        AprLine.SetTitleIdx(arrySubTab[subTabLastCol]);
        AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");      
        AprLine.DataSource(xmlDoc);                        
        AprLine.DataBind("lvAprLine");                    
    }
    catch (e) { }
}
var g_progresswin = null;
function showProgress() {
    g_progresswin = modelessWindow("/myoffice/ezApproval/show_progress_Cross.aspx?fileinfo=" + escape(strLang478), "", 390, 185, g_progresswin);
}
function getSimsaDocList() {
    var manager;
    
    if (beforeJob != pListTypeValue || SelYearFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }
    CurrentDocList = "Simsa";
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "pSusinManagerFlag", "simsa");
    createNodeAndInsertText(xmlpara, objNode, "pDocState", pSelMenu);
    createNodeAndInsertText(xmlpara, objNode, "pPageSize", pageSize);
    createNodeAndInsertText(xmlpara, objNode, "pPageNum", pageNum);
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "SearchQuery", SQLPARADATA);
    createNodeAndInsertText(xmlpara, objNode, "SubQuery", SubQuery);
    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezApproval/aspx/getReceivedDocList.aspx", true);
    xmlhttp.onreadystatechange = getReceivedDocList_after;
    xmlhttp.send(xmlpara);
}
function doCancel() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var pCurSelRow = oArrRows[0];
    if (pCurSelRow.length != 0) {
        var pDocID = GetAttribute(pCurSelRow, "DATA1");
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "ASSIGN");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
        xmlhttp.open("POST", "/myoffice/ezApproval/aspx/doCancel.aspx", false);
        xmlhttp.send(xmlpara);
        var RtnVal = getNodeText(loadXMLString(xmlhttp.responseText).documentElement);
        if (RtnVal == "TRUE") {
            setLogData(pDocID, "AP1002", "", "")
            if (pListTypeValue == "3") {
                var pAlertContent = strLang479 + "<br> " + strLang480;
                OpenAlertUI(pAlertContent);
            }
            else {
                var pAlertContent = strLang481 + "<br> " + strLang482;
                OpenAlertUI(pAlertContent);

            }
            SendMailToCancel(pDocID); 
            openergetDocInfo();
        }
        else if (RtnVal == "ERR01") {
            var pAlertContent = strLang483;
            OpenAlertUI(pAlertContent);
        }
        else if (RtnVal == "ERR02") {
            var pAlertContent = strLang484;
            OpenAlertUI(pAlertContent);
        }
        else if (RtnVal == "ERR03") {
            var pAlertContent = strLang485;
            OpenAlertUI(pAlertContent);
        }
        else {
            var pAlertContent = strLang486;
            OpenAlertUI(pAlertContent);
        }
    }
}
var xmlhttpcancelYN = createXMLHttpRequest();
var cancelYNxmlpara = createXmlDom();
function cancelYN(pDocID) {
    xmlhttpcancelYN = createXMLHttpRequest();
    cancelYNxmlpara = createXmlDom();
    var objNode;
    createNodeInsert(cancelYNxmlpara, objNode, "ASSIGN");
    createNodeAndInsertText(cancelYNxmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(cancelYNxmlpara, objNode, "pUserID", pUserID);
    xmlhttpcancelYN.open("POST", "/myoffice/ezApproval/aspx/doCancelYN.aspx", true);
    xmlhttpcancelYN.onreadystatechange = cancelYN_after;
    xmlhttpcancelYN.send(cancelYNxmlpara);
}

var xmlhttpforcecancelYN = createXMLHttpRequest();
function cancelYN_after() {
    if (xmlhttpcancelYN == null || xmlhttpcancelYN.readyState != 4) return;
    var RtnVal = getNodeText(loadXMLString(xmlhttpcancelYN.responseText).documentElement);
    if (RtnVal == "CALLBACK" && pListTypeValue == "2" && !GetBujaeFlag()) {
        document.getElementById("tbtncallback").style.display = "";
        document.getElementById("tbtnforcecallback").style.display = "none";
    }
    else if (RtnVal == "CANCEL" && pListTypeValue == "3" && !GetBujaeFlag()) {
        document.getElementById("tbtncallback").style.display = "";
        document.getElementById("tbtnforcecallback").style.display = "none";
    }
    else {
        xmlhttpforcecancelYN.open("POST", "/myoffice/ezApproval/aspx/doForceCancelYN.aspx", true);
        xmlhttpforcecancelYN.onreadystatechange = ForcecancelYN_after;
        xmlhttpforcecancelYN.send(cancelYNxmlpara);
    }
       
}

function ForcecancelYN_after() {
    if (xmlhttpforcecancelYN == null || xmlhttpforcecancelYN.readyState != 4) return;
    var RtnVal = getNodeText(loadXMLString(xmlhttpforcecancelYN.responseText).documentElement);
    if (RtnVal == "TRUE")
        document.getElementById("tbtnforcecallback").style.display = "";
    else
        document.getElementById("tbtnforcecallback").style.display = "none";

    document.getElementById("tbtncallback").style.display = "none";
}

function CheckAprLineInfo(tr) {
    var xmldom = createXmlDom();
    try {
        xmldom = getAprLineInfo(tr);
        if (xmldom.getElementsByTagName("ROW").length == 0)
            return "OK";

        if (_DeptInfo != "" && _DeptInfo != null) {
            var pDeptName = "";
            for (var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++) {
                var pUserId = getNodeText(xmldom.getElementsByTagName("DATA4").item(i));
                var pDeptID = getNodeText(xmldom.getElementsByTagName("DATA6").item(i));
                if (pUserId == arr_userinfo[1] && pDeptID == arr_userinfo[4]) {
                    var end = "OK";
                    return "OK";
                }
                else {
                    if (pUserId == arr_userinfo[1]) {
                        pDeptName = getNodeText(xmldom.getElementsByTagName("CELL").item(3));
                    }
                    else {
                        var pBujaeUserInfo = getBujaeInfo_AprLine(pUserId);
                        if (pBujaeUserInfo != "") {
                            var arrBUserInfo = new Array("");
                            arrBUserInfo = pBujaeUserInfo.split(":");

                            if (arrBUserInfo[0] == arr_userinfo[1] && arrBUserInfo[2] == arr_userinfo[4]) {
                                return "OK";
                            }
                            else if (arrBUserInfo[0] == arr_userinfo[1]) {
                                pDeptName = arrBUserInfo[3];
                            }
                        }
                    }
                }
            }
            if (end != "OK") {
                if (pDeptName == "")
                    pDeptName = getNodeText(xmldom.getElementsByTagName("ROW").item(xmldom.getElementsByTagName("ROW").length - 1).childNodes.item(3));

                pDeptName = pDeptName.replace("\"", "");
                return pDeptName;
            }
        }
        else {
            return "OK";
        }
    }
    catch (e) {
        alert("CheckAprLineInfo : " + e.description);
        return "OK";
    }
}
function getBujaeInfo_AprLine(pBujaeUserID) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "USERID", pBujaeUserID);
    var xmlhttp_bujaeinfo = createXMLHttpRequest();
    xmlhttp_bujaeinfo.open("POST", "/myoffice/ezApproval/aspx/GetBujaeCheckInfo.aspx", false);
    xmlhttp_bujaeinfo.send(xmlpara);
    return xmlhttp_bujaeinfo.responseText;
}
function getAprLineInfo(tr) {
    var pDocID
    if (pListTypeValue == "4" || pSelMenu == "hyubjo" || pSelMenu == "gamsa")
        pDocID = GetAttribute(tr, "DATA7");
    else
        pDocID = GetAttribute(tr, "DATA1");

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Mode", "APR");
    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezApproval/ezLine/aspx/GetIngLineInfo.aspx", false);
    xmlhttp.send(xmlpara);
    if (xmlhttp.statusText == "OK")
        return loadXMLString(xmlhttp.responseText);
    else
        return "";
}
function CheckReceiptInfo(tr) {
    var xmldom = createXmlDom();
    try {
        var pReceiptID = GetAttribute(tr, "DATA6");

        if (pReceiptID == arr_userinfo[4])
            return "OK";
        else {
            xmldom.load(getEntryInfo(pReceiptID, "description"));
            var node = SelectNodes(xmldom, "DESCRIPTION");
            var pDeptName = getNodeText(node);
            pDeptName = pDeptName.replace("\"", "");
            return pDeptName;
        }
    }
    catch (e) {
        alert("CheckReceiptInfo : " + e.description);
        return "OK";
    }
}
function getEntryInfo(pCN, pProp) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "CN", pCN);
    createNodeAndInsertText(xmlpara, objNode, "PROP", pProp);
    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/myoffice/ezOrgan/Admin/GetEntryInfo.aspx?Mode=", false);
    xmlhttp.send(xmlpara);
    if (xmlhttp.statusText == "OK")
        return loadXMLString(xmlhttp.responseText);
    else
        return "";
}
function openServerDraftUI(pDraftFlag, pCurSelRow) {
    var pArgument = new Array();
    pArgument[0] = pUserID;
    pArgument[1] = formURL;
    pArgument[2] = pDraftFlag;
    pArgument[3] = formDocType;
    var pDocSN = GetAttribute(pCurSelRow, "DATA1");
    var newDocID = MakeTmp2Ing(pDocSN);
    if (pCurSelRow) {
        pArgument[4] = "0";
        pArgument[5] = "";
        pArgument[6] = "";
        pArgument[7] = newDocID;
    }
    else {
        pArgument[4] = "0"
        pArgument[5] = ""
        pArgument[6] = ""
        pArgument[7] = "";
    }
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
        if (CrossYN() || pNoneActiveX == "YES") {
            alert(strLang1103);
            return;
        }
        else {
            var openLocation = "/myoffice/ezApproval/ezViewHWP/ezDraftUI_HWP.aspx"
        }
    }
    else {
        var openLocation = "";
        if (CrossYN() || pNoneActiveX == "YES") {
            openLocation = "/myoffice/ezApproval/DraftUI/DraftUI_Cross.aspx";
        }
        else {
            if (pUse_Editor == "")
                openLocation = "/myoffice/ezApproval/DraftUI/draftui.aspx";                
            else {
                openLocation = "/myoffice/ezApproval/DraftUI/draftui_IE.aspx";
            }
        }
    }
    openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&DraftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
    openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&DocState=" + escape(pArgument[5]) + "&ListType=" + escape(pListTypeValue) + "&AprState=" + escape(pArgument[6]);
    openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]) + "&DocSN=" + escape(pDocSN)
    //GetOpenWindow(openLocation, "", 1000, 950, "YES")
    openwindow(openLocation, "", 880, 570);
}
function MakeTmp2Ing(tmpDocID) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "TMPDOCID", tmpDocID);
    xmlhttp.open("POST", "/myoffice/ezApproval/aspx/MakeTmp2Ing.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText));
    return getNodeText(dataNodes[0]);
}
function RemoveTmpDoc() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    for (var i = 0; i < oArrRows.length; i++) {
        var pCurSelRow = oArrRows[i];
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", GetAttribute(pCurSelRow, "DATA1"));

        xmlhttp = null;
        xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/myoffice/ezApproval/aspx/RemoveTMPDocInfo.aspx", false);
        xmlhttp.send(xmlpara);
        var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText));
        RtnVal = getNodeText(dataNodes[0]);
        if (RtnVal != "TRUE") {
            var pAlertContent = strLang505;
            OpenAlertUI(pAlertContent);            
        }
        openergetDocInfo();
    }
}
function setBujaeOff() {
    var xmlDom = createXmlDom();
    var xmlHTTP = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "BUJAE", "");
    createNodeAndInsertText(xmlDom, objNode, "PROXY", "");

    xmlHTTP.open("POST", "/myoffice/ezPersonal/BujaeConf/SaveBujae.aspx", false);
    xmlHTTP.send(xmlDom);

    arr_userinfo[7] = "";
}

function ChangeCookies() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[5]);
    createNodeAndInsertText(xmlpara, objNode, "POSITION", arr_userinfo[3]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME1", arr_userinfo[15]); 
    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME2", arr_userinfo[16]);
    createNodeAndInsertText(xmlpara, objNode, "POSITION1", arr_userinfo[13]);
    createNodeAndInsertText(xmlpara, objNode, "POSITION2", arr_userinfo[14]);
    xmlhttp.open("POST", "/myoffice/ezApproval/Include/ChangeUserInfo.aspx", false);
    xmlhttp.send(xmlpara);
}
function btnSimsa_onclick() {
    try {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var oArrRows = DocList.GetSelectedRows();
        var tr = oArrRows[0];
        if (oArrRows.length == 0) {
            var pAlertContent = t817;
            OpenAlertUI(pAlertContent);
            return;
        }
        if (_USE_AdditionalROle == "YES") {
            if (tr == null) {
                var xmldom = createXmlDom();
                xmldom = getEntryInfo(pUserID, "Department;Description")
                var pDeptID = getNodeText(GetElementsByTagName(xmldom, "DEPARTMENT")[0]);
                var pDeptName = getNodeText(GetElementsByTagName(xmldom, "DESCRIPTION")[0]);
                if (arr_userinfo[4] != pDeptID) {
                    var pAlertContent = t23 + "<br>" + t24 + pDeptName + t25;
                    OpenAlertUI(pAlertContent);
                    return;
                }
            }
        }
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;
        var heigth = heigth - 50;
        var width = width - 10;
        var left = 0;
        var top = 0;
        var openLocation = "";
        var pDocID = GetAttribute(tr, "DATA1");
        var pOrgDocID = GetAttribute(tr, "DATA7");
        var pHref = GetAttribute(tr, "DATA3");

        if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
            if (CrossYN() || pNoneActiveX == "YES") {
                alert(strLang1104);
                return;
            }
            else {
                openLocation = "/myoffice/ezApproval/ezViewHWP/ezSimsa_HWP.aspx";
            }
        }
        else {
            if (CrossYN() || pNoneActiveX == "YES") {
                openLocation = "/myoffice/ezApproval/enforce/ezSimsa_Cross.aspx";
            }
            else {
                if (pUse_Editor == "")
                    openLocation = "/myoffice/ezApproval/enforce/ezSimsa.aspx";
                else
                    openLocation = "/myoffice/ezApproval/enforce/ezSimsa_IE.aspx";
            }
        }
        openLocation = openLocation + "?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref) + "&orgDocid=" + escape(pOrgDocID);        
        var result = GetOpenWindow(openLocation, "enforce", width, heigth, "NO");
    }
    catch (e) {
        alert("btnSimsa_onclick : " + e.description);
    }
}
function RemoveDocCabinet() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", GetAttribute(tr, "DATA1"));
    createNodeAndInsertText(xmlpara, objNode, "FIELD", tempField);
    xmlhttp.open("POST", "/myoffice/ezApproval/aspx/SaveReturnDoc.aspx", false);
    xmlhttp.send(xmlpara);
    var RtnVal = getNodeText(loadXMLString(xmlhttp.responseText).documentElement);
    if (RtnVal == "TRUE") {
        var pAlertContent = t822;
        OpenAlertUI(pAlertContent);
    }
    else {
        var pAlertContent = t823;
        OpenAlertUI(pAlertContent);
    }
}
function btnApproveALL_onclick() {

    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var pCurSelRow = DocList.GetSelectedRows();
    if (pCurSelRow.length == 0) {
        var pAlertContent = t809 + "<br> " + t810;
        OpenAlertUI(pAlertContent);
        return;
    }

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pListTypeName", pListTypeValue);
    createNodeAndInsertText(xmlpara, objNode, "pDocTypeName", pDocTypeValue);
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "pPageSize", pageSize);
    createNodeAndInsertText(xmlpara, objNode, "pPageNum", pageNum);
    createNodeAndInsertText(xmlpara, objNode, "companyID", companyID);
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "SubQuery", SubQuery);
    var wWeigth = 655;
    var wHeigth = 400;
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;
    left = (parseInt(width) - parseInt(wWeigth)) / 2;
    top = (parseInt(heigth) - parseInt(wHeigth)) / 2;
    var pop = window.open("", "POP", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeigth + ",width=" + wWeigth + ",top=" + top + ",left =" + left);
    formAPP.APPXML.value = getXmlString(xmlpara);
    formAPP.method = "post";
    formAPP.action = "/myoffice/ezApproval/ApprovUI/doApprovAllselect_Cross.aspx";
    formAPP.target = "POP";
    formAPP.submit();
}
function DisplayAprLineStat(NodeListLen) {
    if (pListTypeValue == 1) {
        document.getElementById("AprManageStat").innerHTML = strLang433 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
    } else if (pListTypeValue == 2) {
        document.getElementById("AprManageStat").innerHTML = strLang434 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
    } else if (pListTypeValue == 3) {
        document.getElementById("AprManageStat").innerHTML = strLang435 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
    } else if (pListTypeValue == 4) {
        switch (pSelMenu) {
            case "all":
                document.getElementById("AprManageStat").innerHTML = strLang436 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
                break;

            case "hyubjo":
                document.getElementById("AprManageStat").innerHTML = strLang437 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
                break;

            case "gamsa":
                document.getElementById("AprManageStat").innerHTML = strLang438 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
                break;
        }
    } else if (pListTypeValue == 5) {
        document.getElementById("AprManageStat").innerHTML = strLang439 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
    } else if (pListTypeValue == 6) {
        document.getElementById("AprManageStat").innerHTML = strLang440 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
    } else if (pListTypeValue == 9) {
        document.getElementById("AprManageStat").innerHTML = strLang503 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang381;
    }
}
function DisplayWaitStat() {
    if (pListTypeValue == 1) {
        document.getElementById("AprManageStat").innerHTML = strLang441;
    } else if (pListTypeValue == 2) {
        document.getElementById("AprManageStat").innerHTML = strLang442;
    } else if (pListTypeValue == 3) {
        document.getElementById("AprManageStat").innerHTML = strLang443;
    } else if (pListTypeValue == 4) {
        switch (pSelMenu) {
            case "all":
                document.getElementById("AprManageStat").innerHTML = strLang444;
                break;

            case "hyubjo":
                document.getElementById("AprManageStat").innerHTML = strLang445;
                break;

            case "gamsa":
                document.getElementById("AprManageStat").innerHTML = strLang446;
                break;
        }
    } else if (pListTypeValue == 5) {
        document.getElementById("AprManageStat").innerHTML = strLang447;
    } else if (pListTypeValue == 5) {
        document.getElementById("AprManageStat").innerHTML = strLang448;
    } else if (pListTypeValue == 9) {
        document.getElementById("AprManageStat").innerHTML = strLang502;
    }
}
function openUserInfo() {
    var AprLine = new ListView();
    AprLine.LoadFromID("AprLine");
    var oArrRows = AprLine.GetSelectedRows();
    var tr = oArrRows[0];

    if (pListTypeValue != "5") {
        if (oArrRows.length != 0) {
            var pCheckval = GetAttribute(tr, "DATA5");
            var pDocID = GetAttribute(tr, "DATA3");
            var pDeptID = GetAttribute(tr, "DATA4");
            var pUserID = GetAttribute(tr, "DATA6");
            if (pCheckval == "Y") {
                if (tr.cells[4].innerHTML == strAprType13) {
                    opencenterwindow("ezDocInfo/ezLineInfo.aspx?pDocID=" + pDocID + "&pDeptID=" + pDeptID + "&pDocState=" + strDocState14, "", 825, 290);
                }
                else {
                    opencenterwindow("ezDocInfo/ezLineInfo.aspx?pDocID=" + pDocID + "&pDeptID=" + pDeptID + "&pDocState=" + strDocState12, "", 825, 290);
                }
            } else {
                opencenterwindow("/myoffice/common/showpersoninfo_cross.aspx?id=" + pDeptID + "&dept=" + pUserID, "", 420, 450);
            }
        }
        else {
            var pAlertContent = strLang449;
            OpenAlertUI(pAlertContent);
        }
    }
    else {
        opencenterwindow("/myoffice/common/showpersoninfo_cross.aspx?id=" + GetAttribute(tr, "DATA1"), "", 420, 450);
    }
}
function openDraftUI(pDraftFlag, pCurSelRow) {
    var pArgument = new Array();

    pArgument[0] = pUserID;
    pArgument[1] = formURL;
    pArgument[2] = pDraftFlag;
    pArgument[3] = formDocType;
    pArgument[8] = formID;
    pArgument[9] = reFormFlag;

    if (pCurSelRow) {
        if (pListTypeValue != "5") {
            pArgument[4] = GetAttribute(pCurSelRow, "DATA9");
            pArgument[5] = GetAttribute(pCurSelRow, "DATA12");
            pArgument[6] = GetAttribute(pCurSelRow, "DATA10");
            pArgument[7] = "";
        }
        else {
            pArgument[4] = "0";
            pArgument[5] = "";
            pArgument[6] = "";
            pArgument[7] = newDocID;
        }
        pArgument[3] = GetAttribute(pCurSelRow, "DATA15");
    }
    else {
        pArgument[4] = "0"
        pArgument[5] = ""
        pArgument[6] = ""
        pArgument[7] = "";
    }
    var temppListTypeValue = pListTypeValue;
    pListTypeValue = "1";
    var openLocation = "";
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
        if (CrossYN() || pNoneActiveX == "YES") {
            alert(strLang1103);
            return;
        }
        else {
            var openLocation = "/myoffice/ezApproval/ezViewHWP/ezDraftUI_HWP.aspx";
        }
    }
    else if (reFormFlag == "Y")
    {
        openLocation = "/myoffice/ezApproval/DraftUI/draftui_reform.aspx";
        if (CrossYN() || pNoneActiveX == "YES")
            openLocation = "/myoffice/ezApproval/DraftUI/draftui_reform_Cross.aspx";
    }
    else {
        if (CrossYN() || pNoneActiveX == "YES") {
            openLocation = "/myoffice/ezApproval/DraftUI/DraftUI_Cross.aspx";
        }
        else {
            if (pUse_Editor == "")
                openLocation = "/myoffice/ezApproval/DraftUI/draftui.aspx";
            else {
                openLocation = "/myoffice/ezApproval/DraftUI/draftui_IE.aspx";
            }
        }
    }
    openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&DraftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
    openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&DocState=" + escape(pArgument[5]) + "&ListType=" + escape(pListTypeValue) + "&AprState=" + escape(pArgument[6]);
    openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7])

	if (reFormFlag == "Y")
        openLocation = openLocation + "&formID=" + escape(pArgument[8]) + "&reFormFlag=" + escape(pArgument[9]);

	//var result = GetOpenWindow(openLocation, "", 1000, 950, "YES");
	var result = openwindow(openLocation, "ApprovUI", 880, 570);
    pListTypeValue = temppListTypeValue;
}
function openApprovUI() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length > 1) {
        var pArgument = new Array();
        pArgument[0] = "";
        var formURL = "";
        MultiSelectedDocID = "<DOCIDS>";
        for (var i = 0; i < tr.length; i++) {
            var pCurSelRow = tr[i];
            if (GetAttribute(pCurSelRow, "DATA12") != strDocState15 && (GetAttribute(pCurSelRow, "DATA10") == strAprState2 || GetAttribute(pCurSelRow, "DATA10") == strAprState5)) {
                MultiSelectedDocID = MultiSelectedDocID + "<DOCID>" + GetAttribute(pCurSelRow, "DATA1") + "</DOCID>";

                if (pArgument[0] == "") {
                    pArgument[0] = GetAttribute(pCurSelRow, "DATA1");
                    pArgument[1] = GetAttribute(pCurSelRow, "DATA4");
                    pArgument[2] = GetAttribute(pCurSelRow, "DATA5");
                    pArgument[3] = GetAttribute(pCurSelRow, "DATA7");
                    formURL = GetAttribute(pCurSelRow, "DATA3");
                }
            }
        }
        MultiSelectedDocID = MultiSelectedDocID + "</DOCIDS>";
        if (MultiSelectedDocID == "<DOCIDS></DOCIDS>") {
            var pAlertContent = strLang455;
            OpenAlertUI(pAlertContent);
            return;
        }

        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
            if (CrossYN() || pNoneActiveX == "YES") {
                var openLocation = "/myoffice/ezApproval/ezViewHWP/ezAproveUI_HWP_Cross.aspx?DocID=" + escape(pArgument[0]);
                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape("2");
            }
            else {
                var openLocation = "/myoffice/ezApproval/ezViewHWP/ezAproveUI_HWP.aspx?DocID=" + escape(pArgument[0]);
                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape("2");
            }
        }
        else if (tr[0].getAttribute("DATA18") == "Y")
        {
            openLocation = "/myoffice/ezApproval/ApprovUI/ApprovUI_reform.aspx";
            if (CrossYN() || pNoneActiveX == "YES")
                openLocation = "/myoffice/ezApproval/ApprovUI/ApprovUI_reform_cross.aspx";
            openLocation = openLocation + "?DocID=" + escape(pArgument[0]) + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
            openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape("2") + "&toyear=" + GetSelectVal("sel_year");
        }
        else {
            var openLocation = "";
            if (CrossYN() || pNoneActiveX == "YES")
                openLocation = "/myoffice/ezApproval/ApprovUI/ApprovUI_Cross.aspx?DocID=" + escape(pArgument[0]);                            
            else {
                if (pUse_Editor == "")
                    openLocation = "/myoffice/ezApproval/ApprovUI/Approvui.aspx?DocID=" + escape(pArgument[0]);
                else
                    openLocation = "/myoffice/ezApproval/ApprovUI/Approvui_IE.aspx?DocID=" + escape(pArgument[0]);
                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape("2") + "&toyear=" + GetSelectVal("sel_year");
            }
        }
        GetOpenWindow(openLocation, "ApprovUI", 1000, 950, "YES");        
    }
    else if (tr.length == 1) {
        var pCurSelRow = tr[0];

        var pArgument = new Array();
        pArgument[0] = GetAttribute(pCurSelRow, "DATA1");
        pArgument[1] = GetAttribute(pCurSelRow, "DATA4");
        pArgument[2] = GetAttribute(pCurSelRow, "DATA5");
        pArgument[3] = GetAttribute(pCurSelRow, "DATA7");

        var formURL = GetAttribute(pCurSelRow, "DATA3");
        var openLocation = "";
        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
            if (CrossYN() || pNoneActiveX == "YES") {
                openLocation = "/myoffice/ezApproval/ezViewHWP/ezAproveUI_HWP_Cross.aspx?DocID=" + escape(pArgument[0]);
                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]);
            }
            else {
                openLocation = "/myoffice/ezApproval/ezViewHWP/ezAproveUI_HWP.aspx?DocID=" + escape(pArgument[0]);
                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]);
            }
        }
        else if (tr[0].getAttribute("DATA18") == "Y")
        {
            openLocation = "/myoffice/ezApproval/ApprovUI/ApprovUI_reform.aspx";
            if (CrossYN() || pNoneActiveX == "YES")
                openLocation = "/myoffice/ezApproval/ApprovUI/ApprovUI_reform_Cross.aspx";
            openLocation = openLocation + "?DocID=" + escape(pArgument[0]) + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
            openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&toyear=" + GetSelectVal("sel_year");
        }
        else {            
            if (CrossYN() || pNoneActiveX == "YES")
                openLocation = "/myoffice/ezApproval/ApprovUI/ApprovUI_Cross.aspx?DocID=" + escape(pArgument[0]);
            else {
                if (pUse_Editor == "")
                    openLocation = "/myoffice/ezApproval/ApprovUI/Approvui.aspx?DocID=" + escape(pArgument[0]);
                else
                    openLocation = "/myoffice/ezApproval/ApprovUI/Approvui_IE.aspx?DocID=" + escape(pArgument[0]);
            }
            openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
            openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&toyear=" + GetSelectVal("sel_year");
        }
        //GetOpenWindow(openLocation, "ApprovUI", 1000, 950, "YES");
        openwindow(openLocation, "ApprovUI", 880, 570);
    }
    else {
        var pAlertContent = strLang456;
        OpenAlertUI(pAlertContent);
    }
}
var getFormCont_dialogArguments = new Array();
function openForm() {
    var parameter = new Array();
    parameter[0] = arr_userinfo[4];
    parameter[1] = "A01000";

    if (CrossYN() || pNoneActiveX == "YES") {
        getFormCont_dialogArguments[0] = parameter;
        getFormCont_dialogArguments[1] = AprManage_B_Complete;
        var getFormCont = GetOpenWindow("/myoffice/ezApproval/formContainer/getFormCont.aspx", "getFormCont", 713, 570, "NO");
    }
    else {
        var url = "/myoffice/ezApproval/formContainer/getFormCont.aspx";
        var feature = "center:yes;status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no;";
        feature = feature + GetShowModalPosition(713, 570);

        var ret;
        if (window.showModalDialog) {
            ret = window.showModalDialog(url, parameter, feature);
        }
        else {
            ret = GetOpenWindow("/myoffice/ezApproval/formContainer/getFormCont.aspx", "getFormCont", 713, 570, "NO");
        }
        formURL = ret[0];
        if (formURL != "cancel")
        {
            formDocType = ret[1];
            formID = ret[2];
            reFormFlag = ret[4];
            openDraftUI("DRAFT", "");
        }        
    }
}

function AprManage_B_Complete(Rtnval)
{
    formURL = Rtnval[0];
    formDocType = Rtnval[1];
    formID = Rtnval[2];
    reFormFlag = Rtnval[4];

    if (formURL != "cancel") {
        openDraftUI("DRAFT", "");
    }
}

function openViewDocInfo(type) {
    if (type == undefined)
        type = "";
    
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];
    var pArgument = new Array();
    pArgument[0] = GetAttribute(tr, "DATA1");
    pArgument[1] = GetAttribute(tr, "DATA3");
    var formURL = GetAttribute(tr, "DATA3");

    if (pListTypeValue == "4" || pListTypeValue == "6") {
        pArgument[2] = GetAttribute(tr, "DATA5");
        pArgument[3] = "VIEW";
        pArgument[4] = pSusinManagerFlag;
        pArgument[5] = GetAttribute(tr, "DATA7");
        pArgument[6] = "OPINION_SHOW"
    }
    else {
        pArgument[2] = GetAttribute(tr, "DATA11");
        pArgument[3] = GetAttribute(tr, "DATA12");
        pArgument[5] = GetAttribute(tr, "DATA2");

        if (pListTypeValue != "5")
            pArgument[6] = "OPINION_SHOW";
        else
            pArgument[6] = "OPINION_HIDE";
    }
    pArgument[7] = pListTypeValue;
    var openLocation = "";
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
        if (CrossYN() || pNoneActiveX == "YES") {
            openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewApr_HWP_Cross.aspx";
        }
        else {
            openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewApr_HWP.aspx";
        }
    }
    else {        
        if (CrossYN() || pNoneActiveX == "YES") 
            openLocation = "/myoffice/ezApproval/aprDocView_Cross.aspx";       
        else {
            if (pUse_Editor == "")
                openLocation = "/myoffice/ezApproval/aprDocView.aspx";
            else
                openLocation = "/myoffice/ezApproval/aprDocView_IE.aspx";
        }
    }
    openLocation = openLocation + "?DocID=" + escape(pArgument[0]) + "&DocHref=" + escape(pArgument[1]) + "&OpinionFlag=" + escape(trim_Cross(pArgument[2])) + "&docState=" + escape(trim_Cross(pArgument[3])) + "&ListSusin=" + escape(trim_Cross(pArgument[4])) + "&odoc=" + escape(trim_Cross(pArgument[5]));
    openLocation = openLocation + "&isOpinion=" + escape(trim_Cross(pArgument[6]));
    openLocation = openLocation + "&ListType=" + escape(trim_Cross(pArgument[7]));
    openLocation = openLocation + "&CallBackType=" + escape(trim_Cross(type));
    //GetOpenWindow(openLocation, "", 1000, 950, "YES");
    openwindow(openLocation, "", 880, 570);
}

function OpenReceiveAssignUI(pCurSelRow) {
    var parameter = pCurSelRow;
    var url = "/myoffice/ezApproval/ezAPRRECEIVE/ezReceiveAssignUI.htm";
    var feature = "status:no;dialogWidth:620px;dialogHeight:455px;edge:sunken;scroll:no"
    feature = feature + GetShowModalPosition(620, 455);
    var ret = window.showModalDialog(url, parameter, feature);
    if (window.showModalDialog) {
        ret = window.showModalDialog(url, parameter, feature);
    }
    else {
        ret = GetOpenWindow(url, parameter, 713, 570, "NO");
    }
    getReceivedDocList();
}
function OpenAllReceiveDraftUI(pDocID, pURL) {
    var pDraftFlag = "SUSIN";
    var openLocation = "";
    if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
        if (CrossYN() || pNoneActiveX == "YES") {
            alert(strLang1103);
            return;
        }
        else {
            openLocation = "/myoffice/ezApproval/ezViewHWP/ezRecevUI_HWP.aspx";
        }
    }
    else {
        if (CrossYN() || pNoneActiveX == "YES") {
            openLocation = "/myoffice/ezApproval/ReceivUI/Recev_End_Cross.aspx";
        }
        else {
            if (pUse_Editor == "")
                openLocation = "/myoffice/ezApproval/ReceivUI/recev_end.aspx";
            else
                openLocation = "/myoffice/ezApproval/ReceivUI/recev_end_IE.aspx";
        }
    }
    openLocation = openLocation + "?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag) + "&AllFlag=2";
    //GetOpenWindow(openLocation, "receive", 1000, 950, "YES");
    openwindow(openLocation, "", 880, 570);
}

function OpenReceiveDraftUI(pCurSelRow, pDraftFlag) {
    var openLocation = "";
    if (pCurSelRow != null) {
        var pURL = GetAttribute(pCurSelRow, "DATA3")
        var pDocID = GetAttribute(pCurSelRow, "DATA1")
        if (pDraftFlag == "SUSIN") {
            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
                if (CrossYN() || pNoneActiveX == "YES") {
                    alert(strLang1105);
                    return;
                }
                else {
                    openLocation = "/myoffice/ezApproval/ezViewHWP/ezRecevUI_HWP.aspx";
                }
            }
            else {
                if (CrossYN() || pNoneActiveX == "YES") {
                    openLocation = "/myoffice/ezApproval/ReceivUI/Recev_End_Cross.aspx";
                }
                else {
                    if (pUse_Editor == "")
                        openLocation = "/myoffice/ezApproval/ReceivUI/recev_end.aspx";
                    else
                        openLocation = "/myoffice/ezApproval/ReceivUI/recev_end_IE.aspx";
                }
            }
            openLocation = openLocation + "?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag) + "&DocHref=" + escape(pURL);
            //GetOpenWindow(openLocation, "receive", 1000, 950, "YES");
            openwindow(openLocation, "", 880, 570);
        }
        else {
            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
                if (CrossYN() || pNoneActiveX == "YES") {
                    alert(strLang1105);
                    return;
                }
                else {
                    openLocation = "/myoffice/ezApproval/ezViewHWP/ezDeptRecevUI_HWP.aspx";
                }
            }
            else {
                if (CrossYN() || pNoneActiveX == "YES") {
                    openLocation = "/myoffice/ezApproval/ReceivUI/Recev_Cross.aspx";
                }
                else {
                    if (pUse_Editor == "")
                        openLocation = "/myoffice/ezApproval/ReceivUI/recev.aspx";
                    else
                        openLocation = "/myoffice/ezApproval/ReceivUI/recev_IE.aspx";
                }
            }
            openLocation = openLocation + "?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag) + "&DocHref=" + escape(pURL);
            GetOpenWindow(openLocation, "receive", 1000, 950, "YES");            
        }
    } else {
        var pAlertContent = strLang465;
        OpenAlertUI(pAlertContent);
        return;
    }
}
function OpenReceiveENDDraftUI(pCurSelRow, pDraftFlag) {
    if (pCurSelRow != null) {
        var pArgument = new Array();
        pArgument[0] = GetAttribute(pCurSelRow, "DATA1");
        pArgument[1] = GetAttribute(pCurSelRow, "DATA2");

        var pURL = GetAttribute(pCurSelRow, "DATA3");
        var openLocation = "";
        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
            if (CrossYN() || pNoneActiveX == "YES") {
                alert(strLang1103);
                return;
            }
            else {
                openLocation = "/myoffice/ezApproval/ezViewHWP/ezRecevUI_HWP.aspx?DocID=" + escape(pArgument[0]) + "&DraftFlag=" + escape(pDraftFlag);
            }
        }
        else {
            if (CrossYN() || pNoneActiveX == "YES") {
                openLocation = "/myoffice/ezApproval/ReceivUI/Recev_End_Cross.aspx?DocID=" + escape(pArgument[0]);
            }
            else {
                if (pUse_Editor == "")
                    openLocation = "/myoffice/ezApproval/ReceivUI/Recev_end.aspx?DocID=" + escape(pArgument[0]);
                else
                    openLocation = "/myoffice/ezApproval/ReceivUI/Recev_end_IE.aspx?DocID=" + escape(pArgument[0]);
            }
        }
        openLocation = openLocation + "&uorgID=" + escape(pArgument[1]) + "&isReDraft=" + escape("Y") + "&DocHref=" + escape(pURL);;
        GetOpenWindow(openLocation, "receive", 1000, 950, "YES");
    } else {
        var pAlertContent = strLang465;
        OpenAlertUI(pAlertContent);
        return;
    }
}

function OpenReceiveDistributeUI(pCurSelRow) {
    var parameter = pCurSelRow;
    var url = "/myoffice/ezApproval/ezAPRRECEIVE/ezReceiveDistributeUI.aspx";
    var feature = "status:no;dialogWidth:540px;dialogHeight:460px;edge:sunken;scroll:no"
    feature = feature + GetShowModalPosition(540, 460);
    var ret = window.showModalDialog(url, parameter, feature);
    getReceivedDocList();
}
var AprOpinion_dialogArgument = new Array();
var SelectRow;
function OpenOpinionUI(pSelectedRow, pOpinionFlag) {
    try {
        SelectRow = pSelectedRow;
        var parameter = new Array();
        parameter[0] = GetAttribute(pSelectedRow, "DATA1");
        parameter[1] = pOpinionFlag;
        parameter[2] = KuyjeType;
        parameter[3] = "";
        if (CrossYN() || pNoneActiveX == "YES") {
            AprOpinion_dialogArgument[0] = parameter;
            AprOpinion_dialogArgument[1] = Aprmanage_openOpinionUI_Complete;
            var result = GetOpenWindow("/myoffice/ezApproval/ezAPROPINION/AprOpinion.aspx?type=open", "AprOpinion_Cross", 530, 520, "NO");
        }
        else {
            var url = "/myoffice/ezApproval/ezAPROPINION/AprOpinion.aspx";
            var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no";
            feature = feature + GetShowModalPosition(530, 520);
            var ret = window.showModalDialog(url, parameter, feature);
            Aprmanage_openOpinionUI_Complete(ret);
        }
    } catch (e) {
        alert("OpenOpinionUI :: " + e.description);
    }
}
function Aprmanage_openOpinionUI_Complete(RtnVal)
{
    
    if (RtnVal != "cancel") {
        if (pListTypeValue == "4") {
            switch (GetAttribute(SelectRow, "DATA9")) {
                case strDocState12:
                    setHeSongHapyuiDocInfo(SelectRow);
                    break;

                case strDocState11:
                    setHeSongDocInfo(SelectRow);
                    break;

                case strDocState14:
                    setHeSongGamsaDocInfo(SelectRow);
                    break;
            }
        }
        else {
            switch (GetAttribute(SelectRow, "DATA12")) {
                case strDocState12:
                    setHeSongHapyuiDocInfo(SelectRow);
                    break;

                case strDocState11:
                    setHeSongDocInfo(SelectRow);
                    break;

                case strDocState14:
                    setHeSongGamsaDocInfo(SelectRow);
                    break;
            }
        }
    }
}
function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApproval/ezAPRALERT_Cross.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);
}
function OpenInformationUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/myoffice/ezApproval/ezAPROPINION_Cross.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal;
    RtnVal = window.showModalDialog(url, parameter, feature);
    return RtnVal;
}

var totalPages;
function setbuttonenable() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];
    if (pListTypeValue == "1")
        document.getElementById("tbtnApproveALL").style.display = "";
    else
        document.getElementById("tbtnApproveALL").style.display = "none";

    if (pListTypeValue == "4" && oArrRows.length == 0)
        document.getElementById("tbar1").style.display = "none";

    if (pListTypeValue != 1 && pListTypeValue != 4) {
        document.getElementById("tbtnRedraft").style.display = "none";
        document.getElementById("tbtnRemoveDoc").style.display = "none";
        document.getElementById("tbtnRegList").style.display = "none";
        document.getElementById("tbtnApprove").style.display = "none";
        document.getElementById("tbtnReceipt").style.display = "none";
        document.getElementById("tbtnReturn").style.display = "none";
        document.getElementById("tbtnSimsa").style.display = "none";
        if (oArrRows.length != 0) {
            document.getElementById("tbtnViewDoc").style.display = "";
        }
        else {
            document.getElementById("tbtnViewDoc").style.display = "none";
        }

        if (pListTypeValue == "6") {
            if (oArrRows.length != 0) {
                if (GetAttribute(tr, "DATA10") == strAprState2) {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                    document.getElementById("tbtnRegList").style.display = "none";
                    document.getElementById("tbtnSimsa").style.display = "";
                    document.getElementById("tbar1").style.display = "";
                }
                else if (GetAttribute(tr, "DATA10") == strAprState4) {
                    document.getElementById("tbtnRemoveDoc").style.display = "";
                    document.getElementById("tbtnRegList").style.display = "";
                    document.getElementById("tbtnSimsa").style.display = "none";
                    document.getElementById("tbar1").style.display = "none";
                }
                else {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                    document.getElementById("tbtnRegList").style.display = "none";
                    document.getElementById("tbtnSimsa").style.display = "none";
                    document.getElementById("tbar1").style.display = "none";
                }
            }
            else {
                document.getElementById("tbtnRemoveDoc").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
                document.getElementById("tbtnSimsa").style.display = "none";
                document.getElementById("tbar1").style.display = "none";
            }
        }
        else if (pListTypeValue == "9") {
            if (oArrRows.length > 0) {
                document.getElementById("tbtnDraft").style.display = "";
                document.getElementById("tbtnRedraft").style.display = "";
                document.getElementById("tbtnRemoveDoc").style.display = "";
                document.getElementById("tbtnRegList").style.display = "none";
                document.getElementById("tbtnReturn").style.display = "none";
                document.getElementById("tbtnTotalSave").style.display = "none";
            }
            else {
                document.getElementById("tbtnDraft").style.display = "";
                document.getElementById("tbtnRemoveDoc").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
                document.getElementById("tbtnSimsa").style.display = "none";
            }
        }
        else if (pListTypeValue == "2") {
            document.getElementById("tbtnRemoveDoc").style.display = "";
        }
    }
    else if (pListTypeValue == 1) {
        document.getElementById("tbtnSimsa").style.display = "none";

        if (oArrRows.length != 0) {
            pFunctionType = GetAttribute(tr, "DATA10");

            if (pFunctionType == strAprState4 || pFunctionType == strAprState6 || pFunctionType == strAprState15) {
                document.getElementById("tbtnDraft").style.display = "";
                document.getElementById("tbtnRedraft").style.display = "";
                document.getElementById("tbtnApprove").style.display = "none";
                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnReturn").style.display = "none";

                if (GetAttribute(tr, "DATA9") != "0") {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                    document.getElementById("tbtnRegList").style.display = "none";
                    document.getElementById("tbtnReturn").style.display = "";
                }
                else if (GetAttribute(tr, "DATA12") == strDocState11 || GetAttribute(tr, "DATA12") == strDocState12 || GetAttribute(tr, "DATA12") == strDocState14) {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                    document.getElementById("tbtnRegList").style.display = "none";
                    document.getElementById("tbtnReturn").style.display = "";
                }
                else {
                    document.getElementById("tbtnRemoveDoc").style.display = "";
                    document.getElementById("tbtnRegList").style.display = "";
                    document.getElementById("tbtnReturn").style.display = "none";
                }
            }
            else {
                document.getElementById("tbtnDraft").style.display = "";
                document.getElementById("tbtnRedraft").style.display = "none";
                document.getElementById("tbtnRemoveDoc").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
                document.getElementById("tbtnApprove").style.display = "";
                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnReturn").style.display = "none";
            }
            document.getElementById("tbtnViewDoc").style.display = "";
        }
        else {
            document.getElementById("tbtnDraft").style.display = "";
            document.getElementById("tbtnRedraft").style.display = "none";
            document.getElementById("tbtnRemoveDoc").style.display = "none";
            document.getElementById("tbtnRegList").style.display = "none";
            document.getElementById("tbtnApprove").style.display = "none";
            document.getElementById("tbtnReceipt").style.display = "none";
            document.getElementById("tbtnViewDoc").style.display = "none";
            document.getElementById("tbtnReturn").style.display = "none";
        }
    }
    else {
        document.getElementById("tbtnSimsa").style.display = "none";
        if (oArrRows.length != 0) {
            pFunctionType = GetAttribute(tr, "DATA10");
            document.getElementById("tbtnViewDoc").style.display = "";
            if (pFunctionType == strAprState11 || pFunctionType == strAprState12 || pFunctionType == strAprState14) {
                document.getElementById("tbtnDraft").style.display = "";
                document.getElementById("tbtnRedraft").style.display = "none";
                document.getElementById("tbtnRemoveDoc").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
                document.getElementById("tbtnApprove").style.display = "none";
                document.getElementById("tbtnReceipt").style.display = "";
                document.getElementById("tbtnReturn").style.display = "";
                if (GetAttribute(tr, "DATA9") == strDocState12)
                    document.getElementById("tbtnViewDoc").style.display = "none";

            }
            else if (pFunctionType == strAprState15) {
                document.getElementById("tbtnDraft").style.display = "";
                document.getElementById("tbtnRedraft").style.display = "none";
                document.getElementById("tbtnRemoveDoc").style.display = "";
                document.getElementById("tbtnRegList").style.display = "";
                document.getElementById("tbtnApprove").style.display = "none";
                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnReturn").style.display = "none";
            }
        }
        else {
            document.getElementById("tbtnDraft").style.display = "";
            document.getElementById("tbtnRedraft").style.display = "none";
            document.getElementById("tbtnRemoveDoc").style.display = "none";
            document.getElementById("tbtnRegList").style.display = "none";
            document.getElementById("tbtnApprove").style.display = "none";
            document.getElementById("tbtnReceipt").style.display = "none";
            document.getElementById("tbtnViewDoc").style.display = "none";
            document.getElementById("tbtnReturn").style.display = "none";
        }
    }

    if (pListTypeValue != "2" && pListTypeValue != "3")
        document.getElementById("tbtncallback").style.display = "none";

    if (GetBujaeFlag()) {
        document.getElementById("tbtnDraft").style.display = "none";
        document.getElementById("tbtnRedraft").style.display = "none";
        document.getElementById("tbtnRemoveDoc").style.display = "none";
        document.getElementById("tbtnRegList").style.display = "none";
        document.getElementById("tbtnApprove").style.display = "none";
        document.getElementById("tbtnReceipt").style.display = "none";
        document.getElementById("tbtnReturn").style.display = "none";
        document.getElementById("tbtncallback").style.display = "none";
        try {
            document.getElementById("tbtnSimsa").style.display = "none";
        } catch (e) { }
    }
    if (oArrRows.length != "0") {
        var pDocType = GetAttribute(tr, "DATA15");

        if (pDocType == strDocType4) {
            document.getElementById("tbtnRedraft").style.display = "none";
        }
    }

    if (pListTypeValue == "4") {
        document.getElementById("tbtnReturn").style.display = "none";
        document.getElementById("tbtnViewDoc").style.display = "none";
    }
    return true;
}
function selFirstRow(Resultxml) {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];
    if (oArrRows.length != 0) {
        pDocID = GetAttribute(tr, "DATA1");
        pURL = GetAttribute(tr, "DATA2");
    }
    else {
        pDocID = "";
        pURL = "";
    }
    switch (pDocInfoValue) {
        case "4":
            getDataInfo("3");
            break;
        case "3":
            getDataInfo("4");
            break;
        case "1":
            getDataInfo("1");
            break;
        case "2":
            getDataInfo("2")
            break;
    }
}
function hideProgress() {
    try {
        if (g_progresswin)
            g_progresswin.close();
    } catch (e) {
    }
}
function check_presence() {
    try {
        var pCNList = new Array();
        var AprLine = new ListView();
        AprLine.LoadFromID("AprLine");
        var oArrRows = AprLine.GetDataRows();
        for (var i = 0; i < oArrRows.length; i++) {
            var tr = oArrRows[i];
            pCNList[i] = GetAttribute(tr, "DATA4");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (var i = 0; i < oArrRows.length; i++) {
            var tr = oArrRows[i];
            tr.cells[1].innerHTML = "<div><img style='vertical-align:middle;padding-right:5px;' src='/images/Presence/unknown.gif' id ='" + GetGUID() + "' onload='PresenceControl(\"" + pSIPUriList[i] + "\",this);' /><span style='vertical-align:middle;'>" + tr.cells[1].innerHTML + "</span></div>";
        }
        pSIPUriList = null;
    } catch (e) { }
}
function check_presence_DocList() {
    try {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var oArrRows = DocList.GetDataRows();
        var pCNList = new Array();
        for (var i = 0; i < oArrRows.length; i++) {
            var tr = oArrRows[i];
            pCNList[i] = GetAttribute(tr, "DATA16");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (var i = 0; i < oArrRows.length; i++) {
            var tr = oArrRows[i];
            tr.cells[2].innerHTML = "<div><img style='vertical-align:middle;padding-right:5px;' src='/images/Presence/unknown.gif' id ='" + GetGUID() + "' onload='PresenceControl(\"" + pSIPUriList[i] + "\",this);' /><span style='vertical-align:middle;'>" + tr.cells[2].innerHTML + "</span></div>";
        }
        pSIPUriList = null;
    } catch (e) { }
}
var BlockSize = 10;
function td_Create1(strtext) {
    document.getElementById("tblPageRayer").innerHTML = strtext;
}
function makePageSelPage() {
    var strtext;
    var PagingHTML = "";
    document.getElementById("tblPageRayer").innerHTML = "";

    var period;
    if (document.getElementById("sel_year").value.toLowerCase() == "all") {
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        var settingDate = new Date();
        settingDate.setYear(settingDate.getYear() - 1);

        var settingmonth = settingDate.getMonth() + 1;
        var settingday = settingDate.getDate();
        if (settingmonth < 10)
            settingmonth = "0" + settingmonth;
        if (settingday < 10)
            settingday = "0" + settingday;

        period = (nowyear - 1) + strLang100 + settingmonth + strLang101 + settingday + strLang102 + " ~ " + nowyear + strLang100 + nowmonth + strLang101 + nowday + strLang102;
    }
    else {
        period = document.getElementById("sel_year").value + strLang100 + " 1" + strLang101 + " 1" + strLang102 + " ~ " + document.getElementById("sel_year").value + strLang100 + "12" + strLang101 + " 31" + strLang102;
    }

    if (ViewLeftCount == "YES") {
        switch (pListTypeValue) {
            case "1":
                if (window.parent.frames["left"].document.getElementById("countsub0") != null && window.parent.frames["left"].document.getElementById("countsub0").parentElement.parentElement.className == "on") {
                }
                else {
                    window.parent.frames["left"].document.getElementById('count1').innerHTML = "<b>(" + pTotalCnt + ")</b>";
                }
                break;
            case "2":
                window.parent.frames["left"].document.getElementById('count2').innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "3":
                window.parent.frames["left"].document.getElementById('count3').innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "4":
                window.parent.frames["left"].document.getElementById('count4').innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "6":
                window.parent.frames["left"].document.getElementById('count6').innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
        }
    }

    document.getElementById("mailBoxInfo").innerHTML = " &nbsp;[" + strLang566 + "<span style='color:#017BEC;'> " + pTotalCnt + " </span>" + strLang567 + " - " + period + "]";
    strtext = "<div class='pagenavi'>";
    PagingHTML += strtext;
    if (totalPage > 1 && pageNum != 1) {
        strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/Sub/btn_p_prev.gif' width='16' height='16'></span>"
        PagingHTML += strtext;
    }
    else {
        strtext = "<span class='btnimg'><img src='/images/Sub/btn_p_prev01.gif' width='16' height='16'></span>"
        PagingHTML += strtext;
    }
    if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
            strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/Sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang564 + "</span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang564 + "</span>";
            PagingHTML += strtext;
        }
    }
    else {
        strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang564 + "</span>";
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
    if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang565 + "</span>";
            strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/Sub/btn_next.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang565 + "</span>";
            strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
    }
    else {
        strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang565 + "</span>";
        strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
        PagingHTML += strtext;
    }
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/Sub/btn_n_next.gif' width='16' height='16'></span>";
        PagingHTML += strtext;
    }
    else {
        strtext = "<span class='btnimg'><img src='/images/Sub/btn_n_next01.gif' width='16' height='16'></span>";
        PagingHTML += strtext;
    }
    PagingHTML += "</div>";
    td_Create1(PagingHTML);
}
function goToPageByNum(Value) {
    currentpage = Value;
    pageNum = currentpage;
    makePageSelPage();
    if (pListTypeValue == "6") {
        getSimsaDocList();
    }
    else if (pSelMenu == "hyubjo" || pSelMenu == "gamsa" || pListTypeValue == "4")
        getReceivedDocList();
    else
        getDocList();
}
function selbeforeBlock() {
    var pageNum = currentpage;
    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selbeforeBlock_one() {
    if (parseInt(pageNum - 1) > 0)
        goToPageByNum(parseInt(pageNum - 1));
    else
        return;
}
function selafterBlock() {
    var pageNum = currentpage;
    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock_one() {
    if (parseInt(pageNum + 1) <= totalPage)
        goToPageByNum(parseInt(pageNum + 1));
    else
        return;
}
function selNum(pselNum) {
    pageNum = pselNum;

    if (pListTypeValue == "6") {
        getSimsaDocList();
    }
    else if (pSelMenu == "hyubjo" || pSelMenu == "gamsa" || pListTypeValue == "4") {
        getReceivedDocList();
    }
    else {
        getDocList();
    }
}
function selNext() {
    pageNum = pageNum + 1;
    if (pListTypeValue == "6") {
        getSimsaDocList();
    }
    else if (pSelMenu == "hyubjo" || pSelMenu == "gamsa" || pListTypeValue == "4")
        getReceivedDocList();
    else
        getDocList();
}
function selPrev() {
    pageNum = pageNum - 1;

    if (pListTypeValue == "6") {
        getSimsaDocList();
    }
    else if (pSelMenu == "hyubjo" || pSelMenu == "gamsa" || pListTypeValue == "4")
        getReceivedDocList();
    else
        getDocList();
}
function selbeforeBlock() {
    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;

    if (pListTypeValue == "6") {
        getSimsaDocList();
    }
    else if (pSelMenu == "hyubjo" || pSelMenu == "gamsa" || pListTypeValue == "4")
        getReceivedDocList();
    else
        getDocList();
}
function selafterBlock() {
    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;

    if (pListTypeValue == "6") {
        getSimsaDocList();
    }
    else if (pSelMenu == "hyubjo" || pSelMenu == "gamsa" || pListTypeValue == "4")
        getReceivedDocList();
    else
        getDocList();
}
function td_Create(strtext) {
    tblPageNum.innerHTML = tblPageNum.innerHTML + strtext;
}

var getformcont_cross_dialogArguments = new Array();
function openForm_reform() {
    var parameter = new Array();
    parameter[0] = arr_userinfo[4];
    parameter[1] = "A01000";

    if (CrossYN() || pNoneActiveX == "YES") {
        getformcont_cross_dialogArguments[0] = parameter;
        getformcont_cross_dialogArguments[1] = aprmanage_B_Cross_reform_Complete;
        var getFormCont_Cross = GetOpenWindow("/myoffice/ezApproval/formContainer/getFormCont_Cross.aspx?Flag=Y", "getFormCont_Cross", 713, 570, "NO");
    }
    else {
        var url = "/myoffice/ezApproval/formContainer/getFormCont_Cross.aspx?Flag=Y";
        var feature = "center:yes;status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no;";
        feature = feature + GetShowModalPosition(713, 570);

        var ret;
        if (window.showModalDialog) {
            ret = window.showModalDialog(url, parameter, feature);
        }
        else {
            ret = GetOpenWindow("/myoffice/ezApproval/formContainer/getFormCont_Cross.aspx", "getFormCont_Cross", 713, 570, "NO");
        }
        formURL = ret[0];
        formDocType = ret[1];
        formID = ret[2];
        reFormFlag = ret[4];
        if (formURL != "cancel") {
            openDraftUI_reform("DRAFT", "");
        }
    }
}

function openDraftUI_reform(pDraftFlag, pCurSelRow) {
    var pArgument = new Array();

    pArgument[0] = pUserID;
    pArgument[1] = formURL;
    pArgument[2] = pDraftFlag;
    pArgument[3] = formDocType;
    pArgument[8] = formID;
    pArgument[9] = reFormFlag;

    if (pCurSelRow) {
        if (pListTypeValue != "5") {
            pArgument[4] = pCurSelRow.getAttribute("DATA9");
            pArgument[5] = pCurSelRow.getAttribute("DATA12");
            pArgument[6] = pCurSelRow.getAttribute("DATA10");
            pArgument[7] = "";
        }
        else {
            pArgument[4] = "0";
            pArgument[5] = "";
            pArgument[6] = "";
            pArgument[7] = newDocID;
        }
        pArgument[3] = pCurSelRow.getAttribute("DATA15");
    }
    else {
        pArgument[4] = "0"
        pArgument[5] = ""
        pArgument[6] = ""
        pArgument[7] = "";
    }
    var temppListTypeValue = pListTypeValue;
    pListTypeValue = "1";
    var openLocation = "";
    openLocation = "/myoffice/ezApproval/DraftUI/draftui_reform.aspx";
    if (CrossYN() || pNoneActiveX == "YES")
        openLocation = "/myoffice/ezApproval/DraftUI/draftui_reform_Cross.aspx";
    openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&DraftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
    openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&DocState=" + escape(pArgument[5]) + "&ListType=" + escape(pListTypeValue) + "&AprState=" + escape(pArgument[6]);
    openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]) + "&formID=" + escape(pArgument[8]) + "&reFormFlag=" + escape(pArgument[9]);
    var result = GetOpenWindow(openLocation, "", 1000, 950, "NO");
    pListTypeValue = temppListTypeValue;
}

function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;

            pleftpos = parseInt(width) - 1150;
            heigth = parseInt(heigth) - 30;

            if (CrossYN())
                heigth = parseInt(heigth) - 25;

            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
                heigth = parseInt(heigth) - 40;

            width = parseInt(width) - pleftpos;

            left = pleftpos / 2;
        }
        else {
            heigth = parseInt(heigth) - 30;

            if (CrossYN())
                heigth = parseInt(heigth) - 25;

            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
                heigth = parseInt(heigth) - 40;

            width = parseInt(width) - 10;
        }

        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
    }
    catch (e) {
        alert("openwindow :: " + e.description);
    }
}