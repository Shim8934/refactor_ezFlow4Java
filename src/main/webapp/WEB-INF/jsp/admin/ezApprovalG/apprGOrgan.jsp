<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t344'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/control_Cross/TreeView.js" ></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var DeptID, DeptName;
	        var xmlHTTP = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var P_companyID;
	        var P_DeptID;
	        var Para = new Array();
	        var topID = "";
	        var ReturnFunction;
	
	        
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        window.onload = function () {
	            try {
	                dialogArguments = opener.organ_dialogArguments[0];
	                ReturnFunction = opener.organ_dialogArguments[1];
	            } catch (e) { }
	
	            topID = dialogArguments;
	            
	            if (topID == "")
	                topID = "top";
	
	            Tree_setconfig();
	
	            TreeViewinitialize("", topID, "extensionAttribute2;extensionAttribute3", "${serverName}");
	            Para[0] = "";
	            Para[1] = "";
	            window.returnValue = Para;
	        }
	
	        function Tree_setconfig() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                
	                treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
	            }
	        }
	        function pNodeDblClick() {
	
	        }
	        function bt_Ok_onclick() {
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            nodeIdx = treeView.GetSelectNode();
	
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);
	            if (treeNode.GetNodeData("EXTENSIONATTRIBUTE2") == topID) {
	                Para[0] = treeNode.GetNodeData("CN");
	                Para[1] = treeNode.GetNodeData("VALUE");
	
	                if(ReturnFunction != null)
	                    ReturnFunction(Para);
	                window.close();
	            }
	            else {
	                alert("<spring:message code='ezApproval.t774'/>");
	            }
	        }
	
	        function bt_Close_onclick() {
	            Para[0] = "";
	            Para[1] = "";
	
	            if (ReturnFunction != null)
	                ReturnFunction(Para);
	            window.close();
	        }
	    var nodeIdx;
	    function TreeViewNodeClick() {
	        nodeIdx = TreeView.selectedIndex;
	    }
	
	    function TreeViewNodeDbClick() {
	    }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApproval.t344'/></h1>
	    <div id="TreeView" style="border: 1px solid #B6B6B6; height: 370px; width: 250px; overflow-x: hidden; overflow-y: auto; background-color: #FFFFFF;" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div>
	    <div class="btnposition">
	        <a class="imgbtn" onclick="bt_Ok_onclick()"><span><spring:message code='ezApproval.t84'/></span></a>
	        <a class="imgbtn" onclick="bt_Close_onclick()"><span><spring:message code='ezApproval.t70'/></span></a>
	    </div>
	</body>
</html>