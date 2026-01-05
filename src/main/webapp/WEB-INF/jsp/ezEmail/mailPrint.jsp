<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<title><spring:message code='ezEmail.t546' /></title>
		<c:if test="${userLang == '1'}">
		<style>
			table, th, td {
				border-collapse: collapse;
				empty-cells: show;
				padding:0;margin:0;
				font-size:12px;
				/*font-family: 'malgun gothic', 'arial', 'verdana';*/
			}
			th{
				white-space: nowrap;
				word-break: keep-all;
				word-wrap: normal;
				color: #777;
				background-color:#f8f8fa;
				border:1px solid #d2d2d2;
				padding:2px 10px;
			}
			p {
				margin-bottom: 0; 
				margin-top: 0;
			}
		</style>
		</c:if>
		<c:if test="${userLang == '2'}">
		<style>
			table, th, td {
				border-collapse: collapse;
				empty-cells: show;
				padding:0;margin:0;
				font-size:12px;
				font-family: 'malgun gothic', 'arial', 'verdana';
			}
			th{
				white-space: nowrap;
				word-break: keep-all;
				word-wrap: normal;
				color: #666;
				background-color:#f8f8f8;
				border:1px solid #ddd;
				padding:2px 10px;
			}
			p {
				margin-bottom: 0; 
				margin-top: 0;
			}
		</style>
		</c:if>
		<c:if test="${userLang == '3'}">
		<style>
			table, th, td {
				border-collapse: collapse;
				empty-cells: show;
				padding:0;margin:0;
				font-size:12px;
				font-family: Meiryo UI, ＭＳ Ｐゴシック, Arial, Helvetica, sans-serif;
			}
			th{
				white-space: nowrap;
				word-break: keep-all;
				word-wrap: normal;
				color: #777;
				background-color:#f8f8fa;
				border:1px solid #d2d2d2;
				padding:2px 10px;
			}
			p {
				margin-bottom: 0; 
				margin-top: 0;
			}
		</style>
		</c:if>
		<c:if test="${userLang == '4'}">
		<style>
			table, th, td {
				border-collapse: collapse;
				empty-cells: show;
				padding:0;margin:0;
				font-size:12px;
				font-family:'malgun gothic','simsun', 'simhei', 'arial', 'verdana';
			}
			th{
				white-space: nowrap;
				word-break: keep-all;
				word-wrap: normal;
				color: #666;
				background-color:#f8f8f8;
				border:1px solid #ddd;
				padding:2px 10px;
			}
			p {
				margin-bottom: 0; 
				margin-top: 0;
			}
		</style>
		</c:if>
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
	    <table cellpadding="0" cellspacing="0" style="margin:5px 5px 5px 5px; border-collapse:collapse;" >
	        <tr>
	            <th style="white-space:nowrap; text-align:left; padding:0px 10px; font-size:12px; color:#666666; background:#f8f8f8; border:1px solid #ddd;"><spring:message code='ezEmail.t161' /></th>
	            <td style="width:60%; font-size:12px; color:#393939; border:1px solid #ddd; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pSender}
	            </td>
	            <th style="white-space:nowrap; text-align:left; padding:0px 10px; font-size:12px; color:#666666; background:#f8f8f8; border:1px solid #ddd;">
	            	<c:if test="${isSentItems== false}"><spring:message code='ezEmail.t657' /></c:if>
	            	<c:if test="${isSentItems== true}"><spring:message code='ezEmail.t704' /></c:if>
	            </th>
	            <td style="width:40%; font-size:12px; color:#393939; border:1px solid #ddd; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pReciveDT}
	            </td>
	        </tr>
	        <tr>
	            <th style="white-space:nowrap; text-align:left; padding:0px 10px; font-size:12px; color:#666666; background:#f8f8f8; border:1px solid #ddd;"><spring:message code='ezEmail.t66' /></th>
	            <td colspan="3" style="font-size:12px; color:#393939; border:1px solid #ddd; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pReciverTo}
	            </td>
	        </tr>
	        <c:if test="${pReciverCc != null and pReciverCc != ''}">
	        <tr>
	            <th style="white-space:nowrap; text-align:left; padding:0px 10px; font-size:12px; color:#666666; background:#f8f8f8; border:1px solid #ddd;"><spring:message code='ezEmail.t594' /></th>
	            <td colspan="3" style="font-size:12px; color:#393939; border:1px solid #ddd; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pReciverCc}
	            </td>
	        </tr>
	        </c:if>
			<c:if test="${pReciverBcc != null and pReciverBcc != ''}">
			<tr>
				<th style="white-space:nowrap; text-align:left; padding:0px 10px; font-size:12px; color:#666666; background:#f8f8f8; border:1px solid #ddd;"><spring:message code='ezEmail.t562' /></th>
				<td colspan="3" style="font-size:12px; color:#393939; border:1px solid #ddd; vertical-align:middle; padding:7px 7px 7px 7px;">
					${pReciverBcc}
				</td>
			</tr>
			</c:if>
	        <tr>
	            <th style="white-space:nowrap; text-align:left; padding:0px 10px; font-size:12px; color:#666666; background:#f8f8f8; border:1px solid #ddd;"><spring:message code='ezEmail.t556' /></th>
	            <td colspan="3" style="font-size:12px; color:#393939; border:1px solid #ddd; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pSubject}
	            </td>
	        </tr>
	        <c:if test="${isAttach == 'OK'}">
	        <tr>
	            <th style="white-space:nowrap; text-align:left; padding:0px 10px; font-size:12px; color:#666666; background:#f8f8f8; border:1px solid #ddd;"><spring:message code='ezEmail.t557' /></th>
	            <td colspan="3" style="font-size:12px; color:#393939; border:1px solid #ddd; vertical-align:middle; padding:7px 7px 7px 7px;">
	                ${pAttachListHtml}
	            </td>
	        </tr>
	        </c:if>
	        <tr>
	        	<td colspan="4" style="border : medium none" height="10px">
	        	</td>
	        </tr>
	        </table>
	        <div style="height:100%; margin:5px; word-wrap:break-word; word-break:normal; display:block">
	            <div style="height:100%; border:1px solid #ddd;vertical-align:top;">
	               <div style="padding:10px">
	                    ${pBody}
	                </div>
	            </div>
	        </div>
	</body>
</html>
