var favoriteModule = (function() {
	
	function onCheckAllClick() {
		var selectedRows = rowModule.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength === 0) {
			return;
		}
		
		var hasNoFavorite = false;
		var index;
		
		for(index = 0; index < selectedLength; index++) {
			if (!selectedRows[index].hasAttribute("favorite")) {
				hasNoFavorite = true;
				break;
			}
		}
		
		var excute = hasNoFavorite ? addFavorite : deleteFavorite;
		var rowInfo;
		
		var length = selectedRows.length;

		for (index = 0; index < length; index++) {
			rowInfo = getRowInfo(selectedRows[index]);
			excute(rowInfo.targetId, rowInfo.targetType, false);
		}
		
		refreshView();
	}
	
    function onImageClick(event) {
    	event.stopPropagation();
    	
    	var imageElement = event.target;
    	var rowElement = imageElement.parentElement.parentElement;
    	
    	toggleFavorite(rowElement, context.refreshList, context.refreshList);
    }
    
	function getRowInfo(rowElement) {
    	var targetId = rowElement.getAttribute("_fileId");
    	var targetType = rowElement.getAttribute("_type");
    	var isFavorite = rowElement.hasAttribute("favorite");
    	
    	// favorite type mapping
    	targetType = targetType === "folder" ? targetType = "D" : targetType = "F";
    	
    	return {
        	targetId: targetId,
        	targetType: targetType,
        	isFavorite: isFavorite
    	}
	}
	
	// TODO 이 윗줄부터 click event라서 jsp로 옮겨야 할지 말지 고민 중
	// 또한 attribute 이름을 통일시켜야함. targetId, targetPath, targetType, favorite 으로 통일 예정
	// 통일 시 변수로 따로 저장해도 괜찮을듯
    
    function toggleFavorite(rowElement, isAsync, addHandler, deleteHandler) {
    	var targetId = rowElement.getAttribute("targetId");
    	var targetType = rowElement.getAttribute("targetType");
    	
    	if (rowElement.hasAttribute("favorite")) {
    		deleteFavorite(targetId, targetType, isAsync, deleteHandler);
    	} else {
    		addFavorite(targetId, targetType, isAsync, addHandler);
    	}
    }
    
    function addFavorite(targetId, targetType, isAsync, successHandler) {
        requestAjax("/ezWebFolder/addFavorite.do", isAsync, {targetId: targetId, targetType: targetType}, successHandler);
    }
    
    function deleteFavorite(targetId, targetType, isAsync, successHandler) {
    	requestAjax("/ezWebFolder/deleteFavorite.do", isAsync, {targetId: targetId, targetType: targetType}, successHandler);
    }
    
    function requestAjax(url, isAsync, data, successHandler) {
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
}());