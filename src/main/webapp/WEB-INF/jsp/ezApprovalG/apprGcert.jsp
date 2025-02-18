<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <title><spring:message code='ezApprovalG.t161'/></title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
    <script type="text/javascript">
    var RetValue;
    var ReturnFunction;
    window.onload = function () {
        try {
            RetValue = parent.cert_dialogArguments[0];
            ReturnFunction = parent.cert_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.cert_dialogArguments[0];
                ReturnFunction = opener.cert_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        var isSend = RetValue;
        if (!isSend) button4.style.display = "none";
        rtnVal[0] = false;
        rtnVal[1] = "";
        rtnVal[2] = "";
        if (!CrossYN())
            window.returnValue = rtnVal;
    }
        var rtnVal = new Array();
        var Count = 0;
        function button1_onclick() {
            var result
            result = cert.chkPasswd();
            if (result == "FALSE") {
                alert("<spring:message code='ezApprovalG.t162'/>")
            Count = Count + 1;
        }
        else if (result == "FAIL") {
            alert("<spring:message code='ezApprovalG.t163'/>")
                Count = Count + 1;
            }
            else {
                rtnVal[0] = true;
                rtnVal[1] = cert.getPasswd();
                rtnVal[2] = cert.getcertPath();

                if (ReturnFunction != null) {
                    ReturnFunction(rtnVal);
                }
                else {
                    window.returnValue = rtnVal
                    window.close();
                }
            }
        if (Count >= 3) {
            rtnVal[0] = false;
            rtnVal[1] = "";
            rtnVal[2] = "";
            if (ReturnFunction != null) {
                ReturnFunction(rtnVal);
            }
            else {
                window.returnValue = rtnVal
                window.close();
            }
        }
    }
    function button2_onclick() {
        cert.reflash();
    }
    function button3_onclick() {
        rtnVal[0] = false;
        rtnVal[1] = "";
        rtnVal[2] = "";
        if (ReturnFunction != null) {
            ReturnFunction(rtnVal);
        }
        else {
            window.returnValue = rtnVal
            window.close();
        }
    }
    function button4_onclick() {
        rtnVal[0] = true;
        rtnVal[1] = cert.getPasswd();
        rtnVal[2] = "NONE_Enc_SEND";
        if (ReturnFunction != null) {
            ReturnFunction(rtnVal);
        }
        else {
            window.returnValue = rtnVal
            window.close();
        }
    }
    </script>
</head>
<body bgcolor="#ece9d8">
    <table>
        <tr>
            <td valign="top">
                <script>ezCert_ActiveX("cert");</script>
            </td>
        </tr>
        <tr>
            <td align="right">
                <input type="button" value="<spring:message code='ezApprovalG.t20'/>" id="button1" name="button1" style="FONT-FAMILY: <spring:message code='ezApprovalG.t164'/>"  onclick="return button1_onclick()">
                <input type="button" value="<spring:message code='ezApprovalG.t165'/>" id="button2" name="button2" style="FONT-FAMILY: <spring:message code='ezApprovalG.t166'/>"  onclick="return button2_onclick()">
                <input type="button" value="<spring:message code='ezApprovalG.t119'/>" id="button3" name="button3" style="FONT-FAMILY: <spring:message code='ezApprovalG.t164'/>"  onclick="return button3_onclick()">
                <input type="button" value="<spring:message code='ezApprovalG.t167'/>" id="button4" name="button4" style="FONT-FAMILY: <spring:message code='ezApprovalG.t168'/>"  onclick="return button4_onclick()">
            </td>
        </tr>
    </table>

</body>
</html>


