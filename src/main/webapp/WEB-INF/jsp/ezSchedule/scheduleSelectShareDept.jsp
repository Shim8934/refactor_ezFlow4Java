<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t1004' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />	    
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var ReturnFunction;	
			var companyID = opener.companyID;
		    window.onload = function () {
		        try {
		            ReturnFunction = opener.schedule_select_sharedept_cross_dialogArguments[1];
		        } catch (e) { }
		        getDeptFullTree("<c:out value='${deptID}'/>");
		    }
	
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();		        
		        xmlHTTP.open("GET", "/xml/common/organtree_config3.xml", false);
		        xmlHTTP.send();
		        
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }
	
		    function getDeptFullTree(deptid) {
		        g_xmlHTTP = createXMLHttpRequest();
		        var strQuery = "<DATA><DEPTID></DEPTID><TOPID>"+companyID+"/other</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	
		        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		        g_xmlHTTP.send(strQuery);
		    }
	
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.status == 200) {
		                Tree_setconfig();
	
		                var treeView = new TreeView();
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("TreeViewRequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(g_xmlHTTP.responseXML);
		                treeView.DataBind("TreeView");
		            } else {
		            	alert("<spring:message code='ezSchedule.t1' />" + g_xmlHTTP.statusText);
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
		        }
		        else {
		            window.returnValue = treeNode.GetNodeData("CN") + ":" + treeNode.GetNodeData("VALUE");
		        }
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezSchedule.t1004' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table>
	    	<tr>
	        	<td style="padding-right:5px">
	            	<div style="border: 1px solid #ddd; padding-top:3px; height: 476px; width:278px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF" id="TreeView"></div>
	        	</td>
	        </tr>
	    </table>	    
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="select_dept()" ><spring:message code='ezSchedule.t4' /></span></a>
	    </div>
	</body>
</HTML>
