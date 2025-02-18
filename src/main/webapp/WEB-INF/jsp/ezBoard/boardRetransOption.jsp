<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezBoard.t10100'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript">
	        var ReturnFunction;
	        var eventVal = "";
	        function event_onclick(event) {
	            eventVal = event;
	            if (ReturnFunction != null)
	                ReturnFunction(eventVal);
	            else {
	                window.returnValue = eventVal;
	                window.close();
	            }
	        }
	        window.onload = function () {
	            
	            try {
	                ReturnFunction = parent.board_retransoption_dialogArguments[1];
	            } catch (e) {}
	            
	        }
	        function tr_mouseover(pRow) {
	            pRow.style.backgroundColor = "#f4f5f5";
	            for (var i = 0; i < pRow.childNodes.length; i++) {
	                if(pRow.childNodes[i].nodeName == "TD")
	                    pRow.childNodes[i].style.backgroundColor = "#f4f5f5";
	            }
	        }
	        function tr_mouseout(pRow) {
	            pRow.style.backgroundColor = "#FFFFFF";
	            for (var i = 0; i < pRow.childNodes.length; i++) {
	                if (pRow.childNodes[i].nodeName == "TD")
	                    pRow.childNodes[i].style.backgroundColor = "#FFFFFF";
	            }
	        }
	        function close_onclick() {
	            if (ReturnFunction != null)
	                ReturnFunction();
	            else
	                window.close();
	        }
	    </script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezBoard.t10100'/></h1>
	    <div id="close">
	        <ul>
	          <li><span onClick="close_onclick()"></span></li>
	        </ul>
	      </div>
	    <table class="content" style="width:100%">
	        <tr style="cursor:pointer;" onmouseover="tr_mouseover(this);" onmouseout="tr_mouseout(this);">
	            <td onclick="event_onclick('boardContent')" style="padding-left:10px;">
	                <img src="/images/icon/bcontent.png" style="margin-bottom:-3px;"/>
	                <spring:message code='ezBoard.t10101'/>
	            </td>
	        </tr>
	        <tr style="cursor:pointer;" onmouseover="tr_mouseover(this);" onmouseout="tr_mouseout(this);">
	            <td onclick="event_onclick('boardAttach')" style="padding-left:10px;">
	                <img src="/images/icon/battach.png" style="margin-bottom:-3px;"/>
	                <spring:message code='ezBoard.t10102'/>
	            </td>
	        </tr>
	        <c:if test="${useExternalMailServer == 'NO'}">   
	        <tr style="cursor:pointer;" onmouseover="tr_mouseover(this);" onmouseout="tr_mouseout(this);">
	            <td onclick="event_onclick('mailContent')" style="padding-left:10px;">
	                <img src="/images/icon/mcontent.png" style="margin-bottom:-3px;"/>
	                <spring:message code='ezBoard.t10103'/>
	            </td>
	        </tr>
	        <tr style="cursor:pointer;" onmouseover="tr_mouseover(this);" onmouseout="tr_mouseout(this);">
	            <td onclick="event_onclick('mailAttach')" style="padding-left:10px;">
	                <img src="/images/icon/mattach.png" style="margin-bottom:-3px;"/>
	                <spring:message code='ezBoard.t10104'/>
	            </td>
	        </tr>
	        </c:if>
	    </table>
	</body>
</html>