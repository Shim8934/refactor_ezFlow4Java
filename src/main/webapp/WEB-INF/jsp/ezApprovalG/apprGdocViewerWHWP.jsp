<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='ezApprovalG.t367'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript">
        var pDocHref = "<c:out value ='${docHref}'/>";
        
        window.onload = function () {
        	window_onload();
        }
        
        function window_onload() {
            window.onresize();
        }
        
        window.onresize = function () {
            document.getElementById("message").style.height = document.documentElement.clientHeight - 70 - document.getElementById("message").offsetTop + "px";
            message.Resize(document.getElementById("message").style.height);
        }
        
        function Editor_Complete() {
            message.ShowRibbon(false);
            if (pDocHref != "") {
                var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
                message.Open(URL, "", "", function (res) {
                    if (res.result) {                  

                    } 
                    message.EditMode(0);
                    message.ScrollPosInfo(0, 1);
                }, null);   
            }
        }
        
        function btnPrint_onclick() {
            message.PrintDocument();
        }
	    
        function btnClose_onclick() {
            window.close();
        }

	    function btnSave_onclick() {
            var hwpDoctitle = message.GetFieldText("doctitle").replace("\r\n", "");
            hwpDoctitle = hwpDoctitle.replace(/\\/ig, '').replace(/\//ig, '').replace(/:/ig, '').replace(/\*/ig, '').replace(/\?/ig, '').replace(/“/ig, '').replace(/</ig, '').replace(/>/ig, '').replace(/|/ig, '').replace("“", "").replace("|", "");

            if (hwpDoctitle == "") {
            	var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
                OpenAlertUI(pAlertContent);
            	return;
            }

            hwpDoctitle += ".hwp";
            message.SaveFile(hwpDoctitle, "HWP", "");
        }
    </script>
</head>
<body class="popup">
    <table class="layout">
        <tr>
            <td height="20">
                <div id="menu">
                    <ul id="icons">
                        <li><span onclick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
                        <li><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span> </li>
                    </ul>
                </div>
                <div id="close">
                    <ul>
                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td height="808">
                <div style="height: 100%">
                    <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
                </div>
            </td>
        </tr>
    </table>
    <script type="text/javascript">
        selToggleList(document.getElementById("menu"), "ul", "li", "0");
        selToggleList(document.getElementById("close"), "ul", "li", "0");
    </script>
</body>
</html>
