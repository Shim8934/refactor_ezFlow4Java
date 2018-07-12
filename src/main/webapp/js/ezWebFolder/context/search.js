"use strict";
var searchContext = (function() {
	
	var isSearchPage = false;
	
	var fileType = "";
	var requirement = {
		startDate: "",
		endDate: "",
		name: "",
		creatorName: "",
		extension: ""
	}

	/** event handler **/
	
	var onSearchPageEnableEventHandler = function() {};
	var onSearchPageDisableEventHandler = function() {};
	var onSearchStartEventHandler = function() {};
	var onFileTypeChangeEventHandler = function() {};
	
	/** public function **/
	
	// 외부에서 requirement json 오브젝트 변수에 직접 접근하지 못하도록 값을 복사해서 캡슐화함
	function getCurrentRequirement() {
		return {
			startDate: requirement.startDate,
			endDate: requirement.endDate,
			name: requirement.name,
			creatorName: requirement.creatorName,
			extension: requirement.extension
		}
	}
	
	function getFileType() {
		return fileType;
	}
	
	function setFileType(value) {
		if (fileType === value) {
			return;
		}
		
		fileType = value;
		onFileTypeChangeEventHandler();
	}
	
	function setSearchPageEnableEventHandler(handler) {
		onSearchPageEnableEventHandler = handler;
	}
	
	function setSearchPageDisableEventHandler(handler) {
		onSearchPageDisableEventHandler = handler;
	}
	
	function setSearchStartEventHandler(handler) {
		onSearchStartEventHandler = handler;
	}
	
	function setFileTypeChangeEventHandler(handler) {
		onFileTypeChangeEventHandler = handler;
	}
	
	function isSearchPage() {
		return isSearchPage;
	}
	
	function clearRequirement() {
		setRequirement("", "", "", "", "", "");
		
		if (isSearchPage) {
			isSearchPage = false;
			onSearchPageDisableEventHandler();
		}
	}
	
	function search(startDate, endDate, name, creatorName, extension) {
		setRequirement(startDate, endDate, name, creatorName, extension);
		
		if (!isSearchPage) {
			isSearchPage = true;
			onSearchPageEnableEventHandler();
		}
		
		onSearchStartEventHandler(getCurrentRequirement());
	}
	
	/** private function **/
	
	function setRequirement(startDate, endDate, name, creatorName, extension) {
		requirement.startDate = startDate;
		requirement.endDate = endDate;
		requirement.name = name;
		requirement.creatorName = creatorName;
		requirement.extension = extension;
	}
	
	return {
		getCurrentRequirement: getCurrentRequirement,
		getFileType: getFileType,
		setFileType: setFileType,
		setSearchPageEnableEventHandler: setSearchPageEnableEventHandler,
		setSearchPageDisableEventHandler: setSearchPageDisableEventHandler,
		setSearchStartEventHandler: setSearchStartEventHandler,
		setFileTypeChangeEventHandler: setFileTypeChangeEventHandler,
		isSearchPage: isSearchPage,
		clearRequirement: clearRequirement,
		search: search
	}
}());