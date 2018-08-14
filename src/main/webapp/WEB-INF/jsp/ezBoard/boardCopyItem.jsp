<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t350'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
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
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
		<script type="text/javascript">
		    var xmlhttp = createXMLHttpRequest();
		    var selectedBoard = "";
		    var ItemIDList = "${itemIDList}";
		    var BoardID = "${boardID}";
		    var oldguBun = "${guBun}";
		    var newguBun = "";
		    var xmlDom_treeview = createXmlDom();
		    var rtnVal = "";
		    var ReturnFunction = "";
		    
		    /* 2018-07-11 홍승비 - 서로 다른 유형의 게시판 간 복사 시도 시 메세지 수정 */
		    var board_alertArguments = new Array();
		    function Select() {
		    	board_alertArguments[1] = DivPopUpHidden;
		        if (selectedBoard == "") {
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t138' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t138'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.t179'/>");
		            return;
		        }

		        if (BoardID.indexOf(selectedBoard) != -1) {
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t351'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t351'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.t351'/>");
		            return;
		        }

		        if (oldguBun > 0) {
			    	if (oldguBun != newguBun) {
			    		var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.hsb02'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.hsb02'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
						DivPopUpShow(330, 205, pUrl);
// 			        	alert("<spring:message code='ezBoard.hsb02'/>");
			            return;
			        }
			    	if (oldguBun == "3" && newguBun == "3") {
			    		var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.hsb02'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.hsb02'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
						DivPopUpShow(330, 205, pUrl);
// 			        	alert("<spring:message code='ezBoard.hsb02'/>");
			            return;
			        }
		    	} else {
		    		if (newguBun != "0") {
		    			var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.hsb02'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.hsb02'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
						DivPopUpShow(330, 205, pUrl);
// 			        	alert("<spring:message code='ezBoard.hsb02'/>");
			            return;
			        }
		    	}

		        CopyItem(selectedBoard);
		    }
		    function cancel() {
		        window.close();
		    }
		    function CopyItem(pDestBoardID) {
		        if (CheckIfAnonyBoard(pDestBoardID) == "1") {
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.hsb02'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.hsb02'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.hsb02'/>");
		            return;
		        }
		
		        if (CheckIfAnonyBoard(pDestBoardID) == "2") {
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t999069'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t999069'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.t999069'/>");
		            return;
		        }
		
		        if (CheckIfCanWrite(pDestBoardID) == false) {
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t354'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t354'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.t354'/>");
		            return;
		        }
		        xmlhttp.open("POST", "/ezBoard/copyItem.do?orgItemIDList=" + ItemIDList + "&orgBoardID=" + BoardID + "&destBoardID=" + pDestBoardID, false);
		        xmlhttp.send();
		        if (xmlhttp.responseText.indexOf("OK") > -1) {
		        	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t355'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t355'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.t355'/>");
					board_alertArguments[1] = window.close;
		            window.returnValue = "OK";
		            rtnVal = "OK";
		            try {
				        window.opener.leftCountRf();
					} catch (e) {
					}
// 		            window.close();
		        } 
		        //else if (window.parent.strListInfo == "" || typeof (window.parent.strListInfo) == "undefined") {
		        	//var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t201' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t201'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					//DivPopUpShow(330, 205, pUrl);
		        //}
		        else {
		            window.returnValue = "ERROR";
		            rtnVal = "ERROR";
		            board_alertArguments[1] = window.close;
// 		            window.close();
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t181' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t181'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 		            alert("<spring:message code='ezBoard.t181'/>" + xmlhttp.responseText);
		        }
		    }
		    function CheckIfCanWrite(pBoardID) {
		        xmlhttp.open("POST", "/ezBoard/getACL.do?boardID=" + pBoardID, false);
		        xmlhttp.send();
		        var ret = xmlhttp.responseText;
		        if (ret.indexOf("<WRITE>true</WRITE>") != -1) return true;
		        return false;
		    }
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
		            ReturnFunction = opener.copyboarditem_cross_dialogArguments[1];
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
		    
		    window.onunload = function () {
		        if (ReturnFunction != null){
		            ReturnFunction(rtnVal);
		        }
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
		    function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(pNodeID);
		        selectedBoard = treeNode.GetNodeData("DATA1");
		        newguBun = treeNode.GetNodeData("DATA5");
		    }
		    function DisplayTopBoard() {
		        xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=top&subFlag=0", false);
		        xmlhttp.send();
		        if (xmlhttp.responseText.indexOf("ERROR") == -1) {
		            MakeTopBoardView(xmlhttp.responseText);
		        }
		    }
		    /* 2018-07-11 홍승비 - 하위게시판 선택한 후 다른 게시판그룹 선택 시, 기존에 선택한 하위게시판 해제 */
		    function TopBoard_onclick(obj, ID, items) {
		        var rootBoardID = "{" + ID + "}";
		        var num = obj.split("TreeCtrl");
		        selectedBoard = "";
		        
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
		            
		            if (i == 0) {
		            	strHTML += "<tr><td><h2 style='border-top:0px' id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";
		            } else {
		            	strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";
		            }
		            strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:300px;overflow-x:hidden;padding-top:10px;padding-bottom:10px'></DIV></td></tr>";
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
	<div id="close">
        <ul>
            <li><span onclick="window.close()"></span></li>
        </ul>
    </div>
	<div class="box" style="height:485px;overflow-y:auto;overflow-x:hidden" id="TopBoardsList"></div>
	<div class="btnposition btnpositionNew">
	    <a class="imgbtn" onClick="Select()" ><span><spring:message code='ezBoard.t47'/></span></a>
	</div>
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	</body>
</html>