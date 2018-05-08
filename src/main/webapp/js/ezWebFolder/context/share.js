var shareContext = (function() {
	
	function addShareView() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength == 0) {
			alert(messages.strLang5);
			return;
		}
		
		if (selectedLength > 1) {
			alert("하나만 선택하세요.");
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
	
//	function toggleAll() {
//		var selectedRows = rowContext.getSelectedRows();
//		var selectedLength = selectedRows.length;
//		
//		if (selectedLength === 0) {
//			alert(messages.strLang5);
//			return;
//		}
//		
//		var hasNoFavorite = false;
//		var i;
//		
//		for (i = 0; i < selectedLength; i++) {
//			if (!selectedRows[i].hasAttribute("favorite")) {
//				hasNoFavorite = true;
//				break;
//			}
//		}
//		
//		var requestAjax = hasNoFavorite ? addFavorite : deleteFavorite;
//		var rowElement, imageElement, successHandle, rowInfo;
//		
//		for (i = 0; i < selectedLength; i++) {
//			rowElement = selectedRows[i];
//			imageElement = rowElement.querySelector("img:first-child");
//			successHandle = function() {
//				toggleImage(rowElement, imageElement);
//			};
//			
//			rowInfo = rowContext.getRowInfo(selectedRows[i]);
//			requestAjax(rowInfo.id, rowInfo.type, false, successHandle);
//		}
//	}
	
//	function onImageClick(element) {
//		event.stopPropagation();
//		
//		var rowElement = element.parentElement.parentElement;
//		var successHandle = function() {
//			toggleImage(rowElement, element);
//		};
//		
//		toggleFavorite(rowElement, true, successHandle, successHandle);
//	}
	
//	function toggleFavorite(rowElement, isAsync, addHandler, deleteHandler) {
//		var rowInfo = rowContext.getRowInfo(rowElement);
//		
//		if (rowInfo.isFavorite) {
//			deleteFavorite(rowInfo.id, rowInfo.type, isAsync, deleteHandler);
//		} else {
//			addFavorite(rowInfo.id, rowInfo.type, isAsync, addHandler);
//		}
//	}
	
	/** private function **/
	
//	function toggleImage(rowElement, imageElement) {
//		if (rowElement.hasAttribute("favorite")) {
//			imageElement.src = "/images/ImgIcon/view-flag.gif";
//			rowElement.removeAttribute("favorite");
//		} else {
//			imageElement.src = "/images/ImgIcon/icon-flag.gif";
//			rowElement.setAttribute("favorite", "");
//		}
//	}
	
	function requestShareAjax(url, isAsync, data, successHandler) {
		$.ajax({
			type: "POST",
			url: url,
			async: isAsync,
			dataType: "json",
			data: data,
			success: function(result) {
				if (result.status === "error") {
					alert(messages.strLang7 + " code:" + result.code);
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
//		onImageClick: onImageClick,
//		toggleAll: toggleAll,
//		toggleFavorite: toggleFavorite,
		addShareView: addShareView,
		showShareInfo: showShareInfo,
		showHiddenSharedList: showHiddenSharedList,
		addShare: addShare,
		deleteShare: deleteShare,
		hideShare: hideShare,
		showShare: showShare
	}
}());