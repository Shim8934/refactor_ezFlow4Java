<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezQuestion.t270" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<link href="/css/default_kr.css" rel="stylesheet" type="text/css">
		<style>
		</style>
		<script type="text/javascript">
 		    window.onunload = function() {
 				window.opener.popupClosing();
		    }; 
		    
		    function btn_Delete() {
		    	var checkedList = "<c:out value='${listQstIds}'/>";
		        var xmlHttp = createXMLHttpRequest();
		        var szUrl = "/ezPoll/deleteQuestion.do?listQst=" + checkedList;
		        xmlHttp.open("POST", szUrl, false);
		        xmlHttp.send();
		        var resultXML = xmlHttp.responseXML;
		        
		        if (resultXML.xml == "") {
		            alert("<spring:message code='ezQuestion.t263'/>" + "\n" + "<spring:message code='ezQuestion.t264'/>");
		        }
		        else {
		            state = SelectSingleNodeValue(resultXML, "DATA");
		            
		            if (state != "DELETE_OK") {
		                alert("<spring:message code='ezQuestion.t263'/>" + "\n" + "<spring:message code='ezQuestion.t264'/>");
		            }
		            else {
		            	window.close();
		            }
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<form id="Form1" method="post"> 
			<h1 style="padding-left: 40%;"><spring:message code='ezPoll.t127'/></h1>
			<div style="height:119px; overflow: auto;">
	  			<table class="content" style="table-layout: fixed;">   				
	    			<tr > 
	      				<th style="width:30px;"><spring:message code='ezPoll.t128'/></th> 
	      				<th><spring:message code='ezPoll.t129'/></th>				
	    			</tr> 
	    			<c:forEach var="list" items="${listQuestionIDs}" varStatus="status">
		    			<tr> 
		      				<td style="width: 25px;padding-left: 40px;">${list}</td>
		      				<td>${listQuestionContents[status.index]}</td> 
		    			</tr> 
	    			</c:forEach>
	  			</table>
	  		</div>
  			<div class="box" style="padding:10px;margin-top:10px">
  				<c:if test="${numberOfQst == 1}">
  					<spring:message code='ezPoll.t130'/><br> 
        			<spring:message code='ezPoll.t131'/>
  				</c:if>
  				<c:if test="${numberOfQst > 1}">
	  				<spring:message code='ezPoll.t132'/> <c:out value='${numberOfQst}'/> <spring:message code='ezPoll.t133'/><br> 
	        		<spring:message code='ezPoll.t131'/>
  				</c:if>
        	</div>
			<div class="btnposition">
				<input type="button" name="Submit" value="<spring:message code='ezQuestion.t268' />" onclick="btn_Delete()"> 
        		<input type="button" name="Submit2" value="<spring:message code='ezQuestion.t269' />" onclick="window.close()">
        	</div>
		</form> 
	</body>
</html>