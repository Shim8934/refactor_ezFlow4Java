<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t303" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>	
	<frameset rows="50,*" frameborder="0" border="0">
		<frame src="/admin/ezWebFolder/webfolderAdminTop.do" name="top" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		<frameset cols="220,*" frameborder="0" border="0">
			<frame src="/admin/ezWebFolder/webfolderAdminLeft.do" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize style="border-top:1px solid #333">
			<frame src="about:blank" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize style="border-top:1px solid #333">
		</frameset>
	</frameset>
</html>
