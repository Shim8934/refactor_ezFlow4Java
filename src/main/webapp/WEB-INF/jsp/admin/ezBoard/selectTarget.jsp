<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t16" /></title>
	    <link rel="stylesheet" href='/css/organ_tree.css' type="text/css" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/address_tree.js"></script>	    
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js?ver_0.1"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
		<script type="text/javascript" language="javascript">
			var m_orgImg = { "normal": "/images/tab_org1.gif", "select": "/images/tab_org.gif" };
		    var m_dlImg = { "normal": "/images/tab_dl1.gif", "select": "/images/tab_dl.gif" };
		    var m_contactImg = { "normal": "/images/tab_addr1.gif", "select": "/images/tab_addr.gif" };
		    var m_tabDialogState = { "org": "select", "contact": "normal", "dl": "normal" };
		    var m_receiverTitleList;
		    var m_receiverWindowList;
		    var m_titleNoneSelectedColor = "#F6F6F6";
		    var m_titleSelectedColor = "#ffffff";
		    var m_selectedWindow = null;
		    var m_selectedTree = null;
		    var g_fnaddReceiver;
		    var g_xmlHTTP = null;
		    var bSearch = false;		    
		    var topid = "<c:out value='${topid}'/>";
		    var userLang = "<c:out value='${userLang}'/>";
		    var ReturnFunction;
		    var RetValue;
		    
		    window.onload = function () {
				try {
		            RetValue = parent.selecttarget_cross_dialogArguments[0];
		            ReturnFunction = parent.selecttarget_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.selecttarget_cross_dialogArguments[0];
		                ReturnFunction = opener.selecttarget_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }

		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                var input = document.getElementsByTagName("input");
		                for (var i = 0; i < input.length; i++) {
		                    if (input[i].getAttribute("type") == "text")
		                        KeEventControl(input[i]);
		                }
		            }
		        } catch (e) { }

		        m_receiverTitleList = new Array(ToTitle);
		        m_receiverWindowList = new Array(ListViewMsgTo);
		        
		        var listviewheader = loadXMLString("<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code='ezBoard.t35'/></NAME><WIDTH>100</WIDTH></HEADER></HEADERS></LISTVIEWDATA>")
		        var listview = new ListView();
		        listview.SetID("ListViewMsgToView");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnClick("SelectReceiverWindow");
		        listview.SetRowOnDblClick("DeleteReceiver");
		        listview.DataSource(listviewheader);
		        listview.DataBind("ListViewMsgTo");
		        
				var listviewheader2 = loadXMLString("<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code='ezBoard.t36' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code='ezBoard.t9' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code='ezBoard.t37' /></NAME><WIDTH>80</WIDTH></HEADER><HEADER><NAME><spring:message code='ezBoard.t38' /></NAME><WIDTH>100</WIDTH></HEADER></HEADERS></LISTVIEWDATA>");
		        var listview5 = new ListView();
		        listview5.SetID("OrganList");
		        listview5.SetMulSelectable(false);
		        listview5.SetRowOnDblClick("ListViewNodeDblClick");
		        listview5.DataSource(listviewheader2);
		        listview5.DataBind("OrganListView");

		        applyCurrentData();

		        g_xmlHTTP = createXMLHttpRequest();
		        var strQuery = "<DATA><DEPTID>" + "${deptID}" + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>mail;displayName</PROP></DATA>";
		        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		        g_xmlHTTP.send(strQuery);

		        m_selectedTree = TreeView;
		        SelectReceiverWindow(ToTitle, ListViewMsgTo);

		        admin_OK.disabled = true;
		        admin_NO.disabled = true;
		        admin_OK.checked = false;
		        admin_NO.checked = true;
			};
			
			function TreeViewNodeClick(pNodeID, pTreeID) {						        	
	            var treenode = new TreeNode();
	            treenode.LoadFromID(pNodeID);
	            nodeIdx = treenode.GetNodeData("CN");
	            displayUserList(nodeIdx);
	        }
		        
		    function displayUserList(DeptID) {
		    	var xmlpara = createXmlDom();		        
		    	var listviewheader2 = loadXMLString("<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code='ezBoard.t36' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code='ezBoard.t9' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code='ezBoard.t37' /></NAME><WIDTH>80</WIDTH></HEADER><HEADER><NAME><spring:message code='ezBoard.t38' /></NAME><WIDTH>100</WIDTH></HEADER></HEADERS></LISTVIEWDATA>");
		    	
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : "displayname;description;title;telephonenumber", prop : "mail;displayName;description;title", type : "user"},
		        	success : function(result){		 
		        		result = loadXMLString(result);
		        		document.getElementById("OrganListView").innerHTML = "";
		                var listview = new ListView();
		                listview.SetID("OrganList");
		                listview.SetSelectFlag(false);
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("ListViewNodeDblClick");
		                listview.DataSource(listviewheader2);
		                listview.DataBind("OrganListView");
		                listview.DataSource(result);
		                listview.RowDataBind();
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezBoard.t22'/>" + error);	
		        	}
		        });		            
		    }
		    
		    function RequestData(pNodeID, pTreeID) {
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        var deptID = treeNode.GetNodeData("CN");

		        GetDeptSubTreeInfo(deptID, TreeIdx);
		    }
			
			function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
		                if (!bSearch) {
		                    try {
		                        RetValue["window"].opener.top.organview = g_xmlHTTP.responseText;
		                    } catch (e) { }
		                }
		                var xmlDom = loadXMLFile("/xml/common/organtree_config3.xml");
		                document.getElementById('TreeView').innerHTML = "";

		                var treeView = new TreeView();
		                treeView.SetConfig(xmlDom);
		                treeView.SetID("TreeViewList");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("RequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
		                treeView.DataBind("TreeView");
		            }
		            else {
		                alert("<spring:message code='ezBoard.t17' />" + g_xmlHTTP.statusText);
		                g_xmlHTTP = null;
		            }
		        }
		    }

		    function applyCurrentData() {
		    	var xmldoc;
		        xmldoc = loadXMLString(RetValue["selectTargetListXML"]);
		        var i = 0;
		        var username, useremail;
		        var username2, boardGroupACL, dept;
		        for (i = 0; i < GetElementsByTagName(xmldoc, "CN").length; i++) {
		            username = getNodeText(GetElementsByTagName(xmldoc, "NAME")[i]);
		            username2 = getNodeText(GetElementsByTagName(xmldoc, "NAME2")[i]);
		            useremail = getNodeText(GetElementsByTagName(xmldoc, "CN")[i]);
		            boardGroupACL = getNodeText(GetElementsByTagName(xmldoc, "GROUP")[i]);
		            dept = getNodeText(GetElementsByTagName(xmldoc, "DEPT")[i]);
		            pparsingXML2 = "";
		            pparsingXML = "";
		            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + useremail + "</DATA1>";
		            pparsingXML = pparsingXML + "<DATA2><![CDATA[" + username + "]]></DATA2>";
		            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + username2 + "]]></DATA3>";
		            pparsingXML = pparsingXML + "<DATA4><![CDATA[" + dept + "]]></DATA4>";
		            pparsingXML = pparsingXML + "<DATA5><![CDATA[" + boardGroupACL + "]]></DATA5>";
		            if (userLang == "" || userLang == "1")
		                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + username + "]]></VALUE>";
		            else
		                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + username2 + "]]></VALUE>";
		            pparsingXML = pparsingXML + "</CELL></ROW>";
		            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";

		            Resultxml = loadXMLString(pparsingXML2);

		            var listview = new ListView();
		            listview.LoadFromID("ListViewMsgToView");

		            var MaxID = 0;
		            var InitTr = listview.GetDataRows();

		            for (var j = 0  ; j < InitTr.length  ; j++) {
		                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                if (MaxID < curnum)
		                    MaxID = curnum;
		            }
		            var objTr = listview.AddRow(MaxID);
		            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
		            listview.AddDataRow(objTr, Resultxml);
		        }
		    }	    
			
		    function GetDeptSubTreeInfo(deptID, TreeIdx) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlRtn = createXmlDom();
		        
		        var strQuery = "<DATA><DEPTID>" + deptID + "</DEPTID><PROP>mail;displayName</PROP></DATA>";
		        
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(strQuery);

		        xmlRtn = loadXMLString(xmlHTTP.responseText);

		        var treeView = new TreeView();
		        treeView.LoadFromID("TreeViewList");
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
		    
		    function SelectReceiverWindow(Title, selectedWindow) {
		        for (var count = 0; count < m_receiverTitleList.length; count++) {
		            m_receiverTitleList[count].style.fontWeight = "normal";
		            m_receiverWindowList[count].style.backgroundColor = m_titleNoneSelectedColor;
		            m_receiverWindowList[count].normalColor = m_titleNoneSelectedColor;
		        }
		        ToTitle.style.fontWeight = "bold";
		        ListViewMsgTo.style.backgroundColor = m_titleSelectedColor;
		        ListViewMsgTo.normalColor = m_titleSelectedColor;
		        m_selectedWindow = ListViewMsgTo;
		        if (document.getElementById(Title)) {
		            if (document.getElementById(Title).getAttribute("DATA4") == "DEPT") {
		                admin_OK.disabled = false;
		                admin_NO.disabled = false;
		                var _data5 = document.getElementById(Title).getAttribute("DATA5");
		                
		                if (_data5 == "Y") {
		                    admin_OK.checked = true;
		                    admin_NO.checked = false;
		                } else {
		                    admin_OK.checked = false;
		                    admin_NO.checked = true;
		                }
		            } else {
		                admin_OK.checked = false;
		                admin_OK.disabled = true;
		                admin_NO.checked = true;
		                admin_NO.disabled = true;
		            }
		        }
		    }
		    
		    function DeleteReceiver(pListView) {
		        var listView = new ListView();
		        listView.LoadFromID("ListViewMsgToView");
		        listView.DeleteRow(listView.GetSelectedRows()[0].id);
		    }
		    
		    function ListViewNodeDblClick() {
		        if (m_selectedWindow != null)
		            InsertReceiver(m_selectedWindow);
		    }
		    
		    function InsertReceiver(pListView) {
		        if (m_selectedTree == TreeView) {
		            var pListViewDL = new ListView();      //// ListView 선언
		            pListViewDL.LoadFromID("OrganList");

		            var arrRows = pListViewDL.GetSelectedRows();

		            if (arrRows.length > 0) {
		                var getlistview = new ListView();
		                getlistview.LoadFromID("ListViewMsgToView");
		                var existId = GetAttribute(arrRows[0], "data2");
		                var existName = GetAttribute(arrRows[0], "data7");
		                var strDeptNM = GetAttribute(arrRows[0], "data9");
		                var existName2 = GetAttribute(arrRows[0], "data8");
		                var strDeptNM2 = GetAttribute(arrRows[0], "data10");
		                var bFlag = getlistview.ExistRow("DATA1", existId);
		                if (bFlag) {
		                    alert("<spring:message code='ezBoard.t20' />");
		                    pAddFlag = true;
		                    return;
		                } else {
		                    pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + existId + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2><![CDATA[" + existName + "(" + strDeptNM.trim() + ")" + "]]></DATA2>";
		                    pparsingXML = pparsingXML + "<DATA3><![CDATA[" + existName2 + "(" + strDeptNM2.trim() + ")" + "]]></DATA3>";
		                    pparsingXML = pparsingXML + "<DATA4><![CDATA[PERSON]]></DATA4>";
		                    pparsingXML = pparsingXML + "<DATA5><![CDATA[N]]></DATA5>";
		                    if (userLang == "" || userLang == "1")
		                        pparsingXML = pparsingXML + "<VALUE><![CDATA[" + existName + "(" + strDeptNM.trim() + ")" + "]]></VALUE>";
		                    else
		                        pparsingXML = pparsingXML + "<VALUE><![CDATA[" + existName2 + "(" + strDeptNM2.trim() + ")" + "]]></VALUE>";
		                    pparsingXML = pparsingXML + "</CELL></ROW>";
		                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";

		                    Resultxml = loadXMLString(pparsingXML2);

		                    var listview = new ListView();
		                    listview.LoadFromID("ListViewMsgToView");

		                    var MaxID = 0;
		                    var InitTr = listview.GetDataRows();

		                    for (var j = 0  ; j < InitTr.length  ; j++) {
		                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                        if (MaxID < curnum)
		                            MaxID = curnum;
		                    }
		                    //var objTr = listview.AddRow(MaxID);
		                    //SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
		                    //listview.AddDataRow(objTr, Resultxml);
		                    var objTr = listview.NewAddRow(0, "ListViewMsgToView" + "_TR_" + eval(MaxID + 1));
		                    listview.AddDataRow(objTr, Resultxml);
		                    listview.SetSelectedIndex(MaxID + 1);
		                    admin_OK.disabled = true;
		                    admin_NO.disabled = true;
		                }
		            } else {
		                var organTree = new TreeView();
		                organTree.LoadFromID("TreeViewList");

		                var nodeIdx = organTree.GetSelectNode();
		                var strCN = nodeIdx.GetNodeData("CN");
		                var pparsingXML = "";
		                var getlistview = new ListView();
		                getlistview.LoadFromID("ListViewMsgToView");
		                var bFlag = getlistview.ExistRow("DATA1", strCN);

		                if (bFlag) {
		                    alert("<spring:message code='ezBoard.t20' />");
		                    return;
		                } else {
		                    pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + nodeIdx.GetNodeData("CN") + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2><![CDATA[" + nodeIdx.GetNodeData("DISPLAYNAME") + "]]></DATA2>";
		                    pparsingXML = pparsingXML + "<DATA3><![CDATA[" + nodeIdx.GetNodeData("DISPLAYNAME2") + "]]></DATA3>";
		                    pparsingXML = pparsingXML + "<DATA4><![CDATA[DEPT]]></DATA4>";
		                    pparsingXML = pparsingXML + "<DATA5><![CDATA[N]]></DATA5>";
		                    if (userLang == "" || userLang == "1")
		                        pparsingXML = pparsingXML + "<VALUE><![CDATA[" + nodeIdx.GetNodeData("DISPLAYNAME") + "]]></VALUE>";
		                    else
		                        pparsingXML = pparsingXML + "<VALUE><![CDATA[" + nodeIdx.GetNodeData("DISPLAYNAME2") + "]]></VALUE>";
		                    pparsingXML = pparsingXML + "</CELL></ROW>";
		                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		                    Resultxml = loadXMLString(pparsingXML2);

		                    Resultxml = loadXMLString(pparsingXML);

		                    var listview = new ListView();
		                    listview.LoadFromID("ListViewMsgToView");

		                    var MaxID = 0;
		                    var InitTr = listview.GetDataRows();

		                    for (var j = 0  ; j < InitTr.length  ; j++) {
		                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                        if (MaxID < curnum)
		                            MaxID = curnum;
		                    }
		                    var objTr = listview.NewAddRow(0, "ListViewMsgToView" + "_TR_" + eval(MaxID + 1));
		                    //var objTr = listview.AddRow(MaxID);
		                    //SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
		                    listview.AddDataRow(objTr, Resultxml);
		                    listview.SetSelectedIndex(MaxID + 1);
		                    admin_OK.disabled = false;
		                    admin_NO.disabled = false;
		                }
		            }
		            document.getElementById("admin_OK").checked = false;
		            document.getElementById("admin_NO").checked = true;
		        }	        
		    }
		    
		    function confirm_onClick() {
		        var listview = new ListView();
		        listview.LoadFromID("ListViewMsgToView");
		        var listviewSelected = listview.GetDataRows();
		        var selectedTarget = "";
		        var selectTargetListXML = "<DATA>";
		        for (var nCnt1 = 0; nCnt1 < listviewSelected.length; nCnt1++) {
		            selectTargetListXML += "<CN>" + listviewSelected[nCnt1].getAttribute("data1") + "</CN>";
		            selectTargetListXML += "<NAME><![CDATA[" + listviewSelected[nCnt1].getAttribute("data2") + "]]></NAME>";
		            selectTargetListXML += "<NAME2><![CDATA[" + listviewSelected[nCnt1].getAttribute("data3") + "]]></NAME2>";
		            selectTargetListXML += "<DEPT><![CDATA[" + listviewSelected[nCnt1].getAttribute("data4") + "]]></DEPT>";
		            selectTargetListXML += "<GROUP><![CDATA[" + listviewSelected[nCnt1].getAttribute("data5") + "]]></GROUP>";
		            if (nCnt1 == 0)
		                selectedTarget = listviewSelected[nCnt1].cells[0].innerText;
		            else
		                selectedTarget += ", " + listviewSelected[nCnt1].cells[0].innerText;
		        }
		        selectTargetListXML += "</DATA>";
		        RetValue["window"].document.getElementById("selectedTarget").innerHTML = MakeXMLString(selectedTarget);
		        if (ReturnFunction != null) {
		            ReturnFunction(selectTargetListXML);
		        }
		        else {
		            window.returnValue = selectTargetListXML;
		        }
		        window.close();
		    }
		    
		    var checkname2_cross_dialogArguments = new Array();
		    var rgParams = new Array();
		    function cnsearch_click(pMode){
		        if (cnkeyword.value == ""){
		            alert("<spring:message code='ezBoard.t23'/>");
		            cnkeyword.focus();
		            return;
		        }		        
		        var adCount = 0;		        
		        var xmlDOM = createXmlDom();

		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {search : pMode + "::" + cnkeyword.value, cell : 'company;description;title;displayName;mail', prop : 'department', type : 'user'},
		        	success : function(result){	
		        		xmlDOM = loadXMLString(result);
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezBoard.t24'/>" + error);
		        		xmlDOM = null;
		        	}
		        });		        
		        
		        if (adCount == 0) {
		        	alert("<spring:message code='ezBoard.t25'/>");
		            return;
		        }
		        else if (adCount == 1) {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + getNodeText(GetElementsByTagName(xmlDOM, "DATA3")[0]) +
		                    "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		        else {
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
		            checkname2_cross_dialogArguments[0] = rgParams;
		            checkname2_cross_dialogArguments[1] = cnsearch_click_Complete;
		            var checkName2 = window.open("/admin/ezBoard/checkName.do", "checkName2", GetOpenWindowfeature(609, 352));
		            try { checkName2.focus(); } catch (e) {
		            }
		        }
		    }

		    function cnsearch_click_Complete(RetValue) {
		        if (RetValue["deptid"] != "") {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + RetValue["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail;displayName</PROP></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		    }
		    
		    function Key_Down(e){
		        if (e.keyCode == 13){
		            cnsearch_click("displayname");
		        }
		    }
	    </script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style ="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t35' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
		<xml id="listviewheader2" style ="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t36' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t9' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t37' /></NAME>
		        		<WIDTH>80</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t38' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>		     
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezBoard.t16' /></h1>
		<table>
			<tr align=left>
		    	<td  colspan=3 id="cnblock" align=right height="30">
		        	<input type="text" id="cnkeyword" style="WIDTH:100px" name="Input" onkeydown='Key_Down(event)'>
		        	<a class="imgbtn"  name="button"><span onClick='cnsearch_click("displayname")'><spring:message code='ezBoard.t42' /></span></a>
		    	</td>
		  	</tr>  
		  	<tr>
		    	<td rowspan="1" valign="top" >
		        	<table border="0" cellspacing="0" cellpadding="0">
		            	<tr>
		              		<td align="center" id="TreeViewTD" valign="top">
		                  		<table>
		                      		<tr>
		                            	<td>
		                                	<div style="OVERFLOW-Y:auto;OVERFLOW-X:auto;WIDTH:225px;HEIGHT:370px;BACKGROUND-COLOR:#ffffff;" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)" class="box"></div>
		                            	</td>
		                            	<td width="5"></td>
		                            	<td>
		                                	<div class="listview">
		                	                <div id=OrganListView style ="OVERFLOW:auto; WIDTH:310px; HEIGHT:370px; border:0"></div></div>
		                    	        </td>
		                      		</tr>
		                 		</table>
		              		</td>                    
		            	</tr>
		      		</table>
		    	</td>
		    	<td  width="30" align="center" >
		        	<img style="cursor:pointer" src="/images/arr_right.gif" alt="" border="0" onClick="InsertReceiver(ListViewMsgTo)" width="16" height="16"> 
		        	<img style="cursor:pointer" src="/images/arr_left.gif" alt="" border="0" onClick="DeleteReceiver(ListViewMsgTo)" width="16" height="16"> 
		    	</td>		
		    	<td>
		        	<table>
		            	<tr style="DISPLAY:none">
		                	<td id="ToTitle"><spring:message code='ezBoard.t43' /></td>
		            	</tr>
		            	<tr>
		                	<td>
		                		<div class="listview">
		                    		<div id=ListViewMsgTo style ="BORDER:0;HEIGHT: 340px; WIDTH:200px;overflow:auto"></div>
		                		</div>
		                	</td>
		            	</tr>
		        	</table>
		        	<table class="content" style="width: 100%;">
		            	<tbody>
		                	<tr>
		                    	<th><spring:message code='ezBoard.t999025' /></th>
		                    	<td>
			                        <input type="checkbox" id="admin_OK" onclick="checkbox_onclick(event)">&nbsp;<spring:message code='ezBoard.t95' />
			                        <input type="checkbox" id="admin_NO" onclick="checkbox_onclick(event)">&nbsp;<spring:message code='ezBoard.t96' />
			                    </td>
		                	</tr>
		            	</tbody>
		        	</table>
		    	</td>
		  	</tr>
		</table>
		<div class="btnposition" style="float:right">
			<a class="imgbtn"><span onclick="confirm_onClick()" ><spring:message code='ezBoard.t48' /></span></a>
			<a class="imgbtn"><span onclick="return window.close()" ><spring:message code='ezBoard.t49' /></span></a>
		</div>
	</body>
</html>