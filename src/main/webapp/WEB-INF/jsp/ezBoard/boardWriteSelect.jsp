<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t135'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<style>
			.node_normal{
				padding-top: 3px;
				vertical-align:top;
				font-family: "<spring:message code='ezBoard.t347'/>";
				font-size: 9pt;
				background-color : #ffffff;
				height : 15px;
				cursor : hand;
			}
			.node_selected{
				padding-top: 3px;
				vertical-align:top;
				font-family: "<spring:message code='ezBoard.t347'/>";
				font-size: 9pt;
				height : 15px;
				background-color : #ECF3BA;
				cursor : hand;
			}
			.node_hover{
				padding-top: 3px;
				vertical-align:top;
				font-family: "<spring:message code='ezBoard.t347'/>";
				font-size: 9pt;
				background-color : #F7FAE0;
				height : 15px;
				cursor : hand;
			}
		</style>
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
			var selectedBoard = "";
			var ItemIDList = "";
			var BoardID = "";
			var BoardGroupID = "";
			
			var	SelectedBoardID = "";
			var	selectedBoardGroupID = "";	
			var SelectedBoardName = "";
			var SelectedBoardType = "";
			var ret = new Array();
			
			var SS_ServerName = "${serverName}";
			var xmlDom_treeview = createXmlDom();
			var pUse_Editor = "${useEditor}";
			var pNoneActiveX = "${noneActiveX}";
			var pUse_IE11Browser = "${useIE11Browser}";
			
		    function Select() {
		        if (SelectedBoardID == "") {
		            alert("<spring:message code='ezBoard.t179'/>");
		            return;
		        }
		
		        if (CheckIfCanWrite(SelectedBoardID) == false) {
		            alert("<spring:message code='ezBoard.t348'/>");
		            return;
		        }
       			ret = SelectedBoardID;
       			var feature = GetOpenWindowfeature(765, 820);
        		switch (SelectedBoardType) {
            		case "0":        
                		if (CrossYN() || pNoneActiveX == "YES") {
                    		window.open("/ezBoard/boardNewItem.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
                		} else {
                    if (pUse_IE11Browser == "CK") {
                        window.open("/ezBoard/boardNewItem.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
                    } else {
                        if(pUse_Editor == "") {
                            window.open("/ezBoard/boardNewItem.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
                        } else {
                            window.open("/ezBoard/boardNewItem.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
                        }
                    }
                }
                break;
	            case "3":
	            case "4":
	                var pheight = window.screen.availHeight;
	                var pwidth = window.screen.availWidth;
	                var pTop = (pheight - 720) / 2;
	                var pLeft = (pwidth - 765) / 2;
	                window.open("/ezBoard/newBoardItemPhoto.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
	                break;
	            default:
	                var feature = GetOpenWindowfeature(765, 820);
	                if (CrossYN() || pNoneActiveX == "YES") {
	                    window.open("/ezBoard/boardNewItem.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
	                }
	                else {
	                    if (pUse_IE11Browser == "CK") {
	                        window.open("/ezBoard/boardNewItem.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
	                    }
	                    else {
	                        if(pUse_Editor == "")
	                            window.open("/ezBoard/boardNewItem.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
	                        else
	                            window.open("/ezBoard/boardNewItem.do?boardID=" + SelectedBoardID + "&mode=new", "", feature, "");
	                    }
	                }
	                break;
	       		 }
	        	window.close();
			}

			function CheckIfAnonyBoard(pBoardID) {
				xmlhttp.open("POST", "/ezBoard/checkIfAnonyBoard.do?boardID=" + pBoardID, false);
				xmlhttp.send();
				var ret = xmlhttp.responseText;
				if(ret.indexOf("anonyboard") != -1) return true;
				return false;
			}
			
			function CheckIfCanWrite(pBoardID)
			{
				xmlhttp.open("POST", "/ezBoard/getACL.do?boardID=" + pBoardID, false);
				xmlhttp.send();
				var ret = xmlhttp.responseText;
				if(ret.indexOf("<WRITE>true</WRITE>") != -1) return true;
				return false;
			}
			
			function window_onload()
			{
				var xmlDom_treeview = createXMLHttpRequest();
			    xmlDom_treeview.open("GET", "/xml/organtree_config.xml", false);
				xmlDom_treeview.send();
				
				if (xmlDom_treeview.readyState == 4 && xmlDom_treeview.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlDom_treeview.responseXML);
			    }
			
				DisplayTopBoard();
			}
	
			function TreeCtrl_onNodeExpanded(pNodeID,pTreeID) 
			{
				var xmlRtn = createXmlDom();
			    var TreeIdx = pNodeID;	
				var treeNode = new TreeNode();
			    treeNode.LoadFromID(TreeIdx);
			    
			    xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1")
			    
			    if(SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0)
				{
				    if(CrossYN())
				    {
					    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
					}
					else
					{
					    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
					}
				}
				var treeView = new TreeView();
			    treeView.LoadFromID(pTreeID);
			    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
			}
			
			function TreeCtrl_onNodeClick(pNodeID,pTreeID)  
			{
				var treeNode = new TreeNode();
			    treeNode.LoadFromID(pNodeID);
			    SelectedBoardID = treeNode.GetNodeData("DATA1");	
			    SelectedBoardName = treeNode.GetNodeData("DATA2");
			    SelectedBoardType = treeNode.GetNodeData("DATA5");
			}
			
			function DisplayTopBoard()
			{
				xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=top&subFlag=0", false);
				xmlhttp.send();
				
				if(xmlhttp.responseXML.text != "ERROR")
				{
					MakeTopBoardView(xmlhttp.responseText)
				}
			}
			
			function TopBoard_onclick(obj, ID, items)
			{
			    var rootBoardID = "{" +ID+ "}";
			    var num = obj.split("TreeCtrl");
			
			    if (document.getElementById(obj).style.display != "none") {
			        document.getElementById(obj).style.display = "none";
			        document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
			        }
			    else{
			        document.getElementById(obj).style.display ="";
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
			
			function GetSubBoard(pRootBoardID, pSubFlag)
			{
				xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=" + pRootBoardID + "&subFlag=" + pSubFlag + "&selectFlag=0&pExcludeBoardID=" + BoardID, false);
				xmlhttp.send();
				
				return xmlhttp.responseXML;
			}
			
			function MakeTopBoardView(strXML)
			{
				var xmldom = createXmlDom();
				var strHTML = "";
				xmldom = loadXMLString(strXML);
				strHTML = "<table id='TopBoards' width=100% border=0>"
				var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
				var items = xmldomNodes.length;	
				for(i=0;i<xmldomNodes.length;i++)
				{
				    var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
				    tid= tid.substring(1,37);
					strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl"+i.toString()+"\" ,\""+ tid + "\""+", \"" + items + "\"" + ")' style='cursor:pointer'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</h2></td></tr>";
					strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:300px;overflow-x:hidden;'></DIV></td></tr>";
				}
				strHTML += "</table>";
				
				xmldomNodes = null;
				xmldom = null;
				
				document.getElementById("TopBoardsList").innerHTML = strHTML;
			}
			
			function CreateBoardGroup()
			{
				window.location.href = "CreateBoard_name_Cross.aspx?UpperBoardID=top";	
			}
			
			function SetTreeConfig()
			{
			    var xmlDom_treeview = createXMLHttpRequest();
			    xmlDom_treeview.open("GET", "/xml/organtree_config2.xml", false);
				xmlDom_treeview.send();
				
				if (xmlDom_treeview.readyState == 4 && xmlDom_treeview.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlDom_treeview.responseXML);
			    }
			}
			
			function SetTreeviewUnSelect(TreeviewID, items)
			{   
			    for(var i = 0; i < items; i++){
			        if(TreeviewID != "TreeCtrl"+ i){
			            document.getElementById("TreeCtrl"+ i).style.display = "none";
			            document.getElementById("TopBoardsList").getElementsByTagName("h2").item(i).className = "off";
			        }
			    }
			}
		</script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
		<h1><spring:message code='ezBoard.t135'/></h1>
		<div class="box" style="width:320px;height:550px;overflow:auto;word-break:break-all" id=TopBoardsList></div>
		<div class="btnposition">
    		<a class="imgbtn"><span onClick="Select()"><spring:message code='ezBoard.t47'/></span></a>
		</div>
	</body>
</html>