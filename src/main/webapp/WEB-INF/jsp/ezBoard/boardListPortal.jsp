<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t338'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<script type="text/javascript">
			var	Access_FG = "${boardInfo.access_FG}";
			var	BoardAdmin_FG = "${boardInfo.boardMin_FG}";
			var	ListView_FG = "${boardInfo.listView_FG}";
			var	Read_FG = "${boardInfo.read_FG}";
			var	Write_FG = "${boardInfo.write_FG}";
			var	Reply_FG = "${boardInfo.reply_FG}";
			var	Delete_FG = "${boardInfo.delete_FG}";
			var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
			var BoardID = "${pBoardID}";
			
			function MiniGotoList() {
				//try {
					//window.parent.top.frames("main").location.href = "/ezBoard/boardMainRedirect.do?boardID=" + BoardID;
				window.parent.top.frames[0].location.href = "/ezBoard/boardMainRedirect.do?boardID=" + BoardID;
				//} catch (e) {}
			}
			
			function MinicloseWebPart() {
				parent.del_webpart("${frmID}");
			}
					
		    function ItemRead_onclick(pItemID, pBoardID) {
		        if (Read_FG != "true") {
		            alert("<spring:message code='ezBoard.t194'/>");
		            return;
		        }
		        var pheigth = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        pheigth = parseInt(pheigth) / 2;
		        pwidth = parseInt(pwidth) / 2;
		        pheigth = pheigth - 340;
		        pwidth = pwidth - 359;
		        window.open("/ezBoard/boardItemView.do?showAdjacent=1&itemID=" + pItemID + "&boardID=" + pBoardID, "", "height=657,width=720px, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth, "");
		    }
		    
		    function initsize() {
		        self.resizeTo(document.body.scrollWidth, document.body.scrollHeight);
		    }		
		</script>
	</head>
	<body leftMargin="0" topMargin="0" marginheight="0" marginwidth="0">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="D2E6F3">
			<tr bgcolor="98C1DB">
				<td colspan="2" height="1"></td>
			</tr>
			<tr>
				<td height="23" style="padding-top:4px;padding-left:15"><font color="1C63AF" style="FONT-WEIGHT: bold; FONT-SIZE: 10pt">${boardInfo.boardName}</font>&nbsp;| <span class="point">${totalCount}</span><spring:message code='ezBoard.t339'/></td>
				<td width="67"><IMG id="TD_SchClose" style="CURSOR: hand" onClick="MiniGotoList()" height="11" src="/images/main/btn_list.gif" width="30" align="absMiddle" hspace="1"></td>
			</tr>
		</table>	
		
		<c:choose>
			<c:when test="${totalCount != '0'}">
				<table style="TABLE-LAYOUT: fixed; margin-top:2;padding-top:4" cellSpacing="0" cellPadding="0" width="100%" border="0">
					<c:forEach items="${list}" var="item">
						<tr onClick="ItemRead_onclick('${item.itemID}', '${boardID}');">
							<td width="15" height="20" class="plist"><img src="/images/main/dot_02.gif" width="4" height="3" align="absmiddle"></td>
							<td height="20" style="overflow:hidden;text-overflow:ellipsis">
								<nobr>
									<span onMouseOver="this.style.color='#006BB6'" title="${item.ABSTRACT}" style="CURSOR: hand" onmouseout="this.style.color='#393939'">
										<c:if test="${fn:indexOf(itemFields, 'STARTDATE') > -1} ">
											[<c:out value='${fn:substring(item.startDate, 5, 5)}'></c:out>]&nbsp;&nbsp; 
										</c:if>
										<c:if test="${fn:indexOf(itemFields, 'WRITERNAME') > -1} ">
											(<c:out value='${item.writerName}'></c:out>)&nbsp; 
										</c:if>
										<c:if test="${fn:indexOf(itemFields, 'TITLE') > -1}">
											<c:out value='${item.title}'></c:out> 
										</c:if>
									</span>&nbsp;
								</nobr>	
							</td>
						</tr>
						<tr>
							<td colspan="2" height="1" background="/images/main/line_dot01.gif"></td>
						</tr>		
					</c:forEach>
				</table>
			</c:when>
			<c:otherwise>
				<table id="noQuery" style="TABLE-LAYOUT: fixed; margin-top:2;padding-top:4;" cellSpacing="0" cellPadding="0" width="100%" border="0">
					<tr>
						<td width="15" height="20" class="plist"><img src="/images/main/dot_02.gif" width="4" height="3" align="absmiddle"></td>
						<td height="20" style="overflow:hidden;text-overflow:ellipsis"><nobr><spring:message code='ezBoard.t340'/></nobr></td>
					</tr>
					<tr>
						<td colspan="2" height="1" background="/images/main/line_dot01.gif"></td>
					</tr>
				</table>		
			</c:otherwise>
		</c:choose>
		<br>
	</body>
</html>