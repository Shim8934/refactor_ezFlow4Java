var g_arrSCInfo = new Array();
var g_arrSCYN = new Array();
function InitSCInputBox() {
    if (g_arrSCInfo[0] != "") {
        trSC1.style.display = "";
        tdSC1Title.innerHTML = g_arrSCInfo[0] + ":";
    }

    if (g_arrSCInfo[1] != "") {
        trSC2.style.display = "";
        tdSC2Title.innerHTML = g_arrSCInfo[1] + ":";
    }

    if (g_arrSCInfo[2] != "") {
        trSC3.style.display = "";
        tdSC3Title.innerHTML = g_arrSCInfo[2] + ":";
    }

    var i;
    for (i = 0; i < g_arrSCInfo.length; i++) {
        if (g_arrSCInfo[i] != "")
        {
            g_arrSCYN[i] = "Y";
        }
        else {
            g_arrSCYN[i] = "N";
        }
    }
}

function InsertSpecialList(pList1, pList2, pList3) {
    var pSN;
    var specialList = new ListView();
    specialList.LoadFromID("SpecialListdiv");

    var oRows = specialList.GetDataRows();

    if (!oRows) {
        pSN = 1;
    }

    if (oRows.length < 1) {
        pSN = 1;
    }
    else {
        pSN = parseInt(oRows[oRows.length - 1].cells[0].innerHTML) + 1;
    }
    InsertRowToSpecialList(pSN, pList1, pList2, pList3);
}

function InsertRowToSpecialList(pSN, pList1, pList2, pList3) {
    if (pSN != "" && pList1 != "") {
        if (pList2 == "")
            pList2 = " ";

        if (pList3 == "")
            pList3 = " ";

        var specialList = new ListView();
        specialList.LoadFromID("SpecialListdiv");
        var RowCount = specialList.GetRowCount();

        var row = "<ROW>";
        row += "<CELL><VALUE>" + pSN + "</VALUE></CELL>";
        if (g_arrSCYN[0] == "Y")
            row += "<CELL><VALUE>" + pList1 + "</VALUE></CELL>";
        if (g_arrSCYN[1] == "Y")
            row += "<CELL><VALUE>" + pList2 + "</VALUE></CELL>";
        if (g_arrSCYN[2] == "Y")
            row += "<CELL><VALUE>" + pList3 + "</VALUE></CELL>";
        row += "</ROW>";

        var rowXml = loadXMLString(row);
        var cnTr = specialList.GetDataRows();
        var MaxID = 0;
        for (var j = 0  ; j < cnTr.length  ; j++) {
            var curnum = Number(specialList.GetSelectedRowID(j).substring(specialList.GetSelectedRowID(j).lastIndexOf('_') + 1), specialList.GetSelectedRowID(j).length);
            if (MaxID < curnum)
                MaxID = curnum;

        }
        var objTr = specialList.NewAddRow(RowCount, "SpecialListdiv" + "_TR_" + eval(MaxID + 1));
        specialList.AddDataRow(objTr, rowXml);

    }
}

function DelRowOfSpecialList() {
    var selRow;
    var count1;
    var specialList = new ListView();
    specialList.LoadFromID("SpecialListdiv");
    var length = specialList.GetSelectedRows().length;

    if (length > 0) {
        for (count1 = 0; count1 < length; count1++) {
            var selIdx = specialList.GetSelectedRows()[0].getAttribute("id");
            specialList.DeleteRow(selIdx);
            OrderSpecialList();
        }
    }
    else {
        alert(strLang698);
    }
}


function OrderSpecialList() {
    var specialList = new ListView();
    specialList.LoadFromID("SpecialListdiv");
    var totalRows = specialList.GetDataRows()

    var i;
    for (i = 0; i < specialList.GetRowCount() ; i++) {
        totalRows[i].cells[0].innerHTML = i + 1;
    }
}
function GetSCHearderXml() {
    var oList, ListViewData, Headers, Header, HName, HWidth, Rows;

    oList = createXmlDom();
    ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");

    Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
    createNodeAndAppandNodeText(oList, Header, HName, "NAME", strLang605);
    createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "35");


    var i;
    for (i = 0; i < g_arrSCInfo.length; i++) {
        if (g_arrSCYN[i] == "Y")
        {
            Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
            createNodeAndAppandNodeText(oList, Header, HName, "NAME", g_arrSCInfo[i]);
            createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "120");

        }
    }
    return getXmlString(oList);
}

function InitSpecialList() {
    var szSCListHeader = GetSCHearderXml();

    oList = createXmlDom();
    oList = loadXMLString(szSCListHeader);

    var oRowsList = new ListView();
    oRowsList.SetID("SpecialListdiv");                               
    oRowsList.SetMulSelectable(false);                        
    oRowsList.SetRowOnDblClick("");      
    oRowsList.DataSource(oList);                             
    oRowsList.DataBind("SpecialList");
}

function GetSCListXml() {
    var i, szSCListHeader, oList, Rows, Row, Cell, Value;

    var oRowsList = new ListView();
    oRowsList.LoadFromID("SpecialListdiv");

    var oRows = oRowsList.GetDataRows();

    if (oRows.length > 0) {
        szSCListHeader = GetSCHearderXml();

        oList = createXmlDom();

        oList = loadXMLString(szSCListHeader);
        Rows = SelectSingleNode(oList, "LISTVIEWDATA");
        Rows = createNodeAndAppandNode(oList, SelectSingleNode(oList, "LISTVIEWDATA"), Rows, "ROWS");

        for (i = 0; i < oRows.length; i++) {
            Row = createNodeAndAppandNode(oList, Rows, Row, "ROW");
            Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
            Value = createNodeAndAppandNodeText(oList, Cell, Value, "VALUE", oRows[i].cells[0].innerHTML);

            if (g_arrSCYN[0] == "Y")
            {
                Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
                Value = createNodeAndAppandNodeText(oList, Cell, Value, "VALUE", oRows[i].cells[1].innerHTML);
            }

            if (g_arrSCYN[1] == "Y")
            {
                Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
                Value = createNodeAndAppandNodeText(oList, Cell, Value, "VALUE", oRows[i].cells[2].innerHTML);
            }

            if (g_arrSCYN[2] == "Y")
            {
                Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
                Value = createNodeAndAppandNodeText(oList, Cell, Value, "VALUE", oRows[i].cells[3].innerHTML);
            }
        }
        return getXmlString(oList);
    }
    else {
        return "";
    }
}