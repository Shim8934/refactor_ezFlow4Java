<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
	</head>
	<frameset cols="200,*" frameborder="NO" border="0" framespacing="0">
		<frame src="/admin/ezApproval/apprLeft.do" name="lef" frameborder="no" scrolling="NO" noresize marginwidth="0" marginheight="0" id="lef" frameborder="NO">  
		<c:choose>
			<c:when test="${isIEBrowser}">
				<frame src="/admin/ezApproval/formAdmin.do" name="right" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0" id="Frame1" frameborder="NO">
			</c:when>
			<c:otherwise>
				<frame src="/myoffice/ezApproval/manage/MCont.aspx" name="right" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0" id="Frame2" frameborder="NO">
			</c:otherwise>
		</c:choose>
	</frameset>
	<noframes>
		<body>
		</body>
	</noframes>
</html>