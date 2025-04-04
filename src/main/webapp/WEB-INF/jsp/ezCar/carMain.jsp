<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<iframe id="left" class="fold" src="${pUrl}" name="left"></iframe>
<iframe src="about:blank" id="right" name="right"></iframe>
</body>
</html>
