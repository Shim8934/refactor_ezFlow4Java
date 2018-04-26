var favoriteContext = (function() {
	
	function toggleAll() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength === 0) {
			return;
		}
		
		var hasNoFavorite = false;
		var i;
		
		for (i = 0; i < selectedLength; i++) {
			if (!selectedRows[i].hasAttribute("favorite")) {
				hasNoFavorite = true;
				break;
			}
		}
		
		var requestAjax = hasNoFavorite ? addFavorite : deleteFavorite;
		var rowElement, imageElement, successHandle, rowInfo;

		for (i = 0; i < selectedLength; i++) {
			rowElement = selectedRows[i];
			imageElement = rowElement.querySelector("img:first-child");
			successHandle = function() { toggleImage(rowElement, imageElement); };
			rowInfo = rowContext.getRowInfo(selectedRows[i]);
			
			requestAjax(rowInfo.id, rowInfo.type, false, successHandle);
		}
	}
	
    function onImageClick(element) {
    	event.stopPropagation();
    	
    	var rowElement = element.parentElement.parentElement;
    	var successHandle = function() { toggleImage(rowElement, element); };
    	
    	toggleFavorite(rowElement, true, successHandle, successHandle);
    }
    
    function toggleFavorite(rowElement, isAsync, addHandler, deleteHandler) {
    	var rowInfo = rowContext.getRowInfo(rowElement);

		if (rowInfo.isFavorite) {
			deleteFavorite(rowInfo.id, rowInfo.type, isAsync, deleteHandler);
		} else {
			addFavorite(rowInfo.id, rowInfo.type, isAsync, addHandler);
		}
	}
    
    function addFavorite(targetId, targetType, isAsync, successHandler) {
    	requestFavoriteAjax("/ezWebFolder/addFavorite.do", isAsync, {targetId: targetId, targetType: targetType}, successHandler);
    }
    
    function deleteFavorite(targetId, targetType, isAsync, successHandler) {
    	requestFavoriteAjax("/ezWebFolder/deleteFavorite.do", isAsync, {targetId: targetId, targetType: targetType}, successHandler);
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
			type : "POST",
			url : url,
			async : isAsync,
			dataType : "json",
			data : data,
			success : function(result) {
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
		onImageClick : onImageClick,
    	toggleAll : toggleAll,
		toggleFavorite : toggleFavorite,
		addFavorite : addFavorite,
		deleteFavorite : deleteFavorite
	}
}());