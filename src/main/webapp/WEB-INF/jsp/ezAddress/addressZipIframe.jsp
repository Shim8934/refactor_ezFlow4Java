<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezAddress.t368" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>	    	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			function Row_onClick(vThis){
				if(vThis){
					window.parent.Row_onClick(vThis);
				}
			}			
			function onmouseOver(elem){				
				elem.style.backgroundColor = "rgb(186, 236, 254);"
			}	
			function onmouseOut(elem){
				elem.style.color = "";
				elem.style.backgroundColor = "#FFFFFF";
			}
	    </script>
	</head>
	<body>
		<table class="" style="table-layout:fixed;width:610px;">
			<tr>
				<th style="width:61px"><spring:message code='ezAddress.t26' /></th>
				<th style="width:83px"><spring:message code='ezAddress.t27' /></th>
				<th style="width:108px"><spring:message code='ezAddress.t28' /></th>
				<th style="width:80px"><spring:message code='ezAddress.t29' /></th>
				<th style="width:152px"><spring:message code='ezAddress.t30' /></th>
			</tr>
		</table>
		<div id="divAddressList" style="Width:610px; height:200px; overflow-y:auto;">
			<table id="TBAddressList" class="" width="590px" cellspacing=1 style="cursor:pointer;table-layout:fixed;text-align:center">
				<c:forEach var="item" items="${list}">
					<tr style="height:22px" onmouseover="onmouseOver(this)" onmouseout="onmouseOut(this)" onclick="Row_onClick(this)">
						<td style="width:61px"><c:out value='${item.zipcode}'/></td>
						<td style="width:83px"><c:out value='${item.sido}'/></td>
						<td style="width:108px"><c:out value='${item.gugun}'/></td>
						<td style="width:80px"><c:out value='${item.dong}'/></td>
						<td style="width:132px"><c:out value='${item.bunji}'/></td>
					</tr>
				</c:forEach>
			</table>
		</div>		
	</body>
</html>