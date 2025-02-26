<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<head>
	<base href="${webHWPUrl}">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script type="text/javascript" data-type="css/app" data-framework="aori|lab" src="js/loadVersion.js"></script>
    <script type="text/javascript" data-type="css/app" data-framework="aori|lab" src="js/loadHead.js"></script>
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
</head>
<body>
</body>
</html>
