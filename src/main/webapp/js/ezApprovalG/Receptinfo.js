//#############################################################################################################################################수신처 초기화
function Receptinfo_ini() {
    if (!Recinfoini) {
        Recinfoini = true;
        Tree_setconfig();
        TreeViewinitialize_tree2(arr_userinfo[4], companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "<%=_pServerName%>");
        
        if (approvalFlag == "G") {
			// 정주환 - 문서24 관련 분기 추가
        	if (useDoc24 == "YES") {
        		ChangeReceptTab(document.getElementById("3tab5"));
        		document.getElementById("3tab5").onclick();
        	}
        	if (receptGubunYN == "Y") {
                if (pDocType == "001" && isOuterForm) { //시행문
        			ChangeReceptTab(document.getElementById("3tab4"));
        			initReceptListView();
        			document.getElementById("3tab4").onclick();
        		} else { //수신문
        			ChangeReceptTab(document.getElementById("3tab1"));
        			initReceptListView();
        			document.getElementById("3tab1").onclick();
        		}
        	} else {
        		ChangeReceptTab(document.getElementById("3tab1"));
        		initReceptListView();
        		document.getElementById("3tab1").onclick();
        	}
        } else {
        	RdisplayUserList(arr_userinfo[4]);
        	
        	ChangeReceptTab(document.getElementById("3tab1"));
        	initReceptListView();
        	document.getElementById("3tab1").onclick();
        }

        treeViewScrollTo("tvTreeView2");   //2020-04-24 : 선택된 노드로 트리뷰 커서 이동
    }
}
//#############################################################################################################################################수신처 내부 버튼 클릭 이벤트
function ChangeReceptTab(obj) {
    if (obj.getAttribute("divname") == "Organ") {
        document.getElementById("ReceptOrgan").style.display = "";
        document.getElementById("ReceptTemp").style.display = "none";
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("ReceptOuter").style.display = "none";
        document.getElementById("ReceptDoc24").style.display = "none";
        // document.getElementById("btnaddressChange").style.display = "none";
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
        document.getElementById("ReceptDoc24").style.display = "none";
        // document.getElementById("btnaddressChange").style.display = "none";
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
        document.getElementById("ReceptDoc24").style.display = "none";
        // document.getElementById("btnaddressChange").style.display = "none";
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
        document.getElementById("ReceptDoc24").style.display = "none";
        // document.getElementById("btnaddressChange").style.display = "";
        
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "none";
        document.getElementById("AprDeptOuterAdd").style.display = "";
        internalTab = false;
        //2015-06-23 표준모듈:추가 - KSK
        SelDivName = "Outer";
        document.getElementById("imgInsertAll").style.display = "";
        document.getElementById("imgDeleteAll").style.display = "";
        document.getElementById("AddRemoveBTN").style.display = "";
    }
    else if (obj.getAttribute("divname") == "Doc24") {
        document.getElementById("ReceptOrgan").style.display = "none";
        document.getElementById("ReceptTemp").style.display = "none";
        document.getElementById("ReceptOuter").style.display = "none";
        document.getElementById("ReceptDoc24").style.display = "";
        document.getElementById("ReceptGroup").style.display = "none";
        document.getElementById("AprDeptAdd").style.display = "none";
        document.getElementById("AprDeptOuterAdd").style.display = "none";
        internalTab = false;
        //2015-06-23 표준모듈:추가 - KSK
        SelDivName = "Doc24";
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
    //2018-06-21 재사용시 수신처정보 완료문서정보가 아닌 고정수신처 정보로 초기화
    /*if (isUsed == "reuse") {
    	docIDorSN = beforeDocID;
    }*/
    
    /* 2021-04-19 홍승비 - 수신부서에서 회송된 문서의 경우, 원문서(완료문서)의 수신처 정보를 가져오도록 수정 */
    if (typeof(isSusinReset) != "undefined" && isSusinReset == true) {
    	docIDorSN = getOrgDocID();
    	pMode = "END2";
    }
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/aprDeptRequest.do",
		data : {
			docID : docIDorSN,
			mode  : pMode,
			//2018-06-21 재사용시 수신처정보 완료문서정보가 아닌 고정수신처 정보로 초기화
//			isUsed : isUsed
			orgCompanyID : companyID
		},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});

    //시행문
    if (pDocType != null && pDocType != undefined && pDocType == "001") {
	    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
	    if (SelectNodes(result, "LISTVIEWDATA/ROWS/ROW").length > 8) {
	        document.getElementById("inputSummaryOuterReceiverList").focus();
	        document.getElementById("trSummaryOuterReceiverList").style.display = "";
	        document.getElementById("btnaddress").style.display = "none";
	        // document.getElementById("btnaddressChange").style.display = "none";
	    }
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
        treeView.SetUseSusinColor4AprG(true);
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
var useupperdeptbox;
function TreeViewNodeClick2(pNodeID, pNodeNM) {
    nodeIdx = pNodeID;
    useupperdeptbox = document.getElementById(pNodeID).getAttribute("useupperdeptbox");

    var treeNode = new TreeNode();
    treeNode.LoadFromID(nodeIdx);
	RdisplayUserList(treeNode.GetNodeData("CN"));
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
    treeView.SetUseSusinColor4AprG(true); // 하위트리 오픈 시, 색 적용 안되는 문제 수정
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
				cell 	 : "displayName;description;title;telephoneNumber;extensionattribute5",
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
//function AprDeptDel_onclick() {
//    var listview = new ListView();
//    listview.LoadFromID("lvRECEPTLIST");
//    var CurSelRow = listview.GetSelectedRows();
//
//    var DeleteState;
//
//    if (CurSelRow.length == 0) return;
//
//    if (CurSelRow.length != 0) {
//        for (var i = 0; i < CurSelRow.length; i++) {
//            DeleteState = DeptRowDelelte(listview.GetSelectedIndexes().split(',')[0], listview.GetDataRows());
//            if (DeleteState == "Y") {
//                listview.DeleteRow(CurSelRow[i].getAttribute("id"));
//            }
//        }
//        var AprDeptInfo = loadXMLString(APRDeptResortList());
//
//        document.getElementById('RECEPTLIST').innerHTML = "";
//        var listview = new ListView();
//        listview.SetID("lvRECEPTLIST");
//        listview.SetMulSelectable(false);
//        listview.SetHeightFree(true);
//        listview.SetRowOnDblClick("AprDeptDel_onclick");
//        listview.DataSource(AprDeptInfo);
//        listview.DataBind("RECEPTLIST");
//        listview.SetSelectFlag(false);
//    }
//}
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
                if (DuplicateFlag) {
                    AprLineAddDept(nodeIdx, "");
                } else {
                    var pAlertContent = linealt13;
                    OpenAlertUI(pAlertContent);
                }
            }
        }
        else { // USER
            var listview = new ListView();
            listview.LoadFromID("lvUserList2");
            var pCurSelRow = listview.GetSelectedRows();
            
            if (pCurSelRow.length != 0) {
                if (isExistDept(true)) {
                    var pAlertContent = strLang244 + "</br>" + strLang245;
                    OpenAlertUI(pAlertContent);
                    return;
                }
            	/* 2023-03-09 홍승비 - 전자결재G > 결재문서를 수신하지 않는 부서의 소속 사원은 수신자로 지정 불가능하도록 수정 */
            	var userDeptID = pCurSelRow[0].getAttribute("DATA3");
                /* 2024-07-17 양지혜 - 전자결재G > 상위부서문서함 사용 부서의 사원은 수신자로 지정 가능하도록 함 */
            	if (GetEntryInfo(userDeptID) == "N" && useupperdeptbox === "N") { // 결재문서를 수신하지 않는 부서 체크
            		OpenAlertUI(strLang1105);
            	}
            	else { // 수신자 중복부서 체크
	                var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, userDeptID);
	                
	                if (DuplicateFlag) {
	                    AprLineAddDept_User(pCurSelRow[0]);
	                } else {
	                    var pAlertContent = linealt13;
	                    OpenAlertUI(pAlertContent);
	                }
            	}
            }
        }
    }
    catch (e) {
        alert("AprDeptAdd_onclick : " + e.description);
        console.log(e);
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
//    if(approvalFlag == "G") {
//    	Resultxml = loadXMLFile(strLangEtcFile1);
//    } else {
    	Resultxml = loadXMLFile(strLangEtcFileliban1);
//    }	
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
//    setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
    //2018-08-20 이효진
    if (useReceiveInfoName == '1') {
    	//현재부서명 + 장
    	setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm + strLang93);
    } else if (useReceiveInfoName == '2') {
        // 상위부서명(현재부서명 + 장)
        var reName;
        if (treeNode.NodeLevel === "0" || deptid === strCmpID) { // 회사
            reName = pDeptNm + strLang93
        } else { // 부서
            reName = getParentDeptNameForDB(deptid) + "(" + pDeptNm + strLang93 + ")";
        }
        setNodeText(GetChildNodes(objNodes[1])[0], reName);
    } else {
    	//default
    	setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
    }
    
    
    //setNodeText(GetChildNodes(objNodes[2])[0], "-");


    var tr = listview.GetSelectedRows();
    var InitTr = listview.GetDataRows();
    var MaxID = 0;
    
    if (InitTr.length > 0 && InitTr[0].id.indexOf("noItems") == -1) {
	    for (var j = 0; j < InitTr.length; j++) {
	        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	        if (MaxID < curnum)
	            MaxID = curnum;
	    }
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
    
    // if (useReceiveInfoName == '0') {
    //     document.getElementById("btnaddressChange").style.display = "none";
    // }
    
    //DeptAddIndex = DeptAddIndex + 1;
}
//#############################################################################################################################################수신처 사용자 수신 추가
function AprLineAddDept_User(pSelectedRow) {

    var isCurretnCompany = "N";
    var Resultxml ="";
    Resultxml.async = false;
//    if(approvalFlag == "G") {
//    	Resultxml = loadXMLFile(strLangEtcFile1);
//    } else {
    	Resultxml = loadXMLFile(strLangEtcFileliban1);
//    }	

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
    var pDeptID = pSelectedRow.getAttribute("DATA3");

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");

    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[1], pDeptID);
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
    
    // 개인 수신자 수신처명 옵션화하지 않으려면 여기를 주석처리
    if (useReceiveInfoName == '1') {
        //현재부서명 + 장
        setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm + strLang93);
    } else if (useReceiveInfoName == '2') {
        // 상위부서명(현재부서명 + 장)
        var reName = "";
        var upperDeptNm = getParentDeptNameForDB(pSelectedRow.getAttribute("DATA3"));
        if (!upperDeptNm || pDeptID === strCmpID) { // 회사
            reName = pDeptNm + strLang93
        } else { // 부서
            reName = upperDeptNm + "(" + pDeptNm + strLang93 + ")";
        }
        setNodeText(GetChildNodes(objNodes[1])[0], reName);
        
    } else {
        //default
        setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
    }

    var tmptr = listview.GetSelectedRows();
    var InitTr = listview.GetDataRows();

    var MaxID = 0;
    if (InitTr.length > 0 && InitTr[0].id.indexOf("noItems") == -1) {
	    for (var j = 0; j < InitTr.length; j++) {
	        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	        if (MaxID < curnum)
	            MaxID = curnum;
	    }
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
//            2018-07-09 이효진 지정된 수신처 삭제시 id값 매칭
//            SetAttribute(objTr, "id", "lvtAPRDEPT" + "_TR_" + eval(MaxID + 1));
            SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml);

        }
    }
    else {
        var objTr = listview.AddRow(0);
//        2018-07-09 이효진 지정된 수신처 삭제시 id값 매칭
//        SetAttribute(objTr, "id", "lvtAPRDEPT" + "_TR_" + eval(MaxID + 1));
        SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
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

    if (AprDeptRow.length == 0 || AprDeptRow[0].id == "lvRECEPTLIST_TR_noItems") {
    	return "NODATA";
    }
    
    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang170 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang171 + "</NAME><WIDTH>600</WIDTH></HEADER></HEADERS>";
    GetXml += "<ROWS>";

    for (i = 0; i < CurListLen; i++) {
        GetXml += "<ROW>";
        for (j = 0; j < CurCellLen; j++)
            GetXml += "<COLUMN>" + MakeXMLString(getNodeText(AprDeptRow[i].cells[j])) + "</COLUMN>";

        if (trim_Cross(GetAttribute(AprDeptRow[i], "DATA2")) == "" || trim_Cross(GetAttribute(AprDeptRow[i], "DATA2")) == "null" || isUsed == "reuse") { // 재사용일 경우 추가
            GetXml += "<DATA name='DocID'>" + pDocID + "</DATA>";
        } else if (pDocID && pReDraftFlag == 'REDRAFT'){
        	GetXml += "<DATA name='DocID'>" + pDocID + "</DATA>";
        } else {
            GetXml += "<DATA name='DocID'>" + GetAttribute(AprDeptRow[i], "DATA2") + "</DATA>";
        }
        
        GetXml += "<DATA name='ReceiptPointID'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA1")) + "</DATA>";
        GetXml += "<DATA name='ExtReceptYN'>" + GetAttribute(AprDeptRow[i], "DATA3") + "</DATA >";
        GetXml += "<DATA name='ProcessYN'>" + GetAttribute(AprDeptRow[i], "DATA4") + "</DATA>";
        GetXml += "<DATA name='CanEditYN'>" + GetAttribute(AprDeptRow[i], "DATA5") + "</DATA>";
        GetXml += "<DATA name='ExtReceptEmail'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA6")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberID'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA7")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberName'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA8")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberJobTitle'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA9")) + "</DATA>";
        GetXml += "<DATA name='AprMemberDeptName'>" + MakeXMLString(AprDeptRow[i].childNodes[1].textContent) + "</DATA>";
        GetXml += "<DATA name='AprMemberDeptName2'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA11")) + "</DATA>";
        GetXml += "<DATA name='ReceiptMemberName2'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA12")) + "</DATA>";

       /* if (GetAttribute(AprDeptRow[i], "DATA12") != null)
            GetXml += "<DATA name='ReceiptMemberName2'></DATA>";
        else
            GetXml += "<DATA name='ReceiptMemberName2'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA12")) + "</DATA>";*/

        if (AprDeptRow[i].getAttribute("DATA13") == null)
            GetXml += "<DATA name='ReceiptMemberJobTitle2'></DATA>";
        else
            GetXml += "<DATA name='ReceiptMemberJobTitle2'>" + MakeXMLString(GetAttribute(AprDeptRow[i], "DATA13")) + "</DATA>";

        GetXml += "</ROW>";
    }
    
    GetXml += "</ROWS>";
    
    GetXml += "</LISTVIEWDATA>";
    
    return GetXml;
}
//############################################################################################################################################# 조직도 사용자 검색
function textUser_onkeypress2() {
    if (window.event.keyCode == "13") {
        document.getElementById("Span2").focus();
        //document.getElementById("btn_searchUser").onclick();
        btn_searchUser_onclick2();
    }
}
//############################################################################################################################################# 조직도 사용자 검색 
function btn_searchUser_onclick2() {
	if (approvalFlag == 'G') {
		searchUserList2();
	} else {
		searchUserList3();
	}
}

//############################################################################################################################################# 조직도 사용자 검색
function searchUserList2(search) {
    try {
        var searchdoc = document.getElementById("textUser2");
        var strSearch = searchdoc.value + "";
        if (searchdoc.value == "") {
            var pAlertContent = linealt3;
            OpenAlertUI(pAlertContent);
            searchdoc.focus();
        }
        else if (strSearch.length < 2) {
            var pAlertContent = linealt4;
            OpenAlertUI(pAlertContent);
            searchdoc.focus();
        }
        else {
    		$.ajax({
    			type : "POST",
    			dataType : "text",
    			async : true,
    			url : "/ezOrgan/getSearchList.do",
    			data : {
    				search : "displayname::" + strSearch + ";;PhysicalDeliveryOfficeName::" + companyID,
    				cell   : "displayname;description;title;telephonenumber;extensionattribute5",
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

function searchUserList3(search) {

    var searchdoc = document.getElementById("textUser2");
    var strSearch = searchdoc.value + "";
    if (searchdoc.value == "") {
        var pAlertContent = linealt3;
        OpenAlertUI(pAlertContent);
        searchdoc.focus();
    }
    else if (strSearch.length < 2) {
        var pAlertContent = linealt4;
        OpenAlertUI(pAlertContent);
        searchdoc.focus();
    }
    else {
    	$.ajax({
			type : "POST",
			dataType : "text",
			async : true,
			url : "/ezOrgan/getSearchList.do",
			data : {
				search : "displayname::" + strSearch + ";;PhysicalDeliveryOfficeName::" + companyID,
				cell   : "displayname;description;title;telephonenumber;extensionattribute5",
				prop   : "department;displayName;description;title;physicalDeliveryOfficeName",
				type   : "user"
			},
			success: function(xml){
				event_displayUserList2(loadXMLString(xml));
			}
		});
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
            searchorganglist_dialogArguments[1] = btnSearchDept_onClick_Complete_New;

            DivPopUpShow(600, 600, "/ezApprovalG/searchOrganGList.do?keyword=" + encodeURIComponent(tmpDeptName));
        }
        else {
            var feature = "status:no;dialogWidth:600px;dialogHeight:600px;scroll:no;edge:sunken;help:no;";
            feature = feature + GetShowModalPosition(600, 600);
            reParam = window.showModalDialog("/ezApprovalG/searchOrganGList.do?keyword=" + encodeURIComponent(tmpDeptName), g_progresswin, feature);
            document.getElementById("txtOuterDeptName").focus();
            
            btnSearchDept_onClick_Complete_New(reParam);
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
            if(approvalFlag == "G") {
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
                // document.getElementById("btnaddressChange").style.display = "none";
            } else {
                document.getElementById("trSummaryOuterReceiverList").style.display = "none";
                document.getElementById("inputSummaryOuterReceiverList").value = "";
                document.getElementById("btnaddress").style.display = "";
                // document.getElementById("btnaddressChange").style.display = "";
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
              //  Resultxml.async = false;
                if(approvalFlag == "G") {
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
                    // document.getElementById("btnaddressChange").style.display = "none";
                } else {
                    document.getElementById("trSummaryOuterReceiverList").style.display = "none";
                    document.getElementById("inputSummaryOuterReceiverList").value = "";
                    document.getElementById("btnaddress").style.display = "";
                    // document.getElementById("btnaddressChange").style.display = "";
                }

            } else {
                var pAlertContent = strLang247 + "<br>  " + strLang248;
                OpenAlertUI(pAlertContent);
            }
        }
    }
}

function btnSearchDept_onClick_Complete_New(reParam) {
	DivPopUpHidden();

	if (typeof(reParam) == "undefined" || reParam["ret"] == "NO" || reParam["ret"] == "") {
		return;
	}
	
	if (isExistDept(false)) {
		var pAlertContent = strLang244;
		OpenAlertUI(pAlertContent);
		return;
	}
	
    if (reParam["ret"] == "OK") {
    	var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, reParam["ouCode"]);
    	if (DuplicateFlag) {
    		AprLineAddDeptG_New(reParam["ouCode"]);
    	} else {
    		var pAlertContent = strLang247 + "<br>" + strLang248;
    		OpenAlertUI(pAlertContent);
    		return;
    	}
    } else if (reParam["ret"] == "MULTISELECT") {
    	for (var i = 0; i < reParam["ouCode"].length; i++) {
    		var DuplicateFlag = DuplicateAprDeptCheck(RECEPTLIST, reParam["ouCode"][i]);
    		if (DuplicateFlag) {
    			AprLineAddDeptG_New(reParam["ouCode"][i]);
    		}
    	}
    } else if (reParam["ret"] == "SEARCH") {  //2020-04-23 : 외부 수신처 검색 후 조직도 이동
        var rtnXml = reParam["search"];

        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");

        var xmlRtn = createXmlDom();
        xmlRtn = loadXMLString(rtnXml);   
        
        var nodes = xmlRtn.getElementsByTagName("ROW");

        var nodeLevel = 1;

        for(var i = nodes.length -1 ; i >= 0 ; i--){

            $("#tvTreeView3").find("div[nodelevel=" + nodeLevel + "]").each(function(){
                if($(this).attr("data1") == $(nodes.item(i)).find("SELCODE").eq(0).text()){

                    var nodeID = "imgNode_" + $(this).attr("id");
                    var nodeSpnDiv = "spn_" + $(this).attr("id");
    
                    if($("#" + nodeID).attr("src").indexOf("plus") > -1){
                        $("#" + nodeID).click();
                    }
    
                    if(i == 0){
                        $("#" + nodeSpnDiv).click();
                    }  
                    
                    return false;
                }
            });
            nodeLevel++;
        }
        treeViewScrollTo("tvTreeView3");   //선택된 노드로 트리뷰 커서 이동
   }
}

function event_getDeptFullTree() {
    if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
        if (g_xmlHTTP.status == 200) {
            var xmlDom = createXmlDom();
            xmlDom.async = false;
            xmlDom = loadXMLFile("/xml/organtree_config.xml");

            document.getElementById('TreeView2').innerHTML = "";
            var treeView = new TreeView();
            treeView.SetID("tvTreeView2");
            treeView.SetUseAgency(true);
            treeView.SetRequestData("RequestData2");
            treeView.SetUseSusinColor4AprG(true);
            treeView.SetNodeClick("TreeViewNodeClick2");
            treeView.SetNodeDblClick("TreeViewNodeDbClick");
            treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
            treeView.DataBind("TreeView2");

            treeViewScrollTo("tvTreeView2");   //2020-04-24 : 선택된 노드로 트리뷰 커서 이동
        }
        else {
            alert(strLang249 + g_xmlHTTP.status);
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
        treeView.SetUseSusinColor4AprG(true);
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
        xmlhttp2.open("POST", "/ezOrgan/getOrganSubTreeInfo.do", false);
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
        AprLineAddDeptG_New(selectnode.GetNodeData("DATA1"));
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

function AprLineAddDeptG_New(outDeptID) {
	var listView = new ListView();
	listView.LoadFromID("lvRECEPTLIST");
	
	var oXmlDom = getExtLdapInfo_New(outDeptID);
	if (oXmlDom != "") {
		var ldapDeptInfo = "";
		var oSelNode = GetChildNodes(SelectNodes(oXmlDom, "ORGAN")[0]);
		if (oSelNode.length > 0) {
			if ((getNodeText(oSelNode[0]) == getNodeText(oSelNode[4])) || getNodeText(oSelNode[10]) == "Y") {
				if (getNodeText(oSelNode[8]) == "") {
					ldapDeptInfo = getNodeText(oSelNode[2]) + strLang93;
				} else {
					ldapDeptInfo = getNodeText(oSelNode[8]);
				}
			} else {
				var pSelNode; 
				var tempCode = getNodeText(oSelNode[5]);
				for (var i = 0; i < getNodeText(oSelNode[6]); i++) {
					pSelNode = GetChildNodes(SelectNodes(getExtLdapInfo_New(tempCode), "ORGAN")[0]);
					
					if (pSelNode.length > 0) {
						if (getNodeText(pSelNode[10]) == "Y") {
							break;
						} else {
							tempCode = getNodeText(pSelNode[5]);
						}
					}
				}
				//상위 기관명
				if (getNodeText(pSelNode[8]) == "") {
					ldapDeptInfo = getNodeText(pSelNode[2]) + strLang93;
				} else {
					ldapDeptInfo = getNodeText(pSelNode[8]);
				}
				//문서를 수신받는 부서명 
				if (getNodeText(oSelNode[8]) == "") {
					ldapDeptInfo = ldapDeptInfo + " (" + getNodeText(oSelNode[2]) + strLang93 + ")";
				} else {
					ldapDeptInfo = ldapDeptInfo + " (" + getNodeText(oSelNode[8]) + ")";
				}
			}
		}
		
		var lvIdx = listView.GetRowCount();
		if (lvIdx > 0) {
			if (listView.GetDataRows()[0].id.indexOf("noItems") > 0) {
				lvIdx = 0;
			}
		}
		lvIdx++;
		
		var ResultXml = createXmlDom();
		var Root, Headers, Header, HData;
		var Rows, Row, Cell, Value;
		
		Root = createNodeInsert(ResultXml, Root, "LISTVIEWDATA");
		//HEADER만들기
		Headers = createNodeAndAppandNode(ResultXml, Root, Headers, "HEADERS");
		
		Header = createNodeAndAppandNode(ResultXml, Headers, Header, "HEADER");
		createNodeAndAppandNodeText(ResultXml, Header, HData, "NAME", "순번");
		createNodeAndAppandNodeText(ResultXml, Header, HData, "WIDTH", "35");
		
		Header = createNodeAndAppandNode(ResultXml, Headers, Header, "HEADER");
		createNodeAndAppandNodeText(ResultXml, Header, HData, "NAME", "수신부서명");
		createNodeAndAppandNodeText(ResultXml, Header, HData, "WIDTH", "200");
		
		Header = createNodeAndAppandNode(ResultXml, Headers, Header, "HEADER");
		createNodeAndAppandNodeText(ResultXml, Header, HData, "NAME", "수신자성명");
		createNodeAndAppandNodeText(ResultXml, Header, HData, "WIDTH", "200");
		
		//ROW만들기
		Rows = createNodeAndAppandNode(ResultXml, Root, Rows, "ROWS");
		Row = createNodeAndAppandNode(ResultXml, Rows, Row, "ROW");
		
		Cell = createNodeAndAppandNode(ResultXml, Row, Cell, "CELL");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "VALUE", lvIdx);
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA1", getNodeText(oSelNode[0]));
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA2", pDocID);
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA3", "Y");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA4", "N");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA5", "N");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA6", "");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA7", "");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA8", "");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA9", "");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA10", ldapDeptInfo);
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA11", ldapDeptInfo);
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA12", "");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA13", "");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA14", ldapDeptInfo);
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA15", ldapDeptInfo);
		
		Cell = createNodeAndAppandNode(ResultXml, Row, Cell, "CELL");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "VALUE", ldapDeptInfo);
		
		Cell = createNodeAndAppandNode(ResultXml, Row, Cell, "CELL");
		createNodeAndAppandNodeText(ResultXml, Cell, Value, "VALUE", "");

		var InitTr = listView.GetDataRows();
		var MaxID = 0;
		var CurID = 0;
		for (var j = 0; j < InitTr.length; j++) {
			CurID = Number(listView.GetSelectedRowID(j).substring(listView.GetSelectedRowID(j).lastIndexOf('_') + 1), listView.GetSelectedRowID(j).length);
			if (MaxID < CurID)
				MaxID = CurID;
		}
		
		if (InitTr.length > 0) {
			if (InitTr[0].id.indexOf("noItems") <= 0) {
				var oTr = listView.AddRow(0);
				SetAttribute(oTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
				listView.AddDataRow(oTr, SelectNodes(ResultXml, "LISTVIEWDATA/ROWS/ROW")[0]);
			} else {
				document.getElementById("RECEPTLIST").innerHTML = "";
	            var listView = new ListView();
	            listView.SetID("lvRECEPTLIST");
	            listView.SetMulSelectable(false);
	            listView.SetHeightFree(true);
	            listView.SetRowOnDblClick("AprDeptDel_onclick");
	            listView.DataSource(ResultXml);
	            listView.DataBind("RECEPTLIST");
	            listView.SetSelectFlag(false);
			}
		} else {
			document.getElementById("RECEPTLIST").innerHTML = "";
            var listView = new ListView();
            listView.SetID("lvRECEPTLIST");
            listView.SetMulSelectable(false);
            listView.SetHeightFree(true);
            listView.SetRowOnDblClick("AprDeptDel_onclick");
            listView.DataSource(ResultXml);
            listView.DataBind("RECEPTLIST");
            listView.SetSelectFlag(false);
		}
		
		/* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */ //이건 복붙
		if (listView.GetDataRows().length > 9) {
			document.getElementById("inputSummaryOuterReceiverList").focus();
			document.getElementById("trSummaryOuterReceiverList").style.display = "";
			document.getElementById("btnaddress").style.display = "none";
			// document.getElementById("btnaddressChange").style.display = "none";
		} else {
			document.getElementById("trSummaryOuterReceiverList").style.display = "none";
			document.getElementById("inputSummaryOuterReceiverList").value = "";
			document.getElementById("btnaddress").style.display = "";
			// document.getElementById("btnaddressChange").style.display = "";
		}
	}
}

function AprLineAddDeptG(nodeIdx, tr) {
    var isCurretnCompany = "Y";

    if(approvalFlag == "G") {
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

    InitTr = listview.GetDataRows();
    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
    if (InitTr.length > 8) {
        document.getElementById("inputSummaryOuterReceiverList").focus();
        document.getElementById("trSummaryOuterReceiverList").style.display = "";
        document.getElementById("btnaddress").style.display = "none";
        // document.getElementById("btnaddressChange").style.display = "none";
    } else {
        document.getElementById("trSummaryOuterReceiverList").style.display = "none";
        document.getElementById("inputSummaryOuterReceiverList").value = "";
        document.getElementById("btnaddress").style.display = "";
        // document.getElementById("btnaddressChange").style.display = "";
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

        if (GetAttribute(CurSelRow[0], "DATA1") == "Address1") {
            rtnVal = true;
        }
    }
    return rtnVal;
}
function getExtLdapInfo(OrganCode) {
    try {
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezOrgan/getOrgInfo.do",
    		data : {
    			orgID 	: OrganCode
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});
        return loadXMLString(result).documentElement;
    } catch (e) {
        return "";
    }
}

function getExtLdapInfo_New(OrganCode) {
	var result = "";
	if (typeof(OrganCode) == "undefined" || OrganCode == "") {
		return result;
	}
	
	try {
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezOrgan/getOrgInfo.do",
			data : {
				orgID 	: OrganCode
			},
			success: function(text) {
				result = text;
			}
		});
		return loadXMLString(result);
	} catch (e) {
		return result;
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
    
    // 2019-04-04 천성준 - 수신처 리스트 row제거 시, row가 0개일때 "데이터가 없습니다" 표출
    if (listview.GetDataRows().length <= 0) {
    	var objTr = document.createElement("TR");
		objTr.setAttribute("id", "lvRECEPTLIST_TR_noItems");
    		
		var oText = document.createTextNode(strLang944);
		var objTd = document.createElement("TD");
		objTd.align = "center";
		
		var colCount = document.getElementById("lvRECEPTLIST").getElementsByTagName("th").length;
		objTd.setAttribute("colSpan", colCount);
		objTd.appendChild(oText);
		objTr.appendChild(objTd);
		
		document.getElementById("lvRECEPTLIST").getElementsByTagName("tbody")[0].appendChild(objTr);
    }

    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
    if (listview.GetDataRows().length < 10) {
        document.getElementById("trSummaryOuterReceiverList").style.display = "none";
        document.getElementById("inputSummaryOuterReceiverList").value = "";
        document.getElementById("btnaddress").style.display = "";
    }
    
    /* 2023-01-12 홍승비 - 결재정보 > 수신처 ROW 제거 시, 수기입력된 수신처ID를 전체적으로 갱신 ("Address" + 숫자 형태의 ID를 가지는 경우에만) */
    refreshAllDeptAddressRowID();
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
    //2017-03-16 이효민 : 안타는 코드 주석 
    //2018-03-12 이효진 : 타는코드라 주석 살림 (IE일떄 CrossYN 안타게)
    //2018-07-19 강민수92 : CrossYN 분기 태우지 않고 한 코드로 동작
//    if (CrossYN()) {
//	if (CrossYN() && !(/netscape/i.test(navigator.appName) && /trident/i.test(navigator.userAgent) || /msie/i.test(navigator.userAgent))) {
        aprdeptaddressusername_cross_dialogArguments[0] = "";
        aprdeptaddressusername_cross_dialogArguments[1] = btnAddAddress_Complete;

        DivPopUpShow(360, 220, windowName);
//    } else {
//        var parameter = "status:no;dialogWidth:335px;dialogHeight:195px;scroll:no;edge:sunken;help:no;";
//        parameter = parameter + GetShowModalPosition(330, 205);
//        var dialogValue = "";
//        var AddressUserName = window.showModalDialog(windowName, dialogValue, parameter);
//        
//        if (AddressUserName == "cancel" || AddressUserName == "") {
//            return;
//        }
//        
//        var Para = window.showModalDialog("/ezAddress/addressZipCodePopUp.do", "", "dialogWidth:655px;dialogHeight:420px;toolbar:no;location:no;directories:no;status:no;menubar:no;scroll:no;edge:sunken;help:no" + GetShowModalPosition(330, 205));
//        var windowName = "/ezApprovalG/aprDeptAddressName.do";
//        var parameter = "status:no;dialogWidth:335px;dialogHeight:195px;scroll:no;edge:sunken;help:no;";
//        parameter = parameter + GetShowModalPosition(330, 205);
//        var dialogValue = "";
//
//        if (typeof (Para) != "undefined") {
//            if ((typeof (Para) != "undefined" && Para[0] != "cancel") || Para[0] == "") {
//                dialogValue = strLang253 + Para[0] + " " + Para[1] + " ";
//            } else {
//                dialogValue = "";
//            }
//        } else {
//            dialogValue = "";
//        }
//
//        var AddressName = "";
//        if (dialogValue != "") {
//            AddressName = window.showModalDialog(windowName, dialogValue, parameter);
//        }
//
//        var strAddress = "";
//        if (AddressName != "" && AddressName != "cancel") {
//            strAddress = AddressUserName + " (" + dialogValue + AddressName + ")";
//        } else {
//            strAddress = AddressUserName + "(" + dialogValue + ")";
//        }
//        
//        if (CheckLen(strAddress, 100) == false) {
//            var windowName = "/ezApprovalG/aprDeptAddressUserName.do";
//            var parameter = "status:no;dialogWidth:335px;dialogHeight:185px;scroll:no;edge:sunken;help:no;";
//            parameter = parameter + GetShowModalPosition(330, 205);
//            var dialogValue = strAddress;
//            strAddress = window.showModalDialog(windowName, dialogValue, parameter);
//
//            if (strAddress == "cancel") {
//                return;
//            }
//        }
//        
//        if (AddressName != "cancel" || strAddress != "cancel") {
//            AprLineAddDeptAddress(strAddress);
//        }
//    }
}

var TempAddressUserName;
var TempstrAddress = "";
var address_zip_select_dialogArguments = new Array();
function btnAddAddress_Complete(AddressUserName) {
    if (AddressUserName == "cancel" || AddressUserName == "") {
    	DivPopUpHidden();
        return;
    }
    
    var useZipCodeSearchInApr = null;
    
    // 우편번호검색 사용여부 체크 후 분기
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getUseZipCodeSearchInApr.do",
		success: function(text){
			useZipCodeSearchInApr = text;
		}        			
	});
    
    if (useZipCodeSearchInApr == "YES") {
    	if (useAddressOpenAPI == "YES") {
    		address_zip_select_dialogArguments[0] = "";
    		address_zip_select_dialogArguments[1] = jusoCallBack;
    		
    		var OpenWin = window.open("/ezAddress/addressZipCodePopUpOpen.do", "", GetOpenWindowfeature(570, 420));
    		try { OpenWin.focus(); } catch (e) { }
    		
    	} else {
    		DivPopUpHidden();
    		
    		address_zip_select_dialogArguments[0] = "";
    		address_zip_select_dialogArguments[1] = btnAddAddress_Complete2;
    		
    		DivPopUpShow(655, 620, "/ezAddress/addressZipCodePopUp.do");
    	}
    	
    	TempAddressUserName = AddressUserName;
    } else {
    	TempstrAddress = AddressUserName;
    	btnAddAddress_Complete4(AddressUserName);
    }
}

var aprdeptaddressname_cross_dialogArguments = new Array();
var TempdialogValue = "";

//Local 주소검색 사용경우
function btnAddAddress_Complete2(Para) {
    DivPopUpHidden();
    var windowName = "/ezApprovalG/aprDeptAddressName.do";

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

//Local 주소검색 사용경우 상세주소 입력후 실행되는 함수
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

//OpenAPI 주소검색 사용경우
//나머지주소를 입력하라는 창이 필요없음.
function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
    DivPopUpHidden();

    if (typeof (zipNo) != "undefined" && typeof (roadFullAddr) != "undefined" && zipNo != "") {
    	TempdialogValue = strLang253 + zipNo + " " + roadFullAddr;
    	
    	TempstrAddress = TempAddressUserName + "(" + TempdialogValue + ")";
    }
    
    btnAddAddress_Complete4(TempstrAddress);
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

// 결재정보 > 수신자 수기입력 완료 > 수신자 리스트에 ROW 삽입 함수
function AprLineAddDeptAddress(AddressName) {
	//2017-03-28 이효민
    //Resultxml.async = false;
    // if(approvalFlag == "G") {
    // 	Resultxml = loadXMLFile(strLangEtcFile1);
    // } else {
    	Resultxml = loadXMLFile(strLangEtcFileliban1);
    // }

    var listview = new ListView();
    listview.SetID("lvRECEPTLIST");
    listview.SetRowOnDblClick("AprDeptDel_onclick");
    
    var DeptAddIndex = listview.GetDataRows().length;
    if (DeptAddIndex == 0 || listview.GetDataRows()[0].id.indexOf("noItems") == -1) {
        DeptAddIndex = DeptAddIndex + 1;
    }
    
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
    
    // if (useReceiveInfoName == '0') {
	//     document.getElementById("btnaddressChange").style.display = "";
	// }
    
    /* 2023-01-12 홍승비 - 결재정보 > 수신자 수기입력 완료 후 ROW 추가 시, 수기입력된 수신처ID를 전체적으로 갱신 ("Address" + 숫자 형태의 ID를 가지는 경우에만) */
    refreshAllDeptAddressRowID();
    
    return true;
}
/******************************모두추가/모두제거/추가/제거 버튼 관련 function******************************/
var SelDivName = "";
function InsertRecAll() {
    try {
    	var deptid = $("#"+nodeIdx).attr("cn");
    	if (GetEntryInfo(deptid) == "N") {
    		var pAlertContent = strLang1105;
    		OpenAlertUI(pAlertContent);
    		return;
    	}
    	if (isReceiverChk(deptid)) {
            
	        if (CrossYN()) {
	            var pAlertContent = T1361andT1362;
	            var Ans = OpenInformationUI(pAlertContent, InsertRecAll_Complete);
	        } else {
	            var pAlertContent = T1361andT1362;
	            var Ans = OpenInformationUI(pAlertContent);
	            InsertRecAll_Complete(Ans);
	        }
    	} else {
    		var pAlertContent = strLang1101+strLang1102;
            var Ans = OpenInformationUI(pAlertContent, InsertRecAll_Complete);
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
        
        if (isExistDept(false)) {
            var pAlertContent = strLang244 + "<br>" + strLang245;
            OpenAlertUI(pAlertContent);
            return;
        }

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
        
        var objTr = document.createElement("TR");
		objTr.setAttribute("id", "lvRECEPTLIST_TR_noItems");
    		
		var oText = document.createTextNode(strLang944);
		var objTd = document.createElement("TD");
		objTd.align = "center";
		
		var colCount = document.getElementById("lvRECEPTLIST").getElementsByTagName("th").length;
		objTd.setAttribute("colSpan", colCount);
		objTd.appendChild(oText);
		objTr.appendChild(objTd);
		
		document.getElementById("lvRECEPTLIST").getElementsByTagName("tbody")[0].appendChild(objTr);
		
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
        if (SelDivName == "Doc24") {
            AprDeptDoc24Add_onclick();
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
//        if(approvalFlag == "G") {
//        	Resultxml = loadXMLFile(strLangEtcFile1);
//        } else {
        	Resultxml = loadXMLFile(strLangEtcFileliban1);
//        }	

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
        
        if (useReceiveInfoName == '1') {
            //현재부서명 + 장
            setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm + strLang93);
        } else if (useReceiveInfoName == '2') {
            // 상위부서명(현재부서명 + 장)
            var reName = "";
            var upperDeptNm = getParentDeptNameForDB(deptid);
            if (!upperDeptNm || deptid === strCmpID) { // 회사
                reName = pDeptNm + strLang93
            } else { // 부서
                reName = upperDeptNm + "(" + pDeptNm + strLang93 + ")";
            }
            setNodeText(GetChildNodes(objNodes[1])[0], reName);
            
        } else {
            //default
            setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
        }

        var tr = listview.GetSelectedRows();
        var InitTr = listview.GetDataRows();
        var MaxID = 0;
        
        if (InitTr.length > 0 && InitTr[0].id.indexOf("noItems") == -1) {
	        for (var j = 0; j < InitTr.length; j++) {
	            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	            if (MaxID < curnum)
	                MaxID = curnum;
	        }
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
        	AprLineAddDeptG_New(outerdeptid);
        }
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezOrgan/insertAllOrganSubTreeInfo.do",
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
        //Resultxml.async = false;

        if(approvalFlag == "G") {
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
            // document.getElementById("btnaddressChange").style.display = "none";
        } else {
            document.getElementById("trSummaryOuterReceiverList").style.display = "none";
            document.getElementById("inputSummaryOuterReceiverList").value = "";
            document.getElementById("btnaddress").style.display = "";
            // document.getElementById("btnaddressChange").style.display = "";
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
	
var xmlhttp3;
function getDoc24List(){
    xmlhttp3 = createXMLHttpRequest();
    xmlhttp3.open("GET", "/ezDoc24/getDoc24List.do", true);
    xmlhttp3.onreadystatechange = event_GetReceptDoc24TempletList;
    xmlhttp3.send();
}
function event_GetReceptDoc24TempletList() {
    if (xmlhttp3 == null || xmlhttp3.readyState != 4 || xmlhttp3.responseXML == null) return;
    try {

        if (xmlhttp3.responseText == "Error")
            return;

        document.getElementById('TreeView4').innerHTML = "";
        var treeView = new TreeView();
        treeView.SetID("tvTreeView4");
        treeView.SetUseAgency(true);
        treeView.SetUseSusinColor4AprG(true);
        treeView.SetRequestData("RequestDataG");
        treeView.SetNodeClick("TreeViewNodeClick4");
        treeView.DataSource(xmlhttp3.responseXML);
        treeView.DataBind("TreeView4");
        xmlhttp3 = null;
    }
    catch (ErrMsg) {
        alert("event_GetReceptOuterTempletList : " + ErrMsg.description);
    }
}
function btnSearchDoc24_onClick() {
	var word = document.getElementById("txtDoc24Name").value;
	$.each($("#tvTreeView4_0_sub").children(), function(index, item){
		if($(item).attr("nodename").indexOf(word) == -1){
			$(item).css("display","none");
		}else{
			$(item).css("display","");
		}
	});
}
function AprDeptDoc24Add_onclick() {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var CurSelRow = listview.GetSelectedRows();
    if (isExistDept(false)) {
        var pAlertContent = strLang244;
        OpenAlertUI(pAlertContent);
        return;
    }
    var treeView = new TreeView();
    treeView.LoadFromID("tvTreeView4");
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

    var DuplicateFlag = DuplicateAprDeptCheckG(RECEPTLIST, selectnode.GetNodeData("DATA1"));
    if (DuplicateFlag) {
        AprLineAddDoc24(selectnode);
    }
    else {
        var pAlertContent = strLang247;
        OpenAlertUI(pAlertContent);
    }
}
function AprLineAddDoc24(selNode) {
	var listView = new ListView();
	listView.LoadFromID("lvRECEPTLIST");
	
	var lvIdx = listView.GetRowCount();
	if (lvIdx > 0) {
		if (listView.GetDataRows()[0].id.indexOf("noItems") > 0) {
			lvIdx = 0;
		}
	}
	lvIdx++;
	
	var ResultXml = createXmlDom();
	var Root, Headers, Header, HData;
	var Rows, Row, Cell, Value;
	
	Root = createNodeInsert(ResultXml, Root, "LISTVIEWDATA");
	//HEADER만들기
	Headers = createNodeAndAppandNode(ResultXml, Root, Headers, "HEADERS");
	
	Header = createNodeAndAppandNode(ResultXml, Headers, Header, "HEADER");
	createNodeAndAppandNodeText(ResultXml, Header, HData, "NAME", "순번");
	createNodeAndAppandNodeText(ResultXml, Header, HData, "WIDTH", "35");
	
	Header = createNodeAndAppandNode(ResultXml, Headers, Header, "HEADER");
	createNodeAndAppandNodeText(ResultXml, Header, HData, "NAME", "수신자명");
	createNodeAndAppandNodeText(ResultXml, Header, HData, "WIDTH", "200");
	
	Header = createNodeAndAppandNode(ResultXml, Headers, Header, "HEADER");
	createNodeAndAppandNodeText(ResultXml, Header, HData, "NAME", "수신자성명");
	createNodeAndAppandNodeText(ResultXml, Header, HData, "WIDTH", "200");
	
	//ROW만들기
	Rows = createNodeAndAppandNode(ResultXml, Root, Rows, "ROWS");
	Row = createNodeAndAppandNode(ResultXml, Rows, Row, "ROW");
	
	Cell = createNodeAndAppandNode(ResultXml, Row, Cell, "CELL");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "VALUE", lvIdx);
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA1", selNode.GetNodeData("DATA1"));
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA2", pDocID);
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA3", "Y");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA4", "N");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA5", "N");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA6", "");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA7", "");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA8", "");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA9", "");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA10", selNode.GetNodeData("nodename"));
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA11", selNode.GetNodeData("nodename"));
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA12", "");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA13", "");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA14", selNode.GetNodeData("nodename"));
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "DATA15", selNode.GetNodeData("nodename"));
	
	Cell = createNodeAndAppandNode(ResultXml, Row, Cell, "CELL");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "VALUE", selNode.GetNodeData("nodename"));
	
	Cell = createNodeAndAppandNode(ResultXml, Row, Cell, "CELL");
	createNodeAndAppandNodeText(ResultXml, Cell, Value, "VALUE", "");

	var InitTr = listView.GetDataRows();
	var MaxID = 0;
	var CurID = 0;
	for (var j = 0; j < InitTr.length; j++) {
		CurID = Number(listView.GetSelectedRowID(j).substring(listView.GetSelectedRowID(j).lastIndexOf('_') + 1), listView.GetSelectedRowID(j).length);
		if (MaxID < CurID)
			MaxID = CurID;
	}
	
	if (InitTr.length > 0) {
		if (InitTr[0].id.indexOf("noItems") <= 0) {
			var oTr = listView.AddRow(0);
			SetAttribute(oTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
			listView.AddDataRow(oTr, SelectNodes(ResultXml, "LISTVIEWDATA/ROWS/ROW")[0]);
		} else {
			document.getElementById("RECEPTLIST").innerHTML = "";
            var listView = new ListView();
            listView.SetID("lvRECEPTLIST");
            listView.SetMulSelectable(false);
            listView.SetHeightFree(true);
            listView.SetRowOnDblClick("AprDeptDel_onclick");
            listView.DataSource(ResultXml);
            listView.DataBind("RECEPTLIST");
            listView.SetSelectFlag(false);
		}
	} else {
		document.getElementById("RECEPTLIST").innerHTML = "";
        var listView = new ListView();
        listView.SetID("lvRECEPTLIST");
        listView.SetMulSelectable(false);
        listView.SetHeightFree(true);
        listView.SetRowOnDblClick("AprDeptDel_onclick");
        listView.DataSource(ResultXml);
        listView.DataBind("RECEPTLIST");
        listView.SetSelectFlag(false);
	}
}
function doc24Detail_onclick() {
	console.log(selDoc24);
    if (selDoc24 == undefined) {
		var pAlertContent = strLang584;
		OpenAlertUI(pAlertContent);
		return;
    }
	var heigth = window.screen.availHeight; 
    var width = window.screen.availWidth; 
    var left = (width - 620) / 2; 
    var top = (heigth - 425) / 2;         
    var szHref = "/ezApprovalG/ezDoc24/getDoc24Detail.do?orgcn=" + selDoc24;   
	try{
	    DivPopUpShow(620, 380, szHref); 
	}catch(e){
		alert(e);
	}
//    window.open(szHref, "", "width=620, height=425, resizable=yes, scrollbars=yes, top="+top+", left=" + left); 
}
var selDoc24;
function TreeViewNodeClick4(){
	selDoc24 = $(event.target).parent().attr("DATA1");
}

/* 2021-04-19 홍승비 - 원문서의 DOCID를 가져오는 ajax 함수 추가 */
function getOrgDocID() {
	var orgDocID = "";
	
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getOrgDocIDByMode.do",
		data : {
				docID    : pDocID,
				mode : "APR",
				orgCompanyID : companyID
		},
		success: function(result){
			orgDocID = result;
		}
	});
	
	return orgDocID;
}

function makeReceptListview(dataJson) {
    /**
     * data0: idx
     * data1: deptId
     * data2: docId
     * data3: extReceptYn
     * data4: processYn
     * data5: canEditYn
     * data6: companyId
     * data7: receptMemberId
     * data8: receptMemberName
     * data9: receptMemberJobTitle
     * data10: receptDeptName
     * data11: receptDeptName2
     * data12: receptMemberJobTitle2
     * data13: receptMemberName2
     */

    var resultXml = "";
    //if(approvalFlag === "G") {
    //	resultXml = loadXMLFile(strLangEtcFile1);
    //} else {
    	resultXml = loadXMLFile(strLangEtcFileliban1);
    //}

    var cells = SelectNodes(resultXml, "LISTVIEWDATA/ROWS/ROW/CELL");

    setNodeText(SelectSingleNode(cells[0], "VALUE"), dataJson["data0"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA1"), dataJson["data1"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA2"), dataJson["data2"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA3"), dataJson["data3"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA4"), dataJson["data4"] || "N");
    setNodeText(SelectSingleNode(cells[0], "DATA5"), dataJson["data5"] || "N");
    setNodeText(SelectSingleNode(cells[0], "DATA6"), dataJson["data6"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA7"), dataJson["data7"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA8"), dataJson["data8"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA9"), dataJson["data9"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA10"), dataJson["data10"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA11"), dataJson["data11"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA12"), dataJson["data12"] || "");
    setNodeText(SelectSingleNode(cells[0], "DATA13"), dataJson["data13"] || "");

    setNodeText(SelectSingleNode(cells[1], "VALUE"), UserLang === "1" ? dataJson["data10"] || "" : dataJson["data11"] || "");
    
    if (approvalFlag !== "G") {
        setNodeText(SelectSingleNode(cells[2], "VALUE"), UserLang === "1" ? dataJson["data7"] || "" : dataJson["data13"] || "");
    }

    return resultXml;
}

function getReceptLastIdx(lv) {
    var idx = lv.GetDataRows().filter(function(elem) {
        return elem.id.indexOf("noItems") === -1;
    }).length + 1;

    return idx;
}

function checkDuplicationRecept(lv, addReceptId) {
    var result = true;
    var rows = lv.GetDataRows();

    for (var i = 0, ilen = rows.length; i < ilen; i++) {
        var row = rows[i];
        if (row.getAttribute("DATA1") === addReceptId) {
            result = false;
            break;
        }
    }

    return result;
}

/* 2023-01-12 홍승비 - 결재정보 > 수신자 수기입력 관련 > 수기입력된 수신처ID를 전체적으로 갱신하는 함수 ("Address" + 숫자 형태의 ID를 가지는 경우에만) */
// 수기입력이 아닌 부서 중에서 "Address" 로 시작하는 부서ID가 존재할 수 있으나, 조직도 상의 부서와 수기입력은 수신자 리스트에 함께 사용할 수 없으므로 사이드 이펙트는 없음
function refreshAllDeptAddressRowID() {
	var deptAddressRows = $("#lvRECEPTLIST").find("tr[data1^='Address']"); // 수기입력된 수신자 리스트 TR 추출
	var deptAddressRowLength = deptAddressRows.length;
	
	// 수기입력된 수신자 Row 중 최하단이 Address1, 최상단이 제일 큰 Address값을 가지도록 data1 세팅
	if (deptAddressRowLength > 0) {
		deptAddressRows.each(function(index, item) {
			item.setAttribute("data1", "Address" + (parseInt(deptAddressRowLength) - parseInt(index)));
		});
	}
}

function getParentDeptNameForDB(deptID) {
    var rtnVal = "";
    
    $.ajax({
		type : "GET",
		dataType : "json",
		async : false,
		url : "/ezOrgan/getUpperDeptName.do",
		data : {
			deptID : deptID
		},
		success: function(result) {
			rtnVal = result.upperDeptName;
		},
        error: function(xhr, status, error){
            console.log(error);
            alert(strLang199);
        },
	});
    
    return rtnVal;
}