<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript">
	        var treeView = new TreeView();
	        var pSelID = "<c:out value='${selID}'/>";
	        var pNodeTreeID = "<c:out value='${nodeID}'/>";
	        var orgSelectedBoardtype = "${selectedBoardtype}";
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
	            xmlhttp4.open("POST", "/ezBoard/getMyBoardsConfig.do?rootTreeID=" + encodeURIComponent(pRootTreeID), false);
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
	        var selectedNodeID = "";
	        var selNewBoard = false;
	        function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	            SelectedBoardID = treeNode.GetNodeData("DATA1");
	            selectedBoardtype = treeNode.GetNodeData("DATA4");
	            SelectedBoardName = treeNode.GetNodeData("VALUE");
	            selectedNodeID = treeNode.GetNodeData("id");
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
	            // 하위게시판 아래에 게시판을 이동하려는 경우 (게시판 하위에 추가할 수 없습니다.)
	            if (orgSelectedBoardtype == "BOARD" && selectedBoardtype == "BOARD") {
	                alert("<spring:message code='ezBoard.t10041'/>");
	                return;
	            }
	        	// 하위게시판 아래에 분류를 이동하려는 경우 (게시판에는 하위를 추가할 수 없습니다.)
	            if (orgSelectedBoardtype == "TREE" && selectedBoardtype == "BOARD") {
	                alert("<spring:message code='ezBoard.t10036'/>");
	                return;
	            }
				
	            if (selectedNodeID.indexOf(pNodeTreeID) == 0) {
	            	alert("<spring:message code='ezBoard.t10047'/>");
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
	            <li><span onclick="Wclose()"></span></li>
	        </ul>
	    </div>
	
	    <table class="popuplist" style="width: 100%">
	        <tr>
	            <td class="pos1" style="border:1px solid #ddd">
	                <div class="tree" style='width: 277px; overflow-x: auto; overflow-y: auto; height: 255px;' id='TreeCtrl_MyBoardTree'></div>
	            </td>	
	        </tr>
	    </table>
	    <div class="btnpositionNew">
	    	<a class="imgbtn"><span onClick="return btn_MoveCopy_onclick('MOVE')"><spring:message code='ezBoard.t134'/></span></a>
	    </div>	
	</body>
</html>