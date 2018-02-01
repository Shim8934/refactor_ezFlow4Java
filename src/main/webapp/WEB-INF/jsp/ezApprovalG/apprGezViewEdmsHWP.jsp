<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title><%=RM.GetString("t367")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/ezApprovalG/conn_HWP.js"></script>
	<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
    <script type="text/javascript">
   	 	var pNoneActiveX = "<%=NoneActiveX%>";
        var pDocHref = '<%=_DocHref%>';
        function window_onload() {

            HwpCtrl.SetSaveMode(1);

            if (pDocHref != "") {
                showProgress("<%=RM.GetString("t368")%>");

	    var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pDocHref);


	    var isTrue = HwpCtrl.LoadFile(URL, false);

	    if (isTrue) {
	        hideProgress();
	    }
	    else {
	        hideProgress();
	        var pAlertContent = "<%=RM.GetString("t369")%>";
			OpenAlertUI(pAlertContent);
			HwpCtrl.ClearDocument();
        }
    }


    HwpCtrl.SetFieldFocus("doctitle");
    HwpCtrl.ezSetScrollPosInfo(0);
}

function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}


function btnPrint_onclick() {
    HwpCtrl.PrintDocument("", true);
}

function btnClose_onclick() {
    window.close();
}


    </script>
</head>

<body class="popup" style="overflow: hidden" onload="javascript:window_onload()">
    <table class="layout">
        <tr>
            <td height="20">
                <div id="menu">
                    <ul>
                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><%=RM.GetString("t60")%></span></li>
                    </ul>
                </div>
                <div id="close">
                    <ul>
                        <li id="btnClose"><span onclick="return btnClose_onclick()"><%=RM.GetString("t64")%></span></li>
                    </ul>
                </div>
                <script type="text/javascript">
                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
                    selToggleList(document.getElementById("close"), "ul", "li", "0");
                </script>
            </td>
        </tr>
        <tr>
            <td style="padding-bottom: 10px">
                <div style="height: 100%">
                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<%=_HwpToolbar%>", "");</script>

                </div>
            </td>
        </tr>
    </table>
</body>
</html>
