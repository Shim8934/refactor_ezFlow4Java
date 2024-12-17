<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t889'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>

<script ID="clientEventHandlersJS" type="text/javascript">
    var g_Flag, g_ID1, g_ID2;
    var FormProcDCflag = false;
    var RetValue;
    var ReturnFunction;
    window.onload = function () {
        try {
            RetValue = parent.printmetainfo_ck_dialogArguments[0];
            ReturnFunction = parent.printmetainfo_ck_dialogArguments[1];
           
        } catch (e) {
            try {
                RetValue = opener.printmetainfo_ck_dialogArguments[0];
                ReturnFunction = opener.printmetainfo_ck_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        g_Flag = RetValue[0];
        g_ID1 = RetValue[1];
        g_ID2 = RetValue[2];
        
        DocumentComplete();
    }
    function btnPrint_onclick() {
        document.getElementById("menu").style.display = "none";
        document.getElementById("close").style.display = "none";
        window.print();
        document.getElementById("menu").style.display = "";
        document.getElementById("close").style.display = "";
    }
    function btnSave_onclick() {
    }
    function DocumentComplete() {
        if (!FormProcDCflag) {
            LoadPrintForm();
            FormProcDCflag = true;
        }
    }
    function LoadPrintForm() {
        var URL, param;
        param = "?ID1=" + javaURLEncode(g_ID1) + "&ID2=" + javaURLEncode(g_ID2);
        if (g_Flag == "CABINET") {
            URL = "/ezApprovalG/printFormCabInfo.do" + param;
        }
        else if (g_Flag == "RECORD") {
            URL ="/ezApprovalG/printFormRecInfo.do" + param;
        }

        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", URL, false);
        xmlhttp.send()

        document.getElementById("content").innerHTML = xmlhttp.responseText;
    }
    function FieldsAvailable() {
    }
    function btnClose_onclick()
    {
        window.close();
    }
</script>
</head>
<body class="popup">
<div id="menu">
	<ul>
		<li><span onClick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li> 
	</ul>
</div>
<div id="close"><ul><li id=btnClose ><span onClick="return btnClose_onclick()"></span></li></ul></div>
<div id="content"></div>
<script type="text/javascript">
	selToggleList(document.getElementById("menu"), "ul", "li", "0");
</script>
</body>
</html>
