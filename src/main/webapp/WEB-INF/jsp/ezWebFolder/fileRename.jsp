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
</head>
<body class="popup" style="overflow: hidden; opacity: 0; transition: 0.1s all;">
    <h1 id="topMenu"><spring:message code='ezWebFolder.t118'/></h1>
    <div id="close">
        <ul>
            <li><span id="btnCancel" onclick="wClose()"></span></li>
        </ul>
    </div>
    <div>
        <div class="txt mb10" id="fileNamediv"><spring:message code='ezWebFolder.t119'/></div>
        <div>
            <input id="nameInput" maxlength="50" type="text" style="width:100%;">
        </div>
    </div>
    <div class="btnpositionNew">
        <a id="btnSave" class="imgbtn" onclick="ok_Click();"><span><spring:message code='ezWebFolder.t116'/></span></a>
    </div>
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
		window.onload = function() {
			try {
				var currentName = parent.inputNameDlg_cross_dialogArguments.currentName;
				document.getElementById("nameInput").value = currentName;
			} catch (ignore) {}
			document.body.style.opacity = "";
		};
		
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
				if (functionType == "insert" && fileId == 0) {
					alert('<spring:message code='ezWebFolder.t265'/>');
				} else if (functionType == "update" && fileId == 0){
					alert('<spring:message code='ezWebFolder.t304'/>');
				} else {
					alert('<spring:message code='ezWebFolder.t400'/>');
				}
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
        var targetId = "";
        var newName = "";
        
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
            } else if(functionType == "update" && fileId == 0) {
            	$('#topMenu').text("<spring:message code='ezWebFolder.t303'/>");
            	$('#fileNamediv').text('<spring:message code='ezWebFolder.t514'/>');
            } 		
			
			if (functionType != "insert") {
				var currentName = parent.inputNameDlg_cross_dialogArguments.currentName;
				document.getElementById("nameInput").value = currentName;
			}
			
			document.body.style.opacity = "";
		}
		
		function wClose() {
			parent.closeAllPopup();
			window.close();
		}
		
		function afterDeleteSuccess() {
			parent.refreshView();
			try {
				parent.leftFolderUpdate(functionType, fileId, folderUppId, targetId, newName);
			} catch (e) {};
			wClose();
		}
		
		function afterSuccessOnlyFolderManage() {
			parent.refreshView();
			wClose();
		}
		
		function ok_Click() {
			newName = document.getElementById("nameInput").value;
			/* 2020-05-06 홍승비 - 폴더명 앞뒤공백제거 코드 추가 */
			newName = newName.trim();
			
			if (newName == "") {
				if (functionType == "insert" && fileId == 0) {
					alert('<spring:message code='ezWebFolder.t265'/>');
				} else if (functionType == "update" && fileId == 0){
					alert('<spring:message code='ezWebFolder.t304'/>');
				} else {
					alert('<spring:message code='ezWebFolder.t400'/>');
				}
				return;
			}

			if (isValid(newName)) {
				alert('<spring:message code='ezWebFolder.t211'/>');
				return;
			}
				
			if (functionType == "insert" && fileId == 0) {
// 				newName = ReplaceText(newName, " ", "");
	            
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
							targetId = data.data;
							afterDeleteSuccess();
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
						targetId = data.data;
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
							targetId = folderUppId;
							afterDeleteSuccess();
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
						targetId = folderUppId;
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
		}
		</c:otherwise>
		</c:choose>
	</script>
</body>
</html>