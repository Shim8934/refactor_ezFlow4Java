// folder 선택된 id까지 열리고 선택되도록 하는 function 
function selectFolder(targetID) {
	if ( folderType == 'C') {
		$element = '#tree';
	} else if (folderType == 'D') {
		$element = '#treeDept';
	} else if (folderType == 'U') {
		$element = '#treePer';
	}
	
	var jstree = $($element).jstree()
	jstree.settings.core.check_callback = true;
	selectFolderData = targetID;
	$($element).jstree().deselect_all(true); 
	$($element).jstree().select_node(targetID , true); 
}

function insertLeftFolder(parentFolderId, targetId, folderName ) {
    $($element).jstree().settings.core.check_callback = true; 
    $($element).jstree().create_node(parentFolderId, {id:targetId, text:folderName}); 
}

function updateLeftFolder(parentFolderId, targetId, folderName ) {
	$($element).jstree().settings.core.check_callback = true; 
	$($element).jstree().rename_node(targetId, folderName);
}

function deleteLeftFolder(folderList) {
	$($element).jstree().settings.core.check_callback = true; 
	var list = new Array();
	list = folderList.split(",");
	
	var targetId = "";
	for (var i = 0; i < list.length; i++ ) {
		targetId = list[i];
    	$($element).jstree().delete_node(targetId); 
	}
}

// 이동시키려고 하는 폴더 , 이동시킬곳 
function moveLeftFolder(folderList, toTargetId) {
	$($element).jstree().settings.core.check_callback = true;
	var list = new Array();
	list = folderList.split(",");
	
	var targetId = "";
	for (var i = 0; i < list.length; i++ ) {
		targetId = list[i];
    	try {
    		// 이동시키려고 하는 폴더 toTargetId가 있는지 판단하는 조건문
			if ($($element).jstree("get_node", toTargetId)){
				$($element).jstree("move_node",targetId, toTargetId);
			} else {
				// 이동시키려고 하는 폴더가 존재하지 않을시 폴더가 현재 jstree에 나타나지 않도록 삭제 
        		deleteLeftFolder(targetId);
			}

    	} catch(e) {
    		deleteLeftFolder(targetId);
    		console.log(moveTargetId);
    	}
	}
}

function copyLeftFolder(folderListString, toTargetId, folderId) {
	this.folderId = folderId;
	$($element).jstree().settings.core.check_callback = true;
	folderList2(folderType);
}