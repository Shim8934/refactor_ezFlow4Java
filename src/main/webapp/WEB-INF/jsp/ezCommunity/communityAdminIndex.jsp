<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Community <spring:message code = 'ezCommunity.t565' /></title>
	</head>
	
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="about:blank" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		    <frameset cols="200,*" frameborder="0" border="0">
			    <frame name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize="noresize" src="/ezCommunity/adminLeft.do?code=<c:out value = '${code}' />&num=<c:out value ='${num}' />">
	            <frame name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" src="/ezCommunity/adminBasic.do?code=<c:out value = '${code}' />&flag=<c:out value = '${flag}' />">
		    </frameset>
    </frameset>
</html>