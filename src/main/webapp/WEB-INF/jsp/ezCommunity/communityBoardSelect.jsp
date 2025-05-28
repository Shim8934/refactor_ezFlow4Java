<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t352' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<%-- <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css"> --%>
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<style>
			.groupBoard {
				display:inline-block;
				width:276px;
				word-break:break-all;
				overflow:hidden;
				white-space:nowrap;
				text-overflow:ellipsis;
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
			/* ellipisis 추가 */
			.node_normal {
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		width:270px;
	    	}
	    	.node_selected {
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		width:270px;
	    	}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var selectedBoard = "";
	        var ItemIDList = "";
	        var BoardID = "";
	        var BoardGroupID = "";
	
	        var SelectedBoardID = "";
	        var selectedBoardGroupID = "";
	        var SelectedBoardName = "";
	        var ret = new Array();
	
	        var code = "<c:out value = '${code}' />";
	        var chkPhotoBrd = "";
	
	        var xmlDom_treeview = createXmlDom();
	        var ReturnFunction;
	        
		    var board_alertArguments = new Array();
		    board_alertArguments[1] = DivPopUpHidden;
	        
	        function Select() {
	            if (SelectedBoardID == "") {
	            	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezCommunity.t411' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezCommunity.t411'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 	                alert("<spring:message code = 'ezCommunity.t411' />");
	                return;
	            }
	
	            if (chkPhotoBrd == "3") {
	            	var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezBoard.t413' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezBoard.t413'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
// 	                alert("<spring:message code = 'ezCommunity.t413' />");
	                return;
	            }
	            
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
	
	        function window_onload() {
                try {
                    ReturnFunction = opener.boardselect_dialogArguments[1];
                } catch (e) {
                    BoardID = dialogArguments[0];
                    BoardGroupID = dialogArguments[1];
                }
	
	            var xmlHTTP = createXMLHttpRequest();

                xmlHTTP.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);    
	            xmlHTTP.send();
	
	            DisplayTopBoard();
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
	            
	            applyEllipsis();
	        }
	
	        function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	            SelectedBoardID = treeNode.GetNodeData("DATA1");
	            SelectedBoardName = treeNode.GetNodeData("DATA2");
	            
	            applyEllipsis();
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
	            
	            applyEllipsis();
	        }
	        
	        function GetSubBoard(pRootBoardID, pSubFlag) {
	        	var xmlRtn;
	        	$.ajax({
		    		type : "POST",
		    		async : false,
					url : "/ezCommunity/getSubBoards.do",
					dataType : "json",
					data : {	rootBoardID : pRootBoardID,
								subFlag : pSubFlag,
								selectFlag : 3,
								pExcludeBoardID : BoardID,
								classID : code
							},
					success: function(result){
						if (result.result.indexOf("ERROR") == -1) {
							xmlRtn = loadXMLString(result.result);
				    	}
					}
		    	});
	        	
	            return xmlRtn;
	        }

	        function MakeTopBoardView(xmldom) {
	            var strHTML = "";
	            strHTML = "<table id='TopBoards' width=100% border=0>"
	            var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
	            var items = xmldomNodes.length;
	            for (var i = 0; i < xmldomNodes.length; i++) {
	                var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
	                tid = tid.substring(1, 37);
	                if (i == 0) {
	                	strHTML += "<tr><td><h2 style='border-top:0px; cursor:pointer;' id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")'>"
	                } else {
	                	strHTML += "<tr><td><h2 id='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ", \"" + items + "\"" + ")' style='cursor:pointer'>"
	                }
	                strHTML += "<span class = 'groupBoard'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2></td></tr>";
	                strHTML += "<TR id='TreeArea' ><td><DIV id='TreeCtrl" + i.toString() + "' style='display:none;height:100%;width:310px;overflow-x:hidden;padding-top:10px;padding-bottom:10px;'></DIV></td></tr>";
	            }
	            strHTML += "</table>";

	            xmldomNodes = null;
	            xmldom = null;

	            document.getElementById("TopBoardsList").innerHTML = strHTML;
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
	        
	        /* 2020-05-25 홍승비 - 커뮤니티 팝업홈 > 게시판검색 > 게시판선택 팝업창 게시판명 말줄임표 적용 */
			function applyEllipsis() {
	        	//nodelevel 값을 가져와서 처리한다.
	        	$(".node_div").each(function(index, element){
	        		var nodelevel = $(element).attr("nodelevel");
	        		var title = $(element).attr("nodename");
	        		var nodeId = $(element).attr("id");
	        		
	        		$("#spn_"+nodeId).attr("title", title);
	        		
	        		if (nodelevel > 0) {
	        			var customWidth = 270 - (18 * nodelevel);
	        			if (customWidth < 0) {
	        				customWidth = 0;
	        			}
	        			$("#spn_"+nodeId).css("width", customWidth+"px");
	        		}
	        	});
	        }
			
		</script>
	</head>
	<body class="popup" onload = "javascript:window_onload()" style="overflow: hidden">
		<h1><spring:message code = 'ezCommunity.t359' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <div class="box" style="height: 485px; overflow: auto; word-break: break-all" id="TopBoardsList"></div>
	    <div class="btnpositionNew">
	        <a class="imgbtn" name="Submit" onclick="Select()"><span><spring:message code = 'ezCommunity.t278' /></span></a>
	    </div>
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>