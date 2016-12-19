<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	<frameset cols="200,*" frameborder="0" border="0">
		<frame src="${url}" name="left" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
        <c:if test="${IsJMochaStandAlone != 'YES'}">
			<%
				String usePortal = (String)request.getAttribute("usePortal");
			%>
		
			<% if (usePortal.equals("YES")) { %>
				<frame src="/ezPortal/myPortalPageList.do" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
			<% } else if(request.getHeader("User-Agent").indexOf("MSIE") > -1 || request.getHeader("User-Agent").indexOf("Trident") > -1) { %>
				<frame src="/myoffice/ezPersonal/WebPart/UserManageWebPart.aspx" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
			<% } else {  %>
				<frame src="/myoffice/ezPersonal/PersonInfo/ChangePersonInfo_cross.aspx" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
			<% } %>
        </c:if>
        <c:if test="${IsJMochaStandAlone == 'YES'}">
            <frame src="/ezPersonal/changePersonInfo.do" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
        </c:if>
	</frameset>
</html>