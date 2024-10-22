var pagination = (function() {
	
	// 상수
	var pageButtonSize = 10;
	
	var currentPage = 1;
	var totalPage = 1;
	var listSize = 0;
	
	var startPosition = 0;
	var itemAmount = 0;
	
	var eventHandler = {
		pageChange: function() {}
	};
	
	function setListSize(size) {
		listSize = size;
	}
	
	function setPage(page, disableHandler, fldId) {
		currentPage = page;
		
		if (!disableHandler) {
			eventHandler.pageChange(currentPage, listSize, fldId);
		}
	}
	
	function setAmount(amount) {
		itemAmount = amount;
	}
	
	function build() {
		startPosition = (listSize * (currentPage - 1));
		
		totalPage = Math.max(~~(itemAmount / listSize), 1);
		
		if (totalPage * listSize < itemAmount) {
			totalPage++;
		}
		
		if (currentPage > totalPage) {
			currentPage = totalPage;
		}
		
		makePagination();
	}
	
	function setPageChangeEventHandler(handler) {
		eventHandler.pageChange = handler;
	}
	
	function makePagination() {
		var pagingHTML = "<div class='pagenavi'>";
		var buttonOverCount = ~~((currentPage - 1) / pageButtonSize);
		var startButtonPage, endButtonPage;
		
		startButtonPage = 1 + buttonOverCount * pageButtonSize;
		endButtonPage = Math.min(totalPage, startButtonPage + pageButtonSize - 1);
		
		document.getElementById("mailBoxInfo").innerHTML = "&nbsp;<span id='countSpan' class='txt_color'>" + itemAmount + "</span>";
		
		if (currentPage == 1) {
			pagingHTML += "<span class='btnimg first disabled'></span>";
		} else {
			pagingHTML += "<span class='btnimg first' onclick='return pagination.setPage(1)'></span>";
		}
		
		if (startButtonPage === 1) {
			pagingHTML += "<span class='btnimg prev disabled'></span>"
		} else {
			pagingHTML += "<span class='btnimg prev' onclick='return pagination.previousBlock()'></span>";
		}
		
		pagingHTML += "";
		
		// TODO
		// if (overPage)
		
		for (var i = startButtonPage; i <= endButtonPage; i++) {
			if (i == currentPage) {
				pagingHTML += "<span class='on'>" + i + "</span>";
			} else {
				pagingHTML += "<span onclick='pagination.setPage(" + i + ");'>" + i + "</span>";
			}
		}
		
		if (endButtonPage < totalPage) {
			pagingHTML += "<span class='btnimg next' onclick='return pagination.nextBlock()'></span>";
		} else {
			pagingHTML += "<span class='btnimg next disabled'></span>";
		}
		
		if (currentPage == totalPage) {
			pagingHTML += "<span class='btnimg last disabled'></span>";
		} else {
			pagingHTML += "<span class='btnimg last' onclick='pagination.setPage(" + totalPage + ");'></span>";
		}
		
		pagingHTML += "</div>";
		document.getElementById("tblPageRayer").innerHTML = pagingHTML;
	}
	
	function previousBlock() {
		var pageNum = ~~((currentPage - 1) / pageButtonSize - 1) * pageButtonSize + 1;
		
		setPage(pageNum);
	}
	
	function nextBlock() {
		var pageNum = ~~((currentPage - 1) / pageButtonSize + 1) * pageButtonSize + 1;
		setPage(Math.min(pageNum, totalPage));
	}
	
	function previous() {
		setPage(Math.max(currentPage - 1, 1));
	}
	
	function next() {
		setPage(Math.min(currentPage + 1, totalPage));
	}
	
	return {
		startPosition: function() {
			return listSize * (currentPage - 1);
		},
		listSize: function() {
			return listSize;
		},
		currentPage: function() {
			return currentPage;
		},
		setListSize: setListSize,
		setPage: setPage,
		setAmount: setAmount,
		build: build,
		setPageChangeEventHandler: setPageChangeEventHandler,
		previousBlock: previousBlock,
		nextBlock: nextBlock,
		previous: previous,
		next: next
	};
}());

function makePageSelPage(){
	var pagingHTML = "<div class='pagenavi'>";
	var pageNum = currentPage == 0 ? 1 : currentPage;
	
	document.getElementById("tblPageRayer").innerHTML = "";
	document.getElementById("mailBoxInfo").innerHTML = "&nbsp;<span id='countSpan' class='txt_color'>" + totalRows + "</span>";
	
	if (totalPages > 1 && pageNum != 1) {
		pagingHTML += "<span class='btnimg first' onClick= 'return goToPageByNum(1)'></span>";
	} else {
		pagingHTML += "<span class='btnimg first disabled'></span>";
	}
	
	if (totalPages > blockSize && pageNum > blockSize) {
		pagingHTML += "<span class='btnimg prev' onClick= 'return selbeforeBlock()'></span>";
	} else {
		pagingHTML += "<span class='btnimg prev disabled'></span>";
	}
	
	var maxNum;
	var i;
	var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1;
	
	if (totalPages >= (startNum + parseInt(blockSize))) {
		maxNum = (startNum + parseInt(blockSize)) - 1;
	} else {
		maxNum = totalPages;
	}
	
	maxNum = maxNum == 0 ? 1 : maxNum;

	for (i = startNum; i <= maxNum; i++) {
		if (i == pageNum) {
			pagingHTML += "<span class='on'>" + i + "</span>";
		} else {
			pagingHTML += "<span onClick='goToPageByNum(" + i + ")'>" + i + "</span>";
		}
	}
	
	if (totalPages > blockSize && totalPages >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
		pagingHTML += ""
					+ "<span class='btnimg next' onClick='return selafterBlock()'></span>";
	} else {
		pagingHTML += ""
					+ "<span class='btnimg next disabled'></span>";
	}
	
	if (totalPages > 1 && totalPages != 1 && (totalPages != pageNum)) {
		pagingHTML += "<span class='btnimg last' onClick='return goToPageByNum(" + totalPages + ")'></span>";
	} else {
		pagingHTML += "<span class='btnimg last disabled'></span>";
	}
	
	pagingHTML += "</div>";
	document.getElementById("tblPageRayer").innerHTML = pagingHTML;
}

function goToPageByNum(Value){
	currentPage = Value;
	makePageSelPage();
	search_Set(currentPage);
}

function selbeforeBlock(){
	var pageNum = parseInt(currentPage);
	
	pageNum     = parseInt((pageNum - 1)/ blockSize) * blockSize;
	goToPageByNum(pageNum);
}

function selbeforeBlock_one(){
	var pageNum = parseInt(currentPage);
	
	if(parseInt(pageNum - 1) > 0) {
		goToPageByNum(parseInt(pageNum - 1));
	} else {
		return;
	}
}

function selafterBlock(){
	var pageNum = parseInt(currentPage);
	
	pageNum     = ((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1;
	goToPageByNum(pageNum);
}

function selafterBlock_one(){
	var pageNum = parseInt(currentPage);
	
	if(parseInt(pageNum + 1) <= totalPages) {
		goToPageByNum(parseInt(pageNum + 1));
	} else {
		return;
	}
}

function getFileSize(fileSize) {
	var fileSize_ = "";
	
	if (fileSize / 1024 / 1024 / 1024 > 1) {
		fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 / 1024 * 10)) / 10).toFixed(1) + "GB";
	}
	else if (fileSize / 1024 / 1024 > 1) {
		fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
	}
	else if (fileSize / 1024 > 1) {
		fileSize_ = parseInt(fileSize / 1024) + "KB";
	}
	else {
		fileSize_ = fileSize + "B";
	}
	
	return fileSize_;
}