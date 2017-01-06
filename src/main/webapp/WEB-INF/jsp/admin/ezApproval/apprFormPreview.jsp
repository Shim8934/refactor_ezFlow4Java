<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html style="height: 97%">
	<head>
	    <title><spring:message code='ezApproval.hyj14'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <style type="text/css">
	        .withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox
	        {
	            border-collapse: collapse;
	            height: 100%;
	            width: 0px;
	            margin: 0px;
	            background-color: white;
	        }
	    </style>
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var pDocHref = "${docHref}";
	        var pFormID = "${formID}"
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        window.onload = function () {
	        }        
	
	        function DocumentComplete() {
	            if (pDocHref != "") {
	                message.Set_EditorContentURL(pDocHref);
	            }
	        }
	
	        var noFieldsAvailable = false;
	        function FieldsAvailable() {          
	        }
	
	        function process_AfterApprove(mode) {
	          
	        }
	
	        function setbutton() {
	            ChangeBtnState();
	        }
	
	        var onlydocinfiview = false;
	        function process_AfterOpen() {           
	        }
	
	        function btnClose_onclick() {
	            window.close();
	        }
	
	        window.onbeforeunload = function () {
	            try {
	                window.opener.openergetDocInfo();
	            } catch (e) { }
	
	            try {
	                opener.window_onload();
	            } catch (e) { }
	        }
	    </script>
	</head>
	<body class="popup" style="height: 100%">
	    <table class="layout">
	        <tr>
	            <td style="height: 20px;">
	                <div id="menu">
	                    <ul>                      
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li><span id="btnClose" onclick="return btnClose_onclick()"><spring:message code='ezApproval.t70'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="vertical-align: top; height: 100%;text-align:center">
	            	<c:choose>
	            		<c:when test="${reformType == 'Y'}">
			                <iframe id="Iframe1" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/myoffice/ezApproval/DraftUI/Draft_reform_Content.aspx" name="message" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            		</c:when>
	            		<c:otherwise>
			                <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/myoffice/ezApproval/ApprovUI/ApprovUI_Content_Cross.aspx" name="message" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            		</c:otherwise>
	            	</c:choose>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px;">
	                <table class="file">
	                    <tr>
	                        <th><spring:message code='ezApproval.t71'/></th>
	                        <td>
	                            <div id="lstAttachLink"></div>
	                        </td>
	                        <td style="display: none"><a class="imgbtn"><span onclick=""><spring:message code='ezApproval.t72'/></span></a>
	                            <br>
	                            <a class="imgbtn"><span onclick=""><spring:message code='ezApproval.t73'/></span></a></td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>    
	</body>
</html>