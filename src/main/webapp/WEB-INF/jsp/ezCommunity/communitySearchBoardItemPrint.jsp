<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezCommunity.t1463'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" type="text/css" href="/css/community.css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			
		</script>
	</head>
	
	<body class="popup">
		<h1><spring:message code='ezCommunity.t1463'/></h1>
		<div id="close">
	  		<ul>
		    	<li><span onClick="window.close();"><spring:message code='ezCommunity.t21'/></span></li>
		  	</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<table class="content">
			<tr>
		    	<th><spring:message code='ezCommunity.t1464'/></th>
		        <td>${userInfo.displayName }(${userInfo.deptName })</td>
		    </tr>
		    <tr>
		    	<th ><spring:message code='ezCommunity.t1465'/></th>
		        <td>${boardName }</td>
			</tr>
	        <tr>
				<th ><spring:message code='ezCommunity.t1466'/></th>
		        <td>${strNow }</td>
	        </tr>
	        <tr>
		    	<th ><spring:message code='ezCommunity.t1431'/></th>
		        <td>${searchConfig }</td>
	        </tr>
		</table>
		<br>
		<table width="100%" class="popuplist">
	    	<tr>
	    		<c:choose>
					<c:when test="${pSortBy == 'A.Title'}">
			    		<th onClick="SortPage('A.Title desc')"><spring:message code='ezCommunity.t124'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.Title desc'}">
			    		<th onClick="SortPage('A.Title')"><spring:message code='ezCommunity.t124'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th onClick="SortPage('A.Title')"><spring:message code='ezCommunity.t124'/></th>
			    	</c:otherwise>
			    </c:choose>
		        
		        <c:choose>
					<c:when test="${pSortBy == 'A.WriterDeptName'}">
			    		<th width="80" onClick="SortPage('A.WriterDeptName desc')"><spring:message code='ezCommunity.t241'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.WriterDeptName desc'}">
			    		<th width="80" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="80" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241'/></th>
			    	</c:otherwise>
			    </c:choose>
		            
		        <c:choose>
					<c:when test="${pSortBy == 'A.WriterName'}">
			    		<th width="60" onClick="SortPage('A.WriterName desc')"><spring:message code='ezCommunity.t445'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.WriterName desc'}">
			    		<th width="60" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="60" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445'/></th>
			    	</c:otherwise>
			    </c:choose>
			    
			    <c:choose>
					<c:when test="${pSortBy == 'A.ParentWriteDate'}">
			    		<th width="60" onClick="SortPage('A.ParentWriteDate desc')"><spring:message code='ezCommunity.t209'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.ParentWriteDate desc'}">
			    		<th width="60" onClick="SortPage('A.ParentWriteDate')"><spring:message code='ezCommunity.t209'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="60" onClick="SortPage('A.ParentWriteDate')"><spring:message code='ezCommunity.t209'/></th>
			    	</c:otherwise>
			    </c:choose>
			    
			    <c:choose>
					<c:when test="${pSortBy == 'A.Attachments'}">
			    		<th width="10" onClick="SortPage('A.Attachments desc')"><spring:message code='ezCommunity.t172'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.Attachments desc'}">
			    		<th width="10" onClick="SortPage('A.Attachments')"><spring:message code='ezCommunity.t172'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="10" onClick="SortPage('A.Attachments')"><spring:message code='ezCommunity.t172'/></th>
			    	</c:otherwise>
			    </c:choose>
			    
			    <c:choose>
					<c:when test="${pSortBy == 'A.ReadCount'}">
			    		<th width="30" onClick="SortPage('A.ReadCount desc')"><spring:message code='ezCommunity.t173'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.Attachments desc'}">
			    		<th width="30" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="30" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173'/></th>
			    	</c:otherwise>
			    </c:choose>
			</tr>
		</table>
	</body>
</html>