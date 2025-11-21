<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="max-width: 500px">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>POP3/IMAP</title>
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <style>
        .custom_radio, .custom_checkbox {
            display: inline-block;
        }

        .custom_radio {
            margin-right: 20px; /* 첫 번째 div의 오른쪽에 20px 간격 추가 */
        }
    </style>
    <script type="text/javascript">

        var usePOP3 = "${usePOP3}";
        var useIMAP = "${useIMAP}";

        window.onload = function () {
            if (usePOP3 == "YES") {
                $('#POP3used').attr('checked', true);
            } else {
                $('#POP3unused').attr('checked', true);
            }

            if (useIMAP == "YES") {
                $('#IMAPused').attr('checked', true);
            } else {
                $('#IMAPunused').attr('checked', true);
            }
        }

        function OK_Click() {

            var paramArray = [];
            paramArray.push({ name: 'usePOP3Default', value: $(':input:radio[name=CheckPOP3]:checked').val() });
            paramArray.push({ name: 'useIMAPDefault', value: $(':input:radio[name=CheckIMAP]:checked').val() });

            var pop3AllUser = document.getElementById('POP3AllUser').checked;
            var imapAllUser = document.getElementById('IMAPAllUser').checked;

            var jsonStr = {
                paramArray : paramArray,
                pop3AllUser : pop3AllUser,
                imapAllUser : imapAllUser
            }

            $.ajax({
                type : "POST",
                url : "/admin/ezEmail/saveConfigPOP3IMAP.do",
                data : JSON.stringify(jsonStr),
                contentType : "application/json; charset=UTF-8",
                success : function(data) {
                    if (data.status == 'OK'){
                        alert("<spring:message code='ezEmail.t292' />");
                        location.reload();
                    } else {
                        alert("<spring:message code='ezEmail.lhm14' />");
                    }
                },
                error : function(e) {
                    alert("<spring:message code='ezEmail.lhm14' />");
                }
            });
        }
    </script>
</head>
<body class="mainbody">
<h1><spring:message code='ezEmail.configPOP3IMAP' /></h1>
<div>
    <table  class="content">
        <tr>
            <th><spring:message code='ezOrgan.usePOP3' /></th>
            <td>
                <div class="custom_radio">
                    <input type="radio" name="CheckPOP3" id="POP3used" value="YES" /><label for="POP3used"><spring:message code="ezOrgan.t161" /></label>
                    <input type="radio" name="CheckPOP3" id="POP3unused" value="NO" /><label for="POP3unused"><spring:message code="ezOrgan.kyj02" /></label>
                </div>
                <div class="custom_checkbox">
                    <input type="checkbox" name="POP3AllUser" id="POP3AllUser" /><label for="POP3AllUser"><spring:message code="ezEmail.setAllUser" /></label>
                </div>
            </td>
        </tr>
        <tr>
            <th><spring:message code='ezOrgan.useIMAP' /></th>
            <td>
                <div class="custom_radio">
                    <input type="radio" name="CheckIMAP" id="IMAPused" value="YES" /><label for="IMAPused"><spring:message code="ezOrgan.t161" /></label>
                    <input type="radio" name="CheckIMAP" id="IMAPunused" value="NO" /><label for="IMAPunused"><spring:message code="ezOrgan.kyj02" /></label>
                </div>
                <div class="custom_checkbox">
                    <input type="checkbox" name="IMAPAllUser" id="IMAPAllUser" /><label for="IMAPAllUser"><spring:message code="ezEmail.setAllUser" /></label>
                </div
            </td>
        </tr>
    </table>
    <div class="btnposition">
        <a class="imgbtn"><span onClick="return OK_Click()"><spring:message code='ezOrgan.t124' /></span></a>
    </div>
</div>
</body>
</html>
