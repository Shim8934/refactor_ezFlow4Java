<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t711'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/CabCategoryInfo_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/CabinetInfo_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/CabRoleInfo_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var OrderCell = "";
	        var g_InitFlag = "${initFlag}";
	        var bDisplayFlag = "0";
	        var bSpecialFlag = "0";
	        var arrTask = new Array();
	        var rtnVal = new Array();
	        var g_SelCabID = "";
	        var AdminYN = "FALSE";
	        var szRoleInfo = "${userInfo.rollInfo}";
	        var g_bRecAdmin = false;
	        var g_bDeptCharger = false;
	        var xmlhttp = createXMLHttpRequest();
	        var pUserID = "${userInfo.id}";
	        var CompanyID = "${userInfo.companyID}";
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName}";
	        arr_userinfo[3] = "${userInfo.title}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName}";
	        arr_userinfo[6] = "${userInfo.jikChek}";
	        arr_userinfo[8] = "${userInfo.email}";
	        arr_userinfo[9] = CompanyID;
	        arr_userinfo[11] = "${userInfo.displayName1}";
	        arr_userinfo[12] = "${userInfo.displayName2}";
	        arr_userinfo[13] = "${userInfo.title1}";
	        arr_userinfo[14] = "${userInfo.title2}";
	        arr_userinfo[15] = "${userInfo.deptName1}";
	        arr_userinfo[16] = "${userInfo.deptName2}";
	        var UserLang = "${userInfo.lang}";
	        var RetValue;
	        var ReturnFunction;
	        var NonActiveX = "YES";
	        window.onload = function () {
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                KeEventControl(document.getElementById("Cabinetkeyword"));
	            }
	            try {
	                RetValue = parent.selectcabinet_cross_dialogArguments[0];
	                ReturnFunction = parent.selectcabinet_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.selectcabinet_cross_dialogArguments[0];
	                    ReturnFunction = opener.selectcabinet_cross_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            g_SelCabID = RetValue[0];
	            rtnVal[0] = "FALSE";
	            initUserRoleinfo();
	            if (g_InitFlag == "1") {
	                if (g_bRecAdmin || AdminYN == "TRUE" || g_bDeptCharger) {
	                    document.getElementById("trCreateCab").style.display = "";
	                    document.getElementById("trCreateCabDummy").style.display = "none";
	                }
	                else {
	                    document.getElementById("trCreateCab").style.display = "none";
	                    document.getElementById("trCreateCabDummy").style.display = "";
	                }
	            }
	            g_DeptCode = arr_userinfo[4];
	            g_DeptName = arr_userinfo[5];
	            InitSelCabinetList();
	            if (typeof (g_SelCabID) != "undefined") {
	                if (g_SelCabID != "") {
	                    InitCabClassInfo(GetCabinetClassInfo(g_SelCabID));
	                }
	            }
	            InitCategorySelection();
	            selTaskCategory_onchange();
	        };
	        function KeEventControl(obj) {
	            useragt = navigator.userAgent.toUpperCase();
	            if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
	            {
	                return;
	            }
	            obj.onkeydown = function () {
	                if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
	                    return false;
	                if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
	                        parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
	                        parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
	                        parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
	                        parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
	                    return false;
	            };
	        }
	        function InitCabClassInfo(objCabInfoXml) {
	            g_arrInitValue[0] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "CATECODE"));
	            g_arrInitValue[1] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "MCATECODE"));
	            g_arrInitValue[2] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "SCATECODE"));
	            g_arrInitValue[3] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "TASKCODE"));
	        }
	        function TaskList_rowclick() {
	            var listview = new ListView();
	            listview.LoadFromID("DivTaskList");
	            var selnode = listview.GetSelectedRows();
	            if (selnode.length != 0) {
	                arrTask[0] = selnode[0].getAttribute("DATA1");
	                arrTask[1] = selnode[0].cells[1].innerText;
	                arrTask[3] = selnode[0].getAttribute("DATA2");
	                bDisplayFlag = selnode[0].getAttribute("DATA4");
	                bSpecialFlag = selnode[0].getAttribute("DATA5");
	                GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], g_SelCabID, g_InitFlag);
	                if (typeof (g_SelCabID) != "undefined") {
	                    if (g_SelCabID != "") {
	                        AddRowToCabList();
	                    }
	                }
	                g_SelCabID = "";
	            }
	            else {
	                GetCabinetSimpleList("", "", "__Dump__Year__", "", g_InitFlag);
	            }
	        }
	        function SelCabinetList_rowdblclick() {
	            DelListRow(SelCabinetList);
	        }
	        function SelCabinetList_rowclick() {
	        }
	        function CabinetList_rowdblclick() {
	            AddRowToCabList();
	        }
	        function AddCabList_onclick() {
	            AddRowToCabList();
	        }
	        function DelCabList_onclick() {
	            DelListRow(SelCabinetList);
	        }
	        function AddRowToCabList() {
	            var IsValueInList = false;
	            var selRow;
	            var count;
	            var listview = new ListView();
	            listview.LoadFromID("DivCabinetList");
	            var length = listview.GetSelectedRows().length;
	            var SelCabRows;
	            if (length > 0) {
	                if (g_InitFlag == "1") {
	                    var SelCab = new ListView();
	                    SelCab.LoadFromID("DivDivCabinetList");
	                    SelCabRows = SelCab.GetDataRows();
	
	                    if (SelCabRows.length > 0) {
	                        var selIdx = SelCabRows[0].getAttribute("id");
	                        SelCab.DeleteRow(selIdx);
	                    }
	
	                    selRow = listview.GetSelectedRows()[0];
	                    AddRow(selRow);
	                }
	                else {
	                    for (count = 0; count < length; count++) {
	                        selRow = listview.GetSelectedRows()[count];
	                        var SelCab = new ListView();
	                        SelCab.LoadFromID("DivDivCabinetList");
	                        var totalRows = SelCab.GetDataRows();
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
	        }
	        function AddRow(selRow) {
	            var selCabList = new ListView();
	            selCabList.LoadFromID("DivDivCabinetList");
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
	            row += selRow.getAttribute("DATA3");
	            row += "</DATA3>";
	            row += "<DATA4>";
	            row += selRow.getAttribute("DATA4");
	            row += "</DATA4>";
	            row += "<DATA5>";
	            row += selRow.getAttribute("DATA5");
	            row += "</DATA5>";
	            row += "<DATA6>";
	            row += selRow.getAttribute("DATA6");
	            row += "</DATA6>";
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
	            var DeptAddIndex = selCabList.GetRowCount();
	            var tr = selCabList.GetSelectedRows();
	            var InitTr = selCabList.GetDataRows();
	            var MaxID = 0;
	            for (var j = 0  ; j < InitTr.length  ; j++) {
	                var curnum = Number(selCabList.GetSelectedRowID(j).substring(selCabList.GetSelectedRowID(j).lastIndexOf('_') + 1), selCabList.GetSelectedRowID(j).length);
	                if (MaxID < curnum)
	                    MaxID = curnum;
	            }
	            var rowXml = loadXMLString(row);
	            if (tr.length == 0) {
	                if (InitTr.length == 0) {
	                    var objTr = selCabList.AddRow(0);
	                    SetAttribute(objTr, "id", "DivDivCabinetList" + "_TR_" + eval(MaxID + 1));
	                    selCabList.AddDataRow(objTr, rowXml);
	                }
	                else {
	                    var objTr = selCabList.AddRow(DeptAddIndex - 1);
	                    SetAttribute(objTr, "id", "DivDivCabinetList" + "_TR_" + eval(MaxID + 1));
	                    selCabList.AddDataRow(objTr, rowXml);
	                }
	            }
	            else {
	                var objTr = selCabList.AddRow(DeptAddIndex - 1);
	                SetAttribute(objTr, "id", "DivDivCabinetList" + "_TR_" + eval(MaxID + 1));
	                selCabList.AddDataRow(objTr, rowXml);
	            }
	        }
	        function DelListRow(objListView) {
	            var selRow;
	            var count1, len;
	            var selRows;
	            var objList = new ListView();
	            objList.LoadFromID("DivDivCabinetList");
	            var selRows = objList.GetSelectedRows();
	            if (selRows.length > 0) {
	                len = selRows.length;
	                if (selRows) {
	                    if (typeof (selRows) != "undefined") {
	                        if (len > 0) {
	                            for (count1 = 0; count1 < len; count1++) {
	                                var selIdx = objList.GetSelectedRows()[len - count1 - 1].getAttribute("id");
	                                objList.DeleteRow(selIdx);
	                            }
	                        }
	                    }
	                }
	            }
	        }
	        function InitSelCabinetList() {
	            var oList, ListViewData, Headers, Header, HName, HWidth, Rows, node;
	            oList = createXmlDom();
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
	        Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
	        var SelListView = new ListView();
	        SelListView.SetID("DivDivCabinetList");
	        SelListView.SetMulSelectable(false);
	        SelListView.SetRowOnDblClick("SelCabinetList_rowdblclick");
	        SelListView.SetRowOnClick("SelCabinetList_rowclick");
	        SelListView.DataSource(oList);
	        SelListView.DataBind("SelCabinetList");
	    }
	    function cmdCancel_onclick() {
	        if (ReturnFunction != null) {
	            ReturnFunction(rtnVal);
	            window.close();
	        }
	        else {
	            rtnVal[0] = "FALSE";
	            window.close();
	        }
	    }
	    function cmdConfirm_onclick() {
	        var List = new ListView();
	        List.LoadFromID("DivDivCabinetList");
	        var totalRows = List.GetDataRows();
	        if (totalRows.length > 0) {
	            rtnVal[0] = "TRUE";
	            rtnVal[1] = GetSelCabInfoXml();
	            if (g_InitFlag == "0") {
	                if (document.getElementById("chkTransfer").checked) {
	                    rtnVal[2] = "1";
	                }
	                else {
	                    rtnVal[2] = "0";
	                }
	            }
	            if (ReturnFunction != null) {
	                ReturnFunction(rtnVal);
	                window.close();
	            }
	            else {
	                window.close();
	            }
	        }
	        else {
	            alert("<spring:message code='ezApprovalG.t1117'/>");
	        }
	    }
	
	    window.onbeforeunload = function () {
	        if (!CrossYN() && NonActiveX == "NO")
	            window.returnValue = rtnVal;
	    };
	    function GetSelCabInfoXml() {
	        var SelCabListview = new ListView();
	        SelCabListview.LoadFromID("DivDivCabinetList");
	        var totalRows = SelCabListview.GetDataRows();
	        var i;
	        var rtnXml = createXmlDom();
	        var Root, objItem, objData;
	        Root = createNodeInsert(rtnXml, Root, "CABINETINFO");
	        for (i = 0; i < totalRows.length; i++) {
	            objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "CABINET");
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETID", totalRows[i].getAttribute("DATA1"));
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETNAME", totalRows[i].cells[0].innerText);
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "RECTYPE", totalRows[i].getAttribute("DATA3"));
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETSN", totalRows[i].cells[1].innerText);
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETVOLNO", totalRows[i].cells[2].innerText);
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "TASKCODE", totalRows[i].getAttribute("DATA2"));
	        }
	        return getXmlString(rtnXml);
	    }
	    var createcabinet_cross_dialogArguments = new Array();
	    function btnCreateCab_onclick() {
	        var List = new ListView();
	        List.LoadFromID("DivTaskList");
	        var selnodes = List.GetSelectedRows();
	        if (selnodes.length > 0) {
	            var selnode = selnodes[0];
	            var para = new Array();
	            para[0] = GetAttribute(selnode, "DATA1");
	            para[1] = selnode.cells[1].innerHTML;
	            para[2] = GetAttribute(selnode, "DATA3");
	            para[3] = GetAttribute(selnode, "DATA2");
	            para[4] = GetAttribute(selnode, "DATA9");
	            para[5] = GetAttribute(selnode, "DATA10");
	            para[6] = GetAttribute(selnode, "DATA4");
	            para[7] = GetAttribute(selnode, "DATA5");
	            para[8] = GetAttribute(selnode, "DATA6");
	            para[9] = GetAttribute(selnode, "DATA7");
	            para[10] = GetAttribute(selnode, "DATA8");
	            para[11] = GetAttribute(selnode, "DATA11");
	            para[12] = GetAttribute(selnode, "DATA12");
	            var url = "/ezApprovalG/createCabinet.do";
	
	            createcabinet_cross_dialogArguments[0] = para;
	            createcabinet_cross_dialogArguments[1] = btnCreateCab_onclick_Complete;
	
	            if ("${userInfo.lang}" == "2" || "${userInfo.lang}" == "3") { 
	            	DivPopUpShow(440, 435, url);
	            } else { 
	            	DivPopUpShow(440, 435, url);
	            } 
	        }
	    }
	    function btnCreateCab_onclick_Complete(rtn) {
	        DivPopUpHidden();
	        if (rtn[0] == "TRUE") {
	            GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], rtn[1], g_InitFlag);
	        }
	    }
	    function btnNewVolume_onclick() {
	        var ListCab = new ListView();
	        ListCab.LoadFromID("DivCabinetList");
	        var selnodes = ListCab.GetSelectedRows();
	        if (selnodes.length > 0) {
	            var selnode = selnodes[0];
	            var rtn = NewVolume(trim(GetAttribute(selnode, "DATA1")), trim(GetAttribute(selnode, "DATA3")));
	            if (rtn != "FALSE") {
	                GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], rtn, g_InitFlag);
	            }
	        }
	        else {
	            alert("<spring:message code='ezApprovalG.t99992'/>");
	        }
	    }
	    function CabinetSearch_Press(e) {
	        if (window.event) {
	            if (e.keyCode != 13)
	                return;
	        }
	        else {
	            if (e.which != 13)
	                return;
	        }
	        CabinetSearch_onclick();
	    }
	    function TaskList_rowdbclick() {
	    }
	    var searchcabinet_cross_dialogArguments = new Array();
	    function CabinetSearch_onclick() {
	        if (document.getElementById("Cabinetkeyword").value == "") {
	            alert("<spring:message code='ezApprovalG.t1160'/>");
	            document.getElementById("Cabinetkeyword").focus();
	            return;
	        }
	        var param = document.getElementById("Cabinetkeyword").value;
	
	        searchcabinet_cross_dialogArguments[0] = param;
	        searchcabinet_cross_dialogArguments[1] = CabinetSearch_onclick_Complete;
	
	        DivPopUpShow(610, 410, "/ezApprovalG/searchCabinet.do");
	    }
	        function CabinetSearch_onclick_Complete(rtn) {
	            DivPopUpHidden();
	        if (rtn[0] == "TRUE") {
	            var xmldom = createXmlDom();
	            xmldom = loadXMLString(rtn[1]);
	            var SelCabListView = new ListView();
	            SelCabListView.LoadFromID("DivDivCabinetList");
	            SelCabRows = SelCabListView.GetDataRows();
	            if (SelCabRows.length > 0) {
	                selRow = SelCabRows[0];
	                var totalRows = GetAttribute(selRow, "id");
	                SelCabListView.DeleteRow(totalRows);
	            }
	            var value = GetElementsByTagName(xmldom.documentElement, "VALUE");
	            var row = "<ROW>";
	            row += "<CELL>";
	            row += "<VALUE>";
	            row += getNodeText(value[0]);
	            row += "</VALUE>";
	            row += "<DATA1>";
	            row += SelectSingleNodeValueNew(xmldom, "ROW/CELL/DATA1");
	            row += "</DATA1>";
	            row += "<DATA2>";
	            row += SelectSingleNodeValueNew(xmldom, "ROW/CELL/DATA2");
	            row += "</DATA2>";
	            row += "<DATA3>";
	            row += SelectSingleNodeValueNew(xmldom, "ROW/CELL/DATA3");
	            row += "</DATA3>";
	            row += "</CELL>";
	            row += "<CELL>";
	            row += "<VALUE>";
	            row += getNodeText(value[1]);
	            row += "</VALUE>";
	            row += "</CELL>";
	            row += "<CELL>";
	            row += "<VALUE>";
	            row += getNodeText(value[2]);
	            row += "</VALUE>";
	            row += "</CELL>";
	            row += "</ROW>";
	            var rowXml = loadXMLString(row);
	            var tr = SelCabListView.AddRow(0);
	            SelCabListView.AddDataRow(tr, rowXml);
	        }
	    }
	    function trim(parm_str) {
	        return rtrim(ltrim(parm_str));
	    }
	    function ltrim(parm_str) {
	        str_temp = parm_str;
	        while (str_temp.length != 0) {
	            if (str_temp.substring(0, 1) == " ") {
	                str_temp = str_temp.substring(1, str_temp.length);
	            } else {
	                return str_temp;
	            }
	        }
	        return str_temp;
	    }
	    function rtrim(parm_str) {
	        str_temp = parm_str;
	        while (str_temp.length != 0) {
	            int_last_blnk_pos = str_temp.lastIndexOf(" ");
	            if ((str_temp.length - 1) == int_last_blnk_pos) {
	                str_temp = str_temp.substring(0, str_temp.length - 1);
	            } else {
	                return str_temp;
	            }
	        }
	        return str_temp;
	    }
	    </script>
	</head>
	<body class="popup" style="margin-left: 0px; margin-top: 0px">
	    <h1 style="height: 39px;"><spring:message code='ezApprovalG.t711'/></h1>
	    <table style="margin-top: -8px;">
	        <tr>
	            <%--기능분류선택--%>
	            <td style="width: 190px; vertical-align: top">
	                <h2><spring:message code='ezApprovalG.t1039'/></h2>
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t592'/></th>
	                        <td>
	                            <select id="selTaskCategory" style="width: 100%" onchange="return selTaskCategory_onchange()">
	                            </select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t593'/></th>
	                        <td>
	                            <select id="selTaskMCategory" style="width: 100%" onchange="return selTaskMCategory_onchange()">
	                            </select>
	                        </td>
	                    </tr>
	                </table>
	                <div class="listview" style="margin-top: 5px">
	                    <div id="TaskSCateList" style="border: 0; HEIGHT: 265px; WIDTH: 190px; overflow: auto; margin: 1px 1px 1px 1px;"></div>
	                </div>
	            </td>
	            <%--단위업무 선택--%>
	            <td style="padding-left: 5px; width: 190px; vertical-align: top">
	                <h2><spring:message code='ezApprovalG.t1040'/></h2>
	                <table style="width: 100%">
	                    <tr>
	                        <th style="height: 23px; text-align: left"><a class="imgbtn"><span onclick="return btnFindTask_onclick()"><spring:message code='ezApprovalG.t1041'/></span></a></th>
	                    </tr>
	                    <tr style="height: 2px;">
	                        <td></td>
	                    </tr>
	                    <tr>
	                        <td style="width: 190px">
	                            <div class="listview">
	                                <div id="TaskList" style="border: 0; HEIGHT: 300px; WIDTH: 180px; overflow: auto; margin: 1px 1px 1px 1px;"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <%--기록물철선택--%>
	            <td style="padding-left: 5px; vertical-align: top">
	                <h2><spring:message code='ezApprovalG.t711'/></h2>
	                <table style="width: 200px;">
	                	<c:if test="${initFlag == '1'}">
		                    <tr id="trCreateCab">
		                        <th style="height: 23px; text-align: left"><a class="imgbtn"><span onclick="return btnCreateCab_onclick()"><spring:message code='ezApprovalG.t1118'/></span></a>
		                            <a class="imgbtn"><span onclick="return btnNewVolume_onclick()"><spring:message code='ezApprovalG.t894'/></span></a></th>
		                    </tr>
		                    <tr id="trCreateCabDummy" style="display: none">
		                        <td></td>
		                    </tr>
	                	</c:if>
	                    <tr>
	                        <td>
	                            <div class="listview">
	                                <div id="CabinetList" style="border: 0; HEIGHT: 300px; WIDTH: 200px; overflow: auto; margin: 1px 1px 1px 1px;"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <%--선택된 기록물철--%>
	            <td style="height: 25px; text-align: center">
	                <img id="RecvAdd" border="0" src="/images/arr_right.gif" width="16" height="16"
	                    onclick="return AddCabList_onclick()" style="cursor: pointer">
	                <img id="RecvDel" border="0" src="/images/arr_left.gif" width="16" height="16"
	                    onclick="return DelCabList_onclick()" style="cursor: pointer"></td>
	
	            <td style="width: 200px; vertical-align: top">
	                <h2><spring:message code='ezApprovalG.t1120'/></h2>
	                <table style="width: 100%">
	                    <tr>
	                        <td colspan="2">
	                            <div class="listview">
	                                <div id="SelCabinetList" style="border: 0; HEIGHT: 330px; WIDTH: 200px; overflow: auto; margin: 1px 1px 1px 1px;"></div>
	                            </div>
	                        </td>
	
	                    </tr>
	                    <c:if test="${initFlag == '0'}">
		                    <tr style="display: none">
		                        <td style="padding-top: 0">
		                            <input type="checkbox" id="chkTransfer" name="chkTransfer" value="1">
		                            <spring:message code='ezApprovalG.t1121'/></td>
		                    </tr>
	                    </c:if>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition" style="text-align: right;">
	        <h2><spring:message code='ezApprovalG.t1090'/>
	            <input type="text" id="Cabinetkeyword" value="" onkeypress="CabinetSearch_Press(event)" style="cursor: text; padding: 0 0 0 0; border-top: 1px solid #bebebe; border-left: 1px solid #bebebe; background-color: White; width: 150px;color:black;font-weight:normal">
	            <a class="imgbtn" onclick="return CabinetSearch_onclick()"><span><spring:message code='ezApprovalG.t111'/></span></a>
	            <a class="imgbtn" onclick="return cmdConfirm_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
	            <a class="imgbtn" onclick="return cmdCancel_onclick()"><span><spring:message code='ezApprovalG.t119'/></span></a>
	        </h2>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>