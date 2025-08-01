<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code='ezEmail.t535' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script>
        let okHandler;
        let cancelHandler;

        function onLoad() {
            const parentWindow = opener || parent;
            okHandler = parentWindow.mailKeepMoveDialogArguments.okHandler;
            cancelHandler = parentWindow.mailKeepMoveDialogArguments.cancelHandler;
        }

        function ok() {
            okHandler(document.getElementById('cleanup').checked);
            if (opener) {
                window.close();
            }
        }

        function cancel() {
            if (cancelHandler) {
                cancelHandler();
            } else {
                window.close();
            }
        }
    </script>
</head>
<body class="popup" onload="onLoad()">
    <h1><spring:message code='ezEmail.keepmove.title' /></h1>
    <div id="close">
        <ul>
            <li><span onclick="cancel();"></span></li>
        </ul>
    </div>
    <table class="content" style="width: 100%;">
        <tr>
            <td class="pos1" style="padding: 15px; text-align: center;">
                <spring:message code="ezEmail.keepmove.description" arguments="${folderName}" />
                <div style="margin-top: 10px;">
                    <input id="cleanup" type="checkbox" />
                    <label for="cleanup"><spring:message code="ezEmail.keepmove.checkmessage" /></label>
                </div>
            </td>
        </tr>
    </table>
    <div class="btnpositionNew">
        <a class="imgbtn"><span onclick="return ok()"><spring:message code='ezEmail.t38' /></span></a>
        <a class="imgbtn"><span onclick="return cancel()"><spring:message code='ezEmail.t39' /></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div style="border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
        <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
    </div>
</body>
</html>
