"use strict";
var favoriteContext = (function() {
	
	function toggleAll() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength === 0) {
			alert(messages.strLang5);
			return;
		}
		
		var hasNoFavorite = false;
		var rowElement;
		var i;
		
		for (i = 0; i < selectedLength; i++) {
			if (!selectedRows[i].hasAttribute("favorite")) {
				hasNoFavorite = true;
				break;
			}
		}
		
		var requestAjax = hasNoFavorite ? addFavorite : deleteFavorite;
		var files = [], folders = [], toggleTargetRows = [];
		var rowInfo;
		
		var successHandle = function() {
			var length = toggleTargetRows.length;
			var rowElement, imageElement, i;
			
			for (i = 0; i < length; i++) {
				rowElement = toggleTargetRows[i];
				imageElement = rowElement.querySelector("img:first-child");
				
				toggleImage(rowElement, imageElement);
			}
		};

		for (i = 0; i < selectedLength; i++) {
			rowElement = selectedRows[i];
			
			if (hasNoFavorite && rowElement.hasAttribute("favorite")) {
				continue;
			}
			
			toggleTargetRows.push(rowElement);
			rowInfo = rowContext.getRowInfo(rowElement);
			
			if (rowInfo.type === "F") {
				files.push(rowInfo.id);
			} else {
				folders.push(rowInfo.id);
			}
		}

		requestAjax(files.toString(), folders.toString(), false, successHandle);
	}
	
	function onImageClick(event) {
		event.stopPropagation();
		
		var element = event.target;
		var rowElement = element.parentElement.parentElement;
		var successHandle = function() {
			toggleImage(rowElement, element);
		};
		
		toggleFavorite(rowElement, true, successHandle, successHandle);
	}
	
	function toggleFavorite(rowElement, isAsync, addHandler, deleteHandler) {
		var rowInfo = rowContext.getRowInfo(rowElement);
		var targetId = rowInfo.id;
		var files = "", folders = "";
		
		if (rowInfo.type === "F") {
			files = targetId;
		} else {
			folders = targetId
		}
		
		if (rowInfo.isFavorite) {
			deleteFavorite(files, folders, isAsync, deleteHandler);
		} else {
			addFavorite(files, folders, isAsync, addHandler);
		}
	}
	
	function addFavorite(fileList, folderList, isAsync, successHandler) {
		requestFavoriteAjax("/ezWebFolder/addFavorite.do", isAsync, {
			fileList: fileList,
			folderList: folderList
		}, successHandler);
	}
	
	function deleteFavorite(fileList, folderList, isAsync, successHandler) {
		requestFavoriteAjax("/ezWebFolder/deleteFavorite.do", isAsync, {
			fileList: fileList,
			folderList: folderList
		}, successHandler);
	}
	
	/** private function **/
	
	function toggleImage(rowElement, imageElement) {
		if (rowElement.hasAttribute("favorite")) {
			imageElement.src = "/images/ImgIcon/view-flag.gif";
			rowElement.removeAttribute("favorite");
		} else {
			imageElement.src = "/images/ImgIcon/icon-flag.gif";
			rowElement.setAttribute("favorite", "");
		}
	}
	
	function requestFavoriteAjax(url, isAsync, data, successHandler) {
		$.ajax({
			type: "POST",
			url: url,
			async: isAsync,
			dataType: "json",
			data: data,
			success: function(result) {
				if (result.status === "error") {
					return;
				}
				
				if (result.code === 1) {
					return;
				}
				
				if (successHandler) {
					successHandler();
				}
			}
		});
	}
	
	return {
		onImageClick: onImageClick,
		toggleAll: toggleAll,
		toggleFavorite: toggleFavorite,
		addFavorite: addFavorite,
		deleteFavorite: deleteFavorite
	}
}());