<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t698'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/admin/mdocnumui_Cross.js"></script>
	    <script type="text/javascript">
	        var Rtnval = new Array();
	        var companyID = "";
	
	        window.onload = function () {
	            Rtnval[0] = "cancle";
	            window.returnValue = Rtnval;
	            companyID = document.getElementById("ListCompany").value;
	            Tree_setconfig();
	            getGroupTree(1, 1, 0, true);
	
	            var listview = new ListView();
	            listview.SetTableWidth = 420 - 14;
	            listview.SetID("lvtFormID");
	            listview.SetMulSelectable(false);
	            listview.DataSource(loadXMLString(document.getElementById("ITEM").innerHTML.toUpperCase()));
	            listview.DataBind("lvtForm");
	        }
	
	        function Tree_setconfig() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
	            }
	        }
	
	        function TreeView_onRequestData(pNodeID, pTreeID) {
	            var treeview = new TreeView();
	            treeview.LoadFromID("FromTreeView");
	            node_select(pNodeID, "", pTreeID, TreeView_onNodeSelect);
	            nodeIdx = treeview.GetSelectNode();
	            var pGroupID = nodeIdx.GetNodeData("DATA1");
	            var pLevel = nodeIdx.GetNodeData("DATA3");
	            getGroupTree(nodeIdx, parseInt(pLevel) + 1, pGroupID, false);
	        }
	
	        function TreeView_onNodeSelect() {
	            var treeview = new TreeView();
	            treeview.LoadFromID("FromTreeView");
	            var nodedata = treeview.GetSelectNode();
	            var pGroupID = nodedata.GetNodeData("DATA1");
	
	            getGroupItem(pGroupID);
	        }
	
	        function getGroupTree(pNodeIdx, pLevel, pGroupID, pFirst) {
	            try {
	                var result = "";
	                
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezApproval/getDocNumGroupNode.do",
			    		data : {
			    			g_level : pLevel,
			    			groupID : pGroupID,
			    			companyID  : document.getElementById("ListCompany").value
			    		},
			    		success: function(text){
			    			result = text;
			    		}
			    	});
	
	                if (pFirst) {
	                    var xmlDom2 = createXmlDom();
	                    xmlDom2 = loadXMLString(document.getElementById("GROUP").innerHTML.toUpperCase());
	
	                    var XmlNode = loadXMLString(result);
	
	                    if (SelectNodes(XmlNode, "NODES/NODE/VALUE").length > 0) {
	                        var xmlRtn = XmlNode.documentElement;
	                        GetChildNodes(GetChildNodes(xmlDom2)[0])[0].appendChild(xmlRtn);
	                    }
	                    document.getElementById('TreeView').innerHTML = "";
	                    var treeView = new TreeView();
	                    treeView.SetID("FromTreeView");
	                    treeView.SetUseAgency(true);
	                    treeView.SetRequestData("TreeView_onRequestData");
	                    treeView.SetNodeClick("TreeView_onNodeSelect");
	                    treeView.DataSource(xmlDom2);
	                    treeView.DataBind("TreeView");
	                }
	                else {
	                    if (loadXMLString(result).xml == "") return;
	
	                    var treeView = new TreeView();
	                    treeView.LoadFromID("FromTreeView");
	
	                    treeView.AppendChildNodes(loadXMLString(result).documentElement, treeView.GetSelectNode().NodeID)
	                }
	            }
	            catch (e) {
	                alert(e.description);
	            }
	        }
	
	        function lvtForm_onclick() {
	        }
	
	        function lvtForm_onSel_Changed() {
	        }
	
	        var minsgroupmain_cross_dialogArguments = new Array();
	        function btnAddTree_onclick() {
	            treeview = new TreeView();
	            treeview.LoadFromID("FromTreeView");
	            var nodeIdx = treeview.GetSelectNode();
	            if (nodeIdx) {
	                var para = new Array();
	                para[0] = "I";
	                para[1] = "";
	                para[2] = "";
	                para[3] = nodeIdx.GetNodeData("DATA1");
	                para[4] = parseInt(nodeIdx.GetNodeData("DATA3")) + 1;
	                para[5] = companyID;
	                minsgroupmain_cross_dialogArguments[0] = para;
	                minsgroupmain_cross_dialogArguments[1] = btnAddTree_onclick_Complete;
	                var url = "minsGroupMain.do?tCheck=Ins";
	                var result = GetOpenWindow(url, "MinsGroupMain_Cross", 480, 177, "NO");
	            }
	            else {
	                var pAlertContent = "<spring:message code='ezApproval.t699'/>";
	                OpenAlertUI(pAlertContent);
	            }
	        }
	        function btnAddTree_onclick_Complete(retVal) {
	            if (retVal[0] != "FALSE") {
	                getGroupTree(1, 1, 0, true);
	            }
	        }
	
	
	        var primaryStr = "${primaryStr}";
	        var nodeIdx;
	        function btnEditTree_onclick() {
	            var treeview = new TreeView();
	            treeview.LoadFromID("FromTreeView");
	            nodeIdx = treeview.GetSelectNode();
	
	            if (!nodeIdx) {
	                var pAlertContent = "<spring:message code='ezApproval.t700'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	
	            if (nodeIdx.NodeLevel > 0) {
	                var para = new Array();
	                if (primaryStr == 1) {
	                    para[0] = "U";
	                    para[1] = nodeIdx.GetNodeData("VALUE");
	                    para[2] = nodeIdx.GetNodeData("DATA1");
	                    para[3] = nodeIdx.GetNodeData("DATA2");
	                    para[4] = nodeIdx.GetNodeData("DATA3");
	                    para[5] = companyID;
	                    para[6] = nodeIdx.GetNodeData("DATA4");
	                } else {
	                    para[0] = "U";
	                    para[1] = nodeIdx.GetNodeData("DATA4");
	                    para[2] = nodeIdx.GetNodeData("DATA1");
	                    para[3] = nodeIdx.GetNodeData("DATA2");
	                    para[4] = nodeIdx.GetNodeData("DATA3");
	                    para[5] = companyID;
	                    para[6] = nodeIdx.GetNodeData("VALUE");
	                }
	
	                var url = "minsGroupMain.do?tCheck=Update";
	                minsgroupmain_cross_dialogArguments[0] = para;
	                minsgroupmain_cross_dialogArguments[1] = btnEditTree_onclick_Complete;
	                var result = GetOpenWindow(url, "MinsGroupMain_Cross", 480, 177, "NO");
	            }
	            else {
	                alert("<spring:message code='ezApproval.t910'/>");
	            }
	        }
	        function btnEditTree_onclick_Complete(retVal) {
	            if (retVal[0] != "FALSE") {
	                if (primaryStr == 1) {
	                    nodeIdx.SetNodeName(retVal[1]);
	                    nodeIdx.SetNodeData("VALUE", retVal[1]);
	                    nodeIdx.SetNodeData("DATA4", retVal[2]);
	                }
	                else {
	                    nodeIdx.SetNodeName(retVal[2]);
	                    nodeIdx.SetNodeData("VALUE", retVal[2]);
	                    nodeIdx.SetNodeData("DATA4", retVal[1]);
	                }
	            }
	        }
	
	        var nodeIdx;
	        function btnDelTree_onclick() {
	            var treeview = new TreeView();
	            treeview.LoadFromID("FromTreeView");
	            nodeIdx = treeview.GetSelectNode();
	
	            if (nodeIdx) {
	                ezapropinion_cross_dialogArgument[1] = btnDelTree_onclick_complete;
	                OpenInformationUI("<spring:message code='ezApproval.t701'/>");
	            }
	            else {
	                var pAlertContent = "<spring:message code='ezApproval.t702'/>";
	                OpenAlertUI(pAlertContent);
	            }
	        }
	        function btnDelTree_onclick_complete(retVal, NextFunction) {
	            if (retVal) {
					var result = "";
	                
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezApproval/mDelDocnumGroup.do",
			    		data : {
			    			groupID : nodeIdx.GetNodeData("DATA1"),
			    			companyID  : companyID
			    		},
			    		success: function(text){
			    			result = text;
			    		}
			    	});
			    	
	                nodeIdx.DeleteNode(treeview.GetID());
	                getGroupTree(1, 1, 0, true);
	            }
	        }
	
	        var minscodemain_cross_dialogArguments = new Array();
	        var nodeIdx;
	        function btnAddItem_onclick() {
	            var treeview = new TreeView();
	            treeview.LoadFromID("FromTreeView");
	            nodeIdx = treeview.GetSelectNode();
	            if (nodeIdx) {
	                var para = new Array();
	                para[0] = "I";
	                para[1] = "";
	                para[2] = "";
	                para[3] = "";
	                para[4] = "";
	                para[5] = "";
	                para[6] = nodeIdx.GetNodeData("DATA1");
	                para[7] = companyID;
	
	                var url = "mInsCodeMain.do?tCheck=Ins&companyID=" + companyID;
	                minscodemain_cross_dialogArguments[0] = para;
	                minscodemain_cross_dialogArguments[1] = btnAddItem_onclick_Complete;
	                var result = GetOpenWindow(url, "MinsCodeMain_Cross", 610, 265, "NO");
	            }
	            else {
	                var pAlertContent = "<spring:message code='ezApproval.t703'/>";
	                OpenAlertUI(pAlertContent);
	            }
	        }
	        function btnAddItem_onclick_Complete(retVal) {
	            if (retVal != "FALSE")
	                getGroupItem(nodeIdx.GetNodeData("DATA1"));
	        }
	
	        function btnEditItem_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvtFormID");
	            var selRow = listview.GetSelectedRows();
	            if (selRow.length) {
	                var para = new Array();
	                if (primaryStr == 1) {
	                    para[0] = "U";
	                    para[1] = selRow[0].childNodes[0].childNodes[0].nodeValue;
	                    para[2] = selRow[0].childNodes[1].childNodes[0].nodeValue;
	                    para[3] = GetAttribute(selRow[0], "DATA2");
	                    para[4] = GetAttribute(selRow[0], "DATA3");
	                    para[5] = GetAttribute(selRow[0],"DATA4");
	                    para[6] = GetAttribute(selRow[0],"DATA1");
	                    para[7] = companyID;
	                    para[8] = GetAttribute(selRow[0],"DATA5");
	                } else {
	                    para[0] = "U";
	                    para[1] = selRow[0].childNodes[0].childNodes[0].nodeValue;
	                    para[2] = GetAttribute(selRow[0],"DATA5");
	                    para[3] = GetAttribute(selRow[0],"DATA2");
	                    para[4] = GetAttribute(selRow[0],"DATA3");
	                    para[5] = GetAttribute(selRow[0],"DATA4");
	                    para[6] = GetAttribute(selRow[0],"DATA1");
	                    para[7] = companyID;
	                    para[8] = selRow[0].childNodes[1].childNodes[0].nodeValue;
	                }
	                var url = "mInsCodeMain.do?tCheck=Update&companyID=" + companyID;
	                minscodemain_cross_dialogArguments[0] = para;
	                minscodemain_cross_dialogArguments[1] = btnEditItem_onclick_Complete;
	                var result = GetOpenWindow(url, "MinsCodeMain_Cross", 610, 265, "NO");
	            }
	            else {
	                var pAlertContent = "<spring:message code='ezApproval.t704'/>";
	                OpenAlertUI(pAlertContent);
	            }
	        }
	        function btnEditItem_onclick_Complete(retVal) {
	            if (retVal != "FALSE") {
	                var treeview = new TreeView();
	                treeview.LoadFromID("FromTreeView");
	                var nodeIdx = treeview.GetSelectNode();
	                getGroupItem(nodeIdx.GetNodeData("DATA1"));
	            }
	        }
	
	        var selRow;
	        function btnDelItem_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvtFormID");
	            selRow = listview.GetSelectedRows();
	
	            if (selRow[0]) {
	                ezapropinion_cross_dialogArgument[1] = btnDelItem_onclick_Complete;
	                OpenInformationUI("<spring:message code='ezApproval.t701'/>");
	            }
	            else {
	                var pAlertContent = "<spring:message code='ezApproval.t704'/>";
	                OpenAlertUI(pAlertContent);
	            }
	        }
	        function btnDelItem_onclick_Complete(retVal, NextFunction) {
	            if (retVal) {
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/admin/ezApproval/mDelDocnumItem.do",
			    		data : {
			    			groupID   : GetAttribute(selRow[0], "DATA1"),
			    			itemCode  : selRow[0].childNodes[0].childNodes[0].nodeValue,
			    			companyID : document.getElementById("ListCompany").value
			    		},
			    		success: function(text){
			    		}
			    	});
			    	
	                var treeview = new TreeView();
	                treeview.LoadFromID("FromTreeView");
	                var nodeIdx = treeview.GetSelectNode();
	                getGroupItem(nodeIdx.GetNodeData("DATA1"));
	            }
	        }
	
	        function changeCompID() {
	            if (companyID != document.getElementById("ListCompany").value) {
	                companyID = document.getElementById("ListCompany").value;
	
	                Tree_setconfig();
	
	                getGroupTree(1, 1, 0, true);
	                document.getElementById('lvtForm').innerHTML = "";
	                var listview = new ListView();
	                listview.SetTableWidth = 420 - 14;
	                listview.SetID("lvtFormID");
	                listview.SetMulSelectable(false);
	                listview.DataSource(loadXMLString(document.getElementById("ITEM").innerHTML.toUpperCase()));
	                listview.DataBind("lvtForm");
	            }
	        }
	    </script>
	</head>
	
	<body class="mainbody">
	    <xml id="GROUP" style="display: none">
		<TREEVIEWDATA>
			<NODE>
				<EXPANDED>TRUE</EXPANDED>
				<ISLEAF>FALSE</ISLEAF>
				<VALUE><spring:message code='ezApproval.t77'/></VALUE>
				<DATA1>0</DATA1>
				<DATA2></DATA2>
				<DATA3>0</DATA3>
			</NODE>
		</TREEVIEWDATA>
	</xml>
	    <xml id="ITEM" style="display: none">
		<LISTVIEWDATA>
			<HEADERS>
				<HEADER>
					<NAME><spring:message code='ezApproval.t78'/></NAME>
					<WIDTH>50</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code='ezApproval.t79'/></NAME>
					<WIDTH>290</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code='ezApproval.t80'/></NAME>
					<WIDTH>80</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code='ezApproval.t81'/></NAME>
					<WIDTH>80</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code='ezApproval.t82'/></NAME>
					<WIDTH>80</WIDTH>
				</HEADER>
			</HEADERS>
		</LISTVIEWDATA>
	</xml>
	    <h1><spring:message code='ezApproval.t707'/></h1>
	    <div id="mainmenu">
	        <ul>
	            <span style="background: none; padding-top: 0;"><b><spring:message code='ezApproval.t378'/></b>
                   	<select id="ListCompany" name="ListCompany" onchange="return changeCompID()">
		    			${companySel}
					</select>
	            </span>
	            <br />
	            <br />
	            <li><span onclick="return btnAddTree_onclick()"><spring:message code='ezApproval.t708'/></span></li>
	            <li><span onclick="return btnEditTree_onclick()"><spring:message code='ezApproval.t709'/></span></li>
	            <li><span onclick="return btnDelTree_onclick()"><spring:message code='ezApproval.t710'/></span></li>
	            <li style="background: none;">
	                <img src="/images/i_bar.gif" style="vertical-align: middle"></li>
	            <li><span onclick="return btnAddItem_onclick()"><spring:message code='ezApproval.t711'/></span></li>
	            <li><span onclick="return btnEditItem_onclick()"><spring:message code='ezApproval.t712'/></span></li>
	            <li><span onclick="return btnDelItem_onclick()"><spring:message code='ezApproval.t713'/></span></li>
	        </ul>
	    </div>
	    <table class="table_manage">
	        <tr>
	            <td>
	                <div style="BORDER: #b6b6b6 1px solid; OVERFLOW-Y: auto; OVERFLOW-X: auto; WIDTH: 200px; HEIGHT: 320px; BACKGROUND-COLOR: #ffffff"
	                    id="TreeView">
	                </div>
	            </td>
	            <td style="padding-left: 5px">
	                <div class="listview">
	                    <div id="lvtForm" style="border: 0; HEIGHT: 320px; WIDTH: 560px; overflow: auto" onclick="lvtForm_onclick()" onselchanged="lvtForm_onSel_Changed()"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	</body>
</html>