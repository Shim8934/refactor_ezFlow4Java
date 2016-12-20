<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezBoard.t178'/></title>
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script language="javascript">
		    var xmlhttp = createXMLHttpRequest();
		    var selectedBoard = "";
		    var ItemIDList = "${itemIDList}";
		    var BoardIDList = "${boardID}";
		    var xmlDom_treeview = createXmlDom();
		    var ReturnFunction;
		
		    function Select() {
		        if (selectedBoard == "") {
		            alert("<spring:message code='ezBoard.t179'/>");
		            return;
		        }
		        if (CheckIfAnonyBoard(selectedBoard) == "1") {
		            alert("<spring:message code='ezBoard.t180'/>");
		            return;
		        }
		        if (CheckIfAnonyBoard(selectedBoard) == "2") {
		            alert("<spring:message code='ezBoard.t999070'/>");
		            return;
		        }
		        if (BoardIDList.indexOf(selectedBoard) != -1) {
		            alert("<spring:message code='ezBoard.t139'/>");
		            return;
		        }
		        if (CheckIfCanWrite(selectedBoard) == false) {
		            alert("<spring:message code='ezBoard.t354'/>");
		            return;
		        }
		        MoveItem(selectedBoard);
		    }
		    function cancel() {
		        window.close();
		    }
		    function CheckIfCanWrite(pBoardID) {
		        xmlhttp.open("POST", "/ezBoard/getACL.do?boardID=" + pBoardID + "&accessID=" + "${userInfo.id}", false);
		        xmlhttp.send();
		        var ret = xmlhttp.responseText;
		        if (ret.indexOf("<WRITE>true</WRITE>") != -1) return true;
		        return false;
		    }
		    var rtnVal = "";
		    function MoveItem(pDestBoardID) {
		        var destItemIDList = "";
		        xmlhttp.open("POST", "/ezBoard/moveItem.do?orgItemIDList=" + ItemIDList + "&orgBoardID=" + BoardIDList + "&destItemIDList=" + destItemIDList + "&destBoardID=" + pDestBoardID, false);
		        xmlhttp.send();
		        if (xmlhttp.responseText.indexOf("OK") > -1) {
		            alert("<spring:message code='ezBoard.t126'/>");
		            rtnVal = "OK";
		            window.close();
		        } else {
		            rtnVal = "ERROR";
		            window.close();
		            alert("<spring:message code='ezBoard.t181'/>" + xmlhttp.responseText);
		        }
		    }
		    window.onunload = function () {
		        if (ReturnFunction != null)
		            ReturnFunction(rtnVal);
		        else
		            window.returnValue = rtnVal;
		    };
		    function CheckIfAnonyBoard(pBoardID) {
		        var xmlhttp2 = createXMLHttpRequest();
		        xmlhttp2.open("POST", "/ezBoard/checkIfAnonyBoard.do?boardID=" + pBoardID, false);
		        xmlhttp2.send();
		        var retval = "0";
		        if (xmlhttp2.responseText.indexOf("anonyboard") > -1)
		            retval = "1";
		        else if (xmlhttp2.responseText.indexOf("attributeextension") > -1)
		            retval = "2";
		        xmlhttp2 = null;
		        return retval;
		    }
		    window.onload = function () {
		
		        try {
		            ReturnFunction = opener.moveboarditem_cross_dialogArguments[1];
		        } catch (e) { }
		
		
		
		        var xmlDom_treeview = createXMLHttpRequest();
		        xmlDom_treeview.open("GET", "/xml/organtree_config2.xml", false);
		        xmlDom_treeview.send();
		        if (xmlDom_treeview.readyState == 4 && xmlDom_treeview.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlDom_treeview.responseXML);
		        }
		        DisplayTopBoard();
		    };
		    function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
		        var xmlRtn = createXmlDom();
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1");
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
		        selectedBoard = treeNode.GetNodeData("DATA1");
		    }
		    function DisplayTopBoard() {
		        xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=top&subFlag=0", false);
		        xmlhttp.send();
		        if (xmlhttp.responseText.indexOf("ERROR") == -1) {
		            MakeTopBoardView(xmlhttp.responseText);
		        }
		    }
		    function TopBoard_onclick(obj, ID, items) {
		        var rootBoardID = "{" + ID + "}";
		        var num = obj.split("TreeCtrl");
		        if (document.getElementById(obj).style.display != "none") {
		            document.getElementById(obj).style.display = "none";
		            document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
		        }
		        else {
		            document.getElementById(obj).style.display = "";
		            document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "on";
		            SetTreeviewUnSelect(obj, items);
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
		        xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=" + pRootBoardID + "&subFlag=" + pSubFlag + "&selectFlag=0", false);
		        xmlhttp.send();
		        return xmlhttp.responseXML;
		    }
		    function MakeTopBoardView(strXML) {
		        var xmldom = createXmlDom();
		        var strHTML = "";
		        xmldom = loadXMLString(strXML);
		        strHTML = "<table id='TopBoards' width=100% border=0>";
		        var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
		        var items = xmldomNodes.length;
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
		            tid = tid.substring(1, 37);
		            strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</h2></td></tr>";
		            strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:300px;overflow-x:hidden;'></DIV></td></tr>";
		        }
		        strHTML += "</table>";
		        xmldomNodes = null;
		        xmldom = null;
		        document.getElementById("TopBoardsList").innerHTML = strHTML;
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
		</script>
	</head>
	<body class="popup"> 
		<h1><spring:message code='ezBoard.t135'/></h1>
		<div class="box" style="width:316px;height:490px;overflow:auto" id=TopBoardsList></div>
		<div class="btnposition">
		    <a class="imgbtn" name="Submit"  onClick="Select()" ><span><spring:message code='ezBoard.t47'/></span></a>
		    <a class="imgbtn" name="Submit"  onClick="javascript:window.close();" ><span><spring:message code='ezBoard.t15'/></span></a>
		</div>
	</body>
</html>