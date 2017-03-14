<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>${Title}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
    <script id="clientEventHandlersJS" type="text/javascript">
        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
            window.onblur = function () {
                window.focus();
            }
        }
        var ReturnType;
        var ReturnFunction;
        window.onload = function () {
            try {
                var ua = navigator.userAgent;
                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
                    var input = document.getElementsByTagName("input");
                    for (var i = 0; i < input.length; i++) {
                        if (GetAttribute(input[i], "type") == "text")
                            KeEventControl(input[i]);
                    }
                }
            }
            catch (e)
            { }
            document.getElementById('TxtAprDeptTempletName').value = "${TitleText}";
            document.getElementById('TxtAprDeptTempletName').focus();

            try {
                ReturnType = parent.getcontname_dialogArgument[0][0];
                ReturnFunction = parent.getcontname_dialogArgument[1];
            } catch (e) {
                try {
                    ReturnType = opener.getcontname_dialogArgument[0][0];
                    ReturnFunction = opener.getcontname_dialogArgument[1];
                } catch (e) {
                }
            }
            if (!CrossYN())
                window.returnValue = "cancel";
        }
        function btn_SaveAprDeptTempletName_onclick() {
            var p_AprDeptTempletName = trim(document.getElementById('TxtAprDeptTempletName').value);
            if (p_AprDeptTempletName == "") {
                var pAlertContent = "<spring:message code='ezApproval.t295'/>";
                OpenAlertUI(pAlertContent);
                TxtAprDeptTempletName.focus();
            } else {
                if (CrossYN()) {
                    ReturnFunction(p_AprDeptTempletName, ReturnType);
                }
                else {
                    window.returnValue = p_AprDeptTempletName;
                    window.close();
                }
            }
        }
     
        function btn_CancelAprDeptTempletName_onclick() {
            if (CrossYN()) {
                ReturnFunction("cancel", ReturnType);
            }
            else {
                window.returnValue = "cancel";
                window.close();
            }
        }
        function trim(parm_str) {
            if (parm_str == "")
                return ""
            else
                return rtrim(ltrim(parm_str));
        }
        function ltrim(parm_str) {
            var str_temp = parm_str;
            while (str_temp.length != 0) {
                if (str_temp.substring(0, 1) == " ") {
                    str_temp = str_temp.substring(1, str_temp.length);
                } else {
                    return str_temp;
                }
            }
            return str_temp;
        }
        function rtrim(parm_str) {
            var str_temp = parm_str;
            while (str_temp.length != 0) {
                int_last_blnk_pos = str_temp.lastIndexOf(" ");
                if ((str_temp.length - 1) == int_last_blnk_pos) {
                    str_temp = str_temp.substring(0, str_temp.length - 1);
                } else {
                    return str_temp;
                }
            }
            return str_temp;
        }
    </script>
</head>
<body class="popup">
    <h1>${Title}</h1>

    <div class="txt"><spring:message code='ezApproval.t296'/></div>

    <div class="nobox">
        <input type="text" id="TxtAprDeptTempletName" name="TxtAprDeptTempletName" style="width: 100%" maxlength="50">
    </div>

    <div class="btnposition">
        <input type="submit" name="btn_SaveAprLineTempletName" id="btn_SaveAprLineTempletName" value="<spring:message code='ezApproval.t84'/>" onclick="return btn_SaveAprDeptTempletName_onclick()">
        <input type="submit" name="btn_CancelAprLineTempletName" id="btn_CancelAprLineTempletName" value="<spring:message code='ezApproval.t85'/>" onclick="return btn_CancelAprDeptTempletName_onclick()">
    </div>

</body>
</html>


