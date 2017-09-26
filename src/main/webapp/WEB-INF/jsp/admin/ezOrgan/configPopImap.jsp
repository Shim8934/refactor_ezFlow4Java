<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>POP3/IMAP</title>
	<link rel="stylesheet"	href="<spring:message code='ezOrgan.e2' />" type="text/css">
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript">
	
	var userConfig = "${propertyValue}";
	var returnValue = "${result}";
	
	function window_onload() {
		try {
			ReturnFunction = opener.serUseDisablePopImap_dialogArguments[1];
		} catch (e) {}

		if (returnValue == "NODATA") {
			// Default '사용'
			$('#unused').attr('checked', false);
			$('#used').attr('checked', true);
		
		} else if (returnValue == "SUCCESS") {
			
			if (userConfig == "YES") {
				$('#unused').attr('checked', true);
				$('#used').attr('checked', false);
			} else {
				$('#unused').attr('checked', false);
				$('#used').attr('checked', true);
			}
			
		} else if (returnValue == "ERROR") {
			alert('ERROR');
		}
	}
	
	function OK_Click(user_id) {
		var data = $(':input:radio[name=CheckUse]:checked').val();
		
		if (ReturnFunction != null) {
			ReturnFunction(data);
		} else {
			window.returnValue = data;
		}
			
		window.close();
	}
	
	</script>
</head>
<body class="popup" onload="javascript:window_onload()">
	<form name="sendForm" method="post" >
		<h1 style="height:30px;">POP3/IMAP</h1>
			<br />
		<table  class="content">
			<tr>
			  	<th><spring:message code='ezOrgan.yjks1' /></th>
				<td>
					<input type="radio" name="CheckUse" id="used" value="NO" /><spring:message code="ezOrgan.t161" />
					<input type="radio" name="CheckUse" id="unused" value="YES" /><spring:message code="ezOrgan.yjks2" />
				</td>
			</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn"><span onClick="return OK_Click()"><spring:message code='ezOrgan.t124' /></span></a>
			<a class="imgbtn"><span onClick="window.close()"><spring:message code='ezOrgan.t125' /></span></a>
		</div>
	</form>
</body>
</html>