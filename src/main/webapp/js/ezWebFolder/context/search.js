var searchContext = (function() {
	
	var isSearchPage = false;
	var requirement = {
		startDate : "",
		endDate : "",
		name : "",
		creatorName : "",
		extension : ""
	}
	
	/** event handler **/
	
	var onSearchPageEnableEventHandler = function() {};
	var onSearchPageDisableEventHandler = function() {};
	var onSearchStartEventHandler = function() {};
	
	/** public function **/
	
	// 외부에서 requirement json 오브젝트 변수에 직접 접근하지 못하도록 값을 복사해서 캡슐화함
	function getCurrentRequirement() {
		if (isSearchPage) {
			return {
				startDate : requirement.startDate,
				endDate : requirement.endDate,
				name : requirement.name,
				creatorName : requirement.creatorName,
				extension : requirement.extension
			}
		}

		throw "Incorrect access! not in search state.";
	}
	
	function setSearchPageEnableEventHandler(handler) {
		onSearchPageEnableEventHandler = hanlder;
	}
	
	function setSearchPageDisableEventHandler(handler) {
		onSearchPageDisableEventHandler = hanlder;
	}
	
	function setSearchStartEventHandler(handler) {
		onSearchStartEventHandler = hanlder;
	}
	
	function isSearchPage() {
		return isSearchPage;
	}
	
	function clearSearch() {
		setCondition("", "", "", "", "");
		
		if (isSearchPage) {
			isSearchPage = false;
			onSearchPageDisableEventHandler();
		}
	}
	
	function search(startDate, endDate, name, creatorName, extension) {
		setCondition(startDate, endDate, name, creatorName, extension);
		
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
		getCurrentRequirement : getCurrentRequirement,
		setSearchPageEnableEventHandler : setSearchPageEnableEventHandler,
		setSearchPageDisableEventHandler : setSearchPageDisableEventHandler,
		setSearchStartEventHandler : setSearchStartEventHandler,
		isSearchPage : isSearchPage,
		clearSearch : clearSearch,
		search : search
	}
}());