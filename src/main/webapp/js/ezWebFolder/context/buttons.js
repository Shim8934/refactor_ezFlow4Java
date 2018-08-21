var buttons = (function() {
	function getSelectedFoldersAndFiles() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength <= 0) {
			alert(messages.strLang5);
			return undefined;
		}
		
		var files  = [];
		var folders = [];
		var rowInfo;
		
		for (var i = 0; i < selectedLength; i++) {
			rowInfo = rowContext.getRowInfo(selectedRows[i]);
			
			if (rowInfo.type === 'D') {
				folders.push(rowInfo.id);
			} else {
				files.push(rowInfo.id);
			}
		}
		
		return {
			folders : folders,
			files : files
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
				return;
			}
			
			if (selected.folders.length > 0) {
				alert(messages.strLang1);
				return;
			}
				
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission.do",
				data: {
					"fileList" : selected.files.toString()
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.status;
					
					if (result != "ok") {
						alert(messages.strLang13);
					} else {
						openLeftPanel();
						DivPopUpShow(450, 250, "/ezWebFolder/deleteConfirm.do?fileList=" + selected.files.toString());
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
			
			if (selected.folders.length > 0) {
				alert(messages.strLang1);
				return;
			}
			
			if (selected.files.length > 1) {
				alert(messages.strLang6);
				return;
			}
			
			var fileId = selected.files[0];
			
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
						alert(messages.strLang13);
					} else {
						openLeftPanel();
						DivPopUpShow(450, 250, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
					}
				},
				error : function(error) {
					alert(messages.strLang7 + error);
				}
			});
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
	};
})();

