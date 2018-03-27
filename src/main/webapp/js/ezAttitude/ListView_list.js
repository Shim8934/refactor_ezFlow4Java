var blockSize = 10; // 화면에 보여질 블록갯수
var listSize = 20; // 게시판에 보여질 게시물갯수

/** jQuery 옵션*/
//체크박스(전체선택/해제)
$(document).on('click', '#HeaderAllCheckBox', function(){
	$("input[type='checkbox']:not(#HeaderAllCheckBox)").each(function(){
		$(this).prop("checked", $("#HeaderAllCheckBox").is(":checked"));
	})
})

//tr클릭 시 체크박스 선택/해제
$(document).on('click', 'tr:not(#attiBoardList tr:eq(0))', function(){
	var checkValue = "";
	if ($(this).find("input[type='checkbox']").is(":checked") == true) {
		checkValue = false;
		$(this).css("background-color", "rgb(255,255,255)");
	} else {
		checkValue = true;
		$(this).css("background-color", "pink");
	}
	$(this).find("input[type='checkbox']").prop("checked", checkValue);
})

//tr hover시 배경색 변경
$(document).on('mouseover mouseleave', 'tr', function(e){
	if ($(this).find("input[type='checkbox']").is(":checked") == false) {
		if (e.type == "mouseover") {
			$(this).css("background-color", "rgb(244,245,245)");
		} else {
			$(this).css("background-color", "rgb(255,255,255)");
		}
	}
})

//td클릭 시 체크박스 선택/해제
$(document).on('click', "#attiBoardList tr input[type='checkbox']", function(){
	var checkValue = "";
	if ($(this).is(":checked") == true) {
		checkValue = false;
	} else {
		checkValue = true;
	}
	
	$(this).prop("checked", checkValue);
})
/** jQuery 옵션 끝*/

//tr 클릭이벤트 부여
function addTrClickEvent(func) {
	$("#attiBoardList tr:not(#attiBoardList tr:eq(0))").unbind('click').on('click', func);
}

//tr 더블클릭이벤트 부여
function addTrDblclickEvent(func) {
	$("#attiBoardList tr:not(#attiBoardList tr:eq(0))").unbind('dblclick').on('dblclick', func);
}

//attitude 페이징 중복 함수, 페이징 셋팅
function makePageSelPageAtti(){
	$("#tblPageLayer").html("");
	var pagingHtml = "";
	
	$("#mailBoxInfo").html(" - [총<span style='color:#017BEC;'> " + totalCount + " </span>개]");
	
	pagingHtml = "<div class='pagenavi'>";
	//|< 버튼 셋팅 ==> 1번페이지로 이동
	if (totalPage > 1 && pageNum != 1) {
		pagingHtml += "<span class='btnimg' onclick='return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
	} else {
		pagingHtml += "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'/></span>";
	}
	//< 버튼 셋팅 ==> 전 블록의 1페이지로 이동
	if (totalPage > blockSize && pageNum / (blockSize + 1) >= 1) {
		var beforeBlock = ((parseInt((pageNum - 1) / blockSize) - 1) * 10) + 1;
		pagingHtml += "<span class='btnimg' onclick='goToPageByNum(" + beforeBlock + ")'><img src='/images/sub/btn_prev.gif' width='16' height='16'/></span><span class='ptxt' onclick='goToPageByNum(" + (pageNum - 1) + ")'>이전</span>";
	} else {
		pagingHtml += "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'/></span><span class='ptxt' onclick='goToPageByNum(" + (pageNum - 1) + ")'>이전</span>";
	}
	
	var maxNum = ""; // 현재 블록의 마지막 페이지를 저장하는 변수
	var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1; // 현재 페이지의 1페이지 변수
	if (totalPage >= startNum + blockSize) {
		maxNum = (startNum + blockSize) - 1;
	} else {
		maxNum = totalPage
	}
	
	//페이지 셋팅
	for (i = startNum; i <= maxNum; i++) {
		if (i == pageNum) {
			pagingHtml += "<span class='on'>" + i + "</span>";
		} else {
			pagingHtml += "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
		}
	}
	
	//> 버튼 셋팅 ==> 다음 블록의 1페이지로 이동
	if (totalPage > blockSize && totalPage > (parseInt((pageNum - 1) / blockSize) + 1) * blockSize) {
		var afterBlock = ((parseInt((pageNum - 1) / blockSize) + 1) * 10) + 1;;
		pagingHtml += "<span class='ptxt' onclick='goToPageByNum(" + (pageNum + 1) + ")'>" + "다음" + "</span><span class='btnimg' onclick='goToPageByNum(" + afterBlock + ")'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	} else {
		pagingHtml += "<span class='ptxt' onclick='goToPageByNum(" + (pageNum + 1) + ")'>" + "다음" + "</span><span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	}
	// >| 버튼 셋팅 ==> 맨 마지막 블록으로 이동
	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		pagingHtml += "<span class='btnimg' onclick='goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
	} else {
		pagingHtml += "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
	}
	
	$("#tblPageRayer").html(pagingHtml);
}