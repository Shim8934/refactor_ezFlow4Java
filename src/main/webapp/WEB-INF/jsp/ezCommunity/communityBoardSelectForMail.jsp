<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.hsbCM02'/></title>
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
			.communityBoardTop {
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
			var SelectedBoardID = "";
			var SelectedBoardParentID = "";
			var SelectedBoardName = "";
			var SelectedBoardType = "";
			var SelectedBoardUrl = "";
			
			var ret = new Array();
			var xmlDom_treeview = createXmlDom();
		    var ReturnFunction;
		    var rtnVal = "";
		    
		    /* 2018-08-06 홍승비 - 대상게시판선택 레이어팝업 추가, 게시물 이동+복사 팝업창과 같도록 UI 통일 */
		    var board_alertArguments = new Array();
		    var clubListSize = "<c:out value='${clubListSize}'/>"; // 가입한 커뮤니티의 갯수
		    
			function Select() {
				board_alertArguments[1] = DivPopUpHidden;
				if (SelectedBoardID == "") {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t138' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t138'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}
				
				if (SelectedBoardParentID.toLowerCase() == "top") { // 커뮤니티의 게시판 그룹을 선택한 경우
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezEmail.hsbCM03' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezEmail.hsbCM03'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}
				
				if (CheckIfCanWrite(SelectedBoardID) == false) {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t354' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t354'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}
				
				// 익명, 포토, url게시판에는 게시 불가
				if ((SelectedBoardType == "2" || SelectedBoardType == "3") || (SelectedBoardUrl != null && SelectedBoardUrl != "null" && trim(SelectedBoardUrl) != "")) {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t349' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t349'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}
				
			    var ret = new Array();
			    ret[0] = SelectedBoardID;
			    ret[1] = SelectedBoardName;
			    
			    rtnVal = ret;
			    window.close();
			}
			
		    window.onunload = function () {
		        if (ReturnFunction !=null) {
		            ReturnFunction(rtnVal);
		        }
		        else {
		            window.returnValue = rtnVal;
		        }
		    };
			
			function CheckIfCanWrite(pBoardID) {
				var boardInfo;
				var access = "-1";
				var writeFG = "false";
				
				$.ajax({
					type : "GET",
					async : false,
					url : "/ezCommunity/getACL.do",
					dataType : "JSON",
					data : {
						boardID	:	pBoardID
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
				
				if(access != "-1" && writeFG == "true") {
					return true;
				} else {
					return false;
				}
			}
			
			function window_onload() {
			    try {
			        ReturnFunction = opener.writeCommboardselect_modal_dialogArguments[1]; // NewItemCommu_onclick_Complete(ret)
			    } catch (e) {}
			}
			
			function TreeCtrl_onNodeExpanded(pNodeID,pTreeID) {
				var xmlRtn = createXmlDom();
			    var TreeIdx = pNodeID;	
				var treeNode = new TreeNode();
			    treeNode.LoadFromID(TreeIdx);
			    
			    // rootBoardID(현재 선택한 게시판의 ID), clubno, subflag
			    xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), treeNode.GetNodeData("DATA5"), "1");
			    
			    if(SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
				    if(CrossYN()) {
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
			
			function TreeCtrl_onNodeClick(pNodeID,pTreeID) {
				var treeNode = new TreeNode();
			    treeNode.LoadFromID(pNodeID);
	            SelectedBoardID = treeNode.GetNodeData("DATA1");
	            SelectedBoardName = treeNode.GetNodeData("DATA2");
	            SelectedBoardParentID = treeNode.GetNodeData("DATA3");
	            SelectedBoardType = treeNode.GetNodeData("DATA6");
	            SelectedBoardUrl = treeNode.GetNodeData("URL");
			}
			 
			function TopCommu_onclick(objID, clubno) {
			    var num = objID.split("TreeCtrl");
			
 			    if (document.getElementById(objID).style.display != "none") {
			        document.getElementById(objID).style.display = "none";
			        document.getElementById("CommunityBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "off";
				}
			    else {
			        document.getElementById(objID).style.display ="";
			        document.getElementById("CommunityBoardsList").getElementsByTagName("h2").item(Number(num[1])).className = "on";
			        SetTreeviewUnSelect(objID, clubListSize);        
				}
				
			    document.getElementById(objID).innerHTML = "";
			    SetTreeConfig();
			    
			    var treeView = new TreeView();
			    treeView.SetID("TreeView" + objID);
			    treeView.SetRequestData("TreeCtrl_onNodeExpanded");
			    treeView.SetNodeClick("TreeCtrl_onNodeClick");
			    treeView.DataSource(GetSubBoard("Top", clubno, "0")); // 각 커뮤니티의 최상위 게시판들을 가져와 표출한다.
			    treeView.DataBind(objID);
			}
			
	        function GetSubBoard(pRootBoardID, pClubno, pSubFlag) {
	        	var xmlRtn;
	        	$.ajax({
		    		type : "POST",
		    		async : false,
					url : "/ezCommunity/getSubBoards.do",
					dataType : "json",
					data : {
						rootBoardID : pRootBoardID,
						classID : pClubno,
						subFlag : pSubFlag,
						selectFlag : 0
					},
					success: function(result){
						if (result.result.indexOf("ERROR") == -1) {
							xmlRtn = loadXMLString(result.result);
				    	}
					}
		    	});
	        	
	            return xmlRtn;
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
			
			 // 커뮤니티 클릭하여 하위게시판 확장 시, 다른 커뮤니티와 하위게시판들을 닫는다.
			function SetTreeviewUnSelect(TreeviewID, items) {   
			    for (var i = 0; i < items; i++){
			        if (TreeviewID != "TreeCtrl"+ i) {
			            document.getElementById("TreeCtrl"+ i).style.display = "none";
			            document.getElementById("CommunityBoardsList").getElementsByTagName("h2").item(i).className = "off";
			        }
			    }
			}
			
		</script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
		<h1><spring:message code='ezEmail.hsbCM02'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close();"></span></li>
            </ul>
        </div>
        <div class="box" style="overflow-x:hidden;overflow-y:auto;height:485px">
			<div style="word-break:break-all" id="CommunityBoardsList">
			<table id='TopBoards' width=100% border=0>
			
			<c:forEach var="clubVO" items="${clubList}" varStatus="status">
			<tr>
				<td>
					<h2 id="cidx_${status.index}" clubno="<c:out value='${clubVO.c_ClubNo}'/>" <c:if test="${status.index == 0}">style="border-top:0px;"</c:if> onclick="TopCommu_onclick('TreeCtrl${status.index}', '<c:out value='${clubVO.c_ClubNo}'/>')">
						<span class='communityBoardTop'>
						<c:choose>
							<c:when test ="${lang == '1'}">
								<c:out value="${clubVO.c_ClubName}"/>
							</c:when>
							<c:otherwise>
								<c:out value="${clubVO.c_ClubName2}"/>
							</c:otherwise>
						</c:choose>
						</span>
					</h2>
				</td>
			</tr>
			
			<tr id='TreeArea'>
				<td>
					<div id="TreeCtrl${status.index}" style="display:none; height:100%; width:300px; overflow-x:hidden; padding-top:10px; padding-bottom:10px;"></div>
				</td>
			</tr>
			
			</c:forEach>
			</table>
			</div>
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