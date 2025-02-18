<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!-- 
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
		<title><spring:message code='ezBoard.t10100'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript">
	    var ReturnFunction;
        var eventVal = "";
        function event_onclick(event) {
            eventVal = event;
            if (ReturnFunction != null)
                ReturnFunction(eventVal);
            else {
                window.returnValue = eventVal;
                window.close();
            }
        }
        window.onload = function () {
            
            try {
                ReturnFunction = parent.board_retransoption_dialogArguments[1];
            } catch (e) {}
            
        }
        function close_onclick() {
            if (ReturnFunction != null)
                ReturnFunction();
            else
                window.close();
        }
    </script>
</head>
<body class="popup">
	<h1><spring:message code='ezJournal.t75'/></h1>
    <div id="close">
    	<ul>
       		<li><span onClick=""><spring:message code='ezJournal.t81'/></span></li>
          	<li><span onClick="close_onclick()"><spring:message code='ezJournal.t27'/></span></li>
        </ul>
   	</div>
    <table class="mainlist" style="width:100%;">
		<tr>
			<th></th>
			<th><spring:message code='ezJournal.t56'/></th>
			<th><spring:message code='ezJournal.t25'/></th>
		</tr>
		<c:choose>
			<c:when test="${fn:length(journalList) ne 0}">
				<c:forEach items="${journalList}" var="journal">
					<tr id="${journal.journalId}">
						<td><input type="radio" name="journalSelect" style="width:13px; height:13px; vertical-align: middle;">
						<td>${journal.journalTitle}</td>
						<td>${journal.journalDate}</td>
					</tr>						
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr><td colspan="3"><spring:message code='ezJournal.t147'/></td></tr> 
			</c:otherwise>
		</c:choose>
		
    </table>
</body>
</html>
 -->
 
	<tr>
		<th></th>
		<th><spring:message code='ezJournal.t56'/></th>
		<th><spring:message code='ezJournal.t25'/></th>
	</tr>
	<c:choose>
		<c:when test="${fn:length(journalList) ne 0}">
			<c:forEach items="${journalList}" var="journal">
				<tr id="${journal.journalId}">
					<td><input type="radio" name="journalSelect" style="width:13px; height:13px; vertical-align: middle;">
					<td>${journal.journalTitle}</td>
					<td>${journal.journalDate}</td>
				</tr>						
			</c:forEach>
		</c:when>
		<c:otherwise>
			<tr><td colspan="3"><spring:message code='ezJournal.t147'/></td></tr> 
		</c:otherwise>
	</c:choose>
