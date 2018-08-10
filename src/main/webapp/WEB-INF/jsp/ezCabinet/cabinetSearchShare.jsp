<%@ page language="java"   contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCabinet.t136"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabShareFile">
		<h1 id="moveCabTtl"><spring:message code="ezCabinet.t136"/></h1>
		<div class="cabClose"><ul><li><span id="closeBttn"></span></li></ul></div>
		
		<div class="cabShareListDiv2">
			<div>
				<table id="sharedTable" class="mainlist">
					<tr>
						<td><spring:message code='ezCabinet.t103'/></td>
						<td><spring:message code='ezCabinet.t104'/></td>
						<td><spring:message code='ezCabinet.t105'/></td>
						<td><spring:message code='ezCabinet.t106'/></td>
					</tr>
					<c:choose>
						<c:when test="${fn:length(listUsers) gt 0}">
							<c:forEach items="${listUsers}" var="sharedUser">
								<tr class="bnkCabNormal" role="${sharedUser.userId}" deptname="${sharedUser.deptName}" usertype="${sharedUser.userType}">
									<td title="<c:out value='${sharedUser.deptName}'/>"><c:out value='${sharedUser.deptName}'/></td>
									<td title="<c:out value='${sharedUser.userName}'/>"><c:out value='${sharedUser.userName}'/></td>
									<td>
										<select>
											<option value="0" ${sharedUser.permission == 0 ? 'selected' : ''}><spring:message code='ezCabinet.t132'/></option>
											<option value="1" ${sharedUser.permission == 1 ? 'selected' : ''}><spring:message code='ezCabinet.t133'/></option>
										</select>
									</td>
									<td>
										<select>
											<option value="0" ${sharedUser.subPermission == 0 ? 'selected' : ''}><spring:message code='ezCabinet.t134'/></option>
											<option value="1" ${sharedUser.subPermission == 1 ? 'selected' : ''}><spring:message code='ezCabinet.t135'/></option>
										</select>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="4" style="text-align: center;"><spring:message code='ezCabinet.t131'/></td>
							</tr>
						</c:otherwise>
					</c:choose>
				</table>
			</div>
		</div>
		
		<div class="btnposition" id="cabShareBttn">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t79'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t46'/></span></a>
		</div>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTable.js"          ></script>
		<script type="text/javascript">
			(function() {
				var selectedUsers = new CabinetTable({
					normal   : "bnkCabNormal",
					selected : "bnkCabSelect",
					mode     : "received"
				});
				
				initEvents();
				
				function initEvents() {
					document.onselectstart  = function () { return false;};
					document.getElementById("closeBttn").addEventListener("click", function(e) {closeWindow();}, false);
					
					var cabShareBttnElmt    = document.getElementById("cabShareBttn");
					var listBttns           = cabShareBttnElmt.children;
					listBttns[0].onclick    = function(e) {changeShareUsers();};
					listBttns[1].onclick    = function(e) {deleteShareUsers();};
					
					//Set selected tables 
					selectedUsers.setTableElement("sharedTable", "id");
					selectedUsers.resetEvents();
				}
				
				function deleteShareUsers() {
					var shareTable = document.getElementById("sharedTable");
					var listTr     = shareTable.querySelectorAll("tr[class='bnkCabSelect']");
					if (!listTr || listTr.length == 0) {alert(CabinetMessages.strSelect2); return;}
					var userList   = [];
					
					for(var i = 0, len = listTr.length; i < len; i++) {
						var userId   = listTr[i].getAttribute("role");
						var userType = listTr[i].getAttribute("userType");
						userList.push({userId: userId, userType : userType});
					}
					
					var parentWd    = window.opener;
					if (parentWd && parentWd.CabinetShareItem) {parentWd.CabinetShareItem.deleteUsers(userList);}
					closeWindow();
				}
				
				function changeShareUsers() {
					var shareTable = document.getElementById("sharedTable");
					var listTr     = shareTable.rows;
					var userList   = [];
					
					for (var i = 1, len = listTr.length; i < len; i++) {
						var userId   = listTr[i].getAttribute("role");
						var userType = listTr[i].getAttribute("userType");
						var perSlBox = listTr[i].children[2].firstElementChild;
						var subSlBox = listTr[i].children[3].firstElementChild;
						var permiss  = perSlBox.options[perSlBox.selectedIndex].value;
						var subPerm  = subSlBox.options[subSlBox.selectedIndex].value;
						userList.push({userId: userId, userType : userType, permis: permiss, subPerm: subPerm});
					}
					
					var parentWd    = window.opener;
					if (parentWd && parentWd.CabinetShareItem) {parentWd.CabinetShareItem.changeUsers(userList);}
					closeWindow();
				}
				
				function closeWindow() {window.close();}
			})();
		</script>
	</body>
</html>