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

        window.onload = function() {
            if (popEnabled == '0') {
                Array.from(document.getElementsByClassName('popUsed_only')).forEach(e =>{
                    e.style.display = 'none';
                });
            }
        }

        function pop3Used() {
            var checkPOP3 = $(':input:radio[name=checkPOP3]:checked').val();
            if (checkPOP3 == '1') {
                Array.from(document.getElementsByClassName('popUsed_only')).forEach(e =>{
                    e.style.display = '';
                });
            } else if (checkPOP3 == '0') {
                Array.from(document.getElementsByClassName('popUsed_only')).forEach(e =>{
                    e.style.display = 'none';
                });
            }
        }

        function saveSetting() {
            var checkPOP3 = $(':input:radio[name=checkPOP3]:checked').val();
            if (checkPOP3 == '1') { // 사용함인 경우 사용자가 변경한 설정으로 저장
                popSince = $(':input:radio[name=POP3since]:checked').val();
                popAsRead = $(':input:radio[name=popAsRead]:checked').val();
                popKeepCopy = $(':input:radio[name=popKeepCopy]:checked').val();
            }  // 사용안함인 경우 기존 설정값 유지

            $.ajax({
                type : "POST",
                url : "/ezEmail/setConfigPOP3IMAP.do",
                data : {
                    popEnabled:checkPOP3,
                    popSince:popSince,
                    popAsRead:popAsRead,
                    popKeepCopy:popKeepCopy,
                    imapEnabled:imapEnabled,
                    shareId:shareId
                },
                success: function(result) {
                    if (result.status == "ok") {
                        alert("<spring:message code='ezEmail.t292' />");
                        if (usePOP3Default == 'NO' && checkPOP3 == '0') { // 전체 설정이 사용 안함이고 개인 설정도 사용 안함으로 변경된 경우
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
    ▒ <spring:message code='ezEmail.config.POP3.tip' />
</div>
<div style="width: 750px;">
    <table class="content" style="width: 750px;">
        <tr>
            <th><spring:message code='ezOrgan.usePOP3' /></th>
            <td>
                <div class="custom_radio">
                    <input type="radio" id='POP3used' name="checkPOP3" value="1"<c:if test="${popEnabled == '1'}"> checked="checked"</c:if> onchange="pop3Used();"><label for='POP3used'><spring:message code='ezOrgan.t161' /></label>
                    <input type="radio" id='POP3unused' name="checkPOP3" value="0"<c:if test="${popEnabled == '0' || empty popEnabled}"> checked="checked"</c:if> onchange="pop3Used();"><label for='POP3unused'><spring:message code='ezOrgan.kyj02' /></label>
                </div>
            </td>
        </tr>
        <tr class="popUsed_only">
            <th><spring:message code='ezEmail.POP3.config.POPsince' /></th>
            <td>
                <div class="custom_radio">
                    <input type="radio" id="POP3sincenow" name="POP3since" value="1" <c:if test="${empty popSince}"> checked="checked"</c:if>><label for="POP3sincenow"><spring:message code='ezEmail.POP3.config.sinceNow' /></label>
                    <input type="radio" id="POP3sinceexist" name="POP3since" value="0" <c:if test="${popSince == '0'}"> checked="checked"</c:if>><label for="POP3sinceexist"><spring:message code='ezEmail.POP3.config.sinceExist' /></label>
                    <c:if test="${not empty popSince && popSince != '0'}">
                        <br>
                        <input type="radio" id="POP3since" name="POP3since" checked="checked" value="${popSince}"><label for="POP3since"><spring:message code='ezEmail.POP3.config.since' /> (${popSinceDateFormat})</label>
                    </c:if>
                </div>
            </td>
        </tr>
        <tr class="popUsed_only">
            <th><spring:message code='ezEmail.POP3.config.POPasRead' /></th>
            <td>
                <div class="custom_radio">
                    <input type="radio" id="popAsRead" name="popAsRead" value="1" <c:if test="${popAsRead == '1' || empty popAsRead}"> checked="checked"</c:if>><label for="popAsRead"><spring:message code='ezEmail.POP3.config.asRead' /></label>
                    <input type="radio" id="popAsNoRead" name="popAsRead" value="0" <c:if test="${popAsRead == '0'}"> checked="checked"</c:if>><label for=popAsNoRead><spring:message code='ezEmail.POP3.config.asNoRead' /></label>
                </div>
            </td>
        </tr>
        <tr class="popUsed_only">
            <th><spring:message code='ezEmail.POP3.config.POPkeepCopy' /></th>
            <td>
                <div class="custom_radio">
                    <input type="radio" id="popKeepCopy" name="popKeepCopy" value="1" <c:if test="${popKeepCopy == '1' || empty popKeepCopy}"> checked="checked"</c:if>><label for="popKeepCopy"><spring:message code='ezEmail.POP3.config.keepCopy' /></label>
                    <input type="radio" id="popKeepNoCopy" name="popKeepCopy" value="0" <c:if test="${popKeepCopy == '0'}"> checked="checked"</c:if>><label for="popKeepNoCopy"><spring:message code='ezEmail.POP3.config.keepNoCopy' /></label>
                </div>
            </td>
        </tr>
    </table>
    <div class="btnposition">
        <a class="imgbtn"><span onClick="saveSetting()"><spring:message code='ezOrgan.t124' /></span></a>
    </div>
</div>
</body>
</html>