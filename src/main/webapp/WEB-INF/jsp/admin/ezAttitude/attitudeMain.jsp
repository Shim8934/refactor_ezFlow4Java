<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1"/>
	</head>
	<frameset cols="220,*" frameborder="no" border="0" framespacing="0">
		<frame src="<c:url value='/admin/ezAttitude/attitudeLeft.do'/>" name="attitude_menu" frameborder="0" scrolling="auto" marginwidth="0" marginheight="0"/>
		<frame src="<c:url value='/admin/ezAttitude/attitudeRight.do'/>" name="attitude_main" frameborder="0" scrolling="auto" marginwidth="0" marginheight="0"/>
	</frameset>
</html>