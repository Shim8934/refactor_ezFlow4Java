<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<iframe id="left" src="/admin/ezSystem/systemLeftMenu.do" name="stat_left"></iframe>
<iframe src="/admin/ezApprovalG/formAdmin.do" id="right" name="stat_main"></iframe>
</body>
</html>