//#############################################################################################################################################수신처 초기화
function Receptinfo_ini() {
    if (!Recinfoini) {
        Recinfoini = true;
        Tree_setconfig();
        TreeViewinitialize_tree2(arr_userinfo[4], companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "<%=_pServerName%>");
        if(approvalYN == "S") {
        	RdisplayUserList(arr_userinfo[4]);
        }
        ChangeReceptTab(document.getElementById("3tab1"));
        initReceptListView();
        document.getElementById("3tab1").onclick();
        //2015-06-23 표준모듈:추가 - KSK
        SelDivName = "Organ";
    }
}
//#############################################################################################################################################수신처 내부 버튼 클릭 이벤트
function ChangeReceptTab(obj) {
    if (obj.getAttribute("divname") == "Organ") {
        document.getElementById("ReceptOrgan").style.display = "";
        document.getElementById("ReceptTemp").style.display = "none";
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("ReceptOuter").style.display = "none";
        document.getElementById("btnaddressChange").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "";
        document.getElementById("AprDeptOuterAdd").style.display = "none";
        internalTab = true;
        //2015-06-23 표준모듈:추가 - KSK
        SelDivName = "Organ";
        document.getElementById("imgInsertAll").style.display = "";
        document.getElementById("imgDeleteAll").style.display = "";
        document.getElementById("AddRemoveBTN").style.display = "";
    }
    else if (obj.getAttribute("divname") == "Save") {
        if (!Recinfoini3) {
            Recinfoini3 = true;
            InitReceptTemplet();
        }
        document.getElementById("ReceptOrgan").style.display = "none";
        document.getElementById("ReceptTemp").style.display = "";
        document.getElementById("ReceptOuter").style.display = "none";
        document.getElementById("btnaddressChange").style.display = "none";
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "";
        document.getElementById("AprDeptOuterAdd").style.display = "none";
        //2015-06-23 표준모듈:추가 - KSK
        document.getElementById("AddRemoveBTN").style.display = "none";
    }
    else if (obj.getAttribute("divname") == "Group") {
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
        //2015-06-23 표준모듈:추가 - KSK
        document.getElementById("AddRemoveBTN").style.display = "none";
    }
    else if (obj.getAttribute("divname") == "Outer") {
        document.getElementById("ReceptOrgan").style.display = "none";
        document.getElementById("ReceptTemp").style.display = "none";
        document.getElementById("ReceptOuter").style.display = "";
        document.getElementById("btnaddressChange").style.display = "";
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "none";
        document.getElementById("AprDeptOuterAdd").style.display = "";
        internalTab = false;
        //2015-06-23 표준모듈:추가 - KSK
        SelDivName = "Outer";
        document.getElementById("imgInsertAll").style.display = "none";
        document.getElementById("imgDeleteAll").style.display = "none";
        document.getElementById("AddRemoveBTN").style.display = "";
    }
}

//#############################################################################################################################################수신처 리스트 초기화
var xmlhttp;
function initReceptListView() {

	var result = "";
	var pMode = "";
	var docIDorSN = "";
    if (pDocSn == "") {
    	docIDorSN = pDocID;
        pMode = "COD";
    }
    else {
    	docIDorSN = pDocSn;
        pMode = "TMP";
    }
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/aprDeptRequest.do",
		data : {
			docID : docIDorSN,
			mode  : pMode
		},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});

    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
    if (SelectNodes(result, "LISTVIEWDATA/ROWS/ROW").length > 9) {
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
    listview.DataSource(result);
    listview.DataBind("RECEPTLIST");
    listview.SetSelectFlag(false);
    xmlhttp = null;

}
function event_initReceptListView() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        Resultxml = xmlhttp.responseXML;

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
//#############################################################################################################################################수신처 조직도 트리뷰 초기화
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
        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
        xmlHTTP.send(xmlpara);
        var xmlDomRet = createXmlDom();
        xmlDomRet = xmlHTTP.responseXML;

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
        xmlDomRet = xmlHTTP.responseXML;

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
//#############################################################################################################################################수신처 조직도 트리뷰 클릭 이벤트 
var nodeIdx;
function TreeViewNodeClick2(pNodeID, pNodeNM) {
    nodeIdx = pNodeID;

    var treeNode = new TreeNode();
    treeNode.LoadFromID(nodeIdx);
    if (approvalYN == 'S') {
    	RdisplayUserList(treeNode.GetNodeData("CN"));
    }
}
function RequestData2(pNodeID, pTreeID) {
    nodeIdx = pNodeID;
    var xmlHTTP = createXMLHttpRequest();

    var treeNode = new TreeNode();
    treeNode.LoadFromID(pNodeID);

    var strQuery = "<DATA><DEPTID>" + treeNode.GetNodeData("CN") + "</DEPTID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName;displayName2</PROP></DATA>";

    xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
    xmlHTTP.send(strQuery);


    var treeView = new TreeView();
    treeView.LoadFromID(pTreeID);
    treeView.AppendChildNodes(xmlHTTP.responseXML.documentElement, pNodeID);
}
//#############################################################################################################################################수신처 조직도 사용자 가져오기 
var ReceptUserXmlHttp;
function RdisplayUserList(DeptID) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezOrgan/getDeptMemberList.do",
		data : {
				deptID   : DeptID, 
				cell 	 : "displayName;description;title;telephoneNumber",
				prop     : "department;displayName;description;title;physicalDeliveryOfficeName",
				type 	 : "user"
				},
		success: function(xml){
			event_RdisplayUserList(loadXMLString(xml));
		}        			
	});

}
//#############################################################################################################################################수신처 조직도 사용자 가져오기 
function event_RdisplayUserList(xml) {
	 var retXml = createXmlDom();
	 
	 if (document.getElementById("UserList2").innerHTML != "") {
	     document.getElementById("UserList2").innerHTML = "";
	 }   
	 
	var headerData = createXmlDom();
    headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());

    if (xml != "") {
        if (CrossYN()) {
            var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
            var Node = headerData.importNode(xmlRtn, true);
            headerData.documentElement.appendChild(Node);
        }
        else {
            var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
            headerData.documentElement.appendChild(xmlRtn);
        }
    }
            var listview = new ListView();
            listview.SetID("lvUserList2");
            listview.SetSelectFlag(false);
            listview.SetHeightFree(true);
            listview.SetRowOnDblClick("Rlist2_onSel_DBclick");
            listview.DataSource(headerData);
            listview.DataBind("UserList2");
            
            var userRows = listview.GetDataRows();

            if (userRows.length <= 0) {
                OpenAlertUI(linealt11);
            }
            else if (USE_OCS.toUpperCase() == "YES") {
                check_presence();
            }
}
//#############################################################################################################################################수신처 리스트 삭제 이벤트
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
                listview.DeleteRow(CurSelRow[i].getAttribute("id"));
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
//#############################################################################################################################################수신처 리스트 삭제 이벤트
function DeptRowDelelte(SelectIndex, ColRow) {
    var RowDelCheck;
    var ReturnVal = "N";
    TIndex = ColRow.length;
    NIndex = SelectIndex;
    for (i = 0; i <= NIndex; i++) {
        RowDelCheck = ColRow[i].cells[0].innerText;
        if (CrossYN())
            ColRow[i].childNodes[0].textContent = RowDelCheck - 1;
        else
            ColRow[i].cells[0].innerText = RowDelCheck - 1;

        var ReturnVal = "Y";
    }
    return ReturnVal;
}
//#############################################################################################################################################수신처 리스트 삭제 이벤트
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
        GetXml = GetXml + "<VALUE>" + MakeXMLString(GetChildNodes(AprDeptRow[i])[0].innerText) + "</VALUE>";
        GetXml = GetXml + "<DATA1>" + AprDeptRow[i].getAttribute("DATA1") + "</DATA1>";
        GetXml = GetXml + "<DATA2>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA2")) + "</DATA2>";
        GetXml = GetXml + "<DATA3>" + AprDeptRow[i].getAttribute("DATA3") + "</DATA3>";
        GetXml = GetXml + "<DATA4>" + AprDeptRow[i].getAttribute("DATA4") + "</DATA4>";
        GetXml = GetXml + "<DATA5>" + AprDeptRow[i].getAttribute("DATA5") + "</DATA5>";
        GetXml = GetXml + "<DATA6>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA6")) + "</DATA6>";
        GetXml = GetXml + "<DATA7>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA7")) + "</DATA7>";
        GetXml = GetXml + "<DATA8>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA8")) + "</DATA8>";
        GetXml = GetXml + "<DATA9>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA9")) + "</DATA9>";
        GetXml = GetXml + "<DATA10>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA10")) + "</DATA10>";
        GetXml = GetXml + "<DATA11>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA11")) + "</DATA11>";
        //GetXml = GetXml + "<DATA12>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA12")) + "</DATA12>";
        //GetXml = GetXml + "<DATA13>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA13")) + "</DATA13>";
        if (AprDeptRow[i].getAttribute("DATA12") == null)
            GetXml = GetXml + "<DATA12></DATA12>";
        else
            GetXml = GetXml + "<DATA12>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA12")) + "</DATA12>";
        if (AprDeptRow[i].getAttribute("DATA13") == null)
            GetXml = GetXml + "<DATA13></DATA13>";
        else
            GetXml = GetXml + "<DATA13>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA13")) + "</DATA13>";
        GetXml = GetXml + "</CELL><CELL>";
        GetXml = GetXml + "<VALUE>" + MakeXMLString(GetChildNodes(AprDeptRow[i])[1].innerText) + "</VALUE>";
        GetXml = GetXml + "</CELL>";
        GetXml = GetXml + "</ROW>";
    }

    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
    return GetXml;
}
//#############################################################################################################################################수신처 사용자 추가 이벤트
function Rlist2_onSel_DBclick() {
    AprDeptAdd_onclick('USER');
}
//#############################################################################################################################################수신처 사용자 추가 이벤트
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
                //2015-05-08 추가 - KSK
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
                var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, pCurSelRow[0].getAttribute("DATA3"));
                if (DuplicateFlag)
                    AprLineAddDept_User(pCurSelRow[0]);
                else {
                    var pAlertContent = linealt13;
                    OpenAlertUI(pAlertContent);
                }
            }
        }
    }
    catch (e) {
        alert("AprDeptAdd_onclick : " + e.description);
    }
}
//#############################################################################################################################################수신처 중복체크
function DuplicateAprDeptCheck(APRDEPT, arrUserInfo) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var AprDeptList = listview.GetDataRows();
    var AprDeptListLen = AprDeptList.length;
    var i;

    for (i = 0 ; i < AprDeptListLen; i++) {
        if (AprDeptList[0].getAttribute("DATA1") == null) {
            return true; break;
        }
        if (AprDeptList[i].getAttribute("DATA1") == arrUserInfo) {
            return false;
            break;
        }
    }
    return true;
}
//#############################################################################################################################################수신처 부서 추가 
function AprLineAddDept(nodeIdx, tr) {
    var isCurretnCompany = "N";
    var Resultxml = "";
    Resultxml.async = false;
    if(approvalYN == "G") {
    	Resultxml = loadXMLFile(strLangEtcFile1);
    } else {
    	Resultxml = loadXMLFile(strLangEtcFileliban1);
    }	
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
    setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);
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
    //setNodeText(GetChildNodes(objNodes[2])[0], "-");


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
    //DeptAddIndex = DeptAddIndex + 1;
}
//#############################################################################################################################################수신처 사용자 수신 추가
function AprLineAddDept_User(pSelectedRow) {

    var isCurretnCompany = "N";
    var Resultxml ="";
    Resultxml.async = false;
    if(approvalYN == "G") {
    	Resultxml = loadXMLFile(strLangEtcFile1);
    } else {
    	Resultxml = loadXMLFile(strLangEtcFileliban1);
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

    var strCmpID = pSelectedRow.getAttribute("DATA7");
    var pDeptNm = pSelectedRow.childNodes[1].innerText;
    var puserNm = pSelectedRow.childNodes[0].innerText;

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");

    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[1], pSelectedRow.getAttribute("DATA3"));
    setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
    setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);
    setNodeText(GetChildNodes(objNodes[0])[4], "N");
    setNodeText(GetChildNodes(objNodes[0])[5], "N");
    setNodeText(GetChildNodes(objNodes[0])[6], strCmpID);
    setNodeText(GetChildNodes(objNodes[0])[7], pSelectedRow.getAttribute("DATA2"));
    setNodeText(GetChildNodes(objNodes[0])[8], pSelectedRow.getAttribute("DATA8"));
    setNodeText(GetChildNodes(objNodes[0])[9], pSelectedRow.getAttribute("DATA12"));
    setNodeText(GetChildNodes(objNodes[0])[10], pSelectedRow.getAttribute("DATA10"));
    setNodeText(GetChildNodes(objNodes[0])[11], pSelectedRow.getAttribute("DATA11"));
    setNodeText(GetChildNodes(objNodes[0])[12], pSelectedRow.getAttribute("DATA9"));
    setNodeText(GetChildNodes(objNodes[0])[13], pSelectedRow.getAttribute("DATA13"));
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
//#############################################################################################################################################수신처 리스트 XML Parsing
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
            GetXml = GetXml + "<COLUMN>" + MakeXMLString(AprDeptRow[i].cells[j].innerText) + "</COLUMN>";

        if (trim_Cross(AprDeptRow[i].getAttribute("DATA2")) == "") {
            GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
        }
        else {
            GetXml = GetXml + "<DATA name='DocID'>" + AprDeptRow[i].getAttribute("DATA2") + "</DATA>";
        }
        GetXml = GetXml + "<DATA name='ReceiptPointID'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA1")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ExtReceptYN'>" + AprDeptRow[i].getAttribute("DATA3") + "</DATA >";
        GetXml = GetXml + "<DATA name='ProcessYN'>" + AprDeptRow[i].getAttribute("DATA4") + "</DATA>";
        GetXml = GetXml + "<DATA name='CanEditYN'>" + AprDeptRow[i].getAttribute("DATA5") + "</DATA>";
        GetXml = GetXml + "<DATA name='ExtReceptEmail'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA6")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReceiptMemberID'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA7")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReceiptMemberName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA8")) + "</DATA>";
        GetXml = GetXml + "<DATA name='ReceiptMemberJobTitle'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA9")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprMemberDeptName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA10")) + "</DATA>";
        GetXml = GetXml + "<DATA name='AprMemberDeptName2'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA11")) + "</DATA>";
        
        if (AprDeptRow[i].getAttribute("DATA12") == null)
            GetXml = GetXml + "<DATA name='ReceiptMemberName2'></DATA>";
        else
            GetXml = GetXml + "<DATA name='ReceiptMemberName2'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA12")) + "</DATA>";

        if (AprDeptRow[i].getAttribute("DATA13") == null)
            GetXml = GetXml + "<DATA name='ReceiptMemberJobTitle2'></DATA>";
        else
            GetXml = GetXml + "<DATA name='ReceiptMemberJobTitle2'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA13")) + "</DATA>";


        GetXml = GetXml + "</ROW>";
    }

    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";

    return GetXml;
}
//############################################################################################################################################# 조직도 사용자 검색
function textUser_onkeypress2() {
    if (window.event.keyCode == "13") {
        document.getElementById("Span2").focus();
    }
}
//############################################################################################################################################# 조직도 사용자 검색 
function btn_searchUser_onclick2() {
    searchUserList2();
}

//############################################################################################################################################# 조직도 사용자 검색
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
    		$.ajax({
    			type : "POST",
    			dataType : "text",
    			async : true,
    			url : "/ezOrgan/getSearchList.do",
    			data : {
    				search : "displayname::" + strSearch + ";;PhysicalDeliveryOfficeName::" + companyID,
    				cell   : "displayname;description;title;telephonenumber",
    				prop   : "department;displayName;description;title;physicalDeliveryOfficeName",
    				type   : "user"
    			},
    			success: function(xml){
    				event_displayUserList2(loadXMLString(xml));
    			}
    		});
        }
    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}
function event_displayUserList2(xml) {
    var retXml = createXmlDom();

    if (document.getElementById("UserList2").innerHTML != "")
        document.getElementById("UserList2").innerHTML = "";

    var headerData = createXmlDom();
    headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
    if (xml != "") {
        if (CrossYN()) {
            var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
            var Node = headerData.importNode(xmlRtn, true);
            headerData.documentElement.appendChild(Node);
        }
        else {
            var xmlRtn = xml.documentElement.getElementsByTagName("ROWS")[0];
            headerData.documentElement.appendChild(xmlRtn);
        }
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
    	check_presence_Rec();
    }
}

// 수정(2007.07.09) : 공문서유통 수신처 검색 기능 추가 - 내부 수신처 검색기능도 추가
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

		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezOrgan/getSearchList.do",
			data : {
				search : "EXACT_EXTENSIONATTRIBUTE2::" + CompanyID + ";;displayname::" + tmpDeptName,
				cell   : "extensionAttribute3;displayname;extensionAttribute9;",
				prop   : "",
				type   : "group"
			},
			success: function(xml){
				document.getElementById("txtDeptName").focus();
                xmlDOM = loadXMLString(xml);
                adCount = xmlDOM.getElementsByTagName("ROW").length;
			},
	    	error : function(error){
	    		document.getElementById("txtDeptName").focus();
                alert(strLang241 + error.responseText);
	    	}
		});
		
        if (adCount == 0) {
            var pAlertContent = strLang242;
            OpenAlertUI(pAlertContent);
            return;
        }
        else if (adCount == 1) {
            g_xmlHTTP = createXMLHttpRequest();

            var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]) +
					"</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
            g_xmlHTTP.send(strQuery);
        }
        else {
            var rgParams = new Array();
            rgParams["addrBook"] = xmlDOM;
            rgParams["deptid"] = "";
            if (CrossYN()) {
                checkname2_cross_dialogArguments[0] = rgParams;
                checkname2_cross_dialogArguments[1] = btnSearchDept_onClick_Complete2;

                DivPopUpShow(609, 372, "/ezPersonal/checkName2.do");
            }
            else {
                window.showModalDialog("/ezPersonal/checkName2.do", rgParams, "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken");

                if (rgParams["deptid"] != "") {
                    g_xmlHTTP = createXMLHttpRequest();
                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
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
        if (CrossYN()) {
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
                    if(approvalYN == "G") {
                    	Resultxml = loadXMLFile(strLangEtcFile1);
                    } else {
                    	Resultxml = loadXMLFile(strLangEtcFileliban1);
                    }

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
                    // getNodeText(GetChildNodes(rtnNodes)[0]) : 기관코드(ouCode)
                    // getNodeText(GetChildNodes(rtnNodes)[1]) : BaseDN
                    // getNodeText(GetChildNodes(rtnNodes)[2]) : 기관명(ou)
                    // getNodeText(GetChildNodes(rtnNodes)[3]) : 전체조직명(ucOrgFullName)
                    // getNodeText(GetChildNodes(rtnNodes)[4]) : 최상위기관코드(topOUCode)
                    // getNodeText(GetChildNodes(rtnNodes)[5]) : 차상위기관코드(parentOUCode)
                    // getNodeText(GetChildNodes(rtnNodes)[8]) : 발신명의(ucChiefTitle)

                    if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                        else
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                    } else {

                        var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
                        if (tempRtnNodes == null) return false;

                        // 최상위 기관이 없을때 
                        if (tempRtnNodes.childNodes.length <= 0) {
                            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                        } else {
                            // 최상위 기관이 있을때
                            // FullName이 Null 인 경우 
                            if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                                else
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                            } else {
                                // FullName이 Null이 아닌 경우
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

                    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
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
                /* 2015-06-30 표준모듈:추가(외부수신자요약, 검색된 수신자 다중 추가) - KSK */
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
                        if(approvalYN == "G") {
                        	Resultxml = loadXMLFile(strLangEtcFile1);
                        } else {
                        	Resultxml = loadXMLFile(strLangEtcFileliban1);
                        }

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
                        // getNodeText(GetChildNodes(rtnNodes)[0]) : 기관코드(ouCode)
                        // getNodeText(GetChildNodes(rtnNodes)[1]) : BaseDN
                        // getNodeText(GetChildNodes(rtnNodes)[2]) : 기관명(ou)
                        // getNodeText(GetChildNodes(rtnNodes)[3]) : 전체조직명(ucOrgFullName)
                        // getNodeText(GetChildNodes(rtnNodes)[4]) : 최상위기관코드(topOUCode)
                        // getNodeText(GetChildNodes(rtnNodes)[5]) : 차상위기관코드(parentOUCode)
                        // getNodeText(GetChildNodes(rtnNodes)[8]) : 발신명의(ucChiefTitle)

                        if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                        } else {

                            var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
                            if (tempRtnNodes == null) return false;

                            // 최상위 기관이 없을때 
                            if (tempRtnNodes.childNodes.length <= 0) {
                                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                                else
                                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                            } else {
                                // 최상위 기관이 있을때
                                // FullName이 Null 인 경우 
                                if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                                    else
                                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                                } else {
                                    // FullName이 Null이 아닌 경우
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

                        /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
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
        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + CompanyID + "</TOPID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName</PROP></DATA>";
        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
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
            if(approvalYN == "G") {
            	Resultxml = loadXMLFile(strLangEtcFile1);
            } else {
            	Resultxml = loadXMLFile(strLangEtcFileliban1);
            }

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
            // getNodeText(GetChildNodes(rtnNodes)[0]) : 기관코드(ouCode)
            // getNodeText(GetChildNodes(rtnNodes)[1]) : BaseDN
            // getNodeText(GetChildNodes(rtnNodes)[2]) : 기관명(ou)
            // getNodeText(GetChildNodes(rtnNodes)[3]) : 전체조직명(ucOrgFullName)
            // getNodeText(GetChildNodes(rtnNodes)[4]) : 최상위기관코드(topOUCode)
            // getNodeText(GetChildNodes(rtnNodes)[5]) : 차상위기관코드(parentOUCode)
            // getNodeText(GetChildNodes(rtnNodes)[8]) : 발신명의(ucChiefTitle)

            if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                else
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
            } else {

                var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
                if (tempRtnNodes == null) return false;

                // 최상위 기관이 없을때 
                if (tempRtnNodes.childNodes.length <= 0) {
                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                } else {
                    // 최상위 기관이 있을때
                    // FullName이 Null 인 경우 
                    if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                        else
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                    } else {
                        // FullName이 Null이 아닌 경우
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

            /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
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
        /* 2015-06-30 표준모듈:추가(외부수신자요약, 검색된 수신자 다중 추가) - KSK */

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
                if(approvalYN == "G") {
                	Resultxml = loadXMLFile(strLangEtcFile1);
                } else {
                	Resultxml = loadXMLFile(strLangEtcFileliban1);
                }

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
                // getNodeText(GetChildNodes(rtnNodes)[0]) : 기관코드(ouCode)
                // getNodeText(GetChildNodes(rtnNodes)[1]) : BaseDN
                // getNodeText(GetChildNodes(rtnNodes)[2]) : 기관명(ou)
                // getNodeText(GetChildNodes(rtnNodes)[3]) : 전체조직명(ucOrgFullName)
                // getNodeText(GetChildNodes(rtnNodes)[4]) : 최상위기관코드(topOUCode)
                // getNodeText(GetChildNodes(rtnNodes)[5]) : 차상위기관코드(parentOUCode)
                // getNodeText(GetChildNodes(rtnNodes)[8]) : 발신명의(ucChiefTitle)

                if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                } else {

                    var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
                    if (tempRtnNodes == null) return false;

                    // 최상위 기관이 없을때 
                    if (tempRtnNodes.childNodes.length <= 0) {
                        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                        else
                            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                    } else {
                        // 최상위 기관이 있을때
                        // FullName이 Null 인 경우 
                        if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                            else
                                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                        } else {
                            // FullName이 Null이 아닌 경우
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

                /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
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
            xmlDom = loadXMLFile("/xml/organtree_config.xml");

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
            alert(strLang249 + g_xmlHTTP.statusText);
            g_xmlHTTP = null;
        }
    }
}
var xmlhttp2;
//############################################################################################################################################# 외부 수신처 그룹 로딩
function liniReceptOuter() {
    xmlhttp2 = createXMLHttpRequest();
    xmlhttp2.open("POST", "/ezOrgan/getOrganTreeInfo.do", true);
    xmlhttp2.onreadystatechange = event_GetReceptOuterTempletList;
    xmlhttp2.send();
}
function event_GetReceptOuterTempletList() {
    if (xmlhttp2 == null || xmlhttp2.readyState != 4 || xmlhttp2.responseXML == null) return;
    try {

        if (xmlhttp2.responseText == "Error")
            return;

        document.getElementById('TreeView3').innerHTML = "";
        var treeView = new TreeView();
        treeView.SetID("tvTreeView3");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("RequestDataG");
        treeView.SetNodeClick("TreeViewNodeClick");
        treeView.DataSource(xmlhttp2.responseXML);
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
            if (CrossYN()) {
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

    //2015-07-10 표준모듈:추가(트리에서 추가 시 수발신 여부가 Y 인 외부수신자만 추가되도록) - KSK
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

    if(approvalYN == "G") {
    	Resultxml = loadXMLFile(strLangEtcFile1);
    } else {
    	Resultxml = loadXMLFile(strLangEtcFileliban1);
    }	

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

    // TreeView 선택 기관 코드 
    var rtnNodes = getExtLdapInfo(treeNode.GetNodeData("DATA1"));
    if (rtnNodes == null) return false;
    if (rtnNodes.childNodes.length <= 0) return false;

    var OutDeptList = "";
    // getNodeText(GetChildNodes(rtnNodes)[0]) : 기관코드(ouCode)
    // getNodeText(GetChildNodes(rtnNodes)[1]) : BaseDN
    // getNodeText(GetChildNodes(rtnNodes)[2]) : 기관명(ou)
    // getNodeText(GetChildNodes(rtnNodes)[3]) : 전체조직명(ucOrgFullName)
    // getNodeText(GetChildNodes(rtnNodes)[4]) : 최상위기관코드(topOUCode)
    // getNodeText(GetChildNodes(rtnNodes)[5]) : 차상위기관코드(parentOUCode)
    // getNodeText(GetChildNodes(rtnNodes)[8]) : 발신명의(ucChiefTitle)

    if (getNodeText(GetChildNodes(rtnNodes)[0]) == getNodeText(GetChildNodes(rtnNodes)[4])) {
        if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
        else
            OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
    }
    else {

        var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
        if (tempRtnNodes == null) return false;

        // 최상위 기관이 없을때 
        if (tempRtnNodes.childNodes.length <= 0) {
            if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
            else
                OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
        }
            // 최상위 기관이 있을때
        else {
            // FullName이 Null 인 경우 
            if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                else
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
            }
                // FullName이 Null이 아닌 경우
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

            //var tempRtnNodes = getExtLdapInfo(getNodeText(GetChildNodes(rtnNodes)[4]));
            //if (tempRtnNodes == null) return false;
            //if (tempRtnNodes.childNodes.length <= 0) {
            //    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
            //        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
            //    else
            //        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
            //}
            //else {
            //    if (getNodeText(GetChildNodes(tempRtnNodes)[8]) == "")
            //        OutDeptList = getNodeText(GetChildNodes(tempRtnNodes)[2]) + strLang93;
            //    else
            //        OutDeptList = getNodeText(GetChildNodes(tempRtnNodes)[8]);

            //    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
            //        OutDeptList = OutDeptList + "(" + getNodeText(GetChildNodes(rtnNodes)[2]) + strLang246;
            //    else
            //        OutDeptList = OutDeptList + "(" + getNodeText(GetChildNodes(rtnNodes)[8]) + ")";
            //}
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

    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
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

        if (GetAttribute(CurSelRow[0], "DATA1") == "Address") {
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

        return xmlhttp2.responseXML.documentElement;
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
    CIndex = Number(listview.GetSelectedIndexes().split(',')[0]);
    NIndex = TIndex - CIndex;

    if (CIndex != 0) {
        for (i = 0 ; i < (CIndex + 2) ; i++)
            if (i != TIndex) {
                if (CrossYN())
                    ColRow[i].childNodes[0].textContent = TIndex - i;
                else
                    ColRow[i].cells[0].innerText = TIndex - i;
            }

        if (CrossYN())
            CurSelRow.childNodes[0].textContent = NIndex;
        else
            CurSelRow.cells[0].innerText = NIndex;

        return NIndex;
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

    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
    if (listview.GetDataRows().length < 10) {
        document.getElementById("trSummaryOuterReceiverList").style.display = "none";
        document.getElementById("inputSummaryOuterReceiverList").value = "";
        document.getElementById("btnaddress").style.display = "";
    }
}

//############################################################################################################################## 민원인 주소
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
        if (GetAttribute(InitTr[0], "DATA1").indexOf("Address") != -1) {
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

    var windowName = "/ezApprovalG/aprDeptAddressUserName.do";
    if (CrossYN()) {
        aprdeptaddressusername_cross_dialogArguments[0] = "";
        aprdeptaddressusername_cross_dialogArguments[1] = btnAddAddress_Complete;

        DivPopUpShow(360, 220, windowName);
    }
    else {
        var parameter = "status:no;dialogWidth:335px;dialogHeight:195px;scroll:no;edge:sunken;help:no;";
        parameter = parameter + GetShowModalPosition(330, 205);
        var dialogValue = "";
        var AddressUserName = window.showModalDialog(windowName, dialogValue, parameter);
        if (AddressUserName == "cancel" || AddressUserName == "")
            return;

        var Para = window.showModalDialog("/ezAddress/addressZipCodePopUp.do", "", "dialogWidth:655px;dialogHeight:420px;toolbar:no;location:no;directories:no;status:no;menubar:no;scroll:no;edge:sunken;help:no" + GetShowModalPosition(330, 205));
        var windowName = "/ezApprovalG/aprDeptAddressUserName.do";
        var parameter = "status:no;dialogWidth:335px;dialogHeight:195px;scroll:no;edge:sunken;help:no;";
        parameter = parameter + GetShowModalPosition(330, 205);
        var dialogValue = "";

        if (typeof (Para) != "undefined") {
            if ((typeof (Para) != "undefined" && Para[0] != "cancel") || Para[0] == "")
                dialogValue = strLang253 + Para[0].substring(0, 3) + "-" + Para[0].substring(4, 7) + " " + Para[1] + " " + Para[2] + " " + Para[3] + " ";
            else
                dialogValue = "";
        }
        else
            dialogValue = "";

        var AddressName = "";
        if (dialogValue != "")
            AddressName = window.showModalDialog(windowName, dialogValue, parameter);

        var strAddress = "";
        if (AddressName != "" && AddressName != "cancel")
            strAddress = AddressUserName + " (" + dialogValue + AddressName + ")";
        else
            strAddress = AddressUserName + "(" + dialogValue + ")";

        if (CheckLen(strAddress, 100) == false) {
            var windowName = "/ezApprovalG/aprDeptAddressUserName.do";
            var parameter = "status:no;dialogWidth:335px;dialogHeight:185px;scroll:no;edge:sunken;help:no;";
            parameter = parameter + GetShowModalPosition(330, 205);
            var dialogValue = strAddress;
            strAddress = window.showModalDialog(windowName, dialogValue, parameter);

            if (strAddress == "cancel")
                return;
        }
        if (AddressName != "cancel" || strAddress != "cancel") {
            AprLineAddDeptAddress(strAddress);
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

    address_zip_select_dialogArguments[0] = "";
    address_zip_select_dialogArguments[1] = btnAddAddress_Complete2;

    DivPopUpShow(655, 420, "/ezAddress/addressZipCodePopUp.do");
    TempAddressUserName = AddressUserName;
}

var aprdeptaddressname_cross_dialogArguments = new Array();
var TempdialogValue = "";
function btnAddAddress_Complete2(Para) {
    DivPopUpHidden();
    var windowName = "/ezApprovalG/aprDeptAddressUserName.do";

    if (typeof (Para) != "undefined") {
        if ((typeof (Para) != "undefined" && Para[0] != "cancel") || Para[0] == "")
            TempdialogValue = strLang253 + Para[0].substring(0, 3) + "-" + Para[0].substring(4, 7) + " " + Para[1] + " " + Para[2] + " " + Para[3] + " ";
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
        var windowName = "/ezApprovalG/aprDeptAddressUserName.do";

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
    if(approvalYN == "G") {
    	Resultxml = loadXMLFile(strLangEtcFile1);
    } else {
    	Resultxml = loadXMLFile(strLangEtcFileliban1);
    }	

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
/******************************모두추가/모두제거/추가/제거 버튼 관련 function******************************/
var SelDivName = "";
function InsertRecAll() {
    try {

        if (CrossYN()) {
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

        //2015-07-06 표준모듈:추가(값이 없을 경우 알려주고 return 처리) - KSK
        if (treeNode.GetNodeData("CN") == "") {
            alert(strLang1138);
            return;
        }

        //2015-07-06 표준모듈:추가(값이 없을 경우 알려주고 return 처리) - KSK
        if (treeNode.GetNodeData("VALUE") == "") {
            alert(strLang1137);
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
            createNodeAndInsertText(XmlDoc, objNode, "PROP", "extensionAttribute2");

            XmlHttp.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
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
        if(approvalYN == "G") {
        	Resultxml = loadXMLFile(strLangEtcFile1);
        } else {
        	Resultxml = loadXMLFile(strLangEtcFileliban1);
        }	

        var treeNode = new TreeNode();
        treeNode.LoadFromID(nodeIdx);

        //2015-05-08 추가 - KSK
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
	var result = "";
    var XmlDoc = null;

    try {

        var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, outerdeptid);
        if (DuplicateFlag && ouReceiveDocumentYN == "Y") {
            AddOuter(outerdeptid, outerdeptnm);
        }
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezOrgan/getOrganSubTreeInfo.do",
    		data : {
    			deptID 	: outerdeptoupath
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});

        XmlDoc = null;
        XmlDoc = createXmlDom();
        XmlDoc = loadXMLString(result);

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
        XmlDoc = null;
    }
}
function AddOuter(strOuterDeptId, strOuterDeptName) {
    try {
        var isCurretnCompany = "Y";
        Resultxml.async = false;

        if(approvalYN == "G") {
        	Resultxml = loadXMLFile(strLangEtcFile1);
        } else {
        	Resultxml = loadXMLFile(strLangEtcFileliban1);
        }	
        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");

        DeptAddIndex = listview.GetRowCount();

        if (DeptAddIndex == "1") {
            var tr = listview.GetDataRows();
            if (tr[0].id.indexOf("noItems") > 0)
                DeptAddIndex = 0;
        }

        DeptAddIndex = DeptAddIndex + 1;

        // TreeView 선택 기관 코드 
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

            // 최상위 기관이 없을때 
            if (tempRtnNodes.childNodes.length <= 0) {
                if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                else
                    OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
            } else {
                // 최상위 기관이 있을때
                // FullName이 Null 인 경우 
                if (getNodeText(GetChildNodes(rtnNodes)[3]) == "") {
                    if (getNodeText(GetChildNodes(rtnNodes)[8]) == "")
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[2]) + strLang93;
                    else
                        OutDeptList = getNodeText(GetChildNodes(rtnNodes)[8]);
                } else {
                    // FullName이 Null이 아닌 경우
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

        /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
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
    var ReceiveDocument = "";

    try {
    	var result = "";
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/admin/ezOrgan/getEntryInfo.do",
    		data : {
    			cn 	  : _DEPTID,
    			prop  : "extensionAttribute11"
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});
    	
        ReceiveDocument = SelectSingleNodeValueNew(loadXMLString(result), "DATA/EXTENSIONATTRIBUTE11");
    } catch (e) {
    } 
    
    return ReceiveDocument;
}