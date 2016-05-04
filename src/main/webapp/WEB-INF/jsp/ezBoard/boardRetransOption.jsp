<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title><spring:message code='ezBoard.t10100'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
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
	          <li><span onClick="close_onclick()"><spring:message code='ezBoard.t12'/></span></li>
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
	    </table>
	</body>
</html>