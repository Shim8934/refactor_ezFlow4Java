var buttons = (function() {
	function add_onclick_Complete(szName) {
		DivPopUpHidden();
		refreshView();
	}
	function getSelectedFoldersAndFiles() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength <= 0) {
			alert(messages.strLang5);
			return undefined;
		}
		
		var files  = [];
		var folders = [];
		var creater = [];
		var rowInfo;
		
		for (var i = 0; i < selectedLength; i++) {
			rowInfo = rowContext.getRowInfo(selectedRows[i]);
			
			if (rowInfo.type === 'D') {
				folders.push(rowInfo.id);
				creater.push(rowInfo.creator);
			} else {
				files.push(rowInfo.id);
			}
		}
		
		return {
			folders : folders,
			files : files,
			creater : creater
		}
	}
	
	return {
		fileDownload: function() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + selected.files.toString() + "&folderList=" + selected.folders.toString();
			
			AttachDownFrame.location.href = downloadUrl;
		},
		
		fileUpload: function() {
			document.getElementById("file").click();
		},
		
		fileDelete: function() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				alert(messages.strLang38);
				return;
			}
			
			if (selected.files.length < 1 && selected.folders.length < 1 ) {
				alert(messages.strLang38);
				return;
			}
				
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission.do",
				data: {
					"fileList" : selected.files.toString(),
					"folderList" : selected.folders.toString()
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.status;
					
					if (result != "ok") {
						alert(messages.strLang30);
					} else {
						openLeftPanel();
						DivPopUpShow(450, 250, "/ezWebFolder/deleteConfirm.do?fileList=" + selected.files.toString()+"&folderList=" + selected.folders.toString());
					}
					
				},
				error : function(error) {
					alert(messages.strLang7 + error);
				}
			});
		},
		
		fileRename: function() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			if (selected.files.length > 1 || selected.folders.length > 1 ) {
				alert(messages.strLang38);
				return;
			}
			
			var fileId = selected.files[0];
			var selectedFolderId = selected.folders[0];
			
			if (fileId != null ) {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/checkPermission.do",
					data: {
						"fileId" : fileId
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.status;
						
						if (result != "ok") {
							alert(messages.strLang30);
						} else {
							openLeftPanel();
							DivPopUpShow(450, 250, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
				
			} else {
				var selectedCreatorId = selected.creater[0];
				if (folderType == "S") {
					if (parentId == 'root') {
						alert(messages.strLang34);
						return;
					}
				} else if (folderType == "C") {
					if (parentId == 'root') {
						alert(messages.strLang36);
						return;
					}
				} else {
					if (folderId == "root") {
						alert(messages.strLang35);
						return;
					}
				}
				
				if (selectedCreatorId != userId) {
					alert(messages.strLang37);
					return;
				}
				
				var functionType = "update";
				
				if (folderId.indexOf("_") > -1) {
					folderId = folderId.substring(0, folderId.indexOf("_"));
				}
				
				inputNameDlg_cross_dialogArguments[0] = selectedFolderId;
				inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
				inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
				inputNameDlg_cross_dialogArguments[3] = functionType;
				openLeftPanel();
				DivPopUpShow(450, 250, "/ezWebFolder/fileRenameConfirm.do?fileId=0");
				
			}
			functionType = "";
		},
		
		fileMoveAndCopy: function() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			if (selected.folders.length > 0) {
				alert(messages.strLang1);
				return;
			}
			
			openLeftPanel();
			DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + selected.files.toString());
		},
		
		fileCopy: function() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			if (selected.folders.length > 0) {
				alert(messages.strLang1);
				return;
			}
			
			openLeftPanel();
			DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + selected.files.toString() + "&type=copy");
		},
		
		newFolder: function() {
		
			if (folderId == "") {
				alert(messages.strLang38);
				return;
			}
			
			if (folderType == "C") {
				if (parentId == 'root' || parentId == undefined) {
					alert(messages.strLang36);
					return;
				}
			}
			
			functionType = "insert";
			
			if (folderId.indexOf("_") > -1) {
				folderId = folderId.substring(0, folderId.indexOf("_"));
			}
			
			var folderName1 = "";
			var folderName2 = "";
			functionType = "insert";
			inputNameDlg_cross_dialogArguments[0] = folderId;
			inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
			inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
			inputNameDlg_cross_dialogArguments[3] = "insert";
			inputNameDlg_cross_dialogArguments[4] = folderName1;
			inputNameDlg_cross_dialogArguments[5] = folderName2;
			openLeftPanel();
			DivPopUpShow(450, 250,  "/ezWebFolder/fileRenameConfirm.do?fileId=0");
			functionType = "";
		}
	};
})();

