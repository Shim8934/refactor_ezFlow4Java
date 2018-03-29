<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <link rel="stylesheet" href="/js/ezEmail/<spring:message code='ezEmail.e4' />" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c3' />" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <script type="text/javascript">
		
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
		
	        function SaveColor() {
	            var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmldom, objNode, "DATA");
	            createNodeAndInsertText(xmldom, objNode, "IMPORTANCE", document.getElementById('ImfortanceColorValue').innerText);
	            createNodeAndInsertText(xmldom, objNode, "INCOLOR", document.getElementById('InColorValue').innerText);
	            createNodeAndInsertText(xmldom, objNode, "OUTCOLOR", document.getElementById('OutColorValue').innerText);
	
	            xmlhttp.open("POST", "/admin/ezEmail/mailSaveColor.do", false);
	            xmlhttp.send(xmldom);
	            xmlhttp = null;
	            alert("<spring:message code='ezEmail.t292' />");
	            document.location.reload();
	        }
	        var manycolor_dialogArguments = new Array();
	        var Name_Complete;
	        function SelectColor(Name) {
	            Name_Complete = Name;
	            var parameter = new Array();
	            parameter[0] = document.getElementById(Name + "Value").value;
	            if (CrossYN()) {
	                manycolor_dialogArguments[1] = SelectColor_Complete;
	                var OpenWin = window.open("/ezCommon/manyColor.do?refresh5=", "manyColor", GetOpenWindowfeature(294, 260));
	                try { OpenWin.focus(); } catch (e) { }
	            }
	            else {
	                var retValue = window.showModalDialog("/ezCommon/manyColor.do?refresh5=", "", "dialogHeight:260px; dialogWidth:294px; status:no;scroll:no; help:no; edge:sunken");
	                if (typeof (retValue) != "undefined" && retValue != null) {
	                    document.getElementById(Name + "Value").innerText = retValue;
	                    document.getElementById(Name).style.backgroundColor = retValue;
	                }
	            }
	        }
	        function SelectColor_Complete(retValue) {
	            if (typeof (retValue) != "undefined" && retValue != null) {
	                document.getElementById(Name_Complete + "Value").innerText = retValue;
	                document.getElementById(Name_Complete).style.backgroundColor = retValue;
	            }
	        }
	
	    </script>
	</head>
	<body>    
	    <br />
	    <table style="border: 0; border-collapse: collapse; border-spacing: 0; padding:0px;">
	        <tr>
	            <td>
	                <span class="subtxt">&nbsp;* <spring:message code='ezEmail.t730' /></span><br />
	                <span class="subtxt">&nbsp;* <spring:message code='ezEmail.t99000069' /></span>
	            </td>
	        </tr>
	    </table>
	    <br>
	    <table class="content" style="width:400px">
	        <tr style="height:30px;">
	            <th style="width: 70px; text-align:center">
	                <spring:message code='ezEmail.t359' />
	            </th>
	            <td id="ImfortanceColor" style="width: 50px; background-color: ${importanceColor};">
	            </td>
	            <td id="ImfortanceColorValue" style="width: 100px; text-align:center">
	                ${importanceColor}         
	            </td>
	            <td style="width: 100px; text-align:center; padding-top:3px;">
	                <a class="imgbtn"><span onclick="SelectColor('ImfortanceColor')" style="vertical-align: middle;"><spring:message code='ezEmail.t408' /></span></a>
	            </td>
	        </tr>
	        <tr style="height:30px;">
	            <th style="width: 70px; text-align:center">
	                <spring:message code='ezEmail.t99000067' />
	            </th>
	            <td id="InColor" style="width: 50px; background-color: ${inColor};">
	            </td>
	            <td id="InColorValue" style="width: 100px; text-align:center">
	                ${inColor}         
	            </td>
	            <td style="width: 100px; text-align:center; padding-top:3px;">
	                <a class="imgbtn"><span onclick="SelectColor('InColor')" style="vertical-align: middle;"><spring:message code='ezEmail.t408' /></span></a>
	            </td>
	        </tr>
	        <tr style="height:30px;">
	            <th style="width: 70px; text-align:center">
	                <spring:message code='ezEmail.t99000068' />
	            </th>
	            <td id="OutColor" style="width: 50px; background-color: ${outColor};">
	            </td>
	            <td id="OutColorValue" style="width: 100px; text-align:center">
	                ${outColor}         
	            </td>
	            <td style="width: 100px; text-align:center; padding-top:3px;">
	                <a class="imgbtn"><span onclick="SelectColor('OutColor')" style="vertical-align: middle;"><spring:message code='ezEmail.t408' /></span></a>
	            </td>
	        </tr>
	    </table>
	    <table style="border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px; width: 400px;">
	        <tr>
	            <td style="height: 50px; text-align: center;">
	                <a class="imgbtn"><span onclick="return SaveColor()"><spring:message code='ezEmail.t48' /></span></a>
	                <a class="imgbtn"><span onclick="document.location.reload()"><spring:message code='ezEmail.t39' /></span></a>
	            </td>
	        </tr>
	    </table>
	
	</body>
</html>
