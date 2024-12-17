<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='email.appr.th.allow.domain' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
</head>
<body class="popup">
	<h1>
		<spring:message code='email.appr.domain.add' /> <% // 도메인추가 %>
	</h1>
	<div id="close">
		<ul><li><span onclick="btnClose()"></span></li></ul>
	</div>

    <div class="layout">
        <table class="content">
            <tbody>
                <tr>
                    <th><spring:message code='email.appr.domain' /></th> <% // 도메인 %>
                    <td><input type="text" id="addDomain" maxlength="20" style="width:100%"></td>
                </tr>
            </tbody>
        </table>

		<div>
			<div class="btnposition btnpositionNew">
				<a class="imgbtn" onclick="btnSave()"><span><spring:message code='common.save' /></span></a> <% // 저장 %>
			</div>
		</div>
    </div>
</body>
<script type="text/javascript">	
var saveEvent;
var okEvent;

window.onload = function () {
	saveEvent = window.opener.addAllowedDomain_arg.save;
	okEvent = window.opener.addAllowedDomain_arg.ok;
}

$(document).on({
	"keyup" : function(event) {
		if (event.keyCode == 13) {btnSave(); return; }
		
		var thisVal = event.currentTarget.value;
		event.currentTarget.value = thisVal.replace(/[^a-zA-Z0-9\_\-\.]/gi, '');
	}
}, "#addDomain");

function btnClose() {
	window.close();
}
	
async function btnSave() {
	let addDomainValue = $("#addDomain").val();
	
	if (addDomainValue.trim() == "") {
		alert("<spring:message code='ezEmail.multiDomain.ksa25' />");
		return
	} else {
		const state = await saveEvent(addDomainValue);
		switch(state) {
			case "OK" :
				alert("<spring:message code='common.success.msg.save' />");
				okEvent();
				btnClose();
				break;
			case "DUPLICATION" :
				alert("<spring:message code='email.appr.domain.msg.already' />");
				break;
			case "ERROR" :
				alert("<spring:message code='common.error.msg' />");
				break;
		}
	}
}

</script>
</html>

