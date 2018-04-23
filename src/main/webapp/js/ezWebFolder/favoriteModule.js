var favoriteModule = (function() {
	
	function onCheckAllClick() {
		var selectedRows = rowModule.getSelectedRows();
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
			rowInfo = getRowInfo(selectedRows[i]);
			
			requestAjax(rowInfo.id, rowInfo.type, false, successHandle);
		}
	}
	
    function onImageClick(element) {
    	event.stopPropagation();
    	
    	var rowElement = element.parentElement.parentElement;
    	var successHandle = function() { toggleImage(rowElement, element); };
    	
    	toggleFavorite(rowElement, true, successHandle, successHandle);
    }
    
	function getRowInfo(rowElement) {
    	var targetId = rowElement.getAttribute("targetId");
    	var targetType = rowElement.getAttribute("targetType");
    	var isFavorite = rowElement.hasAttribute("favorite");
    	
    	// favorite type mapping
    	if (targetType.length > 1) {
        	targetType = targetType === "folder" ? targetType = "D" : targetType = "F";
    	}
    	
    	return {
        	id: targetId,
        	type: targetType,
        	isFavorite: isFavorite
    	}
	}
	
	function toggleImage(rowElement, imageElement) {
		if (rowElement.hasAttribute("favorite")) {
			imageElement.src = "/images/ImgIcon/view-flag.gif";
			rowElement.removeAttribute("favorite");
		} else {
			imageElement.src = "/images/ImgIcon/icon-flag.gif";
			rowElement.setAttribute("favorite", "");
		}
	}
	
	// TODO 이 윗줄부터 click event라서 jsp로 옮겨야 할지 말지 고민 중
	// 또한 attribute 이름을 통일시켜야함. targetId, targetPath, targetType, favorite 으로 통일 예정
	// 통일 시 변수로 따로 저장해도 괜찮을듯 
    function toggleFavorite(rowElement, isAsync, addHandler, deleteHandler) {
    	var rowInfo = getRowInfo(rowElement);

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
		onCheckAllClick : onCheckAllClick,
		onImageClick : onImageClick,
		getRowInfo : getRowInfo,
		toggleFavorite : toggleFavorite,
		addFavorite : addFavorite,
		deleteFavorite : deleteFavorite
	}
}());