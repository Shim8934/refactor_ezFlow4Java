var arrCategory = new Array();
var g_DeptCode = "";
var g_DeptName = "";
var g_arrInitValue = new Array();
g_arrInitValue[0]="";
g_arrInitValue[1]="";
g_arrInitValue[2]="";
g_arrInitValue[3]="";

function selTaskCategory_onchange() 
{
	 var idx = document.getElementById("selTaskCategory").selectedIndex;
	 
	 if(idx > -1)
	 {
		arrCategory[2] = document.getElementById("selTaskCategory").value;
		arrCategory[3] = document.getElementById("selTaskCategory").options[idx].text;
	 
		GetTaskMiddleCategory(arrCategory[2]);
	 }
}

function selTaskMCategory_onchange()
{
	var idx = document.getElementById("selTaskMCategory").selectedIndex;
	if(idx > -1)
	{
		arrCategory[4] = document.getElementById("selTaskMCategory").value;
		arrCategory[5] = document.getElementById("selTaskMCategory").options[idx].text;

		GetTaskSubCategory(arrCategory[4], g_arrInitValue[2]);
		g_arrInitValue[2]="";	
	}
}

function TaskSCateList_rowclick()
{
	var DocList = new ListView();
    DocList.LoadFromID("DivTaskSCateList");   
    var tr = DocList.GetSelectedRows();
    if(tr.length > 0)
	{
	    var selnode = tr[0];
		arrCategory[0] = selnode.getAttribute("DATA1");
		arrCategory[1] = selnode.cells[1].innerHTML;
		
		if(typeof(TaskList)!="undefined")
		{
			GetTaskListInSubCategory(arrCategory[0],g_arrInitValue[3]);
			g_arrInitValue[3]="";
		}
	}
	else
	{
		if(typeof(TaskList)!="undefined")
		{
			GetTaskListInSubCategory("__No__Selected__Row__", "");
		}
	}
}

function InitCategorySelection()
{
	var result = "";
    $.ajax({
		type : "POST",
		dataType : "text",
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
    
	var xmlRtn = loadXMLString(result);
	var dataNodes = GetChildNodes(xmlRtn); 
	var rtnValue = getNodeText(dataNodes[0]);
	
	if (rtnValue == "FALSE")
	{
		alert(strLang465);
	}
	else
	{
		var nodesCategory = SelectNodes(xmlRtn, "TASKCATEGORY/CATEGORY");
		if(nodesCategory != null)
		{		    
			InitCodeSelectBox(nodesCategory, selTaskCategory);
		}
			
		SelectOption(selTaskCategory, g_arrInitValue[0]);
		g_arrInitValue[0]="";
	}
}

function GetTaskMiddleCategory(pCode)
{	
	var result = "";
    $.ajax({
		type : "POST",
		dataType : "text",
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
    
	var xmlRtn = loadXMLString(result);
	var dataNodes = GetChildNodes(xmlRtn); 
	var rtnValue = getNodeText(dataNodes[0]);

	if (rtnValue == "FALSE")
	{
		alert(strLang471);
	}
	else
	{
		document.getElementById("selTaskMCategory").innerHTML = "";
		var nodesCategory =  SelectNodes(xmlRtn, "TASKMCATEGORY/MCATEGORY");
	
		if(nodesCategory)
		{
			InitCodeSelectBox(nodesCategory, selTaskMCategory);
		}
		
		SelectOption(selTaskMCategory, g_arrInitValue[1]);
		g_arrInitValue[1]="";
		selTaskMCategory_onchange();
	}
}
function GetTaskSubCategory(pCode, pSubCategoryCode)
{	    
	var result = "";
    $.ajax({
		type : "POST",
		dataType : "text",
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
    
	var rtnXml = loadXMLString(result);
	var dataNodes = GetChildNodes(rtnXml); 
	var rtnValue = getNodeText(dataNodes[0]);
	
	var iSeledtedIdx=0;
	
	if (rtnValue =="FALSE")
	{
		alert(strLang474);
	}
	else
	{
	    var headerData = createXmlDom();
	    headerData = loadXMLString(Category_h.innerHTML.toUpperCase());

	    var GetXml = "<LISTVIEWDATA>";
        GetXml = GetXml + "<ROWS>";
        var CateCnt = GetChildNodes(GetChildNodes(rtnXml.childNodes[0])[1]).length;
	    for (var i = 0; i < CateCnt; i++) {
	        var pcode = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(rtnXml, "LISTVIEWDATA/ROWS/ROW").item(i))[0])[0]);
	        var SubXml = GetListInSubCateList(pcode);
	        var CateSubcnt = GetChildNodes(GetChildNodes(SubXml.childNodes[0])[1]).length;

	        for (var y = 0; y < CateSubcnt; y++) {
	            var simpleCode = getNodeText(SelectSingleNode(GetChildNodes(SelectNodes(SubXml, "LISTVIEWDATA/ROWS/ROW")[y])[0], "DATA1"));  //철코드
	            var simpleXml = GetSimpleList(arr_userinfo[4], "", simpleCode, g_SelCabID, g_InitFlag);
	            var simpleCnt = SelectNodes(simpleXml, "LISTVIEWDATA/ROWS/ROW").length;

	            var curCategory = SelectNodes(rtnXml, "LISTVIEWDATA/ROWS/ROW")[i];
	            var curSubCategory = SelectNodes(SubXml, "LISTVIEWDATA/ROWS/ROW")[y];
	            if (!simpleCnt) {
	                GetXml = GetXml + GetmakeXml(curCategory, curSubCategory, false, false);
	            }
	            for (var z = 0; z < simpleCnt; z++) {
	                var curSimple = SelectNodes(simpleXml, "LISTVIEWDATA/ROWS/ROW")[z];
	                GetXml = GetXml + GetmakeXml(curCategory, curSubCategory, curSimple, false);
	            }
	        }
	    }
	    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";

	    var xmldoc = loadXMLString(GetXml);
	    if (CrossYN()) {
	        var xmlRtn = xmldoc.documentElement.getElementsByTagName("ROWS")[0];
	        var Node = headerData.importNode(xmlRtn, true);
	        headerData.documentElement.appendChild(Node);
	    }
	    else {
	        var xmlRtn = xmldoc.documentElement.getElementsByTagName("ROWS")[0];
	        headerData.documentElement.appendChild(xmlRtn);
	    }

        if (document.getElementById("TaskSCateList").innerHTML != "") document.getElementById("TaskSCateList").innerHTML = "";
		var DocList = new ListView();                           
		DocList.SetID("DivTaskSCateList");                      
		DocList.SetMulSelectable(false);                       
		DocList.SetSelectFlag(false);
		DocList.SetRowOnClick("TaskSCateList_onclick");
        DocList.SetTitleIdx(0);                           
        DocList.DataSource(headerData);                   
        DocList.DataBind("TaskSCateList");                
		
		var len = DocList.GetRowCount();
		if (len > 0 && g_SelCabID != "")
		{
			if(typeof(pSubCategoryCode)!="undefined")
			{
				if(pSubCategoryCode != "")
				{
				    iSeledtedIdx = GetSelIdxForSubCate(DocList.GetDataRows(), len, g_SelCabID);
				}
			}
			selectRow("DivTaskSCateList", iSeledtedIdx);
		}
		
		DocList = null;
	}
}

function TaskSCateList_onclick()
{
    var MyTaskList = new ListView();
    MyTaskList.LoadFromID("DivMyTaskSCateList");
    MyTaskList.SetUnSelected("DivMyTaskSCateList");
}

function GetmakeXml(selCate, selSub, selSimple, SearchFlag) {
    var strXml = "";
    strXml = strXml + "<ROW>";
    //철단위
    if (!selSimple) {
        strXml = strXml + "<CELL>";
        strXml = strXml + "<VALUE>-</VALUE>";
        strXml = strXml + "<DATA1></DATA1>";
        strXml = strXml + "<DATA2></DATA2>";
        strXml = strXml + "<DATA3></DATA3>";
        strXml = strXml + "<DATA4></DATA4>";
        strXml = strXml + "<DATA5></DATA5>";
        strXml = strXml + "<DATA6></DATA6>";
    }
    else {
        strXml = strXml + "<CELL>";
        strXml = strXml + "<VALUE>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[0])[0]) + "</VALUE>"; // TBCABINETCLASS.TITLE
        strXml = strXml + "<DATA1>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[0])[1]) + "</DATA1>"; // TBCABINET.CABINETID
        strXml = strXml + "<DATA2>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[0])[2]) + "</DATA2>"; // TBCABINETCLASS.TASKCODE
        strXml = strXml + "<DATA3>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[0])[3]) + "</DATA3>"; // TBCABINET.CABINETCLASSNO
        strXml = strXml + "<DATA4>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[0])[4]) + "</DATA4>"; // TBCABINETCLASS.OWNERID
        strXml = strXml + "<DATA5>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[0])[5]) + "</DATA5>"; // TBCABINETCLASS.TITLE
        strXml = strXml + "<DATA6>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[0])[6]) + "</DATA6>"; // TBCABINETCLASS.TITLE2
    }
    //첫번째 Cell값에 단위분류 DATA값을 넣는다 
    strXml = strXml + "<DATA7>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[1]) + "</DATA7>"; // VTASKCLASS.TASKCODE
    strXml = strXml + "<DATA8>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[2]) + "</DATA8>"; // VTASKCLASS.KEEPINGPERIOD
    strXml = strXml + "<DATA9>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[3]) + "</DATA9>"; // VTASKCLASS.TEMPFLAG
    strXml = strXml + "<DATA10>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[4]) + "</DATA10>"; // VTASKCLASS.DISPLAYRECFLAG
    strXml = strXml + "<DATA11>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[5]) + "</DATA11>"; // VTASKCLASS.SPECIALCATALOGFLAG
    strXml = strXml + "<DATA12>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[6]) + "</DATA12>"; // VTASKCLASS.SC1
    strXml = strXml + "<DATA13>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[7]) + "</DATA13>"; // VTASKCLASS.SC2
    strXml = strXml + "<DATA14>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[8]) + "</DATA14>"; // VTASKCLASS.SC3
    strXml = strXml + "<DATA15>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[9]) + "</DATA15>"; // VTASKCLASS.KEEPINGMETHOD
    strXml = strXml + "<DATA16>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[10]) + "</DATA16>"; // VTASKCLASS.KEEPINGPLACE
    strXml = strXml + "<DATA17>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[11]) + "</DATA17>"; // VTASKCLASS.TASKNAME
    strXml = strXml + "<DATA18>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[12]) + "</DATA18>"; // VTASKCLASS.TASKNAME2
    strXml = strXml + "</CELL>";

    //소뷴류 검색할때와 값이 다르다.
    if (SearchFlag) {
        strXml = strXml + "<CELL>";
        strXml = strXml + "<VALUE>" + getNodeText(SelectNodes(selCate, "LISTVIEWDATA/ROWS/ROW/CELL/DATA13")[0]) + "(" + getNodeText(SelectNodes(selCate, "LISTVIEWDATA/ROWS/ROW/CELL/DATA15")[0]) + ")" + "</VALUE>"; //소분류 & 코드 SCNAME(
        strXml = strXml + "<DATA1>" + getNodeText(SelectNodes(selCate, "LISTVIEWDATA/ROWS/ROW/CELL/DATA1")[0]) + "</DATA1>";
        strXml = strXml + "</CELL>";
    }
    else {
        strXml = strXml + "<CELL>";
        strXml = strXml + "<VALUE>" + getNodeText(GetChildNodes(GetChildNodes(selCate)[1])[0]) + "(" + getNodeText(GetChildNodes(GetChildNodes(selCate)[0])[0]) + ")" + "</VALUE>"; // SCNAME(SUBCATEGORYCODE)
        strXml = strXml + "<DATA1>" + getNodeText(GetChildNodes(GetChildNodes(selCate)[0])[1]) + "</DATA1>";
        strXml = strXml + "</CELL>";
    }
    

    //단위업무
    strXml = strXml + "<CELL><VALUE>" + getNodeText(GetChildNodes(GetChildNodes(selSub)[1])[0]) + "(" + getNodeText(GetChildNodes(GetChildNodes(selSub)[0])[0]) + ")" + "</VALUE>"; //VTASKCLASS.TASKNAME(VTASKCLASS.TASKCODE)
    strXml = strXml + "</CELL>";
    if (!selSimple) {
        strXml = strXml + "<CELL><VALUE>-</VALUE></CELL>";
        strXml = strXml + "<CELL><VALUE>-</VALUE></CELL>";
        strXml = strXml + "<CELL><VALUE>-</VALUE></CELL>";
        
    }
    else {
        strXml = strXml + "<CELL><VALUE>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[1])[0]) + "</VALUE></CELL>"; //형태 
        strXml = strXml + "<CELL><VALUE>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[2])[0]) + "</VALUE></CELL>"; //연변
        strXml = strXml + "<CELL><VALUE>" + getNodeText(GetChildNodes(GetChildNodes(selSimple)[3])[0]) + "</VALUE></CELL>"; //권호수
        
    }
    strXml = strXml + "</ROW>";

    
    return strXml;

}
function GetListInSubCateList(pCode) {
	var result = "";
    $.ajax({
		type : "POST",
		dataType : "text",
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
    
    return loadXMLString(result);
}


function GetSimpleList(pDeptCode, pProduceYear, pTaskCode, pCabID, pFlag) {
	var result = "";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCabinetSimpleList.do",
		data : {
			processDeptCode   : pDeptCode,
			companyID         : CompanyID,
			produceYear 	  : pProduceYear,
			langType		  : UserLang,
			flag			  : pFlag,
			taskCode		  : pTaskCode
		},
		success: function(xml){
			result = xml;
		}        			
	});

    return loadXMLString(result);
}

function GetSelIdxForSubCate(Rows, len, pSubCategoryCode)
{
	var i;
	for(i=0; i<len; i++)
	{
		if(Rows[i].getAttribute("DATA1")==pSubCategoryCode)
			return i;
	}
	return 0;
}

function GetTaskListInSubCategory(pCode, pTaskCode)
{
	var result = "";
    $.ajax({
		type : "POST",
		dataType : "text",
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
    
	var rtnXml = loadXMLString(result);
	var dataNodes = GetChildNodes(rtnXml);
	var retValue = getNodeText(dataNodes[0]);
	
	var iSeledtedIdx=0;
	if (retValue == "FALSE")
	{
		alert(strLang477);
	}
	else
	{
		if (document.getElementById("TaskList").innerHTML != "") document.getElementById("TaskList").innerHTML = "";
        var DocList = new ListView();                     
		DocList.SetID("DivTaskList");                     
		DocList.SetMulSelectable(false);                  
        DocList.SetRowOnClick("TaskList_rowclick");       
        //DocList.SetRowOnDblClick("TaskList_rowdbclick");
        //DocList.SetTitleIdx(0);                         
        DocList.DataSource(rtnXml);                       
        DocList.DataBind("TaskList");                     
        
		var Rows = DocList.GetDataRows();
		var len = DocList.GetRowCount();
        
	
		if(len>0)
		{
			if(typeof(pTaskCode)!="undefined")
			{
				if(pTaskCode != "")
				{
					iSeledtedIdx=GetSelIdxForTask(Rows, len, pTaskCode);
				}
			}
			selectRow("DivTaskList", iSeledtedIdx);
		}
		DocList = null;	   

		TaskList_rowclick();
	}
}


function GetSelIdxForTask(Rows, len, pTaskCode)
{
	var i;
	for(i=0; i<len; i++)
	{
		if(Rows[i].getAttribute("DATA1") == pTaskCode)
			return i;
	}
	return 0;
}

function SelectCategory(strValue)
{
	document.getElementById("selTaskCategory").selectedIndex = document.getElementById("selTaskCategory").options(strValue).index;
}

function btnFindTask_onclick()
{
    var rtn = OpenTaskFindWin();
    
	if (rtn[0] == "TRUE")
	{
		FindTask(rtn[1], rtn[2], "2", g_DeptCode);
	}
}

function FindTask(pTitle, pCode, pFlag, pDeptCode)
{
	var rtnXml = GetFindTaskListXml(pTitle, pCode, pFlag, pDeptCode);
	var iSeledtedIdx=0;
	if (SelectSingleNodeValue(rtnXml, "REUSLT") =="FALSE")
	{
		alert(strLang478);
	}
	else
	{
	    var headerData = createXmlDom();
	    headerData = loadXMLString(Category_h.innerHTML.toUpperCase());

	    var GetXml = "<LISTVIEWDATA>";
	    GetXml = GetXml + "<ROWS>";

	    var CateSubcnt = GetChildNodes(GetChildNodes(rtnXml.childNodes[0])[1]).length;

	    for (var y = 0; y < CateSubcnt; y++) {
	        var simpleCode = getNodeText(SelectSingleNode(GetChildNodes(SelectNodes(rtnXml, "LISTVIEWDATA/ROWS/ROW")[y])[0], "DATA1"));  //철코드
	        var simpleXml = GetSimpleList(arr_userinfo[4], "", simpleCode, g_SelCabID, g_InitFlag);
	        var simpleCnt = SelectNodes(simpleXml, "LISTVIEWDATA/ROWS/ROW").length;
	        var curSubCategory = SelectNodes(rtnXml, "LISTVIEWDATA/ROWS/ROW")[y];
	        if (!simpleCnt) {
	            GetXml = GetXml + GetmakeXml(rtnXml, curSubCategory, false, true);
	        }
	        for (var z = 0; z < simpleCnt; z++) {
	            var curSimple = SelectNodes(simpleXml, "LISTVIEWDATA/ROWS/ROW")[z];
	            GetXml = GetXml + GetmakeXml(rtnXml, curSubCategory, curSimple, true);
	        }
	    }
	    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
		
	    var xmldoc = loadXMLString(GetXml);
	    if (CrossYN()) {
	        var xmlRtn = xmldoc.documentElement.getElementsByTagName("ROWS")[0];
	        var Node = headerData.importNode(xmlRtn, true);
	        headerData.documentElement.appendChild(Node);
	    }
	    else {
	        var xmlRtn = xmldoc.documentElement.getElementsByTagName("ROWS")[0];
	        headerData.documentElement.appendChild(xmlRtn);
	    }

	    if (document.getElementById("TaskSCateList").innerHTML != "") document.getElementById("TaskSCateList").innerHTML = "";
		var DocList = new ListView();
		DocList.SetID("DivTaskSCateList");
		DocList.SetMulSelectable(true);
        DocList.SetTitleIdx(0);
        DocList.DataSource(headerData);
        DocList.DataBind("TaskSCateList");
        
		var Rows = DocList.GetDataRows();
		var len = DocList.GetRowCount();
		
		if(len>0)
		{
			if(typeof(pTaskCode)!="undefined")
			{
				if(pTaskCode != "")
				{
					iSeledtedIdx=GetSelIdxForTask(Rows, len, pTaskCode);
				}
			}
			selectRow("DivTaskList", iSeledtedIdx);
		}
		DocList = null;	  
	}
}


function OpenTaskFindWin()
{
	var para = new Array();
	var url = "/ezApprovalG/findTask.do";
	var feature = "dialogWidth:360px;dialogHeight:205px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";
    feature =  feature + GetShowModalPosition(330, 205);
    var rtn;
	if(url != "")
	    rtn = window.showModalDialog(url,para,feature);
		
	return rtn;
}

function GetFindTaskListXml(pTitle, pCode, pFlag, pDeptCode)
{
	var result = "";
	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/findTaskList.do",
		data : {
			deptCode   : pDeptCode,
			title 	   : pTitle,
			code       : pCode,
			flag       : pFlag,
			companyID  : CompanyID,
			langType   : UserLang
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
	return loadXMLString(result);
}