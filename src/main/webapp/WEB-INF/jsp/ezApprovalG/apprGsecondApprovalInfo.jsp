<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1776'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style>
			.datepicker { BEHAVIOR:url(include/datepicker.htc) }
		</style>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script ID="clientEventHandlersJS" LANGUAGE="javascript">
		    function btncancel_onclick() {
		        window.close();
		    }
		</script>
	</head>
	<body class="popup" >
		<h1>&nbsp;<spring:message code='ezApprovalG.t1776'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="return btncancel_onclick()"></span></li>
            </ul>
        </div>
		<div style="overflow:auto;height:145px;">
			<table  class="content">
			    <tr>
			        <th style='width:100px'><spring:message code='ezApprovalG.t1777'/></th>
			        <th style='width:100px'><spring:message code='ezApprovalG.t1778'/></th>
			        <th style='width:250px'><spring:message code='ezApprovalG.t1780'/></th>    
			    </tr>
			    <c:forEach var="result" items="${strResult}" varStatus="status">
			    	<c:set var="temp" value="${fn:split(result.extensionAttribute5, ':')}"/>
			    	<c:choose>
			    		<c:when test="${userInfo.primary == '1'}">
		                    <tr>
		                        <td style='width:100px; padding-left:10px;padding-right:10px;' userid = '${result.userID}'><nobr>${result.userName}</nobr></td>
		                        <td style='width:100px; padding-left:10px;padding-right:10px;' userid = "${temp[0]}"> <nobr>${result.pUserName}</nobr></td>
		                        <td style='padding-left:10px;padding-right:10px;'><nobr>${temp[3]}:${temp[4]} ~ ${temp[5]}:${temp[6]}</nobr></td>
		                    </tr>
			    		</c:when>
			    		<c:otherwise>
		                    <tr>
		                        <td style='width:100px; padding-left:10px;padding-right:10px;' userid = '${result.userID}'><nobr>${result.userName2}</nobr></td>
		                        <td style='width:100px; padding-left:10px;padding-right:10px;' userid = "${temp[0]}"> <nobr>${result.pUserName2}</nobr></td>
		                        <td style='padding-left:10px;padding-right:10px;'><nobr>${temp[3].replace('/', ':')} ~ ${temp[4].replace('/', ':')}</nobr></td>
		                    </tr>
			    		</c:otherwise>
			    	</c:choose>
			    </c:forEach>
			    
			    <c:set var="listLength" value = "${fn:length(strResult)}"/>
		    	<c:if test="${listLength <= 0}">
	                <tr><td colspan='3' align="center"><spring:message code='ezApprovalG.t1779'/></td></tr>
		    	</c:if>
			</table>
		</div>
	</body>
</html>
