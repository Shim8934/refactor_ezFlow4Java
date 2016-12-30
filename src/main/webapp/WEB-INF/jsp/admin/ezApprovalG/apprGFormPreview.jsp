<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code = 'ezApprovalG.t1252' /></title>
		
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
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var pDocHref = "<c:out value = '${docHref}' />";
			
	        document.onselectstart = function () { return false; };
	        
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
	                        <li><span id="btnClose" onclick="return btnClose_onclick()"><spring:message code = 'ezApprovalG.t64' /></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="vertical-align: top; height: 100%;text-align:center">
	                <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/ezApprovalG/approvUIcontent.do" name="message" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px;"></td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	</body>
</html>