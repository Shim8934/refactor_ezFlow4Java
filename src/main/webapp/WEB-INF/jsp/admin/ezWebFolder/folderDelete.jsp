<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
	<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezWebFolder/webfolder.css")%>" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
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
					var code = data.code;
					
					switch(code) {
						case 0: 
							afterDeleteSuccess();
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300' />");
							break;
					}
				},
				error: function (xhr, status, e){
					alert("<spring:message code='ezWebFolder.t134'/>");
					wClose();
				}
			});
		}
	</script>
</head>
<body class="popup" style="overflow: hidden;"> 
	<h1 id ="topmenu" style="margin: 0px; margin-top: 2px;"><spring:message code='ezWebFolder.t246'/></h1>
	<div id="close">
		<ul>
			<li><span onclick="wClose();"></span></li>
		</ul>
	</div>
	
	<div style="margin: 0px 0px 12px; height: 110px; border: 1px solid #ddd; padding: 15px;">
		<span><spring:message code='ezWebFolder.t222'/></span>
	</div>
	
	<div style="margin: 6px 0px 0px; bottom: 0px; text-align: center">
		<a id="btnSave"  class="webfolderBttn" onClick="ok_Click();"><span><spring:message code='ezWebFolder.t111'/></span></a>
		<a id="btnCancel"class="webfolderBttn" onClick="wClose();"  ><span><spring:message code='ezWebFolder.t112'/></span></a>
	</div>
	
</body>
</html>