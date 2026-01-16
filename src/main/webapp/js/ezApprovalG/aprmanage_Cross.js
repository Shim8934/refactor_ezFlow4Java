var beforeJob = "0";
var pDocTypeValue = "000";
var pageSize = "10";
var CallPage = "Right";
var xmlhttp = createXMLHttpRequest();
var xmlhttp2 = createXMLHttpRequest();
var arrySubTab = new Array(0, 6, 4, 4, 3, 4); 
var pTotalCnt = "";
function getDocList() {
    pageSize = "10";
        
    if (typeof (psearch) == "object")
        document.getElementById("psearch").style.display = "none";

    if (beforeJob != pListTypeValue || SelYearFlag || SearchFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }
    
    if (SQLPARADATA == "") {
        var nowyear = nowDate.substring(0,4);
        var nowmonth = nowDate.substring(5,7);
        var nowday = nowDate.substring(8,10);
        
        SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
    }
    
    var searchCompanyID = $("#selectCompany option:selected").val();
    var searchStatus = $("#sel_status option:selected").val();
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getAprDocList.do",
		data : {
				listType : pListTypeValue, 
				docType  : pDocTypeValue,
				userID 		 : pUserID,
				deptID   : arr_userinfo[4],
				pageSize 	 : pageSize,
				pageNum 	 : pageNum,
				companyID    : companyID,
				orderCell    : OrderCell,
				orderOption  : OrderOption,
				searchQuery  : SQLPARADATA,
				subQuery     : SubQuery,
				searchCompanyID : searchCompanyID,
				searchStatus : searchStatus
				},
		success: function(xml){
			getDocList_after(loadXMLString(xml));
		}        			
	});	

    //ShowMailProgress();
    //DisplayWaitStat();
}

function GetTodayDate() {
    var objDate = new Date();
    var y = String(objDate.getYear());
    var m = String(objDate.getMonth() + 1);
    var d = String(objDate.getDate());

    m = "00".substring(0, 2 - m.length) + m;
    d = "00".substring(0, 2 - d.length) + d;

    return y + "-" + m + "-" + d;
}
function chkUrgent() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetDataRows();

    var cnt = tr.length;
    var i, j;
    var chkVal;
    if (cnt > 0) {
        for (i = 0; i < cnt; i++) {
            chkVal = tr[i].getAttribute("DATA14");
            if (chkVal == "Y") {
                for (j = 0; j < tr[i].cells.length; j++)
                    tr[i].cells[j].style.color = "red";
            }
        }
    }
}
function getDocList_after(xml) {
    SelYearFlag = false;

    var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
    var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
    if (listNode == null) return;

    var lstCnt = getNodeText(cntNode);
    
    totalPage = Math.ceil(new Number(lstCnt / pageSize));
    pTotalCnt = lstCnt;
    
    //2018-10-08 천성준 - 상세검색 or 간편검색 시, 검색결과가 없을때 totalPage가 0이 되버려서 무한검색 loop를 타는 버그 수정 
    if (totalPage <= 0)
    	totalPage = 1; //검색 결과가 없어도 페이징 토탈의 default는 1 이다.
    
    if (pageNum > totalPage) {
        pageNum--;
        getDocList();
        return;
    }
    
	// 리스트를 닫기 전에 미리 선택한 row가 있을 때를 확인
    var preDocList = new ListView();
    var docListID = "DocList";
    preDocList.LoadFromID(docListID);
   	var preSelectedRow = preDocList.GetSelectedRows();

    makePageSelPage();

    var xmlDoc;
    if (CrossYN()) {
        var xmlLIST = createXmlDom();
        var nodeToImport = xmlLIST.importNode(listNode, true);
        xmlLIST.appendChild(nodeToImport);

        xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
    }
    else {
        xmlDoc = createXmlDom();
        xmlDoc.appendChild(listNode);
    }
   
    if (document.getElementById("lvDocList").innerHTML != "") document.getElementById("lvDocList").innerHTML = "";
    //if (pListTypeValue == "21") {
    //    var listcnt = SelectNodes(xmlDoc, "LISTVIEWDATA/ROWS/ROW").length;

    //    for (var i = 0; i < listcnt; i++) {
    //        var row = SelectNodes(xmlDoc, "LISTVIEWDATA/ROWS/ROW")[i];
    //        GetChildNodes(row, "VALUE")[4].textContent = GetChildNodes(row, "VALUE")[5].textContent.trim();
    //    }
    //}
    
    var DocList = new ListView();
    DocList.SetID(docListID);
    DocList.SetMulSelectable(false);
    DocList.SetHeaderOnClick("lvDocList_HeaderClick");
    DocList.SetRowOnClick("lvDocList_SelChange");
    DocList.SetRowOnDblClick("lvDocList_DBSelChange");
    DocList.SetTitleIdx(0);
    DocList.SetUrgentFlag(false);
    
    /* 2023-06-19 조소정 - 공람할문서 메뉴(99) 복수 체크박스 추가 */
    if(pListTypeValue == "1" || pListTypeValue == "4" || pListTypeValue == "99" || pListTypeValue == "24" || pListTypeValue == "97" || pListTypeValue == "10") { // 2020-04-29 : 결재할문서 복수체크박스 추가
    	DocList.SetCheckBoxFlag(true);
    }

    DocList.DataSource(xmlDoc);
    DocList.DataBind("lvDocList");
    
    // 리스트를 닫기 전에 미리 선택한 row로 재선택
    if (selRowChangeFlag && preSelectedRow.length > 0) {
    	// 탭 이동 시에도 전 탭에서 선택된 row를 선택되는 오류 개선
    	selRowChangeFlag = false;
    	var docListLength = DocList.GetRowCount() - 1;
    	// 마지막 row의 결재가 완료된 후 리스트로 돌아오면 로우가 선택되어 있지 않는 오류 개선
        var beforeSelectedId = preSelectedRow[0].getAttribute('id');
        if (docListLength < beforeSelectedId.split("_")[2]) {
    		DocList.SetSelectedIndex(docListLength);
    	} else {
            tr_select(beforeSelectedId,docListID,true);
    	}
    }    
    DocList = null;
    
    HiddenMailProgress();

    chkUrgent();

    var Rtnval = setbuttonenable();
    if (Rtnval) {
        //DisplayAprLineStat(lstCnt);

        if (pDocInfoValue == "1") {
            InitlvAprLine();
        }
        else {
            var DocList = new ListView();
            DocList.LoadFromID(docListID);
            var oArrRows = DocList.GetSelectedRows();
            
            if (oArrRows.length != "0") {
                var tr = oArrRows[0];

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
            } /* 2020-07-01 홍승비 - 하단 결재선 탭 이외의 탭을 선택한 상태에서 문서가 리스트에서 전부 사라진 경우, 탭에 정보가 남아있는 오류 수정 */
            else {
            	var headerCnt = $("table[id='AprLine']").find("th").length;
            	if (headerCnt > 0) {
            		$("#AprLine").find("tbody").html("<tr id='AprLine_TR_noItems'><td align='center' colspan='" + headerCnt + "'>" + strLang944 + "</td></tr>");
            	}
            }
        }
    }

    SearchFlag = false;
    
    if ($("#PreviewRayerH").length && $("#PreviewRayerH").css("display") != "none") {
    	PreviewRayerChange("H", 'Manage');
    	if (CrossYN()) {
    		if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
        		ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = strLang930;	        			
    		}
        } else {
        	if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
            	ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLang930;		            		
        	}
        }
    } else if ($("#PreviewRayerH").length) {
    	PreviewRayerChange("NONE", 'Manage');
    }

    if (USE_OCS == "YES")
        check_presence2();
    
    try {
    	parent.frames["left"].pListTypeValue = pListTypeValue;
        parent.frames["left"].getAprCount();
        parent.frames["left"].setPresentValue("");
    } catch (e) { }

    return Rtnval;
}


var g_CurrentFormCd = "_DEF_1";
var CurrentDocList = "";
function getReceivedDocList(p_FormCd) {
    pageSize = "10";   

    if (typeof (psearch) == "object")
        document.getElementById("psearch").style.display = "";

    var manager;

    pSelMenu = "all";

    if (pSelMenu == "hyubjo")
        manager = "admin";
    else
        manager = pSusinManagerFlag;
    
    // 2018-05-02 강민수92 대리수신자일때 부서수신함 표출
    if (pListTypeValue == "4") {
        $.ajax({
        	type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezOrgan/isProxyUser.do",
    		success: function(xml){
    			if (xml == 1) {
    				manager = "admin";
    			}
    		}
    	});
    }

    if (pListTypeValue == "5") {
        manager = manager + ";relay";
    }else if(pListTypeValue == "97"){
        manager = manager + ";personal";
    }

    if (beforeJob != pListTypeValue || SelYearFlag || SearchFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }

    if (SQLPARADATA == "") {
    	var nowyear = nowDate.substring(0,4);
        var nowmonth = nowDate.substring(5,7);
        var nowday = nowDate.substring(8,10);

        SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
    }

    CurrentDocList = "Receive";
    
    var searchStatus = $("#sel_status option:selected").val();
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getReceivedDocList.do",
		data : {
				userID  : pUserID,
				deptID  : arr_userinfo[4],
				mFlag   : manager,
				docState: pSelMenu,
				pageSize: pageSize,
				pageNum : pageNum,
				orderCell : OrderCell,
				orderOption : OrderOption,
				searchQuery : SQLPARADATA,
				searchStatus : searchStatus,
                assignChk : assignChk
				},
		success: function(xml){
			getReceivedDocList_after(loadXMLString(xml));
		}
	});

    //ShowMailProgress();
    //DisplayWaitStat();

}

function getReceivedDocList_after(xml) {
    try {
        SelYearFlag = false;
        var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
        var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");


        var lstCnt = getNodeText(cntNode);
        totalPage = Math.ceil(new Number(lstCnt / pageSize));
        pTotalCnt = lstCnt;
        
        //2018-10-08 천성준 - 상세검색 or 간편검색 시, 검색결과가 없을 때 totalPage가 0이 되버려서 무한검색 loop를 타는 버그 수정 
        if (totalPage <= 0)
        	totalPage = 1; //검색 결과가 없어도 페이징 토탈의 default는 1 이다.

        if (pageNum > totalPage) {
            pageNum--;
            if (CurrentDocList == "Receive")
                getReceivedDocList();
            else
                getSimsaDocList();
            return;
        }
        
        // 리스트를 닫기 전에 미리 선택한 row가 있을 때를 확인
        var preDocList = new ListView();
        var docListID = "DocList";
        preDocList.LoadFromID(docListID);
       	var preSelectedRow = preDocList.GetSelectedRows();
        
        makePageSelPage();

        var xmlDoc;
        if (CrossYN()) {
            var xmlLIST = createXmlDom();
            var nodeToImport = xmlLIST.importNode(listNode, true);
            xmlLIST.appendChild(nodeToImport);

            xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
        }
        else {
            xmlDoc = createXmlDom();
            xmlDoc.appendChild(listNode);
        }


        if (document.getElementById("lvDocList").innerHTML != "") document.getElementById("lvDocList").innerHTML = "";
        var DocList = new ListView();
        DocList.SetID(docListID);
        DocList.SetMulSelectable(false);
        DocList.SetHeaderOnClick("lvDocList_HeaderClick");
        DocList.SetRowOnClick("lvDocList_SelChange");
        DocList.SetRowOnDblClick("lvDocList_DBSelChange");
        DocList.SetTitleIdx(0);
        DocList.SetUrgentFlag(false);

        if ((pListTypeValue == "4" && assignChk != "Y") || pListTypeValue == "97")  // 2023-04-12 이가은 - 부서수신함 복수체크박스 추가
            DocList.SetCheckBoxFlag(true);
        DocList.DataSource(xmlDoc);
        DocList.DataBind("lvDocList");
        
        // 2024-05-29 조수빈 - 부서수신함에서 이전 선택한 row를 유지하는 부분이 누락되어 추가
        // 리스트를 닫기 전에 미리 선택한 row로 재선택
        if (selRowChangeFlag && preSelectedRow.length > 0) {
        	// 탭 이동 시에도 전 탭에서 선택된 row를 선택되는 오류 개선
        	selRowChangeFlag = false;
        	var docListLength = DocList.GetRowCount() - 1;
        	// 마지막 row의 결재가 완료된 후 리스트로 돌아오면 로우가 선택되어 있지 않는 오류 개선
            var beforeSelectedId = preSelectedRow[0].getAttribute('id');
            if (docListLength < beforeSelectedId.split("_")[2]) {
        		DocList.SetSelectedIndex(docListLength);
        	} else {
                tr_select(beforeSelectedId, docListID, true);
        	}
        }  
        
        DocList = null;

        HiddenMailProgress();

        SearchFlag = false;
        //if (displayFlag) document.getElementById("tbtnUserInfo").style.display = "none";

        chkUrgent();

        setbuttonenable();

        //DisplayAprLineStat(lstCnt);

        if (pDocInfoValue == "1") {
            InitlvAprLine();

        }
        else {
            var DocList = new ListView();
            DocList.LoadFromID("DocList");
            var oArrRows = DocList.GetSelectedRows();

            if (oArrRows.length != "0") {
                var tr = oArrRows[0];

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
        
        if ($("#PreviewRayerH").css("display") != "none") {
        	PreviewRayerChange("H", 'Manage');
        	if (CrossYN()) {
        		if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
	        		ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = strLang930;
        		}
            } else {
            	if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
	            	ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLang930;
            	}
            }
        } else {
        	PreviewRayerChange("NONE", 'Manage');
        }
        
        try {
        	parent.frames["left"].pListTypeValue = pListTypeValue;
            parent.frames["left"].getAprCount();
            if (pListTypeValue == 4) {
                var topTitle = assignChk == "Y" ? strLangAssignedList : strLangDeptInbox;
                parent.frames["left"].setPresentValue(topTitle);
            } else {
                parent.frames["left"].setPresentValue("");
            }
        } catch (e) { }
    }
    catch (e) {
        showAlert("getReceivedDocList_after" + " " + e.description);
    }
}

function getSendOutDocList() {    
    pSelMenu = "all";

    if (beforeJob != pListTypeValue || SelYearFlag || SearchFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }
    
    var searchStatus = $("#sel_status option:selected").val();

    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getSendOutDocList.do",
		data : {
				userID : pUserID,
				deptID  : arr_userinfo[4],
				susinManagerFlag : SendOutFlag,
				pageSize : pageSize,
				pageNum  : pageNum,
				orderCell : OrderCell,
				orderOption : OrderOption,
				listType : pListTypeValue,
				searchQuery  : SQLPARADATA,
				searchStatus : searchStatus
				},
		success: function(xml){
			getSendOutDocList_after(loadXMLString(xml));
		}        			
	});
    
    //DisplayWaitStat();

}

function getSendOutDocList_after(xml) {
    try {
        SelYearFlag = false;

        var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
        var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");

        var lstCnt = getNodeText(cntNode);

        totalPage = Math.ceil(new Number(lstCnt / pageSize));
        pTotalCnt = lstCnt;
        makePageSelPage();

        var xmlDoc;
        if (CrossYN()) {
            var xmlLIST = createXmlDom();
            var nodeToImport = xmlLIST.importNode(listNode, true);
            xmlLIST.appendChild(nodeToImport);

            xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
        }
        else {
            xmlDoc = createXmlDom();
            xmlDoc.appendChild(listNode);
        }

        if (document.getElementById("lvDocList").innerHTML != "") document.getElementById("lvDocList").innerHTML = "";
        var DocList = new ListView();
        DocList.SetID("DocList");
        DocList.SetMulSelectable(false);
        DocList.SetHeaderOnClick("lvDocList_HeaderClick");
        DocList.SetRowOnClick("lvDocList_SelChange");
        DocList.SetRowOnDblClick("lvDocList_DBSelChange");
        DocList.SetTitleIdx(0);
        DocList.SetUrgentFlag(false);

        DocList.DataSource(xmlDoc);
        DocList.DataBind("lvDocList");
        DocList = null;

        //if (displayFlag) document.getElementById("tbtnUserInfo").style.display = "none";

        chkUrgent();

        if (typeof adminSendOutFlag !== 'undefined') {
            // 관리자 > 전자결재 > 발송현황 > 리스트 상단 버튼 사용X
        } else {
            setbuttonenable();
        }

        //검색 후 페이지네이션이 안되는 현상 수정. 2020-12-02 홍대표.
        SearchFlag = false;

        //DisplayAprLineStat(lstCnt);

        if (pDocInfoValue == "1") {
            InitlvAprLine();
        }
        else {
            var DocList = new ListView();
            DocList.LoadFromID("DocList");
            var oArrRows = DocList.GetSelectedRows();

            if (oArrRows.length > 0) {
                var tr = oArrRows[0];
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
        try {
            parent.frames["left"].getAprCount();
            parent.frames["left"].setPresentValue("");
        } catch (e) { }
    }
    catch (e) {
        showAlert("getSendOutDocList_after" + " " + e.description);
    }
}

function DisplayAprLineStat(NodeListLen) {
    if (pListTypeValue == 1) {
        document.getElementById("AprManageStat").innerHTML = strLang840 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else if (pListTypeValue == 2) {
        document.getElementById("AprManageStat").innerHTML = strLang841 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else if (pListTypeValue == 3) {
        document.getElementById("AprManageStat").innerHTML = strLang842 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else if (pListTypeValue == 4) {
        switch (pSelMenu) {
            case "all":
                document.getElementById("AprManageStat").innerHTML = strLang843 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
                break;

            case "hyubjo":
                document.getElementById("AprManageStat").innerHTML = strLang844 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
                break;

            case "gamsa":
                document.getElementById("AprManageStat").innerHTML = strLang845 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
                break;
        }
    }
    else if (pListTypeValue == 5) {
        document.getElementById("AprManageStat").innerHTML = strLang846 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else if (pListTypeValue == 6) {
        document.getElementById("AprManageStat").innerHTML = strLang847 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else if (pListTypeValue == 7) {
        document.getElementById("AprManageStat").innerHTML = strLang848 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else if (pListTypeValue == 8) {
        document.getElementById("AprManageStat").innerHTML = strLang849 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else if (pListTypeValue == 9) {
        document.getElementById("AprManageStat").innerHTML = strLang850 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else if (pListTypeValue == 10)
    {
        document.getElementById("AprManageStat").innerHTML = strLang1131 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
}

function DisplayWaitStat() {
    if (pListTypeValue == 1) {
        document.getElementById("AprManageStat").innerHTML = strLang851;
    }
    else if (pListTypeValue == 2) {
        document.getElementById("AprManageStat").innerHTML = strLang852;
    }
    else if (pListTypeValue == 3) {
        document.getElementById("AprManageStat").innerHTML = strLang853;
    }
    else if (pListTypeValue == 4) {
        switch (pSelMenu) {
            case "all":
                document.getElementById("AprManageStat").innerHTML = strLang854;
                break;

            case "hyubjo":
                document.getElementById("AprManageStat").innerHTML = strLang855;
                break;

            case "gamsa":
                document.getElementById("AprManageStat").innerHTML = strLang856;
                break;
        }
    }
    else if (pListTypeValue == 5) {
        document.getElementById("AprManageStat").innerHTML = strLang857;
    }
    else if (pListTypeValue == 6) {
        document.getElementById("AprManageStat").innerHTML = strLang858;
    }
    else if (pListTypeValue == 7) {
        document.getElementById("AprManageStat").innerHTML = strLang859;
    }
    else if (pListTypeValue == 8) {
        document.getElementById("AprManageStat").innerHTML = strLang860;
    }
    else if (pListTypeValue == 9) {
        document.getElementById("AprManageStat").innerHTML = strLang861;
    }
    else if (pListTypeValue == 10) 
    {
        document.getElementById("AprManageStat").innerHTML = strLang1148;
    }
}

function getAprLine(tr, mainPageType) {
    var pDocID,pMode = "",pFlag = "";
    var orgCompanyID = GetAttribute(tr, "orgCompanyID");
    
    if (pSelMenu == "hyubjo" || pSelMenu == "gamsa")
        pDocID = GetAttribute(tr, "DATA7");
    else
        pDocID = GetAttribute(tr, "DATA1");

    if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
    	pMode = "END";
    } else if (pListTypeValue == "21") {
//    	pFlag = "TMP";
//      닷넷에서는 2가지 값만 보내서 controller 에서 노드(0),노드(1) 로 빼서 사용해서  mode로 통일
    	pMode = "TMP";
    } else if (pListTypeValue == "10" || pListTypeValue == "99") {
    	if (approvalFlag == "S") {
    		pDocID = GetAttribute(tr, "DATA2");
    		pMode = "END";
    		pFlag = "Y";
    	} else {
    		pMode = "APR";
    	}
    } else if (pListTypeValue == "3") {
    	pMode = "COD";
    } else {
    	pMode = "APR";
    }
    if (GetAttribute(tr, "DATA12") == "017") {
    	   $.ajax({
    			type : "POST",
    			dataType : "text",
    			async : false,
    			url : "/ezApprovalG/getLineMode.do",
    			data : {
    					docID : pDocID,
    					orgCompanyID : orgCompanyID
    					},
    			success: function(xml){
    				if (xml == "APR") {
    					pMode = "CHAMJOAPR";
    				} else {
    					pMode = "CHAMJOEND";
    				}
    			}        			
    		});
    }
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getLineList.do",
		data : {
				docID : pDocID,
				mode  : pMode,
				flag  : pFlag,
				orgCompanyID : orgCompanyID
				},
		success: function(xml){
			getAprovSub_after(xml, mainPageType);
		}        			
	});
    
}

function getAprovSub_after(xml, type) {
    if (!type) {
        if (document.getElementById("lvAprLine").innerHTML != "") {
            document.getElementById("lvAprLine").innerHTML = "";
        }
    
        if (xml == "NOTPERMISSION") {
            document.getElementById("lvAprLine").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
            document.getElementById("lvAprLine").style.textAlign = "center";
            return;
        }
    }


    var listNode = SelectSingleNodeNew(loadXMLString(xml), "LISTVIEWDATA");

    var xmlDoc;
    if (CrossYN()) {
        var xmlLIST = createXmlDom();
        var nodeToImport = xmlLIST.importNode(listNode, true);
        xmlLIST.appendChild(nodeToImport);

        xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
    }
    else {
        xmlDoc = createXmlDom();
        xmlDoc.appendChild(listNode);
    }

    var AprLine = new ListView();
    AprLine.SetID("AprLine");
    AprLine.SetMulSelectable(false);
//    AprLine.SetTitleIdx(arrySubTab[1]);
    if (type == "dash") {
        AprLine.SetRowOnDblClick("lvAprLine_DBSelChange2");
    } else {
        AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");
    }
    AprLine.SetRowOnClick("lvAprLine_SelChange");
    AprLine.DataSource(xmlDoc);
    if (type != "dash") {
        AprLine.DataBind("lvAprLine");
    }

    if (AprLine.GetRowCount() > 0) {
        //document.getElementById("tbtnUserInfo").style.display = "";
        //if (displayFlag) document.getElementById("tbtnUserInfo").style.display = "none";

        if (USE_OCS == "YES") {
            check_presence();
        }
    }
    else {
        //document.getElementById("tbtnUserInfo").style.display = "none";
        //if (displayFlag) document.getElementById("tbtnUserInfo").style.display = "none";
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
            if (pCheckval == "Y") {
                window.open("/ezApprovalG/ezLineInfo.do?docID=" + pDocID + "&deptID=" + pDeptID + "&docState=012", "", "height=460px,width=1155px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + GetOpenPosition(1155, 460));
            } else {
                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;
                var left = (width - 500) / 2;
                var top = (heigth - 400) / 2;
                // window.open("/ezCommon/showPersonInfo.do?id=" + pDeptID + "&dept=" + GetAttribute(tr, "DATA6"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
                var url = "/ezCommon/showPersonInfo.do?id=" + pDeptID + "&dept=" + GetAttribute(tr, "DATA6");
                var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left;
                showPopup(url, 420, 450, "", feature, hidePopup);
            }
        }
        else {
            var pAlertContent = strLang862;
            OpenAlertUI(pAlertContent);
        }
    }
    else {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;
        var left = (width - 500) / 2;
        var top = (heigth - 400) / 2;
        window.open("/ezCommon/showPersonInfo.do?id=" + GetAttribute(tr, "DATA1"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
    }
}

function openDraftUI(pDraftFlag, pCurSelRow,officeFlag) {
	// 2018.08.27 재기안은 윈도우 하나만 열리도록 수정
	var windowName = "";
	
    if (pDraftFlag.toUpperCase() == "REDRAFT") {
        if (pCurSelRow) {
            var ret = CheckAprLineInfo(pCurSelRow);
            if (ret != "OK") {
                var pAlertContent = strLang863 + "<br>" +
							strLang864 + ret + strLang865;
                OpenAlertUI(pAlertContent);
                return;
            }
        }
        
        windowName = "openDraftUI_REDRAFT";
        
        //2020-01-16 홍대표. receptGubunYN이 Y인데 재기안 할 경우, 민원인 주소 입력 버튼이 사라지는 버그 수정. 닷넷 참고.
        // if (formDocType == "") {
            formDocType = GetAttribute(pCurSelRow, "DATA15");
        //}
    }

    var pArgument = new Array();
    pArgument[0] = pUserID;
    pArgument[1] = formURL;
    pArgument[2] = pDraftFlag;
    pArgument[3] = formDocType;
    
    var openLocation = "";
    if (pCurSelRow) {
        if (pListTypeValue != "5") {
            pArgument[4] = GetAttribute(pCurSelRow, "DATA9");
            pArgument[5] = GetAttribute(pCurSelRow, "DATA12");
            pArgument[6] = GetAttribute(pCurSelRow, "DATA10");
            pArgument[7] = GetAttribute(pCurSelRow, "DATA1");
        }
        else {
            pArgument[4] = "0"; 
            pArgument[5] = "";     
            pArgument[6] = "";    
            pArgument[7] = newDocID;
        }
    }
    else {
        pArgument[4] = "0";
        pArgument[5] = "";
        pArgument[6] = "";
        pArgument[7] = "";
    }
    // 2021-01-21 심기영 오피스결재 추가
    var p_officeFlag = "";
    
    if(officeFlag !== null) {
    	p_officeFlag = officeFlag;
    }
  
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
        var isGroupDoc = checkIsGroupDoc(pArgument[7], ""); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)

        if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) { // 반송된 일괄기안 문서를 여는 경우
            openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        } else {
            openLocation = "/ezApprovalG/draftui.do?formURL=";
            openLocation = openLocation + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        }
            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&officeFlag=" + encodeURI(p_officeFlag);

//        // FormBuilder
//        if (window.reformflag == null) {
//        	// reformflag null 값이라면
//        	reformflag = GetAttribute(pCurSelRow, "REFORMFLAG");
//        }
//        
//    	if (reformflag.length > 0) {
//            openLocation += "&reformflag=" + encodeURI(reformflag);
//    	}
    } else {
    	if (useWebHWP == "NO") {
	    	if (!isIE()) {
	            showAlert("한글양식은 IE에서만 기안 할 수 있습니다.");
	            return;
	        } else {
	        	openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
	            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
	            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
	        }
    	} else {
    		var isGroupDoc = checkIsGroupDoc(pArgument[7], ""); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)
    		
    		if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) { // 반송된 일괄기안 문서를 여는 경우
    			openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
    		} else {
    			openLocation = "/ezApprovalG/draftuiWHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
    		}
            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
    	}
    }

    openwindow(openLocation, windowName, 890, 560);
}

function openApprovUI(allFlag) {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    var mode = "APR";
    var openLocation;
    if (tr.length > 0) {
        var pArgument = new Array();
        pArgument[0] = GetAttribute(tr[0], "DATA1");      
        pArgument[1] = GetAttribute(tr[0], "DATA4");		
        pArgument[2] = GetAttribute(tr[0], "DATA5");		
        pArgument[3] = GetAttribute(tr[0], "DATA7");
        pArgument[4] = GetAttribute(tr[0], "APRMEMBERSN")
        var orgCompanyID = GetAttribute(tr[0], "orgCompanyID");

        if (GetAttribute(tr[0], "DATA12") == "017") {
        	   $.ajax({
        			type : "POST",
        			dataType : "text",
        			async : false,
        			url : "/ezApprovalG/getLineMode.do",
        			data : {
        					docID : pArgument[0],
        					orgCompanyID : orgCompanyID
        					},
        			success: function(xml){
        				mode = xml;
        			}        			
        	  });
        }
        
        var formURL = GetAttribute(tr[0], "DATA3");
        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
            openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?docID=" + encodeURI(pArgument[0]);
            openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
            openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag);
        } else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	        if (useWebHWP == "NO") {
        		if (isIE()) {
	        		var openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + encodeURI(pArgument[0]);
	        		openLocation += "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
	        		openLocation += "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2"));
	        	} else {
	        		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	        		showAlert(pAlertContent);
	                
	                return;
	        	}
        	} else {
        		var isGroupDoc = checkIsGroupDoc(encodeURI(pArgument[0]), orgCompanyID);
        		var openLocation = "";
        		
        		if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) { // 일괄기안 문서를 여는 경우
        			openLocation = "/ezApprovalG/approvuiAll_WHWP.do?docID=" + encodeURI(pArgument[0]);
        		} else {
            		openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + encodeURI(pArgument[0]);
        		}
        		openLocation += "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
        		openLocation += "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2"));
        	}
        } else {
            var isGroupDoc = checkIsGroupDoc(encodeURI(pArgument[0]), orgCompanyID);
            if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) // 일괄기안 문서를 여는 경우
                openLocation = "/ezApprovalG/approvuiAll_WHWP.do?docID=";
            else
                openLocation = "/ezApprovalG/approvui.do?docID=";
            openLocation = openLocation + encodeURI(pArgument[0]);
            openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
            openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2")) + "&aprMemberSN=" + pArgument[4];
        }
        openwindow(openLocation, "ApprovUI", 880, 550);
    }
    else {
        var pAlertContent = strLang870;
        showAlert(pAlertContent);
    }
}

function InitlvAprLine() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();

    if (oArrRows.length != 0) {
        var tr = oArrRows[0];

        SelectFlag = false;
        getAprLine(tr);

    } else {
        var pAprLinexml;

        pAprLinexml = "<LISTVIEWDATA><HEADERS>";
        pAprLinexml = pAprLinexml + "<HEADER><NAME>" + strLang605 + "</NAME><WIDTH>35</WIDTH><COLNAME /></HEADER>";
        pAprLinexml = pAprLinexml + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>50</WIDTH><COLNAME /></HEADER>";
        pAprLinexml = pAprLinexml + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>40</WIDTH><COLNAME /></HEADER>";
        pAprLinexml = pAprLinexml + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>100</WIDTH><COLNAME /></HEADER>";
        pAprLinexml = pAprLinexml + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>75</WIDTH><COLNAME /></HEADER>";
        pAprLinexml = pAprLinexml + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>75</WIDTH><COLNAME /></HEADER>";
        pAprLinexml = pAprLinexml + "<HEADER><NAME>" + strLang871 + "</NAME><WIDTH>160</WIDTH><COLNAME /></HEADER>";
        pAprLinexml = pAprLinexml + "</HEADERS><ROWS /></LISTVIEWDATA>";

        Resultxml = loadXMLString(pAprLinexml);

        if (lvAprLine.innerHTML != "") lvAprLine.innerHTML = "";

        var AprLine = new ListView();                           
        AprLine.SetID("AprLine");                               
        AprLine.SetMulSelectable(false);
        AprLine.SetTitleIdx(arrySubTab[1]);
        AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");
        AprLine.SetRowOnClick("lvAprLine_SelChange");
        AprLine.DataSource(Resultxml);                             
        AprLine.DataBind("lvAprLine");


    }
}

function RemoveDoc(pDocID, orgCompanyID) {
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/delDocInfo.do",
		data : {
				docID : pDocID,
				field  : "MUST",
				orgCompanyID : orgCompanyID 
				},
		success: function(xml){
			result = xml;
		}        			
	});
    
    if (result == "FALSE") {
        var pAlertContent = strLang872;
        OpenAlertUI(pAlertContent);
    }
}

// var getformcont_cross_dialogArguments = new Array();
// var getformcont_Cross_OpenWin = "";
function openForm() {
    var parameter = new Array();
    parameter[0] = arr_userinfo[4];
    parameter[1] = "000";
    var url = "/ezApprovalG/getFormCont.do";
    // var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
    // feature = feature + GetShowModalPosition(713, 570);
    //
    // getformcont_cross_dialogArguments[0] = parameter;
    // getformcont_cross_dialogArguments[1] = openForm_Complete;
    // getformcont_Cross_OpenWin = window.open(url, "getformcont_Cross", GetOpenWindowfeature(713, 570));
    //
    // try { getformcont_Cross_OpenWin.focus(); } catch (e) { }
    ezCommon_cross_dialogArguments[0] = parameter;
    showPopup(url, 713, 570, "getformcont_Cross", GetOpenWindowfeature(713, 570), openForm_Complete);
}

function openForm_Complete(ret) {
    hidePopup();
    formURL = ret[0];
    formDocType = ret[1];
    reformflag = ret["reformflag"];
    
    // 2021-01-21 심기영 오피스결재 추가
    var officeFlag = "";   
    // 2021-01-21 심기영 오피스결재 추가
    if(typeof ret[4] != "undefined") {
    	officeFlag = ret[4];
    }
    // 2021-01-21 심기영 오피스결재 추가
    if (formURL != "cancel") {
        openDraftUI("DRAFT", "",officeFlag);
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
    var formURL = GetAttribute(tr, "DATA3");
    var DocID = GetAttribute(tr, "DATA1");
    var orgCompanyID = GetAttribute(tr, "orgCompanyID");

    pArgument[0] = DocID;
    pArgument[1] = formURL;

    if (pListTypeValue == "4" || pListTypeValue == "97") {
        pArgument[2] = GetAttribute(tr, "DATA5");
        pArgument[3] = "VIEW";
        pArgument[4] = pSusinManagerFlag;
        pArgument[5] = GetAttribute(tr, "DATA7");
        pArgument[6] = "OPINION_SHOW";
        pArgument[7] = pListTypeValue;
    } else if (pListTypeValue != "7" && pListTypeValue != "8" && pListTypeValue != "9") {
        pArgument[2] = GetAttribute(tr, "DATA11").trim();
        pArgument[3] = GetAttribute(tr, "DATA12").trim();
        pArgument[4] = GetAttribute(tr, "DATA4").trim();
        pArgument[5] = GetAttribute(tr, "DATA2").trim();
        
        if (pListTypeValue != "5") {
            pArgument[6] = "OPINION_SHOW";
        } else {
            pArgument[6] = "OPINION_HIDE";
        }
        
        pArgument[7] = pListTypeValue;
    }

    var openLocation;
    // 20191210 ezd 확장자 빼기
    var formUrlExt = getOriginalFileExtension(formURL);

    if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
        if (formUrlExt === "hwp") {
        	if(useWebHWP == "NO") {
	            if (CrossYN() && isIE()) {
	            	openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
	            } else {
	            	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	            	showAlert(pAlertContent);
	                
	                return;
	            }
        	} else {
        		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
        	}
        }
        else {
            openLocation = "/ezApprovalG/contDocView.do";
        }
        openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(formURL) + "&formID=" + encodeURI(formID) + "&orgDocID=&sendType=" + GetAttribute(tr, "DATA5");
    }
    else {
    	// 2018.07.06 (KLIB) - ezd 확장자 처리
        if (formUrlExt === "hwp") {
        	if (useWebHWP == "NO") {
	            if (CrossYN() && isIE()) {
	            	openLocation = "/ezApprovalG/ezviewAprHWP.do";
	            } else {
	            	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	            	showAlert(pAlertContent);
	                
	                return;
	            }
        	} else {
        		var isGroupDoc = checkIsGroupDoc(encodeURI(DocID), orgCompanyID);
        		
        		if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) { // 일괄기안 문서를 여는 경우 (결재진행문서, 기안한문서 메뉴에서 접근 시 지원)
        			openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do";
        		} else {
        			openLocation = "/ezApprovalG/ezviewAprWHWP.do";
        		}
        	}
        }
        else {
            var isGroupDoc = checkIsGroupDoc(encodeURI(DocID), orgCompanyID);

            if (isGroupDoc == "Y") { // 일괄기안 문서를 여는 경우 (결재진행문서, 기안한문서 메뉴에서 접근 시 지원)
                openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do";
            } else {
        	    openLocation = "/ezApprovalG/aprDocView.do";
        	}
        }
        openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&docHref=" + encodeURI(pArgument[1]);
        openLocation = openLocation + "&opinionFlag=" + encodeURI(pArgument[2]) + "&docState=" + encodeURI(pArgument[3]) + "&listSusin=" + encodeURI(pArgument[4]) + "&oDoc=" + encodeURI(pArgument[5]);
        openLocation = openLocation + "&isOpinion=" + encodeURI(pArgument[6]);
        openLocation = openLocation + "&listType=" + encodeURI(pArgument[7]);
        openLocation = openLocation + "&CallBackType=" + escape(trim_Cross(type));
        openLocation = openLocation + "&ext=" + escape(trim_Cross(ext));
        openLocation = openLocation + "&orgCompanyID=" + orgCompanyID;
        if (shareUser = "shareUser") {
        	openLocation += "&pageType=admin";
        }
    }
    openwindow(openLocation, "", 880, 570);
}

function OpenReceiveAssignUI(pCurSelRow) {
    var parameter = pCurSelRow;
    var url = "/myoffice/ezApprovalG/ezAPRRECEIVE/ezReceiveAssignUI.htm";
    var feature = "status:no;dialogWidth:388px;dialogHeight:345px;edge:sunken;scroll:no";
    feature = feature + GetShowModalPosition(388, 345);
    var ret = window.showModalDialog(url, parameter, feature);

    getReceivedDocList();
}

function OpenReceiveDraftUI(pCurSelRow, pDraftFlag) {
    var openLocation;
    if (pCurSelRow != null) {
        if (pDraftFlag == "SUSIN") {
        	var pURL = GetAttribute(pCurSelRow, "DATA3");
            var pDocID = GetAttribute(pCurSelRow, "DATA1").trim();
            var docHref = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
            var isMht = docHref == "mht" || (docHref != "hwp" && g_RelayG_Type.toUpperCase() == "MHT");
            if (isMht) {
                openLocation = "";
                
                if (GetAttribute(pCurSelRow,"DATA15") == "001") {
                	openLocation = "/ezApprovalG/recevG.do";
                } else {
                	openLocation = "/ezApprovalG/recevGSusin.do";
                }
                
                openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag);
                openLocation = openLocation + "&uOrgID=" + encodeURI(GetAttribute(pCurSelRow, "DATA7"));
            } else {
            	if(useWebHWP == "NO") {
	                if (/chrome/i.test(navigator.userAgent)) {
	                     showAlert(strLang1103);
	                     return;
	            	 } else {
	            		if (docHref == "hwp" || g_RelayG_Type.toUpperCase() == "HWP") {
	            			openLocation = "/ezApprovalG/ezRecevGSusinHWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag) + "&uOrgID=" + encodeURI(GetAttribute(pCurSelRow, "DATA7"));
	                    }
	            	 }
            	} else {
            		openLocation = "/ezApprovalG/ezRecevGSusinWHWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag) + "&uOrgID=" + encodeURI(GetAttribute(pCurSelRow, "DATA7"));
            	}
            }
            openwindow(openLocation, "receive", 880, 550);
        } else {
            var pURL = GetAttribute(pCurSelRow, "DATA3");
            var pDocID = GetAttribute(pCurSelRow, "DATA1");
            var orgCompanyID = GetAttribute(pCurSelRow, "orgCompanyID");
            
            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
            	if(useWebHWP == "NO") {
	            	if (/chrome/i.test(navigator.userAgent)) {
	            		showAlert(strLang1103);
	            		return;
	            	} else {
	            		openLocation = "/ezApprovalG/ezDeptRecevUI_HWP.do";
	            	}
            	} else {
            		openLocation = "/ezApprovalG/ezDeptRecevUI_WHWP.do";
            	}
            } else if (approvalFlag == "G") {
            	openLocation = "/ezApprovalG/recevGDeptHapyui.do";
            } else {
            	openLocation = "/ezApprovalG/recev.do";
            }
            openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag) + "&orgCompanyID=" + encodeURI(orgCompanyID);
            openwindow(openLocation, "receive", 880, 550);
        }
    } else {
        var pAlertContent = strLang870;
        OpenAlertUI(pAlertContent);
        return;
    }
}

function OpenReceiveENDDraftUI(pCurSelRow, pDraftFlag) {

    if (pCurSelRow != null) {
        if (pDraftFlag.toUpperCase() == "REDRAFT") {
            var ret = CheckAprLineInfo(pCurSelRow);
            if (ret != "OK") {
                var pAlertContent = strLang863 + "<br>" +
								strLang864 + ret + strLang865;
                OpenAlertUI(pAlertContent);
                return;
            }
        }

        var pArgument = new Array();

        pArgument[0] = GetAttribute(pCurSelRow, "DATA1");        
        pArgument[1] = GetAttribute(pCurSelRow, "DATA2");

        var pURL = GetAttribute(pCurSelRow, "DATA3");
        var tmpDocState = GetAttribute(pCurSelRow, "DATA12");
        
        var openLocation = "";
        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
            if (!useWebHWP) {
                openLocation = "/ezApprovalG/ezRecevGSusinHWP.do";
                openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&uOrgID=" + encodeURI(pArgument[1]) + "&isReDraft=" + encodeURI("Y") + "&draftFlag=" + encodeURI(pDraftFlag);
            } else {
                openLocation = "/ezApprovalG/ezRecevGSusinWHWP.do";
                openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&uOrgID=" + encodeURI(pArgument[1]) + "&isReDraft=" + encodeURI("Y") + "&draftFlag=" + encodeURI(pDraftFlag);
            }
        }
        else {
        	//docstate가 012(합의) 일 경우에 부서합의 페이지 띄우도록 수정 2019-02-27 홍대표
        	if (tmpDocState == strDocState12) {
        		openLocation = "/ezApprovalG/recevGDeptHapyui.do";
        	} else {
        		var docType = GetAttribute(pCurSelRow, "DATA15");
        		if (docType == "001") {
        			openLocation = "/ezApprovalG/recevG.do";
        		} else {
        			openLocation = "/ezApprovalG/recevGSusin.do";
        		}
        	}

            openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&uOrgID=" + encodeURI(pArgument[1]) + "&isReDraft=" + encodeURI("Y") + "&draftFlag=" + encodeURI(pDraftFlag);
        }

        if (g_selReturn == "Y" && (pListTypeValue == "1" || pListTypeValue == "11")) {
            openLocation = openLocation + "&RetFlag=" + g_selReturn;
            g_selReturn = "N";
        }

        openwindow(openLocation, "receive", 880, 550);
    }
    else {
        var pAlertContent = strLang870;
        OpenAlertUI(pAlertContent);
        return;
    }
}

function OpenReceiveDistributeUI(pCurSelRow) {
    var parameter = pCurSelRow;
    var url = "/ezApprovalG/ezReceiveDistributeUI.do";
    var feature = "status:no;dialogWidth:800px;dialogHeight:600px;edge:sunken;scroll:no";
    feature = feature + GetShowModalPosition(453, 410);
    var ret = window.showModalDialog(url, parameter, feature);

    getReceivedDocList();
}

var apropinion_cross_dialogArguments = new Array();
var temppSelectedRow;
function OpenOpinionUI(pSelectedRow, pOpinionFlag) {
    try {
        var parameter = new Array();
        parameter[0] = GetAttribute(pSelectedRow, "DATA1");
        parameter[1] = pOpinionFlag;
        parameter[2] = KuyjeType;
        parameter[3] = "";
        temppSelectedRow = pSelectedRow;
        parameter[98] = GetAttribute(pSelectedRow, "ORGCOMPANYID");
        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
        parameter[99] = ext;
        
        var url = "/ezApprovalG/aprOpinion.do";

        apropinion_cross_dialogArguments[0] = parameter;
        apropinion_cross_dialogArguments[1] = OpenOpinionUI_Complete;

        var OpenWin = window.open(url, "AprOpinion_Cross", GetOpenWindowfeature(530, 520));
        try { OpenWin.focus(); } catch (e) { }
    } catch (e) {
        showAlert("OpenOpinionUI :: " + e.description);
    }
}

function OpenOpinionUI_Complete(ret) {
    if (ret != "cancel") {
        if (pListTypeValue == "4" || pListTypeValue == "97") {
            switch (GetAttribute(temppSelectedRow, "DATA9")) {
                case "012":
                    setHeSongHapyuiDocInfo(temppSelectedRow);
                    break;
                case "011":
                    setHeSongDocInfo(temppSelectedRow);
                    break;
            }
        }
        else {
            switch (GetAttribute(temppSelectedRow, "DATA12")) {
                case "012":
                    setHeSongHapyuiDocInfo(temppSelectedRow);
                    break;
                case "011":
                    setHeSongDocInfo(temppSelectedRow);
                    break;
            }
        }
    }
}

function openOpinionUI_New(pSelectedRow, pOpinionType) {
	try {
		var parameter = new Array();
		parameter[0] = GetAttribute(pSelectedRow, "DATA1");//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = "";			//DRAFTFLAG 
		parameter[3] = GetAttribute(pSelectedRow, "DATA9");//DOCSTATE
		parameter[4] = GetAttribute(pSelectedRow, "ORGCOMPANYID");//ORGCOMPANYID
		parameter[99] = ext;		//EXT
		
		temppSelectedRow = pSelectedRow;
		
		apropinion_cross_dialogArguments[0] = parameter;
		apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete;
		
		var url = "/ezApprovalG/aprOpinionNew.do";
		var OpenWin = window.open(url, "AprOpinion_Cross", GetOpenWindowfeature(530, 520));
        try { OpenWin.focus(); } catch (e) { }
	} catch (e) {
		showAlert("openOpinionUI_New ::: " + e.description);
	}
}
function openOpinionUI_New_Complete(ret) {
	try {
		if (ret != "cancel") {
	        if (pListTypeValue == "4" || pListTypeValue == "97") {
	            switch (GetAttribute(temppSelectedRow, "DATA9")) {
	                case "012":
	                case "014":
	                    setHeSongHapyuiDocInfo(temppSelectedRow);
	                    break;
	                case "011":
	                    setHeSongDocInfo(temppSelectedRow);
	                    break;
	            }
	        }
	        else {
	            switch (GetAttribute(temppSelectedRow, "DATA12")) {
	                case "012":
	                case "014":
	                    setHeSongHapyuiDocInfo(temppSelectedRow);
	                    break;
	                case "011":
	                    setHeSongDocInfo(temppSelectedRow);
	                    break;
	            }
	        }
	    }
	} catch (e) {
		showAlert("openOpinionUI_New_Complete ::: " + e.description);
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

        if (pListTypeValue == "4" || pListTypeValue == "97")
            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", GetAttribute(pSelectedRow, "DATA2"));
        else {
            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", "1");
        }

        xmlhttp.open("POST", "/ezApprovalG/setHeSongHapyuiDocInfo.do", false);
        xmlhttp.send(xmlpara);
        
        if (xmlhttp != null && xmlhttp.readyState == 4) {
       	 if (xmlhttp.status == 200) {
       		 var pAlertContent = strLang878;
             OpenAlertUI(pAlertContent, "", "OPEN");
             openergetDocInfo();
       	 } else {
       		 var pAlertContent = strLang740;
             OpenAlertUI(pAlertContent, "", "OPEN");
             return;
       	 }
       } 
    } catch (e) {
        showAlert("setHeSongHapyuiDocInfo :: " + e.description);
    }
}

function setHeSongDocInfo(pCurSelRow) {
	var result = "";
	var pReceiveSN = "";
	var pDocState = "";
	
	if (pListTypeValue == "4" || pListTypeValue == "97") {
		pReceiveSN = GetAttribute(pCurSelRow, "DATA2");
	} else {
		pReceiveSN = GetAttribute(pCurSelRow, "DATA9");
	}
	
	if (pCurSelRow.cells[2].innerText == strLang879) {
		pDocState = "REBACK";
	} else {
		pDocState = "RECEIVE";
	}
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/setHeSongDocInfo.do",
		data : {
			docID : GetAttribute(pCurSelRow, "DATA1"),
			receiveSN : pReceiveSN,
			deptID  : arr_userinfo[4],
			docState : pDocState,
			userID : pUserID,
			userName : arr_userinfo[11],
			userName2 : arr_userinfo[12]
		},
		success: function(xml){
			result = xml;
		}, error: function() {
			 var pAlertContent = strLang740;
		        OpenAlertUI(pAlertContent, "", "OPEN");
		}       			
	});

    var RtnVal = getNodeText(loadXMLString(result));

    if (RtnVal != "FALSE") {
    	 var pAlertContent = strLang878;
         OpenAlertUI(pAlertContent, "", "OPEN");
         openergetDocInfo();
    }
}


function getAprDocAproveInfo(tr) {
    var pDocID;
    var pFlag;
    var RtnVal = "";
    if (pSelMenu == "hyubjo" || pSelMenu == "gamsa")
        pDocID = GetAttribute(tr, "DATA7");
    else
        pDocID = GetAttribute(tr, "DATA1");
    
    var orgCompanyID = GetAttribute(tr, "orgCompanyID");

    if (pDocInfoValue == "4") {
        if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
        	pFlag = "END";
    	} else if (pListTypeValue == "21") {
        	pFlag = "TMP";
    	} else if (pListTypeValue == "10" || pListTypeValue == "99") {
    		pDocID = GetAttribute(tr, "DATA2");
    		pFlag = "END";
        } else {
        	pFlag = "APR";
        }

        if (GetAttribute(tr, "DATA12") == "017") {
       	   $.ajax({
       			type : "POST",
       			dataType : "text",
       			async : false,
       			url : "/ezApprovalG/getLineMode.do",
       			data : {
       					docID : pDocID
       					},
       			success: function(xml){
       				pFlag = xml;
       			}        			
       	  });
       }
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getTotalAttachInfo.do",
    		data : {
    				docID : pDocID,
    				mode  : pFlag,
    				orgCompanyID : orgCompanyID
    				},
    		success: function(xml){
    			RtnVal = xml;
    		}        			
    	});
    }
    else if (pDocInfoValue == "3") {
        if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
        	pFlag = "END";
        } else if (pListTypeValue == "21") {
        	pFlag = "TMP";
        } else if (pListTypeValue == "10" || pListTypeValue == "99") {
        	pFlag = "APR";
    	} else {
    		pFlag = "APR";
    	}

        if (GetAttribute(tr, "DATA12") == "017") {
      	   $.ajax({
      			type : "POST",
      			dataType : "text",
      			async : false,
      			url : "/ezApprovalG/getLineMode.do",
      			data : {
      					docID : pDocID
      					},
      			success: function(xml){
      				pFlag = xml;
      			}        			
      	  });
      }
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getOpinionInfo.do",
    		data : {
    				docID : pDocID,
    				mode  : pFlag,
    				orgCompanyID : orgCompanyID
    				},
    		success: function(xml){
    			RtnVal = xml;
    		}
    	});
    }
    else if (pDocInfoValue == "2") {
        if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
        	pFlag = "END";
        } else if (pListTypeValue == "21") {
        	pFlag = "TMP";
        } else if (pListTypeValue == "10" || pListTypeValue == "99") {
    		pDocID = GetAttribute(tr, "DATA2");
    		pFlag = "END";
    	} else {
    		pFlag = "APR";
    	}

        if (GetAttribute(tr, "DATA12") == "017") {
     	   $.ajax({
     			type : "POST",
     			dataType : "text",
     			async : false,
     			url : "/ezApprovalG/getLineMode.do",
     			data : {
     					docID : pDocID
     					},
     			success: function(xml){
     				pFlag = xml;
     			}        			
     	  });
     }
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getReceiptinfo.do",
    		data : {
    				docID : pDocID,
    				mode  : pFlag,
    				orgCompanyID : orgCompanyID
    				},
    		success: function(xml){
    			RtnVal = xml;
    		}
    	});
    }
    else if (pDocInfoValue == "5") {
    	if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9" || pListTypeValue == "99" || pListTypeValue == "10" || pListTypeValue == "98") {
    		pDocID = GetAttribute(tr, "DATA2");
    		pFlag = "END";
    	} else if (pListTypeValue == "21") {
    		pFlag = "TMP";
    	} else {
    		pFlag = "APR";
    	}
    	
    	 if (GetAttribute(tr, "DATA12") == "017") {
        	   $.ajax({
        			type : "POST",
        			dataType : "text",
        			async : false,
        			url : "/ezApprovalG/getLineMode.do",
        			data : {
        					docID : pDocID
        					},
        			success: function(xml){
        				pFlag = xml;
        			}        			
        	  });
        }
    	 
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getCirculationinfo.do",
    		data : {
    			docID : pDocID,
    			mode  : pFlag,
    			orgCompanyID : orgCompanyID
    		},
    		success: function(xml){
    			RtnVal = xml;
    		}
    	});
    }

    if (document.getElementById("lvAprLine").innerHTML != "") document.getElementById("lvAprLine").innerHTML = "";

    if (RtnVal == "NOTPERMISSION") {
        document.getElementById("lvAprLine").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
        document.getElementById("lvAprLine").style.textAlign = "center";
        return;
    }

    var AprLine = new ListView();                           
    AprLine.SetID("AprLine");                               
    AprLine.SetMulSelectable(false);                        
//    AprLine.SetTitleIdx(arrySubTab[pDocInfoValue]);
    AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");      
    AprLine.DataSource(loadXMLString(RtnVal));                             
    AprLine.DataBind("lvAprLine");
}


var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction, type) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        ezCommon_cross_dialogArguments[0] = parameter;
        if (type == undefined && CompleteFunction != undefined) {
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
            ezCommon_cross_dialogArguments[1] = CompleteFunction;
            DivPopUpShow(330, 205, url);
        }
        else if (type == undefined && CompleteFunction == undefined) {
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
            ezCommon_cross_dialogArguments[1] = OpenAlertUI_Complete;
            DivPopUpShow(330, 205, url);
        }
        else if (type != undefined && CompleteFunction != "") {
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
            ezapralert_cross_dialogArguments[2] = true;
            ezCommon_cross_dialogArguments[1] = CompleteFunction;
            ezCommon_cross_dialogArguments[2] = true;
            var OpenWin = window.open(url, "ezAPRALERT_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
        else if (type != undefined && CompleteFunction == "") {
        	ezapralert_cross_dialogArguments[2] = true;
        	ezCommon_cross_dialogArguments[2] = true;
            var OpenWin = window.open(url, "ezAPRALERT_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}

var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction, type) {
	var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";
    if (CrossYN() && (ext != 'hwp' || CompleteFunction != "")) { // 크롬에서 반송문서 대장등록 할수있게 하기위해  CompleteFunction != "" 추가 2018-08-07 강민수92
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (type == undefined && CompleteFunction != undefined) {
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
            DivPopUpShow(330, 205, url);
        }
        else if (type == undefined && CompleteFunction == undefined) {
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
            DivPopUpShow(330, 205, url);
        }
        else if (type != undefined && CompleteFunction != "") {
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
            ezapropinion_cross_dialogArguments[2] = true;
            var OpenWin = window.open(url, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
        else if (type != undefined && CompleteFunction == "") {
        	ezapropinion_cross_dialogArguments[2] = true;
            var OpenWin = window.open(url, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
    } else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
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

        // window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
        showPopupSlide(wfileLocation, width, heigth, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left, hidePopupSlide);
    }
    catch (e) {
        showAlert("openwindow :: " + e.description);
    }
}

function openergetDocInfo() {
    if (CallPage == "Left") return;

    try {
    	//이전에 선택된 row를 유지하기 위한 Flag
    	selRowChangeFlag = true;
        if (pListTypeValue == "6")
            getSimsaDocList();
        else if (pListTypeValue == "4" || pListTypeValue == "5" || pListTypeValue == "97")
            getReceivedDocList();
        else if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
            typeof adminSendOutFlag !== 'undefined' ? getAdminSendOutDocList() : getSendOutDocList();
        else
            getDocList();

        try {
        	parent.frames["left"].getAprCount();
		} catch (e) {
			// LEFT메뉴 없는 연동일시 넘어가기
			// TODO: handle exception
		}
    } catch (e) {
        showAlert("openergetDocInfo :: " + e.description);
    }
}


var totalPages;
var BlockSize = 10;
var totalPage = "";
function td_Create1(strtext) {
    document.getElementById("tblPageRayer").innerHTML = strtext;
}

function makePageSelPage() {
    var strtext;
    var PagingHTML = "";
    document.getElementById("tblPageRayer").innerHTML = "";

    var period;
    if (document.getElementById("sel_year").value.toLowerCase() == "all") {
    	var nowyear = nowDate.substring(0,4);
        var nowmonth = parseInt(nowDate.substring(5,7));
        var nowday = parseInt(nowDate.substring(8,10));
        
        if (approvalFlag == "G") { //2018-10-01 김보미 - G버전일때 추가.
        	if (SearchCond[3] != null && SearchCond[3] != "") {
        		period = getDatePeriod(userLang, SearchCond[3], SearchCond[4], SearchCond[5], SearchCond[6], SearchCond[7], SearchCond[8]);
        	} else if (SearchCond[9] != null && SearchCond[9] != "") {
        		period = getDatePeriod(userLang, SearchCond[9], SearchCond[10], SearchCond[11], SearchCond[12], SearchCond[13], SearchCond[14]);
        	} else if (SearchCond[25] != "" && SearchCond[25] != null) {
        		period = getDatePeriod(userLang, SearchCond[25].substring(0, 4), parseInt(SearchCond[25].substring(5, 7)), parseInt(SearchCond[25].substring(8, 10)), SearchCond[26].substring(0, 4), parseInt(SearchCond[26].substring(5, 7)), parseInt(SearchCond[26].substring(8, 10)));
        	} else {
        		period = getDatePeriod(userLang, (nowyear - 1), nowmonth, nowday, nowyear, nowmonth, nowday);
        	}
        } else {
        	if (SearchCond[5] != null && SearchCond[5] != "" ) {
        		//2018-09-27 배현상, 주간, 월간검색 시 날짜 표기오류 개선 
        		period = getDatePeriod(userLang, SearchCond[5].substring(0, 4), parseInt(SearchCond[5].substring(5, 7)), parseInt(SearchCond[5].substring(8,10)), SearchCond[6].substring(0, 4), parseInt(SearchCond[6].substring(5, 7)), parseInt(SearchCond[6].substring(8, 10)));
        	} else if (SearchCond[3] != "" && SearchCond[3] != null) {
        		period = getDatePeriod(userLang, SearchCond[3].substring(0, 4), parseInt(SearchCond[3].substring(5, 7)), parseInt(SearchCond[3].substring(8,10)), SearchCond[4].substring(0, 4), parseInt(SearchCond[4].substring(5, 7)), parseInt(SearchCond[4].substring(8, 10)));
        	} else if (SearchCond[25] != "" && SearchCond[25] != null) {
        		period = getDatePeriod(userLang, SearchCond[25].substring(0, 4), parseInt(SearchCond[25].substring(5, 7)), parseInt(SearchCond[25].substring(8,10)), SearchCond[26].substring(0, 4), parseInt(SearchCond[26].substring(5, 7)), parseInt(SearchCond[26].substring(8, 10)));
        	} else {
        		period = getDatePeriod(userLang, (nowyear - 1), nowmonth, nowday, nowyear, nowmonth, nowday);
        	}
        }
    } else {
    	period = getDatePeriod(userLang, document.getElementById("sel_year").value, 1, 1, document.getElementById("sel_year").value, 12, 31);
    }
    //document.getElementById("presentcell").innerHTML = " - " + localValue;
    document.getElementById("TitleInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color' style='font-weight:bold;'>" + pTotalCnt + "</span>&nbsp;/ " + period;

    try {
    	if (ViewLeftCount == "YES" && ($("#sel_status option:selected").val() == "ALL" || $("#sel_status option:selected").val() == undefined)) {
    		if (pTotalCnt == "0") {    			
    			pTotalCnt = "";
    		}
    		
    		switch (pListTypeValue) {
    		case "1":
    			parent.frames["left"].document.getElementById("count1").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
    		case "2":
    			parent.frames["left"].document.getElementById("count3").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
    		case "3":
    			parent.frames["left"].document.getElementById("count2").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
    		case "4":
    			parent.frames["left"].document.getElementById("count4").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
    		case "6":
    			parent.frames["left"].document.getElementById("count6").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
    		case "7":
    			parent.frames["left"].document.getElementById("count7").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
    		case "21":
    			parent.frames["left"].document.getElementById("count21").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
            case "24":
                parent.frames["left"].document.getElementById("count24").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
                break;
    		case "99":
    			parent.frames["left"].document.getElementById("count99").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
    		case "11":
    			parent.frames["left"].document.getElementById("count11").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
    			break;
            case "97":
                parent.frames["left"].document.getElementById("count97").innerHTML = "&nbsp;&nbsp;" + pTotalCnt;
                break;
    		}
    	}
	} catch (e) {
		// LEFT메뉴 없는 연동일시 넘어가기
		// TODO: handle exception
	}

    strtext = "<div class='pagenavi'>";
    PagingHTML += strtext;
    if (totalPage > 1 && pageNum != 1) {
        // strtext = "<span class='btnimg'><a onclick= 'return goToPageByNum(1)'>";
        // strtext = strtext + "<img src='/images/kr/cm/btn_p_prev.gif' /></a></span>";
        strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
        PagingHTML += strtext;
    } else {
        // strtext = "<span class='btnimg'><a >";
        // strtext = strtext + "<img src='/images/kr/cm/btn_p_prev01.gif' /></a></span>";
        strtext = "<span class='btnimg first disabled'></span>";
        PagingHTML += strtext;
    }
    if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
            // strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'>";
            // strtext = strtext + "<img src='/images/kr/cm/btn_prev.gif' /></span>";
            strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
            PagingHTML += strtext;
        }
        else {
            // strtext = "<span class='btnimg'>";
            // strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif' /></span>";
            strtext = "<span class='btnimg prev disabled'></span>";
            PagingHTML += strtext;
        }
    }
    else {
        // strtext = "<span class='btnimg'>";
        // strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif' /></span>";
        strtext = "<span class='btnimg prev disabled'></span>";
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
            strtext = "<span onclick = 'goToPageByNum(" + i + ")'>" + i + "</span>";
            PagingHTML += strtext;
        }
    }
    if (i == 1) {
    	strtext = "<span class='on'>" + i + "</span>";
        PagingHTML += strtext;
    }
    if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
            // strtext = "<span class='btnimg' onclick='return selafterBlock()'>";
            // strtext = strtext + "<img src='/images/kr/cm/btn_next.gif'/></span>";
            strtext = "<span class='btnimg next' onclick='return selafterBlock()'></span>";
            PagingHTML += strtext;
        }
        else {
            // strtext = "<span class='btnimg'>";
            // strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif'/></span>";
            strtext = "<span class='btnimg next disabled'></span>";

            PagingHTML += strtext;
        }
    }
    else {
        // strtext = "<span class='btnimg'>";
        // strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif'/></span>";
        strtext = "<span class='btnimg next disabled'></span>";
        PagingHTML += strtext;
    }
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        // strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'>";
        // strtext = strtext + "<img src='/images/kr/cm/btn_n_next.gif'/></span>";
        strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
        PagingHTML += strtext;
    }
    else {
        // strtext = "<span class='btnimg'>";
        // strtext = strtext + "<img src='/images/kr/cm/btn_n_next01.gif' /></span>";
        strtext = "<span class='btnimg last disabled'></span>";
        PagingHTML += strtext;
    }
    PagingHTML += "</div>";
    td_Create1(PagingHTML);
    
    listLoading(false);	// 20201211 조진호 로딩바 display:none
}
function goToPageByNum(Value) {
    currentpage = Value;
    pageNum = currentpage;
    makePageSelPage();
    window_onload();
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

function setbuttonenable() {
	var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];
    var pFunctionType = GetAttribute(tr, "DATA10");
    var orgCompanyID = GetAttribute(tr, "ORGCOMPANYID");
    
    document.getElementById("tbtnAssign").style.display = "none";
    document.getElementById("tbtnDeptRecevList").style.display = "none";
    if (pListTypeValue == "1") {
        document.getElementById("tbtnApproveALL").style.display = "";
        document.getElementById("tbtnReceiptAll").style.display = "none";
        document.getElementById("tbtnRJunkyulAll").style.display = "none";
        document.getElementById("tbtnAssignList").style.display = "none";
        document.getElementById("tbtnJiJungAll").style.display = "none";
        document.getElementById("tbtnBebuAll").style.display = "none";
    } else if (pListTypeValue == "4" || pListTypeValue == "97") {
    	document.getElementById("tbtnApproveALL").style.display = "none";
    	document.getElementById("tbtnReceiptAll").style.display = "";
    	document.getElementById("tbtnRJunkyulAll").style.display = "";
        if (assignPermission == "Y" && pListTypeValue == "4") { // 지정목록 > 수발신담당자, 기록물관리자에게만 표출
            document.getElementById("tbtnAssignList").style.display = "";
        } else {
            document.getElementById("tbtnAssignList").style.display = "none";
        }
        document.getElementById("tbtnJiJungAll").style.display = "";
        document.getElementById("tbtnBebuAll").style.display = "";
    }
    else {
    	// apprGManage.jsp에서 공람버튼의 기본 스타일을 display = "none"으로 수정 (공람할문서 메뉴에서만 표출)
        // document.getElementById("tbtnGongRam").style.display = "none";

        document.getElementById("tbtnApprove2").style.display = "none";
        document.getElementById("tbtnApproveALL").style.display = "none";
        document.getElementById("tbtnReceiptAll").style.display = "none";
        document.getElementById("tbtnRJunkyulAll").style.display = "none";
        document.getElementById("tbtnAssignList").style.display = "none";
        document.getElementById("tbtnJiJungAll").style.display = "none";
        document.getElementById("tbtnBebuAll").style.display = "none";
    }

    /*if (pListTypeValue == "8")
        document.getElementById("tbar1").style.display = "none";
    else
        document.getElementById("tbar1").style.display = "";*/

    if (pListTypeValue != 1 && pListTypeValue != 4 && pListTypeValue != 5 && pListTypeValue != 10 && pListTypeValue != 99 && pListTypeValue != 11 && pListTypeValue != 24 && pListTypeValue != "97") {
    	document.getElementById("tbtnRedraft").style.display = "none";		
        //SwapImage(document.getElementById("btnRedraft"), "dis");
        document.getElementById("tbtnRemoveDoc").style.display = "none";
        document.getElementById("tbtnApprove").style.display = "none";		
        document.getElementById("tbtnApprove1").style.display = "none";
        document.getElementById("tbtnApprove2").style.displayd = "none";
        //document.getElementById("tbtnApproveALL").style.display = "none";
        document.getElementById("tbtnReceipt").style.display = "none";
        document.getElementById("tbtnNonElecRec").style.display = "none";
        document.getElementById("tbtnSimsa").style.display = "none";
        document.getElementById("tbtnGongRam").style.display = "none";
        document.getElementById("tbtnGongRamALL").style.display = "none";

        if (oArrRows != null) {
            document.getElementById("tbtnViewDoc").style.display = "";
        }
        else {
            document.getElementById("tbtnViewDoc").style.display = "none";
        }

        if (pListTypeValue == "6") {
            if (oArrRows.length > 0) {
                if (GetAttribute(tr, "DATA10") == "002") {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";		
                    document.getElementById("tbtnSimsa").style.display = "";
                } else if (GetAttribute(tr, "DATA10") == "004") {
                    document.getElementById("tbtnRemoveDoc").style.display = "";	
                    document.getElementById("tbtnSimsa").style.display = "none";
                } else {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";		
                    document.getElementById("tbtnSimsa").style.display = "none";
                }
            } else {
                document.getElementById("tbtnRemoveDoc").style.display = "none";			
                document.getElementById("tbtnSimsa").style.display = "none";
            }
            document.getElementById("tbtnDraft").style.display = "";
        } else if (pListTypeValue == "7") {
            document.getElementById("tbtnReceipt").style.display = "";
            document.getElementById("tbtnNonElecRec").style.display = "none";
        }
        document.getElementById("tbtnRegList").style.display = "none";
        document.getElementById("tbtnLinkDraft").style.display = "none";

        if (pListTypeValue == 21) {//임시보관함
            document.getElementById("tbtnDraft").style.display = "";      
            document.getElementById("tbtnRedraft").style.display = "";
            document.getElementById("tbtnRemoveDoc").style.display = "";
            document.getElementById("tbtnTotalSave").style.display = "none";
        } else {
            document.getElementById("tbtnTotalSave").style.display = "";
        }
        
        if (pListTypeValue == "2") {
        	if (oArrRows.length > 0) {
        		pFunctionType = GetAttribute(tr, "DATA10");
                if (pFunctionType == "004" || pFunctionType == "015" || pFunctionType == "006") {
                    document.getElementById("tbtnRemoveDoc").style.display = "";
                } else {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                }
            } else {
                document.getElementById("tbtnRemoveDoc").style.display = "none";
            }
        }
    } else if (pListTypeValue == 1 || pListTypeValue == 10 || pListTypeValue == 99 || pListTypeValue == 11 || pListTypeValue == 24) {
        document.getElementById("tbtnTotalSave").style.display = "";
        document.getElementById("tbtnSimsa").style.display = "none";
        //document.getElementById("tbtnGongRam").style.display = "";
        if (oArrRows.length > 0) {
            pFunctionType = GetAttribute(tr, "DATA10");
            document.getElementById("tbtnLinkDraft").style.display = "none";

            //20130311 cpno.64
            if (GetAttribute(tr, "DATA12") == "015" && pListTypeValue == 99) {
            	document.getElementById("tbtnGongRam").style.display = "";
            	document.getElementById("tbtnGongRamALL").style.display = "";
            }
            else {
            	document.getElementById("tbtnGongRam").style.display = "none";
            	document.getElementById("tbtnGongRamALL").style.display = "none";
            }

            if (pFunctionType == "001") {
                document.getElementById("tbtnDraft").style.display = "";
                //SwapImage(document.getElementById("btnDraft"), "");
                //document.getElementById("tbtnLinkDraft").style.display = "";
                document.getElementById("tbtnRedraft").style.display = "none";
                //SwapImage(document.getElementById("btnRedraft"), "dis");
                document.getElementById("tbtnRemoveDoc").style.display = "none";
                document.getElementById("tbtnApprove").style.display = "none";
                document.getElementById("tbtnApprove1").style.display = "none";
                document.getElementById("tbtnApprove2").style.display = "none";
                //document.getElementById("tbtnApproveALL").style.display = "none";
                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnNonElecRec").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
            } else if (GetAttribute(tr, "DATA12") == "015") {
                document.getElementById("tbtnDraft").style.display = "";
                //SwapImage(document.getElementById("btnDraft"), "");
                document.getElementById("tbtnLinkDraft").style.display = "none";
                document.getElementById("tbtnRedraft").style.display = "none";
                //SwapImage(document.getElementById("btnRedraft"), "dis");
				if (pListTypeValue == "10") {
	                document.getElementById("tbtnRemoveDoc").style.display = "";
				} else {
	                document.getElementById("tbtnRemoveDoc").style.display = "none";
				}
                document.getElementById("tbtnApprove").style.display = "none";
                document.getElementById("tbtnApprove1").style.display = "none";
                document.getElementById("tbtnApprove2").style.display = "none";
                //document.getElementById("tbtnApproveALL").style.display = "none";
                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnNonElecRec").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
            } else if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
                if (pFunctionType == "004")
                	if(approvalFlag == "G") {
                		document.getElementById("tbtnRegList").style.display = "";
                	} else {
                		document.getElementById("tbtnRegList").style.display = "none";
                	}
                else
                    document.getElementById("tbtnRegList").style.display = "none";

                document.getElementById("tbtnDraft").style.display = "";
                //SwapImage(document.getElementById("btnDraft"), "");
                document.getElementById("tbtnLinkDraft").style.display = "none";
                document.getElementById("tbtnRedraft").style.display = "";
                //SwapImage(document.getElementById("btnRedraft"), "");
                document.getElementById("tbtnApprove").style.display = "none";
                document.getElementById("tbtnApprove1").style.display = "none";
                document.getElementById("tbtnApprove2").style.display = "none";
                //document.getElementById("tbtnApproveALL").style.display = "none";
                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnNonElecRec").style.display = "none";

                if (GetAttribute(tr, "DATA9") != "0") {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                } else if (GetAttribute(tr, "DATA12") == "011" || GetAttribute(tr, "DATA12") == "012") {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                } else {
                    document.getElementById("tbtnRemoveDoc").style.display = "";
                }
            } else {
                document.getElementById("tbtnDraft").style.display = "";
                //SwapImage(document.getElementById("btnDraft"), "");
                document.getElementById("tbtnRedraft").style.display = "none";
                //SwapImage(document.getElementById("btnRedraft"), "dis");
                document.getElementById("tbtnRemoveDoc").style.display = "none";
                document.getElementById("tbtnApprove").style.display = "";
                if (pListTypeValue == "11") {
                	document.getElementById("tbtnApprove1").style.display = "none";
                } else {
//                	document.getElementById("tbtnApprove1").style.display = "";
                }
                //document.getElementById("tbtnApproveALL").style.display = "";

                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnNonElecRec").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
                document.getElementById("tbtnLinkDraft").style.display = "none";
            }
            document.getElementById("tbtnViewDoc").style.display = "";
        } else {
            document.getElementById("tbtnDraft").style.display = "";
            //SwapImage(document.getElementById("btnDraft"), "");
            document.getElementById("tbtnRedraft").style.display = "none";
            //SwapImage(document.getElementById("btnRedraft"), "dis");
            document.getElementById("tbtnRemoveDoc").style.display = "none";
            document.getElementById("tbtnApprove").style.display = "none";
            document.getElementById("tbtnApprove1").style.display = "none";
            document.getElementById("tbtnApprove2").style.display = "none";
            document.getElementById("tbtnApproveALL").style.display = "none";
            document.getElementById("tbtnReceipt").style.display = "none";
            document.getElementById("tbtnNonElecRec").style.display = "none";
            document.getElementById("tbtnViewDoc").style.display = "none";
            document.getElementById("tbtnRegList").style.display = "none";
            document.getElementById("tbtnLinkDraft").style.display = "none";
            document.getElementById("tbtnApproveALL").style.display = "none";
            document.getElementById("tbtnGongRam").style.display = "none";
            document.getElementById("tbtnGongRamALL").style.display = "none";
        }
    } else {
        document.getElementById("tbtnSimsa").style.display = "none";
        
		if (approvalFlag == "G") {
			if((pListTypeValue == "4" || pListTypeValue == "97") && (useHWP == 'YES' || pNonElecRecType.toUpperCase() == "MHT")) {
				document.getElementById("tbtnNonElecRec").style.display = "";
			}else{
                var ElecElement = document.getElementById("tbtnNonElecRec");
                if (ElecElement) {
                    ElecElement.style.display = "none";
                }
            }
		}
        
        //20130311 cpno.64
        document.getElementById("tbtnGongRam").style.display = "none";
        document.getElementById("tbtnGongRamALL").style.display = "none";

        if (oArrRows.length != 0) {
            pFunctionType = GetAttribute(tr, "DATA10");
            if (pFunctionType == "011" || pFunctionType == "012" || pFunctionType == "014") {
                document.getElementById("tbtnDraft").style.display = "";
                //SwapImage(document.getElementById("btnDraft"), "");
                document.getElementById("tbtnLinkDraft").style.display = "none";
                document.getElementById("tbtnRedraft").style.display = "none";
                //SwapImage(document.getElementById("btnRedraft"), "dis");
                document.getElementById("tbtnRemoveDoc").style.display = "none";
                document.getElementById("tbtnApprove").style.display = "none";
                document.getElementById("tbtnApprove1").style.display = "none";
                document.getElementById("tbtnApprove2").style.display = "none";
                //document.getElementById("tbtnApproveALL").style.display = "none";
                document.getElementById("tbtnReceipt").style.display = "";
                document.getElementById("tbtnRegList").style.display = "none";
            } else if (pFunctionType == "015") {
                document.getElementById("tbtnDraft").style.display = "";
                //SwapImage(document.getElementById("btnDraft"), "");
                document.getElementById("tbtnLinkDraft").style.display = "none";
                document.getElementById("tbtnRedraft").style.display = "none";
                //SwapImage(document.getElementById("btnRedraft"), "dis");
                document.getElementById("tbtnRemoveDoc").style.display = "";
                document.getElementById("tbtnApprove").style.display = "none";
                document.getElementById("tbtnApprove1").style.display = "none";
                document.getElementById("tbtnApprove2").style.display = "none";
                //document.getElementById("tbtnApproveALL").style.display = "none";
                document.getElementById("tbtnReceipt").style.display = "none";
                //document.getElementById("tbtnNonElecRec").style.display = "";
                
                if(approvalFlag == "G") {
                	document.getElementById("tbtnRegList").style.display = "";
                } else {
                	document.getElementById("tbtnRegList").style.display = "none";
                }
            }
            document.getElementById("tbtnViewDoc").style.display = "";
        } else {
            document.getElementById("tbtnDraft").style.display = "";
            //SwapImage(document.getElementById("btnDraft"), "");
            document.getElementById("tbtnRedraft").style.display = "none";
            //SwapImage(document.getElementById("btnRedraft"), "dis");
            document.getElementById("tbtnRemoveDoc").style.display = "none";
            document.getElementById("tbtnApprove").style.display = "none";
            document.getElementById("tbtnApprove1").style.display = "none";
            document.getElementById("tbtnApprove2").style.display = "none";
            //document.getElementById("tbtnApproveALL").style.display = "none";
            document.getElementById("tbtnReceipt").style.display = "none";
            document.getElementById("tbtnViewDoc").style.display = "none";
            document.getElementById("tbtnRegList").style.display = "none";
            document.getElementById("tbtnLinkDraft").style.display = "none";
        }
    }

    if (oArrRows.length != 0) {
        if ((pListTypeValue == 4 || pListTypeValue == 97) && tr.getAttribute("DATA7") != "" && tr.getAttribute("DATA9") == "011") {
            if (approvalFlag == 'G') {
            	document.getElementById("tDocInfo").style.display = "none";
            }
            /* 2023-05-22 양지혜 - 반송문서는 공람정보 버튼을 활성화하지 않도록 제외 */
        } else if (pListTypeValue != 4 && pListTypeValue != 97 && tr.getAttribute("DATA2") != "" && tr.getAttribute("DATA12") == "011" && pFunctionType != "004") {
        	if (approvalFlag == 'G') {
        		document.getElementById("tDocInfo").style.display = "";
            }
        } else {
            document.getElementById("tDocInfo").style.display = "none";
        }
        
        if (pListTypeValue == 98) {
            document.getElementById("tDocInfo").style.display = "";
        	document.getElementById("tdGongRam").style.display = "";
        } else {
            document.getElementById("tdGongRam").style.display = "none";
        }
    } else
        document.getElementById("tDocInfo").style.display = "none";

    if (GetBujaeFlag()) {
        document.getElementById("tbtnDraft").style.display = "none";
        //SwapImage(document.getElementById("btnDraft"), "dis");
        document.getElementById("tbtnRedraft").style.display = "none";
        //SwapImage(document.getElementById("btnRedraft"), "dis");
        document.getElementById("tbtnRemoveDoc").style.display = "none";
        document.getElementById("tbtnApprove").style.display = "none";
        document.getElementById("tbtnApprove1").style.display = "none";
        document.getElementById("tbtnApprove2").style.display = "none";
        //document.getElementById("tbtnApproveALL").style.display = "none";
        document.getElementById("tbtnReceipt").style.display = "none";
        document.getElementById("tbtnNonElecRec").style.display = "none";
        document.getElementById("tbtnRegList").style.display = "none";
        document.getElementById("tbtnLinkDraft").style.display = "none";

        try {
            document.getElementById("tbtnSimsa").style.display = "none";
        } catch (e) { }
    }

    if (approvalFlag == "S") {
	    if (pListTypeValue == "4" || pListTypeValue == "97") {
//	        document.getElementById("tbtnViewDoc").style.display = "none";
	        document.getElementById("tbtnReceipt").style.display = "";
	        document.getElementById("tbtnReceiptAll").style.display = "";
	        document.getElementById("tbtnRJunkyulAll").style.display = "";
            document.getElementById("tbtnJiJungAll").style.display = "";
	        document.getElementById("tbtnBebuAll").style.display = "";
            
	        if (pFunctionType == "015") {
	            // 회송된 문서일 경우 접수버튼 display none 처리
	            document.getElementById("tbtnReceipt").style.display = "none";	   	        	
	        }     
	    }
    }
    // 결재진행문서, 기안한문서 에서 S, G 버전 모두 기안버튼 출력 되도록 스코프 변경
    if (pListTypeValue == "3") {
        if(!shareUser || shareUser != 'shareUser'){
            document.getElementById("tbtnDraft").style.display = "";
        }
    }
    if (pListTypeValue == "2") {
        document.getElementById("tbtnDraft").style.display = "";
    }
    
    if (pListTypeValue != "21" ) {
        document.getElementById("tbtnTotalSave").style.display = "";      
    }

    /* 2024-06-28 양지혜 - 부서수신함 > 지정목록에서 사용하는 버튼 */
    if (assignChk == "Y" && pListTypeValue == "4") {
        document.getElementById("tbtnReceiptAll").style.display = "none";
        document.getElementById("tbtnRJunkyulAll").style.display = "none";
        document.getElementById("tbtnAssignList").style.display = "none";
        document.getElementById("tbtnAssign").style.display = "";
        document.getElementById("tbtnDeptRecevList").style.display = "";
        document.getElementById("tbtnDraft").style.display = "none";
        document.getElementById("tbtnRedraft").style.display = "none";
        document.getElementById("tbtnReceipt").style.display = "none";
        document.getElementById("tbtnJiJungAll").style.display = "none";
        document.getElementById("tbtnBebuAll").style.display = "none";
    } else if (assignChk == "Y" && (pListTypeValue == "2" || pListTypeValue == "3")) {
        document.getElementById("tbtnDraft").style.display = "";
    }
    
    document.getElementById("tSearchCondi").style.display = ""; 
    
    if (pListTypeValue == "9" && typeof adminPage !== "undefined") {
        document.getElementById("tbtnViewDoc").style.display = "none";
        document.getElementById("tbtnTotalSave").style.display = "none";
        document.getElementById("tSearchCondi").style.display = "none";
    }
    return true;
}

function selFirstRow(Resultxml) {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];

    if (oArrRows.length != 0) {

        pDocID = tr.getAttribute("DATA1");
        pURL = tr.getAttribute("DATA2");
        orgCompanyID = tr.getAttribute("ORGCOMPANYID");
    }
    else {
        pDocID = "";
        pURL = "";
        orgCompanyID = "" ;
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
            getDataInfo("2");
            break;
    }
}

function getDataInfo(jobState) {
    switch (jobState) {
        case "3":
        	var pFlag = "";
        	if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
                pFlag = "END";
            else if (pListTypeValue == "21")
            	pFlag = "TMP";
            else
            	pFlag = "APR";
            	
            $.ajax({
        		type : "POST",
        		dataType : "text",
        		async : true,
        		url : "/ezApprovalG/getTotalAttachInfo.do",
        		data : {
        				docID : pDocID,
        				flag  : pFlag,
        				orgCompanyID : orgCompanyID
        				},
        		success: function(xml){
        			getdoclistSub_after(xml);
        		}        			
        	});
            break;

        case "4":
        	var pFlag = "";
        	if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
                pFlag = "END";
            else if (pListTypeValue == "21")
            	pFlag = "TMP";
            else
            	pFlag = "APR";
            	
            $.ajax({
        		type : "POST",
        		dataType : "text",
        		async : true,
        		url : "/ezApprovalG/getOpinionInfo.do",
        		data : {
        				docID : pDocID,
        				flag  : pFlag
        				},
        		success: function(xml){
        			getdoclistSub_after(xml);
        		}        			
        	});
            break;

        case "1":
        	var pFlag = "";
        	if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
                pFlag = "END";
            else if (pListTypeValue == "21")
            	pFlag = "TMP";
            else
            	pFlag = "APR";
            	
            $.ajax({
        		type : "POST",
        		dataType : "text",
        		async : false,
        		url : "/ezApprovalG/getLineList.do",
        		data : {
        				docID : pDocID,
        				flag  : pFlag
        				},
        		success: function(xml){
        			getdoclistSub_after(xml);
        		}        			
        	});
            break;

        case "2":
        	var pFlag = "";
        	if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
                pFlag = "END";
            else if (pListTypeValue == "21")
            	pFlag = "TMP";
            else
            	pFlag = "APR";
            	
            $.ajax({
        		type : "POST",
        		dataType : "text",
        		async : true,
        		url : "/ezApprovalG/getReceiptinfo.do",
        		data : {
        				docID : pDocID,
        				flag  : pFlag
        				},
        		success: function(xml){
        			getdoclistSub_after(xml);
        		}        			
        	});
            break;
    }
}

function getdoclistSub_after(xml) {
    try {
        if (document.getElementById("lvAprLine").innerHTML != "") document.getElementById("lvAprLine").innerHTML = "";
        if (xml == "NOTPERMISSION") {
            document.getElementById("lvAprLine").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
            document.getElementById("lvAprLine").style.textAlign = "center";
            return;
        }

        var AprLine = new ListView();
        AprLine.SetID("AprLine");
        AprLine.SetMulSelectable(false);
//        AprLine.SetTitleIdx(arrySubTab[subTabLastCol]);
        AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");
        AprLine.DataSource(loadXMLString(xml));
        AprLine.DataBind("lvAprLine");
    }
    catch (e) { }
}

var g_progresswin = null;

function showProgress() {
    g_progresswin = modelessWindow("/myoffice/ezApprovalG/show_progress_Cross.aspx?fileinfo=" + encodeURI(strLang592), "", 390, 185, g_progresswin);
}

function hideProgress() {
    try {
        if (g_progresswin)
            g_progresswin.close();
    } catch (e) {
    }
}


function getSimsaDocList() {
    pageSize = "10";
    
    var manager;
    if (beforeJob != pListTypeValue || SelYearFlag || SearchFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }

    if (SQLPARADATA == "") {
    	var nowyear = nowDate.substring(0,4);
        var nowmonth = nowDate.substring(5,7);
        var nowday = nowDate.substring(8,10);

        SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
    }

    CurrentDocList = "Simsa";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getReceivedDocList.do",
		data : {
				userID  : pUserID,
				deptID  : arr_userinfo[4],
				mFlag   : "simsa",
				docState: pSelMenu,
				pageSize: pageSize,
				pageNum : pageNum,
				orderCell : OrderCell,
				orderOption : OrderOption,
				searchQuery : SQLPARADATA
				},
		success: function(xml){
			getReceivedDocList_after(loadXMLString(xml));
		}        			
	});
}


var xmlhttp3;
var temppDocID;
/* 2020-05-22 홍승비 - 사용자 부서에 특수문자 허용 + arr_userinfo[] 배열의 값은 c:out 태그로 저장하므로, DB 저장 시 역으로 특수문자 인코딩 진행 */
function RemoveDocCabinet(tempDocID, FLAG) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/removeDocCabinetInfo.do",
		data : {
			docID : tempDocID,
			deptID : arr_userinfo[4],
			deptName : ConvMakeXMLString(arr_userinfo[15]),
			flag : FLAG,
			deptName2 : ConvMakeXMLString(arr_userinfo[16])
		},
		success: function(xml){
			result = xml;
		}
	});
	
    var RtnVal = getNodeText(loadXMLString(result).documentElement);

    if (RtnVal == "TRUE") {
        if (FLAG == "")
            var pAlertContent = strLang899;
        else
            var pAlertContent = strLang900;
        OpenAlertUI(pAlertContent, RemoveDocCabinet_Complete, "OPEN");
        return;
    }
    else {
        if (FLAG == "") {
//        	if (RtnVal == "RESETLINE") {
//        		var pAlertContent = strLangBae1;
//        	} else {
        		var pAlertContent = strLang901;
//        	}
        	
        }
        else {
        	var pAlertContent = strLang902;
        }
        OpenAlertUI(pAlertContent, "", "OPEN");
        return;
    }
}
function RemoveDocCabinet_Complete() {
    openergetDocInfo();
}

function OpenReceiptHistory() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    if (oArrRows.length > 0) {
        var tr = oArrRows[0];
        var pDocID = tr.getAttribute("DATA2");
        var pDeptID = tr.getAttribute("DATA1");
        var url = "./ezDocInfo/ezReceiptHistoryInfo_Cross.aspx?pDocID=" + pDocID + "&pDeptID=" + pDeptID;
        var feature = "status:no;dialogWidth:555px;dialogHeight:240px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(555, 240);
        var ret = window.showModalDialog(url, "", feature);
    }
}

function CheckFormConnFlag(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getFormConnFlag.do",
		data : {
			docID : pDocID,
			companyID : companyID
		},
		success: function(xml){
			result = xml;
		}
	});
	
    if (getNodeText(loadXMLString(result).documentElement) == "Y")
        return true;
    else
        return false;
}

/* 2020-07-13 홍승비 - 재기안 시 부서명 가져오는 부분의 오류 수정, 함수 내부의 지역변수 선언부분 if분기 바깥으로 이동 */
function CheckAprLineInfo(tr) {
    var xmldom = createXmlDom();
    try {
    	var pDeptID = "";
    	var pDeptName = "";
    	
        xmldom = getAprLineInfo(tr);
        
        if (xmldom.getElementsByTagName("ROW").length > 0) {
            if (CrossYN()) {
                pDeptID = xmldom.getElementsByTagName("DATA6").item(xmldom.getElementsByTagName("ROW").length - 1).textContent;
            }
            else {
                pDeptID = xmldom.getElementsByTagName("DATA6").item(xmldom.getElementsByTagName("ROW").length - 1).text;
            }
            
            if (pDeptID == arr_userinfo[4]) {
                return "OK";
            }
            else { // 부서명 가져올 때의 오류 수정, 다국어 처리
                if (CrossYN()) {
                    // pDeptName = xmldom.getElementsByTagName("ROW").item(xmldom.getElementsByTagName("ROW").length - 1).childNodes.item(7).textContent;
                	if (primary == "1") {
                		pDeptName = xmldom.getElementsByTagName("DATA15").item(xmldom.getElementsByTagName("ROW").length - 1).textContent;
                	} else {
                		pDeptName = xmldom.getElementsByTagName("DATA16").item(xmldom.getElementsByTagName("ROW").length - 1).textContent;
                	}
                }
                else {
                   // pDeptName = xmldom.getElementsByTagName("ROW").item(xmldom.getElementsByTagName("ROW").length - 1).childNodes.item(7).text;
                	if (primary == "1") {
                		pDeptName = xmldom.getElementsByTagName("DATA15").item(xmldom.getElementsByTagName("ROW").length - 1).text;
                	} else {
                		pDeptName = xmldom.getElementsByTagName("DATA16").item(xmldom.getElementsByTagName("ROW").length - 1).text;
                	}
                }
                
                pDeptName = pDeptName.replace("\"", "");
                return pDeptName;
            }
        }
        else {
            return "OK";
        }
    }
    catch (e) {
        return "OK";
    }
}

function getAprLineInfo(tr) {
    var pDocID = "";
    var result = "";

    if (pSelMenu == "hyubjo" || pSelMenu == "gamsa")
    	pDocID = tr.getAttribute("DATA7");
    else
    	pDocID = tr.getAttribute("DATA1");
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getLineList.do",
		data : {
				docID : pDocID,
				mode  : "APR"
				},
		success: function(xml){
			result = xml;
		}        			
	});

    return loadXMLString(result);
}

function check_presence() {
    try{
        var AprLine = new ListView();
        AprLine.LoadFromID("AprLine");
        var oArrRows = AprLine.GetDataRows();
        var pCNList = new Array();
        for (i = 0; i < oArrRows.length; i++) {
            var tr = oArrRows[i];
            pCNList[i] = tr.getAttribute("DATA4");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (var i = 0; i < oArrRows.length; i++) {
            var tr = oArrRows[i];
            tr.cells[1].innerHTML = "<span><img src='/images/Presence/unknown.gif' id ='" + GetGUID() + ",type=smtp' onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/></span>" + tr.cells[1].innerHTML;
        }
        pSIPUriList = null;
    } catch (e) { }
}

function check_presence2() {
    try{
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var oArrRows = DocList.GetDataRows();
        var pCNList = new Array();
        for (var i = 0; i < oArrRows.length; i++) {
            var tr = oArrRows[i];
            pCNList[i] = tr.getAttribute("DATA16");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (var i = 0; i < oArrRows.length; i++) {
            var tr = oArrRows[i];
            tr.cells[2].innerHTML = "<span><img src='/images/Presence/unknown.gif' id ='" + GetGUID() + ",type=smtp' onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/></span>" + tr.cells[2].innerHTML;
        }
        pSIPUriList = null;
    } catch (e) { }
}

//서버저장된 문서 진행문서로 바꾸는 함수이다.
function MakeTmp2Ing(tmpDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/makeTmp2Ing.do",
		data : {
			tmpDocID : tmpDocID
		},
		success: function(xml){
			result = xml;
		}
	});
	
    return getNodeText(loadXMLString(result).documentElement);
}
function openServerDraftUI(pDraftFlag, pCurSelRow) {
    var pArgument = new Array();
    pArgument[0] = pUserID;
    pArgument[1] = formURL;
    pArgument[2] = pDraftFlag;
    
    // 2018.08.27 재기안은 윈도우 하나면 열리게 수정
    var windowName =  "";
    
    if (pDraftFlag == "REDRAFT") {
    	pArgument[3] = pCurSelRow.getAttribute("DATA15");
    	windowName = "openServerDraftUI_REDRAFT";
    } else {
    	pArgument[3] = formDocType;
    }  
    
    var pDocSN = pCurSelRow.getAttribute("DATA1");
    var newDocID = MakeTmp2Ing(pDocSN);

    if (pCurSelRow) {
        pArgument[4] = "0";    //susinSN 
        pArgument[5] = "";     //DocState
        pArgument[6] = "";     // 결재처리 상태
        pArgument[7] = newDocID;
    }
    else {
        pArgument[4] = "0";
        pArgument[5] = "";
        pArgument[6] = "";
        pArgument[7] = "";
    }

    //우선 만들고 tmpDocID를 넘겨주어야 한다.	
    var openLocation = "";
    
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
        var isGroupDoc = checkIsGroupDoc(pDocSN, "");
        if (isGroupDoc == "Y") { // 임시저장된 일괄기안 문서를 여는 경우
            openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        } else {
    	    openLocation = "/ezApprovalG/draftui.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        }
    	openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
    	openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&docSN=" + encodeURI(pDocSN);
    	
        // FormBuilder
        if (window.reformflag == null) {
        	// reformflag null 값이라면
        	reformflag = GetAttribute(pCurSelRow, "REFORMFLAG");
        }
        
    	if (reformflag.length > 0) {
            openLocation += "&reformflag=" + encodeURI(reformflag);
    	}
    } else {
    	if(useWebHWP == "NO") {
	    	if (!isIE()) {
	    		//노티문구가 잘못되었음. 아무래도 한글양식은 IE에서만 지원가능합니다 라고 바꿔야할듯
	            showAlert(strLang1103);
	            return;
	        } else {
	        	openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
	            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
	            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&docSN=" + encodeURI(pDocSN);;
	        }
    	} else {
    		var isGroupDoc = checkIsGroupDoc(pDocSN, "");
    		
    		if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) { // 임시저장된 일괄기안 문서를 여는 경우
    			openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
    		} else {
        		openLocation = "/ezApprovalG/draftuiWHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
    		}
            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&docSN=" + encodeURI(pDocSN);
    	}
    }
    
    openwindow(openLocation, windowName, 890, 560);
}

/* 2022-02-10 홍승비 - 일괄기안문서 대응을 위해 알림메세지 및 갱신 분기 추가 */
function RemoveTmpDoc(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/removeTMPDocInfo.do",
		data : {
			docID : pDocID
		},
		success: function(text){
			result = text;	
			var pAlertContent = strLang802;
	        //OpenAlertUI(pAlertContent);
			
			// 일괄기안 문서 삭제 분기 (일괄기안 관련 변수가 존재하며, 최종 안까지 삭제가 모두 끝난 경우에만 알러트 발생)
			if (typeof(isGroupDoc) != "undefined" && isGroupDoc == "Y" && typeof(groupDocListCnt) != "undefined" && typeof(groupDocDelCnt) != "undefined") {
				groupDocDelCnt ++; // 일괄기안 루프 내부 문서삭제완료 카운트 증가 
				if (groupDocDelCnt == groupDocListCnt) {
					showAlert(pAlertContent);
					openergetDocInfo();
				}
			}
			// 기존 일반문서 삭제 분기
			else {
				showAlert(pAlertContent);
		        openergetDocInfo();
			}
		},
		error : function() {
			var pAlertContent = strLang872;
	        //OpenAlertUI(pAlertContent);
			showAlert(pAlertContent);
		}
	});
}

function checkIsDrafter() {
	var rtnVal = false;
	
	var DocList = new ListView();
	DocList.LoadFromID("DocList");
	
	var oSelRow = DocList.GetSelectedRows();
	if (oSelRow.length > 0) {
		if (GetAttribute(oSelRow[0], "DATA16") == arr_userinfo[1]) {
			rtnVal = true;
		}
	}
	
	return rtnVal;
}

function getEngMonth(month) {
	var engMonthStr = "";
	
	switch(Number(month)) {
		case 1 :
			engMonthStr = "Jan";
			break;
		case 2 :
			engMonthStr = "Feb";
			break;
		case 3 :
			engMonthStr = "Mar";
			break;
		case 4 :
			engMonthStr = "Apr";
			break;
		case 5 :
			engMonthStr = "May";
			break;
		case 6 :
			engMonthStr = "Jun";
			break;
		case 7 :
			engMonthStr = "Jul";
			break;
		case 8 :
			engMonthStr = "Aug";
			break;
		case 9 :
			engMonthStr = "Sep";
			break;
		case 10 :
			engMonthStr = "Oct";
			break;
		case 11 :
			engMonthStr = "Nov";
			break;
		case 12 :
			engMonthStr = "Dec";
			break;
	}
	
	return engMonthStr;
}

function getDatePeriod(userLang, startYear, startMonth, startDate, endYear, endMonth, endDate) {
	return getDateStrByLang(userLang, startYear, startMonth, startDate) + " ~ " + getDateStrByLang(userLang, endYear, endMonth, endDate);
}

function getDateStrByLang(userLang, year, month, date) {
	if (userLang == "2") {
		return getEngMonth(month) + " " + date + ", " + year;
	} else {
		return year + strLang1028 + " " + month + strLang1029 + " " + date + strLang1030
	}
}

//2020-04-29 : 리스트에서 직접 일괄결재 진행
var ezchkpasswd_all_cross_dialogArguments = new Array();
function chk_Passwd(pPwd) {
    var parameter = pPwd;

    ezchkpasswd_all_cross_dialogArguments[0] = parameter;
    ezchkpasswd_all_cross_dialogArguments[1] = chk_Passwd_Complete;

    DivPopUpShow(330, 215, "/ezApprovalG/ezchkPasswdall.do");
}
function chk_Passwd_Complete(chkpass) {
    if (chkpass == "FALSE") {
        var pAlertContent = strLang581;
        OpenAlertUI(pAlertContent);
        return;
    }
    else if (chkpass == "cancel") {
        var pAlertContent = strLang582;
        OpenAlertUI(pAlertContent);
        return;
    }

    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var pCurSelRow = DocList.GetSelectedRows();    

    var pMode = "";
      
    var xmlpara = createXmlDom();
    var objRoot, objNode, doc, objNode2, objNodes, objDocinfoNode;
    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "USERID", arr_userinfo[1]);
    createNodeAndInsertText(xmlpara, objNode, "DISPLAYNAME", arr_userinfo[2]);
    createNodeAndInsertText(xmlpara, objNode, "TITLE", arr_userinfo[3]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[5]);
    createNodeAndInsertText(xmlpara, objNode, "JIKCHEK", arr_userinfo[6]);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
    createNodeAndInsertText(xmlpara, objNode, "PASSWD", "");
    createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", userLang);
    var list = createNodeAndAppandNode(xmlpara, objRoot, list, "DOCIDS");
    var passCnt = 0;
    $(pCurSelRow).each(function(idx, curRow){
        //대결처리, docstate : 공람, aprState : 대기, 보류 제외
        var curDeptId = $(this).attr("DATA7");
        var curAprMemberSN = $(this).attr("APRMEMBERSN");
        orgCompanyID = $(this).attr("orgCompanyID");
        var curAprType = "";

        //대결자 결재도 일괄결제 제외
        if (useAdditionalRole == "YES" && curDeptId != arr_userinfo[4]) {
            return false;
        }
        
        /* 2022-02-23 홍승비 - 일괄기안된 문서는 일괄결재 제외 
        var isGroupDoc = checkIsGroupDoc($(this).attr("DATA1"), orgCompanyID); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)
        if (isGroupDoc == "Y") {
        	passCnt++;
        	return true;
        }*/
        
        //결재타입 정보
        $.ajax({
            type : "POST",
            dataType : "text",
            async : false,
            url : "/ezApprovalG/getAprStateToAprType.do",
            data : {
                    docID : $(this).attr("DATA1"),
                    userID : $(this).attr("DATA4"),
                    docState : $(this).attr("DATA15"),
                    orgCompanyID : orgCompanyID
                    },
            success: function(xml){
                curAprType = xml;
            }        			
        });

        if(GetAttribute(curRow, "DATA12") === "015") { //DATA12 - docstate
            passCnt++;
            return true;
        }
        if(GetAttribute(curRow, "DATA10") !== "002" && GetAttribute(curRow, "DATA10") !== "005") { //data10 - functiontype
            passCnt++;
            return true;
        }
        
        //결재타입이 001(결재), 004(전결), 007(참조), 019(검토) 만 일괄결재 처리
        curAprType = curAprType.split("/")[0];
        if(!(curAprType == "001") && !(curAprType == "004") && !(curAprType == "007") && !(curAprType == "019")) {
            //jquery each 내부 return true: continue, false: break -> return false
            passCnt++;
            return true;
        }

        doc = createNodeAndAppandNode(xmlpara, list, doc, "DOC");
        $.ajax({
              type : "POST",
              dataType : "text",
              async : false,
              url : "/ezApprovalG/getLineMode.do",
              data : {
                      docID : $(this).attr("DATA1"),
                      orgCompanyID : orgCompanyID
                      },
              success: function(xml){
                  pMode = xml;
              }        			
        });  

        createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCID", $(this).attr("DATA1"));
        createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGAPRUSERID", $(this).attr("DATA4"));
        createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "FORMID", $(this).attr("DATA17"));
        var itemExt = $(this).attr("DATA3");
        itemExt = itemExt.substr($(this).attr("DATA3").lastIndexOf(".")+1, itemExt.length).toUpperCase();
        createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "TYPE", itemExt);
        createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCSTATE", $(this).attr("DATA12"));
        createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "orgCompanyID", orgCompanyID);
        createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "APRMEMBERSN", curAprMemberSN);
        createNodeAndInsertText(xmlpara, objNode, "MODE", pMode);                
    });

    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "/ezApprovalG/doApprovAllG.do", false);
    xmlhttp.send(xmlpara);
    var RtnVal = xmlhttp.responseText;
    var arrRtnVal = new Array();
    arrRtnVal[0] = RtnVal.split("/")[0]; // OK or ERR
    arrRtnVal[1] = RtnVal.split("/")[1]; // totalCount
    arrRtnVal[2] = RtnVal.split("/")[2]; // trueCount
    arrRtnVal[3] = RtnVal.split("/")[3]; // falseCount
    if (arrRtnVal[0] == "OK") {
        hideProgress();
        pAlertContent = strLang933 + (Number(arrRtnVal[1]) + passCnt) + strLang934_1 + "<br/>";
        pAlertContent += strLang935 + arrRtnVal[2] + strLang934_1;
        if (arrRtnVal[3] != 0) {
            pAlertContent += " / " + strLang936 + arrRtnVal[3] + strLang934_1;
        }
        if(passCnt > 0) {
            pAlertContent += " / " + strLang938 + passCnt + strLang934_1;
        }
        pAlertContent += "<br/>" + strLang931_1;
        OpenAlertUI(pAlertContent, OpenAlertUI_Close);
    } else {
        hideProgress();
        pAlertContent = strLang932;
        OpenAlertUI(pAlertContent);
    }
}
function OpenAlertUI_Close() {
    try{
        DivPopUpHidden();
        parent.frames["left"].getAprCount();
        getDocList();
    }catch(e){}
}

function OpenAlertUI_Close_Complete() {
    try {
        DivPopUpHidden();
        parent.frames["left"].getAprCount();
        if (assignChk == "Y") { // 지정목록 > 지정완료 > 리스트 재호출
            getReceivedDocList();
        } else {
            getDocList();
        }
        OpenPopupWin.close();
    } catch (e) {
        console.log("OpenAlertUI_Close_Complete ::: " + e);
    }
}

function CheckUsePassword() {
    var result = "";
    $.ajax({
        type : "POST",
        dataType : "text",
        async : false,
        url : "/ezApprovalG/getApprovalPWD.do",
        success: function(text) {
            result = text;
        }        			
    });
    
    if (result != "N") {
        return true;
    } else {
        return false;
    }
}
//일괄결재 끝

/* 2021-05-03 홍승비 - 부서에 특수문자를 허용하므로, DB 저장 시 역인코딩을 위한 함수 추가 */
function ConvMakeXMLString(str) {
    str = ReplaceText(str, "&lt;", "<");
    str = ReplaceText(str, "&gt;", ">");
    str = ReplaceText(str, "&#039;", "'");
    str = ReplaceText(str, "&#034;", "\"");
	str = ReplaceText(str, "&#92;", "\\");
	str = ReplaceText(str, "&amp;", "&");
    return str;
}

/* 2022-01-27 홍승비 - 일괄기안된 문서인지 판별하는 ajax 함수 (Y/N) */
function checkIsGroupDoc(pDocID, pOrgCompanyID) {
    var res = "";
    
    $.ajax({
        type : "GET",
        dataType : "text",
        async : false,
        url : "/ezApprovalG/checkIsGroupDoc.do",
        data : {
            docID : pDocID,
            orgCompanyID : pOrgCompanyID
        },
        success: function(result) {
            res = result;
        }        			
    });
    
    return res;
}

/* 2022-02-10 홍승비 - 1안의 DOCID/DOCSN을 전달하여 일괄기안된 문서 리스트를 문자열 배열리스트로 리턴 */
function getGroupDocListByDocID(pDocID) {
	var result = new Array();
	
	$.ajax({
		type : "GET",
		async : false,
		url : "/ezApprovalG/getGroupDocListByDocID.do",
		data : {
			docID : pDocID
		},
		success: function(resultAry){
			result = resultAry;
		},
		error : function(e) {
			console.log(e);
		}
	});
	
	return result;
}

/* 2022-02-10 홍승비 - 일괄기안된 문서 삭제 전용 ajax 함수 (전달받은 docID 또는 임시저장 docSN으로 GROUPDOCSN을 찾아, 일치하는 레코드를 전부 삭제) */
// mode에 따라 모든 일괄기안 레코드를 삭제할지, 현재 전달된 DOCID에 대한 레코드만 삭제할지 모드값 추가 (ALL, ONE)
function delGroupDocInfoByDocID(pDocID, pMode) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/delGroupDocInfoByDocID.do",
		data : {
			docID : pDocID,
			mode : pMode
		},
		success: function(text){},
		error : function(e) {
			console.log(e);
		}
	});
}

function btn_newpopup() {
	lvDocList_DBSelChange();
}

/* 2023-06-26 민지수 - 추가의견 의견작성창 호출 */
function openOpinionUI_New_Add(pOpinionType, CompleteFunction) {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;		// DOCID
        parameter[1] = pOpinionType;// OPINIONTYPE NAME
        parameter[2] = "";			// DRAFTFLAG 결재는 공백 고정
        parameter[4] = orgCompanyID;// ORGCOMPANYID
        parameter[99] = ext;		// EXT

        apropinion_cross_dialogArguments[0] = parameter;
        if (typeof(CompleteFunction) != "undefined") {
            apropinion_cross_dialogArguments[1] = CompleteFunction;
        } else {
            apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete_Add;
        }

        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinionNew.do?opMode=ADD");
    } catch (e) {
        showAlert("openOpinionUI_New ::: " + e.description);
    }
}

function openOpinionUI_New_Complete_Add(ret) {
    try {
        DivPopUpHidden();
        if (ret == "Clear") {
            pHasOpinionYN = "N";
            var fields = message.GetFieldsList();
            var field = message.GetListItem(fields, "opinions");

            if (field) {
                field.innerHTML = " ";
            }
        } else
        // 추가의견은 양식상에 맵핑하지 않음
        if (ret == "cancel") {
            //do_nothing
        } else {
            var objXML = createXmlDom();
            objXML = loadXMLString(ret);
            var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");

            if (NodeList.length != 0) {
                pHasOpinionYN = "Y";
            } else {
                pHasOpinionYN = "N";
                ret = "cancel";
            }
            // 추가의견은 양식상에 맵핑하지 않음
           // makeOpinionList_Add(objXML);
        }
    } catch (e) {
        showAlert("openOpinionUI_New_Complete ::: " + e.description);
    }
}

var aprgongramline_cross_dialogArguments = new Array();
function btnSendAround_onclick() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length != 0) {
		var DocID = GetAttribute(selRow[0], "DATA2");
        var para = new Array();
        para[0] = DocID;
        var url = "/ezApprovalG/aprGongRamLine.do?type=END";

        aprgongramline_cross_dialogArguments[0] = para;
        aprgongramline_cross_dialogArguments[1] = btnSendAround_onclick_Complete;

//        var OpenWin = window.open(url, "AprGongRamLine_Cross", GetOpenWindowfeature(1200, 780));
//        try { OpenWin.focus(); } catch (e) { }
        ezCommon_cross_dialogArguments[0] = para;
        showPopup(url, 1200, 780, "AprGongRamLine_Cross", GetOpenWindowfeature(1200, 780), btnSendAround_onclick_Complete);
    }
}

function btnSendAround_onclick_Complete(rtn) {
	hidePopup();
    if (rtn == "OK") {
        var pAlertContent = "<spring:message code='ezApprovalG.t1424'/>";
        OpenAlertUI(pAlertContent);
    }
}

function RemoveGongramDoc(pDocID, pAprmemeberSn) {
	var result = "FALSE";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/gongramDocDelete.do",
		data : {
			docID : pDocID,
			aprmemberSN : pAprmemeberSn
		},
		success: function(res) {
			result = res;
		}        			
	});
    
    if (result != "TRUE") {
        var pAlertContent = strLang872;
        OpenAlertUI(pAlertContent);
    }
}

// var ezreceivedistributeui_cross_dialogArguments = new Array();
function btnBaeBuAll_onclick() {
	var DocList = new ListView();
	DocList.LoadFromID("DocList");
	
	var selRows = DocList.GetSelectedRows();

    if (selRows.length == 0) {
		var pAlertContent = strLang930 + "<br>" + strLang336;
        OpenAlertUI(pAlertContent);
        return;
    } else {
		OpenInformationUI(ezApproval_allBeabu01 + "<br>" + ezApproval_allBeabu02, btnBaeBuAll_onclick_Complete);
	}
}

function btnBaeBuAll_onclick_Complete(rtn) {
	DivPopUpHidden();
	
	var DocList = new ListView();
	DocList.LoadFromID("DocList");
	
	var selRows = DocList.GetSelectedRows();
	
	var excludeCnt = 0;	// 일괄배부 제외 대상 문서 갯수
	
	for (var i = 0; i < selRows.length; i++) {
		if (selRows[i].getAttribute("data10") == "015" || selRows[i].getAttribute("data9") == "012") {
			excludeCnt += 1;
		}
		if (pSusinManagerFlag != "admin" && selRows[i].getAttribute("data8") != pUserID) {
			var pAlertContent = "<spring:message code='ezApprovalG.t1730'/>";
            OpenInformationUI(pAlertContent);
			return;
		}	
	}
	
	if (rtn && selRows.length == excludeCnt) {
		OpenAlertUI(strLang721);
		return;
	}
	
	var DocID = "";
	var DocState = "";
	var AprState = "";
	
	if (rtn) {
		for (var j = 0; j < selRows.length; j++) {
		    var targetUrl = selRows[j].getAttribute("data3");
		    var targetUrlType = (targetUrl.substr(targetUrl.length-3, targetUrl.length)).toUpperCase(); 
		    if (targetUrlType == "MHT") {
            	ajaxUrl = "/ezApprovalG/recevGSusin.do";
            } else if (targetUrlType == "HWP") {
            	ajaxUrl = "/ezApprovalG/ezRecevGSusinHWP.do";
            } else if (targetUrlType == "WHWP") {
            	ajaxUrl = "/ezApprovalG/ezRecevGSusinWHWP.do";
            }
            	
            // 수신문서 열어주는 작업
            $.ajax({
            	type : "GET",
            	dataType : "text",
            	async : false,
            	url : ajaxUrl,
            	data : {
            		docID : selRows[j].getAttribute("data1"),
            		uOrgID : selRows[j].getAttribute("data7"),
            		isReDraft : "",
            		draftFlag : "SUSIN",
            		retFlag : "",
            		isPreview : "Y"
            	}
            });
		
			DocID += selRows[j].getAttribute("data1");
			DocState += selRows[j].getAttribute("data9");
			AprState += selRows[j].getAttribute("data10");
			if (j != selRows.length - 1) {
				DocID += ",";
				DocState += ",";
				AprState += ",";
			} 
		}
		var parameter = new Array();
		parameter[0] = DocID;
		parameter[1] = "1";
		parameter[2] = arr_userinfo[4];
		parameter[3] = AprState;
		parameter[4] = arr_userinfo[4];
		parameter[5] = DocState;
	
		var url = "/ezApprovalG/ezReceiveDistributeUI.do?mode=addAll&pdocid=" + DocID;
	
		// ezreceivedistributeui_cross_dialogArguments[0] = parameter;
		// ezreceivedistributeui_cross_dialogArguments[1] = receiveDistributeAll_Complete;

		// var OpenWin = window.open(url, "ezReceiveDistributeUI_Cross", GetOpenWindowfeature(800, 600));
		// try { OpenWin.focus(); } catch (e) { }
        ezCommon_cross_dialogArguments[0] = parameter;
        showPopup(url, 800, 600, "ezReceiveDistributeUI_Cross", GetOpenWindowfeature(800, 600), receiveDistributeAll_Complete);
	}

}

function receiveDistributeAll_Complete(ret){
	hidePopup();

    if (ret == "true") {
        if (pListTypeValue == "97") {
            window.parent.frames[0].convMain('97', '');
        } else {
            window.parent.frames[0].convMain('4', '');
        }
    }
}