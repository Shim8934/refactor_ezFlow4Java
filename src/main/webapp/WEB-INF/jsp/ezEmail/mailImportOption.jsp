<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<script type="text/javascript">

var m_rgParams4PostOption = new Array();
var RetValue;
var ReturnFunction;
var CancelFunction; 
var isDivPopUp = false;
var tempId = "${tempId}"; 
var userkey = "${userkey}";

window.onload = function(){
	showTobLiftDim();
	showMailProgressNew();
	 var rgParams;
     try {
         CancelFunction = parent.importOption_cross_dialogArguments[2];
         isDivPopUp = true;
         rgParams = RetValue;
         
     } catch (e) {
         try {
             CancelFunction = opener.importOption_cross_dialogArguments[2];
             rgParams = RetValue;
         } catch (e) {  }
     }
}

function confirm(){
	
	if (document.getElementById("securePassword").value.trim() == "") {
		alert('암호가 입력되지 않았습니다. 암호를 입력해주세요.'); // 보안메일 메세지 사용예정
		return;
	} else {
		var pwd = document.getElementById("securePassword").value;
		CancelFunction();
		hideTopLeftDim();
		hideMailProgressNew();
		window.parent.mailbox_attach_import(pwd, tempId, userkey);
	}
	
}
function cancel() {
	parent.document.importMailboxform.file1.value = "";
	CancelFunction();
	hideTopLeftDim();
	hideMailProgressNew();
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

function showTobLiftDim(){
	parent.parent.document.getElementById("left").contentWindow.showProgress();
	parent.parent.parent.document.getElementById("topFrame").contentWindow.showProgress();
}
</script>
</head>
<body style="overflow: hidden;" class="popup">
	<form name="optionForm">
		<h1><spring:message code="ezEmail.kyj05"/></h1>
		<span>▒ <spring:message code="ezEmail.kyj07"/> 암호를 입력해 주세요. </span><br> <!-- 보안메일 메세지 사용예정 -->
		<br>
		
		<table style="width:100%;" class="content">
		  <tr>
		    <th>암호</th> <!-- 보안메일 메세지 사용예정 -->
		    <td><input type="password" id="securePassword" maxlength="50" />
		    </td>
		  </tr>
		</table>
		
		<div class="btnposition">
		   <a class="imgbtn" onClick="javascript:confirm();" ><span><spring:message code='ezEmail.t38' /></span></a>
		   <a class="imgbtn" onClick="cancel()" ><span><spring:message code='ezEmail.t39' /></span></a>
		</div>
	</form>
</body>
</html>