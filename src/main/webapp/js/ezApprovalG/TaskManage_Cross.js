var Headers;

function GetTaskFullList(pTitle, pCode, pFlag) {
    var ListName;

    listLoading(true);  // 20201215 강승구 로딩바 display:none
    Resultxml = GetTaskFullListXml(pTitle, pCode, pFlag);
    taskCount = getTaskCount(pTitle, pCode, pFlag);
    ListName = strLang440;

    if (Resultxml != null) {
        if (SelectSingleNodeValue(Resultxml, "RESULT") == "FALSE") {
            alert(strLang443);
        } else {
            DisplayTaskList(Resultxml);
            if (NodeListLen == null) {
            		NodeListLen = 0;
            }

            if (pageAdminFlag == 'admin') {
                document.getElementById("listcount").innerHTML = "<b>" + deptName + "</b>의 단위업무 : <span class='txt_color' style='font-weight:bold;'>" + taskCount + "</span> 개";
            } else {
                document.getElementById("listcount").innerHTML = taskCount;
            }
        }
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
    } else {
    	OpenAlertUI(strLang437);
    }
}

function btnFindTaskFullList_onclick() {
    var rtn = OpenTaskFindWin("OPEN", btnFindTaskFullList_onclick_Complete);
}

function btnFindTaskFullList_onclick_Complete(rtn) {
    if (rtn[0] == "TRUE") {
        curpage = 1;
        searchTitle = rtn[1];
        searchCode = rtn[2];
        searchFlag = "1";
        makePagenationBar(rtn[1], rtn[2], "1");

    } else if (rtn[0] == "FALSE") {
        curpage = 1;
        searchTitle = '';
        searchCode = '';
        searchFlag = '';
        makePagenationBar(null, null, '0');
    } else {
        alert(strLang449);
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
        } else {
            xmlDoc = createXmlDom();
            xmlDoc.appendChild(ListViewData);
        }

        if (document.getElementById("lvtDoclist").innerHTML != "") document.getElementById("lvtDoclist").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DocList");                               
        DocList.SetMulSelectable(true);                        

        if (pageAdminFlag == undefined || pageAdminFlag == null || pageAdminFlag !== 'admin') {
            DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");
        }
        DocList.SetRowOnClick("lvtDoclist_onselchanged");
        DocList.SetRowOnDblClick("btnViewTask_onclick");
        DocList.SetOrderbyCol("COLNAME");
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
        } else {
            xmlDoc = createXmlDom();
            xmlDoc.appendChild(ListViewData);
        }

        if (document.getElementById("lvtDoclist").innerHTML != "") {
            document.getElementById("lvtDoclist").innerHTML = "";
        }
        var DocList = new ListView();                           
        DocList.SetID("DocList");                               
        DocList.SetMulSelectable(true);                        
                                  
        if (pageAdminFlag == undefined || pageAdminFlag == null || pageAdminFlag !== 'admin') {
            DocList.SetHeaderOnClick("lvtDoclist_HeaderClick");
        }
        DocList.SetRowOnClick("lvtDoclist_onselchanged");
        DocList.SetRowOnDblClick("btnViewTaskInfo_onclick");
        DocList.SetOrderbyCol("COLNAME");
        DocList.SetTitleIdx(0);                                  

        DocList.DataSource(xmlDoc);                             
        DocList.DataBind("lvtDoclist");                          
        DocList = null;
    }
    listLoading(false); // 20201215 강승구 로딩바 display:none
}

function GetTaskFullListXml(pTitle, pCode, pFlag) {
	var tempRet;
	$.ajax({
		type : "GET",
		url : "/admin/ezApprovalG/getTaskFullList.do",
		async : false,
		data : {
		    deptCode : DeptID,
		    companyID : CompanyID,
		    pageSize : PageSize,
		    pageNo : curpage,
		    langType : UserLang,
		    title 	   : pTitle,
            code       : pCode,
            flag       : pFlag,
		    orderOption1: g_SortField,
		    orderOption2 : g_SortType
        },
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
    } else {
    	OpenAlertUI(strLang437);
    }
}

// 단위업무 갯수 호출 함수
function getTaskCount(pTitle, pCode, pFlag) {
    var tempRet;
    $.ajax({
		type : "GET",
		dataType: 'json',
		url : "/admin/ezApprovalG/getTaskCount.do",
		async : false,
		data : {
                    deptCode : DeptID, 
                    companyID : CompanyID,
                    title : pTitle,
                    code : pCode,
                    flag : pFlag
		        },
		success : function(result) {
			tempRet = result.taskCount;
		},
		error : function(error) {
			console.log(error);
		}
	});
	return tempRet;
}

// 내부노드 순회 삭제 함수
function removeAllChildNode(element) {
    if (element != null) {
        while (element.firstChild) {
            element.removeChild(element.firstChild);
        }
    }
}

// 페이지네이션 함수
function makePagenationBar(pTitle, pCode, pFlag) {
    var pageNavBox = $("<div class='pagenavi'>");
    pageNum = curpage;
    taskCount = getTaskCount(pTitle, pCode, pFlag);
    totalPage = Math.ceil(taskCount/PageSize) > 1 ? Math.ceil(taskCount/PageSize) : 1;

    var getFirstBtn = $('<span class="btnimg first">');
    var getPrevBlockBtn = $('<span class="btnimg prev">');
    var getNextBlockBtn = $('<span class="btnimg next">');
    var getLastBtn = $('<span class="btnimg last">');

    if (curpage != 1) {
        $(getFirstBtn).on("click", {pTitle:pTitle, pCode:pCode, pFlag:pFlag}, getFirstPage);
    } else {
        $(getFirstBtn).addClass("disabled");
    }
    if (curpage != totalPage) {
        $(getLastBtn).on("click", {pTitle:pTitle, pCode:pCode, pFlag:pFlag}, getLastPage);
    } else {
        $(getLastBtn).addClass("disabled");
    }

    if (Math.ceil(curpage/10) < Math.ceil(totalPage/10)) {
        $(getNextBlockBtn).on("click", {pTitle:pTitle, pCode:pCode, pFlag:pFlag}, getNextBlockPage);
    } else {
        $(getNextBlockBtn).addClass("disabled");
    }

    if (Math.ceil(curpage/10) > 1) {
        $(getPrevBlockBtn).on("click", {pTitle:pTitle, pCode:pCode, pFlag:pFlag}, getPrevBlockPage);
    } else {
        $(getPrevBlockBtn).addClass("disabled");
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
            $(pageBtn).on("click", {pTitle:pTitle, pCode:pCode, pFlag:pFlag}, goToPageByNumTask);
        }
        $(pageBtn).text(btnPageNum);
        $(pageNavBox).append(pageBtn);
    }
    $(pageNavBox).append(getNextBlockBtn);
    $(pageNavBox).append(getLastBtn);
    $('#tblPageRayer').append(pageNavBox);
    GetTaskFullList(pTitle, pCode, pFlag);
}

function getFirstPage(event) {
    curpage = 1;
    var pTitle = event.data.pTitle;
    var pCode = event.data.pCode;
    var pFlag = event.data.pFlag;
    makePagenationBar(pTitle, pCode, pFlag);
}

function getLastPage(event) {
    curpage = totalPage;
    var pTitle = event.data.pTitle;
    var pCode = event.data.pCode;
    var pFlag = event.data.pFlag;
    makePagenationBar(pTitle, pCode, pFlag);
}

function getPrevBlockPage(event) {
    curpage = (Math.ceil(curpage/10) - 2)*10 + 1;
    var pTitle = event.data.pTitle;
    var pCode = event.data.pCode;
    var pFlag = event.data.pFlag;
    makePagenationBar(pTitle, pCode, pFlag);
}

function getNextBlockPage(event) {
    curpage = (Math.ceil(curpage/10))*10 + 1;
    var pTitle = event.data.pTitle;
    var pCode = event.data.pCode;
    var pFlag = event.data.pFlag;
    makePagenationBar(pTitle, pCode, pFlag);
}

function goToPageByNumTask(event) {
    curpage = $(event.target).text();
    var pTitle = event.data.pTitle;
    var pCode = event.data.pCode;
    var pFlag = event.data.pFlag;
    makePagenationBar(pTitle, pCode, pFlag);
}
