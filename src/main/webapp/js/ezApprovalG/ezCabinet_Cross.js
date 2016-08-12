var ListTypeFlag;
var g_SelCabXml = "";
var g_TransFlag = "0";
var g_szParamXml = "";
var g_CabSearchParamXml = "";
var g_RecSearchParamXml = "";
var g_DeliverySearchParamXml = "";

var g_HeaderInfoXml = "";

var g_SortField = "", g_SortType = "", g_OrderBy = "";

var g_bConfirm = false;
var g_bRecAdmin = false;	
var g_bDeptCharger = false;	
var g_bCabCharger = false;

var g_ItemDeptID;
var g_OtherDeptDocViewRight = false;

var g_CabListXmlhttp = null;
var totalPage = "";
var pTotalCnt = "";
function ChkCabRoleInfo(selRow) {
    var ConfirmFlag;
    var CabClassNo;
    var MenuType;

    if (selRow != null) {
        if (ListTypeFlag == "2" || ListTypeFlag == "3") {
            MenuCtl_Trans();
        }
        else {
            if (DocList_Flag == "CABINET") {
                ConfirmFlag = selRow.getAttribute("DATA4");
                CabClassNo = selRow.getAttribute("DATA2");
                g_ItemDeptID = selRow.getAttribute("DATA5");
                g_ItemDeptID = g_ItemDeptID.trim();

                MenuType = "0";
            }
            else if (DocList_Flag == "RECORD") {
                ConfirmFlag = selRow.getAttribute("DATA9");
                CabClassNo = selRow.getAttribute("DATA10");
                g_ItemDeptID = selRow.getAttribute("DATA11");

                g_ItemDeptID = g_ItemDeptID.trim();

                MenuType = "1";
            }

            if (ConfirmFlag == "1")
                g_bConfirm = true;
            else
                g_bConfirm = false;

            g_bCabCharger = ISCabCharger(CabClassNo, UserID);
            ezCabMunuCtl(MenuType, selRow);
        }
    }
}

function SwapIcon(objImg, szVal) {
    if (objImg) {
        objImg.Enable = szVal;
    }
}

function ezCabMunuCtl(MenuType, selRow) {
    var ModRight = GetChangeRight();

    var pModRight_Flag = true;

    if (ModRight == "true")
        pMenuFlag = "";
    else
        pMenuFlag = "none";

    switch (MenuType) {
        case "0":
            if (typeof (tdNewVol) != "undefined" && typeof (tdNewVol) != "unknown") {
                document.getElementById("tdNewVol").style.display = pMenuFlag;
            }

            if (typeof (tdModifyCab) != "undefined" && typeof (tdModifyCab) != "unknown") {

                document.getElementById("tdModifyCab").style.display = pMenuFlag;
            }

            if (selRow.getAttribute("DATA6") == "0") {
                if (typeof (tdbtnEndProduce) != "undefined" && typeof (tdbtnEndProduce) != "unknown") {
                    if (GetCabChargerRight() == "true" && ListTypeFlag == "8") {
                        document.getElementById("tdbtnEndProduce").style.display = "";
                        //SwapImage(btnEndProduce, "");
                    }
                    else {
                        document.getElementById("tdbtnEndProduce").style.display = "none";
                        //SwapImage(btnEndProduce, "dis");
                    }
                }

                if (typeof (tdbtnCancelEndProd) != "undefined" && typeof (tdbtnCancelEndProd) != "unknown") {
                    document.getElementById("tdbtnCancelEndProd").style.display = "none";
                    //SwapImage(btnCancelEndProd, "dis");
                }
            }
            else {
                if (typeof (tdbtnEndProduce) != "undefined" && typeof (tdbtnEndProduce) != "unknown") {
                    document.getElementById("tdbtnEndProduce").style.display = "none";
                    //SwapImage(btnEndProduce, "dis");
                }

                if (typeof (tdbtnCancelEndProd) != "undefined" && typeof (tdbtnCancelEndProd) != "unknown") {
                    if (GetCabChargerRight() == "true" && ListTypeFlag == "8") {
                        document.getElementById("tdbtnCancelEndProd").style.display = "";
                        //SwapImage(btnCancelEndProd, "");
                    }
                    else {
                        document.getElementById("tdbtnCancelEndProd").style.display = "none";
                        //SwapImage(btnCancelEndProd, "dis");
                    }
                }
            }

            if (typeof (tdViewCabHist) != "undefined" && typeof (tdViewCabHist) != "unknown") {
                if (IsUserDeptRec() == "true")
                    document.getElementById("tdViewCabHist").style.display = "";
                else
                    document.getElementById("tdViewCabHist").style.display = "none";
            }


            if (typeof (tdSetCharger) != "undefined" && typeof (tdSetCharger) != "unknown") {
                if (IsUserDeptRec() == "true")
                    document.getElementById("tdSetCharger").style.display = "";
                else
                    document.getElementById("tdSetCharger").style.display = "none";
            }

            break;

        case "1":

            if (typeof (tdRegRecord) != "undefined" && typeof (tdRegRecord) != "unknown") {
                if (GetCabChargerRight() == "true")
                    document.getElementById("tdRegRecord").style.display = "";
                else
                    document.getElementById("tdRegRecord").style.display = "none";
            }

            if (typeof (tdRegSepAtt) != "undefined" && typeof (tdRegSepAtt) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    if (GetCabChargerRight() == "true")
                        document.getElementById("tdRegSepAtt").style.display = "";
                    else
                        document.getElementById("tdRegSepAtt").style.display = "none";
                }
                else {
                    document.getElementById("tdRegSepAtt").style.display = "none";
                }
            }

            if (typeof (tdMoveRec) != "undefined" && typeof (tdMoveRec) != "unknown")
                document.getElementById("tdMoveRec").style.display = pMenuFlag;

            if (typeof (tdModifyRec) != "undefined" && typeof (tdModifyRec) != "unknown")
                document.getElementById("tdModifyRec").style.display = pMenuFlag;

            if (typeof (ichange_Rec) != "undefined" && typeof (ichange_Rec) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    if (IsUserDeptRec() == "true" && document.getElementById("tdichange_Rec").style.display == "") {
                        document.getElementById("ichange_Rec").style.display = "";
                        document.getElementById("tdichange_Rec").style.display = "";
                        //SwapImage(ichange_Rec, "");
                    }
                    else {
                        document.getElementById("ichange_Rec").style.display = "none";
                        document.getElementById("tdichange_Rec").style.display = "none";
                        //SwapImage(ichange_Rec, "dis");
                    }
                }
                else {
                    document.getElementById("ichange_Rec").style.display = "none";
                    document.getElementById("tdichange_Rec").style.display = "none";
                    //SwapImage(ichange_Rec, "dis");
                }
            }

            if (typeof (tdNotify_Rec) != "undefined" && typeof (tdNotify_Rec) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    if (IsUserDeptRec() == "true")
                        document.getElementById("tdNotify_Rec").style.display = "";
                    else
                        document.getElementById("tdNotify_Rec").style.display = "none";
                }
                else {
                    document.getElementById("tdNotify_Rec").style.display = "none";
                }
            }

            if (typeof (tddisplaySend_Rec) != "undefined" && typeof (tddisplaySend_Rec) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    if (IsUserDeptRec() == "true")
                        document.getElementById("tddisplaySend_Rec").style.display = "";
                    else
                        document.getElementById("tddisplaySend_Rec").style.display = "none";
                }
                else {
                    document.getElementById("tddisplaySend_Rec").style.display = "none";

                }
            }

            if (typeof (tdVeiwRecHist) != "undefined" && typeof (tdVeiwRecHist) != "unknown") {
                if (IsUserDeptRec() == "true" && document.getElementById("tdVeiwRecHist").style.display == "")
                    document.getElementById("tdVeiwRecHist").style.display = "";
                else
                    document.getElementById("tdVeiwRecHist").style.display = "none";
            }

            if (typeof (tdbtnViewRecReadHist) != "undefined" && typeof (tdbtnViewRecReadHist) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00") {
                    if (IsUserDeptRec() == "true" && document.getElementById("tdbtnViewRecReadHist").style.display == "")
                        document.getElementById("tdbtnViewRecReadHist").style.display = "";
                    else
                        document.getElementById("tdbtnViewRecReadHist").style.display = "none";
                }
                else {
                    document.getElementById("tdbtnViewRecReadHist").style.display = "none";
                }
            }

            if (typeof (tdbtnCardSend) != "undefined" && typeof (tdbtnViewRecReadHist) != "unknown") {

                if (selRow.getAttribute("DATA8") == "00") {
                    if (selRow.getAttribute("DATA12") == "7") {
                        if (IsUserDeptRec() == "true")
                            document.getElementById("tdbtnViewRecReadHist").style.display = "";
                        else
                            document.getElementById("tdbtnViewRecReadHist").style.display = "none";
                    }
                    else {
                        document.getElementById("tdbtnCardSend").style.display = "none";
                    }
                }
                else {
                    document.getElementById("tdbtnCardSend").style.display = "none";
                }
            }

            if (typeof (tdichange_Rec) != "undefined" && typeof (tdichange_Rec) != "unknown") {
                if (selRow.getAttribute("DATA8") == "00" && selRow.getAttribute("DATA13") == "0") {
                    document.getElementById("ichange_Rec").style.display = "";
                    document.getElementById("tdichange_Rec").style.display = "";
                    //SwapImage(ichange_Rec, "");
                }
                else {
                    document.getElementById("ichange_Rec").style.display = "none";
                    document.getElementById("tdichange_Rec").style.display = "none";
                    //SwapImage(ichange_Rec, "dis");
                }
            }
            break;
    }

    if (ListTypeFlag == "9") {
        SetMenuBtn("tdModifyCab", "none");
        SetMenuBtn("tdViewCabHist", "none");
        SetMenuBtn("tdSetCharger", "none");
        SetMenuBtn("tdbtnViewRecList", "none");
        SetMenuBtn("tbar1", "none");
        SetMenuBtn("tdNewVol", "none");
    }
}
function SetMenuBtn(sbtnname, sbtnstyle) {
    if (document.getElementById(sbtnname) != null)
        document.getElementById(sbtnname).style.display = sbtnstyle;
}

function IsUserDeptRec() {
    if (AdminYN == "TRUE") {
        return "true";
    }
    else {
        if (g_ItemDeptID == DeptID)	
        {
            return "true";
        }
        else
        {
            return "false";
        }
    }
}
function GetCabChargerRight() {
    if (AdminYN == "TRUE") {
        return "true";
    }
    else {
        if (g_ItemDeptID == DeptID)
        {
            if (g_bRecAdmin)
            {
                return "true";
            }
            else			
            {
                return g_bCabCharger.toString();
            }
        }
        else	
        {
            return "false";
        }
    }
}

function GetChangeRight() {
    if (AdminYN == "TRUE") {
        return "true";
    }
    else {
        if (g_ItemDeptID == DeptID)	
        {
            if (g_bRecAdmin)
            {
                return "true";
            }
            else {
                if (g_bConfirm)	
                {
                    return "false";
                }
                else
                {
                    return g_bCabCharger.toString();
                }
            }
        }
        else	
        {
            return "false";
        }
    }
}

function InitGlobals(ListFlag, ListType, MenuType) {
    curpage = 1;
    nowblock = 0;
    totalPage = 0;

    DocList_Flag = ListFlag;
    ListTypeFlag = ListType;

    if (ListFlag == "CABINET") {
        //g_CabSearchParamXml = "";
        try {
            if (trSubInfoTab) {
                document.getElementById("trSubInfoTab").style.display = "none";
                document.getElementById("divList").style.height = "385";

                //PageSize = 10;
                Block_Size = 10;
            }
        } catch (e) { }
    }
    else if (ListFlag == "RECORD") {
        g_SelCabXml = "";
        //g_RecSearchParamXml = "";
        try {
            if (trSubInfoTab) {
                document.getElementById("trSubInfoTab").style.display = "";
                document.getElementById("divList").style.height = "310";
                //PageSize = 10;
                Block_Size = 10;
            }
        } catch (e) { }
    }

    g_SortField = "";
    g_SortType = "";
    g_OrderBy = "";

    GetHearderXml();
    InitSubMenu(MenuType);
}


function GetCabHistList() {
    DocList_Flag = "CABHIST";

    switch (ListTypeFlag) {
        case "2":
            GetTransListXml("P03");
            break;

        case "3":
            GetTransListXml("T03");
            break;

        case "4":
            g_CabSearchParamXml = "";
            GetTransListXml("T03");
            break;
    }
    InitSubMenu();
}

function GetRecHistList() {
    DocList_Flag = "RECHIST";
    switch (ListTypeFlag) {
        case "2":
            GetTransListXml("P04");
            break;

        case "3":
            GetTransListXml("T04");
            break;

        case "4":
            g_CabSearchParamXml = ""; 
            GetTransListXml("T04");
            break;
    }
    InitSubMenu();
}

function GetSCList() {
    DocList_Flag = "SCLIST";
    switch (ListTypeFlag) {
        case "2":
            GetTransListXml("P05");
            break;

        case "3": 
            GetTransListXml("T05");
            break;

        case "4": 
            g_CabSearchParamXml = ""; 
            GetTransListXml("T05");
            break;
    }
    InitSubMenu();
}

function GetAttachList() {
    DocList_Flag = "ATTACH";

    switch (ListTypeFlag) {
        case "2":
            GetTransListXml("P06");
            break;

        case "3":
            GetTransListXml("T06");
            break;

        case "4": 
            g_CabSearchParamXml = "";
            GetTransListXml("T06");
            break;
    }
    InitSubMenu();
}

function GetDistList() {
    DocList_Flag = "DISTLIST";

    GetTransListXml("P07");	

    InitSubMenu();
}

function GetCaninetList() {
    if (isPeriodYear && g_CabSearchParamXml == "") {
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        if (nowmonth < 10)
            nowmonth = "0" + nowmonth;

        if (nowday < 10)
            nowday = "0" + nowday;

        g_CabSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><TASKCODE></TASKCODE><SPRODUCEY>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00.001</SPRODUCEY><EPRODUCEY>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59.999</EPRODUCEY><SENDY></SENDY><EENDY></EENDY><RECTYPECODE></RECTYPECODE><KEEPPERIOD></KEEPPERIOD><KEEPMETHOD></KEEPMETHOD><KEEPPLACE></KEEPPLACE><CHARGER></CHARGER><TRANSEXPIRE/><TRANSFLAG/><RECEIVEDCAB/><GIVECAB/></SEARCHPARAM>";
    }

    switch (ListTypeFlag) {
        case "2": 
            GetTransListXml("P01");
            break;

        case "3": 
            GetTransListXml("T01");
            break;

        case "4": 
            g_CabSearchParamXml = "<SEARCHPARAM><TRANSFLAG>16=0</TRANSFLAG></SEARCHPARAM>";
            GetTransListXml("T01");
            break;

        default:
            GetCaninetListXml();
    }
}

function GetRecordList() {
    if (g_RecSearchParamXml == "") {
        var nowyear = new Date().getFullYear();
        var nowmonth = new Date().getMonth() + 1;
        var nowday = new Date().getDate();

        if (nowmonth < 10)
            nowmonth = "0" + nowmonth;

        if (nowday < 10)
            nowday = "0" + nowday;

        g_RecSearchParamXml = "<SEARCHPARAM><DEPTCODE>" + DeptID + "</DEPTCODE><TITLE></TITLE><REGTYPE></REGTYPE><SREGDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + " 00:00:00.001</SREGDATE><EREGDATE>" + nowyear + "-" + nowmonth + "-" + nowday + " 23:59:59.999</EREGDATE><CHARGER></CHARGER><SC></SC><TRANSEXPIRE/><DRAFTER></DRAFTER><CABTITLE></CABTITLE></SEARCHPARAM>";
    }

    switch (ListTypeFlag) {
        case "2": 
            GetTransListXml("P02");
            break;

        case "3": 
            GetTransListXml("T02");
            break;

        case "4": 
            GetTransListXml("T02");
            break;

        default:
            GetRecordListXml();
    }
}

function GetTransListXml(ListType) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "LISTTYPE", ListType);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "ORDERBY", g_OrderBy);

    if (g_CabSearchParamXml != "")	
    {
        var oSParam = loadXMLString(g_CabSearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);
    }

    g_szParamXml = getXmlString(xmlpara);

    g_CabListXmlhttp = createXMLHttpRequest();
    g_CabListXmlhttp.open("POST", "/ezApprovalG/getTransList.do", true);
    g_CabListXmlhttp.onreadystatechange = onreadystatechange_CabList;
    g_CabListXmlhttp.send(xmlpara);

}

function GetCaninetListXml() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "LISTFLAG", ListTypeFlag);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "ORDERBY", g_OrderBy);

    if (g_CabSearchParamXml != "")	
    {
        var oSParam = loadXMLString(g_CabSearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);
    }
    else if (g_RecSearchParamXml != "") {
        var oSParam = loadXMLString(g_RecSearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);
    }

    g_szParamXml = getXmlString(xmlpara);

    g_CabListXmlhttp = createXMLHttpRequest();
    g_CabListXmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_GetCabinetList.aspx", true);
    g_CabListXmlhttp.onreadystatechange = onreadystatechange_CabList;
    g_CabListXmlhttp.send(xmlpara);
}


function onreadystatechange_CabList() {
    var Resultxml;
    var iStatus;

    if (g_CabListXmlhttp != null) {
        if (g_CabListXmlhttp.readyState == 4 && g_CabListXmlhttp.status == 200) {
            Resultxml = g_CabListXmlhttp.responseXML;
            iStatus = g_CabListXmlhttp.status;

            switch (iStatus) {
                case 200:
                case 201:
                case 204:
                case 207:
                    if (getXmlString(Resultxml) == "" || getNodeText(GetChildNodes(Resultxml)) == "FALSE") {
                        OpenAlertUI(strLang548);
                        return null;
                    }

                    if (iStatus == 207) {
                        var nodeStatus = SelectSingleNode(Resultxml, "a:multistatus/a:response[a:status $ge$ 'HTTP/1.1 4']");
                        if (nodeStatus != null) {
                            OpenAlertUI(strLang548);
                            return null;
                        }
                    }

                    InsertToCabListView(Resultxml);
                    break;

                default:
                    OpenAlertUI(strLang548);
                    return null;
            }
            g_CabListXmlhttp = null;
        }
    }
}

function InsertToCabListView(Resultxml) {
    try {
        ListViewData = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
        NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALDOCCOUNT");

        if (ListViewData == null)
            return;

        NodeListLen = 0;

        
        if (NodeList2 != null) {
            var cnt = getNodeText(NodeList2);
            if (cnt != "")
                NodeListLen = cnt;
            else
                NodeListLen = 0;
        }

        var xmlDoc
        if (CrossYN()) {
            var xmlLIST = createXmlDom();
            var nodeToImport = xmlLIST.importNode(ListViewData, true);
            xmlLIST.appendChild(nodeToImport);

            xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
        }
        else {
            xmlDoc = createXmlDom();
            xmlDoc.appendChild(ListViewData);
        }

        if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DocList");                               
        DocList.SetMulSelectable(true);                        
                                  
        DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");      
        DocList.SetRowOnClick("lvtDoclist_SelChange");           
        DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
        DocList.SetOrderbyCol("COLNAME");
        DocList.SetTitleIdx(0);                                  

        DocList.DataSource(ListViewData);                             
        DocList.DataBind("lvtDoclist");                          
        DocList = null;

        makePageSelPage(NodeListLen);
        DisplayLineCnt_ezCab(NodeListLen);

        selFirstRow(Resultxml);
    } catch (e) { }
}

function GetRecordListXml() {
    var xmlpara = createXmlDom();
    var objNode, objChildNode;
    objNode = createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "USERID", UserID);
    createNodeAndInsertText(xmlpara, objNode, "TRANSFLAG", g_TransFlag);
    createNodeAndInsertText(xmlpara, objNode, "LISTFLAG", ListTypeFlag);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "ORDERBY", g_OrderBy);

    if (g_RecSearchParamXml != "")
    {
        var oSParam = loadXMLString(g_RecSearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);
    }
    objChildNode = createNodeAndAppandNode(xmlpara, objNode, objChildNode, "CABINETINFO");

    var i, len;
    if (g_SelCabXml != "")	
    {
        var CabListXml = loadXMLString(g_SelCabXml);

        var objCabs = SelectNodes(CabListXml, "CABINETID");
        //len = objCabs.length;

        for (i = 0; i < objCabs.length; i++) {
            try{
                objChildNode.appendChild(objCabs[i]);
            }
            catch (e) {
                objChildNode.appendChild(objCabs[0]);
            }
        }
    }

    g_szParamXml = getXmlString(xmlpara);

    g_CabListXmlhttp = createXMLHttpRequest();
    g_CabListXmlhttp.open("POST", "/ezApprovalG/getRecordList.do", true);
    g_CabListXmlhttp.onreadystatechange = onreadystatechange_RecList;
    g_CabListXmlhttp.send(xmlpara);
}

function InsertToRecListView(Resultxml) {
    try {
        ListViewData = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
        NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALDOCCOUNT");

        if (ListViewData == null)
            return;

        NodeListLen = 0;

        
        if (NodeList2 != null) {
            var cnt = getNodeText(NodeList2);
            if (cnt != "")
                NodeListLen = cnt;
            else
                NodeListLen = 0;
        }

        var xmlDoc
        if (CrossYN()) {
            var xmlLIST = createXmlDom();
            var nodeToImport = xmlLIST.importNode(ListViewData, true);
            xmlLIST.appendChild(nodeToImport);
            xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
        }
        else {
            xmlDoc = createXmlDom();
            xmlDoc.appendChild(ListViewData);
        }

        if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DocList");                               
        DocList.SetMulSelectable(true);                        
                                  
        DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");      
        DocList.SetRowOnClick("lvtDoclist_SelChange");           
        DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
        DocList.SetOrderbyCol("COLNAME");
        DocList.SetTitleIdx(0);                                 
        DocList.SetSecurityFlag(true);
        DocList.DataSource(xmlDoc);                             
        DocList.DataBind("lvtDoclist");                          
        DocList = null;

        makePageSelPage(NodeListLen);

        DisplayLineCnt_ezCab(NodeListLen);
        selFirstRow(Resultxml);
    } catch (e) { }
}

function onreadystatechange_RecList() {
    var Resultxml;
    var iStatus;

    if (g_CabListXmlhttp != null) {
        if (g_CabListXmlhttp.readyState == 4 && g_CabListXmlhttp.status == 200) {
            if (typeof (CheckBtnSetRecRole) == "function")
                CheckBtnSetRecRole();
            Resultxml = g_CabListXmlhttp.responseXML;
            iStatus = g_CabListXmlhttp.status;

            switch (iStatus) {
                case 200:
                case 201:
                case 204:
                case 207:
                    if (getXmlString(Resultxml) == "" || getNodeText(GetChildNodes(Resultxml)) == "FALSE") {
                        OpenAlertUI(strLang555);
                        return null;
                    }

                    if (iStatus == 207) {
                        var nodeStatus = SelectSingleNode(Resultxml, "a:multistatus/a:response[a:status $ge$ 'HTTP/1.1 4']");
                        if (nodeStatus != null) {
                            OpenAlertUI(strLang555);
                            return null;
                        }
                    }
                    InsertToRecListView(Resultxml);
                    break;

                default:
                    OpenAlertUI(strLang555);
                    return null;
            }
            g_CabListXmlhttp = null;
        }
    }
}


function MoveRecord(pRecID, pSepAttNo, pNewCabID, pFlag) {
    var XmlHttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();	

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "RECORDID", pRecID);
    createNodeAndInsertText(xmlpara, objNode, "SEPATTACHNO", pSepAttNo);
    createNodeAndInsertText(xmlpara, objNode, "NEWCABID", pNewCabID);
    createNodeAndInsertText(xmlpara, objNode, "FLAG", pFlag);

    XmlHttp.open("POST", "/ezApprovalG/moveRecord.do", false);
    XmlHttp.send(xmlpara);

    var rtn = getNodeText(GetChildNodes(XmlHttp.responseXML)[0]);
    if (rtn == "FALSE") {
        return false;
    }
    else {
        return true;
    }
}

function DisplayLineCnt_ezCab(NodeListLen) {
    var ListName = "";
    if (DocList_Flag == "RECORD") {
        if (ListTypeFlag == "10")
            ListName = strLang559;
        else if (ListTypeFlag == "11")
            ListName = strLang560;
        else
            ListName = strLang561;
    }
    else if (DocList_Flag == "CABINET") {
        if (ListTypeFlag == "9")
            ListName = strLang562;
        else if (ListTypeFlag == "10")
            ListName = strLang563;
        else
            ListName = strLang227;
    }

    
}

function GetHearderXml() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getLVHearderInfo.do",
		data : {
			companyID : CompanyID,
			listFlag  : DocList_Flag,
			listType  : ListTypeFlag
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    var rtnXml = result;
    var dataNodes = GetChildNodes(rtnXml);

    if (getNodeText(dataNodes[0]) == "FALSE") {
        OpenAlertUI(strLang573);
        g_HeaderInfoXml = "";
    }
    else {
        g_HeaderInfoXml = rtnXml;
    }
}

function lvtDoclist_HeaderClick(pHeader) {
    if (pHeader != "")
        SortList(pHeader);
}

function SortList(szField) {
    if (g_SortField == szField)
    {
        g_SortType = GetToggledSotrType();
    }
    else {
        g_SortType = "ASC";
    }

    g_SortField = szField;
    g_OrderBy = "Order By " + g_SortField + " " + g_SortType;

    if (DocList_Flag == "CABINET") {
        GetCaninetList();
    }
    else if (DocList_Flag == "RECORD") {
        GetRecordList();
    }
}

function GetToggledSotrType() {
    if (g_SortType == "ASC")
        return "DESC";
    else
        return "ASC";
}
var viewrechistory_cross_dialogArguments = new Array();
function btnViewRecHistory_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var para = new Array();
        para[0] = selRow[0].getAttribute("DATA6");
        para[1] = selRow[0].getAttribute("DATA8");
        var url = "/ezApprovalG/viewRecHistory.do";

        viewrechistory_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewRecHistory_Cross", GetOpenWindowfeature(615, 480));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        OpenAlertUI(strLang577);
    }
}

var viewrecinfo_cross_dialogArguments = new Array();
function btnViewRecInfo_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var para = new Array();
        para[0] = selRow[0].getAttribute("DATA6");
        para[1] = selRow[0].getAttribute("DATA8");	

        var url = "/ezApprovalG/viewRecInfo.do";

        viewrecinfo_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewRecInfo_Cross", GetOpenWindowfeature(640, 560));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        OpenAlertUI(strLang577);
    }
}
var viewcabinfo_cross_dialogArguments = new Array();
function btnViewCabInfo_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var para = new Array();
        para[0] = selRow[0].getAttribute("DATA1");		
        para[1] = selRow[0].getAttribute("DATA2");	

        var url = "/myoffice/ezApprovalG/ezCabinet/ViewCabInfo_Cross.aspx";
        viewcabinfo_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewCabInfo_Cross", GetOpenWindowfeature(640, 630));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        OpenAlertUI(strLang578);
    }
}

var viewcabhistory_cross_dialogArguments = new Array();
function btnViewCabHistory_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var para = new Array();
        para[0] = selRow[0].getAttribute("DATA2");	

        var url = "/myoffice/ezApprovalG/ezCabinet/ViewCabHistory_Cross.aspx";

        viewcabhistory_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewCabHistory_Cross", GetOpenWindowfeature(612, 473));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        OpenAlertUI(strLang578);
    }
}

function btnViewContent_onclick() {
    ViewDoc_onclick();
}
var doclistview_cross_dialogArguments = new Array();
function DocListPrinter_onclick() {
    var para = new Array()
    para[0] = DocList_Flag;
    para[1] = DeptID;
    para[2] = ContainerID;
    para[3] = DelListYN;
    para[4] = condition;
    para[5] = UserID;
    para[6] = Init_Flag;
    para[7] = AdminYN;

    para[8] = ListTypeFlag;
    para[9] = g_szParamXml;
    para[10] = deptName;

    para[11] = NodeListLen

    var url = "/ezApprovalG/docListView.do"

    doclistview_cross_dialogArguments[0] = para;

    var OpenWin = window.open(url, "DocListView_Cross", GetOpenWindowfeature(830, 582));
    try { OpenWin.focus(); } catch (e) { }
}

function ISReceivedCab(pCabID) {
    var objCabInfoXml = GetCabinetClassInfo(pCabID)

    CabTransFlag = getNodeText(SelectSingleNode(objCabInfoXml, "CABTRANSFLAG"));
    TDetpCode = getNodeText(SelectSingleNode(objCabInfoXml, "TDEPTCODE"));

    if (CabTransFlag != "2") {
        return false;
    }
    else {
        if (TDetpCode == DeptID) {
            return true;
        }
        else {
            return false;
        }
    }
}

//START
function ViewDoc_onclick() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length > 0) {
        var selRow = tr[0];
        if (DocList_Flag == "RECORD") {
            if (trim_Cross(selRow.getAttribute("DATA14")) != "null" && trim_Cross(selRow.getAttribute("DATA14")) != "" && trim_Cross(selRow.getAttribute("DATA14")) >= GetTodayDate()) {
                if (CheckAprLine(selRow.getAttribute("DATA1")) == "TRUE") {
                    chk_Passwd(UserID, ViewDoc_onclick_Complete);
                }
                else {
                    OpenAlertUI(strLang580);
                    return "";
                }
            }
            else
                ViewDoc_onclick_Complete("True");
        }
        else
            ViewDoc_onclick_Complete("True");
    }
    else {
        OpenAlertUI(strLang584);
    }
}

function ViewDoc_onclick_Complete(Rtn) {
    if (Rtn == "False") {
        var pAlertContent = strLang581;
        OpenAlertUI(pAlertContent);
        return "";
    }
    else if (Rtn == "cancel") {
        var pAlertContent = strLang582;
        OpenAlertUI(pAlertContent);
        return "";
    }
    else if (Rtn == "True") {
        var DocList = new ListView();          
        DocList.LoadFromID("DocList");
        var tr = DocList.GetSelectedRows();
        if (tr.length > 0) {
            var selRow = tr[0];
            if (DocList_Flag == "RECORD") {
                if (AdminYN != "TRUE" && (!g_bRecAdmin)) {
                    if (!HasRecReadRight(trim_Cross(selRow.getAttribute("DATA6")), trim_Cross(selRow.getAttribute("DATA8")), UserID)) {
                        OpenAlertUI(strLang580);
                        return "";
                    }
                }
                if (selRow.getAttribute("DATA8") != "00") {
                    OpenAlertUI(strLang260);
                    return "";
                }
            }
        }

        if (trim_Cross(pURL) == "") {
            if (trim_Cross(DocID) == "") {
                OpenAlertUI("내용이 존재하지 않는 문서입니다.");
            }
            else {
                var para2 = new Array();
                para2[0] = selRow.getAttribute("DATA6");
                para2[1] = selRow.getAttribute("DATA8");

                var url = "/ezApprovalG/contDocView_NoDoc.do?docID=" + encodeURI(DocID) + "&g_RecID=" + encodeURI(para2[0]) + "&g_SepAttNo=" + encodeURI(para2[1]);
                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;
                var left = 0;
                var top = 0;
                var wWidth = 600;
                var wHeigth = 300;
                var pleftpos, ptoppos;
                pleftpos = parseInt(width) - wWidth;
                ptoppos = parseInt(heigth) - wHeigth;

                left = pleftpos / 2;
                top = ptoppos / 2;

                window.open(url, "수기기록물", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeigth + ",width=" + wWidth + ",top=" + top + ",left = " + left);
            }
        }
        else {
            var para = new Array()
            para[0] = DocID;
            para[1] = pURL;
            var openLocation = "";
            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
                if (g_uFlag == "m03") {
                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP_Cross.aspx?DocID=" + encodeURI(DocID) + "&DocHref=" + encodeURI(pURL) + "&formID=&orgDocid=";
                }
                else {
                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP_Cross.aspx?DocID=" + encodeURI(DocID) + "&DocHref=" + encodeURI(pURL) + "&formID=" + encodeURI(selRow.getAttribute("DATA5")) + "&orgDocid=";
                }
            }
            else {
                if (g_uFlag == "m03") {
                    if (CrossYN() || NonActiveX == "YES")
                        openLocation = "/ezApprovalG/contDocView.do";
                    else {
                        if (pUse_Editor == "")
                            openLocation = "/myoffice/ezApprovalG/FormContainer/contDocView.aspx";
                        else
                            openLocation = "/myoffice/ezApprovalG/FormContainer/contDocView_IE.aspx";
                    }
                    openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=&orgDocID=&uFlag=" + g_uFlag;
                }
                else {
                    if (CrossYN() || NonActiveX == "YES") {
                        openLocation = "/ezApprovalG/contDocView.do";
                    }
                    else {
                        if (pUse_Editor == "") {
                            openLocation = "/myoffice/ezApprovalG/FormContainer/contDocView.aspx";
                        }
                        else {
                            openLocation = "/myoffice/ezApprovalG/FormContainer/contDocView_IE.aspx";
                        }
                    }
                    openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(selRow.getAttribute("DATA5")) + "&orgDocid=";
                }
            }
            openwindow(openLocation, "", 880, 570);
        }
    }
}
//END
function GetTodayDate() {
    var objDate = new Date();
    var y = String(objDate.getYear());
    var m = String(objDate.getMonth() + 1);
    var d = String(objDate.getDate());
    m = "00".substring(0, 2 - m.length) + m;
    d = "00".substring(0, 2 - d.length) + d;
    return y + "-" + m + "-" + d;
}

//START
var ezchkpasswd_cross_dialogArguments = new Array();
function chk_Passwd(pUserID, CompleteFunction) {
    var parameter = pUserID;
    ezchkpasswd_cross_dialogArguments[0] = parameter;
    if (CompleteFunction != undefined)
        ezchkpasswd_cross_dialogArguments[1] = CompleteFunction;
    else
        ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;

    var url = "/myoffice/ezApprovalG/ezchkPasswd_Cross.aspx";
    var OpenWin = window.open(url, "ezchkPasswd_Cross", GetOpenWindowfeature(330, 200));
    try { OpenWin.focus(); } catch (e) { }
}
//END

function CheckAprLine(pDocID) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "MODE", "END");
    createNodeAndInsertText(xmlpara, objNode, "USERID", UserID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPRLINE/aspx/checkaprlineuser.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    return getNodeText(dataNodes[0]);

}

function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;

            pleftpos = parseInt(width) - 967;
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

        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

    }
    catch (e) {
        alert("openwindow :: " + e.description);
    }
}

function OpenWin(wfileLocation, wName, wWidth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = 0;
        var top = 0;

        var pleftpos, ptoppos;
        pleftpos = parseInt(width) - wWidth;
        ptoppos = parseInt(heigth) - wHeigth;

        left = pleftpos / 2;
        top = ptoppos / 2;

        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeigth + ",width=" + wWidth + ",top=" + top + ",left = " + left);

    } catch (e) {
        OpenAlertUI("openwindow :: " + e.description);
    }
}

function HasRecReadRight(pRecID, pSepAttNo, pUserID) {
    if (GetUserRecRight(pRecID, pSepAttNo, pUserID) == "1")
        return true;
    else
        return false;
}

function GetUserRecRight(pRecID, pSepAttNo, pUserID) {
    var xmlpara = createXmlDom();	

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS");
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "RECID", pRecID);
    createNodeAndInsertText(xmlpara, objNode, "SEPATTNO", pSepAttNo);
    createNodeAndInsertText(xmlpara, objNode, "USERID", pUserID);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_GetUserRecRight.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    var rtn = getNodeText(dataNodes[0]);

    if (rtn == "FALSE") {
        OpenAlertUI(strLang586);
        return "0";
    }
    else {
        return rtn;
    }
}

var searchrec_cross_dialogArguments = new Array();
function btnSearchRec_onclick(opnOption,opentype) {
    var para = new Array();
    para[0] = AdminYN;	
    para[1] = DeptID;		
    para[2] = deptName;

    if (typeof (opnOption) == "undefined") opnOption = "0";
    para[3] = opnOption;	

    var url = "/ezApprovalG/searchRec.do";

    if (CrossYN() || NonActiveX == "YES") {
        searchrec_cross_dialogArguments[0] = para;
        searchrec_cross_dialogArguments[1] = btnSearchRec_onclick_Complete;

        if (opentype == "OPEN") {
            var OpenWin = window.open(url, "SearchRec_Cross", GetOpenWindowfeature(470, 370));
            try { OpenWin.focus(); } catch (e) { }
        }
        else
            DivPopUpShow(470, 350, url);
    }
    else {
        var feature;
        if (opnOption == "1") {
            feature = "dialogWidth:470px;dialogHeight:420px;scroll:no;resizable:no;status:no;help:no;edge:sunken";
            feature = feature + GetShowModalPosition(470, 420);
        }
        else {
            feature = "dialogWidth:470px;dialogHeight:410px;scroll:no;resizable:no;status:no;help:no;edge:sunken";
            feature = feature + GetShowModalPosition(470, 410);
        }
        var rtnVal = window.showModalDialog(url, para, feature);

        if (rtnVal[0] == "TRUE") {
            curpage = 1;

            g_RecSearchParamXml = rtnVal[1];
            GetRecordList();
        }
    }
}

function btnSearchRec_onclick_Complete(rtnVal) {
    DivPopUpHidden();
    if (rtnVal[0] == "TRUE") {
        curpage = 1;

        g_RecSearchParamXml = rtnVal[1];
        GetRecordList();
    }
    if (document.getElementById("rec_year") != null) {
        $('#rec_year').val("ALL");
        $('#rec_year').selectmenu('refresh');
    }
}

function btnSetRecUserRole_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();
    if (selRow.length > 0) {
        var tr = selRow[0];
        if (DocList_Flag == "RECORD") {
            if (tr.getAttribute("DATA8") != "00") 
            {
                OpenAlertUI(strLang590);
                return;
            }
        }

        if (DocID == "") {
            OpenAlertUI(strLang590);
            return;
        }
        else {
            SetRecUserRole(tr.getAttribute("DATA6"), tr.getAttribute("DATA8"), DeptID);
        }
    }
    else {
        OpenAlertUI(strLang584);
        return;
    }
}

var setrecuserrole_cross_dialogArguments = new Array();
function SetRecUserRole(pRecID, pSepAttNo, pDeptCode) {
    var para = new Array();
    para[0] = pRecID;		
    para[1] = pSepAttNo;	
    para[2] = pDeptCode;	

    var url = "/ezApprovalG/setRecUserRole.do";

    setrecuserrole_cross_dialogArguments[0] = para;

    var OpenWin = window.open(url, "SetRecUserRole_Cross", GetOpenWindowfeature(505, 455));
    try { OpenWin.focus(); } catch (e) { }
}

function SaveToRecReadHist() {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", DocID);
    createNodeAndInsertText(xmlpara, objNode, "USERID", arr_userinfo[1]);
    createNodeAndInsertText(xmlpara, objNode, "USERNAME", arr_userinfo[11]);
    createNodeAndInsertText(xmlpara, objNode, "USERTITLE", arr_userinfo[13]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[15]);
    createNodeAndInsertText(xmlpara, objNode, "USERNAME2", arr_userinfo[12]);
    createNodeAndInsertText(xmlpara, objNode, "USERTITLE2", arr_userinfo[14]);
    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME2", arr_userinfo[16]);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_SaveRecReadHist.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);

    if (getNodeText(dataNodes[0]) != "TRUE") {

    }
}


var g_progresswin = null;	
function showProgress() {
}

function hideProgress() {
}

function Search_Onclick(pInitFlag) {
    if (DocList_Flag == "RECORD") {

    }
    else if (DocList_Flag == "CABINET") {
        SearchCabinet(pInitFlag);
    }
}
var searchcab_cross_dialogArguments = new Array();
function SearchCabinet(pInitFlag) {
    var para = new Array();
    para[0] = AdminYN;
    para[1] = DeptID;
    para[2] = deptName;
    para[3] = pInitFlag;

    var url = "/myoffice/ezApprovalG/ezCabinet/SearchCab_Cross.aspx";

    searchcab_cross_dialogArguments[0] = para;
    searchcab_cross_dialogArguments[1] = SearchCabinet_Complete;

    if (pInitFlag == "0") {
        var OpenWin = window.open(url, "SearchCab_Cross", GetOpenWindowfeature(800, 455));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
        var OpenWin = window.open(url, "SearchCab_Cross", GetOpenWindowfeature(470, 395));
        try { OpenWin.focus(); } catch (e) { }
    }
}


function SearchCabinet_Complete(rtnVal) {
    if (rtnVal[0] == "TRUE") {
        g_CabSearchParamXml = rtnVal[1];
        GetCaninetList();
    }

    if (document.getElementById("cab_year") != null) {
        $('#cab_year').val("ALL");
        $('#cab_year').selectmenu('refresh');
    }
}


function openergetDocInfo() {
    if (DocList_Flag == "CABINET") {
        GetCaninetList();
    }
    else if (DocList_Flag == "RECORD") {
        GetRecordList();
    }
    else {
        GetDocDeliveryList(g_DeliverySearchParamXml);
    }
}


var BlockSize = 10;
var totalPage = "";
function td_Create1(strtext) {
    document.getElementById("tblPageRayer").innerHTML = strtext;
}
function makePageSelPage(pTotalCnt) {

    var strtext;
    var PagingHTML = "";
    document.getElementById("tblPageRayer").innerHTML = "";
    if (pTotalCnt != undefined) {
        if (GetSelectVal("rec_year") == "ALL" && GetSelectVal("cab_year") == "ALL" && GetSelectVal("del_year") == "ALL") {
            var nowyear = new Date().getFullYear();
            var nowmonth = new Date().getMonth() + 1;
            var nowday = new Date().getDate();
            period = (nowyear - 1) + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030 + " ~ " + nowyear + strLang1028 + " " + nowmonth + strLang1029 + " " + nowday + strLang1030;
        }
        else {
            if (GetSelectVal("rec_year") != "ALL")
                period = document.getElementById("rec_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("rec_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
            else if (GetSelectVal("cab_year") != "ALL")
                period = document.getElementById("cab_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("cab_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
            else
                period = document.getElementById("del_year").value + strLang1028 + " 1" + strLang1029 + " 1" + strLang1030 + " ~ " + document.getElementById("del_year").value + strLang1028 + " 12" + strLang1029 + " 31" + strLang1030;
        }

        if (!isPeriodYear)
            document.getElementById("TitleInfo").innerHTML = "-&nbsp;[" + strLang942 + "<span style='color:#017BEC;font-weight:bold;'> " + pTotalCnt + " </span>" + strLang943 + "]";
        else
            document.getElementById("TitleInfo").innerHTML = "-&nbsp;[" + strLang942 + "<span style='color:#017BEC;font-weight:bold;'> " + pTotalCnt + " </span>" + strLang943 + " - " + period + "]";
    }

    strtext = "<div class='pagenavi'>";

    PagingHTML += strtext;
    totalPage = Math.ceil(new Number(pTotalCnt / PageSize));
    var pageNum = curpage;
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
            strtext = "<span class='on'>" + i + "</span>"
            PagingHTML += strtext;
        }
        else {
            strtext = "<span onclick = 'goToPageByNum(" + i + ")'>" + i + "</span>"
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
    curpage = Value;
    pageNum = curpage;
    makePageSelPage();
    openergetDocInfo();
}
function selbeforeBlock() {
    var pageNum = curpage;
    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selbeforeBlock_one() {
    var pageNum = curpage;
    if (parseInt(pageNum - 1) > 0)
        goToPageByNum(parseInt(pageNum - 1));
    else
        return;
}
function selafterBlock() {
    var pageNum = curpage;
    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
    goToPageByNum(pageNum);
}
function selafterBlock_one() {
    var pageNum = curpage;
    if (parseInt(pageNum + 1) <= totalPage)
        goToPageByNum(parseInt(pageNum + 1));
    else
        return;
}

function goToPage(page) {
    if (page == "front") {
        if (parseInt(curpage) - 1 < 1)
            return;
        curpage = curpage - 1;
        openergetDocInfo();
    }
    else if (page == "next") {
        if (parseInt(curpage) + 1 > parseInt(totalPage))
            return;
        curpage = curpage + 1;
        openergetDocInfo();
    }
}


function insertSortInfoToHeader(header, listData) {
    try {
        if (getXmlString(header) != "" && getXmlString(header) != "<LISTINFO/>") {
            var oXml = header;
            var nodesCell = SelectNodes(oXml, "LISTINFO/CELL");
            var header = SelectNodes(listData, "LISTVIEWDATA/HEADERS/HEADER");
            var heaerLength = header.length;

            var objNode;
            for (var i = 0; i < heaerLength; i++) {             

                for (var j = 0; j < nodesCell.length; j++) {
                    var sn = getNodeText(SelectSingleNode(nodesCell[j], "SN"));
                    var colAlias = getNodeText(SelectSingleNode(nodesCell[j], "COLALIAS"));
                    var colname = getNodeText(SelectSingleNode(nodesCell[j], "COLNAME"));
                    if (i == j && colname != "") {                
                        createNodeAndAppandNodeText(listData, header[i], objNode, "COLNAME", colAlias);
                        j = nodesCell.length;

                    }
                }

            }
        }

        return listData;

    } catch (e) { }
}

String.prototype.trim = function () {
    return this.replace(/^\s+|\s+$/g, "");
}

var searchdelivery_cross_dialogArguments = new Array();
function btnSearchDelivery_onclick(opnOption) {
    var para = new Array();
    para[0] = AdminYN;
    para[1] = DeptID;
    para[2] = deptName;
    para[3] = opnOption;

    if (typeof (opnOption) == "undefined") opnOption = "0";
    para[3] = opnOption;

    searchdelivery_cross_dialogArguments[0] = para;
    searchdelivery_cross_dialogArguments[1] = btnSearchDelivery_onclick_Complete;

    var url = "/myoffice/ezApprovalG/ezCabinet/SearchDelivery_Cross.aspx";

    var OpenWin = window.open(url, "SearchDelivery_Cross", GetOpenWindowfeature(465, 370));
    try { OpenWin.focus(); } catch (e) { }
}

function btnSearchDelivery_onclick_Complete(rtnVal) {
    if (rtnVal[0] == "TRUE") {
        curpage = 1;

        g_DeliverySearchParamXml = rtnVal[1];
        GetDocDeliveryList(g_DeliverySearchParamXml);
    }
}

function orgmakePageSelPage(pTotalCnt) {
    totalPage = parseInt(pTotalCnt / PageSize);
    var modCnt = pTotalCnt - (totalPage * PageSize);
    if (modCnt > 0) totalPage = totalPage + 1;

    td_pTotalCount.textContent = totalPage;
    txt_PageInputNum.value = curpage;
    return;
}