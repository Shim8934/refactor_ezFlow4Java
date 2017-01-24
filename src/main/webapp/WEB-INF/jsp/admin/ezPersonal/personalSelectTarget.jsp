<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
		<script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
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
	        var strInitList = "";
	        var topid = "<c:out value = '${topID}' />";
	        var userLang = "<c:out value = '${userLang}' />";
	        var ReturnFunction;
	        var RetValue;
	        
	        $(document).ready(function () {
	            try{
	                RetValue = parent.selecttarget_dialogArguments[0];
	                ReturnFunction = parent.selecttarget_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.selecttarget_dialogArguments[0];
	                    ReturnFunction = opener.selecttarget_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	
	            m_receiverTitleList = new Array(ToTitle);
	            m_receiverWindowList = new Array(ListViewMsgTo);
	
	            var listview = new ListView();
	            listview.SetID("ListViewMsgToView");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnClick("SelectReceiverWindow");
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.DataSource(loadXMLString(listviewheader.innerHTML.toUpperCase()));
	            listview.DataBind("ListViewMsgTo");
	            initUserList();
	
	            var listview5 = new ListView();
	            listview5.SetID("OrganList");
	            listview5.SetMulSelectable(false);
	            listview5.SetRowOnDblClick("ListViewNodeDblClick");
	            listview5.DataSource(loadXMLString(listviewheader2.innerHTML.toUpperCase()));
	            listview5.DataBind("OrganListView");
	
// 	            applyCurrentData();
	
	            g_xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><DEPTID>${userInfo.deptID}</DEPTID><TOPID>" + topid + "</TOPID><PROP>mail;displayName</PROP></DATA>";
	            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	            g_xmlHTTP.send(strQuery);
	            
	            m_selectedTree = TreeView;
	            SelectReceiverWindow(ToTitle, ListViewMsgTo);
	        });
	        
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
		                if (!bSearch) {
		                    try {
		                        RetValue["window"].opener.top.organview = getXmlString(g_xmlHTTP.responseXML);
		                    } catch (e) { }
		                }
		
		                var xmlDom = loadXMLFile("/xml/common/organtree_config3.xml");
		                document.getElementById('TreeView').innerHTML = "";
		
		                var treeView = new TreeView();
		                treeView.SetID("TreeViewList");
		                treeView.SetConfig(xmlDom);
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.SetRequestData("RequestData");
		                treeView.DataSource(g_xmlHTTP.responseXML);
		                treeView.DataBind("TreeView");
		            } else {
		                alert("<spring:message code = 'ezPersonal.t17' />" + g_xmlHTTP.statusText);
		                g_xmlHTTP = null;
		            }
		        }
		    }
		    
	        function initUserList() {
	            if (RetValue != "" && RetValue != null) {
	                var listView = new ListView();
	                listView.LoadFromID("ListViewMsgToView");
	
	                var totalRows = listView.GetDataRows();
	                var totalLen = totalRows.length;
	                dialogArgData1 = RetValue["DATA1"];
	                dialogArgData2 = RetValue["DATA2"];
	                dialogArgData3 = RetValue["DATA3"];
	                dialogArgData5 = RetValue["DATA5"];
	                
	                for (var i = 0; i < dialogArgData1.length; i++) {
	                    var ACCESSNAME = dialogArgData1[i];
	                    var ACCESSNAME2 = dialogArgData2[i];
	                    var ACCESSID = dialogArgData3[i];
	                    var PERMISSIONS = dialogArgData5[i];
	
	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + ACCESSID + "</DATA1>";
	                    pparsingXML = pparsingXML + "<DATA2>" + ACCESSNAME + "</DATA2>";
	                    pparsingXML = pparsingXML + "<DATA3>" + ACCESSNAME2 + "</DATA3>";
	                    pparsingXML = pparsingXML + "<DATA5>" + PERMISSIONS + "</DATA5>";
	
	                    if (userLang == "") {
	                        pparsingXML = pparsingXML + "<VALUE>" + ACCESSNAME + "</VALUE>";
	                    } else {
	                        pparsingXML = pparsingXML + "<VALUE>" + ACCESSNAME2 + "</VALUE>";
	                    }
	                    
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
	                var listview2 = new ListView();
	                listview2.LoadFromID("ListViewMsgToView");
	                var InitTr2 = listview2.GetDataRows();
	
	
	                for (var i = 0; i < InitTr2.length; i++) {
	                    if (InitTr2[i].getAttribute("data5") == "N") {
	                        InitTr2[i].childNodes[0].style.color = "red";
	                    }
	                }
	
	            }
	        }
	        function applyCurrentData() {
	            var xmldoc;
	            xmldoc = loadXMLString(RetValue["selectTargetListXML"]);
	
	            var i = 0;
	            var username, useremail;
	        	var username2;
	        	
	        	for (i = 0; i < GetElementsByTagName(xmldoc, "CN").length; i++) {
		            if (CrossYN()) {
		                username = GetElementsByTagName(xmldoc, "NAME")[i].textContent;
		                username2 = GetElementsByTagName(xmldoc, "NAME2")[i].textContent;
		                useremail = GetElementsByTagName(xmldoc, "CN")[i].textContent;
		            } else {
		                username = GetElementsByTagName(xmldoc, "NAME")[i].text;
		                username2 = GetElementsByTagName(xmldoc, "NAME2")[i].text;
		                useremail = GetElementsByTagName(xmldoc, "CN")[i].text; 
		            }
		            
		            pparsingXML2 = "";
		            pparsingXML = "";
		            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + useremail + "</DATA1>";
		            pparsingXML = pparsingXML + "<DATA2>" + username + "</DATA2>";
		            pparsingXML = pparsingXML + "<DATA3>" + username2 + "</DATA3>";
		            
		            if (userLang == "") {
		                pparsingXML = pparsingXML + "<VALUE>" + username + "</VALUE>";
		            } else {
		                pparsingXML = pparsingXML + "<VALUE>" + username2 + "</VALUE>";
		            }
		            
		            pparsingXML = pparsingXML + "</CELL></ROW>";
		            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		
		            Resultxml = loadXMLString(pparsingXML2);
		
		            var listview = new ListView();
		            listview.LoadFromID("ListViewMsgToView");
		
		            var MaxID = 0;
		            var InitTr = listview.GetDataRows();
		
		            for (var j = 0  ; j < InitTr.length  ; j++) {
		                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                
		                if (MaxID < curnum) {
		                    MaxID = curnum;
		                }
		            }
		            
		            var objTr = listview.AddRow(MaxID);
		            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
		            listview.AddDataRow(objTr, Resultxml);
		        }
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
		
		        var strQuery = "<DATA><DEPTID>" + deptID + "</DEPTID><PROP>mail;displayName</PROP></DATA>";
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(strQuery);
		
		        xmlRtn = loadXMLString(xmlHTTP.responseText);
		
		        var treeView = new TreeView();
		        treeView.LoadFromID("TreeViewList");
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
	
		    function MakeXMLString(str) {
		        str = ReplaceText(str, "&", "&amp;");
		        str = ReplaceText(str, "<", "&lt;");
		        str = ReplaceText(str, ">", "&gt;");
		        return str;
		    }
	
		    function confirm_onClick() {
		        var listview = new ListView();
		        listview.LoadFromID("ListViewMsgToView");
		        var listviewSelected = listview.GetDataRows();
		        var selectTargetListXML = "<NODES>";
		        
		        for (var nCnt1 = 0; nCnt1 < listviewSelected.length; nCnt1++) {
		            selectTargetListXML += "<NODE>";
		            selectTargetListXML += "<ACCESSID>" + listviewSelected[nCnt1].getAttribute("data1") + "</ACCESSID>";
		            selectTargetListXML += "<ACCESSNAME>" + listviewSelected[nCnt1].getAttribute("data2") + "</ACCESSNAME>";
		            selectTargetListXML += "<ACCESSNAME2>" + listviewSelected[nCnt1].getAttribute("data3") + "</ACCESSNAME2>";
		            selectTargetListXML += "<PERMISSIONS>" + listviewSelected[nCnt1].getAttribute("data5") + "</PERMISSIONS>";
		            selectTargetListXML += "</NODE>";
		        }
		        
		        selectTargetListXML += "</NODES>";
		        
		        if(ReturnFunction != null) {
		            ReturnFunction(selectTargetListXML);
		        } else {
		            window.returnValue = selectTargetListXML;
		        }
		        window.close();
		    }
	
		    function InsertReceiver(pListView) {
		        admin_OK.checked = true;
		        admin_NO.checked = false;
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
		                    alert("<spring:message code = 'ezPersonal.t354' />");
		                    pAddFlag = true;
		                    return;
		                }
		                else {
		                    pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + existId + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2>" + existName + "(" + strDeptNM.trim() + ")" + "</DATA2>";
		                    pparsingXML = pparsingXML + "<DATA3>" + existName2 + "(" + strDeptNM2.trim() + ")" + "</DATA3>";
		                    pparsingXML = pparsingXML + "<DATA5>" + "Y" + "</DATA5>";
		
		
		                    if (userLang == "")
		                        pparsingXML = pparsingXML + "<VALUE>" + existName + "(" + strDeptNM.trim() + ")" + "</VALUE>";
		                    else
		                        pparsingXML = pparsingXML + "<VALUE>" + existName2 + "(" + strDeptNM2.trim() + ")" + "</VALUE>";
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
		                    var objTr = listview.NewAddRow(0, "ListViewMsgToView" + "_TR_" + eval(MaxID + 1));
		                    listview.AddDataRow(objTr, Resultxml);
		                    listview.SetSelectedIndex(MaxID + 1);
		                    //var objTr = listview.AddRow(0, "ListViewMsgToView" + "_TR_" + eval(MaxID + 1));
		                    //listview.AddDataRow(objTr, Resultxml);
		                    //listview.SetSelectedIndex(MaxID + 1);
		                }
		            }
		            else {
		                var organTree = new TreeView();
		                organTree.LoadFromID("TreeViewList");
		
		                var nodeIdx = organTree.GetSelectNode();
		                var strCN = nodeIdx.GetNodeData("CN");
		                var pparsingXML = "";
		                var getlistview = new ListView();
		                getlistview.LoadFromID("ListViewMsgToView");
		                var bFlag = getlistview.ExistRow("DATA1", strCN);
		
		                if (bFlag) {
		                    alert("<spring:message code = 'ezPersonal.t354' />");
		                    return;
		                }
		                else {
		                    pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + nodeIdx.GetNodeData("CN") + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2>" + nodeIdx.GetNodeData("DISPLAYNAME") + "</DATA2>";
		                    pparsingXML = pparsingXML + "<DATA3>" + nodeIdx.GetNodeData("DISPLAYNAME2") + "</DATA3>";
		                    pparsingXML = pparsingXML + "<DATA5>" + "Y" + "</DATA5>";
		
		                    if (userLang == "")
		                        pparsingXML = pparsingXML + "<VALUE>" + nodeIdx.GetNodeData("DISPLAYNAME") + "</VALUE>";
		                    else
		                        pparsingXML = pparsingXML + "<VALUE>" + nodeIdx.GetNodeData("DISPLAYNAME2") + "</VALUE>";
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
		
		                    var objTr = listview.AddRow(MaxID);
		                    SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
		                    listview.AddDataRow(objTr, Resultxml);
		                }
		            }
		        }
		    }
		
		    function DeleteReceiver(pListView) {
		        var listView = new ListView();
		        listView.LoadFromID("ListViewMsgToView");
		        listView.DeleteRow(listView.GetSelectedRows()[0].id);
		    }
		    function checkbox_onclick(e) {
		        if (window.ActiveXObject)
		            srcElementID = window.event.srcElement.id;
		        else
		            srcElementID = e.target.id;
		
		        var checkFlag = "Y";
		        if (srcElementID == "admin_OK") {
		            admin_OK.checked = true;
		            admin_NO.checked = false;
		            checkFlag = "Y";
		        }
		        else {
		            admin_OK.checked = false;
		            admin_NO.checked = true;
		            checkFlag = "N";
		        }
		
		        var pListViewDL = new ListView();
		        pListViewDL.LoadFromID("ListViewMsgToView");
		        var arrRows = pListViewDL.GetSelectedRows();
		        if (arrRows == "") return;
		        SetAttribute(arrRows[0], "DATA5", checkFlag);
		
		        if (checkFlag == "N") {
		            if (CrossYN())
		                SetAttribute(arrRows[0].childNodes[0], "style", "color:red;");
		            else
		                arrRows[0].childNodes[0].style.color = "red";
		        }
		        else {
		            if (CrossYN())
		                SetAttribute(arrRows[0].childNodes[0], "style", "color:;");
		            else
		                arrRows[0].childNodes[0].style.color = "";
		        }
		    }
		    function SelectReceiverWindow(Title, selectedWindow) {
		        var pListViewDL = new ListView();
		        pListViewDL.LoadFromID("ListViewMsgToView");
		        var arrRows = pListViewDL.GetSelectedRows();
		        if (arrRows.length > 0) {
		            var permissionsFlag = GetAttribute(arrRows[0], "data5");
		            if (permissionsFlag == "Y") {
		                admin_OK.checked = true;
		                admin_NO.checked = false;
		            }
		            else {
		                admin_NO.checked = true;
		                admin_OK.checked = false;
		            }
		        }
		
		        for (var count = 0; count < m_receiverTitleList.length; count++) {
		            m_receiverTitleList[count].style.fontWeight = "normal";
		            m_receiverWindowList[count].style.backgroundColor = m_titleNoneSelectedColor;
		            m_receiverWindowList[count].normalColor = m_titleNoneSelectedColor;
		            ChangeRowsColor(m_receiverWindowList[count], m_titleNoneSelectedColor);
		
		        }
		
		        ToTitle.style.fontWeight = "bold";
		        ListViewMsgTo.style.backgroundColor = m_titleSelectedColor;
		        ListViewMsgTo.normalColor = m_titleSelectedColor;
		        ChangeRowsColor(ListViewMsgTo, m_titleSelectedColor);
		        m_selectedWindow = ListViewMsgTo;
		        
		    }
		
		    function TreeViewNodeClick(pNodeID, pTreeID) {
		        var treenode = new TreeNode();
		        treenode.LoadFromID(pNodeID);
		        nodeIdx = treenode.GetNodeData("CN");
		        displayUserList(nodeIdx);
		    }
		
		    function displayUserList(DeptID) {
		    	$.ajax({
		    		type : 'POST',
		    		url : '/ezOrgan/getDeptMemberList.do',
		    		dataType : "text",
		    		data : {deptID : DeptID,
		    				cell : 'displayName;description;title;telephoneNumber',
		    				prop : 'mail;displayName;description;title',
		    				type : 'user'},
		    		success : function (result) {
		    			document.getElementById("OrganListView").innerHTML = "";
		                var listview = new ListView();
		                listview.SetID("OrganList");
		                listview.SetSelectFlag(false);
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("ListViewNodeDblClick");
		                listview.DataSource(loadXMLString($('#listviewheader2').html().toUpperCase()));
		                listview.DataBind("OrganListView");
		                listview.DataSource(loadXMLString(result));
		                listview.RowDataBind();
		    		},
		    		error : function(jqXHR, textStatus, errorThrown) {
		    			alert("<spring:message code = 'ezPersonal.t22' />" + textStatus);
		    		}
		    	});
		    }
		
		    function ListViewNodeDblClick() {
		        if (m_selectedWindow != null)
		            InsertReceiver(m_selectedWindow);
		    }
		
		    function RemoveEventDblClick(TreeViewNode) {
		        var children;
		        var child;
		        children = TreeViewNode.childNodes;
		        
		        for (var count = 0; count < children.length; count++) {
		            child = children.item(count);
		            child.iconItem.ondblclick = fire_dblClickEvent;
		            child.textItem.ondblclick = fire_dblClickEvent;
		            RemoveEventDblClick(child);
		        }
		    }
		
		    function fire_dblClickEvent() {
		        var selectedNode = window.event.srcElement.parentElement;
		        var currentState = selectedNode.expandState;
		        try {
		            window.event.srcElement.parentElement.expandState = (currentState == 0) ? 1 : 0;
		        } catch (e) { }
		    }
		
		    function ChangeRowsColor(pListView, color) {
		    }
		
		    function search_press() {
		        if (window.event.keyCode == "13")
		            contactTabButton_onClick();
		    }
		    function cnsearch_press() {
		        if (window.event.keyCode == "13")
		            cnsearch_click();
		    }
		
		    function cnsearch_click(pMode) {
		        if (cnkeyword.value == "") {
		            alert("<spring:message code = 'ezPersonal.t23' />");
		            cnkeyword.focus();
		            return;
		        }
		        var count;
		        var adCount = 0;
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "SEARCH", pMode + "::" + cnkeyword.value);
		        createNodeAndInsertText(xmlDOM, objNode, "CELL", "company;description;title;displayName;mail");
		        createNodeAndInsertText(xmlDOM, objNode, "PROP", "department");
		        createNodeAndInsertText(xmlDOM, objNode, "TYPE", "user");
		
		        try {
		            xmlHTTP.open("POST", "/ezOrgan/getSearchList.do", false);
		            xmlHTTP.send(xmlDOM);
		            if (xmlHTTP.statusText != "OK") {
		                alert("<spring:message code = 'ezPersonal.t24' />" + xmlHTTP.statusText);
		                xmlDOM = null;
		                xmlHTTP = null;
		            }
		            else {
		                xmlDOM = xmlHTTP.responseXML;
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		            }
		        } catch (e) {
		            alert("<spring:message code = 'ezPersonal.t24' />" + e.description);
		            xmlDOM = null;
		            xmlHTTP = null;
		        }
		        if (adCount == 0) {
		            alert("<spring:message code = 'ezPersonal.t25' />");
		            return;
		        }
		        else if (adCount == 1) {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            if (CrossYN()) {
		                var strQuery = "<DATA><DEPTID>" + GetElementsByTagName(xmlDOM, "DATA3")[0].textContent +
		                        "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
		            }
		            else {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA3").item(0).text +
		                      "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
		            }
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		        else {
		            var rgParams = new Array();
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
		            window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken" + GetShowModalPosition(600, 320));
		
		            if (rgParams["deptid"] != "") {
		                bSearch = true;
		                g_xmlHTTP = createXMLHttpRequest();
		                var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail;DisplayName</PROP></DATA>";
		                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		                g_xmlHTTP.send(strQuery);
		            }
		        }
		    }
		
		    function infoview_click() {
		        if (OrganListView.multiSelects.length < 1) {
		            alert("<spring:message code = 'ezPersonal.t26' />");
		            return;
		        }
		        var cn = OrganListView.multiSelects.item(0).cells[0].DATA2;
		        window.dialogArguments["window"].document.Script.open_userinfo(cn);
		    }
		
		    function dlmember_click() {
		        if (ListViewDL.multiSelects.length < 1) {
		            alert("<spring:message code = 'ezPersonal.t27' />");
		            return;
		        }
		        var rtnValue = { "name": new Array(), "email": new Array() };
		        var count = window.showModalDialog("mail_select_dlmember.aspx?cn=" + ListViewDL.multiSelects.item(0).cells[0].DATA1, rtnValue, "dialogHeight:450px; dialogWidth:601px; status:no;scroll:auto; help:no; edge:sunken" + GetShowModalPosition(601, 450));
		        for (var i = 0; i < count; i++) {
		            var row = m_selectedWindow.rows.add();
		            row.cells[0].innerText = rtnValue["name"][i];
		            row.cells[0].name = rtnValue["name"][i];
		            row.cells[0].href = "";
		            row.cells[0].type = "contact";
		            row.cells[0].email = rtnValue["email"][i];
		            row.cells[1].innerText = rtnValue["email"][i];
		            row.cells[0].parentElement.style.backgroundColor = m_titleSelectedColor;
		        }
		    }
		    function groupmember_click() {
		        if (AddressListView.multiSelects.length < 1) {
		            alert("<spring:message code = 'ezPersonal.t28' />");
		            return;
		        }
		        if (AddressListView.multiSelects.item(0).cells[0].DATA2 != "mailgroup") {
		            alert("<spring:message code = 'ezPersonal.t28' />");
		            return;
		        }
		        var rtnValue = { "name": new Array(), "email": new Array() };
		        var count = window.showModalDialog(AddressListView.multiSelects.item(0).cells[0].DATA1.replace("get", "select").replace("/remote", ""), rtnValue, "dialogHeight:450px; dialogWidth:501px; status:no;scroll:auto; help:no; edge:sunken" + GetShowModalPosition(501, 450));
		        for (var i = 0; i < count; i++) {
		            var row = m_selectedWindow.rows.add();
		            row.cells[0].innerText = rtnValue["name"][i];
		            row.cells[0].name = rtnValue["name"][i];
		            row.cells[0].href = "";
		            row.cells[0].type = "contact";
		            row.cells[0].email = rtnValue["email"][i];
		            row.cells[1].innerText = rtnValue["email"][i];
		            row.cells[0].parentElement.style.backgroundColor = m_titleSelectedColor;
		        }
		    }
		    function dept_select() {
		        var nodeIdx = TreeView.selectedIndex;
		        if (TreeView.selectedIndex > 0) {
		            selname = TreeView.getvalue(nodeIdx, "VALUE");
		            selid = TreeView.getvalue(nodeIdx, "CN");
		        }
		        else {
		            alert("<spring:message code = 'ezPersonal.t29' />");
		            return;
		        }
		        if (selid == "Top") selid = "everyone";
		        if (ReturnFunction != null)
		            ReturnFunction(selid + ";" + selname);
		        else
		            window.returnValue = selid + ";" + selname;
		        window.close();
		    }
		
		    function Save_onclick() {
		        var length = OrganListView.multiSelects.length;
		        var selid = "";
		        var selname = "";
		        if (length == 0) {
		            selname = TreeView.getvalue(TreeView.selectedIndex, "VALUE");
		            selid = TreeView.getvalue(TreeView.selectedIndex, "CN");
		        }
		        else {
		            if (length > 1) {
		                alert("<spring:message code = 'ezPersonal.t34' />");
		                return;
		            }
		            var selRow = OrganListView.multiSelects.item(0);
		            selname = selRow.cells[0].innerText + "(" + selRow.cells[4].innerText + ", " + selRow.cells[1].innerText + ")";
		            selid = selRow.cells[0].DATA2;
		        }
		        if (selid == "Top") selid = "everyone";
		        if (ReturnFunction != null)
		            ReturnFunction(selid + ";" + selname);
		        else
		            window.returnValue = selid + ";" + selname;
		        window.close();
		    }
		    
		    function Cancel_onclick() {
		        window.close();
		    }
		</script>
		
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t304' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		    	</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id="listviewheader2" style="display: none">
			<LISTVIEWDATA>
		    	<HEADERS>
		    		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t68' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t7' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t69' />/<spring:message code = 'ezPersonal.t175' /></NAME>
		        		<WIDTH>80</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t70' /></NAME>
		        		<WIDTH>100</WIDTH>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
		
	    <h1><spring:message code = 'ezPersonal.t1018' /></h1>
	    <table>
			<tr>
	            <td rowspan="1" valign="top">
	                <table border="0" cellspacing="0" cellpadding="0">
	                    <tr>
	                        <td align="center" id="TreeViewTD" valign="top">
	                            <table>
	                                <tr>
	                                    <td>
	                                        <div style="OVERFLOW-Y: auto; OVERFLOW-X: auto; WIDTH: 225px; HEIGHT: 370px; BACKGROUND-COLOR: #ffffff;" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)" class="box"></div>
	                                    </td>
	                                    <td width="5"></td>
	                                    <td>
	                                        <div class="listview">
	                                            <div id="OrganListView" style="OVERFLOW: auto; WIDTH: 310px; HEIGHT: 370px; border: 0"></div>
	                                        </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <td width="30" align="center">
	                <img style="cursor: pointer" src="/images/arr_right.gif" alt="" border="0" onclick="InsertReceiver(ListViewMsgTo)" width="16" height="16">
	                <img style="cursor: pointer" src="/images/arr_left.gif" alt="" border="0" onclick="DeleteReceiver(ListViewMsgTo)" width="16" height="16">
	            </td>
	            <td>
	            	<table>
	                    <tr style="DISPLAY: none">
	                        <td id="ToTitle" colspan="2"><spring:message code = 'ezPersonal.t43' /></td>
	                    </tr>
	                    <tr>
	                        <td colspan="2">
	                            <div class="listview">
	                                <div id="ListViewMsgTo" style="BORDER: 0; HEIGHT: 340px; WIDTH: 200px; overflow: auto"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <table class="content" style="width:100%;">
	                            <tr>
	                                <th><spring:message code = 'ezPersonal.t1019' /></th>
	                                <td>
	                                    <input type="checkbox" id="admin_OK" onclick="checkbox_onclick(event)">&nbsp;<spring:message code = 'ezPersonal.t1020' />
	                                    <input type="checkbox" id="admin_NO" onclick="checkbox_onclick(event)">&nbsp;<spring:message code = 'ezPersonal.t1021' />
	                                </td>
	                            </tr>
	                        </table>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition" style="float: right">
	        <a class="imgbtn"><span onclick="confirm_onClick()"><spring:message code = 'ezPersonal.t12' /></span></a>
	        <a class="imgbtn"><span onclick="return window.close()"><spring:message code = 'ezPersonal.t13' /></span></a>
	    </div>
	</body>
</html>