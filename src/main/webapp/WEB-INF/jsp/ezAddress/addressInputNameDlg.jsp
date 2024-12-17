<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezAddress.t21' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/string_component.js')}"></script>
	    <script type="text/javascript">
	        var ReturnFunction;
	        var CancelFunction;
	        window.onload = function () {
	            try{
	                txt_FolderName.value = parent.inputnamedlg_cross_dialogArguments[0];
	                ReturnFunction = parent.inputnamedlg_cross_dialogArguments[1];
	                CancelFunction = parent.inputnamedlg_cross_dialogArguments[2];
	            }catch(e){
	                txt_FolderName.value = window.dialogArguments[1];
	            }
	            //try {
	            //    var ua = navigator.userAgent;
	            //    if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	            //        KeEventControl(document.getElementById("txt_FolderName"));
	            //    }
	            //}catch (e){ }
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
	
	        function btn_ok_onclick() {
	            var szInput;
	            szInput = txt_FolderName.value;
	            //szInput = ReplaceText(szInput, " ", "");
	
	            if (szInput.trim() == "") {
	                alert("<spring:message code='ezAddress.t22' />");
	                return;
	            }

                // 태그 제거
	            szInput = szInput.replace(/<[^>]*>?/g, '');

	            if (ReturnFunction!=null) {
	                try {
	                    window.opener.szName = szInput;
	                    window.opener.inputNameOKFlag = true;
	                } catch (e) {
	                    parent.szName = szInput;
	                    parent.inputNameOKFlag = true;
	                }
	            }
	            else {
	                dialogArguments[0].document.Script.szName = szInput;
	                dialogArguments[0].document.Script.inputNameOKFlag = true;
	            }
	            if (ReturnFunction != null)
	                ReturnFunction();
	            else
	                window.close();
	        }
	        function btn_cancel_onclick() {
	            if (ReturnFunction != null)
	                CancelFunction();
	            else
	                window.close();
	        }
	
	        function folderName_onkeydown() {
	            if (event.keyCode == 13)
	                btn_ok_onclick();
	        }
	
	    </script>
	</head>
	<body class="popup" style="overflow:hidden;">
	    <h1><spring:message code='ezAddress.t23' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="return btn_cancel_onclick()"></span></li>
            </ul>
        </div>
	    <h2 style="height:100%;margin-bottom:10px;font-weight: normal"><spring:message code='ezAddress.t24' /></h2>
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezAddress.t373' /></th>
	            <td style="padding: 0">
	                <table width="100%">
	                    <tr class="primary">
	                        <td style="border:0px">
	                            <input id="txt_FolderName" type="text" onkeydown="folderName_onkeydown()" style="width: 100%;box-sizing: border-box;" maxlength="20">
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn" onclick="return btn_ok_onclick()"><span><spring:message code='ezAddress.t25' /></span></a>
	    </div>
	</body>
</html>


