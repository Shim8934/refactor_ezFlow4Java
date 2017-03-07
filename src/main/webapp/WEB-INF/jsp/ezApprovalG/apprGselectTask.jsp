<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1040'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CabCategoryInfo_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var OrderCell = "";
		    var g_InitFlag = "${initFlag}";
		    var g_MultiSelect="${multiSelect}";
		    var xmlhttp = createXMLHttpRequest();
		    var rtnVal = new Array();
		    var CompanyID = "${userInfo.companyID}";
		    var UserLang = "${userInfo.lang}";
		    var RetValue;
		    var ReturnFunction;
		    var NonActiveX = "YES";
		    window.onload = window_onload;
		    function window_onload() {
		        try {
		            RetValue = parent.selecttask_cross_dialogArguments[0];
		            ReturnFunction = parent.selecttask_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.selecttask_cross_dialogArguments[0];
		                ReturnFunction = opener.selecttask_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        g_DeptCode = RetValue[0];
		        g_DeptName = RetValue[1];
		        rtnVal[0] = "FALSE";
		        InitCategorySelection();
		        selTaskCategory_onchange();
		        InitSelTaskList();
		    }
		    function TaskList_rowclick() {
		    }
		    function TaskList_rowdbclick() {
		        AddRowToLV();
		    }
		    function SelTaskList_rowdbclick() {
		        DelListRow("DivSelTaskList");
		    }
		
		    function btnViewTaskInfo_onclick() {
		        AddRowToLV();
		    }
		
		    function Add_onclick() {
		        AddRowToLV();
		    }
		    function Del_onclick() {
		        DelListRow("DivSelTaskList");
		    }
		    function AddRowToLV() {
		        var IsValueInList = false;
		
		        var ListTask = new ListView();
		        ListTask.LoadFromID("DivTaskList");
		        var selRows = ListTask.GetSelectedRows();
		
		        var selRow;
		        var count;
		        var length = selRows.length;
		
		        var SelectedRows;
		
		        if (g_MultiSelect == "0")
		        {
		            var SelTask = new ListView();
		            SelTask.LoadFromID("DivSelTaskList");
		            SelectedRows = SelTask.GetDataRows();
		
		            if (SelectedRows.length > 0) {
		                var selIdx = SelectedRows[0].getAttribute("id");
		                SelTask.DeleteRow(selIdx);
		            }
		
		            selRow = ListTask.GetSelectedRows()[0];
		            AddRow(selRow);
		        }
		        else
		        {
		            for (count = 0; count < length; count++) {
		                var Task = new ListView();
		                Task.LoadFromID("DivTaskList");
		
		                selRow = Task.GetSelectedRows()[count];
		
		                var SelTask = new ListView();
		                SelTask.LoadFromID("DivSelTaskList");
		
		                var totalRows = SelTask.GetDataRows();
		                if (totalRows.length > 0) {
		                    var i;
		                    for (i = 0; i < totalRows.length; i++) {
		                        if (totalRows[i].getAttribute("DATA1") == selRow.getAttribute("DATA1")) {
		                            IsValueInList = true;
		                            break;
		                        }
		                    }
		                }
		
		                if (!IsValueInList) {
		                    AddRow(selRow);
		                }
		                IsValueInList = false;
		            }
		        }
		    }
		    function AddRow(selRow) {
		        var SelTaskListView = new ListView();
		        SelTaskListView.LoadFromID("DivSelTaskList");
		
		        var row = "<ROW>";
		        row += "<CELL>";
		        row += "<VALUE><![CDATA[";
		        row += selRow.cells[0].innerText;
		        row += "]]></VALUE>";
		        row += "<DATA1><![CDATA[";
		        row += selRow.getAttribute("DATA1");
		        row += "]]></DATA1>";
		        row += "<DATA2><![CDATA[";
		        row += selRow.getAttribute("DATA2");
		        row += "]]></DATA2>";
		        row += "<DATA3><![CDATA[";
		        row += selRow.getAttribute("DATA3");
		        row += "]]></DATA3>";
		        row += "<DATA4><![CDATA[";
		        row += selRow.getAttribute("DATA4");
		        row += "]]></DATA4>";
		        row += "<DATA5><![CDATA[";
		        row += selRow.getAttribute("DATA5");
		        row += "]]></DATA5>";
		        row += "<DATA6><![CDATA[";
		        row += selRow.getAttribute("DATA6");
		        row += "]]></DATA6>";
		        row += "<DATA7><![CDATA[";
		        row += selRow.getAttribute("DATA7");
		        row += "]]></DATA7>";
		        row += "<DATA8><![CDATA[";
		        row += selRow.getAttribute("DATA8");
		        row += "]]></DATA8>";
		        row += "<DATA9><![CDATA[";
		        row += selRow.getAttribute("DATA9");
		        row += "]]></DATA9>";
		        row += "<DATA10><![CDATA[";
		        row += selRow.getAttribute("DATA10");
		        row += "]]></DATA10>";
		        row += "</CELL>";
		        row += "<CELL>";
		        row += "<VALUE><![CDATA[";
		        row += selRow.cells[1].innerText;
		        row += "]]></VALUE>";
		        row += "</CELL>";
		        row += "</ROW>";
		
		        var rowXml = loadXMLString(row);
		        var tr = SelTaskListView.AddRow(0);
		        SelTaskListView.AddDataRow(tr, rowXml);
		    }
		    function InitSelTaskList() {
		        var oList, ListViewData, Headers, Header, node, Rows;
		
		        oList = createXmlDom();
		        ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
		        Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t379'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "65");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t572'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
		
		        createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
		
		        SelTaskList.dataSource = oList;
		
		        var SelListView = new ListView();
		        SelListView.SetID("DivSelTaskList");
		        SelListView.SetMulSelectable(false);
		        SelListView.SetRowOnDblClick("SelTaskList_rowdbclick");
		        SelListView.DataSource(oList);
		        SelListView.DataBind("SelTaskList");
		    }
		    function GetSelTaskInfoXml() {
		        var TaskListview = new ListView();
		        TaskListview.LoadFromID("DivSelTaskList");
		
		        var totalRows = TaskListview.GetDataRows();
		        var i;
		
		        var rtnXml = createXmlDom();
		        var Root, objItem, objData;
		        Root = createNodeInsert(rtnXml, Root, "TASKINFO");
		
		        for (i = 0; i < totalRows.length; i++) {
		            objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "TASK");
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "NAME", totalRows[i].cells[1].innerText);
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CODE", totalRows[i].getAttribute("DATA1"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "KEEPPERIOD", totalRows[i].getAttribute("DATA2"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "TEMPFLAG", totalRows[i].getAttribute("DATA3"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "DISPLAYFLAG", totalRows[i].getAttribute("DATA4"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "SCFLAG", totalRows[i].getAttribute("DATA5"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "LIST1", totalRows[i].getAttribute("DATA6"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "LIST2", totalRows[i].getAttribute("DATA7"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "LIST3", totalRows[i].getAttribute("DATA8"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "KEEPMETHOD", totalRows[i].getAttribute("DATA9"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "KEEPPLACE", totalRows[i].getAttribute("DATA10"));
		        }
		        return getXmlString(rtnXml);
		    }
		    function DelListRow(objListView) {
		        var selRow;
		        var count1, len;
		        var objList = new ListView();
		        objList.LoadFromID(objListView);
		        var selRows = objList.GetSelectedRows();
		
		        if (selRows) {
		            len = selRows.length;
		
		            if (len > 0) {
		                for (count1 = 0; count1 < len; count1++) {
		                    var selIdx = objList.GetSelectedRows()[len - count1 - 1].getAttribute("id");
		                    objList.DeleteRow(selIdx);
		
		                }
		            }
		        }
		    }
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null)
		            ReturnFunction(rtnVal);
		        else
		            window.returnValue = rtnVal;
		        window.close();
		    }
		    function cmdConfirm_onclick() {
		        var List = new ListView();
		        List.LoadFromID("DivSelTaskList");
		        var totalRows = List.GetDataRows();
		
		        if (totalRows.length > 0) {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = GetSelTaskInfoXml();
		            if (ReturnFunction != null)
		                ReturnFunction(rtnVal);
		            else
		                window.returnValue = rtnVal;
		            window.close();
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1131'/>");
		
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1040'/></h1>
		<table>
		  <tr>
		    <td style="vertical-align:top"><h2><spring:message code='ezApprovalG.t591'/></h2>
		      <table class="content" style="WIDTH:202px;">
		        <tr>
		          <th><spring:message code='ezApprovalG.t592'/></th>
		          <td><Select id="selTaskCategory" style="width:100%" onChange="return selTaskCategory_onchange()">
		            </Select></td>
		        </tr>
		        <tr>
		          <th><spring:message code='ezApprovalG.t593'/></th>
		          <td><Select id="selTaskMCategory" style="width:100%" onChange="return selTaskMCategory_onchange()">
		            </Select>
		          </td>
		        </tr>
		      </table>
		      <div class="listview"  style="WIDTH:200px;HEIGHT:231px; OVERFLOW-Y:AUTO;" id="divTaskSCateList2">
		          <div id="TaskSCateList" style="margin: 0PX"></div>
		        </div>        
		     </td>
		    <td style="padding-left:5px; vertical-align:top;" ><h2><spring:message code='ezApprovalG.t1040'/></h2>
		      <table>
		        <tr>
		          <th style="text-align:left"><a class="imgbtn"><span onClick="return btnFindTask_onclick()"><spring:message code='ezApprovalG.t111'/></span></a></th>
		        </tr>
		        <tr>
		          <td >
		          <div class="listview"  style="WIDTH:270px;HEIGHT:260px; OVERFLOW-Y:AUTO;" id="divTaskList2">
		          <div id="TaskList" style="margin: 1px 1px 1px 1px;"></div>
		        </div> 
		          </td>
		        </tr>
		      </table></td>
		
		    <td style="width:25px; text-align:center">
		        <img id="RecvAdd" name="Image93" border="0" src="/images/arr_right.gif" width="16" height="16" onClick="return Add_onclick()" style="cursor:pointer" >
		        <img id="RecvDel" name="Image103" border="0" src="/images/arr_left.gif" width="16" height="16" onClick="return Del_onclick()" style="cursor:pointer" >
		    </td>
		    <td style="vertical-align:top"><h2><spring:message code='ezApprovalG.t1132'/></h2>
		    <div class="listview"  style="WIDTH:210px;HEIGHT:288px; OVERFLOW-Y:AUTO;" id="divSelTaskList2">
		          <div id="SelTaskList" style="margin: 1px 1px 1px 1px;"></div>
		        </div> 
		     </td>
		  </tr>
		</table>
		
		<div class="btnposition">
		  <a class="imgbtn" name="btnOK"><span onClick="return cmdConfirm_onclick()" style="width:40px;" ><spring:message code='ezApprovalG.t20'/></span></a>
		  <a class="imgbtn" name="btnCancel"><span onClick="return cmdCancel_onclick()" style="width:40px;" ><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>