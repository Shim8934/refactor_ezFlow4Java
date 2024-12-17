<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>
<html>
<head>
    <title><spring:message code='ezApprovalG.t259'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script id="clientEventHandlersJS" type="text/javascript">
        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
            window.onblur = function () {
                window.focus();
            }
        }
        if (new RegExp(/Chrome/).test(navigator.userAgent)) {
            window.resizeTo(347, 270);
        }
        if (navigator.userAgent.indexOf('Firefox') != -1) {
            window.resizeTo(348, 277);
        }
        var ReturnFunction;
        var pCompanyID = "<c:out value='${userInfo.companyID}'/>";
        window.onload = function () {
            try {
                ReturnFunction = parent.selectenc_dialogArguments[1];
            } catch (e) {
                try {
                    ReturnFunction = opener.selectenc_dialogArguments[1];
                } catch (e) {
                }
            }

            var objXml = createXmlDom();
            objXml = GetencodeinfoxXML();

            if (objXml == "") {
                document.getElementById("btnOpinion1").style.display = "";
                document.getElementById("btnOpinion2").style.display = "";
                document.getElementById("btnOpinion3").style.display = "";
            } else {
                var flag = false;
                objXml = loadXMLString(objXml);
                if (BroswerAndNonActiveXCheck() == "CROSS") {
                    document.getElementById("btnOpinion1").style.display = "none";
                    document.getElementById("btnOpinion2").style.display = "none";                    
                } else {
                    if (getNodeText(GetChildNodes(GetChildNodes(objXml)[0])[1]) == "Y") {
                        flag = true;
                        document.getElementById("btnOpinion1").style.display = "";
                    } else {
                        document.getElementById("btnOpinion1").style.display = "none";
                    }

                    if (getNodeText(GetChildNodes(GetChildNodes(objXml)[0])[0]) == "Y") {
                        flag = true;
                        document.getElementById("btnOpinion2").style.display = "";
                    } else {
                        document.getElementById("btnOpinion2").style.display = "none";
                    }

                    if (getNodeText(GetChildNodes(GetChildNodes(objXml)[0])[2]) == "Y") {
                        flag = true;
                        document.getElementById("btnOpinion3").style.display = "";
                    } else {
                        document.getElementById("btnOpinion3").style.display = "none";
                    }
                    
                    if (!flag) {
                        document.getElementById("btnOpinion3").style.display = "";
                    }
                }
            }
            
            if (!CrossYN()) {
                window.returnValue = "NONE";
            }
        }

    function GetencodeinfoxXML() {
        var xhttp = createXMLHttpRequest();
        xhttp.open("GET", "/ezApprovalG/getencodeinfoxXML.do", false);
        xhttp.send();
        return xhttp.responseText;
    }
    
    function btnOpinion1_onclick() {
        if (ReturnFunction != null) {
            ReturnFunction("ENC");
        } else {
            window.returnValue = "ENC";
            window.close();
        }
    }
    
    function btnOpinion2_onclick() {
        if (ReturnFunction != null) {
            ReturnFunction("SIGN");
        } else {
            window.returnValue = "SIGN";
            window.close();
        }
    }
    
    function btnOpinion3_onclick() {
        if (ReturnFunction != null) {
            ReturnFunction("NONE");
        } else {
            window.returnValue = "NONE";
            window.close();
        }
    }
    </script>
</head>
<body style="overflow: hidden;">
    <div class="popup_noti">
        <div class="popup_noti_title" style="height: 10px;"><span class="tl"></span><span class="tr"></span></div>
        <div class="popup_noti_content">
            <div style="padding: 10px;">
                <table>
                    <tr>
                        <td class="cimg"></td>
                        <td class="ctxt"><span id="pMessageContent"><spring:message code='ezApprovalG.t260'/></span></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="popup_noti_btnarea">
            <div class="btnposition">
                <input type="submit" name="Submit3" style="display: none" value="<spring:message code='ezApprovalG.t261'/>" id="btnOpinion1" onclick="return btnOpinion1_onclick()">
                <input type="submit" name="Submit3" style="display: none" value="<spring:message code='ezApprovalG.t262'/>" id="btnOpinion2" onclick="return btnOpinion2_onclick()">
                <input type="submit" name="Submit3" value="<spring:message code='ezApprovalG.t263'/>" id="btnOpinion3" onclick="return btnOpinion3_onclick()">
            </div>
            <span class="bl"></span><span class="br"></span>
        </div>
    </div>
</body>
</html>
