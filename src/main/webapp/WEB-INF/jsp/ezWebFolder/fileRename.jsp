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
			parent.DivPopUpHidden();
			window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshView();
			parent.DivPopUpHidden();
			window.close();
		}
		
		function isValid(str){
			var regex = /[*:"\\|<>\/?]/g;
			return regex.test(str);
		}
		
		function ok_Click() {
			var newName = document.getElementById("nameInput").value;
			
			if (isValid(newName) == true) {
				alert("<spring:message code='ezWebFolder.t211'/>");
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
<body class="popup"> 
	<div id="menu">
		<div style="font-weight: bold; font-size: 16px; color: #fff; margin-top: 3px;"><spring:message code='ezWebFolder.t118'/></div>
	</div>
	<div id="close">
		<ul>
			<li><span onclick="wClose();"><spring:message code='ezWebFolder.t110'/></span></li>
		</ul>
	</div>
	
	<div style="margin: 10px;">
		<div style="text-align: center;"><spring:message code='ezWebFolder.t119'/></div>
		<div style="height: 40px; line-height: 40px; margin-top: 5px;">
			<input id="nameInput" type="text" placeholder="<spring:message code='ezWebFolder.t212'/>" style="margin-left: 15px; margin-right: 15px; width: 380px; height: 35px; line-height: 35px; font-size: 14px; padding: 0px 10px; border-radius: 5px; border: 1px solid #666666;">
		</div>
	</div>
	
	<div style="margin-top: 15px;"><hr size="0" style="color:#fff; background-color:#fff; margin: 0px 10px; border-top: 1px solid #304D7F;"></div>
	
	<div style="margin: 6px 0px 10px 140px; position:fixed; bottom: 0px;">
		<a id="btnSave"   class="webfolderBttn" onClick="ok_Click();"><span><spring:message code='ezWebFolder.t116'/></span></a>
		<a id="btnCancel" class="webfolderBttn" onClick="wClose();"  ><span><spring:message code='ezWebFolder.t112'/></span></a>
	</div>
	
</body>
</html>