<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
<title>Insert title here</title>
<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
<script type="text/javascript" src="/js/ezEmail/Controls_cross/datepicker.htc.js"></script>
<script type="text/javascript" src="/js/ezEmail/Controls_cross/composeappt.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<!-- crypt -->
<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
<script type="text/javascript" src="/js/rsa/asn1.js"></script>
<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
<script type="text/javascript" src="/js/rsa/prng4.js"></script>
<script type="text/javascript" src="/js/rsa/rng.js"></script>
<script type="text/javascript" src="/js/rsa/rsa.js"></script>
<script type="text/javascript">

var m_rgParams4PostOption = new Array();
var RetValue;
var ReturnFunction;
var CancelFunction;
var isDivPopUp = false;
var exportType = "${exportType}";
var pwdcheck = "NO";

window.onload = function(){
	 var rgParams;
     var useEncrytZipFileChk = document.getElementById("useEncrytZipFileChk").checked = true;
     
     try {
    	 showTobLeftDim();
    	 showMailProgressNew();
		 checkUsePassword(useEncrytZipFileChk); 
         CancelFunction = parent.exportOption_cross_dialogArguments[2];
         isDivPopUp = true;
         rgParams = RetValue;
     } catch (e) {
         try {
             CancelFunction = opener.exportOption_cross_dialogArguments[2];
             rgParams = RetValue;
         } catch (e) {  }
     }	
}

$(function(){
	
	// 암호 일치 확인
	$('#securePassword').keyup(function(){
		
		if ($('#securePassword').val() != $('#securePasswordCheck').val()) {
			pwdcheck = "NO";
		} else {
			pwdcheck = "YES";
		}
		
	});
	
	$('#securePasswordCheck').keyup(function(){
		
		if ($('#securePassword').val() != $('#securePasswordCheck').val()) {
			pwdcheck = "NO";
		} else {
			pwdcheck = "YES";
		}
		
	});
	
	
})

function confirm() {
		
	var useEncrytZipFileChk = document.getElementById("useEncrytZipFileChk").checked;
	
	if (useEncrytZipFileChk) {
		
		if (document.getElementById("securePassword").value.trim() == "") {
			alert("<spring:message code='ezEmail.lhm42' />");
			return;
		}
		
		if (document.getElementById("securePasswordCheck").value.trim() == "") {
			alert("<spring:message code='ezEmail.lhm62' />");
			return;
		}
		
		if (pwdcheck == "YES") {
			// 암호 알고리즘 사용 확인
			var pwd = document.getElementById("securePassword").value;
			
			CancelFunction();
			hideTopLeftDim();
			hideMailProgressNew();
			
			if (exportType == "MAIL") {
				window.parent.mailExport_start(pwd);
				return;
			}
			
			if (exportType == "MAILBOX") {
				window.parent.mailbox_export_start(pwd);
				return;
			}
			
		} else {
			alert("<spring:message code='ezEmail.lhm62' />");
			return;
		}
		
	} else {
		CancelFunction();
		hideTopLeftDim();
		hideMailProgressNew();
		
		if (exportType == "MAIL") {
			window.parent.mailExport_start();
			return;
		}
		
		if (exportType == "MAILBOX") {
			window.parent.mailbox_export_start();
			return;
		}
	}
}

function checkUsePassword(obj) {
	
    if (obj.checked || obj == true) {
        document.getElementById("securePassword").disabled = false;
        document.getElementById("securePasswordCheck").disabled = false;
    } else {
    		document.getElementById("securePassword").value = "";
    		document.getElementById("securePasswordCheck").value = "";
        document.getElementById("securePassword").disabled = true;
        document.getElementById("securePasswordCheck").disabled = true;
    }
    
}

function cancel() {
	CancelFunction();
	hideTopLeftDim();
	hideMailProgressNew();
}

function keycheck(event) {
	var keycode = event.keyCode ? event.keyCode : event.which;
	
	if (keycode == 13) {
		confirm();
	}
}

function hideMailProgressNew() {
	parent.document.getElementById("mailPanel").style.display = "none";
	parent.document.getElementById("mailPanel").style.backgroundColor = "";
}

function showMailProgressNew(){
	parent.document.getElementById("mailPanel").style.display = "block";
	parent.document.getElementById("mailPanel").style.opacity = 0.5;
	parent.document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
}

function hideTopLeftDim(){
	parent.parent.document.getElementById("left").contentWindow.hideProgress();
	parent.parent.parent.document.getElementById("topFrame").contentWindow.hideProgress();
}

function showTobLeftDim(){
	parent.parent.document.getElementById("left").contentWindow.showProgress();
	parent.parent.parent.document.getElementById("topFrame").contentWindow.showProgress();
}

</script>
</head>
<body style="overflow:hidden;" class="popup">
<form name="optionForm">
	<h1><spring:message code="ezEmail.kyj04"/></h1>
	<c:if test="${exportType eq 'MAILBOX' }">
		<span>▒ <spring:message code='ezEmail.kyj02' /></span><br>
	</c:if>
	<c:if test="${exportType eq 'MAIL' }">
		<span>▒ <spring:message code='ezEmail.kyj09' /></span><br>
	</c:if>
		<span>▒ <spring:message code='ezEmail.kyj03' /></span><br>
	<br>
	
	<table style="width:100%;" class="content">
	  <tr>
	    <th><spring:message code="ezEmail.lhm64" /></th> 
	    <td><input type="password" id="securePassword" maxlength="50" />
    		<input type="checkbox" name="usePassword" value="checkbox" onClick="checkUsePassword(this);" id="useEncrytZipFileChk">
    		<span style="vertical-align:middle;"><spring:message code="ezEmail.kyj06"/></span>
	    </td>
	  </tr>
	  <tr>
	    <th><spring:message code="ezEmail.lhm61" /></th> 
	    <td><input type="password" id="securePasswordCheck" maxlength="50" onkeypress="keycheck(event)"/></td>
	  </tr>
	</table>
	
	<div class="btnposition">
	   <a class="imgbtn" onClick="javascript:confirm();" ><span><spring:message code='ezEmail.t38' /></span></a>
	   <a class="imgbtn" onClick="cancel()" ><span><spring:message code='ezEmail.t39' /></span></a>
	</div>
</form>
</body>
</html>