<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<iframe id="left" class="fold" src="${url}" name="left"
		style="width:<c:out value='${leftFrameWidth}'/>px"></iframe>
<iframe src="about:blank" id="right" name="right"></iframe>
</body>
</html>