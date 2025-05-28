var blockSize = 10; // 화면에 보여질 블록갯수
var listSize = 20; // 게시판에 보여질 게시물갯수

var m_strColorSelect = "#f1f8ff"; //리스트 선택시 색상
var m_strColorDefault =  "#FFFFFF"; //리스트 기본값
var m_strColorOver = "#f4f5f5"; //리스트 마우스오버 시 색상

/** jQuery 옵션*/
//체크박스(전체선택/해제)
$(document).on('click', '#HeaderAllCheckBox', function() {
	$("input[type='checkbox']:not(#HeaderAllCheckBox)").each(function() {
		$(this).prop("checked", $("#HeaderAllCheckBox").is(":checked"));
		if ($("#HeaderAllCheckBox").is(":checked") == true) {
			$(this).closest('tr').css("background-color", m_strColorSelect);
			$(this).closest('tr').attr("class","selectTR");
		} else {
			$(this).closest('tr').css("background-color", m_strColorDefault);
		}
	})
})

//tr클릭 시 - 휴가유형관리, 근태권한 관리
$(document).on('click', '#contentlist tr:not(.tr_noItems)', function(e) {
	//근무시간관리일때
	if ($(this).find("input[type='checkbox']").length != 0) {
		if (e.type == "click") {
			if (!$(this).find("input[type='checkbox']:not(#HeaderAllCheckBox)").is(":checked")) {
				$(this).css("background-color", m_strColorSelect);
				$(this).attr("class","selectTR");
    			$(this).find("input[type='checkbox']:not(#HeaderAllCheckBox)").prop("checked", true);
			} else {
				$(this).css("background-color", m_strColorDefault);
				$(this).attr("class","");
    			$(this).find("input[type='checkbox']:not(#HeaderAllCheckBox)").prop("checked", false);
			}
		}
	} else {
		if (e.type == "click") {
			$('#contentlist tr').not(this).attr("class","");
			$('#contentlist tr').not(this).css("background-color", m_strColorDefault);
			$(this).css("background-color", m_strColorSelect);
			$(this).attr("class","selectTR");
		} else {
			$(this).css("background-color", m_strColorDefault);
		}
	}
})

//tr hover시 배경색 변경 - 휴가유형관리, 근태권한 관리
$(document).on('mouseover mouseleave', '#contentlist tr:not(.tr_noItems)', function(e) {
	if ($(this).attr("class") == "selectTR") {
		return;
	}
	if (e.type == "mouseover") {
		$(this).css("background-color", m_strColorOver);
	} else {
		$(this).css("background-color", m_strColorDefault);
	}
})

//td클릭 시 체크박스 선택/해제
$(document).on('click', "#contentlist tr input[type='checkbox']:not(#HeaderAllCheckBox)", function() {
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
	$("#contentlist tr:not(#contentlist tr:eq(0)):not(.tr_noItems)").unbind('click').on('click', func);
}

//tr 더블클릭이벤트 부여
function addTrDblclickEvent(func) {
	$("#contentlist tr:not(#contentlist tr:eq(0)):not(.tr_noItems)").unbind('dblclick').on('dblclick', func);
}

//attitude 페이징 중복 함수, 페이징 셋팅
function makePageSelPageAtti() {
	$("#tblPageLayer").html("");
	var pagingHtml = "";
	
	$("#mailBoxInfo").html("&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span>");
	
	pagingHtml = "<div class='pagenavi'>";
	//|< 버튼 셋팅 ==> 1번페이지로 이동
	if (totalPage > 1 && pageNum != 1) {
		pagingHtml += "<span class='btnimg first' onclick='return goToPageByNum(1)'></span>";
	} else {
		pagingHtml += "<span class='btnimg first disabled'></span>";
	}
	//< 버튼 셋팅 ==> 전 블록의 1페이지로 이동
	if (totalPage > blockSize && pageNum / (blockSize + 1) >= 1) {
		var beforeBlock = ((parseInt((pageNum - 1) / blockSize) - 1) * 10) + 1;
		pagingHtml += "<span class='btnimg prev' onclick='goToPageByNum(" + beforeBlock + ")'></span>";
	} else {
		pagingHtml += "<span class='btnimg prev disabled'></span>";
	}
	
	var maxNum = 1; // 현재 블록의 마지막 페이지를 저장하는 변수
	var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1; // 현재 페이지의 1페이지 변수
	if (totalPage >= startNum + blockSize) {
		maxNum = (startNum + blockSize) - 1;
	} else {
		if (totalPage == 0) {
			totalPage = 1;
		}
		
		maxNum = totalPage;
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
		var afterBlock = ((parseInt((pageNum - 1) / blockSize) + 1) * 10) + 1;
		pagingHtml += "<span class='btnimg next' onclick='goToPageByNum(" + afterBlock + ")'></span>";
	} else {
		pagingHtml += "<span class='btnimg next disabled'></span>";
	}
	// >| 버튼 셋팅 ==> 맨 마지막 블록으로 이동
	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		pagingHtml += "<span class='btnimg last' onclick='goToPageByNum(" + totalPage + ")'></span>";
	} else {
		pagingHtml += "<span class='btnimg last disabled'></span>";
	}
	
	$("#tblPageRayer").html(pagingHtml);
}

//팝업창 주모니터가 아니더라도 가운데로 오게끔
function GetOpenWindow2(url, target, popUpW, popUpH, resizeFlag) {
    var resize;
    if (MACSAFARIYN())
        popUpH = popUpH + 50;

    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;
    
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    
    var left = ((screen.width / 2) - (popUpW / 2)) + dualScreenLeft ;
    var top = ((screen.height / 2) - (popUpH / 2)) + dualScreenTop - 40;

    if (resizeFlag == undefined || resizeFlag.toUpperCase() == "NO")
        resize = "resizable=no";
    else
        resize = "resizable=yes";
    
    var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + "px ,top=" + top + "px, status = no, toolbar=no, menubar=no,location=no," + resize;
    var result = window.open(url, target, feature);
    result.focus();
    return result;
}
