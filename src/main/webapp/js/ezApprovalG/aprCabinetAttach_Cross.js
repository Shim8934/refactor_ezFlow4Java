function DocMove() {
    var selRow;
    var count1, pCount;
    var length, SDocID, strAttachList;

    var SelDocList = new ListView();
    SelDocList.LoadFromID("lvTDocLV");

    if (SelDocList.GetDataRows().length == 1){
        if (SelDocList.GetDataRows()[0].id == "lvTDocLV_TR_noItems") {
            SelDocList.DeleteRow("lvTDocLV_TR_noItems");
        }
    }

    var countsel = SelDocList.GetDataRows();

    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    pCulSel = DocList.GetSelectedRows();

    if (pCulSel.length <= 0) {
        OpenAlertUI(strLang257);
    }
    else {
        DocInfo = pCulSel;
        for (count1 = 0; count1 < pCulSel.length; count1++) {
            selRow = pCulSel[count1];

            if (selRow) {
                var DuplicateFlag = false;
                for (i = 0; i < SelDocList.GetRowCount() ; i++) {
                    countsel = SelDocList.GetDataRows();

                    if (GetAttribute(countsel[i], "DATA1") == GetAttribute(selRow, "DATA2") && countsel[i].cells[0].innerHTML == selRow.childNodes[5].innerHTML) {
                        DuplicateFlag = true;
                    }
                }

                if (DuplicateFlag) {
                    OpenAlertUI(strLang258);
                }
                else {
                    var GetXml = "<LISTVIEWDATA>";
                    GetXml += "<HEADERS><HEADER><NAME>" + strLang940 + "</NAME><WIDTH>50</WIDTH></HEADER></HEADERS>"
                    GetXml += "<ROWS><ROW><CELL>"
                    GetXml += "<VALUE><![CDATA[" + GetChildNodes(selRow)[5].textContent + "]]></VALUE>";
                    GetXml += "<DATA1>" + MakeXMLString(GetAttribute(selRow, "DATA2")) + "</DATA1>";
                    GetXml += "<DATA2 ></DATA2>";
                    GetXml += "<DATA3>" + MakeXMLString(pDocID) + "</DATA3>";
                    GetXml += "<DATA4>" + MakeXMLString(pUserID) + "</DATA4>";
                    GetXml += "<DATA5>" + MakeXMLString(pUserJobTitle) + "</DATA5>";
                    GetXml += "<DATA6>" + MakeXMLString(pDeptID) + "</DATA6>";
                    GetXml += "<DATA7>" + MakeXMLString(pDeptName) + "</DATA7>";
                    GetXml += "<DATA8>" + MakeXMLString(pUserName) + "</DATA8>";
                    GetXml += "<DATA9>N</DATA9>";
                    GetXml += "<DATA10><![CDATA[" + GetChildNodes(selRow)[5].textContent + "]]></DATA10>";
                    GetXml += "<DATA11>" + MakeXMLString(arr_userinfo[11]) + "</DATA11>";
                    GetXml += "<DATA12>" + MakeXMLString(arr_userinfo[12]) + "</DATA12>";
                    GetXml += "<DATA13>" + MakeXMLString(arr_userinfo[13]) + "</DATA13>";
                    GetXml += "<DATA14>" + MakeXMLString(arr_userinfo[14]) + "</DATA14>";
                    GetXml += "<DATA15>" + MakeXMLString(arr_userinfo[15]) + "</DATA15>";
                    GetXml += "<DATA16>" + MakeXMLString(arr_userinfo[16]) + "</DATA16>";
                    GetXml += "</CELL></ROW></ROWS></LISTVIEWDATA>";

                    var Resultxml = loadXMLString(GetXml);
                    var RowCount = SelDocList.GetRowCount();
                    var cnTr = SelDocList.GetDataRows();

                    var MaxID = 0;
                    for (var j = 0  ; j < cnTr.length  ; j++) {
                        var curnum = Number(SelDocList.GetSelectedRowID(j).substring(SelDocList.GetSelectedRowID(j).lastIndexOf('_') + 1), SelDocList.GetSelectedRowID(j).length);
                        if (MaxID < curnum)
                            MaxID = curnum;
                    }
                    var objTr = SelDocList.NewAddRow(RowCount, "lvTDocLV" + "_TR_" + eval(MaxID + 1));//InitTr.length			  
                    SelDocList.AddDataRow(objTr, Resultxml);

                }
            }
        }
    }
}
function AttachList() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "NODE", pDocID);

    xmlhttp.open("POST", "aspx/getAttachInfo.aspx", false);
    xmlhttp.send(xmlpara);

    var DocList = new ListView();
    DocList.SetID("lvTDocLV");
    DocList.SetMulSelectable(true);
    DocList.SetRowOnClick("lvTDoc_onSel_Click");
    DocList.SetRowOnDblClick("lvTDoc_onSel_DBclick");
    DocList.DataSource(xmlhttp.responseXML);
    DocList.DataBind("lvTDoc");
    if (DocList.GetRowCount() > 0)
        DocList.SetSelectFlag(true);
}
function delAttachDoc() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "NODE", pDocID);

    xmlhttp.open("POST", "aspx/delAttachDoc.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
function delAttachDoc() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "NODE", pDocID);

    xmlhttp.open("POST", "aspx/delAttachDoc.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
function DocMoveParser() {
    var count1;
    var length;
    var rtnXML;

    var xmlhttp = createXMLHttpRequest();
    var xmlRtn = createXmlDom();
    var xmlpara = createXmlDom();

    var objRoot, x_ROW, x_DOCID;

    var SelDocList = new ListView();
    SelDocList.LoadFromID("lvTDocLV");
    var totalList = SelDocList.GetDataRows();

    objRoot = createNodeInsert(xmlpara, objRoot, "ROWS");

    for (var i = 0 ; i < totalList.length ; i++) {
        x_ROW = createNodeAndAppandNode(xmlpara, objRoot, x_ROW, "ROW");
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA1", GetAttribute(totalList[i], "DATA1"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA2", GetAttribute(totalList[i], "DATA2"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA3", GetAttribute(totalList[i], "DATA3"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA4", GetAttribute(totalList[i], "DATA4"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA5", GetAttribute(totalList[i], "DATA5"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA6", GetAttribute(totalList[i], "DATA6"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA7", GetAttribute(totalList[i], "DATA7"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA8", GetAttribute(totalList[i], "DATA8"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA9", GetAttribute(totalList[i], "DATA9"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA10", GetAttribute(totalList[i], "DATA10"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA11", GetAttribute(totalList[i], "DATA11"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA12", GetAttribute(totalList[i], "DATA12"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA13", GetAttribute(totalList[i], "DATA13"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA14", GetAttribute(totalList[i], "DATA14"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA15", GetAttribute(totalList[i], "DATA15"));
        x_DOCID = createNodeAndAppandNodeText(xmlpara, x_ROW, x_DOCID, "DATA16", GetAttribute(totalList[i], "DATA16"));
    }

    xmlhttp.open("Post", "aspx/updateDocattach.aspx", false);
    xmlhttp.send(xmlpara);

    var rtnval = xmlhttp.responseXML;
    if (SelectSingleNodeValue(rtnval, "RESULT") == "TRUE") {
        rtnXML = getXmlString(xmlpara);
    }
    else rtnXML = "<ROWS></ROWS>"

    return rtnXML;
}
// START
var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN() || NonActiveX == "YES") {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
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
// END

function MakeXMLString(pOrgString) {
    return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
}
function ReplaceText(orgStr, findStr, replaceStr) {
    try {
        if (findStr == ".") {
            var a = 0;
            for (a = 0; a < 10; a++)
                orgStr = orgStr.replace(".", replaceStr);
            return orgStr;
        }
        else {
            var re = new RegExp(findStr, "gi");
            return (orgStr.replace(re, replaceStr));
        }
    } catch (e) {
        return orgStr
    }
}
function GetRecordList_lv() {
    hideProgress();
    showProgress();
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
            GetRecordListXml_lv();
    }
}
function GetRecordListXml_lv() {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS");
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID); 
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "USERID", UserID);
    createNodeAndInsertText(xmlpara, objNode, "TRANSFLAG", g_TransFlag); // 0:기록물 대장 가져옴, 1:인계부서의 기록물도 가져옴
    createNodeAndInsertText(xmlpara, objNode, "LISTFLAG", ListTypeFlag);// 0:기록물 대장, 1:편철확정 대상 기록물
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);
    createNodeAndInsertText(xmlpara, objNode, "ORDERBY", g_OrderBy);

    if (g_RecSearchParamXml != "")	//검색 파라미터가 있으면 노드를 붙인다.
    {
        var oSParam = createXmlDom();
        oSParam = loadXMLString(g_RecSearchParamXml);
        xmlpara.documentElement.appendChild(oSParam.documentElement);

    }
    createNodeAndInsertText(xmlpara, objNode, "CABINETINFO", "");   // 기록물철 정보

    // g_SelCabXml로 부터 기록물철 ID 부분만 추출
    var i, len;
    if (g_SelCabXml != "")	//선택된 기록물철이 있을 경우 기록물철 아이디를 파라미터로 넘겨준다.
    {
        var CabListXml = createXmlDom();
        CabListXml = loadXMLString(g_SelCabXml);

        var objCabs = SelectNodes(CabListXml, "CABINET");
        len = objCabs.length;

        for (i = 0; i < len; i++) {
            objNode.appendChild(SelectNodes(objCabs[i], "CABINETID"));
        }
    }

    g_szParamXml = getXmlString(xmlpara);

    g_CabListXmlhttp = createXMLHttpRequest();
    g_CabListXmlhttp.open("POST", "/ezApprovalG/getRecordList.do", true);
    g_CabListXmlhttp.onreadystatechange = onreadystatechange_RecList_lv;
    g_CabListXmlhttp.send(xmlpara);
}
function onreadystatechange_RecList_lv() {
    var Resultxml;
    var iStatus;

    if (g_CabListXmlhttp != null) {
        if (g_CabListXmlhttp.readyState == 4) {
            if (typeof (CheckBtnSetRecRole) == "function")
                CheckBtnSetRecRole();

            Resultxml = g_CabListXmlhttp.responseXML;
            iStatus = g_CabListXmlhttp.status;

            switch (iStatus) {
                case 200:
                case 201:
                case 204:
                case 207:
                    if (Resultxml.xml == "" || Resultxml.text == "FALSE") {
                        OpenAlertUI("기록물 대장 조회에 실패하였습니다!");
                        return null;
                    }

                    if (iStatus == 207) {
                        var nodeStatus = Resultxml.selectSingleNode("a:multistatus/a:response[a:status $ge$ 'HTTP/1.1 4']");
                        if (nodeStatus != null) {
                            OpenAlertUI("기록물 대장 조회에 실패하였습니다!");
                            return null;
                        }
                    }
                    InsertToRecListView_lv(Resultxml);

                    break;

                default:
                    OpenAlertUI("기록물 대장 조회에 실패하였습니다!");
                    return null;
            }
            hideProgress();
            g_CabListXmlhttp = null;
        }
    }
}
function InsertToRecListView_lv(Resultxml) {
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

        orgmakePageSelPage(NodeListLen);
        DisplayLineCnt_ezCab(NodeListLen);

        selFirstRow(Resultxml);
    } catch (e) { }
}
function goToPage_lv(page) {
    if (page == "front") {
        if (parseInt(curpage) - 1 < 1)
            return;
        curpage = curpage - 1;
        openergetDocInfo_lv();
    }
    else if (page == "next") {
        if (parseInt(curpage) + 1 > parseInt(totalPage))
            return;
        curpage = curpage + 1;
        openergetDocInfo_lv();
    }
    else if (page == "page") {
        if (event.keyCode == 13) {
            var goPage = document.all.txt_PageInputNum.value;
            if (parseInt(goPage) != goPage || parseInt(goPage) < 1 || parseInt(goPage) > parseInt(totalPage))
                return;
            curpage = parseInt(goPage);
            openergetDocInfo_lv();
        }
    }
}
function openergetDocInfo_lv() {
    if (DocList_Flag == "CABINET") {
        GetCaninetList();
    }
    else if (DocList_Flag == "RECORD") {
        GetRecordList_lv();
    }
    else {
        GetDocDeliveryList();
    }
}