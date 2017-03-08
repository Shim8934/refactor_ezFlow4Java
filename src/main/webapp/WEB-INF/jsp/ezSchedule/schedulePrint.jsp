<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t261' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />	    
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>        
        <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>        
		<script>	
		    window.onbeforeprint = function () {
		        document.all.normalScreen.style.display = "none";
		    }
			
		    window.onafterprint = function () {
		        document.all.normalScreen.style.display = "";
		    }
		</script>
		<style type="text/css">
	       html, body {height: 101%;}        
	    </style>
	</head>	
	<body id="body" class="popup" scroll="auto">    
		<form method="post"> 
			<div id="normalScreen" >
		    	<div id="menu">
		      		<ul>
		        		<li><span onClick="window.print()"><spring:message code='ezSchedule.t217' /></span></li>
		      		</ul>
		    	</div>
		    	<div id="close">
		      		<ul>
		        		<li><span onClick="window.close()"><spring:message code='ezSchedule.t16' /></span></li>
		      		</ul>
		    	</div>
		  	</div>
		  	<table style="width:100%" class="box">
		    	<tr>
		      		<td style="width:50%;height:22px; vertical-align:bottom">
		      			<div style="margin-left:10px">
		      				<spring:message code='ezSchedule.t263' />
		        			${deptName}
		        		</div>	
		        	</td>
		      		<td style="width:50%; vertical-align:bottom">
		      			<div style="margin-left:5px">
		      				<spring:message code='ezSchedule.t264' />
		        			${name}
		        		</div>	
		        	</td>
		    	</tr>
		    	<tr style="vertical-align:top;">
		      		<td style="height:22px;">
		      			<div style="margin-left:5px;margin-top:3px">${description}</div>
		      		</td>
		      		<td>
		      			<div style="margin-left:5px;margin-top:3px">
		      				<spring:message code='ezSchedule.t265' />
		      				${today}
		        		</div>
		      		</td>
		    	</tr>
		  	</table>
		  	<br/>
		  	<table style="width:100%">
		    	<tr>
		      		<td style="width:100px">
		      			<h2><spring:message code='ezSchedule.t266' /></h2>
		      		</td>
		      		<td style="text-align:right"><span id="resultCount"></span></td>
		      		<td style="text-align:right">
		      			<spring:message code='ezSchedule.t267' />
		        		${fn:length(scheduleListData)}
		        		<spring:message code='ezSchedule.t268' />
		        	</td>
		    	</tr>
		  	</table>
		  	<table class="popuplist" style="table-layout:fixed;width:100%;">
		  		<colgroup>
		  			<col width="6%" /><col width="9%" /><col width="9%" /><col width="22%" /><col width="18%" /><col width="18%" /><col width="18%" />
		  		</colgroup>
		    	<tr>
		      		<th><spring:message code='ezSchedule.t269' /></th>
		      		<th><spring:message code='ezSchedule.t270' /></th>
		      		<th><spring:message code='ezSchedule.t271' /></th>
		      		<th><spring:message code='ezSchedule.t272' /></th>
		      		<th><spring:message code='ezSchedule.t273' /></th>
		      		<th><spring:message code='ezSchedule.t274' /></th>
		      		<th><spring:message code='ezSchedule.t275' /></th>
		    	</tr>
		    	<c:forEach var="item" items="${scheduleListData}">
				<tr>
			         <td style="text-align:center;word-break:break-all;">			         
			         	<c:if test="${item.importance == '1'}"><img src='/images/i_l.gif' width='8' height='10' /></c:if>
			         	<c:if test="${item.importance == '2'}">&nbsp;</c:if>
			         	<c:if test="${item.importance == '3'}"><img src='/images/i_h.gif' width='8' height='10' /></c:if>
			         </td>
			         <td style="word-break:break-all;">
			         	<c:if test="${item.scheduleType == '1'}"><spring:message code='ezSchedule.t281' /></c:if>
			         	<c:if test="${item.scheduleType == '2'}"><spring:message code='ezSchedule.t12' /></c:if>
			         	<c:if test="${item.scheduleType == '3'}"><spring:message code='ezSchedule.t11' /></c:if>
			         	<c:if test="${item.scheduleType == '4'}"><spring:message code='ezSchedule.t282' /></c:if>
			         	<c:if test="${item.scheduleType == '7'}"><spring:message code='ezSchedule.t282' /></c:if>
			         	<c:if test="${item.scheduleType == '8'}"><spring:message code='ezSchedule.t205' /> / <spring:message code='ezSchedule.t996' /></c:if>
			         </td>
			         <td style="word-break:break-all;">			          
				        <c:if test="${primary == '1'}">${item.ownerName}</c:if>
						<c:if test="${primary != '1'}">${item.ownerName2}</c:if>
			         </td>
			         <td style="word-break: keep-all;">
					 	${item.title} 
					 </td>
			         <td style="word-break:break-all;">
			         	${item.location} 
			         </td>
			         <td style="word-break:break-all;">
			         	<c:if test="${item.dateType == '2'}">${fn:substring(item.startDate,0,10)}(<spring:message code='ezSchedule.t280' /></c:if>
			         	<c:if test="${item.dateType != '2'}">${fn:substring(item.startDate,0,16)}</c:if>
			         </td>
			         <td style="word-break:break-all;">
			         	<c:if test="${item.dateType == '2'}">${fn:substring(item.endDate,0,10)}(<spring:message code='ezSchedule.t280' /></c:if>
			         	<c:if test="${item.dateType != '2'}">${fn:substring(item.endDate,0,16)}</c:if>
			         </td>
			    </tr>
			    </c:forEach>
		    	<c:if test="${fn:length(scheduleListData) == 0}">
		      	<tr>
		        	<td colspan="7" style="text-align:center"><spring:message code='ezSchedule.t276' /></td>
		      	</tr>
		    	</c:if>
		  	</table>
		  	<br/>
		  	<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
				selToggleList(document.getElementById("close"), "ul", "li", "0");
			</script>		
		</form>
	</body>
</html>