<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
    <title>mailAutoForward</title>
    <meta name="CODE_LANGUAGE" Content="C#">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
    <script type="text/javascript">
    var g_UserID = "${userId}";
    var g_Email = "${userEmail}";
    var g_ExeCnt = 0;
    window.onload = window_onload;
    document.onselectstart = function () { return false; };

    function window_onload() {
        if (navigator.userAgent.indexOf('Firefox') != -1) {
            document.body.style.MozUserSelect = 'none';
            document.body.style.WebkitUserSelect = 'none';
            document.body.style.khtmlUserSelect = 'none';
            document.body.style.oUserSelect = 'none';
            document.body.style.UserSelect = 'none';
        }
        if (document.getElementById("OrgForwardAddress").value == "")
            document.getElementById("btnSave").style.display = "";

        if (document.getElementById("ForwardAddress").value == "")
            document.getElementById("ForwardDel").style.display = "none";
        else
            document.getElementById("btnSave").style.display = "none";
    }
    var xmlHTTP = createXMLHttpRequest();
    function btnSave_onClick() {
        if (document.getElementById("OrgForwardAddress").value == "") {
            if (document.getElementById("ForwardAddress").value == "" || document.getElementById("ForwardAddress").value.indexOf("@") == -1) {
                alert("<spring:message code='ezEmail.t130' />");
                ddocument.getElementById("ForwardAddress").focus();
                event.returnValue = false;
                return false;
            }
            if (document.getElementById("ForwardAddress").value.indexOf("@") + 1 == document.getElementById("ForwardAddress").value.length) {
                alert("<spring:message code='ezEmail.t130' />");
                document.getElementById("ForwardAddress").focus();
                event.returnValue = false;
                return false;
            }
            if (document.getElementById("ForwardAddress").value.toLowerCase() == g_Email.toLowerCase()) {
                alert("<spring:message code='ezEmail.t131' />");
                document.getElementById("ForwardAddress").focus();
                event.returnValue = false;
                return false;
            }
            Button_Disabled();
            var xmlDOM = createXmlDom();
            var objNode;
            createNodeInsert(xmlDOM, objNode, "DATA");
            createNodeAndInsertText(xmlDOM, objNode, "GUBUN", "SET");
            createNodeAndInsertText(xmlDOM, objNode, "USERID", g_UserID);
            createNodeAndInsertText(xmlDOM, objNode, "ADDRESS", document.getElementById("ForwardAddress").value);
            if (document.getElementById("DisplayName").value == "")
                document.getElementById("DisplayName").value = document.getElementById("ForwardAddress").value;

            createNodeAndInsertText(xmlDOM, objNode, "DISPLAYNAME", document.getElementById("DisplayName").value);

            if (xmlHTTP == null) {
            	xmlHTTP = createXMLHttpRequest();
            }
            
            xmlHTTP.open("POST", "/ezEmail/mailAutoForwardSave.do", true);
            xmlHTTP.onreadystatechange = event_autoforward_save;
            xmlHTTP.send(xmlDOM);
        }
    }
    function event_autoforward_save() {
        if (xmlHTTP != null && xmlHTTP.readyState == 4) {
            if (xmlHTTP.status < 200 || xmlHTTP.status > 300) {
                xmlHTTP = null;
                Button_Enabled();
                alert("<spring:message code='ezEmail.t133' />");
            }
            else {
                var ret = "";
                if (xmlHTTP.status == 200) {
                    if (navigator.userAgent.indexOf("MSIE") != -1) {
                        ret = xmlHTTP.responseXML.text;
                    }
                    else if (navigator.userAgent.indexOf("MSIE") == -1) {
                        var result = xmlHTTP.responseText;
                        result = replaceAll(result, "<RESULT>", "");
                        result = replaceAll(result, "</RESULT>", "");
                        ret = result;
                    }

                    if (ret == "OK") {
                        alert("<spring:message code='ezEmail.t134' />");
                        document.getElementById("btnSave").style.display = "none";
                        document.getElementById("ForwardDel").style.display = "";
                        Button_Enabled();
                    }
                    else if (ret == "MINE") {
                        alert("<spring:message code='ezEmail.t135' />");
                        Button_Enabled();
                    }
                    else {
                        alert("<spring:message code='ezEmail.t136' />" + ret);
                        Button_Enabled();
                    }
                    xmlHTTP = null;
                }
            }
        }
    }
    function replaceAll(pStrContent, pStrOrg, pStrRep) {
        return pStrContent.split(pStrOrg).join(pStrRep);
    }
    function Button_Disabled() {
        document.getElementById("btnSave").disabled = true;
    }
	
    function Button_Enabled() {
        document.getElementById("btnSave").disabled = false;
    }
    function onkeydown_SaveKeyEvent(e) {
        var curevent = (typeof event == 'undefined' ? e : event)
        if (curevent.keyCode == "13")
            btnSave_onClick();
    }
    function ButtonSaveAutoForward_Click() {
        var xmlhttp = createXMLHttpRequest();
        xmlhttp.open("POST", "/ezEmail/mailAutoForwardDelete.do", false);
        xmlhttp.send();
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        	var ret = "";
            
            if (navigator.userAgent.indexOf("MSIE") != -1) {
                ret = xmlhttp.responseXML.text;
            }
            else if (navigator.userAgent.indexOf("MSIE") == -1) {
                var result = xmlhttp.responseText;
                result = replaceAll(result, "<RESULT>", "");
                result = replaceAll(result, "</RESULT>", "");
                ret = result;
            }

            if (ret == "OK") {
	            document.getElementById("ForwardDel").style.display = "none";
	            document.getElementById("btnSave").style.display = "";
	
	            window.location.href='/ezEmail/mailAutoForward.do';
	            
	            alert("<spring:message code='ezEmail.t141' />");
            }
            else {
            	alert("<spring:message code='ezEmail.t142' />");
            }
        }
        else {
            alert("<spring:message code='ezEmail.t142' />");
        }
        xmlhttp = null;

    }
        var mail_newreceiverchoose_dialogArguments = new Array();
        function SelectReceiver_onClick() {
            var type = "auto";
            var receiverData = new Array();
            receiverData["addReceiver"] = addReceiver;
            receiverData["window"] = this;
            mail_newreceiverchoose_dialogArguments[0] = receiverData;
            mail_newreceiverchoose_dialogArguments[1] = addReceiver;
            var OpenWin = window.open("/ezEmail/mailNewReceiverChoose.do?defaultwin=&type=" + type + "&rulekind=" + "", "mail_foldermanage_Cross", GetOpenWindowfeature(970, 655));
            try { OpenWin.focus(); } catch (e) { }
        }

        function addReceiver(strEmail) {
            document.getElementById("ForwardAddress").value = strEmail;
        }
</script>
</HEAD>
<body style="margin-left:10px;margin-right:10px;"> 

<form id="form1">

<br>
<h2 class="h2_dot"><spring:message code='ezEmail.t138' /></h2>
<br>
<table class="content" style="width:490px;">
  <tr>
    <th><spring:message code='ezEmail.t139' /></th>
    <td>
        <input type="text" id="ForwardAddress" value="${forwardAddress}" class="textarea" style="WIDTH:80%" NAME="ForwardAddress" onkeyup="onkeydown_SaveKeyEvent(event);">
        <a id="ReceiverSelect" class="imgbtn" onClick="SelectReceiver_onClick()"><span><spring:message code='ezEmail.t488' /></span></a>
        </td>
  </tr>
</table>
<div class="btnposition">
</div>
<div style="text-align:center;width:410px;">
    <a class="imgbtn" id="ForwardDel" onClick="ButtonSaveAutoForward_Click()"><span><spring:message code='ezEmail.t95' /></span></a>
    <a id="btnSave" class="imgbtn" onClick="btnSave_onClick()"><span><spring:message code='ezEmail.t48' /></span></a>
    <a class="imgbtn" onClick="window.location.href='/ezEmail/mailAutoForward.do'"><span><spring:message code='ezEmail.t39' /></span></a>
    
</div>
<div style="display:none;">
    <input type="text" id="DisplayName" value="${forwardAddress}" class="textarea" style="WIDTH:250px"> 
    <input type="hidden" id="OrgForwardAddress" value="${forwardAddress}" class="textarea" style="WIDTH:250px">
</div>



<p />
<!--
<div id="divLoading" style="width:410px;height:365px;overflow-y:auto;">
<table style="width:100%;">
    <tr>
        <td style="text-align:center;">
            Loading...
        </td>
    </tr>
    <tr>
        <td style="text-align:center;">
            <img src="/images/email/progress_img.gif" />
        </td>
    </tr>
</table>
</div>
 -->

</form>


</body>
</HTML>


