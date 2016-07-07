var beforeJob = "0";
var pDocTypeValue = "000";
var pageSize = "10";
var CallPage = "Right";
var xmlhttp = createXMLHttpRequest();
var xmlhttp2 = createXMLHttpRequest();
var arrySubTab = new Array(0, 6, 4, 4, 3); 
var pTotalCnt = "";
function getDocList() {
    pageSize = "10";
        
    if (typeof (psearch) == "object")
        document.getElementById("psearch").style.display = "none";

    if (beforeJob != pListTypeValue || SelYearFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }

    if (SQLPARADATA == "") {
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        if (nowmonth < 10)
            nowmonth = "0" + nowmonth;

        if (nowday < 10)
            nowday = "0" + nowday;

        SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
    }
    
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : true,
		url : "/ezApprovalG/getAprDocList.do",
		data : {
				listType : pListTypeValue, 
				docType  : pDocTypeValue,
				userID 		 : pUserID,
				userDeptID   : arr_userinfo[4],
				pageSize 	 : pageSize,
				pageNum 	 : pageNum,
				companyID    : companyID,
				orderCell    : OrderCell,
				orderOption  : OrderOption,
				searchQuery  : SQLPARADATA
				},
		success: function(xml){
			getDocList_after(xml);
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
    if (pageNum > totalPage) {
        pageNum--;
        getDocList();
        return;
    }

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
                else if (pDocInfoValue == "5") {
                    getAprDocAproveInfo(tr);
                }

            }

        }
    }

    SearchFlag = false;

    if (USE_OCS == "YES")
        check_presence2();

    try {
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

    if (beforeJob != pListTypeValue || SelYearFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }

    if (SQLPARADATA == "") {
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        if (nowmonth < 10)
            nowmonth = "0" + nowmonth;

        if (nowday < 10)
            nowday = "0" + nowday;

        SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
    }

    CurrentDocList = "Receive";
    
    $.ajax({
		type : "POST",
		dataType : "xml",
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
				searchQuery : SQLPARADATA
				},
		success: function(xml){
			getReceivedDocList_after(xml);
		}        			
	});

    //ShowMailProgress();
    //DisplayWaitStat();

}

function getReceivedDocList_after(xml) {
//    try {
//        if (xmlhttp.responseText == "") return;
        SelYearFlag = false;
        var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
        var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");


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
        try {
            parent.frames["left"].getAprCount();
            parent.frames["left"].setPresentValue("");
        } catch (e) { }
//    }
//    catch (e) {
//        alert("getReceivedDocList_after" + " " + e.description);
//    }
}

function getSendOutDocList() {    
    pSelMenu = "all";

    if (beforeJob != pListTypeValue || SelYearFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }

    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER"); 
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "pSusinManagerFlag", SendOutFlag);
    createNodeAndInsertText(xmlpara, objNode, "pPageSize", pageSize);
    createNodeAndInsertText(xmlpara, objNode, "pPageNum", pageNum);
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);

    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "aspx/getSendOutDocList.aspx", true);
    xmlhttp.onreadystatechange = getSendOutDocList_after;
    xmlhttp.send(xmlpara);

    //DisplayWaitStat();

}

function getSendOutDocList_after() {
    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        try {
            if (xmlhttp.responseText == "") return;

            SelYearFlag = false;

            var cntNode = SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/TOTALCNT");
            var listNode = SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/LISTVIEWDATA");

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

            setbuttonenable();

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
            alert("getSendOutDocList_after" + " " + e.description);
        }
    }
    else
        return;
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
        document.getElementById("AprManageStat").innerHTML = "공람한 문서 : " + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
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
        document.getElementById("AprManageStat").innerHTML = "공람한 문서를 준비중 입니다..";
    }
}

function getAprLine(tr) {
    var pDocID,pMode = "",pFlag = "";

    if (pSelMenu == "hyubjo" || pSelMenu == "gamsa")
        pDocID = GetAttribute(tr, "DATA7");
    else
        pDocID = GetAttribute(tr, "DATA1");


    if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
    	pMode = "END";
    } else if (pListTypeValue == "21") {
    	pFlag = "TMP";
    } else {
    	pMode = "APR";
    }

    $.ajax({
		type : "POST",
		dataType : "xml",
		async : true,
		url : "/ezApprovalG/getLineList.do",
		data : {
				docID : pDocID,
				mode  : pMode,
				flag  : pFlag
				},
		success: function(xml){
			getAprovSub_after(xml);
		}        			
	});
    
}

function getAprovSub_after(xml) {
    if (document.getElementById("lvAprLine").innerHTML != "") document.getElementById("lvAprLine").innerHTML = "";
    if (xml == "NOTPERMISSTION") {
        document.getElementById("lvAprLine").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
        document.getElementById("lvAprLine").style.textAlign = "center";
        return;
    }


    var listNode = SelectSingleNodeNew(xml, "LISTVIEWDATA");

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
    AprLine.SetTitleIdx(arrySubTab[1]);
    AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");
    AprLine.SetRowOnClick("lvAprLine_SelChange");
    AprLine.DataSource(xmlDoc);
    AprLine.DataBind("lvAprLine");

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
                window.open("ezDocInfo/ezLineInfo.aspx?pDocID=" + pDocID + "&pDeptID=" + pDeptID + "&pDocState=012", "", "height=220px,width=540px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(540, 220));
            } else {
                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;
                var left = (width - 500) / 2;
                var top = (heigth - 400) / 2;
                window.open("/myoffice/common/showpersoninfo_cross.aspx?id=" + pDeptID + "&dept=" + GetAttribute(tr, "DATA6"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
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
        window.open("/myoffice/common/showpersoninfo_cross.aspx?id=" + GetAttribute(tr, "DATA1"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
    }
}

function openDraftUI(pDraftFlag, pCurSelRow) {
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
  
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht" || formExt == "MHT") {        
        if (CrossYN() || NonActiveX == "YES") {
        	openLocation = "/ezApprovalG/draftui.do?formURL=";
        }
        else
        {
            if (pUse_Editor == "") 
                openLocation = "/myoffice/ezApprovalG/DraftUI/draftui.aspx?formURL=";
            else
                openLocation = "/myoffice/ezApprovalG/DraftUI/draftui_IE.aspx?formURL=";
        }

        openLocation = openLocation + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
        openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
    }
    else {
        if (CrossYN() || NonActiveX == "YES") {
            alert(strLang1103);
            return;
        }
        else {
            openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezDraftUI_HWP.aspx?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
        }
    }

    openwindow(openLocation, "", 890, 560);
}

function openApprovUI(allFlag) {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    var openLocation;
    if (tr.length > 0) {
        var pArgument = new Array();
        pArgument[0] = GetAttribute(tr[0], "DATA1");      
        pArgument[1] = GetAttribute(tr[0], "DATA4");		
        pArgument[2] = GetAttribute(tr[0], "DATA5");		
        pArgument[3] = GetAttribute(tr[0], "DATA7");	

        var formURL = GetAttribute(tr[0], "DATA3");
        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
            openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?docID=" + encodeURI(pArgument[0]);
            openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
            openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag);
        }
        else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
            if (CrossYN() || NonActiveX == "YES") {
                var openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezAproveUI_HWP_Cross.aspx?docID=" + encodeURI(pArgument[0]);
                openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
                openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag);
            }
            else {
                var openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezAproveUI_HWP.aspx?DocID=" + encodeURI(pArgument[0]);
                openLocation = openLocation + "&uID=" + encodeURI(pArgument[1]) + "&uName=" + encodeURI(pArgument[2]);
                openLocation = openLocation + "&uDeptID=" + encodeURI(pArgument[3]) + "&AllFlag=" + encodeURI(allFlag);
            }
        }
        else {
            if (CrossYN() || NonActiveX == "YES")
                openLocation = "/ezApprovalG/approvui.do?docID=";
            else
            {
                if (pUse_Editor == "TAGFREE")
                    openLocation = "/myoffice/ezApprovalG/ApprovUI/approvui_TFI.aspx?docID=";
                else
                    openLocation = "/myoffice/ezApprovalG/ApprovUI/approvui.aspx?docID=";
            }
            openLocation = openLocation + encodeURI(pArgument[0]);
            openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
            openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag);
        }
        openwindow(openLocation, "ApprovUI", 880, 550);
    }
    else {
        var pAlertContent = strLang870;
        OpenAlertUI(pAlertContent);
    }
}

function InitlvAprLine() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();

    if (oArrRows.length != 0) {
        var tr = oArrRows[0];

        if (pListTypeValue == "2") {
            var DocID = GetAttribute(tr, "DATA1");
            cancelYN(DocID);
        }
        else if (pListTypeValue == "3") {
            var DocID = GetAttribute(tr, "DATA1");
            cancelYN(DocID);
        }

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

function RemoveDoc(pDocID) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER"); 
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "FIELD", "MUST");

    xmlhttp = null;
    xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "ReceivUI/aspx/delDocInfo.aspx", false);
    xmlhttp.send(xmlpara);

    var RtnVal = getNodeText(xmlhttp.responseXML.documentElement);
    if (RtnVal == "false") {
        var pAlertContent = strLang872;
        OpenAlertUI(pAlertContent);
    }
}

var getformcont_cross_dialogArguments = new Array();
var getformcont_Cross_OpenWin = "";
function openForm() {
    var parameter = new Array();
    parameter[0] = arr_userinfo[4];
    parameter[1] = "000";

    var url = "/ezApprovalG/getFormCont.do";
    var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
    feature = feature + GetShowModalPosition(713, 570);

    getformcont_cross_dialogArguments[0] = parameter;
    getformcont_cross_dialogArguments[1] = openForm_Complete;

    getformcont_Cross_OpenWin = window.open(url, "getformcont_Cross", GetOpenWindowfeature(713, 570));
    
    try { getformcont_Cross_OpenWin.focus(); } catch (e) { }
}

function openForm_Complete(ret) {
    getformcont_Cross_OpenWin.close();
    formURL = ret[0];
    formDocType = ret[1];
    formExt = ret[2];

    if (formURL != "cancel") {
        openDraftUI("DRAFT", "");
    }
}

function openViewDocInfo() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];

    var pArgument = new Array();
    var formURL = GetAttribute(tr, "DATA3");
    var DocID = GetAttribute(tr, "DATA1");

    pArgument[0] = DocID;
    pArgument[1] = formURL;

    if (pListTypeValue == "4") {
        pArgument[2] = GetAttribute(tr, "DATA5");
        pArgument[3] = "VIEW";
        pArgument[4] = pSusinManagerFlag;
        pArgument[5] = GetAttribute(tr, "DATA7");
        pArgument[6] = "OPINION_SHOW";
        pArgument[7] = pListTypeValue;
    }
    else if (pListTypeValue != "7" && pListTypeValue != "8" && pListTypeValue != "9") {
        pArgument[2] = GetAttribute(tr, "DATA11").trim();
        pArgument[3] = GetAttribute(tr, "DATA12").trim();
        pArgument[4] = GetAttribute(tr, "DATA4").trim();
        pArgument[5] = GetAttribute(tr, "DATA2").trim();
        if (pListTypeValue != "5")
            pArgument[6] = "OPINION_SHOW";
        else
            pArgument[6] = "OPINION_HIDE";
        pArgument[7] = pListTypeValue;
    }

    var openLocation;

    if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
            if (CrossYN() || NonActiveX == "YES") {
                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP_Cross.aspx";
            }
            else {
                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP.aspx";
            }
        }
        else {
            if (CrossYN() || NonActiveX == "YES")
                openLocation = "/myoffice/ezApprovalG/formContainer/contDocView_Cross.aspx";
            else {
                if (pUse_Editor == "")
                    openLocation = "/myoffice/ezApprovalG/formContainer/contDocView.aspx";
                else
                    openLocation = "/myoffice/ezApprovalG/formContainer/contDocView_IE.aspx";
            }            
        }
        openLocation = openLocation + "?DocID=" + encodeURI(DocID) + "&DocHref=" + encodeURI(formURL) + "&formID=&orgDocid=";
    }
    else {
        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
            if (CrossYN() || NonActiveX == "YES") {
                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewApr_HWP_Cross.aspx";
            }
            else {
                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewApr_HWP.aspx";
            }
        }
        else {
            if (CrossYN() || NonActiveX == "YES")
                openLocation = "/myoffice/ezApprovalG/AprDocView_Cross.aspx";
            else {
                if (pUse_Editor == "")
                    openLocation = "/myoffice/ezApprovalG/AprDocView.aspx";
                else
                    openLocation = "/myoffice/ezApprovalG/AprDocView_IE.aspx";
            }
        }
        openLocation = openLocation + "?DocID=" + encodeURI(pArgument[0]) + "&DocHref=" + encodeURI(pArgument[1]);
        openLocation = openLocation + "&OpinionFlag=" + encodeURI(pArgument[2]) + "&docState=" + encodeURI(pArgument[3]) + "&ListSusin=" + encodeURI(pArgument[4]) + "&odoc=" + encodeURI(pArgument[5]);
        openLocation = openLocation + "&isOpinion=" + encodeURI(pArgument[6]);
        openLocation = openLocation + "&ListType=" + encodeURI(pArgument[7]);
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
            var pDocID = GetAttribute(pCurSelRow, "DATA1");
            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "mht" || g_RelayG_Type.toUpperCase() == "MHT") {
                openLocation = "";
                if (pCurSelRow.getAttribute("DATA15") == "001") {
                    if (CrossYN() || NonActiveX == "YES") {
                        openLocation = "/myoffice/ezApprovalG/ReceivUI/recevG_Cross.aspx";
                    }
                    else {
                        if (pUse_Editor == "")
                            openLocation = "/myoffice/ezApprovalG/ReceivUI/recevG.aspx";
                        else
                            openLocation = "/myoffice/ezApprovalG/ReceivUI/recevG_IE.aspx";
                    }
                }
                else {
                    if (CrossYN() || NonActiveX == "YES") {
                        openLocation = "/ezApprovalG/recevGSusin.do";
                    }
                    else {
                        if (pUse_Editor == "")
                            openLocation = "/myoffice/ezApprovalG/ReceivUI/recevG_Susin.aspx";
                        else
                            openLocation = "/myoffice/ezApprovalG/ReceivUI/recevG_Susin_IE.aspx";
                    }
                }
                openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag);
                openLocation = openLocation + "&uOrgID=" + encodeURI(GetAttribute(pCurSelRow, "DATA7"));
            }
            else {
                if (CrossYN() || NonActiveX == "YES") {
                    alert(strLang1103);
                    return;
                }
                else {
                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezRecevG_Susin_HWP.aspx?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag);
                }
            }
            openwindow(openLocation, "receive", 880, 550);
        }
        else {
            var pURL = GetAttribute(pCurSelRow, "DATA3");
            var pDocID = GetAttribute(pCurSelRow, "DATA1");
            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
                if (CrossYN() || NonActiveX == "YES") {
                    alert(strLang1103);
                    return;
                }
                else {
                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezDeptRecevUI_HWP.aspx";
                }
            }
            else {
                if (CrossYN() || NonActiveX == "YES")
                    openLocation = "/myoffice/ezApprovalG/ReceivUI/recev_Cross.aspx";
                else {
                    if (pUse_Editor == "")
                        openLocation = "/myoffice/ezApprovalG/ReceivUI/recevG.aspx";
                    else
                        openLocation = "/myoffice/ezApprovalG/ReceivUI/recevG_IE.aspx";
                }
                openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag);
            }
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
        var openLocation = "";
        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
            if (CrossYN() || NonActiveX == "YES") {
                alert(strLang1103);
                return;
            }
            openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezRecevG_Susin_HWP.aspx?DocID=" + encodeURI(pArgument[0]) + "&DraftFlag=" + encodeURI(pDraftFlag);
        }
        else {
            if (GetAttribute(pCurSelRow, "DATA15") == "001") {                
                if (CrossYN() || NonActiveX == "YES")
                    openLocation = "/myoffice/ezApprovalG/ReceivUI/RecevG_Cross.aspx";
                else
                {
                    if (pUse_Editor == "")
                        openLocation = "/myoffice/ezApprovalG/ReceivUI/RecevG.aspx";
                    else
                        openLocation = "/myoffice/ezApprovalG/ReceivUI/RecevG_IE.aspx";
                }
            }
            else {
                if (CrossYN() || NonActiveX == "YES")
                    openLocation = "/myoffice/ezApprovalG/ReceivUI/RecevG_Susin_Cross.aspx?DocID=" + encodeURI(pArgument[0]);
                else
                {
                    if (pUse_Editor == "")
                        openLocation = "/myoffice/ezApprovalG/ReceivUI/RecevG_Susin.aspx?DocID=" + encodeURI(pArgument[0]);
                    else
                        openLocation = "/myoffice/ezApprovalG/ReceivUI/RecevG_Susin_IE.aspx?DocID=" + encodeURI(pArgument[0]);
                }
            }

            openLocation = openLocation + "?DocID=" + encodeURI(pArgument[0]) + "&uorgID=" + encodeURI(pArgument[1]) + "&isReDraft=" + encodeURI("Y") + "&DraftFlag=" + encodeURI(pDraftFlag);
        }

        if (g_selReturn == "Y" && pListTypeValue == "1") {
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
    var url = "/myoffice/ezApprovalG/ezAPRRECEIVE/ezReceiveDistributeUI_Cross.aspx";
    var feature = "status:no;dialogWidth:1000px;dialogHeight:740px;edge:sunken;scroll:no";
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
        var url = "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion_Cross.aspx";

        apropinion_cross_dialogArguments[0] = parameter;
        apropinion_cross_dialogArguments[1] = OpenOpinionUI_Complete;

        var OpenWin = window.open(url, "AprOpinion_Cross", GetOpenWindowfeature(530, 520));
        try { OpenWin.focus(); } catch (e) { }
    } catch (e) {
        alert("OpenOpinionUI :: " + e.description);
    }
}

function OpenOpinionUI_Complete(ret) {
    if (ret != "cancel") {
        if (pListTypeValue == "4") {
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
        else {
            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", "1");
        }

        xmlhttp.open("POST", "ezAPRRECEIVE/aspx/setHeSongHapyuiDocInfo.aspx", false);
        xmlhttp.send(xmlpara);

        if (getNodeText(xmlhttp.responseXML.documentElement) != "TRUE") {
            var pAlertContent = strLang740;
            OpenAlertUI(pAlertContent, "", "OPEN");
            return;
        } else {
            var pAlertContent = strLang878;
            OpenAlertUI(pAlertContent, "", "OPEN");
            openergetDocInfo();
        }
    } catch (e) {
        alert("setHeSongHapyuiDocInfo :: " + e.description);
    }
}

function setHeSongDocInfo(pCurSelRow) {
    var xmlpara = createXmlDom();
    var xmlhttp = createXMLHttpRequest();

    var objNode;
    createNodeInsert(xmlpara, objNode, "ASSIGN");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", GetAttribute(pCurSelRow, "DATA1"));

    if (pListTypeValue == "4")
        createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", GetAttribute(pCurSelRow, "DATA2"));
    else
        createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", GetAttribute(pCurSelRow, "DATA9"));

    createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);

    if (pCurSelRow.cells[2].innerText == strLang879)
        createNodeAndInsertText(xmlpara, objNode, "pDocSate", "REBACK");
    else
        createNodeAndInsertText(xmlpara, objNode, "pDocSate", "RECEIVE");

    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[11]);
    createNodeAndInsertText(xmlpara, objNode, "pUserName2", arr_userinfo[12]);

    xmlhttp.open("POST", "ezAPRRECEIVE/aspx/setHeSongDocInfo.aspx", false);
    xmlhttp.send(xmlpara);

    var RtnVal = getNodeText(xmlhttp.responseXML.documentElement);

    if (RtnVal == "FALSE") {
        var pAlertContent = strLang740;
        OpenAlertUI(pAlertContent, "", "OPEN");
    }
    else {
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

    if (pDocInfoValue == "4") {
        if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
        	pFlag = "END";
    	} else if (pListTypeValue == "21") {
        	pFlag = "TMP";
        } else {
        	pFlag = "APR";
        }

        $.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getTotalAttachInfo.do",
    		data : {
    				docID : pDocID,
    				mode  : pFlag
    				},
    		success: function(xml){
    			RtnVal = xml;
    		}        			
    	});
    }
    else if (pDocInfoValue == "3") {
        if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
        	pFlag = "END";
        else if (pListTypeValue == "21")
        	pFlag = "TMP";
        else
        	pFlag = "APR";

        $.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getOpinionInfo.do",
    		data : {
    				docID : pDocID,
    				mode  : pFlag
    				},
    		success: function(xml){
    			RtnVal = xml;
    		}
    	});
    }
    else if (pDocInfoValue == "2") {
        if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
        	pFlag = "END";
        else if (pListTypeValue == "21")
        	pFlag = "TMP";
        else
        	pFlag = "APR";

        $.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/getReceiptinfo.do",
    		data : {
    				docID : pDocID,
    				mode  : pFlag
    				},
    		success: function(xml){
    			RtnVal = xml;
    		}
    	});
    }

    if (document.getElementById("lvAprLine").innerHTML != "") document.getElementById("lvAprLine").innerHTML = "";

    if (RtnVal == "NOTPERMISSTION") {
        document.getElementById("lvAprLine").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
        document.getElementById("lvAprLine").style.textAlign = "center";
        return;
    }

    var AprLine = new ListView();                           
    AprLine.SetID("AprLine");                               
    AprLine.SetMulSelectable(false);                        
    AprLine.SetTitleIdx(arrySubTab[pDocInfoValue]);
    AprLine.SetRowOnDblClick("lvAprLine_DBSelChange");      
    AprLine.DataSource(RtnVal);                             
    AprLine.DataBind("lvAprLine");
}


var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction, type) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN() || NonActiveX == "YES") {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (type == undefined && CompleteFunction != undefined) {
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
            DivPopUpShow(330, 205, url);
        }
        else if (type == undefined && CompleteFunction == undefined) {
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
            DivPopUpShow(330, 205, url);
        }
        else if (type != undefined && CompleteFunction != "") {
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
            var OpenWin = window.open(url, "ezAPRALERT_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
        else if (type != undefined && CompleteFunction == "") {
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
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

    if (CrossYN() || NonActiveX == "YES") {
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
            var OpenWin = window.open(url, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
        else if (type != undefined && CompleteFunction == "") {
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
            var OpenWin = window.open(url, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
    }
    else {
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

        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
    }
    catch (e) {
        alert("openwindow :: " + e.description);
    }
}

function openergetDocInfo() {
    if (CallPage == "Left") return;

    try {
        if (pListTypeValue == "6")
            getSimsaDocList();
        else if (pListTypeValue == "4")
            getReceivedDocList();
            
        else if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
            getSendOutDocList();
        else
            getDocList();


        parent.frames["left"].getAprCount();
    } catch (e) {
        alert("openergetDocInfo :: " + e.description);
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
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();
        period = (nowyear - 1) + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030 + " ~ " + nowyear + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030;
    }
    else {
        period = document.getElementById("sel_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("sel_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
    }

    document.getElementById("TitleInfo").innerHTML = " &nbsp;[" + strLang942 + "<span style='color:#017BEC;font-weight:bold;'> " + pTotalCnt + " </span>" + strLang943 + " - " + period + "]";

    if (ViewLeftCount == "YES") {
        switch (pListTypeValue) {
            case "1":
                parent.frames["left"].document.getElementById("count1").innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "2":
                parent.frames["left"].document.getElementById("count3").innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "3":
                parent.frames["left"].document.getElementById("count2").innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "4":
                parent.frames["left"].document.getElementById("count4").innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "6":
                parent.frames["left"].document.getElementById("count6").innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "7":
                parent.frames["left"].document.getElementById("count7").innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "21":
                parent.frames["left"].document.getElementById("count21").innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
            case "99":
                parent.frames["left"].document.getElementById("count99").innerHTML = "<b>(" + pTotalCnt + ")</b>";
                break;
        }
    }

    strtext = "<div class='pagenavi'>";
    PagingHTML += strtext;
    if (totalPage > 1 && pageNum != 1) {
        strtext = "<span class='btnimg'><a onclick= 'return goToPageByNum(1)'>";
        strtext = strtext + "<img src='/images/kr/cm/btn_p_prev.gif' width='16' height='16' /></a></span>";
        PagingHTML += strtext;
    }
    else {
        strtext = "<span class='btnimg'><a >";
        strtext = strtext + "<img src='/images/kr/cm/btn_p_prev01.gif' width='16' height='16' /></a></span>";
        PagingHTML += strtext;
    }
    if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
            strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'>";
            strtext = strtext + "<img src='/images/kr/cm/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg'>";
            strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
            PagingHTML += strtext;
        }
    }
    else {
        strtext = "<span class='btnimg'>";
        strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang940 + "</span>";
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
    if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
            strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang941 + "</span><span class='btnimg' onclick='return selafterBlock()'>";
            strtext = strtext + "<img src='/images/kr/cm/btn_next.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang941 + "</span><span class='btnimg'>";
            strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif' width='16' height='16'></span>";

            PagingHTML += strtext;
        }
    }
    else {
        strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang941 + "</span><span class='btnimg'>";
        strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif' width='16' height='16'></span>";
        PagingHTML += strtext;
    }
    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'>";
        strtext = strtext + "<img src='/images/kr/cm/btn_n_next.gif' width='16' height='16' /></span>";
        PagingHTML += strtext;
    }
    else {
        strtext = "<span class='btnimg'>";
        strtext = strtext + "<img src='/images/kr/cm/btn_n_next01.gif' width='16' height='16' /></span>";
        PagingHTML += strtext;
    }
    PagingHTML += "</div>";
    td_Create1(PagingHTML);
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

    if (pListTypeValue == "1") {
        document.getElementById("tbtnApproveALL").style.display = "";
    }
    else {
        document.getElementById("tbtnGongRam").style.display = "none";

        document.getElementById("tbtnApprove2").style.display = "none";
        document.getElementById("tbtnApproveALL").style.display = "none";
    }

    if (pListTypeValue == "3" || pListTypeValue == "2" || pListTypeValue == "8" || pListTypeValue == "10")
        document.getElementById("tbar1").style.display = "none";
    else
        document.getElementById("tbar1").style.display = "";

    if (pListTypeValue != 1 && pListTypeValue != 4 && pListTypeValue != 10 && pListTypeValue != 99) {
        document.getElementById("tbtnRedraft").style.display = "none";		
        //SwapImage(document.getElementById("btnRedraft"), "dis");
        document.getElementById("tbtnRemoveDoc").style.display = "none";		
        document.getElementById("tbtnApprove").style.display = "none";		
        document.getElementById("tbtnApprove1").style.display = "none";
        document.getElementById("tbtnApprove2").style.displayd = "none";
        //document.getElementById("tbtnApproveALL").style.display = "none";
        document.getElementById("tbtnReceipt").style.display = "none";
        document.getElementById("tbtnReturn").style.display = "none";
        document.getElementById("tbtnSimsa").style.display = "none";
        document.getElementById("tbtnGongRam").style.display = "none";

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
                }
                else if (GetAttribute(tr, "DATA10") == "004") {
                    document.getElementById("tbtnRemoveDoc").style.display = "";	
                    document.getElementById("tbtnSimsa").style.display = "none";
                }
                else {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";		
                    document.getElementById("tbtnSimsa").style.display = "none";
                }
            }
            else {
                document.getElementById("tbtnRemoveDoc").style.display = "none";			
                document.getElementById("tbtnSimsa").style.display = "none";
            }
        }
        else if (pListTypeValue == "7") {
            document.getElementById("tbtnReceipt").style.display = "";
        }
        document.getElementById("tbtnRegList").style.display = "none";
        document.getElementById("tbtnLinkDraft").style.display = "none";

        if (pListTypeValue == 21) {//임시보관함
            document.getElementById("tbtnDraft").style.display = "";      
            document.getElementById("tbtnRedraft").style.display = "";
            document.getElementById("tbtnRemoveDoc").style.display = "";
            document.getElementById("tbtnTotalSave").style.display = "none";
        }
        else
            document.getElementById("tbtnTotalSave").style.display = "";
    }
    else if (pListTypeValue == 1 || pListTypeValue == 10 || pListTypeValue == 99)
    {
        document.getElementById("tbtnTotalSave").style.display = "";
        document.getElementById("tbtnSimsa").style.display = "none";
        //document.getElementById("tbtnGongRam").style.display = "";
        if (oArrRows.length > 0) {
            pFunctionType = GetAttribute(tr, "DATA10");
            document.getElementById("tbtnLinkDraft").style.display = "none";

            //20130311 cpno.64
            if (GetAttribute(tr, "DATA12") == "015" && pListTypeValue == 99)
                document.getElementById("tbtnGongRam").style.display = "";
            else
                document.getElementById("tbtnGongRam").style.display = "none";


            if (pFunctionType == "001")
            {
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
                document.getElementById("tbtnReturn").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
            }
            else if (GetAttribute(tr, "DATA12") == "015")
            {
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
                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnReturn").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
            }
            else if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
                if (pFunctionType == "004")
                    document.getElementById("tbtnRegList").style.display = "";
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
                document.getElementById("tbtnReturn").style.display = "none";

                if (GetAttribute(tr, "DATA9") != "0") {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                    returnYN(GetAttribute(tr, "DATA1"));

                    if (GetAttribute(tr, "DATA15") == "001")
                        document.getElementById("tbtnReturn").style.display = "none";;
                }
                else if (GetAttribute(tr, "DATA12") == "011" || GetAttribute(tr, "DATA12") == "012") {
                    document.getElementById("tbtnRemoveDoc").style.display = "none";
                    returnYN(GetAttribute(tr, "DATA1"));

                    if (GetAttribute(tr, "DATA15") == "001")
                        document.getElementById("tbtnReturn").style.display = "none";;
                }
                else {
                    document.getElementById("tbtnRemoveDoc").style.display = "";
                    document.getElementById("tbtnReturn").style.display = "none";
                }
            }
            else {
                document.getElementById("tbtnDraft").style.display = "";
                //SwapImage(document.getElementById("btnDraft"), "");
                document.getElementById("tbtnRedraft").style.display = "none";
                //SwapImage(document.getElementById("btnRedraft"), "dis");
                document.getElementById("tbtnRemoveDoc").style.display = "none";
                document.getElementById("tbtnApprove").style.display = "";
                document.getElementById("tbtnApprove1").style.display = "";
                //document.getElementById("tbtnApproveALL").style.display = "";

                document.getElementById("tbtnReceipt").style.display = "none";
                document.getElementById("tbtnReturn").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "none";
                document.getElementById("tbtnLinkDraft").style.display = "none";
            }
            document.getElementById("tbtnViewDoc").style.display = "";
        }
        else {
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
            document.getElementById("tbtnViewDoc").style.display = "none";
            document.getElementById("tbtnReturn").style.display = "none";
            document.getElementById("tbtnRegList").style.display = "none";
            document.getElementById("tbtnLinkDraft").style.display = "none";
            document.getElementById("tbtnApproveALL").style.display = "none";
            document.getElementById("tbtnGongRam").style.display = "none";
        }
    }
    else
    {
        document.getElementById("tbtnSimsa").style.display = "none";
        //20130311 cpno.64
        document.getElementById("tbtnGongRam").style.display = "none";
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

                if (tr.getAttribute("DATA9") == "003" || tr.getAttribute("DATA9") == "014")
                    document.getElementById("tbtnReturn").style.display = "none";
                else {
                    returnYN(tr.getAttribute("DATA1"));

                    if (tr.getAttribute("DATA15") == "001")
                        document.getElementById("tbtnReturn").style.display = "none";
                }
            }
            else if (pFunctionType == "015") {
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
                document.getElementById("tbtnReturn").style.display = "none";
                document.getElementById("tbtnRegList").style.display = "";
            }
            document.getElementById("tbtnViewDoc").style.display = "";
        }
        else {
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
            document.getElementById("tbtnReturn").style.display = "none";
            document.getElementById("tbtnRegList").style.display = "none";
            document.getElementById("tbtnLinkDraft").style.display = "none";
        }
    }

    if (oArrRows.length != 0) {
        if (pListTypeValue == 4 && tr.getAttribute("DATA7") != "" && tr.getAttribute("DATA9") == "011")
            document.getElementById("tDocInfo").style.display = "";
        else if (pListTypeValue != 4 && tr.getAttribute("DATA2") != "" && tr.getAttribute("DATA12") == "011")
            document.getElementById("tDocInfo").style.display = "";
        else
            document.getElementById("tDocInfo").style.display = "none";
    }
    else
        document.getElementById("tDocInfo").style.display = "none";

    if (pListTypeValue != "2" && pListTypeValue != "3") {
        document.getElementById("tbtncallback").style.display = "none";
    }

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
        document.getElementById("tbtnReturn").style.display = "none";
        document.getElementById("tbtncallback").style.display = "none";
        document.getElementById("tbtnRegList").style.display = "none";
        document.getElementById("tbtnLinkDraft").style.display = "none";

        try {
            document.getElementById("tbtnSimsa").style.display = "none";
        } catch (e) { }
    }

    if (pListTypeValue != "4" && pListTypeValue != "1") {
        document.getElementById("tbtnReturn").style.display = "none";
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
            getDataInfo("2");
            break;
    }
}

function getDataInfo(jobState) {
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);


    switch (jobState) {
        case "3":
            
            if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "END");
            else if(pListTypeValue == "21")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "TMP");
            else
                createNodeAndInsertText(xmlpara, objNode, "Flag", "APR");

            xmlhttp.open("POST", "aspx/getTotalAttachInfo.aspx", true);
            break;

        case "4":
            
            if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "END");
            else if (pListTypeValue == "21")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "TMP");
            else
                createNodeAndInsertText(xmlpara, objNode, "Flag", "APR");

            xmlhttp.open("POST", "aspx/getOpinionInfo.aspx", true);
            break;

        case "1":
            
            if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "END");
            else if (pListTypeValue == "21")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "TMP");
            else
                createNodeAndInsertText(xmlpara, objNode, "Flag", "APR");

            xmlhttp.open("POST", "ezaprline/aspx/GetLineList.aspx", false);
            break;

        case "2":
            
            if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "END");
            else if (pListTypeValue == "21")
                createNodeAndInsertText(xmlpara, objNode, "Flag", "TMP");
            else
                createNodeAndInsertText(xmlpara, objNode, "Flag", "APR");

            xmlhttp.open("POST", "aspx/getReceiptinfo.aspx", true);
            break;
    }
    xmlhttp.onreadystatechange = getdoclistSub_after;
    xmlhttp.send(xmlpara);
}

function getdoclistSub_after() {
    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        try {
            if (document.getElementById("lvAprLine").innerHTML != "") document.getElementById("lvAprLine").innerHTML = "";
            if (xmlhttp.responseText == "NOTPERMISSTION") {
                document.getElementById("lvAprLine").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
                document.getElementById("lvAprLine").style.textAlign = "center";
                return;
            }

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
    else
        return;
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
    if (beforeJob != pListTypeValue || SelYearFlag) {
        beforeJob = pListTypeValue;
        pageNum = 1;
        OrderOption = "";
        OrderCell = "";
    }

    if (SQLPARADATA == "") {
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        if (nowmonth < 10)
            nowmonth = "0" + nowmonth;

        if (nowday < 10)
            nowday = "0" + nowday;

        SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
    }

    CurrentDocList = "Simsa";
    
    $.ajax({
		type : "POST",
		dataType : "xml",
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
			getReceivedDocList_after(xml);
		}        			
	});
}

function doCancel(pDocID, tempListType) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "ASSIGN");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);

    xmlhttp.open("POST", "aspx/doCancel.aspx", false);
    xmlhttp.send(xmlpara);

    var RtnVal = getNodeText(xmlhttp.responseXML.documentElement);

    if (RtnVal == "TRUE") {
        if (tempListType == "3") {
            var pAlertContent = strLang891 + "<br> " + strLang892;
            OpenAlertUI(pAlertContent, "", "OPEN");
        }
        else {
            var pAlertContent = strLang893 + "<br> " + strLang894;
            OpenAlertUI(pAlertContent, "", "OPEN");
        }
        getDocList();

        try {
            parent.frames["left"].getAprCount();
        }
        catch (e) { }
    }
    else if (RtnVal == "ERR01") {
        var pAlertContent = strLang895;
        OpenAlertUI(pAlertContent, "", "OPEN");
    }
    else if (RtnVal == "ERR02") {
        var pAlertContent = strLang896;
        OpenAlertUI(pAlertContent, "", "OPEN");
    }
    else if (RtnVal == "ERR03") {
        var pAlertContent = strLang897;
        OpenAlertUI(pAlertContent, "", "OPEN");
    }
    else {
        var pAlertContent = strLang898;
        OpenAlertUI(pAlertContent, "", "OPEN");
    }
}

var xmlhttp3;
var temppDocID;
function cancelYN(pDocID) {
    temppDocID = pDocID;
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : true,
		url : "/ezApprovalG/doCanCelYN.do",
		data : {
			docID : pDocID,
			userID : pUserID
		},
		success: function(xml){
			cancelYN_after(xml);
		}
	});
}
function cancelYN_after(xml) {
    var RtnVal = getNodeText(xml.documentElement);
    if (RtnVal == "CALLBACK" && pListTypeValue == "2" && !GetBujaeFlag()) {
        document.getElementById("tbtncallback").style.display = "";
        document.getElementById("tbtnforcecallback").style.display = "none";
    }
    else if (RtnVal == "CANCEL" && pListTypeValue == "3" && !GetBujaeFlag()) {
        document.getElementById("tbtncallback").style.display = "";
        document.getElementById("tbtnforcecallback").style.display = "none";
    }
    else {
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/doForceCancelYN.do",
    		data : {
    			docID : temppDocID,
    			userID : pUserID
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});
    	
        var RtnVal = getNodeText(result.documentElement);
        if (RtnVal == "TRUE")
            document.getElementById("tbtnforcecallback").style.display = "";
        else
            document.getElementById("tbtnforcecallback").style.display = "none";

        document.getElementById("tbtncallback").style.display = "none";
        temppDocID = null;
    }
}

function returnYN(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/gongRamDocInfo.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}
	});
	
    var RtnVal = getNodeText(result.documentElement);
    if (RtnVal == "NONE")
        document.getElementById("tbtnReturn").style.display = "";
    else
        document.getElementById("tbtnReturn").style.display = "none";
    
}

function returnYN_after() {
    if (xmlhttp2.readyState == 4 && xmlhttp2.status == 200) {
        try {
            var RtnVal = getNodeText(xmlhttp2.responseXML.documentElement);
            if (RtnVal == "NONE")
                document.getElementById("tbtnReturn").style.display = "";
            else
                document.getElementById("tbtnReturn").style.display = "none";

            xmlhttp2 = null;
        }
        catch (e) {
        }
    }
    else
        return;
}

function RemoveDocCabinet(tempDocID, FLAG) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", tempDocID);
    createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "pDeptName", arr_userinfo[15]);
    createNodeAndInsertText(xmlpara, objNode, "FLAG", FLAG);
    createNodeAndInsertText(xmlpara, objNode, "pDeptName2", arr_userinfo[16]);

    xmlhttp.open("POST", "aspx/RemoveDocCabinetInfo.aspx", false);
    xmlhttp.send(xmlpara);

    var RtnVal = getNodeText(xmlhttp.responseXML.documentElement);

    if (RtnVal == "TRUE") {
        if (FLAG == "")
            var pAlertContent = strLang899;
        else
            var pAlertContent = strLang900;
        OpenAlertUI(pAlertContent, RemoveDocCabinet_Complete, "OPEN");
        return;
    }
    else {
        if (FLAG == "")
            var pAlertContent = strLang901;
        else
            var pAlertContent = strLang902;
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
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER"); 
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);

    xmlhttp.open("POST", "aspx/GetFormConnFlag.aspx", false);
    xmlhttp.send(xmlpara);

    if (getNodeText(xmlhttp.responseXML.documentElement) == "Y")
        return true;
    else
        return false;
}

function CheckAprLineInfo(tr) {
    var xmldom = createXmlDom();
    try {
        xmldom = getAprLineInfo(tr);

        if (xmldom.getElementsByTagName("ROW").length > 0) {
            if (CrossYN()) {
                var pDeptID = xmldom.getElementsByTagName("DATA6").item(xmldom.getElementsByTagName("ROW").length - 1).textContent;
            }
            else {
                var pDeptID = xmldom.getElementsByTagName("DATA6").item(xmldom.getElementsByTagName("ROW").length - 1).text;
            }
            if (pDeptID == arr_userinfo[4])
                return "OK";
            else {
                if (CrossYN()) {
                    var pDeptName = xmldom.getElementsByTagName("ROW").item(xmldom.getElementsByTagName("ROW").length - 1).childNodes.item(7).textContent;
                }
                else {
                    var pDeptName = xmldom.getElementsByTagName("ROW").item(xmldom.getElementsByTagName("ROW").length - 1).childNodes.item(7).text;
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
    var pDocID

    if (pSelMenu == "hyubjo" || pSelMenu == "gamsa")
        pDocID = tr.getAttribute("DATA7");
    else
        pDocID = tr.getAttribute("DATA1");

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Mode", "APR");

    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "ezaprline/aspx/GetLineList.aspx", false);
    xmlhttp.send(xmlpara);

    if (xmlhttp.statusText == "OK")
        return xmlhttp.responseXML;
    else
        return "";
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
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA"); // Root Node 생성
    createNodeAndInsertText(xmlpara, objNode, "TMPDOCID", tmpDocID);

    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("POST", "aspx/MakeTmp2Ing.aspx", false);
    xmlhttp.send(xmlpara);

    return getNodeText(xmlhttp.responseXML.documentElement);
}
function openServerDraftUI(pDraftFlag, pCurSelRow) {
    var pArgument = new Array();
    pArgument[0] = pUserID;
    pArgument[1] = formURL;
    pArgument[2] = pDraftFlag;
    pArgument[3] = formDocType;

    var pDocSN = pCurSelRow.getAttribute("DATA1");

    var newDocID = MakeTmp2Ing(pDocSN);

    if (pCurSelRow) {
        pArgument[4] = "0";    //susinSN 
        pArgument[5] = "";     //DocState
        pArgument[6] = "";     // 결재처리 상태
        pArgument[7] = newDocID;
    }
    else {
        pArgument[4] = "0"
        pArgument[5] = ""
        pArgument[6] = ""
        pArgument[7] = "";
    }

    //우선 만들고 tmpDocID를 넘겨주어야 한다.	
    var openLocation = "";
    if (CrossYN() || NonActiveX == "YES") {
        openLocation = "/ezApprovalG/draftui.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
    }
    else {
        if (pUse_Editor == "TAGFREE") {
            openLocation = "/myoffice/ezApprovalG/DraftUI/draftui_TFI.aspx?formURL=" + encodeURI(pArgument[1]) + "&DraftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        }
        else {
            openLocation = "/myoffice/ezApprovalG/DraftUI/draftui.aspx?formURL=" + encodeURI(pArgument[1]) + "&DraftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        }
    }


    
    openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
    openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&docSN=" + encodeURI(pDocSN)


    openwindow(openLocation, "", 890, 560);
}

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
		}
	});
	
    var RtnVal = result;
    if (RtnVal.indexOf("TRUE") == -1) {
        var pAlertContent = strLang872;
        OpenAlertUI(pAlertContent);
    }
    else {
        var pAlertContent = strLang802;
        OpenAlertUI(pAlertContent);
        openergetDocInfo();
    }
}