<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.kasMailTemplate02'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style>
		    #divList tr{ border: 1px solid #d2d2d2; }
		    #divList th{ text-align:center; }
			#divList td { border: none; }
		</style>
	</head>
	<body class="popup">
		  <h1><spring:message code='ezEmail.kasMailTemplate02'/></h1>
		  <div id="close">
		    <ul>
		      <li onClick="btn_Close()"><span></span></li>
		    </ul>
		  </div>
		  
		<div style="width:100%;" id="divList">
            <table class="popuplist" style="width:100%;">
            	<th width="20%"><spring:message code='ezEmail.kasMailTemplate03'/></th>
            	<td width="80%"><input id="templateDisplayName" type="text" maxlength="40" style="width:100%"></td>
            </table>
        </div>
        
        <div class="btnpositionNew">
        	<a class="imgbtn" onclick="btn_Add()"><span><spring:message code='ezEmail.kasMailTemplate08'/></span></a>
        </div>
	</body>
	<script>
		var companyId = "${companyId}";
	
		function btn_Add() {
			var editorType = parent.bodyType.value; // 0:html, 1:plainTxt
			var templateDisplayName = $("#templateDisplayName").val();
			var templateContent = editorType == 1 ? parent.document.getElementById("plainTextArea").value 
					: parent.message.GetEditorContent();
			
			if (templateDisplayName.trim() == "") {
				alert("<spring:message code='ezEmail.kasMailTemplate14' />");
				return;
			}
			
			$.ajax({
				type: "POST",
				async: false,
				data: {
					"displayName" : templateDisplayName,
					"content" : templateContent,
					"editorType" : editorType
				},
				url : "/ezEmail/saveUserMailTemplate.do",
				success: function(data) {
					if (data == "OK") {
						alert("<spring:message code='ezEmail.kasMailTemplate09' />");
						btn_Close();
					} else if (data == "DUPLICATE") {
						alert("<spring:message code='ezEmail.kasMailTemplate10' />");
					} else {
						alert("<spring:message code='ezEmail.kasMailTemplate11' />");
					}
				}, error : function(data) {
					alert("<spring:message code='ezEmail.kasMailTemplate11' /> : " + data);
				}
			});
		}
	
		function btn_Close() {
           	parent.DivPopUpHidden();
		}
	</script>
</html>
