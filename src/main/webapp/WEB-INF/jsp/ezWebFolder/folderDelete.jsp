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
		var folderId = "";
		var ReturnFunction;
		
		window.onload = function () {
            try {
            	folderId = parent.deleteFolderDlg_cross_dialogArguments[0];
            	ReturnFunction = parent.deleteFolderDlg_cross_dialogArguments[1];
            } catch (e) {}
            
            try {
                txt_FolderName.focus();
            } catch (e) {}
        }
		
		function wClose() {
			parent.DivPopUpHidden();
			window.close();
		}
		
		function afterDeleteSuccess() {
			window.close();
			parent.refreshView();
			parent.DivPopUpHidden();
		}
		
		function ok_Click() {
			console.log("folderId = " + folderId);
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/deleteFolder.do",
				data: {
					"folderId": folderId
				},
				dataType: "JSON",
				async: false,
				success : function(data) {
					var reason = data.status;
					
					if (reason == "ok") {
						wClose();
						ReturnFunction(folderId);
						alert("<spring:message code='ezWebFolder.t280'/>")
					} else {
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
	<h1 id ="topMenu" style="margin:0px;margin-bottom:3px"><spring:message code='ezWebFolder.t246'/></h1>
	<div id="close">
		<ul>
			<li><span onclick="wClose();"></span></li>
		</ul>
	</div>
	<div style="height:100px; border:1px solid #ddd; font-size:12px;padding:10px"><spring:message code='ezWebFolder.t307'/></div>		
	<div style="margin: 6px 0px 0px; text-align: center;">
		<a id="btnSave" class="webfolderBttn" onclick="ok_Click();"><span><spring:message code='ezWebFolder.t111'/></span></a>
		<a id="btnCancel"class="webfolderBttn" onclick="wClose();"><span><spring:message code='ezWebFolder.t112'/></span></a>
	</div>
	
</body>
</html>