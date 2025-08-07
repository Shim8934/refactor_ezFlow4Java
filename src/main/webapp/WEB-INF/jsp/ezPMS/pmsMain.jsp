<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class="frame_main">
<head>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
	</head>
<body>
<iframe id="left" class="fold" src="/ezPMS/pmsLeft.do" name="left"
		style="width:<c:out value='${leftFrameWidth}'/>px"></iframe>
<iframe src="about:blank" id="right" name="right"></iframe>
</body>
</html>