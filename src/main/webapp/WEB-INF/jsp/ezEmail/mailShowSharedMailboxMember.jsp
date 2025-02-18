<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="overflow:hidden">
	<head>
		<title><spring:message code='ezEmail.sharedMailbox06' /></title>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script>
		    var Arguments;
		    var CancelFunction;
		    
		    window.onload = function () {
		        try {
		            Arguments = parent.mail_select_sharedMailboxMember_cross_dialogArguments[0];
		            CancelFunction = parent.mail_select_sharedMailboxMember_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                Arguments = opener.mail_select_sharedMailboxMember_cross_dialogArguments[0];
		                CancelFunction = opener.mail_select_sharedMailboxMember_cross_dialogArguments[1];
		            } catch (e) {console.log(e);}
		        }
		    }
		    
		    function Window_Close() {
		        if (CancelFunction != null) {
		            CancelFunction();
		        } else {
		            window.returnValue = 0;
		            window.close();
		        }
		    }
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<form method="post">
			<h1 id="h1"><spring:message code='ezEmail.sharedMailbox06' /></h1>
			<div id="close">
	            <ul>
	                <li><span onclick="Window_Close()"></span></li>
	            </ul>
	        </div>
			<div class="box" id="maillist" style="overflow-y:auto; overflow-x:hidden; width:100%; height:400px;border:0px;padding: 0px;">
			  <table style="width:100%;table-layout:fixed;" class="popuplist" id="checkboxtable">
			    <tr>
			      <th style="text-align:center;"><spring:message code='ezEmail.t712' /></th>
			      <th style="width:120px;text-align:center;"><spring:message code='ezEmail.t26' /></th>
			      <th style="width:120px;text-align:center;"><spring:message code='ezEmail.t28' /></th>
			      <th style="width:120px;text-align:center;"><spring:message code='ezEmail.t31' /></th>
			    </tr>
			    
			    <c:forEach var="item" items="${list}">
				    <tr>
				      <td style="text-align:center;">${item.company}</td>
				      <td style="text-align:center;">${item.dept}</td>
				      <td style="text-align:center;">${item.title}</td>
				      <td style="text-align:center;">${item.displayName}</td>
				    </tr>
			    </c:forEach>
			    
			  </table>
			</div>
		</form>
	</body>
</html>



