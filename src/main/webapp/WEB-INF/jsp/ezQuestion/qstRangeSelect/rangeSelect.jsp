<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/myoffice/ezQuestion/controls/ListView_list.js"></script>
		<script type="text/javascript" src="/myoffice/ezQuestion/controls/TreeView.js"></script>
		<script type="text/javascript">
        	var xmlHttp_Depttree = createXMLHttpRequest();
        	var xmlHttp_UserList = createXMLHttpRequest();
        	var xmlHttp = createXMLHttpRequest();
			var L_BRDID = "${pBrdId}"; 
			var L_ITEMNO = "${pItemNo}"; 
			var g_aChanged = false;
			var g_bChanged = false;
			var g_bTreeLoad = false;
			var bSearch = false;
        	var retArr = new Array();
        	window.onload = function () {
            	var InitData = "";
            	ListviewInit2("DListView", "DeptListView");
            	ListviewInit2("MListView", "MemberListView");

                if ((window.opener != null) && (!window.opener.closed)) {
                    InitData = window.opener.GetRangeValue();
                }
            	on_view();
            	ListviewInit();
            	if (InitData != "") {
                	InitRangeData(InitData);
            	}
        	}
        	window.onunload = function () {
        	}
        	function ListviewInit2(pID, pListView) {
            	var listview = new ListView();
            	listview.SetID(pID);
            	listview.SetHeightFree(true);
            	listview.SetSelectFlag(false);
            	listview.SetMulSelectable(true);
            	if(pListView == "DeptListView")
	                listview.SetRowOnDblClick("delete_admin");
    	        else if (pListView == "MemberListView")
        	        listview.SetRowOnDblClick("delete_member");
            		listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
            		listview.DataBind(pListView);
            		listview.RowDataBind();
        	}

        	function ListviewInit() {
            	var listview = new ListView();
            	listview.SetID("Organ");
            	listview.SetSelectFlag(false);
            	listview.SetMulSelectable(true);
            	listview.SetRowOnDblClick("ListViewNodeDblClick");
            	listview.DataSource(listviewheader2);
            	listview.DataBind("OrganListView");
        	}
        	function cancel_onclick() {
            	window.close();
        	}
        	
        	function close_onclick() {
            	if (g_aChanged == true || g_bChanged == true)
                	if (confirm("<spring:message code='ezQuestion.t185' />")) {
                    	SetRange();
                    	return;
                	}
            	window.returnValue = "NO"
            	window.close();
        	}
    		function check_length(chkstr, maxlength, fieldname) {
        		var length = 0;
        		var i;
        		for (i = 0; i < chkstr.length; i++)
            		if (chkstr.charCodeAt(i) > 256)
                		length = length + 2;
            		else
                		length++;
        		if (length > maxlength) {
            		alert(fieldname + "<spring:message code='ezQuestion.t14' />" + maxlength + "<spring:message code='ezQuestion.t15' />");
            		return false
        		}
        		return true;
    		}
    		function add_list() {
        		if (TreeView.selectedNode) {
            		lastindex = deptlist.length;
            		if (TreeView.selectedNode.DATA3 == "user") {
                		add_member();
            		} else {
                		add_dept();
            		}
        		}
    		}
    		function add_dept() {
        		g_aChanged = true;
        		var treeView = new TreeView();
        		treeView.LoadFromID("FromTreeView");
        		var nodeIdx = treeView.GetSelectNode();
        		if (nodeIdx != null) {
            		var _listview = new ListView();
            		_listview.LoadFromID("DListView");
            		var arrRows = _listview.GetDataRows();
            		for (count2 = 0; count2 < arrRows.length; count2++) {
                		if (nodeIdx.GetNodeData("CN") == arrRows[count2].getAttribute("CN")) {
                    		alert("<spring:message code='ezQuestion.t18' />");
                    		return;
                		}
            		}
            		pparsingXML2 = "";
            		pparsingXML = "";
            		pparsingXML2 = "<LISTVIEWDATA><ROWS>";
            		pparsingXML = pparsingXML + "<ROW><CELL><CN><![CDATA[" + nodeIdx.GetNodeData("CN") + "]]></CN>";
            		pparsingXML = pparsingXML + "<DISPLAYNAME1><![CDATA[" + nodeIdx.GetNodeData("DISPLAYNAME1") + "]]></DISPLAYNAME1>";
            		pparsingXML = pparsingXML + "<DISPLAYNAME2><![CDATA[" + nodeIdx.GetNodeData("DISPLAYNAME2") + "]]></DISPLAYNAME2>";
            		pparsingXML = pparsingXML + "<VALUE><![CDATA[" + nodeIdx.GetNodeData("VALUE") + "]]></VALUE></CELL></ROW>";
            		pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA>";
            		Resultxml = loadXMLString(pparsingXML2);
	
    		        var listview = new ListView();
		            listview.LoadFromID("DListView");

		            var MaxID = 0;
            		var InitTr = listview.GetDataRows();
            		var MaxCntNum = 0;
            		for (var j = 0  ; j < InitTr.length  ; j++) {
                		var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                		if (MaxID < curnum) {
                    		MaxID = curnum;
                    		MaxCntNum = j;
                		}
            		}

		            var objTr = listview.AddRow(InitTr.length);
        		    if (MaxCntNum != 0)
		                MaxCntNum = MaxCntNum + 1;
            		SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
            		listview.AddDataRow(objTr, Resultxml);
		            document.getElementById("DeptListView").className = "receiver_list";
        		    var _tdlength = document.getElementById("DeptListView").getElementsByTagName("TD").length;
            		for (var y = 0; y < _tdlength; y++) {
                		document.getElementById("DeptListView").getElementsByTagName("TD")[y].style.textOverflow = "";
                		document.getElementById("DeptListView").getElementsByTagName("TD")[y].style.overflow = "";
            		}
		        }
    		}
    		function CheckIfExists(pList, pCN) {
        		for (var i = 0; i < pList.length; i++) {
            		if (pCN == pList[i].value.split("\t")[0]) return true;
        		}
        		return false;
    		}
    		function delete_admin() {
        		var selList = new ListView();
        		selList.LoadFromID("DListView");
        		var arrRows = selList.GetSelectedRows();
        		var strName = "";
        		for (var i = 0; i < arrRows.length; i++) {
            		selList.DeleteRow(arrRows[i].id);
        		}
    		}
    		function add_member() {
        		g_bChanged = true;
        		var organListview = new ListView();
        		organListview.LoadFromID("Organ");
        		var length = organListview.GetSelectedRows().length;
        		for (count1 = 0; count1 < length; count1++) {
            		var selRow = organListview.GetSelectedRows()[count1];
            		if (selRow) {
			            var _listview = new ListView();
			            _listview.LoadFromID("MListView");
			            var arrRows = _listview.GetDataRows();
                		for (count2 = 0; count2 < arrRows.length; count2++) {
                    		if (selRow.getAttribute("DATA2") == arrRows[count2].getAttribute("CN")) {
                        		alert("<spring:message code='ezQuestion.t18' />");
                    		return;
                		}
            		}
            		pparsingXML2 = "";
            		pparsingXML = "";
            		pparsingXML2 = "<LISTVIEWDATA><ROWS>";
            		pparsingXML = pparsingXML + "<ROW><CELL><DATA2>" + selRow.getAttribute("DATA2") + "</DATA2>";
            		pparsingXML = pparsingXML + "<DATA4>" + selRow.getAttribute("DATA4") + "</DATA4>";
            		pparsingXML = pparsingXML + "<DATA5>" + selRow.getAttribute("DATA5") + "</DATA5>";
            		pparsingXML = pparsingXML + "<VALUE>" + selRow.cells[0].innerText + "</VALUE></CELL></ROW>";
            		pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA>";
            		Resultxml = loadXMLString(pparsingXML2);

		            var listview = new ListView();
            		listview.LoadFromID("MListView");

		            var MaxID = 0;
        		    var InitTr = listview.GetDataRows();
            		var MaxCntNum = 0;
            		for (var j = 0  ; j < InitTr.length  ; j++) {
                		var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                		if (MaxID < curnum) {
                    		MaxID = curnum;
                    		MaxCntNum = j;
                		}
            		}

		            var objTr = listview.AddRow(InitTr.length);
        		    if (MaxCntNum != 0)
		                MaxCntNum = MaxCntNum + 1;
            		SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
            		listview.AddDataRow(objTr, Resultxml);

		            document.getElementById("MemberListView").className = "receiver_list";
        		    var _tdlength = document.getElementById("MemberListView").getElementsByTagName("TD").length;
            		for (var y = 0; y < _tdlength; y++) {
                		document.getElementById("MemberListView").getElementsByTagName("TD")[y].style.textOverflow = "";
                		document.getElementById("MemberListView").getElementsByTagName("TD")[y].style.overflow = "";
					}
				}
			}
		}
    	function delete_member() {
        	var selList = new ListView();
        	selList.LoadFromID("MListView");
        	var arrRows = selList.GetSelectedRows();
        	var strName = "";
        	for (var i = 0; i < arrRows.length; i++) {
	            selList.DeleteRow(arrRows[i].id);
        	}
    	}
    	function on_view() {
	        var strQuery = "<DATA><DEPTID>${userInfoDeptCode}</DEPTID><TOPID>Top</TOPID><PROP>DisPlayName</PROP></DATA>"; 
    	    xmlHttp_Depttree = null;
	        xmlHttp_Depttree = createXMLHttpRequest();
    	    xmlHttp_Depttree.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	        xmlHttp_Depttree.onreadystatechange = event_getDeptFullTree;
        	xmlHttp_Depttree.send(strQuery);
    	}
    	function RequestData(pNodeID, pTreeID) {
	        var TreeIdx = pNodeID;
        	var treeNode = new TreeNode();
        	treeNode.LoadFromID(TreeIdx);
        	var deptID = treeNode.GetNodeData("CN");
        	GetDeptSubTreeInfo(deptID, TreeIdx);
    	}
    	function GetDeptSubTreeInfo(deptID, TreeIdx) {
	        var xmlHTTP = createXMLHttpRequest();
    	    var xmlRtn = createXmlDom();
        	var xmlpara = createXmlDom();
        	var objNode;
        	createNodeInsert(xmlpara, objNode, "DATA");
        	createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
        	createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;DisplayName");
        	xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
        	xmlHTTP.send(xmlpara);
        	xmlRtn = loadXMLString(xmlHTTP.responseText);
        	if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
            	if (CrossYN()) {
	                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
    	        }
        	    else {
            	    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
            	}
        	}
        	var treeView = new TreeView();
        	treeView.LoadFromID("FromTreeView");
        	treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
    	}
    	function TreeViewNodeClick() {
	        var treeView = new TreeView();
    	    treeView.LoadFromID("FromTreeView");
	        var nodeIdx = treeView.GetSelectNode();
    	    displayUserList(nodeIdx.GetNodeData("CN"));
    	}
    	function displayUserList(DeptID) {
	        var xmlDoc = createXmlDom();
        	var objNode;
        	createNodeInsert(xmlDoc, objNode, "DATA");
        	createNodeAndInsertText(xmlDoc, objNode, "DEPTID", DeptID);
        	createNodeAndInsertText(xmlDoc, objNode, "CELL", "displayname;title;description");
        	createNodeAndInsertText(xmlDoc, objNode, "PROP", "displayname");
        	createNodeAndInsertText(xmlDoc, objNode, "TYPE", "user");
        	xmlHttp_UserList = null;
        	xmlHttp_UserList = createXMLHttpRequest();
        	xmlHttp_UserList.open("POST", "/ezOrgan/getDeptMemberList.do", true);
        	xmlHttp_UserList.onreadystatechange = event_displayUserList;
        	xmlHttp_UserList.send(xmlDoc);
    	}
    	function event_displayUserList() {
	        if (xmlHttp_UserList != null && xmlHttp_UserList.readyState == 4) {
    	        if (xmlHttp_UserList.statusText == "OK") {
                	document.getElementById("OrganListView").innerHTML = "";
                	var listview = new ListView();
                	listview.SetID("Organ");
                	listview.SetSelectFlag(false);
                	listview.SetMulSelectable(true);
                	var xmlDoc2 = createXmlDom();
                	xmlDoc2 = xmlHttp_UserList.responseXML.getElementsByTagName("LISTVIEWDATA")[0].appendChild(SelectNodes(loadXMLString(listviewheader2.innerHTML.toUpperCase()), "LISTVIEWDATA/HEADERS")[0]);
                	listview.SetRowOnDblClick("ListViewNodeDblClick");
                	listview.DataSource(xmlHttp_UserList.responseXML.getElementsByTagName("LISTVIEWDATA")[0]);
                	listview.DataBind("OrganListView");
            	}
            	else
	                alert("<spring:message code='ezQuestion.t21' />" + xmlHttp_UserList.statusText)
    	        xmlHttp_UserList = null;
	        }
	    }
    	function cnsearch_press(e) {
	        var keyCode = e.keyCode ? e.keyCode : e.which;
    	    if (keyCode == "13") {
        	    cnsearch_click();
        	}
    	}
	    var checkname2_cross_dialogArguments = new Array();
    	function cnsearch_click() {
        	if (cnkeyword.value == "") {
            	alert("<spring:message code='ezQuestion.t22' />");
            	cnkeyword.focus();
            	return;
        	}
        	var count;
        	var adCount = 0;
        	var xmlDOM = createXmlDom();
        	var objNode;
        	createNodeInsert(xmlDOM, objNode, "DATA");
        	createNodeAndInsertText(xmlDOM, objNode, "SEARCH", "displayname::" + cnkeyword.value);
        	createNodeAndInsertText(xmlDOM, objNode, "CELL", "company;description;title;displayname;mail");
        	createNodeAndInsertText(xmlDOM, objNode, "PROP", "department;displayname");
        	createNodeAndInsertText(xmlDOM, objNode, "TYPE", "user");
        	try {
            	xmlHttp_UserList = null;
            	xmlHttp_UserList = createXMLHttpRequest();
            	xmlHttp_UserList.open("POST", "/ezOrgan/getSearchList.do", false);
            	xmlHttp_UserList.send(xmlDOM);
            	if (xmlHttp_UserList.statusText != "OK") {
                	alert("<spring:message code='ezQuestion.t23' />" + xmlHttp_UserList.statusText);
                	xmlDOM = null;
                	xmlHttp_UserList = null;
            	}
            	else {
                	xmlDOM = null;
                	xmlDOM = createXmlDom();
                	xmlDOM = xmlHttp_UserList.responseXML;
                	var rows = SelectNodes(xmlDOM, "ROW");
                	adCount = rows.length;
            	}
        	}
        	catch (e) {
            	alert("<spring:message code='ezQuestion.t23' />" + e.description);
            	xmlDOM = null;
            	return;
        	}
        	finally {
            	xmlHttp_UserList = null;
        	}
        	if (adCount == 0) {
	            alert("<spring:message code='ezQuestion.t24' />");
    	        return;
	        }
    	    else if (adCount == 1) {
        	    bSearch = true;
            	var strQuery = "<DATA><DEPTID>" + getNodeText(GetElementsByTagName(xmlDOM, "DATA3")[0]) + "</DEPTID><TOPID>Top</TOPID><PROP>DisPlayName</PROP></DATA>";
            	xmlHttp_Depttree = null;
            	xmlHttp_Depttree = createXMLHttpRequest();
            	xmlHttp_Depttree.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
            	xmlHttp_Depttree.onreadystatechange = event_getDeptFullTree;
            	xmlHttp_Depttree.send(strQuery);
        	}
        	else {
	            if (!CrossYN()) {
    	            var rgParams = new Array();
        	        rgParams["addrBook"] = xmlDOM;
            	    rgParams["deptid"] = "";
                	var feature = GetShowModalPosition(609, 352);
                	window.showModalDialog("/ezEmail/htm/checkName2.do", rgParams, "dialogHeight:352px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken" + feature);
                	if (rgParams["deptid"] != "") {
	                    bSearch = true;
    	                xmlHttp_Depttree = null;
        	            xmlHttp_Depttree = createXMLHttpRequest();
            	        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>DisPlayName</PROP></DATA>";
                	    xmlHttp_Depttree.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
                    	xmlHttp_Depttree.onreadystatechange = event_getDeptFullTree;
                    	xmlHttp_Depttree.send(strQuery);
                	}
            	}
            	else {
	                var rgParams = new Array();
    	            rgParams["addrBook"] = xmlDOM;
        	        rgParams["deptid"] = "";
            	    checkname2_cross_dialogArguments[0] = rgParams;
                	checkname2_cross_dialogArguments[1] = cnsearch_click_Complete;
                	var checkName2_Cross = window.open("/ezEmail/htm/checkName2.do", "checkName2_Cross", GetOpenWindowfeature(609, 352));
                	try { checkName2_Cross.focus(); } catch (e) {
                	}
            	}
        	}
    	}
	    function cnsearch_click_Complete(RetValue) {
    	    if (RetValue["deptid"] != "") {
        	    bSearch = true;
            	xmlHttp_Depttree = null;
            	xmlHttp_Depttree = createXMLHttpRequest();
            	var strQuery = "<DATA><DEPTID>" + RetValue["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>DisPlayName</PROP></DATA>";
            	xmlHttp_Depttree.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
            	xmlHttp_Depttree.onreadystatechange = event_getDeptFullTree;
            	xmlHttp_Depttree.send(strQuery);
        	}
    	}
	    function event_getDeptFullTree() {
    	    if (xmlHttp_Depttree != null && xmlHttp_Depttree.readyState == 4) {
        	    if (xmlHttp_Depttree.statusText == "OK") {
            	    if (!bSearch) {
                	    try {
                    	    window.dialogArguments["window"].opener.top.organview = getXmlString(xmlHttp_Depttree.responseXML);
                    	} catch (e) { }
                	}
                	var treeXML = loadXMLFile("/xml/organtree_config.xml");
                	document.getElementById('TreeView').innerHTML = "";
                	var treeView = new TreeView();
                	treeView.SetConfig(treeXML);
                	treeView.SetID("FromTreeView");
                	treeView.SetUseAgency(true);
                	treeView.SetRequestData("RequestData");
                	treeView.SetNodeClick("TreeViewNodeClick");
                	treeView.DataSource(xmlHttp_Depttree.responseXML);
                	treeView.DataBind("TreeView");
            	}
            	else {
	                alert("<spring:message code='ezQuestion.t25' />" + xmlHttp_Depttree.statusText);
    	        }
            	xmlHttp_Depttree = null;
        	}
    	}
    	function SetRange() {
        	var selList = new ListView();
        	selList.LoadFromID("DListView");
        	var arrRows = selList.GetDataRows();
	        var selList2 = new ListView();
    	    selList2.LoadFromID("MListView");
	        var arrRows2 = selList2.GetDataRows();
    	    if (arrRows.length + arrRows2.length > 0) {
        	    SaveRangeACL();
            	window.opener.updateParent("set_Target", 1, "selectedIndex");
            	window.opener.updateParent("hidTarget", "1", "value");
            	window.opener.updateParent("select_YN", "YES", "value");
            	window.opener.updateParent("RangeXMLStr", MakeXml_Range(), "value");
            	window.opener.updateParent("item_no", L_ITEMNO, "value");
            	window.opener.closeWindow();
        	}
        	else {
            	window.opener.updateParent("set_Target", 0, "selectedIndex");
            	window.opener.updateParent("hidTarget", "0", "value");
            	window.opener.updateParent("select_YN", "NO", "value");
            	window.opener.updateParent("RangeXMLStr", "", "value");
            	window.opener.updateParent("item_no", L_ITEMNO, "value");
            	window.opener.closeWindow();
        	}
    	}
    	function GetItemNo() {
	        var xmldom = createXmlDom();
    	    var xmlHttp = createXMLHttpRequest();
        	var szUrl = "../callGetItemSeqXML.do?brd_id=" + L_BRDID;
        	xmlHttp.open("POST", szUrl, false);
        	xmlHttp.send(xmldom)
        	if (getXmlString(xmlHttp.responseXML) != "") {
            	xmlRtn = xmlHttp.responseXML;
            	if (SelectSingleNodeValueNew(xmlRtn, "RESULT/DATA") == "OK") {
                	L_ITEMNO = SelectSingleNodeValueNew(xmlRtn, "RESULT/ITEMNO");
                	return true;
            	}
        	}
        	else {
            	alert("<spring:message code='ezQuestion.t27' />");
            	return false;
        	}
    	}
    	function SaveRangeACL() {
        	if (L_ITEMNO == "") {
	            if (GetItemNo() != true) {
     	           alert("<spring:message code='ezQuestion.t28' />");
        	        return;
            	}
            	window.returnValue = L_ITEMNO;
        	}
        	var xmlDoc = createXmlDom();
        	var objNode;
        	var Rootnode = createNodeInsert(xmlDoc, objNode, "PARA");
        	var DeptNode = createNodeAndAppandNode(xmlDoc, Rootnode, objNode, "DEPT");
	        var selList = new ListView();
    	    selList.LoadFromID("DListView");
        	var arrRows = selList.GetDataRows();
	        var selList2 = new ListView();
    	    selList2.LoadFromID("MListView");
        	var arrRows2 = selList2.GetDataRows();

        	for (var i = 0; i < arrRows.length; i++) {
	            var CurrID = arrRows[i].getAttribute("CN");// deptlist[i].value.split("\t")[0];
    	        var CurrNM = arrRows[i].getAttribute("DISPLAYNAME1");// MakeXMLString(deptlist[i].value.split("\t")[1]);
        	    var CurrNM2 = arrRows[i].getAttribute("DISPLAYNAME2");// MakeXMLString(deptlist[i].value.split("\t")[2]);
            	var DeptNode_sub = createNodeAndAppandNodeText(xmlDoc, DeptNode, objNode, "DATA", CurrID);
            	SetAttribute(DeptNode_sub, "id", CurrID);
            	SetAttribute(DeptNode_sub, "nm", CurrNM);
            	SetAttribute(DeptNode_sub, "nm2", CurrNM2);
        	}
        	var UserNode = createNodeAndAppandNode(xmlDoc, Rootnode, objNode, "MEMBER");
        	for (var j = 0; j < arrRows2.length; j++) {
            	var CurrID = arrRows2[j].getAttribute("DATA2");// memberlist[j].value.split("\t")[0];
            	var CurrNM = arrRows2[j].getAttribute("DATA4"); //MakeXMLString(memberlist[j].value.split("\t")[1]);
            	var CurrNM2 = arrRows2[j].getAttribute("DATA5"); //MakeXMLString(memberlist[j].value.split("\t")[2]);
            	var UserNode_sub = createNodeAndAppandNodeText(xmlDoc, UserNode, objNode, "DATA", CurrID);
            	SetAttribute(UserNode_sub, "id", CurrID);
            	SetAttribute(UserNode_sub, "nm", CurrNM);
            	SetAttribute(UserNode_sub, "nm2", CurrNM2);
        	}
        	createNodeAndInsertText(xmlDoc, objNode, "BRDID", L_BRDID);
        	createNodeAndInsertText(xmlDoc, objNode, "ITEMNO", L_ITEMNO);
        	<%-- createNodeAndInsertText(xmlDoc, objNode, "PcompanyID", "<%=pCompanyID%>"); --%>
        	var szUrl = "callSaveRangeACL.do";
        	xmlHttp = null;
        	xmlHttp = createXMLHttpRequest();
        	xmlHttp.open("POST", szUrl, false);
        	//xmlHttp.onreadystatechange = HandleStateChange;
        	xmlHttp.send(xmlDoc);
    	}
    	function HandleStateChange() {
	        if (xmlHttp.readyState != 4) {
    	        return;
	        }
    	    if (getXmlString(xmlHttp.responseXML) != "") {
        	    xmlRtn = xmlHttp.responseXML;
            	if (SelectSingleNodeValueNew(xmlRtn, "RESULT/DATA") != "-1") {
                	window.returnValue = L_ITEMNO;
                	window.close();
                	return true;
            	}
            	else {
                	alert("<spring:message code='ezQuestion.t27' />");
                	return false;
            	}
        	}
        	else {
            	alert("<spring:message code='ezQuestion.t27' />");
            	return false;
        	}
    	}
    	function ReplaceText(orgStr, findStr, replaceStr) {
        	var re = new RegExp(findStr, "gi");
        	return (orgStr.replace(re, replaceStr));
    	}
	    function MakeXMLString(str) {
    	    str = ReplaceText(str, "&", "&amp;");
        	str = ReplaceText(str, "<", "&lt;");
        	str = ReplaceText(str, ">", "&gt;");
        	str = ReplaceText(str, "'", "&#039;");
        	return str;
    	}
    	function MakeUNXMLString(str) {
        	str = ReplaceText(str, "&amp;", "&");
        	str = ReplaceText(str, "&lt;", "<");
        	str = ReplaceText(str, "&gt;", ">");
        	str = ReplaceText(str, "&#039;", "'");
        	return str;
    	}
    	function ListViewNodeDblClick() {
        	add_member();
    	}
    	function MakeXml_Range() {
        	var xmlDoc = createXmlDom();
        	var objNode;
        	var Rootnode = createNodeInsert(xmlDoc, objNode, "RANGE");
        	var DeptNode = createNodeAndAppandNode(xmlDoc, Rootnode, objNode, "DEPT");
	        var selList = new ListView();
    	    selList.LoadFromID("DListView");
        	var arrRows = selList.GetDataRows();
        	var selList2 = new ListView();
        	selList2.LoadFromID("MListView");
        	var arrRows2 = selList2.GetDataRows();
        	
	        for (var i = 0; i < arrRows.length; i++) {
    	        var CurrID = arrRows[i].getAttribute("CN");
            	var CurrNM = arrRows[i].getAttribute("DISPLAYNAME1");
            	var CurrNM2 = arrRows[i].getAttribute("DISPLAYNAME2");
            	var DeptNode_sub = createNodeAndAppandNodeText(xmlDoc, DeptNode, objNode, "DATA", CurrID);
            	SetAttribute(DeptNode_sub, "id", CurrID);
            	SetAttribute(DeptNode_sub, "nm", CurrNM);
            	SetAttribute(DeptNode_sub, "nm2", CurrNM2);
        	}
        	var UserNode = createNodeAndAppandNode(xmlDoc, Rootnode, objNode, "MEMBER");
        	
        	for (var j = 0; j < arrRows2.length; j++) {
            	var CurrID = arrRows2[j].getAttribute("DATA2");
            	var CurrNM = arrRows2[j].getAttribute("DATA4");
            	var CurrNM2 = arrRows2[j].getAttribute("DATA5");
            	var UserNode_sub = createNodeAndAppandNodeText(xmlDoc, UserNode, objNode, "DATA", CurrID);
            	SetAttribute(UserNode_sub, "id", CurrID);
            	SetAttribute(UserNode_sub, "nm", CurrNM);
            	SetAttribute(UserNode_sub, "nm2", CurrNM2);
        	}
        	return getXmlString(xmlDoc);
    	}
    	function InitRangeData(InitData) {
        	var xmlDoc = createXmlDom();
        	xmlDoc = loadXMLString(InitData);
        	var DeptRows = SelectSingleNodeNew(xmlDoc, "RANGE/DEPT");
        	
        	if (DeptRows != null) {
            	var DeptLen = DeptRows.childNodes.length;
            	
            	for (var i = 0; i < DeptLen; i++) {
                	var CurrID = MakeUNXMLString(GetAttribute(DeptRows.childNodes[i], "id"));
                	var CurrNM = MakeUNXMLString(GetAttribute(DeptRows.childNodes[i], "nm"));
                	var CurrNM2 = MakeUNXMLString(GetAttribute(DeptRows.childNodes[i], "nm2"));
                	//lastindex = deptlist.length;
                	var pVaule = "";
                	
                	<%-- if ("<%= userinfo.lang %>" == "1") {
                    	pVaule = CurrNM;
                	}
                	else {
	                    pVaule = CurrNM2;
					} --%>
                	//newoption = new Option(pVaule,
                	//    CurrID + "\t" + CurrNM + "\t" + CurrNM2);
                	//deptlist.options[lastindex] = newoption;
	                pparsingXML2 = "";
    	            pparsingXML = "";
        	        pparsingXML2 = "<LISTVIEWDATA><ROWS>";
                	pparsingXML = pparsingXML + "<ROW><CELL><CN><![CDATA[" + CurrID + "]]></CN>";
                	pparsingXML = pparsingXML + "<DISPLAYNAME1><![CDATA[" + CurrNM + "]]></DISPLAYNAME1>";
                	pparsingXML = pparsingXML + "<DISPLAYNAME2><![CDATA[" + CurrNM2 + "]]></DISPLAYNAME2>";
                	pparsingXML = pparsingXML + "<VALUE><![CDATA[" + pVaule + "]]></VALUE></CELL></ROW>";
                	pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA>";
                	Resultxml = loadXMLString(pparsingXML2);
	                var listview = new ListView();
    	            listview.LoadFromID("DListView");

        	        var MaxID = 0;
            	    var InitTr = listview.GetDataRows();
                	var MaxCntNum = 0;
                	for (var j = 0  ; j < InitTr.length  ; j++) {
                    	var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    	if (MaxID < curnum) {
                        	MaxID = curnum;
                        	MaxCntNum = j;
                    	}
                	}
	                var objTr = listview.AddRow(InitTr.length);
    	            if (MaxCntNum != 0)
        	            MaxCntNum = MaxCntNum + 1;
            	    SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
                	listview.AddDataRow(objTr, Resultxml);

                	document.getElementById("DeptListView").className = "receiver_list";
                	var _tdlength = document.getElementById("DeptListView").getElementsByTagName("TD").length;
                	for (var y = 0; y < _tdlength; y++) {
	                    document.getElementById("DeptListView").getElementsByTagName("TD")[y].style.textOverflow = "";
    	                document.getElementById("DeptListView").getElementsByTagName("TD")[y].style.overflow = "";
        	        }
	            }
        	}
        	var UserRows = SelectSingleNodeNew(xmlDoc, "RANGE/MEMBER");
        	if (UserRows != null) {
	            var UserLen = UserRows.childNodes.length;
	            for (var i = 0; i < UserLen; i++) {
    	            var CurrID = MakeUNXMLString(GetAttribute(UserRows.childNodes[i], "id"));
        	        var CurrNM = MakeUNXMLString(GetAttribute(UserRows.childNodes[i], "nm"));
            	    var CurrNM2 = MakeUNXMLString(GetAttribute(UserRows.childNodes[i], "nm2"));
	                //lastindex = memberlist.length;
    	            var pVaule = "";
        	       <%--  if ("<%= userinfo.lang %>" == "1") {
            	        pVaule = CurrNM;
                	}
                	else {
	                    pVaule = CurrNM2;
    	            } --%>
        	        //newoption = new Option(pVaule,
            	    //    CurrID + "\t" + CurrNM + "\t" + CurrNM2);
                	//memberlist.options[lastindex] = newoption;
	                var _listview = new ListView();
    	            _listview.LoadFromID("MListView");
	                pparsingXML2 = "";
    	            pparsingXML = "";
        	        pparsingXML2 = "<LISTVIEWDATA><ROWS>";
            	    pparsingXML = pparsingXML + "<ROW><CELL><DATA2><![CDATA[" + CurrID + "]]></DATA2>";
                	pparsingXML = pparsingXML + "<DATA4><![CDATA[" + CurrNM + "]]></DATA4>";
                	pparsingXML = pparsingXML + "<DATA5><![CDATA[" + CurrNM2 + "]]></DATA5>";
                	pparsingXML = pparsingXML + "<VALUE><![CDATA[" + pVaule + "]]></VALUE></CELL></ROW>";
                	pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA>";
                	Resultxml = loadXMLString(pparsingXML2);
	                var listview = new ListView();
    	            listview.LoadFromID("MListView");
	                var MaxID = 0;
    	            var InitTr = listview.GetDataRows();
        	        var MaxCntNum = 0;
            	    for (var j = 0  ; j < InitTr.length  ; j++) {
                	    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                    	if (MaxID < curnum) {
	                        MaxID = curnum;
    	                    MaxCntNum = j;
        	            }
            	    }

                	var objTr = listview.AddRow(InitTr.length);
                	if (MaxCntNum != 0)
                    	MaxCntNum = MaxCntNum + 1;
                	SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
                	listview.AddDataRow(objTr, Resultxml);

                	document.getElementById("MemberListView").className = "receiver_list";
                	var _tdlength = document.getElementById("MemberListView").getElementsByTagName("TD").length;
                	for (var y = 0; y < _tdlength; y++) {
                    	document.getElementById("MemberListView").getElementsByTagName("TD")[y].style.textOverflow = "";
                    	document.getElementById("MemberListView").getElementsByTagName("TD")[y].style.overflow = "";
                	}
	            }
	        }
    	}
		</script>
	</head>
	<body class="popup"> 
		<xml id="listviewheader" style="display:none">
    		<LISTVIEWDATA>
        		<HEADERS>
            		<HEADER>
                		<NAME><spring:message code='ezQuestion.t8' /></NAME>
                		<WIDTH>50</WIDTH>
            		</HEADER>
            		<HEADER>
                		<NAME><spring:message code='ezQuestion.t4' /></NAME>
                		<WIDTH>50</WIDTH>
            		</HEADER>
        		</HEADERS>
    		</LISTVIEWDATA>
		</xml>
		<xml id="listviewheader2" style="display:none">
  		<LISTVIEWDATA>
    		<HEADERS>
      		<HEADER>
        		<NAME><spring:message code='ezQuestion.t8' /></NAME>
        		<WIDTH>50</WIDTH>
      		</HEADER>
      		<HEADER>
        		<NAME><spring:message code='ezQuestion.t4' /></NAME>
        		<WIDTH>70</WIDTH>
      		</HEADER>
      		<HEADER>
        		<NAME><spring:message code='ezQuestion.t5' /></NAME>
        		<WIDTH>60</WIDTH>
      		</HEADER>
    		</HEADERS>
  		</LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezQuestion.t7' /></h1>
		<table> 
    		<tr> 
        		<td width="195" valign="top">
            		<h2><spring:message code='ezQuestion.t33' /></h2>
            		<div style="OVERFLOW-Y:auto;OVERFLOW-X:auto;WIDTH:280px;HEIGHT:270px;BACKGROUND-COLOR:#ffffff;" id="TreeView" class="box"></div>
        		</td>
        		<td width="30" align="center" valign="middle"> 
            		<div><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onclick="add_dept()" style="cursor:pointer"></div>
            		<div><img src="/images/arr_left.gif" width="16" height="16" vspace="3" onclick="delete_admin()" style="cursor:pointer"></div>
        		</td>
        		<td valign="top">
            		<h2><spring:message code='ezQuestion.t35' /></h2>
             		<div class="listview" style="margin-top:5px;margin-bottom:5px">
		                    <div id="DeptListView" style="OVERFLOW:auto;WIDTH:220px;HEIGHT:270px;border:0"></div>
                	</div>
            		<%--<div>
                		<select id="deptlist" style="WIDTH:220px; HEIGHT:270px" ondblclick='delete_admin()' NAME="select" multiple>
                    		<%=strDeptACL%>
                		</select>
            		</div>--%>
        		</td>
			</tr>
			<tr>
        		<td>
            		<div class="listview" style="margin-top:5px;margin-bottom:5px">
                		<div id="OrganListView" style="OVERFLOW:auto;WIDTH:274px;HEIGHT:260px;border:0"></div>
            		</div>
        		</td> 
        		<td width="30" align="center" valign="middle"> 
            		<div><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onclick="add_member()" style="cursor:pointer"></div>
            		<div><img src="/images/arr_left.gif" width="16" height="16" vspace="3" onclick="delete_member()" style="cursor:pointer"></div>
        		</td> 
        		<td valign="top">
            		<h2><spring:message code='ezQuestion.t36' /></h2>
            		<div class="listview" style="margin-top:5px;margin-bottom:5px">
                    	<div id="MemberListView" style="OVERFLOW:auto;WIDTH:220px;HEIGHT:240px;border:0"></div>
                	</div>
            		<%--<div>
                		<select id="memberlist" name="memberlist" id="select2" style="WIDTH:220px; HEIGHT:240px" ondblclick='delete_member()' multiple>
                    		<%=strMemberACL%>
                		</select>
            		</div>--%>
        		</td> 
    		</tr>
			<tr>
        		<td>
            		<input id="cnkeyword" onkeypress="cnsearch_press(event)" style="WIDTH:130px" />
            		<%--<input id = "cnkeybtn" onclick="cnsearch_click()" type="button" value="<%=RM.GetString("t34")%>" class="imginput" style="cursor:pointer" /> --%>
            		<a class="imgbtn"  = "cnkeybtn" onclick="cnsearch_click()"  ><span><spring:message code='ezQuestion.t34' /></span></a>
        		</td>
        		<td></td>
        		<td>         
            		<div class="btnposition">
                		<a class="imgbtn" name="Submit" onClick="SetRange()" ><span><spring:message code='ezQuestion.t37' /></span></a>
                		<a class="imgbtn" name="Submit2" onClick="close_onclick()" ><span><spring:message code='ezQuestion.t38' /></span></a>
            		</div>
        		</td>
    		</tr>
		</table> 
	</body>
</html>