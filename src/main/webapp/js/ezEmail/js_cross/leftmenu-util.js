var leftWindow = (function() {
	function filterOnlyMailLeftFrame(frame) {
		return frame.location.href.indexOf("mailLeft") > -1 ? frame : null;
	}

	var parentWindow = self;
	var i;

	while (parentWindow != top || parentWindow.opener != null) {
		for (i = 0; i < parentWindow.frames.length; i++) {
			if (parentWindow.frames[i].name == 'left') {
				return filterOnlyMailLeftFrame(parentWindow.frames[i]);
			}
		}
		parentWindow = parentWindow.opener || parentWindow.parent;
	}

	return filterOnlyMailLeftFrame(parentWindow);
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