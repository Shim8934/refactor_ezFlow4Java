<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
		<title><spring:message code='ezBoard.t484'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ErrorHandler_Cross.js"></script>
		<script  type="text/javascript" >
		    var eOneline = "false";
		    var eAttach = "false";
		    var pItemID = "${itemID}";
		    var pBoardID = "${boardID}";
		    var rvalue = new Array();
		    var ReturnFunction;
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    window.onload = function () {
		        try {
		            ReturnFunction = opener.boarditemview_cross_print_option_dialogArguments[1];
		        } catch (e) { }
		
		        GetAttachmentCount();
		        if ("${oneLineReplyFlag}" == "1") {
		            getOneLineReplyCount();
		
		            if (eOneline != "true") {
		                document.getElementById('onl').disabled = true;
		            }
		        }
		        if (eAttach != "true") {
		            document.getElementById('att').disabled = true;
		        }
		        rvalue[0] = "0";
		        rvalue[1] = "0";
		
		        if (ReturnFunction == null)
		            window.returnValue = rvalue;
		    };
		    function GetAttachmentCount() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		        xmlhttp.open("POST", "/ezBoard/getItemAttachments.do?itemID=" + pItemID, false);
		        xmlhttp.send();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        var i = 0;
		        var pos = 0;
		        var filename = "";
		        var filepath = "";
		        var strAttach = "";
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        if (xmldomNodes.length > 0)
		            eAttach = "true";
		    }
		    function getOneLineReplyCount() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "interASP/ReadOneLineReply.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
		        xmlhttp.send();
		        var xmldom = createXmlDom();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        if (xmldom.getElementsByTagName("REPLYID").length > 0)
		            eOneline = "true";
		    }
		    function all_click() {
		        if (eOneline == "true")
		            rvalue[0] = "Y";
		        else
		            rvalue[0] = "N";
		        if (eAttach == "true")
		            rvalue[1] = "Y";
		        else
		            rvalue[1] = "N";
		        window.close();
		    }
		    function select_click() {
		        if (eOneline == "true") {
		            if (document.getElementById('onl').checked == true)
		                rvalue[0] = "Y";
		            else
		                rvalue[0] = "N";
		        }
		        else
		            rvalue[0] = "N";
		
		        if (eAttach == "true") {
		            if (document.getElementById('att').checked == true)
		                rvalue[1] = "Y";
		            else
		                rvalue[1] = "N";
		        }
		        else
		            rvalue[1] = "N";
		        window.close();
		    }
		    function only_click() {
		        rvalue[0] = "N";
		        rvalue[1] = "N";
		        window.close();
		    }
		
		    window.onunload = function () {
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		        else {
		            window.returnValue = rvalue;
		        }
		    }
		
		</script>
		<style type="text/css" title="ezform_style_1">
		P {
				MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm
			}
		</style>
	</head>
	<body class="popup">
		<h1><spring:message code='ezBoard.t484'/></h1>
		<h2><spring:message code='ezBoard.t485'/></h2>
		<span id="pMessageContent"></span>
		<table class="content">
		<c:if test="${oneLineReplyFlag == '1'}">
			<tr>
			    <th><input id='onl' name ='onl'  type='checkbox' /></th>
			    <td><span id="ext1"><spring:message code='ezBoard.t486'/></span></td>
			</tr>
		</c:if>
		<tr>
		    <th ><input id='att' name='att'  type='checkbox' /></th>
		    <td><span id="ext2"><spring:message code='ezBoard.t487'/></span></td>
		</tr>
		</table>
		          
		<div class="btnposition">
		    <a class="imgbtn" id="Submit1" onClick="all_click()" ><span><spring:message code='ezBoard.t488'/></span></a>
		    <a class="imgbtn" id="Submit2" onClick="select_click()" ><span><spring:message code='ezBoard.t489'/></span></a>
		    <a class="imgbtn" id="Submit3" onClick="only_click()" ><span><spring:message code='ezBoard.t490'/></span></a>
		</div>
	</body>
</html>