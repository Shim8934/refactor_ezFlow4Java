<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t135'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<%-- <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css"> --%>
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
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
			var pUse_Editor = "<c:out value='${useEditor}'/>";
			var isAdminLeft = "<c:out value='${isAdminLeft}'/>";
			var ReturnFunction;
			
		    function Select() {
		        if (SelectedBoardID == "") {
		            alert("<spring:message code='ezBoard.t179'/>");
		            return;
		        }
		
		        if (CheckIfCanWrite(SelectedBoardID) == false) {
		            alert("<spring:message code='ezBoard.t348'/>");
		            return;
		        }
		        
		        if (CheckIfAnonyBoard(SelectedBoardID)) {
		    		alert("<spring:message code='ezBoard.t349'/>");
		    		return;
		    	}
		        
		        if (CrossYN()) {
		        	ret[0] = SelectedBoardID;
	       			ret[2] = SelectedBoardName;
	       			isselected = true;
	       			opener.boardselect_cross_dialogArguments[1](ret);
	       			window.close();	
		        } else {
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
		        
		    }

			function CheckIfAnonyBoard(pBoardID) {
				xmlhttp.open("POST", "/ezBoard/checkIfAnonyBoard.do?boardID=" + encodeURIComponent(pBoardID), false);
				xmlhttp.send();
				var ret = xmlhttp.responseText;
				if (ret.indexOf("anonyboard") != -1 || ret.indexOf("URLboard") != -1) { // 익명, 포토, 썸네일, URL게시판에는 게시불가
					return true;
				}
				return false;
			}
			
			function CheckIfCanWrite(pBoardID) {
				xmlhttp.open("POST", "/ezBoard/getACL.do?boardID=" + encodeURIComponent(pBoardID), false);
				xmlhttp.send();
				var ret = xmlhttp.responseText;
				if(ret.indexOf("<WRITE>true</WRITE>") != -1) return true;
				return false;
			}
			
			function window_onload() {
				var xmlDom_treeview = createXMLHttpRequest();
			    xmlDom_treeview.open("GET", "/xml/organtree_config2.xml", false);
				xmlDom_treeview.send();
				
				if (xmlDom_treeview.readyState == 4 && xmlDom_treeview.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlDom_treeview.responseXML);
			    }
				DisplayTopBoard();
			}
	
			function TreeCtrl_onNodeExpanded(pNodeID,pTreeID) {
				var xmlRtn = createXmlDom();
			    var TreeIdx = pNodeID;	
				var treeNode = new TreeNode();
			    treeNode.LoadFromID(TreeIdx);
			    
			    xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1")
			    
			    if(SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
				    if(CrossYN()) {
					    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
					} else {
					    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
					}
				}
				var treeView = new TreeView();
			    treeView.LoadFromID(pTreeID);
			    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
			}
			
			function TreeCtrl_onNodeClick(pNodeID,pTreeID)  {
				var treeNode = new TreeNode();
			    treeNode.LoadFromID(pNodeID);
			    SelectedBoardID = treeNode.GetNodeData("DATA1");	
			    SelectedBoardName = treeNode.GetNodeData("DATA2");
			}
			
			function DisplayTopBoard() {
				xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=top&subFlag=0&isAdminLeft=" + isAdminLeft, false);
				xmlhttp.send();
				
				if(xmlhttp.responseXML.text != "ERROR") {
					MakeTopBoardView(xmlhttp.responseText)
				}
			}
			
			function TopBoard_onclick(obj, ID, items) {
			    var rootBoardID = encodeURIComponent("{" +ID+ "}");
			    var num = obj.split("TreeCtrl");
			
			    if (document.getElementById(obj).style.display != "none") {
			        document.getElementById(obj).style.display = "none";
			        document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
				} else {
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
			
			function GetSubBoard(pRootBoardID, pSubFlag) {
				xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=" + encodeURIComponent(pRootBoardID) + "&subFlag=" + pSubFlag + "&selectFlag=0&pExcludeBoardID=" + encodeURIComponent(BoardID) + "&isAdminLeft=" + isAdminLeft, false);
				xmlhttp.send();
				
				return xmlhttp.responseXML;
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
				for(i=0;i<xmldomNodes.length;i++) {
				    var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
				    //서한별 게시판아이디 자르지않도록수정
				    //tid= tid.substring(1,37);
					strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl"+i.toString()+"\" ,\""+ tid + "\""+", \"" + items + "\"" + ")' style='cursor:pointer'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</h2></td></tr>";
					strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:300px;overflow:hidden;'></DIV></td></tr>";
				}
				strHTML += "</table>";
				
				xmldomNodes = null;
				xmldom = null;
				
				document.getElementById("TopBoardsList").innerHTML = strHTML;
			}
			
			function CreateBoardGroup() {
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
			
			function SetTreeviewUnSelect(TreeviewID, items) {   
			    for(var i = 0; i < items; i++){
			        if(TreeviewID != "TreeCtrl"+ i){
			            document.getElementById("TreeCtrl"+ i).style.display = "none";
			            document.getElementById("TopBoardsList").getElementsByTagName("h2").item(i).className = "off";
			        }
			    }
			}
			
			 window.onunload = function () {
			    if (!isselected)
			        opener.boardselect_cross_dialogArguments[1]("");
			} 
		</script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
		<h1><spring:message code='ezBoard.t135'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<div class="box" style="width:340px;height:540px;overflow:auto;word-break:break-all" id=TopBoardsList></div>
		<div class="btnposition btnpositionNew">
    		<a class="imgbtn"><span onClick="Select()"><spring:message code='ezBoard.t47'/></span></a>
		</div>
	</body>
</html>