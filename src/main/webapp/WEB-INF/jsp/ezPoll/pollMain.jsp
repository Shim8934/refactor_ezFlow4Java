<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<iframe id="left" class="fold" src="/ezPoll/pollLeft.do?qstId=<c:out value="${qstId }"/>" name="left"
		style="width:<c:out value='${leftFrameWidth}'/>px"></iframe>
<iframe src="about:blank" id="right" name="right"></iframe>
</body>
</html>
