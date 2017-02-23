<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>main</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	
	<c:choose>
		<c:when test="${cID == ''}">
			<frameset cols="200,*" frameborder="NO" border="0" framespacing="0">
				<frame src="/admin/ezCommunity/left.do" name="comm_left" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" noresize="noresize">
				<frame src="/admin/ezCommunity/right.do" name="comm_right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
		</c:when>
		
		<c:otherwise>
			<frameset cols="200,*" frameborder="NO" border="0" framespacing="0">
				<frame src="/admin/ezCommunity/left.do" name="comm_left" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" noresize="noresize">
				<frame src="/admin/ezCommunity/right.do?cID="<c:out value = '${cID}' />" name="comm_right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
		</c:otherwise>
	</c:choose>
</html>