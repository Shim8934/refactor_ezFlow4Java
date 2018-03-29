﻿var g_szSCListXml = "";
var g_arrSCName = new Array();

function InitSCInfo_Mod(oSCNode) {
    g_arrSCName[0] = SelectSingleNodeValue(SelectSingleNode(oSCNode, "NAME"), "LIST1");
    g_arrSCName[1] = SelectSingleNodeValue(SelectSingleNode(oSCNode, "NAME"), "LIST2");
    g_arrSCName[2] = SelectSingleNodeValue(SelectSingleNode(oSCNode, "NAME"), "LIST3");

    var oList, ListViewData, Headers, Header, HName, HWidth, Rows, Row, Cell, Value;

    oList = createXmlDom();
    ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
    Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
    HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", strLang605);
    HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "35");

    var i;
    for (i = 0; i < g_arrSCName.length; i++) {
        if (g_arrSCName[i] != "")
        {
            Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
            HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", g_arrSCName[i]);
            HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "120");
        }
    }

    Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");

    var nlSCData = SelectNodes(oSCNode, "DATA");

    var i;
    for (i = 0; i < nlSCData.length; i++) {
        var Row = createNodeAndAppandNode(oList, Rows, Row, "ROW");
        var Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
        var Value = createNodeAndAppandNodeText(oList, Cell, Value, "VALUE", i + 1);
        Rows.appendChild(Row)
        if (g_arrSCName[0] != "") {
            var Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
            var Value = createNodeAndAppandNodeText(oList, Cell, Value, "VALUE", SelectSingleNodeValue(nlSCData[i], "LIST1"));
        }

        if (g_arrSCName[1] != "") {
            var Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
            var Value = createNodeAndAppandNodeText(oList, Cell, Value, "VALUE", SelectSingleNodeValue(nlSCData[i], "LIST2"));
        }

        if (g_arrSCName[2] != "") {
            var Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
            var Value = createNodeAndAppandNodeText(oList, Cell, Value, "VALUE", SelectSingleNodeValue(nlSCData[i], "LIST3"));
        }
    }

    g_szSCListXml = getXmlString(oList);
}