<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script src="/js/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>
	<script type="text/javascript">
		var fileId = "<c:out value="${fileId}"/>";
		
		function wClose() {
			parent.closeAllPopup();
			window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshView();
			wClose();
		}
		
		function isValid(str){
			var regex = /[*:"\\|<>\/?]/g;
			return regex.test(str);
		}
		
		function ok_Click() {
			var newName = document.getElementById("nameInput").value;
			
			if (isValid(newName)) {
				alert('<spring:message code='ezWebFolder.t211'/>');
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/renameFile.do",
				data: {
					"fileId"  : fileId,
					"newName" : newName
				},
				dataType: "text",
				async: true,
				success : function(data, textStatus, jqXHR) {
					afterDeleteSuccess();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("<spring:message code='ezWebFolder.t134'/>" + jqXHR.status + ", " + textStatus);
				}
			});
		}
	</script>
</head>
<body class="popup" style="overflow: hidden;"> 
	<h1 id ="topMenu" style="margin:2px;"><spring:message code='ezWebFolder.t118'/></h1>
	<div id="close">
        <ul>
            <li><span id="btnCancel" onclick="wClose();"></span></li>
        </ul>
    </div>
	<div style="margin: 0px; height:112px; border:1px solid #ddd; padding:15px; margin-bottom:10px">
		<div style="text-align:left; font-size:12px"><spring:message code='ezWebFolder.t119'/></div>
		<div style="height: 40px; line-height: 40px; margin-top: 10px;">
			<input id="nameInput" type="text" placeholder="<spring:message code='ezWebFolder.t212'/>" style="width: 380px; height: 35px; line-height: 35px; font-size: 12px; padding: 0px 10px; border-radius: 5px; border: 1px solid #ddd;">
		</div>
	</div>	
	<div class="btnpositionNew">
		<a id="btnSave" class="imgbtn" onclick="ok_Click();"><span><spring:message code='ezWebFolder.t116'/></span></a>
	</div>
</body>
</html>