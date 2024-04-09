var Headers;

function GetTaskFullList() {
    nowblock = 0;

    var ListName;

    listLoading(true);  // 20201215 강승구 로딩바 display:none
    switch (g_ListFlag) {
        case "1":
            Resultxml = GetTaskFullListXml();
            taskCount = getTaskCount();
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
            if(NodeListLen == null)
            	{
            		NodeListLen = 0;
            	}
            
            if (pageAdminFlag == 'admin') {
                document.getElementById("listcount").innerHTML = "<b>" + deptName + "</b>의 단위업무 : <span style='color:#017BEC;font-weight:bold;'>" + taskCount + "</span> 개";
            } else {
                document.getElementById("listcount").innerHTML = taskCount;
            }
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

        var OpenWin = window.open(url, "ViewTaskInfo", GetOpenWindowfeature(450, 710));
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
    } else {
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
    }

    listLoading(false); // 20201215 강승구 로딩바 display:none
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
		type : "GET",
		url : "/admin/ezApprovalG/getTaskFullList.do",
		async : false,
		data : {deptCode : DeptID, companyID : CompanyID, pageSize : PageSize, pageNo : curpage, langType : UserLang},
		success : function (result) {
			tempRet = loadXMLString(result);
		},
		error : function(error) {
		    console.log(error);
			tempRet = loadXMLString("<RESULT>FALSE</RESULT>");
		}
	});
	return tempRet;
}

function getTaskCount() {
    var tempRet;
    $.ajax({
		type : "GET",
		dataType: 'json',
		url : "/admin/ezApprovalG/getTaskCount.do",
		async : false,
		data : {deptCode : DeptID, companyID : CompanyID},
		success : function(result) {
			tempRet = result.taskCount;
		},
		error : function(error) {
			console.log(error);
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
    } else {
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
    }
    
}

function removeAllChildNode(element) {
    if (element != null) {
        while (element.firstChild) {
            element.removeChild(element.firstChild);
        }
    }
}

function makePagenationBar() {
    var pageNavBox = $("<div class='pagenavi'>");
    pageNum = curpage;
    
    var getFirstBtn = $('<span class="btnimg">');
    var getPrevBlockBtn = $('<span class="btnimg">');
    var getNextBlockBtn = $('<span class="btnimg">');
    var getLastBtn = $('<span class="btnimg">');
    
    if (curpage != 1) {
        $(getFirstBtn).on("click", getFirstPage);
        $(getFirstBtn).append("<img src='/images/kr/cm/btn_p_prev.gif'>");
    } else {
        $(getFirstBtn).append("<img src='/images/kr/cm/btn_p_prev01.gif'>");
    } 
    if (curpage != totalPage) {
        $(getLastBtn).on("click", getLastPage);
        $(getLastBtn).append('<img src="/images/kr/cm/btn_n_next.gif">');
    } else {
        $(getLastBtn).append('<img src="/images/kr/cm/btn_n_next01.gif">');
    }
             
    if (Math.ceil(curpage/10) < Math.ceil(totalPage/10)) {
        $(getNextBlockBtn).on("click", getNextBlockPage);
        $(getNextBlockBtn).append('<img src="/images/kr/cm/btn_next.gif">')
    } else {
        $(getNextBlockBtn).append('<img src="/images/kr/cm/btn_next01.gif">')
    }
    
    if (Math.ceil(curpage/10) > 1) {
        $(getPrevBlockBtn).on("click", getPrevBlockPage);
        $(getPrevBlockBtn).append('<img src="/images/kr/cm/btn_prev.gif">')
    } else {
        $(getPrevBlockBtn).append('<img src="/images/kr/cm/btn_prev01.gif">')
    }

    removeAllChildNode($('#tblPageRayer')[0]); // 기존 네비 삭제
    
    $(pageNavBox).append(getFirstBtn); 
    $(pageNavBox).append(getPrevBlockBtn);
    for (let i = 1 ; i < 11 ; i++) {
        var btnPageNum = Math.floor(curpage/10)*10 + i;
        var pageBtn = $('<span>');
        if (btnPageNum > totalPage) {
            break;
        }
        if (btnPageNum == curpage) {
             $(pageBtn).addClass('on');
        } else {
            $(pageBtn).on("click", goToPageByNumTask);
        }
        $(pageBtn).text(btnPageNum);
        $(pageNavBox).append(pageBtn);
    }
    $(pageNavBox).append(getNextBlockBtn);
    $(pageNavBox).append(getLastBtn);
    $('#tblPageRayer').append(pageNavBox);
    GetTaskFullList();
}

function getFirstPage() {
    curpage = 1;
    makePagenationBar();
}

function getLastPage() {
    curpage = totalPage;
    makePagenationBar();
}

function getPrevBlockPage() {
    curpage = (Math.ceil(curpage/10) - 2)*10 + 1;
    makePagenationBar();
}

function getNextBlockPage() {
    curpage = (Math.ceil(curpage/10))*10 + 1;
    makePagenationBar();
}

function goToPageByNumTask() {
    curpage = $(event.target).text();
    makePagenationBar();
}
