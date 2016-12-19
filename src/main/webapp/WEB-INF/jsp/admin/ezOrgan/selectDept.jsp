<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t248" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e3' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var g_xmlHTTP = null;
			var ReturnFunction;
		    var topid = "<c:out value='${companyID}'/>";
		    
		    $(document).ready(function(){
		    	try {
		            ReturnFunction = opener.selectdept_cross_dialogArguments[1];
		            subtitle.innerText = opener.selectdept_cross_dialogArguments[0];
		        } catch (e) {
		            subtitle.innerText = window.dialogArguments;
		        }
		        getDeptFullTree(topid);
		    });
		    
		    function Tree_setconfig() {
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/common/organtree_config3.xml", false);			    
			    xmlHTTP.send();
			    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlHTTP.responseXML);
			    }
			}
		    
		    function getDeptFullTree(deptid){
			    g_xmlHTTP = createXMLHttpRequest();
				var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP></DATA>";

				g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
				g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
				g_xmlHTTP.send(strQuery);
			}
		    
		    function event_getDeptFullTree(){
				if(g_xmlHTTP != null && g_xmlHTTP.readyState == 4){
					if (g_xmlHTTP.statusText == "OK"){
					    Tree_setconfig();

					    var treeView = new TreeView();
					    treeView.SetID("FromTreeView");
					    treeView.SetUseAgency(true);
					    treeView.SetRequestData("TreeViewRequestData");
					    treeView.SetNodeClick("TreeViewNodeClick");
					    treeView.SetNodeDblClick("TreeViewNodeDbClick");
					    treeView.DataSource(g_xmlHTTP.responseXML);
					    treeView.DataBind("TreeView");
					}else{	
						alert("<spring:message code='ezOrgan.t1' />" + g_xmlHTTP.statusText)
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
			        if (CrossYN()){
			            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
			        }else{
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
			
			function OK_Click(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex != -1){					
				    if(ReturnFunction != null){				    	
		                ReturnFunction(treeNode.GetNodeData("CN"));
				    }else{
		                window.returnValue = treeNode.GetNodeData("CN");
				    }
					window.close();
				}else{
					alert("<spring:message code='ezOrgan.t249' />");
				}
			}
	    </script>
	</head>
	<body class="popup">
		<h1 id="subtitle"><spring:message code='ezOrgan.t248' /></h1>		
		<div style="border: 1px solid #b6b6b6; height: 256px; width: 265px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF" id="TreeView"></div>
		<div class="btnposition">
		    <a id="btnSave" class="imgbtn" onClick="OK_Click()"><span><spring:message code='ezOrgan.t124' /></span></a>
		    <a id="btnCancel"class="imgbtn" onClick="window.close()"><span><spring:message code='ezOrgan.t125' /></span></a>
		</div>
	</body>
</html>