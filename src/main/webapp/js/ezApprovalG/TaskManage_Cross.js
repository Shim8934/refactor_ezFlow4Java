var Headers;

function GetTaskFullList() {
    curpage = 1;
    nowblock = 0;
    totalPage = 0;

    var ListName;
    switch (g_ListFlag) {
        case "1":
            Resultxml = GetTaskFullListXml();
            ListName = strLang440;
            break;

        case "2":
            Resultxml = GetTaskReqListXml();
            ListName = strLang442;
            break;
    }

    if (Resultxml != null)
    {
        if (SelectSingleNodeValue(Resultxml, "RESULT") == "FALSE")
        {
            alert(strLang443);
        }
        else {
            DisplayTaskList(Resultxml);
            document.getElementById("listcount").innerHTML = "<b>" + deptName + "</b>&nbsp;" + strLang444 + "&nbsp;" + ListName + " : <span class='point'>" + NodeListLen + "</span> " + strLang445;
        }
    }
}

function GetTaskReqListXml() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
    createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", PageSize);
    createNodeAndInsertText(xmlpara, objNode, "PAGENO", curpage);


    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/Manage/aspx/API_GetTaskRequestList.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseXML;
}

function btnUpdateClass_onclick() {
    bCon = confirm(strLang446)
    if (bCon) {
        if (UpdateTaskClass()) {
            if (DeptID == OrganID) {
                DeptID = "";
            }
            GetTaskFullList();
        }
    }
}

function btnUpdateTempReq_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();

    if (tr.length > 0) {
        selRow = tr[0];

        if (selRow.getAttribute("DATA6") == "1") {
            OpenNewTaskReqWin(DeptID, selRow.getAttribute("DATA1"), "0");
            GetTaskFullList();
        }
        else {
            alert(strLang447);
        }
    }
    else {
        alert(strLang448);
    }
}

var viewtaskinfo_cross_dialogArguments = new Array();
function btnViewTaskInfo_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();

    if (tr.length > 0) {
        selRow = tr[0];
        var para = new Array();
        para[0] = DeptID;
        para[1] = selRow.getAttribute("DATA1");

        var url = "/admin/ezApprovalG/viewTaskInfo.do";

        viewtaskinfo_cross_dialogArguments[0] = para;

        var OpenWin = window.open(url, "ViewTaskInfo", GetOpenWindowfeature(450, 705));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
    	OpenAlertUI(strLang437);
    }
}

function btnFindTaskFullList_onclick() {
    var rtn = OpenTaskFindWin("OPEN", btnFindTaskFullList_onclick_Complete);
}

function btnFindTaskFullList_onclick_Complete(rtn) {
    if (rtn[0] == "TRUE") {
        FindFullTask(rtn[1], rtn[2], "1", DeptID);
    }
}

function FindFullTask(pTitle, pCode, pFlag, pDeptCode) {
    curpage = 1;
    nowblock = 0;
    totalPage = 0;

    Resultxml = GetFindTaskListXml(pTitle, pCode, pFlag, pDeptCode);

    if (getXmlString(Resultxml) != "") {
        var dataNodes = GetChildNodes(Resultxml);
        if (getNodeText(dataNodes[0]) == "FALSE") {
            alert(strLang449);
        }
        else {
            DisplayTaskList(Resultxml);
            document.getElementById("listcount").innerHTML = strLang450 + GetChildNodes(NodeList).length + strLang451;
        }
    }
}


function DisplayTaskList(Resultxml) {
    ListViewData = SelectSingleNodeNew(Resultxml, "LISTVIEWDATA");
    NodeList = SelectSingleNodeNew(Resultxml, "LISTVIEWDATA/ROWS");
    Haders = SelectSingleNodeNew(Resultxml, "LISTVIEWDATA/HEADERS/HEADER");

    Headers = SelectSingleNodeNew(Resultxml, "LISTVIEWDATA/HEADERS");
    NodeListLen = 0;

    if (NodeList) {
        NodeListLen = GetChildNodes(NodeList).length;
    }

    var xmlDoc;
    if (PageSize < 0) {
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
                                  
        DocList.SetRowOnClick("lvtDoclist_onselchanged");           
        DocList.SetRowOnDblClick("btnViewTask_onclick");      
        DocList.SetTitleIdx(0);                                  

        DocList.DataSource(xmlDoc);                             
        DocList.DataBind("lvtDoclist");                          
        DocList = null;
    }
    else if (NodeListLen > PageSize) {
        paging_Task(curpage, nowblock);
    }
    else {
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
                                  
        DocList.SetRowOnClick("lvtDoclist_onselchanged");           
        DocList.SetRowOnDblClick("btnViewTaskInfo_onclick");      
        DocList.SetTitleIdx(0);                                  

        DocList.DataSource(xmlDoc);                             
        DocList.DataBind("lvtDoclist");                          
        DocList = null;

        pagingCount_Task(curpage, nowblock);
    }
}


function paging_Task(p_page, p_nowblock) {
    var count = NodeList.item(0).childNodes.length;

    var s_page = PageSize * (p_page - 1) + 1;
    var e_page = PageSize * p_page;

    if (totalPage == p_page) {
        if (NodeListLen % PageSize != 0) {
            e_page = s_page + (NodeListLen % PageSize) - 1;
        }
    }

    var xmlpara = createXmlDom();

    var objRoot = xmlpara.createNode(1, "LISTVIEWDATA", "");
    xmlpara.appendChild(objRoot);
    objRoot.appendChild(Headers.cloneNode(true));

    var x_ROWS = xmlpara.createNode(1, "ROWS", "");
    objRoot.appendChild(x_ROWS);

    var i;
    for (i = s_page; i <= e_page; i++) {
        x_ROWS.appendChild(NodeList[i - 1].cloneNode(true));
    }

    if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
    var DocList = new ListView();                           
    DocList.SetID("DocList");                               
    DocList.SetMulSelectable(true);                        
                              
    DocList.SetRowOnClick("lvtDoclist_onselchanged");           
    DocList.SetRowOnDblClick("btnViewTaskInfo_onclick");      
    DocList.SetTitleIdx(0);                                  

    DocList.DataSource(xmlpara);                             
    DocList.DataBind("lvtDoclist");                          
    DocList = null;

    pagingCount_Task(p_page, p_nowblock);
}

function pagingCount_Task(p_page, p_nowblock) {
    var td;
    PageNum.innerText = "";
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

    mychoice = PageSize;

    total_block = parseInt(totalPage / mychoice);

    if (totalPage % mychoice == 0)
        total_block = total_block - 1;


    if (totalPage > 1) {
        if (nowblock > 0) {
            strtext = "<a onclick= 'return paging_Task(" + ((nowblock - 1) * mychoice + 1) + "," + (nowblock - 1) + ")' style='cursor:pointer'>";
            strtext = strtext + "<img src='/images/page_previous.gif' width='15' height='15'  border='0' align='absmiddle'>&nbsp;</a>";
            td_Create_Task(strtext);
        }

        if (curpage != 1 && NodeListLen != 0) {
            if (((curpage - 1) % mychoice) == 0) {
                block = nowblock - 1;
                strtext = "<a onclick= 'return paging_Task(" + prevPage + "," + block + ")' style='cursor:pointer'>&nbsp";
            }
            else {
                block = nowblock;
                strtext = "<a onclick= 'return paging_Task(" + prevPage + "," + block + ")' style='cursor:pointer'>&nbsp";
            }

            strtext = strtext + "<img src='/images/page_previous.gif' width='15' height='15'  border='0' align='absmiddle'></a>&nbsp;";
            td_Create_Task(strtext);
        }

        if (total_block != nowblock) {
            for (Gopage = 1; Gopage <= mychoice; Gopage++) {

                if (curpage != nowblock * mychoice + Gopage) {
                    strtext = "<a onclick='return paging_Task(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer'>";
                    strtext = strtext + "" + "<span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></a>&nbsp;";
                    td_Create_Task(strtext);
                }
                else
                {
                    strtext = "<b><span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></b>&nbsp;";
                    td_Create_Task(strtext);

                }
            }
        }
        else {
            for (Gopage = 1; Gopage <= totalPage - mychoice * nowblock; Gopage++) {
                if (curpage != nowblock * mychoice + Gopage) {
                    strtext = "<a onclick='return paging_Task(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer'>";
                    strtext = strtext + "" + "<span style = font-size:'10pt'>" + ((nowblock * mychoice) + Gopage) + "</span></a>&nbsp;";
                    td_Create_Task(strtext);
                }
                else
                {
                    strtext = "<b><span style = font-size:'10pt';>" + ((nowblock * mychoice) + Gopage) + "</span></b>&nbsp;";
                    td_Create_Task(strtext);
                }
            }
        }

        if ((curpage != totalPage) && (NodeListLen != 0)) {
            if ((curpage % mychoice) == 0) {
                block = (nowblock + 1);
                strtext = "&nbsp<a onclick='return paging_Task(" + nextPage + "," + block + ")' style='cursor:pointer' >";
            }
            else {
                block = nowblock;
                strtext = "&nbsp<a onclick='return paging_Task(" + nextPage + "," + block + ")' style='cursor:pointer' >";
            }

            strtext = strtext + "<img src='/images/page_next.gif' width='15' height='15' border='0' align='absmiddle'></a>&nbsp;";
            td_Create_Task(strtext);

        }

        if ((total_block > 0) && (nowblock < total_block)) {
            strtext = "<a onclick='return paging_Task(" + ((nowblock + 1) * mychoice + 1) + "," + (nowblock + 1) + ")' style='cursor:pointer'>";
            strtext = strtext + "<img src='/images/page_next.gif' width='15' height='15' border='0' align='absmiddle'></a>";
            td_Create_Task(strtext);
        }
    }
}

function td_Create_Task(strtext) {
    document.getElementById("PageNum").innerHTML = document.getElementById("PageNum").innerHTML + strtext;
}

function btnNewTaskReq_onclick() {
    OpenNewTaskReqWin(DeptID, "", "1");
    GetTaskFullList();
}

function OpenNewTaskReqWin(pDeptID, pTempTaskCode, pInitFlag) {
    var para = new Array();
    para[0] = pDeptID;
    para[1] = pTempTaskCode;


    var url = "/myoffice/ezApprovalG/ezCabinet/Manage/Req_NewTask_Cross.aspx?InitFlag=" + pInitFlag;
    var feature = "dialogWidth:453px;dialogHeight:710px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";

    if (url != "")
        var rtn = window.showModalDialog(url, para, feature);
}

function btnChDeptCodeReq_onclick() {
    var para = new Array();
    para[0] = DeptID;

    var url = "/myoffice/ezApprovalG/ezCabinet/Manage/Req_ChgDeptID_Cross.aspx";
    var feature = "dialogWidth:450px;dialogHeight:290px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";

    if (url != "")
        var rtn = window.showModalDialog(url, para, feature);

    GetTaskFullList();
}

function btnChOwnerDeptReq_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();

    if (tr.length != 0) {
        var selRow = tr[0];
        if (selRow.getAttribute("DATA6") == "0") {
            var para = new Array();
            para[0] = DeptID;
            para[1] = deptName;
            para[2] = selRow.getAttribute("DATA1");
            para[3] = selRow.cells[1].innerHTML;

            var url = "/myoffice/ezApprovalG/ezCabinet/Manage/Req_ChgOwnerDept_Cross.aspx";
            var feature = "dialogWidth:450px;dialogHeight:310px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";

            if (url != "")
                var rtn = window.showModalDialog(url, para, feature);

            GetTaskFullList();
        }
        else {
            alert(strLang452);
        }
    }
    else {
        alert(strLang437);
    }
}

function btnDisuseTaskReq_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();

    if (tr.length != 0) {
        var selRow = tr[0];
        if (selRow.getAttribute("DATA6") == "0") {
            var CabNum = GetValidCabNumInTask(selRow.getAttribute("DATA1"), DeptID);
            if (parseInt(CabNum) > 0) {
                alert(strLang453);
            }
            else if (CabNum == "0") {
                var para = new Array();
                para[0] = DeptID;
                para[1] = deptName;
                para[2] = selRow.getAttribute("DATA1");
                para[3] = selRow.cells[1].innerHTML;

                var url = "/myoffice/ezApprovalG/ezCabinet/Manage/Req_TaskDisuse_Cross.aspx";
                var feature = "dialogWidth:450px;dialogHeight:287px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";

                if (url != "")
                    var rtn = window.showModalDialog(url, para, feature);

                GetTaskFullList();
            }
        }
        else {
            alert(strLang454);
        }
    }
    else {
        alert(strLang437);
    }
}

function GetValidCabNumInTask(pTaskCode, pDeptCode) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS");
    createNodeAndInsertText(xmlpara, objNode, "TASKCODE", pTaskCode);
    createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", pDeptCode);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/Manage/aspx/API_GetValidCabNumInTask.aspx", false);
    xmlhttp.send(xmlpara);

    var rtnXml = xmlhttp.responseXML;
    var dataNodes = GetChildNodes(rtnXml);
    var retValue = getNodeText(dataNodes[0]);

    if (retValue == "FALSE") {
        alert(strLang455);
        return "-1";
    }
    else {
        return retValue;
    }
}

function btnUpdateTaskReq_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();

    if (tr.length != 0) {
        var selRow = tr[0];
        if (selRow.getAttribute("DATA6") == "0") {
            var para = new Array();
            para[0] = DeptID;
            para[1] = selRow.getAttribute("DATA1");

            var url = "/myoffice/ezApprovalG/ezCabinet/Manage/Req_ChgTaskInfo_Cross.aspx";
            var feature = "dialogWidth:470px;dialogHeight:512px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";

            if (url != "")
                var rtn = window.showModalDialog(url, para, feature);

            GetTaskFullList();
        }
        else {
            alert(strLang456);
        }
    }
    else {
        alert(strLang437);
    }
}

function GetTaskFullListXml() {
	var tempRet;
	$.ajax({
		type : "POST",
		url : "/admin/ezApprovalG/getTaskFullList.do",
		async : false,
		data : {deptCode : DeptID, companyID : CompanyID, pageSize : PageSize, pageNo : curpage, langType : UserLang},
		success : function (result) {
			tempRet = loadXMLString(result);
		}
	});
	return tempRet;
}

function UpdateTaskClass() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS");
    createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);


    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/Manage/aspx/API_UpdateTaskClass.aspx", false);
    xmlhttp.send(xmlpara);

    var rtnXml = xmlhttp.responseXML;
    var dataNodes = GetChildNodes(rtnXml);
    var rtnValue = getNodeText(dataNodes[0]);

    if (rtnValue == "NOCLASSFILE") {
        alert(strLang457);
        return false;
    }
    else if (rtnValue == "TRUE") {
        alert(strLang458);
        return true;
    }
    else {
        alert(strLang459);
        return false;
    }
}

function btnCreateTask_onclick() {
    var para = new Array();
    para[0] = UserID;
    para[1] = DeptID;
    para[2] = deptName;

    var url = "/myoffice/ezApprovalG/ezCabinet/Manage/CreateTempTask_Cross.aspx";
    var feature = "dialogWidth:678px;dialogHeight:520px;scroll:no;resizable:yes;status:no; help:no;edge:sunken ";

    if (url != "")
        var rtn = window.showModalDialog(url, para, feature);

    if (rtn[0] == "TRUE") {
        GetTaskFullList();
    }
}

var taskhistoryinfo_cross_dialogArguments = new Array();
function btnViewTaskHistoryInfo_onclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DocList");
    var tr = DocList.GetSelectedRows();

    if (tr.length != 0) {
        var selRow = tr[0];
        var para = new Array();
        para[0] = "";
        para[1] = selRow.getAttribute("DATA1");
        para[2] = CompanyID;

        var url = "/admin/ezApprovalG/taskHistoryInfo.do";

        taskhistoryinfo_cross_dialogArguments[0] = para;
        var OpenWin = window.open(url, "TaskHistoryInfo", GetOpenWindowfeature(840, 326));
        try { OpenWin.focus(); } catch (e) { }
    }
    else {
    	OpenAlertUI(strLang437);
    }

}


function DisplayTaskList_Admin(Resultxml) {
    ListView = Resultxml.selectSingleNode("LISTVIEWDATA");
    NodeList = Resultxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
    Haders = Resultxml.selectNodes("LISTVIEWDATA/HEADERS/HEADER");

    Headers = Resultxml.selectSingleNode("LISTVIEWDATA/HEADERS");
    NodeListLen = 0;

    if (NodeList) {
        NodeListLen = NodeList.length;
    }

    var xmlDoc
    if (PageSize < 0) {
    	if (CrossYN()) {
    		var xmlLIST = createXmlDom();
    		var nodeToImport = xmlLIST.importNode(ListViewData, true);
    		xmlLIST.appendChild(nodeToImport);
    		
    		xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
    	} else {
    		xmlDoc = createXmlDom();
    		xmlDoc = loadXMLString(ListViewData);
    	}

        if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
        var DocList = new ListView();
        DocList.SetID("DocList");
        DocList.SetMulSelectable(true);

        DocList.SetRowOnClick("lvtDoclist_onselchanged");
        DocList.SetRowOnDblClick("btnViewTaskInfo_onclick");
        DocList.SetTitleIdx(0);

        DocList.DataSource(xmlDoc);
        DocList.DataBind("lvtDoclist");
        DocList = null;
    }
    else if (NodeListLen > PageSize) {
        paging_Task(curpage, nowblock);
    }
    else {
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

        DocList.SetRowOnClick("lvtDoclist_onselchanged");
        DocList.SetRowOnDblClick("btnViewTaskInfo_onclick");
        DocList.SetTitleIdx(0);

        DocList.DataSource(xmlDoc);
        DocList.DataBind("lvtDoclist");
        DocList = null;

        pagingCount_Task(curpage, nowblock);
    }
    
}
