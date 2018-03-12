// 새로운 사다리 만들기
function newLad() {
	window.location.href = '/ezLadder/selectLadderType.do';
}

// 참여자 버튼
function participant() {
	if (modeCheck !== 'part') {
		currPage = 1;
	}
	modeCheck = "part";
	searchSelect = "none";
	if (searchSelect !== 'none') {
		currPage = 1;
	}

	if (mode !== "part") {
		currPage = 1;
	}
	mode = $('#part').val();

	if (pageChange === parseInt(currPage)) {
		currPage = 1;
	} else {
		currPage = pageChange;
		pageChange = 1;
	}

	$.ajax({
		type : "GET",
		dataType : "json",
		async : false,
		url : "/ezLadder/viewLadderModeList.do",
		data : {
			mode : mode,
			currPage : currPage
		},
		success : function(data) {
			viewList(data);
			makePageSelPage();
		}
	});
}

// 전체 버튼
function allPart() {
	if (modeCheck !== 'all') {
		currPage = 1;
	}
	modeCheck = "all";
	searchSelect = "none";
	if (searchSelect !== 'none') {
		currPage = 1;
	}
	if (mode !== "all") {
		currPage = 1;
	}
	mode = $('#all').val();

	if (pageChange === parseInt(currPage)) {
		currPage = 1;
	} else {
		currPage = pageChange;
		pageChange = 1;
	}

	$.ajax({
		type : "GET",
		dataType : "json",
		async : false,
		url : "/ezLadder/viewLadderModeList.do",
		data : {
			mode : mode,
			currPage : currPage
		},
		success : function(data) {
			viewList(data);
			makePageSelPage();
		}
	});
}

// 삭제
function deleteLadder(ladderId) {

	allData = [ ladderId, searchSelect, searchInput, mode, currPage ];

	jQuery.ajaxSettings.traditional = true;
	if (confirm('삭제 하시겠습니까?')) {
		$.ajax({
			type : "GET",
			dataType : "json",
			async : false,
			url : "/ezLadder/deleteLadder.do",
			data : {
				"allData" : allData
			},
			success : function(data) {
				viewList(data);
				makePageSelPage();
			}
		});
	}
}

// 검색 ajax
function searchLadder() {
	modeCheck = "search";
	if (searchSelect === 'none') {
		currPage = 1;
	}
	if (searchInput !== document.getElementById("searchInput").value) {
		currPage = 1;
	}

	if (pageChange === parseInt(currPage)) {
		currPage = 1;
	} else {
		currPage = pageChange;
		pageChange = 1;
	}

	searchSelect = document.getElementById("searchOption").value;
	searchInput = document.getElementById("searchInput").value;

	allData = [ searchSelect, searchInput, mode, currPage ];

	jQuery.ajaxSettings.traditional = true;

	$.ajax({
		type : "GET",
		dataType : "json",
		async : false,
		url : "/ezLadder/searchLadder.do",
		data : {
			"allData" : allData
		},
		success : function(data) {
			viewList(data);
			makePageSelPage();
		}
	});
}

// 리스트 출력
function viewList(data) {
	var list = "";
	list += "<table class='mainlist' style='width:100%;margin-top:30px;'>"
			+ "<tr><th width='30px'>" + strLang2 + "</th>"
			+ "<th width='20px'>" + strLang3 + "</th>"
			+ "<th width='60px'>" + strLang4 + "</th>"
			+ "<th width='40px'>" + strLang5 + "</th>"
			+ "<th width='50px'>" + strLang6 + "</th>"
			+ "<th width='50px'>" + strLang7 + "</th>"
			+ "<th width='50px'>" + strLang8 + "</th></tr>";
	if (data.list.length > 0) {

		$.each(data.list, function(key, value) {

			list += "<tr class='white'>" + "<td>" + value.type + "</td>"
					+ "<td>" + value.title + "</td>" + "<td>"
					+ value.writerName + "</td>" + "<td>"
					+ value.writeDate.substring(0, 16) + "</td>" + "<td>"
					+ value.status + "</td>" + "<td>" + value.secretFlag
					+ "</td>";
			if (id == value.writerId) {
				list += "<td><a href='#' onclick='deleteLadder("
						+ value.ladderId + ")'>" + value.deleteFlag
						+ "</a></td></tr>";
			} else {
				list += "<td>" + value.deleteFlag + "</td></tr>";
			}
		});
	} else {
		list += "<tr><td colspan='7' align='center' bgcolor='#FFFFFF'> <spring:message code='ezLadder.t010' /></td></tr>";
	}
	list += "</table>";
	$("#divList").html(list);
	totalLadder = data.totalLadder;
	currPage = data.currPage;
	totalPage = data.totalPage;
	totalLadder = data.totalLadder;
}

// 페이징 처리
function makePageSelPage() {

	var strtext = "";
	var PagingHTML = "<div class='pagenavi'>";
	var pageNum = currPage;

	document.getElementById("tblPageRayer").innerHTML = "";
	document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang16
			+ "<span style='color:#017BEC;'> " + totalLadder + " </span>"
			+ strLang17 + "]";

	if (totalPage > 1 && pageNum != 1) {
		strtext = "<span class='btnimg' onClick='goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
		PagingHTML += strtext;
	} else {
		strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
		PagingHTML += strtext;
	}

	if (totalPage > blockSize) {
		if (pageNum > blockSize) {
			strtext = "<span class='btnimg' onClick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>"
					+ strLang14 + "</span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>"
					+ strLang14 + "</span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>"
				+ strLang14 + "</span>";
		PagingHTML += strtext;
	}

	var MaxNum;
	var i;
	var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1;

	if (totalPage >= (startNum + parseInt(blockSize))) {
		MaxNum = (startNum + parseInt(blockSize)) - 1;
	} else {
		MaxNum = totalPage;
	}

	for (i = startNum; i <= MaxNum; i++) {
		if (i == pageNum) {
			strtext = "<span class='on'>" + i + "</span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span onClick='goToPageByNum(" + i + ")'>" + i
					+ "</span>";
			PagingHTML += strtext;
		}
	}

	if (totalPage > blockSize) {
		if (totalPage >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
			strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>"
					+ strLang15 + "</span>";
			strtext = strtext
					+ "<span class='btnimg' onClick='return selafterBlock()' ><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>"
					+ strLang15 + "</span>"; // 활성화 off >
			strtext = strtext
					+ "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>"
				+ strLang15 + "</span>"; // 활성화 >
		strtext = strtext
				+ "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		PagingHTML += strtext;
	}

	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		strtext = "<span class='btnimg' onclick = 'goToPageByNum("
				+ totalPage
				+ ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
		PagingHTML += strtext;
	} else {
		strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
		PagingHTML += strtext;
	}

	PagingHTML += "</div>";
	td_Create1(PagingHTML);
}

function td_Create1(strtext) {
	document.getElementById("tblPageRayer").innerHTML = strtext;
}

function selbeforeBlock() {
	var pageNum = parseInt(currPage);
	pageNum = ((parseInt(pageNum / blockSize) - 1) * blockSize) + 1;
	goToPageByNum(pageNum);
}

function selbeforeBlock_one() {
	var pageNum = parseInt(currPage);
	if (parseInt(pageNum - 1) > 0)
		goToPageByNum(parseInt(pageNum - 1));
	else
		return;
}

function selafterBlock() {
	var pageNum = parseInt(currPage);
	pageNum = ((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1;
	goToPageByNum(pageNum);
}

function selafterBlock_one() {
	var pageNum = parseInt(currPage);
	if (parseInt(pageNum + 1) <= totalPage)
		goToPageByNum(parseInt(pageNum + 1));
	else
		return;
}

function goToPageByNum(page) {
	pageChange = page;
	if (searchSelect !== 'none') {
		searchLadder();
	} else if (mode === 'all') {
		allPart();
	} else {
		participant();
	}
	makePageSelPage();
}