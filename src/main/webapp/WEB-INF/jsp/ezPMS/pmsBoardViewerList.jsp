<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
	<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezPMS/common.js"></script>
	<script type="text/javascript">
		selToggleList(document.getElementById("close"), "ul", "li", "0");
	</script>
	<style type="text/css">
		.popuplist tr:nth-child(even) td{
			background-color : #f8f8fa;
		}
	</style>
</head>
<body class="popup">
	<form method="post" >
		<h1><spring:message code='ezBoard.t320'/></h1>
		<div id="close">
			<ul>
				<li onClick="close_onclick()"><span><spring:message code='ezBoard.t12'/></span></li>
		    </ul>
		</div>
		<div style="width:100%; height:305px" id="divList">
			 <c:choose>
	            <c:when test="${fn:length(viewerList) ne 0 }">
            		<table class="popuplist" style="width:100%;">
			            <c:forEach items="${viewerList}" var="viewer" varStatus="status">
							<tr data-userid="${viewer.userId}" onclick="show_info(this);" style="background-color: rgb(255, 255, 255);">
								<td align="left" style="width: 130px; text-align: center; cursor: pointer;"><c:out value='${viewer.userName}'/></td>
								<td align="left" style="width: 120px; text-align: center; cursor: pointer;"><c:out value='${viewer.userDeptName}'/></td>
								<td align="left" style="width: 80px; text-align: center; cursor: pointer;"><c:out value='${viewer.position}'/></td>
								<td align="left" style="width: 150px; text-align: center; cursor: pointer;"><c:out value='${fn:substring(viewer.readDate, 0, 16) }'/></td>
							</tr>
			            </c:forEach>
					</table>
	            </c:when>
	            <c:otherwise>
            		<table class="popuplist" style="width:100%; height:100%;">
		            	<tr style="background-color: rgb(255, 255, 255);">
							<td align="left" colspan="3" style="height:100%; width: 130px; text-align: center; cursor: pointer;"><spring:message code='ezBoard.kbm01'/></td>
						</tr>
					</table>
	            </c:otherwise>
            </c:choose>
		</div>
	</form>
	 
</body>
</html>