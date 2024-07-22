var leftWindow = (function() {
	function filterOnlyMailLeftFrame(frame) {
		return frame.location.href.indexOf("mailLeft") > -1 ? frame : null;
	}

	var parentWindow = self;
	var i;
	// 무한재귀 방지
	var tryCount = 0, tryLimit = 10;

	while (tryCount < tryLimit &&
		// top까지 아직 도달하지 못한 경우
		(parentWindow !== parentWindow.top
			// 또는 opener가 남아있는 경우
			|| (parentWindow.opener != null && parentWindow !== parentWindow.opener))) {
		tryCount++;
		for (i = 0; i < parentWindow.frames.length; i++) {
			if (parentWindow.frames[i].name === 'left') {
				return filterOnlyMailLeftFrame(parentWindow.frames[i]);
			}
		}

		// parentWindow의 opener가 본인인 경우가 있음. 이 경우 opener.opener.opener 조차도 본인이 되기 때문에 무한재귀 방지
		if (parentWindow === parentWindow.opener) {
			parentWindow = parentWindow.parent;
		} else {
			parentWindow = parentWindow.opener || parentWindow.parent;
		}
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