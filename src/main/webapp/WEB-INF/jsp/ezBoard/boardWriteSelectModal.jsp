<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t135'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
		<style>
			img {
				padding-top:0px
			}
			.groupBoard {
				width:266px;
				overflow:hidden;
				text-overflow:ellipsis;
				display: inline-block;
			}
			.node_div span {
				overflow:hidden;
				text-overflow:ellipsis;
			}
		</style>
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
			var selectedBoard = "";
			var ItemIDList = "";
			var BoardID = " ";
			var BoardGroupID = "";
			
			var	SelectedBoardID = "";
			var	selectedBoardGroupID = "";	
			var SelectedBoardName = "";
			var SelectedBoardType = "";
			var SelectedBoardUrl = "";
			var ret = new Array();
			
			var xmlDom_treeview = createXmlDom();
			var pUse_Editor = "${useEditor}";
		    var ReturnFunction;
		    var rtnVal = "";

			var popupMsg;
		    
		    var popupMsg;
		    
		    /* 2018-08-06 홍승비 - 대상게시판선택 레이어팝업 추가, 게시물 이동+복사 팝업창과 같도록 UI 통일 */
		    var board_alertArguments = new Array();
			function Select()
			{
				board_alertArguments[1] = DivPopUpHidden;
				if(SelectedBoardID == "") {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t138' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t138'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}
				
				if (CheckIfCanWrite(SelectedBoardID) == false)
				{
					if (SelectedBoardType !== "9" && SelectedBoardType !== "10") {
						popupMsg = "<spring:message code='ezBoard.t354' />";
					}

					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent(popupMsg) + "&MESSAGE=" + encodeURIComponent(popupMsg) + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					
					/* 2022-01-05 홍승비 - 홈페이지 게시판에 작성 시 알러트 메세지 추가 (홈페이지 게시판은 관리자만 작성이 가능합니다.) */
					if (SelectedBoardType == "8") {
						pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.HSBHp02' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.HSBHp02'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					}
					
					DivPopUpShow(330, 205, pUrl);
					return;
				}
				
				/* 2020-06-23 홍승비 - URL게시판 선택 시 경고 메세지 추가 */
				/*if (SelectedBoardUrl != null && SelectedBoardUrl != "null" && trim(SelectedBoardUrl) != "") {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.garm02' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.garm02'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}*/
				
			    var ret = new Array();
			    ret[0] = SelectedBoardID;
			    ret[1] = SelectedBoardName;
			    ret[2] = SelectedBoardType;
			    ret[3] = SelectedBoardUrl;
			
			    rtnVal = ret;
			    window.close();
			}
			
		    window.onunload = function () {
		        if (ReturnFunction !=null)
		            ReturnFunction(rtnVal);
		        else
		            window.returnValue = rtnVal;
		    };
			
		    // 미사용 함수 주석처리
/* 			function CheckIfAnonyBoard(pBoardID)
			{
				xmlhttp.open("POST", "/ezBoard/checkIfAnonyBoard.do?boardID=" + encodeURIComponent(pBoardID), false);
				xmlhttp.send();
				var ret = xmlhttp.responseText;
				if (ret.indexOf("anonyboard") != -1 || ret.indexOf("URLboard") != -1) {
					return true;
				}
				return false;
			} */
			
			function CheckIfCanWrite(pBoardID)
			{
				if (SelectedBoardType === "9") {
					popupMsg = "<spring:message code = 'ezBoard.fileViewerBoard.msg4' />";
					return false;
				} else if (SelectedBoardType === "10") {
			        popupMsg = "<spring:message code='ezBoard.MJSCAT02' />";
			        return false;
			    }

				xmlhttp.open("POST", "/ezBoard/getACL.do?boardID=" + encodeURIComponent(pBoardID), false);
				xmlhttp.send();
				var ret = xmlhttp.responseText;
				
				/* 2022-01-05 홍승비 - 홈페이지 게시판의 경우, 관리자만 게시 가능 */
				if (SelectedBoardType == "8") {
					if (ret.indexOf("<BOARDGROUPADMIN>OK</BOARDGROUPADMIN>") == -1 && ret.indexOf("<BOARDADMIN>true</BOARDADMIN>") == -1) {
						return false;						
					} else {
						return true;
					}
				}
				
				if (ret.indexOf("<WRITE>true</WRITE>") != -1 || ret.indexOf("<BOARDGROUPADMIN>OK</BOARDGROUPADMIN>") != -1) {
		        	return true;
		        } else {
		        	return false;
		        }
			}
			
			function window_onload()
			{
			    try {
			        ReturnFunction = opener.writeboardselect_modal_dialogArguments[1];
			    } catch (e) {}
			    
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
			    
			    xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1");
			    
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
			    
			    /* 2018-08-06 홍승비 - boardLeft.jsp에서 하위게시판 ellipsis 부분 가져옴 */
		        /* var node = document.getElementById(TreeIdx);
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
		        } */
			}
			
			/* 2018-11-08 홍승비 - URL게시판의 URL값 전달 추가 */
			function TreeCtrl_onNodeClick(pNodeID,pTreeID)  
			{
				var treeNode = new TreeNode();
			    treeNode.LoadFromID(pNodeID);
			    SelectedBoardID = treeNode.GetNodeData("DATA1");	
			    SelectedBoardName = treeNode.GetNodeData("DATA2");
			    SelectedBoardType = treeNode.GetNodeData("DATA5");
			    SelectedBoardUrl = treeNode.GetNodeData("DATA6");
			}
			
			function DisplayTopBoard()
			{
				xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=top&subFlag=0", false);
				xmlhttp.send();
				
				if(xmlhttp.responseXML.text != "ERROR")
				{
					MakeTopBoardView(xmlhttp.responseText);
				}
			}
			
			function TopBoard_onclick(obj, ID, items)
			{
				//서한별 게시판아이디 그대로쓰도록 수정
			    //var rootBoardID = "{" +ID+ "}";
			    var rootBoardID = ID;
			    var num = obj.split("TreeCtrl");
			
			    if (document.getElementById(obj).style.display != "none") {
			        document.getElementById(obj).style.display = "none";
			        document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
			        }
			    else{
			        document.getElementById(obj).style.display ="";
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
			
			function GetSubBoard(pRootBoardID, pSubFlag)
			{
				xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=" + encodeURIComponent(pRootBoardID) + "&subFlag=" + pSubFlag + "&selectFlag=0&pExcludeBoardID=" + encodeURIComponent(BoardID), false);
				xmlhttp.send();
				
				return xmlhttp.responseXML;
			}
			
			function MakeTopBoardView(strXML)
			{
				var xmldom = createXmlDom();
				var strHTML = "";
				xmldom = loadXMLString(strXML);
				strHTML = "<table id='TopBoards' width=100% border=0>";
				
				var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
		        if (xmldomNodes == null || xmldomNodes == false) {
		        	xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        }
		        
				var items = xmldomNodes.length;	
				for(var i=0;i<xmldomNodes.length;i++)
				{
				    var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
				  //서한별 게시판아이디 자르지않도록수정
				   // tid= tid.substring(1,37);
				    
				    if (i == 0) {
				    	strHTML += "<tr><td><h2 style='border-top:0px' id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl"+i.toString()+"\" ,\""+ tid + "\""+", \"" + items + "\"" + ")' style='cursor:pointer'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";    	
				    } else {
						strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl"+i.toString()+"\" ,\""+ tid + "\""+", \"" + items + "\"" + ")' style='cursor:pointer'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";
				    }
					strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:300px;overflow:hidden;padding-top:10px;padding-bottom:10px'></DIV></td></tr>";
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
		<div id="close">
            <ul>
                <li><span onclick="window.close();"></span></li>
            </ul>
        </div>
        <div class="box" style="overflow-x:hidden;overflow-y:auto;height:485px">
			<div style="word-break:break-all" id=TopBoardsList></div>
		</div>	
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn"><span onClick="Select()"><spring:message code='ezBoard.t47'/></span></a>
		</div>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>