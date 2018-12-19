<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>	
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<script type="text/javascript">
		function isValid(str){
			var regex = /[*:"\\|<>\/?]/g;
			return regex.test(str);
		}
		
		<c:choose>
		<c:when test="${isUploading}">
		function wClose() {
			parent.closeAllPopup();
			skipRename();
			window.close();
		}
		
		function skipRename() {
			parent.duplicateFile.onClosePopup({
				code: "SKIP",
				looping: false
			});
		}
		
		function ok_Click() {
			var newName = document.getElementById("nameInput").value;
			
			if (newName == "") {
				alert('<spring:message code='ezWebFolder.t400'/>');
				return;
			}

			if (isValid(newName)) {
				alert('<spring:message code='ezWebFolder.t211'/>');
				return;
			}
			
			parent.duplicateFile.onClosePopup({
				code: "RENAME",
				newFileName: newName,
				looping: false
			});
			
			parent.closeAllPopup();
			window.close();
		}
		</c:when>
		<c:otherwise>
		var fileId = "<c:out value="${fileId}"/>";
		var folderUppId = "";
        var functionType = "";
        var folderName1 = "";
        var folderName2 = "";
        
		window.onload = function(){
			if (!parent.inputNameDlg_cross_dialogArguments) {
				folderUppId = "";
				functionType = "";
				
			} else {
				folderUppId = parent.inputNameDlg_cross_dialogArguments[0];
				functionType = parent.inputNameDlg_cross_dialogArguments[3];
			}

			if (functionType == "insert" && fileId == 0) {
            	$('#topMenu').text("<spring:message code='ezWebFolder.t302'/>");
            	$('#fileNamediv').text('<spring:message code='ezWebFolder.t514'/>');
            	$('#nameInput').attr("placeholder","<spring:message code='ezWebFolder.t314'/>");
            } else if(functionType == "update" && fileId == 0) {
            	$('#topMenu').text("<spring:message code='ezWebFolder.t303'/>");
            	$('#fileNamediv').text('<spring:message code='ezWebFolder.t514'/>');
            	$('#nameInput').attr("placeholder","<spring:message code='ezWebFolder.t314'/>");
            } 		
		}
		
		function wClose() {
			parent.closeAllPopup();
			window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshView();
			wClose();
		}
		
		function ok_Click() {
			var newName = document.getElementById("nameInput").value;
			
			if (newName == "") {
				alert('<spring:message code='ezWebFolder.t400'/>');
				return;
			}

			if (isValid(newName)) {
				alert('<spring:message code='ezWebFolder.t211'/>');
				return;
			}
				
			if (functionType == "insert" && fileId == 0) {
				newName = ReplaceText(newName, " ", "");
	            
				if (newName == "") {
	                alert('<spring:message code='ezWebFolder.t314'/>');
	                return;
	            }
				
				if (isValid(newName)) {
					alert('<spring:message code='ezWebFolder.t211'/>');
					return;
				}
				
	            $.ajax({
					type :"POST",
					async: false,
					url  : "/ezWebFolder/insertFolder.do",
					data : { 
						"folderId": folderUppId,
						"newFolderName1": newName
					},
					dataType: "JSON",
					success : function (data) {
						switch(data.code) {
						case 0: 
							alert("<spring:message code='ezWebFolder.t263'/>");
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
						case 8:
							alert(messages.resultErrDuplicateCreate);
						}
					}
	        	});
			} else if (functionType == "update" && fileId == 0) {
				$.ajax({
					type :"POST",
					async: false,
					url  : "/ezWebFolder/updateFolder.do",
					data : { 
						"folderId": folderUppId,
						"newFolderName1": newName
					},
					dataType: "JSON",
					success : function (data) {
						switch(data.code) {
						case 0: 
							alert("<spring:message code='ezWebFolder.t264'/>");
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
						case 8:
							alert(messages.resultErrDuplicateRename);
						}
					}
				});
			} else {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/renameFile.do",
					data: {
						"fileId"  : fileId,
						"newName" : newName
					},
					dataType: "JSON",
					async: false,
					success : function(data) {
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
							case 8:
								alert(messages.resultErrDuplicateRename);
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezWebFolder.t134'/>" + jqXHR.status + ", " + textStatus);
					}
				});
			}
			afterDeleteSuccess();
		}
		</c:otherwise>
		</c:choose>
	</script>
</head>
<body class="popup" style="overflow: hidden;"> 
	<h1 id ="topMenu" style="margin:2px;"><spring:message code='ezWebFolder.t118'/></h1>
	<div id="close">
        <ul>
            <li><span id="btnCancel" onclick="wClose()"></span></li>
        </ul>
    </div>
	<div style="margin: 0px; height:112px; border:1px solid #ddd; padding:15px; margin-bottom:10px">
		<div style="text-align:left; font-size:12px" id ="fileNamediv"><spring:message code='ezWebFolder.t119'/></div>
		<div style="height: 40px; line-height: 40px; margin-top: 10px;">
			<input id="nameInput" type="text" placeholder="<spring:message code='ezWebFolder.t212'/>" style="width: 380px; height: 35px; line-height: 35px; font-size: 12px; padding: 0px 10px; border-radius: 5px; border: 1px solid #ddd;">
		</div>
	</div>	
	<div class="btnpositionNew">
		<a id="btnSave" class="imgbtn" onclick="ok_Click();"><span><spring:message code='ezWebFolder.t116'/></span></a>
	</div>
</body>
</html>