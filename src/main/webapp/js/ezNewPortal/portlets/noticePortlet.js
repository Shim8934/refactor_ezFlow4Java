// 2024-05-30 조수빈 - 공지사항 페이징 처리
var noticePortletObj = {};
const noticePorletPagingCnt = 12;

function initNoticePortletInfo(noticePortletId) {
	var newObj = {};
	var perCount = getNoticePagePerCount(noticePortletId);
	newObj.page = new Paging().init(perCount);
	
	newObj.page.getPagePerCount = function () {
		return getNoticePagePerCount(noticePortletId);
	}
	
	portletInfoMap["portlet" + noticePortletId] = newObj;
	noticePortletObj.portletId = noticePortletId;
	
	noticePortletLoadFunc();
}

// 2024-05-30 조수빈 - 공지사항이 보여질 수 있는 개수에 비해 작은 경우 처리하기 위해 전역변수로 선언
var count = 0;

function getNoticePagePerCount(noticePortletId) {
	var portletSize = getPortletSize(noticePortletId);
	
	if (portletSize == GridSize.TWO_BY_ONE) {
		count = 6;
	} else {
		count = 3;
	}

	return count;
}

/* 공지사항 데이터 조합 */
var assembleNoticeList = function(noticeList, portletBoardId, access) {
	/* HTMLColllection에도 forEach 추가*/
	HTMLCollection.prototype.forEach = Array.prototype.forEach;
	var str = '';
	var viewCnt = count; // 보여주는 공지사항 갯수
	var boardId = '';
	
	var noticeDetail = function() {
		var height = window.screen.availHeight;
		var width = window.screen.availWidth;
		var top = (height - 720) / 2;
		var left = (width - 765) / 2;
		var option = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top='+top+',left='+left;
		
		if(this.getAttribute('data3') === "3" || this.getAttribute('data3') === "4") {
			top = (height - 720) / 2;
			left = (width - 790) / 2;
			 
			option = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=790,top='+top+',left='+left;
			window.open('/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID='+ encodeURIComponent(this.getAttribute('data1'))+'&boardID='+ encodeURIComponent(this.getAttribute('data2')), "", option, "");
		} else if (this.getAttribute('data3') == "7") {
			 top = (height - 679) / 2;
			 left = (width - 765) / 2;
			 
			 option = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=679,width=765,top='+top+',left='+left;
			 window.open('/ezBoard/boardItemViewMovie.do?showAdjacent=&itemID='+ encodeURIComponent(this.getAttribute('data1'))+'&boardID='+ encodeURIComponent(this.getAttribute('data2')), "", option, "");
		   } else {
			window.open('/ezBoard/boardItemView.do?showAdjacent=&itemID='+ encodeURIComponent(this.getAttribute('data1'))+'&boardID='+ encodeURIComponent(this.getAttribute('data2')), "", option, "");
		}
	}
	
	var noticePlus = function() {
		//console.log('boardId', boardId);
		window.open("/ezBoard/boardMainRedirect.do?boardID=" + encodeURIComponent(boardId), "main", "");
	}
	var dataAssembler = function(data, index) {	
		index = (index*1 + 1); // 혹시 모르니 int형태로 변환
		boardId = data.boardID;
		
		//오늘날짜 구하기
		var today = new Date();
		var writeDate = new Date(data.writeDate);
		var date = today.getDate();
		
		today.setDate(date - 1);
		
		var text = "";
		
		/* 2023-05-31 홍승비 - 디자인 개선을 위한 공지사항 게시판 포틀릿 게시물 영역 표출 수정, 기존 코드 주석처리 */
		/*
		if (today < writeDate) {
			text = '<li class="notiLI" data1="'+data.itemID+'" data2="'+data.boardID+'" data3="'+data.guBun+'"><dl class="notiDL0'+index+'"><dt class="noti_num">'+index+'</dt><dt class="noti_new">N</dt><dd class="noti_text">' + ConvertCharToEntityReference(data.title) + '</dd></dl></li>';
		} else {
			text = '<li class="notiLI" data1="'+data.itemID+'" data2="'+data.boardID+'" data3="'+data.guBun+'"><dl class="notiDL0'+index+'"><dt class="noti_num">'+index+'</dt><dt class="N"></dt><dd class="noti_text">' + ConvertCharToEntityReference(data.title) + '</dd></dl></li>'; 
		}
		*/
		
		text = '<li class="notiLI" data1="' + data.itemID + '" data2="' + data.boardID + '" data3="' + data.guBun + '"><dl>';
		
		// if (Number($("#noticePortlet_usedTheme").val()) === 3) {
			// text += '<dt>' + index + '</dt>';
		// }
		// else {
			text += '<dt class="noti_num">' + index + '</dt>';
		// }
		
        var writeDateFormatt = data.writeDate.substring(0,4).toString() + "." + data.writeDate.substring(5,7).toString() + "." + data.writeDate.substring(8,10).toString() + " " + data.writeDate.substring(11,16).toString()
		text += '<dd class="noti_text">' + ConvertCharToEntityReference(data.title) + '</dd><dd class="noti_date">' + writeDateFormatt + '</dd></dl></li>';
		
		return text;
	};
	
	if (access == "true") {
		if (noticeList && noticeList.length != 0) {
//			str += "<ul class='noti_portlet_list portletPagingArea'>";
			noticeList.forEach(function(item, index){
				str += dataAssembler(item, index);
			});
		} else {
//			str += "<ul class='portlet_list'>";
			str += "<dl class='nodata'>";
			str += "<dt>";
			str += "<img src='/images/kr/main/noData_sIcon.png'>";
			str += "</dt>";
			str += "<dd>" + messages.strLang1 + "</dd>";
			str += "</dl>";
		}
	} else {
		if (portletBoardId == null || portletBoardId == "") {
//			str += "<ul class='portlet_list'>";
			str += "<dl class='nodata'>";
			str += "<dt>";
			str += "<img src='/images/kr/main/noData_sIcon.png'>";
			str += "</dt>";
			str += "<dd>" + messages.strLang17 + "</dd>";
			str += "</dl>";
		} else {
			str += "<ul class='portlet_list'>";
			str += "<dl class='nodata'>";
			str += "<dt>";
			str += "<img src='/images/kr/main/noData_sIcon.png'>";
			str += "</dt>";
			str += "<dd>" + messages.strLang14 + "</dd>";
			str += "</dl>";
		} 
	}

	var noticeCnt = str.match(/notiLI/g); // 공지사항 갯수 확인.
	
//	str += "</ul>";
	document.getElementById('BoardList_NewBoard').innerHTML = str;
	
	document.getElementsByClassName('notiLI').forEach(function(item, index) {
		if(item.getAttribute('data1')) {
			item.addEventListener('click', noticeDetail);	
		}
	});
	
	document.getElementById('noticePlus').addEventListener('click', noticePlus);
	
	var totalCnt = noticeList.length < noticePorletPagingCnt ? noticeList.length : noticePorletPagingCnt; 
	resetPortletList(noticePortletObj.portletId, totalCnt);
}

var portletId = $(".notice").parent().attr("id");
portletId = portletId.substring(0, portletId.indexOf("P"));

/* [포틀릿] 공지사항 리스트 */ 
var getNoticePortletList = function () {
	var xhr = new XMLHttpRequest();
	xhr.onload = function () {
		if(xhr.status >= 200 && xhr.status < 300) {
			var noticeList = JSON.parse(xhr.responseText).noticeList;
			var boardId = JSON.parse(xhr.responseText).boardId;
			var access = JSON.parse(xhr.responseText).access;
			assembleNoticeList(noticeList, boardId, access);
		} else {
			console.error(xhr.responseText);
		}
	};
	xhr.open('GET', '/ezNewPortal/getNoticePortlet.do?portletId='+portletId);
	xhr.send();
};

var noticePortletLoadFunc = function () {
	getNoticePortletList();	
}
