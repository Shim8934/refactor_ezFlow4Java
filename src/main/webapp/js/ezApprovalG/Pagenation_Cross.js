var sPage = 10;
function paging(p_page, p_nowblock) {
    if (DocListType == "getDocList") {
        var h, j, x_NAME, x_WIDTH, x_HEADER, x_CELL2, x_VALUE2, count;
        count = NodeList.length;
        var xmlpara = createXmlDom();
        var xmlRtn = createXmlDom();
        var ParaName, ParaValue;
        var Cnt, oOption;
        var objRoot, objNode;

        objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "NODE", document.getElementById("selSContName").value);
        createNodeAndInsertText(xmlpara, objNode, "BlockNum", p_page);
        createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
        createNodeAndInsertText(xmlpara, objNode, "SortHeader", SortHeader == null ? "" : SortHeader);
        createNodeAndInsertText(xmlpara, objNode, "sortType", sortType);

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
            setHeaderEventHandler();
        }
        pChackYN = "FALSE"
    }
    else if (DocListType == "GetDocSearch") {
        curpage = p_page;
        GetDocSearch();
    }
}

function pagingCount(p_page, p_nowblock) {
    var td;
    if (CrossYN())
        document.getElementById("PageNum").innerHTML = "";
    else
        setNodeText(document.getElementById("PageNum"),"");
    curpage = p_page;
    nowblock = p_nowblock;

    var Gopage;
    var comNoPerPage = sPage;
    var nextPage, mychoice, prevPage, total_block;
    totalPage = parseInt(NodeListLen / comNoPerPage);
    var strtext = "";

    if (((totalPage * comNoPerPage) != NodeListLen) && ((NodeListLen % comNoPerPage) != 0)) {
        totalPage = totalPage + 1;
    }

    if (curpage < totalPage)
        nextPage = parseInt(curpage) + 1;
    else
        nextPage = totalPage;

    if (curpage > 1)
        prevPage = parseInt(curpage) - 1;
    else
        prevPage = 1;
    mychoice = 10;

    total_block = parseInt(totalPage / mychoice);
    if (totalPage % mychoice == 0)
        total_block = total_block - 1;

    if (totalPage > 1) {
        if (nowblock > 0) {
            strtext = "<div onclick= 'return Block_Check(" + ((nowblock - 1) * mychoice + 1) + "," + (nowblock - 1) + ")' style='cursor:pointer;margin-top:3px;'>";
            strtext = strtext + "<img src='/images/ppage_pprevious.gif' border='0'></div>";
            td_Create(strtext);
        }
        if (curpage != 1 && NodeListLen != 0) {
            if (((curpage - 1) % mychoice) == 0) {
                block = nowblock - 1;
                strtext = "<div onclick= 'return Block_Check(" + prevPage + "," + block + ")' style='cursor:pointer;margin-top:3px;'>";
            }
            else {
                block = nowblock;
                strtext = "<div onclick= 'return Page_Click(" + prevPage + "," + block + ")' style='cursor:pointer;margin-top:3px;'>";
            }
            strtext = strtext + "<img src='/images/page_previous.gif' border='0'></div>";
            td_Create(strtext);
        }
        if (total_block != nowblock) {
            for (Gopage = 1; Gopage <= mychoice; Gopage++) {
                if (curpage != nowblock * mychoice + Gopage) {
                    strtext = "<div onclick='return Page_Click(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer;' >";
                    strtext = strtext + "[" + ((nowblock * mychoice) + Gopage) + "]</div>";
                    td_Create(strtext);
                }
                else {
                    strtext = "<font color='#0684f9'> [" + ((nowblock * mychoice) + Gopage) + "] </font>";
                    td_Create(strtext);
                }
            }
        }
        else {
            for (Gopage = 1; Gopage <= totalPage - mychoice * nowblock; Gopage++) {
                if (curpage != nowblock * mychoice + Gopage) {
                    strtext = "<div onclick='return Page_Click(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer' >";
                    strtext = strtext + "[" + ((nowblock * mychoice) + Gopage) + "]</div>";
                    td_Create(strtext);
                }
                else {
                    strtext = "<font color='#0684f9'> [" + ((nowblock * mychoice) + Gopage) + "] </font>";
                    td_Create(strtext);
                }
            }
        }
        if ((curpage != totalPage) && (NodeListLen != 0)) {
            if ((curpage % mychoice) == 0) {
                block = (nowblock + 1);
                strtext = "<div onclick='return Block_Check(" + nextPage + "," + block + ")' style='cursor:pointer;margin-top:3px;' >";
            }
            else {
                block = nowblock;
                strtext = "<div onclick='return Page_Click(" + nextPage + "," + block + ")' style='cursor:pointer;margin-top:3px;' >";
            }
            strtext = strtext + "<img src='/images/page_next.gif' border='0'></div>";
            td_Create(strtext);

        }
        if ((total_block > 0) && (nowblock < total_block)) {
            strtext = "<div onclick='return Block_Check(" + ((nowblock + 1) * mychoice + 1) + "," + (nowblock + 1) + ")' style='cursor:pointer;margin-top:3px;'>";
            strtext = strtext + "<img src='/images/ppage_nnext.gif' border='0'></div>";
            td_Create(strtext);
        }
    }
}
function td_Create(strtext) {
    td = document.getElementById("PageNum").insertCell(-1);
    td.width = "17px";
    td.height = "17px";
    td.align = "center";
    td.valign = "center";
    td.innerHTML = strtext;
}
function Page_Click(PageNum, block) {
    curpage = PageNum;
    nowblock = block;
    pChackYN = "TRUE";
    paging(curpage, nowblock);
}
function Block_Check(PageNum, BlockNum) {
    curpage = PageNum;
    nowblock = BlockNum;
    pChackYN = "TRUE";
    getDocList();
}
function lvSDocResize() {
}

function lvTDocResize() {
}