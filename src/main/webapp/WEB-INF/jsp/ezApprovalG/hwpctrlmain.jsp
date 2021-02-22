<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<base href="${webHWPUrl}">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script type="text/javascript" data-type="css/app" data-framework="aori|lab" src="js/loadVersion.js"></script>
    <script type="text/javascript" data-type="css/app" data-framework="aori|lab" src="js/loadHead.js"></script>
    <script type="text/javascript">
		window.serverProps = {skin:"default"};
        window.BaseUrl = getUrlParameter("baseurl");
    </script>
    <script type="text/javascript">
        var require = { urlArgs : "version="+window.__hctfwoVersion };
    </script>
    <script type="text/javascript" src="js/libs/require/require.js"></script>
    <script type="text/javascript" src="js/require_config.js"></script>
    <script type="text/javascript">
        require(["main-hwpapp"]);
    </script>
</head>
<body>
</body>
</html>
