<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title><spring:message code='ezEmail.t348' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script src="/js/ezEmail/js_cross/string_component.js"></script>
	    <script type="text/ecmascript">
	        var ReturnFunction;
	        var CancelFunction;
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        function window_onload() {
	            var InputValue;
	            try {
	                InputValue = parent.inputNameDlg_cross_dialogArguments[0];
	                ReturnFunction = parent.inputNameDlg_cross_dialogArguments[1];
	                CancelFunction = parent.inputNameDlg_cross_dialogArguments[2];
	            } catch (e) { }
	            if (InputValue != "") {
	                txt_FolderName.value = InputValue;
	            }
	            try {
	                txt_FolderName.focus();
	                var ua = navigator.userAgent;
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    KeEventControl(document.getElementById("txt_FolderName"));
	                }
	            }
	            catch (e)
	            { }
	        }
	        function btn_ok_onclick() {
	            var szInput;
	            szInput = txt_FolderName.value;
	            szInput = ReplaceText(szInput, " ", "");
	
	            if (szInput == "") {
	                alert("<spring:message code='ezEmail.t349' />");
	                return;
	            }
	            var szCheckPermit = szInput;
	            szCheckPermit = ReplaceText(szInput, "=", "");
	
	            if (szInput != szCheckPermit) {
	                alert("<spring:message code='ezEmail.t351' />");
	                return;
	            }
	            ReturnFunction(txt_FolderName.value);
	        }
	        function btn_cancel_onclick() {
	            CancelFunction();
	        }
	        function folderName_onkeydown() {
	            if (event.keyCode == 13)
	                btn_ok_onclick();
	        }
	        function KeEventControl(obj) {
	            useragt = navigator.userAgent.toUpperCase();
	            if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
	            {
	                useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
	                if (parseInt(useragt) > 5) {
	                    return;
	                }
	            }
	            obj.onkeydown = function () {
	                if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
	                    return false;
	                if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
	                        parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
	                        parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
	                        parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
	                        parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
	                    return false;
	            };
	        }
	    </script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
	    <h1><spring:message code='ezEmail.t348' /></h1>
	    <div class="txt"><spring:message code='ezEmail.t352' /></div>
	    <div class="nobox">
	        <input id="txt_FolderName" type="text" onkeydown="folderName_onkeydown()" style="width: 100%" maxlength="8">
	    </div>
	    <div class="btnposition">
	        <a id="btn_ok" class="imgbtn" onclick="btn_ok_onclick()"><span><spring:message code='ezEmail.t38' /></span></a>
	        <a id="btn_cancel" class="imgbtn" onclick="btn_cancel_onclick()"><span><spring:message code='ezEmail.t39' /></span></a>
	    </div>
	
	</body>
</html>



