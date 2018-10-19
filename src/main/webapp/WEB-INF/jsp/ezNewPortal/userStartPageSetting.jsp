<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User Startpage</title>
<link rel="stylesheet"  href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css">

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript">
</script>
</head>
<body class="mainbody">
	<h1><spring:message code='ezPortal.t265'/></h1>
	<div id="mainmenu">
		<ul>
			<li><span id="setStartPage"><spring:message code='ezPortal.t248'/></span></li>
		</ul>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" class="ltitle">
		<tr>
			<td height="1" class="dotted"></td>
		</tr>	
		<tr>
			<td height="1"  bgcolor="#ffffff"></td>
		</tr>		
		<tr>
			<td height="50" > 
				<div>▒&nbsp;<spring:message code='ezPortal.t266'/></div>
                <div style="margin-top:3px">▒&nbsp;<spring:message code='ezPortal.t267'/></div>
			</td>
		</tr>
		<tr>
			<td height="1"  bgcolor="#ffffff"></td>
		</tr>
		<tr>
			<td  class="dotted"></td>
		</tr>
	</table>
	<table class="mainlist" style="width:100%"> 
		<tr>
			<th width="120">&nbsp;</th>
			<th width=""><spring:message code='ezPortal.t268'/></th>
			<th width="150"><spring:message code='ezPortal.t257'/></th>
			<th width="150"> &nbsp;</th>
		</tr>
	</table>
	<table class="mainlist">
		<c:forEach items="${menuList}" var="menu">
		<c:choose>
			<c:when test="${menu.menuId eq 0 }">
				<tr>
					<td></td>
					<td>${menu.menuName }</td>
					<td></td>
			        <td width="150"></td>	
				</tr>
			</c:when>
			<c:when test="${menu.menuId eq menuId }">
				<tr>
					<td></td>
					<td>${menu.menuName }</td>
					<td>사용중</td>
			        <td width="150"></td>	
				</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<td width="120"></td>
					<td>${menu.menuName }</td>
					<td width="150"></td>
			        <td width="150"></td>	
			</c:otherwise>
		</c:choose>
		</c:forEach>
	</table>
</body>
</html>