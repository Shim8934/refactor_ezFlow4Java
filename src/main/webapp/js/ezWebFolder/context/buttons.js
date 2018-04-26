function fileDownload() {
	var selected = getSelectedFoldersAndFiles();

	if (selected === undefined) {
		return;
	}

	var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + selected.files.toString() + "&folderList=" + selected.folders.toString();

	AttachDownFrame.location.href = downloadUrl;
}

function refreshView() {
	getFileList(folderId);
}

function fileDelete() {
	var selected = getSelectedFoldersAndFiles();

	if (selected === undefined) {
		return;
	}

	if (selected.folders.length > 0) {
		alert("<spring:message code = 'ezWebFolder.t20'/>");
		return;
	}

	$.ajax({
		type : "POST",
		url : "/ezWebFolder/checkPermission.do",
		data : {
			"fileList" : selected.files.toString()
		},
		dataType : "JSON",
		async : true,
		success : function(data) {
			var result = data.resultValue;

			if (result != "ok") {
				alert("<spring:message code='ezWebFolder.t243'/>");
			} else {
				DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + selected.files.toString());
			}

			refreshView();
		},
		error : function(error) {
			alert("<spring:message code='ezWebFolder.t134'/>" + error);
		}
	});
}

function fileRename() {
	var selected = getSelectedFoldersAndFiles();

	if (selected === undefined) {
		return;
	}

	if (selected.folders.length > 0) {
		alert("<spring:message code = 'ezWebFolder.t20'/>");
		return;
	}

	if (selected.files.length > 1) {
		alert("<spring:message code = 'ezWebFolder.t115'/>");
		return;
	}

	var fileId = selected.files[0];

	$.ajax({
		type : "POST",
		url : "/ezWebFolder/checkPermission.do",
		data : {
			"fileId" : fileId
		},
		dataType : "JSON",
		async : true,
		success : function(data) {
			var result = data.resultValue;

			if (result != "ok") {
				alert("<spring:message code='ezWebFolder.t243'/>");
			} else {
				DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
			}
		},
		error : function(error) {
			alert("<spring:message code='ezWebFolder.t134'/>" + error);
		}
	});
}

function fileMove() {
	var selected = getSelectedFoldersAndFiles();

	if (selected === undefined) {
		return;
	}

	if (selected.folders.length > 0) {
		alert("<spring:message code = 'ezWebFolder.t20'/>");
		return;
	}

	DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + selected.files.toString());
}

function getSelectedFoldersAndFiles() {
	var selectedRows = rowModule.getSelectedRows();
	var selectedLength = selectedRows.length;

	if (selectedLength <= 0) {
		alert("<spring:message code = 'ezWebFolder.t108'/>");
		return undefined;
	}

	var files = [];
	var folders = [];
	var rowInfo;

	for (var i = 0; i < selectedLength; i++) {
		rowInfo = rowModule.getRowInfo(selectedRows[i]);

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