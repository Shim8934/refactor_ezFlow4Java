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
    	var fileId = "<c:out value="${fileId}" />";
    	var selectedFolder = null;
    	
		function wClose() {
	        parent.DivPopUpHidden();               
	        window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshView();
	        parent.DivPopUpHidden();            
	        window.close();
		}
		
		function fileCopy() {
			if (selectedFolder == null) {
				alert("Please select a folder!");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFile.do",
				data: {
					"fileId"   : fileId,
					"folderId" : selectedFolder,
					"mode"	   : "copy"
				},
				dataType: "text",
				async: true,
				success : function(data, textStatus, jqXHR) {				
					afterDeleteSuccess();
				},
 				error : function(jqXHR, textStatus, errorThrown) {
					alert("Error: " + jqXHR.status + ", " + textStatus);
				}
			});
		}
		
		function fileMove() {
			if (selectedFolder == null) {
				alert("Please select a folder!");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFile.do",
				data: {
					"fileId"   : fileId,
					"folderId" : selectedFolder,
					"mode"	   : "move"
				},
				dataType: "text",
				async: true,
				success : function(data, textStatus, jqXHR) {					
					afterDeleteSuccess();
				},
 				error : function(jqXHR, textStatus, errorThrown) {
					alert("Error: " + jqXHR.status + ", " + textStatus);
				}
			});
		}
    </script>
</head>
<body class="popup"> 
	<div id="menu">
		<div style="font-weight: bold; font-size: 16px; color: #fff; margin-top: 3px;"><spring:message code='ezWebFolder.t120' /></div>	
    </div>
    <div id="close">
    	<ul>
            <li><span onclick="wClose();"><spring:message code='ezWebFolder.t110' /></span></li>
        </ul>
    </div>
    
    <div style="margin: 10px; border: 1px solid #666666; height: 380px;">
	
    </div>	
    
	<div style="margin: 6px 0px 10px 140px; position:fixed; bottom: 0px;">
	    <a id="btnSave" class="webfolderBttn" onClick="fileMove();"><span><spring:message code='ezWebFolder.t121' /></span></a>
	    <a id="btnCancel"class="webfolderBttn" onClick="fileCopy();"><span><spring:message code='ezWebFolder.t122' /></span></a>
	</div>
    
</body>
</html>