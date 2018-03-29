<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t320'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		    function close_onclick() {
		    	parent.DivPopUpHidden();
		    }
		    
		    function bindOtherJournal(){
		    	var journalId = $("input[type='radio'][name='otherJournalRadio']:checked").val();
		    	parent.getOtherJournal(journalId);
		    }
		</script>
	</head>
	<body class="popup">
		<form method="post" >
		  <h1><spring:message code='ezJournal.t75'/></h1>
		  <div id="close">
		    <ul>
		      <li onClick="bindOtherJournal();"><span><spring:message code='ezJournal.t86'/></span></li>
		      <li onClick="close_onclick()"><span><spring:message code='ezBoard.t12'/></span></li>
		    </ul>
		  </div>
		  <script type="text/javascript">
		    selToggleList(document.getElementById("close"), "ul", "li", "0");
		  </script>
	        <div style="width:100%; height:305px" id="divList">
	            <table class="popuplist" style="width:100%">
	            <c:choose>
		            <c:when test="${fn:length(journalList) ne 0 }">
			            <c:forEach items="${journalList }" var="journal" varStatus="status">
							<tr style="background-color: rgb(255, 255, 255);">
								<td style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
								<input type="radio" value="${journal.journalId }" name="otherJournalRadio" style="width: 13px; height: 13px; padding : 0px; margin : 0px; vertical-align: middle"></td>
								<td align="left"
									style="width: 300px; text-align: center; cursor: pointer;">${journal.journalTitle }</td>
<!-- 								<td align="left" -->
<%-- 									style="width: 130px; text-align: center; cursor: pointer;">${journal.formName }</td> --%>
								<td align="left"
									style="width: 130px; text-align: center; cursor: pointer;">${journal.journalDate }</td>
							</tr>
			            </c:forEach>
		            </c:when>
		            <c:otherwise>
		            	<tr style="background-color: rgb(255, 255, 255);">
							<td align="left" colspan="3"
								style="width: 130px; text-align: center; cursor: pointer;"><spring:message code='ezJournal.t147'/></td>
						</tr>
		            </c:otherwise>
	            </c:choose>
			</table>
	        </div>
	        <div id='runtime' style="color:#666;padding-top:5px"></div>
		</form>
	</body>
</html>