
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
	try {
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
	} catch(e) {
        alert("GetReceptTempletInfo::" + e.description);
    }
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
    var param = new FormData();
    param.append("extReceptYn", isOuterForm ? "Y" : "N");
    
    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();

    xmlhttp.open("Post", "/ezApprovalG/getReceptGroupList.do", true);
    xmlhttp.send(param);
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

function btn_GroupReceptAdd_onclick(flag){
    var lv = new ListView();
    lv.LoadFromID("lvRecGroupList")
    var curSelRows = lv.GetSelectedRows();

    if (curSelRows.length > 0) {
        var lv2 = new ListView();
        lv2.LoadFromID("lvRecGroupDetail")
        var curSelMemberRows = lv2.GetDataRows();
        if (flag === "each") {
            addSusinGroupMember(curSelMemberRows);
        } else if (flag === "group") {
            var curSelRow = curSelRows[0];
            addSusinGroup(curSelRow, curSelMemberRows);
        }
    } else {
        OpenAlertUI(strLang974);
    }
}

function addSusinGroup(row, mrows) {
    var TrashList = [];
    for (var i = 0, ilen = mrows.length; i < ilen; i++) {
        var mrow = mrows[i];
        if (mrow.getAttribute("DATA6") == "N" && mrow.getAttribute("DATA7") == "Y") {
            var deptName = (UserLang == "1") ? mrow.getAttribute("DATA2") : mrow.getAttribute("DATA3");
            TrashList.push(deptName);
        }
    }
    if (TrashList.length > 0){
        alert("[" + TrashList.join(",") + "]" + " 부서는 폐지되었습니다. 수신자 리스트에 제외됩니다.");
    }

    var groupId = preSusinGroupStr + row.getAttribute("DATA1");
    var groupName = row.getAttribute("DATA2");
    var extReceptYn = row.getAttribute("DATA3");

    addGroupToRecept(groupId, groupName, groupName, extReceptYn);
}

function addGroupToRecept(groupId, groupName, groupName2, extReceptYn) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");

    var idx = getReceptLastIdx(listview);

    if (idx > 1) {
        var notSameRecept = listview.GetDataRows().some(function(data) {
            return data.getAttribute("DATA3") !== extReceptYn;
        });
        if (notSameRecept) {
            OpenAlertUI(strLang973);
            return;
        }
    }

    if (listview.ExistRow("DATA1", groupId)) {
        OpenAlertUI(strLang247);
        return;
    }

    var addRowXml = makeReceptListview({
        data0: idx,
        data1: groupId,
        data2: pDocID,
        data3: extReceptYn,
        data4: "N",
        data5: "N",
        data6: extReceptYn === "N" ? companyID : "",
        data7: "",
        data8: "",
        data9: "",
        data10: groupName,
        data11: groupName2,
        data12: "",
        data13: ""
    });

    if (idx === 1) {
        listview.DataSource(addRowXml);
        listview.RowDataBind();
    } else {
        var newTr = listview.AddRow(0);
        SetAttribute(newTr, "id", "lvRECEPTLIST_TR_" + (idx - 1));
        listview.AddDataRow(newTr, addRowXml);
    }
}

function addSusinGroupMember(rows) {
    var groupMemberIds = [];
    var groupMemberNames = [];
    var groupMemberName2s = [];
    var groupMemberExtReceptYns = [];
    var TrashList = [];

    for (var i = 0, ilen = rows.length; i < ilen; i++) {
        var row = rows[i];
        if (row.getAttribute("DATA6") == "N" && row.getAttribute("DATA7") == "Y") {
            var deptName = (UserLang == "1") ? row.getAttribute("DATA2") : row.getAttribute("DATA3");
            TrashList.push(deptName);
        } else {
            groupMemberIds.push(row.getAttribute("DATA1"));
            groupMemberNames.push(row.getAttribute("DATA2"));
            groupMemberName2s.push(row.getAttribute("DATA3"));
            groupMemberExtReceptYns.push(row.getAttribute("DATA6"));
        }
    }

    if (TrashList.length > 0){
        alert("[" + TrashList.join(",") + "]" + " 부서는 폐지되었습니다. 수신자 리스트에 제외됩니다.");
    }

    addGroupMemberToRecept(groupMemberIds, groupMemberNames, groupMemberName2s, groupMemberExtReceptYns);
}

function addGroupMemberToRecept(groupMemberIds, groupMemberNames, groupMemberName2s, groupMemberExtReceptYns) {
    var listview = new ListView();
    listview.LoadFromID("lvRECEPTLIST");

    var idx = getReceptLastIdx(listview);

    if (idx > 1) {
        var notSameRecept = listview.GetDataRows().some(function(data) {
            return data.getAttribute("DATA3") !== groupMemberExtReceptYns[0];
        });
        if (notSameRecept) {
            OpenAlertUI(strLang973);
            return;
        }
    }

    var addRowsXml = createXmlDom();
    var rowsNode = createNodeInsert(addRowsXml, null, "ROWS");

    for (var i = 0, tempI = 0, ilen = groupMemberIds.length; i < ilen; i++) {
        if (checkDuplicationRecept(listview, groupMemberIds[i])) {
            var addRowXml = makeReceptListview({
                data0: idx + tempI++,
                data1: groupMemberIds[i],
                data2: pDocID,
                data3: groupMemberExtReceptYns[i],
                data4: "N",
                data5: "N",
                data6: groupMemberExtReceptYns[i] === "N" ? companyID : "",
                data7: "",
                data8: "",
                data9: "",
                data10: groupMemberNames[i],
                data11: groupMemberName2s[i],
                data12: "",
                data13: ""
            });
    
            if (rowsNode.firstChild) {
                rowsNode.insertBefore(SelectNodes(addRowXml, "LISTVIEWDATA/ROWS/ROW")[0], rowsNode.firstChild);
            } else {
                rowsNode.appendChild(SelectNodes(addRowXml, "LISTVIEWDATA/ROWS/ROW")[0]);
            }
        }
    }

    if (idx === 1) {
        listview.DataSource(addRowsXml);
        listview.RowDataBind();
    } else {
        var rows = SelectNodes(addRowsXml, "ROWS/ROW");

        for (var i = rows.length - 1, tempIdx = idx; i >= 0; i--, tempIdx++) {
            var newTr = listview.AddRow(0);
            SetAttribute(newTr, "id", "lvRECEPTLIST_TR_" + (tempIdx - 1));
            listview.AddDataRow(newTr, rows[i]);
        }
    }
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

    /* 2024-04-18 민지수 - 전자결재 > 결재정보 > 수신처 즐겨찾기에 폐지부서 있는지 확인 */
    var CheckAprTrashDept;
    var TrashList = [];
    var RetireList = [];
    var ReceiverlessList = [];
    var NonReceivingDeptList = [];
    var Templist = new ListView();
    Templist.LoadFromID("lvRecSaveDetail");
    var TempListLen = Templist.GetDataRows();
   
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
        for (var i = 0; i < TempListLen.length; i ++) {
            CheckAprTrashDept = TempListLen[i].getAttribute("TRASHDEPT");
            if (CheckAprTrashDept == "Y") {
                TrashList.push(TempListLen[i].getAttribute("DATA10"));                
            }
            /* 2024-05-10 양지혜 - 전자결재 > 결재정보 > 퇴직자 포함된 즐겨찾기 적용 시 제외 */
            if (TempListLen[i].getAttribute("RETIRECHK") == "Y") {
                RetireList.push(TempListLen[i].querySelector("td:nth-child(2)").textContent);
            }
            if (ListViewLen[0].getAttribute("DATA3") != "Y" && TempListLen[i].children[1] && TempListLen[i].children[1].textContent == '') {
                if (!isReceiverChk(TempListLen[i].getAttribute("data1"))) {
                    ReceiverlessList.push(TempListLen[i].getAttribute("DATA10"));
                }
            }
            if (approvalFlag === "G" && GetEntryInfo(TempListLen[i].getAttribute("DATA1")) !== "Y") {
                NonReceivingDeptList.push(TempListLen[i].getAttribute("DATA10"));
            }
        }
        if (TrashList.length > 0){
            alert("[" + TrashList.join(",") + "] " + strLangRetiree02);
        }
        if (RetireList.length > 0) {
            alert("[" + RetireList.join(",") + "] " + strLangRetiree01);
        }
        if (ReceiverlessList.length > 0) {
            alert("[" + ReceiverlessList.join(",") + "] " + strLang1101 + strLang1102);
        }
        if (NonReceivingDeptList.length > 0) {
            alert("[" + NonReceivingDeptList.join(",") + "] " + strLangJJE01);
        }

        AddToAprDeptFromAprDeptTemplet(p_CheckAprDeptTempletSN);
        pAprDeptTempletUseFlag = false;
        //시행문
        if (pDocType != null && pDocType != undefined && pDocType == "001") {
        	checkOuterReceiver();
        }
    }
    
	/* 2023-01-12 홍승비 - 결재정보 > 수신자 즐겨찾기 적용으로 ROW 추가 시, 수기입력된 수신처ID를 전체적으로 갱신 ("Address" + 숫자 형태의 ID를 가지는 경우에만) */
	refreshAllDeptAddressRowID();
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
    if (Ans) {
        DelAprDeptTempletList(pUserID, pFormID, p_CheckAprDeptTempletSN);
    }
}

function btn_AprDeptTempletDel_onclick_Complete(rtn) {
    DivPopUpHidden();
    if (rtn == "" || rtn == undefined)
        return;
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
		success: function(result){
			InitReceptTemplet();
		},
		error : function() {
			var parameter = strLang163 + "<br> " + strLang164;
	        OpenAlertUI(parameter);
		}
	});
}
//############################################################################################################################################# 수신처 즐겨찾기 삭제 
//############################################################################################################################################# 수신처 즐겨찾기 저장 및 수정
var aprdepttempletname_cross_dialogArguments = new Array();
var tempmode;
function btn_AprDeptTempletSave_onclick(mode) {
    tempmode = mode;
    
    //외부 수신자도 즐겨찾기 저장 가능하게 주석처리 2018-03-21 강민수92
//    if (isExistDept(true)) {
//        var parameter = strLang1002;
//        OpenAlertUI(parameter);
//        return;
//    }

    var templistviewsn = "";
    var templisttviewname = "";
    var ListViewLen = "";
    var listview = new ListView();
    
    listview.LoadFromID("lvRECEPTLIST");
    ListViewLen = listview.GetDataRows();
    
    if (ListViewLen.length == 0 || GetAttribute(ListViewLen[0], "id") == "lvRECEPTLIST_TR_noItems") {
		OpenAlertUI(strLangS957);
        return;
    }

    var hasSusinGroup = ListViewLen.some(function(data) {
        return data.getAttribute("DATA1").indexOf(preSusinGroupStr) === 0;
    });
    if (hasSusinGroup) {
		OpenAlertUI(strLangMJSSFA);
        return;
    }

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
        var parameter = "status:no;dialogWidth:340px;dialogHeight:185px;scroll:no;edge:sunken";
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

            DivPopUpShow(360, 185, windowName);
        }
        else {
            parameter = parameter + GetShowModalPosition(340, 185);

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
    
    if (AprDeptXml == "NODATA") {
    	OpenAlertUI(strLangS957);
    	
    	return;
    }
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

    var RtnVal = xmlhttp.responseText;
    
    if (xmlhttp != null && xmlhttp.readyState == 4) {
		if (xmlhttp.status == 200 && RtnVal == "TRUE") {
			OpenAlertUI(strLang814, CreateNewAprDeptTemplet_Complete);
	        if (!CrossYN())
	            InitReceptTemplet();
		} else {
			OpenAlertUI(strLang131);
		}
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

function checkOuterReceiver() {
	var listview = new ListView();
	listview.LoadFromID("lvRECEPTLIST");
	
	var cnt = listview.GetRowCount();
	var row = listview.GetDataRows();

	if (cnt > 0) {
		var checkOuter = row[0].getAttribute("DATA3");
		var checkAddress = row[0].getAttribute("DATA1");
		
		if (cnt > 8 && checkOuter == "Y" && checkAddress.indexOf("Address") == -1) {
	        document.getElementById("inputSummaryOuterReceiverList").focus();
	        document.getElementById("trSummaryOuterReceiverList").style.display = "";
	        document.getElementById("btnaddress").style.display = "none";
	        // document.getElementById("btnaddressChange").style.display = "none";
		} else if (cnt <= 8 && checkOuter == "Y" && checkAddress.indexOf("Address") == -1) {
	        document.getElementById("trSummaryOuterReceiverList").style.display = "none";
	        document.getElementById("btnaddress").style.display = "";
	        // document.getElementById("btnaddressChange").style.display = "";
		} else if (checkOuter == "Y" && checkAddress.indexOf("Address") != -1) {
			document.getElementById("trSummaryOuterReceiverList").style.display = "none";
	        document.getElementById("btnaddress").style.display = "";
	        // document.getElementById("btnaddressChange").style.display = "";
		} else {
			document.getElementById("trSummaryOuterReceiverList").style.display = "none";
	        document.getElementById("btnaddress").style.display = "";
	        // document.getElementById("btnaddressChange").style.display = "none";
		}
	}
}