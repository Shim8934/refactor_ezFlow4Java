<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${club.c_ClubName}' /> <spring:message code = 'ezCommunity.t485' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			.groupBoard {
				display:inline-block;
				width:169px;
				word-break:break-all;
				overflow:hidden;
				white-space:nowrap;
				text-overflow:ellipsis;
			}
			.tree {
				height:auto;
				width:190px;
				padding-left:20px;
				margin-left:-40px;
			}
			/* ellipisis 추가 */
			.node_normal {
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		width:135px;
	    	}
	    	.node_selected {
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		width:135px;
	    	}
	    	#treeUL li.on > span {
	    		color: black !important;
	    		font-weight: normal !important;
	    	}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var beforeThis;
			var topThis;
			var colorflg=false;	
			var code = "<c:out value = '${code}'/>";
		    var num = "<c:out value = '${num}' />";
			var clickboard = "<c:out value = '${clickBoard}' />";
			var boardid = "<c:out value = '${boardID}' />";
			var xmlDom_treeview = createXmlDom();
			var xmlHttp = createXMLHttpRequest();
			var cnt = SelectNodes(loadXMLString('${xmlret}'), "TREEVIEWDATA/NODE").length;
			
			var curMenuIndex = 1;
			
			$(document).ready(function(){
			    var xmlHttp = createXMLHttpRequest();
			    xmlHttp.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
			    xmlHttp.send();
	
			    if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlHttp.responseXML);
			    }
	
			    if (num != "") {
			        document.getElementById("goPage_" + num).click();
			    }
	
			    if (clickboard != "") {
			        document.getElementById("BoardList").click();
			        document.getElementById(boardid).click();
			    }
			    
			    makeTree();
			})
			
			function applyEllipsis() {
	        	
	        	//nodelevel 값을 가져와서 처리한다.
	        	$(".node_div").each(function(index, element){
	        		var nodelevel = $(element).attr("nodelevel");
	        		var title = $(element).attr("nodename");
	        		var nodeId = $(element).attr("id");
	        		
	        		$("#spn_"+nodeId).attr("title", title);
	        		
	        		if (nodelevel > 0) {
	        			var customWidth = 135 - (18 * nodelevel);
	        			if (customWidth < 0) {
	        				customWidth = 0;
	        			}
	        			$("#spn_"+nodeId).css("width", customWidth+"px");
	        		}
	        	});
	        }	
			
			function change(sdata) {  
				if (colorflg != false) {
					beforeThis.style.color ="#202020";
					sdata.style.color="#358500";
					beforeThis=sdata;
				} else {	
					sdata.style.color="#358500";
					beforeThis=sdata;
					colorflg=true;
				}
			}
			
			function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
				var xmlRtn = createXmlDom();
				var TreeIdx = pNodeID;
				var treeNode = new TreeNode();
				treeNode.LoadFromID(TreeIdx);
				xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1");
	
				var treeView = new TreeView();
				treeView.LoadFromID(pTreeID);
				treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
				
				applyEllipsis();
			}
	
			function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
				var treeNode = new TreeNode();
				treeNode.LoadFromID(pNodeID);
	
				SelectedBoardID = treeNode.GetNodeData("DATA1");
				chkPhotoBrd = treeNode.GetNodeData("DATA2");
				SelectedBoardParentBoardID = treeNode.GetNodeData("DATA3");
	
				applyEllipsis();
				
				OpenRightMenu(curMenuIndex);
			}
	
			function TreeCtrl_ForceClick(pNodeID, pTreeID) {
			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(pNodeID);
				
				SelectedBoardID = treeNode.GetNodeData("DATA1");
				SelectedBoardParentBoardID = treeNode.GetNodeData("DATA2");
				chkPhotoBrd = treeNode.GetNodeData("DATA3");
	
				OpenRightMenu(curMenuIndex);	
			}
	
			function TopBoard_onclick(obj, ID, cnt, e) {
			    if (CrossYN()) {
			        var TopBoardID = e.target.id;
			        SelectedBoardID = TopBoardID;
			        SelectedBoardGroupID = TopBoardID;
			        SelectedBoardName = e.target.innerText;
			    } else {
			        var TopBoardID = e.srcElement.id;
			        SelectedBoardID = TopBoardID;
			        SelectedBoardGroupID = TopBoardID;
			        SelectedBoardName = e.srcElement.innerText;
			    }
				
				var TreeCtrl = obj;
				
				g_AutoSelect = false;
				
				document.getElementById(obj + "obj").innerHTML = "";
				SetTreeConfig();
				var treeView = new TreeView();
				treeView.SetID("TreeView" + obj);
				treeView.SetRequestData("TreeCtrl_onNodeExpanded");
				treeView.SetNodeClick("TreeCtrl_onNodeClick");
				treeView.DataSource(GetSubBoard(ID, "1"));
				treeView.DataBind(obj + "obj");
				
				/* 2020-05-25 홍승비 - 하위게시판명의 말줄임표 스타일 오류 수정 */
				applyEllipsis();
	
				var idx = obj.substring(8, obj.length)
	
				if (curMenuIndex == 1 || curMenuIndex == 2 || curMenuIndex == 3 || curMenuIndex == 4 || curMenuIndex == 6) {	
					SelectedBoardID = TopBoardID;
					SelectedBoardParentBoardID = "TOP";
					OpenRightMenu(curMenuIndex);	
				}
				
				for(var i=0; i<cnt; i++) {
					if(i != idx) {
						eval("sub"+i).style.display = "none";
					} else {
						if(eval("sub"+i).style.display == "none") {
							eval("sub"+i).style.display = "";
						} else {
							eval("sub"+i).style.display = "none";
						}
					}
				}
			}
	
			function SetTreeConfig() {
			    var xmlHttp = createXMLHttpRequest();
			    xmlHttp.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
			    xmlHttp.send();
	
			    if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlHttp.responseXML);
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
			
			function Manage_function(data) {
			    var feature = "dialogwidth:467px;dialogheight:396px;toolbar:no;location:no;help:no;directories:no;status:no;menubar:no;scrollbars=no;resizable:no";
			    feature = feature + GetShowModalPosition(467, 396);
			    var Para = window.showModalDialog("../../manage/function_main.aspx?code=" + data, "", feature);
				
				if (Para=="CANCEL") {
					Manage_function(data);
				} else {
		   			window.opener.left_function_View(data);
					self.location.reload();
				}
			}
			
			function OpenRightMenu(pIndex) {
				if (SelectedBoardID == "" && pIndex == 6) {
					alert("<spring:message code = 'ezCommunity.t289' />");
					return;
				}
	
				curMenuIndex = pIndex;
	
				if (SelectedBoardID == "" && pIndex != 9 && pIndex != 7 && pIndex != 6) {
					alert("<spring:message code = 'ezCommunity.t289' />");
					return;
				}
				
				if (SelectedBoardID == SelectedBoardGroupID && pIndex != 1 && pIndex != 2 && pIndex != 3 && pIndex != 4 && pIndex != 9 && pIndex != 7 && pIndex != 6) {
					alert("<spring:message code = 'ezCommunity.t290' />");
					return;
				}
				
				switch(pIndex) {	
					case 1:
						window.open("/ezCommunity/boardProperty.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID) + "&code=" + encodeURIComponent(code), "right");
						break;
					case 2:
					    window.open("/ezCommunity/boardCreate.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID) + "&code=" + encodeURIComponent(code), "right");
						break;
					case 3:
						window.open("/ezCommunity/boardACL.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID) + "&code=" + encodeURIComponent(code), "right");
						break;
					case 4:
						window.open("/ezCommunity/boardOrder.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID) + "&code=" + encodeURIComponent(code), "right");
						break;
					case 5:
						window.open("/ezCommunity/boardMove.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID) + "&code=" + encodeURIComponent(code), "right");
						break;
					case 6:
						window.open("/ezCommunity/boardDelete.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID) + "&code=" + encodeURIComponent(code), "right");
						break;
					case 7:
						window.open("/ezCommunity/adminSearchBoardItem.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID) + "&code=" + encodeURIComponent(code), "right");
						break;
					case 9:
						window.open("/ezCommunity/boardGroupCreate.do?code=" + encodeURIComponent(code), "right");
						break;
					default:
						window.open("/ezCommunity/boardProperty.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID) + "&code=" + encodeURIComponent(code), "right");
						break;		
				}
			}
			
			function Open_Func(){	
			    if (cnt == "0") {
				    SelectedBoardGroupID ="";
				    SelectedBoardID="";
				    OpenRightMenu(9);
			    }
			}
	
			function goPage(idx) {
				var url = "";
				switch(idx) {
					case 1:
						url = "/ezCommunity/adminBasic.do?code=" + code;
						break;
					
					case 2:
						url = "/ezCommunity/adminLogo.do?code=" + code;
						break;
						
					case 3:
						break;
						
					case 4:
						var cofirmType = getClubConfirmType(code);
						if (cofirmType == "3") {
							url = "/ezCommunity/adminMemPermit.do?code=" + code;
						} else {
							alert("<spring:message code = 'ezCommunity.t486' />");								
							return false;
						}
						break;
						
					case 5:
						url = "/ezCommunity/adminNoticeMail.do?code=" + code;
						break;	
						
					case 6:
						url = "/ezCommunity/adminOuterList.do?code=" + code;
						break;
						
					case 7:
						url = "/ezCommunity/adminMemberList.do?code=" + code + "&mode=delete" ;
						break;	
						
					case 8:
						url = "/ezCommunity/adminMemberList.do?code=" + code + "&mode=master" ;
						break;	
						
					case 9:
						url = "/ezCommunity/adminCommClose.do?code=" + code;
					    break;
					    
				    case 10:
				        url = "/ezCommunity/adminHomeBoard.do?code=" + code;
				        break;

					case 11:
						url = "/ezCommunity/adminMemberGrade.do?code=" + code;
						break;
				}
				
				window.open(url,"right");
			}
			
			/* 2018-06-20 홍승비 - 커뮤니티 관리메뉴 > 게시판 그룹명 스타일 수정 */
			function makeTree() {
				var retXML = loadXMLString('${xmlret}');
				var treeXML = "";

				for (var i = 0; i < SelectNodes(retXML, "TREEVIEWDATA/NODE").length; i++) {
					treeXML += "<li><span id='" + SelectSingleNodeValue(SelectNodes(retXML, "TREEVIEWDATA/NODE")[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i + "\", \"" + SelectSingleNodeValue(SelectNodes(retXML, "TREEVIEWDATA/NODE")[i], "DATA1") + "\" , \"" + cnt + "\", event)'"
						+ "class='groupBoard'>" + SelectSingleNodeValue(SelectNodes(retXML, "TREEVIEWDATA/NODE")[i], "DATA2") + "</span>";
					treeXML += "<span id=\"sub" + i + "\" style=\"display:none;margin-left:0px;padding-bottom:15px\">";
					treeXML += "<div class='tree' id='TreeCtrl" + i + "obj'></div>\n";
					treeXML += "</span></li>";
				}
				
				$("#treeUL").html(treeXML);
				
			}
			
			/* 2021-08-17 홍승비 - 커뮤니티 유형 (승인여부) 체크를 위한 ajax 동작 추가 (기본정보 수정 후 좌측메뉴 갱신 불가능하기 때문) */
			function getClubConfirmType(pCode) {
				var returnVal = "";
				
				$.ajax({
					type : "GET",
					async : false,
					url : "/ezCommunity/getClubConfirmType.do",
					dataType : "text",
					data : {
						code : pCode
					},
					success: function(result) {
						returnVal = result;
					}
				});

				return returnVal;
			}
			
		</script>
		
	</head>
	<body class="leftbody">  
		<div id="left" style="height:526px;overflow-y:auto;">
			<div class="left_admin" title="Community Administrator"><spring:message code = 'ezCommunity.t234' /></div>
			<h2><span onClick="goPage(2)" id="goPage_2" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t2012' /></span><ul></ul></h2>	
			<h2><span onClick="goPage(1)" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t488' /></span><ul></ul></h2>	
	        <h2><span onClick="goPage(10)" id="goPage_10" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t2014' /></span><ul></ul></h2>
			<h2><span onClick="Open_Func()" id="BoardList" style="display:inline-block;width:100%"> <spring:message code = 'ezCommunity.t418' /></span></h2>
			
			<ul id = "treeUL"></ul>
			
			<h2><span onClick="goPage(4)" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t490' /></span><ul></ul></h2>	
			<h2><span onClick="goPage(6)" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t492' /></span><ul></ul></h2>
			<h2><span onClick="goPage(11)" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.lyj01' /></span><ul></ul></h2>
			<h2><span onClick="goPage(7)" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t493' /></span><ul></ul></h2>	
			<h2><span onClick="goPage(8)" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t494' /></span><ul></ul></h2>	
			<h2><span onClick="goPage(5)" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t491' /></span><ul></ul></h2>	
			<h2><span onClick="goPage(9)" style="display:inline-block;width:100%"><spring:message code = 'ezCommunity.t475' /></span><ul></ul></h2>
		       
		</div>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>