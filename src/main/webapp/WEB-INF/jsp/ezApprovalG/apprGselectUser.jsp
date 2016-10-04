<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1143'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/OrganTree_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/composeappt.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var g_InitFlag = "0";
		    var OrderCell = "";
		    var arrDeptInfo = new Array();
		    var g_CabClassNo, g_DeptCode;
		    var rtnVal = new Array();
		    var RetValue;
		    var ReturnFunction;
		    var NonActiveX = "YES";
		    
		    window.onload = function () {
		        if (CrossYN() || NonActiveX == "YES") {
		            document.getElementById("OrgListView").style.width = "220px";
		            document.getElementById("OrgListView").style.height = "195px";
		            document.getElementById("SelUserList").style.width = "150px";
		            document.getElementById("SelUserList").style.height = "195px";
		        }
		        try {
		            RetValue = parent.selectuser_cross_dialogArguments[0];
		            ReturnFunction = parent.selectuser_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.selectuser_cross_dialogArguments[0];
		                ReturnFunction = opener.selectuser_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        g_CabClassNo = RetValue[0];
		        g_DeptCode = RetValue[1];
		        rtnVal[0] = "FALSE";
		        var pSearchList = "extensionAttribute1::w=1;;EXACT_Department::" + g_DeptCode;
		        var pCellList = "displayName;title;description;company";
		        var pPropList = "displayName";
		        var pClass = "user";
		        DisplayOrganSearchList(pSearchList, pCellList, pPropList, pClass);
		        InitSelUserList();
		    };
		    function InitSelUserList() {
		        document.getElementById("SelUserList").innerHTML = "";
		        var listview = new ListView();
		        listview.SetID("Seluserlistview");
		        listview.SetMulSelectable(true);
		        listview.SetSelectFlag(false);
		        listview.SetRowOnDblClick("SelUserList_rowdblclick");
		
		        if (CrossYN())
		            listview.DataSource(SelUserListHeader);
		        else {
		            var objXML = createXmlDom();
		            objXML = loadXMLString(SelUserListHeader.xml);
		            listview.DataSource(objXML);
		        }
		        listview.DataBind("SelUserList");
		    }
		    function SelUserList_rowdblclick() {
		        DelListRow();
		    }
		    function OrganListView_rowdblclick() {
		        AddRowToCabList();
		    }
		    function AddUser_onclick() {
		        AddRowToCabList();
		    }
		    function DelUser_onclick() {
		        DelListRow();
		    }
		    function AddRowToCabList() {
		        var IsValueInList = false;
		
		        var selRow;
		        var count;
		
		        var listview = new ListView();
		        listview.LoadFromID("OrganListView");
		
		        var length = listview.GetSelectedRows().length;
		
		        var sellist = new ListView();
		        sellist.LoadFromID("Seluserlistview");
		
		        var SelCabRows = sellist.GetDataRows();
		
		        if (g_InitFlag == "1")
		        {
		
		            if (SelCabRows.length > 0) {
		                selRow = SelCabRows(0);
		                selRow.remove();
		            }
		
		            selRow = OrganListView.multiSelects.item(0);
		            AddRow(selRow);
		        }
		        else
		        {
		            for (count = 0; count < length; count++) {
		                selRow = listview.GetSelectedRows()[count];
		
		                var totalRows = SelCabRows;
		
		                if (totalRows.length > 0) {
		                    var i;
		                    for (i = 0; i < totalRows.length; i++) {
		                        if (totalRows[i].getAttribute("DATA2") == selRow.getAttribute("DATA2")) {
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
		
		    var AprLineAddIndex = 0;
		    function AddRow(selRow) {
		        var sellist = new ListView();
		        sellist.LoadFromID("Seluserlistview");
		        var addXml = "<LISTVIEWDATA>";
		        addXml += "<ROW>";
		        addXml += "<CELL>";
		        addXml += "<VALUE>" + selRow.cells[0].innerText + "</VALUE>";
		        addXml += "<DATA1>" + selRow.getAttribute("DATA1") + "</DATA1>";
		        addXml += "<DATA2>" + selRow.getAttribute("DATA2") + "</DATA2>";
		        addXml += "<DATA3>" + selRow.getAttribute("DATA3") + "</DATA3>";
		        addXml += "<DATA4>" + selRow.getAttribute("DATA4") + "</DATA4>";
		        addXml += "<DATA5>" + selRow.getAttribute("DATA5") + "</DATA5>";
		        addXml += "</CELL>";
		        addXml += "</ROW>";
		        addXml += "</LISTVIEWDATA>";
		
		
		        var domaddxml = loadXMLString(addXml);
		
		        var tr = sellist.GetSelectedRows();
		        var InitTr = sellist.GetDataRows();
		        var MaxID = 0;
		
		        if (InitTr[0] != undefined && InitTr[0].id.indexOf("noItems") > -1) {
		            sellist.DeleteRow(InitTr[0].id);
		            var objTr = sellist.NewAddRow(0, "Seluserlistview" + "_TR_0");
		            sellist.AddDataRow(objTr, domaddxml);
		            AprLineAddIndex = AprLineAddIndex + 1;
		            return;
		        }
		
		        for (var j = 0  ; j < InitTr.length  ; j++) {
		            var curnum = Number(sellist.GetSelectedRowID(j).substring(sellist.GetSelectedRowID(j).lastIndexOf('_') + 1), sellist.GetSelectedRowID(j).length);
		            if (MaxID < curnum)
		                MaxID = curnum;
		        }
		        var objTr = sellist.NewAddRow(0, "Seluserlistview" + "_TR_" + eval(MaxID + 1));
		        sellist.AddDataRow(objTr, domaddxml);
		        AprLineAddIndex = AprLineAddIndex + 1;
		    }
		    function DelListRow(objListView) {
		        var selRow;
		        var count1, len;
		        var sellist = new ListView();
		        sellist.LoadFromID("Seluserlistview");
		        var selRows = sellist.GetSelectedRows();
		
		        if (selRows) {
		            len = selRows.length;
		
		            for (count1 = 0; count1 < len; count1++) {
		                var selIdx = sellist.GetSelectedRows()[len - count1 - 1].getAttribute("id");
		                sellist.DeleteRow(selIdx);
		            }
		        }
		    }
		    function OrganList_rowclick() {
		        var listview = new ListView();
		        listview.LoadFromID("OrganListView");
		        var selnode = listview.GetSelectedRows();
		        var tr = selnode[0];
		
		        arrDeptInfo[0] = GetAttribute(tr, "DATA2");
		        arrDeptInfo[1] = tr.cells[0].innerText;
		    }
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		        }
		        else {
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    function cmdConfirm_onclick() {
		        var sellist = new ListView();
		        sellist.LoadFromID("Seluserlistview");
		        var totalRows = sellist.GetDataRows();
		        if (totalRows.length > 0 && totalRows[0].id.indexOf("noItems") == -1) {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = GetSelUserInfo();
		
		            if (ReturnFunction != null) {
		                ReturnFunction(rtnVal);
		            }
		            else {
		                window.returnValue = rtnVal;
		                window.close();
		            }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1144'/>");
		        }
		    }
		    window.onunload = function () {
		        if (!CrossYN())
		            window.returnValue = rtnVal;
		    };
		    
		    function GetSelUserInfo() {
		        var sellist = new ListView();
		        sellist.LoadFromID("Seluserlistview");
		        var totalRows = sellist.GetDataRows();
		        var i;
		        var objItem, objData;
		        var rtnXml = createXmlDom();
		        var Root = createNodeInsert(rtnXml, Root, "USERINFO");
		        for (i = 0; i < totalRows.length; i++) {
		            objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "USER");
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "ID", totalRows[i].getAttribute("DATA2"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "NAME", totalRows[i].getAttribute("DATA3"));
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "NAME2", totalRows[i].getAttribute("DATA4"));
		        }
		        return getXmlString(rtnXml);
		    }
		    function MM_swapImgRestore() {
		        var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
		    }
		    function MM_preloadimages() {
		        var d = document; if (d.images) {
		            if (!d.MM_p) d.MM_p = new Array();
		            var i, j = d.MM_p.length, a = MM_preloadimages.arguments; for (i = 0; i < a.length; i++)
		                if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
		        }
		    }
		    function MM_findObj(n, d) {
		        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
		            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
		        }
		        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
		        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document); return x;
		    }
		    function MM_swapImage() {
		        var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2) ; i += 3)
		            if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
		    }
		</SCRIPT>
	</head>
	<body class="popup">
		<xml id="OrganListHeader" style="display:none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t229'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t230'/></NAME>
		        <WIDTH>80</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t108'/></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t1145'/></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<xml id="SelUserListHeader" style="display:none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t229'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		
		<h1><spring:message code='ezApprovalG.t1143'/></h1>
		<table >
		  <tr>
		    <td style="vertical-align:top"><h2><spring:message code='ezApprovalG.t1146'/></h2>
		      <div class="listview">
					<DIV id="OrgListView" style="border:0;HEIGHT: 235px; WIDTH: 290px; overflow:auto;margin:1px 1px 1px 1px;" ></DIV>
		      </div></td>
		    <td style="width:25px;text-align:center"><img id="RecvAdd" onClick="return AddUser_onclick()" src="/images/arr01.gif" width="16" height="16" style="cursor:pointer"><img id="RecvDel" onClick="return DelUser_onclick()" src="/images/arr02.gif" width="16" height="16" style="cursor:pointer"> </td>
		    <td style="vertical-align:top"><h2><spring:message code='ezApprovalG.t1147'/></h2>
		      <div class="listview">
				    <DIV id="SelUserList" style="border:0;HEIGHT: 235px; WIDTH: 150px;margin:1px 1px 1px 1px;"> </DIV>
		      </div></td>
		  </tr>
		</table>
		<div class="btnposition">
		  <a class="imgbtn"><span id="btnOK" onclick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		  <a class="imgbtn"><span id="btnCancel" onclick="return cmdCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>   
		</div>
	</body>
</html>