var leftWindow = (function() {
	var parentWindow = self;
	while (!parentWindow.left && (parentWindow != top || parentWindow.opener != null)) {
		parentWindow = parentWindow.opener || parentWindow.parent;
	}
	return parentWindow;
})();

var leftMenu = (function() {
	var isAccessable = Boolean(leftWindow);

	/** right 프레임에 변화 없이 left 프레임만 새로고침한다. */
	function reloadWithoutSelectNode() {
		if (!isAccessable) {
			return;
		}

		var url = leftWindow.location.pathname;
		var queryParam = leftWindow.location.search;

		if (queryParam.indexOf('withoutnodeselect') == -1) {
			queryParam += "&withoutnodeselect=1";
		}

		leftWindow.location.href = url + queryParam;
	}

	/** 프레임 변화 없이 태그 목록만 새로 가져온다. 활성화/비활성화 여부에 따라 가려지거나 하지 않는다. */
	function reloadTags() {
		if (!isAccessable) {
			return;
		}

		leftWindow.reloadTags();
	}

	return {
		reloadWithoutSelectNode: reloadWithoutSelectNode,
		reloadTags: reloadTags
	};
})();