function Cabinetinfo_ini() 
{
    initUserRoleinfo();
    
    if(g_InitFlag=="1")	//분류 편철일 경우
    {
        if(g_bRecAdmin || AdminYN == "TRUE" || g_bDeptCharger)
        {
	        document.getElementById("trCreateCab").style.display="";
	        document.getElementById("trCreateCabDummy").style.display="none";
        }
        else
        {
	        document.getElementById("trCreateCab").style.display="none";
	        document.getElementById("trCreateCabDummy").style.display="";
        }
    }
	
    //기록물철 기능(분류) 정보를 가져오기 위한 처리과 코드를 초기화
    g_DeptCode=arr_userinfo[4];
    g_DeptName=arr_userinfo[5];
                
    var oList, ListViewData, Headers, Header, HName, HWidth, Rows, node;	
    oList = createXmlDom();
    ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA"); // Root Node 생성    	    	    	
		
    Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     //기록물철 이름
    createNodeAndAppandNodeText(oList, Header, node, "NAME", Cabinet1);
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     //연번
    createNodeAndAppandNodeText(oList, Header, node, "NAME", Cabinet5);
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "50");

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     //연번
    createNodeAndAppandNodeText(oList, Header, node, "NAME", Cabinet2);
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "50");    

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     //권호수
    createNodeAndAppandNodeText(oList, Header, node, "NAME", Cabinet3);
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");

    Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");	
    
    var Sel_Cabinet = new ListView();                           // ListView 선언
    Sel_Cabinet.SetID("SelDivCabinetList");                           // ID 지정
    Sel_Cabinet.SetMulSelectable(false);
    Sel_Cabinet.SetRowOnDblClick("SelCabinetList_rowdblclick");
    Sel_Cabinet.SetRowOnClick("SelCabinetList_rowclick");
    Sel_Cabinet.DataSource(oList);                             // DataSource 지정
    Sel_Cabinet.DataBind("Sel_CabinetList");

    //이전에 선택했던 철을 다시 선택하기위해 필요한 변수를 초기화한다.
    if(typeof(g_SelCabID)!="undefined")
    {
        if (g_SelCabID.trim() != "") {
            InitCabClassInfo(GetCabinetClassInfo(g_SelCabID));
        }
    }
    
    InitCategorySelection();
    selTaskCategory_onchange();
    MyCabinet_List();
    //document.getElementById("DivTaskSCateList_TH_2").style.whiteSpace = "nowrap";
    //document.getElementById("DivTaskSCateList_TH_2").style.wordBreak = "break-all";
    //document.getElementById("DivTaskSCateList_TH_2").style.width = "25%";
    //document.getElementById("DivTaskSCateList_TH_2").style.textOverflow = "ellipsis‎";
}
function GetCabinetClassInfo(pCabID) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCabinetInfo.do",
		data : {
			cabinetID  : pCabID,
			companyID  : CompanyID,
			strType    : UserLang
		},
		success: function(xml){
			result = xml;
		}        			
	});

    var dataNodes = GetChildNodes(loadXMLString(result));
    var rtnXml = getNodeText(dataNodes[0]);

    if (rtnXml == "FALSE") {
        alert(strLang483);
    }
    return loadXMLString(result);
}
function InitCabClassInfo(objCabInfoXml) {
    g_arrInitValue[0] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "CATECODE"));// objCabInfoXml.documentElement.selectSingleNode("CATECODE").text;
    g_arrInitValue[1] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "MCATECODE"));// objCabInfoXml.documentElement.selectSingleNode("MCATECODE").text;
    g_arrInitValue[2] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "SCATECODE"));// objCabInfoXml.documentElement.selectSingleNode("SCATECODE").text;
    g_arrInitValue[3] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "TASKCODE"));// objCabInfoXml.documentElement.selectSingleNode("TASKCODE").text;	
}
//pDeptCode, pProduceYear, pTaskCode에 해당하는 기록물철 리스트를 가져온 후
//pCabID에 해당한는 기록물철을 선택한다.
function GetCabinetSimpleList(pDeptCode, pProduceYear, pTaskCode, pCabID, pFlag) {
    var XmlHttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();// 매개변수 전달을 위한 XMLDOM
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); // Root Node 생성
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID); // 회사 아이디
    createNodeAndInsertText(xmlpara, objNode, "PROCESSDEPTCODE", pDeptCode);// 처리과 코드
    createNodeAndInsertText(xmlpara, objNode, "PRODUCTIONYEAR", pProduceYear);// 생산년도
    createNodeAndInsertText(xmlpara, objNode, "TASKCODE", pTaskCode);// 단위업무코드
    createNodeAndInsertText(xmlpara, objNode, "FLAG", pFlag);//조회 플래그: 0-대장보기 1-분류편철(이관된 기록물철은 가져오지 않는다.)
    createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", UserLang);//2010.08.17 다국어 추가

    XmlHttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_GetCabinetSimpleList.aspx", false);
    XmlHttp.send(xmlpara);

    var rtnXml = XmlHttp.responseXML;

    var iSeledtedIdx = 0;
    //	if (rtnXml.text =="FALSE")
    if (XmlHttp.responseText == "FALSE") {
        alert(strLang482);
    }
    else {
        //CabinetList.dataSource = rtnXml;		
        if (document.getElementById("CabinetList").innerHTML != "") document.getElementById("CabinetList").innerHTML = "";
        var DocList = new ListView();                           // ListView 선언
        DocList.SetID("DivCabinetList");                               // ID 지정
        DocList.SetMulSelectable(false);                        // MultiSelect 여부
        DocList.SetRowOnDblClick("CabinetList_rowdblclick");      // 리스트 더블클릭
        //        DocList.SetTitleIdx(0);                                 // 제목컬럼 idx  [...] 처리 
        DocList.SetSelectFlag(false);
        //DocList.SetUrgentFlag(false);                            // 긴급결재 붉은색 처리        
        DocList.DataSource(rtnXml);                             // DataSource 지정
        DocList.DataBind("CabinetList");                          // ListView DataBind	


        var Rows = DocList.GetDataRows();
        var len = DocList.GetRowCount();
        if (len > 0) {
            if (typeof (pCabID) != "undefined") {
                if (pCabID != "") {
                    iSeledtedIdx = GetSelIdxForCabinet(Rows, len, pCabID);
                }
            }
            //selectRow("DivCabinetList", iSeledtedIdx);
        }

        DocList = null;

    }
}

function SelCabinetList_rowdblclick()
{
    //AddRowToCabList();
    DelListRow(SelDivCabinetList);
}

function SelCabinetList_rowclick()
{
}

var AddFlag = false;
function CabinetList_rowdblclick()
{
    AddRowToCabList();
    AddFlag = true;
}

function AddCabList_onclick()
{
	AddRowToCabList();
}

function DelCabList_onclick()
{
    DelListRow(SelDivCabinetList);
}

function TaskList_rowclick()
{
    var listview = new ListView(); 
    listview.LoadFromID("DivTaskList");

	var selnode = listview.GetSelectedRows();
	
	if (selnode.length != 0)
	{
		arrTask[0] = selnode[0].getAttribute("DATA1");		//단위업무코드
		arrTask[1] = selnode[0].cells[1].innerText;	//단위업무명
		arrTask[3] = selnode[0].getAttribute("DATA2");			//단위업무 보존년한
		bDisplayFlag = selnode[0].getAttribute("DATA4");		//비치항목 여부
		bSpecialFlag = selnode[0].getAttribute("DATA5");	//특수목록 여부
		
		GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], g_SelCabID, g_InitFlag);
		
		if(typeof(g_SelCabID)!="undefined")
		{
			if(g_SelCabID!="")
			{
				AddRowToCabList();
			}
		}
		g_SelCabID="";	//초기화
	}
	else	//선택된 row가 없을 경우 단위업무 리스트뷰를 초기화한다.
	{
		GetCabinetSimpleList("", "", "__Dump__Year__", "", g_InitFlag);
	}
}


function AddRowToCabList()
{
	var IsValueInList = false;
	
	var selRow;
	var count;
	var listview = new ListView(); 
    listview.LoadFromID("DivCabinetList");
    
	var length = listview.GetSelectedRows().length;
	
	var SelCabRows;
	if(length>0)
	{
		if(g_InitFlag=="1")	//분류편철일 경우-1개의 철만을 선택할 수 있다.
		{		    
		    var SelCab = new ListView();
		    SelCab.LoadFromID("SelDivCabinetList");
		    SelCabRows=SelCab.GetDataRows();
		
			if(SelCabRows.length>0)
			{
				//alert("하나의 기록물철만을 선택할 수 있습니다.");
				
				var selIdx  = SelCabRows[0].getAttribute("id");
			    SelCab.DeleteRow(selIdx);
			}

			selRow = listview.GetSelectedRows()[0];
			AddRow(selRow);
		}
		else	//대장보기일 경우-여러개의 철들을 선택할 수 있다.
		{
			for(count = 0; count < length; count++)
			{						
				selRow = listview.GetSelectedRows()[count];
				
				var SelCab = new ListView();
				SelCab.LoadFromID("SelDivCabinetList");
		        
				var totalRows = SelCab.GetDataRows();
					
				if (totalRows.length > 0)
				{
					var i;
					for (i=0; i<totalRows.length; i++)
					{
						if (totalRows[i].getAttribute("DATA1") == selRow.getAttribute("DATA1"))
						{
							IsValueInList = true;
							break;
						}
					}
				}
					
				if( ! IsValueInList)
				{
					AddRow(selRow);
				}
				
				IsValueInList = false;
			}
		}
	}
}

function AddRow(selRow)
{    
    var selCabList = new ListView();      //// ListView 선언
    selCabList.LoadFromID("SelDivCabinetList"); 
    
	var row = "<ROW>";
	row += "<CELL>"
	row += "<VALUE>"
	row += selRow.cells[0].innerText;	//기록물철 이름
	row += "</VALUE>"
	row += "<DATA1>"
	row += selRow.getAttribute("DATA1");			//기록물철 아이디
	row += "</DATA1>"
	row += "<DATA2>"
	row += selRow.getAttribute("DATA2");			//단위업무코드
	row += "</DATA2>"
	row += "<DATA3>"
	row += selRow.getAttribute("DATA3");			//단위업무코드
	row += "</DATA3>"
	row += "<DATA4>"
	row += selRow.getAttribute("DATA4");			//단위업무코드
	row += "</DATA4>"
	row += "<DATA5>"
	row += selRow.getAttribute("DATA5");			//단위업무코드
	row += "</DATA5>"
	row += "<DATA6>"
	row += selRow.getAttribute("DATA6");			//단위업무코드
	row += "</DATA6>"
	row += "</CELL>"
	row += "<CELL>";
	row += "<VALUE>";
	row += selRow.cells[1].innerText;		//기록물형태	
	row += "</VALUE>";
	row += "</CELL>";
	row += "<CELL>";
	row += "<VALUE>";
	row += selRow.cells[2].innerText;  //기록물철 연번
	row += "</VALUE>";
	row += "</CELL>";
	row += "<CELL>";
	row += "<VALUE>";
	row += selRow.cells[3].innerText;  //기록물철 권호수
	row += "</VALUE>";
	row += "</CELL>";
	row += "</ROW>";
    
    var DeptAddIndex = selCabList.GetRowCount();
	DeptAddIndex = DeptAddIndex + 1;
	    
    var tr = selCabList.GetSelectedRows();
    var InitTr = selCabList.GetDataRows();
	
    var MaxID = 0;
    for(var j =0  ; j< InitTr.length  ;j++)
    {
        var curnum = Number(selCabList.GetSelectedRowID(j).substring(selCabList.GetSelectedRowID(j).lastIndexOf('_') + 1),selCabList.GetSelectedRowID(j).length);
        if(MaxID < curnum)
          MaxID = curnum;
    }   
    
    var rowXml = loadXMLString(row);
    if( tr.length == 0 )
    {
        if (InitTr.length == 0)
        {            
            var objTr = selCabList.AddRow(0);
            SetAttribute(objTr, "id", "Sel_CabinetList" + "_TR_" + eval(MaxID + 1));
            selCabList.AddDataRow(objTr, rowXml);	
		}
		else
		{
		    var objTr = selCabList.AddRow(DeptAddIndex-1);
		    SetAttribute(objTr, "id", "Sel_CabinetList" + "_TR_" + eval(MaxID + 1));
            selCabList.AddDataRow(objTr, rowXml);
		}
    }
    else
    {
        var objTr = selCabList.AddRow(DeptAddIndex-1);
        SetAttribute(objTr, "id", "Sel_CabinetList" + "_TR_" + eval(MaxID + 1));
        selCabList.AddDataRow(objTr, rowXml);
    }
}

function DelListRow(objListView) {
    var selRow;
    var count1, len;
    var selRows;

    var objList = new ListView();
    objList.LoadFromID(objListView);
    var selRows = objList.GetSelectedRows();

    if (AddFlag) {
        var selIdx = objList.GetSelectedRows()[0].getAttribute("id");
        objList.DeleteRow(selIdx);
    }
}

var addvolume_cross_dialogArguments = new Array();
var temppCabClassNo = "";
function NewVolume(pCabID, pCabClassNo) {
    var para = new Array();
    para[0] = pCabID;
    para[1] = pCabClassNo;

    var url = "/ezApprovalG/addVolume.do";
    if (CrossYN()) {
        addvolume_cross_dialogArguments[0] = para;
        addvolume_cross_dialogArguments[1] = NewVolume_Complete;
        DivPopUpShow(360, 310, url);
        temppCabClassNo = pCabClassNo;
    }
    else {
        var feature = "dialogWidth:360px;dialogHeight:310px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
        feature = feature + GetShowModalPosition(360, 310);

        var rtn = window.showModalDialog(url, para, feature);
        if (rtn[0] == "TRUE") {
            return AddNewVolume(pCabClassNo, rtn[1]);
        }
    }
}

function NewVolume_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE")
        AddNewVolume(temppCabClassNo, rtn[1]);
}

function AddNewVolume(pCabClassNo, pNewVolNo) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/addNewVolume.do",
		data : {
			cabClassNO : pCabClassNo,
			companyID  : CompanyID,
			newVolNO   : pNewVolNo
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    var dataNodes = GetChildNodes(loadXMLString(result));
    var rtn = getNodeText(dataNodes[0]);

    if (rtn == "FALSE") {
        alert(strLang486);
    }
    else
        selTaskMCategory_onchange();
}

function CabinetSearch_onclick() {
    if (document.getElementById("Cabinetkeyword").value.length <= 0) {
        alert(Cabinet6);
        return;
    } 
    var SearchNum = document.getElementById("selSearchOption").selectedIndex;
    if (SearchNum == "0") {
    	var date = new Date();    
        var result = "";
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getCabinetSearchAll.do",
    		data : {
    			companyID : CompanyID,
    			processDeptCode : arr_userinfo[4],
    			productionYear  : "",
    			searchKeyword   : document.getElementById("Cabinetkeyword").value,
    			flag : "1",
    			langType : "1"
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});
        
        var rtnXml = loadXMLString(result);
        var iSeledtedIdx = 0;
        if (SelectSingleNodeValue(rtnXml, "RESULT") == "FALSE") {
            alert(linealt17);
        }
        else {
            var headerData = createXmlDom();
            headerData = loadXMLString(Category_h.innerHTML.toUpperCase());

            if (CrossYN()) {
                var xmlRtn = rtnXml.documentElement.getElementsByTagName("ROWS")[0];
                var Node = headerData.importNode(xmlRtn, true);
                headerData.documentElement.appendChild(Node);
            }
            else {
                var xmlRtn = rtnXml.documentElement.getElementsByTagName("ROWS")[0];
                headerData.documentElement.appendChild(xmlRtn);
            }

            if (document.getElementById("TaskSCateList").innerHTML != "") document.getElementById("TaskSCateList").innerHTML = "";

            var SelListView = new ListView();
            SelListView.SetID("DivTaskSCateList");
            SelListView.SetMulSelectable(false);
            SelListView.DataSource(headerData);
            SelListView.DataBind("TaskSCateList");
        }
    }
    else if (SearchNum == "1") {
        FindTask(document.getElementById("Cabinetkeyword").value, "", "2", g_DeptCode);
    }
}

// 기록물철 즐겨 찾기
function MyCabinet_List() {
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getMyTaskCode.do",
		data : {
			deptID    : arr_userinfo[4],
			userID    : arr_userinfo[1]
		},
		success: function(xml){
			MyCabinet_ini(loadXMLString(xml));
		}        			
	});
}

function MyCabinet_ini(xml) {
    var rtnXml = xml;
    var TaskXml = loadXMLString(GetTaskXml(rtnXml));
    var headerData = createXmlDom();
    headerData = loadXMLString(Category_h.innerHTML.toUpperCase());

    if (CrossYN()) {
        var xmlRtn = GetElementsByTagName(TaskXml, "ROWS")[0];
        var Node = headerData.importNode(xmlRtn, true);
        headerData.documentElement.appendChild(Node);
    }
    else {
        var xmlRtn = GetElementsByTagName(TaskXml, "ROWS")[0];
        headerData.documentElement.appendChild(xmlRtn);
    }

    if (document.getElementById("MyTaskSCateList").innerHTML != "") document.getElementById("MyTaskSCateList").innerHTML = "";
    var SelListView = new ListView();
    SelListView.SetID("DivMyTaskSCateList");
    SelListView.SetSelectFlag(false);
    SelListView.SetMulSelectable(false);
    SelListView.SetRowOnClick("MyTaskSCateList_onclick");
    SelListView.DataSource(headerData);
    SelListView.DataBind("MyTaskSCateList");

}

function MyTaskSCateList_onclick()
{
    var TaskList = new ListView();
    TaskList.LoadFromID("DivTaskSCateList");
    TaskList.SetUnSelected("DivTaskSCateList");

    var xmlHttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;


    var SelListView = new ListView();
    SelListView.LoadFromID("DivMyTaskSCateList");

    var SelRow = SelListView.GetSelectedRows();

    createNodeInsert(xmlpara, objNode, "PARAMETERS");
    createNodeAndInsertText(xmlpara, objNode, "CABINETID", GetAttribute(SelRow[0], "DATA1"));
    xmlHttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/GetMyTaskCodeCheck.aspx", false);
    xmlHttp.send(xmlpara);

    var ToDay = new Date();    
    if(parseInt(getNodeText(GetElementsByTagName(xmlHttp.responseXML, "EXPIRATIONYEAR")[0])) < parseInt(ToDay.getFullYear()))
    {
        SetAttribute(SelRow[0], "DATA1", "")
        alert(strLang1006);
        return;
    }
    if (getNodeText(GetElementsByTagName(xmlHttp.responseXML, "PROCESSDEPTCODE")[0]) != arr_userinfo[4]) {
        SetAttribute(SelRow[0], "DATA1", "")
        alert(strLang1007);
        return;
    }
    if (getNodeText(GetElementsByTagName(xmlHttp.responseXML, "CONFIRMFLAG")[0]) != '0') {
        SetAttribute(SelRow[0], "DATA1", "")
        alert(strLang1008);
        return;
    }
}

// 즐겨찾기 추가 
function Set_MyTask(type) {
    var objList = new ListView();
    if (type == "INS") {
        objList.LoadFromID("DivTaskSCateList");       
    }
    else
        objList.LoadFromID("DivMyTaskSCateList");

    var selRows = objList.GetSelectedRows();
    if (selRows.length == 0) {
        OpenAlertUI(Cabinet4);
        return;
    }
    if (GetAttribute(selRows[0], "data1") == "") {
        OpenAlertUI(strLang1005);
        return;
    }

    if (type == "INS")
    {
        var myjList = new ListView();
        myjList.LoadFromID("DivMyTaskSCateList");
        var myjListRow = myjList.GetDataRows();
        for (var i = 0; i < myjList.GetRowCount() ; i++)
        {
            if (GetAttribute(selRows[0], "data1") == GetAttribute(myjListRow[i], "data1"))
            {
                OpenAlertUI(strLang1009);
                return;
            }
        }
    }
    var result = "";
   
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/setMyTaskCode.do",
		data : {
			cabinetID : GetAttribute(selRows[0], "data1"),
			taskCode  : GetAttribute(selRows[0], "data2"),
			type      : type
		},
		success: function(text){
			result = text;
		}        			
	});
        
    if (result == "OK") {
        if (type == "INS")
            OpenAlertUI(strLang1003);
        else
            OpenAlertUI(strLang1004);

        MyCabinet_List();
        return;
    }
    else {
        OpenAlertUI(strLang649);
        return;
    }
}

function GetTaskXml(TaskXml) {
    var strXml = "";
    strXml = strXml + "<ROWS>";
    for (var i = 0; i < GetElementsByTagName(TaskXml, "ROW").length; i++) {
        strXml = strXml + "<ROW>";      
        strXml = strXml + "<CELL>";
        strXml = strXml + "<VALUE>" + getNodeText(GetElementsByTagName(TaskXml, "TITLE").item(i)) + "</VALUE>"; // TBCABINETCLASS.TITLE
        strXml = strXml + "<DATA1>" + getNodeText(GetElementsByTagName(TaskXml, "CABINETID").item(i)) + "</DATA1>"; // TBCABINET.CABINETID
        strXml = strXml + "<DATA2>" + getNodeText(GetElementsByTagName(TaskXml, "TASKCODE").item(i)) + "</DATA2>"; // TBCABINETCLASS.TASKCODE
        strXml = strXml + "<DATA3>" + getNodeText(GetElementsByTagName(TaskXml, "CABINETCLASSNO").item(i)) + "</DATA3>"; // TBCABINET.CABINETCLASSNO
        strXml = strXml + "<DATA4>" + getNodeText(GetElementsByTagName(TaskXml, "OWNERID").item(i)) + "</DATA4>"; // TBCABINETCLASS.OWNERID
        strXml = strXml + "<DATA5>" + getNodeText(GetElementsByTagName(TaskXml, "TITLE").item(i)) + "</DATA5>"; // TBCABINETCLASS.TITLE
        strXml = strXml + "<DATA6>" + getNodeText(GetElementsByTagName(TaskXml, "TITLE2").item(i)) + "</DATA6>"; // TBCABINETCLASS.TITLE2
        //}
        //첫번째 Cell값에 단위분류 DATA값을 넣는다 
        strXml = strXml + "<DATA7>" + getNodeText(GetElementsByTagName(TaskXml, "TASKCODE").item(i)) + "</DATA7>"; // VTASKCLASS.TASKCODE
        strXml = strXml + "<DATA8>" + getNodeText(GetElementsByTagName(TaskXml, "KEEPINGPERIOD").item(i)) + "</DATA8>"; // VTASKCLASS.KEEPINGPERIOD
        strXml = strXml + "<DATA9>" + getNodeText(GetElementsByTagName(TaskXml, "TEMPFLAG").item(i)) + "</DATA9>"; // VTASKCLASS.TEMPFLAG
        strXml = strXml + "<DATA10>" + getNodeText(GetElementsByTagName(TaskXml, "DISPLAYRECFLAG").item(i)) + "</DATA10>"; // VTASKCLASS.DISPLAYRECFLAG
        strXml = strXml + "<DATA11>" + getNodeText(GetElementsByTagName(TaskXml, "SPECIALCATALOGFLAG").item(i)) + "</DATA11>"; // VTASKCLASS.SPECIALCATALOGFLAG
        strXml = strXml + "<DATA12>" + getNodeText(GetElementsByTagName(TaskXml, "SC1").item(i)) + "</DATA12>"; // VTASKCLASS.SC1
        strXml = strXml + "<DATA13>" + getNodeText(GetElementsByTagName(TaskXml, "SC2").item(i)) + "</DATA13>"; // VTASKCLASS.SC2
        strXml = strXml + "<DATA14>" + getNodeText(GetElementsByTagName(TaskXml, "SC3").item(i)) + "</DATA14>"; // VTASKCLASS.SC3
        strXml = strXml + "<DATA15>" + getNodeText(GetElementsByTagName(TaskXml, "KEEPINGMETHOD").item(i)) + "</DATA15>"; // VTASKCLASS.KEEPINGMETHOD
        strXml = strXml + "<DATA16>" + getNodeText(GetElementsByTagName(TaskXml, "KEEPINGPLACE").item(i)) + "</DATA16>"; // VTASKCLASS.KEEPINGPLACE
        strXml = strXml + "<DATA17>" + getNodeText(GetElementsByTagName(TaskXml, "TASKNAME").item(i)) + "</DATA17>"; // VTASKCLASS.TASKNAME
        strXml = strXml + "<DATA18>" + getNodeText(GetElementsByTagName(TaskXml, "TASKNAME2").item(i)) + "</DATA18>"; // VTASKCLASS.TASKNAME2
        strXml = strXml + "</CELL>";
        strXml = strXml + "<CELL>";
        strXml = strXml + "<VALUE>" + getNodeText(GetElementsByTagName(TaskXml, "SCNAME").item(i)) + "(" + getNodeText(GetElementsByTagName(TaskXml, "SUBCATEGORYCODE").item(i)) + ")" + "</VALUE>"; //소분류 & 코드 SCNAME(
        strXml = strXml + "<DATA1>" + getNodeText(GetElementsByTagName(TaskXml, "SCNAME").item(i)) + "</DATA1>";
        strXml = strXml + "</CELL>";
        //단위업무
        strXml = strXml + "<CELL><VALUE>" + getNodeText(GetElementsByTagName(TaskXml, "TASKNAME").item(i)) + "(" + getNodeText(GetElementsByTagName(TaskXml, "TASKCODE").item(i)) + ")" + "</VALUE>"; //VTASKCLASS.TASKNAME(VTASKCLASS.TASKCODE)
        strXml = strXml + "</CELL>";
        strXml = strXml + "<CELL><VALUE>" + getNodeText(GetElementsByTagName(TaskXml, "RECTYPECODE").item(i)) + "</VALUE></CELL>"; //형태 TBCABINETCLASS.RECTYPECODE
        strXml = strXml + "<CELL><VALUE>" + getNodeText(GetElementsByTagName(TaskXml, "REGSERIALNO").item(i)) + "</VALUE></CELL>"; //연변 TBCABINETCLASS.REGSERIALNO
        strXml = strXml + "<CELL><VALUE>" + getNodeText(GetElementsByTagName(TaskXml, "VOLUMENO").item(i)) + "</VALUE></CELL>"; //권호수 TBCABINET.VOLUMENO
        strXml = strXml + "</ROW>";
    }
    strXml = strXml + "</ROWS>";
    return strXml;

}

