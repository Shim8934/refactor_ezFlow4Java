<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='main.kms1'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="<spring:message code='main.e15'/>" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
	
	var list = [];
	var confirmChange = "";
	
	function update_Sys_Param() {
		var paramArray
			= [
				{ name : "BigSizeMailAttachDelDay", value : document.getElementById("BigSizeMailAttachDelDay").value.trim() },
				{ name : "totBigSizeMailAttachLimit", value : document.getElementById("totBigSizeMailAttachLimit").value.trim() },
				{ name : "MailAttachLimit", value : document.getElementById("MailAttachLimit").value.trim() },				
				{ name : "ExpirePassPeriod", value : document.getElementById("ExpirePassPeriod").value.trim() },
				{ name : "INDIVIDUALMAILUSER", value : document.getElementById("INDIVIDUALMAILUSER").value.trim() },
				{ name : "IS_READ_DELETE", value : document.getElementById("IS_READ_DELETE").value.trim() },
				{ name : "PrimaryLang", value : document.getElementById("PrimaryLang").value.trim() },
				{ name : "USE_FileExtension", value : document.getElementById("USE_FileExtension").value.trim() },
				{ name : "LicenseKey", value : document.getElementById("LicenseKey").value.trim() }
			  ];
		
		if (!paramArray[0].value.match(/^\d+$/)) {
		    alert("<spring:message code='ezSystem.x0001'/>: <spring:message code='ezEmail.t99000066'/>");
		    return;
		} else if (!paramArray[1].value.match(/^\d+$/)) {
		    alert("<spring:message code='ezSystem.x0002'/>: <spring:message code='ezEmail.t99000066'/>");
		    return;
		} else if (!paramArray[2].value.match(/^\d+$/)) {
		    alert("<spring:message code='ezSystem.x0003'/>: <spring:message code='ezEmail.t99000066'/>");
		    return;
		} else if (!paramArray[3].value.match(/^\d+$/)) {
		    alert("<spring:message code='ezSystem.x0005'/>: <spring:message code='ezEmail.t99000066'/>");
		    return;
		} else if (!paramArray[4].value.match(/^\d+$/)) {
		    alert("<spring:message code='ezSystem.x0006'/>: <spring:message code='ezEmail.t99000066'/>");
		    return;
		}		
				
		var jsonStr = JSON.stringify(paramArray);

		$.ajax({
			type : "POST",
			url : "/admin/ezSystem/updateSysParam.do",
			processData : true, 
			contentType : "application/json; charset=UTF-8", 
			data :jsonStr,
			success : function(data){
				if(data.msg=='success'){
					alert("<spring:message code='main.sp10'/>");
					
					window.location.href='/admin/ezSystem/systemMainMenu.do';
				}
				if(data.msg=='fail'){
					alert("<spring:message code='main.sp12'/>");
				}
			},
			error : function(e) {
				alert(e);
			}
		});	
	}
	
</script>
</head>
<body class="mainbody">
<h1><spring:message code='main.kms1'/></h1>
    <table class="content">
        <tbody>
            <tr><th><spring:message code="main.kms1"/></th><th><spring:message code="main.kms3"/></th></tr>
            <tr><th><spring:message code="ezSystem.x0001"/></th><td><input id="BigSizeMailAttachDelDay" maxlength="3" type="text" value="${configMap.BigSizeMailAttachDelDay}"> (<spring:message code="ezSystem.x0010"/>)</td></tr>          
            <tr><th><spring:message code="ezSystem.x0002"/></th><td><input id="totBigSizeMailAttachLimit" maxlength="4" type="text" value="${configMap.totBigSizeMailAttachLimit}"> (<spring:message code="ezSystem.x0011"/>)</td></tr>
            <tr><th><spring:message code="ezSystem.x0003"/></th><td><input id="MailAttachLimit" maxlength="3" type="text" value="${configMap.MailAttachLimit}"> (<spring:message code="ezSystem.x0011"/>)</td></tr>                              
            <tr><th><spring:message code="ezSystem.x0005"/></th><td><input id="ExpirePassPeriod" maxlength="3" type="text" value="${configMap.ExpirePassPeriod}"> (<spring:message code="ezSystem.x0010"/>, <spring:message code="ezSystem.x0014"/>)</td></tr>
            <tr><th><spring:message code="ezSystem.x0006"/></th><td><input id="INDIVIDUALMAILUSER" maxlength="3" type="text" value="${configMap.INDIVIDUALMAILUSER}"> (<spring:message code="ezSystem.x0015"/>)</td></tr>
            <tr><th><spring:message code="ezSystem.x0007"/></th><td><select id="IS_READ_DELETE"><option <c:if test="${configMap.IS_READ_DELETE == 'YES'}">selected="selected"</c:if> value="YES"><spring:message code="ezQuestion.t103"/></option><option <c:if test="${configMap.IS_READ_DELETE == 'NO'}">selected="selected"</c:if> value="NO"><spring:message code="ezQuestion.t104"/></option></select></td></tr>
            <tr><th><spring:message code="ezSystem.x0008"/></th><td><select id="PrimaryLang"><option <c:if test="${configMap.PrimaryLang == '1'}">selected="selected"</c:if> value="1"><spring:message code="ezPersonal.s81"/></option><option <c:if test="${configMap.PrimaryLang == '3'}">selected="selected"</c:if> value="3"><spring:message code="ezPersonal.s84"/></option></select></td></tr>
            <tr><th><spring:message code="ezSystem.x0009"/></th><td><input id="USE_FileExtension" type="text" value="${configMap.USE_FileExtension}"> (<spring:message code="ezSystem.x0012"/>, <spring:message code="ezSystem.x0013"/>: jpg,doc,xls)</td></tr>
            <tr><th><spring:message code="ezSystem.x0016"/></th><td><input id="LicenseKey" size="60" maxlength="60" type="text" value="${configMap.LicenseKey}"> (<spring:message code="ezSystem.x0017"/>: ${licensedUserCount}, <spring:message code="ezSystem.x0018"/>: ${userCount})</td></tr>
        </tbody>
    </table> 
    <div class="btnposition">
        <a class="imgbtn" onclick="update_Sys_Param()"><span><spring:message code='main.sp09'/></span></a>
        <a class="imgbtn" onClick="window.location.href='/admin/ezSystem/systemMainMenu.do'"><span><spring:message code='main.t135'/></span></a>
    </div>       
</body>
</html>