<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<title><spring:message code='ezEmail.t546' /></title>
	    <script type="text/javascript">
	        var myVar;
	        window.onload = function ()
	        {
	            myVar = setInterval(function () { DocumentComplate() }, 2000);
	        }
	        function DocumentComplate()
	        {
	            if (!CrossYN()) {
	                preview_print();
	            }
	            else
	                window.print();
	            clearInterval(myVar);
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
	<body>    
	    <table cellpadding="0" cellspacing="0" style="margin:5px 5px 5px 5px; border-collapse:collapse; font-family:Gulim, Verdana, Geneva, sans-serif;" >
	        <tr>
	            <th style="white-space:nowrap; text-align:center; padding:0px 10px; font-size:12px; color:#666666; background:#f3f3f3; border:1px solid #b6b6b6;"><spring:message code='ezEmail.t161' /></th>
	            <td style="width:60%; font-size:12px; color:#393939; border:1px solid #b6b6b6; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pSender}
	            </td>
	            <th style="white-space:nowrap; text-align:center; padding:0px 10px; font-size:12px; color:#666666; background:#f3f3f3; border:1px solid #b6b6b6;"><spring:message code='ezEmail.t657' /></th>
	            <td style="width:40%; font-size:12px; color:#393939; border:1px solid #b6b6b6; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pReciveDT}
	            </td>
	        </tr>
	        <tr>
	            <th style="white-space:nowrap; text-align:center; padding:0px 10px; font-size:12px; color:#666666; background:#f3f3f3; border:1px solid #b6b6b6;"><spring:message code='ezEmail.t66' /></th>
	            <td colspan="3" style="font-size:12px; color:#393939; border:1px solid #b6b6b6; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pReciverTo}
	            </td>
	        </tr>
	        <c:if test="${pReciverCc != null and pReciverCc != ''}">
	        <tr>
	            <th style="white-space:nowrap; text-align:center; padding:0px 10px; font-size:12px; color:#666666; background:#f3f3f3; border:1px solid #b6b6b6;"><spring:message code='ezEmail.t594' /></th>
	            <td colspan="3" style="font-size:12px; color:#393939; border:1px solid #b6b6b6; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pReciverCc}
	            </td>
	        </tr>
	        </c:if>
	        <tr>
	            <th style="white-space:nowrap; text-align:center; padding:0px 10px; font-size:12px; color:#666666; background:#f3f3f3; border:1px solid #b6b6b6;"><spring:message code='ezEmail.t556' /></th>
	            <td colspan="3" style="font-size:12px; color:#393939; border:1px solid #b6b6b6; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pSubject}
	            </td>
	        </tr>
	        <c:if test="${isAttach == 'OK'}">
	        <tr>
	            <th style="white-space:nowrap; text-align:center; padding:0px 10px; font-size:12px; color:#666666; background:#f3f3f3; border:1px solid #b6b6b6;"><spring:message code='ezEmail.t557' /></th>
	            <td colspan="3" style="font-size:12px; color:#393939; border:1px solid #b6b6b6; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pAttachListHtml}
	            </td>
	        </tr>
	        </c:if>
	        <tr style="height:100%;">
	            <td colspan="4" style="height:100%; border:1px solid #b6b6b6;vertical-align:top;">
	               <div style="padding:10px;">
	                    ${pBody}
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>
