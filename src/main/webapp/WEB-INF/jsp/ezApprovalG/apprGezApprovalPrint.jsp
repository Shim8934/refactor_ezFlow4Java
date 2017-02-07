<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.pjj03'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <meta http-equiv="X-UA-Compatible" content="IE=9">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    
	    <script type="text/javascript">
	
	        var myVar;
	        var NoneActiveX = "YES";
	        document.onselectstart = function () { return false; };
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        window.onload = function () {
	            document.getElementById("printDocument").innerHTML = opener.PrtBodyContent;
	            myVar = setInterval(function () { DocumentComplate() }, 2000);
	        }
	        function DocumentComplate() {
	            if (!CrossYN() && NoneActiveX == "NO") {
	                preview_print();
	            }
	            else{
	                window.print();
	            }
	            clearInterval(myVar);
	        }
	
	        function FieldsAvailable() {
	            document.getElementById("printDocument").innerHTML = message.div_Content.innerHTML;
	            myVar = setInterval(function () { DocumentComplate() }, 2000);
	        }
	
	        function preview_print() { //미리보기 기능 선언
	            var OLECMDID = 7; //7이 미리보기,6이 인쇄,8이 페이지설정
	            var PROMPT = 1;
	            var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
	            document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
	            WebBrowser1.ExecWB(OLECMDID, PROMPT);
	            WebBrowser1.outerHTML = "";
	            return false;
	        }
	    </script>
	</head>
	<body scroll="auto">
	    <table align="center">
	        <tr>
	            <td>
	                <div id="printDocument"></div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>