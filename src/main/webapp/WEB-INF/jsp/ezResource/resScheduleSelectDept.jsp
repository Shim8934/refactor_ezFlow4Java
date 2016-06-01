<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
		<script type="text/javascript">
			var ReturnFunction;
	    	window.onload = function () {
	        	try {
		            ReturnFunction = opener.schedule_select_dept_dialogArguments[1];
		        }
	        	catch (e) {
	        	}
	        	getDeptFullTree('${userInfo.deptID}');
	    	}

	    	function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
	        	xmlHTTP.open("GET", "/xml/ezResource/organtree_config3.xml", false);
	        	xmlHTTP.send();
	        	if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
	        	}
	    	}

	    	function getDeptFullTree(deptid) {
		        g_xmlHTTP = createXMLHttpRequest();
	        	var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";

	        	g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	        	g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	        	g_xmlHTTP.send(strQuery);
	    	}

	    	function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	            	if (g_xmlHTTP.statusText == "OK") {
		                Tree_setconfig();

	                	var treeView = new TreeView();
	                	treeView.SetID("FromTreeView");
	                	treeView.SetUseAgency(true);
	                	treeView.SetRequestData("TreeViewRequestData");
	                	treeView.SetNodeClick("TreeViewNodeClick");
	                	treeView.SetNodeDblClick("TreeViewNodeDbClick");
	                	treeView.DataSource(g_xmlHTTP.responseXML);
	                	treeView.DataBind("TreeView");
	            	} else {
	                	alert(g_xmlHTTP.statusText)
		                g_xmlHTTP = null;
	            	}
	        	}
	    	}

	    	function TreeViewRequestData(pNodeID, pTreeID) {
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
	        	createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName");

		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	        	xmlHTTP.send(xmlpara);
	        	xmlRtn = loadXMLString(xmlHTTP.responseText);
	        	if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
	            	if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		            } else {
	                	xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	            	}
	        	}

	        	var treeView = new TreeView();
	        	treeView.LoadFromID("FromTreeView");
	        	treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	    	}

		    function TreeViewNodeClick() {
		        return;
	    	}

	    	function TreeViewNodeDbClick() {
		        return;
		    }

	    	function select_dept() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
	    	    var nodeIdx = treeView.GetSelectNode();
	        	var treeNode = new TreeNode();
	        	treeNode.LoadFromID(nodeIdx.NodeID);

	        	var nodeIdx = treeNode.selectedIndex;

	        	if (nodeIdx == -1) {
	            	alert(strLang94);
	            	return;
	        	}

	        	if (ReturnFunction != null) {
		            ReturnFunction(treeNode.GetNodeData("CN") + ":" + treeNode.GetNodeData("VALUE"));
	        	} else {
	            	window.returnValue = treeNode.GetNodeData("CN") + ":" + treeNode.GetNodeData("VALUE");
	        	}
	        	window.close();
	    	}
		</script>
	</head>
	<body class="popup">
    	<h1>${title}</h1>
	    <table>
			<tr>
        		<td style="padding-right:5px">
            		<div style="border: 1px solid #b6b6b6; height: 326px; width: 253px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF" id="TreeView"></div>
        		</td>
			</tr>
		</table>
    
    	<div class="btnposition">
        	<a class="imgbtn"><span onclick="select_dept()" ><spring:message code='ezResource.t15'/></span></a>
        	<a class="imgbtn"><span onclick="window.close()"><spring:message code='ezResource.t16'/></span></a>      
    	</div>
	</body>
</html>