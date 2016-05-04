<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	    <link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
	    <script type="text/javascript">
	        var treeView = new TreeView();
	        var pSelID = "${selID}";
	        var ReturnFunction;
	        
	        window.onload = function () {
	            try {
	                ReturnFunction = parent.myboard_movecopy_dialogArguments[1];
	            } catch (e) {}
	            SetTreeConfig();
	            treeView.SetID("FromTreeView");
	            treeView.SetNodeClick("TreeCtrl_onNodeClick");
	            treeView.SetRequestData("TreeCtrl_onNodeExpanded");
	            treeView.DataSource(GetMyBoardItem("0"));
	            treeView.DataBind("TreeCtrl_MyBoardTree");
	        };
	        function GetMyBoardItem(pRootTreeID) {
	            var xmlhttp4 = createXMLHttpRequest();
	            xmlhttp4.open("POST", "/ezBoard/getMyBoardsConfig.do?rootTreeID=" + pRootTreeID, false);
	            xmlhttp4.send();
	            var ret = xmlhttp4.responseXML;
	            xmlhttp4 = null;
	            return ret;
	        }
	
	        function SetTreeConfig() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                treeView.SetConfig(xmlHTTP.responseXML);
	            }
	
	        }
	        var SelectedBoardID = "";
	        var SelectedBoardName = "";
	        var selectedBoardtype = "";
	        var selNewBoard = false;
	        function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	            SelectedBoardID = treeNode.GetNodeData("DATA1");
	            selectedBoardtype = treeNode.GetNodeData("DATA4");
	            SelectedBoardName = treeNode.GetNodeData("VALUE");
	            if (treeNode.GetNodeData("DATA3") == '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}')
	                selNewBoard = true;
	        }
	        function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
	            var xmlRtn = createXmlDom();
	            var TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            xmlRtn = GetMyBoardItem(treeNode.GetNodeData("DATA1"));
	            if (SelectNodes(xmlRtn, "TREEVIEWDATA/NODE/VALUE").length > 0) {
	                if (CrossYN()) {
	                    xmlRtn.getElementsByTagName("TREEVIEWDATA")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("TREEVIEWDATA")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
	                }
	                else {
	                    xmlRtn.selectNodes("TREEVIEWDATA/NODE")[0].appendChild(xmlRtn.selectNodes("TREEVIEWDATA/NODE/VALUE")[0]);
	                }
	            }
	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	
	        function btn_MoveCopy_onclick(pMode) {
	            if (SelectedBoardID == "") {
	                alert("<spring:message code='ezBoard.t10035'/>");
	                return;
	            }
	            if (pSelID == SelectedBoardID) {
	                alert("<spring:message code='ezBoard.t10047'/>"); 
	                return;
	            }
	            if (selectedBoardtype == "BOARD") {
	                alert("<spring:message code='ezBoard.t10036'/>");
	                return;
	            }
	
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "PSELTREEID", pSelID);
	            createNodeAndInsertText(xmlpara, objNode, "PMOVETREEID", SelectedBoardID);
	            createNodeAndInsertText(xmlpara, objNode, "PMODE", pMode);
	
	            xmlhttp.open("POST", "/ezBoard/setMyBoardMoveCopy.do", false);
	            xmlhttp.send(xmlpara);
	
	            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
	                if (getNodeText(GetChildNodes(xmlhttp.responseXML)[0]) == "OK") {
	                    alert("<spring:message code='ezBoard.t126'/>");
	
	                    if (ReturnFunction != null) {
	                        ReturnFunction("TRUE");
	                    } else {
	                        window.returnValue = "TRUE";
	                        window.close();
	                    }
	
	                }
	            }
	        }
	        function Wclose() {
	            if (CrossYN()) {
	                parent.DivPopUpHidden();
	            }
	            else {
	                window.close();
	            }
	        }
	    </script>
	</head>
	<body class="popup">
	     <h1 style="margin-bottom: 0px;"><spring:message code='ezBoard.t134'/></h1> 
	    <div id="close">
	        <ul>
	            <li><span onclick="Wclose()"><spring:message code='ezBoard.t12'/></span></li>
	        </ul>
	    </div>
	
	    <table class="popuplist" style="width: 100%">
	        <tr>
	            <td class="pos1">
	                <div class="tree" style='width: auto; overflow-x: auto; overflow-y: auto; margin-left: 5px; height: 285px;' id='TreeCtrl_MyBoardTree'></div>
	            </td>
	
	            <td class="pos3">
	                <a href="#" class="imgbtn"><span onClick="return btn_MoveCopy_onclick('MOVE')"><spring:message code='ezBoard.t134'/></span></a>
	                <%--<a href="#" class="imgbtn"><span onClick="return btn_MoveCopy_onclick('COPY')">복사</span></a>--%>
	            </td>
	        </tr>
	    </table>
	</body>
</html>