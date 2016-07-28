var g_CurrentFormCd = "_DEF_1";


function DisplayLineCnt(Resultxml, viewtype) {
    //document.getElementById("listcount").innerHTML = strLang596 + "<span class='point'>" + NodeListLen + "</span> " + strLang445;
}

function getDataInfo() {
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER"); 
    createNodeAndInsertText(xmlpara, objNode, "DocID", DocID);

    if (jobState == "APPROVAL")
        createNodeAndInsertText(xmlpara, objNode, "Flag", "END");
    else
        createNodeAndInsertText(xmlpara, objNode, "Mode", "END");


    xmlhttp = createXMLHttpRequest();
    switch (jobState) {
        case "ATTACH":
            xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/getTotalAttachInfo.aspx", true);
            break;

        case "OPINION":
            xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/getOpinionInfo.aspx", true);
            break;

        case "APPROVAL":
            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezaprline/aspx/GetLineList.aspx", true);
            break;

        case "RECIPENT":
            xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/getReceiptinfo.aspx", true);
            break;
    }
    xmlhttp.onreadystatechange = getdoclistSub_after;
    try {
        xmlhttp.send(xmlpara);
    } catch (e) { }
}

function getdoclistSub_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        Resultxml = xmlhttp.responseXML;
        if (document.getElementById("lvtDetail").innerHTML != "")
            document.getElementById("lvtDetail").innerHTML = "";


        var vRows = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW")
        vWriterID = "";
        for (var i = 0; i < vRows.length; i++) {
            if (i == (vRows.length - 1)) {
                vWriterID = getNodeText(GetChildNodes(GetChildNodes(vRows[i])[0])[4]);
            }
        }



        var DocList = new ListView();      
        DocList.SetID("SubDocList");                               
        DocList.SetMulSelectable(false);                        
        DocList.SetRowOnDblClick("lvtDetail_onSel_DBclick");      
        DocList.DataSource(Resultxml);                             
        DocList.DataBind("lvtDetail");


        if (jobState == "APPROVAL") {
            if (USE_OCS == "YES") {
                check_presence();
            }
        }
    }
    catch (e) { }
}

function selFirstRow(Resultxml) {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var selRow = DocList.GetSelectedRows();

    if (selRow.length > 0) {
        processRowClick(selRow[0]);
    }
    else {
        DocID = "";
        pURL = "";
        WriterID = "";
        getDataInfo();
    }
}

function check_presence() {
    try{
        var DocList = new ListView();
        DocList.LoadFromID("SubDocList");
        var selRow = DocList.GetDataRows();
        var pCNList = new Array();
        for (var i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            pCNList[i] = tr.getAttribute("DATA4");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (var i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            tr.cells[1].innerHTML = "<span><img src='/images/Presence/unknown.gif' id ='" + GetGUID() + ",type=smtp' onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/></span>" + tr.cells[1].innerHTML;
        }
        pSIPUriList = null;
    } catch (e) { }
}

function processRowClick(tr) {
    if (DocList_Flag == "CABINET" || DocList_Flag == "RECORD")
        ChkCabRoleInfo(tr);

    if (DocList_Flag != "CABINET") {

        DocID = tr.getAttribute("DATA1");
        pURL = tr.getAttribute("DATA2");
        WriterID = tr.getAttribute("DATA3");

        if (typeof (SendOfferCheckBtn) != "undefined")
            SendOfferCheckBtn(DocID, UserID);

        if (DocList_Flag == "RECORD") {
            if (document.getElementById("tdGongRam")) {
                /* 2015-07-06 표준모듈:수정 - KSK */
                if (tr.getAttribute("DATA15") == "011" && (arr_userinfo[1] == vWriterID || WriterID == ""))
                    document.getElementById("tdGongRam").style.display = "";
                else
                    document.getElementById("tdGongRam").style.display = "none";
            }
        }

        if (WriterID == arr_userinfo[1]) {
            try {
                if (typeof (tr.cells[12].innerHTML) == "string") {
                    // START
                    if (tr.cells[12].innerHTML == strLang597 && tr.cells[11].innerHTML == "") {
                    //END
                        if (typeof (tdReSend) != "undefined" && typeof (tdReSend) != "unknown") {
                            document.getElementById("tdReSend").style.display = "";
                            //SwapImage(ReSend, "");
                        }
                    }
                    else {
                        if (typeof (tdReSend) != "undefined" && typeof (tdReSend) != "unknown") {
                            document.getElementById("tdReSend").style.display = "none";
                            //SwapImage(ReSend, "dis");
                        }
                    }
                }
                else {
                    if (typeof (tdReSend) != "undefined" && typeof (tdReSend) != "unknown") {
                        document.getElementById("tdReSend").style.display = "none";
                        //SwapImage(ReSend, "dis");
                    }
                }
            }
            catch (e) { }
        }
        else {
            if (typeof (tdReSend) != "undefined" && typeof (tdReSend) != "unknown") {
                document.getElementById("tdReSend").style.display = "none";
                //SwapImage(ReSend, "dis");
            }
        }

        switch (jobState) {
            case "ATTACH":
                Attach_onclick();
                break;

            case "OPINION":
                Opinion_onclick();
                break;

            case "APPROVAL":
            	alert("adsad");
                Approval_onclick();
                break;

            case "RECIPENT":
                Recipent_onclick()
                break;
        }
    }
}

function lvtDoclist_SelChange() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length > 0) {
        processRowClick(tr[0]);
    }
}

function OpenConfirmUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/myoffice/ezApprovalG/ezAPRQuestion_Cross.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken;resizable:yes;";
    feature = feature + GetShowModalPosition(330, 205);
    var RtnVal = window.showModalDialog(url, parameter, feature);

    return RtnVal;
}

//START
function OpenReceiptHistory() {
    var DocList = new ListView();
    DocList.LoadFromID("SubDocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length > 0) {
        var pDocID = tr[0].getAttribute("DATA2");
        var pDeptID = tr[0].getAttribute("DATA1");
        var isExtYN = tr[0].getAttribute("DATA3");

        var Url, OpenWin;
        if (isExtYN.toUpperCase() == "Y") {
            Url = "/myoffice/ezApprovalG/ezDocInfo/ezReceiptHistoryInfo.aspx?pDocID=" + pDocID + "&pDeptID=" + pDeptID;
        }
        else {
            Url = "/myoffice/ezApprovalG/ezDocInfo/ezLineInfo_Cross.aspx?pDocID=" + pDocID + "&pDeptID=" + pDeptID + "&pDocState=011";
        }

        var OpenWin = window.open(Url, "OpenReceiptHistory", GetOpenWindowfeature(610, 270));
        try { OpenWin.focus(); } catch (e) { }
    }
}
//END

function openUserInfo() {
    var DocList = new ListView();
    DocList.LoadFromID("SubDocList");
    var tr = DocList.GetSelectedRows();
    if (tr.length != 0) {
        var pCheckval = tr[0].getAttribute("DATA5");
        if (pCheckval == "Y") {
            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;
            var left = (width - 650) / 2;
            var top = (heigth - 300) / 2;
            window.open("/myoffice/ezApprovalG/ezDocInfo/ezLineInfo_Cross.aspx?pDocID=" + tr.getAttribute("DATA3") + "&pDeptID=" + tr.getAttribute("DATA4") + "&pDocState=012", "", "height=270px,width=600px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
        } else {
            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;
            var left = (width - 450) / 2;
            var top = (heigth - 450) / 2;
            window.open("/myoffice/common/showpersoninfo_cross.aspx?id=" + tr[0].getAttribute("DATA4"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
        }
    }
    else {
        var pAlertContent = strLang598;
        OpenAlertUI(pAlertContent);
    }
}

function GetDocDeliveryList(g_DeliverySearchParamXml) {
    DocListType = "DeliveryList";
    if (pChackYN == "FALSE") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
    }

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER"); 
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "pOrderCell", "");
    createNodeAndInsertText(xmlpara, objNode, "pOrderOption", "");
    createNodeAndInsertText(xmlpara, objNode, "pQuery", "");	
    createNodeAndInsertText(xmlpara, objNode, "ISDOCPRINT", "FALSE");
    if (g_DeliverySearchParamXml != "" && g_DeliverySearchParamXml != undefined) {
        createNodeAndInsertText(xmlpara, objNode, "search", "1");
            var oSParam = loadXMLString(g_DeliverySearchParamXml);
            xmlpara.documentElement.appendChild(oSParam.documentElement);
    }
    else {
        createNodeAndInsertText(xmlpara, objNode, "search", "0");
    }

    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    g_szParamXml = getXmlString(xmlpara);
   
    g_DeliveryXmlhttp = createXMLHttpRequest();
    g_DeliveryXmlhttp.open("POST", "/myoffice/ezApprovalG/formContainer/aspx/getDeliveryList.aspx", true);
    g_DeliveryXmlhttp.onreadystatechange = onreadystatechange_GetDocDeliveryList;
    g_DeliveryXmlhttp.send(xmlpara);
}

function onreadystatechange_GetDocDeliveryList() {
    var iStatus;
    var Resultxml;
    if (g_DeliveryXmlhttp != null) {
        if (g_DeliveryXmlhttp.readyState == 4) {

            excelXML = getXmlString(g_DeliveryXmlhttp.responseXML);
            Resultxml = g_DeliveryXmlhttp.responseXML;

            iStatus = g_DeliveryXmlhttp.status;

            switch (iStatus) {
                case 200:
                case 201:
                case 204:
                case 207:
                    if (getNodeText(Resultxml) != "") {
                        listNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
                        NodeList = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
                        NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALDOCCOUNT");
                        Haders = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/HEADERS/HEADER");
                        NodeListLen = 0;

                        if (NodeList2 != null) {
                            var cnt = getNodeText(NodeList2);
                            if (cnt != "")
                                NodeListLen = cnt;
                            else
                                NodeListLen = 0;
                        }

                        if (listNode != null) {

                            var xmlDoc
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

                            if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
                            var DocList = new ListView();                           
                            DocList.SetID("DocList");                               
                            DocList.SetMulSelectable(true);
                            DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");
                            DocList.SetRowOnClick("lvtDoclist_SelChange");           
                            DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
                            DocList.SetTitleIdx(0);                                  
                            DocList.SetUrgentFlag(false);                            

                            DocList.DataSource(xmlDoc);                             
                            DocList.DataBind("lvtDoclist");                          
                            DocList = null;

                            makePageSelPage(NodeListLen);
                            selFirstRow(Resultxml);
                        }
                    }
                    else {
                        OpenAlertUI("목록 조회에 실패하였습니다!");
                        return null;
                    }
                    break;
                default:
                    OpenAlertUI("목록 조회에 실패하였습니다!");
                    return null;
                    break;

            }
            DisplayLineCnt(Resultxml, "3");

            pChackYN = "TRUE";
        }
    }
}

function CheckFormConnFlag(pDocID) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER"); 
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetFormConnFlag.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);

    if (getNodeText(dataNodes[0]) == "Y")
        return true;
    else
        return false;
}
