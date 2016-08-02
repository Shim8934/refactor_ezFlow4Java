<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t560'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/CabinetInfo_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/OpenSelWin_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/OrganTree_Cross.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var OrderCell = "";
	        var xmlhttp = createXMLHttpRequest();
	        var g_STaskCode = "";
	        var g_DDeptCode = "";
	        var g_DDeptName = "";
	        var g_DTaskCode = "";
	        var g_DTaskName = "";
	        var g_SDeptCode = "${userInfo.deptID}";
	    	var g_SDeptName = "${userInfo.deptName1}";
	        var CompanyID = "${userInfo.companyID}";
	        var UserLang = "${userInfo.lang}";
	        document.onselectstart = function () { return false; };
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            document.getElementById("tdSDeptName").innerText = g_SDeptName;
	            InitSelCabinetList();
	        };
	
	        function bt_OK_onclick() {
	            var SelCabinetList = new ListView();
	            SelCabinetList.LoadFromID("DivSelCabinetList");
	            var length = SelCabinetList.GetRowCount();
	            if (length > 0) {
	                if (g_DDeptCode == "") {
	                    alert("<spring:message code='ezApprovalG.t561'/>");
	            }
	            else if (g_DTaskCode == "") {
	                alert("<spring:message code='ezApprovalG.t562'/>");
	            }
	            else {
	                if (TransferCabinet()) {
	                    alert("<spring:message code='ezApprovalG.t563'/>");
	                    GetCabinetSimpleList(g_SDeptCode, "", g_STaskCode, "", "2");
	                    DelAllRowOfLV(SelCabinetList);
	                }
	            }
	    }
	    else {
	        alert("<spring:message code='ezApprovalG.t566'/>");
	        }
	    }
	
	    function GetDeptRecAdminInfo() {
	        var pSearchList = "extensionAttribute1::m=1;;EXACT_Department::" + g_DDeptCode;
	        var pCellList = "CN;displayname;";
	        var pPropList = "displayname";
	        var pClass = "user";
	        var arrUserInfo = new Array();
	        arrUserInfo[0] = "";
	        arrUserInfo[1] = "";
	        arrUserInfo[2] = "";
	        var rtnXml = OrganSearch(pSearchList, pCellList, pPropList, pClass);
	        var nlRow = SelectNodes(rtnXml, "LISTVIEWDATA/ROWS/ROW/CELL");
	        if (nlRow.length > 0) {
	            arrUserInfo[0] = SelectSingleNodeValue(nlRow[0], "VALUE");
	            arrUserInfo[1] = SelectSingleNodeValue(nlRow[0], "DATA4");
	            arrUserInfo[2] = SelectSingleNodeValue(nlRow[0], "DATA5");
	        }
	        return arrUserInfo;
	    }
	
	    function TransferCabinet() {
	        var arrDeptAdmInfo = GetDeptRecAdminInfo();
	        var XmlHttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETERS");
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTCODE", g_DDeptCode);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTNAME", g_DDeptName);
	        createNodeAndInsertText(xmlpara, objNode, "DTASKCODE", g_DTaskCode);
	        createNodeAndInsertText(xmlpara, objNode, "DTASKNAME", g_DTaskName);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTMID", arrDeptAdmInfo[0]);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTMNAME", arrDeptAdmInfo[1]);
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTNAME2", g_DDeptName);
	        createNodeAndInsertText(xmlpara, objNode, "DTASKNAME2", g_DTaskName);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTMNAME2", arrDeptAdmInfo[2]);
	        var objCabXml = GetSelCabInfo();
	        var xmlDoc;
	        if (CrossYN()) {
	            var nodeToImport = xmlpara.importNode(objCabXml.documentElement, true);
	            xmlpara.documentElement.appendChild(nodeToImport);
	        }
	        else {
	            xmlpara.documentElement.appendChild(objCabXml.documentElement);
	        }
	        XmlHttp.open("POST", "/ezApprovalG/transferCab.do", false);
	        XmlHttp.send(xmlpara);
	        var rtnVal = getNodeText(XmlHttp.responseXML.documentElement);
	        if (rtnVal == "NODEPTADMIN") {
	            alert("<spring:message code='ezApprovalG.t567'/>");
	            return false;
	        }
	        else if (rtnVal == "FALSE") {
	            alert("<spring:message code='ezApprovalG.t568'/>");
	                return false;
	            }
	            else {
	                return true;
	            }
	    }
	
	    function GetSelCabInfo() {
	        var oXml = createXmlDom();
	        var objNode;
	        createNodeInsert(oXml, objNode, "CABINETLIST");
	        var CabList = new ListView();
	        CabList.LoadFromID("DivSelCabinetList");
	        var len = CabList.GetRowCount();
	        var Rows = CabList.GetDataRows();
	        var i;
	        if (len > 0) {
	            for (i = 0; i < len; i++) {
	                createNodeAndInsertText(oXml, objNode, "ID", Rows[i].getAttribute("DATA1"));
	            }
	        }
	        return oXml;
	    }
	
	    function bt_Cancle_onclick() {
	        window.close();
	    }
	
	    function btnChangeDDept_onclick() {
	        SelectDept("OPEN", btnChangeDDept_onclick_Complete);
	    }
	
	    function btnChangeDDept_onclick_Complete(rtn) {
	        if (rtn[0] == "TRUE") {
	            if (g_SDeptCode == rtn[1]) {
	                alert("<spring:message code='ezApprovalG.t569'/>");
	                return;
	            }
	            if (g_DDeptCode != rtn[1]) {
	                g_DTaskCode = "";
	                g_DTaskName = "";
	                document.getElementById("tdDTaskCode").innerText = " ";
	                document.getElementById("tdDTaskName").innerText = " ";
	            }
	            g_DDeptCode = rtn[1];
	            g_DDeptName = rtn[2];
	            document.getElementById("tdDDeptName").innerText = g_DDeptName;
	        }
	    }
	
	    function btnChangeSTask_onclick() {
	       SelectTask(g_SDeptCode, g_SDeptName, "0", "0", "OPEN", btnChangeSTask_onclick_Complete);
	    }
	
	    function btnChangeSTask_onclick_Complete(rtn) {
	        if (rtn[0] == "TRUE")
	            GetSelSTaskInfo(rtn[1]);
	    }
	
	    function btnChangeDTask_onclick() {
	        if (g_SDeptCode == "") {
	            alert("<spring:message code='ezApprovalG.t561'/>");
	        }
	        else {
	            SelectTask(g_DDeptCode, g_DDeptName, "1", "0", "OPEN", btnChangeDTask_onclick_onclick_Complete);
	        }
	    }
	
	    function btnChangeDTask_onclick_onclick_Complete(rtn) {
	        if (rtn[0] == "TRUE")
	            GetSelDTaskInfo(rtn[1]);
	    }
	
	    function GetSelSTaskInfo(szTaskXml) {
	        var oXml = loadXMLString(szTaskXml);
	        g_STaskCode = getNodeText(SelectNodes(oXml, "/TASKINFO/TASK/CODE")[0]);
	        document.getElementById("tdSTaskCode").innerText = g_STaskCode;
	        document.getElementById("tdSTaskName").innerText = getNodeText(SelectNodes(oXml, "/TASKINFO/TASK/NAME")[0]);
	        GetCabinetSimpleList(g_SDeptCode, "", g_STaskCode, "", "2");
	    }
	
	    function GetSelDTaskInfo(szTaskXml) {
	        var oXml = loadXMLString(szTaskXml);
	        g_DTaskCode = getNodeText(SelectNodes(oXml, "/TASKINFO/TASK/CODE")[0]);;
	        g_DTaskName = getNodeText(SelectNodes(oXml, "/TASKINFO/TASK/NAME")[0]);;
	        document.getElementById("tdDTaskCode").innerText = g_DTaskCode;
	        document.getElementById("tdDTaskName").innerText = g_DTaskName;
	    }
	
	    function SelCabinetList_rowdblclick() {
	        DelListRow("DivSelCabinetList");
	    }
	
	    function CabinetList_rowdblclick() {
	        AddRowToCabList();
	    }
	
	    function AddCabList_onclick() {
	        AddRowToCabList();
	    }
	
	    function DelCabList_onclick() {
	        DelListRow("DivSelCabinetList");
	    }
	
	    function btnAddAll_onclick() {
	        AddAllRowToCabList();
	    }
	
	    function AddRowToCabList() {
	        var IsValueInList = false;
	        var selRow;
	        var count;
	        var CabList = new ListView();
	        CabList.LoadFromID("DivCabinetList");
	        var selRows = CabList.GetSelectedRows();
	        var length = selRows.length;;
	        if (length > 0) {
	            for (count = 0; count < length; count++) {
	                selRow = selRows[count];
	
	                var SelListView = new ListView();
	                SelListView.LoadFromID("DivSelCabinetList");
	                var totalRows = SelListView.GetDataRows();
	
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
	
	    function AddAllRowToCabList() {
	        var IsValueInList = false;
	        var count;
	        var CabListView = new ListView();
	        CabListView.LoadFromID("DivCabinetList");
	        var selRows = CabListView.GetDataRows();
	        var length = selRows.length;
	        if (length > 0) {
	            for (count = 0; count < length; count++) {
	                selRow = selRows[count];
	                var SelListView = new ListView();
	                SelListView.LoadFromID("DivSelCabinetList");
	                var totalRows = SelListView.GetDataRows();
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
	        var Cnt002 = GetUncompleteDocCount(selRow.getAttribute("DATA1"));
	        if (Cnt002 > 0) {
	            alert(selRow.cells[0].innerText + "<spring:message code='ezApprovalG.t570'/>" + Cnt002 + "<spring:message code='ezApprovalG.t571'/>");
	            return;
	        }
	        var SelListView = new ListView();
	        SelListView.LoadFromID("DivSelCabinetList");
	        var row = "<ROW>";
	        row += "<CELL>";
	        row += "<VALUE>";
	        row += selRow.cells[0].innerText;
	        row += "</VALUE>";
	        row += "<DATA1>";
	        row += selRow.getAttribute("DATA1");
	        row += "</DATA1>";
	        row += "<DATA2>";
	        row += selRow.getAttribute("DATA2");
	        row += "</DATA2>";
	        row += "<DATA3>";
	        row += selRow.cells[1].innerText;
	        row += "</DATA3>";
	        row += "</CELL>";
	        row += "<CELL>";
	        row += "<VALUE>";
	        row += selRow.cells[2].innerText;
	        row += "</VALUE>";
	        row += "</CELL>";
	        row += "<CELL>";
	        row += "<VALUE>";
	        row += selRow.cells[3].innerText;
	        row += "</VALUE>";
	        row += "</CELL>";
	        row += "</ROW>";
	        var rowXml = loadXMLString(row);
	        var tr = SelListView.AddRow(0);
	        SelListView.AddDataRow(tr, rowXml);
	    }
	
	    function GetUncompleteDocCount(pCabinetID) {
	    	var result = "";
	    	
	        $.ajax({
	    		type : "POST",
	    		dataType : "xml",
	    		async : false,
	    		url : "/ezApprovalG/getUncompleteDocCount.do",
	    		data : {
	    				deptCode : g_DDeptCode,
	    				companyID : CompanyID,
	    				cabinetID : pCabinetID
	    				},
	    		success: function(xml){
	    			result = xml;
	    		}        			
	    	});

	        return getNodeText(result.documentElement);
	    }
	
	    function InitSelCabinetList() {
	        var oList;
	        oList = createXmlDom();
	        var ListViewData, Headers, Header, Rows, node;
	        ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
	        Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
	        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
	        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t379'/>");
	        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
	        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
	        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t572'/>");
	        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "50");
	        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
	        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t573'/>");
	        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");
	        createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
	        var SelListView = new ListView();
	        SelListView.SetID("DivSelCabinetList");
	        SelListView.SetMulSelectable(false);
	        SelListView.SetRowOnDblClick("SelCabinetList_rowdblclick");
	        SelListView.DataSource(oList);
	        SelListView.DataBind("SelCabinetList");
	    }
	
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezApprovalG.t560'/></h1>
	    <div id="mainmenu">
	        <ul>
	            <li><span onclick="return bt_OK_onclick()"><spring:message code='ezApprovalG.t574'/></span></li>
	        </ul>
	    </div>
	    <table>
	        <tr>
	            <td>
	                <table class="content" style="width: 100%">
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t575'/></th>
	                        <td id="tdSDeptName">&nbsp;</td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t576'/></th>
	                        <td>
	                            <table style="border: 0px; width: 100%">
	                                <tr>
	                                    <td id="tdSTaskCode">&nbsp;</td>
	                                    <td style="width: 45px;">
	                                        <a class="imgbtn"><span onclick="return btnChangeSTask_onclick()" style="width: 40px; text-align: center;"><spring:message code='ezApprovalG.t105'/></span></a>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t577'/></th>
	                        <td id="tdSTaskName">&nbsp;</td>
	                    </tr>
	                </table>
	                <br>
	                <h2><spring:message code='ezApprovalG.t578'/></h2>
	                <div style="WIDTH: 450px; HEIGHT: 300px; OVERFLOW-Y: AUTO;" class="listview">
	                    <div id="CabinetList"></div>
	                </div>
	            </td>
	            <td style="text-align: center; width: 25px">
	                <img src="/images/arr_right.gif" name="Image191" width="16" height="16" onclick="return AddCabList_onclick()" style="cursor: pointer">
	                <img src="/images/arr_left.gif" name="Image201" width="16" height="16" onclick="return DelCabList_onclick()" style="padding-top: 5px; padding-left: 0px; cursor: pointer;">
	                <br>
	                <br>
	                <br>
	                <img name="Image1911" src="/images/arr01a.gif" width="16" height="16" onclick="return btnAddAll_onclick()" style="cursor: pointer">
	            </td>
	            <td style="vertical-align: top">
	                <table class="content" style="width: 100%">
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t579'/></th>
	                        <td>
	                            <table style="width: 100%; border: 0px">
	                                <tr>
	                                    <td id="tdDDeptName">&nbsp;</td>
	                                    <td style="width: 45px;">
	                                        <a class="imgbtn"><span onclick="return btnChangeDDept_onclick()" style="width: 40px; text-align: center;"><spring:message code='ezApprovalG.t105'/></span></a>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t576'/></th>
	                        <td>
	                            <table style="width: 100%; border: 0px;">
	                                <tr>
	                                    <td id="tdDTaskCode">&nbsp;</td>
	                                    <td style="width: 45px;">
	                                        <a class="imgbtn"><span onclick="return btnChangeDTask_onclick()" style="width: 40px; text-align: center;"><spring:message code='ezApprovalG.t105'/></span></a>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t577'/></th>
	                        <td id="tdDTaskName">&nbsp;</td>
	                    </tr>
	                </table>
	                <br>
	                <h2><spring:message code='ezApprovalG.t580'/></h2>
	                <div style="WIDTH: 375px; HEIGHT: 300px; OVERFLOW-Y: AUTO;" class="listview">
	                    <div id="SelCabinetList"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>