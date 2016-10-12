
//############################################################################################################################################# 수신처 즐겨찾기 로딩
function InitReceptTemplet() {
    GetReceptTempletList();
}
//############################################################################################################################################# 수신처 즐겨찾기 리스트 구성
var xmlhttp;
function GetReceptTempletList() {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getReceptTemplist.do",
		data : {
				userID : pUserID,
				formID : pFormID
				},
		success: function(text){
			event_GetReceptTempletList(text);
		}        			
	});
}
function event_GetReceptTempletList(text)
{
    try
    {
        if (document.getElementById("RecSaveList").innerHTML != "") document.getElementById("RecSaveList").innerHTML = "";
        var liveView = new ListView();
        liveView.SetID("lvRecSaveList");
        liveView.SetRowOnClick("lvRecSaveList_onSel_Click");
        liveView.SetSelectFlag(true);
        liveView.SetHeightFree(true);
        liveView.DataSource(loadXMLString(text));      
        liveView.DataBind("RecSaveList");    

        var pCurSelRow = liveView.GetSelectedRows();
        if (pCurSelRow.length != 0) {
            GetReceptTempletInfo(pCurSelRow[0].getAttribute("DATA1"));
        }
        else{
            document.getElementById("RecSaveDetail").innerHTML = "";
        }
    }
    catch (ErrMsg) {
        alert(" GetReceptTempletList : " + ErrMsg.description);
    }
}
//############################################################################################################################################# 수신처 즐겨찾기 리스트 클릭 이벤트
function lvRecSaveList_onSel_Click() {
    var liveView = new ListView();    
    liveView.SetID("lvRecSaveList");
    var pCurSelRow = liveView.GetSelectedRows();
    if (pCurSelRow.length != 0) {
        GetReceptTempletInfo(pCurSelRow[0].getAttribute("DATA1"));
    }
}
//############################################################################################################################################# 수신처 즐겨찾기 리스트 세부 리스트 로드
var xmlHTTP;
function GetReceptTempletInfo(p_AprLineTempletID) {

	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getAprDeptTempletListInfo.do",
		data : {
				userID : pUserID,
				formID : pFormID,
				aprSN  : p_AprLineTempletID
				},
		success: function(text){
			event_GetReceptTempletInfo(text);
		}        			
	});
}
function event_GetReceptTempletInfo(text)
{
    try
    {
        if (document.getElementById("RecSaveDetail").innerHTML != "")
            document.getElementById("RecSaveDetail").innerHTML = "";
        var pAPRTEMP = new ListView();     
        pAPRTEMP.SetID("lvRecSaveDetail");
        pAPRTEMP.SetMulSelectable(false);   
        pAPRTEMP.SetHeightFree(true);
        pAPRTEMP.SetSelectFlag(false);
        pAPRTEMP.DataSource(loadXMLString(text));
        pAPRTEMP.DataBind("RecSaveDetail");
        xmlHTTP = null;
    }
    catch (ErrMsg) {
        alert(" GetReceptTempletInfo : " + ErrMsg.description);
    }
}
//############################################################################################################################################# 수신처 그룹 로딩
function liniReceptGroup() {
    GetReceptGroupList();
}
//############################################################################################################################################# 수신처 그룹 리스트 적용
function GetReceptGroupList() {
    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();

    xmlhttp.open("Post", "/ezApprovalG/getReceptGroupList.do", true);
    xmlhttp.send();
    xmlhttp.onreadystatechange = event_GetReceptGroupList;
}
function event_GetReceptGroupList()
{   
    if(xmlhttp == null || xmlhttp.readyState != 4) return;
    try
    {
        if (document.getElementById("RecGroupList").innerHTML != "") document.getElementById("RecGroupList").innerHTML = "";
        var liveView = new ListView();   
        liveView.SetID("lvRecGroupList");
        liveView.SetRowOnClick("lvRecGroupList_onSel_Click");   
        liveView.SetSelectFlag(true);
        liveView.SetHeightFree(true);
        liveView.DataSource(loadXMLString(xmlhttp.responseText));
        liveView.DataBind("RecGroupList");   

        var pCurSelRow = liveView.GetSelectedRows();
        if (pCurSelRow.length != 0) {
            GetReceptGroupInfo(pCurSelRow[0].getAttribute("DATA1"));
        }
        xmlhttp = null;
    }
    catch (ErrMsg) {
        alert(" GetReceptGroupList : " + ErrMsg.description);
    }
}
function btn_GroupReceptAdd_onclick(){
    var liveView = new ListView();
    liveView.SetID("lvRecGroupList");
    var pCurSelRow = liveView.GetSelectedRows();
    if (pCurSelRow.length != 0) {
        if (SusinGroupUseFlag != "Y") {
            AprLineAddDeptGroup();
        }
        else {
            AddGroupReceptADD(pCurSelRow[0].getAttribute("DATA1"));
        }
    }
}

function AprLineAddDeptGroup() {
    var Resultxml = "";
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
    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");

    var listview2 = new ListView();
    listview2.LoadFromID("lvRecGroupList");

    if (listview.ExistRow("DATA1", "SG_" + listview2.GetSelectedRows()[0].getAttribute("DATA1"))) {
        OpenAlertUI(strLang166);
        return;
    }

    setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
    setNodeText(GetChildNodes(objNodes[0])[1], "SG_" + listview2.GetSelectedRows()[0].getAttribute("DATA1"));
    setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
    setNodeText(GetChildNodes(objNodes[0])[3], "N");
    setNodeText(GetChildNodes(objNodes[0])[4], "N");
    setNodeText(GetChildNodes(objNodes[0])[5], "N");
    setNodeText(GetChildNodes(objNodes[0])[6], companyID);
    setNodeText(GetChildNodes(objNodes[0])[7], "");
    setNodeText(GetChildNodes(objNodes[0])[8], "");
    setNodeText(GetChildNodes(objNodes[0])[9], "");
    setNodeText(GetChildNodes(objNodes[0])[10], listview2.GetSelectedRows()[0].getAttribute("DATA2"));
    setNodeText(GetChildNodes(objNodes[0])[11], listview2.GetSelectedRows()[0].getAttribute("DATA2"));
    setNodeText(GetChildNodes(objNodes[1])[0], listview2.GetSelectedRows()[0].getAttribute("DATA2"));

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
    DeptAddIndex = DeptAddIndex + 1;
}

function AddGroupReceptADD(p_AprLineTempletID) {
	var result = "";
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getReceptGroupADDTo.do",
		data : {
				groupID : p_AprLineTempletID
				},
		success: function(text){
			result = text;
		}        			
	});
	
    var ResultXML = loadXMLString(result)
    if (SelectNodes(ResultXML, "LISTVIEWDATA/ROWS/ROW").length > 0) {
        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");
        var objHeaderXML = SelectNodes(ResultXML, "LISTVIEWDATA/HEADERS").item(0);
        var objRowsCnt = SelectNodes(ResultXML, "LISTVIEWDATA/ROWS/ROW").length;
        for (var RowsCnt = 0; RowsCnt < objRowsCnt; RowsCnt++) {

            DeptAddIndex = listview.GetRowCount();
            if (DeptAddIndex == 1) {
                var tr = listview.GetDataRows();
                if (tr[0].id.indexOf("noItems") > 0)
                    DeptAddIndex = 0;
            }
            DeptAddIndex = DeptAddIndex + 1;

            var NodeXmlPara = createXmlDom();
            var objNode, objHeaders, objNodes;
            objNode = createNodeInsert(NodeXmlPara, objNode, "LISTVIEWDATA");
            objNode.appendChild(objHeaderXML);
            objNodes = createNodeAndInsertText(NodeXmlPara, objNodes, "ROWS", "");
            objNodes.appendChild(SelectNodes(ResultXML, "LISTVIEWDATA/ROWS/ROW").item(0));
            setNodeText(SelectNodes(NodeXmlPara, "LISTVIEWDATA/ROWS/ROW/CELL/VALUE")[0], DeptAddIndex);

            if (DuplicateAddGroupReceptCheck(getNodeText(SelectNodes(NodeXmlPara, "LISTVIEWDATA/ROWS/ROW/CELL/DATA1")[0]))) {
                var tmptr = listview.GetSelectedRows();
                var InitTr = listview.GetDataRows();

                var MaxID = 0;
                for (var j = 0; j < InitTr.length; j++) {
                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    if (MaxID < curnum)
                        MaxID = curnum;
                }

                if (tmptr.length == 0) {
                    if (InitTr.length == 0) {
                        document.getElementById('RECEPTLIST').innerHTML = "";
                        var listview = new ListView();
                        listview.SetID("lvRECEPTLIST");
                        listview.SetSelectFlag(false);
                        listview.SetHeightFree(true);
                        listview.SetMulSelectable(false);
                        listview.SetRowOnDblClick("AprDeptDel_onclick");
                        listview.DataSource(NodeXmlPara);
                        listview.DataBind("RECEPTLIST");

                    } else {

                        var objTr = listview.AddRow(0);
                        SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                        listview.AddDataRow(objTr, NodeXmlPara);

                    }
                }
                else {
                    var objTr = listview.AddRow(0);
                    SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, NodeXmlPara);
                }
                DeptAddIndex = DeptAddIndex + 1;
                NodeXmlPara = null;
            }
        }

    }
}
function DuplicateAddGroupReceptCheck(APRDEPT) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");
    var AprDeptList = listview.GetDataRows();
    var AprDeptListLen = AprDeptList.length;
    var i;

    for (i = 0; i < AprDeptListLen; i++) {
        if (AprDeptList[0].getAttribute("DATA1") == null) {
            return true; break;
        }
        if (AprDeptList[i].getAttribute("DATA1") == APRDEPT) {
            return false;
            break;
        }
    }
    return true;
}
//############################################################################################################################################# 수신처 그룹 리스트 클릭 이벤트
function lvRecGroupList_onSel_Click() {
    var liveView = new ListView();    
    liveView.SetID("lvRecGroupList");
    var pCurSelRow = liveView.GetSelectedRows();
    if (pCurSelRow.length != 0) {
        GetReceptGroupInfo(pCurSelRow[0].getAttribute("DATA1"));
    }
}
//############################################################################################################################################# 수신처 그룹 리스트 세부 리스트
var xmlHTTP2;
function GetReceptGroupInfo(p_AprLineTempletID) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getReceptGroupDetailList.do",
		data : {
				groupID : p_AprLineTempletID
				},
		success: function(text){
			event_GetReceptGroupInfo(text);
		}        			
	});
}
function event_GetReceptGroupInfo(text)
{
    try
    {        
        if (document.getElementById("RecGroupDetail").innerHTML != "")
            document.getElementById("RecGroupDetail").innerHTML = "";
        var pAPRTEMP = new ListView();    
        pAPRTEMP.SetID("lvRecGroupDetail");
        pAPRTEMP.SetMulSelectable(false);  
        pAPRTEMP.SetHeightFree(true);
        pAPRTEMP.SetSelectFlag(false);
        pAPRTEMP.DataSource(loadXMLString(text));
        pAPRTEMP.DataBind("RecGroupDetail");
        xmlHTTP2 = null;
    }
    catch (ErrMsg) {
        alert(" GetReceptGroupInfo : " + ErrMsg.description);
    }
}
//############################################################################################################################################# 수신처 즐겨찾기 적용
function btn_AprDeptTempletAdd_onclick()
{
    var p_CheckAprDeptTempletSN;
    var pAPRTemplist = new ListView();   
    pAPRTemplist.LoadFromID("lvRecSaveList");
    var ListViewLen = pAPRTemplist.GetSelectedRows();
   
    if(ListViewLen.length < 1)
	{
		return;
	}
	
    p_CheckAprDeptTempletSN = ListViewLen[0].getAttribute("DATA1");
    if (p_CheckAprDeptTempletSN == "") {
        var pAlertContent = linealt14;
        OpenAlertUI(pAlertContent);
    }
    else {
        AddToAprDeptFromAprDeptTemplet(p_CheckAprDeptTempletSN);
        pAprDeptTempletUseFlag = false;
    }
}
function AddToAprDeptFromAprDeptTemplet(p_CheckAprDeptTempletSN) {
	var result = "";
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/addToAprDept.do",
		data : {
				userID : pUserID,
				formID : pFormID,
				aprSN  : p_CheckAprDeptTempletSN
				},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});

    document.getElementById('RECEPTLIST').innerHTML = "";
    var listview = new ListView();                      
    listview.SetID("lvRECEPTLIST");                     
    listview.SetMulSelectable(false);                     
    listview.SetHeightFree(true);
    listview.SetSelectFlag(false);
    listview.SetRowOnDblClick("AprDeptDel_onclick");
    listview.DataSource(result);            
    listview.DataBind("RECEPTLIST");
}
//############################################################################################################################################# 수신처 즐겨찾기 적용 
//############################################################################################################################################# 수신처 즐겨찾기 삭제 
var temp_CheckAprDeptTempletSN;
function btn_AprDeptTempletDel_onclick() {
    var p_CheckAprDeptTempletSN;
    var pAPRTemplist = new ListView();
    pAPRTemplist.LoadFromID("lvRecSaveList");
    var ListViewLen = pAPRTemplist.GetSelectedRows();

    if (ListViewLen.length < 1) {
        var pAlertContent = linealt15;
        OpenAlertUI(pAlertContent);
        return;
    }

    p_CheckAprDeptTempletSN = ListViewLen[0].getAttribute("DATA1");

    if (p_CheckAprDeptTempletSN == "") {
        var pAlertContent = linealt15;
        OpenAlertUI(pAlertContent);
        return;
    }
    temp_CheckAprDeptTempletSN
    temp_CheckAprDeptTempletSN = p_CheckAprDeptTempletSN;
    var pInformationContent = linealt16;
    var Ans = OpenInformationUI(pInformationContent, btn_AprDeptTempletDel_onclick_Complete);
    if (!CrossYN() && Ans) {
        DelAprDeptTempletList(pUserID, pFormID, p_CheckAprDeptTempletSN);
    }
}

function btn_AprDeptTempletDel_onclick_Complete() {
    DivPopUpHidden();
    DelAprDeptTempletList(pUserID, pFormID, temp_CheckAprDeptTempletSN);
}

function DelAprDeptTempletList(pUserID, pFormID, p_SelAprDeptTempletSN) {
	var result = "";
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/delAprDeptTempletList.do",
		data : {
				userID : pUserID,
				formID : pFormID,
				aprSN  : p_SelAprDeptTempletSN
				},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});
	
    var dataNodes = GetChildNodes(result);
    var RtnVal = getNodeText(dataNodes[0]);

    if (RtnVal == "TRUE") {
        InitReceptTemplet();
    }
    else {
        var parameter = strLang163 + "<br> " + strLang164;
        OpenAlertUI(parameter);
    }
}
//############################################################################################################################################# 수신처 즐겨찾기 삭제 
//############################################################################################################################################# 수신처 즐겨찾기 저장 및 수정
var aprdepttempletname_cross_dialogArguments = new Array();
var tempmode;
function btn_AprDeptTempletSave_onclick(mode) {
    tempmode = mode;
    if (isExistDept(true)) {
        var parameter = strLang1002;
        OpenAlertUI(parameter);
        return;
    }

    var templistviewsn = "";
    var templisttviewname = "";
    var ListViewLen = "";
    var listview = new ListView();

    if (mode == "NEW") {
        listview.LoadFromID("lvRECEPTLIST");
        ListViewLen = listview.GetDataRows();
    }
    else {
        listview.LoadFromID("lvRecSaveList");
        ListViewLen = listview.GetSelectedRows();
    }

    if (mode == "MODIFY" && ListViewLen.length < 1) {
        return;
    }
    else if (mode == "MODIFY" && ListViewLen.length >= 1) {
        templistviewsn = ListViewLen[0].getAttribute("DATA1");
        templisttviewname = ListViewLen[0].getAttribute("DATA2");
    }

    if (ListViewLen.length != "0" && ListViewLen[0].id != "lvRECEPTLIST_TR_noItems") {
        var windowName = "/ezApprovalG/aprDeptTempletName.do";
        var parameter = "status:no;dialogWidth:340px;dialogHeight:200px;scroll:no;edge:sunken";
        var dialogValue = new Array();
        dialogValue[0] = pUserID;
        dialogValue[1] = pFormID;
        dialogValue[2] = "";
        dialogValue[3] = "";
        if (mode == "MODIFY") {
            dialogValue[2] = templistviewsn;
            dialogValue[3] = templisttviewname;
        }
        if (CrossYN()) {
            aprdepttempletname_cross_dialogArguments[0] = dialogValue;
            aprdepttempletname_cross_dialogArguments[1] = btn_AprDeptTempletSave_onclick_Complete;

            DivPopUpShow(360, 220, windowName);
        }
        else {
            parameter = parameter + GetShowModalPosition(340, 200);

            var ret = window.showModalDialog(windowName, dialogValue, parameter);
            if (ret != "cancel") {
                if (mode == "NEW")
                    pAprDeptTempletUseFlag = true;
                else
                    pAprDeptTempletUseFlag = false;

                CreateNewAprDeptTemplet(ret);
            }
        }
    }
    else {
        var pAlertContent = linealt14;
        OpenAlertUI(pAlertContent);
    }
}

function btn_AprDeptTempletSave_onclick_Complete(ret) {
    DivPopUpHidden();
    if (ret != "cancel") {
        if (tempmode == "NEW")
            pAprDeptTempletUseFlag = true;
        else
            pAprDeptTempletUseFlag = false;

        CreateNewAprDeptTemplet(ret);
    }
}

function CreateNewAprDeptTemplet(p_AprDeptTempletName) {
    var AprDeptTemplet = createXmlDom();
    var Result;
    var p_AprDeptTempletID;
    AprDeptTemplet = AprDeptTempletXmlParsing(p_AprDeptTempletName);
    var AprDeptXml = APRDeptXMLParsing(RECEPTLIST, pDocID);
    var AprDeptInfo = createXmlDom();
    AprDeptInfo = loadXMLString(AprDeptXml);

    if (CrossYN()) {
        var xmlRtn = AprDeptTemplet.documentElement;
        var Node = AprDeptInfo.importNode(xmlRtn, true);
        AprDeptInfo.documentElement.appendChild(Node);
    }
    else {
        var xmlRtn = AprDeptTemplet.documentElement;
        AprDeptInfo.documentElement.appendChild(xmlRtn);
    }
        
    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("Post", "/ezApprovalG/createAprDeptTemplet.do", false);
    xmlhttp.send(AprDeptInfo);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    var RtnVal = getNodeText(dataNodes[0]);

    if (RtnVal == "TRUE") {
        OpenAlertUI(strLang814, CreateNewAprDeptTemplet_Complete);
        if (!CrossYN())
            InitReceptTemplet();
    }
    else {
        OpenAlertUI(strLang131);
    }
}

function CreateNewAprDeptTemplet_Complete() {
    DivPopUpHidden();
    InitReceptTemplet();
}
function AprDeptTempletXmlParsing(p_AprDeptTempletName) {
    var p_AprDeptSN;
    var xmlpara = createXmlDom();
    if (pAprDeptTempletUseFlag) {
        p_AprDeptSN = "";
    } else {

        var pAPRTemplist = new ListView();
        pAPRTemplist.LoadFromID("lvRecSaveList");
        var ListViewLen = pAPRTemplist.GetSelectedRows();
        p_AprDeptSN = ListViewLen[0].getAttribute("DATA1");
    }

    var objNode;
    createNodeInsert(xmlpara, objNode, "APRDEPT");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID);
    createNodeAndInsertText(xmlpara, objNode, "pAprDeptSN", p_AprDeptSN);
    createNodeAndInsertText(xmlpara, objNode, "p_AprDeptTempletName", p_AprDeptTempletName);

    return xmlpara;
}
//############################################################################################################################################# 수신처 즐겨찾기 저장 및 수정