<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<iframe id="left" class="fold" src="/ezApprovalG/apprGLeft.do?listType=${listType}" name="left"
		style="width:<c:out value='${leftFrameWidth}'/>px"></iframe>
<iframe src="" id="right" name="right"></iframe>
</body>
</html>