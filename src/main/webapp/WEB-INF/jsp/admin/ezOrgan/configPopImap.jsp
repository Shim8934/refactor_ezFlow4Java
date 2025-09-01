<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>POP3/IMAP</title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
	
	function window_onload() {
		try {
			ReturnFunction = opener.serUseDisablePopImap_dialogArguments[1];
		} catch (e) {console.log(e);}
	}

	function OK_Click() {
		var usePop3 = $(':input:radio[name=usePop3]:checked').val() || "0";
		var useImap = $(':input:radio[name=useImap]:checked').val() || "0";
		
		ReturnFunction(usePop3, useImap);
		window.close();
	}
	
	</script>
</head>
<body class="popup" onload="javascript:window_onload()">
	<form name="sendForm" method="post" >
		<h1 style="height:30px;">POP3/IMAP</h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<br />
		<table  class="content">
			<tr>
				<th><spring:message code='ezOrgan.usePOP3' /></th>
				<td>
					<input type="radio" name="usePop3" id="pop3Used" value="1" <c:if test="${popEnabled == '1'}"> checked="checked"</c:if> /><spring:message code="ezOrgan.t161" />
					<input type="radio" name="usePop3" id="pop3Unused" value="0" <c:if test="${empty popEnabled or popEnabled == '0'}"> checked="checked"</c:if> /><spring:message code="ezOrgan.kyj02" />
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezOrgan.useIMAP' /></th>
				<td>
					<input type="radio" name="useImap" id="imapUsed" value="1" <c:if test="${imapEnabled == '1'}"> checked="checked"</c:if> /><spring:message code="ezOrgan.t161" />
					<input type="radio" name="useImap" id="imapUnused" value="0" <c:if test="${empty imapEnabled or imapEnabled == '0'}"> checked="checked"</c:if> /><spring:message code="ezOrgan.kyj02" />
				</td>
			</tr>
		</table>
		<div class="btnposition">
			<a class="imgbtn"><span onClick="return OK_Click()"><spring:message code='ezOrgan.t124' /></span></a>
		</div>
	</form>
</body>
</html>