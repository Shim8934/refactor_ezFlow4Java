<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><spring:message code='ezApprovalG.t1155'/></title>
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="/js/ezApprovalG/OrganTree_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var g_InitFlag = "0";
    var OrderCell = "";
    var g_RecID, g_SepAttNo, g_DeptCode;
    var rtnVal = new Array();
    var CompanyID = "${userInfo.companyID}";
    var UserLang = "${userInfo.lang}";
    var RetValue;
    var ReturnFunction;
    window.onload = function () {
        var ua = navigator.userAgent;
        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            KeEventControl(document.getElementById("txtKeyword"));
        }
        try {
            RetValue = parent.setrecuserrole_cross_dialogArguments[0];
            ReturnFunction = parent.setrecuserrole_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.setrecuserrole_cross_dialogArguments[0];
                ReturnFunction = opener.setrecuserrole_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        g_RecID = RetValue[0];
        g_SepAttNo = RetValue[1];
        g_DeptCode = RetValue[2];
        rtnVal[0] = "FALSE";
        var pSearchList = "EXACT_Department::"+g_DeptCode.trim();
        var pCellList = "displayname;title;description;company";
        var pPropList = "Department;Description;DisplayName;Title";
        var pClass = "user";

        DisplayOrganSearchList(pSearchList, pCellList, pPropList, pClass);
        InitRecViewerInfo();

        MM_preloadimages('./images/arrow_add1.gif', './images/arrow_delete1.gif');
    }
    function DisplayOrganSearchList(pSearchList, pCellList, pPropList, pClass) {
        var rtnXml = OrganSearch(pSearchList, pCellList, pPropList, pClass);
        var objRoot, objNode, header, Data;

        document.getElementById("OrgListView").innerHTML = "";
        var listview = new ListView();
        listview.SetID("OrganListView");
        listview.SetMulSelectable(true);
        listview.SetRowOnDblClick("OrganList_rowdblclick");
        listview.DataSource(loadXMLString(OrganListHeader.innerHTML.toUpperCase()));
        listview.DataBind("OrgListView");

        listview.DataSource(rtnXml);             
        listview.RowDataBind("OrgListView");
        listview.SetSelectFlag(false);
    }
    function SwapRoleList() {
    
         if (document.getElementsByName("rdoRecRole")[0].checked) {
            document.getElementById("DataLayout").disabled = true;
            document.getElementById("OrganListView").disabled = true;
//          document.getElementByNames("OrganListView_TR_").disabled = true;
            document.getElementById("RecvDel").style.display = "";
        }
        else if (document.getElementsByName("rdoRecRole")[1].checked) {
            document.getElementById("DataLayout").style.display = "";
            document.getElementById("DataLayout").disabled = "";
        }
    }
    function InitRecViewerInfo() {
        var rtnXml = GetRecViewerInfo(g_RecID, g_SepAttNo);
        var AllAllowed = SelectSingleNodeValue(rtnXml.documentElement, "ALLALLOWED");
        if (AllAllowed == "0") {
            alert("<spring:message code='ezApprovalG.t1156'/>");
            return "";
        }

   
        if (AllAllowed == "0") {
            document.getElementsByName("rdoRecRole")[0].checked = false;
            document.getElementsByName("rdoRecRole")[1].checked = true;
        }
        else {
            document.getElementsByName("rdoRecRole")[0].checked = true;
            document.getElementsByName("rdoRecRole")[1].checked = false;
        }
        var LVXml = createXmlDom();
        LVXml = SelectSingleNode(SelectSingleNode(rtnXml,"ROLEINFO"),"LISTVIEWDATA");
        var listview = new ListView();
        listview.SetID("lvSelUserList");
        listview.SetMulSelectable(true);
        listview.SetRowOnDblClick("SelUserList_rowdblclick");
        listview.DataSource(loadXMLString(SelUserListHeader.innerHTML.toUpperCase()));
        listview.DataBind("SelUserList");
        listview.DataSource(LVXml);
        listview.RowDataBind("SelUserList");
        listview.SetSelectFlag(false);
        SwapRoleList();
    }
    function GetRecViewerInfo(pRecID, pSepAttNo) {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETERS");
        createNodeAndInsertText(xmlpara, objNode, "RECID", pRecID);
        createNodeAndInsertText(xmlpara, objNode, "SEPATTNO", pSepAttNo);
        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
        createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", UserLang);

        xmlhttp.open("POST", "/ezApprovalG/getRecViewerInfo.do", false);
        xmlhttp.send(xmlpara);
        return  xmlhttp.responseXML;
    }
    function SelUserList_rowdblclick() {
        DelListRow();
    }
    function OrganList_rowdblclick() {
        AddRowToCabList();
    }
    function AddUser_onclick() {
        AddRowToCabList();
    }
    function DelUser_onclick() {
        DelListRow();
    }
    function AddRowToCabList() {
        if (document.getElementsByName("rdoRecRole")[0].checked == true)
            return;

        var IsValueInList = false;

        var listview = new ListView();
        listview.LoadFromID("OrganListView");

        var userlist = new ListView();
        userlist.LoadFromID("lvSelUserList");

        var selRow;
        var count;
        var length = listview.GetSelectedRows().length;

        var SelCabRows;

        if (g_InitFlag == "1")
        {
            SelCabRows = userlist.GetDataRows();
            if (SelCabRows.length > 0) {
                selRow = SelCabRows(0);
                selRow.remove();
            }

            selRow = listview.GetSelectedRows()[0];
            AddRow(selRow);
        }
        else
        {
            for (count = 0; count < length; count++) {
                selRow = listview.GetSelectedRows()[count];

                var totalRows = userlist.GetDataRows();

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
                else {
                    alert("<spring:message code='ezApprovalG.t1157'/>");
                }

                IsValueInList = false;
            }
        }
    }
    function AddRow(selRow) {
        var listview = new ListView();
        listview.LoadFromID("lvSelUserList");

        if (listview.GetRowCount() > 0 && listview.GetDataRows()[0].id == "lvSelUserList_TR_noItems")
            listview.DeleteRow("lvSelUserList_TR_noItems")

        var DeptAddIndex = listview.GetRowCount();
        DeptAddIndex = DeptAddIndex + 1;

        var tr = listview.GetSelectedRows();
        var InitTr = listview.GetDataRows();

        

        var MaxID = 0;
        for (var j = 0  ; j < InitTr.length  ; j++) {
            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
            if (MaxID < curnum)
                MaxID = curnum;
        }

        var addXml = "<LISTVIEWDATA>";
        addXml += "<ROW>";
        addXml += "<CELL>";
        addXml += "<VALUE>" + selRow.childNodes[0].innerText + "</VALUE>";
        addXml += "<DATA1>" + selRow.getAttribute("DATA1") + "</DATA1>";
        addXml += "<DATA2>" + selRow.getAttribute("DATA2") + "</DATA2>";
        addXml += "<DATA3>" + selRow.getAttribute("DATA9") + "</DATA3>";
        addXml += "<DATA4>" + selRow.getAttribute("DATA10") + "</DATA4>";
        addXml += "<DATA5>" + selRow.getAttribute("DATA11") + "</DATA5>";
        addXml += "<DATA6>" + selRow.getAttribute("DATA12") + "</DATA6>";
        addXml += "<DATA7>" + selRow.getAttribute("DATA7") + "</DATA7>";
        addXml += "<DATA8>" + selRow.getAttribute("DATA8") + "</DATA8>";
        addXml += "</CELL>";
        addXml += "<CELL>";
        addXml += "<VALUE>" + selRow.childNodes[2].innerText + "</VALUE>";
        addXml += "</CELL>";
        addXml += "<CELL>";
        addXml += "<VALUE>" + selRow.childNodes[1].innerText + "</VALUE>";
        addXml += "</CELL>";
        addXml += "</ROW>";
        addXml += "</LISTVIEWDATA>";
        var xmlDoc = createXmlDom();
        xmlDoc = loadXMLString(addXml);

        if (tr.length == 0) {
            if (InitTr.length == 0) {
                var objTr = listview.AddRow(0);
                SetAttribute(objTr, "id", "lvSelUserList" + "_TR_" + eval(MaxID + 1));
                listview.AddDataRow(objTr, xmlDoc);
            }
            else {
                var objTr = listview.AddRow(DeptAddIndex - 1);
                SetAttribute(objTr, "id", "lvSelUserList" + "_TR_" + eval(MaxID + 1));
                listview.AddDataRow(objTr, xmlDoc);
            }
        }
        else {
            var objTr = listview.AddRow(DeptAddIndex - 1);
            SetAttribute(objTr, "id", "lvSelUserList" + "_TR_" + eval(MaxID + 1));
            listview.AddDataRow(objTr, xmlDoc);
        }
    }
    function DelListRow(objListView) {
        if (document.getElementsByName("rdoRecRole")[0].checked == true)
            return;
        var objListView = new ListView();
        objListView.LoadFromID("lvSelUserList");
        var selRow;
        var count1, len;
        var selRows = objListView.GetSelectedRows();

        if (selRows) {
            len = selRows.length;

            for (count1 = 0; count1 < len; count1++) {
                var totalRows = GetAttribute(selRows[count1], "id");
                objListView.DeleteRow(totalRows);
            }
        }
    }
    function cmdCancel_onclick() {
        window.close();
    }
    function cmdConfirm_onclick() {
        var userlist = new ListView();
        userlist.LoadFromID("lvSelUserList");

        var totalRows = userlist.GetDataRows();
        if (document.getElementsByName("rdoRecRole")[1].checked) {
            if (totalRows.length < 1) {
                alert("<spring:message code='ezApprovalG.t1158'/>");
                return;
            }
        }
        if (SaveRecUserRole()) {
            window.close();
        }
    }
    function SaveRecUserRole() {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETERS");

        if (document.getElementsByName("rdoRecRole")[0].checked)
            createNodeAndInsertText(xmlpara, objNode, "FLAG", "0");
        else if (document.getElementsByName("rdoRecRole")[1].checked)
            createNodeAndInsertText(xmlpara, objNode, "FLAG", "1");

        createNodeAndInsertText(xmlpara, objNode, "RECID", g_RecID);
        createNodeAndInsertText(xmlpara, objNode, "SEPATTNO", g_SepAttNo);

        if (document.getElementsByName("rdoRecRole")[1].checked) {
            var objUserInfoXml = GetSelUserInfo();	
            xmlpara.documentElement.appendChild(objUserInfoXml.documentElement);
        }

        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

        xmlhttp.open("POST", "/ezApprovalG/saveRecUserRole.do", false);
        xmlhttp.send(xmlpara);

        var rtnXml = xmlhttp.responseXML;
        if (getNodeText(GetChildNodes(rtnXml)[0]) == "FALSE") {
            alert("<spring:message code='ezApprovalG.t1159'/>");
            return false;
        }
        else {
            return true;
        }
    }
    function GetSelUserInfo() {
        var listview = new ListView();
        listview.LoadFromID("lvSelUserList");

        var totalRows = listview.GetDataRows();
        var i;

        var rtnXml = createXmlDom();

        var objRoot, objNode, subNode;
        objRoot = createNodeInsert(rtnXml, objRoot, "USERINFO");

        for (i = 0; i < totalRows.length; i++) {
            objNode = createNodeAndAppandNode(rtnXml, objRoot, objNode, "USER");
            createNodeAndAppandNodeText(rtnXml, objNode, subNode, "ID", totalRows[i].getAttribute("DATA2"));
            createNodeAndAppandNodeText(rtnXml, objNode, subNode, "NAME", totalRows[i].getAttribute("DATA3"));
            createNodeAndAppandNodeText(rtnXml, objNode, subNode, "TITLE", totalRows[i].getAttribute("DATA5"));
            createNodeAndAppandNodeText(rtnXml, objNode, subNode, "DEPTCODE", g_DeptCode);
            createNodeAndAppandNodeText(rtnXml, objNode, subNode, "DEPTNAME", totalRows[i].getAttribute("DATA7"));
            createNodeAndAppandNodeText(rtnXml, objNode, subNode, "NAME2", totalRows[i].getAttribute("DATA4"));
            createNodeAndAppandNodeText(rtnXml, objNode, subNode, "TITLE2", totalRows[i].getAttribute("DATA6"));
            createNodeAndAppandNodeText(rtnXml, objNode, subNode, "DEPTNAME2", totalRows[i].getAttribute("DATA8"));
        }

        return rtnXml;
    }
    function txtKeyword_onKeyPress() {
        if (window.event.keyCode == "13")
            btnSearch_Click();
    }
    var g_xmlHTTP;
    function btnSearch_Click() {
        if (txtKeyword.value == "") {
            alert("<spring:message code='ezApprovalG.t1160'/>");
            txtKeyword.focus();
            return;
        }

        var xmlDOM = createXmlDom();
        $.ajax({
        	type : "POST",
        	dataType : "xml",
        	url : "/ezOrgan/getSearchList.do",
        	async : false,
        	data : {search : selSearchType.value+ "::" +txtKeyword.value, cell : "displayName;title;description;company", prop : "department", type : "user"},
        	success : function(result){	
        		xmlDOM = result;
                adCount = xmlDOM.getElementsByTagName("ROW").length;
                if(adCount<0){
                	  alert("<spring:message code='ezApprovalG.t1161'/>");
                }
                document.getElementById("OrgListView").innerHTML = "";
                var listview = new ListView();
                listview.SetID("OrganListView");
                listview.SetMulSelectable(true);
                listview.SetRowOnDblClick("OrganList_rowdblclick");
                listview.DataSource(loadXMLString(OrganListHeader.innerHTML.toUpperCase()));
                listview.DataBind("OrgListView");

                listview.DataSource(xmlDOM);
                listview.RowDataBind("OrgListView");
                listview.SetSelectFlag(false);
        	},
        	error : function(error){
        		alert("<spring:message code='ezOrgan.t60' />" + xmlHTTP.statusText);
        		xmlDOM = null;
        		
        	}
        });		        	
        
       
    }
    function event_displayUserList() {
        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
            if (g_xmlHTTP.statusText == "OK") {
                if (g_xmlHTTP.responseXML.getElementsByTagName("ROW").length == 0)
                    alert("<spring:message code='ezApprovalG.t1161'/>");
                else {
                    document.getElementById("OrgListView").innerHTML = "";
                    var listview = new ListView();
                    listview.SetID("OrganListView");
                    listview.SetMulSelectable(true);
                    listview.SetRowOnDblClick("OrganList_rowdblclick");
                    listview.DataSource(loadXMLString(OrganListHeader.innerHTML.toUpperCase()));
                    listview.DataBind("OrgListView");

                    listview.DataSource(g_xmlHTTP.responseXML);
                    listview.RowDataBind("OrgListView");
                    listview.SetSelectFlag(false);
                }
            }
            else
                alert("<spring:message code='ezApprovalG.t1162'/>" + g_xmlHTTP.statusText);

            g_xmlHTTP = null;
        }
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
			<WIDTH>70</WIDTH>
		</HEADER>
		<HEADER>
			<NAME><spring:message code='ezApprovalG.t249'/></NAME>
			<WIDTH>100</WIDTH>
		</HEADER>
		<HEADER>
			<NAME><spring:message code='ezApprovalG.t230'/></NAME>
			<WIDTH>100</WIDTH>
		</HEADER>
	</HEADERS>
</LISTVIEWDATA>
</xml>
<!---------------------------------------- 리스트뷰 컨트롤 ---------------------------------------->	
<h1><spring:message code='ezApprovalG.t1155'/></h1>

<table class="content">
	<tr>
	<th><spring:message code='ezApprovalG.t1163'/></th>
		<td><Input Type="radio" name="rdoRecRole" id="rdoRecRole1" value="0" style="margin:3px 0px 5px 3px" onClick="return SwapRoleList()" checked><spring:message code='ezApprovalG.t1164'/><br />
			<Input Type="radio" name="rdoRecRole" id="rdoRecRole2" value="1" style="margin:3px 0px 5px 3px" onClick="return SwapRoleList()"><spring:message code='ezApprovalG.t1165'/></td>
	</tr>
</table>
<table id="DataLayout" style="margin-top:10px">
	<tr id="trRecUserRole">			
		<td style="vertical-align:top"> <h2><spring:message code='ezApprovalG.t1166'/></h2>
			<table>
				<tr>
					<th style="height:30px"><select id="selSearchType">
						<option selected value="displayname"><spring:message code='ezApprovalG.t379'/></option>
						<option value="description"><spring:message code='ezApprovalG.t108'/></option>
						<option value="title"><spring:message code='ezApprovalG.t230'/></option>
					</select>
					<input id="txtKeyword" value="" onKeyPress="txtKeyword_onKeyPress()" style="width:90px"><a class="imgbtn" style="vertical-align:middle"><span onClick="btnSearch_Click()" style="width:40px" ><spring:message code='ezApprovalG.t111'/></span></a></th>
				</tr>
				<tr style="height:2px">
				<td></td>
				</tr>
				<tr> 
					<td><div class="listview">
					<div id="OrgListView" style="overflow:auto; border:0;HEIGHT: 205px; WIDTH: 240px;margin:1px 1px 1px 1px; "></div>
					</div></td>
				</tr>
			</table>
		</td>

		<td style="width:25px;text-align:center"><img id="RecvAdd" border="0" src="/images/arr_right.gif" width="16" height="16" 
						onClick="return AddUser_onclick()"><a><img id="RecvDel" border="0" src="/images/arr_left.gif" width="16" height="16" onClick="return DelUser_onclick()"></a></td>

		<td style="width:200px;vertical-align:top"><h2><spring:message code='ezApprovalG.t1167'/></h2>
		<div class="listview" id ="listview" >
		<div id="SelUserList" style="overflow:auto; border:0;HEIGHT: 237px; WIDTH: 230px;margin:1px 1px 1px 1px;"></div>
		</div></td>
	</tr>
</table>

<div class="btnposition">
<a class="imgbtn"><span id="btnOK" onclick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
<a class="imgbtn"><span id="btnCancel" onclick="return cmdCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>  
</div>

</body>
</html>
