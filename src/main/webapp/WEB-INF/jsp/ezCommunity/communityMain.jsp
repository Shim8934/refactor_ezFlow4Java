<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="about:blank" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		    <frameset cols="${leftFrameWidth},*" frameborder="0" border="0" id="frameset">
			    <frame src="/ezCommunity/communityLeftCommunity.do" name="left" marginwidth="0" marginheight="0" scrolling=no frameborder="0" noresize="noresize">
	            <frame src="about:blank" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
		    </frameset>
    </frameset>
</html>