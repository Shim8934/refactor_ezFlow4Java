<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<iframe id="left" src="/admin/ezcabinet/cabinetAdminLeft.do" name="left"></iframe>
<iframe src="about:blank" id="right" name="right"></iframe>
</body>
</html>
