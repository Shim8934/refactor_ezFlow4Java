<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
<title>Insert title here</title>
<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript">

var m_rgParams4PostOption = new Array();
var RetValue;
var ReturnFunction;
var CancelFunction; 
var isDivPopUp = false;
var tempId = '<c:out value="${tempId}"/>'; 
var userkey = '<c:out value="${userkey}"/>';

window.onload = function(){
	 showMailProgressNew();
	 showTobLeftDim();
	
	 var rgParams;
     
	 try {
         CancelFunction = parent.importOption_cross_dialogArguments[2];
         isDivPopUp = true;
         rgParams = RetValue;
     } catch (e) {
         try {
             CancelFunction = opener.importOption_cross_dialogArguments[2];
             rgParams = RetValue;
         } catch (e) {console.log(e);}
     }
}

function confirm(){
	
	if (document.getElementById("securePassword").value == "") {
		alert("<spring:message code='ezEmail.kyj14' />");
		return;
	} else {
		var pwd = document.getElementById("securePassword").value;
		DivPopUpHiddenForOption();
		hideTopLeftDim();
		hideMailProgressNew();
		window.parent.mailbox_attach_import(pwd, tempId, userkey);
	}
	
}

function cancel() {
	parent.document.importMailboxform.file1.value = "";
	DivPopUpHiddenForOption();
	hideTopLeftDim();
	hideMailProgressNew();
	
	if (tempId != "") {
		$.ajax({
			url: '/ezEmail/deleteZipFile.do',
			dataType: 'json',
			type: 'POST',
			data: {tempId : tempId},
			success: function() {
				console.log('file Delete success');
			},
			error: function(request, status, error) {
				console.log("code=" + request.status + ", message=" + request.responseText + ", error=" + error);
			}
		});
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
	
	if (window.parent.parent.frames["left"].useBottomFrameOnly == "NO") {
		parent.parent.parent.document.getElementById("topFrame").contentWindow.hideProgress();
	} 
}

function showTobLeftDim(){
	parent.parent.document.getElementById("left").contentWindow.showProgress();
	
	if (window.parent.parent.frames["left"].useBottomFrameOnly == "NO") {
		parent.parent.parent.document.getElementById("topFrame").contentWindow.showProgress();
	} 
}

function keycheck(event) {
	var keycode = event.keyCode ? event.keyCode : event.which;
	
	if (keycode == 13) {
		confirm();
	}
}

function DivPopUpHiddenForOption() {
    try {
        parent.document.getElementById("mailPanel").style.display = "none";
        parent.document.getElementById("iFramePanel").style.display = "none";
        parent.document.getElementById("iFrameLayer").src = "/blank.htm";
    } catch (e) {console.log(e);}
}

</script>
</head>
<body style="overflow: hidden;" class="popup">
	<form name="optionForm">
		<h1><spring:message code="ezEmail.kyj05"/></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel()"></span></li>
            </ul>
        </div>
		<span>▒ <spring:message code="ezEmail.kyj07"/> <spring:message code="ezEmail.kyj14" /></span><br/>
		<br/>		
		<table style="width:100%;" class="content">
			<tr>
		    	<th><spring:message code="ezEmail.lhm64" /></th> 
		    	<td><input type="password" id="securePassword" style="width:98%;margin-left:3px" maxlength="50" onkeypress="keycheck(event)" autocomplete="off" /></td>
		  	</tr>
		</table>		
		<div class="btnposition btnpositionNew">
		   <a class="imgbtn" onClick="javascript:confirm();" ><span><spring:message code='ezEmail.t38' /></span></a>
		</div>
	</form>
</body>
</html>