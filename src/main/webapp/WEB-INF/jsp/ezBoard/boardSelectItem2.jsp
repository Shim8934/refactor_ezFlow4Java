<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezBoard.khj1' /></title>
<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
<style>
	.node_div span {
		max-width:365px;
		overflow:hidden;
		text-overflow:ellipsis;
	}
</style>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
<script type="text/javascript">
	var xmlhttp = createXMLHttpRequest();
	var treeView = new TreeView();
	var selectedBoard = "";
	var selectedBoardName = "";
	var selectedBoardtype = "";
	var selectedBoardParentBoardID = "";
	var board_alertArguments = new Array();

	window.onload = function () {
		SetTreeConfig();
        makeTreeList();
    };
    
    function makeTreeList() {
    	document.getElementById("TopBoardsList").innerHTML = "";
    	treeView.SetID("FromTreeView");
    	treeView.SetNodeClick("TreeCtrl_onNodeClick");
        treeView.SetRequestData("TreeCtrl_onNodeExpanded");
        treeView.DataSource(GetSubBoard("top", "1"));
        treeView.DataBind("TopBoardsList");
    }
    function GetSubBoard(pRootBoardID, pSubFlag) {
        xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=" + encodeURIComponent(pRootBoardID) + "&subFlag=" + pSubFlag + "&selectFlag=0", false);
        xmlhttp.send();
        return xmlhttp.responseXML;
    }   
    function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
        var treeNode = new TreeNode();
        treeNode.LoadFromID(pNodeID);
        selectedBoard = treeNode.GetNodeData("DATA1"); 		//아이디
        selectedBoardName = treeNode.GetNodeData("DATA2");  //이름
        selectedBoardtype = treeNode.GetNodeData("DATA5");  //타입
        selectedBoardParentBoardID = treeNode.GetNodeData("DATA3"); 
        newguBun = treeNode.GetNodeData("DATA5");
        
    }
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
        
        /* 2018-10-10 홍승비 - boardLeft.jsp에서 하위게시판 ellipsis 부분 가져옴 */
        /* var node = document.getElementById(TreeIdx);
        var title2 = node.getElementsByClassName("node_div");
        var nodeLevel = title2[0].getAttribute("nodelevel");
        if(nodeLevel > 9) {
        	nodeLevel = 9;
        }
        for(var i=0; i<title2.length; i++) {
        	title3 = title2[i].getElementsByClassName("node_normal");
        	title3[0].setAttribute("TITLE", title3[0].parentElement.getAttribute("DATA2")); 
        	title3[0].style.width = 362 - 18*nodeLevel +'px';
        	title3[0].style.textOverflow = 'ellipsis';
        	title3[0].style.overflow = 'hidden';
        } */
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
   	function Select() {
   		board_alertArguments[1] = DivPopUpHidden;

   		if (selectedBoard == "") {
    		var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t138' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t138'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
			DivPopUpShow(330, 205, pUrl);
            return;
        }
   		opener.document.getElementById("selectedBoard").value = selectedBoard;
   		opener.document.getElementById("selectedBoardParentBoardID").value = selectedBoardParentBoardID;
   		opener.document.getElementById("selectedBoardName").innerHTML = selectedBoardName;
   		//console.log(selectedBoardParentBoardID);
   		window.close();
   	}
   	
   	function AllSelect() {
   		opener.document.getElementById("selectedBoard").value = "all";
   		opener.document.getElementById("selectedBoardName").innerHTML = "<spring:message code='ezBoard.khj5' />";
   		window.close();
   	}
</script>
</head>
<body class="popup">
	<h1><spring:message code='ezBoard.khj1'/></h1>
	<div id="close">
        <ul>
            <li><span onclick="javascript:window.close()"></span></li>
        </ul>
    </div>
	<div class="box" style="width: auto;height:465px;overflow:auto;overflow-x:hidden;margin-left:5px;margin-rignt:5px; padding: 10px;" id=TopBoardsList></div>
	<div class="btnposition btnpositionNew">
		<a class="imgbtn" onclick="AllSelect()"><span><spring:message code='ezBoard.khj3'/></span></a>
		<a class="imgbtn" name="Submit"  onClick="Select()" ><span><spring:message code='ezBoard.t47'/></span></a>
	</div>
	
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>