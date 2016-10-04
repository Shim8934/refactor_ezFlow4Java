<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t352' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/TreeView.js"></script>
		
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var selectedBoard = "";
	        var ItemIDList = "";
	        var BoardID = "";
	        var BoardGroupID = "";
	
	        var SelectedBoardID = "";
	        var selectedBoardGroupID = "";
	        var SelectedBoardName = "";
	        var ret = new Array();
	
	        var code = "<c:out value = '${code}' />";
	        var chkPhotoBrd = "";
	
	        var xmlDom_treeview = createXmlDom();
	        var ReturnFunction;
	        
	        function Select() {
	            if (SelectedBoardID == "") {
	                alert("<spring:message code = 'ezCommunity.t411' />");
	                return;
	            }
	
	            if (chkPhotoBrd == "3") {
	                alert("<spring:message code = 'ezCommunity.t413' />");
	                return;
	            }
	            
	            ret[0] = SelectedBoardID;
	            ret[1] = selectedBoardGroupID;
	            ret[2] = SelectedBoardName;
	
	            if (ReturnFunction != null) {
	                ReturnFunction(ret);
	            } else {
	                window.returnValue = ret;
	            }
	            
	            window.close();
	        }
	
	        function window_onload() {
                try {
                    ReturnFunction = opener.boardselect_dialogArguments[1];
                } catch (e) {
                    BoardID = dialogArguments[0];
                    BoardGroupID = dialogArguments[1];
                }
	
	            var xmlHTTP = createXMLHttpRequest();

                xmlHTTP.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);    
	            xmlHTTP.send();
	
	            DisplayTopBoard();
	        }
	
	        function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
	            var xmlRtn = createXmlDom();
	            var TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	
	            xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1")
	
	            if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
	                if (CrossYN()) {
	                    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
	                }
	                else {
	                    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	                }
	            }
	            
	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	
	        function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	            SelectedBoardID = treeNode.GetNodeData("DATA1");
	            SelectedBoardName = treeNode.GetNodeData("DATA2");
	        }
	
	        function DisplayTopBoard() {
	            xmlhttp.open("POST", "/ezCommunity/getSubBoards.do?rootBoardID=TOP&subFlag=0&classID=" + code, false);
	            xmlhttp.send();
	
	            if (xmlhttp.responseText != "ERROR") {
	                MakeTopBoardView(xmlhttp.responseText);
	            }
	        }
	
	        function TopBoard_onclick(obj, ID, items) {
	            var rootBoardID = "{" + ID + "}";
	            var num = obj.split("TreeCtrl");
	            
	            if (document.getElementById(obj).style.display != "none") {
	                document.getElementById(obj).style.display = "none";
	                document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
	            } else {
	                document.getElementById(obj).style.display = "";
	                document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "on";
	                SetTreeviewUnSelect(obj, items)
	            }

	            document.getElementById(obj).innerHTML = "";
	            SetTreeConfig();
	            var treeView = new TreeView();
	            treeView.SetID("TreeView" + obj);
	            treeView.SetRequestData("TreeCtrl_onNodeExpanded");
	            treeView.SetNodeClick("TreeCtrl_onNodeClick");
	            treeView.DataSource(GetSubBoard(rootBoardID, "1"));
	            treeView.DataBind(obj);
	        }
	        
	        function GetSubBoard(pRootBoardID, pSubFlag) {
	            xmlhttp.open("POST", "/ezCommunity/getSubBoards.do?rootBoardID=" + pRootBoardID + "&subFlag=" + pSubFlag + "&selectFlag=3&pExcludeBoardID=" + BoardID + "&classID=" + code, false);
	            xmlhttp.send();
	            return xmlhttp.responseXML;
	        }

	        function MakeTopBoardView(strXML) {
	            var xmldom = createXmlDom();
	            var strHTML = "";
	            xmldom = loadXMLString(strXML);
	            strHTML = "<table id='TopBoards' width=100% border=0>"
	            var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
	            var items = xmldomNodes.length;
	            for (var i = 0; i < xmldomNodes.length; i++) {
	                var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
	                tid = tid.substring(1, 37);
	                strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</h2></td></tr>";
	                strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;display:none;height:100%;width:300px;padding-top:5px;padding-bottom:3px'></DIV></td></tr>";
	            }
	            strHTML += "</table>";

	            xmldomNodes = null;
	            xmldom = null;

	            document.getElementById("TopBoardsList").innerHTML = strHTML;
	        }
	        
	        function SetTreeConfig() {
	            var xmlDom_treeview = createXMLHttpRequest();
	            
	            xmlDom_treeview.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
	            xmlDom_treeview.send();

	            if (xmlDom_treeview.readyState == 4 && xmlDom_treeview.status == 200) {
	                var treeView = new TreeView();
	                treeView.SetConfig(xmlDom_treeview.responseXML);
	            }
	        }
	        function SetTreeviewUnSelect(TreeviewID, items) {
	            for (var i = 0; i < items; i++) {
	                if (TreeviewID != "TreeCtrl" + i) {
	                    document.getElementById("TreeCtrl" + i).style.display = "none";
	                    document.getElementById("TopBoardsList").getElementsByTagName("h2").item(i).className = "off";
	                }
	            }
	        }
		</script>
	</head>
	<body class="popup" onload = "javascript:window_onload()" style="overflow: hidden">
		<h1><spring:message code = 'ezCommunity.t359' /></h1>
	    <div class="box" style="width: 320px; height: 550px; overflow: auto; word-break: break-all" id="TopBoardsList"></div>
	    <div class="btnposition">
	        <a class="imgbtn" name="Submit" onclick="Select()"><span><spring:message code = 'ezCommunity.t278' /></span></a>
	    </div>
	    
	</body>
</html>