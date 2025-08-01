<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/input-util.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/leftmenu-util.js')}"></script>
    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <script type="text/javascript">
        var popEnabled = "${empty popEnabled ? '0' : popEnabled}";
        var popSince = "${popSince}";
        var popAsRead = "${empty popEnabled ? '1' : popEnabled}";
        var popKeepCopy = "${empty popEnabled ? '1' : popEnabled}";
        var imapEnabled = "${empty imapEnabled ? '0' : imapEnabled}";
        var usePOP3Default = "${usePOP3Default}"
        var useIMAPDefault = "${useIMAPDefault}"
        var shareId = "${shareId}"

        function saveSetting() {
            var checkIMAP = $(':input:radio[name=checkIMAP]:checked').val();

            $.ajax({
                type : "POST",
                url : "/ezEmail/setConfigPOP3IMAP.do",
                data : {
                    popEnabled:popEnabled,
                    popSince:popSince,
                    popAsRead:popAsRead,
                    popKeepCopy:popKeepCopy,
                    imapEnabled:checkIMAP,
                    shareId:shareId
                },
                success: function(result) {
                    if (result.status == "ok") {
                        alert("<spring:message code='ezEmail.t292' />");
                        if (useIMAPDefault == 'NO' && checkIMAP == '0') { // 전체 설정이 사용 안함이고 개인 설정도 사용 안함으로 변경된 경우
                            parent.location.reload();
                        } else {
                            location.reload();
                        }
                    } else {
                        alert("<spring:message code='ezEmail.lhm14' />");
                        location.reload();
                    }
                },
                error : function(e) {
                    alert("<spring:message code='ezEmail.lhm14' />");
                }
            });
        }
    </script>

</head>
<body style="margin: 0 10px;">
<br>
<div class="txt" style="margin-bottom:25px">
    ▒ <spring:message code='ezEmail.config.IMAP.tip' />
</div>
<div style="width: 680px;">
    <table class="content" style="width: 680px;">
        <tr>
            <th><spring:message code='ezOrgan.useIMAP' /></th>
            <td>
                <input type="radio" id='IMAPused' name="checkIMAP" value="1"<c:if test="${imapEnabled == '1'}"> checked="checked"</c:if>><label for='IMAPused'><spring:message code='ezOrgan.t161' /></label>
                <input type="radio" id='IMAPunused' name="checkIMAP" value="0"<c:if test="${imapEnabled == '0' || empty imapEnabled}"> checked="checked"</c:if>><label for='IMAPunused'><spring:message code='ezOrgan.kyj02' /></label>
            </td>
        </tr>
    </table>
    <div class="btnposition">
        <a class="imgbtn"><span onClick="saveSetting()"><spring:message code='ezOrgan.t124' /></span></a>
    </div>
</div>
</body>
</html>