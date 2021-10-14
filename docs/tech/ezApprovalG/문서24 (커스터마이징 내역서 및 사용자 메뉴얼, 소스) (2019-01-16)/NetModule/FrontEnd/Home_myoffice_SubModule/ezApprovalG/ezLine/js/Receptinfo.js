
function Receptinfo_ini() {
    if (!Recinfoini) {
        Recinfoini = true;
        Tree_setconfig();
        TreeViewinitialize_tree2(arr_userinfo[4], companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayname", "<%=_pServerName%>");
        ChangeReceptTab(document.getElementById("3tab1"));
        initReceptListView();
        document.getElementById("3tab1").onclick();
        
        SelDivName = "Organ";
    }
}

function ChangeReceptTab(obj) {
    if (GetAttribute(obj,"divname") == "Organ") {
        document.getElementById("ReceptOrgan").style.display = "";
        document.getElementById("ReceptTemp").style.display = "none";
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("ReceptOuter").style.display = "none";
        document.getElementById("btnaddressChange").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "";
        document.getElementById("AprDeptOuterAdd").style.display = "none";
		document.getElementById("ReceptOuterDoc24").style.display = "none"; //2018.11.25 문서24
        internalTab = true;
        SelDivName = "Organ";
        document.getElementById("imgInsertAll").style.display = "";
        document.getElementById("imgDeleteAll").style.display = "";
        document.getElementById("AddRemoveBTN").style.display = "";
    }
    else if (GetAttribute(obj,"divname") == "Save") {
        if (!Recinfoini3) {
            Recinfoini3 = true;
            InitReceptTemplet();
        }
        document.getElementById("ReceptOrgan").style.display = "none";
        document.getElementById("ReceptTemp").style.display = "";
        document.getElementById("ReceptOuter").style.display = "none";
        document.getElementById("ReceptOuterDoc24").style.display = "none"; //2018.11.25 문서24
        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");

        if (listview.GetDataRows().length > 0 && GetAttribute(listview.GetDataRows()[0],"DATA3") == "Y")
            document.getElementById("btnaddressChange").style.display = "";
        else {
            document.getElementById("btnaddressChange").style.display = "none";
        }
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "";
        document.getElementById("AprDeptOuterAdd").style.display = "none";
        
        document.getElementById("AddRemoveBTN").style.display = "none";
    }
    else if (GetAttribute(obj,"divname") == "Group") {
        if (!Recinfoini2) {
            Recinfoini2 = true;
            liniReceptGroup();
        }
        document.getElementById("ReceptOrgan").style.display = "none";
        document.getElementById("ReceptTemp").style.display = "none";
        document.getElementById("ReceptOuter").style.display = "none";
        document.getElementById("btnaddressChange").style.display = "none";
        document.getElementById("ReceptGroup").style.display = "";
        document.getElementById("AprDeptAdd").style.display = "";
        document.getElementById("AprDeptOuterAdd").style.display = "none";
        
        document.getElementById("AddRemoveBTN").style.display = "none";
    }
    else if (GetAttribute(obj,"divname") == "Outer") {
        document.getElementById("ReceptOrgan").style.display = "none";
        document.getElementById("ReceptTemp").style.display = "none";
        document.getElementById("ReceptOuter").style.display = "";
        document.getElementById("ReceptOuterDoc24").style.display = "none"; //2018.11.25 문서24
        document.getElementById("btnaddressChange").style.display = "";
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "none";
        document.getElementById("AprDeptOuterAdd").style.display = "";
        internalTab = false;
        
        SelDivName = "Outer";
        document.getElementById("imgInsertAll").style.display = "none";
        document.getElementById("imgDeleteAll").style.display = "none";
        document.getElementById("AddRemoveBTN").style.display = "";
    }
    else if (GetAttribute(obj, "divname") == "OuterDoc24") {    //2018.11.25 문서24
        if (!Recinfoini5) {
            Recinfoini5 = true;
            liniReceptDoc24();
        }

        document.getElementById("ReceptOrgan").style.display = "none";
        document.getElementById("ReceptTemp").style.display = "none";
        document.getElementById("ReceptOuter").style.display = "none";
        document.getElementById("ReceptOuterDoc24").style.display = "";
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "none";
        document.getElementById("AprDeptOuterAdd").style.display = "none";
        internalTab = false;
        SelDivName = "OuterDoc24";
        document.getElementById("imgInsertAll").style.display = "none";
        document.getElementById("imgDeleteAll").style.display = "none";
        document.getElementById("AddRemoveBTN").style.display = "none";
    }
}


var xmlhttp;
function initReceptListView() {
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    if (pDocSn == "") {
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pMode", "COD");
    }
    else {
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocSn);
        createNodeAndInsertText(xmlpara, objNode, "pMode", "TMP");
    }

    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/AprDeptRequest.aspx", false);
    xmlhttp.send(xmlpara);
    Resultxml = loadXMLString(xmlhttp.responseText);

    if (SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW").length > 9) {
        document.getElementById("inputSummaryOuterReceiverList").focus();
        document.getElementById("trSummaryOuterReceiverList").style.display = "";
        document.getElementById("btnaddress").style.display = "none";
        document.getElementById("btnaddressChange").style.display = "none";
    }

    document.getElementById('RECEPTLIST').innerHTML = "";
    var listview = new ListView();
    listview.SetID("lvRECEPTLIST");
    listview.SetMulSelectable(false);
    listview.SetHeightFree(true);
    listview.SetRowOnDblClick("AprDeptDel_onclick");
    listview.DataSource(Resultxml);
    listview.DataBind("RECEPTLIST");
    listview.SetSelectFlag(false);
    xmlhttp = null;

}
function event_initReceptListView() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        Resultxml = loadXMLString(xmlhttp.responseText);

        document.getElementById('RECEPTLIST').innerHTML = "";
        var listview = new ListView();
        listview.SetID("lvRECEPTLIST");
        listview.SetMulSelectable(false);
        listview.SetHeightFree(true);
        listview.SetRowOnDblClick("AprDeptDel_onclick");
        listview.DataSource(Resultxml);
        listview.DataBind("RECEPTLIST");
        listview.SetSelectFlag(false);
        xmlhttp = null;
    }
    catch (ErrMsg) {
        alert(" initReceptListView : " + ErrMsg.description);
    }
}

var xmlHTTP;
function TreeViewinitialize_tree2(targetDeptID, TopDeptID, tProperty, ServerName) {
    try {
        Tree_setconfig();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", targetDeptID);
        createNodeAndInsertText(xmlpara, objNode, "TOPID", TopDeptID);
        createNodeAndInsertText(xmlpara, objNode, "PROP", tProperty);

        xmlHTTP = createXMLHttpRequest();
        xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptTreeInfo.aspx", false);
        xmlHTTP.send(xmlpara);
        var xmlDomRet = createXmlDom();
        xmlDomRet = loadXMLString(xmlHTTP.responseText);

        var treeView = new TreeView();
        treeView.SetID("tvTreeView2");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("RequestData2");
        treeView.SetNodeClick("TreeViewNodeClick2");
        treeView.DataSource(xmlDomRet);
        treeView.DataBind("TreeView2");
        xmlHTTP = null;
    }
    catch (ErrMsg) {
        alert(" TreeViewinitialize : " + ErrMsg.description);
    }
}
function event_TreeViewinitialize_tree2() {
    if (xmlHTTP == null || xmlHTTP.readyState != 4) return;
    try {
        var xmlDomRet = createXmlDom();
        xmlDomRet = loadXMLString(xmlHTTP.responseText);

        var treeView = new TreeView();
        treeView.SetID("tvTreeView2");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("RequestData2");
        treeView.SetNodeClick("TreeViewNodeClick2");
        treeView.DataSource(xmlDomRet);
        treeView.DataBind("TreeView2");
        xmlHTTP = null;
    }
    catch (ErrMsg) {
        alert(" TreeViewinitialize : " + ErrMsg.description);
    }
}

var nodeIdx;
function TreeViewNodeClick2(pNodeID, pNodeNM) {
    nodeIdx = pNodeID;

    var treeNode = new TreeNode();
    treeNode.LoadFromID(nodeIdx);
}
function RequestData2(pNodeID, pTreeID) {
    nodeIdx = pNodeID;
    var xmlHTTP = createXMLHttpRequest();

    var treeNode = new TreeNode();
    treeNode.LoadFromID(pNodeID);

    var strQuery = "<DATA><DEPTID>" + treeNode.GetNodeData("CN") + "</DEPTID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;DisplayName</PROP></DATA>";

    xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptSubTreeInfo.aspx", false);
    xmlHTTP.send(strQuery);


    var treeView = new TreeView();
    treeView.LoadFromID(pTreeID);
    treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID)
}

var ReceptUserXmlHttp;
function RdisplayUserList(DeptID) {
    var xmlpara = createXmlDom();


    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA"); 
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "CELL", "displayname;Description;Title;telephonenumber");
    createNodeAndInsertText(xmlpara, objNode, "PROP", "Department;DisplayName;Description;Title;PhysicalDeliveryOfficeName");
    createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");

    ReceptUserXmlHttp = createXMLHttpRequest();
    ReceptUserXmlHttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptMemberList.aspx", false);
    ReceptUserXmlHttp.send(xmlpara);
    if (ReceptUserXmlHttp.statusText == "OK") {
        var xmldom = createXmlDom();
        xmldom = loadXMLString(userlist_h.innerHTML.toUpperCase());
        if (ReceptUserXmlHttp.responseText != "") {

            var xmlRtn = ReceptUserloadXMLString(XmlHttp.responseText).documentElement.getElementsByTagName("ROWS")[0];
            xmldom.documentElement.appendChild(xmlRtn);

        }
        document.getElementById('UserList2').innerHTML = "";
        var listview = new ListView();
        listview.SetID("lvUserList2");
        listview.SetSelectFlag(false);
        listview.SetHeightFree(true);
        listview.SetRowOnDblClick("Rlist2_onSel_DBclick");
        listview.DataSource(xmldom);
        listview.DataBind("UserList2");
        if (listview.GetRowCount() <= 0)
            OpenAlertUI(linealt11);
        else if (USE_OCS.toUpperCase() == "YES")
            check_presence();
    }
    else
        OpenAlertUI(linealt12 + g_xmlHTTP.statusText)

    ReceptUserXmlHttp = null;

}

function event_RdisplayUserList() {
    if (ReceptUserXmlHttp != null && ReceptUserXmlHttp.readyState == 4) {
        if (ReceptUserXmlHttp.statusText == "OK") {
            var xmldom = createXmlDom();
            xmldom = loadXMLString(userlist_h.innerHTML.toUpperCase());
            if (ReceptUserXmlHttp.responseText != "") {

                var xmlRtn = ReceptUserloadXMLString(XmlHttp.responseText).documentElement.getElementsByTagName("ROWS")[0];
                xmldom.documentElement.appendChild(xmlRtn);

            }
            document.getElementById('UserList2').innerHTML = "";
            var listview = new ListView();
            listview.SetID("lvUserList2");
            listview.SetSelectFlag(false);
            listview.SetHeightFree(true);
            listview.SetRowOnDblClick("Rlist2_onSel_DBclick");
            listview.DataSource(xmldom);
            listview.DataBind("UserList2");
            if (listview.GetRowCount() <= 0)
                OpenAlertUI(linealt11);
            else if (USE_OCS.toUpperCase() == "YES")
                check_presence();
        }
        else
            OpenAlertUI(linealt12 + g_xmlHTTP.statusText)

        ReceptUserXmlHttp = null;
    }
}

function AprDeptDel_onclick() {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var CurSelRow = listview.GetSelectedRows();

    var DeleteState;

    if (CurSelRow.length == 0) return;

    if (CurSelRow.length != 0) {
        for (var i = 0; i < CurSelRow.length; i++) {
            DeleteState = DeptRowDelelte(listview.GetSelectedIndexes().split(',')[0], listview.GetDataRows());
            if (DeleteState == "Y") {
                listview.DeleteRow(GetAttribute(CurSelRow[i],"id"));
            }
        }
        var AprDeptInfo = loadXMLString(APRDeptResortList());

        document.getElementById('RECEPTLIST').innerHTML = "";
        var listview = new ListView();
        listview.SetID("lvRECEPTLIST");
        listview.SetMulSelectable(false);
        listview.SetHeightFree(true);
        listview.SetRowOnDblClick("AprDeptDel_onclick");
        listview.DataSource(AprDeptInfo);
        listview.DataBind("RECEPTLIST");
        listview.SetSelectFlag(false);
    }
}

function DeptRowDelelte(SelectIndex, ColRow) {
    var RowDelCheck;
    var ReturnVal = "N";
    TIndex = ColRow.length;
    NIndex = SelectIndex;
    for (i = 0; i <= NIndex; i++) {
        RowDelCheck = getNodeText(ColRow[i].cells[0]);
        if (CrossYN())
            setNodeText(ColRow[i].childNodes[0] , RowDelCheck - 1);
        else
            setNodeText(ColRow[i].cells[0] , RowDelCheck - 1);

        var ReturnVal = "Y";
    }
    return ReturnVal;
}

function APRDeptResortList() {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var AprDeptRow = listview.GetDataRows();
    var CurListLen = AprDeptRow.length;
    var CurCellLen = 0;
    if (CurListLen > 0)
        CurCellLen = AprDeptRow[0].cells.length;

    var i;
    var j;
    var GetXml;

    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang605 + "</NAME><WIDTH>35</WIDTH></HEADER><HEADER><NAME>" + strLang943 + "</NAME><WIDTH>200</WIDTH></HEADER></HEADERS>";
    GetXml = GetXml + "<ROWS>";

    for (i = 0; i < CurListLen; i++) {

        GetXml = GetXml + "<ROW><CELL>";
        GetXml = GetXml + "<VALUE>" + MakeXMLString(getNodeText(GetChildNodes(AprDeptRow[i])[0])) + "</VALUE>";
        GetXml = GetXml + "<DATA1>" + GetAttribute(AprDeptRow[i],"DATA1") + "</DATA1>";
        GetXml = GetXml + "<DATA2>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA2")) + "</DATA2>";
        GetXml = GetXml + "<DATA3>" + GetAttribute(AprDeptRow[i],"DATA3") + "</DATA3>";
        GetXml = GetXml + "<DATA4>" + GetAttribute(AprDeptRow[i],"DATA4") + "</DATA4>";
        GetXml = GetXml + "<DATA5>" + GetAttribute(AprDeptRow[i],"DATA5") + "</DATA5>";
        GetXml = GetXml + "<DATA6>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA6")) + "</DATA6>";
        GetXml = GetXml + "<DATA7>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA7")) + "</DATA7>";
        GetXml = GetXml + "<DATA8>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA8")) + "</DATA8>";
        GetXml = GetXml + "<DATA9>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA9")) + "</DATA9>";
        GetXml = GetXml + "<DATA10>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA10")) + "</DATA10>";
        GetXml = GetXml + "<DATA11>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA11")) + "</DATA11>";
        
        
        if (GetAttribute(AprDeptRow[i],"DATA12") == null)
            GetXml = GetXml + "<DATA12></DATA12>";
        else
            GetXml = GetXml + "<DATA12>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA12")) + "</DATA12>";
        if (GetAttribute(AprDeptRow[i],"DATA13") == null)
            GetXml = GetXml + "<DATA13></DATA13>";
        else
            GetXml = GetXml + "<DATA13>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA13")) + "</DATA13>";
        GetXml = GetXml + "</CELL><CELL>";
        GetXml = GetXml + "<VALUE>" + MakeXMLString(getNodeText(GetChildNodes(AprDeptRow[i])[1])) + "</VALUE>";
        GetXml = GetXml + "</CELL>";
        GetXml = GetXml + "</ROW>";
    }

    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
    return GetXml;
}

function Rlist2_onSel_DBclick() {
    AprDeptAdd_onclick('USER');
}

function AprDeptAdd_onclick(Type) {
    try {
        if (Type == "DEPT") {
            if (nodeIdx != "") {
                if (isExistDept(true)) {
                    var pAlertContent = strLang244 + "</br>" + strLang245;
                    OpenAlertUI(pAlertContent);
                    return;
                }

                var treeNode = new TreeNode();
                treeNode.LoadFromID(nodeIdx);
                var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, treeNode.GetNodeData("CN"));

                
                if (GetEntryInfo(treeNode.GetNodeData("CN")) == "N") {
                    var pAlertContent = strLang1105;
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (DuplicateFlag)
                    AprLineAddDept(nodeIdx, "");
                else {
                    var pAlertContent = linealt13;
                    OpenAlertUI(pAlertContent);
                }
            }
        }
        else {
            var listview = new ListView();
            listview.LoadFromID("lvUserList2");
            var pCurSelRow = listview.GetSelectedRows();
            if (pCurSelRow.length != 0) {
                var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, GetAttribute(pCurSelRow[0],"DATA3"));
                if (DuplicateFlag)
                    AprLineAddDept_User(pCurSelRow[0]);
                else {
                    var pAlertContent = linealt13
                    OpenAlertUI(pAlertContent);
                }
            }
        }
    }
    catch (e) {
        alert("AprDeptAdd_onclick : " + e.description);
    }
}

function DuplicateAprDeptCheck(APRDEPT, arrUserInfo) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var AprDeptList = listview.GetDataRows();
    var AprDeptListLen = AprDeptList.length;
    var i;

    for (i = 0 ; i < AprDeptListLen; i++) {
        if (GetAttribute(AprDeptList[0],"DATA1") == null) {
            return true; break;
        }
        if (GetAttribute(AprDeptList[i],"DATA1") == arrUserInfo) {
            return false;
            break;
        }
    }
    return true;
}

function AprLineAddDept(nodeIdx, tr) {
    var Resultxml = "";
    Resultxml.async = false;
    Resultxml = loadXMLFile(strLangEtcFile1);

    var treeNode = new TreeNode();
    treeNode.LoadFromID(nodeIdx);
    var deptid = treeNode.GetNodeData("CN");
    if (!isgetUser(deptid)) {
        var pAlertContent = strLang291 + strLang1102;
        OpenAlertUI(pAlertContent);
        return;
    }
    if (!isReceiverChk(deptid)) {
        var pAlertContent = strLang1101 + strLang1102;
        OpenAlertUI(pAlertContent);
        return;
    }

    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");

    DeptAddIndex = listview.GetRowCount();
    if (DeptAddIndex == 1) {
        var tr = listview.GetDataRows();
        if (tr[0].id.indexOf("noItems") > 0)
            DeptAddIndex = 0;
    }
    DeptAddIndex = DeptAddIndex + 1;
    var strCmpID = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");
    var strCmpNm = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");

    var pCompanyNAME;

    if (strCmpID == "TopGroup")
        pCompanyNAME = treeNode.GetNodeData("VALUE");
    else
        pCompanyNAME = strCmpNm;

    var pDeptNm = treeNode.GetNodeData("VALUE");
    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[1], deptid);
    setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
    setNodeText(GetChildNodes(objNodes[0])[3], "N");
    setNodeText(GetChildNodes(objNodes[0])[4], "N");
    setNodeText(GetChildNodes(objNodes[0])[5], "N");
    setNodeText(GetChildNodes(objNodes[0])[6], strCmpID);
    setNodeText(GetChildNodes(objNodes[0])[7], "");
    setNodeText(GetChildNodes(objNodes[0])[8], "");
    setNodeText(GetChildNodes(objNodes[0])[9], "");
    setNodeText(GetChildNodes(objNodes[0])[10], treeNode.GetNodeData("DISPLAYNAME1"));
    setNodeText(GetChildNodes(objNodes[0])[11], treeNode.GetNodeData("DISPLAYNAME2"));
    setNodeText(GetChildNodes(objNodes[0])[12], "");
    setNodeText(GetChildNodes(objNodes[0])[13], "");
    setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
    var tr = listview.GetSelectedRows();
    var InitTr = listview.GetDataRows();
    var MaxID = 0;
    for (var j = 0; j < InitTr.length; j++) {
        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }
    if (tr.length == 0) {
        if (InitTr.length == 0 || InitTr[0].id.indexOf("noItems") > 0) {
            document.getElementById('RECEPTLIST').innerHTML = "";
            var listview = new ListView();
            listview.SetID("lvRECEPTLIST");
            listview.SetSelectFlag(false);
            listview.SetHeightFree(true);
            listview.SetRowOnDblClick("AprDeptDel_onclick");
            listview.DataSource(Resultxml);
            listview.DataBind("RECEPTLIST");
        }
        else {
            var objTr = listview.AddRow(0);
            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
        }
    }
    else {
        var objTr = listview.AddRow(0);
        SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
        listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
    }
}

function AprLineAddDept_User(pSelectedRow) {
    var isCurretnCompany = "N";
    Resultxml.async = false;
    Resultxml = loadXMLFile(strLangEtcFile1);

    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");

    DeptAddIndex = listview.GetRowCount();
    if (DeptAddIndex == 1) {
        var tr = listview.GetDataRows();
        if (tr[0].id.indexOf("noItems") > 0)
            DeptAddIndex = 0;
    }

    DeptAddIndex = DeptAddIndex + 1;

    var strCmpID = GetAttribute(pSelectedRow,"DATA7")
    var pDeptNm = getNodeText(pSelectedRow.childNodes[1]);
    var puserNm = getNodeText(pSelectedRow.childNodes[0]);

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");

    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[1], GetAttribute(pSelectedRow,"DATA3"));
    setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
    setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);
    setNodeText(GetChildNodes(objNodes[0])[4], "N");
    setNodeText(GetChildNodes(objNodes[0])[5], "N");
    setNodeText(GetChildNodes(objNodes[0])[6], strCmpID);
    setNodeText(GetChildNodes(objNodes[0])[7], GetAttribute(pSelectedRow,"DATA2"));
    setNodeText(GetChildNodes(objNodes[0])[8], GetAttribute(pSelectedRow,"DATA8"));
    setNodeText(GetChildNodes(objNodes[0])[9], GetAttribute(pSelectedRow,"DATA12"));
    setNodeText(GetChildNodes(objNodes[0])[10], GetAttribute(pSelectedRow,"DATA10"));
    setNodeText(GetChildNodes(objNodes[0])[11], GetAttribute(pSelectedRow,"DATA11"));
    setNodeText(GetChildNodes(objNodes[0])[12], GetAttribute(pSelectedRow,"DATA9"));
    setNodeText(GetChildNodes(objNodes[0])[13], GetAttribute(pSelectedRow,"DATA13"));
    setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
    setNodeText(GetChildNodes(objNodes[2])[0], puserNm);
    var tmptr = listview.GetSelectedRows();
    var InitTr = listview.GetDataRows();

    var MaxID = 0;
    for (var j = 0; j < InitTr.length; j++) {
        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }

    if (tmptr.length == 0) {
        if (InitTr.length == 0 || InitTr[0].id.indexOf("noItems") > 0) {
            document.getElementById('RECEPTLIST').innerHTML = "";
            var listview = new ListView();
            listview.SetID("lvRECEPTLIST");
            listview.SetSelectFlag(false);
            listview.SetHeightFree(true);
            listview.SetRowOnDblClick("AprDeptDel_onclick");
            listview.DataSource(Resultxml);
            listview.DataBind("RECEPTLIST");

        } else {

            var objTr = listview.AddRow(0);
            SetAttribute(objTr, "id", "lvtAPRDEPT" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml);

        }
    }
    else {
        var objTr = listview.AddRow(0);
        SetAttribute(objTr, "id", "lvtAPRDEPT" + "_TR_" + eval(MaxID + 1));
        listview.AddDataRow(objTr, Resultxml);
    }
    DeptAddIndex = DeptAddIndex + 1;
}

function APRDeptXMLParsing(APRDEPT, pDocID) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var AprDeptRow = listview.GetDataRows();
    var CurListLen = AprDeptRow.length;
    var CurCellLen = 0;
    if (CurListLen > 0)
        CurCellLen = AprDeptRow[0].cells.length;
    var i;
    var j;
    var GetXml;

    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang170 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang171 + "</NAME><WIDTH>600</WIDTH></HEADER></HEADERS>";
    GetXml = GetXml + "<ROWS>";

    for (i = 0; i < CurListLen; i++) {
        GetXml = GetXml + "<ROW>";
        for (j = 0; j < CurCellLen; j++)
            GetXml = GetXml + "<COLUMN>" + MakeXMLString(getNodeText(AprDeptRow[i].cells[j])) + "</COLUMN>";

        GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
        GetXml = GetXml + "<DATA name='ReceiptPointID'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA1")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ExtReceptYN'>" + GetAttribute(AprDeptRow[i],"DATA3") + "</DATA >";
        GetXml = GetXml + "<DATA name='ProcessYN'>" + GetAttribute(AprDeptRow[i],"DATA4") + "</DATA>";
        GetXml = GetXml + "<DATA name='CanEditYN'>" + GetAttribute(AprDeptRow[i],"DATA5") + "</DATA>";
        GetXml = GetXml + "<DATA name='ExtReceptEmail'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA6")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReceiptMemberID'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA7")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReceiptMemberName'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA8")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReceiptMemberJobTitle'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA9")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprMemberDeptName'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA10")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprMemberDeptName2'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA11")) + "</DATA>";

        if (GetAttribute(AprDeptRow[i],"DATA12") == null)
            GetXml = GetXml + "<DATA name='ReceiptMemberName2'></DATA>";
        else
            GetXml = GetXml + "<DATA name='ReceiptMemberName2'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA12")) + "</DATA>";

        if (GetAttribute(AprDeptRow[i],"DATA13") == null)
            GetXml = GetXml + "<DATA name='ReceiptMemberJobTitle2'></DATA>";
        else
            GetXml = GetXml + "<DATA name='ReceiptMemberJobTitle2'>" + MakeXMLString(GetAttribute(AprDeptRow[i],"DATA13")) + "</DATA>";


        GetXml = GetXml + "</ROW>";
    }

    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
    return GetXml;
}

function textUser_onkeypress2() {
    if (window.event.keyCode == "13") {
        document.getElementById("Span2").focus();
    }
}

function btn_searchUser_onclick2() {
    searchUserList2();
}


function searchUserList2(search) {
    try {
        var searchdoc = document.getElementById("textUser2");
        var strSearch = searchdoc.value + "";
        if (textUser.value == "") {
            var pAlertContent = linealt3;
            OpenAlertUI(pAlertContent);
            textUser.focus();
        }
        else if (strSearch.length < 2) {
            var pAlertContent = linealt4;
            OpenAlertUI(pAlertContent);
            textUser.focus();
        }
        else {
            xmlhttpUserlist = createXMLHttpRequest();
            var xmlDOM = createXmlDom();

            var objNode;
            createNodeInsert(xmlDOM, objNode, "DATA");
            createNodeAndInsertText(xmlDOM, objNode, "SEARCH", "displayname::" + strSearch + ";;PhysicalDeliveryOfficeName::" + companyID);
            createNodeAndInsertText(xmlDOM, objNode, "CELL", "displayname;description;title;telephonenumber");
            
            createNodeAndInsertText(xmlDOM, objNode, "PROP", "Department;DisplayName;Description;Title;PhysicalDeliveryOfficeName");
            createNodeAndInsertText(xmlDOM, objNode, "TYPE", "user");

            xmlhttpUserlist = createXMLHttpRequest();
            xmlhttpUserlist.open("POST", "/myoffice/ezOrgan/OrganInfo/GetSearchList.aspx", true);
            xmlhttpUserlist.onreadystatechange = event_displayUserList2;
            xmlhttpUserlist.send(xmlDOM);
        }
    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}
function event_displayUserList2() {
    if (xmlhttpUserlist != null && xmlhttpUserlist.readyState == 4) {
        if (xmlhttpUserlist.statusText == "OK") {
            var retXml = createXmlDom();

            if (document.getElementById("UserList2").innerHTML != "")
                document.getElementById("UserList2").innerHTML = "";

            var headerData = createXmlDom();
            headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
            if (xmlhttpUserlist.responseText != "") {
                var xmlRtn = loadXMLString(xmlhttpUserlist.responseText).documentElement.getElementsByTagName("ROWS")[0];
                headerData.documentElement.appendChild(xmlRtn);

            }
            var pUserList = new ListView();
            pUserList.SetID("lvUserList2");
            pUserList.SetSelectFlag(false);
            pUserList.SetHeightFree(true);
            pUserList.SetRowOnDblClick("Rlist2_onSel_DBclick");
            pUserList.DataSource(headerData);
            pUserList.DataBind("UserList2");

            var userRows = pUserList.GetDataRows();

            if (userRows.length <= 0) {
                OpenAlertUI(linealt1);
            }
            else if (USE_OCS.toUpperCase() == "YES") {
                check_presence();
            }
        }
        else
            OpenAlertUI(linealt2 + xmlhttpUserlist.statusText)

        xmlhttpUserlist = null;
    }
}


var g_xmlHTTP;
var searchorganglist_dialogArguments = new Array();
var checkname2_cross_dialogArguments = new Array();
function btnSearchDept_onClick() {
    if (internalTab) {
        var tmpDeptName = txtDeptName.value;
        if (tmpDeptName.length == 0) {
            var pAlertContent = strLang240;
            document.getElementById("txtDeptName").focus();
            OpenAlertUI(pAlertContent);
            return;
        }

        var xmlHTTP = createXMLHttpRequest();
        var xmlDOM = createXmlDom();
        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "SEARCH", "EXACT_EXTENSIONATTRIBUTE2::" + CompanyID + ";;displayname::" + tmpDeptName);
        createNodeAndInsertText(xmlDOM, objNode, "CELL", "extensionAttribute3;displayname;extensionAttribute9;");
        createNodeAndInsertText(xmlDOM, objNode, "PROP", "");
        createNodeAndInsertText(xmlDOM, objNode, "TYPE", "group");

        try {
            xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetSearchList.aspx", false);
            xmlHTTP.send(xmlDOM);
            if (xmlHTTP.statusText != "OK") {
                document.getElementById("txtDeptName").focus();
                alert(strLang241 + xmlHTTP.statusText);
                xmlDOM = null;
                xmlHTTP = null;
            }
            else {
                document.getElementById("txtDeptName").focus();
                xmlDOM = loadXMLString(xmlHTTP.responseText);
                adCount = xmlDOM.getElementsByTagName("ROW").length;
            }
        } catch (e) {
            alert(strLang241 + e.description);
            xmlDOM = null;
            xmlHTTP = null;
        }

        if (adCount == 0) {
            var pAlertContent = strLang242;
            OpenAlertUI(pAlertContent);
            return;
        }
        else if (adCount == 1) {
            g_xmlHTTP = createXMLHttpRequest();

            var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]) +
					"</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayname</PROP></DATA>";
            g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptTreeInfo.aspx", true);
            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
            g_xmlHTTP.send(strQuery);
        }
        else {
            var rgParams = new Array();
            rgParams["addrBook"] = xmlDOM;
            rgParams["deptid"] = "";
            if (CrossYN() || pNoneActiveX == "YES") {
                checkname2_cross_dialogArguments[0] = rgParams;
                checkname2_cross_dialogArguments[1] = btnSearchDept_onClick_Complete2;

                DivPopUpShow(609, 372, "/myoffice/ezPersonal/PersonSearch/checkName2_Cross.aspx");
            }
            else {
                window.showModalDialog("/myoffice/ezPersonal/PersonSearch/checkName2_Cross.aspx", rgParams, "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken");

                if (rgParams["deptid"] != "") {
                    g_xmlHTTP = createXMLHttpRequest();
                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayname</PROP></DATA>";
                    g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptTreeInfo.aspx", true);
                    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
                    g_xmlHTTP.send(strQuery);
                }
            }
        }
    }
    else {
        var tmpDeptName = txtOuterDeptName.value;
        if (tmpDeptName.length < 3) {
            var pAlertContent = strLang243;
            OpenAlertUI(pAlertContent);
            document.getElementById("txtOuterDeptName").focus();
            return;
        }
        if (CrossYN() || pNoneActiveX == "YES") {
            searchorganglist_dialogArguments[0] = g_progresswin;
            searchorganglist_dialogArguments[1] = btnSearchDept_onClick_Complete;

            DivPopUpShow(600, 600, "/myoffice/ezApprovalG/ezOrganG/SearchOrganGList.aspx?keyword=" + escape(tmpDeptName));
        }
        else {
            var feature = "status:no;dialogWidth:600px;dialogHeight:600px;scroll:no;edge:sunken;help:no;";
            feature = feature + GetShowModalPosition(600, 600);
            reParam = window.showModalDialog("/myoffice/ezApprovalG/ezOrganG/SearchOrganGList.aspx?keyword=" + escape(tmpDeptName), g_progresswin, feature);
            document.getElementById("txtOuterDeptName").focus();

            if (reParam["ret"] == "OK") {
                if (isExistDept(false)) {
                    var pAlertContent = strLang244 + "<br>" + strLang245;
                    OpenAlertUI(pAlertContent);
                    return;
                }

                var DuplicateFlag = DuplicateAprDeptCheckG(RECEPTLIST, reParam["ouCode"]);
                if (DuplicateFlag) {
                    Resultxml.async = false;
                    Resultxml = loadXMLFile("TreeViewAddDept.xml")

                    var listview = new ListView();
                    listview.LoadFromID("lvRECEPTLIST");

                    DeptAddIndex = listview.GetRowCount();

                    if (DeptAddIndex == "1") {
                        var tr = listview.GetDataRows();
                        if (tr[0].id.indexOf("noItems") > 0)
                            DeptAddIndex = 0;
                    }

                    DeptAddIndex = DeptAddIndex + 1;

                    var rtnNodes = getExtLdapInfo(reParam["ouCode"]);
                    if (rtnNodes == null)
                        return false;
                    if (rtnNodes.childNodes.length <= 0)
                        return false;

                    var OutDeptList = "";
                    if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                        else
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                    } else {

                        var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
                        if (tempRtnNodes == null) return false;

                        
                        if (tempRtnNodes.childNodes.length <= 0) {
                            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                        } else {
                            
                            
                            if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                                else
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                            } else {
                                
                                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "") {
                                    var namelength = getNodeText(GetChildNodes(rtnNodes)[3]).length - 1;
                                    var location = getNodeText(GetChildNodes(rtnNodes)[3]).indexOf(strLang93);
                                    if (namelength == location)
                                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]);
                                    else
                                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]) + strLang93;
                                } else {
                                    if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4]))
                                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                                    else
                                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]).replace(getNodeText(GetChildNodes(rtnNodes)[2]), '') + "(" + getNodeText(GetChildNodes(rtnNodes)[8]) + ")";
                                }
                            }
                        }
                    }

                    var pDeptNm = OutDeptList;
                    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
                    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
                    setNodeText(GetChildNodes(objNodes[0])[1], reParam["ouCode"]);
                    setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
                    setNodeText(GetChildNodes(objNodes[0])[3], "Y");
                    setNodeText(GetChildNodes(objNodes[0])[4], "N");
                    setNodeText(GetChildNodes(objNodes[0])[5], "N");
                    setNodeText(GetChildNodes(objNodes[0])[6], "");
                    setNodeText(GetChildNodes(objNodes[0])[7], "");
                    setNodeText(GetChildNodes(objNodes[0])[8], "");
                    setNodeText(GetChildNodes(objNodes[0])[9], "");
                    setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
                    setNodeText(GetChildNodes(objNodes[0])[10], pDeptNm);
                    setNodeText(GetChildNodes(objNodes[0])[11], pDeptNm);
                    setNodeText(GetChildNodes(objNodes[0])[12], "");
                    setNodeText(GetChildNodes(objNodes[0])[13], "");

                    var tr = listview.GetSelectedRows();
                    var InitTr = listview.GetDataRows();

                    var MaxID = 0;
                    for (var j = 0  ; j < InitTr.length  ; j++) {
                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                        if (MaxID < curnum)
                            MaxID = curnum;
                    }

                    if (tr.length == 0) {
                        if (InitTr.length == 0) {
                            document.getElementById('RECEPTLIST').innerHTML = "";
                            var listview = new ListView();
                            listview.SetID("lvRECEPTLIST");
                            listview.SetMulSelectable(false);
                            listview.SetHeightFree(true);
                            listview.SetRowOnDblClick("AprDeptDel_onclick");
                            listview.DataSource(Resultxml);
                            listview.DataBind("RECEPTLIST");
                            listview.SetSelectFlag(false);
                        }
                        else {
                            var objTr = listview.AddRow(0);
                            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                            listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
                        }
                    }
                    else {
                        var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
                        SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                        listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

                        ReSetAprLineDept(listview);
                    }

                    DeptAddIndex = DeptAddIndex + 1;

                    if (InitTr.length > 8) {
                        document.getElementById("inputSummaryOuterReceiverList").focus();
                        document.getElementById("trSummaryOuterReceiverList").style.display = "";
                        document.getElementById("btnaddress").style.display = "none";
                        document.getElementById("btnaddressChange").style.display = "none";
                    } else {
                        document.getElementById("trSummaryOuterReceiverList").style.display = "none";
                        document.getElementById("inputSummaryOuterReceiverList").value = "";
                        document.getElementById("btnaddress").style.display = "";
                        document.getElementById("btnaddressChange").style.display = "";
                    }

                } else {
                    var pAlertContent = strLang247 + "<br>  " + strLang248;
                    OpenAlertUI(pAlertContent);
                }


            } else if (reParam["ret"] == "MULTISELECT") {
                var InitTr = null;
                for (var i = 0; i < reParam["ouCode"].length; i++) {
                    if (isExistDept(false)) {
                        var pAlertContent = strLang244 + "<br>" + strLang245;
                        OpenAlertUI(pAlertContent);
                        return;
                    }

                    var DuplicateFlag = DuplicateAprDeptCheckG(RECEPTLIST, reParam["ouCode"][i]);
                    if (DuplicateFlag) {
                        Resultxml.async = false;
                        Resultxml = loadXMLFile("TreeViewAddDept.xml")

                        var listview = new ListView();
                        listview.LoadFromID("lvRECEPTLIST");

                        DeptAddIndex = listview.GetRowCount();

                        if (DeptAddIndex == "1") {
                            var tr = listview.GetDataRows();
                            if (tr[0].id.indexOf("noItems") > 0)
                                DeptAddIndex = 0;
                        }

                        DeptAddIndex = DeptAddIndex + 1;

                        var rtnNodes = getExtLdapInfo(reParam["ouCode"][i]);
                        if (rtnNodes == null)
                            return false;
                        if (rtnNodes.childNodes.length <= 0)
                            return false;

                        var OutDeptList = "";
                        
                        
                        
                        
                        
                        
                        

                        if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                        } else {

                            var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
                            if (tempRtnNodes == null) return false;

                            
                            if (tempRtnNodes.childNodes.length <= 0) {
                                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                                else
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                            } else {
                                
                                
                                if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                                    else
                                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                                } else {
                                    
                                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "") {
                                        var namelength = getNodeText(GetChildNodes(rtnNodes)[3]).length - 1;
                                        var location = getNodeText(GetChildNodes(rtnNodes)[3]).indexOf(strLang93);
                                        if (namelength == location)
                                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]);
                                        else
                                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]) + strLang93;
                                    } else {
                                        if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4]))
                                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                                        else
                                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]).replace(getNodeText(GetChildNodes(rtnNodes)[2]), '') + "(" + getNodeText(GetChildNodes(rtnNodes)[8]) + ")";
                                    }
                                }
                            }
                        }

                        var pDeptNm = OutDeptList;
                        var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
                        setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
                        setNodeText(GetChildNodes(objNodes[0])[1], reParam["ouCode"][i]);
                        setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
                        setNodeText(GetChildNodes(objNodes[0])[3], "Y");
                        setNodeText(GetChildNodes(objNodes[0])[4], "N");
                        setNodeText(GetChildNodes(objNodes[0])[5], "N");
                        setNodeText(GetChildNodes(objNodes[0])[6], "");
                        setNodeText(GetChildNodes(objNodes[0])[7], "");
                        setNodeText(GetChildNodes(objNodes[0])[8], "");
                        setNodeText(GetChildNodes(objNodes[0])[9], "");
                        setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
                        setNodeText(GetChildNodes(objNodes[0])[10], pDeptNm);
                        setNodeText(GetChildNodes(objNodes[0])[11], pDeptNm);
                        setNodeText(GetChildNodes(objNodes[0])[12], "");
                        setNodeText(GetChildNodes(objNodes[0])[13], "");

                        var tr = listview.GetSelectedRows();
                        InitTr = listview.GetDataRows();

                        var MaxID = 0;
                        for (var j = 0  ; j < InitTr.length  ; j++) {
                            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                            if (MaxID < curnum)
                                MaxID = curnum;
                        }

                        if (tr.length == 0) {
                            if (InitTr.length == 0) {
                                document.getElementById('RECEPTLIST').innerHTML = "";
                                var listview = new ListView();
                                listview.SetID("lvRECEPTLIST");
                                listview.SetMulSelectable(false);
                                listview.SetHeightFree(true);
                                listview.SetRowOnDblClick("AprDeptDel_onclick");
                                listview.DataSource(Resultxml);
                                listview.DataBind("RECEPTLIST");
                                listview.SetSelectFlag(false);
                            } else {
                                var objTr = listview.AddRow(0);
                                SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                                listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
                            }
                        } else {
                            var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
                            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                            listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

                            ReSetAprLineDept(listview);
                        }

                        DeptAddIndex = DeptAddIndex + 1;

                        if (InitTr.length > 8) {
                            document.getElementById("inputSummaryOuterReceiverList").focus();
                            document.getElementById("trSummaryOuterReceiverList").style.display = "";
                            document.getElementById("btnaddress").style.display = "none";
                            document.getElementById("btnaddressChange").style.display = "none";
                        } else {
                            document.getElementById("trSummaryOuterReceiverList").style.display = "none";
                            document.getElementById("inputSummaryOuterReceiverList").value = "";
                            document.getElementById("btnaddress").style.display = "";
                            document.getElementById("btnaddressChange").style.display = "";
                        }

                    } else {
                        var pAlertContent = strLang247 + "<br>  " + strLang248;
                        OpenAlertUI(pAlertContent);
                    }
                }
            }
        }
    }
}

function btnSearchDept_onClick_Complete2(rgParams) {
    DivPopUpHidden();
    if (rgParams["deptid"] != "") {
        g_xmlHTTP = createXMLHttpRequest();
        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayname</PROP></DATA>";
        g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptTreeInfo.aspx", true);
        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
        g_xmlHTTP.send(strQuery);
    }
}

function btnSearchDept_onClick_Complete(reParam) {
    DivPopUpHidden();
    if (reParam["ret"] == "OK") {
        if (isExistDept(false)) {
            var pAlertContent = strLang244 + "<br>" + strLang245;
            OpenAlertUI(pAlertContent);
            return;
        }

        var DuplicateFlag = DuplicateAprDeptCheckG(RECEPTLIST, reParam["ouCode"]);
        if (DuplicateFlag) {
            Resultxml.async = false;
            Resultxml = loadXMLFile("TreeViewAddDept.xml")

            var listview = new ListView();
            listview.LoadFromID("lvRECEPTLIST");

            DeptAddIndex = listview.GetRowCount();

            if (DeptAddIndex == "1") {
                var tr = listview.GetDataRows();
                if (tr[0].id.indexOf("noItems") > 0)
                    DeptAddIndex = 0;
            }

            DeptAddIndex = DeptAddIndex + 1;

            var rtnNodes = getExtLdapInfo(reParam["ouCode"]);
            if (rtnNodes == null)
                return false;
            if (rtnNodes.childNodes.length <= 0)
                return false;

            var OutDeptList = "";
            
            
            
            
            
            
            

            if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                else
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
            } else {

                var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
                if (tempRtnNodes == null) return false;

                
                if (tempRtnNodes.childNodes.length <= 0) {
                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                } else {
                    
                    
                    if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                        else
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                    } else {
                        
                        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "") {
                            var namelength = getNodeText(GetChildNodes(rtnNodes)[3]).length - 1;
                            var location = getNodeText(GetChildNodes(rtnNodes)[3]).indexOf(strLang93);
                            if (namelength == location)
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]);
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]) + strLang93;
                        } else {
                            if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4]))
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]).replace(getNodeText(GetChildNodes(rtnNodes)[2]), '') + "(" + getNodeText(GetChildNodes(rtnNodes)[8]) + ")";
                        }
                    }
                }
            }

            var pDeptNm = OutDeptList;
            var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
            setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
            setNodeText(GetChildNodes(objNodes[0])[1], reParam["ouCode"]);
            setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
            setNodeText(GetChildNodes(objNodes[0])[3], "Y");
            setNodeText(GetChildNodes(objNodes[0])[4], "N");
            setNodeText(GetChildNodes(objNodes[0])[5], "N");
            setNodeText(GetChildNodes(objNodes[0])[6], "");
            setNodeText(GetChildNodes(objNodes[0])[7], "");
            setNodeText(GetChildNodes(objNodes[0])[8], "");
            setNodeText(GetChildNodes(objNodes[0])[9], "");
            setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
            setNodeText(GetChildNodes(objNodes[0])[10], pDeptNm);
            setNodeText(GetChildNodes(objNodes[0])[11], pDeptNm);
            setNodeText(GetChildNodes(objNodes[0])[12], "");
            setNodeText(GetChildNodes(objNodes[0])[13], "");

            var tr = listview.GetSelectedRows();
            var InitTr = listview.GetDataRows();

            var MaxID = 0;
            for (var j = 0  ; j < InitTr.length  ; j++) {
                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                if (MaxID < curnum)
                    MaxID = curnum;
            }

            if (tr.length == 0) {
                if (InitTr.length == 0) {
                    document.getElementById('RECEPTLIST').innerHTML = "";
                    var listview = new ListView();
                    listview.SetID("lvRECEPTLIST");
                    listview.SetMulSelectable(false);
                    listview.SetHeightFree(true);
                    listview.SetRowOnDblClick("AprDeptDel_onclick");
                    listview.DataSource(Resultxml);
                    listview.DataBind("RECEPTLIST");
                    listview.SetSelectFlag(false);
                } else {
                    var objTr = listview.AddRow(0);
                    SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
                }
            } else {
                var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
                SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

                ReSetAprLineDept(listview);
            }

            DeptAddIndex = DeptAddIndex + 1;

            if (InitTr.length > 8) {
                document.getElementById("inputSummaryOuterReceiverList").focus();
                document.getElementById("trSummaryOuterReceiverList").style.display = "";
                document.getElementById("btnaddress").style.display = "none";
                document.getElementById("btnaddressChange").style.display = "none";
            } else {
                document.getElementById("trSummaryOuterReceiverList").style.display = "none";
                document.getElementById("inputSummaryOuterReceiverList").value = "";
                document.getElementById("btnaddress").style.display = "";
                document.getElementById("btnaddressChange").style.display = "";
            }
        } else {
            var pAlertContent = strLang247 + "<br>  " + strLang248;
            OpenAlertUI(pAlertContent);
        }

    } else if (reParam["ret"] == "MULTISELECT") {

        var InitTr = null;
        for (var i = 0; i < reParam["ouCode"].length; i++) {
            if (isExistDept(false)) {
                var pAlertContent = strLang244 + "<br>" + strLang245;
                OpenAlertUI(pAlertContent);
                return;
            }

            var DuplicateFlag = DuplicateAprDeptCheckG(RECEPTLIST, reParam["ouCode"][i]);
            if (DuplicateFlag) {
                Resultxml.async = false;
                Resultxml = loadXMLFile("TreeViewAddDept.xml")

                var listview = new ListView();
                listview.LoadFromID("lvRECEPTLIST");

                DeptAddIndex = listview.GetRowCount();

                if (DeptAddIndex == "1") {
                    var tr = listview.GetDataRows();
                    if (tr[0].id.indexOf("noItems") > 0)
                        DeptAddIndex = 0;
                }

                DeptAddIndex = DeptAddIndex + 1;

                var rtnNodes = getExtLdapInfo(reParam["ouCode"][i]);
                if (rtnNodes == null)
                    return false;
                if (rtnNodes.childNodes.length <= 0)
                    return false;

                var OutDeptList = "";
                
                
                
                
                
                
                

                if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                } else {

                    var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
                    if (tempRtnNodes == null) return false;

                    
                    if (tempRtnNodes.childNodes.length <= 0) {
                        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                        else
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                    } else {
                        
                        
                        if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                        } else {
                            
                            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "") {
                                var namelength = getNodeText(GetChildNodes(rtnNodes)[3]).length - 1;
                                var location = getNodeText(GetChildNodes(rtnNodes)[3]).indexOf(strLang93);
                                if (namelength == location)
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]);
                                else
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]) + strLang93;
                            } else {
                                if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4]))
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                                else
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]).replace(getNodeText(GetChildNodes(rtnNodes)[2]), '') + "(" + getNodeText(GetChildNodes(rtnNodes)[8]) + ")";
                            }
                        }
                    }
                }

                var pDeptNm = OutDeptList;
                var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
                setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
                setNodeText(GetChildNodes(objNodes[0])[1], reParam["ouCode"][i]);
                setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
                setNodeText(GetChildNodes(objNodes[0])[3], "Y");
                setNodeText(GetChildNodes(objNodes[0])[4], "N");
                setNodeText(GetChildNodes(objNodes[0])[5], "N");
                setNodeText(GetChildNodes(objNodes[0])[6], "");
                setNodeText(GetChildNodes(objNodes[0])[7], "");
                setNodeText(GetChildNodes(objNodes[0])[8], "");
                setNodeText(GetChildNodes(objNodes[0])[9], "");
                setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
                setNodeText(GetChildNodes(objNodes[0])[10], pDeptNm);
                setNodeText(GetChildNodes(objNodes[0])[11], pDeptNm);
                setNodeText(GetChildNodes(objNodes[0])[12], "");
                setNodeText(GetChildNodes(objNodes[0])[13], "");

                var tr = listview.GetSelectedRows();
                InitTr = listview.GetDataRows();

                var MaxID = 0;
                for (var j = 0  ; j < InitTr.length  ; j++) {
                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    if (MaxID < curnum)
                        MaxID = curnum;
                }

                if (tr.length == 0) {
                    if (InitTr.length == 0) {
                        document.getElementById('RECEPTLIST').innerHTML = "";
                        var listview = new ListView();
                        listview.SetID("lvRECEPTLIST");
                        listview.SetMulSelectable(false);
                        listview.SetHeightFree(true);
                        listview.SetRowOnDblClick("AprDeptDel_onclick");
                        listview.DataSource(Resultxml);
                        listview.DataBind("RECEPTLIST");
                        listview.SetSelectFlag(false);
                    } else {
                        var objTr = listview.AddRow(0);
                        SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                        listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
                    }
                } else {
                    var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
                    SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

                    ReSetAprLineDept(listview);
                }

                DeptAddIndex = DeptAddIndex + 1;

                if (InitTr.length > 8) {
                    document.getElementById("inputSummaryOuterReceiverList").focus();
                    document.getElementById("trSummaryOuterReceiverList").style.display = "";
                    document.getElementById("btnaddress").style.display = "none";
                    document.getElementById("btnaddressChange").style.display = "none";
                } else {
                    document.getElementById("trSummaryOuterReceiverList").style.display = "none";
                    document.getElementById("inputSummaryOuterReceiverList").value = "";
                    document.getElementById("btnaddress").style.display = "";
                    document.getElementById("btnaddressChange").style.display = "";
                }

            } else {
                var pAlertContent = strLang247 + "<br>  " + strLang248;
                OpenAlertUI(pAlertContent);
            }
        }
    }
}

function event_getDeptFullTree() {
    if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
        if (g_xmlHTTP.statusText == "OK") {
            var xmlDom = createXmlDom();
            xmlDom.async = false;
            xmlDom = loadXMLFile("/myoffice/common/organtree_config.xml");

            document.getElementById('TreeView2').innerHTML = "";
            var treeView = new TreeView();
            treeView.SetID("tvTreeView2");
            treeView.SetUseAgency(true);
            treeView.SetRequestData("RequestData");
            treeView.SetNodeClick("TreeViewNodeClick2");
            treeView.SetNodeDblClick("TreeViewNodeDbClick");
            treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
            treeView.DataBind("TreeView2");
        }
        else {
            alert(strLang249 + g_xmlHTTP.statusText)
            g_xmlHTTP = null;
        }
    }
}
var xmlhttp2;

function liniReceptOuter() {
    xmlhttp2 = createXMLHttpRequest();
    xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezOrganG/GetOrganTreeInfo.aspx", true);
    xmlhttp2.onreadystatechange = event_GetReceptOuterTempletList;
    xmlhttp2.send();
}
function event_GetReceptOuterTempletList() {
    if (xmlhttp2 == null || xmlhttp2.readyState != 4 || loadXMLString(xmlhttp2.responseText) == null) return;
    try {

        if (xmlhttp2.responseText == "Error")
            return;

        document.getElementById('TreeView3').innerHTML = "";
        var treeView = new TreeView();
        treeView.SetID("tvTreeView3");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("RequestDataG");
        treeView.SetNodeClick("TreeViewNodeClick");
        treeView.DataSource(loadXMLString(xmlhttp2.responseText));
        treeView.DataBind("TreeView3");
        xmlhttp2 = null;
    }
    catch (ErrMsg) {
        alert("event_GetReceptOuterTempletList : " + ErrMsg.description);
    }
}
function RequestDataG(pNodeID, pTreeID) {
    try {
        var TreeIdx = pNodeID;

        var treeNode = new TreeNode();
        treeNode.LoadFromID(TreeIdx);

        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", treeNode.GetNodeData("DATA2"));
        xmlhttp2 = createXMLHttpRequest();
        xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezOrganG/GetOrganSubTreeInfo.aspx", false);
        xmlhttp2.send(xmlpara);

        var xmlRtn = createXmlDom();
        xmlRtn = loadXMLString(xmlhttp2.responseText);

        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
            if (CrossYN() || pNoneActiveX == "YES") {
                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
            }
            else {
                xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
            }
        }

        var treeView = new TreeView();
        treeView.LoadFromID("tvTreeView3");

        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
        xmlhttp2 = null;
    } catch (e) {
        alert("RequestDataG" + e.description);
    }
}
function AprDeptOuterAdd_onclick() {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var CurSelRow = listview.GetSelectedRows();
    if (isExistDept(false)) {
        var pAlertContent = strLang244;
        OpenAlertUI(pAlertContent);
        return;
    }
    var treeView = new TreeView();
    treeView.LoadFromID("tvTreeView3");
    var selectnode = treeView.GetSelectNode();
    if (selectnode == null) {
        var pAlertContent = strLang584;
        OpenAlertUI(pAlertContent);
        return;
    }

    
    var ouReceiveDocumentYN = selectnode.GetNodeData("DATA3");
    if (ouReceiveDocumentYN != "Y") {
        alert(strLang1104);
        return;
    }

    var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, selectnode.GetNodeData("DATA1"));
    if (DuplicateFlag) {
        AprLineAddDeptG(selectnode.NodeID, CurSelRow);
    }
    else {
        var pAlertContent = strLang247;
        OpenAlertUI(pAlertContent);
    }
}

function DuplicateAprDeptCheckG(APRDEPT, arrUserInfo) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var AprDeptList = listview.GetDataRows();
    var AprDeptListLen = AprDeptList.length;
    var i;
    for (i = 0 ; i < AprDeptListLen ; i++) {
        if (GetAttribute(AprDeptList[i], "DATA1") == arrUserInfo) {
            return false;
            break;
        }
    }
    return true;
}


function AprLineAddDeptG(nodeIdx, tr) {
    var isCurretnCompany = "Y";
    Resultxml.async = false;

    Resultxml = loadXMLFile(strLangEtcFile1);

    var treeNode = new TreeNode();
    treeNode.LoadFromID(nodeIdx);

    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");

    DeptAddIndex = listview.GetRowCount();

    if (DeptAddIndex == "1") {
        var tr = listview.GetDataRows();
        if (tr[0].id.indexOf("noItems") > 0)
            DeptAddIndex = 0;
    }
    DeptAddIndex = DeptAddIndex + 1;

    
    var rtnNodes = getExtLdapInfo(treeNode.GetNodeData("DATA1"));
    if (rtnNodes == null) return false;
    if (rtnNodes.childNodes.length <= 0) return false;

    var OutDeptList = "";
    if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
        else
            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
    }
    else {

        var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
        if (tempRtnNodes == null) return false;

        
        if (tempRtnNodes.childNodes.length <= 0) {
            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
            else
                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
        }
            
        else {
            
            if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                else
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
            }
                
            else {
                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "") {
                    var namelength = getNodeText(GetChildNodes(rtnNodes)[3]).length - 1;
                    var location = getNodeText(GetChildNodes(rtnNodes)[3]).indexOf(strLang93);
                    if (namelength == location)
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]);
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]) + strLang93;
                }
                else {
                    if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4]))
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]).replace(getNodeText(GetChildNodes(rtnNodes)[2]), '') + "(" + getNodeText(GetChildNodes(rtnNodes)[8]) + ")";
                }
            }
        }
    }

    var pDeptNm = OutDeptList;
    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[1], treeNode.GetNodeData("DATA1"));
    setNodeText(GetChildNodes(objNodes[0])[2], pDocID);

    setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);
    setNodeText(GetChildNodes(objNodes[0])[4], "N");
    setNodeText(GetChildNodes(objNodes[0])[5], "N");
    setNodeText(GetChildNodes(objNodes[0])[6], "");
    setNodeText(GetChildNodes(objNodes[0])[7], "");
    setNodeText(GetChildNodes(objNodes[0])[8], "");
    setNodeText(GetChildNodes(objNodes[0])[9], "");
    setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);

    setNodeText(GetChildNodes(objNodes[0])[10], pDeptNm);
    setNodeText(GetChildNodes(objNodes[0])[11], pDeptNm);
    setNodeText(GetChildNodes(objNodes[0])[12], "");
    setNodeText(GetChildNodes(objNodes[0])[13], "");

    var tr = listview.GetSelectedRows();
    var InitTr = listview.GetDataRows();

    var MaxID = 0;
    for (var j = 0  ; j < InitTr.length  ; j++) {
        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }

    if (tr.length == 0) {
        if (InitTr.length == 0) {
            document.getElementById('RECEPTLIST').innerHTML = "";
            var listview = new ListView();
            listview.SetID("lvRECEPTLIST");
            listview.SetMulSelectable(false);
            listview.SetHeightFree(true);
            listview.SetRowOnDblClick("AprDeptDel_onclick");
            listview.DataSource(Resultxml);
            listview.DataBind("RECEPTLIST");
            listview.SetSelectFlag(false);
        } else {
            var objTr = listview.AddRow(0);
            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
        }
    }
    else {
        var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
        SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
        listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

        ReSetAprLineDept(listview);
    }

    DeptAddIndex = DeptAddIndex + 1;

    if (InitTr.length > 8) {
        document.getElementById("inputSummaryOuterReceiverList").focus();
        document.getElementById("trSummaryOuterReceiverList").style.display = "";
        document.getElementById("btnaddress").style.display = "none";
        document.getElementById("btnaddressChange").style.display = "none";
    } else {
        document.getElementById("trSummaryOuterReceiverList").style.display = "none";
        document.getElementById("inputSummaryOuterReceiverList").value = "";
        document.getElementById("btnaddress").style.display = "";
        document.getElementById("btnaddressChange").style.display = "";
    }

}
function isExistDept(ExtFlag) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var CurSelRow = listview.GetDataRows();
    var rtnVal = false;
    for (i = 0; i < CurSelRow.length; i++) {
        if (ExtFlag) {
            if (GetAttribute(CurSelRow[0], "DATA3") == "Y")
                rtnVal = true;
        }
        else {
            if (GetAttribute(CurSelRow[0], "DATA3") == "N")
                rtnVal = true;
        }

        if ((GetAttribute(CurSelRow[0], "DATA1") != null ? GetAttribute(CurSelRow[0], "DATA1").indexOf("Address") : -1) > -1) {
            rtnVal = true;
        }
    }
    return rtnVal;
}
function getExtLdapInfo(OrganCode) {
    try {
        var xmlpara = createXmlDom();
        var xmlRtn = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARA");
        createNodeAndInsertText(xmlpara, objNode, "ORGID", OrganCode);
        xmlhttp2 = createXMLHttpRequest();
        xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezOrganG/GetOrgInfo.aspx", false);
        xmlhttp2.send(xmlpara);

        return loadXMLString(xmlhttp2.responseText).documentElement;
    } catch (e) {
        return "";
    }
}
function ReSetAprLineDept(listview) {
    var Depth = null;
    var TIndex = null;
    var CIndex = null;
    var NIndex = null;
    var i;

    SelRow = listview.GetSelectedRows();
    ColRow = listview.GetDataRows();

    if (typeof (SelRow[0]) == "undefined")
        var CurSelRow = SelRow;
    else
        var CurSelRow = SelRow[0];

    TIndex = ColRow.length;
    CIndex = Number(listview.GetSelectedIndexes().split(',')[0])
    NIndex = TIndex - CIndex;

    if (CIndex != 0) {
        for (i = 0 ; i < (CIndex + 2) ; i++)
            if (i != TIndex) {
                if (CrossYN())
                    setNodeText(ColRow[i].childNodes[0] , TIndex - i);
                else
                    setNodeText(ColRow[i].cells[0] , TIndex - i);
            }

        if (CrossYN())
            setNodeText(CurSelRow.childNodes[0] , NIndex);
        else
            setNodeText(CurSelRow.cells[0] , NIndex);

        return NIndex
    }
}
function AprDeptDel_onclick() {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var CurSelRow = listview.GetSelectedRows();
    var DeleteState;
    if (CurSelRow.length != 0) {
        DeleteState = DeptRowDelelte(listview.GetSelectedIndexes().split(',')[0], listview.GetDataRows());
        if (DeleteState == "Y")
            listview.DeleteRow(GetAttribute(CurSelRow[0], "id"));
    }

    if (listview.GetDataRows().length < 10) {
        document.getElementById("trSummaryOuterReceiverList").style.display = "none";
        document.getElementById("inputSummaryOuterReceiverList").value = "";
        document.getElementById("btnaddress").style.display = "";
    }
}


var aprdeptaddressusername_cross_dialogArguments = new Array();
function btnAddAddress() {
    var passFlag = false;

    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");

    var InitTr = listview.GetDataRows();

    if (InitTr.length == 0) {
        passFlag = true;
    }
    else {
        if ((GetAttribute(InitTr[0], "DATA1") !=null ? GetAttribute(InitTr[0], "DATA1").indexOf("Address") : -1) != -1) {
            passFlag = true;
        }
        if (InitTr[0].id.indexOf("noItems") > 0)
            passFlag = true;

    }

    if (!passFlag) {
        var pAlertContent = strLang251 + "<br> " + strLang252;
        OpenAlertUI(pAlertContent);
        return;
    }

    var windowName = "/myoffice/ezApprovalG/ezLine/AprDeptAddressUserName.aspx";
    if (CrossYN() || pNoneActiveX == "YES") {
        aprdeptaddressusername_cross_dialogArguments[0] = "";
        aprdeptaddressusername_cross_dialogArguments[1] = btnAddAddress_Complete;

        DivPopUpShow(360, 220, windowName);
    }
    else {
        //var parameter = "status:no;dialogWidth:335px;dialogHeight:195px;scroll:no;edge:sunken;help:no;";
        //parameter = parameter + GetShowModalPosition(330, 205);
        //var dialogValue = "";
        //var AddressUserName = window.showModalDialog(windowName, dialogValue, parameter);
        
        //if (AddressUserName == "cancel" || AddressUserName == "")
        //    return;

        //var Para = window.showModalDialog("/myoffice/ezPersonal/ZipCode/address_zip_select.aspx", "", "dialogWidth:655px;dialogHeight:620px;toolbar:no;location:no;directories:no;status:no;menubar:no;scroll:no;edge:sunken;help:no" + GetShowModalPosition(655, 620));
        //var windowName = "/myoffice/ezApprovalG/ezLine/AprDeptAddressName.aspx";
        //var parameter = "status:no;dialogWidth:335px;dialogHeight:195px;scroll:no;edge:sunken;help:no;";
        //parameter = parameter + GetShowModalPosition(330, 205);
        //var dialogValue = "";

        //if (typeof (Para) != "undefined") {
        //    if ((typeof (Para) != "undefined" && Para[0] != "cancel") || Para[0] == "")
        //        dialogValue = strLang253 + Para[0] + " " + Para[1] + " ";
        //    else
        //        dialogValue = "";
        //}
        //else {
        //    dialogValue = "";
        //    return;
        //}

        //var AddressName = "";
        //if (dialogValue != "")
        //    AddressName = window.showModalDialog(windowName, dialogValue, parameter);

        //var strAddress = "";
        //if (AddressName != "" && AddressName != "cancel")
        //    strAddress = AddressUserName + " (" + dialogValue + AddressName + ")";
        //else
        //    strAddress = AddressUserName + "(" + dialogValue + ")";

        //if (CheckLen(strAddress, 100) == false) {
        //    var windowName = "/myoffice/ezApprovalG/ezLine/AprDeptAddressUserName.aspx";
        //    var parameter = "status:no;dialogWidth:335px;dialogHeight:185px;scroll:no;edge:sunken;help:no;";
        //    parameter = parameter + GetShowModalPosition(330, 205);
        //    var dialogValue = strAddress;
        //    strAddress = window.showModalDialog(windowName, dialogValue, parameter);

        //    if (strAddress == "cancel")
        //        return;
        //}
        //if (AddressName != "cancel" || strAddress != "cancel") {
        //    AprLineAddDeptAddress(strAddress);
        //}

        //민원인 주소 직접 입력할수 있도록 수정 (20161220)
        var parameter = "status:no;dialogWidth:335px;dialogHeight:195px;scroll:no;edge:sunken;help:no;";
        parameter = parameter + GetShowModalPosition(330, 205);
        var dialogValue = "";
        var AddressUserName = window.showModalDialog(windowName, dialogValue, parameter);
        if (AddressUserName != "") {
            AprLineAddDeptAddress(AddressUserName);
        }

    }
}

var TempAddressUserName;
var address_zip_select_dialogArguments = new Array();
function btnAddAddress_Complete(AddressUserName) {
    DivPopUpHidden();
    if (AddressUserName == "cancel" || AddressUserName == "") {
        return;
    }
    address_zip_select_dialogArguments[1] = btnAddAddress_Complete2;

    DivPopUpShow(655, 620, "/myoffice/ezPersonal/ZipCode/address_zip_select.aspx");
    TempAddressUserName = AddressUserName
}

var aprdeptaddressname_cross_dialogArguments = new Array();
var TempdialogValue = "";
function btnAddAddress_Complete2(Para) {

    if (Para == "cancel") {
        DivPopUpHidden();
        return;
    }

    DivPopUpHidden();
    var windowName = "/myoffice/ezApprovalG/ezLine/AprDeptAddressName.aspx";

    if (typeof (Para) != "undefined") {
        if ((typeof (Para) != "undefined" && Para[0] != "cancel") || Para[0] == "")
            TempdialogValue = strLang253 + Para[0] + " " + Para[1] + " ";
        else
            TempdialogValue = "";
    }
    else
        TempdialogValue = "";

    if (TempdialogValue != "") {
        aprdeptaddressname_cross_dialogArguments[0] = TempdialogValue;
        aprdeptaddressname_cross_dialogArguments[1] = btnAddAddress_Complete3;

        DivPopUpShow(350, 220, windowName);
    }
    else {
        btnAddAddress_Complete3("");
    }
}

var TempstrAddress = "";
function btnAddAddress_Complete3(AddressName) {
    DivPopUpHidden();
    if (AddressName != "" && AddressName != "cancel")
        TempstrAddress = TempAddressUserName + " (" + TempdialogValue + AddressName + ")";
    else
        TempstrAddress = TempAddressUserName + "(" + TempdialogValue + ")";

    if (CheckLen(TempstrAddress, 100) == false) {
        var windowName = "/myoffice/ezApprovalG/ezLine/AprDeptAddressUserName.aspx";
        if (TempstrAddress == "cancel")
            return;

        aprdeptaddressusername_cross_dialogArguments[0] = TempstrAddress;
        aprdeptaddressusername_cross_dialogArguments[1] = btnAddAddress_Complete4;
        DivPopUpShow(330, 205, windowName);
    }
    else {
        btnAddAddress_Complete4(AddressName);
    }
}

function btnAddAddress_Complete4(AddressName) {
    DivPopUpHidden();
    if (AddressName != "cancel" || TempstrAddress != "cancel") {
        AprLineAddDeptAddress(TempstrAddress);
    }
}
function CheckLen(pStr, pSize) {
    var ch;
    var count = 0;
    var pKoreanLen = parseInt(parseInt(pSize) / 2, 10);
    var nlen = pStr.length;
    for (var k = 0; k < nlen; k++) {
        ch = pStr.charAt(k);
        if (escape(ch).length > 4)
            count += 2;
        else
            count++;
    }

    if (parseInt(count) > parseInt(pSize)) {
        alert(strLang254 + pSize + " byte " + strLang255 + pKoreanLen + " " + strLang256);
        return false;
    }
    else
        return true;
}
function AprLineAddDeptAddress(AddressName) {
    Resultxml.async = false;
    Resultxml = loadXMLFile(strLangEtcFile1);

    var listview = new ListView();
    listview.SetID("lvRECEPTLIST");
    listview.SetRowOnDblClick("AprDeptDel_onclick");

    var DeptAddIndex = listview.GetDataRows().length;
    if (DeptAddIndex == 0 || listview.GetDataRows()[0].id.indexOf("noItems") == -1)
        DeptAddIndex = DeptAddIndex + 1;

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[1], "Address" + DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
    setNodeText(GetChildNodes(objNodes[0])[3], "Y");
    setNodeText(GetChildNodes(objNodes[0])[4], "N");
    setNodeText(GetChildNodes(objNodes[0])[5], "N");
    setNodeText(GetChildNodes(objNodes[0])[6], "");
    setNodeText(GetChildNodes(objNodes[0])[7], "");
    setNodeText(GetChildNodes(objNodes[0])[8], "");
    setNodeText(GetChildNodes(objNodes[0])[9], "");
    setNodeText(GetChildNodes(objNodes[0])[10], AddressName);
    setNodeText(GetChildNodes(objNodes[0])[11], AddressName);
    setNodeText(GetChildNodes(objNodes[0])[12], "");
    setNodeText(GetChildNodes(objNodes[0])[13], "");
    setNodeText(GetChildNodes(objNodes[1])[0], AddressName);

    var tr = listview.GetSelectedRows();
    var InitTr = listview.GetDataRows();

    var MaxID = 0;
    for (var j = 0  ; j < InitTr.length  ; j++) {
        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }

    if (tr.length == 0) {
        if (InitTr.length == 0) {
            document.getElementById('RECEPTLIST').innerHTML = "";
            var listview = new ListView();
            listview.SetID("lvRECEPTLIST");
            listview.SetMulSelectable(false);
            listview.SetHeightFree(true);
            listview.SetRowOnDblClick("AprDeptDel_onclick");
            listview.DataSource(Resultxml);
            listview.DataBind("RECEPTLIST");
        } else {
            var SelIndex = Number(listview.GetSelectedIndexes().split(',')[0]);
            var objTr = listview.AddRow(SelIndex);
            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
        }
    } else {
        var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
        SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
        listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

        ReSetAprLineDept(listview);
    }

    DeptAddIndex = DeptAddIndex + 1;

    return true;
}
var SelDivName = "";
function InsertRecAll() {
    try {

        if (CrossYN() || pNoneActiveX == "YES") {
            var pAlertContent = T1361andT1362;
            var Ans = OpenInformationUI(pAlertContent, InsertRecAll_Complete);
        } else {
            var pAlertContent = T1361andT1362;
            var Ans = OpenInformationUI(pAlertContent);
            InsertRecAll_Complete(Ans);
        }

    } catch (e) {
        alert("Receptinfo.js.InsertRecAll()::" + e.description);
    }
}

function InsertRecAll_Complete(_RESPONSE) {

    if (SelDivName == "Organ" && _RESPONSE == true) {
        var treeNode = new TreeNode();
        treeNode.LoadFromID(nodeIdx);

        
        if (treeNode.GetNodeData("CN") == "") {
            alert("부서아이디가 없습니다.");
            return;
        }

        
        if (treeNode.GetNodeData("VALUE") == "") {
            alert("부서명이 없습니다.");
            return;
        }

        insertOrganAll(treeNode.GetNodeData("CN"), treeNode.GetNodeData("VALUE"));
    }
    if (SelDivName == "Outer" && _RESPONSE == true) {
        if (!_RESPONSE)
            return;

        var treeView = new TreeView();
        treeView.LoadFromID("tvTreeView3");
        var selectnode = treeView.GetSelectNode();
        insertOuterAll(selectnode.GetNodeData("DATA1"), selectnode.GetNodeData("VALUE"), selectnode.GetNodeData("DATA2"), selectnode.GetNodeData("DATA3"));
    }

    DivPopUpHidden();
}

function DeleteRecAll() {
    try {
        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");
        var CurSelRow = listview.GetDataRows();
        var DeleteState;
        for (var i = 0; i < CurSelRow.length; i++) {
            try {
                DeleteState = DeptRowDelelte(listview.GetSelectedIndexes().split(',')[0], listview.GetDataRows());
                if (DeleteState == "Y")
                    listview.DeleteRow(GetAttribute(CurSelRow[i], "id"));
            } catch (e) {
                alert(e.description);
            }
        }
    } catch (e) {
        alert("Receptinfo.js.DeleteRecAll()::" + e.description);
    }
}
function InsertRec() {
    try {
        if (SelDivName == "Organ") {
            AprDeptAdd_onclick('DEPT');
        }

        if (SelDivName == "Outer") {
            AprDeptOuterAdd_onclick();
        }
    } catch (e) {
        alert("Receptinfo.js.InsertRec()::" + e.description);
    }
}
function DeleteRec() {
    try {
        AprDeptDel_onclick();
    } catch (e) {
        alert("Receptinfo.js.DeleteRec()::" + e.description);
    }
}
function insertOrganAll(_ParentOrganId, _ParentOrganName) {

    var XmlHttp = null;
    var XmlDoc = null;
    var objNode;

    try {

        if (nodeIdx != "") {

            if (isExistDept(true)) {
                var pAlertContent = strLang244 + "</br>" + strLang245;
                OpenAlertUI(pAlertContent);
                return;
            }

            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx);

            var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, _ParentOrganId);
            if (DuplicateFlag)
                AddOrgan(_ParentOrganId, _ParentOrganName);

            XmlHttp = createXMLHttpRequest();
            XmlDoc = createXmlDom();

            createNodeInsert(XmlDoc, objNode, "DATA");
            createNodeAndInsertText(XmlDoc, objNode, "DEPTID", _ParentOrganId);
            createNodeAndInsertText(XmlDoc, objNode, "PROP", "EXTENSIONATTRIBUTE2");

            XmlHttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptSubTreeInfo.aspx", false);
            XmlHttp.send(XmlDoc);

            XmlDoc = null;
            XmlDoc = createXmlDom();
            XmlDoc = loadXMLString(XmlHttp.responseText);

            var objNodes = SelectNodes(XmlDoc, "NODES/NODE");

            if (objNodes.length > 0) {
                for (var i = 0; i < objNodes.length; i++) {
                    insertOrganAll(objNodes[i].getElementsByTagName("CN")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("VALUE")[0].childNodes[0].nodeValue);
                }
            }
        }

        return;

    } catch (e) {
        alert("Receptinfo.js.insertOrganAll()::" + e.description);
    } finally {
        XmlHttp = null;
        XmlDoc = null;
        objNode = null;
    }
}
function AddOrgan(_OrganId, _OrganName) {

    try {
        var isCurretnCompany = "N";
        var Resultxml = "";
        Resultxml.async = false;
        Resultxml = loadXMLFile(strLangEtcFile1);

        var treeNode = new TreeNode();
        treeNode.LoadFromID(nodeIdx);

        
        if (GetEntryInfo(_OrganId) == "N") {
            return;
        }

        var deptid = _OrganId;
        if (!isgetUser(deptid)) {
            return;
        }

        if (!isReceiverChk(deptid)) {
            return;
        }

        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");

        DeptAddIndex = listview.GetRowCount();
        if (DeptAddIndex == 1) {
            var tr = listview.GetDataRows();
            if (tr[0].id.indexOf("noItems") > 0)
                DeptAddIndex = 0;
        }
        DeptAddIndex = DeptAddIndex + 1;
        var strCmpID = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");
        var strCmpNm = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");

        var pCompanyNAME;

        if (strCmpID == "TopGroup")
            pCompanyNAME = treeNode.GetNodeData("VALUE");
        else
            pCompanyNAME = strCmpNm;

        var pDeptNm = _OrganName;
        var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
        setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
        setNodeText(GetChildNodes(objNodes[0])[1], deptid);
        setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
        setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);
        setNodeText(GetChildNodes(objNodes[0])[4], "N");
        setNodeText(GetChildNodes(objNodes[0])[5], "N");
        setNodeText(GetChildNodes(objNodes[0])[6], strCmpID);
        setNodeText(GetChildNodes(objNodes[0])[7], "");
        setNodeText(GetChildNodes(objNodes[0])[8], "");
        setNodeText(GetChildNodes(objNodes[0])[9], "");
        setNodeText(GetChildNodes(objNodes[0])[10], pDeptNm);
        setNodeText(GetChildNodes(objNodes[0])[11], pDeptNm);
        setNodeText(GetChildNodes(objNodes[0])[12], "");
        setNodeText(GetChildNodes(objNodes[0])[13], "");
        setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);

        var tr = listview.GetSelectedRows();
        var InitTr = listview.GetDataRows();
        var MaxID = 0;

        for (var j = 0; j < InitTr.length; j++) {
            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
            if (MaxID < curnum)
                MaxID = curnum;
        }

        if (tr.length == 0) {
            if (InitTr.length == 0 || InitTr[0].id.indexOf("noItems") > 0) {
                document.getElementById('RECEPTLIST').innerHTML = "";
                var listview = new ListView();
                listview.SetID("lvRECEPTLIST");
                listview.SetSelectFlag(false);
                listview.SetHeightFree(true);
                listview.SetRowOnDblClick("AprDeptDel_onclick");
                listview.DataSource(Resultxml);
                listview.DataBind("RECEPTLIST");
            } else {
                var objTr = listview.AddRow(0);
                SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
            }
        } else {
            var objTr = listview.AddRow(0);
            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
        }
    } catch (e) {
        alert("Receptinfo.js.AddOrgan()::" + e.description);
    }
}
function insertOuterAll(outerdeptid, outerdeptnm, outerdeptoupath, ouReceiveDocumentYN) {

    var XmlHttp = null;
    var XmlDoc = null;
    var objNode;

    try {

        var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, outerdeptid);
        if (DuplicateFlag && ouReceiveDocumentYN == "Y") {
            AddOuter(outerdeptid, outerdeptnm);
        }

        XmlHttp = createXMLHttpRequest();
        XmlDoc = createXmlDom();

        createNodeInsert(XmlDoc, objNode, "PARA");
        createNodeAndInsertText(XmlDoc, objNode, "DEPTID", outerdeptoupath);

        XmlHttp.open("POST", "/myoffice/ezApprovalG/ezOrganG/GetOrganSubTreeInfo.aspx", false);
        XmlHttp.send(XmlDoc);

        XmlDoc = null;
        XmlDoc = createXmlDom();
        XmlDoc = loadXMLString(XmlHttp.responseText);

        var objNodes = SelectNodes(XmlDoc, "NODES/NODE");

        if (objNodes.length > 0) {
            for (var i = 0; i < objNodes.length; i++) {
                insertOuterAll(objNodes[i].getElementsByTagName("DATA1")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("VALUE")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("DATA2")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("DATA3")[0].childNodes[0].nodeValue);
            }
        }

        return;
    } catch (e) {
        alert("Receptinfo.js.insertOuterAll()::" + e.description);
    } finally {
        XmlHttp = null;
        XmlDoc = null;
        objNode = null;
    }
}
function AddOuter(strOuterDeptId, strOuterDeptName) {
    try {
        var isCurretnCompany = "Y";
        Resultxml.async = false;

        Resultxml = loadXMLFile(strLangEtcFile1);

        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");

        DeptAddIndex = listview.GetRowCount();

        if (DeptAddIndex == "1") {
            var tr = listview.GetDataRows();
            if (tr[0].id.indexOf("noItems") > 0)
                DeptAddIndex = 0;
        }

        DeptAddIndex = DeptAddIndex + 1;

        
        var rtnNodes = getExtLdapInfo(strOuterDeptId);
        if (rtnNodes == null)
            return false;
        if (rtnNodes.childNodes.length <= 0)
            return false;

        var OutDeptList = "";

        if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
            else
                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
        } else {

            var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
            if (tempRtnNodes == null)
                return false;

            
            if (tempRtnNodes.childNodes.length <= 0) {
                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                else
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
            } else {
                
                
                if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                } else {
                    
                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "") {
                        var namelength = getNodeText(GetChildNodes(rtnNodes)[3]).length - 1;
                        var location = getNodeText(GetChildNodes(rtnNodes)[3]).indexOf(strLang93);
                        if (namelength == location)
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]);
                        else
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]) + strLang93;
                    } else {
                        if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                        } else {
                            if (getNodeText(GetChildNodes(rtnNodes)[3]).replace(getNodeText(GetChildNodes(rtnNodes)[2]), '') == "")
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[3]).replace(getNodeText(GetChildNodes(rtnNodes)[2]), '') + "(" + getNodeText(GetChildNodes(rtnNodes)[8]) + ")";
                        }
                    }
                }
            }
        }

        var pDeptNm = OutDeptList;
        var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
        setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
        setNodeText(GetChildNodes(objNodes[0])[1], strOuterDeptId);
        setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
        setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);
        setNodeText(GetChildNodes(objNodes[0])[4], "N");
        setNodeText(GetChildNodes(objNodes[0])[5], "N");
        setNodeText(GetChildNodes(objNodes[0])[6], "");
        setNodeText(GetChildNodes(objNodes[0])[7], "");
        setNodeText(GetChildNodes(objNodes[0])[8], "");
        setNodeText(GetChildNodes(objNodes[0])[9], "");
        setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
        setNodeText(GetChildNodes(objNodes[0])[10], pDeptNm);
        setNodeText(GetChildNodes(objNodes[0])[11], pDeptNm);
        setNodeText(GetChildNodes(objNodes[0])[12], "");
        setNodeText(GetChildNodes(objNodes[0])[13], "");

        var tr = listview.GetSelectedRows();
        var InitTr = listview.GetDataRows();

        var MaxID = 0;
        for (var j = 0  ; j < InitTr.length  ; j++) {
            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
            if (MaxID < curnum)
                MaxID = curnum;
        }

        if (tr.length == 0) {
            if (InitTr.length == 0) {
                document.getElementById('RECEPTLIST').innerHTML = "";
                var listview = new ListView();
                listview.SetID("lvRECEPTLIST");
                listview.SetMulSelectable(false);
                listview.SetHeightFree(true);
                listview.SetRowOnDblClick("AprDeptDel_onclick");
                listview.DataSource(Resultxml);
                listview.DataBind("RECEPTLIST");
                listview.SetSelectFlag(false);
            } else {
                var objTr = listview.AddRow(0);
                SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
            }
        } else {
            var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

            ReSetAprLineDept(listview);
        }

        DeptAddIndex = DeptAddIndex + 1;

        if (InitTr.length > 8) {
            document.getElementById("inputSummaryOuterReceiverList").focus();
            document.getElementById("trSummaryOuterReceiverList").style.display = "";
            document.getElementById("btnaddress").style.display = "none";
            document.getElementById("btnaddressChange").style.display = "none";
        } else {
            document.getElementById("trSummaryOuterReceiverList").style.display = "none";
            document.getElementById("inputSummaryOuterReceiverList").value = "";
            document.getElementById("btnaddress").style.display = "";
            document.getElementById("btnaddressChange").style.display = "";
        }

    } catch (e) {
        alert("Receptinfo.js.AddOuter()::" + e.description);
    }
}
function GetEntryInfo(_DEPTID) {
    var XmlHttp = null;
    var XmlDom = null;
    var Node;
    var ReceiveDocument = "";

    try {
        XmlDom = createXmlDom();
        XmlHttp = createXMLHttpRequest();

        createNodeInsert(XmlDom, Node, "DATA");
        createNodeAndInsertText(XmlDom, Node, "CN", _DEPTID);
        createNodeAndInsertText(XmlDom, Node, "PROP", "extensionAttribute11");

        XmlHttp.open("POST", "/myoffice/ezOrgan/Admin/GetEntryInfo.aspx?pMode=dept", false);
        XmlHttp.send(XmlDom);

        if (XmlHttp.status == 200) {
            XmlDom = loadXMLString(XmlHttp.responseText);
            ReceiveDocument = SelectSingleNodeValueNew(XmlDom, "DATA/EXTENSIONATTRIBUTE11").trim();
        }

    } catch (e) {
        alert(e.description);
    } finally {
        XmlHttp = null;
        XmlDom = null;
        Node = null;
    }
    return ReceiveDocument;
}


//2018.11.28 문서24
function liniReceptDoc24() {
    xmlhttp2 = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "SEARCH", "");

    xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezOrganG/Doc24/GetDoc24DeptList.aspx", true);
    xmlhttp2.onreadystatechange = event_GetReceptDoc24List;
    xmlhttp2.send(xmlpara);
}
function event_GetReceptDoc24List() {
    if (xmlhttp2 == null || xmlhttp2.readyState != 4 || loadXMLString(xmlhttp2.responseText) == null) return;
    try {

        if (xmlhttp2.responseText == "Error")
            return;

        document.getElementById('RecDoc24List').innerHTML = "";
        var listview = new ListView();
        listview.SetID("lvDoc24");
        listview.SetMulSelectable(false);
        listview.SetHeightFree(true);
        //listview.SetDrop("receptDrop");
        listview.SetRowOnDblClick("AddDoc24_onclick");
        listview.DataSource(loadXMLString(xmlhttp2.responseText));
        listview.DataBind("RecDoc24List");
        listview.SetSelectFlag(false);
        xmlhttp2 = null;
    }
    catch (ErrMsg) {
        Alert_Message("event_GetReceptDoc24List : " + ErrMsg.description, null, "");
    }
}
function AddDoc24_onclick() {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var CurSelRow = listview.GetSelectedRows();

    if (isExistDept(false)) {
        alert(strLang244);
        return;
    }
    var listview5 = new ListView();
    listview5.LoadFromID("lvDoc24");
    if (listview5.GetSelectedRows().length < 0) {
        alert(strLang584);
        return;
    }

    var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, GetAttribute(listview5.GetSelectedRows()[0], "DATA1"));
    if (DuplicateFlag) {
        RecevptAddDept(listview5.GetSelectedRows()[0], CurSelRow);
    }
    else {
		alert(strLang247);
    }

}
function RecevptAddDept(node, tr) {
    var isCurretnCompany = "Y";
    Resultxml.async = false;

    Resultxml = loadXMLFile(strLangEtcFile1);

    var listview5 = new ListView();
    listview5.LoadFromID("lvDoc24");

    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");

    var DeptAddIndex = listview.GetDataRows().length;
    if (DeptAddIndex == 0 || listview.GetDataRows()[0].id.indexOf("noItems") == -1)
        DeptAddIndex = DeptAddIndex + 1;
    else {
        if (DeptAddIndex == 1 && listview.GetDataRows()[0].id == "lvRECEPTLIST_TR_noItems")
            listview.DeleteRow("lvRECEPTLIST_TR_noItems,");
    }

    var pDeptNm = GetAttribute(node, "DATA2");
    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[1], GetAttribute(node, "DATA1"));
    setNodeText(GetChildNodes(objNodes[0])[2], pDocID);

    //setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);
    setNodeText(GetChildNodes(objNodes[0])[3], "Y");
    setNodeText(GetChildNodes(objNodes[0])[4], "N");
    setNodeText(GetChildNodes(objNodes[0])[5], "N");
    setNodeText(GetChildNodes(objNodes[0])[6], "");
    setNodeText(GetChildNodes(objNodes[0])[7], "");
    setNodeText(GetChildNodes(objNodes[0])[8], "");
    setNodeText(GetChildNodes(objNodes[0])[9], "");
    setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
    setNodeText(GetChildNodes(objNodes[0])[10], pDeptNm);
    setNodeText(GetChildNodes(objNodes[0])[11], pDeptNm);
    setNodeText(GetChildNodes(objNodes[0])[12], "");
    setNodeText(GetChildNodes(objNodes[0])[13], "");

    var tr = listview.GetSelectedRows();
    var InitTr = listview.GetDataRows();

    var MaxID = 0;
    for (var j = 0; j < InitTr.length; j++) {
        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }

    if (tr.length == 0) {
        if (InitTr.length == 0 || InitTr[0].id.indexOf("noItems") > 0) {
            document.getElementById('RECEPTLIST').innerHTML = "";
            var listview = new ListView();
            listview.SetID("lvRECEPTLIST");
            listview.SetMulSelectable(false);
            listview.SetHeightFree(true);
            listview.SetRowOnDblClick("AprDeptDel_onclick");
            listview.DataSource(Resultxml);
            listview.DataBind("RECEPTLIST");
            listview.SetSelectFlag(false);
        } else {
            var objTr = listview.AddRow(0);
            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
        }
    }
    else {
        var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
        SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
        listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

        ReSetAprLineDept(listview);
    }

    DeptAddIndex = DeptAddIndex + 1;

    if (InitTr.length > 8) {
        document.getElementById("inputSummaryOuterReceiverList").focus();
        document.getElementById("trSummaryOuterReceiverList").style.display = "";
        document.getElementById("btnaddress").style.display = "none";
        document.getElementById("btnaddressChange").style.display = "none";
    } else {
        document.getElementById("trSummaryOuterReceiverList").style.display = "none";
        document.getElementById("inputSummaryOuterReceiverList").value = "";
        document.getElementById("btnaddress").style.display = "";
        document.getElementById("btnaddressChange").style.display = "";
    }

}
function btnSearchDoc24Dept_onKeyPress() {
    if (window.event.keyCode == "13") {
        document.getElementById("SpanDoc24").onclick();
    }
}
function btnSearchDoc24Dept_onClick() {
    var tmpDeptName = document.getElementById("txtDoc24").value + "";
    var strSeach = "";
    if (tmpDeptName.length == 0) {
        //var pAlertContent = strLang240;
        //document.getElementById("txtDoc24").focus();
        //Alert_Message(pAlertContent, null, "");
        //return;
        strSeach = "";
    }
    else
        strSeach = "cmpnyNm:" + tmpDeptName;

    xmlhttp2 = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "SEARCH", strSeach);

    xmlhttp2.open("POST", "/myoffice/ezApprovalG/ezOrganG/Doc24/GetDoc24DeptList.aspx", true);
    xmlhttp2.onreadystatechange = event_GetReceptDoc24List;
    xmlhttp2.send(xmlpara);
}

var Doc24Info__dialogArguments = new Array();
function Doc24Info_onclick() {
    try {
        var listview5 = new ListView();
        listview5.LoadFromID("lvDoc24");

        if (listview5.GetSelectedRows().length < 0) {
            alert(strLang584);
            return;
        }

        var windowName = "/myoffice/ezApprovalG/ezOrganG/Doc24/Doc24DeptInfo.aspx";
        Doc24Info__dialogArguments[0] = GetAttribute(listview5.GetSelectedRows()[0], "data1");
        Doc24Info__dialogArguments[1] = Doc24Info_Complete;
        DivPopUpShow(360, 400, windowName);

    } catch (e) {
    }
}

function Doc24Info_Complete(retvalue) {
    if (!retvalue) {
        alert(strLang131);
    }
    DivPopUpHidden();

}

