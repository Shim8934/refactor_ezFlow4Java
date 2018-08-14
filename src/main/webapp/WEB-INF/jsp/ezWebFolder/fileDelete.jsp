<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<script type="text/javascript">
		var fileList = "<c:out value="${fileList}"/>";
		
		function wClose() {
			parent.closeAllPopup();
			window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshView();
			wClose();
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
					var code = data.code;
					
					switch(code) {
						case 0: 
							alert("<spring:message code='ezWebFolder.t113'/>");
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
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t114'/>" + error);
					wClose();
				}
			});
		}
	</script>
</head>
<body class="popup" style="overflow: hidden;"> 
	<h1 id ="topMenu" style="margin:0px;margin-top:2px"><spring:message code='ezWebFolder.t117'/></h1>
	<div id="close">
        <ul>
            <li><span id="btnCancel"class="webfolderBttn" onclick="wClose();"></span></li>
        </ul>
    </div>
	<div style="margin: 0px 0px 12px;height:110px;border:1px solid #ddd;padding:15px;font-size:12px;"><spring:message code='ezWebFolder.t109'/></div>	
	<div class="btnpositionNew">
		<a id="btnSave" class="imgbtn" onclick="ok_Click();"><span><spring:message code='ezWebFolder.t111'/></span></a>
	</div>
</body>
</html>