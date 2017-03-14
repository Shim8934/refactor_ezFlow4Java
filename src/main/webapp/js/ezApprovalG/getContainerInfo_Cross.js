var arrySubTab = new Array(0, 9, 4, 3, 4);
var subTabLastCol = 1;

function GetDocList(p_FormCd) {
    DocListType = "DocList";

    var pDocstate = "000";
    if (contFlag == "END")
        pDocstate = "001";
    else
        pDocstate = "011";

    if (pChackYN == "FALSE") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
        OrderOption = "";
        OrderCell = "";
    }

    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "ID", ContainerID);
    createNodeAndInsertText(xmlpara, objNode, "FLAG", "DETAIL");
    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "DocState", "");
    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
    createNodeAndInsertText(xmlpara, objNode, "subCondition", subCondition);

    if (GamSaFlag)
        xmlhttp.open("POST", "aspx/getGamSaDocList.aspx", true);
    else
        xmlhttp.open("POST", "aspx/getFormDocList.aspx", true);

    xmlhttp.onreadystatechange = getDocList_after;
    xmlhttp.send(xmlpara);
    //document.getElementById("listcount").innerHTML = strLang788 + "";
}


function getDocList_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    try {
        Resultxml = xmlhttp.responseXML;

        if (xmlhttp.responseText != "") {
            ListViewNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
            NodeList = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
            NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");
            NodeListLen = 0;

            
            if (NodeList2 != null) {
                var cnt = getNodeText(NodeList2);
                if (cnt != "") {
                    NodeListLen = cnt;
                }
                else
                    NodeListLen = 0;
            }

            var xmlDoc;
            if (CrossYN()) {
                var xmlLIST = createXmlDom();
                var nodeToImport = xmlLIST.importNode(ListViewNode, true);
                xmlLIST.appendChild(nodeToImport);

                xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
            }
            else {
                xmlDoc = createXmlDom();
                xmlDoc.appendChild(ListViewNode);
            }

            ListViewNode = xmlDoc;

            if (NodeListLen > 10) {
                paging(curpage, nowblock);
            }
            else {
                if (document.getElementById("lvtDoclist").innerHTML != "")
                    document.getElementById("lvtDoclist").innerHTML = "";

                var DocList = new ListView();      
                DocList.SetID("DocList");                               
                DocList.SetMulSelectable(false);                        
                DocList.SetHeaderOnClick("lvDocList_HeaderClick");      
                DocList.SetRowOnClick("lvtDoclist_SelChange");           
                DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
                DocList.SetUrgentFlag(true);                            
                DocList.SetSecurityFlag(true);                           
                DocList.DataSource(ListViewNode);                             
                DocList.DataBind("lvtDoclist");                          
                DocList = null;


                pagingCount(curpage, nowblock);
                selFirstRow(Resultxml);

            }

            //DisplayLineCnt(Resultxml, "1");

            pChackYN = "FALSE";
            makePageSelPage();
            if (USE_OCS == "YES")
                check_presence2();
        }

    }
    catch (e) { }
}

function DisplayLineCnt(Resultxml, viewtype) {
    var deptName;

    deptName = arr_userinfo[5];

    if (viewtype == "1") {
        if (GamSaFlag)
            document.getElementById("listcount").innerHTML = strLang789 + "<span class='point'>" + NodeListLen + "</span> " + strLang445;
        else
            document.getElementById("listcount").innerHTML = "<b>" + deptName + "</b> " + strLang790 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
    }
    else
        document.getElementById("listcount").innerHTML = strLang791 + "<b><span class='point'>" + NodeListLen + "</span></b> " + strLang445;
}

function GetDocSearch() {
    DocListType = "GetDocSearch";

    var pDocstate = "000";
    if (contFlag == "END")
        pDocstate = "001";
    else
        pDocstate = "011";

    if (pChackYN == "FALSE" || SelYearFlag)
    {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
        OrderOption = "";
        OrderCell = "";
    }

    var objNode, i, nodeName
    var xmlpara = createXmlDom();
    createNodeInsert(xmlpara, objNode, "PARAMETER");


    for (i = 0; i < condition.length - 1 ; i++) {
        if (typeof(condition[i]) == "undefined")
            createNodeAndInsertText(xmlpara, objNode, "Param" + i, "");
        else
            createNodeAndInsertText(xmlpara, objNode, "Param" + i, condition[i]);
    }
    if (typeof(ContainerID) == "undefined") {
    	createNodeAndInsertText(xmlpara, objNode, "Param24", "");
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "Param24", ContainerID);
    }


    createNodeAndInsertText(xmlpara, objNode, "Param25", UserID);   	        
    createNodeAndInsertText(xmlpara, objNode, "Param26", arr_userinfo[4]);  	
    createNodeAndInsertText(xmlpara, objNode, "Param27", "DETAIL");             
    createNodeAndInsertText(xmlpara, objNode, "PageNum", curpage);              
    createNodeAndInsertText(xmlpara, objNode, "PageSize", PageSize);            
    createNodeAndInsertText(xmlpara, objNode, "DocState", "");

    if (subCondition == "")
        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", condition[condition.length - 1]);
    else if (condition[condition.length - 1] == "")
        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition);
    else
        createNodeAndInsertText(xmlpara, objNode, "pSubQuery", subCondition + " AND " + condition[condition.length - 1]);

    createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
    createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);


    
    if (GamSaFlag){
    	xmlhttp.open("POST", "/ezApprovalG/getGamSaSearchDocList.do", true);
    } else {
    	xmlhttp.open("POST", "/ezApprovalG/getFormSearchDocList.do", true);
    }

    xmlhttp.onreadystatechange = getsearchDocList_after;		
    xmlhttp.send(xmlpara);

    //ShowMailProgress();
    //document.getElementById("listcount").innerHTML = "<b><font color='#e67802'>" + strLang796 + "</font></b>";
}

function getsearchDocList_after() {
    if (xmlhttp == null || xmlhttp.readyState != 4) return;

    try {
        Resultxml = xmlhttp.responseXML;

        if (Resultxml.xml != "") {
            SelYearFlag = false;
            ListViewNode = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
            NodeList = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
            NodeList2 = SelectSingleNodeNew(Resultxml, "DOCLIST/TOTALCNT");
            Haders = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA/HEADERS/HEADER");
            NodeListLen = 0;

            
            if (NodeList2 != null) {
                var cnt = getNodeText(NodeList2);
                if (cnt != "")
                    NodeListLen = cnt;
                else
                    NodeListLen = 0;
            }

            var xmlDoc;
            if (CrossYN()) {
                var xmlLIST = createXmlDom();
                var nodeToImport = xmlLIST.importNode(ListViewNode, true);
                xmlLIST.appendChild(nodeToImport);

                xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
            }
            else {
                xmlDoc = createXmlDom();
                xmlDoc.appendChild(ListViewNode);
            }

            ListViewNode = xmlDoc;

            if (NodeListLen > 10) {

                paging(curpage, nowblock);
            }
            else {
                if (document.getElementById("lvtDoclist").innerHTML != "")
                    document.getElementById("lvtDoclist").innerHTML = "";

                var DocList = new ListView();      
                DocList.SetID("DocList");                               
                DocList.SetMulSelectable(false);                        
                DocList.SetHeaderOnClick("lvDocList_HeaderClick");      
                DocList.SetRowOnClick("lvtDoclist_SelChange");           
                DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
                DocList.SetUrgentFlag(true);                            
                DocList.SetSecurityFlag(true);                           
                DocList.DataSource(ListViewNode);                             
                DocList.DataBind("lvtDoclist");                          
                DocList = null;

                pagingCount(curpage, nowblock);
                selFirstRow(Resultxml);
            }

            //DisplayLineCnt(Resultxml, "2");
            makePageSelPage();
            pChackYN = "FALSE";
        }
        else {
            prompt(xmlhttp.responseText, xmlhttp.responseText);
        }
        HiddenMailProgress();
    }
    catch (e) { }
}

function selFirstRow(Resultxml) {

    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];

    if (oArrRows.length != 0) {
        DocID = tr.getAttribute("DATA1");
        pURL = tr.getAttribute("DATA2");
        WriterID = tr.getAttribute("DATA3");

        document.getElementById("tSearchCondi").style.display = "";
        document.getElementById("tViewDoc").style.display = "";
        document.getElementById("tbtnExcel").style.display = "";
        document.getElementById("tbtnExcelAll").style.display = "";

        if (tr.getAttribute("DATA5").trim() != "")
            document.getElementById("tDocInfo").style.display = "";
        else
            document.getElementById("tDocInfo").style.display = "none";
    }
    else {
        DocID = "";
        pURL = "";

        document.getElementById("tSearchCondi").style.display = "";
        document.getElementById("tViewDoc").style.display = "none";
        document.getElementById("tbtnExcel").style.display = "none";
        document.getElementById("tbtnExcelAll").style.display = "none";
        document.getElementById("tDocInfo").style.display = "none";
    }

    switch (jobState) {
        case "ATTACH":
            Attach_onclick();
            break;

        case "OPINION":
            Opinion_onclick();
            break;

        case "APPROVAL":
            Approval_onclick();
            break;

        case "RECIPENT":
            Recipent_onclick();
            break;
    }
}

function getDataInfo() {
	var pUrl = "";
	
    switch (jobState) {
        case "ATTACH":
        	pUrl = "/ezApprovalG/getTotalAttachInfo.do";
            break;

        case "OPINION":
        	pUrl = "/ezApprovalG/getOpinionInfo.do";
            break;

        case "APPROVAL":
        	pUrl = "/ezApprovalG/getLineList.do";
            break;

        case "RECIPENT":
        	pUrl = "/ezApprovalG/getReceiptinfo.do";
            break;
    }
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : pUrl,
		data : {
				docID : DocID,
				mode  : "END"
				},
		success: function(xml){
			getdoclistSub_after(loadXMLString(xml));
		}        			
	});
}

function getdoclistSub_after(xml) {
    try {
        Resultxml = xml;
        if (document.getElementById("lvtDetail").innerHTML != "")
            document.getElementById("lvtDetail").innerHTML = "";

        if (xml.documentElement.textContent == "NOTPERMISSION") {
            document.getElementById("lvtDetail").innerHTML = "<img src='/images/warning02.gif' width='120' height='100'><h1>" + strLang929 + "</h1>";
            document.getElementById("lvtDetail").style.textAlign = "center";
            return;
        }

        var DocList = new ListView();      
        DocList.SetID("SubDocList");                               
        DocList.SetMulSelectable(false);                        
        DocList.SetRowOnDblClick("lvtDetail_onSel_DBclick");      
        DocList.DataSource(Resultxml);
        DocList.DataBind("lvtDetail");

        if (USE_OCS == "YES" && jobState == "APPROVAL") {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                setTimeout(check_presence, 100);
            }
            else {
                check_presence();
            }
        }
    }
    catch (e) { }
}

var oArrRowsid = "";
function lvtDoclist_SelChange() {
    var SelList = new ListView();
    SelList.LoadFromID("DocList");
    var oArrRows = SelList.GetSelectedRows();

    if (oArrRowsid == oArrRows[0].id)
        return;

    if (oArrRows.length != 0) {
        var tr = oArrRows[0];

        oArrRowsid = tr.id;

        if (tr.getAttribute("DATA5").trim() != "")
            document.getElementById("tDocInfo").style.display = "";
        else
            document.getElementById("tDocInfo").style.display = "none";

        DocID = tr.getAttribute("DATA1");
        pURL = tr.getAttribute("DATA2");
        WriterID = tr.getAttribute("DATA3");

        switch (jobState) {
            case "ATTACH":
                Attach_onclick();
                break;

            case "OPINION":
                Opinion_onclick();
                break;

            case "APPROVAL":
                Approval_onclick();
                break;

            case "RECIPENT":
                Recipent_onclick();
                break;
        }
    }
}

function paging(p_page, p_nowblock) {
    var h, j, x_NAME, x_WIDTH, x_HEADER, x_CELL2, x_VALUE2, count;

    if (document.getElementById("lvtDoclist").innerHTML != "")
        document.getElementById("lvtDoclist").innerHTML = "";

    var DocList = new ListView();      
    DocList.SetID("DocList");                               
    DocList.SetMulSelectable(false);                        
    DocList.SetHeaderOnClick("lvDocList_HeaderClick");      
    DocList.SetRowOnClick("lvtDoclist_SelChange");           
    DocList.SetRowOnDblClick("lvtDoclist_onSel_DBclick");      
    DocList.SetUrgentFlag(true);                            
    DocList.SetSecurityFlag(true);                           
    DocList.DataSource(ListViewNode);                             
    DocList.DataBind("lvtDoclist");                          
    DocList = null;

    pagingCount(p_page, p_nowblock);
    selFirstRow(Resultxml);
    pChackYN = "FALSE";
}

var totalPages;
function pagingCount(p_page, p_nowblock) {
    totalPages = parseInt(NodeListLen / PageSize);
    if (((totalPages * PageSize) != NodeListLen) && ((NodeListLen % PageSize) != 0))
        totalPages = totalPages + 1;

    //document.getElementById("td_pTotalCount").innerHTML = totalPages;
    //document.getElementById("txt_PageInputNum").value = curpage;
    return;

    var td;

    document.getElementById("PageNum").innerHTML = "";

    curpage = p_page;

    nowblock = p_nowblock;

    var Gopage;
    var comNoPerPage = PageSize;

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

    mychoice = Block_Size;

    total_block = parseInt(totalPage / mychoice);

    if (totalPage % mychoice == 0)
        total_block = total_block - 1;

    if (totalPage > 1) {
        if (nowblock > 0) {
            strtext = "<a onclick= 'return Block_Check(" + ((nowblock - 1) * mychoice + 1) + "," + (nowblock - 1) + ")' style='cursor:pointer'>";
            strtext = strtext + "<img src='/images/page_previous.gif' width='15' height='15'  border='0' align='absmiddle'>&nbsp;</a>";

            td_Create(strtext);
        }

        if (curpage != 1 && NodeListLen != 0) {
            if (((curpage - 1) % mychoice) == 0) {
                block = nowblock - 1;
                strtext = "<a onclick= 'return Block_Check(" + prevPage + "," + block + ")' style='cursor:pointer'>&nbsp";
            }
            else {
                block = nowblock;
                strtext = "<a onclick= 'return Page_Click(" + prevPage + "," + block + ")' style='cursor:pointer'>&nbsp";
            }

            strtext = strtext + "<img src='/images/page_previous.gif' width='15' height='15'  border='0' align='absmiddle'></a>&nbsp;";

            td_Create(strtext);
        }

        if (total_block != nowblock) {
            for (Gopage = 1; Gopage <= mychoice; Gopage++) {
                if (curpage != nowblock * mychoice + Gopage) {
                    strtext = "<a onclick='return Page_Click(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer'>";
                    strtext = strtext + "" + "<span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></a>&nbsp;";

                    td_Create(strtext);
                }
                else
                {
                    strtext = "<b><span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></b>&nbsp;";

                    td_Create(strtext);
                }
            }
        }
        else {
            for (Gopage = 1; Gopage <= totalPage - mychoice * nowblock; Gopage++) {
                if (curpage != nowblock * mychoice + Gopage) {
                    strtext = "<a onclick='return Page_Click(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer'>";
                    strtext = strtext + "" + "<span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></a>&nbsp;";

                    td_Create(strtext);
                }
                else
                {
                    strtext = "<b><span style = font-size:'10pt';>" + ((nowblock * mychoice) + Gopage) + "</span></b>&nbsp;";

                    td_Create(strtext);
                }
            }
        }

        if ((curpage != totalPage) && (NodeListLen != 0)) {
            if ((curpage % mychoice) == 0) {
                block = (nowblock + 1);
                strtext = "&nbsp<a onclick='return Block_Check(" + nextPage + "," + block + ")' style='cursor:pointer' >";
            }
            else {
                block = nowblock;
                strtext = "&nbsp<a onclick='return Page_Click(" + nextPage + "," + block + ")' style='cursor:pointer' >";
            }
            strtext = strtext + "<img src='/images/page_next.gif' width='15' height='15' border='0' align='absmiddle'></a>&nbsp;";
            td_Create(strtext);
        }

        if ((total_block > 0) && (nowblock < total_block)) {
            strtext = "<a onclick='return Block_Check(" + ((nowblock + 1) * mychoice + 1) + "," + (nowblock + 1) + ")' style='cursor:pointer'>";
            strtext = strtext + "<img src='/images/page_next.gif' width='15' height='15' border='0' align='absmiddle'></a>";

            td_Create(strtext);
        }
    }
}

function td_Create(strtext) {
    document.getElementById("PageNum").innerHTML = document.getElementById("PageNum").innerHTML + strtext;
}

function Page_Click(PageNum, block) {
    curpage = PageNum;
    nowblock = block;
    pChackYN = "TRUE";

    if (DocListType == "DocList")
        GetDocList();
    else if (DocListType == "GetDocSearch")
        GetDocSearch();
}

function Block_Check(PageNum, BlockNum) {
    curpage = PageNum;
    nowblock = BlockNum;
    pChackYN = "TRUE";

    if (DocListType == "DocList")
        GetDocList();
    else if (DocListType == "GetDocSearch")
        GetDocSearch();
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != "") {
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
            var OpenWin = window.open(url, "ezAPRALERT_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
        else {
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

function isViewDoc(pDocID) {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "UserID", UserID);

    xmlhttp.open("POST", "aspx/isViewDoc.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
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
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);             
    createNodeAndInsertText(xmlpara, objNode, "MODE", "END");
    createNodeAndInsertText(xmlpara, objNode, "USERID", UserID);            
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);      

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezaprline/aspx/CheckAprLineUser.aspx", false);
    xmlhttp.send(xmlpara);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    return getNodeText(dataNodes[0]);
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
            tr.cells[1].innerHTML = "<span><img src='/images/presence/unknown.gif' id= '" + GetGUID() + "'  onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/>" + tr.cells[1].innerHTML + "</span>";
        }
    } catch (e) { }
}

function check_presence2() {
    try{
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetDataRows();
        var pCNList = new Array();
        for (var i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            pCNList[i] = tr.getAttribute("DATA3");
        }
        var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
        pCNList = null;
        for (i = 0; i < selRow.length; i++) {
            var tr = selRow[i];
            tr.cells[2].innerHTML = "<span><img src='/images/presence/unknown.gif' id= '" + GetGUID() + "'  onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/>" + tr.cells[2].innerHTML + "</span>";

        }
    } catch (e) { }
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

        if (condition[3] != "null" && condition[3].trim() != "") {
            TYPE += "STARTDATEAF;"
            DATA += "<STARTDATEAF>" + condition[3] + "</STARTDATEAF>";
        }

        if (condition[4] != "null" && condition[4].trim() != "") {
            TYPE += "STARTDATEBF;"
            DATA += "<STARTDATEBF>" + condition[4] + "</STARTDATEBF>";
        }

        if (condition[5] != "null" && condition[5].trim() != "") {
            TYPE += "ENDDATEAF;"
            DATA += "<ENDDATEAF>" + condition[5] + "</ENDDATEAF>";
        }

        if (condition[6] != "null" && condition[6].trim() != "") {
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
//        else if (pItemCD != "") {
//            TYPE += "CAPR;";
//            DATA += "<ITEMCODE>" + pItemCD + "</ITEMCODE>";
//        }
        if (typeof (condition[14]) != "undefined" && condition[14] != "") {
            TYPE += condition[14];
            DATA += condition[15];
        }
        if (typeof (condition[16]) != "undefined" && condition[16] != "") {
            TYPE += condition[16];
            DATA += condition[17];
        }

        SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
    }
