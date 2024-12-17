<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t135" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css" />
	    <style>
			.groupBoard {
				width:266px;
				overflow:hidden;
				text-overflow:ellipsis;
				display: inline-block;
			}
			.node_div span {
				width:266px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
		</style>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>	        
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	    
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
	
			var SS_ServerName = "<c:out value='${serverName}'/>";
			var xmlDom_treeview = createXmlDom();
			var tmpSelectedBoardGroupID = "";
			var tmpSelectedBoardGroupName = "";
			var ReturnFunction;
			var RetValue;
			
			$(document).ready(function(){
				try {
// 			        RetValue = parent.boardmoveselect_cross_dialogArguments[0];
			        ReturnFunction = parent.boardmoveselect_cross_dialogArguments[0];
			    } catch (e) {
			        try {
// 			            RetValue = opener.boardmoveselect_cross_dialogArguments[0];
			            ReturnFunction = opener.boardmoveselect_cross_dialogArguments[0];
			        } catch (e) {
			            RetValue = window.dialogArguments;
			        }
			    }

// 			    BoardID = RetValue[0]
// 			    BoardGroupID = RetValue[1];
			        
				var xmlHTTP = createXMLHttpRequest();
				xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
				xmlHTTP.send();

				DisplayTopBoard();
			});
			
			function GetSubBoard(pRootBoardID, pSubFlag) {
	        	var ret;

	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getSubBoards.do",
					data : {
						rootBoardID : pRootBoardID,
						subFlag : pSubFlag,
						selectFlag : "0",
						isAdminLeft : "Y"
					},
					success: function(result){
						ret = loadXMLString(result);				
					}
				});
	        	
	        	return ret;
	        }
			
			/* 2018-08-06 홍승비 - 대상게시판선택 레이어팝업 추가, 게시물 이동+복사 팝업창과 같도록 UI 통일 */
			 var board_alertArguments = new Array();
			function Select()
			{
				board_alertArguments[1] = DivPopUpHidden;
				var objGList = document.all("GChkBox");
				
				if( SelectedBoardID == "" && tmpSelectedBoardGroupID == "" ) {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t138' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t138'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}
				
				if( SelectedBoardID == BoardID )
				{
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t139' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t139'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
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
				if (ReturnFunction !=null){
				    ReturnFunction(ret);	
				}
				else
				    window.returnValue = ret;
				window.close();
			}
			
			function DisplayTopBoard(){
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getSubBoards.do",
					data : {
						rootBoardID : 'top',
						subFlag : '0',
						isAdminLeft : "Y"
					},
					success : function(result){
						MakeTopBoardView(result);
					}
				});				
			}
			
			function MakeTopBoardView(strXML) {
			    var xmldom = createXmlDom();
			    var strHTML = "";
			    xmldom = loadXMLString(strXML);
			    strHTML = "<table id='TopBoards' width=100% border=0>";
			    
			    var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
		        if (xmldomNodes == null || xmldomNodes == false) {
		        	xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        }
			    
			    var items = xmldomNodes.length;
			    for (i = 0; i < xmldomNodes.length; i++) {
					var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
			        tid = tid.substring(1, 37);
			        
			        if (i == 0) {
						strHTML += "<tr><td><h2 style='border-top:0px' id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";
			        } else {
			        	strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";
			        }
			        strHTML += "<tr id='TreeArea' ><td><div class='tree' id='TreeCtrl" + i.toString() + "' style='display:none;width:300px;overflow:hidden;'></div></td></tr>";
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
			    
			    /* 2018-08-06 홍승비 - boardLeft.jsp에서 하위게시판 ellipsis 부분 가져옴 */
		        var node = document.getElementById(TreeIdx);
		        var title2 = node.getElementsByClassName("node_div");
		        var nodeLevel = title2[0].getAttribute("nodelevel");
		        if(nodeLevel > 9) {
		        	nodeLevel = 9;
		        }
		        for(var i=0; i<title2.length; i++) {
		        	title3 = title2[i].getElementsByClassName("node_normal");
		        	title3[0].setAttribute("TITLE", title3[0].parentElement.getAttribute("DATA2")); 
		        	title3[0].style.width = 266 - 18*nodeLevel +'px';
		        	title3[0].style.textOverflow = 'ellipsis';
		        	title3[0].style.overflow = 'hidden';
		        }
			}	
	    </script>
	</head>
	<body class="popup">
		<h1><spring:message code="ezBoard.t135" /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<div class="box" style="height:485px;overflow-y:auto;overflow-x:hidden";word-break:break-all" id=TopBoardsList></div>
		<div class="btnposition">
			<a class="imgbtn" name="Submit" onClick="Select()" ><span><spring:message code="ezBoard.t47" /></span></a>
		</div>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>