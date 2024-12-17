<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezPoll.t229" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style>
		</style>
		<script type="text/javascript">
/*  		    window.onunload = function() {
 				window.opener.popupClosing();
		    }; */ 
		    
		    function btn_Delete() {
		    	var checkedList = "<c:out value='${listQstIds}'/>";
		        var xmlHttp = createXMLHttpRequest();
		        var szUrl = "/ezPoll/deleteQuestion.do?listQst=" + checkedList;
		        xmlHttp.open("POST", szUrl, false);
		        xmlHttp.send();
		        var resultXML = xmlHttp.responseXML;
		        
		        if (resultXML.xml == "") {
		            alert("<spring:message code='ezPoll.t230'/>" + "\n" + "<spring:message code='ezPoll.t231'/>");
		        }
		        else {
		            var state = SelectSingleNodeValue(resultXML, "DATA");
		            
		            if (state != "DELETE_OK") {
		                alert("<spring:message code='ezPoll.t230'/>" + "\n" + "<spring:message code='ezPoll.t231'/>");
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
			<div id="close">
	            <ul>
	                <li><span onclick="window.close()"></span></li>
	            </ul>
	        </div>
			<div style="overflow: auto; max-height: 120px;">
	  			<table class="content" style="table-layout: fixed; width: 100%;">   				
	    			<tr > 
	      				<%-- <th style="width:30px;"><spring:message code='ezPoll.t128'/></th>  --%>
	      				<th style="text-align:center;"><spring:message code='ezPoll.t244'/></th>				
	    			</tr> 
	    			<c:forEach var="list" items="${listQuestionIDs}" varStatus="status">
		    			<tr> 
		      				<%-- <td style="width: 25px; text-align:center;">${list}</td> --%>
		      				<td style="overflow: hidden; cursor: default; text-overflow: ellipsis; padding:0px 10px; max-width: 270px; white-space: nowrap; line-height: 25px;" title="<c:out value='${listQuestionContents[status.index]}'/>"><c:out value='${listQuestionContents[status.index]}'/></td> 
		    			</tr> 
	    			</c:forEach>
	  			</table>
	  		</div>
  			<div class="box" style="padding:10px; margin-top:10px; line-height:19px;">
  				<c:if test="${numberOfQst == 1}">
  					<spring:message code='ezPoll.t130'/><br> 
        			<spring:message code='ezPoll.t131'/>
  				</c:if>
  				<c:if test="${numberOfQst > 1}">
	  				<spring:message code='ezPoll.t130'/><br> 
	        		<spring:message code='ezPoll.t131'/>
  				</c:if>
        	</div>
			<div class="btnposition btnpositionNew">
				<input type="button" name="Submit" value="<spring:message code='ezPoll.t228' />" onclick="btn_Delete()">
        	</div>
		</form> 
	</body>
</html>