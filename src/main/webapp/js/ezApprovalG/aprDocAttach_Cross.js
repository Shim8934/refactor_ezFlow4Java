function getDocType() {
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var ParaName, ParaValue
    var Cnt, oOption
    var index, i;

    var objRoot, objNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "NODE", pDeptID);

    xmlhttp.open("POST", "/ezApprovalG/mgetDeptUseDocType.do", false);
    xmlhttp.send(xmlpara);

    xmlRtn = loadXMLString(xmlhttp.responseText);
    objNode = GetChildNodes(xmlRtn.documentElement);
    index = document.getElementById("selSContName").length;

    if (index > 0) {
        for (i = index; i > 0; i--) {
            document.getElementById("selSContName").remove(i - 1);
        }
    }

    for (Cnt = 0; Cnt < objNode.length - 1; Cnt++) {
        Add_ContType(getNodeText(objNode[Cnt + 1]), getNodeText(objNode[Cnt]));
        Cnt = Cnt + 1;
    }
}

function Add_ContType(Name, ID) {
    var oOption = document.createElement("OPTION");
    setNodeText(oOption , Name);
    oOption.value = ID;

    if (CrossYN() || pNoneActiveX == "YES")
        document.getElementById("selSContName").appendChild(oOption);
    else
        document.getElementById("selSContName").add(oOption);
}

function getDocList() {
    if (pChackYN == "FALSE") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
    }

    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var ParaName, ParaValue;
    var Cnt, oOption;
    var objRoot, objNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "NODE", selSContName.value);
    createNodeAndInsertText(xmlpara, objNode, "BlockNum", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);

    xmlhttp.open("POST", "/ezApprovalG/aprDocAttachList.do", false);
    xmlhttp.send(xmlpara);

    Resultxml = loadXMLString(xmlhttp.responseText);
    if (Resultxml != null) {
        ListViewXml = Resultxml.getElementsByTagName("LISTVIEWDATA");
        NodeList = Resultxml.getElementsByTagName("ROW");
        NodeList2 = Resultxml.getElementsByTagName("TOTALCNT");
        Headers = Resultxml.getElementsByTagName("HEADER");
        NodeListLen = 0;

        if (NodeList2 != null) {
            if (NodeList2[0].hasChildNodes())
                NodeListLen = NodeList2[0].childNodes[0].nodeValue;
            else
                NodeListLen = 0;
        }

        document.getElementById("lvSDoc").innerHTML = "";

        var listview = new ListView();
        listview.SetID("lvSDocList");
        listview.SetMulSelectable(false);
        listview.SetWidthFlag(false);
        listview.SetRowOnDblClick("btnIns_onclick");
        listview.SetTableWidth(350 - 14);
        listview.DataSource(ListViewXml[0]);
        listview.DataBind("lvSDoc");

        pagingCount(curpage, nowblock);
    }

    pChackYN = "FALSE"
}

function DocMove() {
    var xmlpara = createXmlDom();
    var selRow;
    var count1, pCount;
    var length, SDocID, strAttachList, objRoot, objNode, objChildNode;

    var listview = new ListView();
    listview.LoadFromID("lvSDocList");

    var Doclistview = new ListView();
    Doclistview.LoadFromID("lvTDocList");

    length = listview.GetSelectedRows().length;
    Doclength = Doclistview.GetDataRows().length;

    if (Doclength == 1 && Doclistview.GetDataRows()[0].id == "lvTDocList_TR_noItems") {
        Doclistview.DeleteRow(Doclistview.GetDataRows()[0].id);
        Doclength--;
    }

    if (length <= 0) {
    	if (approvalFlag == 'G') {
    		alert(strLang174);
    	} else {
    		alert(strLangS174);
    	}
    }
    else {
        DocInfo = listview.GetSelectedRows()[0];

        for (count1 = 0; count1 < length; count1++) {
            selRow = listview.GetSelectedRows()[count1];
            if (selRow && DuplicateCheck(GetAttribute(selRow, "DATA2"))) {
                var row = Doclistview.AddRow(Doclength);
                SDocID = GetAttribute(selRow, "DATA1");
                objRoot = createNodeInsert(xmlpara, objRoot, "ROW");
                objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "CELL");
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "VALUE", "【" + getNodeText(selRow.cells[5]) + "】" + getNodeText(selRow.cells[1]));
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA1", GetAttribute(selRow, "DATA2"));
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA2", "");
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA3", pDocID);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA4", pUserID);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA5", arr_userinfo[13]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA6", pDeptID);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA7", arr_userinfo[15]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA8", arr_userinfo[11]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA9", "N");
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA10", "【" + getNodeText(selRow.cells[5]) + "】" + getNodeText(selRow.cells[1]));
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA11", arr_userinfo[12]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA12", arr_userinfo[14]);
                createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA13", arr_userinfo[16]);

                Doclistview.AddDataRow(row, xmlpara);
            }
        }
    }
}

function AttachList() {
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var objRoot, objNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");

    createNodeAndInsertText(xmlpara, objNode, "NODE", pDocID);

    xmlhttp.open("POST", "/ezApprovalG/getAttachInfo.do", false);
    xmlhttp.send(xmlpara);

    document.getElementById("lvTDoc").innerHTML = "";

    var listview = new ListView();
    listview.SetID("lvTDocList");
    listview.SetMulSelectable(false);
    listview.SetWidthFlag(false);
    listview.SetRowOnClick("lvTDoc_onSel_Click");
    listview.SetRowOnDblClick("btndel_onclick");
    listview.SetTableWidth(350 - 14);
    listview.DataSource(loadXMLString(xmlhttp.responseText));
    listview.DataBind("lvTDoc");
}

function delAttachDoc() {
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var objRoot, objNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");

    createNodeAndInsertText(xmlpara, objNode, "NODE", pDocID);

    xmlhttp.open("POST", "/myoffice/ezApproval/ezAPRDOCATTACH/aspx/delAttachDoc.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}

function DocMoveParser() {
    var count1;
    var length;
    var rtnXML;

    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var objRoot, objNode, objChildNode;

    objRoot = createNodeInsert(xmlpara, objRoot, "ROWS");

    var listview = new ListView();
    listview.LoadFromID("lvTDocList");

    length = listview.GetDataRows().length;
    for (i = 0; i < length; i++) {
        objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "ROW");
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA1", GetAttribute(listview.GetDataRows()[i], "DATA1"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA2", GetAttribute(listview.GetDataRows()[i], "DATA2"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA3", GetAttribute(listview.GetDataRows()[i], "DATA3"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA4", GetAttribute(listview.GetDataRows()[i], "DATA4"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA5", GetAttribute(listview.GetDataRows()[i], "DATA5"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA6", GetAttribute(listview.GetDataRows()[i], "DATA6"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA7", GetAttribute(listview.GetDataRows()[i], "DATA7"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA8", GetAttribute(listview.GetDataRows()[i], "DATA8"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA9", GetAttribute(listview.GetDataRows()[i], "DATA9"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA10", GetAttribute(listview.GetDataRows()[i], "DATA10"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA11", GetAttribute(listview.GetDataRows()[i], "DATA11"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA12", GetAttribute(listview.GetDataRows()[i], "DATA12"));
        createNodeAndAppandNodeText(xmlpara, objNode, objChildNode, "DATA13", GetAttribute(listview.GetDataRows()[i], "DATA13"));
    }

    xmlhttp.open("Post", "/ezApprovalG/updateDocAttach.do", false);
    xmlhttp.send(xmlpara);

    var rtnval = getNodeText(SelectSingleNode(loadXMLString(xmlhttp.responseText), "RESULT"));
    var rtnXML;
    if (rtnval == "TRUE")
        rtnXML = getXmlString(xmlpara);
    else
        rtnXML = "<ROWS></ROWS>";

    return rtnXML;
}

function GetDocSearch() {
    DocListType = "GetDocSearch";
    var pDocstate = "A02011";

    if (pChackYN == "FALSE") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
        OrderOption = "";
        OrderCell = "";
    }

    var xmlpara = createXmlDom();
    var objRoot, objNode, i, nodeName;

    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");

    for (i = 0; i < 12; i++) {
        nodeName = "Param" + i;
        if (typeof (condition[i]) == "undefined")
            createNodeAndInsertText(xmlpara, objNode, nodeName, "");
        else
            createNodeAndInsertText(xmlpara, objNode, nodeName, condition[i]);
    }
    createNodeAndInsertText(xmlpara, objNode, "Param12", selSContName.value);
    createNodeAndInsertText(xmlpara, objNode, "Param13", arr_userinfo[1]);
    createNodeAndInsertText(xmlpara, objNode, "Param14", arr_userinfo[4]);
    createNodeAndInsertText(xmlpara, objNode, "Param15", "DETAIL");
    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "DocState", "");
    createNodeAndInsertText(xmlpara, objNode, "pSubQuery", SQLPARADATA);
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);

    xmlhttp.open("POST", "/ezApprovalG/getFormSearchDocListS.do", true);
    xmlhttp.onreadystatechange = getsearchDocList_after;
    xmlhttp.send(xmlpara);
}

function getsearchDocList_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;

    try {
        Resultxml = loadXMLString(xmlhttp.responseText);

        if (Resultxml != null) {
            ListViewXml = Resultxml.getElementsByTagName("LISTVIEWDATA");
            NodeList = Resultxml.getElementsByTagName("ROW");
            NodeList2 = Resultxml.getElementsByTagName("TOTALCNT");
            Headers = Resultxml.getElementsByTagName("HEADER");
            NodeListLen = 0;

            if (NodeList2 != null) {
                if (NodeList2[0].hasChildNodes())
                    NodeListLen = NodeList2[0].childNodes[0].nodeValue;
                else
                    NodeListLen = 0;
            }

            document.getElementById("lvSDoc").innerHTML = "";

            var listview = new ListView();
            listview.SetID("lvSDocList");
            listview.SetMulSelectable(false);
            listview.SetWidthFlag(false);
            listview.SetRowOnDblClick("btnIns_onclick");
            listview.SetTableWidth(350 - 14);
            listview.DataSource(ListViewXml[0]);
            listview.DataBind("lvSDoc");

            pagingCount(curpage, nowblock);

            pChackYN = "FALSE"
        }
        else {
            prompt(xmlhttp.responseText, xmlhttp.responseText);
        }
    }
    catch (e) { }
}

function MakeSubCondition() {
    var TYPE = "";
    var DATA = "";

    if (condition[0] != "") {
        TYPE += "DOCNO;"
        DATA += "<DOCNO>" + condition[0] + "</DOCNO>";
    }

    if (condition[1] != "") {
        TYPE += "DOCTITLE;"
        DATA += "<DOCTITLE>" + condition[1] + "</DOCTITLE>";
    }

    if (condition[2] != "") {
        TYPE += "WRITERNAME;"
        DATA += "<WRITERNAME>" + condition[2] + "</WRITERNAME>";
    }


    if (condition[3] != "") {
        TYPE += "STARTDATEAF;"
        DATA += "<STARTDATEAF>" + condition[3] + "</STARTDATEAF>";
    }

    if (condition[4] != "") {
        TYPE += "STARTDATEBF;"
        DATA += "<STARTDATEBF>" + condition[4] + "</STARTDATEBF>";
    }

    if (condition[5] != "") {
        TYPE += "ENDDATEAF;"
        DATA += "<ENDDATEAF>" + condition[5] + "</ENDDATEAF>";
    }

    if (condition[6] != "") {
        TYPE += "ENDDATEBF;"
        DATA += "<ENDDATEBF>" + condition[6] + "</ENDDATEBF>";
    }

    if (condition[9] != "") {
        TYPE += "FORMID;"
        DATA += "<FORMID>" + condition[9] + "</FORMID>";
    }

    if (condition[11] != "") {
        TYPE += "WRITERDEPTNAME;"
        DATA += "<WRITERDEPTNAME>" + condition[11] + "</WRITERDEPTNAME>";
    }

    if (condition[12] != "") {
        TYPE += condition[12];
        DATA += condition[13];
    }

    SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
}

function DuplicateCheck(AttachDocID) {
    var RtnVal = true;
    var listview = new ListView();
    listview.LoadFromID("lvTDocList");
    var selRow = listview.GetDataRows();
    if (selRow.length > 0) {
        for (i = 0; i < selRow.length; i++) {
            if (AttachDocID == trim_Cross(GetAttribute(selRow[i], "DATA1"))) {
                RtnVal = false;
                break;
            }
        }
    }
    listview = null;
    return RtnVal;
}