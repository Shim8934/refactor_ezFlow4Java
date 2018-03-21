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
		var fileList = "<c:out value="${fileList}"/>";
		
		function wClose() {
			parent.DivPopUpHidden();
			window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshView();
			parent.DivPopUpHidden();
			window.close();
		}
		
		function ok_Click() {
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/deleteFile.do",
				data: {
					"fileList" : fileList
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var reason = data.reason;
					
					if (reason) {
						alert(reason);
						afterDeleteSuccess();
					}
					else {
						alert("<spring:message code='ezWebFolder.t113'/>");
						afterDeleteSuccess();
					}
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t114'/>" + error);
				}
			});
		}
	</script>
</head>
<body class="popup"> 
	<div id="menu">
		<div style="font-weight: bold; font-size: 16px; color: #fff; margin-top: 3px;"><spring:message code='ezWebFolder.t117'/></div>
	</div>
	<div id="close">
		<ul>
			<li><span onclick="wClose();"><spring:message code='ezWebFolder.t110'/></span></li>
		</ul>
	</div>
	
	<div style="margin: 10px;"><spring:message code='ezWebFolder.t109'/></div>
	
	<div style="margin-top: 15px;"><hr size="0" style="color:#fff; background-color:#fff; margin: 0px 10px; border-top: 1px solid #304D7F;"></div>
	
	<div style="margin: 6px 0px 6px 140px; position:fixed; bottom: 0px;">
		<a id="btnSave"  class="webfolderBttn" onClick="ok_Click();"><span><spring:message code='ezWebFolder.t111'/></span></a>
		<a id="btnCancel"class="webfolderBttn" onClick="wClose();"  ><span><spring:message code='ezWebFolder.t112'/></span></a>
	</div>
	
</body>
</html>