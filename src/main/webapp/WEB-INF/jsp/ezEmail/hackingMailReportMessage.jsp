<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %><html>
<head>
    <title><spring:message code="ezEmail.ksy01"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <link rel="stylesheet" type="text/css" href="${util.addVer('/css/previewmail.css')}">
    <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" type="text/css">
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/input-util.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
    <script type="text/javascript">

        var message;
        var ReturnFunction;
        var CancelFunction;

        window.onload = function() {

            try {
                message = parent.hacking_mail_report_message_cross_dialogArguments[0];
                ReturnFunction = parent.hacking_mail_report_message_cross_dialogArguments[1];
                CancelFunction = parent.hacking_mail_report_message_cross_dialogArguments[2];
            }catch (e) {

            }
        }

        function btn_ok_onclick(){
            message['message'] = escape_text(document.getElementById('reportTxt').value);
            ReturnFunction(message);
            CancelFunction();
            window.close();
        }

        //전송되는 메일에 문자열이 들어갈 때 html 형태로 들어가므로 문자열에 포함된 <, >, ', " 등 특수문자를 escape 처리함
        function escape_text(text){
            var message = text.replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;")
                .replace(/\n/g, "<br>")                         // 줄넘김 처리
                .replace(/\t/g, "&nbsp;&nbsp;&nbsp;&nbsp;")     // 탭 문자 처리
                .replace(/  /g, "&nbsp;&nbsp;");                // 연속된 공백 처리
            return message;
        }


        function windows_close() {
            $(parent.parent.frames['left'].document.getElementById('blockLeft')).remove();
            CancelFunction();
            window.close();
        }

    </script>
</head>
<body class="popup">
<h1><spring:message code="ezEmail.ksy01"/></h1>
<div id="close">
    <ul>
        <li><span onclick="windows_close()"></span></li>
    </ul>
</div>
<div id="content">
    <label for="reportTxt"></label>
    <textarea style="height:72%; resize:none" id="reportTxt"></textarea>
</div>
<div class="btnposition btnpositionNew">
    <a class="imgbtn" onclick="return btn_ok_onclick()"><span><spring:message code="ezBoard.t10100" /></span></a>
</div>
</body>
</html>