
// 새로운 사다리 만들기
function newLad() {
	console.log("========");
	window.location.href = '/ezLadder/selectLadderType.do';
}

// 게임 조회로 이동
function getLadderGame(ladderId) {
	mode = modeCheck;
	allData = [ ladderId, searchSelect, searchInput, mode, currPage ];
	if(modeCheck === "pre") {
		console.log("enter pre");
		return allData;
	}
	window.location.href = '/ezLadder/getLadderGame.do?ladderId=' + ladderId + '&searchSelect=' + searchSelect +
	'&searchInput=' + searchInput + '&mode=' + mode + '&currPage=' + currPage;
}

// 참여자 버튼
function participant(val) {
	
	if (modeCheck !== val) {
		currPage = 1;
	}
	modeCheck = val;
	searchSelect = "none";
	if (searchSelect !== 'none') {
		currPage = 1;
	}
	mode = val;

	if (pageChange === parseInt(currPage)) {
		currPage = 1;
	} else {
		currPage = pageChange;
		pageChange = 1;
	}
	
	if(mode === "pre") {
		/*viewAjax();*/
		searchSelect ="";
		view();
	} else {
		view();
	}
}

// 참여자 버튼 색깔 바꾸기
function changeBtnColor(){
	if (modeCheck === 'part') {	// 일부
		$("#part").css("color", "white");
		$("#part").css("background-color", "#B5B3B3");
		$("#all").css("color", "grey");
		$("#all").css("background-color", "#FFFFFF");		
	} else { // 전체
		$("#all").css("color", "white");
		$("#all").css("background-color", "#B5B3B3");
		$("#part").css("color", "grey");
		$("#part").css("background-color", "#FFFFFF");
	}
}

//검색 
function searchLadder() {
	mode = modeCheck;

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
	searchInput = document.getElementById("searchInput").value.trim();
	
	if(searchInput==="") {
		alert(strLang39);
		searchSelect = '';
		return;
	} else if(searchInput.includes("%")) {
		alert(strLang40);
		searchSelect = '';
		return;
	} else if(searchInput.includes("&")) {
		alert(strLang41);
		searchSelect = '';
		return;
	}
	if(mode === "pre") {
		viewAjax();
	} else {
		view();
	}
}

//삭제
function deleteLadder(ladderId) {

	mode = modeCheck;
	allData = [ ladderId, searchSelect, searchInput, mode, currPage, back ];

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
				view();
			}
		});
	}
}


function view() {
	var szUrl = "/ezLadder/ladderMain.do?mode=" + mode + "&currPage=" + currPage + "&searchSelect=" + searchSelect + "&searchInput=" + searchInput;
	document.location.href = szUrl;
}

function viewAjax() {
	$.ajax({
		type: "POST",
		url: "/ezLadder/ladderMain.do",
		dataType: "json",
		traditional: true,
		async : false,
		data: {
			"mode": mode,
			"currPage": currPage,
			"searchSelect": searchSelect,
			"searchInput": searchInput
		},
		success: function(result) {
			viewSearchList(result);
		}, 
		error: function(e) {
			console.log(e);
		}
	});
}

// 페이징 처리
function pageZeroCheck() {
	if(totalPage==0) {
		totalPage=1;
		currPage=1;
	}
}
function makePageSelPage() {
	pageZeroCheck();
	var strtext = "";
	var PagingHTML = "<div class='pagenavi'>";
	var pageNum = currPage;

	document.getElementById("tblPageRayer").innerHTML = "";
	if(document.getElementById("mailBoxInfo") !== null) {
		document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang16
		+ "<span style='color:#017BEC;'> " + totalLadder + " </span>"
		+ strLang17 + "]";
	}

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
					+ strLang15 + "</span>";
			strtext = strtext
					+ "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>"
				+ strLang15 + "</span>"; 
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
	if(pageNum%blockSize == 0) {
		pageNum = pageNum - blockSize;
	}
	pageNum = ((parseInt(pageNum / blockSize)) * blockSize);
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
	
	if (searchSelect !== '' && searchSelect !== 'none') {
		searchLadder();
	} else  {
		participant(modeCheck);
	}
	/*if (modeCheck === 'all') {
		var temp = 'all';
		participant(temp);
	} else {
		var temp = 'part'
		participant(temp);
	} */
	makePageSelPage();
}
