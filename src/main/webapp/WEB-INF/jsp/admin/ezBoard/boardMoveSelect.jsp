<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t135" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <link rel="stylesheet" href='/css/email_tree.css' type="text/css" />
	    <script type="text/javascript" src="/js/TreeView.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>	        
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
		<script type="text/javascript" language="javascript">
			var xmlhttp = createXMLHttpRequest();
			var selectedBoard = "";
			var ItemIDList = "";
			var BoardID = " ";
			var BoardGroupID = "";
			var code = "";
	
			var	SelectedBoardID = "";
			var	selectedBoardGroupID = "";	
			var SelectedBoardName = "";
			var ret = new Array();
	
			var SS_ServerName = "${serverName}";
			var xmlDom_treeview = createXmlDom();
			var tmpSelectedBoardGroupID = "";
			var tmpSelectedBoardGroupName = "";
			var ReturnFunction;
			var RetValue;
			
			$(document).ready(function(){
				try {
			        RetValue = parent.boardmoveselect_cross_dialogArguments[0];
			        ReturnFunction = parent.boardmoveselect_cross_dialogArguments[1];
			    } catch (e) {
			        try {
			            RetValue = opener.boardmoveselect_cross_dialogArguments[0];
			            ReturnFunction = opener.boardmoveselect_cross_dialogArguments[1];
			        } catch (e) {
			            RetValue = window.dialogArguments;
			        }
			    }

			    BoardID = RetValue[0]
			    BoardGroupID = RetValue[1];
			        
				var xmlHTTP = createXMLHttpRequest();
				xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
				xmlHTTP.send();

				DisplayTopBoard();
			});
			
			function GetSubBoard(pRootBoardID, pSubFlag) {
	        	var ret;

	        	$.ajax({
					type : "POST",
					dataType : "xml",
					async : false,
					url : "/ezBoard/getSubBoards.do",	        			
					data : { rootBoardID : pRootBoardID, subFlag : pSubFlag, selectFlag : "0"},
					success: function(result){
						ret = result;				
					}
				});
	        	
	        	return ret;
	        }
			
			function Select(){
				var objGList = document.all("GChkBox");
				
				if( SelectedBoardID == "" && tmpSelectedBoardGroupID == "" ){
				    alert("<spring:message code='ezBoard.t138'/>");
					return;
				}
				
				if( SelectedBoardID == BoardID )
				{
				    alert("<spring:message code='ezBoard.t139'/>");
					return;
				}
				
				if( tmpSelectedBoardGroupID != "" )
				{
					ret[0] = tmpSelectedBoardGroupID;
					ret[1] = tmpSelectedBoardGroupID;
					ret[2] = tmpSelectedBoardGroupName;
				}
				else
				{
					ret[0] = SelectedBoardID;
					ret[1] = selectedBoardGroupID;
					ret[2] = SelectedBoardName;
				}
				if (ReturnFunction !=null)
				    ReturnFunction(ret);
				else
				    window.returnValue = ret;
				window.close();
			}
			
			function DisplayTopBoard(){
				$.ajax({
					data : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getSubBoards.do",
					data : { rootBoardID : 'top', subFlag : '0'},
					success : function(result){
						MakeTopBoardView(result);
					}
				});				
			}
			
			function MakeTopBoardView(strXML) {
			    var xmldom = createXmlDom();
			    var strHTML = "";
			    xmldom = loadXMLString(strXML);
			    strHTML = "<table id='TopBoards' width=100% border=0>"
			    var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
			    var items = xmldomNodes.length;
			    for (i = 0; i < xmldomNodes.length; i++) {
			        var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
			        tid = tid.substring(1, 37);
			        strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</h2></td></tr>";
			        strHTML += "<tr id='TreeArea' ><td style='background-color:rgb(229, 229, 229)'><div class='tree' id='TreeCtrl" + i.toString() + "' style='display:none;width:300px;overflow-x:hidden;'></div></td></tr>";
			    }
			    strHTML += "</table>";

			    xmldomNodes = null;
			    xmldom = null;

			    document.getElementById("TopBoardsList").innerHTML = strHTML;
			}
			
			function TopBoard_onclick(obj, ID, items){
			    tmpSelectedBoardGroupID = document.getElementById("{" + ID + "}").id;
			    if (CrossYN())
			        tmpSelectedBoardGroupName = document.getElementById("{" + ID + "}").textContent;
			    else
			        tmpSelectedBoardGroupName = document.getElementById("{" + ID + "}").innerText;
			    SelectedBoardID = tmpSelectedBoardGroupID;
			    var rootBoardID = "{" + ID + "}";
			    var num = obj.split("TreeCtrl");
			    if (document.getElementById(obj).style.display != "none") {
			        document.getElementById(obj).style.display = "none";
			        document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
			    }
			    else {
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
			
			function SetTreeConfig() {
			    var xmlDom_treeview = createXMLHttpRequest();
			    xmlDom_treeview.open("GET", "/xml/organtree_config2.xml", false);
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
			
			function TreeCtrl_onNodeClick(pNodeID, pTreeID){
			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(pNodeID);
			    tmpSelectedBoardGroupID = "";
			    tmpSelectedBoardGroupName = "";
			    SelectedBoardID = treeNode.GetNodeData("DATA1");
			    selectedBoardGroupID = treeNode.GetNodeData("DATA1")
			    SelectedBoardName = treeNode.GetNodeData("DATA2")
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
			
	    </script>
	</head>
	<body class="popup" style ="overflow:hidden">
		<h1><spring:message code="ezBoard.t135" /></h1>
		<div class="box" style="width:320px;height:550px;overflow:auto;word-break:break-all" id=TopBoardsList></div>
		<div class="btnposition">
			<a class="imgbtn" name="Submit" onClick="Select()" ><span><spring:message code="ezBoard.t47" /></span></a>
		</div>
	</body>
</html>