<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var SelectedBoardID = "<c:out value = '${boardID}' />";
			var SelectedBoardName = "<c:out value = '${boardName}' />";
			
			var BoardID = "<c:out value = '${boardID}' />";
			var ParentBoardID = "<c:out value = '${parentBoardID}' />";
			var BoardGroupID = "<c:out value = '${boardGroupID}' />";
			var code = "<c:out value = '${code}' />";
			var iMenuNum = 6;
			
			function Delete() {
				var ret = confirm("<spring:message code ='ezCommunity.t329' />");
				
				if(ret) {
				    var xmlhttp = createXMLHttpRequest();
					xmlhttp.open("POST", "/ezCommunity/deleteBoard.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(SelectedBoardName) + "&code=" + code, false);
					xmlhttp.send();
				
					if(xmlhttp.responseText.indexOf("OK") > -1) {
					    parent.window.frames.left.location.reload();
					    parent.window.frames.right.location.href = "/ezCommunity/adminBasic.do?code=<c:out value = '${code}' />";
					}else {
						alert("<spring:message code ='ezCommunity.t330' />");
					}
					
					xmlhttp = null;
				}
			}
			
			function OpenRightMenu(pIndex){
				if (BoardID == "" && pIndex == 6) {
					alert("<spring:message code ='ezCommunity.t289' />");
					return;
				}
			
				curMenuIndex = pIndex;
				
				if (BoardID == "" && pIndex != 9 && pIndex != 7 && pIndex != 6)
				{
					alert("<spring:message code ='ezCommunity.t289' />");
					return;
				}
				
				if (BoardID == ParentBoardID && pIndex != 1 && pIndex != 2 && pIndex != 3 && pIndex != 4 && pIndex != 9 && pIndex != 7 && pIndex != 6)
				{
					alert("<spring:message code ='ezCommunity.t290' />");
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
				        window.location.href = "/ezCommunity/boardOrder.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
				    case 5:		
				        if (BoardID == BoardGroupID) {
				            alert("<spring:message code ='ezCommunity.t377' />");
					    } else {
							window.location.href = "/ezCommunity/boardMove.do?boardID=" + encodeURIComponent(BoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						}
				        
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
			    var ret = window.showModalDialog("/myoffice/ezCommunity/class_admin/Board/SearchBoard.aspx", "", feature);
			    
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
			
				window.location.href = "/ezCommunity/boardProperty.do?boardID=" + SelectedBoardID;
			} */
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.t331' /></h1>
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
		<c:if test="${hasSubBoard == '1'}">
			<table  class="content" style="margin-top:10px">
				<tr>
			    	<th><spring:message code="ezCommunity.t306"/></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table><br/>
			<h2><spring:message code="ezCommunity.jsh03"/></h2>
		</c:if>
		<c:if test="${hasSubBoard != '1'}">
			<table class="content" style="margin-top:10px">
			  	<tr>
				    <th ><spring:message code = 'ezCommunity.t306' /></th>
					<td><b class="point"><c:out value = '${boardName}' /></b></td>
				</tr>
				<tr>
			    	<td colspan="2" style="padding:15px"> <spring:message code = 'ezCommunity.t332' /><b class="point"><c:out value = '${boardName}' /></b>&nbsp;<spring:message code = 'ezCommunity.t333' /><br> <spring:message code = 'ezCommunity.t334' /></td>
			  	</tr>
			</table>
			<div class="btnposition btnpositionNew">
				<a class="imgbtn" onClick="Delete()"><span><spring:message code = 'ezCommunity.t108' /></span></a>
				<a class="imgbtn" onClick="history.back();"><span><spring:message code = 'ezCommunity.t109' /></span></a>
			</div>
		</c:if>
	</body>
</html>