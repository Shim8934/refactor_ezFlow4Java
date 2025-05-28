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
	<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
    <script type="text/javascript">
        var pDocHref = "<c:out value ='${docHref}'/>";
        window.onload = function () {
        	try {
        			HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
                	showProgress("<spring:message code='ezApprovalG.t368'/>");
		            var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + encodeURIComponent(pDocHref);
		            var isTrue = HwpCtrl.LoadFile(URL, false);
		            
		            if (isTrue) {
		                hideProgress();
		            } else {
		                hideProgress();
		                var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
		                OpenAlertUI(pAlertContent);
		                HwpCtrl.ClearDocument();
		            }
        	} catch (e) {
	            hideProgress();
	            var pAlertContent = "<spring:message code='ezApprovalG.t370'/><br> <spring:message code='ezApprovalG.t371'/><br>" + e.description;
	            OpenAlertUI(pAlertContent);
        	}
    	}
        
	    function btnPrint_onclick() {
	        HwpCtrl.PrintDocument("", true);
	    }
	    
	    function btnClose_onclick() {
	        window.close();
	    }
	    
	    function btnSave_onclick() {
	        try {
	            HwpCtrl.SaveFile("");
	        } catch (e) {
	            alert("btnsave_onclick : " + e.description);
	        }
	    }
	    
	    var g_progresswin = null;
	    function showProgress(inforstring) {
	        g_progresswin = window.showModelessDialog("/ezApprovalG/showProgress.do?fileInfo=" + escape(inforstring), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
	    }
	    
	    function hideProgress() {
	        try {
	            if (g_progresswin)
	                g_progresswin.close();
	        } catch (e) { }
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
            <td height="908">
                <div style="height: 100%">
                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "", "");</script>
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
