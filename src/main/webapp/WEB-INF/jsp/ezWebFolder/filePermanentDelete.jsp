<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<script src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>	
	<script type="text/javascript">
		var fileList = "<c:out value="${fileList}"/>";
		var folderList = "<c:out value="${folderList}"/>";
		var versionList = "<c:out value="${versionList}"/>";
		
		function wClose() {
			parent.hiddenPanel();
			window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshView();
			wClose();
		}
		
		function ok_Click() {
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/pemanentDeleteFile.do",
				data: {
					"fileList" : fileList,
					"folderList" : folderList,
					"versionList": versionList
				},
				dataType: "JSON",
				async: false,
				success : function(data) {
					var reason = data.reason;
					
					if (reason) {
						alert(reason);
						afterDeleteSuccess();
					} else {
						if (data.code == 1) {
							alert("<spring:message code='ezWebFolder.t113'/>");
						} else if (data.code == 2) {
							alert("<spring:message code='ezWebFolder.t114'/>" + error);
						} else if (data.code == 3) {
							alert("<spring:message code='ezWebFolder.t28'/>" + error);
						}
					}
				},
				error : function(error) {
            		alert(messages.strLang7 + error);
				}
			});
			
			afterDeleteSuccess();
		}
	</script>
</head>
<body class="popup"> 
	<h1 id ="topMenu" style="margin:0px;margin-top:2px"><spring:message code='ezWebFolder.t19'/></h1>
	<div id="close">
        <ul>
            <li><span id="btnCancel" onclick="wClose();"></span></li>
        </ul>
    </div>
	<p style="margin: 0;padding:25px 0px;font-size:14px;text-align:center;"><spring:message code='ezWebFolder.t294'/></p>	
	<div class="btnpositionNew">
		<a id="btnSave" class="imgbtn" onclick="ok_Click();"><span><spring:message code='ezWebFolder.t111'/></span></a>
	</div>
</body>
</html>