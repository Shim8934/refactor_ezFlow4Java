<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCabinet.t159"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
	</head>
	<body class="popup cabShareFile">
		<h1><spring:message code="ezCabinet.t158"/></h1>
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
								<tr class="bnkCabNormal">
									<td title="<c:out value='${sharedUser.deptName}'/>"><c:out value='${sharedUser.deptName}'/></td>
									<td title="<c:out value='${sharedUser.userName}'/>"><c:out value='${sharedUser.userName}'/></td>
									<td>
										<c:choose>
											<c:when test="${sharedUser.permission == 0}"><spring:message code='ezCabinet.t132'/></c:when>
											<c:otherwise><spring:message code='ezCabinet.t133'/></c:otherwise>
										</c:choose>
									</td>
									<td>
										<c:choose>
											<c:when test="${sharedUser.subPermission == 0}"><spring:message code='ezCabinet.t134'/></c:when>
											<c:otherwise><spring:message code='ezCabinet.t135'/></c:otherwise>
										</c:choose>
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
		
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')}"></script>
		<script type="text/javascript">
			(function() {
				initEvents();
				
				function initEvents() {
					document.onselectstart = function () { return false;};
					document.getElementById("closeBttn").addEventListener("click", function(e) {closeWindow();}, false);
				}
				
				function closeWindow() {window.close();}
			})();
		</script>
	</body>
</html>