<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1"/>
	</head>
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="about:blank" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		    <frameset cols="${leftFrameWidth},*" frameborder="0" border="0" id="frameset">
			    <frame src="/ezAttitude/attitudeLeft.do" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize>
	            <frame src="about:blank" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize>
		    </frameset>
    </frameset>
</html>