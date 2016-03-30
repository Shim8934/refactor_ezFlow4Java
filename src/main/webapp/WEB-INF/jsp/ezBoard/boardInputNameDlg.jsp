<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
	    <script type="text/javascript">
	        var ReturnFunction;
	        var RetValue;
	        function window_onload() {
	            try {
	                RetValue = parent.inputnamedlg_dialogArguments[0];
	                ReturnFunction = parent.inputnamedlg_dialogArguments[1];
	
	                if (parent.inputNameDlg_returnval == undefined) {
	                    txt_FolderName.value = RetValue;
	                }
	                else {
	                    txt_FolderName.value = parent.inputNameDlg_returnval;
	                }
	            } catch (e) {
	                if (window.dialogArguments.inputNameDlg_returnval == undefined) {
	                    txt_FolderName.value = window.dialogArguments;
	                }
	                else {
	                    txt_FolderName.value = window.dialogArguments.inputNameDlg_returnval;
	                }
	            }
	
	            try {
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
	                alert("<spring:message code='ezBoard.t10049'/>");
	                return;
	            }
	            var szCheckPermit = szInput;
	            szCheckPermit = ReplaceText(szInput, "=", "");
	
	            if (szInput != szCheckPermit) {
	                alert("<spring:message code='ezBoard.t10050'/>");
	                return;
	            }
	
	            if (ReturnFunction !=null)
	                ReturnFunction(txt_FolderName.value);
	            else {
	                window.returnValue = txt_FolderName.value;
	                window.close();
	            }
	        }
	
	        function btn_cancel_onclick() {
			if(ReturnFunction!=null)
	            parent.DivPopUpHidden();
			else
				window.close();
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
	    <h1><spring:message code='ezBoard.t275'/>/<spring:message code='ezBoard.t316'/></h1>
	    <div class="txt"><spring:message code='ezBoard.t144'/></div>
	    <div class="nobox">
	        <input id="txt_FolderName" type="text" onkeydown="folderName_onkeydown()" style="width: 100%" maxlength="8">
	    </div>
	    <div class="btnposition">
	        <a id="btn_ok" class="imgbtn" onclick="btn_ok_onclick()"><span><spring:message code='ezBoard.t14'/></span></a>
	        <a id="btn_cancel" class="imgbtn" onclick="btn_cancel_onclick()"><span><spring:message code='ezBoard.t15'/></span></a>
	    </div>
	
	</body>
</html>