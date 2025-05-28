<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAddress.t320' /></title>
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
        <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script>
		    var Arguments;
		    var ReturnFunction;
		    var CancelFunction;
		    function window_onload() {
		        try {
		            CancelFunction = parent.mail_select_groupmember_cross_dialogArguments[0];
		        } catch (e) {
		            try {
		                CancelFunction = opener.mail_select_groupmember_cross_dialogArguments[0];
		            } catch (e) {console.log(e);}
		        }
		    }
		    function Window_Close() {
		        if (CancelFunction!=null) {
		            CancelFunction();
		        }
		        else {
		            window.returnValue = 0;
		            window.close();
		        }
		    }

		</script>
	</head>
	<body style="overflow:hidden;" class="popup" onload="javascript:window_onload()">
		<form id="Form1" method="post">
			<h1><spring:message code='ezAddress.t320' /></h1>
			<div id="close">
	            <ul>
	                <li><span onclick="Window_Close()"></span></li>
	            </ul>
	        </div>
			<div id="maillist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; border:0px; HEIGHT:323px;" class="box">
				<table style="width:100%;table-layout: fixed;" class="popuplist" > 
					<tr> 
						<th style="width:50px;white-space:nowrap;"><spring:message code='ezStatistics.t1042' /></th>
						<th style=""><spring:message code='main.t74' /></th>
						<th style=""><spring:message code='main.t75' /></th>
						<th style="width:200px;white-space:nowrap;"><spring:message code='ezEmail.lsd04' /></th>
					</tr>
					<c:forEach var="item" items="${list}">
						<tr>
							<td>${item.type}</td>
							<td>${item.company}</td>
							<td>${item.dept}</td>
							<td>${item.name}</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</form>
	</body>
</html>


