var shareContext = (function() {
	
	function addShareView() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength == 0) {
			alert(messages.strLang5);
			return;
		}
		
		if (selectedLength > 1) {
			alert(messages.strLang23);
			return;
		}
		
		var rowInfo = rowContext.getRowInfo(selectedRows[0]);
		
		var openWindow = window.open("/ezWebFolder/addShareView.do?folderFileId=" + rowInfo.id + "&folderFileType=" + rowInfo.type, "addShareView", GetOpenWindowfeature(610, 685));
        try { openWindow.focus(); } catch (e) { }
	}
	
	function showShareInfo(target) {
		var folderFileId = $(target).closest('tr').attr("targetId");
		var folderFileType = $(target).closest('tr').attr("targetType");
		
		var openWindow = window.open("/ezWebFolder/showShareInfo.do?folderFileId=" + folderFileId + "&folderFileType=" + folderFileType, "shareInfo", GetOpenWindowfeature(400, 450));
        try { openWindow.focus(); } catch (e) { }
	}
	
	function showHiddenSharedList(pPage) {
		location.href = "/ezWebFolder/webfolderHiddenSharedList.do";
	}
	
	function addShare(folderFileId, folderFileType, depts, users, isAsync, successHandle) {
		requestShareAjax("/ezWebFolder/addShare.do", isAsync, {
			folderFileId: folderFileId,
			folderFileType: folderFileType,
			deptList: depts.toString(),
			userList: users.toString()
		}, successHandle);
	}
	
	function deleteShare() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength == 0) {
			alert(messages.strLang5);
			return;
		}
		
		var files = [], folders = [];
		var rowInfo;
		
		for (i = 0; i < selectedLength; i++) {
			rowInfo = rowContext.getRowInfo(selectedRows[i]);
			
			if (rowInfo.type === "F") {
				files.push(rowInfo.id);
			} else {
				folders.push(rowInfo.id);
			}
		}
		
		requestShareAjax("/ezWebFolder/deleteShare.do", false, {
			fileList: files.toString(),
			folderList: folders.toString()
		}, refreshView);
	}
	
	function hideShare() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength == 0) {
			alert(messages.strLang5);
			return;
		}
		
		var files = [], folders = [];
		var rowInfo;
		
		for (i = 0; i < selectedLength; i++) {
			rowInfo = rowContext.getRowInfo(selectedRows[i]);
			
			if (rowInfo.type === "F") {
				files.push(rowInfo.id);
			} else {
				folders.push(rowInfo.id);
			}
		}
		
		requestShareAjax("/ezWebFolder/hideShare.do", false, {
			fileList: files.toString(),
			folderList: folders.toString()
		}, refreshView);
	}
	
	function showShare() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength == 0) {
			alert(messages.strLang5);
			return;
		}
		
		var files = [], folders = [];
		var rowInfo;
		
		for (i = 0; i < selectedLength; i++) {
			rowInfo = rowContext.getRowInfo(selectedRows[i]);
			
			if (rowInfo.type === "F") {
				files.push(rowInfo.id);
			} else {
				folders.push(rowInfo.id);
			}
		}
		
		requestShareAjax("/ezWebFolder/showShare.do", false, {
			fileList: files.toString(),
			folderList: folders.toString()
		}, refreshView);
	}
	
	function requestShareAjax(url, isAsync, data, successHandler) {
		$.ajax({
			type: "POST",
			url: url,
			async: isAsync,
			dataType: "json",
			data: data,
			success: function(result) {
				if (result.status != "ok") {
					if (result.code == 1) {
						console.log(messages.strLang24);
						return;
					} else if (result.code == 2) {
						alert(messages.strLang7);
						return;
					} else if (result.code == 3) {
						alert(messages.strLang25);
						return;
					} else {
						alert(messages.strLang7 + " code:" + result.code);
						return;
					}
				}
				
				if (successHandler) {
					successHandler();
				}
			},
			error : function(error) {
				alert(messages.strLang7);
			}
		});
	}
	
	return {
		addShareView: addShareView,
		showShareInfo: showShareInfo,
		showHiddenSharedList: showHiddenSharedList,
		addShare: addShare,
		deleteShare: deleteShare,
		hideShare: hideShare,
		showShare: showShare
	}
}());