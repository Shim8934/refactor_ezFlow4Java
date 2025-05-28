<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>${Title}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
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
            document.getElementById('TxtBoardletName').focus();

            try {
                ReturnType = parent.getscrapcontname_dialogArgument[0][0];
                ReturnFunction = parent.getscrapcontname_dialogArgument[1];
            } catch (e) {
                try {
                    ReturnType = opener.getscrapcontname_dialogArgument[0][0];
                    ReturnFunction = opener.getscrapcontname_dialogArgument[1];
                } catch (e) {
                }
            }
            if (!CrossYN())
                window.returnValue = "cancel";
        }
        function btn_SaveBoardletName_onclick() {
            var p_boardletName = trim(document.getElementById('TxtBoardletName').value);
            if (p_boardletName == "") {
                var pAlertContent = "<spring:message code='ezBoard.kmh29'/>";
                OpenAlertUI(pAlertContent);
                TxtBoardletName.focus();
            } else {
                if (CrossYN()) {
                    ReturnFunction(p_boardletName, ReturnType);
                }
                else {
                    window.returnValue = p_boardletName;
                    window.close();
                }
            }
        }
     
        function btn_CancelBoardletName_onclick() {
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
        
        var ezboardalert_cross_dialogArguments = new Array();
        function OpenAlertUI(pAlertContent, CompleteFunction) {
            var parameter = pAlertContent;
            var url = "";
            if(CompleteFunction == "OPEN") 
                url = "/ezBoard/boardAlert.do?type=OPEN";
            else
                url = "/ezBoard/boardAlert.do";

            if (CrossYN()) {
                ezboardalert_cross_dialogArguments[0] = parameter;
                ezboardalert_cross_dialogArguments[1] = CompleteFunction;

                if (CompleteFunction != undefined) {
                    if (CompleteFunction == "OPEN")
                    {
                        var OpenWin = GetOpenWindow(url, "", 330, 205, "NO");
                    }
                    else
                        DivPopUpShow(330, 205, url);
                }
                else {            
                    ezboardalert_cross_dialogArguments[1] = OpenAlertUI_Complete;
                    DivPopUpShow(330, 205, url);
                }
            }
            else {
                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
                feature = feature + GetShowModalPosition(330, 205);
                var RtnVal = window.showModalDialog(url, parameter, feature);
            }
        }
        
        function OpenAlertUI_Complete(RtnVal) {
            DivPopUpHidden();
        }

    </script>
</head>
<body class="popup">
    <h1>${title}</h1>
    <div id="close">
        <ul>
            <li><span name="btn_CancelBoardletName" id="btn_CancelBoardletName" onclick="return btn_CancelBoardletName_onclick()"></span></li>
        </ul>
    </div>
    <div class="txt" style="margin-top:5px">▒&nbsp;<spring:message code='ezBoard.kmh40'/></div>
    <div class="nobox" style="margin-top:5px">
        <input type="text" id="TxtBoardletName" name="TxtBoardletName" style="width: 100%;height:25px;border:1px solid #ccc;margin-top:5px" maxlength="50" value="<c:out value ='${titleText}'/>">
    </div>
    <div class="btnposition btnpositionNew">
    	<a class="imgbtn"><span name="btn_SaveBoardletName" id="btn_SaveBoardletName" onclick="return btn_SaveBoardletName_onclick()"><spring:message code='ezBoard.kmh41'/></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none; overflow:hidden;" id="iFramePanel">
    <iframe src="<spring:message code='main.kms4' />" style="border:none; overflow:hidden;" id="iFrameLayer"></iframe>
    </div>
</body>
</html>


