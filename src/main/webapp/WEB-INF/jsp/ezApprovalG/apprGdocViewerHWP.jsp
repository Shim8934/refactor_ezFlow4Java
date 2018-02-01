<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title><%=RM.GetString("t367")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript"> var pNoneActiveX = "<%=NoneActiveX%>"; </script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
    <link rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>" type="text/css">
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/mouseeffect.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/Common/Kaoni_ActiveX.js") %>"></script>
    <script type="text/javascript">
        var pDocHref = "<%=_DocID%>";
        window.onload = function () {
            try {
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
        } catch (e) {
            hideProgress();
            var pAlertContent = "<%=RM.GetString("t370")%><br> <%=RM.GetString("t371")%><br>" + e.description;
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
        g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape(inforstring), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
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
                        <li><span onclick="return btnSave_onclick()"><%=RM.GetString("t59")%></span></li>
                        <li><span onclick="return btnPrint_onclick()"><%=RM.GetString("t60")%></span> </li>
                    </ul>
                </div>
                <div id="close">
                    <ul>
                        <li id="btnClose"><span onclick="return btnClose_onclick()"><%=RM.GetString("t64")%></span></li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td>
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
