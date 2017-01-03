<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t75'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/TreeView.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/docnumui_Cross.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var Rtnval = new Array();
	        var companyID = "";
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        var ReturnFunction;
	        window.onload = function () {
	            var xmlDom = createXmlDom();
	            xmlDom = loadXMLFile("/xml/organtree_config2.xml");
	            companyID = parent.document.getElementById("ListCompany").value;
	            var treeView = new TreeView();
	            treeView.SetID("FormTreeView");
	            treeView.SetConfig(xmlDom);
	            getGroupTree(1, 1, 0, true);
	            getGroupItem(0);            
	            if (CrossYN())
	            {
	                try {
	                    ReturnFunction = parent.itemcode_dialogArgument[1];
	                } catch (e) {
	                    try {
	                        ReturnFunction = opener.itemcode_dialogArgument[1];
	                    } catch (e) {
	                    }
	                }                
	            }
	            else {
	                Rtnval[0] = "cancel"
	                window.returnValue = Rtnval;
	            }
	        }
	
	        function TreeViewRequestData(pNodeID, pTreeID) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	            node_select(pNodeID, "", pTreeID, TreeViewNodeClick);
	            var pGroupID = treeNode.GetNodeData("DATA1");
	            var pLevel = treeNode.GetNodeData("DATA3");
	
	            getGroupTree(pNodeID, parseInt(pLevel) + 1, pGroupID, false);
	            getGroupItem(pGroupID);
	        }
	
	        function TreeViewNodeClick(pNodeID, pNodeNM) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	
	            var pGroupID = treeNode.GetNodeData("DATA1");
	            getGroupItem(pGroupID);
	        }
	
	        function lvtForm_onclick() {
	        }
	
	        function lvtForm_onSel_Changed() {
	        }
	
	        function lvtForm_onSel_DBclick() {
	            btn_OK();
	        }
	
	        function btn_OK() {
	            var listview = new ListView();
	            listview.LoadFromID("FormList");
	            var oArrRows = listview.GetSelectedRows();
	
	            if (oArrRows.length > 0) {
	                var selRow = oArrRows[0];
	                Rtnval[0] = getNodeText(selRow.cells[0]);
	                Rtnval[1] = getNodeText(selRow.cells[1]);
	                Rtnval[2] = GetAttribute(selRow, "DATA2");
	                Rtnval[3] = GetAttribute(selRow, "DATA3");
	                Rtnval[4] = GetAttribute(selRow, "DATA4");
	                Rtnval[5] = GetAttribute(selRow, "DATA1");
	                Rtnval[6] = GetAttribute(selRow, "DATA5");
	
	                if (CrossYN())
	                {
	                    ReturnFunction(Rtnval);
	                    window.close();
	                }
	                else {
	                    window.returnValue = Rtnval;
	                    window.close();
	                }
	            }
	            else {
	                var pAlertContent = "<spring:message code='ezApproval.t76'/>";
	                OpenAlertUI(pAlertContent);
	            }
	        }
	
	        function btn_Cancle() {
	            if (CrossYN())
	            {
	                Rtnval[0] = "cancel"
	                ReturnFunction(Rtnval);
	                window.close();
	            }
	            else
	            {
	                Rtnval[0] = "cancel"
	                window.returnValue = Rtnval;
	                window.close();
	            }
	        }
	    </script>
	</head>
	<body class="popup">
	    <xml id='GROUP' style="display: none">
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
	    <xml id='ITEM' style="display: none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t78'/></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApproval.t79'/></NAME>
		        <WIDTH>250</WIDTH>
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
	    <h1><spring:message code='ezApproval.t83'/></h1>
	    <table>
	        <tr>
	            <td>
	                <div id="TreeView" style="height: 215px; width: 200px; overflow-x: auto; overflow-y: auto; BORDER: #b6b6b6 1px solid; BACKGROUND-COLOR: #ffffff; vertical-align: top"></div>
	            </td>
	            <td style="padding-left: 5px">
	                <div class="listview">
	                    <div id="lvtForm" style="border: 0; HEIGHT: 215px; WIDTH: 508px; overflow-x: auto; overflow-y: auto;"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn" onclick="return btn_OK()"><span><spring:message code='ezApproval.t84'/></span></a>
	        <a class="imgbtn" onclick="return btn_Cancle()"><span><spring:message code='ezApproval.t85'/></span></a>
	    </div>
	</body>
</html>