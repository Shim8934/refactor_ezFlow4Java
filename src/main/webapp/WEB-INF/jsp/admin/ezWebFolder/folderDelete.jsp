<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script src="/js/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>
	<script type="text/javascript">
		var folderId = "<c:out value="${folderId}"/>";
		
		function wClose() {
			parent.closeAllPopup();
			window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshViewAfterUpdate();
			wClose();
		}
		
		function ok_Click() {
			$.ajax({
				type: "POST",
				url: "/admin/ezWebFolder/delCompanyFolder.do",
				data: {
					"folderId" : folderId
				},
				dataType: "JSON",
				async: false,
				success: function(data) {
					afterDeleteSuccess();
				},
				error: function (xhr, status, e){
					alert("<spring:message code='ezWebFolder.t134'/>");
					wClose();
				}
			});
		}
	</script>
</head>
<body class="popup"> 
	<h1 id ="topmenu"><spring:message code='ezWebFolder.t246'/></h1>
	<div id="close">
		<ul>
			<li><span onclick="wClose();"><spring:message code='ezWebFolder.t110'/></span></li>
		</ul>
	</div>
	
	<div style="margin: 10px;"><spring:message code='ezWebFolder.t222'/></div>
	
	<div style="margin-top: 10px;"><hr size="0" style="color:#fff; background-color:#fff; margin: 0px 10px; border-top: 1px solid #304D7F;"></div>
	
	<div style="margin: 10px 0px; position:fixed; bottom: 0px; text-align: center; width: 100%;">
		<a id="btnSave"  class="webfolderBttn" onClick="ok_Click();"><span><spring:message code='ezWebFolder.t111'/></span></a>
		<a id="btnCancel"class="webfolderBttn" onClick="wClose();"  ><span><spring:message code='ezWebFolder.t112'/></span></a>
	</div>
	
</body>
</html>