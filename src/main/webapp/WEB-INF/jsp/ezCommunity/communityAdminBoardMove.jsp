<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t340' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();

			var SelectedBoardID = "";
			var SelectedBoardName = "";
			var SelectedBoardParentBoardID = "";
			var selectedBoardGroupID = "";

			var OrgBoardID = "<c:out value = '${boardID}' />";
			var OrgBoardGroupID = "<c:out value = '${boardGroupID}' />";
			
			var BoardID = "<c:out value = '${boardID}' />";
			var ParentBoardID = "<c:out value = '${parentBoardID}' />";
			var BoardGroupID = "<c:out value = '${boardGroupID}' />";
			var code = "<c:out value = '${code}' />";
			var iMenuNum = 5;
			
			function Move() {
			    var boardName = "";
			    
			    if (CrossYN()) {
			        boardName = document.getElementById("pSelectBoardName").textContent;
			    } else {
			        boardName = document.getElementById("pSelectBoardName").innerText;
			    }

			    if (boardName == "") {
					alert("<spring:message code = 'ezCommunity.t341' />");
					return;
				}
				
				if (OrgBoardID == selectedBoardGroupID) {
					alert("<spring:message code = 'ezCommunity.t342' />");
					return;
				}
				
				xmlhttp.open("POST", "/ezCommunity/moveBoard.do?orgBoardID=" + encodeURIComponent(OrgBoardID) + "&newParentBoardID=" + encodeURIComponent(SelectedBoardID) + "&newBoardGroupID=" + encodeURIComponent(selectedBoardGroupID) + "&code=" + encodeURIComponent(code), false);
				xmlhttp.send();
				
				/* 2020-06-29 홍승비 - 상위게시판을 자신의 하위게시판 아래로 이동하지 못하도록 수정 */
				if (xmlhttp.responseText.indexOf("OK") > -1) {
					alert("<spring:message code = 'ezCommunity.t343' />");
					parent.window.location.reload();
				} 
				else if (xmlhttp.responseText.indexOf("CANCEL") > -1) {
					alert("<spring:message code = 'ezBoard.hsbMv01' />");
				}
				else {
					alert("<spring:message code = 'ezCommunity.t344' />");
				}
			}

			var boardmoveselect_cross_dialogArguments = new Array();
			function MoveSelect() {
				var parameter = new Array();
				parameter[0] = OrgBoardID;
				parameter[1] = OrgBoardGroupID;
				parameter[2] = code;
				var url;
				
				url = "/ezCommunity/boardMoveSelect.do";
				boardmoveselect_cross_dialogArguments[0] = parameter;
		        boardmoveselect_cross_dialogArguments[1] = MoveSelect_Complete;
		        var BoardMoveSelect_Cross = window.open(url, "boardMoveSelect", GetOpenWindowfeature(355, 600));
		        try { 
		        	BoardMoveSelect_Cross.focus(); 
		        }catch (e) {}
				/* var feature	= "status:no;dialogWidth:338px;dialogHeight:650px;help:no;scroll:no;edge:sunken";
				feature = feature + GetShowModalPosition(338, 650);
				var ret = window.showModalDialog(url, parameter, feature);
				
				if (typeof(ret) == "undefined") {
					return;
				}
				
				if (ret[0] == "cancel") {
					alert("<spring:message code = 'ezCommunity.t345' />");
				} else {
					SelectedBoardID = ret[0];
					selectedBoardGroupID = ret[1];
					
					if (CrossYN()) {
					    document.getElementById("pSelectBoardName").textContent = ret[2];
					} else {
					    document.getElementById("pSelectBoardName").innerText = ret[2];
					}
					
					MoveCheck.style.display = "";
				} */
			}
			
			function MoveSelect_Complete(ret) {
				if (typeof(ret) == "undefined") {
					return;
				}
				
				if (ret[0] == "cancel") {
					alert("<spring:message code = 'ezCommunity.t345' />");
				} else {
					SelectedBoardID = ret[0];
					selectedBoardGroupID = ret[1];
					
					if (CrossYN()) {
					    document.getElementById("pSelectBoardName").textContent = ret[2];
					} else {
					    document.getElementById("pSelectBoardName").innerText = ret[2];
					}
					
					MoveCheck.style.display = "";
				}
			}
			
			function OpenRightMenu(pIndex) {
				if (BoardID == "" && pIndex == 6) {
					alert("<spring:message code = 'ezCommunity.t289' />");
					return;
				}

				curMenuIndex = pIndex;

				if (BoardID == "" && pIndex != 9 && pIndex != 7 && pIndex != 6) {
					alert("<spring:message code = 'ezCommunity.t289' />");
					return;
				}
				
				if (BoardID == ParentBoardID && pIndex != 1 && pIndex != 2 && pIndex != 3 && pIndex != 4 && pIndex != 9 && pIndex != 7 && pIndex != 6) {
					alert("<spring:message code = 'ezCommunity.t290' />");
					return;
				}

				switch(pIndex) {
					case 1:		
						window.location.href = "/ezCommunity/boardProperty.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 2:		
					    window.location.href = "/ezCommunity/boardCreate.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 3:		
						window.location.href = "/ezCommunity/boardACL.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
				    case 4:
				        if (CrossYN()) {
				            window.location.href = "/ezCommunity/boardOrder.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
				        } else {
				            window.location.href = "/ezCommunity/boardOrder.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
				        }
				        
						break;
					case 5:		
						window.location.href = "/ezCommunity/boardMove.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 6:		
						window.location.href = "/ezCommunity/boardDelete.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 7:		
						window.location.href = "/ezCommunity/adminSearchBoardItem.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 9:		
						window.location.href = "/ezCommunity/boardGroupCreate.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
						
					default:
						break;		
				}
			}
			
			/* function searchBoard_onclick() {
			    var feature = "DialogHeight:470px;DialogWidth:340px;status:no;help:no;edge:sunken";
			    feature = feature + GetShowModalPosition(340, 470);
			    var ret = window.showModalDialog("/ezCommunity/class_admin/Board/SearchBoard.aspx", "", feature);
			    
				if(typeof(ret) == "undefined") {
				} else {
					var spans = TopBoardsList.all.tags("span");
					
					for (var i=0; i<spans.length; i++) {
						if(spans.item(i).id == ret[1]) {
							loadTreeViewByPath(spans.item(i), ret[0], ret[1], ret[2], ret[3]);
						}
					}
				}
			}

			function loadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID, pBoardName, pParentBoardID) {
				var divs = TopBoardsList.all.tags("DIV");
				
				for (var i=0; i<divs.length; i++) {
					if(divs.item(i).parentElement.parentElement.id == "TreeArea") {
						divs.item(i).parentElement.parentElement.style.display = "none";
					}
				}

				pObjSpan.parentElement.parentElement.nextSibling.style.display = "";
				var TreeCtrl = pObjSpan.parentElement.parentElement.nextSibling.firstChild.firstChild;
				
				TreeCtrl.server = SS_ServerName;
				TreeCtrl.config = xmlDom_treeview;
				TreeCtrl.source = GetBoardTreeByPath(pBoardID, pBoardGroupID);
				TreeCtrl.update();

				SelectedBoardID = pBoardID;
				SelectedBoardName = pBoardName;
				SelectedBoardParentBoardID = pParentBoardID;
				SelectedBoardGroupID = pBoardGroupID;

				window.location.href = "BoardProperty.aspx?BoardID=" + SelectedBoardID;
			} */
			
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.t346' /></h1>
		
		<div id="mainmenu">
			<ul>
			    <li><span onClick="OpenRightMenu(1)"><spring:message code = 'ezCommunity.t291' /></span></li>
			    <li><span onClick="OpenRightMenu(9)"><spring:message code = 'ezCommunity.t297' /></span></li>
			    <li><span onClick="OpenRightMenu(2)"><spring:message code = 'ezCommunity.t324' /></span></li>
			    <li><span onClick="OpenRightMenu(4)"><spring:message code = 'ezCommunity.t294' /></span></li>
			    <li><span onClick="OpenRightMenu(5)"><spring:message code = 'ezCommunity.t295' /></span></li>
			    <li><span onClick="OpenRightMenu(6)"><spring:message code = 'ezCommunity.t208' /></span></li>
			    <li><span onClick="OpenRightMenu(7)"><spring:message code = 'ezCommunity.t296' /></span></li>
			    <li style="display:none"><span onClick="OpenRightMenu(3)"><spring:message code = 'ezCommunity.t293' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>		
		
		<div class="subtxt" style="margin-top:15px">		
			<c:choose>
				<c:when test="">
					<b class="point"><spring:message code = 'ezCommunity.t347' /></b> - <spring:message code = 'ezCommunity.t348' />
				</c:when>
				
				<c:otherwise>
					<spring:message code = 'ezCommunity.t348' />
				</c:otherwise>
			</c:choose>			
		</div>
		
		<table class="content" style="margin-top:5px">
			<tr>
		    	<th><spring:message code = 'ezCommunity.t349' /></th>
		    	<td><b class="point"><c:out value = '${boardName}' /></b></td>
			</tr>
		</table>
		
		<br>
		<table class="content" >
			<tr>
			    <th><spring:message code = 'ezCommunity.t350' /></th>
			    <td ID="pSelectBoardName"><a class="imgbtn"><span onClick="MoveSelect()"><spring:message code = 'ezCommunity.t351' /></span></a></td>
			</tr>
		</table>
		
		<div class="btnposition" id="MoveCheck" style="display:none">
			<input name="submit" type="submit"  onClick="Move()" value="<spring:message code = 'ezCommunity.t108' />"> 
			<input name="submit2" type="submit"  onClick="window.location.reload(false)" value="<spring:message code = 'ezCommunity.t109' />">
		</div>
	
	</body>
</html>