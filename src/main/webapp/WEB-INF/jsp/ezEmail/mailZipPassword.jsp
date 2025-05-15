<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <script type="text/javascript">
        window.onload = function() {
            const inputField = document.getElementById('newZipFilePassword');
            if (inputField) {
                inputField.focus();  // 포커스를 주기
            }
        };
        
        function OK_Click() {
            var password = document.getElementById("newZipFilePassword").value.trim();
            var confirmPw = document.getElementById("confirmZipFilePassword").value.trim();

            if (isFileAttached()) {
                alert("<spring:message code='ezEmail.zipEncryptedFile.007' />");
                return;
            }
            
            if (password == "") {
                alert("<spring:message code='ezOrgan.t229' />");
                document.getElementById('newZipFilePassword').focus();
                return;
            }

            if (password != confirmPw) {
                alert("<spring:message code='ezOrgan.t230' />");
                document.getElementById('ConfirmZipFilePassword').focus();
                return;
            }

            sessionStorage.setItem("zipPassword", password);

            if (typeof ReturnFunction === "function") {
                ReturnFunction(password);
            } else {
                window.returnValue = password;
            }

            parent.DivPopUpHidden();
        }

        function isFileAttached() {
            return window.opener && window.opener.fileListExists;
        }
    </script>
</head>
<body class="popup">
<h1><spring:message code="ezEmail.zipEncryptedFile.003" /></h1>
<div id="close">	
    <ul>
        <li><span onclick="parent.DivPopUpHidden()  "></span></li>
    </ul>
</div>
<div id="pwPolicyExplain" style="margin-top: 5px; color: #393939;"><span>${pwPolicyExplain }</span></div> <!-- el로 값 통째로 넣어줌 -->
<table class="content" style="margin-top: 3px">
    <tr>
        <th><spring:message code="ezEmail.zipEncryptedFile.004" /></th>
        <td><input id=newZipFilePassword type=password style="width:98%" maxlength="50"></td>
    </tr>
    <tr>
        <th><spring:message code="ezEmail.zipEncryptedFile.005" /></th>
        <td><input id=confirmZipFilePassword type=password style="width:98%" maxlength="50"></td>
    </tr>
</table>
<div class="btnpositionNew">
    <a class="imgbtn" onClick="OK_Click()"><span><spring:message code="ezOrgan.t124" /></span></a>
</div>
</body>
</html>
