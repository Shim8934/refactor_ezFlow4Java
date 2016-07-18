var arrCategory = new Array();
var g_DeptCode = "";
var g_DeptName = "";

var g_arrInitValue = new Array();
g_arrInitValue[0] = "";
g_arrInitValue[1] = "";
g_arrInitValue[2] = "";
g_arrInitValue[3] = "";

function selTaskCategory_onchange() {
    var idx = document.getElementById("selTaskCategory").selectedIndex;

    if (idx > -1) {
        arrCategory[2] = document.getElementById("selTaskCategory").value;
        arrCategory[3] = document.getElementById("selTaskCategory").options[idx].text;

        GetTaskMiddleCategory(arrCategory[2]);
    }
}

function selTaskMCategory_onchange() {
    var idx = document.getElementById("selTaskMCategory").selectedIndex;
    if (idx > -1) {
        arrCategory[4] = document.getElementById("selTaskMCategory").value;
        arrCategory[5] = document.getElementById("selTaskMCategory").options[idx].text;

        GetTaskSubCategory(arrCategory[4], g_arrInitValue[2]);
        g_arrInitValue[2] = "";	
    }
}

function TaskSCateList_rowclick() {
    var DocList = new ListView();          
    DocList.LoadFromID("DivTaskSCateList");
    var tr = DocList.GetSelectedRows();
    if (tr.length > 0) {
        var selnode = tr[0];
        arrCategory[0] = selnode.getAttribute("DATA1");
        arrCategory[1] = selnode.cells[1].innerHTML;

        if (typeof (TaskList) != "undefined")	
        {
            GetTaskListInSubCategory(arrCategory[0], g_arrInitValue[3]);
            g_arrInitValue[3] = "";	
        }
    }
    else {
        if (typeof (TaskList) != "undefined") {
            GetTaskListInSubCategory("__No__Selected__Row__", "");
        }
    }
}

function InitCategorySelection() {
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getTaskCategory.do",
		data : {
			deptCode   : g_DeptCode,
			companyID  : CompanyID,
			strType    : UserLang
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var xmlRtn = result;
    var dataNodes = GetChildNodes(xmlRtn);
    var rtnValue = getNodeText(dataNodes[0]);

    if (rtnValue == "FALSE") {
        alert(strLang465);
    }
    else {
        var nodesCategory = SelectNodes(xmlRtn, "TASKCATEGORY/CATEGORY");
        if (nodesCategory != null) {
            InitCodeSelectBox(nodesCategory, selTaskCategory);
        }

        SelectOption(selTaskCategory, g_arrInitValue[0]);	
        g_arrInitValue[0] = "";	
    }
}

function GetTaskMiddleCategory(pCode) {
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getTaskMiddleCategory.do",
		data : {
			cateCode   : pCode,
			companyID  : CompanyID,
			deptCode   : g_DeptCode
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var xmlRtn = result;
    var dataNodes = GetChildNodes(xmlRtn);
    var rtnValue = getNodeText(dataNodes[0]);

    if (rtnValue == "FALSE") {
        alert(strLang471);
    }
    else {
        document.getElementById("selTaskMCategory").innerHTML = "";

        var nodesCategory = SelectNodes(xmlRtn, "TASKMCATEGORY/MCATEGORY");
        if (nodesCategory) {
            InitCodeSelectBox(nodesCategory, selTaskMCategory);
        }

        SelectOption(selTaskMCategory, g_arrInitValue[1]);	
        g_arrInitValue[1] = "";	

        selTaskMCategory_onchange();
    }
}


function GetTaskSubCategory(pCode, pSubCategoryCode) {
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getTaskSubCategory.do",
		data : {
			cateCode   : pCode,
			companyID  : CompanyID,
			deptCode   : g_DeptCode,
			strType    : UserLang
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var rtnXml = result;
    var dataNodes = GetChildNodes(rtnXml);
    var rtnValue = getNodeText(dataNodes[0]);

    var iSeledtedIdx = 0;

    if (rtnValue == "FALSE") {
        alert(strLang474);
    }
    else {

        if (document.getElementById("TaskSCateList").innerHTML != "") document.getElementById("TaskSCateList").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DivTaskSCateList");                               
        DocList.SetMulSelectable(true);                        
        DocList.SetRowOnClick("TaskSCateList_rowclick");           
        DocList.SetTitleIdx(0);                                  

        DocList.DataSource(rtnXml);                             
        DocList.DataBind("TaskSCateList");                          

        var len = DocList.GetRowCount();

        if (len > 0) {
            if (typeof (pSubCategoryCode) != "undefined") {
                if (pSubCategoryCode != "") {
                    iSeledtedIdx = GetSelIdxForSubCate(DocList.GetDataRows(), len, pSubCategoryCode);
                }
            }
            selectRow("DivTaskSCateList", iSeledtedIdx);
        }

        DocList = null;
        TaskSCateList_rowclick();
    }
}



function GetSelIdxForSubCate(Rows, len, pSubCategoryCode) {
    var i;
    for (i = 0; i < len; i++) {
        if (Rows[i].getAttribute("DATA1") == pSubCategoryCode)
            return i;
    }
    return 0;
}

function GetTaskListInSubCategory(pCode, pTaskCode) {
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getTaskInSubCategory.do",
		data : {
			cateCode   : pCode,
			companyID  : CompanyID,
			deptCode   : g_DeptCode,
			strType    : UserLang
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var rtnXml = result;
    var dataNodes = GetChildNodes(rtnXml);
    var retValue = getNodeText(dataNodes[0]);

    var iSeledtedIdx = 0;
    if (retValue == "FALSE") {
        alert(strLang477);
    }
    else {

        if (document.getElementById("TaskList").innerHTML != "") document.getElementById("TaskList").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DivTaskList");                               
        DocList.SetMulSelectable(false);                        
        DocList.SetRowOnClick("TaskList_rowclick");
        DocList.SetRowOnDblClick("Add_onclick");

        DocList.DataSource(rtnXml);                             
        DocList.DataBind("TaskList");                          

        var Rows = DocList.GetDataRows();
        var len = DocList.GetRowCount();


        if (len > 0) {
            if (typeof (pTaskCode) != "undefined") {
                if (pTaskCode != "") {
                    iSeledtedIdx = GetSelIdxForTask(Rows, len, pTaskCode);
                }
            }
            selectRow("DivTaskList", iSeledtedIdx);
        }
        DocList = null;

        TaskList_rowclick();
    }
}


function GetSelIdxForTask(Rows, len, pTaskCode) {
    var i;
    for (i = 0; i < len; i++) {
        if (Rows[i].getAttribute("DATA1") == pTaskCode)
            return i;
    }
    return 0;
}

function SelectCategory(strValue) {
    document.getElementById("selTaskCategory").selectedIndex = document.getElementById("selTaskCategory").options(strValue).index;
}

function btnFindTask_onclick() {
    var rtn = OpenTaskFindWin();
}

function FindTask(pTitle, pCode, pFlag, pDeptCode) {
    var rtnXml = GetFindTaskListXml(pTitle, pCode, pFlag, pDeptCode);

    var iSeledtedIdx = 0;
    if (SelectSingleNodeValue(rtnXml, "REUSLT") == "FALSE") {
        alert(strLang478);
    }
    else {

        if (document.getElementById("TaskList").innerHTML != "") document.getElementById("TaskList").innerHTML = "";
        var DocList = new ListView();                           
        DocList.SetID("DivTaskList");                               
        DocList.SetMulSelectable(true);                        
        DocList.SetRowOnClick("TaskList_rowclick");           
        DocList.SetRowOnDblClick("TaskList_rowdbclick");      
        DocList.SetTitleIdx(0);                                  

        DocList.DataSource(rtnXml);                             
        DocList.DataBind("TaskList");                          

        var Rows = DocList.GetDataRows();
        var len = DocList.GetRowCount();

        if (len > 0) {
            if (typeof (pTaskCode) != "undefined") {
                if (pTaskCode != "") {
                    iSeledtedIdx = GetSelIdxForTask(Rows, len, pTaskCode);
                }
            }
            selectRow("DivTaskList", iSeledtedIdx);
        }
        DocList = null;
        TaskList_rowclick();
    }
}

var findtask_cross_dialogArguments = new Array();
function OpenTaskFindWin(opentype, CompleteFunction) {
    var para = new Array();
    var url = "/ezApprovalG/findTask.do";

    if (CrossYN() || NonActiveX == "YES") {
        findtask_cross_dialogArguments[0] = para;
        if (CompleteFunction == undefined)
            findtask_cross_dialogArguments[1] = OpenTaskFindWin_Complete;
        else
            findtask_cross_dialogArguments[1] = CompleteFunction;

        if (opentype == undefined)
            DivPopUpShow(330, 205, url);
        else {
            var OpenWin = window.open(url, "FindTask_Cross", GetOpenWindowfeature(330, 205));
            try { OpenWin.focus(); } catch (e) { }
        }
    }
    else {
        var feature = "dialogWidth:360px;dialogHeight:205px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";
        if (url != "")
            var rtn = window.showModalDialog(url, para, feature);
        if (rtn[0] == "TRUE") {
            FindTask(rtn[1], rtn[2], "0", g_DeptCode);
        }
    }
}

function OpenTaskFindWin_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        FindTask(rtn[1], rtn[2], "0", g_DeptCode);
    }
}

function GetFindTaskListXml(pTitle, pCode, pFlag, pDeptCode) {
	var result = "";
	var pageSize = "";
	var pageNO = "";
	
	if (pFlag == "1") {
		pageSize = PageSize;
		pageNO = curpage;
	}
	
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/findTaskList.do",
		data : {
			deptCode   : pDeptCode,
			title 	   : pTitle,
			code       : pCode,
			flag       : pFlag,
			companyID  : CompanyID,
			langType   : UserLang,
			pageSize   : pageSize,
			pageNO     : pageNO
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    return result;
}