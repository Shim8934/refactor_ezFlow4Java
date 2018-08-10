<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t348' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/mouseeffect.js")%>"></script>
	    <script src="<%=CommonUtil.addVer(application, "/js/ezEmail/js_cross/string_component.js")%>"></script>
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
	    </script>
	</head>
	<body class="popup" onload="javascript:window_onload()">
	    <h1><spring:message code='ezEmail.t348' /></h1>
	    <div id="close">
            <ul>
                <li><span id="btn_cancel" onclick="btn_cancel_onclick()"></span></li>
            </ul>
        </div>
	    <div class="txt"><spring:message code='ezEmail.t352' /></div>
	    <div class="nobox">
	        <input id="txt_FolderName" type="text" onkeydown="folderName_onkeydown()" style="width: 100%;margin-top:2px" maxlength="20">
	    </div>
	    <div class="btnposition btnpositionNew">
	        <a id="btn_ok" class="imgbtn" onclick="btn_ok_onclick()"><span><spring:message code='ezEmail.t38' /></span></a>
	    </div>	
	</body>
</html>