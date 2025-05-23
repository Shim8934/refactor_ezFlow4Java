<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<spring:message code='ezApprovalG.t1217'/>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript">
			var ReturnFunction;
			window.onload = function () {
				if (isParentCommonArgsUsed()) {
					ReturnFunction = parent.ezCommon_cross_dialogArguments[1];
				}
			}
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<h1>
			<spring:message code='ezApprovalG.t1217'/>
		</h1>
		<div id="close">
		  <ul>
		    <li><span onclick="btnClose_onclick()"></span></li>
		  </ul>
		</div>
		
		<div class="portlet_tabpart01" style="margin:0px;">
       		<div class="portlet_tabpart01_top" style="border-bottom:0px;">
			    <p id="tagsub1"><span class="tabon">
			   	    <spring:message code='ezApprovalG.t53'/>
					<c:if test="${fn:startsWith(receiptId, susinGroupPrefix)}">(<c:out value="${receiptName}" />)</c:if>
			    </span></p>
       		</div>
       	</div>
       	
		<div class="listview" style="overflow-x:auto;width:100%;">
			<div id="lvAprLine" style="height:360px;width:100%;">
				<table id="AprLine" class="mainlist" style="width: 100%;">
					<thead>
						<tr>
								<c:choose>
						  <c:when test="${lang == '1'}">
							<th>순번</th>
							<th>수신부서</th>
							<th>수신자성명</th>
						  </c:when>
		     		      <c:when test="${lang == '2'}">
							<th>No.</th>
							<th>Dept.</th>
							<th>name</th>
						  </c:when>
		     		      <c:when test="${lang == '3'}">
							<th>順番</th>
							<th>受信部署名</th>
							<th>受信者氏名</th>
						  </c:when>  
						</c:choose>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="receipts" items="${receipts}">
							<tr>
								<td><c:out value="${receipts.SN}" /></td>
								<td><c:out value="${receipts.DISPLAYRECEIPTPOINTNAME}" /></td>
								<td><c:out value="${receipts.DISPLAYRECEIPTMEMBERNAME}" /></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</body>
</html>