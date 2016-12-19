<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t1168'/></title>
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="/js/ezApprovalG/CabUser_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/OrganTree_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var g_InitFlag = "0";
    var OrderCell = "";
    var CompanyID = "${userInfo.companyID}";
    var g_CabClassNo, g_DeptCode;
    var rtnVal = new Array();
    window.onload= window_onload;
    window.onbeforeunload = window_onunload;
    window.onunload = window_onunload;
    var RetValue;
    var ReturnFunction;
    function window_onload() {
        try {
            RetValue = parent.settaskchrger_cross_dialogArguments[0];
            ReturnFunction = parent.settaskchrger_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.settaskchrger_cross_dialogArguments[0];
                ReturnFunction = opener.settaskchrger_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        g_CabClassNo = RetValue[0];
        g_DeptCode = RetValue[1];
        rtnVal[0] = "FALSE";

        var pSearchList = "extensionAttribute1::w=1;;EXACT_Department::" + g_DeptCode.trim();
        var pCellList = "displayname;title;description;company";
        var pPropList = "displayname";
        var pClass = "user";

        DisplayOrganSearchList_Cross(pSearchList, pCellList, pPropList, pClass);

        InitSelUserList_Cross();

        MM_preloadimages('./images/arrow_add1.gif', './images/arrow_delete1.gif');
    }
    function cmdCancel_onclick() {
        rtnVal[0] = "FALSE";
        window.close();
    }
    function window_onunload() {
        if (ReturnFunction != null)
            ReturnFunction(rtnVal);
        else
            window.returnValue = rtnVal;
    }
    function DisplayOrganSearchList_Cross(pSearchList, pCellList, pPropList, pClass) {

        var rtnXml = OrganSearch(pSearchList, pCellList, pPropList, pClass);

        document.getElementById("OrgListView").innerHTML = "";
        var listview = new ListView();
        listview.SetID("OrganListView");
        listview.SetMulSelectable(true);
        listview.SetRowOnClick("OrganList_rowclick");
        listview.SetRowOnDblClick("OrganList_rowdbclick");

        if (CrossYN())
            listview.DataSource(OrganListHeader);
        else {
            var objXML = createXmlDom();
            objXML = loadXMLString(OrganListHeader.xml);
            listview.DataSource(objXML);
        }

        listview.DataBind("OrgListView");

        listview.DataSource(rtnXml);             
        listview.RowDataBind("OrgListView");
        listview.SetSelectFlag(false);
    }
    function InitSelUserList_Cross() {
        var rtnXml = GetTaskCharger(g_CabClassNo, g_DeptCode);

        if (rtnXml == null)
            return;

        document.getElementById("UserListView").innerHTML = "";
        var userlistview = new ListView();
        userlistview.SetID("UsersListView");
        userlistview.SetMulSelectable(true);
        userlistview.SetRowOnClick("UserList_rowclick");
        userlistview.SetRowOnDblClick("UserList_rowdbclick");

        if (CrossYN())
            userlistview.DataSource(UserListHeader);
        else {
            var objXML = createXmlDom();
            objXML = loadXMLString(UserListHeader.xml);
            userlistview.DataSource(objXML);
        }

        userlistview.DataBind("UserListView");
        userlistview.DataSource(rtnXml);             
        userlistview.RowDataBind("UserListView");
        userlistview.SetSelectFlag(true);

        var DataNodes = GetChildNodes(rtnXml);
        if (getNodeText(DataNodes[0]) == "FALSE" || getNodeText(DataNodes[0]) == "") {
            alert("<spring:message code='ezApprovalG.t1169'/>");
        }
        else {

        }
    }
    function AddRowToCabList_Cross() {
        var oList = new ListView();      
        oList.LoadFromID("OrganListView");

        var IsValueInList = false;
        var selRow;
        var count;

        var SelCabRows = oList.GetSelectedRows();
        var length = SelCabRows.length;

        for (count = 0; count < length; count++) {
            selRow = SelCabRows[count];

            var UList = new ListView();
            UList.LoadFromID("UsersListView");

            var totalRows = UList.GetDataRows();
            if (totalRows.length > 0) {
                var i;
                for (i = 0; i < totalRows.length; i++) {

                    if (GetAttribute(totalRows[i], "DATA1").toLowerCase() == GetAttribute(selRow, "DATA2").toLowerCase()) {
                        IsValueInList = true;
                        break;
                    }
                }
            }
            if (!IsValueInList) {
                AddRow_Cross(selRow);
            }
            else {
                alert("<spring:message code='ezApprovalG.t1170'/>");
                return;
            }
            IsValueInList = false;
        }
    }
    function DelListRow_Cross() {
        var oList = new ListView();
        oList.LoadFromID("UsersListView");
        var SelCabRows = oList.GetSelectedRows();
        var length = SelCabRows.length;

        for (count = 0; count < length; count++) {
            var selIdx = oList.GetSelectedRows()[count].getAttribute("id");
            oList.DeleteRow(selIdx);
        }
    }
    function AddRow_Cross(selRow) {
        var pparsingXML = "<LISTVIEWDATA><HEADERS>";
        pparsingXML = pparsingXML + "<HEADER><NAME><spring:message code='ezApprovalG.t229'/></NAME><WIDTH>30</WIDTH></HEADER>";;
        pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
        pparsingXML = pparsingXML + "<VALUE>" + selRow.cells[0].innerText + "</VALUE>";
        pparsingXML = pparsingXML + "<DATA1>" + GetAttribute(selRow, "DATA2") + "</DATA1>";
        pparsingXML = pparsingXML + "<DATA2>" + GetAttribute(selRow, "DATA4") + "</DATA2>";
        pparsingXML = pparsingXML + "<DATA3>" + GetAttribute(selRow, "DATA5") + "</DATA3>";
        pparsingXML = pparsingXML + "</CELL></ROW></ROWS></LISTVIEWDATA>";
        var Resultxml = loadXMLString(pparsingXML);

        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("UsersListView");

        var tr = pAPRLINE.GetSelectedRows();
        var InitTr = pAPRLINE.GetDataRows();
        var MaxID = 0;
        for (var j = 0  ; j < InitTr.length  ; j++) {
            var curnum = Number(pAPRLINE.GetSelectedRowID(j).substring(pAPRLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAPRLINE.GetSelectedRowID(j).length);
            if (MaxID < curnum)
                MaxID = curnum;
        }
        var objTr = pAPRLINE.NewAddRow(0, "UsersListView" + "_TR_" + eval(MaxID + 1));
        pAPRLINE.AddDataRow(objTr, Resultxml);
    }
    function cmdConfirm_onclick() {
        var UList = new ListView();
        UList.LoadFromID("UsersListView");

        var totalRows = UList.GetDataRows();

        if (totalRows.length > 0) {
            if (SaveCabRoleInfo_Cross()) {
                alert("<spring:message code='ezApprovalG.t1171'/>");

                rtnVal[0] = "TRUE";
                window.close();
            }
            else {
                alert("<spring:message code='ezApprovalG.t1172'/>");
            }
        }
        else {
            alert("<spring:message code='ezApprovalG.t1173'/>");
        }
    }
    function SaveCabRoleInfo_Cross() {
        var oXmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode = createNodeInsert(xmlpara, objNode, "PARAMETERS");

        createNodeAndInsertText(xmlpara, objNode, "CABCLASSNO", g_CabClassNo);

        var SelUserList = new ListView();
        SelUserList.LoadFromID("UsersListView");
        var totalRows = SelUserList.GetDataRows();
        var i;
        var IDList = "";
        var NameList = "";
        var NameList2 = "";
        var objSubNode = createNodeAndAppandNode(xmlpara, objNode, objSubNode, "USERINFO");

        for (i = 0; i < totalRows.length; i++) {
            if (IDList != "")
                IDList += ",";

            if (NameList != "")
                NameList += ",";

            if (NameList2 != "")
                NameList2 += ",";

            var UList = new ListView();
            UList.LoadFromID("UsersListView");

            var totalRows = UList.GetDataRows();
            selRow = totalRows[i];

            IDList += GetAttribute(selRow, "DATA1")
            NameList += GetAttribute(selRow, "DATA2")
            if (GetAttribute(selRow, "DATA3") == "")
                NameList2 += " ";
            else
                NameList2 += GetAttribute(selRow, "DATA3")
        }
        createNodeAndAppandNodeText(xmlpara, objNode, objSubNode, "USERID", IDList);
        createNodeAndAppandNodeText(xmlpara, objNode, objSubNode, "USERNAME", NameList);
        createNodeAndAppandNodeText(xmlpara, objNode, objSubNode, "USERNAME2", NameList2);

        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

        oXmlhttp.open("POST", "/ezApprovalG/saveCabRoleInfo.do", false);
        oXmlhttp.send(xmlpara);

        var rtnXml = oXmlhttp.responseXML;
        var DataNodes = GetChildNodes(rtnXml);
        if (getNodeText(DataNodes[0]) == "TRUE")
            return true;
        else
            return false;
    }
    function GetSelUserID_Cross() {
        var SelUserList = new ListView();
        SelUserList.LoadFromID("UsersListView");
        var totalRows = SelUserList.GetDataRows();
        var i;
        var IDList = "";
        var NameList = "";
        var NameList2 = "";

        var rtnXml = createXmlDom();
        var Root;
        createNodeInsert(rtnXml, Root, "USERINFO");

        for (i = 0; i < totalRows.length; i++) {
            if (IDList != "")
                IDList += ",";

            if (NameList != "")
                NameList += ",";

            if (NameList2 != "")
                NameList2 += ",";

            var UList = new ListView();
            UList.LoadFromID("UsersListView");

            var totalRows = UList.GetDataRows();
            selRow = totalRows[i];

            IDList += GetAttribute(selRow, "DATA1")
            NameList += GetAttribute(selRow, "DATA2")
            if (GetAttribute(selRow, "DATA3") == "")
                NameList2 += " ";
            else
                NameList2 += GetAttribute(selRow, "DATA3")
        }
        var objNode;
        createNodeAndInsertText(rtnXml, objNode, "USERID", IDList);
        createNodeAndInsertText(rtnXml, objNode, "USERNAME", NameList);
        createNodeAndInsertText(rtnXml, objNode, "USERNAME2", NameList2);

        return rtnXml;
    }
    function OrganList_rowclick() {
    }
    function OrganList_rowdbclick() {
        AddRowToCabList_Cross();
    }
    function AddUser_onclick() {
        AddRowToCabList_Cross();
    }
    function DelUser_onclick() {
        DelListRow_Cross();
    }
    function UserList_rowclick() {
    }
    function UserList_rowdbclick() {
        DelListRow_Cross();
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
    function MM_swapImage() {
        var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2) ; i += 3)
            if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
    }
    function MM_preloadImages() {
        var d = document; if (d.images) {
            if (!d.MM_p) d.MM_p = new Array();
            var i, j = d.MM_p.length, a = MM_preloadImages.arguments; for (i = 0; i < a.length; i++)
                if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
        }
    }
    function MM_findObj(n, d) {
        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
        }
        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
        if (!x && d.getElementById) x = d.getElementById(n); return x;
    }
</SCRIPT>
</head><body class="popup">
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

<xml id="UserListHeader"  style="display:none">
<LISTVIEWDATA>
	<HEADERS>
		<HEADER>
			<NAME><spring:message code='ezApprovalG.t229'/></NAME>
			<WIDTH>150</WIDTH>
		</HEADER>		
	</HEADERS>
</LISTVIEWDATA>
</xml>
<h1><spring:message code='ezApprovalG.t1168'/></h1>

<table>
        <tr> 
          <td style="vertical-align:top"><h2><spring:message code='ezApprovalG.t1174'/></h2>
        <div class="listview"  style="HEIGHT: 235px; WIDTH: 290px; overflow:AUTO" id="divList">
        <div ID="OrgListView" style="margin: 1px 1px 1px 1px;"></div></div>
        </td>
          <td style="width:25px;text-align:center"><img id="RecvAdd" border="0" src="/images/arr_right.gif" width="16" height="16" 
						onClick="return AddUser_onclick()" style="cursor:pointer"><img id="RecvDel" border="0" src="/images/arr_left.gif" width="16" height="16" 
						onClick="return DelUser_onclick()" style="cursor:pointer"></td>

          <td style="vertical-align:top"><h2><spring:message code='ezApprovalG.t1175'/></h2>
          <div class="listview"  style="HEIGHT: 235px; WIDTH: 180px;overflow-x:hidden;overflow-y:AUTO" id="divList2">
          <div ID="UserListView" style="margin: 1px 1px 1px 1px;"></div></div></td>
        </tr>
</table>

<div class="btnposition">
<a class="imgbtn"><span id="btnOK" onClick="return cmdConfirm_onclick()" ><spring:message code='ezApprovalG.t20'/></span></a>
<a class="imgbtn"><span id="btnCancel" onClick="return cmdCancel_onclick()" ><spring:message code='ezApprovalG.t119'/></span></a>
</div>

</body>
</html>
