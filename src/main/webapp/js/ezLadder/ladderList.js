function mouseCursor() {
	var overColor = "rgb(244, 245, 245)";
	var origColor = "#FFF";

	$(document)
	.on("mouseenter", ".black", function() {
		$(this).css("background", overColor);
		$(this).css("cursor", 'pointer');
	})
	.on("mouseleave", ".black", function() {
		$(this).css("background", origColor);
	});
}

// 새로운 사다리 만들기
function newLad() {
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
	'&searchInput=' + searchInput + '&mode=' + mode + '&currPage=' + currPage + '&sort=' + sort + '&sortFlag=' + sortFlag;
}

// 참여자 버튼
function participant(val) {

	searchInput='';
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
		$("#part").attr('checked', 'checked');	
	} else { // 전체
		$("#all").attr('checked', 'checked');	
	}
}

//검색 
function searchLadder() {
	mode = modeCheck;
	var tempInput=searchInput;
	var tempSelect=searchSelect;
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

	if(searchSelect === 'kind') {	// 종류 검색
		searchInput = document.getElementById("ladderType").value;
	} else {	// 이외
		searchInput = document.getElementById("searchInput").value.trim();
	}
	if(searchOption==='on'){
		searchInput = tempInput;
		searchSelect = tempSelect;
		searchOption ='off';
	}
	if(searchInput==="") {
		alert(strLang14);
		searchSelect = '';
		return;
	}
	if(mode === "pre") {
		viewAjax();
	} else {
		view();
	}
}

//삭제 불가
function imposDelete(){
	alert(strLang15);
	return;
}

// 삭제 가능
function deleteLadder(ladderId, event) {
	event.stopPropagation();
	
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
function sortView() {
	var temp;
	if(sort==='type') {
		temp=0;
	} else if(sort==='title') {
		temp=1;
	} else if(sort=== 'writerName') {
		temp=2;
	} else if(sort==='writeDate') {
		temp=3;
	} else if(sort==='status') {
		temp=4;
	} else if(sort==='secretFlag') {
		temp=5;
	} else if(sort==='deleteFlag') {
		temp=6;
	} else {
		temp=7;
	}

	return temp;
}

function sortViews() {
	var html="";
	var temp = sortView();
	$("#sort_" + temp).html("");
	html = "";
	if(sortFlag == 'desc') {
		html += "<img src='/images/etc/view-sortdown.gif' align='absmiddle'>";
	} else {
		html += "<img src='/images/etc/view-sortup.gif' align='absmiddle'>";
	}
	$("#sort_" + temp).append(html); 
}

function listSort(num) {
	
	var temp = sort;
	switch(num) {
		case 0: sort="type";
				break;
		case 1: sort="title";
				break;
		case 2: sort="writerName";
				break;
		case 3: sort="writeDate";
				break;
		case 4: sort="status";
				break;
		case 5: sort="secretFlag";
				break;
		case 6: sort="deleteFlag";
				break;
		default: sort="basic";
				break;
	}
	
	if((sortFlag == 'desc') && (temp == sort)) {
		sortFlag = 'asc';
	} else {
		sortFlag = 'desc';
	}
	mode=modeCheck;
	view();
}

function view() {
	if(mode === "pre") {
		sort ='date';
		sortFlag = 'desc';
	}
	var searching = document.getElementById("searchInput").value;
	searching = encodeURIComponent(searching).replace(/%20/g,'+');
	searchInput = encodeURIComponent(searchInput).replace(/%20/g,'+');
	var szUrl = "/ezLadder/ladderMain.do?mode=" + mode + "&currPage=" + currPage + "&searchSelect=" + searchSelect + "&searchInput=" + searchInput + "&sort=" + sort + "&sortFlag=" + sortFlag +"&searching=" + searching;

	document.location.href = szUrl;
}

function viewAjax() {
	$.ajax({
		type: "GET",
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
		document.getElementById("mailBoxInfo").innerHTML = "&nbsp;<span class='txt_color'>" + totalLadder + "</span>";
	}

	if (totalPage > 1 && pageNum != 1) {
		strtext = "<span class='btnimg first' onClick='goToPageByNum(1)'></span>";
		PagingHTML += strtext;
	} else {
		strtext = "<span class='btnimg first disabled'></span>";
		PagingHTML += strtext;
	}

	if (totalPage > blockSize) {
		if (pageNum > blockSize) {
			strtext = "<span class='btnimg prev' onClick= 'return selbeforeBlock()'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span class='btnimg prev disabled'></span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = "<span class='btnimg prev disabled'></span>";
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
			strtext = "";
			strtext = strtext
					+ "<span class='btnimg next' onClick='return selafterBlock()'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "";
			strtext = strtext
					+ "<span class='btnimg next disabled'></span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = ""; 
		strtext = strtext
				+ "<span class='btnimg next disabled'></span>";
		PagingHTML += strtext;
	}

	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		strtext = "<span class='btnimg last' onclick = 'goToPageByNum("
				+ totalPage
				+ ")'></span>";
		PagingHTML += strtext;
	} else {
		strtext = "<span class='btnimg last disabled'></span>";
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
	searchOption ='on';
	if (searchSelect !== '' && searchSelect !== 'none') {
		searchLadder();
	} else  {
		participant(modeCheck);
	}
	makePageSelPage();
}

// 작성자 정보 보기
function menuQst_DetailUserInfo(pUserID, pDeptID, event) {
	event.stopPropagation();
	var feature = GetOpenPosition(420, 450);
    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" +pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
}	
