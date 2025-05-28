<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>
	<base href="${webHWPUrl}">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script type="text/javascript" data-type="css/app" data-framework="aori|lab" src="js/loadVersion.js"></script>
    <script type="text/javascript" data-type="css/app" data-framework="aori|lab" src="js/loadHead.js"></script>
    <c:if test="${webHWPVersion eq 2}">
        <script data-main="js/main" data-bundle="dist/main_bundle" src="js/loadMain.js"></script>
        <script type='text/javascript'>
            var eqsdk;
            var Module = {
                preRun: [],
                postRun: (function() {
                    eqsdk = new Module.eqsdk(window.location.href);
                    window.wasmInitialized = true;
                }),
            };
        </script>
        <script async type="text/javascript" src="wasm/eqeditwa.js"></script>
    </c:if>
    <c:if test="${webHWPVersion eq 1}">
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
    </c:if>
</head>
<body>
</body>
</html>
