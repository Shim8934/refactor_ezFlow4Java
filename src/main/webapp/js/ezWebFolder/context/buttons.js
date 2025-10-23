var buttons = (function() {
	function add_onclick_Complete(szName) {
		DivPopUpHidden();
		refreshView();
	}
	function getPathSplit (data) {
		var jbSplit = data.split('/');
		return jbSplit;
	}
	function getSelectedFoldersAndFiles(ignoreAlert) {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (!ignoreAlert && selectedLength <= 0) {
			alert(messages.strLang38);
			return undefined;
		}
		
		var files  = [];
		var folders = [];
		var creater = [];
		var targetFunction = [];
		var targetPath = [];
		var rowInfo;
		
		for (var i = 0; i < selectedLength; i++) {
			rowInfo = rowContext.getRowInfo(selectedRows[i]);
			
			if (rowInfo.type === 'D') {
				folders.push(rowInfo.id);
				creater.push(rowInfo.creator);
				targetFunction.push(rowInfo.targetFunction);
				functionType = targetFunction[0];
				targetPath.push(getPathSplit(rowInfo.targetPath).length);
			} else {
				files.push(rowInfo.id);
			}
		}
		
		return {
			folders : folders,
			files : files,
			creater : creater,
			targetFunction : targetFunction ,
			targetPath : targetPath
		}
	}

	return {
		fileDownload: function() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			var selectedFileId = selected.files[0];
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission_y.do",
				data: {
					"fileList" : selected.files.toString(),
					"folderList" : selected.folders.toString()
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.status;
					
					if (result != "ok" && data.code == "3") {
						alert(messages.strLang25);
					} else if (data.code == "1") {
						alert(messages.strLang7);
					} else {
						/* var rowElem = rowContext.getRowElement(selectedFileId);
						
						if (rowElem.getAttribute("encryptedFlag") === "1") {
							unidocsWebViewerOpen(selectedFileId);
						} else { */
							var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + selected.files.toString() + "&folderList=" + selected.folders.toString();
							AttachDownFrame.location.href = downloadUrl;
						//}
					}
				},
				error : function(error) {
					alert(messages.strLang7 + error);
				}
			});
		},
		filePreview: function() {
			var selected = getSelectedFoldersAndFiles(true);

			if (selected.folders.length > 0) {
				alert(messages.strLang1);
				return;
			}

			if (selected.files.length == 0) {
				alert(messages.strLang5);
				return;
			}

			if (selected.files.length > 1) {
				alert(messages.strLang6);
				return;
			}

			var fileId = selected.files[0];

			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission_y.do",
				data: { "fileList" : fileId, "folderList" : "" },
				dataType: "JSON",
				success : function(data) {
					if (data.status != "ok" && data.code == "3") {
						alert(messages.strLang25);
					} else if (data.code == "1") {
						alert(messages.strLang7);
					} else {
						$.ajax({
							type: "GET",
							url: "/ezWebFolder/filePreview.do",
							data: { "fileId" : fileId },
							dataType: "JSON",
							success: function(previewData) {
								if (previewData.status == "ok") {
									if (previewData.code == 1) {
										alert(messages.unsupportedFormat);
										return;
									}

									window.open(previewData.data, "_blank", GetOpenWindowfeature(1100, 950));
								} else {
									alert(messages.strLang7);
								}
							},
							error : function(error) {
								alert(messages.strLang7 + error);
							}
						});
					}
				},
				error : function(error) {
					alert(messages.strLang7 + error);
				}
			});
		},
		fileUpload: function() {
			document.getElementById("file").click();
		},
		
		fileDelete: function() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			if (selected.files.length < 1 && selected.folders.length < 1 ) {
				alert(messages.strLang39);
				return;
			}
			var fileId = selected.files[0];
			var selectedFolderId = selected.folders[0];
			
			var targetPathLength = selected.targetPath;
			var selectedCreatorId = selected.creater[0]
			
			if (selected.targetFunction[0] != null || selected.targetFunction[0] == "") {
				folderType = selected.targetFunction[0];
			}
			
			if (folderType == "C" && parentId == 'root' && !(window.checkIsManager && checkIsManager(selected.folders))) {
				alert(messages.strLang36);
				return;
			}
			
			if (targetPathLength[0] < 1) {
				alert(messages.strLang35);
				return;
			}
			
			/*if (hasContainsReplyFiles(selected.files)) {
				alert(messages.replyFileDelete);
				return;
			}*/
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission.do",
				data: {
					"fileList" : selected.files.toString(),
					"folderList" : selected.folders.toString(),
					"isRecursive" : true
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.status;
					
					if (result != "ok") {
						alert(messages.strLang41);
					} else {
						openLeftPanel();
						DivPopUpShow(450, 180, "/ezWebFolder/deleteConfirm.do?fileList=" + selected.files.toString()+"&folderList=" + selected.folders.toString());
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
			
			if (selected.files.length + selected.folders.length > 1) {
				alert(messages.strLang39);
				return;
			}
			
			if (folderType == "C" && parentId == 'root' && !(window.checkIsManager && checkIsManager(selected.folders))) {
				alert(messages.strLang36);
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
							alert(messages.strLang42);
						} else {
							var nameTd = rowContext.getRowElement(fileId).querySelector(".wfFileName");
							var currentName = nameTd.getAttribute("title");
							var fileExt = nameTd.getAttribute("ext");

							if (fileExt && fileExt != ".none") {
								currentName = currentName.substr(0, currentName.length - fileExt.length - 1);
							}
							
							inputNameDlg_cross_dialogArguments.currentName = currentName;
							inputNameDlg_cross_dialogArguments[0] = folderId;
							inputNameDlg_cross_dialogArguments[3] = "update";
							openLeftPanel();
							DivPopUpShow(450, 200, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
				
			} else {
				if (selected.targetFunction[0] != null || selected.targetFunction[0] == "") {
					folderType = selected.targetFunction[0];
				}
				var targetPathLength = selected.targetPath;
				var selectedCreatorId = selected.creater[0];
				
				if (folderId == "root" || targetPathLength[0] < 1) {
					alert(messages.strLang35);
					return;
				}
				
				functionType = "update";
				
				if (folderId.indexOf("_") > -1) {
					folderId = folderId.substring(0, folderId.indexOf("_"));
				}
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/checkPermission.do",
					data: {
						"folderList" : selectedFolderId
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						if (data.status == "ok") {
							var nameTd = rowContext.getRowElement(selectedFolderId).querySelector(".wfFileName");
							var currentName = nameTd.getAttribute("title");
							inputNameDlg_cross_dialogArguments.currentName = currentName;
							inputNameDlg_cross_dialogArguments[0] = selectedFolderId;
							inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
							inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
							inputNameDlg_cross_dialogArguments[3] = functionType;
							openLeftPanel();
							DivPopUpShow(450, 200, "/ezWebFolder/fileRenameConfirm.do?fileId=0");
						} else {
							alert(messages.strLang42);
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					},
					complete: function() {
						functionType = "";
					}
				});
				
			}
		},
		
		fileMoveAndCopy: function() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			if (folderType == "C" && parentId == 'root' && !(window.checkIsManager && checkIsManager(selected.folders))) {
				alert(messages.strLang36);
				return;
			}
			
			for (var i = 0; i < selected.folders.length; i++) {
				if (selected.targetFunction[i] != null || selected.targetFunction[i] == "") {
					folderType = selected.targetFunction[i];
				}
				
				var targetPathLength = selected.targetPath;
				
				if (targetPathLength[i] < 1) {
					alert(messages.strLang35);
					return;
				}
			}
			
			if (window.showProgress) {
				showProgress();
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
					var isPermitted = data.status == "ok";
					if (!isPermitted) {
						$.ajax({
							type: "POST",
							url: "/ezWebFolder/checkPermission_y.do",
							data: {
								"fileList" : selected.files.toString(),
								"folderList" : selected.folders.toString()
							},
							dataType: "JSON",
							async: false,
							success : function(data) {
								isPermitted = data.status == "ok";
							}
						});
					}

					var isMultiple = selected.folders.length + selected.files.length > 1;

					if (!isPermitted) {
						if (window.hideProgress) {
							hideProgress();
						}
						
						setTimeout(function() {
							alert(isMultiple ? messages.permissionErrorContains : messages.permissionError);
						}, 10);
						return;
					}
					
					// 폴더 권한 비상속 체크
					var isNotInherit = false;

					$.ajax({
						type: "POST",
						url: "/ezWebFolder/checkNotInherit.do",
						data: {
							"fileList" : selected.files.toString(),
							"folderList" : selected.folders.toString()
						},
						dataType: "JSON",
						async: false,
						success : function(data) {
							isNotInherit = Boolean(data.result);
						}
					});
					
					if (window.hideProgress) {
						hideProgress();
					}
					
					if (isNotInherit) {
						alert(isMultiple ? messages.moveFromNotInheritErrorContains : messages.moveFromNotInheritError);
						return;
					}
					
					var params = [];
					
					if (selected.files.length > 0) {
						params.push("fileList=" + encodeURIComponent(selected.files.toString()));
					}
					
					if (selected.folders.length > 0) {
						params.push("folderList=" + encodeURIComponent(selected.folders.toString()));
					}
					
					if (folderTypeCheck === undefined || !folderTypeCheck ) {
						folderTypeCheck = "N";
					} 
					params.push("folderTypeCheck=" + folderTypeCheck);
					params.push("folderType=" + folderType);
					
					openLeftPanel();
					DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?" + params.join("&"));
				}
			});
		},
		
		fileCopy: function() {
			var selectedRows = rowContext.getSelectedRows();
			var selectedLength = selectedRows.length;
			var selected ;
			
			if (selectedLength <= 0) {
				alert(messages.strLang1);
				selected = undefined;
			} else {
				selected = getSelectedFoldersAndFiles();
			}
			
			if (selected === undefined) {
				return;
			}
			
			if (selected.folders.length > 0) {
				alert(messages.strLang1);
				return;
			}
			
			if (folderTypeCheck === undefined || !folderTypeCheck ) {
				folderTypeCheck = "N";
			}
			
			openLeftPanel();
			DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + selected.files.toString() + "&type=copy&folderTypeCheck=" + folderTypeCheck);
		},
		
		newFolder: function() {
		
			if (folderId == "") {
				alert(messages.strLang38);
				return;
			}
			
			if (folderType == "C") {
				if (parentId == 'root' || parentId == undefined ) {
					alert(messages.strLang36);
					return;
				}
//				if (parentId == 'root' || targetPathLength[0] < 2) {
//					alert(messages.strLang36);
//					return;
//				}
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
			DivPopUpShow(450, 200,  "/ezWebFolder/fileRenameConfirm.do?fileId=0");
			functionType = "";
		},
		
		openFileVersionHistory: function() {
			var selectedRows = rowContext.getSelectedRows();
			var selectedLength = selectedRows.length;
			
			if (selectedLength == 0) {
				alert(messages.strLang5);
				return;
			} else if (selectedLength > 1) {
				alert(messages.strLang6);
				return;
			}
			
			var rowInfo = rowContext.getRowInfo(selectedRows[0]);
			
			if (rowInfo.type == 'F') {
				openLeftPanel();
				DivPopUpShow(450, 405, "/ezWebFolder/fileVersionManage.do?fileId=" + rowInfo.id);
			} else {
				alert(messages.strLang1);
			}
		},
		
		openReply: function() {
			var selectedRows = rowContext.getSelectedRows();
			var selectedLength = selectedRows.length;
			
			if (selectedLength == 0) {
				alert(messages.strLang5);
				return;
			} else if (selectedLength > 1) {
				alert(messages.strLang6);
				return;
			}
			
			var rowInfo = rowContext.getRowInfo(selectedRows[0]);
			
			if (rowInfo.type == 'F') {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/selectedFolderCheckPermission.do",
					data: {
						"fileId" : rowInfo.id
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						if (data.status != "ok" && data.code == "3") {
							alert(messages.strLang25);
						} else if (data.code == "1") {
							alert(messages.strLang7);
						} else {
							openLeftPanel();
							DivPopUpShow(300, 220, "/ezWebFolder/webfolderReply.do?fileId=" + rowInfo.id);
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
			} else {
				alert(messages.strLang1);
			}
		}
	};
})();

function optionView(obj) {
	if (obj.getAttribute("mode") == "off") {
		var isWfOptionDiv = $("#wfOptionDiv").length > 0;	//  2021-04-28 김은실 - #20200 공유폴더 > 리스트 선택박스 나타나지 않음.
		var a_left = isWfOptionDiv? $("#wfOptionDiv").offset().left - ($("#layer_Viewpopup").width() - $("#wfOptionDiv").width()) 
									: document.documentElement.clientWidth - 260 + "px";
		var a_top = isWfOptionDiv? $("#wfOptionDiv").offset().top + $("#wfOptionDiv").height() + 2 : "130px";
		document.getElementById("layer_Viewpopup").style.display = "";
		obj.setAttribute("class", "icon16 btn_onarrow_down");
		obj.setAttribute("mode", "on");
		$("#layer_Viewpopup").css({"left":a_left, "top":a_top});
	} else {
		optionHidden();
	}
}

function optionHidden() {
	document.getElementById("layer_Viewpopup").style.display = "none";
	document.getElementById("webfolderlistoptiondiv").setAttribute("mode", "off");
	document.getElementById("webfolderlistoptiondiv").setAttribute("class", "icon16 btn_arrow_down");
}
