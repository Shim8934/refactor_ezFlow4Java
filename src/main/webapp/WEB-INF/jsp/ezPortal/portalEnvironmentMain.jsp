<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	<frameset cols="${leftFrameWidth},*" frameborder="0" border="0" id="frameset">
		<frame src="${url}" id="left" name="left" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		<frame src="" id="right" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
	</frameset>
</html>