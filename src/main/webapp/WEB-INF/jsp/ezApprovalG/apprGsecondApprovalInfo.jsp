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
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script ID="clientEventHandlersJS" LANGUAGE="javascript">
		    function btncancel_onclick() {
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<h1>&nbsp;<spring:message code='ezApprovalG.t1776'/></h1>
		    <div style="overflow:auto;height:200px;">
		<table  class="content">
		    <tr>
		        <th style='width:200px'><spring:message code='ezApprovalG.t1777'/></th>
		        <th style='width:200px'><spring:message code='ezApprovalG.t1778'/></th>
		        <th><spring:message code='ezApprovalG.t1780'/></th>    
		    </tr>
		    <c:forEach var="result" items="${strResult}" varStatus="status">
		    	<c:set var="temp" value="${fn:split(result.extensionAttribute5, ':')}"/>
		    	<c:choose>
		    		<c:when test="${userInfo.primary == '1'}">
	                    <tr>
	                        <td style='width:200px;padding-left:10px;' userid = '${result.userID}'><nobr>${result.userName}</nobr></td>
	                        <td style='width:200px;padding-left:10px;' userid = "${fn:split(result.extensionAttribute5, ':')[0]}"> <nobr>${result.pUserName}</nobr></td>
	                        <td style='padding-left:10px;'><nobr>${fn:split(result.extensionAttribute5, ':')[3]} ~ ${fn:split(result.extensionAttribute5, ':')[4]}</nobr></td>
	                    </tr>
		    		</c:when>
		    		<c:otherwise>
	                    <tr>
	                        <td style='width:200px;padding-left:10px;' userid = '${result.userID}'><nobr>${result.userName2}</nobr></td>
	                        <td style='width:200px;padding-left:10px;' userid = "${fn:split(result.extensionAttribute5, ':')[0]}"> <nobr>${result.pUserName2}</nobr></td>
	                        <td style='padding-left:10px;'><nobr>${fn:split(result.extensionAttribute5, ':')[3]} ~ ${fn:split(result.extensionAttribute5, ':')[4]}</nobr></td>
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
		<div class="btnposition" >    
		    <input type="submit" name="Submit2" value="<spring:message code='ezApprovalG.t64'/>" onClick="return btncancel_onclick()">
		</div>
	</body>
</html>