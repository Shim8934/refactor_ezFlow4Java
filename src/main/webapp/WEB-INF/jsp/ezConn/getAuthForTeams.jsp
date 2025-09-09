<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="${util.addVer('/js/ezConn/MicrosoftTeams.min.js')}"></script>
    <script type="text/javascript">
        (function () {
            "use strict";
            var pTabMenu = '<c:out value="${tabmenu}"/>' || 'orgChart';
            var pIndex   = '<c:out value="${index}"/>';
            var pDevice  = '<c:out value="${device}"/>' || 'web';

            microsoftTeams.app.initialize().then(function () {

                microsoftTeams.authentication.getAuthToken({
                    successCallback: function (token) {
                        var f = document.createElement("form");
                        f.method = "POST";
                        f.action = "/ezConn/getCurrUser.do";

                        var add = function (n, v) { var i = document.createElement("input"); i.type="hidden"; i.name=n; i.value=v; f.appendChild(i); };
                        add("FLAG", "AUTHTOKEN");
                        add("TOKEN", token);
                        add("TABMENU", pTabMenu);
                        add("INDEX", pIndex);
                        add("DEVICE", pDevice);

                        document.body.appendChild(f);
                        f.submit();
                    },
                    failureCallback: function (err) {
                        console.log("getAuthToken failed:", err);
                    }
                });
            });
        })();
    </script>
</head>
<body></body>
</html>