<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t1047' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%-- <link rel="stylesheet" type="text/css" href="${util.addVer('ezOrgan.e3', 'msg')}"> --%>
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			.groupBoard {
				width:276px;
				overflow:hidden;
				text-overflow:ellipsis;
				display: inline-block;
			}
			.node_div {
				overflow:hidden;
				text-overflow:ellipsis;
			}
			.node_div span {
				vertical-align:text-bottom;
			}
			.node_div img {
				margin-bottom: 3px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
      		var selectedBoard = "";
      		var ItemIDList = "<c:out value = '${itemIDList}' />";
			var BoardID = "<c:out value = '${boardID}' />";
			var code = "<c:out value = '${code}' />";
			//2018-07-13 김보미
    		var treeCtrl = "<c:out value='${treeCtrl}' />";
			var xmlDom_treeview = createXmlDom();
			var mailFG_Post = "<c:out value = '${mailFG_Post}'/>"; // 게시알림
			
			/* 2018-08-06 홍승비 - 커뮤니티 게시물 복사 팝업창 게시판과 같도록 UI 통일 */
			var board_alertArguments = new Array();
			function Select()
			{
				board_alertArguments[1] = DivPopUpHidden;
    			if (selectedBoard == "") {
    				var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezCommunity.t356' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezCommunity.t356'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
    				return;
				}
   				if (selectedBoard == BoardID) {
   					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezCommunity.t1048' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezCommunity.t1048'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
		    		return;
				}
   			
    			CopyItem(selectedBoard);
			}

			function cancel() {
		    	window.close();
			}

			function CopyItem(pDestBoardID) {
							
			    if (CheckIfCanWrite(pDestBoardID) == false) {
			    	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezCommunity.t1049' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezCommunity.t1049'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
			    	return;
				}
			    
				if (CheckIfAnonyBoard(pDestBoardID) == "1") {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezCommunity.t1050' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezCommunity.t1050'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}
	
	   			var destItemIDList = "";
	
			   	for (i = 0; i < ItemIDList.split(";").length - 1; i++) {
			    	destItemIDList += "{" + GetGUID().toUpperCase() + "};";
			   	}
			   	
			   	$.ajax({
			   		type : "POST",
			   		async : false,
			   		url : "/ezCommunity/copyItem.do",
			   		dataType : "JSON",
			   		data : {
			   			orgItemIDList : ItemIDList,
			   			orgBoardID : BoardID,
			   			destItemIDList : destItemIDList,
			   			destBoardID : pDestBoardID
			   		},
			   		success : function(result) {
			   			board_alertArguments[1] = window.close;
			   			
			   			if (result["ret"].indexOf("OK") > -1) {
			   				var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezCommunity.t1051' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezCommunity.t1051'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
							DivPopUpShow(330, 205, pUrl);
							
							 /* 2021-11-19 홍승비 - 게시판의 옵션에 따라 게시알림메일 발송 (비동기식, 백그라운드 동작) */
			                if (mailFG_Post == "Y") { // 복사 시 mode는 항상 new, 다중 복사 대응
			                	sendCommBoardAlertMail("new", pDestBoardID, destItemIDList);
			                }
		 				} else {
		 					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezCommunity.t1052' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezCommunity.t1052'/>") + result["ret"] + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
							DivPopUpShow(330, 205, pUrl);
		 				}
			   			try {
			   				if (window.opener.parent.opener.location.href.indexOf("ezCommunity/boardItemList.do") > -1 && typeof(window.opener.parent.opener.refresh_onclick) == "function") {
			   					window.opener.parent.opener.refresh_onclick(); // 게시물 읽기창에서 복사 시
			   				} else if (window.opener.location.href.indexOf("ezCommunity/boardItemList.do") > -1 && typeof(window.opener.refresh_onclick) == "function") {
		 			        	window.opener.refresh_onclick(); // 게시물 리스트에서 복사 시
			   				}
		 			        
		 			       /* 2021-11-09 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
							if (window.opener.parent.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.opener.parent.applyIsNewIconAll) == "function") {
								window.opener.parent.opener.parent.applyIsNewIconAll(); // 게시물 읽기창에서 복사 시
							} else if (window.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.applyIsNewIconAll) == "function") {
								window.opener.parent.applyIsNewIconAll(); // 게시물 리스트에서 복사 시
							}
		 			    } catch (e) {
		 			    	window.opener.console.log(e);
		 			    }
			   		}
			   	});
			}

			function CheckIfCanWrite(pBoardID) {
				var boardInfo;
				var access = "-1";
				var writeFG = "false";
				
				$.ajax({
					type : "GET",
					async : false,
					url : "/ezCommunity/getACL.do",
					dataType : "JSON",
					data : { boardID	:	pBoardID, 
						   },
					success: function(result){
						if (typeof(result["boardInfo"]) != "undefined") {
							boardInfo = result["boardInfo"];
							access = boardInfo["access_"];
							writeFG = boardInfo["write_FG"];
						}
					},
					error: function(e) {
						alert("error");
					}
				});
				
				if (access != "-1" && writeFG == "true") {
					return true;
				} else {
					return false;
				}
			}

			function CheckIfAnonyBoard(pBoardID) {
				var retval = '0';
				
				$.ajax({
			   		type : "GET",
			   		async : false,
			   		url : "/ezCommunity/checkIfAnonyBoard.do",
			   		dataType : "JSON",
			   		data : {
			   			boardID : pBoardID,
			   		},
			   		success : function(result) {
			   			if (result["result"] == 'anonyboard') {
		 					retval = '1';
		 				}
			   		},
					error: function(e) {
						alert("error");
					}
			   	});
				
				return retval;
			}

			window.onload = function () {
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
			    xmlHTTP.send();
			
			    DisplayTopBoard();
			    
			    /* 2018-08-06 홍승비 - treeCtrl을 파라미터로 받지 않을 경우 분기 처리 */
			    if ((treeCtrl != null) && (treeCtrl.trim() != "")) {
				    //2018-07-13 김보미 - 복사하려는 게시글의 게시판이 선택되도록(트리뷰 펼치기)
				    $("h2[treeCtrl=" + treeCtrl.split("TreeView")[1].split("_")[0] + "]").trigger("click");//그룹선택
				    
				    var treeCtrlarr = treeCtrl.split("_"); 
				    var spanId = "#spn_" + treeCtrlarr[0]; //spn_TreeViewTreeCtrl0
				    var imgId = "#imgNode_" + treeCtrlarr[0]; //imgNode_TreeViewTreeCtrl0
				    for (var i = 1; i < treeCtrlarr.length; i++) {
				    	if(i != 1) { //하위게시판일 경우 펼쳐지게끔.
				    		$(imgId).trigger("click");
				    	}
				    	//게시판 클릭
				    	spanId += "_" + treeCtrlarr[i];
				    	$(spanId).trigger("click");
				    	
				    	imgId += "_" + treeCtrlarr[i];
				    }
			    }
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
			        } else {
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
				$.ajax({
					type : "POST",
					async : false,
					url : "/ezCommunity/getSubBoards.do",
					dataType : "json",
					data : {	rootBoardID : 'TOP',
								subFlag : 0,
								classID : code
							},
					success: function(result){
						if (result.result.indexOf("ERROR") == -1) {
					        MakeTopBoardView(loadXMLString(result.result));
				    	}
					}
				});
			}
			
			function TopBoard_onclick(obj, ID, items) {
			    var rootBoardID = "{" + ID + "}";
			    var num = obj.split("TreeCtrl");
			    
			    if (document.getElementById(obj).style.display != "none") {
			        document.getElementById(obj).style.display = "none";
			        document.getElementById("TopBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
			    } else {
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
			    xmlDom_treeview.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
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
			
			function GetSubBoard(pRootBoardID, pSubFlag) {
				var returnVal = "";
				
				$.ajax({
					type : "POST",
					async : false,
					url : "/ezCommunity/getSubBoards.do",
					dataType : "json",
					data : {	rootBoardID : pRootBoardID,
								subFlag : pSubFlag,
								selectFlag : 0,
								classID : code
							},
					success: function(result){
						returnVal = loadXMLString(result.result);
					}
				});
				
				return returnVal;
			}
			
			function MakeTopBoardView(strXML) {
			    var xmldom = strXML;
			    var strHTML = "";
			    strHTML = "<table id='TopBoards' width=100% border=0>";
			    var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
			    var items = xmldomNodes.length;
			    
			    for (i = 0; i < xmldomNodes.length; i++) {
			        var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
			        tid = tid.substring(1, 37);
			        //2018-07-13 김보미 - h2태그에 속성값 추가
					//strHTML += "<tr><td><h2 style='border-top:0px' id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</h2></td></tr>";
			       
					 if (i == 0) {
						//strHTML += "<tr><td><h2 style='border-top:0px' id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl"+i.toString()+"\" ,\""+ tid + "\""+", \"" + items + "\"" + ")' style='cursor:pointer'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";    	
				   		strHTML += "<tr><td><h2 style='border-top:0px; cursor:pointer;' TreeCtrl='TreeCtrl" + i.toString() + "' id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";
				    } else {
						strHTML += "<tr><td><h2 TreeCtrl='TreeCtrl" + i.toString() + "' id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'><span class='groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";
				    }
 					strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:300px;overflow:hidden;padding-top:10px;padding-bottom:10px;'></DIV></td></tr>";
			    }
			    strHTML += "</table>";
			
			    xmldomNodes = null;
			    xmldom = null;
			
			    document.getElementById("TopBoardsList").innerHTML = strHTML;
			}
			
			// 관리자단에서는 예약게시물이 검색되며, 복사도 가능하다. (게시일자는 현재 시간으로 들어가므로 알림메일 발송 진행)
			 /* 2021-11-19 홍승비 - 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 (다중 복사 대응) */
			function sendCommBoardAlertMail(pMode, pBoardID, pItemID) {
				var itemList = pItemID.split(";");
				 
				for (var i = 0; i < itemList.length; i ++) {
					if (itemList[i].trim() != "") {
				        $.ajax({
							type : "POST",
							dataType : "text",
							async : true,
							url : "/ezCommunity/sendCommBoardAlertMail.do",
							data : {
								mode : pMode,
								boardID : pBoardID,
								itemID : itemList[i]
							}
						});
					}
				}
			}
			 
		</script>
	</head>
	<body class = "popup">
		<h1><spring:message code='ezCommunity.t359' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <div class="box" style="height: 485px; overflow-y:auto;overflow-x:hidden; word-break: break-all" id="TopBoardsList"></div>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn" name="Submit" onclick="Select()"><span><spring:message code='ezCommunity.t278' /></span></a>
	    </div>
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>